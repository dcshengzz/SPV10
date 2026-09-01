using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;
using swz.Clover.Core.View;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using swz.Clover.Core.Configuration;
using System.Web;
using swz.Clover.Core.Utils;
using swz.Clover.Security.Providers;
using System.Text;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Related to Intranet user account login and functions (no respondent account related methods here)
    /// </summary>
	[Authorize]
	public class AccountController : Controller
    {
        private readonly ILogger logger;
        private readonly CloverOptions cloverOptions;
        private readonly IWindowsAuthenticationChallenger windowsAuthenticationChallenger;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public AccountController(
            ILogger<AccountController> logger, 
            CloverOptions cloverOptions, 
            IWindowsAuthenticationChallenger windowsAuthenticationChallenger,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.cloverOptions = cloverOptions ?? throw new ArgumentNullException(nameof(cloverOptions));
            this.windowsAuthenticationChallenger = windowsAuthenticationChallenger ?? throw new ArgumentNullException(nameof(windowsAuthenticationChallenger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        //n.b. if you are looking for GetAccessibleOrganisation() under setting/organisation route, its in SettingController
        //TODO - we can consider moving it here, but it does have the setting/ path in URL. We should probably change that too?
        //       or just move here and put in the old ones here as synonyms until the client side is updated...

        /// <summary>
        /// Return view for the login page
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> Login()
        {
            try
            {
                ViewData["SurveyPlusOptions"] = surveyPlusOptions;

                SetValidatedTotpLoginId(null);
                User user = await CloverRuntime.Security.GetCurrentUserAsync();
                if (user != null)
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace("Login: Already logged in as {0}, redirecting to /", user.Name);
                    }
                    return LocalRedirect("/");
                }
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace("Login: Returning Login view. IsWindowsAuthentication={0}, IsPasswordAuthentication={1}", cloverOptions.IsWindowsAuthentication, cloverOptions.IsPasswordAuthentication);
                }
                ViewData["IsWindowsAuthentication"] = cloverOptions.IsWindowsAuthentication;
                ViewData["IsPasswordAuthentication"] = cloverOptions.IsPasswordAuthentication;
                ViewData["IsSaml2Authentication"] = cloverOptions.IsSaml2Authentication;
                ViewData["NoAuthenticationOptions"] = !(cloverOptions.IsWindowsAuthentication || cloverOptions.IsPasswordAuthentication || cloverOptions.IsSaml2Authentication);
                ViewData["LoginWithWindowsAuthenticationLabel"] = cloverOptions.LoginWithWindowsAuthenticationLabel;
                ViewData["LoginWithSaml2AuthenticationLabel"] = cloverOptions.LoginWithSaml2AuthenticationLabel;
                return View();
            }
            catch (Clover.Core.License.LicenseException le)
            {
                logger.LogCritical("License Error - {0}", le.Message);
                return new ContentResult() { Content = le.Message, StatusCode = 403 };
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Login) + " - caught unexpected exception");
                return StatusCode(500);
            }

        }

        /// <summary>
        /// Used in WindowsLogin to indicate the type of request flow being handled
        /// (Essentially determines what log messages to use and whether to return response codes or redirects)
        /// </summary>
        private enum WindowsLoginFlow { LoginPageFlow, RedirectionFlow };

        /// <summary>
        /// Manages the intranet login via Windows Authentication (ie: the 'AD Login' feature).
        /// Responsible for issuing the challenge to the browser, and then for signing the user in to Clover
        /// when the browser responds and IIS authenticates the Windows account and provides us that Identity 
        /// in the request.
        /// This method now has two modes of operation. For a GET it assumes it is processing the /windowslogin
        /// redirection flow. For a POST it assumes it is invoked from the account/login button for performaing
        /// a windows login. In the former case it will redirect after authenticating, in the latter it will return
        /// a response to the clientside in the expectation the JS there will send the user on or show a message
        /// as appropriate. 
        /// </summary>
        /// <param name="ReturnUrl">desired URL to proceed to after a successful sign-in</param>
        /// <returns>a challenge, a redirect, or a response</returns>
        [AllowAnonymous]
        [HttpGet]
        [HttpPost]
        public async Task<ActionResult> WindowsLogin(string ReturnUrl)
        {
            //Note: sign-in via Windows Authentication previously took place in the CurrentUser property getter
            //      but is now (20220324) managed via a redirect to here (see AuthorizationFilter) to invoke that logic
            //      and also to issue the 401 challenge (which used to be done in the OnRedirectToLogin callback set in Startup)
            try
            {
                DateTime? licenseExpiry = swz.Clover.Core.License.LicenseHelper.CloverLicenseExpiry();
                if (licenseExpiry.HasValue && licenseExpiry <= DateTime.Now)
                {
                    return Json(new FailResponse($"Surveyplus license has expired on {licenseExpiry}. Please renew your license to continue using the service."));
                }


                bool loggerIsTraceEnabled = logger.IsEnabled(LogLevel.Trace);
                WindowsLoginFlow flow = HttpMethods.Post.Equals(Request.Method)
                    ? WindowsLoginFlow.LoginPageFlow        //For POST we assume its a post from button on the Login screen
                    : WindowsLoginFlow.RedirectionFlow;     //Otherwise (eg GET) we assume its the redirection flow via /windowslogin

                string loginPage;
                switch (flow)
                {
                    case WindowsLoginFlow.LoginPageFlow:
                        ReturnUrl = null; //nb: we won't use this here if its a POST from login page though
                        loginPage = null;
                        break;

                    case WindowsLoginFlow.RedirectionFlow:
                        if (String.IsNullOrWhiteSpace(ReturnUrl)) ReturnUrl = "/";
                        loginPage = string.Format("/account/login?ReturnUrl={0}", HttpUtility.UrlEncode(ReturnUrl) );
                        break;

                    default:
                        throw new NotImplementedException(flow.ToString());
                }

                bool isAuthenticatedInClover = (CloverRuntime.Security.CurrentUser != null);

                ClearConcurrentRespSession();

                //Send them somewhere else or reject them if Clover Windows Authentication integration is not enabled
                if (cloverOptions.IsWindowsAuthentication == false)
                {
                    switch (flow)
                    {
                        case WindowsLoginFlow.LoginPageFlow:
                            //Return a message to login page noting that Windows Authentication feature is disabled
                            if (loggerIsTraceEnabled)
                            {
                                //Log this one at error level as we don't really expect to see it in the wild and it may indicate funny business
                                logger.LogError("WindowsLogin: [Login Page Flow] Windows Authentication feature is disabled yet received a LoginPageFlow request for WindowsLogin so will return error message");
                            }
                            //It may just be they left the login page open when it was still on so let's give them the
                            //benefit of the doubt and return a friendly message for the login page to display :-)
                            return Json(new FailResponse("Windows Authentication is not currently enabled"));

                        case WindowsLoginFlow.RedirectionFlow:
                            //For the redirection flow we will just send them to the normal login page
                            //(they may have bookmarked /windowslogin for convenience last time but its switched off now)
                            string redirectUrl = (isAuthenticatedInClover) ? ReturnUrl : loginPage;
                            if (loggerIsTraceEnabled)
                            {
                                logger.LogTrace("WindowsLogin: [Redirection Flow] Windows Authentication feature is disabled and isAuthenticatedInClover={0} so will redirect to {0}", isAuthenticatedInClover, redirectUrl);
                            }
                            return LocalRedirect(redirectUrl);

                        default:
                            throw new NotImplementedException(flow.ToString());
                    }
                } //end of handling for when the windows auth feature is off

                //Part of the magic that enable windows authentication (auto login without password required)
                //Challenge the browser to present windows creds, browser will re-issue the request with the creds added
                //(assuming it is configured appropriately e.g. such as having domain in the intranet zone etc) 
                //IIS will see the creds (assuming it is configured correctly, ie: Windows Authentication enabled) and
                //will populate the Identity object in the request if this machine considers it a valid windows user.
                //We can use the Name in the identity to map to a Clover login and sign them into Clover.
                //If browser doesnt provide credentials that IIS considers valid then they won't be identified in the request
                //and so would get challenged again. 
                string login = ControllerUtilities.GetIdentityName(Request);
                bool isIdentifiedByIIS = !string.IsNullOrWhiteSpace(login) && (Request.HttpContext.User?.Identity?.IsAuthenticated ?? false);
                if (!isAuthenticatedInClover)
                {
                    if (isIdentifiedByIIS)
                    {
                        if (loggerIsTraceEnabled)
                        {
                            logger.LogTrace("WindowsLogin: Not authenticated in Clover but identified in request as {0} so will validate mapping and sign-in", login);
                        }
                        isAuthenticatedInClover = await CloverRuntime.Security.WindowsAuthenticationValidateAndSignInAsync();
                        if (loggerIsTraceEnabled)
                        {
                            logger.LogTrace("WindowsLogin: Attempted Clover sign-in for login={0}, success={1}", login, isAuthenticatedInClover);
                        }
                    }
                    else
                    {
                        //not identified by iis so issue a challenge to make browser pass some creds
                        if (loggerIsTraceEnabled)
                        {
                            logger.LogTrace("WindowsLogin: Not authenticated in Clover and not identified in request so will issue 401 WWW-Authenticate challenge using {0}", windowsAuthenticationChallenger.ToString());
                        }
                        return await windowsAuthenticationChallenger.IssueChallenge(HttpContext);
                    }
                }

                //At this point we have tried to authenticate them so we will act on the outcome of that as appropriate
                if (isAuthenticatedInClover)
                {
                    switch (flow)
                    {
                        case WindowsLoginFlow.LoginPageFlow:
                            //If they are POSTING from the login page then we return a success response and JS in the login page will
                            //redirect them into the application
                            if (loggerIsTraceEnabled)
                            {
                                logger.LogTrace("WindowsLogin: [Login Page Flow] Is authenticated in Clover as {0} so will return success response", CloverRuntime.Security.CurrentUser?.Name);
                            }
                            return Json(new SuccessResponse());

                        case WindowsLoginFlow.RedirectionFlow:
                            //If we are processing the GET based redirection flow then we can now send them on to the ReturnUrl
                            if (loggerIsTraceEnabled)
                            {
                                logger.LogTrace("WindowsLogin: [Redirection Flow] Is authenticated in Clover as {0} so will redirect to {1}", CloverRuntime.Security.CurrentUser?.Name, ReturnUrl);
                            }
                            return LocalRedirect(ReturnUrl);

                        default:
                            throw new NotImplementedException(flow.ToString());
                    }
                }
                else //not authenticated in Clover
                {
                    //We would end up here if they do have a windows user (checked by IIS) but that windows user isn't mapped in clover or is locked
                    switch (flow)
                    {
                        case WindowsLoginFlow.LoginPageFlow:
                            //If they comne from the login page then we need to return an error message
                            if (loggerIsTraceEnabled)
                            {
                                logger.LogTrace("WindowsLogin: [Login Page Flow] Unable to authenticate in Clover although identified in request as {0} so will clear identity and return error message", login);
                            }
                            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                            //nb: for security reasons we also don't want to confirm the account exists
                            //We include the identity their browser is presenting for troubleshooting purposes
                            string unknownOrInvalidUserMessage = $"{login} is either not mapped to a profile or the mapped profile is locked";
                            return Json(new FailResponse(unknownOrInvalidUserMessage));

                        case WindowsLoginFlow.RedirectionFlow:
                            //For the redirection flow we send them to the login page so they can manually authenticate with a password (if enabled)
                            if (loggerIsTraceEnabled)
                            {
                                logger.LogTrace("WindowsLogin: [Redirection Flow] Unable to authenticate in Clover although identified in request as {0} so will clear identity and redirect to {1}", login, loginPage);
                            }
                            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                            return LocalRedirect(loginPage);

                        default:
                            throw new NotImplementedException(flow.ToString());
                    }
                } //end if not authenticated
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(WindowsLogin) + " - caught unexpected exception");
                return StatusCode(500);
            }
        } //end of WindowsLogin

        /// <summary>
        /// Complete a TOTP (Google Authenticator 2FA) login started in Login
        /// </summary>
        /// <param name="totp"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        public async Task<ActionResult> LoginTotp(string code)
        {
            try
            {
                DateTime? licenseExpiry = swz.Clover.Core.License.LicenseHelper.CloverLicenseExpiry();
                if (licenseExpiry.HasValue && licenseExpiry <= DateTime.Now)
                {
                    return Json(new FailResponse($"Surveyplus license has expired on {licenseExpiry}. Please renew your license to continue using the service."));
                }

                if (!cloverOptions.IsPasswordAuthentication)
                {
                    logger.LogError("{0}: A request to process totp for a password based login was made, but this feature is not enabled", nameof(LoginTotp));
                    return Json(new FailResponse("Password Authentication is not enabled"));
                }

                (string login, DateTime? when) = GetValidatedTotpLoginId();

                logger.LogDebug("{0} called with code {1} for login={2}, validated {3}", nameof(LoginTotp), code, login, when);

                if(login==null)
                {
                    throw new InvalidOperationException("Username and password not validated yet");
                }

                SecurityCredential credential = await SecurityUser.GetCredentialByLogin(login);
                SecurityUser user = await SecurityUser.SelectByKey(credential.SecurityUserId);
                if (user.IsLocked)
                {
                    return Json(new FailResponse("Account is locked"));
                }

                GoogleAuthenticator.Validity validity = GoogleAuthenticator.IsValid(user, code);
                switch (validity)
                {
                    case GoogleAuthenticator.Validity.Correct:
                        SetValidatedTotpLoginId(null);
                        await SignInAsync(login);
                        return Json(new ItemSuccessResponse<string>("redirectToApp"));

                    case GoogleAuthenticator.Validity.Incorrect:
                        return Json(new FailResponse("Incorrect Code"));

                    case GoogleAuthenticator.Validity.BlockedToPreventReplay:
                        //see: https://www.rfc-editor.org/rfc/rfc6238#section-5.2
                        int recommendedDelay = (GoogleAuthenticator.DefaultAllowedAdjacentIntervals + 1) * GoogleAuthenticator.IntervalLength;
                        return Json(new FailResponse($"Please try again with a new code after {recommendedDelay} seconds"));

                    default:
                        throw new NotImplementedException($"Unsupported {nameof(GoogleAuthenticator.Validity)} = {validity}");
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(LoginTotp) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        private async Task SignInAsync(string login, bool remember = false)
        {
            SetValidatedTotpLoginId(null);
            string remoteIpAddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();
            string browserType = Request.Headers["User-Agent"].ToString();
            await CloverRuntime.Security.SignInAsync(login, remember, remoteIpAddress, browserType);
            ClearConcurrentRespSession();
        }

        private const string SKey_ValidatedTotpLogin = "ValidatedTotpLogin";
        private const string SKey_ValidatedTotpLoginTime = "ValidatedTotpLoginTime";

        private (string login, DateTime? when) GetValidatedTotpLoginId()
        {
            string login = HttpContext.Session.GetString(SKey_ValidatedTotpLogin);
            if(string.IsNullOrEmpty(login))
            {
                return (null, null);
            }
            DateTime when = DateTime.ParseExact(HttpContext.Session.GetString(SKey_ValidatedTotpLoginTime), Constants.DatetimeFormat,null);
            return (login, when);
        }

        private void SetValidatedTotpLoginId(string login)
        {
            if(login == null)
            {
                HttpContext.Session.Remove(SKey_ValidatedTotpLogin);
                HttpContext.Session.Remove(SKey_ValidatedTotpLoginTime);
            }
            else
            {
                HttpContext.Session.SetString(SKey_ValidatedTotpLogin, login);
                HttpContext.Session.SetString(SKey_ValidatedTotpLoginTime, DateTime.Now.ToString(Constants.DatetimeFormat));
            }
        }

        /// <summary>
        /// Implements username:password login for the intranet side. 
        /// Note: If TOTP is required for this user then they will not be signed-in yet and will need a call 
        /// to LoginTotp with the correct GA code to complete the process.
        /// </summary>
        /// <param name="login"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        [AllowAnonymous]
		[HttpPost]
        public async Task<ActionResult> Login(string login, string password)
        {
            try
            {

                if(!cloverOptions.IsPasswordAuthentication)
                {
                    logger.LogError(nameof(Login) + " - a request to process password based login for {0} was made, but this feature is not enabled", login);
                    return Json(new FailResponse("Password Authentication is not enabled"));
                }

                if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(password))
                {
                    return BadRequest();
                }

                DateTime? licenseExpiry = swz.Clover.Core.License.LicenseHelper.CloverLicenseExpiry();
                if (licenseExpiry.HasValue && licenseExpiry <= DateTime.Now)
                {
                    logger.LogError(nameof(Login) + " -  Surveyplus license expired on {0}, will not process login for {1}", licenseExpiry, login);

                    return Json(new FailResponse($"Surveyplus license has expired on {licenseExpiry}. Please renew your license to continue using the service."));
                }

                SetValidatedTotpLoginId(null);

                //TODO - refactor this
                List<AppSettings> loginSettings = await AppSettings.SelectAsync(Filter.And.In(
                    new List<string>
                    {
                        "FailedPwdMaxAttempt",
                    }, Constants.FieldName.Name));

                ISecurityProvider_PasswordValidity validity = await CloverRuntime.Security.ValidateUserByLoginAsync(login, password);
                switch (validity)
                {
                    case ISecurityProvider_PasswordValidity.Valid:
                        //login and password correct, no GA code needed
                        await SignInAsync(login);
                        return Json(new ItemSuccessResponse<string>("redirectToApp"));

                    case ISecurityProvider_PasswordValidity.TotpRequired:
                        //login & password correct but also need a GA code
                        SetValidatedTotpLoginId(login);
                        ClearConcurrentRespSession();
                        return Json(new ItemSuccessResponse<string>("totpRequired"));

                    case ISecurityProvider_PasswordValidity.Invalid:
                        //n.b. FailedLoginByUser will log the failure at error level so logging here is debug
                        string res = await CloverRuntime.Security.FailedLoginByUser(login, loginSettings);
                        string remoteIpAddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();
                        if (res == "Locked")
                        {
                            logger.LogDebug(nameof(Login) + " - failed login for locked account {0}, RemoteIpAddress={1}", login, remoteIpAddress);

                            return Json(new FailResponse("Account is locked. Please contact administrators"));
                        }
                        else if (res == "JustLocked")
                        {
                            logger.LogDebug(nameof(Login) + " - failed login for {0} resulting in account being locked, RemoteIpAddress={1}", login, remoteIpAddress);

                            return Json(new FailResponse("Account is locked. Please contact system administrators"));
                        }
                        else
                        {
                            logger.LogDebug(nameof(Login) + " - failed login for account {0}, res={1}, RemoteIpAddress={2}", login, res, remoteIpAddress);

                            return Json(new FailResponse("Login or password is not correct."));
                        }

                    default:
                        throw new NotImplementedException($"Unsupported {nameof(ISecurityProvider_PasswordValidity)} value = {validity}");
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Login) + " - caught unexpected exception, login={0}", login);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Remove uId from session to avoid concurrent respondent and intranet logins
        /// </summary>
        private void ClearConcurrentRespSession()
        {
            //TODO - Remove doesn't throw an error if key is absent, the Any is superflous
            if (HttpContext.Session.Keys.Any(k => k == "uId")) //don't allow concurrent user and resp
                HttpContext.Session.Remove("uId");
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("account/get")]
        public async Task<ActionResult> GetUserInfo()
        {
            try
            {
                var user = await CloverRuntime.Security.GetCurrentUserAsync();
                if (user != null) user.GaSalt = null; //not showing GaSalt
                return Json(new ItemSuccessResponse<User>(user));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetUserInfo) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Route("account/getlicenseexpiry")]
        public async Task<ActionResult> GetLicenseExpiry()
        {
            try
            {
                int expiryDays = surveyPlusOptions.LicenseExpiryDays;
                DateTime? expiryDate = swz.Clover.Core.License.LicenseHelper.CloverLicenseExpiry();

                var response = new
                {
                    ExpiryDate = expiryDate,
                    ExpiryDays = expiryDays
                };

                return Json(new ItemSuccessResponse<object>(response));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetLicenseExpiry) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        //TODO - non-idempotent action so should use a POST and not allow GET here
        //       (note that this is called from both the logout menu
        //       item and by the clientside session timeout script. both will need to be fixed)
        [HttpGet]
        [HttpPost]
        [Route("account/logoff")]
        public async Task<ActionResult> Logoff()
        {
            try
            {
                await CloverRuntime.Security.SignOutAsync();
                return Redirect("/account/login");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Logoff) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("account/unlockuser")]
        public async Task<ActionResult> UnlockUser(string id, bool onLock)
        {
            try
            {
                if (!Guid.TryParse(id, out Guid userId)) return Json(new FailResponse("Invalid input"));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    throw new PermissionException($"Requires {Constants.Role.UserAdmin}");

                SecurityUser targetUser = await SecurityUser.SelectByKey(userId);
                if (targetUser == null) return Json(new FailResponse("Invalid input"));
                if (!await currentUser.IsInStructDivisionAsync((Guid)targetUser.StructDivisionId))
                {
                    throw new PermissionException($"Target user {targetUser.Id} in not in the struct divisions of {currentUser.Id}");
                }

                var msg = "";
                var isLocked = false;
                targetUser.StartTracking();
                if (onLock)
                {
                    msg = "Lock account successful";
                    isLocked = true;
                    targetUser.IsLocked = true;
                }
                else
                {
                    msg = "Unlock account successful";
                    targetUser.IsLocked = false;
                    isLocked = false;
                    targetUser.NumRetry = 0;
                }
                await targetUser.ApplyAsync();

                dynamic m = new ExpandoObject();
                m.message = msg;
                m.isLocked = isLocked;
                m.success = true;

                return Json(m);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UnlockUser) + " - caught unexpected exception, id={0}", id);
                return Json(new FailResponse("Lock/Unlock unsuccessful"));
            }
        }

        /// <summary>
        /// Endpoint for managing the GaSalt field in SecurityUser 
        /// (reset and email for single and multiple users)
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="resetSalt"></param>
        /// <param name="sendEmail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("account/manageAuthenticatorKey")]
        public async Task<ActionResult> ManageAuthenticatorKey(string ids, bool resetSalt, bool sendEmail)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

                if(resetSalt==false && sendEmail==false)
                    return Json(new FailResponse("No action specified"));

                List<Guid> targetUserIds = (ids??"").Split(",").Select(idStr => Guid.Parse(idStr)).ToList();
                if (!targetUserIds.Any())
                    return Json(new FailResponse("No users selected"));
                List<SecurityUser> targetUsers = await SecurityUser.SelectAsync(Filter.And.In(targetUserIds, Constants.FieldName.Id));

                //Verify organisation has access to all those users
                HashSet<Guid> currentUsersStructDivisions = await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser);
                if(!targetUsers.All(u => currentUsersStructDivisions.Contains((Guid)u.StructDivisionId)))
                {
                    throw new PermissionException($"A selected user's structDivisionId is invalid for {currentUser.Name} ({currentUser.Id})");
                }

                string appName = await SettingsHelper.Common.GetApplicationName();

                int resetCount = 0;
                int sendCount = 0;
                foreach (SecurityUser targetUser in targetUsers)
				{
                    try
                    {
                        //Additional behaviour 20221007 - We will also generate a salt if it is missing even if reset wasn't requested
                        //(this would even be the case if a send wasn't requested but the id was in our list. New accounts should now always
                        //have a salt provisioned automatically going forwards, but existing accounts might not have one. Creating one on
                        //demand for such accounts is necessary since the UI will not longer make its absence obvious.
                        bool missingSecret = (string.IsNullOrEmpty(targetUser.GaSalt)); 

                        if (resetSalt || missingSecret)
                        {
                            if (logger.IsEnabled(LogLevel.Debug))
                                logger.LogDebug("Setting new GaSalt for {0}", targetUser.Name);

                            //New behaviour 20220929 - We will now  reset the salt if requested even if no email or locked (but won't send mail)
                            //This is to allow for the use-case of resetting a compromised code
                            targetUser.StartTracking();
                            targetUser.ResetTotpSecret();
                            await targetUser.ApplyAsync();
                            resetCount++;
                        }
                        
                        bool canSendEmail = sendEmail && !targetUser.IsLocked && Email.IsAddressFormatValid(targetUser.Email);
                        if (canSendEmail)
                        {
                            byte[] secret = targetUser.ReadTotpSecret();
                            await BusinessProcess.Enqueue.SendGoogleAuthenticatorSeed(
                                mailTo: targetUser.Email,
                                issuer: appName,
                                accountName: targetUser.Name,
                                secret: secret);
                            sendCount++;
                        } 
                        else if (sendEmail && !canSendEmail && logger.IsEnabled(LogLevel.Debug))
                        {   //Log failure to send when a send was requested
                            logger.LogDebug("Not sending GaSalt to {0}, IsLocked={1}, Email={2}",
                                    targetUser.Name, targetUser.IsLocked, targetUser.Email);
                        }
                    }
                    catch(Exception e)
                    {
                        throw new Exception($"Unexpected exception processing user {targetUser?.Id}", e);
                    }
                }

                StringBuilder responseMessage = new StringBuilder();
                responseMessage.Append(targetUserIds.Count);
                responseMessage.Append(targetUserIds.Count == 1 ? " user selected" : " users selected");
                if(resetSalt || resetCount > 0)
                {
                    if (responseMessage.Length > 0) responseMessage.Append(". ");
                    responseMessage.Append("Reset authenticator key for ");
                    responseMessage.Append(resetCount);
                    responseMessage.Append(resetCount == 1 ? " user" : " users");
                }
                if(sendEmail || sendCount > 0)
                {
                    if (responseMessage.Length > 0) responseMessage.Append(". ");
                    responseMessage.Append("Sending authenticator key to ");
                    responseMessage.Append(sendCount);
                    responseMessage.Append(sendCount == 1 ? " user" : " users");
                }
                responseMessage.Append(". ");
                return Json(new SuccessResponse(responseMessage.ToString()));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ManageAuthenticatorKey) + " - caught unexpected exception, ids={0}, resetSalt={1}. sendEmail={2}", ids, resetSalt, sendEmail);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Route("account/getalternativeacc")]
        public async Task<ActionResult> GetAlternativeAccount()
        {
            try
            {
                List<object> result = new List<object>();
                Dictionary<Guid, SecurityUser> userDict = await SecurityUser.GetAlternativeAccount(CloverRuntime.Security.CurrentUser);

                foreach (SecurityUser u in userDict.Values)
                {
                    result.Add(new { Id = u.Id, Name = u.Name });
                }

                return Json(new ItemSuccessResponse<List<object>>(result));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetAlternativeAccount) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("account/switchacc/{userId}")]
        public async Task<ActionResult> SwitchAccount(Guid userId)
        {
            try
            {
                //Switch to another account (linked by domain login). Throws UnauthorizedAccessException if not valid
                SecurityProcessingStatus result = await CloverRuntime.Security.SwitchAccount(userId);
                if (result == SecurityProcessingStatus.AccountLocked) 
                    return Json(new FailResponse(Constants.Message.AccountLocked));

                return Json(new SuccessResponse());
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SwitchAccount) + " - caught unexpected exception, userId={0}", userId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// This endpoint exists so that client UI can let the server know the client is still active.
        /// (This will allow the cookie expiry to be updated if the client is being actively used
        /// when it might not necessarily be generating any other requests)
        /// </summary>
        [HttpPost]
        [Route("/account/active")]
        public async Task<ActionResult> Active()
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(Active) + " - {0} ({1})", currentUser.Id, currentUser.Name);
            }
            //Currently clientside doesn't use the result data (but this may change later)
            return new JsonResult(new ItemSuccessResponse<Guid>(currentUser.Id));
        }

    }
}