using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.IntranetApplication;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class HelpController : Controller
    {
        private readonly ILogger logger;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public HelpController(ILogger<HelpController> logger, SurveyPlusOptions surveyPlusOptions)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (surveyPlusOptions == null) throw new ArgumentNullException(nameof(surveyPlusOptions));
            this.logger = logger;
            this.surveyPlusOptions = surveyPlusOptions;
        }

        [Route("help")]
        public ActionResult OnlineHelp()
        {
            if (!surveyPlusOptions.IsHelpEnabled) return Forbid();
            ViewData["SurveyPlusOptions"] = surveyPlusOptions;
            return View("Help");
        }

        [Route("help/get")]
        [HttpGet]
        public async Task<ActionResult> getHelp(string helpType)
        {
            if (!surveyPlusOptions.IsHelpEnabled) return Forbid();
            try
            {
                //nb: in practice 'resp' help will be retrieved via the intranet api through the
                //RespHelpController in the internet application and not here, so this method 
                //would just be used for 'admin' help in the intranet application
                if(!("admin".Equals(helpType) || "resp".Equals(helpType)))
                {
                    return StatusCode(StatusCodes.Status400BadRequest);
                }

                EntityModel qnnHelpModel = await MetadataToModelConverter.GetEntityModelByModelAsync("QNN_HELP");
                Filter filter = Filter.And.Equal(1, "Status"); //leave out draft help
                filter = filter.Merge(Filter.And.Equal(helpType, "Type"));
                Order order = Order.StartAsc("Topic").Asc("Heading");
                List<DynamicEntity> helpItems = await qnnHelpModel.GetAsync(filter, order, Paging.Empty);

                var results = helpItems.Select(item =>
                {
                    Dictionary<String, Object> itemJson = new Dictionary<string, object>();
                    itemJson.Add("Id", item.GetId());
                    itemJson.Add("Topic", item["Topic"]);
                    itemJson.Add("Heading", item["Heading"]);
                    itemJson.Add("Content", item["Content"]);
                    return itemJson;
                });
                return Json(results);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Error getting help");
                return StatusCode(StatusCodes.Status500InternalServerError, e);
            }

        }
    }
}
