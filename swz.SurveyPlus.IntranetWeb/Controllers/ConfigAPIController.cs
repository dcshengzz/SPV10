using System;
using System.Collections.Specialized;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.SurveyPlus.IntranetApplication;
using swz.SurveyPlus.Application;
using Microsoft.Extensions.Logging;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Admin Panel
    /// </summary>
    [Authorize]
    public class ConfigAPIController : Controller
    {
        private readonly SurveyPlusOptions surveyPlusOptions;
        private readonly ILogger<ConfigAPIController> logger;

        public ConfigAPIController(
            SurveyPlusOptions surveyPlusOptions, 
            ILogger<ConfigAPIController> logger)
        {
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [Route("Admin")]
        public ActionResult Admin()
        {
            if (!CloverRuntime.Security.CheckAccess(Constants.Role.Admins)) return AccessDenied();
            ViewData["SurveyPlusOptions"] = surveyPlusOptions;
            return View("Admin");
        }

        [Route("ConfigAPI")]
        public async Task<ActionResult> API()
        {
            if (!CloverRuntime.Security.CheckAccess(Constants.Role.Admins)) return AccessDenied();

            var pars = new NameValueCollection();
            foreach (var item in Request.Query) pars.Add(item.Key, item.Value);

            if (Request.HasFormContentType)
                foreach (var item in Request.Form)
                    pars.Add(item.Key, item.Value);

            Stream filestream = null;
            var isPost = Request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase);
            if (isPost && Request.HasFormContentType && Request.Form.Files.Count > 0)
                filestream = Request.Form.Files[0].OpenReadStream();

            try
            {
                var res = await CloverRuntime.Metadata.ConfigAPI(pars, filestream);
                return Json(res);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, nameof(API) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        //TODO - update to the PermissionException idiom
        private ActionResult AccessDenied()
        {
            return Content(Constants.Message.Unauthorized);
        }
    }
}