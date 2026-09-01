using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.Application;
using System.Collections.Generic;
using swz.SurveyPlus.IntranetApplication;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class UserInterfaceController : Controller
    {
        private readonly ILogger logger;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public UserInterfaceController(
            ILogger<UserInterfaceController> logger,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        [Route("ui/form/{name}/preview")]
        public async Task<ActionResult> GetFormPreview(string name, bool wrapResult = false, bool enableSecurity = false)
        {
            try
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyDesigner))
                    throw new PermissionException($"Requires {Constants.Role.SurveyDesigner}");

                Form form = CloverRuntime.Metadata.GetForm(name); //20260701 - was MTMC
                if (form == null)
                    throw new NotFoundException($"Form {name} is not found!");

                Guid? formStructDivisionId = form?.StructDivisionId;

                if (!await HasStructAccess(formStructDivisionId))
                    throw new PermissionException("Access denied. Not within the same department!");

                return await GetForm(form, wrapResult, enableSecurity);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFormPreview) + " - caught unexpected exception. name={0}, wrapResult={1}, enableSecurity={2}", name, wrapResult, enableSecurity);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Route("ui/form/{name}")]
        public async Task<ActionResult> GetForm(string name, bool wrapResult = false, bool enableSecurity = false)
        {
            try
            {
                Form form = CloverRuntime.Metadata.GetForm(name); //20260701 - was MTMC
                if (form == null)
                {
                    logger.LogError(nameof(GetForm) + " - form not found {0}", name);
                    return Json(new FailResponse("Form is not found!"));
                }

                return await GetForm(form, wrapResult, enableSecurity);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetForm) + " - caught unexpected exception, name={0}, wrapResult={1}, enableSecurity={2}", name, wrapResult, enableSecurity);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Route("ui/flow/{name}")]
        public async Task<ActionResult> GetFlow(string name, string urlFilter)
        {
            try
            {
                Guid? id = null;
                if (!string.IsNullOrEmpty(urlFilter))
                    if (Guid.TryParse(urlFilter, out var entityId))
                        id = entityId;

                var form = await BusinessFlow.GetForm(name, id);
                if (form != null) return await GetForm(form, true, true);

                return Json(new FailResponse("The form is not found for this BusinessFlow!"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFlow) + " - caught unexpected exception, name={0}, urlFilter={1}", name, urlFilter);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Route("ui/localization.js")]
        public ActionResult GetLocalization()
        {
            var cu = CloverRuntime.Security.CurrentUser;
            if (cu == null) return Content("", "application/x-javascript");
            var localization = cu.Localization;
            return Content(CloverRuntime.Metadata.GetLocalizationScript(localization), "application/x-javascript");
        }

        [Route("ui/form/businessobjects.js")]
        public async Task<ActionResult> GetFormsBusinesscode()
        {
            string businessObjects = CloverRuntime.Metadata.GetBusinessObjects();
            return Content(businessObjects, "application/x-javascript");
        }

        [AllowAnonymous]
        [Route("ui/login")]
        public async Task<ActionResult> Login()
        {
            return await GetForm("login");
        }

        [AllowAnonymous]
        [Route("ui/loginTotp")]
        public async Task<ActionResult> LoginTotp()
        {
            return await GetForm("loginTotp");
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("ui/brandingImagePath")]
        public async Task<ActionResult> BrandingImagePath()
        {
            Dictionary<string, object> response = new Dictionary<string, object>
            {
                {"BrandingImagePath", surveyPlusOptions.BrandingImagePath},
            };

            return Json(new ItemSuccessResponse<Dictionary<string, object>>(response));
        }

        #region Private function
        private async Task<ActionResult> GetForm(Form form, bool wrapResult, bool enableSecurity)
        {
            if (!await CloverRuntime.Security.CheckFormPermissionAsync(form, "View"))
                throw new Exception("Access denied!");

            var localization = CloverRuntime.Security.CurrentUser?.Localization;
            if (!string.IsNullOrWhiteSpace(localization))
                await form.FillCustomBlockFormsAndLocalizateAsync(localization);
            else
                await form.FillCustomBlockFormsAsync();

            if (wrapResult)
            {
                if (enableSecurity)
                {
                    var userId = CloverRuntime.Security.CurrentUser.GetOperationUserId();
                    await form.FillPermissionsAsync(userId);
                }

                await form.FillMappingAsync();
                return Json(new ItemSuccessResponse<object>(form));
            }

            var json = form.Source;
            if (string.IsNullOrEmpty(json))
                throw new Exception("This form is not found!");
            return Json(JsonConvert.DeserializeObject(json));
        }

        private static async Task<bool> HasStructAccess(Guid? accessingStructDivisionId)
        {
            if (!accessingStructDivisionId.HasValue) return true;

            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            return childrenStructDivisionIds.Contains(accessingStructDivisionId.Value);
        }
        #endregion
    }
}