using Hangfire;
using Hangfire.Storage;
using Hangfire.Storage.Monitoring;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.License;
using swz.Clover.Core.Security;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class MaintenanceController : Controller
    {
        private readonly ILogger<MaintenanceController> logger;

        public MaintenanceController(ILogger<MaintenanceController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpPost]
        [Route("maintenance/tests/smtp/{behaviour}")]
        public async Task<ActionResult> PerformSmtpTest(string behaviour)
        {
            try
            {
                switch(behaviour ?? "")
                {
                    case "direct":
                    case "async":
                        break;
                    default:
                        return BadRequest("bad behaviour");
                }

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Maintenance))
                    throw new PermissionException($"Requires role {Constants.Role.Maintenance}");

                logger.LogInformation(nameof(PerformSmtpTest) + " - performing SMTP test using {0} behaviour,invoked by {1}", behaviour, currentUser.Name);
                
                switch (behaviour)
                {
                    case "direct":
                        bool ok = await MaintenanceApplication.PerformSmtpTest(currentUser.StructDivisionId.Value);
                        return Json(
                            ok
                            ? new SuccessResponse("Test performed without errors reported")
                            : new FailResponse("There was a problem performing the test. Check logs for details"));

                    case "async":
                        await BusinessProcess.Enqueue.MaintenancePerformSmtpTest(currentUser.StructDivisionId.Value);
                        return Json(new SuccessResponse("Test message will be sent in the background"));

                    default:
                        throw new NotImplementedException();
                }
                
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(PerformSmtpTest) + " - caught an exception");
                if((e.Message??"").StartsWith(Constants.Message.Prefix.ClientReportable))
                {
                    string message = e.Message.Substring(Constants.Message.Prefix.ClientReportable.Length);
                    return Json(new FailResponse(message));
                }
                else
                {
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }
                
            }
        }

        [HttpGet]
        [Route("maintenance/license")]
        public async Task<ActionResult> GetLicense()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Maintenance))
                    throw new PermissionException($"Requires role {Constants.Role.Maintenance}");
                DateTime? expiry = LicenseHelper.CloverLicenseExpiry();

                Dictionary<string, object> details = new Dictionary<string, object>();
                details.Add("host", CloverRuntime.LicenseControl.Host);
                details.Add("expiry", expiry?.ToString(Constants.DatetimeFull8601Format));
                details.Add("description", LicenseHelper.CloverLicenseDescription());
                details.Add("validated", CloverRuntime.LicenseControl.Validated);
                details.Add("requestHost", Request.Host.Value);
                return Json(new ItemSuccessResponse<Dictionary<string, object>>(details));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetLicense) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Download a CSV file showing how much space each table and index is using
        /// </summary>
        [HttpGet]
        [Route("maintenance/database/objectpageusage")]
        public async Task<ActionResult> ObjectPageUsage([FromServices]SurveyPlusOptions options)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Maintenance))
                    throw new PermissionException($"Requires role {Constants.Role.Maintenance}");
                return File(
                    fileStream: await MaintenanceApplication.ObjectPageUsageCSV(),
                    contentType: System.Net.Mime.MediaTypeNames.Text.Csv, 
                    fileDownloadName: $"{options.ShortApplicationName}_ObjectPageUsage_{DateTime.Now.ToString("yyyyMMddTHHmmss")}.csv");
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ObjectPageUsage) + " - caught unexpected exception");
                return StatusCode(
                    (int)HttpStatusCode.InternalServerError,
                    Constants.Message.InternalErrorException);
            }
        }

        [HttpGet]
        [Route("maintenance/hangfire/servers")]
        public async Task<ActionResult> GetHangfireServers()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Maintenance))
                    throw new PermissionException($"Requires role {Constants.Role.Maintenance}");
                //Rather than returning the DTOs directly, we prefer to extract out
                //the info we want and return that so that if a later hangfire
                //version adds something we don't want to send clientside then we
                //won't be inadvertantly exposing it. This also means that we'll catch
                //breaking changes to the dto properties at compile time.
                IMonitoringApi monitoringApi = JobStorage.Current.GetMonitoringApi();
                IList<ServerDto> servers = monitoringApi.Servers();
                logger.LogDebug(nameof(GetHangfireServers) + " - servers={0}", servers);
                ImmutableList<Dictionary<string, object>> results 
                    = servers
                    .OrderByDescending(dto => dto.Heartbeat??dto.StartedAt)
                    .Select(dto => new Dictionary<string, object>() {
                        { "name", dto.Name },
                        { "workersCount", dto.WorkersCount },
                        { "startedAt", dto.StartedAt },
                        { "heartbeat", (dto.Heartbeat==null)?null:DateTime.SpecifyKind(dto.Heartbeat.Value, DateTimeKind.Utc) },
                        { "queues", dto.Queues } })
                    .ToImmutableList();

                return Json(
                    new ItemSuccessResponse<ImmutableList<Dictionary<string,object>>>(results));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetHangfireServers) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
    }
}
