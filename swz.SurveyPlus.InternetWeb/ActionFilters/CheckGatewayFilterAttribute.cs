using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Routing;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.InternetWeb.ActionFilters
{
    public class CheckGatewayFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {


            context.HttpContext.Session.SetString("encrUserId", "test123");
            context.HttpContext.Session.SetString("encrTs", "test123");

            var encrUserId = context.HttpContext.Session.GetString("encrUserId");
            var encrTs = context.HttpContext.Session.GetString("encrTs");



            if (string.IsNullOrEmpty(encrUserId) || string.IsNullOrEmpty(encrTs))
                //context.Result = new JsonResult(new { HttpStatusCode.Unauthorized });
                context.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                {
                    controller = Constants.ControllerName.Gateway,
                    action = Constants.MethodName.Login
                }));


            base.OnActionExecuting(context);

        }
    }
}
