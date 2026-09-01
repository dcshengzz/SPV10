using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using swz.Clover.Core;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.View;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core.Model;
using swz.Clover.Core.Metadata.DbObjects;
using Hangfire;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{

    [Authorize]
    public class GlobalMailerController : Controller
    {
        private readonly ILogger logger;

        public GlobalMailerController(ILogger<GlobalMailerController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [Authorize]
        public IActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Create or edit an email for the GlobalMailer.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("globalmailer/email")]
        public async Task<ActionResult> GlobalMailerEmail()
        {
            if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin))
                return Json(new FailResponse("You don't have the permission"));

            try
            {
                string globalMsgId = HttpContext.Request.Form["globalMsgId"];
                string organization = HttpContext.Request.Form["organization"];
                string target = HttpContext.Request.Form["target"];
                string body = HttpContext.Request.Form["msgContent"];
                string bodyJson = HttpContext.Request.Form["msgContentJson"];
                string emailFrom = HttpContext.Request.Form["emailFrom"];
                if(!string.IsNullOrEmpty(emailFrom) && !Email.IsAddressFormatValid(emailFrom))
                {
                    return Json(new FailResponse("From address is not valid"));
                }
                string subject = HttpContext.Request.Form["subject"];
                string status = HttpContext.Request.Form["status"];
                string scheduledDateString = HttpContext.Request.Form["scheduledDate"];

                if (string.IsNullOrEmpty(organization) || string.IsNullOrEmpty(target) || 
                    string.IsNullOrEmpty(subject) || string.IsNullOrEmpty(body) || 
                    string.IsNullOrEmpty(scheduledDateString))
                {
                    return Json(new FailResponse("Please input all the fields"));
                } 
                else if(target.Equals("activeSamples") && string.IsNullOrEmpty(status))
                {
                    return Json(new FailResponse("Please input all the fields"));
                }

                Guid selectedStruct = Guid.Parse(organization);


                bool isTargetUsers = false;
                switch (target)
                {
                    case "activeSamples":
                        isTargetUsers = false;
                        break;
                    case "intranetUsers":
                        isTargetUsers = true;
                        break;
                    default:
                        return Json(new FailResponse("Invalid Target"));
                }

                DateTime? scheduledDate = !string.IsNullOrEmpty(scheduledDateString)
                    ? Convert.ToDateTime(scheduledDateString)
                    : (DateTime?)null;

                if (scheduledDate != null && scheduledDate <= DateTime.Now)
                    return Json(new FailResponse("Start From must be later than current time"));

                string[] qnnStatusIdsArray = null;
                if (!string.IsNullOrEmpty(status))
                {
                    qnnStatusIdsArray = status.Split(",");
                }

                bool createNewMessage = string.IsNullOrEmpty(globalMsgId);
                if (createNewMessage)
                {
                    if (!(await GlobalMailer.CreateGlobalMsgAndGlobalMsgStatus(
                        scheduledDate, 
                        emailFrom, 
                        subject, 
                        body, 
                        bodyJson, 
                        qnnStatusIdsArray, 
                        selectedStruct, 
                        isTargetUsers)))
                    {
                        //nb: GLobalMailer will log exceptions itself and return false on error
                        return Json(new FailResponse("Internal Error. Failed to create global mail message"));
                    }                        
                }
                else
                {
                    Guid qnnGlobalMsgId = Guid.Parse(globalMsgId);
                    if (!(await GlobalMailer.EditGlobalMsgAndGlobalMsgStatus(
                        qnnGlobalMsgId, 
                        scheduledDate, 
                        emailFrom, 
                        subject, 
                        body, 
                        bodyJson, 
                        qnnStatusIdsArray, 
                        selectedStruct, 
                        isTargetUsers)))
                    {
                        //Global mailer logs its exceptions and just returs failure flag, check log for error details
                        return Json(new FailResponse("Internal Error. Failed to edit global mail message"));
                    } 
                }
                return Json(new SuccessResponse("Global mail has been scheduled"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GlobalMailerEmail) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }


        [HttpPost]
        [Authorize]
        [Route("globalmailer/canceljob")]
        public async Task<ActionResult> CancelJob()
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin))
                    return Json(new FailResponse("You don't have the permission"));

                string strGlobalMsgId = HttpContext.Request.Form["globalMsgId"];

                if (string.IsNullOrEmpty(strGlobalMsgId) || !Guid.TryParse(strGlobalMsgId, out Guid globalMsgId))
                    return Json(new FailResponse("Invalid access"));

                var userId = CloverRuntime.Security.CurrentUser?.Id;
                var userStructDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;


                var childrenStructDivisionIds =
                (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(userStructDivisionId,
                    Constants.FieldName.ParentId))).Select(p => p.Id).Distinct().ToList();


                //get struct divisionid
                var GlobalMsgModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG);
                var entity = (await GlobalMsgModel.GetAsync(Filter.And.Equal(globalMsgId, Constants.FieldName.Id))).FirstOrDefault();
                if (entity == null || (bool?)entity[Constants.FieldName.JobIsCanceled] == true || entity[Constants.FieldName.ScheduledDate] == null)
                    return Json(new FailResponse("Invalid access"));
                var msgStructDivisionId = (Guid?)entity[Constants.FieldName.StructDivisionId];

                if (!childrenStructDivisionIds.Any() || childrenStructDivisionIds.All(id => id != msgStructDivisionId))
                    return Json(new FailResponse("You don't have the permission"));
                if ((DateTime)entity[Constants.FieldName.ScheduledDate] < DateTime.Now)
                    return Json(new FailResponse("Cannot cancel an executed job"));
                BackgroundJob.Delete(entity[Constants.FieldName.JobId]?.ToString());
                entity[Constants.FieldName.JobIsCanceled] = true;
                entity[Constants.FieldName.UpdatedDate] = DateTime.Now;
                entity[Constants.FieldName.UpdatedBy] = userId;

                await GlobalMsgModel.UpdateSingleAsync(entity);

                return Json(new SuccessResponse("Scheduled job has been canceled"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CancelJob) + " - caught unexpected exception");
                return Json(new FailResponse("Job cancelation was not successful. Please contact system administrator"));
            }            
        }
    }
}
