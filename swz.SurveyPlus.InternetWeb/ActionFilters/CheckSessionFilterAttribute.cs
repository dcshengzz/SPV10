using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Routing;
using swz.Clover.Core;
using swz.SurveyPlus.InternetWeb.Controllers;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.InternetWeb.ActionFilters
{
    /// <summary>
    /// Respondent session is managed by the application by way of a uId session attribute. This filter checks the session
    /// of incoming requests to the internet application and if they lack this attribute will redirect to the login or
    /// timeout page appropriately. 
    /// </summary>
    public class CheckSessionFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (!(context.Controller is Controller controller)) return;

            if (!SurveyPlusInternet.IsLoggedIn(context.HttpContext))
            {
                if (!(controller is DataController || controller is UserInterfaceController || controller is SwzDataController))
                {
                    context.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                    {
                        controller = Constants.ControllerName.Respondent,
                        action = Constants.MethodName.Login
                    }));
                }
                else
                {
                    //TODO - following logic could be smarter, e.g. don't return json if a .js was requested
                    context.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                    {
                        controller = Constants.ControllerName.Respondent,
                        action = Constants.MethodName.Timeout
                    }));
                }
            }

            base.OnActionExecuting(context);

        }
    }

    
}
