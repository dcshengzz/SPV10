using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Globalization;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.Clover.SPCP;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.InternetApplication;
using swz.SurveyPlus.ApiSupport;
using System.Collections.Specialized;
using System.Web;
using swz.Clover.SPCP.OIDC;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.WebUtilities;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Login / Logoff endpoints
    /// (one or two misc endpoints are also found here for now)
    /// 
    /// nb: Methods for changing and resetting password have moved to RespChangePasswordController though
    ///     they still use the Resp/ path for now in their routing
    /// </summary>
    public class RespController : Controller
    {
        private readonly SPCPOptions spcpOptions;
        private readonly CommonPageSettingsOptions CommonPageSettings;
        private readonly WogaaSettings wogaaSettings;

        private readonly ILogger logger;
        private readonly IRespondentService respondentService;
        private readonly ISPCPHandler spcpHandler;
        private readonly SecurityHeaderSetting securityHeaderSetting;

        public RespController(
            SPCPOptions spcpOptions,
            WogaaSettings wogaaSettings,
            CommonPageSettingsOptions commonPageSettings,
            ILogger<RespController> logger,
            IRespondentService respondentService,
            SecurityHeaderSetting securityHeaderSetting,
            ISPCPHandler spcpHandler = null)
        {
            //I inject the various settings individually  (instead of just injecting InternetAppSetting)
            //as I want the dependencies to be clear, but it is getting to be quite a few here!
            //Actually this suggests the RespController may be taking on too many disparate responsibilities
            //and it might be time to move some to a new controller?

            this.CommonPageSettings = commonPageSettings ?? throw new ArgumentNullException(nameof(commonPageSettings));
            this.spcpOptions = spcpOptions ?? throw new ArgumentNullException(nameof(spcpOptions));
            this.respondentService = respondentService ?? throw new ArgumentNullException(nameof(respondentService));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.spcpHandler = spcpHandler; //Might not be injected depending on the configuration (see SPCPConfigurator)
            this.wogaaSettings = wogaaSettings ?? throw new ArgumentNullException(nameof(wogaaSettings));
            this.securityHeaderSetting = securityHeaderSetting ?? throw new ArgumentNullException(nameof(securityHeaderSetting));
        }

        /// <summary>
        /// Return the view for the login page.
        /// (Password form or SPCP buttons depending on settings).
        /// The response has some dynamic elements so shoud not be cached by clients.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/login")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public ActionResult LoginView()
        {
            try
            {
                string uId = SurveyPlusInternet.GetUid(HttpContext.Session);
                string errorMessage = GetErrorMessage(); //any error stashed in the session to report to user?
                SetErrorMessage(null); //now clear it so it doesn't show on refresh or logout

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace("Login: uId={0}, errorMessage={1}", uId, errorMessage);
                }

                //bypass password check for sample with uid "swzanonymous"
                //this is to support the Anonymous survey feature. We would get here from an explicit invoke
                //of Login from StarterApplicationController's Index() method
                if (TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uId))
                {
                    //TODO - follow the flow here to see why we don't call SurveyPlusInternet.ClearRespondentLogin
                    //       here, and only clear the uId
                    HttpContext.Session.Remove("uId");
                }

                //Data needed by the view
                ViewData["CommonPageSettings"] = CommonPageSettings;
                ViewData["SPCPLoginPaths"] = spcpOptions.LoginUrl.GetLoginPaths(spcpOptions.Environment);
                ViewData["IsSPCPLogin"] = spcpOptions.IsSPCPLogin;
                ViewData["IsSingpassSupported"] = spcpOptions.IsSingpassSupported;
                ViewData["IsCorppassSupported"] = spcpOptions.IsCorppassSupported;
                ViewData["WogaaSettings"] = wogaaSettings;
                ViewData["ErrorMessage"] = errorMessage;

                return View("Login"); //Views/Resp/Login.cshtml
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(LoginView) + " - encountered an unexpected exception");
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Process login via username and password
        /// </summary>
        /// <param name="login"></param>
        /// <param name="password"></param>
        /// <returns></returns>        
        [AllowAnonymous]
        [HttpPost]
        [Route("resp/login")]
        public async Task<ActionResult> PasswordLogin(string login, string password)
        {
            if (spcpOptions.IsSPCPLogin)
            {
                logger.LogError(nameof(PasswordLogin) + " - Password login is disabled because Corppass login is active. login={0}", login);
                //I'd prefer to return a 403 but this results in an alert in the UI about database not being configured, so
                //lets just return an error message. (Corppass gets Singpass branding in the UI)
                return Json(new FailResponse("Please login using Singpass"));
            }
            try
            {
                LoginResult result = await respondentService.PasswordLoginAsync(login, password);
                if (result.IsSuccess)
                {
                    if (logger.IsEnabled(LogLevel.Information))
                    {
                        logger.LogInformation(nameof(PasswordLogin) + " - success, login={0}", login);
                    }
                    SurveyPlusInternet.RecordRespondentLogin(result, HttpContext);
                    dynamic response = new ExpandoObject();
                    response.message = "Respondent login successfully";
                    response.success = true;
                    response.forcePwdChange = result.Information.ForcePwdChange; //we didn't use SuccessResponse here as want this property too
                    return Json(response);
                }
                else
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        //log fails at debug because in prod there's likely to be many failed attempts (probes!)
                        logger.LogDebug(nameof(PasswordLogin) + " - failed, reason={0}, login={1}", result.Reason, login);
                    }
                    switch (result.Reason)
                    {
                        //Following cases are for reporting to the user

                        case LoginResult.Outcome.InvalidCredentials:
                            return Json(new FailResponse("Login or password is not correct."));

                        case LoginResult.Outcome.AccountLocked:
                            return Json(new FailResponse("Account is locked. Please contact administrators"));

                        //Following cases are an internal error condition

                        case LoginResult.Outcome.Success: //should be impossible
                            throw new InvalidOperationException("IsSuccess is false but reason is Success");

                        default: //new result we've not implented ui message or action for?
                            throw new NotImplementedException("Unexpected reason:" + result.Reason);
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PasswordLogin) + " - caught unexpected exception. login={0}", login);
                return Json(new FailResponse("Not able to login"));
            }
        }

        /// <summary>
        /// Returns whether wogaa is to be used and the script url to use for it.
        /// This is still called from the respondent dashboard (but not the login page any more)
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/iswogaaenabled")]
        public ActionResult IsWogaaEnabled()
        {
            return Json(new Dictionary<string, object>
            {
                {"success", true},
                {"wogaaEnabled", wogaaSettings.Enable},
                {"wogaaUrl", (wogaaSettings.Enable ? wogaaSettings.Url : null)},
            });
        }

        /// <summary>
        /// Redirect to the configured URL in appsettings to kickoff the Corppass login process.
        /// </summary>
        /// <returns>redirect</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/startiamentitylogin")]
        public ActionResult StartIAmEntityLogin() //renamed 20231121 to remove use of term Corppass in URL
        {
            return StartSPCPLogin(SPCPFlow.Corppass);
        }

        /// <summary>
        /// Redirect to the configured URL in appsettings to kickoff the Singpass login process.
        /// </summary>
        /// <returns>redirect</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/startiamindividuallogin")]
        public ActionResult StartIAmIndividualLogin() //renamed 20231121 to remove use of term Singpass in URL
        {
            return StartSPCPLogin(SPCPFlow.Singpass);
        }

        private ActionResult StartSPCPLogin(SPCPFlow flow)
        {
            // NOTE:
            // (For implementations where additional dynamic things are needed, such as a nonce in the url, you can add an
            // extra redirection, so the button links here, and then the configured url links to another custom controller
            // method that handles the dynamic aspects. That way this method can remain as is to support the general case as
            // this needs to be generic for all our SPCP implementations)

            if (spcpOptions.IsSPCPLogin == false)
            {
                logger.LogError(nameof(StartIAmEntityLogin) + " - SPCP login is not enabled");
                return RedirectToLoginWithErrorMessage("Singpass/Corppass login is not enabled");
            }
            try
            {
                string spcpLoginUrl;
                switch (flow)
                {
                    case SPCPFlow.Corppass:
                        spcpLoginUrl = spcpOptions.LoginUrl.GetLoginPaths(spcpOptions.Environment).Corppass;
                        break;

                    case SPCPFlow.Singpass:
                        spcpLoginUrl = spcpOptions.LoginUrl.GetLoginPaths(spcpOptions.Environment).Singpass;
                        break;

                    default:
                        throw new NotImplementedException($"Unknown {nameof(SPCPFlow)} - {flow}");
                }
                if (string.IsNullOrWhiteSpace(spcpLoginUrl))
                {
                    throw new InvalidOperationException($"{nameof(StartSPCPLogin)}: url for {flow} login is not configured");
                }

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(StartSPCPLogin) + " - flow={0}, spcpLoginUrl={1}", flow, spcpLoginUrl);
                }

                return Redirect(spcpLoginUrl);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(StartSPCPLogin) + " - encountered an unexpected exception, flow={0}", flow);
                return RedirectToLoginWithErrorMessage(
                    "Unable to login. Please contact support if this error persists. "
                    + DateTime.Now.ToString("yyyy-MM-dd HH:mm") + " [b]");
            }
        }

        //TODO - since this URL appears in SIMS configuration it is easier to change, so this legacy endpoint
        //       can be removed much sooner than the Nevis ones
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/spcp/login")]
        public ActionResult LegacyStartIamEntityOidcLogin([FromServices] CorppassOidcSettings corppassOidcSettings=null)
        {
            logger.LogError(nameof(LegacyStartIamEntityOidcLogin) + " - use of legacy SPCP route {0} (this endpoint will be removed soon)", Request.Path);
            return StartIamEntityOidcLogin(corppassOidcSettings);
        }

        /// <summary>
        /// Make a redirection to SPCP for OIDC login. For OIDC login we would set this as the LoginUrl in appsettings.json
        /// so clicks to login with corppass will get redirected to here first by StartSPCPLogin, and then here 
        /// we will assemble the actual OIDC redirect URL and redirect once more to that with nonce and state etc. 
        /// We'll add the nonce to browser session for double checking with token from OIDC resolver later.
        /// </summary>
        /// <returns>A redirection to SPCP URL as per configurations</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/startiamentityoidclogin")]
        public ActionResult StartIamEntityOidcLogin([FromServices]CorppassOidcSettings corppassOidcSettings=null)
        {
            if (spcpOptions.IsSPCPLogin == false)
            {
                logger.LogError(nameof(StartIamEntityOidcLogin) + " - SPCP login is not enabled");
                return RedirectToLoginWithErrorMessage("Singpass/Corppass login is not enabled");
            }            
            try
            {
                if (corppassOidcSettings == null)
                {
                    logger.LogError(nameof(StartIamEntityOidcLogin) + " - CorpPass OIDC is not configured, returning 404");
                    return NotFound();
                }
                string nonce = EncryptionHelper.RandomAlphanumericString(32);
                string state = EncryptionHelper.RandomAlphanumericString(16);
                
                OidcSettings oidcSettings = corppassOidcSettings.GetOidcSettings(spcpOptions.Environment);
                
                NameValueCollection query = HttpUtility.ParseQueryString(string.Empty);
                query.Add("scope", "openid");
                query.Add("response_type", "code");
                query.Add("redirect_uri", oidcSettings.RedirectUrl);
                query.Add("client_id", oidcSettings.ClientId);
                query.Add("state", state);
                query.Add("nonce", nonce);

                UriBuilder uriBuilder = new UriBuilder(oidcSettings.SpcpUrl);
                uriBuilder.Query = query.ToString();
                string redirectionUrl = uriBuilder.ToString();

                //TODO - what happens when there is no session? Does the login still work?
                //       or if there is expected to always be a session in which case why use the ?. operator here?
                //      A: the login does not work if the session isn't available. Review this code in v10
                //TODO - there should be constants for these session keys, and they should have a prefix too
                //       e.g. oidc_nonce, oidc_state
                HttpContext?.Session?.SetString("nonce", nonce);

                if(oidcSettings.IsStateCheckEnabled)
                    HttpContext?.Session?.SetString("state", state);

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    if(spcpOptions.Debug)
                        logger.LogDebug(nameof(StartIamEntityOidcLogin) + " - redirectionUrl={0}, nonce={1}, state={2}, sessionId={3}", redirectionUrl, nonce, state, HttpContext.Session.Id);
                    else
                        logger.LogDebug(nameof(StartIamEntityOidcLogin) + " - redirectionUrl={0}", redirectionUrl);
                    //TODO - review the above logging, url already contains the nonce so could simplify to the second statement and abandon checking the debug flag
                }

                return Redirect(redirectionUrl);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(StartIamEntityOidcLogin) + " - Exception thrown when processing redirection url to SPCP OIDC");
                return RedirectToLoginWithErrorMessage(
                    "Unable to login. Please contact support if this error persists. "
                    + DateTime.Now.ToString("yyyy-MM-dd HH:mm") + " [b]");
            }
        }

        /// <summary>
        /// Endpoint to handle a request for performing Corppass login using SPCPLogin method.
        /// Depending on which SPCP integration implementation we are using this is the endpoint 
        /// the third party gateway will call after interacting with SPCP or this will call the gateway
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("resp/iamentitylogin")] //renamed 20231121 to remove the word Corppass from the URL
        [Route("resp/respiam")] //synonym for iamentitylogin (we already gave this to SPCP so tedious to get it changed)
        public async Task<ActionResult> IAmEntityLogin()
        {
            return await SPCPLogin(SPCPFlow.Corppass);
        }

        /// <summary>
        /// LEGACY CORPPASS URL - please reconfigure instances not to use it, will be removed in a future build
        /// </summary>
        [AllowAnonymous]
        [Route("resp/corppassloginv2")]
        public async Task<ActionResult> LegacyIAmEntityLogin()
        {
            logger.LogError(nameof(LegacyIAmEntityLogin) + " - use of legacy SPCP route {0} (this endpoint will be removed soon)", Request.Path);
            return await IAmEntityLogin();
        }

        /// <summary>
        /// Endpoint to handle a request for performing Singpass login using SPCPLogin method
        /// Depending on which SPCP integration implementation we are using this is the endpoint 
        /// the third party gateway will call after interacting with SPCP or this will call the gateway
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("resp/iamindividuallogin")] //renamed 20231121 to remove the word Singpass from the URL
        public async Task<ActionResult> IAmIndividualLogin()
        {
            return await SPCPLogin(SPCPFlow.Singpass);
        }

        /// <summary>
        /// LEGACY SINGPASS URL - please reconfigure instances not to use it, will be removed in a future build
        /// </summary>
        [AllowAnonymous]
        [Route("resp/singpasslogin")]
        public async Task<ActionResult> LegacyIAmIndividualLogin()
        {
            logger.LogError(nameof(LegacyIAmIndividualLogin) + " - use of legacy SPCP route {0} (this endpoint will be removed soon)", Request.Path);
            return await IAmIndividualLogin();
        }

        /// <summary>
        /// This handles a request for performing Corppass or Singpass login. The request would come from third party gateway that interacts
        /// with SPCP and then calls us, or for some integrations we would call the gateway from here (in our handler).
        /// We will use a configured implementation of ISPCPHandler to handle the logic for determing the uId
        /// of the respondent to login (which may involve contacting a gateway or may involve extracting information sent to us by a gateway
        /// depending on which integration implementation has been configured. Depending on the implementation there may be other 
        /// SurveyPlus endpoints invoved in the flow too.)
        /// </summary>
        private async Task<ActionResult> SPCPLogin(SPCPFlow flow)
        {
            //Q: Would it be normal/possible for session to be null in this method?
            //   (With regard to all the code that sets error messages in it when its not null)
            //A: Yes, because the session cookie might not get included for reasons such as SameSite
            try
            {

                if (spcpOptions.IsSPCPLogin == false)
                {
                    logger.LogError(nameof(SPCPLogin) + " - SPCP login is not enabled");
                    return RedirectToLoginWithErrorMessage("Singpass/Corppass login is not enabled");
                }

                if (spcpHandler == null)
                    throw new InvalidOperationException("No handler provided"); //check appsettings or configurator

                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(SPCPLogin) + " - Processing SPCP login - flow={0}, spcpHandler={1}, IsEnableSameSiteDashboardInterstitial={2}", flow, spcpHandler, spcpOptions.IsEnableSameSiteDashboardInterstitial);
                }
                
                if (spcpOptions.IsEnableSameSiteDashboardInterstitial)
                {   
                    const string interstitialFlagParameter = "ifipage";

                    //Note: we are in RespController SPCPLogin here so this interstitial will be applied
                    //      for all flows (if enabled and the below preconditions are met)
                    bool isHttpGet = Request.Method.Equals(HttpMethods.Get, StringComparison.OrdinalIgnoreCase);
                    bool isStrictSameSite = securityHeaderSetting.AspSameSite == SameSiteMode.Strict;
                    bool isSessionCookiePresent = Request.Cookies.ContainsKey(SurveyPlusInternet.InternetSessionCookie);
                    bool isFromInterstitialPage = Boolean.TrueString.Equals(Request.Query[interstitialFlagParameter], StringComparison.OrdinalIgnoreCase);
                    string location = Request.GetEncodedUrl();

                    bool isRenderInterstitial =                        
                        isStrictSameSite
                        && isHttpGet
                        && !isFromInterstitialPage
                        && (!isSessionCookiePresent || spcpOptions.IsRenderInterstitialNotwithstandingSession);                        

                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(SPCPLogin) + " -  Interstitial check details - isRenderInterstitial={0}, isHttpGet={1}, isStrictSameSite={2}, isSessionCookiePresent={3} ({4}), IsRenderInterstitialNotwithstandingSession={5}, isFromInterstitialPage={6}, location={7}", isRenderInterstitial, isHttpGet, isStrictSameSite, isSessionCookiePresent, SurveyPlusInternet.InternetSessionCookie, spcpOptions.IsRenderInterstitialNotwithstandingSession, isFromInterstitialPage, location);
                    }

                    if(logger.IsEnabled(LogLevel.Trace))
                    {
                        //n.b. because of app.UseSession() in Startup, a Session reference will exist
                        //     but this doesn't mean the cookie is actually sent to browser yet.
                        string sessionKeys = string.Join(',', HttpContext.Session.Keys);
                        string requestHeaderKeys = string.Join(',', Request.Headers.Keys);
                        string requestCookieKeys = string.Join(',', Request.Cookies.Keys);
                        logger.LogTrace(nameof(SPCPLogin) + " Additional Interstitial check details - method={0}, contentType={1}, sessionId={2}, sessionKeys={3}, requestHeaderKeys={4}, requestCookieKeys={5}", Request.Method, Request.ContentType, HttpContext.Session.Id, sessionKeys, requestHeaderKeys, requestCookieKeys); 
                    }

                    if (isRenderInterstitial)
                    {
                        //Render an interstitial page that refreshes itself to reload current url
                        //as a same-site request.
                        //We append a param to the url which the interstitial is going to make the browser
                        //send another request for, and when we see it in that subsequent refresh then we
                        //know they've gone though the interstitial page and won't render it again. Instead
                        //we'll proceed with the rest of the login logic.
                        string interstitialRefreshLocation = QueryHelpers.AddQueryString(location, interstitialFlagParameter, Boolean.TrueString);
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(SPCPLogin) + " - Returning interstitial page for {0}", interstitialRefreshLocation);
                        }
                        return SurveyPlusInternet.LoginInterstitial(interstitialRefreshLocation);
                    }
                } //end of interstitial logic
                
                SPCPHandlerResult handlerResult = await spcpHandler.Handle(Request, flow);
                if (handlerResult.IsSuccess)
                {
                    if (spcpOptions.Debug)
                    {
                        logger.LogInformation(nameof(SPCPLogin) + " - SPCP Handler returned uId {0}", handlerResult.UserIdentity);
                    }

                    //Check that this respondent exists and is enabled
                    LoginResult loginResult = await respondentService.SPCPLoginAsync(handlerResult.UserIdentity);
                    if (loginResult.IsSuccess)
                    {
                        //Update the http session with the respondent information (thus logging them into the portal)
                        SurveyPlusInternet.RecordRespondentLogin(loginResult, HttpContext);
                        if (spcpOptions.Debug)
                        {
                            logger.LogInformation(nameof(SPCPLogin) + " - Successfully logged in SampleId={0}, UserId={1}", loginResult.Information.SampleId, loginResult.Information.UserId);
                        } 
                        else
                        {
                            //Only log the SampleId (guid) because uid might be sensitive (eg CPEntID, NRIC )
                            logger.LogInformation(nameof(SPCPLogin) + " - Successfully logged in sampleId={0}", loginResult.Information.SampleId);
                        }

                        WogaaSetFirstVisitDashboard();

                        string dashboardUrl = Url.Action("Index", "RespDashboard");
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(SPCPLogin) + " - SPCP login complete, redirecting to dashboard at {0}", dashboardUrl);
                        }                        
                        return Redirect(dashboardUrl);

                        //return RedirectToAction("Index", "RespDashboard");
                    }
                    else
                    {
                        if (spcpOptions.Debug)
                        {
                            //UserIdentity may be sensitive so need SPCP Debig mode on to log it
                            logger.LogError(nameof(SPCPLogin) + " - SurveyPlus respondent login failed with reason {0} for {1}", loginResult.Reason, handlerResult.UserIdentity);
                        }
                        else
                        {
                            //Otherwise just log the reason
                            logger.LogError(nameof(SPCPLogin) + " - SurveyPlus respondent login failed with reason {1}", loginResult.Reason);
                        }
                        //Nb: we don't tell them whether its due to lack of account or locking for security reasons
                        //Note that error messages might not show on the login page when cookies are strict
                        //SameSite depending on how the redirect flows are evaluated by the browser
                        return RedirectToLoginWithErrorMessage("Your account on this site is locked or does not exist. Please contact support.");
                    }
                } //end if handler success
                else
                {
                    //handler fail (this is error condition, expected stuff like locks were handled above)
                    logger.LogError(nameof(SPCPLogin) + " - SPCP Handler failed with reason {0}", handlerResult.Reason);
                    switch (handlerResult.Reason)
                    {
                        case SPCPHandlerResult.Outcome.NotEnabled:
                            return RedirectToLoginWithErrorMessage(
                                "Singpass/Corpass login has been disabled by the system administrator.");

                        case SPCPHandlerResult.Outcome.NotImplemented:
                            //We do not expect to see this one in production
                            return RedirectToLoginWithErrorMessage(
                                "Unable to login (Not Implemented). Please contact support.");

                        default:
                            //Include the time so if they give a screenshot of message it's easier to find details in logs
                            //Also include the reason, but use the int form to avoid revealing too much to the public
                            return RedirectToLoginWithErrorMessage(
                                $"Unable to login. [a{(int)handlerResult.Reason}] Please contact support if this error persists. "
                                + DateTime.Now.ToString("yyyy-MM-dd HH:mm"));
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SPCPLogin) + " - caught unexpected exception, flow={0}", flow);
                //Note that error messages might not show on the login page when cookies are strict
                //SameSite depending on how the redirect flows are evaluated by the browser
                return RedirectToLoginWithErrorMessage(
                    "Unable to login. [b] Please contact support if this error persists."
                    + DateTime.Now.ToString("yyyy-MM-dd HH:mm"));
            }
        }

        private void WogaaSetFirstVisitDashboard()
        {
            //wogaa from IMDA
            //var wogaaTransactionalServiceOn = cache?.Get<bool>("WogaaTransactionalServiceOn") ?? false;
            //var wogaaTrackingId = cache?.Get<string>("WogaaTrackingId");

            //if (wogaaTransactionalServiceOn)
            //{
            //    HttpContext?.Session?.SetString("WogaaTrackingId", wogaaTrackingId);
            //    HttpContext?.Session?.SetString("FirstVisitDashboard", "true");
            //}
        }

        /// <summary>
        /// Store an error message in the session for display by the Login page (ie after redirect)
        /// </summary>
        /// <param name="message"></param>
        private ActionResult RedirectToLoginWithErrorMessage(string message)
        {
            SetErrorMessage(message);
            return RedirectToAction("Login", "Resp");
        }

        /// <summary>
        /// Session key under which we store error messages for the UI to display on next view.
        /// Don't use this, instead call SetErrorMessage and GetErrorMessage which will use it internally
        /// </summary>
        private const string ErrorMessage = "ErrorMessage";

        private void SetErrorMessage(string message)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(SetErrorMessage) + " - {0}", message);
            }
            ISession session = HttpContext?.Session;
            //TODO - the below logic won't work as intended, if there isn't an active session there will
            //       still be a Session object (if we had UseSession at startup), and control will
            //       flow to the SetString and then the session will be considered dirty so if there
            //       wasn't an active one a new one would be started. If there was no cookie yet this means
            //       a new cookie would be returned too, however whether the browser actually sets it in
            //       a subsequent request then depends on SameSite settings and how the redirects are
            //       evaluated by the browser
            if (session == null)
            {
                logger.LogError(nameof(SetErrorMessage) + " - session is null");
            }
            else
            {
                if (message == null)
                {
                    session.Remove("ErrorMessage");
                }
                else
                {
                    session.SetString("ErrorMessage", message);
                }
            }
        }

        private string GetErrorMessage()
        {
            ISession session = HttpContext?.Session;
            return session?.GetString("ErrorMessage");
        }

        //[CheckSessionFilter]
        [Route("resp/getResp")]
        public ActionResult GetUserInfo()
        {
            try
            {
                string uId = SurveyPlusInternet.GetUid(HttpContext.Session);
                return Json(!string.IsNullOrEmpty(uId) ? new ItemSuccessResponse<string>(uId) : new ItemSuccessResponse<string>(""));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetUserInfo) + " - caught unexpected exception");
                return Json(new FailResponse("Cannot get respondent UID"));
            }
        }

        [Route("resp/getRespLastLoginDate")]
        public ActionResult GetUserLastLoginDate()
        {
            try
            {
                string lastLoginDate = HttpContext?.Session?.GetString("lastLoginDate");
                return Json(!string.IsNullOrEmpty(lastLoginDate) ? new ItemSuccessResponse<string>(lastLoginDate) : new ItemSuccessResponse<string>(""));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetUserLastLoginDate) + " - caught unexpected exception");
                return Json(new FailResponse("Cannot get respondent last login date"));
            }
        }

        //TODO - require a POST, but logoff currently needs to support GET because the menu UI control only does GETs
        //       that UI control also seems to send an extra request to / at same time (adding undesireable overhead)
        [Route("resp/logoff")]
        public async Task<ActionResult> Logoff()
        {
            try
            {
                await SurveyPlusInternet.Logoff(logger, HttpContext, respondentService);
                return RedirectToAction("Login");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Logoff) + " - caught unexpected exception");
                return Json(new FailResponse("logoff was not successful"));
            }
        }

        private ActionResult AccessDenied()
        {
            return LocalRedirect(Constants.error404);
        }

