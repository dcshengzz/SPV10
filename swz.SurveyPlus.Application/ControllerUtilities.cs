using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Net.Http.Headers;
using swz.Clover.Core;

namespace swz.SurveyPlus.Application
{
    public static class ControllerUtilities
    {
        /// <summary>
        /// Syntactic sugar to check a permission group permission for the current user and throw a PermissionException
        /// if it isn't allowed for them. (Intranet specific, not for use with respondent logins)
        /// </summary>
        /// <exception cref="PermissionException"></exception>
        public static async Task CheckPermission(string permissionGroup, string permission)
        {
            if (!CloverRuntime.Security.CheckPermission(permissionGroup, permission))
            {
                throw new PermissionException($"User does not have {permission} permission in the {permissionGroup} permission group");
            }
        }

        /// <summary>
        /// For use when an already authenticated user (current user) tries to use an endpoint they don't have the necessary role or permission for. 
        /// Logs the details of the stacktrace at warning level and returns an an action result that can be returned to the
        /// client. (i.e a 403 with a fixed "You dont have the permission" style message).
        /// Seeing these in the logs doesn't necessarily indicate nefarious activty, could also be expired cookies, or ui showing
        /// options they shouldn't see etc...
        /// </summary>
        /// <param name="logger">Required, as we want to log these, and do so with the controller's logger category</param>
        /// <param name="details">Exception for the stack trace details (you can pass null here but it is discouraged)</param>
        /// <returns></returns>
        public static ActionResult LogViolationAndDenyPermission(ILogger logger, HttpContext context, PermissionException details)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (context == null) throw new ArgumentNullException(nameof(context));

            //For some discussion on whether to use 401 or 403 see:
            //   https://auth0.com/blog/forbidden-unauthorized-http-status-codes/
            //   https://stackoverflow.com/questions/3297048/403-forbidden-vs-401-unauthorized-http-responses
            //Here we will use 403 since they are authenticated, but that user lacks the necessary role or permission for this feature.
            //For SurveyPlus, if the user is using the client properly(*) then we wouldn't usually expect them to hit this anyway, and for our
            //troubleshooting I think a 403 makes more sense, as 401 will make us think its maybe to do with the AD login stuff?
            //(*) though we might well see this in logs where their alt AD profile session timed out so request got made with their main AD profile

            if(logger.IsEnabled(LogLevel.Warning))
            {
                var user = CloverRuntime.Security.CurrentUser; //may be null (eg, when using alternate authentication like with the api)
                string rawTarget = (context.Features.Get<IHttpRequestFeature>()?.RawTarget) ?? "(not available)";
                string roles = (user == null) ? null : string.Join(',', user.Roles);

                if (details == null)
                {   //We want a stacktrace so we can log the method that we were called from (need to throw for this)
                    try { throw new PermissionException($"{nameof(LogViolationAndDenyPermission)} was called"); } 
                    catch (PermissionException pex) { details = pex; }
                }
                
                logger.LogWarning(details, nameof(LogViolationAndDenyPermission) + " - Name={0}, Id={1}, Roles={2}, StructDivisionId={3}, method={4}, rawTarget={5}", user?.Name, user?.Id, roles, user?.StructDivisionId, context.Request.Method, rawTarget);
            }
            
            ContentResult result = new ContentResult
            {
                StatusCode = StatusCodes.Status403Forbidden,
                Content = (details != null) && (details is SessionInvalidException)
                    ? Constants.Message.SessionInvalid  //special message for this case so that internet side can differentiate
                    : Constants.Message.YouDontHaveThePermission,
                ContentType = System.Net.Mime.MediaTypeNames.Text.Plain,
            };
            return result;
        }

        /// <summary>
        /// Convenience method to get the RawTarget of the HTTP Request. The raw target is not url decoded.
        /// (See docs for IHttpRequestFeature.RawTarget for information).
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public static string GetRawTarget(HttpContext context)
        {
            IHttpRequestFeature requestFeature = context.Features.Get<IHttpRequestFeature>();
            if (requestFeature != null)
            {
                return requestFeature.RawTarget;
            }
            else
            {
                //IHttpRequestFeature is a required feature, so in theory this shouldn't happen
                throw new InvalidOperationException("IHttpRequestFeature is not available from the request's HttpContext");
            }
        }

        public static string GetRawTarget(HttpRequest request)
        {
            return GetRawTarget(request.HttpContext);
        }

        /// <summary>
        /// Convenience method to safely get the name of the Identity in the Request, or null if none available
        /// </summary>
        /// <param name="request"></param>
        /// <returns>request.HttpContext.User?.Identity?.Name</returns>
        public static string GetIdentityName(HttpRequest request)
        {
            return request.HttpContext.User?.Identity?.Name;
        }

        /// <summary>
        /// Get the value of the http Referer header from the request, throwing an InvalidOperationException if it is missing
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public static Uri Referer(HttpRequest request)
        {
            if (request.Headers.TryGetValue(HeaderNames.Referer, out var refererHeader))
            {
                return new Uri(refererHeader.FirstOrDefault());
            }
            else
            {
                throw new InvalidOperationException($"Request has no {HeaderNames.Referer} header");
            }
        }

