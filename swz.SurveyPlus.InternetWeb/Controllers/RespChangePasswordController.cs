using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.InternetApplication;
using swz.Clover.Core.View;
using Microsoft.Extensions.Logging;
using System;
using Microsoft.AspNetCore.Routing;
using swz.SurveyPlus.Application;
using swz.Clover.SPCP;

namespace swz.SurveyPlus.InternetWeb.Controllers
{

    /// <summary>
    /// Endpoints for password management (change / reset).
    /// These were previously in RespController and their urls still follow the resp/ pattern.
    /// Note that this is not in use when SPCP login is being used exclusively at the internet side.
    /// </summary>
    public class RespChangePasswordController : Controller
    {
        private readonly ILogger logger;
        private readonly IRespondentService respondentService;
        private readonly RespondentPortalOptions respondentPortalSetting;
        private readonly SPCPOptions spcpOptions;

        public RespChangePasswordController(
            IRespondentService respondentService, 
            ILogger<RespChangePasswordController> logger,
            RespondentPortalOptions respondentPortalSetting,
            SPCPOptions spcpOptions)
        {
            if (respondentService == null) throw new ArgumentNullException(nameof(respondentService));
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (respondentPortalSetting == null) throw new ArgumentNullException(nameof(respondentPortalSetting));
            if(spcpOptions==null) throw new ArgumentNullException(nameof(spcpOptions));
            this.respondentPortalSetting = respondentPortalSetting;
            this.respondentService = respondentService;
            this.logger = logger;
            this.spcpOptions = spcpOptions;
        }

        public async Task<IActionResult> Index()
        {
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(Index) + " - password change is disabled because Corppass login is active");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            try
            {
                await respondentService.VerifySessionActive();
                SetCommonViewData();
                return View();
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(Index) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (Exception e)
            {
                //Unexpected exception. Log it and fail. 
                logger.LogError(e, nameof(Index) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError, Constants.Message.InternalErrorException);
            }
        }

        private void SetCommonViewData()
        {
            ViewData[nameof(respondentPortalSetting.CommonPageSettings)] = respondentPortalSetting.CommonPageSettings;
            ViewData[nameof(spcpOptions.IsSPCPLogin)] = spcpOptions.IsSPCPLogin;
        }

