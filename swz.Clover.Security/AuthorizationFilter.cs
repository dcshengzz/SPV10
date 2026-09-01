using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using swz.Clover.Core;
using System.Linq;
using Microsoft.Extensions.Logging;
using System.Security.Principal;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using System;
using swz.Clover.Core.Configuration;
using System.Web;
using System.Security.Claims;
using System.Net;
using System.Threading.Tasks;

namespace swz.Clover.Security
{
    //Note:
    //The [Authorize] attribute won't work with the clover roles, 
    //so don't  use it with specific role, check CloverRuntime.Security.HaveAnyRole #NoAuthorizeTagWithRole
    //eg, do't try this --> [Authorize(Roles = Role.UserAdmin + "," + Role.Admins)]
    //Just use [Authorize]
    //(Moving this note here for now as lack a better spot to kiv it)

    /// <summary>
    /// Filter factory to allow the ILogger and CloverOptions needed by the filter to be obtained from the
    /// DI service provider. (Startup will need to ensure these are made available in the services.)
    /// In Startup AddMVC use: options.Filters.Add(new AuthorizationFilterFactory());
    /// </summary>
    public class AuthorizationFilterFactory : IFilterFactory
    {
        //Instance can be shared and re-used after creation as it has no mutable state
        //(logger reference and cloverOptions won't need to be changed)
        public bool IsReusable => true;  

        public IFilterMetadata CreateInstance(IServiceProvider serviceProvider)
        {
            ILogger logger = DefaultApplicationLogging.CreateLogger<AuthorizationFilter>();
            CloverOptions cloverOptions = (CloverOptions)serviceProvider.GetService(typeof(CloverOptions)); //Saying CloverOptions 4 time is lucky
            return new AuthorizationFilter(logger, cloverOptions);
        }
    }

    public class AuthorizationFilter : IAsyncAuthorizationFilter
    {
        //nb: be sure keep this filter stateless as instance will be shared across requests

        private readonly ILogger logger;
        private readonly CloverOptions cloverOptions;

        public AuthorizationFilter(ILogger logger, CloverOptions cloverOptions)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (cloverOptions == null) throw new ArgumentNullException(nameof(cloverOptions));
            this.logger = logger;
            this.cloverOptions = cloverOptions;
        }

        // // // //
        //DONT DELETE (for the time being)
        //Following is the previous code for OnAuthorization before making it more explicit (and thus considerably more verbose) and adding some logging .
        //(and more recently changes to the windows authentication mechanism)
        //Presented here to aid comparison:
        //
        //  public void OnAuthorization(AuthorizationFilterContext context)
        //  {
        //      //Part of the magic that enable windows authentication (auto login without password required)
        //      if (context.ActionDescriptor is ControllerActionDescriptor && 
        //          ((ControllerActionDescriptor)context.ActionDescriptor).FilterDescriptors.Any(c=> c.Filter is Microsoft.AspNetCore.Mvc.Authorization.AuthorizeFilter) &&
        //          !((ControllerActionDescriptor)context.ActionDescriptor).FilterDescriptors.Any(c => c.Filter is Microsoft.AspNetCore.Mvc.Authorization.AllowAnonymousFilter))
        //      {
        //          if (context.HttpContext.User.Identity != null && context.HttpContext.User.Identity.IsAuthenticated)
        //          {
        //              if (CloverRuntime.Security.CurrentUser == null)
        //                  context.HttpContext.Response.Redirect(string.Format("/account/login?ReturnUrl={0}", context.HttpContext.Request.Path));
        //          }
        //      }
        //  }
        //
        // // // // // //