        //Non-human-facing (i.e. API and API-like) Endpoint Patterns for use in the RequestIsNotHumanFacing method
        //Patterns for endpoints considered non-human facing,
        //so the error controller knows actual html error code should be returned rather than
        //a 'friendly' html 200 message page, or the authentication can return a 403 instead of a 302
        //note that they will be compared against the non-decoded RawTarget (explicitly excluding any query)
        //of the request.
        //20260404 - moved from intranet ErrorController to ControllerUtilities, which means internet app
        //           also gets this now, but both apps still sharing same list
        private static readonly RegexOptions aerOptions = RegexOptions.Compiled | RegexOptions.CultureInvariant | RegexOptions.IgnoreCase;
        private static readonly TimeSpan aerTime = new TimeSpan(hours: 0, minutes: 0, seconds: 1); //to avoid regex timeout exploits/errors
        private static readonly IEnumerable<Regex> apiEndpoints = new List<Regex>
        {
            //Common
            new Regex(@"^(.*\.js)|(.*\.css)$", aerOptions, aerTime), // .js or .css
            new Regex(@"^/data/*", aerOptions, aerTime), //DataController api calls
            new Regex(@"^/ui/*", aerOptions, aerTime), //UiController api calls
            new Regex(@"^(.*\.map)$", aerOptions, aerTime), // .map
            new Regex(@"^/shortlink/*", aerOptions, aerTime), // /shortlink
            new Regex(@"^/favicon.ico$", aerOptions, aerTime), //favicon

            //Internet
            //TODO

            //Intranet
            new Regex(@"^/account/active", aerOptions, aerTime),
            new Regex(@"^/api/*", aerOptions, aerTime), //all U@App api calls
            new Regex(@"^/modelapi/*", aerOptions, aerTime), //3PA modelapi calls
            new Regex(@"^/3pa/*", aerOptions, aerTime), //all 3PA calls except modelapi            
            new Regex(@"^/account/windowslogin", aerOptions, aerTime), // /account/windowslogin           
            new Regex(@"^/debug/*", aerOptions, aerTime), //special surveyplus dev/troubleshooting endpoints
            new Regex(@"^/maintenance/*", aerOptions, aerTime), //UiController api calls
            new Regex(@"^/resp/data", aerOptions, aerTime),
            new Regex(@"^/ConfigAPI", aerOptions, aerTime),
            new Regex(@"^/ConfigAPIUserAdmin", aerOptions, aerTime),
            new Regex(@"^/customcssstyle/*", aerOptions, aerTime),
            new Regex(@"^/dataeditor/*", aerOptions, aerTime),
            new Regex(@"^/dataedit/upload/*", aerOptions, aerTime),
            new Regex(@"^/dataedit/download/*", aerOptions, aerTime),
            new Regex(@"^/dataedit/download/response/*", aerOptions, aerTime),
            new Regex(@"^/datavalidationrule/*", aerOptions, aerTime),
            new Regex(@"^/qnn/*", aerOptions, aerTime),
            new Regex(@"^/deployment/*", aerOptions, aerTime),
            new Regex(@"^/fileStorage/*", aerOptions, aerTime),
            new Regex(@"^/file/*", aerOptions, aerTime),
            new Regex(@"^/globalmailer/*", aerOptions, aerTime),
            new Regex(@"^/help/*", aerOptions, aerTime),
            new Regex(@"^/users/*", aerOptions, aerTime),
            new Regex(@"^/list/*", aerOptions, aerTime),
            new Regex(@"^/report/*", aerOptions, aerTime),
            new Regex(@"^/shortlink/*", aerOptions, aerTime),
            new Regex(@"^/surveyform/*", aerOptions, aerTime),
            new Regex(@"^/swzdata/*", aerOptions, aerTime),
            new Regex(@"^/tags/*", aerOptions, aerTime),
            new Regex(@"^/trklist/*", aerOptions, aerTime),
            new Regex(@"^/workflow/*", aerOptions, aerTime),
        }.AsReadOnly();

        /// <summary>
        /// Previously named RequestIsForAnAPIEndpoint this method
        /// looks at the rawTarget and applies some heuristics to try and decide if this is an API or API-like
        /// request, by which I mean a request for something that doesn't expect a human friendly error page 
        /// if there is a problem (ie: a request for which we should return an actual status code because the
        /// response is going to be handled by code rather than being rendered directly to a browser page to
        /// be read by a human).
        /// </summary>
        /// <returns>false unless it considers the target to be for an api endpoint or other non-human-facing request</returns>
        public static bool RequestIsNotHumanFacing(HttpContext httpContext)
        {
            // Check if the client explicitly asked for JSON
            // SurveyPlus SPA requests *should* do this but at the present time mostly they dont :-(
            if (IsRequestingJson(httpContext.Request))
                return true;

            //Need raw target here because request path may already be pointing to
            //something else like the error controller routes at this point
            string rawTarget = ControllerUtilities.GetRawTarget(httpContext); //not URL-decoded
            if (String.IsNullOrWhiteSpace(rawTarget))
                throw new InvalidOperationException("rawTarget is unexpectedly null or empty"); //just the domain:port would still be "/"

            string rawTargetPath = Path(rawTarget.Trim());

            if (rawTargetPath.Length > 255)
                return true; //Garbage URL, don't waste time trying to match it to anything

            //TODO - (for v10?) consider flipping this, so anything not whitelisted as a top level
            //       page gets considered as an API-like endpoint
            try
            {
                bool isForApi = apiEndpoints.Any(pattern => pattern.IsMatch(rawTargetPath));
                return isForApi;
            }
            catch (RegexMatchTimeoutException tooLong)
            {
                throw new InternalException($"Path matching regex timed out for {rawTargetPath}", tooLong);
            }
        }

        public static bool IsRequestingJson(HttpRequest request)
        {
            return request.Headers.Accept.ToString().Contains(MediaTypeNames.Application.Json, StringComparison.OrdinalIgnoreCase);
        }

        private static string Path(string url)
        {
            int q = url.IndexOf('?');
            return (q == -1) ? url : url.Substring(0, q);
        }
    }
}
