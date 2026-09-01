using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.Clover.StarterApplication.Controllers
{
	[Authorize]
    public class FileStorageController : Controller
    {
        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<FileStorageController>();
        private readonly List<string> ROLE_SA_SD = new List<string>() { Constants.Role.SurveyAdmin, Constants.Role.SurveyDesigner };

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        //Never use it with specific role, check CloverRuntime.Security.HaveAnyRole #NoAuthorizeTagWithRole
        //[Authorize(Roles = Constants.Role.SurveyAdmin + "," + Constants.Role.SurveyDesigner)]
        [Authorize]
        [HttpGet]
        [Route("fileStorage/getUploadedFilelist")]
        public async Task<ActionResult> GetUploadedFilelist()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(ROLE_SA_SD)) return AccessDenied();
                var filter = Filter.And.Equal(1, Constants.FieldName.IsLocalStorage);

                Guid currentUserStructDivisionId = (Guid)(await CloverRuntime.Security.GetCurrentUserAsync()).StructDivisionId;
                List<Guid> structDivisions = await StructDivision.SelectChildrenAndThisIdListAsync(currentUserStructDivisionId);
                filter.Merge(Filter.And.In(structDivisions, Constants.FieldName.StructDivisionId));

                List<UploadedFilesPoor> result = await UploadedFilesPoor.SelectAsync(filter);

                return Json(new { Success = true, item = new { fileUploads = result } });
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(GetUploadedFilelist) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        //TODO - should be updated to the new idiom that used PermissionException etc
        private ActionResult AccessDenied()
        {
            return Content(Constants.Message.Unauthorized);
        }
    }
}
