using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;
using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Routing;
using swz.Clover.Core.View;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using Newtonsoft.Json;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Handles server side survey 'printing' features (i.e. printing to PDF).
    /// </summary>
    [CheckSessionFilter]
    public class SurveyPrintController : Controller
    {
        private readonly ILogger<SurveyPrintController> logger;
        private readonly IRespondentService respondentService;
        private readonly InternetAppSetting internetAppSetting;

        public SurveyPrintController(
            ILogger<SurveyPrintController> logger,
            IRespondentService respondentService,
            InternetAppSetting internetAppSetting)
        {
            this.logger = logger
                ?? throw new ArgumentNullException(nameof(logger));
            this.respondentService = respondentService
                ?? throw new ArgumentNullException(nameof(respondentService));
            this.internetAppSetting = internetAppSetting 
                ?? throw new ArgumentNullException(nameof(internetAppSetting));
        }

        /// <summary>
        /// Sends a request to enqueue a survey printing job in server side 
        /// </summary>
        /// <param name="formName"></param>
        /// <param name="surveyName"></param>
        /// <param name="emails"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("/print/download")]
        public async Task<ActionResult> PrintSurvey()
        {
            Guid pdfExportLogId = Guid.Empty;
            try
            {
                if (string.IsNullOrEmpty(Request.Form["formName"])) return BadRequest();
                if (string.IsNullOrEmpty(Request.Form["surveyName"])) return BadRequest();
                if (string.IsNullOrEmpty(Request.Form["emails"])) return BadRequest();
                if (!Guid.TryParse(Request.Form["dlsi"], out Guid dlsi)) return BadRequest();

                if (!internetAppSetting.PrintSettings.IsRespdashboardPrintEnabled)
                {
                    throw new Exception("Print feature in respondent dashboard is not enabled.");
                }

                Guid? respId = string.IsNullOrWhiteSpace(Request.Form["respId"]) ? (Guid?)null : Guid.Parse(Request.Form["respId"]);
                string formName = Request.Form["formName"];
                string surveyName = Request.Form["surveyName"];
                string emails = Request.Form["emails"];

                PdfExportRateLimitResult rateLimitResult = await respondentService.CheckPdfExportRateLimitAsync(dlsi, respId, formName, surveyName, emails);
                pdfExportLogId = rateLimitResult.LogId;

                if (rateLimitResult.IsRateLimited)
                {
                    logger.LogWarning("PDF export rate limited for dlsi {Dlsi} - request within {Minutes} minute cooldown", dlsi, rateLimitResult.CooldownMinutes);
                    return Json(new { success = false, result = false, message = $"A PDF export was recently requested for this survey. Please wait {rateLimitResult.CooldownMinutes} minute(s) before trying again." });
                }
                DynamicEntity responseData = await respondentService.GetSurveyDataForPrintAsync(dlsi, respId, formName, internetAppSetting.PrintSettings.IsPDFExportForSubmittedOnly);

                if (FailResponse.IsFailResponse(responseData, out var fail))
                {
                    await UpdatePdfExportStatusSafe(pdfExportLogId, "Failed", fail.Message);
                    return Json(new { success = false, result = false, message = fail.Message });
                }

                string responseDataJson = JsonConvert.SerializeObject(responseData.ToDictionary(true));
                //Enqueue hangfire job
                await respondentService.EnqueuePrintJobAsync(rateLimitResult.LogId, formName, emails, surveyName, responseDataJson);
                await UpdatePdfExportStatusSafe(pdfExportLogId, "Completed", null);

                return Json(new SuccessResponse("The system is processing the requested email job. All indicated recipients will receive an email with the attached PDF response shortly."));
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(PrintSurvey) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (NotFoundException nfe)
            {
                logger.LogDebug(nfe, nameof(PrintSurvey) + " - not found");
                await UpdatePdfExportStatusSafe(pdfExportLogId, "Failed", nfe.Message);
                return NotFound(new FailResponse(nfe.Message));
            }
            catch (RespondentServiceException rse)
            {
                logger.LogWarning(rse, nameof(PrintSurvey) + " - respondent service failure");
                await UpdatePdfExportStatusSafe(pdfExportLogId, "Failed", rse.Message);
                return Json(new { success = false, result = false, message = rse.Message });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PrintSurvey) + " - caught an unexpected exception");
                await UpdatePdfExportStatusSafe(pdfExportLogId, "Failed", e.Message);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        } //end of PrintSurvey

        private async Task UpdatePdfExportStatusSafe(Guid logId, string status, string errorMessage)
        {
            if (Guid.Empty.Equals(logId)) return;
            try
            {
                await respondentService.UpdatePdfExportStatusAsync(logId, status, errorMessage);
            }
            catch (Exception e)
            {
                logger.LogWarning(e, nameof(UpdatePdfExportStatusSafe) + " - failed to update PDF export log status, logId={LogId}", logId);
            }
        }
    }

}
