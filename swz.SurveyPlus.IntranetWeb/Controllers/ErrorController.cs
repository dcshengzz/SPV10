using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Generates the Error responses.
    /// Startup will do a UseStatusCodePagesWithReExecute to make this handle the error pages (as /error/{code})
    /// This class also plays a role in AD Login in as much as it has to decide what to do with unauthenticated 404s and
    /// has to let the 401 authentication challenges through when appropriate. 
    /// </summary>
    public class ErrorController : Controller
    {

        private const string AccountLogin = "/Account/Login/";
        private const string ErrorPage = "/error/index.html";

        // // // // // // // // // // // // // // //

        private readonly ILogger logger;

        public ErrorController(ILogger<ErrorController> logger)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            this.logger = logger;
        }

        /// <summary>
        /// Special handling for NotFound
        /// </summary>
        /// <returns>redirect to either the error page or login page, or a 404 code if request appears to be for an api endpoint</returns>
		[Route("error/404")]
		public IActionResult Error404()
		{
            try
            {
                bool loggerIsTraceEnabled = logger.IsEnabled(LogLevel.Trace); //nb: also covers higher levels such as debug
                string rawTarget = loggerIsTraceEnabled ? ControllerUtilities.GetRawTarget(HttpContext) : null;
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    //The path of the request will be error/404 when we get here, which isn't very helpful
                    //in knowing what the real request was, but we can still find out from the rawTarget.
                    //Logging this one at debug level (instead of Trace) as expect it will be a more common troubleshooting than
                    //the rest of the stuff we're logging at trace level in this controller.
                    logger.LogDebug("Error404(): rawTarget={0}", rawTarget);
                }

                if (ControllerUtilities.RequestIsNotHumanFacing(HttpContext))
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error404(): Returning a 404 for non-human request for rawTarget={0}", rawTarget);
                    return StatusCode((int)HttpStatusCode.NotFound);
                }

                bool userIsNotAuthenticatedInClover = (CloverRuntime.Security.CurrentUser == null); //BROKEN (due to CurrentUser property actively logging-in windows users)
                if (userIsNotAuthenticatedInClover)
                {
                    //If the user is not logged in then we direct them to the login page to reduce the amount of information we want to expose about structure
                    if (loggerIsTraceEnabled) logger.LogTrace("Error404(): Redirecting to {0} an unauthenticated request for rawTarget={1}", AccountLogin, rawTarget);
                    return LocalRedirect(AccountLogin);
                }
                else
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error404(): Redirecting to {0} an authenticated request by {0} for rawTarget={2}", ErrorPage, CloverRuntime.Security?.CurrentUser?.Name, rawTarget);
                    return LocalRedirect(ErrorPage);
                }
            }
            catch (Exception unexpected)
            {
                //This shouldn't happen, but if it does then we will log it
                //and just return the raw 404 that got us here
                logger.LogError(unexpected, nameof(Error404) + " - caught an unexpected exception");
                return StatusCode((int)HttpStatusCode.NotFound);
            }
        }

        /// <summary>
        /// General http error status handling
        /// (nb: 404 has its own special method above)
        /// </summary>
        /// <param name="code">http status code</param>
        /// <returns>a redirect to a  human-friendly error page or a proper http status code depending on whether request is considered to be for an api or not</returns>
		[Route("error/{code:int}")]
		public IActionResult Error(int code)
		{
            try
            {
                bool loggerIsTraceEnabled = logger.IsEnabled(LogLevel.Trace); //nb: also covers higher levels such as debug
                string rawTarget = loggerIsTraceEnabled ? ControllerUtilities.GetRawTarget(HttpContext) : null;
                if (loggerIsTraceEnabled)
                {
                    logger.LogTrace("Error({0}): rawTarget={1}", code, rawTarget);
                }

                if (ResponseIsAuthenticationChallenge(code))
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error({0}): Allowing a {1} authentication challenge through to client for rawTarget={2}", code, code, rawTarget);
                    return StatusCode(code);
                }
                else if (ControllerUtilities.RequestIsNotHumanFacing(HttpContext))
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error({0}): Allowing a {1} through to non-human client for rawTarget={2}", code, code, rawTarget);
                    return StatusCode(code);
                }

                //StartupIntranet has been changed to allow 403's to be returned, if they are human facing they will reach here
                //which means the logic below will send to login page or errorpage depending on whether user is logged in

                //Decide whether to redirect to login or show an generic error page now (based on whether logged in or not,
                //regardless of error type, so as to avoid revealing too much. Other errors should have been logged by now)
                bool userIsNotAuthenticatedInClover = (CloverRuntime.Security.CurrentUser == null); //BROKEN (due to CurrentUser property actively logging-in windows users)
                if (userIsNotAuthenticatedInClover)
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error({0}): Redirecting a non-API {1} to {2} for rawTarget={3}", code, code, AccountLogin, rawTarget);
                    return LocalRedirect(AccountLogin);
                }
                else
                {
                    if (loggerIsTraceEnabled) logger.LogTrace("Error({0}): Redirecting a {1} to {2} for rawTarget={3}", code, code, ErrorPage, rawTarget);
                    return LocalRedirect(ErrorPage);
                }
            }
            catch(Exception unexpected)
            {
                //This shouldn't happen, but if it does then we will log it
                //and just return the raw status code of the original http error that brought us here
                logger.LogError(unexpected, nameof(Error) + " - caught an unexpected exception");
                return StatusCode(code);
            }            
		}

        private bool ResponseIsAuthenticationChallenge(int code)
        {
            //OLD check was: return (code == 401) && HttpContext.Response.Headers.ContainsKey(HeaderNames.WWWAuthenticate);

            //The Www-Authenticate is added outside our code so by default we don't add it ourself anymore.
            //We must assume any 401 is an auth challenge
            //(so our code that doesn't intend to make a challenge should be using 403 to indicate lack of permission)
            return (code == 401); 
        }

	} //end of ErrorController
}