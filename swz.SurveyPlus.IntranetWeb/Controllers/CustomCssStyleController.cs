using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
	[Authorize]
    public class CustomCssStyleController : Controller
    {
        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<CustomCssStyleController>();

        private readonly List<string> ROLE_SA_SD = new List<string>() { Constants.Role.SurveyAdmin, Constants.Role.SurveyDesigner };

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        //Never use it with specific role, check CloverRuntime.Security.HaveAnyRole #NoAuthorizeTagWithRole
        //[Authorize(Roles = Role.SurveyAdmin + "," + Role.SurveyDesigner)]
        [Authorize]
        [HttpGet]
        [Route("customcssstyle/getstylelist")]
        public async Task<ActionResult> GetStyleList()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                List<QNN_STYLE> result = await QNN_STYLE_CACHE.GetStyleList();
                return Json(new { Success = true, Result = result });
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(GetStyleList) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }


        //Never use it with specific role, check CloverRuntime.Security.HaveAnyRole #NoAuthorizeTagWithRole
        //[Authorize(Roles = Role.SurveyAdmin + "," + Role.SurveyDesigner)]
        [Authorize]
        [HttpPost]
        [Route("customcssstyle/clearCache")]
        public async Task<ActionResult> ClearStyleCacheList()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                await Task.Run(() => { QNN_STYLE_CACHE.ClearCacheDisplayData(); });
                return Json(new { Success = true });
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(ClearStyleCacheList) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }


        //currently duplicated in other controller, might want to find a way to make it shareable #DuplicatedAccessDenied
        private ActionResult AccessDenied()
        {
            return Content(Constants.Message.Unauthorized);
        }
    }
}
