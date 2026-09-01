using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
	[Authorize]
    public class SurveyFormController : Controller
    {
        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<SurveyFormController>();
        private readonly List<string> ROLE_SA_SD = new List<string>() { Constants.Role.SurveyAdmin, Constants.Role.SurveyDesigner };

        [Authorize]
        [HttpGet]
        [Route("surveyform/getsurveyformlist")]
        public async Task<ActionResult> GetSurveyFormList()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                //TODO - check roles using currentUser.IsInRole instead
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                List<Clover.Core.Metadata.Form> result = CloverRuntime.Metadata.CopySurveyFormsCache(currentUser?.StructDivisionId);
                return Json(new ItemSuccessResponse<object>(new { forms = result }));
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(GetSurveyFormList) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Authorize]
        [HttpGet]
        [Route("surveyform/issurveyformnameexist/{formname}")]
        public async Task<ActionResult> IsSurveyFormNameExist(string formname)
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();

                if (string.IsNullOrEmpty(formname)) throw new ArgumentNullException(nameof(formname));
                string decodeFormName = HttpUtility.UrlDecode(formname);

                Clover.Core.Metadata.Form surveyform = await Task.Run(() => { return CloverRuntime.Metadata.GetFormsSettings(decodeFormName); });
                return Json(new { Success = true, isExist = surveyform != null });
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(IsSurveyFormNameExist) + " - caught unexpected exception, formname={0}", formname);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        //TODO - replace this with current idiom of using PermissionException and a catch with logging
        private ActionResult AccessDenied()
        {
            return Content(Constants.Message.Unauthorized);
        }
    }
}
