using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using swz.Clover.Core;
using swz.Clover.Core.View;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Routing;
using swz.SurveyPlus.IntranetApplication;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Security;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    //renamed from QuestionnarieController
    public class FormPropertiesController : Controller
    {
        private readonly ILogger<FormPropertiesController> logger;

        public FormPropertiesController(ILogger<FormPropertiesController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [Authorize]
        [HttpPost]
        [Route("qnn/duplicate")]
        public async Task<ActionResult> DuplicateQnn(string qnnId, string title)
        {
            try
            {
                if (!Guid.TryParse(qnnId, out Guid sourceId))
                    return BadRequest("qnnId");

                if (!CloverRuntime.Security.CheckPermission(
                    group: Constants.PermissionGroup.Questionnaire,
                    permission: Constants.PermissionGroup.Permission.Edit))
                {
                    throw new PermissionException($"Lacks {Constants.PermissionGroup.Questionnaire} {Constants.PermissionGroup.Permission.Edit} permission");
                }

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                (var msg, var isSucessful) = await FormPropertiesApplication.DuplicateQnn(
                    sourceId, 
                    title, 
                    currentUser);

                return isSucessful
                    ? Json(new SuccessResponse(msg))
                    : Json(new FailResponse(msg));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DuplicateQnn) + " - caught unexpected exception, qnnId={0}, title={1}", qnnId, title);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

    }
}
