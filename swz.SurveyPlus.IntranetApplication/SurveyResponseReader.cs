using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Collections.Immutable;

namespace swz.SurveyPlus.IntranetApplication
{
    public class SurveyResponseReader
    {
        /// <summary>
        /// Used to indicate a failure/error to read the response data.
        /// Values in Reason property should be safe for clientside display. 
        /// </summary>
        public class ReadFailedException : Exception
        {
            /// <summary>
            /// Factory method
            /// </summary>
            public static ReadFailedException InvalidSurvey(Guid dlsi)
                => new ReadFailedException(dlsi, Constants.Message.InvalidSurvey, formIsReadOnly: false); //TODO - can I change readOnly to false here?

            public static ReadFailedException MaxResponse(Guid dlsi)
                => new ReadFailedException(dlsi, Constants.Message.SurveyHasReachedMaximumResponses, formIsReadOnly: true);

            public static ReadFailedException InvalidSurveyForm(Guid dlsi)
                => new ReadFailedException(dlsi, Constants.Message.InvalidSurveyForm, formIsReadOnly: false); //TODO - can I change readOnly to false here?

            public static ReadFailedException InternalError(Guid dlsi, Guid? respId, Guid anonymousId, Guid? sampleId, Exception innerException)
                => new ReadFailedException(dlsi, $"Internal Error dlsi={dlsi}, respId={respId}, anonymousId={anonymousId}, sampleId={sampleId}", innerException);

            ////TODO - editable forms follow the previous logic, but why do we even let the form be editable if response read had an error?
            ///// <summary>
            ///// Factory method
            ///// </summary>
            //public static ReadFailedException Editable(Guid dlsi, string reason) 
            //    => new ReadFailedException(dlsi, reason, false);

            /// <summary>
            /// Factory method
            /// </summary>
            public static ReadFailedException ReadOnly(Guid dlsi, string reason)
                => new ReadFailedException(dlsi, reason, true);

            private static string MsgStr(Guid dlsi, string reason)
                => $"Failed to read survey response data. dlsi={dlsi}, reason={reason ?? "Unknown"}";

            public Guid QnnDplySampleInfoId { get; private set; }

            /// <summary>
            /// Should the form be made read-only as a result of this failure?
            /// </summary>
            public bool IsFormReadOnly { get; private set; }

            public string Reason { get; private set; }

            //Private constructor for internal use only, please use one of the factory methods
            private ReadFailedException(Guid dlsi, string reason, bool formIsReadOnly) : base(MsgStr(dlsi, reason))
            {
                this.QnnDplySampleInfoId = dlsi;
                this.IsFormReadOnly = formIsReadOnly;
                this.Reason = reason;
            }

            private ReadFailedException(Guid dlsi, string message, Exception innerException) : base(message, innerException)
            {
                this.QnnDplySampleInfoId = dlsi;
                this.Reason = "Internal Error at " + DateTime.Now.ToString(Constants.QnnDatetimeFormat);
                this.IsFormReadOnly = true;
            }
        } // end of ReadFailedException

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<SurveyResponseReader> logger;

