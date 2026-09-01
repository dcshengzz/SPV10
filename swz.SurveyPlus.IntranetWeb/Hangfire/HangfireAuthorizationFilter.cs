using Hangfire.Dashboard;
using Hangfire.Annotations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace swz.SurveyPlus.IntranetWeb.Hangfire
{
    public class HangfireAuthorizationFilter : IDashboardAuthorizationFilter
    {
        private readonly string _policyName;

        public HangfireAuthorizationFilter(string policyName)
        {
            _policyName = policyName;
        }

        public bool Authorize([NotNull] DashboardContext context)
        {
            var httpContext = context.GetHttpContext();
            var authService = httpContext.RequestServices.GetRequiredService<IAuthorizationService>();
            var authorize = authService.AuthorizeAsync(httpContext.User, _policyName).ConfigureAwait(false)
                .GetAwaiter().GetResult();
            return authorize.Succeeded;
        }
    }
}