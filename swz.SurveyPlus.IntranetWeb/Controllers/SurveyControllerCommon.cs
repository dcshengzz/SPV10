using System;
using System.Linq;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.Clover.Core.Metadata;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Diagnostics;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Some common code used by DataEditController and IntegrationApiController in relation to 
    /// reading and writing survey data
    /// </summary>
    public class SurveyControllerCommon
    {
        public class NotSurveyFormException : Exception
        {
            public Form Form { get; private set; }

            public NotSurveyFormException(Form form) : base("Not a survey form")
            {
                this.Form = form;
            }
        }

        /// <summary>
        /// Thrown by TryGetResponseIds if there is an error reading the ids (as opposed to mere failure)
        /// We factor out all the fiddly work of formatting the message to here so the code can throw it more succinctly
        /// </summary>
        public class ResponseIdsExtractionException : Exception
        {
           


            public static ResponseIdsExtractionException WrappingException(Exception innerException)
            {
                return new ResponseIdsExtractionException("Unexpected exception attempting to extract ids from the request", innerException);
            }

            public static ResponseIdsExtractionException InvalidDlsiSegment(Uri refererUri, string dlsiSegment)
            {
                return new ResponseIdsExtractionException(
                    $"Invalid DLSI segment in refererUri {fmtRU(refererUri)} - found {fmtSeg(dlsiSegment)}")
                    { RefererUri = refererUri, DlsiSegment = dlsiSegment };
            }

            public static ResponseIdsExtractionException InvalidRespIdSegment(Uri refererUri, string dlsiSegment, string respIdSegment)
            {
                return new ResponseIdsExtractionException(
                    $"Invalid RespId segment in refererUri {fmtRU(refererUri)} - found {fmtSeg(respIdSegment)}") 
                    { RefererUri = refererUri, DlsiSegment = dlsiSegment, RespIdSegment = respIdSegment };
            }

            //formatters for the uri and segments so the log is easier to read when the exception message is logged
            //nb: the following two don't escape any quotes in the strings though
            private static string fmtRU(Uri refererUri) { return (refererUri == null) ? "(null)" : $"\"{refererUri.ToString()}\""; }
            private static string fmtSeg(string segment) { return (segment == null) ? "(null)" : $"\"{segment}\""; }

            // // // //

            public Uri RefererUri { get; private set; } = null;

            public string DlsiSegment { get; private set; } = null;

            public string RespIdSegment { get; private set; } = null;

            private ResponseIdsExtractionException(string message)
                : base(message) { }

            private ResponseIdsExtractionException(string message, Exception innerException)
                : base(message, innerException) { }
        }

        /// <summary>
        /// Determine the dlsi, respId, anonymousId based on request headers (notably the referer)
        /// Will throw a ResponseIdsExtractionException if the expected headers aren't valid
        /// </summary>
        public static (Guid dplySampleInfoId, Guid? qnnRespId, Guid anonymousId) SurveyResponseIds(HttpRequest request)
        {
            Guid dplySampleInfoId = Guid.Empty;
            Guid? qnnRespId = null;
            Guid anonymousId = Guid.Empty;
            try
            {
                //Extract the Anonymous Id if an Anonymous cookie was provided (or we'll use Empty if not)
                if (Guid.TryParse(request.Cookies[Constants.SwzAnonymous.AnonymousIdCookie].GetAnonymousId(), out var anonymousIdFromCookie))
                {
                    anonymousId = anonymousIdFromCookie;
                }

                Uri refererUri = ControllerUtilities.Referer(request); //n.b. throws exception if missing

                //Extract the dlsi (id in QNN_DPLY_SAMPLE_INFO) from referer
                //This will always be the LAST segment, but the number of segments can vary depending on whether there is a respId in there
                //example1: http://localhost:48800/form/TrainingFINAL20210214/respid/ff1e0308-4fe5-4a7e-a4c8-32bdaf82ae07/dlsi/3eddebad-d53f-4fb5-bb33-7f318daa97c5 <-- has a respId
                //                                                                   |------------ respId --------------|      |--------------- dsi --------------|
                //example2: http://localhost:48800/form/TrainingFINAL20210214/dlsi/3eddebad-d53f-4fb5-bb33-7f318daa97c5  <-- no resp id (eg: no response yet)
                //
                //example3: http://localhost:48800/form/TrainingFINAL20210214/view/respid/ff1e0308-4fe5-4a7e-a4c8-32bdaf82ae07/dlsi/3eddebad-d53f-4fb5-bb33-7f318daa97c5
                //                                                            view        |------------ respId --------------|      |-------------- dsi ---------------|
                string dlsiSegment = refererUri.Segments?[refererUri.Segments.Length - 1];
                if (Guid.TryParse(dlsiSegment, out Guid dlsi))
                    dplySampleInfoId = dlsi;
                else
                    throw ResponseIdsExtractionException.InvalidDlsiSegment(refererUri,   dlsiSegment);

                //Extract the respId but only if its applicable (otherwise null)
                if (refererUri.Segments.Length == 7 || refererUri.Segments.Length == 8)
                {
                    string respIdSegment = refererUri.Segments?[refererUri.Segments.Length - 3].Trim('/');
                    if (Guid.TryParse(respIdSegment, out Guid respId))
                        qnnRespId = respId;
                    else
                        throw ResponseIdsExtractionException.InvalidRespIdSegment(refererUri, dlsiSegment, respIdSegment);
                }

                return (dplySampleInfoId, qnnRespId, anonymousId);
            }
            catch (ResponseIdsExtractionException)
            {
                throw;
            }
            catch (Exception e)
            {
                throw ResponseIdsExtractionException.WrappingException(e);
            }
        }

        /// <summary>
        /// Return 'data' object that takes the place of the survey response data if it couldnt be read.
        /// This will include a false success code and the message
        /// </summary>
        public static DynamicEntity SurveyResponseDataForFail(string msg, string details = null, bool formIsReadOnly = false)
        {
            //TODO - why do we use DynamicEntity here, is this still relevant, or can use a normal dictionary
            //       seeing as how callers seem to just want the dictionary anyway
            var failed = new DynamicEntity();
            failed.Dictionary.Add("formIsReadOnly", formIsReadOnly);
            failed.Dictionary.Add("success", false);
            failed.Dictionary.Add("message", msg);
            failed.Dictionary.Add("details", details);
            return failed;
            //to return as json use Json(failed.ToDictionary());
        }

        /// <summary>
        /// Create an appropriate response updater object for updating the survey data for a Respondent request
        /// based on values in the request headers.
        /// </summary>
        public static SurveyResponseUpdater CreateUpdaterForRespondent(HttpRequest Request, QNN_SAMPLE sample)
        {
            if (sample == null) throw new ArgumentNullException(nameof(sample));
            return CreateUpdater(Request, sample);
        }

        /// <summary>
        /// Create an appropriate response updater object for updating the survey data for a Data Editor request
        /// based on values in the request headers.
        /// </summary>
        [Obsolete]
        public static SurveyResponseUpdater CreateUpdaterForDataEditor(HttpRequest Request)
        {
            return CreateUpdater(Request, null);
        }

        [Obsolete]
        private static SurveyResponseUpdater CreateUpdater(HttpRequest request, QNN_SAMPLE sample)
        {
            bool isForDataEditor = (sample == null);

            (Guid dplySampleInfoId, Guid? qnnRespId, Guid anonymousId) = SurveyResponseIds(request);
            if (isForDataEditor) anonymousId = Guid.Empty;

            string autoSaveHeader = request.Headers["autosave"];
            bool autoSave = autoSaveHeader?.Equals("True", StringComparison.InvariantCultureIgnoreCase) ?? false;
            string referer = request.Headers["Referer"]; //page that called controller has in its url some ids we'll need
            string timestamp = request.Headers["timestamp"];
            string ipAddress = request.Headers["ipaddress"];
            
            //Now we have marshalled the information we need we can create and configure an updater to do the work
            SurveyResponseUpdater updater = new SurveyResponseUpdater(dplySampleInfoId);
            updater.QnnSample = sample; //will be null for a data editor
            updater.DataEditor = isForDataEditor ? CloverRuntime.Security.CurrentUser : null; //will be null for a respondent
            updater.QnnRespId = qnnRespId ?? Guid.Empty; //TODO - do we actually need to set this here?
            updater.IpAddress = ipAddress;
            updater.Referer = referer;
            updater.AnonymousId = anonymousId;
            updater.CurrentTimeStamp = (timestamp != null) ? timestamp : null; //TODO - response updater will hit an error if this is null (20240412)
            updater.IsAutoSave = autoSave;

            return updater;
        }

        private static async Task<SurveyResponseUpdaterMkII> CreateUpdaterMkII(
            SurveyPlusOptions surveyPlusOptions, 
            HttpRequest request,
            Guid? forDataEditorId,
            Guid? forRespondentId)
        {
            string saveDraftHeader = request.Headers["savedraft"];
            bool isSave = saveDraftHeader?.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            SurveyResponseUpdaterMkII.SaveRequest.RequestedActionType action = isSave
                ? SurveyResponseUpdaterMkII.SaveRequest.RequestedActionType.Save
                : SurveyResponseUpdaterMkII.SaveRequest.RequestedActionType.Submit;
            
            (Guid dplySampleInfoId, Guid? qnnRespId, Guid anonymousId) = SurveyResponseIds(request);
            
            string dataAsJson = request.Form["data"].FirstOrDefault();

            string autoSaveHeader = request.Headers[Constants.HeaderNames.AutoSave];
            bool isAutoSave = autoSaveHeader?.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            string timestamp = request.Headers[Constants.HeaderNames.TimeStamp]; //a custom header set by our frontend
            if (!DateTime.TryParse(timestamp, out DateTime clientTimestamp))
                throw new InvalidOperationException($"Missing or invalid custom timestamp header in request: {timestamp}");
            string ipAddress = request.Headers["ipaddress"];

            SurveyResponseUpdaterMkII.SaveRequest saveRequest = new SurveyResponseUpdaterMkII.SaveRequest(
                clientTimestamp: clientTimestamp,
                action: action,
                dplySampleInfoId: dplySampleInfoId,
                providedRespId: qnnRespId,
                forDataEditorId: forDataEditorId,
                forRespondentId: forRespondentId,
                anonymousId: anonymousId,
                dataAsJson: dataAsJson,
                isAutosave: isAutoSave,
                ipAddress: ipAddress);
            SurveyResponseUpdaterMkII updater 
                = await SurveyResponseUpdaterMkII.GetInstanceUsingAppSettingsAsync(saveRequest, surveyPlusOptions);
            return updater;
        }

        /// <summary>
        /// Get the data to update the survey response from the request, and whether this is a draft save or 
        /// for a submission.
        /// </summary>
        [Obsolete]
        public static (SurveyResponseUpdater.Action action, string data) DataForUpdate(HttpRequest request)
        {
            string saveDraftHeader = request.Headers["savedraft"];
            bool saveDraft = saveDraftHeader?.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            SurveyResponseUpdater.Action action = saveDraft
                    ? SurveyResponseUpdater.Action.Save
                    : SurveyResponseUpdater.Action.Submit;
            string data = request.Form["data"].FirstOrDefault(); 
            return (action, data);
        }

        /// <summary>
        /// Returns an object for the controller to serialise as json and return indicating the result of the survey
        /// data update request.
        /// </summary>
        [Obsolete]
        public static object SurveyResponseUpdateResult(SurveyResponseUpdater.UpdateResult result)
        {
            switch (result.Type)
            {
                case SurveyResponseUpdater.UpdateResult.ResultType.Success:
                    //TODO - use a Dictionary or Expando for the below
                    var res = new
                    {
                        Item = result.ChangeDataResponse,
                        Success = true,
                        Message = result.Message,
                    };
                    return res;

                case SurveyResponseUpdater.UpdateResult.ResultType.Failed:
                    DynamicEntity failed = SurveyResponseDataForFail(result.Message);
                    return failed.ToDictionary();

                case SurveyResponseUpdater.UpdateResult.ResultType.Error:
                    return new FailResponse(result.Message);

                default:
                    throw new NotSupportedException("Unimplemented ResultType " + result.Type.ToString());
            }
        }

        public static async Task<object> UpdateSurveyResponseAsync(
            ILogger logger,
            HttpContext httpContext, 
            SurveyPlusOptions surveyPlusOptions, 
            Clover.Core.Security.User forDataEditor, 
            QNN_SAMPLE forRespondent)
        {
            if (surveyPlusOptions.IsUseLegacySurveyResponseUpdater)
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                //Old updater - to remove once new one is ready
                SurveyResponseUpdater updater = (forDataEditor==null)
                    ? CreateUpdaterForRespondent(httpContext.Request, forRespondent)
                    : CreateUpdaterForDataEditor(httpContext.Request);
                updater.IsEnableResponseVersionCheck = surveyPlusOptions.IsEnableResponseVersionCheck;
                (SurveyResponseUpdater.Action saveOrSubmit, string data) = DataForUpdate(httpContext.Request);
                SurveyResponseUpdater.UpdateResult result = await updater.Update(saveOrSubmit, data);

                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogDebug(nameof(UpdateSurveyResponseAsync) + " - (used legacy updater), duration={0} milliseconds, result={1}", duration, result);
                return SurveyResponseUpdateResult(result);
            }
            else
            {
                SurveyResponseUpdaterMkII updater 
                    = await CreateUpdaterMkII(surveyPlusOptions, httpContext.Request, forDataEditor?.Id, forRespondent?.Id);

                SurveyResponseUpdaterMkII.Result result = await updater.ExecuteWithRetryLogic();

                if (result.IsSuccess)
                {   //WIN
                    Dictionary<string, object> successReturn = new Dictionary<string, object>();
                    successReturn["success"] = true;
                    successReturn["item"] = result.ChangeDataResponse;
                    successReturn["message"] = result.Message;
                    //successReturn["formIsReadOnly"] = false; //TODO - should this be recalculated based on Business Logic? (in updater and not here)
                    return successReturn;
                }
                else
                {   //FAIL
                    if (result.HasException && result.Exception is PermissionException pex)
                    {
                        //Updater logs errors at error level already, here we log some more information specific to a
                        //permission error. Note that we aren't returning a 403 here.
                        ControllerUtilities.LogViolationAndDenyPermission(logger, httpContext, pex);
                    }

                    Dictionary<string, object> failResponse = SurveyResponseDataForFail(result.Message).ToDictionary();
                    return failResponse;
                }
            }
        }

    }
}
