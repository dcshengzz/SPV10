using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Endpoints in internet application to support the survey delegation features in the respondent dashboard
    /// </summary>
    [CheckSessionFilter]
    public class DelegationController : Controller
    {
        private const string DELEGATION_ACCESS_RETRIES_EXCEED_MSG 
            = "Survey access is locked due to excessive Access Code authorisation failures. Please contact support for assistance.";

        private readonly ILogger logger;
        private IHttpClientFactory httpClientFactory;
        private readonly IRespondentService respondentService;

        public DelegationController(
            ILogger<DelegationController> logger,
            IHttpClientFactory httpClientFactory,
            IRespondentService respondentService)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (respondentService == null) throw new ArgumentNullException(nameof(respondentService));
            this.logger = logger;
            this.httpClientFactory = httpClientFactory;
            this.respondentService = respondentService;
        }

        /// <summary>
        /// Endpoint to validate a survey-specific AccessCode (used by the delegation feature)
        /// Respondent can also always use the DelegationCode to access the survey
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("respondent/accesscode")]
        public async Task<ActionResult> ValidateAccessCode()
        {
            if (!Guid.TryParse(Request.Form["dlsi"], out Guid qnnDplySampleInfoId)) return BadRequest();
            string inputCode = Request.Form["accessCode"];
            if (string.IsNullOrWhiteSpace(inputCode)) return BadRequest();
            try
            {
                bool validated = false;
                bool exceed = await respondentService.IsDelegatedAccessRetriesExceedAsync(qnnDplySampleInfoId);
                if (!exceed)
                {
                    validated = await respondentService.ValidateDelegatedAccessCodeAsync(qnnDplySampleInfoId, inputCode);
                    //Record that this dlsi has been validated in this session so they can access surveys
                    //(eg RespController, UserInterfaceController, etc may check this too)
                    if (validated)
                    {
                        SurveyAccessCodeUtil.NoteAccessCodeValidated(HttpContext.Session, qnnDplySampleInfoId);
                    }
                }

                return ValidationJsonResult(qnnDplySampleInfoId, validated, exceed);
            }
            catch (PermissionException)
            {
                return Unauthorized();
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ValidateAccessCode) + " - caught unexpected exception");
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } //end of ValidateAccessCode

        /// <summary>
        /// Controller method used by action handlers in respdashboard to determine if the respondent needs to enter
        /// an access code to access a specific survey.
        /// Returns a result with a true / false to indicate whether they have already done so in this session
        /// (or if this survey doesn't need it in which case it is deemed as validated
        /// - nb: such a deemed result isn't recorded in the session so would be rechecked on each call).
        /// </summary>
        /// <param name="dlsi">Id in QNN_DPLY_SAMPLE_INFO and vSP_ListSampleInfo</param>
        /// <returns>result json with the id, and whether validated already or not</returns>
        [HttpGet]
        [Route("respondent/accesscode")]
        public async Task<ActionResult> IsAccessCodeValidated(string dlsi)
        {
            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return BadRequest();
            try
            {
                bool validated = SurveyAccessCodeUtil.AccessCodePreviouslyValidated(HttpContext.Session, qnnDplySampleInfoId);
                if (!validated)
                {
                    //If the code isn't actually required then we deem them as 'validated' too
                    bool surveyRequiresAccessCode = await respondentService.IsRequireDelegatedAccessCodeAsync(qnnDplySampleInfoId);
                    if (!surveyRequiresAccessCode) validated = true;
                    //Note that we don't cache this result.
                    //When RequireAccessCode is not set on the deployment then we will check each time as it could get turned on later
                }
                return ValidationJsonResult(qnnDplySampleInfoId, validated);
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(IsAccessCodeValidated) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (PermissionException)
            {
                return Unauthorized();
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(IsAccessCodeValidated) + " - caught unexpected exception, dlsi={0}", dlsi);
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } //end of IsAccessCodeNeeded

        /// <summary>
        /// Delegate a survey (eg: create a delegation record and send an access code)
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("respondent/delegate")]
        public async Task<ActionResult> DelegateSurvey()
        {
            if (!Guid.TryParse(Request.Form["dlsi"], out Guid dplyListSampleId)) return BadRequest();
            try
            {
                string email = Request.Form["email"];
                DateTime validityStart = DateTime.Parse(Request.Form["validityStart"]);
                DateTime validityEnd = DateTime.Parse(Request.Form["validityEnd"]);
                string comments = Request.Form["comments"];
                string name = Request.Form["name"];
                string delegateFromName = Request.Form["delegateFromName"];
                string delegationCode = Request.Form["delegateCode"];

                if (validityStart >= validityEnd || validityEnd <= DateTime.Now)
                {
                    return Json(new FailResponse("Invalid validity period"));
                }
                if (string.IsNullOrEmpty(email))
                {
                    return Json(new FailResponse("Email not specified"));
                }

                DelegateSurveyRequest request = new DelegateSurveyRequest(
                    qnnDplySampleInfoId: dplyListSampleId,
                    email: email,
                    validityStart: validityStart,
                    validityEnd: validityEnd,
                    comments: comments,
                    name: name,
                    delegateFromName: delegateFromName
                );
                DelegateSurveyResult result = await respondentService.DelegateSurveyAsync(request, delegationCode);
                switch (result.Reason)
                {
                    case DelegateSurveyResult.Outcome.Success:
                        return Json(new SuccessResponse());

                    case DelegateSurveyResult.Outcome.InvalidDelegationCode:
                        return Json(new FailResponse("Incorrect Delegation Code"));

                    case DelegateSurveyResult.Outcome.IncorrectEmail:
                        return Json(new FailResponse("Invalid email address"));

                    case DelegateSurveyResult.Outcome.InvalidValidityPeriod:
                        return Json(new FailResponse("Invalid validity period"));

                    case DelegateSurveyResult.Outcome.DelegationAccessRetriesExceed:
                        return Json(new FailResponse(DELEGATION_ACCESS_RETRIES_EXCEED_MSG));

                    default:
                        return Json(new FailResponse("Unable to delegate"));
                }
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(DelegateSurvey) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (PermissionException)
            {
                return Unauthorized();
            }
            catch (Exception e)
            {
                //Log the error details but don't expose them to clientside
                logger.LogError(e, nameof(DelegateSurvey) + " - caught unexpected exception");
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } //end of DelegateSurvey

        /// <summary>
        /// Get the delegation history from QNN_RESP_DELEGATION by DplyListSampleId
        /// </summary>
        /// <returns>List<Dictionary<string, string>></returns>
        /// Fixed for SP-05 for MPA Pentest 2022-04-29, use POST to hide delegateCode in message body instead expose in the URL
        [HttpPost]
        [Route("respondent/viewdelegatelist")]
        public async Task<ActionResult> ViewDelegationByDlsi(string dlsi, string delegateCode)
        {
            try
            {
                Guid qnnDplySampleInfoId = Guid.Parse(dlsi);
                bool exceed = await respondentService.IsDelegatedAccessRetriesExceedAsync(qnnDplySampleInfoId);
                if (exceed)
                    return Json(new FailResponse(DELEGATION_ACCESS_RETRIES_EXCEED_MSG));

                DelegationHistoryResult result = await respondentService.GetDelegationHistoryAsync(qnnDplySampleInfoId, delegateCode);
                switch (result.Reason)
                {
                    case DelegationHistoryResult.Outcome.Success:
                        return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(result.History));

                    case DelegationHistoryResult.Outcome.InvalidDelegationCode:
                        return Json(new FailResponse("Incorrect Delegation Code"));

                    case DelegationHistoryResult.Outcome.NoDelegationHistory:
                        return Json(new FailResponse("Delegation history not found"));


                    default:
                        //to be logged and return error to client
                        throw new Exception("Unexpected reason " + result.Reason);
                }
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(ViewDelegationByDlsi) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ViewDelegationByDlsi) + " - caught unexpected exception, dlsi={0}", dlsi);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("respondent/revokedelegationbydlsi")]
        [Route("respondent/revokedelegationbyid")]
        public async Task<ActionResult> RevokeDelegation()
        {
            if (!Guid.TryParse(Request.Form["dlsi"], out Guid qnnDplySampleInfoId)) return BadRequest();
            Guid? qnnRespDelegationId = null;
            if (Request.Form.ContainsKey("delegateId"))
            {
                //delegateId is only passed if we are revoking for a specific delegation, so we prefer
                //to use null (rather than empty) for the non-specific case to avoid any ambiguity later
                if (!Guid.TryParse(Request.Form["delegateId"], out Guid delegateIdTmp)) return BadRequest();
                qnnRespDelegationId = Guid.Empty.Equals(delegateIdTmp) ? (Guid?)null : delegateIdTmp;
            }
            if (!Request.Form.TryGetValue("delegateCode", out var delegateCode)) return BadRequest();
            try
            {
                DelegateSurveyResult result = await respondentService.RevokeDelegationAsync(delegateCode.First(), qnnDplySampleInfoId, qnnRespDelegationId);
                switch (result.Reason)
                {
                    case DelegateSurveyResult.Outcome.Success:
                        return Json(new SuccessResponse("Delegation revocation successful"));

                    case DelegateSurveyResult.Outcome.InvalidDelegationCode:
                        return Json(new FailResponse("Incorrect Delegation Code"));

                    case DelegateSurveyResult.Outcome.NoDelegationsFound:
                        return Json(new FailResponse("No active delegation(s) found to revoke"));

                    case DelegateSurveyResult.Outcome.DelegationAccessRetriesExceed:
                        return Json(new FailResponse(DELEGATION_ACCESS_RETRIES_EXCEED_MSG));

                    default:
                        throw new Exception("Unexpected result " + result.Reason);
                }
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(RevokeDelegation) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (PermissionException)
            {
                return Unauthorized();
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RevokeDelegation) + " - caught unexpected exception");
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } //end of RevokeDelegation

        /// <summary>
        /// Return a JsonResult with an ItemSuccessResponse whose item has id and validated attributes
        /// (id is the dlsi)
        /// </summary>
        /// <param name="qnnDplySampleInfoId"></param>
        /// <param name="validated"></param>
        /// <returns></returns>
        private ActionResult ValidationJsonResult(Guid qnnDplySampleInfoId, bool validated, bool exceed = false)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            result.Add("id", qnnDplySampleInfoId);
            result.Add("validated", validated);
            result.Add("exceed", exceed);

            if(exceed)
                result.Add("message", DELEGATION_ACCESS_RETRIES_EXCEED_MSG);

            return Json(new ItemSuccessResponse<Dictionary<string, object>>(result));
        }
    } //end of DelegationController
}