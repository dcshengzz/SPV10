using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.View;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using swz.SurveyPlus.Application;
using System.Collections.Generic;

namespace swz.SurveyPlus.InternetWeb.Controllers
{

    public class UserInterfaceController : Controller
    {
        private readonly ILogger logger;
        private readonly InternetAppSetting internetAppSetting;
        private readonly IMemoryCache cache;
        private readonly IRespondentService respondentService;

        public UserInterfaceController(
            ILogger<UserInterfaceController> logger,
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
        /// Internet side uses this to get Survey Forms
        /// The referer url must include a dlsi segment
        /// </summary>
        /// <param name="name"></param>
        /// <param name="wrapResult"></param>
        /// <param name="enableSecurity"></param>
        /// <returns></returns>
        [CheckSessionFilter]
        [CheckFormNameFilter]
        [Route("ui/form/{name:regex(^(?!(respdashboard|respaccountchangepassword|spheader|spfooter|sptop|resplogin|respLoginIAm|respLoginIAmIndividual|respLoginIAmEntity|respresetpassword|respresetpasswordsuccess|respchangepassword|respchangepasswordsuccess|inviteschangepassword)$).*$)}")]
        public async Task<ActionResult> GetForm(string name, bool wrapResult = false, bool enableSecurity = false)
        {
            try
            {
                if (ViewBag.IsSurvey != true)
                {
                    if (wrapResult)
                        return Json(new FailResponse("form is not found!"));
                    //throw new Exception("Form is not found!");
                    return Json(new FailResponse("form is not found!"));
                }

                Uri referer = ControllerUtilities.Referer(Request);
                string dlsiUriSegmentString = referer.Segments?[referer.Segments.Length - 1];
                if (!Guid.TryParse(dlsiUriSegmentString, out Guid dlsi)) return GenFailedReponse("Invalid input");

                string sessionUId = SurveyPlusInternet.GetUid(HttpContext.Session);

                //validate. make sure this dplySampleInfoId/respid is for current respondent;
                ListSampleInfo listSampleInfo = await respondentService.GetListSampleInfoAsync(dlsi);
                ListSampleInfo.AccessResult accessResult = listSampleInfo.CheckRespondentAccess(sessionUId, name);
                if(!accessResult.IsValid)
                {
                    if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(accessResult.ErrorMsg);
                    return Json(SurveyPlusInternet.GenFailedDictionary("Invalid access")); //dply/qnn not active, is deleted; qnn not online type, wrong sample, form name not listed in formproperties.
                }

                //Survey-specific AccessCode check (for the delegation feature)
                if(true == listSampleInfo.RequireAccessCode)
                {
                    //nb: submission and validation of password happens in RespDashboardController
                    bool authorisedSurveyDelegate = SurveyAccessCodeUtil.AccessCodePreviouslyValidated(HttpContext.Session, dlsi);
                    if(!authorisedSurveyDelegate)
                    {
                        if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(Constants.FormAccessErrors.UnauthorizedSurveyDeletegate);
                        return Json(SurveyPlusInternet.GenFailedDictionary("Invalid access"));
                    }
                }

                //IP restriction logic
                if(internetAppSetting.Restrictions.Ip)
                {
                    if (await IPRestrictionLogic.IsUserBlockedAsync(HttpContext, cache, listSampleInfo.IPRules))
                    {
                        return Json(SurveyPlusInternet.GenFailedDictionary("Your IP is restricted from accessing this survey"));
                    }
                }
                
                Form form = CloverRuntime.Metadata.GetForm(name); //20260701 - was MTMC
                if (form == null)
                {
                    logger.LogError(nameof(GetForm) + " - form not found {0}", name);
                    return Json(new FailResponse("Form is not found!"));
                }
                  
                return await GetForm(form, wrapResult, enableSecurity);
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(GetForm) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturn403(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetForm) + " - caught unexpected exception, name={0}, wrapResult={1}, enableSecurity={2}", name, wrapResult, enableSecurity);

                if (wrapResult)
                    return Json(new FailResponse("Unable to load the form"));
                return Json(new FailResponse("Unable to load the form"));
            }
        } //end of public GetForm endpoint

