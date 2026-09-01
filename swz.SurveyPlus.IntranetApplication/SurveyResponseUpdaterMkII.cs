using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Instances are not threadsafe, do not share across concurrent requests
    /// </summary>
    public class SurveyResponseUpdaterMkII
    {
        private class SurveyResponseUpdateException : InternalException
        {
            public Result.Outcome OutcomeType { get; private set; }

            public SurveyResponseUpdateException(Result.Outcome outcomeType, string message) : base(message)
            {
                this.OutcomeType = outcomeType;
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        private class InvalidVersionException : SurveyResponseUpdateException
        {
            public SurveyResponseVersionToken VersionUpdating { get; private set; }
            public SurveyResponseVersionToken CurrentVersion { get; private set; }

            public InvalidVersionException(SurveyResponseVersionToken versionUpdating, SurveyResponseVersionToken currentVersion) 
                : base(Result.Outcome.ConcurrentResponseModification,  $"Update is for version {versionUpdating}, but current version is {currentVersion}")
            {
                this.VersionUpdating = versionUpdating;
                this.CurrentVersion = currentVersion;
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        private class OverallQuotaReachedException : SurveyResponseUpdateException
        {
            public int MaxResponse { get; private set; }
            public int Count { get; private set; }

            public OverallQuotaReachedException(int maxResponse, int count)
                : base(Result.Outcome.MaxResponseFilled, $"Survey reached its max responses (max={maxResponse}, count={count}")
            {
                this.MaxResponse = maxResponse;
                this.Count = count;
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        private class StratumQuotaReachedException : SurveyResponseUpdateException
        {
            public StratumQuotaReachedException()
                : base(Result.Outcome.StrataQuotaFilled, "Strata quota filled") { }
        }

        // // // // // // // // // // // // // // // // // // // //

        private class InvalidSurveyException : SurveyResponseUpdateException
        {
            public InvalidSurveyException(string message)
                : base(Result.Outcome.InvalidSurvey, message) { }
        }

        // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Thrown if the legacy timestamp check failed 
        /// (this check is likely made redundant by the newer version check - see InvalidVersionException).
        /// </summary>
        private class LegacyTimestampCheckFailedException : SurveyResponseUpdateException
        {
            public DateTime TimestampFromClient { get; private set; }
            public DateTime UpdatedDate { get; private set; }
            public DateTime? DateComplete { get; private set; }

            public LegacyTimestampCheckFailedException(DateTime timestampFromClient, DateTime updatedDate, DateTime? dateComplete) : base(Result.Outcome.Success, $"Timestamp check failed, TimestampFromClient={timestampFromClient.ToString(Constants.DatetimeFull8601Format)}, updatedDate={updatedDate.ToString(Constants.DatetimeFull8601Format)}, dateComplete={dateComplete?.ToString(Constants.DatetimeFull8601Format)??"null"}")
            {
                this.TimestampFromClient = timestampFromClient;
                this.UpdatedDate = updatedDate;
                this.DateComplete = dateComplete;
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        private class SurveyNotEditableException : SurveyResponseUpdateException
        {
            public static SurveyNotEditableException Because(ResponseApplication.FormEditable reason)
            {
                switch (reason)
                {
                    case ResponseApplication.FormEditable.Yes:
                        throw new ArgumentException($"Value '${reason.ToString()}' is not applicable here", nameof(reason));

                    case ResponseApplication.FormEditable.NoBecauseCleared:
                        return new SurveyNotEditableException(Result.Outcome.AlreadyCleared, reason);

                    case ResponseApplication.FormEditable.NoBecauseClosed:
                        return new SurveyNotEditableException(Result.Outcome.SurveyIsClosed, reason);

                    case ResponseApplication.FormEditable.NoBecauseAlreadyResponded:
                        return new SurveyNotEditableException(Result.Outcome.AlreadyResponded, reason);

                    default:
                        throw new NotImplementedException($"Unimplemented: {reason}");
                }
            }

            public ResponseApplication.FormEditable Reason { get; private set; }

            private SurveyNotEditableException(Result.Outcome outcomeType, ResponseApplication.FormEditable reason)
                : base(outcomeType, "The response is not in an editable state")
            {
                this.Reason = reason;
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Read-only object that wraps up the relevant information about the request to save, update, submit
        /// a survey response that is known before the update process begins. This includes things like the Id of the 
        /// QNN_DPLY_SAMPLE_INFO, the answer data to save, the type of request and so on.
        /// </summary>
        public class SaveRequest
        {
            /// <summary>
            /// The type of action to take when updating. This indicates to the updater what changes it should 
            /// make to status, whether to set a completed date, and so forth
            /// </summary>
            public enum RequestedActionType
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

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            //NOTE: this object is intended to be immutable. Do not add public setters.      //
            //      Exercise caution around the mutability of property and collection types  //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// A timestamp value sent by the client. This is from the client's machine at the time
            /// the request is being sent. It is used for the legacy timestamp check. Since it is
            /// from the client clock it should not be considered authoritative.
            /// </summary>
            public readonly DateTime ClientTimestamp;

            /// <summary>
            /// Indicates if this is a request to save or to (save and) submit the survey response.
            /// </summary>
            public readonly RequestedActionType RequestedAction;

            /// <summary>
            /// Indicates the request is with the intent to complete the survey 
            /// i.e. user clicked the 'submit' button. Value is based on the Action.
            /// Whether status will actually go to submitted depends on other logic
            /// such as whether survey allows multiple responses, resubmission policy, etc...
            /// </summary>
            /// 
            public bool IsRequestingSubmit { get => RequestedActionType.Submit == RequestedAction; }

            /// <summary>
            /// Will be true if the request originated from the auto-save mechanism
            /// OR if it orginated from clicking Next, which also counts as an auto-save!
            /// (Will be false for clicks on Save though)
            /// </summary>
            public readonly bool IsAutoSave;

            /// <summary>
            /// Value of the AnonymousId cookie sent by a respondent's browser. (Not used for data editor,
            /// for anonymous surveys this is used to locate the previous answer from this respondent (as they are
            /// all logged in as swzanonymous))
            /// </summary>
            public readonly Guid? AnonymousId;

            /// <summary>
            /// The "DLSI", an Id that identifies a QNN_DPLY_SAMPLE_INFO (and also rows in some related views) which
            /// records information about a samples participation in a survey.
            /// </summary>
            public readonly Guid DplySampleInfoId;

            /// <summary>
            /// IP Address recorded for the respondent
            /// (note that invalid values >45 length are silently treated as null)
            /// </summary>
            public readonly string IpAddress;

            /// <summary>
            /// The Id in DwSecurityUser of the Data Editor who is sending the request. This will be null for a
            /// respondent initiated request.
            /// </summary>
            public readonly Guid? DataEditorId; //will be null if got RespondentId

            /// <summary>
            /// The Id in QNN_SAMPLE of the repondent sending the request. This will be null for a
            /// data editor inititated request (its identifying the initiator of the request, of course a
            /// response always has an associated sample, but that is already identified via the information
            /// in QNN_DPLY_SAMPLE_INFO and related tables).
            /// </summary>
            public readonly Guid? RespondentSampleId; //will be null if got DataEditorId

            /// <summary>
            /// When the client provides a specific respId it is available from this property, but note
            /// that client might not provide a respId even when there is an existing resp.
            /// </summary>
            public readonly Guid? ProvidedRespId; //updater code must not assume this is set

            /// <summary>
            /// Indicates whether this request is for a data editor or a respondent (i.e. what type of user
            /// initiated the request)
            /// </summary>
            public readonly SurveyUserType PersonUpdatingIs;

            /// <summary>
            /// Alias of the page the user is on now (value comes from client side)
            /// </summary>
            public string LastSavedPage { get => (string)GetDataValue(Constants.SurveyResponseProperties.LastSavedPage); }

            /// <summary>
            /// Survey version token of the response the user was editing (this is used to check that the response wasn't
            /// already saved and updated after they started editing it in their UI - e.g. by another tab or data editor etc)
            /// </summary>
            public readonly SurveyResponseVersionToken VersionUpdating;

            // internal variables below...

            /// <summary>
            /// Submitted response data (answers and various flags etc)
            /// </summary>
            private readonly ImmutableDictionary<string, object> data;
            
            /// <summary>
            /// Alias of the fields that are reported as being prePopulated by the front-end
            /// </summary>
            private readonly ImmutableHashSet<string> prePopulatedFields;

            public SaveRequest(
                DateTime clientTimestamp,
                RequestedActionType action,
                Guid dplySampleInfoId,
                Guid? providedRespId,
                Guid? forDataEditorId,
                Guid? forRespondentId,
                Guid anonymousId,
                string dataAsJson,
                bool isAutosave, 
                string ipAddress)
            {
                if (string.IsNullOrWhiteSpace(dataAsJson)) throw new ArgumentException(nameof(dataAsJson));

                if (isAutosave && action == SaveRequest.RequestedActionType.Submit)
                {
                    throw new ArgumentException($"{nameof(RequestedActionType.Submit)} action is not supported for autosave");
                }

                ClientTimestamp = clientTimestamp;
                RequestedAction = action;
                DplySampleInfoId = dplySampleInfoId;
                ProvidedRespId = providedRespId;

                SurveyUserType userType;
                if (forDataEditorId != null)
                {
                    if (forRespondentId != null) throw new ArgumentException("Expected null", nameof(forRespondentId));

                    userType = SurveyUserType.DataEditor;
                    DataEditorId = forDataEditorId;
                    AnonymousId = null; //Ignore it for data editors 
                }
                else if (forRespondentId != null)
                {
                    if (forDataEditorId != null) throw new ArgumentException("Expected null", nameof(forDataEditorId));
                    if (Guid.Empty.Equals(anonymousId)) throw new ArgumentException("Non-empty value required (check cookie is being passed correctly)", nameof(anonymousId));

                    userType = SurveyUserType.Respondent;
                    RespondentSampleId = forRespondentId;
                    AnonymousId = anonymousId; 
                }
                else
                {
                    throw new ArgumentException($"{nameof(SaveRequest)} must be either for a data editor or for a respondent");
                }
                PersonUpdatingIs = userType;

                data = DeserializeSurveyData(dataAsJson);
                JArray ppf = (JArray)GetDataValue(Constants.SurveyResponseProperties.PrePopulatedFields);
                //TODO - given that front end is one of the places alias are case-sensitive should we not use the
                //       case-sensitive comparer here? (the insensitive one is used in things like csv import)
                //       (for the moment is still AliasCaseInsensitive to copy old behaviour)
                prePopulatedFields = ((ppf != null)
                    ? new HashSet<string>(ppf.ToObject<string[]>(), Constants.Comparers.AliasCaseInsensitive)
                    : new HashSet<string>(Constants.Comparers.AliasCaseInsensitive))
                    .ToImmutableHashSet();
                VersionUpdating = SurveyResponseVersionToken.FromString((string)GetDataValue(Constants.SurveyResponseProperties.SurveyResponseVersion));
                IsAutoSave = isAutosave;

                //TODO - handle this better please...
                //below is q&d hack (I am (still) in a rush now) to avoid trying to insert/update
                //invalid length ipaddress to db - in theory we don't expect any,
                //in practice ... tbd
                if (ipAddress != null && Encoding.ASCII.GetByteCount(ipAddress) > 45)
                {
                    //logger.LogWarning(nameof(IpAddress) + " - ignoring value longer than 45, instance={0}, value={0}", this.GetHashCode(), value);
                    IpAddress = null;
                }
                else
                {
                    IpAddress = ipAddress;
                }   
            }

            public override string ToString()
            {
                //n.b. have excluded IpAddress in case it is considered sensitive
                return $"[{nameof(SaveRequest)} - {nameof(ClientTimestamp)}={ClientTimestamp.ToString(Constants.DatetimeFull8601Format)}, {nameof(RequestedAction)}={RequestedAction.ToString()}, {nameof(IsRequestingSubmit)}={IsRequestingSubmit}, {nameof(IsAutoSave)}={IsAutoSave}, {nameof(AnonymousId)}={AnonymousId}, {nameof(DplySampleInfoId)}={DplySampleInfoId}, {nameof(DataEditorId)}={DataEditorId}, {nameof(RespondentSampleId)}={RespondentSampleId}, {nameof(ProvidedRespId)}={ProvidedRespId}, {nameof(PersonUpdatingIs)}={PersonUpdatingIs.ToString()}, {nameof(LastSavedPage)}={LastSavedPage}, {nameof(VersionUpdating)}={VersionUpdating}]";
            }

            /// <summary>
            /// Get the string ansVal from the deserialised JSON in a string format suitable for use in QNN_RESP_ANS.
            /// This method applies array and string heuristics for use with QNN_RESP_ANS. 
            /// For raw deserialised value use DataValue() instead. 
            /// </summary>
            public string GetAnsVal(string fieldName)
            {
                //A note on the data:
                //  Most things in the dictionary will be string, even for numeric fields and dates, but
                //  sometimes they might not be depending on the quirks of the front-end controls, and also to some extent on
                //  newtonsoft's efforts to guess the type to use. In particular, we will see JArray for multivalued dropdowns
                //  see: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JArray.htm
                //  For JArray the ToString will give us the JSON that we can store in QNN_RESP_ANS
                //  (For dates the settings used in DeserializeSurveyData tell newtonsoft not to try and guess what values
                //  are dates so they should all be raw strings here)
                object valueOrNull = GetDataValue(fieldName); //unanswered questions may be absent from dictionary
                if (valueOrNull is JArray jarray)
                {   //Used by multiple-value dropdown controls, we store a JSON array in QNN_RESP_ANS
                    //but convert to empty string if empty to avoid storing [] in the column and to preserve the legacy behaviour
                    return jarray.Any() ? jarray.ToString() : "";
                }
                else
                {
                    return valueOrNull?.ToString() ?? null;
                }
            }

            //20241226 - we have simplified the per-field pre-pop flag check by using the list managed by the UI
            //           which saves us having to query the old responses. (This comes at a theoretical UX cost,
            //           which is that if the user changes the value and then changes it back again the
            //           field won't get flagged again, but in practice this is already what would appear
            //           to happen because when they change the value the autsave will save that, so they
            //           would need to change it back before the autosave saves it, and even then would not
            //           see the highlight re-appear until exiting and re-entering (or refreshing) the survey.
            //           tldr=nobody will notice the difference)
            /// <summary>
            /// Checks if this alias is one the clientside reported as considered to be pre-populated
            /// (for highlighting)
            /// </summary>
            public bool IsPrePopulated(string fieldName)
            {
                if (string.IsNullOrWhiteSpace(fieldName)) throw new ArgumentException(nameof(fieldName));
                return prePopulatedFields.Contains(fieldName);
            }

            /// <summary>
            /// Get a deserialised value from the request data (or null if absent). Note that you should use AnsVal method
            /// to get values that are specifically intended for response answer data.
            /// Note, for certain types of data the returned object may be a mutable non-scalar (e.g. JArray)
            /// callers should not mutate these. 
            /// </summary>
            private object GetDataValue(string fieldName)
            {
                if (string.IsNullOrWhiteSpace(fieldName)) throw new ArgumentException(nameof(fieldName));
                data.TryGetValue(fieldName, out object valueOrNull);
                return valueOrNull;
            }

            private ImmutableDictionary<string, object> DeserializeSurveyData(string json)
            {
                if (json == null) throw new ArgumentNullException(nameof(json));
                try
                {
                    //Note: alias in the dictionary are case-sensitive
                    return JsonConvert.DeserializeObject<Dictionary<string, object>>(
                        json, 
                        new JsonSerializerSettings
                        {
                            Culture = System.Globalization.CultureInfo.InvariantCulture,
                            DateParseHandling = DateParseHandling.None //important!
                        })
                        .ToImmutableDictionary();
                }
                catch (Exception e)
                {
                    throw new FormatException("Failed to parse survey data JSON", e);
                }
            }

            /// <summary>
            /// Copy the request data into a new mutable dictionary that caller can modify independently of this request
            /// </summary>
            public Dictionary<string, object> GetDataAsNewDictionary()
            {
                 return data.ToDictionary(pair => pair.Key, pair => (object)pair.Value);
            }

        } // end of SaveRequest

        private class OriginIndicators
        {
            public static OriginIndicators ForNewResponseCreation(SaveRequest request, PreflightContext preflight)
            {
                return new OriginIndicators(request, preflight, null);
            }

            public static OriginIndicators FromExistingResponse(QNN_RESP existingResponse)
            {
                return new OriginIndicators(existingResponse);
            }

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            //NOTE: this object is intended to be immutable. Do not add public setters.      //
            //      Exercise caution around the mutability of property and collection types  //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            //see Constants subclasses ResponseBy, ResponseAs, ResponseVia

            public readonly DateTime? UpdatedDate;
            public readonly string LastResponseAs;
            public readonly string LastResponseBy;
            public readonly string LastResponseVia;
            public readonly Guid? UserId;

            public readonly DateTime? DateStart;
            public readonly string InitialResponseAs;
            public readonly string InitialResponseBy;
            public readonly string InitialResponseVia;
            public readonly Guid? InitialResponseUserId;

            public readonly DateTime? DateComplete;
            public readonly string CompletedResponseAs;
            public readonly string CompletedResponseBy;
            public readonly string CompletedResponseVia;
            public readonly Guid? CompletedResponseUserId;

            public bool IsComplete { get => (DateComplete != null); }

            /// <summary>
            /// Constructor that initialises it with new values for use in a save request 
            /// </summary>
            private OriginIndicators(
                SaveRequest request, 
                PreflightContext preflight,
                OriginIndicators existingIndicators)
            {
                if (request == null) throw new ArgumentNullException(nameof(request));
                //n.b. existingIndicators may be null here, also note that a non-null existingIndicators
                //     may be passed where response hasn't 'started' yet but a qnn_resp row exists due to
                //     pre-population or rejection

                //TODO - later I want to update ExcelSupport to use this updater too at which point changes here will be
                //       needed for extra info to be passed to here, such as responseAs, responseVia
                const string responseAs = Constants.ResponseAs.Form;
                const string responseVia = Constants.ResponseVia.Online;

                UpdatedDate = DateTime.Now;
                LastResponseAs = responseAs;
                LastResponseBy = (request.PersonUpdatingIs == SurveyUserType.DataEditor)
                    ? Constants.ResponseBy.Editor
                    : Constants.ResponseBy.Sample;
                LastResponseVia = responseVia;
                //LastResponseUserId is the existing UserId column. Because of existing uses
                //these columns have the weird semantic that their value is only applicable
                //when the xxxxBy is Editor, but they retain their existing previous value when
                //there is an update with xxxxBy=Sample and for the UserId case that id is exported
                //with the csv as a sort of 'this data editor was the last data editor who
                //touched it though maybe a sample touched it since then' type of value.
                //This is of interest to some customers so must be preserved and we extended
                //this behaviour to the new InitialResponseUserId and CompletedResponseUserId
                //for consistency so they do the same weirdness and we dont have to remember
                //different variations of weirdness for each.
                //tldr: if xxxxBy=Sample then UserId=older
                //      (the view spSP_DeploymentSample used in the DE dashboard applies this logic too)
                UserId = (request.PersonUpdatingIs == SurveyUserType.DataEditor)
                    ? request.DataEditorId
                    : existingIndicators?.UserId;

                //Non-null existingResponse does not mean the response has been started/initiated yet
                //as it can be pre-populated, we need to check if there is a startDate too
                bool isResponseStartedAlready = (existingIndicators?.DateStart != null);
                if (isResponseStartedAlready)
                {   //Preserve the initially recorded origin indicators when updating
                    Debug.Assert(existingIndicators != null);
                    DateStart = existingIndicators.DateStart;
                    InitialResponseAs = existingIndicators.InitialResponseAs;
                    InitialResponseBy = existingIndicators.InitialResponseBy;
                    InitialResponseVia = existingIndicators.InitialResponseVia;
                    InitialResponseUserId = existingIndicators.InitialResponseUserId;
                }
                else
                {   //This update is starting the response now (i.e. there is existing qnn_resp row due to something like prePopulation)
                    DateStart = UpdatedDate;
                    InitialResponseAs = LastResponseAs;
                    InitialResponseBy = LastResponseBy;
                    InitialResponseVia = LastResponseVia;
                    //For data editors, initial respondent may vary as can be many data editors, but there is only
                    //one respondent. So for DE case initialResponseUserId records their Id. For Sample case no need
                    //an extra column as UID already recorded. The initialResponseBy indicates which applies.
                    InitialResponseUserId = (request.PersonUpdatingIs==SurveyUserType.DataEditor)
                        ? request.DataEditorId
                        : null;
                }

                switch (preflight.EffectiveAction)
                {
                    case PreflightContext.EffectiveActionType.Save:
                        //For 'draft' saves we preserve the existing values for completion
                        //indicators (would be null if never submit yet)
                        DateComplete = existingIndicators?.DateComplete;
                        CompletedResponseAs = existingIndicators?.CompletedResponseAs;
                        CompletedResponseBy = existingIndicators?.CompletedResponseBy;
                        CompletedResponseVia = existingIndicators?.CompletedResponseVia;
                        CompletedResponseUserId = existingIndicators?.CompletedResponseUserId;
                        break;

                    case PreflightContext.EffectiveActionType.Submit:
                        //Set the completion indicators on a submission request
                        DateComplete = UpdatedDate;
                        CompletedResponseAs = LastResponseAs;
                        CompletedResponseBy = LastResponseBy;
                        CompletedResponseVia = LastResponseVia;
                        //For why old value of completedResponseUserId is preserved for respondent actions,
                        //please see notes on LastResponseUserId above
                        CompletedResponseUserId = (request.PersonUpdatingIs == SurveyUserType.DataEditor)
                            ? request.DataEditorId
                            : existingIndicators?.CompletedResponseUserId;
                        break;

                    case PreflightContext.EffectiveActionType.BlockResubmit:
                        throw new InvalidOperationException("Cannot create origin indicators for blocked action");

                    default:
                        throw new NotImplementedException($"Unimplemented request type: {preflight.EffectiveAction.ToString()}");
                }
            }

            /// <summary>
            /// Constructor that will copy values for the indicators from an existing response
            /// </summary>
            private OriginIndicators(QNN_RESP resp)
            {
                if (resp == null) throw new ArgumentNullException(nameof(resp));

                UpdatedDate = resp.UpdatedDate;
                LastResponseAs = resp.LastResponseAs;
                LastResponseBy = resp.LastResponseBy;
                LastResponseVia = resp.LastResponseVia;
                UserId = resp.UserId;

                DateStart = resp.DateStart;
                InitialResponseAs = resp.InitialResponseAs;
                InitialResponseBy = resp.InitialResponseBy;
                InitialResponseVia = resp.InitialResponseVia;
                InitialResponseUserId = resp.InitialResponseUserId;

                DateComplete = resp.DateComplete;
                CompletedResponseAs = resp.CompletedResponseAs;
                CompletedResponseBy = resp.CompletedResponseBy;
                CompletedResponseVia = resp.CompletedResponseVia;
                CompletedResponseUserId = resp.CompletedResponseUserId;
            }

            /// <summary>
            /// Create a new instance based on the data in this instance but updating it for the specified saveRequest
            /// </summary>
            public OriginIndicators UpdatedForSave(SaveRequest request, PreflightContext preflight)
            {
                return new OriginIndicators(request, preflight, existingIndicators: this);
            }

            public override string ToString()
            {
                return $"[{nameof(OriginIndicators)} - {nameof(UpdatedDate)}={UpdatedDate?.ToString(Constants.DatetimeFull8601Format)}, {nameof(LastResponseAs)}={LastResponseAs}, {nameof(LastResponseBy)}={LastResponseBy}, {nameof(LastResponseVia)}={LastResponseVia}, {nameof(UserId)}={UserId}, {nameof(DateStart)}={DateStart?.ToString(Constants.DatetimeFull8601Format)}, {nameof(InitialResponseAs)}={InitialResponseAs}, {nameof(InitialResponseBy)}={InitialResponseBy}, {nameof(InitialResponseVia)}={InitialResponseVia}, {nameof(InitialResponseUserId)}={InitialResponseUserId}, {nameof(DateComplete)}={DateComplete?.ToString(Constants.DatetimeFull8601Format)}, {nameof(CompletedResponseAs)}={CompletedResponseAs}, {nameof(CompletedResponseBy)}={CompletedResponseBy}, {nameof(CompletedResponseVia)}={CompletedResponseVia}]";
            }

        } // end of OriginIndicators

        // // // // // // // // // // // // // // // // // // // //

        private class PreflightContext
        {
            private static readonly ILogger<PreflightContext> Logger 
                = (ILogger<PreflightContext>)DefaultApplicationLogging.CreateLogger<PreflightContext>();

            /// <summary>
            /// Prepare the pre-flight context by marshalling more information we need to process the 
            /// data save/update from the database and checking various pre-conditions 
            /// (exceptions are raised if these checks fail).
            /// We don't do any writing here, but we do need to participate in the db transaction
            /// </summary>
            public static async Task<PreflightContext> Prepare(
                SaveRequest request, 
                SurveyPlusOptions surveyPlusOptions,
                Settings configuration)
            {
                if (request == null) throw new ArgumentNullException(nameof(request));
                if (surveyPlusOptions == null) throw new ArgumentNullException(nameof(surveyPlusOptions));

                if (Logger.IsEnabled(LogLevel.Trace))
                {
                    Logger.LogTrace(nameof(Prepare) + " - preparing pre-flight context for request={0}", request);
                }

                //Based on the info in the request, find the deployment, and sample's participation in it (dlsi)
                (QNN_DPLY_SAMPLE_INFO dplySampleInfo,QnnStatusId status, QNN_DPLY dply) 
                    = await Prepare_Dply(request.DplySampleInfoId);

                Guid structDivisionIdForAuditPurposes; //may differ from that of dply for an editor
                bool isBeingUpdatedByAnonymous;
                switch (request.PersonUpdatingIs)
                {
                    case SurveyUserType.Respondent:
                        isBeingUpdatedByAnonymous 
                            = await Prepare_IsBeingUpdatedByAnonymous(
                                sampleId: request.RespondentSampleId.Value,
                                isAnonymousSurvey: dply.IsAnonymous ?? false, //TODO - why can this be null????
                                anonymousId: request.AnonymousId);
                        structDivisionIdForAuditPurposes = dply.StructDivisionId.Value;
                        break;

                    case SurveyUserType.DataEditor:
                        isBeingUpdatedByAnonymous = false;
                        structDivisionIdForAuditPurposes 
                            = await Prepare_DataEditor(
                                userId: request.DataEditorId.Value,
                                dplyId: dply.Id,
                                dplyStructDivisionId: dply.StructDivisionId.Value,
                                listSampleId: dplySampleInfo.ListSampleId);
                        break;

                    default:
                        throw new NotImplementedException(request.PersonUpdatingIs.ToString());
                }
                ImmutableDictionary<Guid, string> fieldNamesById 
                    = await Prepare_Fields(configuration, dply.QnnId);

                //Find the existing response (if any)
                (QNN_RESP existingResponse, 
                 ImmutableList<ImmutableDictionary<string, object>> existingAnswers,
                 OriginIndicators existingOriginIndicators)
                    = await Prepare_ExistingReponse(
                        configuration: configuration,
                        providedRespId: request.ProvidedRespId,
                        dplyId: dply.Id,
                        listSampleId: dplySampleInfo.ListSampleId,
                        isBeingUpdatedByAnonymous: isBeingUpdatedByAnonymous,
                        anonymousId: request.AnonymousId,
                        expectedFieldCount: fieldNamesById.Count);

                SurveyResponseVersionToken existingVersion 
                    = Prepare_Version(
                        validateVersionMatches: surveyPlusOptions.IsEnableResponseVersionCheck, 
                        existingResponse: existingResponse, 
                        versionUpdating: request.VersionUpdating);

                //Check if the form is editable in the current situation (fail if not)
                await Prepare_Editability(
                    personUpdatingIs: request.PersonUpdatingIs,
                    status: status,
                    dply: dply,
                    dplySampleInfo: dplySampleInfo,
                    dateComplete: existingResponse?.DateComplete);

                //Determine what strata it falls into (if any)
                (string strata, bool isStrataFilled)
                    = await Prepare_StrataQuota(
                        request, 
                        dply.StrataSource, 
                        dply.Id);

                bool isCreatingNewResponse = (existingResponse == null);
                bool isFirstSubmission = (request.IsRequestingSubmit && (existingResponse?.DateComplete == null));
                EffectiveActionType effectiveAction = Prepare_EffectiveAction(
                    configuration, 
                    request, 
                    isFirstSubmission);

                PreflightContext context = new PreflightContext(
                    dply: dply,
                    dplySampleInfo: dplySampleInfo,
                    structDivisionIdForAuditPurposes: structDivisionIdForAuditPurposes,
                    fieldNamesById: fieldNamesById,
                    strata: strata,
                    isStrataFilled: isStrataFilled,
                    isBeingUpdatedByAnonymous: isBeingUpdatedByAnonymous,
                    isCreatingNewResponse: isCreatingNewResponse,
                    existingResponseId: existingResponse?.Id,
                    isFirstSubmission: isFirstSubmission,
                    existingOriginIndicators: existingOriginIndicators,
                    existingAnswers: existingAnswers,
                    effectiveAction: effectiveAction);

                if (Logger.IsEnabled(LogLevel.Trace))
                {
                    Logger.LogTrace(nameof(Prepare) + " - returning pre-flight context={0}", context);
                }

                return context;
            }

            /// <summary>
            /// Given the DLSI will lookup the QNN_DPLY_SAMPLE_INFO and the QNN_DPLY
            /// For convenience, thisa lso returns the status from the dlsi in the form of a QnnStatusId
            /// </summary>
            private static async Task< (
                    QNN_DPLY_SAMPLE_INFO dplySampleInfo, 
                    QnnStatusId status, 
                    QNN_DPLY)> 
                Prepare_Dply(Guid dlsi)
            {
                QNN_DPLY_SAMPLE_INFO dplySampleInfo = await QNN_DPLY_SAMPLE_INFO.SelectByKey(dlsi);
                if (dplySampleInfo == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, dlsi);
                QnnStatusId status = QnnStatusId.FromGuid(dplySampleInfo.Status);

                QNN_DPLY dply = await QNN_DPLY.SelectByKey(dplySampleInfo.DplyId);
                if (dply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplySampleInfo.DplyId);

                return (dplySampleInfo, status, dply);
            }

            /// <summary>
            /// Determine if the update is for swzAnonymous in an anonymous survey
            /// </summary>
            private static async Task<bool> 
                Prepare_IsBeingUpdatedByAnonymous(
                    Guid sampleId, 
                    bool isAnonymousSurvey, 
                    Guid? anonymousId)
            {
                bool isBeingUpdatedByAnonymous;

                QNN_SAMPLE requestingRespondent = await QNN_SAMPLE.SelectByKey(sampleId);
                if (requestingRespondent == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_SAMPLE, sampleId);

                isBeingUpdatedByAnonymous
                    = ResponseApplication.IsRespondentIsAnonymousSample(
                        isServingRespondent: true,
                        anonymousId: anonymousId ?? Guid.Empty,
                        isAnonymousSurvey: isAnonymousSurvey,
                        uid: requestingRespondent?.UID);

                return isBeingUpdatedByAnonymous;
            }

            /// <summary>
            /// Verify the data editor has the right access for this response (fail if not) and return their
            /// StructDivisionId which may differ from that of the deployment, and will be used as the organisation
            /// to record audit logs against.
            /// </summary>
            private static async Task<Guid>
                Prepare_DataEditor(
                    Guid userId, 
                    Guid dplyId, 
                    Guid dplyStructDivisionId, 
                    Guid listSampleId)
            {
                SecurityUser requestingDataEditor = await SecurityUser.SelectByKey(userId);
                if (requestingDataEditor == null)
                {
                    throw NotFoundException.ForModelName(Constants.ModelName.dwSecurityUser, userId);
                }

                if (!(await IntranetAccountApplication.IsUserInRoleAsync(requestingDataEditor.Id, Constants.Role.DataEditor)))
                {
                    throw new PermissionException($"User {requestingDataEditor.Id} ({requestingDataEditor.Name}) is not a {Constants.Role.DataEditor}");
                }

                //Verify the editor is in an appropriate organisation for this deployment
                HashSet<Guid> editorOrganisations 
                    = await StructDivision.SelectChildrenAndThisIdSetAsync(requestingDataEditor.StructDivisionId.Value);
                if (!editorOrganisations.Contains(dplyStructDivisionId))
                {
                    throw new PermissionException($"Data Editor {requestingDataEditor.Id} ({requestingDataEditor.Name}) in StructDivision {requestingDataEditor.StructDivisionId} does not have organisational access to deployment's StructDivision {dplyStructDivisionId} for QNN_DPLY {dplyId}");
                }

                //Verify this editor is assigned for this sample
                bool sampleIsAssignedToDataEditor
                    = await DeploymentApplication.CheckEditorsAccess(
                        listSampleId: listSampleId,
                        dplyId: dplyId,
                        dataEditorId: requestingDataEditor.Id);
                if (!sampleIsAssignedToDataEditor)
                {
                    throw new PermissionException($"Editor {requestingDataEditor.Id} ({requestingDataEditor.Name}) is not assigned to listSample {listSampleId}");
                }

                return requestingDataEditor.StructDivisionId.Value;
            }

            /// <summary>
            /// Verifies (if configured to do so) that the fields are up to date.
            /// Prepares a lookup table of fieldId to alias
            /// </summary>
            private static async Task<
                ImmutableDictionary<Guid,string>> 
                    Prepare_Fields(
                        Settings configuration, 
                        Guid qnnId)
            {
                List<QNN_QNN_FIELD> fields
                    = await FormPropertiesApplication.GetQNN_QNN_FIELDsByQnnIdAsync(qnnId);
                if (!fields.Any()) throw new InvalidOperationException($"There are no fields for qnn {qnnId}");
                
                if (Logger.IsEnabled(LogLevel.Trace))
                {
                    Logger.LogTrace(nameof(Prepare_Fields) + " - qnnId={1}, fields.Count={2}", qnnId, fields?.Count);
                }

                if (configuration.IsCheckFieldsUpdatedForQnn)
                {
                    //Verify the current form design is still in sync with fields specified in QNN_QNN/QNN_QNN_FIELD
                    //TODO - can we fix redund queries here where LatestFormFieldsUpdatedForQnn needs to fetch the fields again internally? Also to add flag to disable this during response updates as its quite a performance factor
                    (string msg, bool latestFormFieldsUpdatedForQnn)
                        = await FormPropertiesApplication.LatestFormFieldsUpdatedForQnn(qnnId);
                    if (!latestFormFieldsUpdatedForQnn)
                    {
                        throw new InvalidSurveyException(msg);
                    }
                }

                ImmutableDictionary<Guid, string> fieldNamesById = fields.ToImmutableDictionary(f => f.Id, f => f.Name);
                return fieldNamesById;
            }

            /// <summary>
            /// Find the existing response, including its existing answer data and origin indicators.
            /// Will verify the response is really for this dlsi and fail if not. 
            /// </summary>
            private static async Task<( 
                QNN_RESP existingResponse, 
                ImmutableList<ImmutableDictionary<string, object>> existingAnswers, 
                OriginIndicators existingOriginIndicators) > 
                    Prepare_ExistingReponse(
                        Settings configuration,
                        Guid? providedRespId,
                        Guid dplyId, 
                        Guid listSampleId,
                        bool isBeingUpdatedByAnonymous,
                        Guid? anonymousId,
                        int expectedFieldCount)
            {
                //Look for an existing response. If there is none then it indicates that we are creating a new response.
                //Note that ProvidedRespId is optional for single-response surveys (but required for multiple response type
                //surveys to know which response to edit. 
                QNN_RESP existingResponse;
                if (providedRespId != null)
                {   //We don't always have the respId (providied in the URL),
                    //but when we do it lets us skip more complex logic for finding the existing response to be updated
                    existingResponse = await QNN_RESP.SelectByKey(providedRespId.Value);
                    if (existingResponse == null)
                    {   //If a specific respId was provided we expect to find a response with it
                        throw NotFoundException.ForModelName(Constants.ModelName.QNN_RESP, providedRespId.Value);
                    }
                }
                else
                {
                    //The lack of a provided respId (in the url) does not necessarily mean that we are creating a new
                    //response! Instead we have to go look to try and find the response
                    Filter filter = Filter.And
                        .Equal(dplyId, Constants.FieldName.DplyId)
                        .Equal(listSampleId, Constants.FieldName.ListSampleId);
                    //intranet will not check anonymousId, only internet
                    if (isBeingUpdatedByAnonymous)
                    {   //For swzAnonymous we need the unique id from the cookie to find their response again
                        //(Anonymous surveys have only swzAnonymous as the sample, with multiple responses by it)
                        if (anonymousId == null || Guid.Empty.Equals(anonymousId))
                            throw new InvalidOperationException("AnonymousId not provided");
                        filter = filter.Merge(Filter.And.Equal(anonymousId, Constants.FieldName.AnonymousId));
                    }
                    //(legacy behaviour) take only 1 record for anonymous/multiple survey to prevent take too much records
                    //TODO - to check this again in the case of multi-response survey types. Iirc for those we always pass
                    //       a respId? In which case perhaps we could fail-fast if there is more than one response?
                    Paging pageOneRecord = Paging.Create(skip: 0, take: 1);
                    Order orderByNumberId = Order.StartDesc(Constants.FieldName.NumberId);
                    List<QNN_RESP> responseList = await QNN_RESP.SelectAsync(filter, orderByNumberId, pageOneRecord);

                    if (Logger.IsEnabled(LogLevel.Trace))
                    {
                        Logger.LogTrace(nameof(Prepare_ExistingReponse) + " - respId not provided, found {0} responses using filter={1}", responseList?.Count, filter);
                    }

                    existingResponse = responseList.FirstOrDefault(); //may be null
                }

                ImmutableList<ImmutableDictionary<string, object>> existingAnswers;
                OriginIndicators existingOriginIndicators;
                if (existingResponse != null)
                {
                    //Assert that the specified response is really for this deployment
                    if (!dplyId.Equals(existingResponse.DplyId.Value))
                    {
                        throw new InvalidOperationException($"Invalid respId - response {existingResponse.Id} is for QNN_DPLY {existingResponse.DplyId} and not the expected {dplyId}");
                    }

                    //Assert that the specified response is really for this sample
                    if (!listSampleId.Equals(existingResponse.ListSampleId.Value))
                    {
                        throw new InvalidOperationException($"Invalid respId - response {existingResponse.Id} is for QNN_LIST_SAMPLE {existingResponse.ListSampleId} and not the expected {listSampleId}");
                    }

                    //Fetch existing answers 
                    ILogger<spSP_GetSingleResponseData> getSingleResponseDataLogger
                        = (ILogger<spSP_GetSingleResponseData>)DefaultApplicationLogging.CreateLogger<spSP_GetSingleResponseData>();
                    //n.b. as of 20250317 spSP_GetSingleResponseData still supports retries, but here we won't allow them
                    spSP_GetSingleResponseData spSP_GetSingleResponseData
                        = new spSP_GetSingleResponseData(getSingleResponseDataLogger,
                        configuration.SettingsForGetSingleResponseData,
                        RetrySettings.NO_RETRIES_INSTANCE);
                    existingAnswers
                        = (await spSP_GetSingleResponseData.ForResponse(existingResponse.Id))
                        .Select(row => row.ToImmutableDictionary())
                        .ToImmutableList();
                    if (existingAnswers.Count != expectedFieldCount)
                    {
                        throw new InternalException($"Expecting answers for {expectedFieldCount} fields, but found {existingAnswers.Count} rows in QNN_RESP_ANS for QNN_RESP {existingResponse.Id}");
                    }

                    existingOriginIndicators = OriginIndicators.FromExistingResponse(existingResponse);
                }
                else
                {   //if no existing response
                    existingAnswers = null;
                    existingOriginIndicators = null;
                }

                return (existingResponse, existingAnswers, existingOriginIndicators);
            }
             
            /// <summary>
            /// Verify that the existing version is the one we expected to be updating (fail if not)
            /// and return its version token.
            /// </summary>
            private static SurveyResponseVersionToken Prepare_Version(
                bool validateVersionMatches, 
                QNN_RESP existingResponse, 
                SurveyResponseVersionToken versionUpdating)
            {
                // Validate Survey data Version
                bool isCreatingNewResponse = (existingResponse == null);
                SurveyResponseVersionToken existingVersion = (isCreatingNewResponse)
                    ? SurveyResponseVersionToken.NewVersion()
                    : SurveyResponseVersionToken.FromQnnResp(existingResponse);
                if (validateVersionMatches)
                {
                    // When this check is enabled it will check that the survey data that is being saved
                    // was based upon the same version of the data that we have in the database now.
                    // If it is not the same version it means that newer changes have already been saved 'from elsewhere'
                    // and the data we are about to save now will have the effect of overwriting the newer data with older data.
                    if (versionUpdating != existingVersion)
                        throw new InvalidVersionException(versionUpdating, existingVersion);
                }
                return existingVersion;
            }

            /// <summary>
            /// Checks the form is editable based on the business logic and current state. Fail if not.
            /// Note that this doesn't check the effective action.
            /// </summary>
            private static async Task Prepare_Editability(
                SurveyUserType personUpdatingIs,
                QnnStatusId status,
                QNN_DPLY dply,
                QNN_DPLY_SAMPLE_INFO dplySampleInfo,
                DateTime? dateComplete)
            {
                bool isMultipleResponseFeaturesEnabled = ResponseApplication.IsMultipleResponseFeaturesEnabled(dply);
                DateTime dueDate = await spSP_GetDueDate.DueDateFor(dplySampleInfo);
                ResponseApplication.FormEditable editabilityState
                    = ResponseApplication.IsFormEditable(
                        editorType: personUpdatingIs,
                        status: status,
                        dueDateApplicableToSample: dueDate,
                        daysUpdate: dply.DaysUpdate,
                        isMultipleResponseFeaturesEnabled: isMultipleResponseFeaturesEnabled,
                        DateComplete: dateComplete);

                if (Logger.IsEnabled(LogLevel.Trace))
                {
                    Logger.LogTrace(nameof(Prepare_Editability) + " - dlsi={0}, personUpdatingIs={1}, status={2}, dueDate={3}, daysUpdate={4}, isMultipleResponseFeaturesEnabled={5}, dateComplete={6}, editabilityState={7}", dplySampleInfo?.Id, personUpdatingIs, status, dueDate, dply?.DaysUpdate, isMultipleResponseFeaturesEnabled, dateComplete, editabilityState );
                }

                if (ResponseApplication.FormEditable.Yes != editabilityState)
                {
                    throw SurveyNotEditableException.Because(editabilityState);
                }
            }

            /// <summary>
            /// Determine the strata this response is for (if any) and whether that strata is filled or not yet
            /// (but we don't enforce that quota in this method)
            /// </summary>
            private static async Task<(
                string strata, 
                bool isStrataFilled)>
                    Prepare_StrataQuota(
                        SaveRequest request,
                        string strataSource,
                        Guid dplyId)
            {
                //Get the stratum information for this response (quota checked later)
                bool isStrataSourceDefined = !string.IsNullOrEmpty(strataSource);
                string strata = isStrataSourceDefined
                    ? request.GetAnsVal(strataSource)
                    : null;
                bool isStrataFilled = isStrataSourceDefined
                    ? await ResponseApplication.IsStrataFilled(dplyId, strata)
                    : false;
                return (strata, isStrataFilled);
            }

            private static EffectiveActionType 
                Prepare_EffectiveAction(
                    Settings configuration,
                    SaveRequest request,
                    bool isFirstSubmission)
            {
                switch (request.RequestedAction)
                {
                    case SaveRequest.RequestedActionType.Save:
                        return EffectiveActionType.Save;

                    case SaveRequest.RequestedActionType.Submit:
                        if (isFirstSubmission)
                        {
                            return EffectiveActionType.Submit;
                        }
                        else
                        {
                            Settings.ResubmitPolicy resubmitPolicy
                                = configuration.ResubmitPolicyFor(request.PersonUpdatingIs);
                            switch (resubmitPolicy)
                            {
                                case Settings.ResubmitPolicy.Allow: return EffectiveActionType.Submit;
                                case Settings.ResubmitPolicy.Block: return EffectiveActionType.BlockResubmit;
                                case Settings.ResubmitPolicy.SaveOnly: return EffectiveActionType.Save;
                                default: throw new NotImplementedException(resubmitPolicy.ToString());
                            }
                        }

                    default:
                        throw new NotImplementedException(request.RequestedAction.ToString());
                }
            }

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            //NOTE: this object is intended to be immutable. Do not add public setters.      //
            //      Exercise caution around the mutability of property and collection types  //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            public enum EffectiveActionType
            {
                Save,
                Submit,
                BlockResubmit
            }

            //Properties exposed by this context
            public IEnumerable<Guid> FieldIds { get => fieldNamesById.Keys; }

            public int FieldCount { get => fieldNamesById.Count; }

            public bool IsUpdatingExistingResponse { get => (!IsCreatingNewResponse); }

            public bool IsMultipleResponseFeaturesEnabled { get => ResponseApplication.IsMultipleResponseFeaturesEnabled(dply); }

            public int MaxResponse { get => dply.MaxResponse??Constants.Unlimited; }

            public Guid DplyId { get => dply.Id; }

            public Guid QnnId { get => dply.QnnId; }

            public string CompleteURL { get => dply.CompleteURL; }

            public Char CompleteAction { get => dply.CompleteAction; }

            public Guid ListSampleId { get => dplySampleInfo.ListSampleId; }

            // Some of these are declared as class fields (rather than properties) in order to get readonly semantics
            // however from the P.O.V of code outside this class they are considered as get-only properties
            // and hence I am using property-like coding conventions and capitalising their names here
            public readonly Guid StructDivisionIdForAuditPurposes;
            public readonly string Strata;
            public readonly bool IsStrataFilled;
            public readonly bool IsBeingUpdatedByAnonymous;
            public readonly QnnStatusId Status;
            public readonly bool IsCreatingNewResponse;
            public readonly Guid? ExistingResponseId;
            public readonly OriginIndicators Origin;
            public readonly bool IsFirstSubmission;
            public readonly ImmutableList<ImmutableDictionary<string, object>> ExistingAnswers;
            public readonly EffectiveActionType EffectiveAction;
            //End of 'properties'

            //Entity objects are mutable and we want preflight to be immutable to its users, so keep
            //them hidden and only expose the bits the updater needs as immutable properties
            private readonly QNN_DPLY dply;
            private readonly QNN_DPLY_SAMPLE_INFO dplySampleInfo;
            private ImmutableDictionary<Guid, string> fieldNamesById;

            /// <summary>
            /// Hidden constructor. This has no logic - the work of loading and verifying all the information 
            /// is handled in the async static factory method Prepare (and the 'sub-methods' it calls).
            /// </summary>
            private PreflightContext(
                QNN_DPLY dply, 
                QNN_DPLY_SAMPLE_INFO dplySampleInfo,
                Guid structDivisionIdForAuditPurposes, 
                ImmutableDictionary<Guid,string> fieldNamesById, 
                string strata, 
                bool isStrataFilled, 
                bool isBeingUpdatedByAnonymous, 
                bool isCreatingNewResponse, 
                Guid? existingResponseId, 
                bool isFirstSubmission, 
                OriginIndicators existingOriginIndicators,
                ImmutableList<ImmutableDictionary<string, object>> existingAnswers,
                EffectiveActionType effectiveAction)
            {
                this.dply = dply ?? throw new ArgumentNullException(nameof(dply));
                this.dplySampleInfo = dplySampleInfo ?? throw new ArgumentNullException(nameof(dplySampleInfo));
                Status = QnnStatusId.FromGuid(dplySampleInfo.Status);
                StructDivisionIdForAuditPurposes = structDivisionIdForAuditPurposes;
                this.fieldNamesById = fieldNamesById ?? throw new ArgumentNullException(nameof(fieldNamesById));
                Strata = strata; //may be null
                IsStrataFilled = isStrataFilled;
                IsBeingUpdatedByAnonymous = isBeingUpdatedByAnonymous;
                IsCreatingNewResponse = isCreatingNewResponse;
                ExistingResponseId = existingResponseId; //may be null
                IsFirstSubmission = isFirstSubmission;
                Origin = existingOriginIndicators; //may be null
                ExistingAnswers = existingAnswers; //may be null (i.e. if new response)
                this.EffectiveAction = effectiveAction;
            }

            /// <summary>
            /// Returns the alias for the specified fieldId. Will throw an exception if the fieldId is invalid.
            /// </summary>
            public string AliasFor(Guid fieldId)
            {
                if (fieldNamesById.TryGetValue(fieldId, out string name))
                    return name;
                else
                    throw new NotFoundException($"QNN_QNN_FIELD Id {fieldId} is not valid for QNN_QNN {QnnId}");
            }

            public override string ToString()
            {
                return $"[{nameof(PreflightContext)} - {nameof(StructDivisionIdForAuditPurposes)}={StructDivisionIdForAuditPurposes}, {nameof(DplyId)}={DplyId}, {nameof(QnnId)}={QnnId}, {nameof(fieldNamesById)}.Count={fieldNamesById.Count}, {nameof(MaxResponse)}={MaxResponse}, {nameof(IsMultipleResponseFeaturesEnabled)}={IsMultipleResponseFeaturesEnabled}, {nameof(CompleteAction)}={CompleteAction}, {nameof(CompleteURL)}={CompleteURL}, {nameof(dply)}.{nameof(QNN_DPLY.DateStart)}={dply.DateStart}, {nameof(dply)}.{nameof(QNN_DPLY.DateEnd)}={dply.DateEnd}, {nameof(OriginIndicators)}={Origin}, {nameof(ListSampleId)}={ListSampleId}, {nameof(IsBeingUpdatedByAnonymous)}={IsBeingUpdatedByAnonymous}, {nameof(Status)}={Status}, {nameof(ExistingResponseId)}={ExistingResponseId}, {nameof(IsCreatingNewResponse)}={IsCreatingNewResponse}, {nameof(Strata)}={Strata}, {nameof(IsStrataFilled)}={IsStrataFilled}, {nameof(IsFirstSubmission)}={IsFirstSubmission}, {nameof(EffectiveAction)}={EffectiveAction.ToString()}]";
            }

        } //end of PreflightContext

        // // // // // // // // // // // // // // // // // // // //

        public class Result
        {
            public static Result Failed(Exception exception, long durationMs)
            {
                Outcome reason;
                if (exception is SurveyResponseUpdateException sruEx)
                    reason = sruEx.OutcomeType;
                else if (exception is PermissionException)
                    reason = Outcome.Unauthorised;
                else
                    reason = Outcome.Error;

                bool isRetryable = DbHelper.IsTransactionRetryable(exception)
                    || exception.Message == "TESTRETRY"; //TODO - remove TESTRETRY at some point
                return new Result(reason, isRetryable, changeDataResponse: null, exception, durationMs);
            }

            public static Result Success(ChangeDataResponce changeDataResponse, long durationMs)
            {
                if (changeDataResponse == null) throw new ArgumentNullException(nameof(changeDataResponse));
                return new Result(Outcome.Success, isRetryable: false, changeDataResponse, exception: null, durationMs);
            }

            /// <summary>
            /// For use with the legacy timestamp check, where it returns a 'success' response and doesn't let the
            /// clientside know the save request was ignored (legacy behaviour)
            /// </summary>
            public static Result FakeSuccess(Exception exception, ChangeDataResponce changeDataResponse, long durationMs)
            {
                return new Result(Outcome.Success, isRetryable: false, changeDataResponse, exception, durationMs);
            }

            public enum Outcome
            {
                Success, 
                Error,
                Unauthorised,
                InvalidSurvey,
                ConcurrentResponseModification,
                MaxResponseFilled,
                StrataQuotaFilled,
                AlreadyCleared,
                SurveyIsClosed,
                AlreadyResponded,
                ResubmitNotAllowed
            }

            /// <summary>
            /// Human-facing message for reason code
            /// </summary>
            public static string MessageFor(Outcome reason)
            {
                switch (reason)
                {
                    case Outcome.Success:
                        return "Survey updated successfully";

                    case Outcome.Unauthorised:
                        return Constants.Message.YouDontHaveThePermission;

                    case Outcome.InvalidSurvey:
                        return Constants.Message.InvalidSurvey;

                    case Outcome.ConcurrentResponseModification:
                        return "This survey response was already modified elsewhere, please refresh the page and try again";

                    case Outcome.MaxResponseFilled:
                        //TODO - can we remove the . ? (does client check msg text?)
                        return "Survey reached its max responses.";

                    case Outcome.StrataQuotaFilled:
                        return "This survey has reached the maximum number of responses for the group";

                    case Outcome.AlreadyCleared:
                        return "Survey has been cleared. Cannot update survey";

                    case Outcome.SurveyIsClosed:
                        return "Survey has been closed";

                    case Outcome.AlreadyResponded:
                        return "You can no longer update the survey";

                    case Outcome.ResubmitNotAllowed:
                        return "This survey has already been submitted and cannot be resubmitted.";

                    case Outcome.Error:
                    default:
                        //TODO - can we remove the . ? (does client check msg text?)
                        return "Data submission was not successful. Please contact administrator.";
                }
            }

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            //NOTE: this object is intended to be immutable. Do not add public setters.      //
            //      Exercise caution around the mutability of property and collection types  //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            public Outcome Reason { get; private set; }

            public string Message { get => MessageFor(Reason); }

            public bool IsSuccess { get => (Reason == Outcome.Success); }

            public bool IsFailure { get => !IsSuccess; }

            public bool IsRetryable { get; private set; }

            public bool HasResponse { get => (ChangeDataResponse != null); }

            public ChangeDataResponce ChangeDataResponse { get; private set; }

            public bool HasException { get => (Exception != null); }

            public Exception Exception { get; private set; }

            public long DurationMilliseconds { get; private set; }

            private Result(Outcome reason, bool isRetryable, ChangeDataResponce changeDataResponse, Exception exception, long duration)
            {
                this.Reason = reason;
                this.IsRetryable = isRetryable;
                this.ChangeDataResponse = changeDataResponse;
                this.Exception = exception;
                this.DurationMilliseconds = duration;
            }

            public override string ToString()
            {
                return $"[{nameof(Result)} - {nameof(IsSuccess)}={IsSuccess}, {nameof(IsRetryable)}={IsRetryable}, {nameof(Reason)}={Reason}, {nameof(DurationMilliseconds)}={DurationMilliseconds}, {nameof(HasResponse)}={HasResponse}"
                    + (HasException ? $", {nameof(Exception)}.{nameof(Exception.Message)}=\"{Exception?.Message}]\"" : "]");
            }
        } //end of Result

        // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Configuration information for the updater (e.g. behaviour and retry related settings etc)
        /// </summary>
        public class Settings
        {
            /// <summary>
            /// If enabled, the preflight checks will also verify that the form fields for this survey are
            /// up to date with the form design. This is a fail-fast check, if data in qnn_qnn_field is not
            /// in sync with the form design it will result in errors elsewhere if this check is disabled,
            /// however the check adds overhead to each response update.
            /// see method: FormPropertiesApplication.LatestFormFieldsUpdatedForQnn
            /// </summary>
            public readonly bool IsCheckFieldsUpdatedForQnn;

            //TODO - this ought to be a standard part of RetrySettings class?
            public readonly double RetryDelayMultiplier; 

            /// <summary>
            /// When true the new updater logic is used to only update changed answers in their existing table rows.
            /// When false will use the older behaviour of delete-then-insert all answer rows. 
            /// It is intended to remove this option 'soon' and only support update-in-place.
            /// </summary>
            public readonly bool IsUpdateInPlace;

            /// <summary>
            /// Retry settings for the updater itself
            /// </summary>
            public readonly RetrySettings RetryConfiguration;

            /// <summary>
            /// Timeout settings to be used by spSP_InsertResp
            /// </summary>
            public readonly TimeoutSettings SettingsForInsertResp;

            /// <summary>
            /// Timeout settings to be used by spSP_UpdateResp
            /// </summary>
            public readonly TimeoutSettings SettingsForUpdateResp;

            /// <summary>
            /// Timeout settings to be used by spSP_DeleteAllRespAnsByRespId
            /// </summary>
            public readonly TimeoutSettings SettingsForDeleteAllRespAnsByRespId;

            /// <summary>
            /// Timeout settings to be used by spSP_UpdateQnnRespAns
            /// </summary>
            public readonly TimeoutSettings SettingsForUpdateQnnRespAns;

            /// <summary>
            /// Timeout settings to be used by spSP_GetSingleResponseData
            /// </summary>
            public readonly TimeoutSettings SettingsForGetSingleResponseData;

            public enum ResubmitPolicy { Allow, Block, SaveOnly }

            public readonly ResubmitPolicy DataEditorResubmitPolicy;

            public readonly ResubmitPolicy RespondentResubmitPolicy;

            public ResubmitPolicy ResubmitPolicyFor(SurveyUserType userType)
            {
                switch (userType)
                {
                    case SurveyUserType.DataEditor: return DataEditorResubmitPolicy;
                    case SurveyUserType.Respondent: return RespondentResubmitPolicy;
                    default: throw new NotImplementedException(userType.ToString());
                }
            }

            public Settings(RetrySettings retryConfiguration, double retryDelayMultiplier, bool isUpdateInPlace,bool isCheckFieldsUpdatedForQnn, TimeoutSettings settingsForInsertResp, TimeoutSettings settingsForUpdateResp, TimeoutSettings settingsForDeleteAllRespByRespId, TimeoutSettings settingsForUpdateQnnRespAns, TimeoutSettings settingsForGetSingleResponseData, ResubmitPolicy dataEditorResubmitPolicy, ResubmitPolicy respondentResubmitPolicy)
            {
                if (retryDelayMultiplier <= 0) throw new ArgumentOutOfRangeException(nameof(retryDelayMultiplier));
                RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(RetryConfiguration));
                IsUpdateInPlace = isUpdateInPlace;
                IsCheckFieldsUpdatedForQnn = isCheckFieldsUpdatedForQnn;
                RetryDelayMultiplier = retryDelayMultiplier;
                SettingsForInsertResp = settingsForInsertResp ?? throw new ArgumentNullException(nameof(settingsForInsertResp));
                SettingsForUpdateResp = settingsForUpdateResp ?? throw new ArgumentNullException(nameof(settingsForUpdateResp));
                SettingsForDeleteAllRespAnsByRespId = settingsForDeleteAllRespByRespId ?? throw new ArgumentNullException(nameof(settingsForDeleteAllRespByRespId));
                SettingsForUpdateQnnRespAns = settingsForUpdateQnnRespAns ?? throw new ArgumentNullException(nameof(settingsForUpdateQnnRespAns));
                SettingsForGetSingleResponseData = settingsForGetSingleResponseData ?? throw new ArgumentNullException(nameof(settingsForGetSingleResponseData));
                DataEditorResubmitPolicy = dataEditorResubmitPolicy;
                RespondentResubmitPolicy = respondentResubmitPolicy;
            }

            public override string ToString()
            {
                return $"[{nameof(Settings)} - {nameof(IsUpdateInPlace)}={IsUpdateInPlace}, {nameof(RetryDelayMultiplier)}={RetryDelayMultiplier}, {nameof(RetryConfiguration)}={RetryConfiguration}, {nameof(SettingsForInsertResp)}={SettingsForInsertResp}, {nameof(SettingsForUpdateResp)}={SettingsForUpdateResp}, {nameof(SettingsForUpdateQnnRespAns)}={SettingsForUpdateQnnRespAns}, {nameof(SettingsForGetSingleResponseData)}={SettingsForGetSingleResponseData}, {nameof(DataEditorResubmitPolicy)}={DataEditorResubmitPolicy.ToString()}, {nameof(RespondentResubmitPolicy)}={RespondentResubmitPolicy.ToString()}]";
            }
        }

        // // // // // // // // // // // // // // // // // // // //

        public const string SETTING_PREFIX = "SurveyResponseUpdater";
        public const string SETTING_UPDATEINPLACE = SETTING_PREFIX + ".UpdateInPlace";
        public const string SETTING_CHECK_FIELDS_UPDATED_FOR_QNN = SETTING_PREFIX + ".CheckFieldsUpdatedForQnn";
        public const string SETTING_RETRIES = SETTING_PREFIX + RetrySettings.SETTING_RETRIES_POSTFIX;
        public const string SETTING_RETRY_DELAY = SETTING_PREFIX + RetrySettings.SETTING_BASE_RETRY_DELAY_POSTFIX;
        public const string SETTING_RETRY_DELAY_MULTIPLIER = SETTING_PREFIX + ".RetryDelayMultiplier";
        public const string SETTING_DATA_EDITOR_RESUBMIT_POLICY = SETTING_PREFIX + ".DataEditorResubmitPolicy";
        public const string SETTING_RESPONDENT_RESUBMIT_POLICY = SETTING_PREFIX + ".RespondentResubmitPolicy";

        //don't forget to add names here, or you will end up with the falback defaults!
        private static readonly ImmutableList<String> SETTING_NAMES = new List<string> {
            //For the updater itself
            SETTING_UPDATEINPLACE,
            SETTING_CHECK_FIELDS_UPDATED_FOR_QNN,
            SETTING_RETRIES,
            SETTING_RETRY_DELAY,
            SETTING_RETRY_DELAY_MULTIPLIER,
            SETTING_DATA_EDITOR_RESUBMIT_POLICY,
            SETTING_RESPONDENT_RESUBMIT_POLICY,
            spSP_InsertResp.SETTING_TIMEOUT,
            spSP_UpdateResp.SETTING_TIMEOUT,
            spSP_DeleteAllRespAnsByRespId.SETTING_TIMEOUT,
            spSP_UpdateQnnRespAns.SETTING_TIMEOUT,
            spSP_GetSingleResponseData.SETTING_TIMEOUT,
        }.ToImmutableList();

        /// <summary>
        /// Factory method to get an instance of the updater with settings taken from dwAppSettings
        /// </summary>
        public static async Task<SurveyResponseUpdaterMkII> GetInstanceUsingAppSettingsAsync(
            SaveRequest request, 
            SurveyPlusOptions surveyPlusOptions)
        {
            if (request == null) throw new ArgumentNullException(nameof(request));
            if (surveyPlusOptions == null) throw new ArgumentNullException(nameof(request));

            ILogger<SurveyResponseUpdaterMkII> logger 
                = (ILogger<SurveyResponseUpdaterMkII>)DefaultApplicationLogging.CreateLogger<SurveyResponseUpdaterMkII>();

            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(
                userId: request.DataEditorId ?? Guid.Empty,
                sampleId: request.RespondentSampleId ?? Guid.Empty);

            SettingsWrapper appSettings = await SettingsWrapper.ForNames(SETTING_NAMES);

            bool isUpdateInPlace = appSettings.GetBoolOrDefault(SETTING_UPDATEINPLACE, true, logger);

            bool isCheckFieldsUpdatedForQnn = appSettings.GetBoolOrDefault(SETTING_CHECK_FIELDS_UPDATED_FOR_QNN, true, logger);

            RetrySettings retryConfiguration = new RetrySettings(
                retries: appSettings.GetIntOrDefault(SETTING_RETRIES, 2, logger),
                baseRetryDelaySeconds: appSettings.GetDoubleOrDefault(SETTING_RETRY_DELAY, 5, logger));
            double retryDelayMultiplier = appSettings.GetDoubleOrDefault(SETTING_RETRY_DELAY_MULTIPLIER, 2.0d, logger);

            double timeoutForInsertResp 
                = appSettings.GetDoubleOrDefault(spSP_InsertResp.SETTING_TIMEOUT, spSP_InsertResp.DEFAULT_TIMEOUT, logger);

            double timeoutForUpdateResp 
                = appSettings.GetDoubleOrDefault(spSP_UpdateResp.SETTING_TIMEOUT, spSP_UpdateResp.DEFAULT_TIMEOUT, logger);

            double timeoutForDeleteAllRespAnsByRespId 
                = appSettings.GetDoubleOrDefault(spSP_DeleteAllRespAnsByRespId.SETTING_TIMEOUT, spSP_DeleteAllRespAnsByRespId.DEFAULT_TIMEOUT, logger);

            double timeoutForUpdateQnnRespAns 
                = appSettings.GetDoubleOrDefault(spSP_UpdateQnnRespAns.SETTING_TIMEOUT, spSP_UpdateQnnRespAns.DEFAULT_TIMEOUT, logger);

            double timeoutForGetSingleResponseData = appSettings.GetDoubleOrDefault(spSP_GetSingleResponseData.SETTING_TIMEOUT, spSP_GetSingleResponseData.DEFAULT_TIMEOUT, logger);

            string dataEditorResubmitPolicyString = appSettings.GetStringOrDefault(SETTING_DATA_EDITOR_RESUBMIT_POLICY, Settings.ResubmitPolicy.Allow.ToString(), logger);
            if (!Enum.TryParse(dataEditorResubmitPolicyString, out Settings.ResubmitPolicy dataEditorResubmitPolicy))
                logger.LogError(nameof(GetInstanceUsingAppSettingsAsync) + " - invalid configuration {0} for setting {1}, falling back to default {2}", dataEditorResubmitPolicyString, SETTING_DATA_EDITOR_RESUBMIT_POLICY, dataEditorResubmitPolicy.ToString());

            string respondentResubmitPolicyString = appSettings.GetStringOrDefault(SETTING_RESPONDENT_RESUBMIT_POLICY, Settings.ResubmitPolicy.Allow.ToString(), logger);
            if (!Enum.TryParse(respondentResubmitPolicyString, out Settings.ResubmitPolicy respondentResubmitPolicy))
                logger.LogError(nameof(GetInstanceUsingAppSettingsAsync) + " - invalid configuration {0} for setting {1}, falling back to default {2}", respondentResubmitPolicyString, SETTING_RESPONDENT_RESUBMIT_POLICY, respondentResubmitPolicy.ToString());

            Settings settings = new Settings(
                retryConfiguration: retryConfiguration, 
                retryDelayMultiplier: retryDelayMultiplier, 
                isUpdateInPlace: isUpdateInPlace,
                isCheckFieldsUpdatedForQnn: isCheckFieldsUpdatedForQnn,
                settingsForInsertResp: new TimeoutSettings(timeoutForInsertResp),
                settingsForUpdateResp: new TimeoutSettings(timeoutForUpdateResp),
                settingsForDeleteAllRespByRespId: new TimeoutSettings(timeoutForDeleteAllRespAnsByRespId),
                settingsForUpdateQnnRespAns: new TimeoutSettings(timeoutForUpdateQnnRespAns),
                settingsForGetSingleResponseData: new TimeoutSettings(timeoutForGetSingleResponseData),
                dataEditorResubmitPolicy: dataEditorResubmitPolicy,
                respondentResubmitPolicy: respondentResubmitPolicy);
            
            return new SurveyResponseUpdaterMkII(logger, auditBatch, request, surveyPlusOptions, settings);
        }

        private readonly ILogger<SurveyResponseUpdaterMkII> logger;
        private readonly AuditBatch auditBatch; //n.b audit struct division is in preflight
        private readonly SaveRequest request;
        private readonly SurveyPlusOptions surveyPlusOptions;
        private readonly Settings configuration;
        private PreflightContext preflight; //rebuilt for each retry
        private SharedTransaction shared; 

        /// <summary>
        /// Constructor. For normal use you are advised to use the provided factory method to obtain
        /// an instance of the updater instead of calling the constructor yourself.
        /// </summary>
        public SurveyResponseUpdaterMkII(
            ILogger<SurveyResponseUpdaterMkII> logger,
            AuditBatch auditBatch,
            SaveRequest request, 
            SurveyPlusOptions surveyPlusOptions,
            Settings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.auditBatch = auditBatch ?? throw new ArgumentNullException(nameof(auditBatch));
            this.request = request ?? throw new ArgumentNullException(nameof(request));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
            this.configuration = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        /// <summary>
        /// This is the entrypoint to the updater, called to update the survey response data in the database.
        /// For certain error conditions (i.e. transient database issues) it will retry the whole transaction 
        /// a number of times (as per config) before giving in. Even on failure a result object is returned so
        /// caller should check this for success or failure status).
        /// </summary>
        public async Task<Result> ExecuteWithRetryLogic()
        {
            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ExecuteWithRetryLogic) + " - called, request={0}, configuration={1}", request, configuration); //(no eventbatch to log yet)
            }

            //n.b. we don't have an overall tx level timeout, but individual procedures can have their own timeouts
            //     which will fail the whole unit-of-work if hit            
            Result result;
            int currentRetryDelayMilliseconds = configuration.RetryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = configuration.RetryConfiguration.Retries;
            bool isToRetry;
            do
            {
                result = await ExecuteOnceAsync(); //<-- HERE IS WHERE WE TRY TO UPDATE THE SURVEY RESPONSE

                //Note that the transaction was started and committed/rolled-back inside the updater
                //so that our delay before retry is outside of it, and the retry will be in a new transaction
                //(it will also have a new audit EventBatch id)
                isToRetry = (result.IsFailure && result.IsRetryable && remainingRetries > 0);
                if (isToRetry)
                {
                    logger.LogWarning(nameof(ExecuteWithRetryLogic) + " - update failed, will retry in {0} milliseconds, request={1}, result={2}, remainingRetries={3}", currentRetryDelayMilliseconds, request, result, remainingRetries);

                    await Task.Delay(currentRetryDelayMilliseconds); //Back-off a while in the hopes it will work later

                    remainingRetries--;
                    currentRetryDelayMilliseconds = (int)Math.Floor(
                        currentRetryDelayMilliseconds * configuration.RetryDelayMultiplier);
                }
            } while (isToRetry);

            //final result after success or gave up retrying
            return result; 
        }

        /// <summary>
        /// Runs the survey save/update logic one time - this method expected to be invoked from a retry loop
        /// It will start a db transaction, update the survey response inside it, and commit (or rollback) the transaction.
        /// Exceptions caught in here will be made available as part of the result object rather than rethrown and the 
        /// caller should check the IsRetryable property to decide whether to try again or give in.
        /// </summary>
        private async Task<Result> ExecuteOnceAsync()
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            shared = new SharedTransaction(); //disposed in finally block below
            try
            {
                //The updater needs to be at the top level so it can do retries
                //in a new transaction for each try but SharedTransaction tries
                //to make the nesting transaparent. If you combine that behaviour with how
                //SqlCommand silently just runs commands outside a transaction when you pass
                //it a doomed transaction then you have a recipe for trouble!
                //So explicitly assert here that we are the ones who are in
                //control of the transaction here (and fail-fast if actually we aren't).
                DbHelper.AssertTransactionNotStartedYet(shared, $"{nameof(SurveyResponseUpdaterMkII)} must control the transaction so you are not allowed to call it from inside an existing transaction");

                await shared.BeginTransactionAsync();

                //..................................
                preflight = await PreflightContext.Prepare(request, surveyPlusOptions, configuration);
                if (PreflightContext.EffectiveActionType.BlockResubmit == preflight.EffectiveAction)
                {
                    throw new SurveyResponseUpdateException(Result.Outcome.ResubmitNotAllowed, "Resubmit is blocked");
                }
                (Guid respId, SurveyResponseVersionToken version)
                    = await (preflight.IsCreatingNewResponse
                    ? CreateNewSurveyResponse()
                    : UpdateExistingSurveyResponse());
                bool isComplete = await UpdateResponseStatus();
                ChangeDataResponce changeDataResponse = PrepareDataForClient(respId, version, isComplete);
                //..................................

                await shared.CommitAsync();

                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                Result result = Result.Success(changeDataResponse, duration);

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(ExecuteWithRetryLogic) + " - success, EventBatch={0}, preflight={1}, result={2}", auditBatch.EventBatch, preflight, result);
                }

                return result;
            }
            catch (Exception failure)
            {
                //Warning: preflight will be null here if exception was raised during its preparation

                await shared.RollbackAsync();
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;

                Result result;
                if (failure is LegacyTimestampCheckFailedException timestampEx)
                {   //legacy behaviour, TODO review with an eye to removing this
                    //n.b. if we reach here we know there IS an existing response
                    Debug.Assert(preflight.IsUpdatingExistingResponse);
                    ChangeDataResponce changeDataResponse = PrepareDataForClient(preflight.ExistingResponseId.Value, request.VersionUpdating, preflight.Origin.IsComplete);
                    result = Result.FakeSuccess(timestampEx, changeDataResponse, duration);
                    logger.LogWarning(nameof(ExecuteOnceAsync) + " - legacy timestamp check failed - EventBatch={0}, IsAutoSave={1}, {2}", auditBatch.EventBatch, request.IsAutoSave, timestampEx.Message);
                    return result;
                }
                else if(failure is SurveyResponseUpdateException theUsualSuspects)
                {
                    result = Result.Failed(failure, duration);
                    //This failure is some conditions we checked for explicitly and raised an exception to jump to here
                    //so we don't want to clutter the log with these (unless at debug level).
                    logger.LogDebug(theUsualSuspects, nameof(ExecuteOnceAsync) + " - failed, EventBatch={0}, Request={1}, preflight={2}, result={3}", auditBatch.EventBatch, request, preflight, result);
                    return result;
                }
                else
                {   
                    result = Result.Failed(failure, duration);
                    //Anything else we want to capture the stacktrace in the logs at error level before continuing
                    logger.LogError(failure, nameof(ExecuteOnceAsync) + " - failed unexpectedly, EventBatch={0}, Request={1}, preflight={2}, result={3}", auditBatch.EventBatch, request, preflight, result);
                    return result;
                }
            }
            finally
            {
                preflight = null;
                shared.Dispose();
                shared = null;
            }
        }

        /// <summary>
        /// Logic flow for the save if there is no existing data (from sample or pre-population) 
        /// for this survey response yet. Will return the id of the new response and its version token.
        /// </summary>
        private async Task<(Guid, SurveyResponseVersionToken)> CreateNewSurveyResponse()
        {
            await EnforceMaxResponseQuota();
            EnforceStratumQuotas();
            (Guid newResponseId, SurveyResponseVersionToken version) = await InsertResp();
            await InsertAllAnswers(newResponseId);
            return (newResponseId, version);
        }

        /// <summary>
        /// Logic flow for the update if there is already an existing survey response 
        /// (from sample or from pre-population) to be updated.
        /// Will return the id of the existing response and its version token.
        /// </summary>
        private async Task<(Guid, SurveyResponseVersionToken)> UpdateExistingSurveyResponse()
        {
            LegacyTimestampCheck();
            EnforceStratumQuotas();
            SurveyResponseVersionToken updatedVersion = await UpdateResp();
            if (configuration.IsUpdateInPlace)
            {
                await UpdateChangedAnswers();
            }
            else
            {   //Legacy delete-then-insert (to be removed in some future version)
                await DeleteAllAnswers(preflight.ExistingResponseId.Value);
                await InsertAllAnswers(preflight.ExistingResponseId.Value);
            }

            return (preflight.ExistingResponseId.Value, updatedVersion);
        }

        /// <summary>
        /// Legacy timestamp comparison to silently ignore update request if the response was 
        /// updated after the timestamp submitted from the client. If the check fails a LegacyTimestampCheckFailedException
        /// is raised to cancel the update process.
        /// </summary>
        private void LegacyTimestampCheck()
        {
            if(surveyPlusOptions.IsEnableResponseTimestampCheck && request.IsAutoSave)
            {
                //Legacy(?) timestamp check, reproduced from the old SurveyResponseUpdater
                //qnnResp is the existing response in qnn_resp table
                //CurrentTimeStamp = clientside time string passed in a "timestamp" header in the request
                //previous code was: if (((DateTime?)qnnResp[Constants.FieldName.UpdatedDate] > DateTime.Parse(CurrentTimeStamp) || (DateTime?)qnnResp[Constants.FieldName.DateComplete] > DateTime.Parse(CurrentTimeStamp)) && IsAutoSave)
                //then it is considered updated since request so return 'fake' success value without saving

                //TODO - 20241016 - to review the following check, is it redundant now because of the version token?
                //does it actually make sense? Should it return fake success or fail explicitly?
                //The ClientTimestamp is submitted from client. Is it really 'current', or from a previous update
                //like our new token? Or is it from the client's clock - which could be anything!
                // 20250309 - it is using client's clock, see: swz-app/src/thunks/index.jsx 
                // TLDR; if the updated or completed dates are in the future from the client machine's perspective
                // then we tell the client application that the save was a success but we don't actually save it
                DateTime timestampFromClient = request.ClientTimestamp;
                DateTime updatedDate = preflight.Origin.UpdatedDate.Value;
                DateTime? dateComplete = preflight.Origin.DateComplete; //when null its use with > or < results in null (due to 'lifted operators')
                bool isUpdatedSinceRequest = (updatedDate > timestampFromClient || dateComplete > timestampFromClient);

                if(logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(LegacyTimestampCheck) + " - timeStampFromClient={0}, updatedDate={1}, dateComplete={2}, isUpdatedSinceRequest={3}, eventBatch={4}", timestampFromClient, updatedDate, dateComplete, isUpdatedSinceRequest, auditBatch.EventBatch);
                }

                if (isUpdatedSinceRequest)
                {
                    throw new LegacyTimestampCheckFailedException(timestampFromClient, updatedDate, dateComplete);
                }
            }
        }

        /// <summary>
        /// Delete the previous answers in the existing response (wipes the related QNN_RESP_ANS rows)
        /// This is used for the legacy delete-then-insert update behaviour and will be removed in a future version
        /// </summary>
        private async Task DeleteAllAnswers(Guid respId)
        {
            DbHelper.AssertTransactionStartedAlready(shared);
            ILogger<spSP_DeleteAllRespAnsByRespId> deleteAllRespAnsByRespIdLogger
                = (ILogger<spSP_DeleteAllRespAnsByRespId>)DefaultApplicationLogging.CreateLogger<spSP_DeleteAllRespAnsByRespId>();
            spSP_DeleteAllRespAnsByRespId spSP_DeleteAllRespAnsByRespId
                = new spSP_DeleteAllRespAnsByRespId(deleteAllRespAnsByRespIdLogger, configuration.SettingsForDeleteAllRespAnsByRespId);

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DeleteAllAnswers) + " - EventBatch={0}, spSP_DeleteAllRespAnsByRespId={1}, respId={2}", auditBatch.EventBatch, spSP_DeleteAllRespAnsByRespId, respId);
            }

            await spSP_DeleteAllRespAnsByRespId.DeleteResp(
                qnnRespId: respId,
                structDivisionId: preflight.StructDivisionIdForAuditPurposes,
                auditBatch: auditBatch);
        }

        /// <summary>
        /// Uses SqlBulkCopy to write all the answers to the database using the specified respId
        /// and log an audit event for it. This is used when creating a new response and also by
        /// the legacy delete-then-insert update behaviour if update-in-place is disabled.
        /// </summary>
        private async Task InsertAllAnswers(Guid respId)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(InsertAllAnswers) + " - called, EventBatch={0}, respId={1}", auditBatch.EventBatch, respId);
            }

            DbHelper.AssertTransactionStartedAlready(shared);
            DataTable dataForQnnRespAns = ReadAllAnswersIntoDataTableForInsert(respId);
            DbHelper.BulkCopyDataTable(dataForQnnRespAns, shared, timeoutSeconds: 120);
            if (auditBatch.AuditOn)
            {
                await SurveyPlusAuditHelper.BatchImport(
                    tableName: Constants.ModelName.QNN_RESP_ANS,
                    auditBatch: auditBatch,
                    auditStructDivisionId: preflight.StructDivisionIdForAuditPurposes,
                    insertedData: SurveyPlusAuditHelper.SerialiseDataTableToJson(dataForQnnRespAns));
            }


            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(InsertAllAnswers) + " - EventBatch={0}, inserted {1} answers for ExistingResponseId={2}", auditBatch.EventBatch, dataForQnnRespAns.Rows.Count, preflight.ExistingResponseId);
            }
        }

        /// <summary>
        /// Update-in-place logic to update an existing survey response's answer data. Will use a stored procedure
        /// to update only those qnn_resp_ans rows that have changed. 
        /// </summary>
        private async Task UpdateChangedAnswers()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UpdateChangedAnswers) + " - called, EventBatch={0}, ExistingResponseId={1}", auditBatch.EventBatch, preflight.ExistingResponseId.Value);
            }

            DataTable updates = await ReadChangedAnswersIntoDataTableForUpdate();
            if(updates.Rows.Count > 0)
            {   //Only call the procedure if there are changes
                ILogger<spSP_UpdateQnnRespAns> updateQnnRespAnsLogger = (ILogger<spSP_UpdateQnnRespAns>)DefaultApplicationLogging.CreateLogger<spSP_UpdateQnnRespAns>();
                spSP_UpdateQnnRespAns spSP_UpdateQnnRespAns
                    = new spSP_UpdateQnnRespAns(updateQnnRespAnsLogger, configuration.SettingsForUpdateQnnRespAns);

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(UpdateChangedAnswers) + " - EventBatch={0}, spSP_UpdateQnnRespAns={1}, updating {2} answers for ExistingResponseId={3}", auditBatch.EventBatch, spSP_UpdateQnnRespAns, updates.Rows.Count, preflight.ExistingResponseId);
                }

                await spSP_UpdateQnnRespAns.ExecuteAsync(
                    respId: preflight.ExistingResponseId.Value, 
                    updates, 
                    auditBatch, 
                    structDivisionIdForAudit: preflight.StructDivisionIdForAuditPurposes);
            }
            else
            {   //No-op if there are no changes
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(UpdateChangedAnswers) + " - EventBatch={0}, no changed answers for ExistingResponseId={1}, (procedure not called)", auditBatch.EventBatch, preflight.ExistingResponseId);
                }
            }
        }

        /// <summary>
        /// MaxResponse (Overall) Logic
        /// Fail if the survey has already reached its maximum responses and we intend to create a new response 
        /// </summary>
        private async Task EnforceMaxResponseQuota()
        {
            //The logic here follows the existing behaviour of the old updater which only blocks
            //for reaching the MaxResponses quota when there isn't an existing response and we are
            //about to create one (in contrast to the strata check which blocks at completion time).
            //(This is a less common case because the respondent dashboard should also disable the
            //survey edit button when it sees the quota is reached)
            if(preflight.IsCreatingNewResponse)
            {
                if (preflight.MaxResponse != Constants.Unlimited)
                {
                    int currentResponseCount 
                        = await ResponseApplication.GetOverallSurveyResponseCount(preflight.DplyId, ResponseApplication.SurveyResponseCountType.Completed);
                    bool isMaxResponseReached 
                        = ResponseApplication.HasReachedMaxResponses(preflight.MaxResponse, currentResponseCount);
                    if (isMaxResponseReached)
                        throw new OverallQuotaReachedException(preflight.MaxResponse, currentResponseCount);
                }
            }
        }

        /// <summary>
        ///  Stratum Quota Logic
        ///  (we only block save for this on the server-side when submitting first time, saves are always allowed
        ///  even if the response is already completed but the strata was changed (this is a known limitation in
        ///  our current implementation and we may revise it in a future version)).
        /// </summary>
        private void EnforceStratumQuotas()
        {
            if(preflight.IsStrataFilled && preflight.IsFirstSubmission)
            {
                throw new StratumQuotaReachedException(); //n.b this fail will prevent the latest changes from saving
            }
        }

        /// <summary>
        /// Checks if the Status needs to change based on the business-logic and if so will use a stored procedure
        /// to update the row in qnn_dply_sample_info. Returns a flag indicating whether this response is considered
        /// 'complete'.
        /// </summary>
        private async Task<bool> UpdateResponseStatus()
        {
            QnnStatusId newStatus;
            bool isComplete;

            switch (preflight.EffectiveAction)
            {
                case PreflightContext.EffectiveActionType.Submit:
                    //Normal survey will go to submitted status on submission, multiple response will stay in-progress
                    newStatus = preflight.IsMultipleResponseFeaturesEnabled
                        ? preflight.Status
                        : QnnStatusId.Submitted;
                    isComplete = true;
                    break;

                case PreflightContext.EffectiveActionType.Save:
                    //On first save would change to in-progress
                    newStatus = (preflight.Status.IsPending || preflight.Status.IsAcknowledged)
                        ? QnnStatusId.InProgress
                        : preflight.Status;
                    isComplete = preflight.IsCreatingNewResponse 
                        ? false 
                        : preflight.Origin.IsComplete;
                    break;

                case PreflightContext.EffectiveActionType.BlockResubmit:
                    throw new InvalidOperationException("Blocked action - execution should not reach here");

                default:
                    throw new NotImplementedException(request.RequestedAction.ToString());
            }

            bool needUpdate = !newStatus.Equals(preflight.Status);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(UpdateResponseStatus) + " - EventBatch={0}, requestedAction={1}, effectiveAction={2}, isComplete={3}, newStatus={4}, needUpdate={5}", auditBatch.EventBatch, request.RequestedAction, preflight.EffectiveAction, isComplete, newStatus, needUpdate);

            if (needUpdate)
            {
                DbHelper.AssertTransactionStartedAlready(shared);
                spSP_UpdateDplySampleInfo spSP_UpdateDplySampleInfo
                    = await spSP_UpdateDplySampleInfo.GetInstanceUsingAppSettingsAsync();
                await spSP_UpdateDplySampleInfo.UpdateDsiStatus(
                    id: request.DplySampleInfoId,
                    structDivisionId: preflight.StructDivisionIdForAuditPurposes,
                    oldStatus: preflight.Status,
                    newStatus: newStatus,
                    auditBatch: auditBatch);
            } //end if needUpdate

            return isComplete;
        }

        /// <summary>
        /// Call a stored procedure to insert a new row in qnn_resp.
        /// Returns the response id and version token.
        /// </summary>
        private async Task<(Guid, SurveyResponseVersionToken)> InsertResp()
        {
            DbHelper.AssertTransactionStartedAlready(shared);
            OriginIndicators origin = OriginIndicators.ForNewResponseCreation(request, preflight);
            Guid respId = Guid.NewGuid();
            ILogger<spSP_InsertResp> insertRespLogger
                = (ILogger<spSP_InsertResp>)DefaultApplicationLogging.CreateLogger<spSP_InsertResp>();
            spSP_InsertResp spSP_InsertResp = new spSP_InsertResp(insertRespLogger, configuration.SettingsForInsertResp);

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(InsertResp) + " - EventBatch={0}, spSpInsertResp={0}, respId={1}", auditBatch.EventBatch, spSP_InsertResp, respId);
            }

            await spSP_InsertResp.InsertResponse(
                auditBatch: auditBatch,
                auditStructDivisionId: preflight.StructDivisionIdForAuditPurposes,
                newRespId: respId,
                updatedDate: origin.UpdatedDate.Value,
                qnnId: preflight.QnnId,
                listSampleId: preflight.ListSampleId,
                dplyId: preflight.DplyId,
                dateStart: origin.DateStart.Value,
                dateComplete: origin.DateComplete,
                lastSavedPage: request.LastSavedPage,
                anonymousId: request.AnonymousId,
                ipAddress: request.IpAddress,
                initialResponseAs: origin.InitialResponseAs,
                initialResponseBy: origin.InitialResponseBy,
                initialResponseVia: origin.InitialResponseVia,
                initialResponseUserId: origin.InitialResponseUserId,
                lastResponseAs: origin.LastResponseAs,
                lastResponseBy: origin.LastResponseBy,
                lastResponseVia: origin.LastResponseVia,
                userId: origin.UserId,
                completedResponseAs: origin.CompletedResponseAs,
                completedResponseBy: origin.CompletedResponseBy,
                completedResponseVia: origin.CompletedResponseVia,
                completedResponseUserId: origin.CompletedResponseUserId,
                strata: preflight.Strata);
            return (respId, SurveyResponseVersionToken.FromUpdatedDate(origin.UpdatedDate.Value));
        }

        /// <summary>
        /// Call a stored procedure to update the existing row in qnn_resp.
        /// Returns the version token.
        /// </summary>
        private async Task<SurveyResponseVersionToken> UpdateResp()
        {
            DbHelper.AssertTransactionStartedAlready(shared);
            OriginIndicators updatedOrigin = preflight.Origin.UpdatedForSave(request, preflight);
            ILogger<spSP_UpdateResp> updateRespLogger
                = (ILogger<spSP_UpdateResp>)DefaultApplicationLogging.CreateLogger<spSP_UpdateResp>();
            spSP_UpdateResp spSP_UpdateResp
                = new spSP_UpdateResp(updateRespLogger, configuration.SettingsForUpdateResp);

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UpdateResp) + " - EventBatch={0}, spSP_UpdateResp={1}, ExistingResponseId={2}", auditBatch.EventBatch, spSP_UpdateResp, preflight.ExistingResponseId);
            }

            await spSP_UpdateResp.UpdateResponse(
                auditBatch: auditBatch,
                auditStructDivisionId: preflight.StructDivisionIdForAuditPurposes,
                existingRespId: preflight.ExistingResponseId.Value,
                updatedDate: updatedOrigin.UpdatedDate.Value,
                dateStart: updatedOrigin.DateStart,
                dateComplete: updatedOrigin.DateComplete,
                lastSavedPage: request.LastSavedPage,
                ipAddress: request.IpAddress,
                initialResponseAs: updatedOrigin.InitialResponseAs,
                initialResponseBy: updatedOrigin.InitialResponseBy,
                initialResponseVia: updatedOrigin.InitialResponseVia,
                initialResponseUserId: updatedOrigin.InitialResponseUserId,
                lastResponseAs: updatedOrigin.LastResponseAs,
                lastResponseBy: updatedOrigin.LastResponseBy,
                lastResponseVia: updatedOrigin.LastResponseVia,
                userId: updatedOrigin.UserId,
                completedResponseAs: updatedOrigin.CompletedResponseAs,
                completedResponseBy: updatedOrigin.CompletedResponseBy,
                completedResponseVia: updatedOrigin.CompletedResponseVia,
                completedResponseUserId: updatedOrigin.CompletedResponseUserId,
                strata: preflight.Strata);
            return SurveyResponseVersionToken.FromUpdatedDate(updatedOrigin.UpdatedDate.Value);
        }

        /// <summary>
        /// Create a DataTable which can be used with SqlBulkCopy to insert 
        /// all the answer data for this response into qnn_resp_ans
        /// </summary>
        private DataTable ReadAllAnswersIntoDataTableForInsert(Guid respId)
        {
            DataTable dataForQnnRespAns = ResponseApplication.DataTableForQnnRespAns();
            foreach (Guid fieldId in preflight.FieldIds)
            {
                string alias = preflight.AliasFor(fieldId);
                string ansVal = request.GetAnsVal(alias);
                bool isPrePopulated = request.IsPrePopulated(alias); //such fields are highlighted in survey UI
                dataForQnnRespAns.Rows.Add(respId, fieldId, ansVal, isPrePopulated);
            }
            return dataForQnnRespAns;
        }

        /// <summary>
        /// Create a DataTable which can be used with a stored procedure to update-in-place 
        /// only those existing rows in qnn_resp_ans that need to be changed
        /// </summary>
        /// <returns></returns>
        private async Task<DataTable> ReadChangedAnswersIntoDataTableForUpdate()
        {
            Debug.Assert(preflight.ExistingAnswers != null);
            Debug.Assert(preflight.FieldCount == preflight.ExistingAnswers.Count);

            bool isLoggingAlias = logger.IsEnabled(LogLevel.Debug);
            List<string> changedAlias = isLoggingAlias ? new List<string>() : null;

            DataTable respAnsUpdate = new DataTable();
            respAnsUpdate.Columns.Add("Id", typeof(Guid));
            respAnsUpdate.Columns.Add("NewAnsVal", typeof(string));
            respAnsUpdate.Columns.Add("NewIsPrePopulated", typeof(bool));
            foreach(ImmutableDictionary<string, object> oldAns in preflight.ExistingAnswers)
            {
                Guid id = (Guid)oldAns["Id"];
                Guid qnnFieldId = (Guid)oldAns["QnnFieldId"];
                string alias = preflight.AliasFor(qnnFieldId); //will fail-fast if Id is not valid for this qnn
                object oldAnsVal = oldAns["AnsVal"];
                string oldAnswer = DBNull.Value.Equals(oldAnsVal) ? null : (string)oldAnsVal;
                string newAnswer = request.GetAnsVal(alias); 
                bool isAnswerChanged = !StringComparer.OrdinalIgnoreCase.Equals(oldAnswer, newAnswer);
                if (isAnswerChanged)
                {
                    object newAnsVal = (object)newAnswer ?? DBNull.Value;
                    bool newIsPrePopulated = request.IsPrePopulated(alias); //such fields get highlighted in survey UI
                    respAnsUpdate.Rows.Add(id, newAnsVal, newIsPrePopulated);
                    if (isLoggingAlias) changedAlias.Add(alias);
                }
            }

            if (isLoggingAlias)
            {
                logger.LogDebug(nameof(ReadChangedAnswersIntoDataTableForUpdate) + " - EventBatch={0}, {1} changed answers, IsAutoSave={2}, aliases={3}", auditBatch?.EventBatch, respAnsUpdate?.Rows?.Count, request?.IsAutoSave, changedAlias);
            }

            return respAnsUpdate;
        }

        /// <summary>
        /// Prepares an instance of ChangeDataResponce that the updater's caller can send back to client-side. This
        /// contains current updated answer data as well as a number of other values needed by the client.
        /// </summary>
        private ChangeDataResponce PrepareDataForClient(Guid respId, SurveyResponseVersionToken version, bool isComplete)
        {
            //Prepare the success response item   
            Dictionary<string, object> responseEntity = request.GetDataAsNewDictionary();

            //TODO - I don't understand the purpose of this check (when is it NOT a survey here?)
            bool isReturnRedirect = !responseEntity.ContainsKey(Constants.SurveyResponseProperties.IsSurvey); 
            if (isReturnRedirect)
            {
                //n.b. It seems that QNN_DPLY.CompleteAction is not used any more? (Seems like is always 'C')
                //     TODO - the column remains in the db, we should review to see if its ok to remove it                
                responseEntity[Constants.SurveyResponseProperties.IsSurvey] = true;
                responseEntity[Constants.SurveyResponseProperties.SurveyRedirectUrl] = preflight.CompleteURL;
                responseEntity[Constants.SurveyResponseProperties.UrlFilter] = "?dlsi=" + request.DplySampleInfoId;
            }

            bool isSurveyRedirect
                = !string.IsNullOrWhiteSpace(preflight.CompleteURL)
                && (request.RequestedAction == SaveRequest.RequestedActionType.Submit)
                && (request.PersonUpdatingIs == SurveyUserType.Respondent);

            responseEntity[Constants.SurveyResponseProperties.SurveyRedirect] = isSurveyRedirect;
            responseEntity[Constants.SurveyResponseProperties.QnnRespId] = respId;
            responseEntity[Constants.SurveyResponseProperties.SurveyResponseVersion] = version.Value;
            responseEntity[Constants.SurveyResponseProperties.IsStrataFilled] = preflight.IsStrataFilled;
            responseEntity[Constants.SurveyResponseProperties.IsComplete] = isComplete;

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(PrepareDataForClient) + " - EventBatch={0}, isSurveyRedirect={1}, QnnRespId={2}, SurveyResponseVersion={3}, IsStrataFilled={4}, IsComplete={5}", auditBatch.EventBatch, isSurveyRedirect, respId, version, preflight.IsStrataFilled, isComplete);

            return new ChangeDataResponce()
            {
                EntityId = null,
                Entity = responseEntity,
            };
        }
    } //end of SurveyResponseUpdaterMkII
}