        public SurveyResponseReader(ILogger<SurveyResponseReader> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<Dictionary<string, object>> ResponseData(
            Guid dplySampleInfoId,
            Guid? qnnRespId,
            Guid anonymousId,
            QNN_SAMPLE sample)
        {
            return await InternalGetRespAns(dplySampleInfoId, qnnRespId, anonymousId, sample);
        }

        //Moved and adapted from the code that was in DataEditController
        //TODO - could merge this into ResponseData method above, no need to preserve old name anymore
        private async Task<Dictionary<string, object>> InternalGetRespAns(
            Guid dplySampleInfoId,
            Guid? specificRespId,
            Guid anonymousId,
            QNN_SAMPLE sample = null)
        {
            try
            {
                bool isTraceEnabled = logger.IsEnabled(LogLevel.Trace);

                if (isTraceEnabled)
                    logger.LogTrace(nameof(InternalGetRespAns) + " - dplySampleInfoId={0}, respId={1}", dplySampleInfoId, specificRespId);

                //check owner. 
                EntityModel dplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);
                Filter byDlsi = Filter.And.Equal(dplySampleInfoId, Constants.FieldName.Id);
                DynamicEntity dplySampleInfo = (await dplySampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
                if (dplySampleInfo == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, dplySampleInfoId);

                bool isAnonymousSurvey = (bool)dplySampleInfo[Constants.FieldName.DplyId + '_' + Constants.FieldName.IsAnonymous];


                ListSampleInfo lsi = await ListSampleInfo.GetByDlsi(dplySampleInfoId);
                if (lsi == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.vSP_ListSampleInfo, dplySampleInfoId);

                //Determine if we are serving an intranet data editor or an internet respondent
                //If there is a logged-in intranet user then we assume the former (login for respondents
                //is meant to clear any intranet login as part of the process)
                Guid? userId = (await CloverRuntime.Security.GetCurrentUserAsync())?.Id;
                SurveyUserType serving = (userId == null) || (userId.HasValue == false)
                    ? SurveyUserType.Respondent
                    : SurveyUserType.DataEditor;

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - ListSampleInfo : Id={0}, Status={1}, IsAnonymousSurvey={2}, IsMultipleResponse={3}, DueDate={4}, DaysUpdate={5}, ListSampleId={6}, QnnId={7}, ListId={8}, DplyId={9} - Other info : dlsi={10}, sample.Id={11}, userId={12}, serving={13}",
                        lsi.Id,
                        lsi.Status,
                        lsi.IsAnonymousSurvey,
                        lsi.IsMultipleResponse,
                        lsi.DueDate,
                        lsi.DaysUpdate,
                        lsi.ListSampleId,//don't want to log UID as may be sensitive
                        lsi.QnnId,
                        lsi.ListId,
                        lsi.DplyId,
                        dplySampleInfoId,
                        sample?.Id,
                        userId,
                        serving);
                }

                //Data consistency check (we don't expect this to fail)
                if ((serving == SurveyUserType.Respondent && sample == null)
                    || (serving == SurveyUserType.DataEditor && ((userId == null) || (userId.HasValue == false))))
                {
                    bool hasUid = !string.IsNullOrEmpty(sample?.UID);
                    logger.LogError(nameof(InternalGetRespAns) + " - invalid state: userId={0}, sample={1}, sample.Id={2}, hasUid={3}",
                        userId, sample, sample?.Id, hasUid);

                    throw ReadFailedException.ReadOnly(dplySampleInfoId, "Internal Error (User Type)");
                }

                //Check survey access for respondent, DataEditor will have full access
                if (serving == SurveyUserType.Respondent)
                {
                    ListSampleInfo.AccessResult surveyValidity = lsi.CheckSurveyAccess();
                    if (!surveyValidity.IsValid)
                    {
                        logger.LogError(nameof(InternalGetRespAns) + " - survey not valid: ErrorMsg={0}", surveyValidity.ErrorMsg);
                        throw ReadFailedException.InvalidSurvey(dplySampleInfoId);
                    }
                }

                //Check access permission for respondent or data editor
                switch (serving)
                {
                    case SurveyUserType.DataEditor:
                        if (!await DeploymentApplication.CheckEditorsAccess(dplySampleInfo))
                        {
                            throw new PermissionException($"Intranet User with id={userId} lacks permission for response with dlsi={lsi.Id}");
                        }
                        break;

                    case SurveyUserType.Respondent:
                        if (sample == null || sample.Id != lsi.SampleId)
                        {
                            throw new PermissionException($"Internet Respondent with sample id={sample?.Id} lacks permission for response with dlsi={lsi.Id}");
                        }
                        break;

                    default:
                        throw new NotImplementedException($"Unknown {nameof(SurveyUserType)} ({serving}");
                }

                (string msg, bool latestFormFieldsUpdatedForQnn) = await FormPropertiesApplication.LatestFormFieldsUpdatedForQnn(lsi.QnnId);
                if (!latestFormFieldsUpdatedForQnn)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(InternalGetRespAns) + " - LatestFormFieldsUpdatedForQnn returned false, qnnId={0}, msg={1}", lsi.QnnId, msg);
                    }

