using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Net.Http.Headers;
using System.Net;
using swz.Clover.Core.Configuration;
using System;
using Microsoft.Extensions.Primitives;
using System.Collections.Generic;
using System.Linq;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Part of the magic that enable windows authentication (auto login without password required, a.k.a AD Login)
    /// You can use WindowsAuthenticationChallengerHelper.CreateChallenger 
    /// to get an instance implementing the desired challenge behaviour. 
    /// </summary>
    public interface IWindowsAuthenticationChallenger
    {
        /// <summary>
        /// Issue a challenge to the client to authenticate for purposes of SurveyPlus Windows Logn (this would be a 401). 
        /// Implementation may modify the response directly and will return an ActionResult for the controller to return.
        /// Implementations should override ToString to facilitate logging of which challenger is being used (and its
        /// important details, if any).
        /// </summary>
        /// <param name="context">The HttpContext - response will typically be modified to add headers or status code</param>
        /// <returns>ActionResult</returns>
        public Task<ActionResult> IssueChallenge(HttpContext context);
    }

    public static class WindowsAuthenticationChallengerHelper
    {
        /// <summary>
        /// Utility method that will create a challenger implementing the specified behaviour
        /// </summary>
        public static IWindowsAuthenticationChallenger CreateChallenger(CloverOptions.WA401ChallengeBehaviour behaviour)
        {
            switch (behaviour)
            {
                case CloverOptions.WA401ChallengeBehaviour.auto:
                case CloverOptions.WA401ChallengeBehaviour.windowsChallenge:
                    return new DefaultWindowsAuthenticationChallenger();

                case CloverOptions.WA401ChallengeBehaviour.status401:
                    return new Status401Challenger(isAddNegotiateHeader: false, isAddNtlmHeader: false);

                case CloverOptions.WA401ChallengeBehaviour.headers:
                    return new Status401Challenger(isAddNegotiateHeader: true, isAddNtlmHeader: true);

                case CloverOptions.WA401ChallengeBehaviour.negotiateOnly:
                    return new Status401Challenger(isAddNegotiateHeader: true, isAddNtlmHeader: false);

                case CloverOptions.WA401ChallengeBehaviour.ntlmOnly:
                    return new Status401Challenger(isAddNegotiateHeader: false, isAddNtlmHeader: true);

                case CloverOptions.WA401ChallengeBehaviour.legacy:
                    return new LegacyChallenger();

                default:
                    throw new NotImplementedException($"This factory method has not implemented behaviour: {behaviour}");
            }
        }
    }

    /// <summary>
    /// Placeholder implementation (for keeping DI happy), 
    /// will throw a NotImplementedException if actually called.
    /// </summary>
    public class NotImplementedChallenger : IWindowsAuthenticationChallenger
    {
        public async Task<ActionResult> IssueChallenge(HttpContext context)
        {
            throw new NotImplementedException();
        }

        public override string ToString()
        {
            return nameof(NotImplementedChallenger);
        }
    }

    /// <summary>
    /// Implementation of IWindowsAuthenticationChallenger that calls HttpContext.ChallengeAsync, specifying the "Windows" schema.
    /// To facilitate troubleshooting, this implementation will also add an X-SWZ-Challenger header to the response.
    /// </summary>
    public class DefaultWindowsAuthenticationChallenger : IWindowsAuthenticationChallenger
    {
        public async Task<ActionResult> IssueChallenge(HttpContext context)
        {
            //Add X-SWZ-Challenger. This lets us know the response came from here when troubleshooting AD Login issues
            //(However if handled correctly by the browser you won't see it in the devtools network tab as most browsers
            //swallow the response and send creds when they see the challenge. But if its not working and you cancel the
            //resultant browser dialog you would see it)
            context.Response.Headers.Append(Constants.HeaderNames.Challenger, ToString());

            await context.ChallengeAsync(Microsoft.AspNetCore.Server.IISIntegration.IISDefaults.AuthenticationScheme); //"Windows"
            return new EmptyResult();
        }

        public override string ToString()
        {
            return nameof(DefaultWindowsAuthenticationChallenger);
        }
    }

    /// <summary>
    /// Implementation of IWindowsAuthenticationChallenger that returns a 401 response and (optionally) explicitly adds
    /// Www-Authenticate headers for Negotiate and NTLM. This can be used for troubleshooting or in environments where
    /// the HttpContext.ChallengeAsync doesn't result in the required headers being added before the response reaches the
    /// client. Note that in an IIS environment, IIS (or HTTP.sys) will automatically add Www-Authenticate headers to the
    /// our outgoing response if the status code is 401, so exlicitly adding them will result in superflous headers in the 
    /// response.
    /// See also: https://github.com/dotnet/aspnetcore/issues/5888
    /// To facilitate troubleshooting, this implementation will also add an X-SWZ-Challenger header to the response.
    /// </summary>
    public class Status401Challenger : IWindowsAuthenticationChallenger
    {
        private readonly StringValues wwwAuthenticateHeaders;

        public Status401Challenger(bool isAddNegotiateHeader, bool isAddNtlmHeader)
        {
            List<string> headerValues = new List<string>(2);
            if (isAddNegotiateHeader)
                headerValues.Add("Negotiate");
            if (isAddNtlmHeader)
                headerValues.Add("NTLM");
            wwwAuthenticateHeaders = new StringValues(headerValues.ToArray());
        }

        public async Task<ActionResult> IssueChallenge(HttpContext context)
        {
            //Include details of this challengers configuration to assist with troubleshooting
            context.Response.Headers.Append(Constants.HeaderNames.Challenger, ToString());

            if(wwwAuthenticateHeaders.Any())
            {
                context.Response.Headers.Append(HeaderNames.WWWAuthenticate, wwwAuthenticateHeaders);
            }

            return new StatusCodeResult((int)HttpStatusCode.Unauthorized); //401
        }

        public override string ToString()
        {
            return $"{nameof(Status401Challenger)}[{wwwAuthenticateHeaders}]";
        }
    }

    /// <summary>
    /// Implements previous SurveyPlus Windows Authentication challenge which is a 401 response
    /// with an explicit 'Www-Authenticate: Negotiate,NTLM' header.
    /// To preserve legacy behaviour this does not add a X-SWZ-Challenger header to the response.
    /// In practice setting the header is superflous as IIS seems to add them itself when we return a 401 even
    /// if we already added one, so we are now considering this implementation where we add it ourself to be obsolete.
    /// You can observe this behaviour via the debug/authentication troubleshooter in HelloController using
    /// Postman to send the request. When the Launch Profile for IIS Express has Enable Windows Authentication
    /// and you request just a 401 challenge to elicit a response with status 401, then the two headers are added, 
    /// if it is not enabled (even though nothing else is changed) then you will see that the headers are not added.
    /// are not added.
    /// See also: https://github.com/dotnet/aspnetcore/issues/5888
    /// </summary>
    public class LegacyChallenger : IWindowsAuthenticationChallenger
    {
        public async Task<ActionResult> IssueChallenge(HttpContext context)
        {
            //Code moved here from AccountController.WindowsLogin
            context.Response.Headers.Append(HeaderNames.WWWAuthenticate, "Negotiate,NTLM");
            return new StatusCodeResult((int)HttpStatusCode.Unauthorized); //401
        }

        public override string ToString()
        {
            return nameof(LegacyChallenger);
        }
    }
}