using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetApplication;
using swz.Clover.Core.View;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using Microsoft.Extensions.Caching.Memory;
using System.Net;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.InternetWeb.Controllers
{

    /// <summary>
    /// Endpoints to support the Excel survey support feature
    /// </summary>
    [CheckSessionFilter]
    public class ExcelController : Controller
    {
        private readonly ILogger logger;
        private readonly InternetAppSetting internetAppSetting;
        private IMemoryCache cache;
        private readonly IRespondentService respondentService;

        public ExcelController(
            ILogger<ExcelController> logger,
            InternetAppSetting internetAppSetting,
            IMemoryCache cache,
            IRespondentService respondentService)
        { 
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.internetAppSetting = internetAppSetting ?? throw new ArgumentNullException(nameof(internetAppSetting));
            this.cache = cache ?? throw new ArgumentNullException(nameof(cache));
            this.respondentService = respondentService ?? throw new ArgumentNullException(nameof(respondentService));
        }

        /// <summary>
        /// Sends a request to get the populated file from the internet side. This method is essentially just a proxy
        /// as it will pass on the parameters to the internet side to do all the work and then read the result and send
        /// it back to the client. 
        /// </summary>
        /// <param name="dsiIdString"></param>
        /// <param name="token"></param>
        /// <param name="respIdString"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("respondent/download/file/{dsiIdString}/{token}/{respIdString}")]
        [Route("respondent/download/file/{dsiIdString}/{token}/")]
        public async Task<ActionResult> DownloadSurveyExcelOnlineApi(string dsiIdString, string token, string respIdString)
        {
            Guid dlsi;
            Guid? respId;
            try
            {
                if (string.IsNullOrWhiteSpace(token)) throw new ArgumentException();
                dlsi = Guid.Parse(dsiIdString);
                respId = string.IsNullOrWhiteSpace(respIdString) ? (Guid?)null : Guid.Parse(respIdString);
            }
            catch (Exception badArgs) when (badArgs is ArgumentException || badArgs is ArgumentNullException || badArgs is FormatException)
            {
                return StatusCode((int)HttpStatusCode.BadRequest);
            }

            try
            {
                if(internetAppSetting.Restrictions.Ip)
                {
                    ListSampleInfo listSampleInfo = await respondentService.GetListSampleInfoAsync(dlsi);
                    if (await IPRestrictionLogic.IsUserBlockedAsync(HttpContext, cache, listSampleInfo.IPRules))
                    {
                        return Json(SurveyPlusInternet.GenFailedDictionary("Your IP is restricted from accessing this survey"));
                    }
                }
                
                //Stream the file to the browser
                StreamWithName excel = await respondentService.DownloadExcelAsync(dlsi, token, respId);
                //Return the stream, note that netcore will take care of closing the stream for us
                //see: https://stackoverflow.com/questions/26275764/does-filestreamresult-close-stream
                //see: https://github.com/dotnet/AspNetCore.Docs/issues/14585
                return File(excel.Stream, excel.ContentType, excel.Name); 
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(DownloadSurveyExcelOnlineApi) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadSurveyExcelOnlineApi) + " - caught unexpected exception, dsiIdString={0}, token={1}, respIdString={2}", dsiIdString, token, respIdString);
                return StatusCode((int)HttpStatusCode.InternalServerError);
            }
        } //end of DownloadSurveyExcelOnlineApi


        /// <summary>
        /// For use with UploadExcelReponse
        /// Actually returns a JsonResult with a SuccessReponse and the value as the message
        /// This is because we need to return success for the file upload to properly trigger the
        /// action handler
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private ActionResult UploadResult(string value)
        {
            return Json(new SuccessResponse(value));
        }

        [HttpPost]
        [Route("respondent/uploadexcelresponse")]
        public async Task<ActionResult> UploadExcelResponse(
            string qnnId,
            string dplyId,
            string listSampleId,
            string dlsi)
        {
            if (!Guid.TryParse(qnnId, out Guid qnnGuid)) return UploadResult("INVALID PARAMETERS qnnId");
            if (!Guid.TryParse(dplyId, out Guid dplyGuid)) return UploadResult("INVALID PARAMETERS dplyId");
            if (!Guid.TryParse(listSampleId, out Guid listSampleGuid)) return UploadResult("INVALID PARAMETERS listSampleId");
            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return UploadResult("INVALID PARAMETERS dlsi");
            StreamWithName file = null;
            try
            {
                ListSampleInfo listSampleInfo = await respondentService.GetListSampleInfoAsync(qnnDplySampleInfoId);
                if (!listSampleInfo.IsExcelEnabled)
                {
                    throw new SurveySubmissionException(Constants.ExcelUploadErrors.NotEnabled);
                }

                if (internetAppSetting.Restrictions.Ip)
                {
                    if (await IPRestrictionLogic.IsUserBlockedAsync(HttpContext, cache, listSampleInfo.IPRules))
                    {
                        return UploadResult("RESTRICTED IP"); //this is going to a file field, UI to check for this code
                    }
                }
                      
                if (Request.Form.Files.Count > 0)
                {
                    IFormFile formFile = Request.Form.Files[0];

                    //TODO - consider doing size based rejection immediately here

                    file = new StreamWithName(
                        formFile.OpenReadStream(),
                        formFile.ContentType,
                        formFile.FileName);
                }
                else
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug("No file in the request to UploadExcelResponse. qnnId={0}, dplyId={1}, listSampleId={2}, qnnDplySampleInfoId={3}",
                            qnnGuid, dplyGuid, listSampleGuid, qnnDplySampleInfoId);
                    }
                    return UploadResult("NO FILE");
                }

                await respondentService.UploadExcelAsync(qnnGuid, dplyGuid, listSampleGuid, file);

                return UploadResult("OK");
            }
            catch (SurveySubmissionException uploadException)
            {
                string message = uploadException.Message;
                if (Constants.ExcelUploadErrors.ReportableToClient.Contains(message))
                {
                    //Failure must also be returned as success response to get the result into the file field
                    return UploadResult(message);
                }
                else
                {
                    //Hide technical details for other problems from respondents.
                    logger.LogError(uploadException, nameof(UploadExcelResponse) + " - caught " + nameof(SurveySubmissionException) + ", qnnId={0}, dplyId={1}, listSampleId={2}, dlsi={3}", qnnId, dplyId, listSampleId, dlsi);
                    return UploadResult(Constants.ExcelUploadErrors.InternalError);
                }
            }
            catch (VirusDetectedException e)
            {
                return UploadResult(e.Message); //TODO - should use a 'code' and check in the UI and give message there
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(UploadExcelResponse) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturn403(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadExcelResponse) + " - caught unexpected exception, qnnId={0}, dplyId={1}, listSampleId={2}, dlsi={3}", qnnId, dplyId, listSampleId, dlsi);
                return UploadResult(Constants.ExcelUploadErrors.InternalError);
            }
            finally
            {
                if (file != null) file.Stream.Dispose();
            }
        } // end of UploadExcelResponse


    } //end of ExcelController
}
