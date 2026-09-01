using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using swz.Clover.Core;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using swz.Clover.Core.View;
using swz.SurveyPlus.IntranetApplication;
using swz.SurveyPlus.Application;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using swz.Clover.Core.Security;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{

    [Authorize]
    public class AuditController : Controller
    {
        private readonly ILogger logger;
        private readonly IWebHostEnvironment env;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public AuditController(
            IWebHostEnvironment env, 
            ILogger<AuditController> logger,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.env = env ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [Route("/audit/purgeauditlog")]
        public async Task<ActionResult> PurgeAuditLog()
        {
            try
            {
                User user = await CloverRuntime.Security.GetCurrentUserAsync();
                //20260830 - we are tightening the requirements to need admins for the purge too
                bool isAuthorised 
                    = user.IsInRole(Constants.Role.Admins) 
                    && user.IsInRole(Constants.Role.AuditAdmin);
                if (!isAuthorised)
                    throw new PermissionException($"Requires {Constants.Role.Admins} and {Constants.Role.AuditAdmin}");
                StructDivision structDivision = await StructDivision.SelectByKey(user.StructDivisionId);
                bool isTopLevelStructDivision = structDivision.ParentId == null;
                if (!isTopLevelStructDivision)
                    throw new PermissionException("User is not in the top-level struct division");

                string isArchiveInString = HttpContext.Request.Form["isArchive"];
                string dateArchiveInString = HttpContext.Request.Form["dateArchive"];
                string dataCreatedBeforeInString = HttpContext.Request.Form["dataCreatedBefore"];

                bool isArchive = isArchiveInString == "true" || isArchiveInString == "1";

                DateTime? dateArchive = !string.IsNullOrEmpty(dateArchiveInString)
                    ? Convert.ToDateTime(dateArchiveInString)
                    : (DateTime?)null;

                DateTime dataCreatedBefore = Convert.ToDateTime(dataCreatedBeforeInString);

                if (dateArchive != null && dateArchive <= DateTime.Now)
                    return Json(new FailResponse("Archive Date must be later than current date"));

                if (dataCreatedBefore > DateTime.Now.AddDays(1))
                    return Json(new FailResponse("Events Logged Before date must not be later than tomorrow's date."));

                //Reject request if user has no email for archive case
                if (isArchive && string.IsNullOrEmpty(user.Email))
                    return Json(new FailResponse("Current user does not have an email, email setup is required for archive option enabled."));

                string auditLogsPath = Path.Combine(env.ContentRootPath, surveyPlusOptions.ArchivedAuditLogsFolderPath);

                await AuditLogApplication.SchedulePurgeAuditLogs(auditLogsPath, dataCreatedBefore, dateArchive,  isArchive, user);

                return Json(new SuccessResponse("The system will perform the purge in the background. You will be informed of the outcome via email when it is done."));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(FormatException)
            {   //probably the date
                return Json(new FailResponse("Invalid purge options specified"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PurgeAuditLog) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
    }
}