        [CheckSessionFilter]
        [Route("ui/form/{name:regex(^(respdashboard|respaccountchangepassword|inviteschangepassword)$)}")]
        public async Task<ActionResult> GetSpForm(string name, bool wrapResult = false, bool enableSecurity = false)
        {
            try
            {
                if ("respdashboard".Equals(name, StringComparison.OrdinalIgnoreCase) &&
                    SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
                {
                    return StatusCode(403, Constants.Message.YouDontHaveThePermission);
                }

                Form form = CloverRuntime.Metadata.GetForm(name); //20260701 - was CR.M
                if (form == null)
                {
                    //TODO - review the below, does it need logging?
                    if (wrapResult)
                        return Json(new FailResponse("Form is not found!"));
                    //throw new Exception("Form is not found!");
                    return Json(new FailResponse("Form is not found!"));
                }

                return await GetSpForm(form, wrapResult, enableSecurity);
            }
            catch(SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(GetSpForm) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturn403(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetSpForm) + " - caught unexpected exception, name={0}, wrapResult={1}, enableSecurity={2}", name, wrapResult, enableSecurity);

                //TODO - review the below, why is it like this?, is something missing?
                if (wrapResult)
                    return Json(new FailResponse("Form is not found!"));
                return Json(new FailResponse("Form is not found!"));
            }
        }