        /// <summary>
        /// Password change from the UI form in the application.
        /// Change password in response to an already authenticated POST from the form that was accessed via the respondent dahboard link
        /// or redirected to in the case of a forced password change.
        /// nb: there is a seperate flow for password reset initiated by an unauthenticated user who forgot their password
        /// </summary>
        /// <param name="oldPassword"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
		[AllowAnonymous]
		[HttpPost]
		public async Task<ActionResult> RespChangePassword(string oldPassword, string newPassword) 
		{
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(RespChangePassword) + " - password change is disabled because Corppass login is active");
                return Json(new FailResponse(Constants.Message.FeatureNotEnabled));
            }
            try
            {
                string uid = SurveyPlusInternet.GetUserId(HttpContext.Session);
                try
                {
                    await respondentService.ChangePasswordAsync(uid, oldPassword, newPassword);
                    return Json(new SuccessResponse("Change password success"));
                }
                catch (PasswordChangeException pce)
                {
                    return Json(new FailResponse(pce.Message));
                }
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(RespChangePassword) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RespChangePassword) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
		}

        /// <summary>
        /// Reset password step 1
        /// Send reset password link in email to the user
        /// NOTE THIS NEEDS A POST
        /// </summary>
        /// <param name="uid"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("/Resp/resetRespPassword")]
        public async Task<ActionResult> SendResetPasswordLink(string uid)
        {
            if (!respondentPortalSetting.EnablePasswordResetFeature)
            {
                logger.LogError(nameof(SendResetPasswordLink) + " - password reset feature is disabled");
                return NotFound(); //404 for this one
            }
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(SendResetPasswordLink) + " - password change is disabled because SPCP login is enabled");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            if (string.IsNullOrWhiteSpace(uid)) return BadRequest();
            try
            {
                bool success = await respondentService.SendResetPasswordLinkAsync(uid);
                if (!success && logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(SendResetPasswordLink) + " - respondentService.SendResetPasswordLinkAsync returned false for " + uid);
                }
            }
            catch (Exception e)
            {
                //Log the error but return the usual message to user to avoid revelaing any details about the accounts
                logger.LogError(e, nameof(SendResetPasswordLink) + " - caught unexpected exception, uid={0}", uid);
            }
            return Json(new SuccessResponse("If you key in correct UID, reset password email should have been sent"));
        }

        /// <summary>
        /// Reset password step 2
        /// User has clicked the link in the email and comes here.
        /// Validate the token and forward to the password reset form
        /// </summary>
        /// <param name="nkt"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("/Resp/resetPassword/")]
        public async Task<ActionResult> ShowPasswordResetForm(string nkt)
        {
            if (!respondentPortalSetting.EnablePasswordResetFeature)
            {
                logger.LogError(nameof(ShowPasswordResetForm) + " - password reset feature is disabled");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(ShowPasswordResetForm) + " - password change is disabled because Corppass login is active");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            if (string.IsNullOrWhiteSpace(nkt)) return BadRequest();
            try
            {
                ValidatePasswordResetTokenResult result = await respondentService.ValidatePasswordResetTokenAsync(nkt);
                switch (result.Reason)
                {
                    case ValidatePasswordResetTokenResult.Outcome.ValidToken:
                        SetCommonViewData();
                        return View("PasswordResetForm");

                    case ValidatePasswordResetTokenResult.Outcome.InvalidToken:
                        return Content("Invalid Token");

                    case ValidatePasswordResetTokenResult.Outcome.LinkExpired:
                        return Content("The link has expired.");

                    default:
                        throw new Exception("Unknown reason:" + result.Reason);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ShowPasswordResetForm) + " - caught unexpected exception");
                return LocalRedirect(Constants.error404);
            }
        }

        /// <summary>
        /// Reset password step 3
        /// Post from the password reset form to set a new password.
        /// Authentication of the request is by the token supplied in the initial link.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("/Resp/RespChangePassword/")]
        public async Task<ActionResult> RespResetPassword(string token, string newPassword)
        {
            if (!respondentPortalSetting.EnablePasswordResetFeature)
            {
                logger.LogError(nameof(RespResetPassword) + " - password reset feature is disabled");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(RespResetPassword) + " - password change is disabled because Corppass login is active");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            if (string.IsNullOrWhiteSpace(token)) return BadRequest();
            if (string.IsNullOrWhiteSpace(newPassword)) return BadRequest();
            try
            {
                bool passwordResetSuccessfully = await respondentService.ResetPasswordAsync(token, newPassword);
                return passwordResetSuccessfully
                    ? Json(new SuccessResponse("Reset password successfully"))
                    : Json(new FailResponse("Not able to reset password"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RespResetPassword) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Route("/Resp/InvitesChangePassword/")]
        public async Task<ActionResult> InvitesChangePassword()
        {
            string uid = SurveyPlusInternet.GetUserId(HttpContext.Session);
            //Only authorize user able to proceed, because the flow after this page is the dashboard.
            if (string.IsNullOrWhiteSpace(uid)) return RedirectToAction(Constants.MethodName.Login, Constants.ControllerName.Respondent);

            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(InvitesChangePassword) + " - password change is disabled because Corppass login is active");
                return StatusCode(StatusCodes.Status403Forbidden, Constants.Message.FeatureNotEnabled);
            }
            ViewData[nameof(respondentPortalSetting.CommonPageSettings)] = respondentPortalSetting.CommonPageSettings;
            ViewData[nameof(spcpOptions.IsSPCPLogin)] = spcpOptions.IsSPCPLogin;
            return View();
        }

        /// <summary>
        /// Password change from the UI form in the application.
        /// This flow only applicable through the invitation link.
        /// </summary>
        /// <param name="oldPassword"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("/Resp/InvitesChangePassword/")]
        public async Task<ActionResult> InvitesChangePassword(string newPassword)
        {
            try
            {
                if (spcpOptions.IsSPCPLogin)
                {
                    logger.LogError(nameof(InvitesChangePassword) + " - password change is disabled because Corppass login is active");
                    return Json(new FailResponse(Constants.Message.FeatureNotEnabled));
                }
                string uid = SurveyPlusInternet.GetUserId(HttpContext.Session);
                await respondentService.InvitesChangePasswordAsync(uid, newPassword);
                return Json(new SuccessResponse("Change password success"));
            }
            catch (PasswordChangeException pce)
            {
                logger.LogError(pce, nameof(InvitesChangePassword) + " - failed");
                return Json(new FailResponse(pce.Message));
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(InvitesChangePassword) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(InvitesChangePassword) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

    } //end of RespChangePasswordController
}
