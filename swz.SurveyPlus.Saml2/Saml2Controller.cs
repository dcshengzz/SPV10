using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using swz.Clover.Core;
using swz.Clover.Core.Configuration;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using System;
using System.Net.Mime;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Endpoints related to SAML2 login flows for the SurveyPlus intranet application
    /// </summary>
    public class Saml2Controller : Controller
    {
        private static string HtmlEncode(string s) => string.IsNullOrEmpty(s) ? string.Empty : HtmlEncoder.Default.Encode(s);

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<Saml2Controller> logger;
        private readonly IDataProtectionProvider dataProtectionProvider;
        private readonly CloverOptions cloverOptions;
        private readonly Saml2Options saml2Options;
        private readonly Saml2Keys keys;

        private const string correlationProtectorName = "SAML_Correlation";

        public Saml2Controller(
            ILogger<Saml2Controller> logger,
            IDataProtectionProvider dataProtectionProvider,
            CloverOptions cloverOptions,
            Saml2Options saml2Options,
            Saml2Keys keys)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.dataProtectionProvider = dataProtectionProvider ?? throw new ArgumentNullException(nameof(dataProtectionProvider));
            this.cloverOptions = cloverOptions ?? throw new ArgumentNullException(nameof(cloverOptions));
            this.saml2Options = saml2Options ?? throw new ArgumentNullException(nameof(saml2Options));
            this.keys = keys ?? throw new ArgumentNullException(nameof(keys));
        }

        /// <summary>
        /// Generate an AuthnRequest and redirect the browser to the IdP
        /// </summary>
        [AllowAnonymous]
        [HttpGet]
        [Route("/saml2/sendrequest")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public async Task<ActionResult> SendRequest(string ReturnUrl)
        {
            try
            {
                if (cloverOptions.IsSaml2Authentication == false)
                {
                    logger.LogError(nameof(SendRequest) + " - SAML2 login is not enabled");
                    return StatusCode((int)StatusCodes.Status503ServiceUnavailable, "SAML2 login is not enabled");
                }

                //Invalidate current login (if any)
                await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

                //We use the RelayState to track the ReturnUrl (if any)
                string relayState = string.IsNullOrWhiteSpace(ReturnUrl) ? null : ReturnUrl;

                RsaSecurityKey privateKey
                    = saml2Options.IsSignAuthnRequest
                    ? (RsaSecurityKey)await keys.GetServiceProviderVerificationPrivateKey()
                    : null;

                //Create signed query string with SAMLRequest
                AuthnRequest authnRequest = AuthnRequest.FromSaml2Options(saml2Options);  
                SamlRedirect sr = SamlRedirect.FromAuthnRequest(authnRequest, relayState, privateKey);

                //Record the request ID in a secure cookie to check later in ACS
                if(saml2Options.IsSetCorrelationCookie)
                {
                    SamlCorrelationCookie
                    .FromAuthnRequest(authnRequest)
                    .Save(saml2Options.SamlCorrelationCookieName, Response, CorrelationCookieProtector(), saml2Options.CorrelationCookieExpiryMinutes);
                }

                //Redirect user to the IdP to check their credentials
                string samlRequestUrl = $"{saml2Options.Destination}?{sr.QueryString}";
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(SendRequest) + " - redirecting to {0}", samlRequestUrl);
                }
                return Redirect(samlRequestUrl);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(SendRequest) + " - caught unexpected exception");
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

        /// <summary>
        /// Endpoint to which the IdP will POST the Response.
        /// Will check the response and if valid log the user into SurveyPlus intranet application.
        /// </summary>
        [AllowAnonymous]
        [HttpPost]
        [Route("/saml2/acs")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public async Task<ActionResult> AssertionConsumerService([FromServices]ISamlSchemaProvider schemaProvider)
        {
            try
            {
                if (cloverOptions.IsSaml2Authentication == false)
                {
                    logger.LogError(nameof(AssertionConsumerService) + " - SAML2 login is not enabled");
                    return StatusCode((int)StatusCodes.Status503ServiceUnavailable, "SAML2 login is not enabled");
                }

                string samlResponse = Request.Form["SAMLResponse"];
                if (string.IsNullOrWhiteSpace(samlResponse)) return BadRequest("missing SAMLResponse");

                string relayState = Request.Form["RelayState"];

                if (!SamlCorrelationCookie.TryLoad(saml2Options.SamlCorrelationCookieName, Request, CorrelationCookieProtector(), out SamlCorrelationCookie correlationCookie))
                {
                    if (saml2Options.IsRequireCorrelationCookie)
                    {
                        //The cookie is missing, expired (15 mins), or the wrong cookie
                        //which can happen if user leaves IdP page open too long before authenticating
                        //or has mutiple tabs open trying to authenticate, or there was some problem with
                        //browser retaining their cookie or it being stripped.
                        //Would also see this for an IdP initiated login where we never set the cookie
                        //in the first place. 
                        Guid errorId = Guid.NewGuid();
                        logger.LogError(nameof(AssertionConsumerService) + " - the correlation cookie could not be loaded (missing or expired), errorId={0}, expected name={1}, available cookies={2}", errorId, saml2Options.SamlCorrelationCookieName, string.Join(',',Request.Cookies.Keys));
                        return SamlLoginInterstitial(
                                new Uri("/Account/Login", UriKind.Relative),
                                $"Unable to login. Try logging in again or contact system administrator if the error persists. [Reference={errorId}]",
                                delaySeconds: 20);
                    }
                }
                Response.Cookies.Delete(saml2Options.SamlCorrelationCookieName);

                SamlAuthenticationResult result = await Saml2Application.ProcessResponse(
                    saml2Options,
                    keys,
                    schemaProvider,
                    samlResponse,
                    correlationCookie,
                    DateTime.UtcNow);

                switch (result.Outcome)
                {
                    case SamlAuthenticationResult.Reason.Success: //The good (user authenticated ok)
                        if(logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(AssertionConsumerService) + " - Success, NameID={0}, StatusCodes={1}", result.NameID, string.Join(',', result.StatusCodes));
                        }
                        string login = result.NameID;
                        bool ok = await SignInAsync(login);
                        if(ok)
                        {
                            return SamlLoginInterstitial(
                                ReturnUrl(relayState),
                                "Signing in");
                        }
                        else
                        {
                            return SamlLoginInterstitial(
                                new Uri("/Account/Login", UriKind.Relative),
                                $"{login} is either not mapped to a profile or the mapped profile is locked",
                                delaySeconds: 20);
                        }

                    case SamlAuthenticationResult.Reason.Failed: //The bad (user failed auth at IdP)
                        //n.b. for most authentication failures, IdP like Entra won't send a response
                        //     back to the service provider, but there are a few edge-case where they do
                        logger.LogWarning(nameof(AssertionConsumerService) + " - Failed SAMLResponse, StatusCodes={0}", string.Join(',', result.StatusCodes));
                        return SamlLoginInterstitial(
                                new Uri("/Account/Login", UriKind.Relative),
                                $"Login was not successful, returning to login page...",
                                delaySeconds: 20);

                    case SamlAuthenticationResult.Reason.Invalid: //The ugly (response failed validation)
                        Guid errorId = Guid.NewGuid();
                        logger.LogError(nameof(AssertionConsumerService) + " - Invalid SAMLResponse, errorId={0}, message={1}", errorId, result.Message);
                        return SamlLoginInterstitial(
                                new Uri("/Account/Login", UriKind.Relative),
                                $"Unable to login [Reference={errorId}]. Please contact system administrator or try logging in again",
                                delaySeconds: 20);

                    default:
                        throw new NotImplementedException(result.Outcome.ToString());
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AssertionConsumerService) + " - caught unexpected exception");
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

        private Uri ReturnUrl(string relayState)
        {
            return (string.IsNullOrWhiteSpace(relayState) || !Url.IsLocalUrl(relayState))
                ? new Uri("/", UriKind.Relative)
                : new Uri(relayState, UriKind.Relative);
        }

        /// <summary>
        /// Prepare an interstitial page that serves two purposes:
        /// 1. Interstitial to break page flow for SameSite cookie support
        /// 2. Display of bad outcomes (because we can't use the usual login page error display here)
        /// </summary>
        /// <param name="location">must be a relative path</param>
        /// <param name="message">message to display</param>
        /// <param name="delaySeconds">how long before the meta refresh redirects browser</param>
        /// <returns>an html page with a meta-refresh to redirect to the location</returns>
        private ContentResult SamlLoginInterstitial(
            Uri location, 
            string message = "Loading...", 
            int delaySeconds=0)
        {
            if(location==null)
                throw new ArgumentNullException(nameof(location));
            if (location.IsAbsoluteUri)
                throw new ArgumentException("must be relative", nameof(location));
            string encodedLocation = HtmlEncode(location.ToString());
            string encodedMessage = HtmlEncode(message);
            string html = $@"
                <!DOCTYPE html>
                <html>
                    <head>
                        <title>Redirecting...</title>
                        <meta http-equiv='refresh' content='{delaySeconds};url={encodedLocation}' />
                    </head>
                    <body>
                        {encodedMessage} (If the next page does not load automatically, please <a href='{encodedLocation}'>click here</a>).
                    </body>
                </html>";
            return new ContentResult()
            {
                Content = html,
                ContentType = MediaTypeNames.Text.Html,
            };
        }

        /// <summary>
        /// Determine the mapped user based on the NameID (which will be their email address).
        /// Mapping is based on value in the "Primary Domain Login" in the user profile.
        /// If the user isn't mapped or they are locked then return false to caller.
        /// Will add audit events.
        /// </summary>
        private async Task<bool> SignInAsync(string nameID)
        {
            if (string.IsNullOrWhiteSpace(nameID))
                throw new ArgumentException("required", nameof(nameID));

            SecurityUser mappedUser = await SecurityUser.SelectByPrincipal(login: nameID, AuthenticationType.Domain);
            bool isMappedUserFound = mappedUser != null;

            if (isMappedUserFound && logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(SignInAsync) + " - mapped NameID={0} to SecurityUser.Id={1} ({2}), IsLocked={3}", nameID, mappedUser?.Id, mappedUser?.Name, mappedUser?.IsLocked);
            }
            if(!isMappedUserFound && logger.IsEnabled(LogLevel.Warning))
            {
                logger.LogWarning(nameof(SignInAsync) + " - NameID={0} is not mapped to a user", nameID);
            }

            if (isMappedUserFound && !mappedUser.IsLocked)
            {
                string remoteIpAddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();
                string browserType = Request.Headers["User-Agent"].ToString();
                await CloverRuntime.Security.SignInAsync(nameID, false, remoteIpAddress, browserType);
                return true;
            }
            else
            {
                //Audit Log for unknown or locked user login
                await AuditHelper.AuditLogLoginFailed(nameID);
                return false;
            }
        }

        private ITimeLimitedDataProtector CorrelationCookieProtector()
        {
            return dataProtectionProvider.CreateProtector(correlationProtectorName).ToTimeLimitedDataProtector();
        }

    }
}
