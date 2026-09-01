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
    public class DataValidationRuleController : Controller
    {
        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<DataValidationRuleController>();
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
        [Route("datavalidationrule/getrulelist")]
        public async Task<ActionResult> GetRuleList()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                List<QNN_RULE> result = await QNN_RULE_CACHE.GetRuleList();
                return Json(new { Success = true, Result = result });
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(GetRuleList) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }


        //Never use it with specific role, check CloverRuntime.Security.HaveAnyRole #NoAuthorizeTagWithRole
        //[Authorize(Roles = Role.SurveyAdmin + "," + Role.SurveyDesigner)]
        [Authorize]
        [HttpPost]
        [Route("datavalidationrule/clearCache")]
        public async Task<ActionResult> ClearRuleCacheList()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                await Task.Run(() => { QNN_RULE_CACHE.ClearCacheDisplayData(); });
                return Json(new { Success = true });
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(ClearRuleCacheList) + " - caught unexpected exception");
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