        [AllowAnonymous]
        [Route("ui/form/{name:regex(^(resplogin|respLoginIAm|respLoginIAmIndividual|respLoginIAmEntity|respresetpassword|respresetpasswordsuccess|respchangepassword|respchangepasswordsuccess|spheader|spfooter|sptop)$)}")]
        public async Task<ActionResult> GetSpLoginForm(string name, bool wrapResult = false, bool enableSecurity = false)
        {
            try
            {
                var form = CloverRuntime.Metadata.GetForm(name); //20260701 - was MTMC
                if (form == null)
                {
                    logger.LogError(nameof(GetSpLoginForm) + " - form not found {0}", name);
                    return Json(new FailResponse("Form is not found!"));
                }

                return await GetSpForm(form, wrapResult, enableSecurity);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetSpLoginForm) + " - caught unexpected exception, name={0}, wrapResult={1}, enableSecurity={2}", name, wrapResult, enableSecurity);
                //TODO - review the below, why is it like this?, is something missing?
                if (wrapResult)
                    return Json(new FailResponse("Form is not found!"));
                return Json(new FailResponse("Form is not found!"));
            }
        }

        [AllowAnonymous]
        [Route("ui/localization.js")]
        public ActionResult GetLocalization()
        {
            return Content(CloverRuntime.Metadata.GetLocalizationScript("base"), "application/x-javascript");
        }

        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/splocalization.js")]
        public ActionResult GetSpLocalization()
        {
            return Content(CloverRuntime.Metadata.GetLocalizationScript("base"), "application/x-javascript");
        }

        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/spbusinessobjects.js")]
        public ActionResult GetSpFormsBusinesscode()
        {
            string headerReferer = Request.Headers["Referer"];
            var myUri = new Uri(headerReferer);
            var form = myUri.Segments.Length<3?"respdashboard":myUri.Segments[2].Trim('/');
            return Content(CloverRuntime.Metadata.GetFormsBusinessCode(form), "application/x-javascript");
        }

        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/spheader.js")]
        public ActionResult GetSpHeadercode()
        {
            return Content(CloverRuntime.Metadata.GetFormsBusinessCode("spheader"), "application/x-javascript");
        }

        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/businessobjects.js")]
        public ActionResult GetFormsBusinesscode()
        {
            string headerReferer = Request.Headers["Referer"];
            Uri myUri = new Uri(headerReferer);
            var form = myUri.Segments.Length < 3 ? "respdashboard" : myUri.Segments[2].Trim('/');
            return Content(CloverRuntime.Metadata.GetFormsBusinessCode(form), "application/x-javascript");
        }
        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/respAccountChangePasswordBusinessobjects.js")]
        public ActionResult GetRespAccountChangePasswordFormBusinesscode()
        {
            return Content(CloverRuntime.Metadata.GetFormsBusinessCode("RespAccountChangePassword"), "application/x-javascript");
        }

        [AllowAnonymous]
        [CheckSessionFilter]
        [Route("ui/respDashboardBusinessobject.js")]
        public ActionResult GetRespDashboardBusinesscode()
        {
            return Content(CloverRuntime.Metadata.GetFormsBusinessCode("respdashboard"), "application/x-javascript");
        }

        [AllowAnonymous]
        [Route("ui/resplogin")]
        public async Task<ActionResult> RespLogin()
        {
            return await GetForm("resplogin");
        }

		[AllowAnonymous]
		[Route("ui/respchangepassword")]
		public async Task<ActionResult> RespChangePassword()
		{
			return await GetForm("RespChangePassword");
		}

		[AllowAnonymous]
		[Route("ui/respchangepasswordsuccess")]
		public async Task<ActionResult> RespChangePasswordSuccess()
		{
			return await GetForm("RespChangePassword");
		}

		[AllowAnonymous]
		[Route("ui/respresetpassword")]
		public async Task<ActionResult> RespResetPassword()
		{
			return await GetForm("RespResetPassword");
		}

		[AllowAnonymous]
		[Route("ui/respresetpasswordsuccess")]
		public async Task<ActionResult> RespResetPasswordSuccess()
		{
			return await GetForm("RespResetPasswordSuccess");
		}

        [AllowAnonymous]
        [Route("ui/brandingImagePath")]
        public async Task<ActionResult> BrandingImagePath()
        {
            Dictionary<string, object> response = new Dictionary<string, object>
            {
                {"BrandingImagePath", internetAppSetting.RespondentPortal.CommonPageSettings.BrandingImagePath},
            };

            return Json(new ItemSuccessResponse<Dictionary<string, object>>(response));
        }

        #region Private function
        private async Task<ActionResult> GetForm(Form form, bool wrapResult, bool enableSecurity)
        {

            var localization = CloverRuntime.Security.CurrentUser?.Localization;
            if (!string.IsNullOrWhiteSpace(localization))
            {
                await form.FillCustomBlockFormsAndLocalizateAsync(localization);
            }
            else
            {
                await form.FillCustomBlockFormsAsync();
            }

            if (wrapResult)
            {
                await form.FillMappingAsync();
                return Json(new ItemSuccessResponse<object>(form));
            }

            string json = form.Source;
            if (string.IsNullOrEmpty(json))
                return Json(new FailResponse($"{form.Name} is not found!"));
            return Json(Newtonsoft.Json.JsonConvert.DeserializeObject(json));
        }

        private async Task<ActionResult> GetSpForm(Form form, bool wrapResult, bool enableSecurity)
        {

            await form.FillCustomBlockFormsAsync();

            if (wrapResult)
            {
                await form.FillMappingAsync();
                return Json(new ItemSuccessResponse<object>(form));
            }

            string json = form.Source;
            if (string.IsNullOrEmpty(json))
                return Json(new FailResponse($"{form.Name} is not found!"));
            return Json(Newtonsoft.Json.JsonConvert.DeserializeObject(json));
        }

        private static bool NotNullOrEmpty(string urlFilter)
        {
            return !string.IsNullOrEmpty(urlFilter) && !urlFilter.Equals("null", StringComparison.OrdinalIgnoreCase);
        }

        private ActionResult GenFailedReponse(string msg, string details = null)
        {
            var failed = new DynamicEntity();
            failed.Dictionary.Add("success", false);
            failed.Dictionary.Add("message", msg);
            failed.Dictionary.Add("details", details);
            return Json(failed.ToDictionary());
        }
        #endregion


    } //end of UserInterfaceController
}