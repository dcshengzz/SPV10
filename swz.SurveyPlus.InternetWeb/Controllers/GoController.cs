using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Handles the /go/ links for Direct Access survey and Invite login flow etc
    /// </summary>
    public class GoController : Controller
    {
        public const string VIEW_CHECKLINK = "CheckLink";
        public const string VIEW_COMPLETED = "Completed";
        public const string VIEW_INACTIVE = "Inactive";
        public const string VIEW_INVITES_CHANGE_PASSWORD = "InvitesChangePassword"; //this is in RespChangePasswordController

        private readonly ILogger<GoController> logger;
        private readonly IRespondentService respondentService;
        private readonly CommonPageSettingsOptions CommonPageSettings;

        public GoController(
            ILogger<GoController> logger,
            IRespondentService respondentService,
            CommonPageSettingsOptions commonPageSettings)
        {
            this.logger = logger
                ?? throw new ArgumentNullException(nameof(logger));
            this.respondentService = respondentService
                ?? throw new ArgumentNullException(nameof(respondentService));
            this.CommonPageSettings = commonPageSettings
                ?? throw new ArgumentNullException(nameof(commonPageSettings));
        }

        /// <summary>
        /// Handle a Direct Access survey link (previously known as "Trackable Anonymous")
        /// </summary>
        [Route("/go/{accesscode}/{dlsiCode}/{formCode}")]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GoDirectAccess(string accessCode, string dlsiCode, string formCode)
        {
            try
            {
                ViewData[nameof(CommonPageSettings)] = CommonPageSettings;

                DirectAccessLoginResult result = await respondentService.DirectAccessLoginAsync(accessCode, dlsiCode, formCode);

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(GoDirectAccess) + " - dlsiCode={0}, formCode={1}, result={2}", dlsiCode, formCode, result);
                }

                switch (result.Response)
                {
                    case DirectAccessLoginResult.Outcome.RedirectToSurvey:
                        SurveyPlusInternet.RecordRespondentLogin(result.LoginResult, HttpContext);
                        return new RedirectResult($"/form/{result.FormName}/dlsi/{result.DplySampleInfoId}");

                    case DirectAccessLoginResult.Outcome.ResponseCompleted:
                        return View(VIEW_COMPLETED);

                    case DirectAccessLoginResult.Outcome.InvalidSurvey:
                    case DirectAccessLoginResult.Outcome.InvalidAccessCode:
                    case DirectAccessLoginResult.Outcome.InvalidRespondent:
                        return View(VIEW_CHECKLINK);

                    case DirectAccessLoginResult.Outcome.IncompatibleSurveyFeatures:
                        throw new Exception($"Incompatible survey features, DplySampleInfoId={result.DplySampleInfoId}");

                    default:
                        throw new NotImplementedException("Unknown response:" + result.Response);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GoDirectAccess) + " - caught unexpected exception, dlsiCode={0}, formCode={1}", dlsiCode, formCode);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Process a Short Link request
        /// </summary>
        /// <param name="shortLinkCode"></param>
        /// <param name="accessCode"></param>
        /// <returns></returns>
        [Route("/go/{shortLinkCode}")]
        [Route("/go/{shortLinkCode}/{accessCode}")]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GoShortLink(string shortLinkCode, string accessCode)
        {
            try
            {
                ViewData[nameof(CommonPageSettings)] = CommonPageSettings;

                //Don't bother the respondent service with obviously invalid shortlink or accesscode
                if (!AccessCode.IsValidFormat(shortLinkCode, expectedLength: Constants.Unlimited)) 
                {
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(GoShortLink) + " - Invalid shortLinkCode format");
                    }
                    return View(VIEW_CHECKLINK); 
                }

                bool accessCodeProvided = !string.IsNullOrWhiteSpace(accessCode);
                if (accessCodeProvided && !AccessCode.IsValidFormat(accessCode))
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(GoShortLink) + " - Invalid accessCode format");
                    }
                    return View(VIEW_CHECKLINK); 
                }

                //Final checks
                try
                {
                    long asLong = AccessCode.DecodeStringAsLong(shortLinkCode); //can convert to long (e.g. for NumberId)
                    if (asLong < 0 || asLong > Int32.MaxValue) throw new ArgumentOutOfRangeException();

                    //All ok, log that we are processing
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(GoShortLink) + " - Processing {0}, asLong={1}", shortLinkCode, asLong);
                    }
                }
                catch (Exception)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(GoShortLink) + " - Invalid shortLinkCode format (failed to convert to long)");
                    }
                    return View(VIEW_CHECKLINK);
                }

                //Seems legit, hand off to the service to verify further and tell us where to send them
                ShortLinkResult result = await respondentService.ProcessShortLinkAsync(shortLinkCode, accessCode);
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(GoShortLink) + " - Response for {0} is {1}, Url={2}", shortLinkCode, result.Response, result.Url);
                }
                switch (result.Response)
                {
                    case ShortLinkResult.Outcome.Inactive:
                        return View(VIEW_INACTIVE);

                    case ShortLinkResult.Outcome.InvalidShortLink:
                    case ShortLinkResult.Outcome.InvalidAccessCode:
                        return View(VIEW_CHECKLINK);

                    case ShortLinkResult.Outcome.RedirectToUrl:
                        return new RedirectResult(result.Url.ToString());

                    default:
                        throw new NotImplementedException($"Unimplemented {nameof(ShortLinkResult.Outcome)} - {result.Response}");
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GoShortLink) + " - caught unexpected exception, shortLinkCode={0}", shortLinkCode);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route("/in/{accesscode}/{dlsiCode}")]
        [HttpGet]
        [AllowAnonymous]
        public async Task<ActionResult> GoInvitation(string accessCode, string dlsiCode)
        {
            try
            {
                ViewData[nameof(CommonPageSettings)] = CommonPageSettings;

                RespInvitationResult result = await respondentService.InvitesLoginAsync(accessCode, dlsiCode);

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(GoInvitation) + " - dlsiCode={1}, result={2}", dlsiCode, result);
                }

                switch (result.Response)
                {
                    case RespInvitationResult.Outcome.InviteCompletedRequireChangePassword:
                        SurveyPlusInternet.RecordRespondentLogin(result.LoginResult, HttpContext);
                        return RedirectToAction(VIEW_INVITES_CHANGE_PASSWORD, Constants.ControllerName.RespChangePassword);

                    case RespInvitationResult.Outcome.InviteCompleted:
                        return RedirectToAction(Constants.MethodName.Login, Constants.ControllerName.Respondent);

                    case RespInvitationResult.Outcome.InvalidSurvey:
                    case RespInvitationResult.Outcome.InvalidRespondent:
                        return RedirectToAction(Constants.MethodName.Login, Constants.ControllerName.Respondent);

                    default:
                        throw new NotImplementedException("Unknown response:" + result.Response);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GoInvitation) + " - caught unexpected exception, dlsiCode={0}", dlsiCode);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route("/completed")]
        [AllowAnonymous]
        [HttpGet]
        public ActionResult Completed()
        {
            ViewData[nameof(CommonPageSettings)] = CommonPageSettings;
            return View(VIEW_COMPLETED);
        }
    }
}
