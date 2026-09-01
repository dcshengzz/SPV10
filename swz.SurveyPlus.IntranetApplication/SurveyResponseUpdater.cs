using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using swz.Clover.Core.Security;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System.Text;
using Newtonsoft.Json.Linq;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Handles writing the response data from online survey save/submit into the database
    /// nb: this does NOT handle it for the online excel submissions which is done in ExcelSupport
    /// </summary>
    /// [Obsolete]
    public class SurveyResponseUpdater
    {
        private class InvalidVersionException : InternalException
        {
            public SurveyResponseVersionToken VersionUpdating { get; private set; }
            public SurveyResponseVersionToken CurrentVersion { get; private set; }

            public InvalidVersionException(SurveyResponseVersionToken versionUpdating, SurveyResponseVersionToken currentVersion) : base($"Update is for version {versionUpdating}, but current version is {currentVersion}")
            {
                this.VersionUpdating = versionUpdating;
                this.CurrentVersion = currentVersion;
            }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<SurveyResponseUpdater>();

        /// <summary>
        /// Represents a success, failed, or error result from the Update method.
        /// Contains IsSuccess property and a Message property indicating the nature of the error when not successful.
        /// On success the ChangeDataResponse object is provided. 
        /// </summary>
        public class UpdateResult
        {
            public class CommonMessages
            {
                /// <summary>
                /// Error message indicating one of many possible internal inconsistencies or states that prevent the update.
                /// This includes specifying surveys that don't exist or whose field definitions are missing or out of sync with the form etc
                /// </summary>
                public const string INVALID_SURVEY_ERROR = "Invalid survey";

                public const string PERMISSION_ERROR = Constants.Message.YouDontHaveThePermission;

                public const string CONCURRENT_RESPONSE_MODIFICATION = "This survey response was already modified elsewhere, please refresh the page and try again";

                public const string STRATA_FILLED = "This survey has reached the maximum number of responses for the group";

                public const string GENERIC_ERROR = "Data submission was not successful. Please contact administrator.";
            }

            public enum ResultType { Success, Failed, Error }

            public ResultType Type { get; }
            
            /// <summary>
            /// Message that will be displayed to end user (data editor or respondent)
            /// </summary>
            public string Message { get; }

            public ChangeDataResponce ChangeDataResponse { get; }

            public bool IsSuccess { get { return ResultType.Success == Type; } }

            public static UpdateResult Failed(string message)
            {
                if (message == null)
                    throw new ArgumentException("message is required for an error result", "message");
                return new UpdateResult(ResultType.Error, message);
            }

            public static UpdateResult GenericError()
            {
                return Failed(CommonMessages.GENERIC_ERROR);
            }

            public static UpdateResult ConcurrentResponseModificationError()
            {
                return Failed(CommonMessages.CONCURRENT_RESPONSE_MODIFICATION);
            }

            public static UpdateResult StrataFilled()
            {
                return Failed(CommonMessages.STRATA_FILLED);
            }

            /// <summary>
            /// Error with common "Invalid survey" message 
            /// </summary>
            /// <returns></returns>
            public static UpdateResult InvalidSurveyError()
            {
                return Failed(CommonMessages.INVALID_SURVEY_ERROR);
            }

            /// <summary>
            /// Error with common "You dont have the permission" message
            /// </summary>
            /// <returns></returns>
            public static UpdateResult PermissionError()
            {
                return Failed(CommonMessages.PERMISSION_ERROR);
            }

            public static UpdateResult Success(ChangeDataResponce changeDataResponse)
            {
                //ChangeDataResponse could be null for condition : skip autosave mode, return success instead of error message.
                //if (changeDataResponse == null)
                //    throw new ArgumentException("changeDataResponse is required for a success result", "changeDataResponse");
                return new UpdateResult(ResultType.Success, "Survey updated successfully", changeDataResponse);
            }

            private UpdateResult(ResultType type, string message, ChangeDataResponce changeDataResponse = null)
            {
                this.Type = type;
                this.Message = message;
                this.ChangeDataResponse = changeDataResponse;
            }

            public override string ToString()
            {
                bool hasChangeDataResponse = (ChangeDataResponse != null);
                return $"[{nameof(UpdateResult)} - IsSuccess={IsSuccess}, Type={Type}, Message={Message}, hasChangeDataResponse={hasChangeDataResponse}]";
            }

        } //end of UpdateResult

        /// <summary>
        /// Object that holds the result of SaveResponseAndUpdateStatus (fka "DataProcessing"). 
        /// If IsFailed is true then Message will contain an error message, otherwise
        /// the data processing was a success and the Id of the updated or new response entity can be obtained from QnnRespId
        /// </summary>
        private class DataProcessingResult
        {
            public enum Outcome { Success, UnexpectedError, ModifiedElsewhere, StrataFilled }

            public Outcome Reason { get; }
            public bool IsFailed { get => Reason != Outcome.Success; }
            public Guid? QnnRespId { get; }
            public SurveyResponseVersionToken Version { get; }
            public bool? IsStrataFilled { get; }
            public bool? IsComplete { get; }
            
            public static DataProcessingResult Fail(Outcome reason)
            {
                if (reason == Outcome.Success) throw new ArgumentException("Invalid reason", nameof(reason));
                return new DataProcessingResult(failed: true, reason, null, null, null, null);
            }

            public static DataProcessingResult Success(
                Guid respId, 
                SurveyResponseVersionToken version, 
                bool strataFilled,
                bool isComplete)
            {
                if (version == null) throw new ArgumentNullException(nameof(version));
                return new DataProcessingResult(false, Outcome.Success, respId, version, strataFilled, isComplete);
            }

            public override string ToString()
            {
                return $"{nameof(DataProcessingResult)}[IsFailed={IsFailed}, Reason={Reason}, QnnRespId={QnnRespId}, Version={Version}, IsStrataFilled={IsStrataFilled}, IsComplete={IsComplete}]";
            }

            private DataProcessingResult(bool failed, Outcome result, Guid? qnnRespId, SurveyResponseVersionToken version, bool? isStrataFilled, bool? isComplete)
            {
                this.Reason = result;
                this.QnnRespId = qnnRespId;
                this.Version = version;
                this.IsStrataFilled = isStrataFilled;
                this.IsComplete = isComplete;
            }
        } //end of DataProcessingResult

        /// <summary>
        /// The type of action to take when updating. This indicates to the updater what changes it should 
        /// make to status, whether to set a completed date, and so forth
        /// </summary>
        public enum Action 
        {
            /// <summary>
            /// Save is used when saving 'drafts', such as when the save button is clicked, on autosave, or when navigating to next page.
            /// </summary>
            Save,
            /// <summary>
            /// Submit is used to indicate that they are submitting their survey response. 
            /// </summary>
            Submit
        }

        private string ipAddressInternal;

        /// <summary>
        /// IP Address of the respondent
        /// </summary>
        public string IpAddress { get => ipAddressInternal; set {

                //TODO - handle this better please...
                //below is q&d hack (I am in a rush now) to avoid trying to insert/update invalid length ipaddress to db
                //in theory we don't expect any, in practice ... lol anything can happen
                if(value!=null && Encoding.ASCII.GetByteCount(value)>45)
                {
                    logger.LogWarning(nameof(IpAddress) + " - ignoring value longer than 45, instance={0}, value={0}", this.GetHashCode(), value);
                    ipAddressInternal = null;
                }
                else
                {
                    ipAddressInternal = value;
                }
            }
        }

        /// <summary>
        /// The URL of the page requesting that we save. This would be the url of the survey form used to edit the response.
        /// In that path will be some ids we need. 
        /// </summary>
        public string Referer { get; set; }

        /// <summary>
        /// If updating by data editor or not using the anonymous then this must be set to Empty
        /// </summary>
        public Guid AnonymousId { get; set; } = Guid.Empty;

        /// <summary>
        /// Id of the existing response to update in QNN_RESP. If there is none please set this to Guid.Empty.
        /// </summary>
        public Guid QnnRespId { get; set; } = Guid.Empty; //may be empty in certain cases

        //TODO - privitise constructor and have QnnSample or DateEditor passed to it, provide two factory methods

        /// <summary>
        /// When updating by a respondent this must be set to their QNN_SAMPLE and must be null if being
        /// updated by a data editor
        /// </summary>
        public QNN_SAMPLE QnnSample { get; set; }

        /// <summary>
        /// When updating by a data editor this must be set to that User , but must be null if updating
        /// by a respondent
        /// </summary>
        public User DataEditor { get; set; }

        //TODO - parsing headers is controller's resposibility make this a DateTime, also follow up on whether it
        //       can be null or not as looks like will hit error if it is null (so should be required by ctor)
        /// <summary>
        /// Timestamp taken from "timestamp" header in the request
        /// </summary>
        public string CurrentTimeStamp { get; set; }

        /// <summary>
        /// If autosave trigger this update or normal save then this must be null.
        /// updated by a data editor
        /// </summary>
        public bool IsAutoSave { get; set; }

        public bool IsEnableResponseVersionCheck { get; set; } = true;

        private bool initialised = false; //will set to true in Initialise 
        private EntityModel qnnDplySampleInfoModel;
        private EntityModel vSpListSampleInfoModel;
        private EntityModel vSpDeploymentRespCountModel;
        private EntityModel qnnQnnFieldModel;
        private EntityModel qnnRespModel;
        private EntityModel qnnDplyModel;

        private readonly Guid QnnDplySampleInfoId;
        private SurveyUserType personUpdatingIs; //is this being done by a data editor or a respondent
        private string ResponseBy
        {
            get => (personUpdatingIs == SurveyUserType.DataEditor)
                    ? Constants.ResponseBy.Editor
                    : Constants.ResponseBy.Sample;
        }
        private AuditBatch auditBatch = null;

        /// <summary>
        /// Constructor, requires the dlsi id
        /// </summary>
        /// <param name="qnnDplySampleInfoId">Id of the row in both QNN_DPLY_SAMPLE_INFO and vSPListSampleInfo (aka dlsi)</param>
        public SurveyResponseUpdater(Guid qnnDplySampleInfoId)
        {
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException("qnnDplySampleInfoId is not set", "qnnDplySampleInfoId");
            this.QnnDplySampleInfoId = qnnDplySampleInfoId;
        }

        /// <summary>
        /// Validate the properties are configured for the updater to operate for the specified type of user
        /// </summary>
        /// <param name="forUserType">respondent or data editor</param>
        private void Validate(SurveyUserType forUserType)
        {
            //nb: using forUserType instead of personUpdatingIs to ensure the type is ready to use too! (later we may rearrange order of calls to this)

            if (forUserType == SurveyUserType.DataEditor)
            {
                if (QnnSample != null)
                {
                    //We assume only one of DataEditor or QnnSample will be specified and so use it to
                    //tell if updating by data editor or the respondent
                    throw new InvalidOperationException("Only one of DataEditor vs QnnSample may be specified");
                }
                //presence of DataEditor was used to determine user type so we already checked that (if change it to determine another way
                //then add a check for DataEditor here too as its required is updater is a data editor)
            }
            else if (forUserType == SurveyUserType.Respondent)
            {
                if (QnnSample == null)
                {
                    throw new InvalidOperationException("QnnSample reference is required when updating for a respondent");
                }
            }
        }

        /// <summary>
        /// Save or submit survey response answers.
        /// This is the entrypoint to the survey updater logic.
        /// </summary>
        /// <param name="action">save draft vs submit</param>
        /// <param name="data">the JSON containing the survey response data from the online form</param>
        /// <returns></returns>
        public async Task<UpdateResult> Update(Action action, string data)
        {
            //This method will gather information and check things before handing over to SaveResponseAndUpdateStatus to make the db changes
            //and will then take the result from that and prepare a result to return to the caller

            //Pre-flight checks
            if (string.IsNullOrWhiteSpace(data)) return UpdateResult.Failed("Invalid input"); //we can has data?
            //determine if for respondent or dataEditor by whether DataEditor vs QnnSample reference was set. Must be only one (will confirm in Validate)
            personUpdatingIs = (DataEditor == null) ? SurveyUserType.Respondent : SurveyUserType.DataEditor;
            Validate(personUpdatingIs); //is the updater ready to go?
            if (!initialised) await Initialise(); //get entity models

            try
            {
                DynamicEntity vSpListSampleInfo = await GetVSpListSampleInfo(); //lsi
                if (!IsValidSurvey(vSpListSampleInfo) && !IsAutoSave)
                    return UpdateResult.InvalidSurveyError(); //dply/qnn not active, is deleted; qnn not online type

                //Do not show error message if data empty in autosave mode, user exit the survey before autosave complete.
                if ((!IsValidSurvey(vSpListSampleInfo) && IsAutoSave) || (string.IsNullOrWhiteSpace(data) && IsAutoSave))
                    return UpdateResult.Success(null);


                //Check access for data editor or respondent
                if (personUpdatingIs == SurveyUserType.DataEditor)
                {
                    bool sampleIsAssignedToDataEditor = await DeploymentApplication.CheckEditorsAccess(vSpListSampleInfo, DataEditor.Id);
                    if (!sampleIsAssignedToDataEditor)
                        return UpdateResult.PermissionError();
                }
                else
                {
                    bool lsiIsForThisRespondent = (QnnSample.Id == (Guid)vSpListSampleInfo[Constants.FieldName.SampleId]);
                    if (!lsiIsForThisRespondent)
                        return UpdateResult.PermissionError();
                }

                Guid qnnId = (Guid)vSpListSampleInfo[Constants.FieldName.QnnId];

                //Verify the current form design is still in sync with fields specified in QNN_QNN/QNN_QNN_FIELD
                (string msg, bool latestFormFieldsUpdatedForQnn)
                    = await FormPropertiesApplication.LatestFormFieldsUpdatedForQnn(qnnId);
                if (!latestFormFieldsUpdatedForQnn)
                {
                    return UpdateResult.Failed(msg);
                }


                bool isServingRespondent = personUpdatingIs == SurveyUserType.Respondent;
                bool isListSampleRecordActiveYN = (bool)vSpListSampleInfo[Constants.Views.FieldName.ListSampleRecordActiveYN];
                //if is ListSampleRecord not active, respondent should not be able to access the survey
                if (isServingRespondent && !isListSampleRecordActiveYN) return UpdateResult.PermissionError();

                ListSampleInfo lsi = ListSampleInfo.FromDynamic(vSpListSampleInfo); //TODO - laer might move earlier and use this more?
                bool respondentIsAnonymousSample 
                    = ResponseApplication.IsRespondentIsAnonymousSample(isServingRespondent, AnonymousId, lsi.IsAnonymousSurvey, lsi.UID);

                //Get the existing response (this may be null if they haven't started a response yet)
                //It uses the QnnRespId and a bunch of other stuff to find it. 
                //For an Anonymous survey it will also depend on the AnonymousId (from the cookie)
                DynamicEntity qnnResp = await GetQnnResp(vSpListSampleInfo, respondentIsAnonymousSample);
                DateTime? respDateEnd = (qnnResp==null) ? null : (DateTime?)qnnResp[Constants.FieldName.DateComplete];

                QnnStatusId status = QnnStatusId.FromGuid((Guid)vSpListSampleInfo[Constants.FieldName.Status]);
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById((Guid)vSpListSampleInfo[Constants.FieldName.DplyId], qnnDplyModel);
                if (qnnDply == null) throw new InvalidOperationException("Could not find deployment");

                //Use the appropriate StructDivisionId (for the audit events we have control over at least, ORM will
                //unfortunately use null if there is no current user). See issue #157
                Guid structDivisionIdForAuditPurposes;
                switch (personUpdatingIs)
                {
                    case SurveyUserType.DataEditor:
                        structDivisionIdForAuditPurposes = DataEditor.StructDivisionId.Value;
                        break;

                    case SurveyUserType.Respondent:
                        structDivisionIdForAuditPurposes = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                        break;

                    default: 
                        throw new NotImplementedException(personUpdatingIs.ToString());
                }

                ResponseApplication.FormEditable isFormEditable = ResponseApplication.IsFormEditable(
                    personUpdatingIs,
                    lsi,
                    respDateEnd);

                switch (isFormEditable)
                {
                    case ResponseApplication.FormEditable.NoBecauseCleared:
                        return UpdateResult.Failed("Survey has been cleared. Cannot update survey");
                    case ResponseApplication.FormEditable.NoBecauseClosed:
                        return UpdateResult.Failed("Survey has been closed");
                    case ResponseApplication.FormEditable.NoBecauseAlreadyResponded:
                        return UpdateResult.Failed("You can no longer update the survey");
                }

                //MaxResponseCount (Overall)
                bool isCreatingNewResponse = (qnnResp == null);
                if (isCreatingNewResponse)
                {
                    if (await GetSurveyReachedOverallMaxResponse(vSpListSampleInfo))
                        return UpdateResult.Failed("Survey reached its max responses.");
                }
                //n.b. Stratum Quotas are checked later as we don't have the information to check it yet here
                
                //Get the field/alias definitions for this survey
                List<DynamicEntity> qnnQnnFields = await GetQnnQnnFields(qnnId);
                if (!qnnQnnFields.Any()) 
                    return UpdateResult.InvalidSurveyError();

                bool isMultipleResponseFeaturesEnabled = ResponseApplication.IsMultipleResponseFeaturesEnabled(qnnDply);

                Guid dplyId = (Guid)vSpListSampleInfo[Constants.FieldName.DplyId];
                Guid listSampleId = (Guid)vSpListSampleInfo[Constants.FieldName.ListSampleId];
                Guid sampleId = (Guid)vSpListSampleInfo[Constants.FieldName.SampleId];

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    //n.b. I'm including the hashcode in these logs as 'instance'
                    //     so its easier to differentiate between different updaters when concurrent activity is logged
                    logger.LogTrace(nameof(Update) + " - before deserialize json - instance={0}, action={1}, personUpdatingIs={2}, qnnQnnFields.Count={3}, data.Length={4}, isMultipleResponseFeaturesEnabled={5}, isCreatingNewResponse={6}, isAutoSave={7}, dplyId={8}, listSampleId={9}, sampleId={10}", this.GetHashCode(), action, personUpdatingIs, qnnQnnFields?.Count, data?.Length, isMultipleResponseFeaturesEnabled, isCreatingNewResponse, IsAutoSave, dplyId, listSampleId, sampleId);
                }
                
                Dictionary<string, object> surveyData = DeserializeSurveyData(data);

                //Save/update the survey answers in the db in a single tx using the context we have marshalled
                DataProcessingResult result = await SaveResponseAndUpdateStatus(
                    surveyData: surveyData,
                    isMultipleResponseFeaturesEnabled: isMultipleResponseFeaturesEnabled,
                    qnnQnnId: qnnId, 
                    qnnDplyId: dplyId,
                    qnnListSampleId: listSampleId,
                    sampleId: sampleId,
                    qnnQnnFields: qnnQnnFields, 
                    qnnResp: qnnResp, 
                    action: action,
                    structDivisionIdForAuditPurposes: structDivisionIdForAuditPurposes);

                if(logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(Update) + " - after saving - instance={0}, result={1}", this.GetHashCode(), result);
                }
                
                if (result.IsFailed)
                {
                    switch (result.Reason)
                    {
                        case DataProcessingResult.Outcome.Success: //Shouldn't be possible
                            throw new InvalidOperationException($"result.IsFailed={result.IsFailed} but reason is {result.Reason}");
                        
                        case DataProcessingResult.Outcome.ModifiedElsewhere: //Multiple tabs open (or autosave timing issue)
                            return UpdateResult.ConcurrentResponseModificationError();

                        case DataProcessingResult.Outcome.StrataFilled: //Trying to complete a response for strata that reached quota
                            return UpdateResult.StrataFilled();

                        case DataProcessingResult.Outcome.UnexpectedError:
                        default:
                            return UpdateResult.GenericError();

                    }
                }

                //Prepare the success response item   
                Dictionary<string, object> responseEntity = surveyData.ToDictionary(pair => pair.Key, pair => (object)pair.Value);
                surveyData = null; //set null now to fast-fail if we accidentally try to modify it instead of responseEntity below
                                             
                string surveyRedirectUrl = (string)vSpListSampleInfo[Constants.FieldName.CompleteURL];
                bool isReturnRedirect = !responseEntity.ContainsKey(Constants.SurveyResponseProperties.IsSurvey); //TODO - I don't understand this
                if (isReturnRedirect)
                {
                    //redirection info
                    string completeAction = (string)vSpListSampleInfo[Constants.FieldName.CompleteAction];
                    //bool isSurveyRedirect = ("R".Equals(completeAction)) && action == Action.Submit;
                    //completeAction seems no longer needed, the UI input also gets hidden, you only get 'C' for all records.
                    //Currently decided to leave the column in db, But when decided to remove it, please do not leave the "lava flow", remember UI and backend (logic and db) also need clean up too.

                    responseEntity[Constants.SurveyResponseProperties.IsSurvey] = true;
                    responseEntity[Constants.SurveyResponseProperties.SurveyRedirectUrl] = surveyRedirectUrl;
                    responseEntity[Constants.SurveyResponseProperties.UrlFilter] = "?dlsi=" + QnnDplySampleInfoId;
                }

                bool isSurveyRedirect = action == Action.Submit;
                if (personUpdatingIs == SurveyUserType.DataEditor || string.IsNullOrEmpty(surveyRedirectUrl))
                {
                    //not to redirect for dataeditor, and not redirect if URL is null or empty
                    isSurveyRedirect = false;
                }
                responseEntity[Constants.SurveyResponseProperties.SurveyRedirect] = isSurveyRedirect;
                responseEntity[Constants.SurveyResponseProperties.QnnRespId] = result.QnnRespId.Value; 
                responseEntity[Constants.SurveyResponseProperties.SurveyResponseVersion] = result.Version.Value;
                responseEntity[Constants.SurveyResponseProperties.IsStrataFilled] = result.IsStrataFilled;
                responseEntity[Constants.SurveyResponseProperties.IsComplete] = result.IsComplete;

                return UpdateResult.Success(
                    new ChangeDataResponce
                    {
                        EntityId = null,
                        Entity = responseEntity,
                    });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Update) + " - caught unexpected exception, instance={0}, action={1}", this.GetHashCode(), action);
                return UpdateResult.Failed("Not able to update response data. Please check with system administrator");
            }
        } //end of Update

        /// <summary>
        /// Called from Update to do the actual work of writing answers to the database
        /// Also responsible for calling the method to update the status in the dlsi
        /// </summary>
        private async Task<DataProcessingResult> SaveResponseAndUpdateStatus(
            Dictionary<string, object> surveyData,
            bool isMultipleResponseFeaturesEnabled,
            Guid qnnQnnId,
            Guid qnnDplyId,
            Guid qnnListSampleId,
            Guid sampleId,
            List<DynamicEntity> qnnQnnFields,
            DynamicEntity qnnResp, //may be null if no response yet
            Action action,
            Guid structDivisionIdForAuditPurposes)
        {
            try
            {
                bool isExistingResponse = (qnnResp != null);
                auditBatch = await AuditSettings.NewBatchAsync(CloverRuntime.Security.CurrentUser?.Id ?? Guid.Empty, sampleId);
                Guid respId = isExistingResponse
                    ? (Guid)qnnResp?[Constants.FieldName.Id]
                    : Guid.NewGuid(); //we need to know in advance so can pass it to PrepareAnswersTable

                SurveyResponseVersionToken currentVersion = SurveyResponseVersionToken.FromQnnResp(qnnResp);
                if(logger.IsEnabled(LogLevel.Trace))
                {
                    DateTime? respUpdatedDate = qnnResp == null ? null : (DateTime?)qnnResp[Constants.FieldName.UpdatedDate];
                    logger.LogTrace(nameof(SaveResponseAndUpdateStatus) + " - instance={0}, EventBatch={1}, currentVersion={2}, respUpdatedDate={3}, IsEnableResponseVersionCheck={4}", this.GetHashCode(), auditBatch.EventBatch, currentVersion, respUpdatedDate, IsEnableResponseVersionCheck);
                }

                //Extract data from the JSON to be written to QNN_RESP_ANS and lastSavedPage to go in QNN_RESP
                PreparedResponseData response = await PrepareResponseData(
                        surveyData,
                        isExistingResponse,
                        qnnDplyId,
                        respId,  
                        qnnQnnFields);

                //Check to see if the response was modified elsewhere and if so this request will be rejected as the
                //information it was based on is out of date and would overwrite the newer changes that were made
                if(IsEnableResponseVersionCheck && response.VersionUpdating != currentVersion)
                    throw new InvalidVersionException(response.VersionUpdating, currentVersion);

                //Stratum Quotas (we only block for this on the server-side when submitting first time)
                bool isCompleteBeforeUpdate = (qnnResp != null) && (qnnResp[Constants.FieldName.DateComplete] != null);
                bool isFirstSubmission = (Action.Submit == action) && !isCompleteBeforeUpdate;
                if (isFirstSubmission && response.IsStrataFilled)
                {
                    //n.b this fail will prevent the latest changes from saving
                    return DataProcessingResult.Fail(DataProcessingResult.Outcome.StrataFilled);
                }

                bool isComplete;
                using (SharedTransaction transaction = new SharedTransaction())
                {
                    try
                    {
                        transaction.BeginTransactionAsync().Wait();

                        DateTime now = DateTime.Now;

                        string lastResponseAs = Constants.ResponseAs.Form;
                        string lastResponseBy = ResponseBy;
                        string lastResponseVia = Constants.ResponseVia.Online;
                        //LastResponseUserId is the existing UserId column. Because of existing uses
                        //these columns have the weird semantic that their value is only applicable
                        //when the By is Editor, but they retain their existing previous value when
                        //there is an update with By=Sample and for the UserId case that id is exported
                        //with the csv as a sort of 'this data editor was the last data editor who
                        //touched it though maybe a sample touched it since then' type of value.
                        //This is apparently of interest to some customers so must be preserved
                        //and we'll extend this behaviour to the new InitialResponseUserId and
                        //CompletedResponseUserId for consistency so they do the same weirdness and
                        //we dont have to remember different weirdness for each.
                        //tldr: if By=Sample then UserId=older
                        //      (the view spSP_DeploymentSample used in the DE dashboard applies this logic)
                        Guid? lastResponseUserId = (personUpdatingIs == SurveyUserType.DataEditor)
                            ? DataEditor.Id
                            : isExistingResponse ? (Guid?)qnnResp[Constants.FieldName.UserId] : null;

                        //n.b. UpdatedDate is also used for the version token, so ensure everything below uses same
                        //     value with this variable
                        DateTime updatedDate = now; //As per issue #122, always update for both saving and submitting now
                        SurveyResponseVersionToken newVersion = SurveyResponseVersionToken.FromUpdatedDate(updatedDate);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            logger.LogTrace(nameof(SaveResponseAndUpdateStatus) + " - instance={0}, EventBatch={1}, newVersion={2}, updatedDate={3}", this.GetHashCode(), auditBatch.EventBatch, newVersion, updatedDate);
                        }

                        if (isExistingResponse)
                        {
                            //TODO - 20241016 - to review the following check, is it redundant because of the version token? does it actually make sense? Should it return fake success or fail explicitly? The CurrentTimeStamp is submitted from client. Is it really 'current', or from previous update like our new token?
                            if (((DateTime?)qnnResp[Constants.FieldName.UpdatedDate] > DateTime.Parse(CurrentTimeStamp)
                                || (DateTime?)qnnResp[Constants.FieldName.DateComplete] > DateTime.Parse(CurrentTimeStamp))
                            && IsAutoSave)
                            {
                                if(logger.IsEnabled(LogLevel.Trace))
                                {
                                    logger.LogTrace(nameof(SaveResponseAndUpdateStatus) + " -  returning nominal Success value without updating. instance={0}, EventBatch={1}, CurrentTimeStamp={2}, response UpdatedDate={3}, DateComplete={4}", this.GetHashCode(), auditBatch.EventBatch, CurrentTimeStamp, (DateTime?)qnnResp[Constants.FieldName.UpdatedDate], (DateTime?)qnnResp[Constants.FieldName.DateComplete]);
                                }
                                isComplete = (qnnResp[Constants.FieldName.DateComplete] != null);
                                return DataProcessingResult.Success(respId, currentVersion, response.IsStrataFilled, isComplete);
                            }

                            //Update an existing QNN_RESP in the db (id refers to one that is already there)

                            //Delete the previous answers in the existing response (wipes the related QNN_RESP_ANS rows)
                            spSP_DeleteAllRespAnsByRespId spSP_DeleteAllRespAnsByRespId
                                = await spSP_DeleteAllRespAnsByRespId.GetInstanceUsingAppSettingsAsync();
                            await spSP_DeleteAllRespAnsByRespId.DeleteResp(
                                qnnRespId: respId, 
                                structDivisionId: structDivisionIdForAuditPurposes, 
                                auditBatch: auditBatch);

                            //Before refactoring was: {"DateStart", (bool?)respEntity["IsPrePopulated"]==true? dateStart:respEntity["DateStart"]??DBNull.Value}
                            //nb: pre-population was previously referred to as "imputation"
                            bool responseWasCreatedByPrePopulation = (true == (bool?)qnnResp[Constants.FieldName.IsPrePopulated]);

                            //Preserve existing response start date unless the existing response was from pre-pop (ie: not respondent created)
                            DateTime? dateStartForUpdate = responseWasCreatedByPrePopulation 
                                ? now 
                                : (DateTime?)qnnResp[Constants.FieldName.DateStart];

                            //If saving then preserve the DateComplete (will be null before submit), if submitting then set it to current time
                            DateTime? dateComplete = (action == Action.Save) 
                                ? ((DateTime?)qnnResp[Constants.FieldName.DateComplete] ?? null) 
                                : DateTime.Now;
                            isComplete = (dateComplete != null);

                            //previously was isInitiated = (string)qnnResp[Constants.FieldName.InitialResponseAs] != Constants.InitialResponseAs.PrePopulated;
                            bool isResponseStartedAlready //fka isInitiated
                                = ((DateTime?)qnnResp[Constants.FieldName.DateStart] != null);

                            Guid? initialResponseUserId;
                            string initialResponseAs, initialResponseBy, initialResponseVia;
                            if (isResponseStartedAlready)
                            {   //Preserve the initially recorded origin indicators when updating
                                initialResponseAs = (string)qnnResp[Constants.FieldName.InitialResponseAs];
                                initialResponseBy = (string)qnnResp[Constants.FieldName.InitialResponseBy];
                                initialResponseVia = (string)qnnResp[Constants.FieldName.InitialResponseVia];
                                initialResponseUserId = (Guid?)qnnResp[Constants.FieldName.InitialResponseUserId];
                            }
                            else
                            {   //This update is starting the response (i.e. existing qnn_resp row due to something like prePopulation)
                                //So we need to record the origin indicators
                                initialResponseAs = Constants.ResponseAs.Form;
                                initialResponseBy = ResponseBy; //editor vs respondent
                                initialResponseVia = Constants.ResponseVia.Online;
                                //For data editors initial respondent may vary as can be many data editors, but there is only
                                //one respondent. So for DE case initialResponseUserId records their Id. For Sample case no need
                                //an extra column as UID already recorded. The initialResponseBy indicates which applies.
                                initialResponseUserId = (personUpdatingIs == SurveyUserType.DataEditor) ? DataEditor.Id : null;
                            }

                            Guid? completedResponseUserId;
                            string completedResponseAs, completedResponseBy, completedResponseVia;
                            switch (action)
                            {
                                case Action.Save:
                                    //Preserve the existing values for completion indicators (would be null if never submit yet)
                                    completedResponseAs = (string)qnnResp[Constants.FieldName.CompletedResponseAs];
                                    completedResponseBy = (string)qnnResp[Constants.FieldName.CompletedResponseBy];
                                    completedResponseVia = (string)qnnResp[Constants.FieldName.CompletedResponseVia];
                                    completedResponseUserId = (Guid?)qnnResp[Constants.FieldName.CompletedResponseUserId];
                                    break;

                                case Action.Submit:
                                    completedResponseAs = lastResponseAs;
                                    completedResponseBy = lastResponseBy;
                                    completedResponseVia = lastResponseVia;
                                    //For why old value of completedResponseUserId is preserved for sample,
                                    //please see notes on LastResponseUserId above
                                    completedResponseUserId = (personUpdatingIs == SurveyUserType.DataEditor)
                                        ? DataEditor.Id
                                        : (Guid?)qnnResp[Constants.FieldName.CompletedResponseUserId];
                                    break;

                                default:
                                    throw new NotImplementedException(action.ToString());
                            } //end switch on action

                            spSP_UpdateResp spSP_UpdateResp
                                = await spSP_UpdateResp.GetInstanceUsingAppSettingsAsync();
                            await spSP_UpdateResp.UpdateResponse(
                                auditBatch: auditBatch,
                                auditStructDivisionId: structDivisionIdForAuditPurposes,
                                existingRespId: respId,
                                updatedDate: updatedDate,
                                dateStart: dateStartForUpdate,
                                dateComplete: dateComplete,
                                lastSavedPage: response.LastSavedPage,
                                ipAddress: IpAddress,
                                initialResponseAs: initialResponseAs,
                                initialResponseBy: initialResponseBy,
                                initialResponseVia: initialResponseVia,
                                initialResponseUserId: initialResponseUserId,
                                lastResponseAs: lastResponseAs,
                                lastResponseBy: lastResponseBy,
                                lastResponseVia: lastResponseVia,
                                userId: lastResponseUserId,
                                completedResponseAs: completedResponseAs,
                                completedResponseBy: completedResponseBy,
                                completedResponseVia: completedResponseVia,
                                completedResponseUserId: completedResponseUserId,
                                strata: response.Strata);
                        } //end update existing response row
                        else
                        {
                            //There is no existing QNN_RESP row so we shall create one                     

                            DateTime? dateComplete;
                            string completedResponseAs, completedResponseBy, completedResponseVia;
                            Guid? completedResponseUserId;
                            if (Action.Submit == action)
                            {
                                dateComplete = now;
                                completedResponseAs = Constants.ResponseAs.Form;
                                completedResponseBy = ResponseBy;
                                completedResponseVia = Constants.ResponseVia.Online;
                                completedResponseUserId = lastResponseUserId;
                            }
                            else
                            {
                                dateComplete = null;
                                completedResponseAs = null;
                                completedResponseBy = null;
                                completedResponseVia = null;
                                completedResponseUserId = null;
                            }
                            isComplete = (dateComplete != null);

                            //Write a new QNN_RESP row to the db (it will be using the new id we generated)
                            spSP_InsertResp spSP_InsertResp 
                                = await spSP_InsertResp.GetInstanceUsingAppSettingsAsync();
                            await spSP_InsertResp.InsertResponse(
                                auditBatch: auditBatch,
                                auditStructDivisionId: structDivisionIdForAuditPurposes,
                                newRespId: respId,
                                updatedDate: updatedDate,
                                qnnId: qnnQnnId,
                                listSampleId: qnnListSampleId,
                                dplyId: qnnDplyId,
                                dateStart: now,
                                dateComplete: dateComplete,
                                lastSavedPage: response.LastSavedPage,
                                anonymousId: AnonymousId,
                                ipAddress: IpAddress,
                                initialResponseAs: lastResponseAs, //first and last are same here
                                initialResponseBy: lastResponseBy, //first and last are same here
                                initialResponseVia: lastResponseVia, //first and last are same here
                                initialResponseUserId: lastResponseUserId, //first and last are same here
                                lastResponseAs: lastResponseAs,
                                lastResponseBy: lastResponseBy,
                                lastResponseVia: lastResponseVia,
                                userId: lastResponseUserId,
                                completedResponseAs: completedResponseAs,
                                completedResponseBy: completedResponseBy,
                                completedResponseVia: completedResponseVia,
                                completedResponseUserId: completedResponseUserId,
                                strata: response.Strata);
                        }  //end inserting new response row                       

                        //With the QNN_RESP row in place we can now insert the QNN_RESP_ANS rows that refer to it
                        DbHelper.BulkCopyDataTable(response.DataForQnnRespAns, transaction, timeoutSeconds: 120);

                        //Update status in QNN_DPLY_SAMPLE_INFO
                        await UpdateStatus(
                            transaction, 
                            qnnDplyId, 
                            isMultipleResponseFeaturesEnabled,
                            qnnListSampleId, 
                            action,
                            structDivisionIdForAuditPurposes);

                        if (auditBatch.AuditOn)
                        {
                            //audit - we record a json with all the new answer data
                            string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(response.DataForQnnRespAns);
                            await SurveyPlusAuditHelper.BatchImport(
                                Constants.ModelName.QNN_RESP_ANS,
                                auditBatch,
                                structDivisionIdForAuditPurposes,
                                newValue);
                        }
                        auditBatch = null;

                        transaction.Commit();

                        return DataProcessingResult.Success(respId, newVersion, response.IsStrataFilled, isComplete);
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(SaveResponseAndUpdateStatus) + " - caught unexpected exception (inner catch), rolling back and returning fail result, instance={0}, isMultipleResponseFeaturesEnabled={1}, qnnQnnId={2}, qnnDplyId={3}, qnnListSampleId={4}, sampleId={5}, action={6}, respId={7}", this.GetHashCode(), isMultipleResponseFeaturesEnabled, qnnQnnId, qnnDplyId, qnnListSampleId, sampleId, action, respId);

                        await transaction.RollbackAsync().ConfigureAwait(false);
                        return DataProcessingResult.Fail(DataProcessingResult.Outcome.UnexpectedError);
                    }
                } // end using shared
            }
            catch (InvalidVersionException ive)
            {
                logger.LogError(nameof(SaveResponseAndUpdateStatus) + " - response modified elsewhere, versionUpdating={0}, currentVersion={1}, qnnDplyId={2}, qnnListSampleId={3}, sampleId={4}, action={5},", ive.VersionUpdating, ive.CurrentVersion, qnnDplyId, qnnListSampleId, sampleId, action);

                return DataProcessingResult.Fail(DataProcessingResult.Outcome.ModifiedElsewhere);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SaveResponseAndUpdateStatus) + " - caught unexpected exception (outer catch), returning fail result, instance={0}, isMultipleResponseFeaturesEnabled={1}, qnnQnnId={2}, qnnDplyId={3}, qnnListSampleId={4}, sampleId={5}, action={6}", this.GetHashCode(), isMultipleResponseFeaturesEnabled, qnnQnnId, qnnDplyId, qnnListSampleId, sampleId, action);

                return DataProcessingResult.Fail(DataProcessingResult.Outcome.UnexpectedError);
            }
        } //end of DataProcessing

        /// <summary>
        /// Contains the logic to update status depending on old status and whether we are saving or submiting.
        /// The status is stored in QNN_DPLY_SAMPLE_INFO and updated using spSP_UpdateDplySampleInfo to also write audit info.
        /// </summary>
        /// <param name="transaction">shared transaction</param>
        /// <param name="qnnDplyId">deployment</param>
        /// <param name="qnnListSampleId">lsi</param>
        /// <param name="action">save vs submit</param>
        /// <returns></returns>
        private async Task UpdateStatus(
            SharedTransaction transaction, 
            Guid qnnDplyId,
            bool isMultipleResponseFeaturesEnabled, 
            Guid qnnListSampleId, 
            Action action,
            Guid structDivisionIdForAuditPurposes)
        {
            DynamicEntity qnnDplySampleInfo = await GetQnnDplySampleInfo(qnnDplyId, qnnListSampleId);
            if (qnnDplySampleInfo == null)
                throw new NotFoundException($"Missing deployment sample info for listSampleId={qnnListSampleId} in dplyId={qnnDplyId}");

            Guid qnnDplySampleInfoId = (Guid)qnnDplySampleInfo[Constants.FieldName.Id];
            QnnStatusId oldStatus = QnnStatusId.FromGuid((Guid)qnnDplySampleInfo[Constants.FieldName.Status]);
            QnnStatusId newStatus = oldStatus;
            
            switch (action)
            {
                case Action.Submit:
                    //Normal survey will go to submitted status on submission, multiple response will stay in-progress
                    newStatus = isMultipleResponseFeaturesEnabled
                        ? oldStatus
                        : QnnStatusId.Submitted;
                    break;

                case Action.Save:
                    //On first save would change to in-progress
                    if (oldStatus.IsPending || oldStatus.IsAcknowledged)
                    {
                        newStatus = QnnStatusId.InProgress;
                    }
                    break;

                default:
                    throw new InvalidOperationException("Unimplemented action");
            } //end switch on action

            bool needUpdate = (newStatus != null) && !newStatus.Equals(oldStatus);
            if (needUpdate)
            {
                //use stored procedure to update so as to have userId or sampleId in the audit log
                spSP_UpdateDplySampleInfo spSP_UpdateDplySampleInfo
                    = await spSP_UpdateDplySampleInfo.GetInstanceUsingAppSettingsAsync();
                await spSP_UpdateDplySampleInfo.UpdateDsiStatus(
                    id: qnnDplySampleInfoId,
                    structDivisionId: structDivisionIdForAuditPurposes,
                    oldStatus: oldStatus,
                    newStatus: newStatus,
                    auditBatch: auditBatch);
            } //end if needUpdate

        } //end of UpdateStatus

        /// <summary>
        /// Wraps information returned by PrepareResponseData.
        /// The main part of this is the DataTable that has been prepared ready for insertion,
        /// and the rest are some values extracted from the submitted data and needed for processing
        /// such as LastSavedPage etc
        /// </summary>
        private class PreparedResponseData
        {
            public DataTable DataForQnnRespAns { get; private set; }
            public string LastSavedPage { get; private set; }
            public string Strata { get; private set; }
            public bool IsStrataFilled { get; private set; }
            public SurveyResponseVersionToken VersionUpdating { get; private set; }

            public PreparedResponseData(
                DataTable dataForQnnRespAns,
                string lastSavedPage,
                string strata,
                bool isStrataFilled,
                SurveyResponseVersionToken versionUpdating)
            {
                this.DataForQnnRespAns = dataForQnnRespAns ?? throw new ArgumentNullException(nameof(dataForQnnRespAns));
                this.LastSavedPage = lastSavedPage;
                this.Strata = strata; //may be null
                this.IsStrataFilled = isStrataFilled;
                this.VersionUpdating = versionUpdating ?? throw new ArgumentNullException(nameof(dataForQnnRespAns));
            }
        }

        /// <summary>
        /// Prepare a DataTable with the response data, extract the lastSavedPage from the submitted
        /// data, and also the version token
        /// </summary>
        private async Task<PreparedResponseData> PrepareResponseData(
            Dictionary<string, object> surveyData,
            bool isExistingResponse,
            Guid qnnDplyId,
            Guid qnnRespId, 
            List<DynamicEntity> qnnQnnFields)
        {
            if (surveyData == null)
                throw new ArgumentNullException(nameof(surveyData));
            if (Guid.Empty.Equals(qnnRespId))
                throw new ArgumentException("qnnRespId may not be empty", nameof(qnnRespId));            
            if (qnnQnnFields == null || !qnnQnnFields.Any())
                throw new ArgumentException("qnnQnnFields may not be null or empty", nameof(qnnQnnFields));

            QNN_DPLY qnnDply = await QNN_DPLY.SelectByKey(qnnDplyId);
            if (qnnDply == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, qnnDplyId);

            //We now rely on the UI to submit back the list of fields to be marked as pre-populated
            //(previously required an additional query to qnn_resp_ans)
            HashSet<string> prePopulatedFields = surveyData.ContainsKey(Constants.SurveyResponseProperties.PrePopulatedFields)
                ? new HashSet<string>( ((JArray)surveyData[Constants.SurveyResponseProperties.PrePopulatedFields]).ToObject<string[]>(), Constants.Comparers.AliasCaseInsensitive)
                : new HashSet<string>(Constants.Comparers.AliasCaseInsensitive);

            SurveyResponseVersionToken versionUpdating 
                = SurveyResponseVersionToken.FromString((string)surveyData[Constants.SurveyResponseProperties.SurveyResponseVersion]);

            //Now we will iterate through all the fields in this survey and extract answers from the submitted json
            DataTable dataForQnnRespAns = ResponseApplication.DataTableForQnnRespAns();            
            foreach (DynamicEntity qnnField in qnnQnnFields)
            {
                Guid qnnFieldId = (Guid)qnnField[Constants.FieldName.Id];
                string fieldName = (string)qnnField[Constants.FieldName.Name];
                string ansVal = AnsVal(surveyData, fieldName);

                //set isPrePopulated to false and that field will no longer be highlighted
                //20241226 - we have simplified the per-field pre-pop flag check by using the list managed by the UI
                //           which saves us having to query the old responses. (This comes at a theoretical UX cost,
                //           which is that if the user changes the value and then changes it back again the
                //           field won't get flagged again, but in practice this is already what would appear
                //           to happen because when they change the value the autsave will save that, so they
                //           would need to change it back before the autosave saves it, and even then would not
                //           see the highlight re-appear until exiting and re-entering (or refreshing) the survey.
                //           tldr=nobody will notice the difference)
                bool isPrePopulated = prePopulatedFields.Contains(fieldName);
                dataForQnnRespAns.Rows.Add(qnnRespId, qnnFieldId, ansVal, isPrePopulated);
            }

            string lastSavedPage = (string)surveyData[Constants.SurveyResponseProperties.LastSavedPage];

            bool isStrataSourceDefined = !string.IsNullOrEmpty(qnnDply.StrataSource);
            string strata = isStrataSourceDefined
                ? AnsVal(surveyData, qnnDply.StrataSource)
                : null;
            bool isStrataFilled = isStrataSourceDefined
                ? await ResponseApplication.IsStrataFilled(qnnDplyId, strata)
                : false;

            return(new PreparedResponseData(
                dataForQnnRespAns, 
                lastSavedPage, 
                strata, 
                isStrataFilled, 
                versionUpdating));
        }

        /// <summary>
        /// Get the ListSampleInfo information based on the dlsi
        /// </summary>
        /// <returns>LSI row from vSPListSampleInfo</returns>
        private async Task<DynamicEntity> GetVSpListSampleInfo()
        {
            Filter byDlsiAndRespId = Filter.And.Equal(QnnDplySampleInfoId, Constants.FieldName.Id);
            DynamicEntity vSpListSampleInfo = (await vSpListSampleInfoModel.GetAsync(byDlsiAndRespId)).FirstOrDefault();
            return vSpListSampleInfo;
        }

        /// <summary>
        /// Find and return the existing response.
        /// The entity returned is found using a combination of identifiers depending on context, such as DplyId, ListSampleId, QnnId, RespId, AnonymousId
        /// </summary>
        /// <param name="vSpListSampleInfo">the lsi</param>
        /// <param name="respondentIsAnonymousSample">if is respondent && deployment is anonymous && uis is swzAnonymous</param>
        /// <returns>a single record from QNN_RESP or null if none were found</returns>
        private async Task<DynamicEntity> GetQnnResp(DynamicEntity vSpListSampleInfo, bool respondentIsAnonymousSample)
        {
            Guid dplyId = (Guid)vSpListSampleInfo[Constants.FieldName.DplyId];
            Guid listSampleId = (Guid)vSpListSampleInfo[Constants.FieldName.ListSampleId];
            Guid qnnId = (Guid)vSpListSampleInfo[Constants.FieldName.QnnId];
            Filter filter = Filter.And
                .Equal(dplyId, Constants.FieldName.DplyId)
                .Equal(listSampleId, Constants.FieldName.ListSampleId)
                .Equal(qnnId, Constants.FieldName.QnnId);
            if (!Guid.Empty.Equals(QnnRespId))
            {
                filter = filter.Merge(Filter.And.Equal(QnnRespId, Constants.FieldName.Id));
            }

            //intranet will not check anonymousId, only internet
            if (respondentIsAnonymousSample)
            {
                filter = filter.Merge(Filter.And.Equal(AnonymousId, Constants.FieldName.AnonymousId));
            }

            //take only 1 record for anonymous/multiple survey to prevent take too much records
            Paging pageOneRecord = Paging.Create(skip: 0, take: 1);
            Order orderByNumberId = Order.StartDesc(Constants.FieldName.NumberId);

            DynamicEntity qnnResp = (await qnnRespModel.GetAsync(filter, orderByNumberId, pageOneRecord)).FirstOrDefault();
            return qnnResp;
        } //end of GetQnnResp

        /// <summary>
        /// Return true if the overall maximum responses are limited 
        /// and the number of responses for the deployment has already reached that limit
        /// </summary>
        /// <param name="vSPListSampleInfo">dlsi</param>
        /// <returns>true or false</returns>
        private async Task<bool> GetSurveyReachedOverallMaxResponse(DynamicEntity vSPListSampleInfo)
        {
            //nb: the MaxResponse is across all responses to a deployment
            //(it is not per-sample for multi-response types)
            Guid dplyId = (Guid)vSPListSampleInfo[Constants.FieldName.DplyId];
            //20230224 - Changing logic to only consider COMPLETED responses for Max Responses quota (previously considered all)
            int count = await ResponseApplication.GetOverallSurveyResponseCount(dplyId, ResponseApplication.SurveyResponseCountType.Completed);
            int? maxResponse = (int?)vSPListSampleInfo[Constants.FieldName.MaxResponse]; //setting
            bool reachedMaxCount = ResponseApplication.HasReachedMaxResponses(maxResponse, count);
            return reachedMaxCount;
        }

        /// <summary>
        /// Get the QNN_DPLY_SAMPLE_INFO (no joins)
        /// </summary>
        /// <param name="qnnDplyId">id the dsi row references in QNN_DPLY</param>
        /// <param name="qnnListSampleId">id the dsi row references in QNN_LIST_SAMPLE</param>
        /// <returns>dsi</returns>
        private async Task<DynamicEntity> GetQnnDplySampleInfo(Guid qnnDplyId, Guid qnnListSampleId)
        {
            if (Guid.Empty.Equals(qnnDplyId))
                throw new ArgumentException("qnnDplyId may not be empty", "qnnDplyId");
            if (Guid.Empty.Equals(qnnListSampleId))
                throw new ArgumentException("qnnListSampleId may not be empty", "qnnListSampleId");
            Filter byDplyIdAndListSampleId = Filter.And
                            .Equal(qnnDplyId, Constants.FieldName.DplyId)
                            .Equal(qnnListSampleId, Constants.FieldName.ListSampleId);
            DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byDplyIdAndListSampleId)).FirstOrDefault();
            return qnnDplySampleInfo;
        }

        private bool IsValidSurvey(DynamicEntity vSpListSampleInfo)
        {
            if (vSpListSampleInfo == null || !Convert.ToBoolean(vSpListSampleInfo[Constants.FieldName.DplyStatus]) ||
                !Convert.ToBoolean(vSpListSampleInfo[Constants.FieldName.QnnStatus]) ||
                Convert.ToBoolean(vSpListSampleInfo[Constants.FieldName.DplyIsDeleted]) ||
                Convert.ToBoolean(vSpListSampleInfo[Constants.FieldName.QnnIsDeleted]) ||
                !Convert.ToBoolean(vSpListSampleInfo[Constants.FieldName.QnnType].ToString() == Constants.QnnType.Online))
                return false;
            else 
                return true;
        }

        /// <summary>
        /// True if this response is completed
        /// (Will check for presence of DateComplete value, this is not based on dlsi status)
        /// </summary>
        /// <param name="qnnResp">a QNN_RESP entity</param>
        /// <returns>true if this response is complete</returns>
        private bool IsResponseCompleted(DynamicEntity qnnResp)
        {
            return qnnResp[Constants.FieldName.DateComplete] != null;
        }

        /// <summary>
        /// Get the field definitions for the specified form properties
        /// </summary>
        /// <param name="qnnId">Id in QNN_QNN</param>
        /// <returns>fields - a list of QNN_QNN records</returns>
        private async Task<List<DynamicEntity>> GetQnnQnnFields(Guid qnnId)
        {
            var orderByNumberId = Order.StartAsc(Constants.FieldName.NumberId);
            Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
            List<DynamicEntity> qnnQnnFields = await qnnQnnFieldModel.GetAsync(byQnnId, orderByNumberId, paging: null);
            return qnnQnnFields;
        }

        private Dictionary<string, object> DeserializeSurveyData(string json)
        {
            if (json == null) throw new ArgumentNullException(nameof(json));
            try
            {
                JsonSerializerSettings settings = new JsonSerializerSettings
                {
                    Culture = System.Globalization.CultureInfo.InvariantCulture,                    
                    DateParseHandling = DateParseHandling.None
                };
                Dictionary<string, object> surveyData 
                    = JsonConvert.DeserializeObject<Dictionary<string, object>>(json, settings);
                if(logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(DeserializeSurveyData) + " - instance={0}, json.Length={1}, count={2}", this.GetHashCode(), json?.Length, surveyData.Count);
                }
                return surveyData;
            }
            catch (Exception e)
            {
                throw new FormatException("Failed to parse survey data JSON", e);
            }
        }

        /// <summary>
        /// Get the ansVal from the deserialised JSON in a string format suitable for use in QNN_RESP_ANS
        /// </summary>
        private string AnsVal(Dictionary<string, object> surveyData, string fieldName)
        {
            //A note on the data:
            //  Most things in the dictionary will be string, even for numeric fields and dates, but
            //  sometimes they might not be depending on the quirks of the front-end controls, and also to some extent on
            //  newtonsoft's efforts to guess the type to use. In particular, we will see JArray for multivalued dropdowns
            //  see: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JArray.htm
            //  For JArray the ToString will give us the JSON that we can store in QNN_RESP_ANS
            //  (For dates the settings used in DeserializeSurveyData tell newtonsoft not to try and guess what values are dates
            //  so they should all be raw strings here)
            surveyData.TryGetValue(fieldName, out object value); //unanswered questions may be absent from dictionary
            string ansVal;
            if (value is JArray jarray)
            {   //Used by multiple-value dropdown controls, we store a JSON array in QNN_RESP_ANS
                //but convert to empty string if empty to avoid storing [] in the column and to preserve the legacy behaviour
                ansVal = jarray.Any() ? jarray.ToString() : "";                
            }
            else
            {
                ansVal = value?.ToString();
            }
            return ansVal;
        }

        private async Task Initialise()
        {
            qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

            vSpListSampleInfoModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);

            vSpDeploymentRespCountModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_DeploymentRespCount, Constants.Level.NoJoins);

            qnnQnnFieldModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);

            qnnRespModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

            qnnDplyModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);

            initialised = true;
        } //end of InitialiseAsync

    } //end of SurveyResponseUpdater
}