#if(DEBUG)
        /// <summary>
        /// For use in development when changing the form.
        /// Use to clear app cache and see the new version of the form
        /// (only affects this internet instance)
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("resp/resetappcache")]
        public ActionResult ResetAppCache([FromServices] IMetadataSourceCache metadataCache)
        {
            try
            {
                CloverRuntime.ResetAppCache();
                metadataCache.ClearCache();
                return Content("App cache reset successful");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ResetAppCache) + " - caught unexpected exception resetting caches: {0}", e.Message);
                return StatusCode(500, "App cache reset incomplete, check log for details");
            }
        }
#endif

        [AllowAnonymous]
        [HttpGet]
        public ActionResult Timeout()
        {
            return Json(new FailResponse("Session Timeout due to inactivity. Please login again."));
        }

        //Moved from the removed Extensions.cs class (we might well move this back at a later stage)
        private static DateTime ToDate(string dateTimeStr, string dateFmt)
        {
            // example: var dt="2011-03-21 13:26".toDate("yyyy-MM-dd HH:mm");
            const DateTimeStyles style = DateTimeStyles.AllowWhiteSpaces;
            var result = DateTime.MinValue;
            DateTime dt;
            if (DateTime.TryParseExact(dateTimeStr, dateFmt,
                CultureInfo.InvariantCulture, style, out dt)) result = dt;
            return result;
        }

        /// <summary>
        /// Returns whether autosave is being enabled and get the autosave delay duration..
        /// This is still called from the respondent dashboard 
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("resp/autosavesettings")]
        public async Task<ActionResult> GetAutoSaveSettings()
        {
            var autoSaveEnabled = await respondentService.GetAutoSaveEnabled();
            var delay = await respondentService.GetAutoSaveDelay();
            var response = new
            {
                autoSaveEnabled = autoSaveEnabled,
                delay = delay
            };

            return Json(new ItemSuccessResponse<object>(response));
        }

    } //end of RespController

}
