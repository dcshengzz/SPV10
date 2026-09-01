using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using swz.Clover.Core;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.InternetWeb.ActionFilters
{
    public class CheckFormNameFilterAttribute : ActionFilterAttribute
    {
 
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (!(context.Controller is Controller controller)) return;
            var formName = context.ActionArguments.Any(a => a.Key == "name") ? context.ActionArguments.FirstOrDefault(a => a.Key == "name").Value.ToString() : "";

            if (!Constants.SpForms.RespForms.Contains(formName, StringComparer.OrdinalIgnoreCase))
            {
                var form = CloverRuntime.Metadata.GetFormsSettings(formName);
                if (form != null && form.IsSurvey)
                {

                    controller.ViewBag.IsSurvey = true;
                }

            }

            base.OnActionExecuting(context);

        }
    }
}