                    throw ReadFailedException.InvalidSurveyForm(dplySampleInfoId);
                }

                Order orderByNumberIdAsc = Order.StartAsc(Constants.FieldName.NumberId);
                bool isFormHasField = await IsFormHasField(lsi.QnnId, orderByNumberIdAsc);
                if (!isFormHasField)
                    throw ReadFailedException.InvalidSurvey(dplySampleInfoId);

                bool isServingRespondent = (serving == SurveyUserType.Respondent);
                bool respondentIsAnonymousSample
                    = ResponseApplication.IsRespondentIsAnonymousSample(isServingRespondent, anonymousId, lsi.IsAnonymousSurvey, lsi.UID);

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - anonymousId={0}, isServingRespondent={1}, respondentIsAnonymousSample={2}",
                        anonymousId, isServingRespondent, respondentIsAnonymousSample);
                }

                EntityModel qnnRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.DeepFetchJoins);

                //This method processing is expected respId could be null value (Means no response before)
                DynamicEntity qnnResp = await GetQnnResp(
                    qnnRespModel: qnnRespModel,
                    dplyId: lsi.DplyId,
                    listSampleId: lsi.ListSampleId,
                    qnnId: lsi.QnnId,
                    respId: specificRespId,
                    respondentIsAnonymousSample: respondentIsAnonymousSample,
                    anonymousId: Guid.Empty.Equals(anonymousId) ? null : anonymousId.ToString(),
                    orderByNumberIdAsc: orderByNumberIdAsc);
                bool hasResponse = (qnnResp != null);
                //n.b. at this point we might have found a respone by listSampleId but specificRespId will remain null

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - qnnResp Id={0}", (hasResponse ? qnnResp[Constants.FieldName.Id] : "NONE"));
                }

                QNN_DPLY qnnDply = await QNN_DPLY.SelectByKey(lsi.DplyId);
                if (qnnDply == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, lsi.DplyId);

                DateTime? respDateEnd = hasResponse ? (DateTime?)qnnResp[Constants.FieldName.DateComplete] : null;
                ResponseApplication.FormEditable editability = ResponseApplication.IsFormEditable(serving, lsi, respDateEnd);
                bool formIsReadOnly = (editability != ResponseApplication.FormEditable.Yes);

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - editability={0}, formIsReadOnly={1}", editability, formIsReadOnly);
                }

                //Fetch values for list sample properties if we are exposing these to the form
                bool isExposeListProperties = qnnDply.IsExposeListProperties;
                Dictionary<string, string> exposedListSampleProperties = isExposeListProperties
                    ? await GetListSampleProperties(lsi.ListSampleId)
                    : null;

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - isExposeListProperties={0}, exposedListSampleProperties?.Count={1}",
                        isExposeListProperties, exposedListSampleProperties?.Count);
                }

                //Fetch (optional) data for the data-on-data validation
                bool isDataToDataValidationEnabled = qnnDply.IsDataToData;
                spSP_GetRespAnsRows spSP_GetRespAnsRows
                    = (hasResponse || isDataToDataValidationEnabled)
                    ? await spSP_GetRespAnsRows.GetInstanceUsingAppSettingsAsync()
                    : null; //save doing the settings lookup if we aren't going to use the procedure
                Dictionary<string, object> validationData = null;
                if (isDataToDataValidationEnabled)
                {
                    Filter byDplyIdAndSampleId = Filter.And
                        .Equal(lsi.DplyId, Constants.FieldName.DplyId)
                        .Equal(lsi.SampleId, Constants.FieldName.SampleId);
                    EntityModel qnnDplyDatasetModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_DATASET, Constants.Level.NoJoins);
                    DynamicEntity qnnDplyDataset = (await qnnDplyDatasetModel.GetAsync(byDplyIdAndSampleId)).FirstOrDefault();
                    bool foundDataset = (qnnDplyDataset != null);
                    if (foundDataset)
                    {
                        string validationDataAsJson = (string)qnnDplyDataset[Constants.FieldName.Data];
                        validationData = JsonConvert.DeserializeObject<Dictionary<string, object>>(validationDataAsJson);
                    }

                    if (!foundDataset)
                    {
                        //ValidationDplyId identifies another deployment (for example the previous year's survey) whence to
                        //fetch answers that can be used in data-on-data validation by the form's validation conditions.
                        //We'll refer to this as the validation souurce deployment in the comments below
                        DynamicEntity vQnnDply = null;
                        Guid? vDplyId = qnnDply.ValidationDplyId;
                        if (vDplyId != null)
                        {
                            Filter byId = Filter.And.Equal(vDplyId, Constants.FieldName.Id);
                            vQnnDply = (await QNN_DPLY.Model.GetAsync(byId)).FirstOrDefault();
                        }
                        if (vQnnDply != null)
                        {
                            Paging pageOnlyFirstRow = Paging.Create(0, 1);
                            EntityModel qnnListSampleModel
                                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.NoJoins);

                            Guid vQnnId = (Guid)vQnnDply[Constants.FieldName.QnnId];

                            //QNN_LIST_SAMPLE (listSampleId) relates a sample to a QNN_LIST but the deployment selected 
                            //for the validation dataset may be using a different list than what the current deployment 
                            //is using, so we need to find the QNN_LIST_SAMPLE id for the current sample (respondent) in
                            //the list the validation deployment is using. We will use that one to find the
                            //validation source response. 
                            Guid vQnnListId = (Guid)vQnnDply[Constants.FieldName.ListId];

                            Guid? vQnnListSampleId; //Their listSampleId in the validation source deployment,n.b. it might not exist
                            bool usingSameList = lsi.ListId.Equals(vQnnListId);
                            if (usingSameList)
                            {
                                //Optimisation if same list was also used for validation source deployment
                                vQnnListSampleId = lsi.ListSampleId;
                            }
                            else
                            {
                                //Find their membership in the validation source deployment's list
                                Filter bySampleAndList = Filter.And
                                    .Equal(lsi.SampleId, Constants.FieldName.SampleId)
                                    .Equal(vQnnListId, Constants.FieldName.ListId);
                                DynamicEntity vQnnListSample
                                    = (await qnnListSampleModel.GetAsync(bySampleAndList, orderByNumberIdAsc, pageOnlyFirstRow))
                                    .FirstOrDefault();
                                vQnnListSampleId = (vQnnListSample == null) ? null : (Guid?)vQnnListSample[Constants.FieldName.Id];
                            }

                            bool sampleWasInVSourceDply = (vQnnListSampleId != null);
                            if (sampleWasInVSourceDply)
                            {
                                //Find their response to the 'previous' survey
                                Filter byDplyIdAndListSampleIdAndQnnId = Filter.And
                                    .Equal(vDplyId, Constants.FieldName.DplyId)
                                    .Equal(vQnnListSampleId, Constants.FieldName.ListSampleId)
                                    .Equal(vQnnId, Constants.FieldName.QnnId);
                                DynamicEntity vQnnResp =
                                    (await qnnRespModel.GetAsync(byDplyIdAndListSampleIdAndQnnId, orderByNumberIdAsc, pageOnlyFirstRow))
                                    .FirstOrDefault(); //We only support using the first response here
                                if (vQnnResp != null)
                                {
                                    //And with that response's id, we can pull their 'previous' answers for the validation object
                                    Guid vQnnRespId = (Guid)vQnnResp[Constants.FieldName.Id];
                                    validationData
                                        = (await spSP_GetRespAnsRows.ExecuteAsync(
                                            vQnnRespId,
                                            spSP_GetRespAnsRows.Include.ResponseDataOnly))
                                            .Answers;
                                    if (validationData == null)
                                    {   //Don't expect this if there is a QNN_RESP
                                        logger.LogWarning(nameof(InternalGetRespAns) + " - no response answer data found in deployment {0} for existing response {0} when retrieving data for the validation object", vDplyId, vQnnRespId);
                                    }

                                }
                            } //end if vQnnListSampleId isnt null or empty
                        } //end if vQnnDply != null
                    } // end if !foundDataset
                } //end if isDataToDataValidationEnabled

                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - isDataToDataValidationEnabled={0}, validationData?.Count={1}",
                        isDataToDataValidationEnabled, validationData?.Count);
                }

                SurveyResponseVersionToken version = SurveyResponseVersionToken.FromQnnResp(qnnResp);
                
                if (qnnResp != null)
                {
                    Guid currentRespId = (Guid)qnnResp[Constants.FieldName.Id];
                    bool isComplete = qnnResp[Constants.FieldName.DateComplete] != null;
                    //Get answers, along with LastSavedPage, RespId, NumberId
                    spSP_GetRespAnsRows.Result result 
                        = await spSP_GetRespAnsRows.ExecuteAsync( currentRespId,                        spSP_GetRespAnsRows.Include.ResponseDataAndMetainfo);
                    if (result == null)
                    {
                        //Put here for now to fail with a better message on this condition
                        //TODO - reconsider this in light of the below comments
                        throw new InternalException($"Found no answer data for response {currentRespId}");
                    }
                    Dictionary<string, object> item = result.Answers;
                    if (item != null)  //<---- TODO, review this condition (see comments below)
                    {
                        string strata = GetStrata(qnnDply, item);
                        bool isStrataFilled = await ResponseApplication.IsStrataFilled(lsi.DplyId, strata);
                        SetSurveyResponseProperties(
                            item: item,
                            version: version,
                            success: true,
                            isComplete: isComplete,
                            isCleared: lsi.Status.IsCleared,
                            isStrataFilled: isStrataFilled,
                            formIsReadOnly: formIsReadOnly,
                            exposedListSampleProperties: exposedListSampleProperties,
                            validationData: validationData,
                            prePopulatedAliases: result.PrePopulatedAliases);
                        return item;
                    }

                    //TODO - the situation for this line needs to be reviewed (got qnn_resp but no qnn_resp_ans)
                    //Old comment: "if item is null it means they didn't start to respond yet, so we continue with logic below"
                    //but does this make sense? Could the old spSP_GetRespAns return null?
                    //certainly spSP_GetRespAns does not, if there aren't any rows it would return dictionary with just the
                    //LastSavedPage, RespId, NumberId
                    // NOTE20241219 - spSP_GetRespAnsRows.ExecuteAsync WILL explicitly return null if no ans rows
                    //As a general thing, we consider a response with no rows in qnn_resp_ans to be an invalid state, altough
                    //it can occur in some cases (eg, failed writing of answers). 
                    //I think the main implication is that if you have the invalid state that the qnn_resp does exist but the
                    //answers do not and this is a recurring survey, then I think it would skip the on-demand pre-population.

                }
                else 
                {   //reading for a new response (no qnn_resp yet)
                    if (!lsi.IsMaxResponseUnlimited)
                    {
                        //20230224 - Changing logic to only consider COMPLETED responses for Max Responses quota (previously considered all)
                        int currentCompletedResponseCount
                            = await ResponseApplication.GetOverallSurveyResponseCount(lsi.DplyId, ResponseApplication.SurveyResponseCountType.Completed);
                        if (lsi.IsWithinMaxResponseCount(currentCompletedResponseCount) == false)
                        {
                            throw ReadFailedException.MaxResponse(dplySampleInfoId);
                        }
                    }
                    //If don't have response yet and max not reached, we'll continue with logic below
                }

                //If they haven't responded yet (or the response was reset by data editor) then there is no qnnResp entity.
                //it is also possible to have respid without responses when responses are cascade deleted when generating the online form fields;
                //check InsertQnnOnlineFormFieldsTrigger trigger

                //If this is a recurrence of a deployment and they haven't responded yet, then it may be we need to
                //perform a just-in-time Pre-Populate for the response. (Unlike a regular manual pre-populate for the
                //recurring deployment we do it when fetching the answer). (TODO - we could look at standardising how
                //we do this, JIT pre-pop might be a more efficient and simpler mechanism for all pre-pop?)
                bool deploymentIsRecurrence = (qnnDply.RecurrenceOfDplyId != null);
                if (deploymentIsRecurrence)
                {
                    bool isRecurrencePrePopulateEnable
                        = (await QNN_DPLY.SelectByKey((Guid)qnnDply.RecurrenceOfDplyId)).IsRecurrencePrePopulateEnabled ?? false;
                    if (isRecurrencePrePopulateEnable)
                    {
                        //Get the previous recurrence of the deployment (n.b. this is not the same thing as RecurrenceOfDplyId
                        //except for the first recurrence because all the recurences will have the original one as their parent)
                        QNN_DPLY qnnDplyPrevious = await QNN_DPLY.GetPreviousRecurrenceByDply(qnnDply);
                        if (qnnDplyPrevious != null)
                        {
                            //And we will include values from this sample's response to that one if it exists to pre-populate here
                            //n.b. stored procedure makes use of QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD to see which fields to include
                            QNN_RESP qnnRespPrevious = await QNN_RESP.GetByDplyIdQnnIdListSampleId(qnnDplyPrevious.Id, lsi.QnnId, lsi.ListSampleId);

                            if (isTraceEnabled)
                            {
                                logger.LogTrace(nameof(InternalGetRespAns) + " pre-populate reccuring deployment - qnnRespPrevious={0}", qnnRespPrevious?.Id);
                            }

                            bool foundSourceResponseForPrePopulate = (qnnRespPrevious != null);
                            if(foundSourceResponseForPrePopulate)
                            {
                                //Gets data for pre-population from this respondent's response to another deployment
                                //which we call the "previous" response as typically its a response to the previous run
                                //of this sort of survey - although not necessarily so.
                                Dictionary<string, object> prePopulatedItem
                                    = await spSP_GetRecurrencePreviousRespAns.GetRecurrencePreviousRespAns(
                                        previousDplyId: qnnDplyPrevious.Id,
                                        qnnId: lsi.QnnId,
                                        previousRespId: qnnRespPrevious.Id);

                                string strata = GetStrata(qnnDply, prePopulatedItem); //strata may have been pre-populated
                                bool isStrataFilled = await ResponseApplication.IsStrataFilled(lsi.DplyId, strata);

                                //n.b this is used where there was no qnn_resp yet and its is pre-populating
                                //(existing resp has its return somewhere above and non existing with no pre-pop is somewhere below)
                                //So we consider that any value returned by GetRecurrencePreviousRespAns is for a pre-pop field
                                //and put those in the pre-pop list.
                                //(GetRecurrencePreviousRespAns does check QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD)
                                ISet<string> prePopulatedFields = prePopulatedItem
                                    .Where(kvp => !string.IsNullOrEmpty(kvp.Value.ToString()))
                                    .Select(kvp => kvp.Key)
                                    .ToImmutableHashSet();

                                SetSurveyResponseProperties(
                                    item: prePopulatedItem,
                                    version: version,
                                    success: true,
                                    isComplete: false,
                                    isCleared: lsi.Status.IsCleared,
                                    isStrataFilled: isStrataFilled,
                                    formIsReadOnly: formIsReadOnly,
                                    exposedListSampleProperties: exposedListSampleProperties,
                                    validationData: validationData,
                                    prePopulatedAliases: prePopulatedFields);
                                return prePopulatedItem;
                            }
                            else
                            {
                                //If no 'previous' response to supply pre-pop data then we will
                                //continue on with the logic below as though it was not a pre-pop response
                            }
                        } //end if no 'previous' response
                    } //end if isRecurrencePrePopulateEnable
                } //end if deploymentIsRecurrence

                //We would reach here if they never responded before and there were no special things like pre-pop
                //or if it was a pre-pop but there was no previous response to pre-pop from
                if (isTraceEnabled)
                {
                    logger.LogTrace(nameof(InternalGetRespAns) + " - No existing response data to return, returning basic response");
                }

                //n.b this is used where there was no qnn_resp yet and its not prepopulating
                //(existing resp or non-existing resp with pre-opulate has its return somewhere above)
                Dictionary<string, object> newItem = new Dictionary<string, object>();
                SetSurveyResponseProperties(
                    item: newItem,
                    version: version,
                    success: true,
                    isComplete: false,
                    isCleared: lsi.Status.IsCleared,
                    isStrataFilled: false,
                    formIsReadOnly: formIsReadOnly,
                    exposedListSampleProperties: exposedListSampleProperties,
                    validationData: validationData,
                    prePopulatedAliases: null); //new HashSet<string>()
                return newItem;
            }
            catch (ReadFailedException)
            {
                throw;
            }
            catch (Exception e)
            {
                //Log at debug level here, error level logging is caller's responsibility
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(InternalGetRespAns) + " - Caught unexpected exception: dplySampleInfoId={0}, respId={1}, anonymousId={2}, sample?.Id={3}", dplySampleInfoId, specificRespId, anonymousId, sample?.Id);
                }

                throw ReadFailedException.InternalError(dplySampleInfoId, specificRespId, anonymousId, sample?.Id, e);
            }
        }

        /// <summary>
        /// Add values from the list sample properties dictionary to the response data. Note that we DO NOT add for any keys that
        /// are already present - i.e. an Alias of the same name in the retrieved answers will override the list sample property 
        /// (note that on first read that alias won't be there so the LSP would set the initial value).
        /// </summary>
        /// <param name="item">The response data to add to</param>
        /// <param name="listSampleProperties">The values for the custom list sample properties for this sample. May be null if there are none</param>
        /// <exception cref="ArgumentNullException"></exception>
        private void AddListSampleProperties(Dictionary<string, object> item, Dictionary<string, string> listSampleProperties)
        {
            if (item == null) throw new ArgumentNullException(nameof(item));

            if (listSampleProperties != null)
            {
                foreach (KeyValuePair<string, string> listSampleProperty in listSampleProperties)
                {
                    if (!item.ContainsKey(listSampleProperty.Key))
                    {
                        item.Add(listSampleProperty.Key, listSampleProperty.Value);
                    }
                }
            }
        }

        private async Task<bool> IsFormHasField(Guid qnnId, Order orderByNumberIdAsc)
        {
            bool result;
            EntityModel qnnFieldModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);
            Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
            List<DynamicEntity> onlineFieldEntities = await qnnFieldModel.GetAsync(byQnnId, orderByNumberIdAsc, paging: null);
            result = onlineFieldEntities.Any();
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="qnnRespModel"></param>
        /// <param name="dplyId"></param>
        /// <param name="listSampleId"></param>
        /// <param name="qnnId"></param>
        /// <param name="respId">The Id in QNN_RESP, you must explicitly pass Guid.EMPTY here if there is none</param>
        /// <param name="respondentIsAnonymousSample"></param>
        /// <param name="anonymousId"></param>
        /// <param name="orderByNumberIdAsc"></param>
        /// <returns></returns>
        private async Task<DynamicEntity> GetQnnResp(
            EntityModel qnnRespModel,
            Guid dplyId,
            Guid listSampleId,
            Guid qnnId,
            Guid? respId,
            bool respondentIsAnonymousSample,
            string anonymousId,
            Order orderByNumberIdAsc)
        {
            DynamicEntity result = null;
            Filter filterQnnResp = Filter.And
                    .Equal(dplyId, Constants.FieldName.DplyId)
                    .Equal(listSampleId, Constants.FieldName.ListSampleId)
                    .Equal(qnnId, Constants.FieldName.QnnId);
            if (respId != null)
            {
                filterQnnResp = filterQnnResp.Merge(Filter.And.Equal(respId.Value, Constants.FieldName.Id));
            }

            if (respondentIsAnonymousSample)
            {
                //We recorded an anonymous id in the QNN_RESP and this is in a cookie on anonymous respondent's
                //browser. If that cookie is present then we use it to find their previous anonympus response
                //again.
                filterQnnResp = filterQnnResp.Merge(Filter.And.Equal(anonymousId, Constants.FieldName.AnonymousId));
            }

            //take only 1 record for anonymous/multiple survey to prevent take too much records
            Paging takeOneRecord = Paging.Create(skip: 0, take: 1);

            result = (await qnnRespModel.GetAsync(filterQnnResp, orderByNumberIdAsc, takeOneRecord)).FirstOrDefault();

            return result;
        }

        private async Task<Dictionary<string, string>> GetListSampleProperties(Guid listSampleId)
        {
            EntityModel qnnListSamplePropModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE_PROP, Constants.Level.FetchJoins);
            Filter byListSampleId = Filter.And.Equal(listSampleId, Constants.FieldName.ListSampleId);
            var listSampleProperties
                = (await qnnListSamplePropModel.GetAsync(byListSampleId))
                    .ToDictionary(
                        p => (string)p[Constants.FieldName.ListPropId + '_' + Constants.FieldName.Alias],
                        p => (string)p[Constants.FieldName.PropValue]);
            return listSampleProperties;
        }

        private string GetStrata(QNN_DPLY qnnDply, Dictionary<string, object> answers)
        {
            bool isStrataEnabled = !string.IsNullOrEmpty(qnnDply.StrataSource);
            return isStrataEnabled
                ? (string)answers.GetValueOrDefault(qnnDply.StrataSource, "")
                : null;
        }

        /// <summary>
        /// Writes the common survey response properties to the dictionary of survey response answers.
        /// (The item arg will be mutated)
        /// </summary>
        private void SetSurveyResponseProperties(
            Dictionary<string,object> item,
            SurveyResponseVersionToken version,
            bool success,
            bool isComplete,
            bool isCleared,
            bool isStrataFilled,
            bool formIsReadOnly,
            Dictionary<string, string> exposedListSampleProperties,
            Dictionary<string,object> validationData,
            ISet<string> prePopulatedAliases)
        {
            if (version == null) throw new ArgumentNullException(nameof(version));

            item[Constants.SurveyResponseProperties.PrePopulatedFields] = prePopulatedAliases
                ?? new HashSet<string>(Constants.Comparers.AliasCaseInsensitive);
            item[Constants.SurveyResponseProperties.Validation] = validationData
                ??new Dictionary<string, object>();
            item[Constants.SurveyResponseProperties.Success] = success;
            item[Constants.SurveyResponseProperties.SurveyResponseVersion] = version.ToString();
            item[Constants.SurveyResponseProperties.IsStrataFilled] = isStrataFilled;
            item[Constants.SurveyResponseProperties.IsComplete] = isComplete;
            item[Constants.SurveyResponseProperties.IsCleared] = isCleared;
            item[Constants.SurveyResponseProperties.FormIsReadOnly] = formIsReadOnly;

            AddListSampleProperties(item, exposedListSampleProperties);
        }
    }
}
