using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetApplication;
using swz.Clover.Core.View;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using swz.SurveyPlus.Application;
using swz.Clover.SPCP;

namespace swz.SurveyPlus.InternetWeb.Controllers
{

    [CheckSessionFilter]
    public class RespDashboardController : Controller
    {
        private readonly ILogger logger;
        private readonly IRespondentService respondentService;
        private readonly CommonPageSettingsOptions commonPageSettings;
        private readonly SPCPOptions spcpOptions;

        public RespDashboardController(
            ILogger<RespDashboardController> logger,
            IRespondentService respondentService, 
            CommonPageSettingsOptions commonPageSettings,
            SPCPOptions spcpOptions)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (respondentService == null) throw new ArgumentNullException(nameof(respondentService));
            if (commonPageSettings == null) throw new ArgumentNullException(nameof(commonPageSettings));
            if (spcpOptions == null) throw new ArgumentNullException(nameof(spcpOptions));
            this.commonPageSettings = commonPageSettings;
            this.logger = logger;
            this.respondentService = respondentService;
            this.spcpOptions = spcpOptions;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                ViewData[nameof(commonPageSettings)] = commonPageSettings;
                ViewData["IsSPCPLogin"] = spcpOptions.IsSPCPLogin;

                if (SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
                {
                    SurveyPlusInternet.ClearRespondentLogin(HttpContext);
                    return Redirect("/public/index");
                }

                await respondentService.VerifySessionActive();
                return View(Constants.ViewName.Index);
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(Index) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Index) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError, "Internal Error, please contact helpdesk for assistance");
            }
        }

        [HttpPost]
        [Route("respondent/newresponse")]
        public async Task<ActionResult> AddNewResponse()
        {
            try
            {
                Guid qnnDplySampleInfoId = Guid.Parse(Request.Form["id"]);
                AddResponseResult result = await respondentService.AddNewResponseAsync(qnnDplySampleInfoId);
                return result.IsSuccess
                    ? Json(new ItemSuccessResponse<Guid>(result.QnnRespId))
                    : Json(new FailResponse(result.Message));
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(AddNewResponse) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (PermissionException)
            {
                return Unauthorized();
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AddNewResponse) + " - caught unexpected error");
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } 

    } //end of RespDashboardController
}
