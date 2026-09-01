using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.InternetApplication;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using System.Net;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    //nb: doesn't use CheckSessionFilter at controller level as need unauthenticated access to respondent login content

    /// <summary>
    /// Serves routes under resphelp and SwzData related to the online help and respondent content features
    /// </summary>
    public class HelpAndContentController : Controller
    {
        private readonly ILogger logger = DefaultApplicationLogging.CreateLogger<HelpAndContentController>();
        private readonly IRespondentService respondentService;
        private readonly CommonPageSettingsOptions CommonPageSettings;

        public HelpAndContentController(
            IRespondentService respondentService, 
            ILogger<HelpAndContentController> logger, 
            CommonPageSettingsOptions commonPageSettings)

        {
            if (respondentService == null) throw new ArgumentNullException(nameof(respondentService));
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (commonPageSettings == null) throw new ArgumentNullException(nameof(commonPageSettings));

            this.CommonPageSettings = commonPageSettings;
            this.respondentService = respondentService;
            this.logger = logger;
        }

        [CheckSessionFilter]
        [Route("help")]
        public async Task<ActionResult> RespHelp()
        {
            if (!CommonPageSettings.IsHelpEnabled)
                return StatusCode((int)HttpStatusCode.Forbidden);
            try
            {
                await respondentService.VerifySessionActive();
                ViewData[nameof(CommonPageSettings)] = CommonPageSettings;
                return View("RespHelp"); //asp will look for this in Views folder whose name matches this controller
            }
            catch(SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(RespHelp) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RespHelp) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [CheckSessionFilter]
        [Route("resphelp/get")]
        [HttpGet]
        public async Task<ActionResult> GetRespHelp()
        {
            if (!CommonPageSettings.IsHelpEnabled) 
                return StatusCode((int)HttpStatusCode.Forbidden);
            try
            {
                List<HelpItem> items = await respondentService.GetRespHelpAsync();

                //nb: convert to dictionary because clientside expects capitalised property
                //    names, but newtonsoft will magically convert to lowercase, unless you
                //    use a dictionary, which it uses verbatim. (I did try using SerializerSettings
                //    but got errors from newtonsoft here. TODO - look at again later, avoid the
                //    extra dictionary step if we can)
                return Json(items.Select(item => item.ToDictionary()).ToList());
            }
            catch (SessionInvalidException)
            {
                //nb: currently (20231012) this won't be thrown as GetRespHelpAsync doesn't need to pass a jwt
                //    Also, since we currently fetch all the items on first render this would be called immediately
                //    after RespHelp (view) which makes an explicit session check and redirects.
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(RespHelp) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturn403(HttpContext);
            }
            catch (PermissionException)
            {
                return StatusCode(StatusCodes.Status403Forbidden);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get help"); //no-one can help you now
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        } //end of GetRespHelp

        /// <summary>
        /// Fetch respondent content
        /// </summary>
        /// <param name="type">RespLogin or RespDashboard</param>
        /// <returns>information including EditorState</returns>
        [Route("swzData/getmultiple")]
        [HttpGet]
        public async Task<ActionResult> GetMultipleRespondentContent(string type)
        {
            if(!SurveyPlusInternet.IsLoggedIn(HttpContext))
            {
                if(!"RespLogin".Equals(type))
                {
                    return StatusCode(StatusCodes.Status403Forbidden);
                }
            }

            try
            {
                var _mView = await respondentService.GetRespondentContentAsync(type);

                return Json(new
                {
                    Success = true,
                    Data = _mView,
                    Message = "Load Html View Success"
                });
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to retrieve respondent content");
                return Json(new
                {
                    Success = false,
                    Message = "Unable to view HTML Viewer"
                });
            }
        } //end of GetMultipleContentApi

    } //end of HelpAndContentController
}
