using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Builder;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using System;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Serves the Index view for the Intranet when logged in
    /// </summary>
    [Authorize]
    public class IntranetIndexPageController : Controller
    {
        /// <summary>
        /// Called by StartupIntranet to add this controller to the routes map
        /// for form, flow, and as the default route
        /// </summary>
        public static void MapRoutes(IRouteBuilder routes)
        {
            string controllerName = nameof(IntranetIndexPageController).Replace("Controller", "");
            string actionName = nameof(Index);

            routes.MapRoute("form", "form/{formName}/{*other}",
                defaults: new { controller = controllerName, action = actionName });

            routes.MapRoute("flow", "flow/{flowName}/{*other}",
                defaults: new { controller = controllerName, action = actionName });
            
            routes.MapRoute(
                name: "default",
                template: "{controller="+controllerName+"}/{action="+actionName+"}/");
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        private readonly SurveyPlusOptions surveyPlusOptions;

        public IntranetIndexPageController(SurveyPlusOptions surveyPlusOptions)
        {
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        /// <summary>
        /// Serves the main application page (that loads the SPA) when logged into the application. 
        /// This includes when refreshing the survey form as a data editor. 
        /// Does not include the page for login, error, or the help, admin, user admin, form designer applications.
        /// The route mapping for is configured in StartupIntranet.Configure
        /// </summary>
        /// <returns></returns>
        public IActionResult Index()
        {
            ViewData["SurveyPlusOptions"] = surveyPlusOptions;

            //TODO - I don't like the following non-thread-safe assignment, but it probably won't cause problems
            //       since its been this way 5 years already
            //see also: https://stackoverflow.com/a/2193445
            if (string.IsNullOrEmpty(CloverRuntime.SiteUrl))
                CloverRuntime.SiteUrl = $"{Request.Scheme}:////{Request.Host.Value}";

            return View(Constants.ViewName.Index);
        }
    }
}