using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public class InvalidStatusFlowException : InvalidStatusException
    {
        public readonly QnnStatusId FromStatus;
        public readonly QnnStatusId ToStatus;

        public InvalidStatusFlowException(QnnStatusId fromStatus, QnnStatusId toStatus)
            : base($"Status flow {fromStatus} to {toStatus} is not valid")
        {
            this.FromStatus = fromStatus;
            this.ToStatus = toStatus;
        }
    }


    /// <summary>
    /// Various functions related to survey responses 
    /// </summary>
    public static class ResponseApplication
    {
        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(ResponseApplication));

        /// <summary>
        /// Performs the logic check to see if currentResponseCount has reached what is configured in the setting.
        /// </summary>
        /// <param name="maxResponseSetting">value from deployment MaxResponse, this may be null, or -1 for unlimited</param>
        /// <param name="currentResponseCount">the current response count (for the deployment, not the individual sample)</param>
        /// <returns></returns>
        public static bool HasReachedMaxResponses(int? maxResponseSetting, int currentResponseCount)
        {
            if (currentResponseCount < 0)
                throw new ArgumentException("currentResponseCount cannot be negative", "currentResponseCount");
            if (maxResponseSetting == null)
                maxResponseSetting = Constants.Unlimited;
            bool reachedMax = (Constants.Unlimited != maxResponseSetting)
                           && (currentResponseCount >= maxResponseSetting);
            return reachedMax;
        }

        /// <summary>
        /// Add a new empty QNN_RESP for specified DLSI.
        /// Permissions are checked based on the user or sample reported in the AuditBatch.
        /// Throws PermissionException if data editor or respondent lacks authority for this dlsi. 
        /// </summary>
        /// <param name="dlsi">id in vSP_ListSampleInfo or QNN_DPLY_SAMPLE_INFO</param>
        /// <param name="auditBatch">specified audit event id, and the current user or respondent</param>
        /// <param name="auditStructDivisionId">for the audit event</param>
        /// <returns>qnnRespId</returns>
        public static async Task<Guid> InsertEmptyResponse(
            Guid dlsi, 
            AuditBatch auditBatch, 
            Guid? auditStructDivisionId,
            string responseAs)
        {
            //n.b. this function assumes this is for Online, and considers the 'Form' as source. If we later add other
            //     features that call this to insert responses then make those indicators arguments to the method. 
            //

            //Because we require user / sample from this too we won't use a default if its not provided.
            //Caller must be explicit. 
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            auditBatch.AssertHasUserOrSample();

            if (!ResponseApplication.IsValidResponseAs(responseAs))
                throw new ArgumentException(nameof(responseAs));

            try
            {
                ListSampleInfo listSampleInfo = await ListSampleInfo.GetByDlsi(dlsi);
                if (listSampleInfo == null)
                    throw new ArgumentException("Invalid Id, could not find row in vSP_ListSampleInfo", nameof(dlsi));

                //Check access rights for user (data editor) or sample (respondent)
                //This is based on the values in the audit batch
                bool isForDataEditor = auditBatch.HasUser;
                if (isForDataEditor)
                {
                    if (await DeploymentApplication.CheckEditorsAccess(listSampleInfo) == false)
                        throw new PermissionException();
                }
                else
                {
                    if (!listSampleInfo.SampleId.Equals(auditBatch.SampleId))
                        throw new PermissionException();
                }

                int maxResponse = listSampleInfo.MaxResponse;
                if (Constants.Unlimited != maxResponse)
                {
                    //20230224 - Changing logic to only consider COMPLETED responses for Max Responses quota (previously considered all)
                    int responseCount = await GetOverallSurveyResponseCount(listSampleInfo.DplyId, SurveyResponseCountType.Completed); //count for deployment
                    bool reachedMaxResponse = HasReachedMaxResponses(maxResponse, responseCount);
                    if (reachedMaxResponse)
                        throw new MaxResponsesException(maxResponse, responseCount);
                }

                using (SharedTransaction transaction = new SharedTransaction())
                {
                    try
                    {
                        transaction.BeginTransactionAsync().Wait();

                        Guid qnnRespId = Guid.NewGuid();

                        string ipAddress = null; //TODO
                        Guid? anonymousId = null; //TODO - if invoked by internet side this should have a value?
                        string responseBy = auditBatch.HasUser
                            ? Constants.ResponseBy.Editor
                            : Constants.ResponseBy.Sample;
                        Guid? responseUserId = auditBatch.HasUser ? auditBatch.UserId : null;
                        DateTime now = DateTime.Now;

                        spSP_InsertResp spSP_InsertResp = await spSP_InsertResp.GetInstanceUsingAppSettingsAsync();

                        //Stored procedure will record an audit event as well as inserting the new row for us
                        await spSP_InsertResp.InsertResponse(
                            auditBatch: auditBatch,
                            auditStructDivisionId: auditStructDivisionId,
                            newRespId: qnnRespId,
                            updatedDate: now,
                            qnnId: listSampleInfo.QnnId,
                            listSampleId: listSampleInfo.ListSampleId,
                            dplyId: listSampleInfo.DplyId,
                            dateStart: now,
                            dateComplete: null,
                            lastSavedPage: null,
                            anonymousId: anonymousId,
                            ipAddress: ipAddress,
                            initialResponseAs: Constants.ResponseAs.Form,
                            initialResponseBy: responseBy,
                            initialResponseVia: Constants.ResponseVia.Online,
                            initialResponseUserId: responseUserId,
                            lastResponseAs: responseAs,
                            lastResponseBy: responseBy,
                            lastResponseVia: Constants.ResponseVia.Online,
                            userId: responseUserId,
                            completedResponseAs: null,
                            completedResponseBy: null,
                            completedResponseVia: null,
                            completedResponseUserId: null,
                            strata: null);

                        //We need to create blank answers for every field in QNN_RESP_ANS
                        List<Guid> qnnFieldIds = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(listSampleInfo.QnnId))
                            .Select(field => (Guid)field[Constants.FieldName.Id])
                            .ToList();
                        DataTable qnnRespAnsTable = DataTableForQnnRespAns();
                        List<dynamic> auditData = auditBatch.AuditOn ? new List<dynamic>(qnnFieldIds.Count) : null;
                        foreach (Guid qnnFieldId in qnnFieldIds)
                        {
                            qnnRespAnsTable.Rows.Add(
                                qnnRespId,          //RespId
                                qnnFieldId,         //QnnFieldId
                                null,               //AnsVal
                                false);             //IsPrePopulated

                            //TODO - use SurveyPlusAuditHelper.Serialise... for this instead
                            if (auditBatch.AuditOn)
                            {
                                dynamic auditItem = new ExpandoObject();
                                auditItem.RespId = qnnRespId;
                                auditItem.QnnFieldId = qnnFieldId;
                                auditItem.AnsVal = null;
                                auditItem.IsPrePopulated = false;
                                auditData.Add(auditItem);
                            }
                        }

                        DbHelper.BulkCopyDataTable(qnnRespAnsTable, transaction, timeoutSeconds: 600);
                        if (auditBatch.AuditOn)
                        {
                            //audit, we will write a single row for all this response's answers using json for the value
                            string auditDataJson = JsonConvert.SerializeObject(auditData, Formatting.Indented);
                            await SurveyPlusAuditHelper.BatchImport(Constants.ModelName.QNN_RESP_ANS, auditBatch, auditStructDivisionId, auditDataJson);
                        }

                        transaction.Commit();
                        return qnnRespId;
                    }
                    catch (Exception)
                    {
                        await transaction.RollbackAsync().ConfigureAwait(false);
                        throw; //caller to handle / log (will go via the outer catch first)
                    }
                } //end using shared tx
            }
            catch (Exception e)
            {
                if(_logger.IsEnabled(LogLevel.Trace))
                {
                    _logger.LogTrace(nameof(InsertEmptyResponse) + " - dlsi={0}, eventBatch={1}, wrapping and re-throwing {1} with message: {2}", dlsi, auditBatch.EventBatch, e.GetType().FullName, e.Message);
                }
                throw new InternalException($"InsertEmptyResponse failed for dlsi={dlsi}, eventBatch={auditBatch.EventBatch}", e);
            }
        } //end of InsertEmptyResponse

        /// <summary>
        /// Helper method to get an instance of entity QNN_RESP by its id.
        /// Will throw an argument exception on empty Guid or invalid model reference
        /// </summary>
        /// <param name="id">id, may not be empty</param>
        /// <param name="qnnRespModel">optional model to use. Will use NoJoins fetch if not specified.</param>
        /// <returns>entity or null if not found</returns>
        public static async Task<DynamicEntity> GetQnnRespById(Guid id, EntityModel qnnRespModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_RESP, qnnRespModel);
        }

        /// <summary>
        /// Get the responses (QNN_RESP) made by the specified listSample to the specified deployment.
        /// </summary>
        /// <param name="dplyId">id in QNN_DPLY</param>
        /// <param name="listSampleId">id in QNN_LIST_SAMPLE</param>
        /// <param name="qnnRespModel">optional QNN_RESP model, if not specified a no-join model will be used</param>
        /// <returns>list of QNN_RESP entityl, may be empty but never null</returns>
        public static async Task<List<DynamicEntity>> GetResponsesForSample(Guid dplyId, Guid listSampleId, EntityModel qnnRespModel = null)
        {
            if (Guid.Empty.Equals(dplyId))
                throw new ArgumentException("dplyId may not be empty", "id");
            if (Guid.Empty.Equals(listSampleId))
                throw new ArgumentException("listSampleId may not be empty", "id");

            if (qnnRespModel == null)
            {
                qnnRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);
            }
            else if (!Constants.ModelName.QNN_RESP.Equals(qnnRespModel.Name))
            {
                throw new ArgumentException("Expected model for " + Constants.ModelName.QNN_RESP, "qnnRespModel");
            }
            Filter byDplyIdAndListSampleId = Filter.And
                .Equal(dplyId, Constants.FieldName.DplyId)
                .Equal(listSampleId, Constants.FieldName.ListSampleId);
            List<DynamicEntity> responses = await qnnRespModel.GetAsync(byDplyIdAndListSampleId);
            return responses;
        }

        public enum SurveyResponseCountType { All, Completed }

        /// <summary>
        /// Get the count of responses for the survey (ie: across all samples in the deployment).
        /// Uses vSP_DeploymentRespCount or vSP_DeploymentRespCompleteCount
        /// </summary>
        /// <param name="qnnDplyId">Id in QNN_DPLY</param>
        /// <param name="type">count all responses or just the completed ones</param>
        /// <returns></returns>
        public static async Task<int> GetOverallSurveyResponseCount(Guid qnnDplyId, SurveyResponseCountType type)
        {
            if (Guid.Empty.Equals(qnnDplyId).Equals(qnnDplyId))
                throw new ArgumentException("qnnDplyId may not be empty", nameof(qnnDplyId));
            string modelName;
            //Instead of just putting two columns in one view there are two different views and two different models
            //(TODO: If we want to add Incomplete we could recursively get All - Complete, but thats now two queries
            //and probably at read-committed rather than serializable. Maybe should refactor into one view then?)
            switch (type)
            {
                case SurveyResponseCountType.All:
                    modelName = Constants.ModelName.vSP_DeploymentRespCount;
                    break;

                case SurveyResponseCountType.Completed:   //<--- we use this one now
                    modelName = Constants.ModelName.vSP_DeploymentRespCompleteCount;
                    break;

                default:
                    //At the time of writing there are only the above options
                    //At the time this is thrown, someone has added more but didn't implement them here :p
                    throw new InvalidOperationException("Unimplemented SurveyResponseCountType");
            }
            EntityModel countViewModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(modelName, Constants.Level.NoJoins);
            Filter byDplyId = Filter.And.Equal(qnnDplyId, Constants.FieldName.DplyId);
            DynamicEntity count = (await countViewModel.GetAsync(byDplyId)).FirstOrDefault();
            int respCount = (count == null) ? 0 : (int)count[Constants.FieldName.RespCount]; //nb: view uses inner join, assume 0 if no row
            return respCount;
        }

        /// <summary>
        /// To identify if is still allow to proceed after X day(s) of QNN_RESP.DateComplete
        /// </summary>
        /// <param name="daysUpdate">-1 means unlimited.</param>
        /// <param name="respDateEnd">null/MinValue means not yet response</param>
        /// <returns></returns>
        public static bool IsUpdateAllowedAfterResponse(int daysUpdate, DateTime respDateEnd)
        {
            if (daysUpdate == Constants.Unlimited) return true; //No limit, always allow.
            if (respDateEnd == DateTime.MinValue) return true;
            if (respDateEnd.AddDays(daysUpdate) >= DateTime.Now) return true;
            return false;
        }

        /// <summary>
        /// To identify is Anonymous Respondent in an anonymous survey when serving a respondent.
        /// (Always false if serving data editor)
        /// </summary>
        /// <param name="isServingRespondent">if is respondent from internet (Not Data Editor)</param>
        /// <param name="anonymousId">AnonymousId from cookie. Pass EMPTY if don't have one.</param>
        /// <param name="isAnonymousSurvey">is this an anonymous deployment</param>
        /// <param name="uid">sample uId</param>
        /// <returns></returns>
        public static bool IsRespondentIsAnonymousSample(bool isServingRespondent, Guid anonymousId, bool isAnonymousSurvey, string uid)
        {
            bool result = false;
            //intranet will not check anonymousId cookie, only internet
            if (isServingRespondent)
            {
                if (anonymousId != Guid.Empty && isAnonymousSurvey)
                {
                    result = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uid);
                }
            }
            return result;
        }

        /// <summary>
        /// Is this one of the special 'multiple response' type surveys?
        /// Currently these are surveys with the "Multiple Response Survey" or "Anonymous Survey" features enabled.
        /// </summary>
        /// <param name="qnnDply">The deployment entity, may not be null</param>
        /// <returns>true if this deployment enables multiple QNN_RESP per QNN_DPLY_SAMPLE_INFO</returns>
        public static bool IsMultipleResponseFeaturesEnabled(DynamicEntity qnnDply)
        {
            return (bool)qnnDply[Constants.FieldName.IsMultipleResponse] || (bool)qnnDply[Constants.FieldName.IsAnonymous];
        }

        public static bool IsMultipleResponseFeaturesEnabled(QNN_DPLY qnnDply)
        {
            //TODO - why are these nullable columns? 
            return (qnnDply.IsMultipleResponse??false) || (qnnDply.IsAnonymous??false);
        }

        public enum FormEditable
        {
            /// <summary>
            /// The survey form may be edited in its curret state
            /// For example, not submitted yet, or within the allowed update period, or data editor access etc
            /// </summary>
            Yes,

            /// <summary>
            /// The survey form may not be edited because the status is Cleared
            /// </summary>
            NoBecauseCleared,

            /// <summary>
            /// The survey form may not be edited because it's closed already.
            /// i.e survey end date has passed and is past any due date extension for this specific sample
            /// </summary>
            NoBecauseClosed,

            /// <summary>
            /// The survey form may not be edited because this response is complete (a fuzzy term that depends on a few factors, 
            /// eg status, date complete) and not in a state that allows editing of completed responses by the respondent
            /// </summary>
            NoBecauseAlreadyResponded
        }

        public static FormEditable IsFormEditable(
            SurveyUserType editorType,
            ListSampleInfo lsi,
            DateTime? DateComplete)
        {
            return IsFormEditable(
                editorType: editorType,
                status: lsi.Status,
                dueDateApplicableToSample: lsi.DueDate,
                daysUpdate: lsi.DaysUpdate,
                isMultipleResponseFeaturesEnabled: lsi.IsMultiplResponseFeaturesEnabled,
                DateComplete);
        }

        public static FormEditable IsFormEditable(
            SurveyUserType editorType,
            QnnStatusId status,
            DateTime dueDateApplicableToSample,  //nb: as per LSI logic (from dply or might be sample specific)
            int? daysUpdate,
            bool isMultipleResponseFeaturesEnabled,
            DateTime? DateComplete)
        {
            bool isPastDue = (dueDateApplicableToSample < DateTime.Now);
            FormEditable editability;
            switch (editorType)
            {
                case SurveyUserType.Respondent:
                    //Old get for daysUpdate was Convert.ToInt32(vSpListSampleInfo[Constants.FieldName.DaysUpdate] ?? Constants.Unlimited)
                    //meaning it would be 0 if null (and NOT Unlimited!). It clearly intended null to also mean unlimited however.
                    //TODO - respDateEnd is not correct for swzAnonymous AGAIN - its someone else's response (if cookie is cleared) so once again
                    //       anonymous feature is broken where only the first respondent can answer, and they need to kludge daysUpdate to workaround

                    //DueDate in the view is based on sample-specific DueDate or deployment EndDate. (In schema the DateEnd can be null in table) 
                    //Regardless of the daysUpdate, the DueDate is terminator for submission (as per AT's comment of 2021-08-14)
                    bool isResponseComplete = (DateComplete != null); //value is from QNN_RESP.DateComplete

                    //The DaysUpdate test applies to completed responses, where the DaysUpdate setting specifies the
                    //number of days the response can still be edited by the respondent after submission, e.g. to make
                    //corrections. The comparison here is thus with the date they completed (submitted) this response
                    //and not with the DueDate.
                    bool isWithinDaysUpdate = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods
                        .IsWithinDaysUpdateAfterCompletion(DateTime.Now, daysUpdate, DateComplete);

                    editability = IsFormEditableForRespondent(
                        status,
                        isWithinDaysUpdate,
                        isPastDue,
                        isMultipleResponseFeaturesEnabled,
                        isResponseComplete);
                    break;

                case SurveyUserType.DataEditor:
                    editability = IsFormEditableForDataEditor(status);
                    break;

                default:
                    throw new NotImplementedException($"Unknown {nameof(SurveyUserType)} ({editorType})");
            }

            return editability;
        }

        private static FormEditable IsFormEditableForDataEditor(QnnStatusId status)
        {
            return status.IsCleared
                    ? FormEditable.NoBecauseCleared
                    : FormEditable.Yes;
        }

        private static FormEditable IsFormEditableForRespondent(
            QnnStatusId status,
            bool isWithinDaysUpdateOfCompletion,
            bool isClosedForThisRespondent,
            bool multipleResponseFeaturesEnabled,
            bool isResponseComplete)
        {
            if (status.IsCleared)
            {
                return FormEditable.NoBecauseCleared;
            }

            if (multipleResponseFeaturesEnabled)
            {
                //Kludge:
                //For multiple response surveys (including anonymous survey) we can't base editability on
                //status as they all shre the same status (due to legacy design decision) so instead we have
                //to base it on whether this response is complete or not (by checking presence of DateComplete)

                if (isResponseComplete)
                {
                    return isWithinDaysUpdateOfCompletion && !isClosedForThisRespondent
                        ? FormEditable.Yes
                        : FormEditable.NoBecauseAlreadyResponded;
                }
                else
                {
                    return isClosedForThisRespondent
                        ? FormEditable.NoBecauseClosed
                        : FormEditable.Yes;
                }
            }
            else
            {
                //Normal single-response surveys depend on the submission status and daysUpdate
                if (status.IsSubmitted)
                {
                    return isWithinDaysUpdateOfCompletion && !isClosedForThisRespondent
                        ? FormEditable.Yes
                        : FormEditable.NoBecauseAlreadyResponded;
                }
                else
                {
                    //Any other status (Pending, In-Progress, Exempted, all custom status etc..
                    //allows for editing if we are are in the appropriate time window. 
                    return isClosedForThisRespondent
                        ? FormEditable.NoBecauseClosed
                        : FormEditable.Yes;
                }
            }
        }

        /// <summary>
        /// Takes a list of status titles and returns the corresponding ids of the QNN_STATUS.
        /// An InvalidStatusException will be thrown if any of the specified titles aren't found.
        /// An empty collection is returned if no titles were specified, this method never returns null.
        /// </summary>
        public static async Task<IEnumerable<QnnStatusId>> GetStatusIdsFromTitlesAsync(IEnumerable<string> titles)
        {
            if (titles == null || !titles.Any()) return Constants.Flyweights.Empty_ReadOnlyCollection_QnnStatusId;

            EntityModel statusModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);

            List<string> titlesList = titles.ToList(); //Filter is a picky eater and doesn't like IEnumerables and Brocolli
            Filter byStatusTitle = Filter.And.In(titlesList, Constants.FieldName.Title);
            List<QnnStatusId> statusIdList = (await statusModel.GetAsync(byStatusTitle))
                .Select(qnnStatus => QnnStatusId.FromGuid((Guid)qnnStatus[Constants.FieldName.Id])).Distinct().ToList();
            if (titlesList.Count != statusIdList.Count)
                throw new InvalidStatusException();
            return statusIdList.AsReadOnly();
        }

        public static async Task<IEnumerable<QnnStatusId>> GetStatusIdsFromCodesAsync(IEnumerable<string> codes)
        {
            if (codes == null || !codes.Any()) return Constants.Flyweights.Empty_ReadOnlyCollection_QnnStatusId;

            EntityModel statusModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);

            List<string> codesList = codes.ToList();
            Filter byStatusCode = Filter.And.In(codesList, Constants.FieldName.Code);
            List<QnnStatusId> statusIdList = (await statusModel.GetAsync(byStatusCode))
                .Select(qnnStatus => QnnStatusId.FromGuid((Guid)qnnStatus[Constants.FieldName.Id])).Distinct().ToList();
            if (codesList.Count != statusIdList.Count)
                throw new InvalidStatusException();
            return statusIdList.AsReadOnly();
        }

        /// <summary>
        /// Returns a mutable case-insensitive dictionary of all QNN_STATUS code to the related status Id
        /// </summary>
        /// <returns>dictionary with Code as key, QnnStatusId as the value</returns>
        public static async Task<Dictionary<string, QnnStatusId>> GetStatusCodeToIdDictionary()
        {
            EntityModel statusModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);
            return (await statusModel.GetAsync(Filter.Empty))
                        .ToDictionary(
                            qnnStatus => (string)qnnStatus[Constants.FieldName.Code],
                            qnnStatus => QnnStatusId.FromGuid((Guid)qnnStatus[Constants.FieldName.Id]),
                            Constants.Comparers.ObjectNameCaseInsensitive);
        }

        /// <summary>
        /// Outcome of a successful call to RejectResponseWithComments
        /// nb: serious errors would give an exception, but the method considers an email failure non-serious
        /// </summary>
        public enum Result_RejectResponseWithComments
        {
            /// <summary>
            /// Reset successful and email queued
            /// </summary>
            SuccessWithEmail,

            /// <summary>
            /// Reset successful, sample doesn't have an email address
            /// </summary>
            SuccessWithoutEmail,

            /// <summary>
            /// Reset successful, email intentionally not sent
            /// </summary>
            SuccessRejectOnly,

            /// <summary>
            /// Reset successful, error queueing an email send
            /// </summary>
            SuccessWithEmailFailure,

            /// <summary>
            /// Reset failed because the response is not in submitted status
            /// (Ideally UI shouldn't provide the button in these cases)
            /// </summary>
            InvalidStatus,
        }

        /// <summary>
        /// Reject Response with comments will email the comments to the respondent's Email and CcEmails,
        /// update the Remarks in the QNN_RESP with the comments, and set the status back to Pending (without 
        /// clearing the existing response answers).
        /// </summary>
        /// <param name="qnnDplySampleInfoId">Id in QNN_DPLY_SAMPLE_INFO (aka dlsi)</param>
        /// <param name="qnnRespId">Id in QNN_RESP<param>
        /// <param name="isSendEmail">if false no email is sent</param>
        /// <param name="messageToRespondent">A message to include in the email to the respondent</param>
        /// <param name="remarks">Internal response remarks (stored QNN_DPLY_SAMPLE_INFO)</param>
        /// <param name="dataEditor">The data editor who is checking (will verify their access to the sample)</param>
        /// <returns>A string to return to the UI indicating the outcome on success</returns>
        /// <exception cref="ArgumentNullException"></exception>
        /// <exception cref="Exception"></exception>
        public static async Task<Result_RejectResponseWithComments> RejectResponseWithComments(
            Guid qnnDplySampleInfoId,
            Guid qnnRespId,
            bool isSendEmail,
            string messageToRespondent,
            string remarks,
            Clover.Core.Security.User dataEditor)
        {

            //TODO - do we need to check sample activeYN? Doesnt make sense to send the email to an inactive sample right?

            if (dataEditor == null) throw new ArgumentNullException(nameof(dataEditor));

            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetRemarks, Constants.PermissionGroup.Permission.View))
            {
                throw new PermissionException($"User {dataEditor.Id} lacks {Constants.PermissionGroup.Permission.View} for {Constants.PermissionGroup.SetRemarks}");
            }

            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);

            DynamicEntity qnnDplySampleInfo = null;
            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(
                        Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.Id))).FirstOrDefault();
                    if (qnnDplySampleInfo == null)
                    {
                        throw new ArgumentException($"{Constants.ModelName.QNN_DPLY_SAMPLE_INFO} {qnnDplySampleInfoId} does not exist", nameof(qnnDplySampleInfoId));
                    }

                    //Does this data editor have access for this sample?
                    if (!await DeploymentApplication.CheckEditorsAccess(qnnDplySampleInfo, dataEditor.Id))
                    {
                        throw new PermissionException($"User {dataEditor.Id} lacks access for dlsi ${qnnDplySampleInfoId}");
                    }

                    QnnStatusId currentStatus = QnnStatusId.FromGuid((Guid)qnnDplySampleInfo[Constants.FieldName.Status]);
                    if (!currentStatus.IsSubmitted)
                    {
                        _logger.LogWarning(nameof(RejectResponseWithComments) + " dlsi {0} is not in submitted status, status={1})", 
                            qnnDplySampleInfoId, currentStatus);
                        return Result_RejectResponseWithComments.InvalidStatus;
                    }

                    DateTime now = DateTime.Now;

                    qnnDplySampleInfo[Constants.FieldName.RemarksModifyOn] = now;
                    qnnDplySampleInfo[Constants.FieldName.RemarksModifyBy] = dataEditor.Id;
                    qnnDplySampleInfo[Constants.FieldName.Remarks] = string.IsNullOrEmpty(remarks) ? null : remarks;
                    qnnDplySampleInfo[Constants.FieldName.StatusModifyOn] = now;
                    qnnDplySampleInfo[Constants.FieldName.StatusModifyBy] = dataEditor.Id;
                    qnnDplySampleInfo[Constants.FieldName.Status] = QnnStatusId.Pending.Value;
                    await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);

                    EntityModel qnnRespModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);
                    DynamicEntity qnnResp = await GetQnnRespById(qnnRespId, qnnRespModel);
                    if (qnnResp == null)
                        throw NotFoundException.ForModelName(qnnRespModel.Name, qnnRespId);
                    qnnResp[Constants.FieldName.LastSavedPage] = null;
                    //Changed 20221003 to clear completion date after rejection, note that we still keep DateStart though
                    //This means that its possible to have a started response in the pending status. 
                    qnnResp[Constants.FieldName.DateComplete] = null;

                    //Added 20240519 (MISP v6 SR, ported to v8 20240723)
                    qnnResp[Constants.FieldName.UpdatedDate] = now;
                    qnnResp[Constants.FieldName.LastResponseAs] = Constants.ResponseAs.Rejection;
                    qnnResp[Constants.FieldName.LastResponseBy] = Constants.ResponseBy.Editor;
                    qnnResp[Constants.FieldName.LastResponseVia] = Constants.ResponseVia.Online;
                    qnnResp[Constants.FieldName.UserId] = dataEditor.Id;
                    qnnResp[Constants.FieldName.CompletedResponseAs] = null;
                    qnnResp[Constants.FieldName.CompletedResponseBy] = null;
                    qnnResp[Constants.FieldName.CompletedResponseVia] = null;
                    qnnResp[Constants.FieldName.CompletedResponseUserId] = null;

                    await qnnRespModel.UpdateSingleAsync(qnnResp);
                    shared.Commit();
                }
                catch (Exception e)
                {
                    string msg = $"Exception caught in Reject Response With Comments, qnnDplySampleInfoId={(Guid)qnnDplySampleInfoId}, respId={(Guid)qnnRespId}, dataEditor={(Guid)dataEditor?.Id}"; // guid is safe for log/exception msg, but if you add more take care
                    if (_logger.IsEnabled(LogLevel.Debug))
                    {
                        _logger.LogDebug(e, msg);
                    }
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception(msg, e);
                }
            } //end using shared tx

            if (!isSendEmail)
            {
                return Result_RejectResponseWithComments.SuccessRejectOnly;
            }
            else
            {
                //Send emails outside of the transaction so it doesn't rollback just for an email issue
                try
                {
                    Guid sampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.SampleId];
                    Guid structDivisionForAddress = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId + '_' + Constants.FieldName.StructDivisionId];
                    string surveyName = (string)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.SurveyName];

                    DynamicEntity qnnSample = await InternetAccountApplication.GetQnnSampleById(sampleId);
                    if (qnnSample == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_SAMPLE, sampleId);
                    string sampleName = (string)qnnSample[Constants.FieldName.Name];

                    DynamicEntity qnnSampleAddress = await InternetAccountApplication.GetSampleAddressAsync(sampleId, structDivisionForAddress);
                    if (qnnSampleAddress == null)
                    {
                        throw new NotFoundException($"Did not find {Constants.ModelName.QNN_SAMPLE_ADDRESS} for sampleId={sampleId}, structDivisionId={structDivisionForAddress}");
                    }
                    string commaDelimitedToEmails = (string)qnnSampleAddress[Constants.FieldName.ToEmails];
                    List<string> toEmails = Email.SplitAddresses(commaDelimitedToEmails);
                    bool toSendEmail = toEmails.Any(); //Note that if there are no primary address then the cc would be ignored
                    if (toSendEmail)
                    {
                        string commaDelimitedCcEmails = (string)qnnSampleAddress[Constants.FieldName.CcEmails] ?? "";
                        List<string> ccEmails = Email.SplitAddresses(commaDelimitedCcEmails);

                        //Add data editor's email as the first CC address
                        bool dataEditorHasEmail = !string.IsNullOrWhiteSpace(dataEditor.Email);
                        if (dataEditorHasEmail)
                        {
                            ccEmails.Insert(0, dataEditor.Email);
                        }

                        MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                        string appName = await SettingsHelper.Common.GetApplicationName();
                        Dictionary<string, string> parameters = new Dictionary<string, string>();
                        //Parameters share the names of the column they originate from
                        parameters[Constants.FieldName.Name] = sampleName;
                        parameters[Constants.FieldName.QnnTitle] = surveyName;
                        parameters[Constants.FieldName.SurveyName] = surveyName;
                        parameters["MessageToRespondent"] = messageToRespondent;
                        //nb: UID, UIDName are no longer made available to the template
                        //    and the comments to the respondent are no longer conflated with internal remarks
                        await Email.FormSendAsync(
                            mailSettings: mailSettings,
                            mailTo: toEmails,
                            mailCc: ccEmails,
                            mailBcc: null,
                            formName: Constants.EmailTemplate.RejectResponseEmailTemplate,
                            parameters: parameters,
                            senderDisplayName: appName);
                        return Result_RejectResponseWithComments.SuccessWithEmail;
                    }
                    else
                    {
                        return Result_RejectResponseWithComments.SuccessWithoutEmail;
                    }
                }
                catch (Exception e)
                {
                    _logger.LogError(e, nameof(RejectResponseWithComments) + " - Caught unxepected exception caught sending email notification after Reject Response With Comments, qnnDplySampleInfoId={0}, respId={1}, dataEditor={2}", qnnDplySampleInfoId, qnnRespId, dataEditor?.Id);
                    return Result_RejectResponseWithComments.SuccessWithEmailFailure;
                }
            }
        }

        /// <summary>
        /// Get rows from vSP_ListSampleInfoResp for Sample in deployment which is (no response data) or (with response data and data is pre-populated)
        /// These sample is the target to populate data or sample which do not have response
        /// 
        /// SQL will look like this :-
        /// where DplyId = 'dplyId' and ((respId is null) or (respId is not null and IsPrePopulated = 1))
        /// </summary>
        /// <param name="dplyId">Deployment Id</param>
        /// <returns>List of sample</returns>
        public static async Task<List<DynamicEntity>> GetNoRespByDplyId(Guid dplyId)
        {
            try
            {
                EntityModel model 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfoResp, Constants.Level.NoJoins);
                Filter filter
                    = Filter.And
                        .Equal(dplyId, Constants.FieldName.DplyId)
                        .NestOr()
                            .Equal(Null.Value, Constants.FieldName.RespId)
                            .NestAnd()
                                .NotEqual(Null.Value, Constants.FieldName.RespId)
                                .Equal(true, Constants.FieldName.IsPrePopulated);
                List<DynamicEntity> result = await model.GetAsync(filter);
                return result;
            }
            catch (Exception e)
            {
                if(_logger.IsEnabled(LogLevel.Debug))
                {
                    _logger.LogDebug(e, nameof(GetNoRespByDplyId) + " - caught unexpected exception, dplyId={0}", dplyId);
                }
                throw; //caller to handle
            }
        }

        /// <summary>
        /// Is this string a valid value for XXXResponseAs ?
        /// Note that if the string is null or empty this will always return false which
        /// is not what you want in the case where the indicator hasn't actually been set yet
        /// (e.g. a Completed indicator won't be set until completion). Caller needs to take
        /// this into account.
        /// (These indicators in QNN_RESP should really be defined by an enum, 
        /// but have been implemented as strings (for now) due
        /// to some inconveniences with using an enum with the ORM.)
        /// </summary>
        public static bool IsValidResponseAs(string responseAs)
        {
            if (responseAs == null) return false;
            switch (responseAs)
            {
                case Constants.ResponseAs.Unknown:
                case Constants.ResponseAs.Form:
                case Constants.ResponseAs.Excel:
                case Constants.ResponseAs.Pdf:
                case Constants.ResponseAs.PrePopulated:
                case Constants.ResponseAs.Rejection:
                    return true;
                default:
                    return false;
            }
        }

        public static bool IsValidResponseBy(string responseBy)
        {
            if (responseBy == null) return false;
            switch(responseBy)
            {
                case Constants.ResponseBy.Unknown:
                case Constants.ResponseBy.Editor:
                case Constants.ResponseBy.Sample:
                    return true;
                default:
                    return false;
            }
        }

        public static bool IsValidResponseVia(string responseVia)
        {
            if (responseVia == null) return false;
            switch(responseVia)
            {
                case Constants.ResponseVia.Unknown:
                case Constants.ResponseVia.Online:
                case Constants.ResponseVia.Offline:
                    return true;
                default:
                    return false;
            }
        }

        /// <summary>
        /// Convenience method to create a new instance of DataTable configured with mappings for QNN_RESP_ANS
        /// (does not include Id, NumberId)
        /// </summary>
        public static DataTable DataTableForQnnRespAns()
        {
            DataTable table = new DataTable();
            table.TableName = "dbo." + Constants.ModelName.QNN_RESP_ANS;
            table.Columns.Add(Constants.FieldName.RespId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.QnnFieldId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.AnsVal, typeof(string));
            table.Columns.Add(Constants.FieldName.IsPrePopulated, typeof(bool));
            return table;
        }

        public static async Task<bool> IsStrataFilled(Guid dplyId, string strata)
        {
            if (string.IsNullOrEmpty(strata)) return false;
            try
            {
                EntityModel qnnDplyStrataQuotaModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_STRATA_QUOTA, Constants.Level.NoJoins);
                Filter byDplyIdAndStrataValue = Filter.And
                    .Equal(dplyId, Constants.FieldName.DplyId)
                    .Equal(strata, Constants.FieldName.StrataValue);
                DynamicEntity strataQuota = (await qnnDplyStrataQuotaModel.GetAsync(byDplyIdAndStrataValue)).FirstOrDefault();
                bool strataIsUnlimited = (strataQuota == null) || ((int)strataQuota[Constants.FieldName.MaxResponse] == Constants.Unlimited);
                if (strataIsUnlimited)
                {
                    return false;
                }
                else
                {
                    //TODO - since it turns out Im not using all the values we ought to replace this SP with one that
                    //       is strata specific, we could also have it do the above work to retrieve the quota too
                    //       to save more trips to the db

                    //Query the db for the current response counts by strata
                    spSP_GetResponseStratumCount spSP_GetResponseStratumCount
                        = spSP_GetResponseStratumCount.GetInstanceUsingDefaultSettings();
                    Dictionary<string, int> counts = await spSP_GetResponseStratumCount.GetCountByStrata(dplyId);
                    int maxResponse = (int)strataQuota[Constants.FieldName.MaxResponse];
                    int count = counts.GetValueOrDefault(strata, 0);
                    return count >= maxResponse;
                }
            }
            catch (Exception e)
            {
                throw new InternalException("Failed to check if strata is filled", e);
            }
        }

        public static async Task SetStatus(Guid dlsi, QnnStatusId newStatus, Guid dataEditorId)
        {
            try
            {
                EntityModel qnnDplySampleInfoModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
                DynamicEntity dplySampleInfo 
                    = await DeploymentApplication.GetQnnDplySampleInfoById(dlsi, qnnDplySampleInfoModel);
                if (dplySampleInfo == null) 
                    throw NotFoundException.ForModelName(qnnDplySampleInfoModel.Name, dlsi);

                if (!await DeploymentApplication.CheckEditorsAccess(dplySampleInfo, dataEditorId))
                    throw new PermissionException();

                QnnStatusId currentStatus = QnnStatusId.FromGuid((Guid)dplySampleInfo[Constants.FieldName.Status]);

                if(await IsStatusFlowValid(currentStatus, newStatus))
                {
                    dplySampleInfo[Constants.FieldName.Status] = newStatus.Value;
                    //20260209 - previously this was updating the wrong pair of columns (see issue #263)
                    dplySampleInfo[Constants.FieldName.StatusModifyOn] = DateTime.Now;
                    dplySampleInfo[Constants.FieldName.StatusModifyBy] = dataEditorId;

                    await qnnDplySampleInfoModel.UpdateSingleAsync(dplySampleInfo);
                }
                else
                {
                    throw new InvalidStatusFlowException(currentStatus, newStatus);
                }                    
            }
            catch (Exception e)
            {
                if(_logger.IsEnabled(LogLevel.Debug))
                    _logger.LogDebug(e, nameof(SetStatus) + " - caught unexpected exception for dlsi={0}, status={1}, dataEditorId={2}", dlsi, newStatus, dataEditorId);
                throw;
            }
        }

        public static async Task<bool> IsStatusFlowValid(QnnStatusId currentStatus, QnnStatusId newStatus)
        {
            if (currentStatus.Equals(newStatus))
            {
                return false;
            }
            else if (currentStatus.IsPending && newStatus.IsExempted)
            {   //UI has a special button for this because its a standard flow
                //which is not captured in the flow table by default
                return true;
            }
            else
            {   //For other case (i.e. the status button) verify the flow is allowed
                ImmutableHashSet<QnnStatusId> permittedFlows
                    = (await GetStatusFlows(currentStatus))
                    .Select(sf => QnnStatusId.FromGuid((Guid)sf[Constants.FieldName.ToStatus]))
                    .ToImmutableHashSet();
                return permittedFlows.Contains(newStatus);
            }
        }

        /// <summary>
        /// Fetch all QNN_STATUS_FLOW entities with the specified status as the FromStatus.
        /// Will fetch with join so that the QNN_STATUS information is available in the entities.
        /// If there are none an empty list is returned, never null.
        /// </summary>
        /// <param name="fromStatus"></param>
        public static async Task<List<DynamicEntity>> GetStatusFlows(QnnStatusId fromStatus)
        {
            try
            {
                EntityModel qnnStatusFlowModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS_FLOW, Constants.Level.FetchJoins);
                List<DynamicEntity> flows = await qnnStatusFlowModel.GetAsync(
                    Filter.And.Equal(fromStatus.Value, Constants.FieldName.FromStatus));
                return flows;
            }
            catch(Exception e)
            {
                throw new InternalException($"Failed to get status flows for {fromStatus}", e);
            }
        }

        /// <summary>
        /// Outcome of a call to ResetStatus
        /// </summary>
        public class ResetStatusResult
        {
            public readonly bool IsStatusReset;
            public readonly bool IsResponseCleared;

            public ResetStatusResult(bool isStatusReset, bool isResponseCleared)
            {
                this.IsStatusReset = isStatusReset;
                this.IsResponseCleared = isResponseCleared;
            }
        }

        /// <summary>
        /// Delete specified response (if any) and reset the status to pending (if applicable).
        /// Returns true if the status was reset (e.g. for multi-response it would not be).
        /// Editor assignment to specific sample is checked, but it is caller's responsibility to
        /// check if specified editor has data editor role (if applicable)
        /// </summary>
        public static async Task<ResetStatusResult> ResetStatus(
            Guid qnnDplySampleInfoId, 
            Guid? qnnRespId, 
            Guid dataEditorId)
        {
            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);
            EntityModel qnnRespModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

            bool isClearResponse = (qnnRespId != null);

            try
            {
                //Read the dlsi row from QNN_DPLY_SAMPLE_INFO
                DynamicEntity qnnDplySampleInfo = await DeploymentApplication.GetQnnDplySampleInfoById(qnnDplySampleInfoId, qnnDplySampleInfoModel);
                if (qnnDplySampleInfo == null) 
                    throw NotFoundException.ForModelName(qnnDplySampleInfoModel.Name, qnnDplySampleInfoId);
                Guid dplyId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId];
                Guid listSampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId];

                //Verify this sample is assigned to this data editor 
                if (!await DeploymentApplication.CheckEditorsAccess(qnnDplySampleInfo, dataEditorId))
                    throw new PermissionException($"Editor {dataEditorId} does not have access to dlsi {qnnDplySampleInfoId}");

                using (SharedTransaction transaction = new SharedTransaction())
                {
                    try
                    {
                        //We want to group status update and response delete in same db transaction
                        transaction.BeginTransactionAsync().Wait();

                        bool wereStatusUpdated;
                        bool isMultipleResponse = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsMultipleResponse];
                        bool isAnonymous = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsAnonymous];

                        //Find all responses for this dlsi
                        List<DynamicEntity> responsesForDlsi = await ResponseApplication.GetResponsesForSample(dplyId, listSampleId);
                        int numberOfResponses = responsesForDlsi.Count;
                        if (isClearResponse == false && responsesForDlsi.Any())
                            throw new ArgumentException($"A value for {nameof(qnnRespId)} was specified but no responses related to the specified {qnnDplySampleInfoId} were found", nameof(qnnRespId));

                        if (isClearResponse)
                        {
                            //Verify the specified response to be deleted is valid for this dlsi 
                            DynamicEntity qnnResp = responsesForDlsi.Where(response => qnnRespId.Equals(response[Constants.FieldName.Id])).FirstOrDefault();
                            if (qnnResp == null)
                                throw new ArgumentException($"QNN_RESP {qnnRespId} does not belong to QNN_DPLY_SAMPLE_INFO {qnnDplySampleInfoId}", nameof(qnnRespId));

                            //Delete uploaded files associated with this response
                            foreach (string token in await spSP_GetUploadedFiles.ForResponse(qnnRespId.Value))
                            {
                                await CloverRuntime.ContentProvider.RemoveAsync(token);
                            }

                            //Delete the specified response only
                            await qnnRespModel.DeleteAsync(new List<object>() { qnnRespId });
                        }

                        //For a multiple responses survey we dont reset the status in QNN_DPLY_SAMPLE_INFO back to pending unless
                        //there are no other responses. For normal types of survey then we will always reset the status here.
                        QnnStatusId currentStatus = QnnStatusId.FromGuid((Guid)qnnDplySampleInfo[Constants.FieldName.Status]);
                        bool isResetStatus
                            = !currentStatus.IsPending 
                            && ((!isMultipleResponse && !isAnonymous)
                                || !isClearResponse
                                || numberOfResponses <= 1);
                        if (isResetStatus)
                        {
                            //Update status of the dlsi
                            qnnDplySampleInfo[Constants.FieldName.StatusModifyOn] = DateTime.Now;
                            qnnDplySampleInfo[Constants.FieldName.StatusModifyBy] = dataEditorId;
                            qnnDplySampleInfo[Constants.FieldName.Status] = Constants.Status.PENDING;
                            (var _, long updated) = await qnnDplySampleInfoModel.UpdateAsync(new List<dynamic> { qnnDplySampleInfo });
                            wereStatusUpdated = (updated > 0);
                        }
                        else
                        {
                            wereStatusUpdated = false;
                        }

                        transaction.Commit();

                        return new ResetStatusResult(isResetStatus, isClearResponse);
                    }
                    catch (Exception)
                    {
                        _logger.LogDebug(nameof(ResetStatus) + " - caught unexpected exception - rolling back transaction");
                        await transaction.RollbackAsync().ConfigureAwait(false);
                        throw;
                    }
                } //end using transaction
            }
            catch (Exception e)
            {
                if (_logger.IsEnabled(LogLevel.Debug))
                {
                    _logger.LogDebug(e, nameof(ResetStatus) + " - caught unexpected exception, qnnDplySampleInfoId={0}, qnnRespId={1}, dataEditorId={2}", qnnDplySampleInfoId, qnnRespId, dataEditorId);
                }
                throw new InternalException($"Failed to reset status for dlsi={qnnDplySampleInfoId}, response={qnnRespId}, for dataEditor={dataEditorId}", e);
            }
        }

        /// <summary>
        /// Used by ResetStatus to delete uploaded files
        /// </summary>
        /// <param name="uploadedFilesToken">The object that contain the files token in comma delimited format</param>
        private static async Task xxxxDeleteUploadedFiles(object uploadedFilesToken)
        {
            if (!string.IsNullOrEmpty(uploadedFilesToken.ToString()))
            {
                foreach (string Id in uploadedFilesToken.ToString().Split(",").ToList())
                {
                    if (!string.IsNullOrEmpty(Id))
                    {
                        await CloverRuntime.ContentProvider.RemoveAsync(Id.Trim());
                    }
                }
            }
        }

    } //end of ResponseApplication
}