        public async Task OnAuthorizationAsync(AuthorizationFilterContext context)
        {
            try
            {
                bool loggerIsTraceEnabled = logger.IsEnabled(LogLevel.Trace);
                string rawTarget = loggerIsTraceEnabled ? context.HttpContext.Features.Get<IHttpRequestFeature>()?.RawTarget : null;
                string path = context.HttpContext.Request.Path;
                IIdentity identity = context.HttpContext.User.Identity;
                bool isControllerRouteRequiringAuthorization
                    = context.ActionDescriptor is ControllerActionDescriptor
                    && ((ControllerActionDescriptor)context.ActionDescriptor).FilterDescriptors.Any(c => c.Filter is Microsoft.AspNetCore.Mvc.Authorization.AuthorizeFilter)
                    && !((ControllerActionDescriptor)context.ActionDescriptor).FilterDescriptors.Any(c => c.Filter is Microsoft.AspNetCore.Mvc.Authorization.AllowAnonymousFilter);
                bool isAuthenticatedInAsp = (identity != null) && identity.IsAuthenticated;
                bool isWindowsIdentity = isAuthenticatedInAsp && identity is WindowsIdentity; //Identity was determined by windows from response to challenge
                bool isClaimsIdentity = isAuthenticatedInAsp && identity is ClaimsIdentity; //Identity was signed in before and stored (eg in encrypted cookie)
                bool isMissingCurrentUserInClover = ((await CloverRuntime.Security.GetCurrentUserAsync()) == null);

                bool isRequiringWindowsAuthenticationCheck
                    = cloverOptions.IsWindowsAuthentication
                    && isControllerRouteRequiringAuthorization
                    && isAuthenticatedInAsp
                    && isWindowsIdentity;

                //This can occur if the AppPool recycles and the UI has not timed out the session, and the ASP.Net Core cookie is still
                //valid to identify the user for ASP Authorisation. If we allow them through, they will be considered authorised by ASP
                //but not by Clover. This is a similar situation to the initial login via WindowsIndentity except in this case they will
                //have the ClaimsIdentity we normally track them with. Yes, the condition below has some redundancy. This is to make
                //the logic explicit to you my dear reader. 
                bool isForgottenByClover
                    = isMissingCurrentUserInClover
                    && isAuthenticatedInAsp
                    && !isWindowsIdentity
                    && isClaimsIdentity;

                if (loggerIsTraceEnabled)
                {
                    LogDetails(LogLevel.Trace, path, identity, isControllerRouteRequiringAuthorization, isRequiringWindowsAuthenticationCheck, isForgottenByClover, rawTarget);
                }

                bool isUnsupportedIdentityType = isAuthenticatedInAsp && !isWindowsIdentity && !isClaimsIdentity;
                if (isUnsupportedIdentityType)
                {   //We don't expect this, and if it happens we don't know what to do with it, so lets just fail fast.   
                    throw new NotImplementedException($"Unsupported Identity Type: {identity.GetType().FullName} ");
                }

                if (isRequiringWindowsAuthenticationCheck)
                {
                    //At this point request is considered authenticated in IIS/ASP.netcore but maybe not in Clover, so we'll check CurrentUser
                    //and if that doesn't resolve to a valid Clover user then we'll send them on a side-quest to the login page to login to Clover

                    Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                    bool isAuthenticatedInClover = (currentUser != null);
                    if (isAuthenticatedInClover)
                    {
                        if (loggerIsTraceEnabled)
                        {
                            logger.LogTrace("OnAuthorization: Authenticated in Clover as {0} for rawTarget={1}", currentUser.Name, rawTarget);
                        }
                    }
                    else
                    {
                        //Redirect to the login page passing it this page so after login user can be directed back to what they were trying to do
                        string windowsLoginUrl = string.Format("/account/windowslogin?ReturnUrl={0}", HttpUtility.UrlEncode(path));
                        if (loggerIsTraceEnabled)
                        {
                            logger.LogTrace("OnAuthorization: Identified in ASP as {0} but not authenticated in Clover so redirecting to {1} for rawTarget={2}", identity?.Name, windowsLoginUrl, rawTarget);
                        }
                        //We must use a RedirectResult here because Response.Redirect sometimes does nothing! Seems to be
                        //if cookie was cleared and User object is found in UserCache? Then it just allows the request through
                        //to the requested path! I don't understand why that is the case but using RedirectResult seems to fix it!
                        context.Result = new RedirectResult(windowsLoginUrl);
                    }
                }//end if isRequiringWindowsAuthenticationCheck
                else if (isForgottenByClover)
                {
                    //User is authenticated in ASP and doesn't need further mapping, but the SecurityProvider doesn't consider them to be CurrentUser.
                    //This can occur when the AppPool recycles which clears the static UserCache in the SecurityProvider
                    await CloverRuntime.Security.RefreshUserAsync(context.HttpContext.User);
                    Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                    if (loggerIsTraceEnabled)
                    {
                        logger.LogTrace("OnAuthorization: Refreshed in Clover as {0} for rawTarget={1}", currentUser.Name, rawTarget);
                    }
                }
            }
            catch(Core.License.LicenseException le)
            {
                logger.LogCritical("License Error - {0}", le.Message);
                context.Result = new ContentResult() { Content = le.Message, StatusCode = 403 };
            }
            catch(Exception e)
            {
                string rawTarget = context.HttpContext.Features.Get<IHttpRequestFeature>()?.RawTarget;
                logger.LogError(e, "OnAuthorizationAsync caught exception processing request for {0}", rawTarget);
                context.Result = new StatusCodeResult((int)HttpStatusCode.InternalServerError); //500
            }

            //note: request that isn't authorized in ASP and isn't authorized in Clover when authorization is required (eg: [Authorize] is applied)
            //      will get redirected by ASP (default is /Account/Login, can be overridden in the AddCookie in startup.cs)

        }//end of OnAuthorization

        /// <summary>
        /// Log details of the request for OnAuthorizationAsync
        /// </summary>
        /// <param name="logLevel"></param>
        /// <param name="path"></param>
        /// <param name="identity"></param>
        /// <param name="isControllerRouteRequiringAuthorization"></param>
        /// <param name="isRequiringWindowsAuthenticationCheck"></param>
        /// <param name="isForgottenByClover"></param>
        /// <param name="rawTarget"></param>
        private void LogDetails(
            LogLevel logLevel, 
            string path, 
            IIdentity identity, 
            bool isControllerRouteRequiringAuthorization, 
            bool isRequiringWindowsAuthenticationCheck,
            bool isForgottenByClover,
            string rawTarget)
        {
            logger.Log(logLevel, "OnAuthorizationAsync: path={0}, Identity type={1}, Identity.Name={2}, Identity.IsAuthenticated={3}, isControllerRouteRequiringAuthorization={4}, isRequiringWindowsAuthenticationCheck={5}, isForgottenByClover={6}, rawTarget={7}", 
                    path,
                    (identity == null) ? "null" : identity.GetType().FullName,
                    identity?.Name,
                    identity?.IsAuthenticated,
                    isControllerRouteRequiringAuthorization,
                    isRequiringWindowsAuthenticationCheck,
                    isForgottenByClover,
                    rawTarget);
        }
    }
}
