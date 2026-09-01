using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static swz.SurveyPlus.Application.Constants;
using static swz.SurveyPlus.IntranetApplication.UserAccessMatrixApplication;
using swz.SurveyPlus.Application;
using System.Linq;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class SettingController : Controller
    {
        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<SettingController>();
        private readonly List<string> ROLE_UA_ADMINS = new List<string>() { Constants.Role.UserAdmin, Constants.Role.Admins };

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Returns information about which StructDivision the current user can access in a flat format that you can pump straight into a dropdown
        /// (so the heirarchy is not preserved here).
        /// e.g a list of objects with key, value, text, isPrimary properties, where the text is the organisation name, and both the key and value are
        ///     the organisation's StructDivisionId. The isPrimary flag is added as a convenience to note which of these is the current user's actual
        ///     structDivisionId. The list will be ordered by Organisation Name. 
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [Route("setting/organisation")]
        [Route("setting/organization")]        
        public async Task<ActionResult> GetAccessibleOrganisation()
        {
            try
            {
                //n.b This method is now available to all authenticated user's now.
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid parentStructDivisionId = currentUser.StructDivisionId.Value; //should not be null for a valid user
                List<StructDivision> structDivisions = await StructDivision.SelectChildrenAndThisAsync(parentStructDivisionId);
                List<object> options 
                    = structDivisions
                    .Select(structDivision => (object)new { 
                        key = structDivision.Id, 
                        value = structDivision.Id, 
                        text = structDivision.Name,
                        isPrimary = (structDivision.Id.Equals(parentStructDivisionId) )})
                    .ToList();
                return Json(new ItemSuccessResponse<List<object>>(options));
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(GetAccessibleOrganisation) + " - caught an unexpected exception");
                return Json(new FailResponse(Message.InternalErrorException));
            }
        }

        [Authorize]
        [HttpGet]
        [Route("setting/accessreportschedule/{structDivisionIdStr}")]
        public async Task<ActionResult> GetUserAccessMatrixSchedule(string structDivisionIdStr)
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_UA_ADMINS)) return AccessDenied();

                if (!Guid.TryParse(structDivisionIdStr, out Guid structDivisionId))
                    return BadRequest("Invalid Input - structDivisionIdStr");

                DynamicEntity de = await UserAccessMatrixApplication.GetAccessReportSchedule(structDivisionId);

                return Json(new ItemSuccessResponse<IDictionary<string,object>>(de != null ? de.Dictionary : null));
                
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GetAccessReportSchedule) + " - caught unexpected exception, structDivisionIdStr={0}", structDivisionIdStr);
                return Json(new FailResponse(Message.InternalErrorException));
            }
        }

        [Authorize]
        [HttpPost]
        [Route("setting/saveaccessreportschedule")]
        public async Task<ActionResult> SaveUserAccessMatrixSchedule()
        {
            try
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.UserAdmin))
                    throw new PermissionException($"Requires {Constants.Role.UserAdmin}");

                if(!Guid.TryParse((string)HttpContext.Request.Form["structDivisionId"], out Guid structDivisionId))
                    return BadRequest("Invalid Input - structDivisionId");

                HashSet<Guid> allowedStructDivisions = await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser);
                if (!allowedStructDivisions.Contains(structDivisionId))
                    throw new PermissionException($"Lacks rights to structDivisionId {structDivisionId}");

                if (!bool.TryParse((string)HttpContext.Request.Form["isEnabled"], out bool isEnabled))
                    return BadRequest("Invalid Input - isEnabled");

                string ScheduleType = HttpContext.Request.Form["scheduleType"];
                if ( string.IsNullOrEmpty(ScheduleType) || !UserAccessMatrixApplication.isValidScheduleType(ScheduleType) )
                    return BadRequest("Invalid Input - scheduleType");

                string email = HttpContext.Request.Form["email"];
                if(isEnabled)
                {
                    //Only validate the email if the schedule is enabled. In the meantime they can put whatever they want
                    if (string.IsNullOrWhiteSpace(email))
                    {
                        return BadRequest("Invalid Input - email");
                    }
                        
                    try
                    {
                        Email.SplitAddresses(email);
                    }
                    catch (FormatException)
                    {
                        return BadRequest("Invalid Input - email");
                    }
                }
                
                await UserAccessMatrixApplication.SaveAccessReportSchedule(
                    structDivisionId, 
                    ScheduleType, 
                    isEnabled, 
                    email);
                
                return Json(new SuccessResponse());
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(_logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(SaveUserAccessMatrixSchedule) + " - caught an unexpected exception");
                return Json(new FailResponse(Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Returns whether autosave is being enabled and get the autosave delay duration..
        /// This is still called from the backend portal
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [Route("setting/autosavesettings")]
        public async Task<ActionResult> GetAutoSaveSettings()
        {
            AppSettings autosaveDelay = (await AppSettings.SelectAsync(Filter.And.Equal("AutosaveDelay", "Name"))).FirstOrDefault();
            AppSettings autosaveEnabled = (await AppSettings.SelectAsync(Filter.And.Equal("AutosaveEnabled", "Name"))).FirstOrDefault();
            bool autosaveOn = autosaveEnabled?.Value.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            int delay = 0;
            if(autosaveEnabled == null)
            {
                _logger.LogWarning(Constants.dwAppSettingName.AutosaveEnabled + " - setting not found, Defaulting to true");
            }
            if (autosaveDelay == null)
            {
                delay = 3;
               _logger.LogWarning(Constants.dwAppSettingName.AutosaveDelay + " - setting not found, Defaulting to 3 seconds");

            }
            else if (autosaveDelay != null && int.TryParse(autosaveDelay.Value, out int parsedDelay))
            {
                delay = parsedDelay;
            }

            var response = new
            {
                autoSaveEnabled = autosaveOn,
                delay = delay
            };

            return Json(new ItemSuccessResponse<object>(response));
        }

        //currently duplicated in other controller, might want to find a way to make it shareable #DuplicatedAccessDenied
        //also, such cases should be handled with PermissionException and logged appropriately
        private ActionResult AccessDenied()
        {
            return Content(Constants.Message.Unauthorized);
        }
    }
}
