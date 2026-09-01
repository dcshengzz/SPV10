using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Net.Http.Headers;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.IntegrationApi;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Metadata.DbObjects;
using System.Net.Mime;
using System.Net;
using static swz.SurveyPlus.IntranetWeb.Controllers.SurveyControllerCommon;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Net.Http.Headers;
using swz.Clover.AuthServices.Jwt.Services;
using swz.Clover.AuthServices.Jwt.Components.Entity;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class IntegrationApiController : Controller
    {
        private readonly ILogger logger;
        private readonly IntranetAppSetting intranetAppSetting;
        private readonly IJwtService jwtService;

        public IntegrationApiController(
            ILogger<IntegrationApiController> logger, 
            IntranetAppSetting intranetAppSetting,
            IJwtService jwtService)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.intranetAppSetting = intranetAppSetting ?? throw new ArgumentNullException(nameof(intranetAppSetting));
            this.jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
        }

        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ConnectivityTest)]
        public async Task<ActionResult> ConnectivityTest()
        {
            try
            {
                logger.LogTrace(nameof(ConnectivityTest) + " - called");

                if(!intranetAppSetting.UnifiedAtApp.IsEnableConnectivityTestResult)
                {
                    return StatusCode((int)HttpStatusCode.NoContent);
                }
                else
                {
                    string machineInfo = "";
                    if(intranetAppSetting.UnifiedAtApp.IsConnectivityTestIncludeMachineInfo)
                    {
                        try
                        {
                            string name = Environment.MachineName;
                            machineInfo = $"on {name}";
                        }
                        catch (Exception e)
                        {
                            logger.LogWarning(e, nameof(ConnectivityTest) + " - failed to get machine info");
                            machineInfo = "on ?";
                        }
                    }

                    string result = $"API Connectivity Test - reached intranet application {machineInfo} via U@App API";

                    //Here we just check for the presense of these headers, we don't verify their values
                    //For Authorization header the current internet impl of the test just passes a fake placeholder
                    //For the apiKey its request util method will always add it.

                    Request.Headers.TryGetValue(IntegrationApiKeys.HeaderApiKey, out var apiKey);
                    if (apiKey.Any()) result += ", with key";

                    Request.Headers.TryGetValue(HeaderNames.Authorization, out var authHeader);
                    if (authHeader.Any()) result += ", with auth";

                    logger.LogInformation(nameof(ConnectivityTest) + " - OK, result={0}", result);
                    return new ContentResult
                    {
                        ContentType = "text/plain",
                        StatusCode = 200,
                        Content = result
                    };
                }
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(ConnectivityTest) + " - caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/plain",
                    StatusCode = 500,
                    Content = "API Connectivity Test encountered an unexpected internal error on the intranet side"
                };
            }
        }

        /// <summary>
        /// GET survey response data for internet side (called by InternetApiDataSource)
        /// </summary>
        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ResponseData)]
        public async Task<ActionResult> GetApiRespAns(
            [FromServices] SurveyResponseReader reader,
            string form)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetApiRespAns) + " - called, form={0}", form);
            }

            if (string.IsNullOrEmpty(form))
                return BadRequest("form not specified");

            //The dlsi will be extracted from the referer url which the internet side passes along as the referer header

            try
            {
                //check clover-apikey
                Request.Headers.TryGetValue(IntegrationApiKeys.HeaderApiKey, out var apiKey);
                if (!apiKey.Any() || !CloverRuntime.IntegrationApiKey.Equals(apiKey.First()))
                {
                    await Clover.Core.Utils.AuditHelper.AuditLog(null, null, null, "InvalidAPIKey");
                    throw new PermissionException($"Invalid or missing header for {IntegrationApiKeys.HeaderApiKey}");
                }

                AuthenticationHeaderValue authHeader 
                    = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
                QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader); //Validate internet user
                if (sample == null) throw new PermissionException("Invalid sample accessToken");

                Clover.Core.Metadata.Form formSettings = CloverRuntime.Metadata.GetFormsSettings(form);
                if (form == null) throw new NotFoundException("Form not found");
                if (!formSettings.IsSurvey) throw new NotSurveyFormException(formSettings);

                (Guid dplySampleInfoId, Guid? qnnRespId, Guid anonymousId) = SurveyResponseIds(Request);

                Dictionary<string, object> data
                    = await reader.ResponseData(dplySampleInfoId, qnnRespId, anonymousId, sample);
                return Json(data);
            }
            catch (SurveyResponseReader.ReadFailedException rfe)
            {
                logger.LogError(rfe, nameof(GetApiRespAns) + " - Failed to retrieve survey response data, reason={0}", rfe.Reason);
                DynamicEntity failed = SurveyResponseDataForFail(msg: rfe.Reason, details: null, formIsReadOnly: rfe.IsFormReadOnly);
                return Json(failed.ToDictionary());
            }
            catch (ResponseIdsExtractionException badIds)
            {
                logger.LogError(badIds, nameof(GetApiRespAns) + " - Error getting response ids from request");
                return BadRequest();
            }
            catch (NotFoundException nfe)
            {
                logger.LogError(nfe, nameof(GetApiRespAns) + " - Form not found: {0}", form);
                return NotFound("invalid survey form");
            }
            catch (NotSurveyFormException nsf)
            {
                logger.LogError(nsf, nameof(GetApiRespAns) + " - Form is not a survey form: {0}", form);
                return NotFound("invalid survey form");
            }
            catch (PermissionException pex)
            {
                ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                return Json(new FailResponse("Unauthorized")); //using a 200 here, not 403, 401
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetApiRespAns) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// POST survey response from internet side
        /// Internet's Respondent survey save / submit calls here 
        /// </summary>
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ResponseData)]
        public async Task<ActionResult> PostApiRespAns(string form, [FromServices] SurveyPlusOptions surveyPlusOptions)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(PostApiRespAns) + " - called, form={0}", form);
            }                

            if (string.IsNullOrEmpty(form))
                return BadRequest("form not specified");

            //The dlsi will be extracted from the referer url which the internet side passes along as the referer header

            try
            {
                //check clover-apikey
                Request.Headers.TryGetValue(IntegrationApiKeys.HeaderApiKey, out var apiKey);
                if (!apiKey.Any() || !CloverRuntime.IntegrationApiKey.Equals(apiKey.First()))
                {
                    await Clover.Core.Utils.AuditHelper.AuditLog(null, null, null, "InvalidAPIKey");
                    throw new PermissionException($"Invalid or missing header for {IntegrationApiKeys.HeaderApiKey}");
                }

                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                Clover.Core.Metadata.Form formSettings = CloverRuntime.Metadata.GetFormsSettings(form);
                if (form == null) throw new NotFoundException("Form not found");
                if (!formSettings.IsSurvey) throw new NotSurveyFormException(formSettings);

                //SurveyResponseUpdater updater = CreateUpdaterForRespondent(Request, sample);
                //(SurveyResponseUpdater.Action saveOrSubmit, string data) = DataForUpdate(Request);
                //SurveyResponseUpdater.UpdateResult result = await updater.Update(saveOrSubmit, data);
                //return Json(SurveyResponseUpdateResult(result));

                object result = await UpdateSurveyResponseAsync(
                    logger,
                    HttpContext,
                    surveyPlusOptions,
                    forDataEditor: null,
                    forRespondent: sample);
                return Json(result);

            }
            catch (NotFoundException nfe)
            {
                logger.LogError(nfe, nameof(PostApiRespAns) + " - Form not found: {0}", form);
                return NotFound("invalid survey form");
            }
            catch (NotSurveyFormException nsf)
            {
                logger.LogError(nsf, nameof(PostApiRespAns) + " - Form is not a survey form: {0}", form);
                return NotFound("invalid survey form");
            }
            catch (PermissionException pex)
            {
                ActionResult result = ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                //Because the response is interpreted by ChangeApiDataForUrlAsync which always assumes it
                //will get JSON, we have to use a FailResponse here, with a 200 , not 403, 401 etc
                if (result is ContentResult contentResult)
                {
                    return Json(new FailResponse(contentResult.Content));
                }
                else
                {
                    return Json(new FailResponse("Unauthorized"));
                }
                
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PostApiRespAns) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Returns whether the deployment for the specified dlsi is anonymous or not
        /// This endpoint can be called without respondent specific jwt, so rather than fetch an entire vSP_ListSampleInfo we just
        /// return the minimal necessary info for the internet side to know whether to proceed as swzanonymous
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.IsAnonymousSurvey)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> IsAnonymousSurvey(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(IsAnonymousSurvey) + " - called, dlsi={0}", dlsi);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return BadRequest("invalid dlsi");

                bool isAnonymous = await DeploymentApplication.IsAnonymousSurvey(qnnDplySampleInfoId);
                return Json(new ItemSuccessResponse<bool>(isAnonymous));
            }
            catch(NotFoundException nfe)
            {
                logger.LogDebug(nfe, nameof(IsAnonymousSurvey) + " - not found");
                //for arguments on whether to return 204 or 404 or what, see:
                //https://stackoverflow.com/questions/11746894/what-is-the-proper-rest-response-code-for-a-valid-request-but-an-empty-data
                //for now I'll just use 404 with custom message for convenience, but Im still not convinced its the better choice...
                return NotFound(new FailResponse(nfe.Message));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(IsAnonymousSurvey) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Endpoint exposed for the internet app to call the intranet app to process
        /// a delegation to a respondent on POST request.
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.DelegateSurvey)]
        [HttpPost]
        public async Task<ActionResult> DelegateSurvey([FromBody] DelegateSurveyRequest request)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DelegateSurvey) + " - called");
            }

            if (!Request.Headers.TryGetValue(Constants.HeaderNames.DelegationCode, out var delegationCodeHeader))
            {
                logger.LogError(nameof(DelegateSurvey) + " - called without expected header {0}", Constants.HeaderNames.DelegationCode);
                return BadRequest("DelegationCode");
            }
            string delegateCode = delegationCodeHeader.First();

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                DelegateSurveyResult result = await DelegationApplication.DelegateSurvey(request, delegateCode);
                return Json(result);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DelegateSurvey) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.DelegationHistory)]
        [HttpGet]
        public async Task<ActionResult> GetDelegationHistory(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetDelegationHistory) + " - called, dlsi={0}", dlsi);
            }

            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId))
            {
                logger.LogError(nameof(GetDelegationHistory) + " - called without a parseable dlsi");
                return BadRequest("dlsi");
            }
            if (!Request.Headers.TryGetValue(Constants.HeaderNames.DelegationCode, out var delegationCodeHeader))
            {
                logger.LogError(nameof(GetDelegationHistory) + " - called without expected header {0}, qnnDplySampleInfoId={1}", Constants.HeaderNames.DelegationCode, qnnDplySampleInfoId);
                return BadRequest("DelegationCode");
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                string delegateCode = EncryptionHelper.DecryptStr(delegationCodeHeader.First(), Constants.LoginKey, Constants.LoginIv);
                DelegationHistoryResult result 
                    = await DelegationApplication.CheckMasterDelegationCodeAndUpdateAttempts(qnnDplySampleInfoId, delegateCode)
                        ? await DelegationApplication.GetDelegationHistory(qnnDplySampleInfoId)
                        : DelegationHistoryResult.Fail(DelegationHistoryResult.Outcome.InvalidDelegationCode);                
                return Json(result);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetDelegationHistory) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Endpoint exposed for the internet app to call the intranet app to process
        /// a revoke delegation to a respondent on POST request.
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.RevokeAllDelegation)]
        [HttpPost]
        public async Task<ActionResult> ApiRespRevokeDelegationByDlsi(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ApiRespRevokeDelegationByDlsi) + " - called, dlsi={0}", dlsi);
            }

            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) 
            {
                logger.LogError(nameof(ApiRespRevokeDelegationByDlsi) + " - called without parseable dlsi, dlsi={0}", dlsi);
                return BadRequest("dlsi"); 
            }
            if (!Request.Headers.TryGetValue(Constants.HeaderNames.DelegationCode, out var delegationCodeHeader))
            {
                logger.LogError(nameof(ApiRespRevokeDelegationByDlsi) + " - called without expected header {0}, qnnDplySampleInfoId={1}", Constants.HeaderNames.DelegationCode, qnnDplySampleInfoId);
                return BadRequest("DelegationCode");
            }
            string encryptedDelegationCode = delegationCodeHeader.First();
            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                DelegateSurveyResult result 
                    = await DelegationApplication.RespRevokeDelegationByDlsi(qnnDplySampleInfoId, encryptedDelegationCode);
                return Json(result);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ApiRespRevokeDelegationByDlsi) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        } //end of ApiRespRevokeDelegationByDlsi

        /// <summary>
        /// Endpoint exposed for the internet app to call the intranet app to process
        /// a revoke delegation to a respondent on POST request.
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.RevokeSingleDelegation)]
        [HttpPost]
        public async Task<ActionResult> ApiRespRevokeDelegationById()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ApiRespRevokeDelegationById) + " - called");
            }

            //TODO - follow-up: the route has {id} path parameter but seems like it isn't being used in here?

            if (!Request.HasFormContentType)
            {
                logger.LogError(nameof(ApiRespRevokeDelegationById) + " - called without form");
                return BadRequest("no form");
            }                
            if (!Guid.TryParse(Request.Form["dlsi"], out Guid qnnDplySampleInfoId))
            {
                logger.LogError(nameof(ApiRespRevokeDelegationById) + " - called without a parseable dlsi");
                return BadRequest("dlsi");
            }
            if (!Guid.TryParse(Request.Form["delegateId"], out Guid qnnRespDelegationId))
            {
                logger.LogError(nameof(ApiRespRevokeDelegationById) + " - called without a parseable delegateId");
                return BadRequest("delegateId");
            }
            if (!Request.Headers.TryGetValue(Constants.HeaderNames.DelegationCode, out var delegationCodeHeader))
            {
                logger.LogError(nameof(ApiRespRevokeDelegationById) + " - called without expected header {0}, qnnDplySampleInfoId={1}, qnnRespDelegationId={2}", Constants.HeaderNames.DelegationCode, qnnDplySampleInfoId, qnnRespDelegationId);
                return BadRequest("DelegationCode");
            }
            string delegateCode = delegationCodeHeader.First();
            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                DelegateSurveyResult result 
                    = await DelegationApplication.RespRevokeDelegationById(qnnDplySampleInfoId, qnnRespDelegationId, delegateCode);
                return Json(result);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ApiRespRevokeDelegationById) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        } //end of ApiRespRevokeDelegationById

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ValidateDelegation)]
        [HttpPost]
        public async Task<ActionResult> ValidateDelegationCode(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ValidateDelegationCode) + " - called, dlsi={0}", dlsi);
            }

            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId))
            {
                logger.LogError(nameof(ValidateDelegationCode) + " - called without a parseable dlsi");
                return BadRequest("dlsi");
            }
            if (!Request.Headers.TryGetValue(Constants.HeaderNames.DelegationCode, out var delegationCodeHeader))
            {
                logger.LogError(nameof(ValidateDelegationCode) + " - called without expected header {0}, qnnDplySampleInfoId={1}", Constants.HeaderNames.DelegationCode, qnnDplySampleInfoId);
                return BadRequest("DelegationCode");
            }
            
            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                string delegateCode = EncryptionHelper.DecryptStr(delegationCodeHeader.First(), Constants.LoginKey, Constants.LoginIv);
                bool valid = await DelegationApplication.ValidateAccessCodeAndUpdateAttempts(qnnDplySampleInfoId, delegateCode);
                return Json(new ItemSuccessResponse<bool>(valid));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ValidateDelegationCode) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.IsDelegationExceeded)]
        [HttpGet]
        public async Task<ActionResult> IsDelegatedAccessRetriesExceed(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(IsDelegatedAccessRetriesExceed) + " - called, dlsi={0}", dlsi);
            }

            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return BadRequest();
            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                bool exceeded = await DelegationApplication.IsDelegatedAccessRetriesExceed(qnnDplySampleInfoId);
                return Json(new ItemSuccessResponse<bool>(exceeded));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(IsDelegatedAccessRetriesExceed) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Endpoint exposed for the internet app to call the intranet app to tell it to process
        /// an excel file with survey answers uploaded by a respondent. The request must include the file.
        /// The bulk of the work is done in BusinessProcess.DataProcessingExcelOnline.
        /// This endpoint will be invoked from internet sides' UploadExcelResponse in RespDashboardController
        /// nb: the UploadExcelResponse in DataEditContoller serves the same purpose for data editors 
        /// </summary>
        /// <param name="qnnId">Id of the QNN_QNN</param>
        /// <param name="dplyId">Id of the QNN_DPLY</param>
        /// <param name="listSampleId">Id in QNN_LIST_SAMPLE</param>
        /// <returns></returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.UploadExcelResponse)]
        [HttpPost]
        public async Task<ActionResult> UploadExcelResponse(
            string qnnId,
            string dplyId,
            string listSampleId)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UploadExcelResponse) + " - called, qnnId={0}, dplyId={1}, listSampleId={2}", qnnId, dplyId, listSampleId);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                //TODO - the following business logic doesn't belong in the controller, to move it out to an 'application' class

                //Verify that the survey specified is actually for the sample (ie: respondent) who called us,
                //which we do by checking that the sample identified in the access token is indeed the one in the specified QNN_LIST_SAMPLE
                //(a table that records a sample's participation in a sample list).
                //nb: Checking that this QNN_LIST_SAMPLE is in fact assigned to the specified survey is a chore that we
                //    leave to the business logic method as that stuff is common to both upload by respondent and data editor.
                EntityModel qnnListSampleModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE);
                DynamicEntity listSample 
                    = (await qnnListSampleModel.GetAsync(Filter.And.Equal(listSampleId, Constants.FieldName.Id))).FirstOrDefault();
                if (listSample == null)
                {
                    throw new ArgumentNullException("Unknown List Sample");
                }
                Guid callerSampleId = sample.Id;
                Guid expectedSampleId = (Guid)listSample["SampleId"];
                if (!expectedSampleId.Equals(callerSampleId))
                {
                    throw new ArgumentException("Incorrect List Sample");
                }

                var file = Request.Form.Files[0];
                string contentType = file.ContentType;
                if (!Constants.ContentTypes.XlsxFileType.Equals(contentType))
                {
                    return Json(new FailResponse("INCORRECT FILE TYPE")); 
                }
                using (var stream = file.OpenReadStream())
                {
                    Guid? dataEditorUserId = null; //The answers are being uploaded by respondent, not a data editor
                    var (msg, failed) = await ExcelSupport.DataProcessingExcelOnline(
                        dplyId: Guid.Parse(dplyId),
                        listSampleId: Guid.Parse(listSampleId),
                        dataEditorUserId: dataEditorUserId,
                        fileStream: stream);
                    if (failed)
                    {
                        logger.LogError(nameof(UploadExcelResponse) + " - failed: {msg}", new object[] { msg });
                        return Json(new FailResponse(msg));
                    }
                    else
                    {
                        return Json(new SuccessResponse());
                    }
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadExcelResponse) + " - caught unexpected exception, qnnId={0}, dplyId={1}, listSampleId={2}", qnnId, dplyId, listSampleId);
                return Json(new FailResponse(e.Message));
            }
        }

        /// <summary>
        /// Endpoint exposed for the internet side to call in order to download a populated survey excel file
        /// Expects the internet users's bearer header in the request.
        /// </summary>
        /// <param name="qnnDplySampleInfoIdString">Id of QNN_DPLY_SAMPLE_INFO</param>
        /// <param name="token">file token</param>
        /// <param name="qnnRespIdString">Id of the QNN_RESP if there is an existing response to update already</param>
        /// <returns>stream</returns>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.DownloadSurveyExcel)]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.DownloadSurveyExcel_Resp)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> DownloadSurveyExcel(
            string dlsi, 
            string token, 
            string respId)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DownloadSurveyExcel) + " - called, dlsi={0}, token={1}, respId={2}", dlsi, token, respId);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                //Use the bearer header to retrieve the QNN_SAMPLE for the internet user
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return BadRequest(); //Required
                Guid.TryParse(respId, out Guid qnnRespId); //May be empty

                //Deployment sample info links the respondent (sample) to the survey
                EntityModel qnnDeploySampleInfoModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, 1);
                DynamicEntity qnnDplySampleInfo = (await qnnDeploySampleInfoModel.GetAsync(
                    Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.Id)))
                    .FirstOrDefault();
                if (qnnDplySampleInfo == null)
                {
                    return StatusCode(400);
                }

                //Verify that the caller is in fact the sample identified in the dsi (other respondents arent allowed to read it)
                Guid callerSampleId = sample.Id;
                Guid specifiedSampleId = (Guid)qnnDplySampleInfo["ListSampleId_SampleId"];
                if (!callerSampleId.Equals(specifiedSampleId))
                {
                    return StatusCode(403);
                }

                (var memoryStream, var contentType, var fileName, var errorMessage) 
                    = await ExcelSupport.DownloadSurveyExcelOnline(qnnDplySampleInfoId, token, qnnRespId, populateFromResponseData: false);
                if (memoryStream == null)
                {
                    if("INVALID qnnRespId".Equals(errorMessage))
                    {
                        return StatusCode(400);
                    }
                    throw new ArgumentException($"Unable to prepare the stream: {errorMessage}");
                }
                return File(memoryStream, contentType, fileName);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadSurveyExcel) + " - caught unexpected exception, dlsi={0}, token={1}, respId={2}", dlsi, token, respId);
                return StatusCode(500);
            }
        }

        /// <summary>
        /// Endpoint to expose a curated selection of settings to the internet side.
        /// (We don't want to expose all the settings, limit to just those it needs, the fewer the better)
        /// </summary>
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Setting)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetSetting(string name)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetSetting) + " - called, name={0}", name);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                //nb: internet side is expecting a string for all settings and will convert for itself

                if(Constants.dwAppSettingName.DelegationAccessCodeRetries == name)
                {
                    int retriesLimit = await DelegationApplication.GetDelegationAccessCodeRetriesSetting();
                    return Json(retriesLimit.ToString());
                }
                else if(Constants.dwAppSettingName.WhitelistedFileExt == name)
                {
                    //TODO - would be better to move this setting to the appsettings.json (on both sides) instead of using api to fetch! (or cache it)
                    ILookup<string, string> settings = (await AppSettings
                                    .SelectAsync(Filter.And.Equal(Constants.dwAppSettingName.WhitelistedFileExt, Constants.FieldName.Name)))
                                    .ToLookup(s => s.Name, s => s.Value);
                    string extensions = settings[Constants.dwAppSettingName.WhitelistedFileExt].FirstOrDefault();
                    return Json(extensions ?? "");
                }
                else if(Constants.dwAppSettingName.AutosaveEnabled == name)
                {
                    ILookup<string, string> settings = (await AppSettings
                        .SelectAsync(Filter.And.Equal(Constants.dwAppSettingName.AutosaveEnabled, Constants.FieldName.Name)))
                        .ToLookup(s => s.Name, s => s.Value);
                    string autosaveEnabled = settings[Constants.dwAppSettingName.AutosaveEnabled].FirstOrDefault();
                    if (autosaveEnabled == null)
                    {
                        autosaveEnabled = "True";
                        logger.LogWarning(nameof(GetSetting) + " - setting not found: {0}, Defaulting to true", name);

                    }
                    return Json(autosaveEnabled);
                }
                else if(Constants.dwAppSettingName.AutosaveDelay == name)
                {
                    ILookup<string, string> settings = (await AppSettings
                        .SelectAsync(Filter.And.Equal(Constants.dwAppSettingName.AutosaveDelay, Constants.FieldName.Name)))
                        .ToLookup(s => s.Name, s => s.Value);
                    string autosaveDelay = settings[Constants.dwAppSettingName.AutosaveDelay].FirstOrDefault();
                    if (autosaveDelay == null)
                    {
                        autosaveDelay = "3";
                        logger.LogWarning(nameof(GetSetting) + " - setting not found: {0}, Defaulting to 3 seconds", name);

                    }
                    return Json(autosaveDelay);
                }

                //Any other setting is not whitelisted for exposure to internet side
                throw new NotFoundException();
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(NotFoundException nfe)
            {
                logger.LogWarning(nameof(GetSetting) + " - setting not found: {0}", name);
                return NotFound(new FailResponse(nfe.Message ?? "Setting not found"));
            }
            catch (Exception e)
            {
                logger.LogError(e, "Unexpected exception caught trying to get setting, name={0}", name);
                return StatusCode(500);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Metadata)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetMetadata(string fileName, string folderName)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetMetadata) + " - called, fileName={0}, folderName={1}", fileName, folderName);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (string.IsNullOrEmpty(fileName) || string.IsNullOrEmpty(folderName))
                    return BadRequest();

                //TODO - can we filter the allowed records here? But its hard to know without deserialising its settings object

                Filter filter = Filter.And
                    .Equal(fileName, Constants.FieldName.Filename)
                    .Equal(folderName, Constants.FieldName.Folder);
                Metadata metadataItem = (await Metadata.SelectAsync(filter)).FirstOrDefault();
                if (metadataItem == null) throw new NotFoundException("file not found");
                string content = metadataItem.Data;

                if(string.IsNullOrEmpty(content))
                {
                    //this page has been left blank intentionally (common to see this with the .js files in metadata)
                    return new StatusCodeResult((int)HttpStatusCode.NoContent);
                }
                else
                {
                    //TODO - if they requested metadata.json, deserialise and redact it here as a lot of it is
                    //       not relevant to internet side

                    string contentType 
                        = fileName.EndsWith(".json") ? MediaTypeNames.Application.Json
                        : fileName.EndsWith(".js") ? "text/javascript"
                        : fileName.EndsWith(".css") ? "text/css"
                        : "application/unknown";
                    return Content(content, contentType, Encoding.UTF8); //I'm assuming its all UTF-8 here (should be)
                }  
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (NotFoundException)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(GetMetadata) + " - {0} not found in folder {1}", fileName, folderName);
                return NotFound(folderName + fileName);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetMetadata) + " - unexpected exception trying to get metadata: fileName={0}, folderName={1}", fileName, folderName);
                return StatusCode(500);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.FileLocalStorageProperties)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetFileLocalStorageProperties(string fileName)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetFileLocalStorageProperties) + " - called, fileName={0}", fileName);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (string.IsNullOrEmpty(fileName))
                    return BadRequest();

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(GetFileLocalStorageProperties) + " - fileName={1}", fileName);

                //Use the bearer header to retrieve the QNN_SAMPLE for the internet user
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                List<Guid> mappedOrganisations = await GetMappedOrganisations(sample.Id);
                List<UploadedFilesPoor> files 
                    = await UploadedFilesPoor.GetLocalStorageFilesByNameAsync(fileName, mappedOrganisations);
                if(files.Count == 0)
                {
                    throw new NotFoundException($"File not found for sample {sample.Id}");
                } 
                else if(files.Count > 1)
                {
                    throw new InvalidOperationException($"Found multiple matching files in {nameof(UploadedFilesPoor)} for sample {sample.Id}");
                }
                else
                {
                    UploadedFilesPoor item = files.FirstOrDefault();
                    Dictionary<string, string> properties = FileProperties(item);
                    if (!IsFileDownloadable(properties))
                        throw new NotFoundException("File is marked as not downloadable");

                    return Json(properties);
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (NotFoundException notFound)
            {
                //nb: this can also be the case if the file does exist in dwUploadedFiles but isn't mapped to one of this sample's StructDivisions
                //    or doesn't have IsLocalStorage=1 (i.o.w its not in the local storage for the sample's struct divisions)
                //    We also throw this is the file is marked as not downloadable
                logger.LogDebug(notFound, nameof(GetFileLocalStorageProperties) + " - file not found: fileName={0}", fileName);
                return NotFound("File not found in local storage");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFileLocalStorageProperties) + " - caught unexpected exception: fileName={0}", fileName);
                return StatusCode(500);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.FileLocalStorageContent)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetFileLocalStorageContent(string fileName)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetFileLocalStorageContent) + " - called, fileName={0}", fileName);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (string.IsNullOrEmpty(fileName))
                    return BadRequest();

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(GetFileLocalStorageProperties) + " - fileName={1}", fileName);

                //Use the bearer header to retrieve the QNN_SAMPLE for the internet user
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                List<Guid> mappedOrganisations = await GetMappedOrganisations(sample.Id);
                List<UploadedFilesPoor> files
                    = await UploadedFilesPoor.GetLocalStorageFilesByNameAsync(fileName, mappedOrganisations);
                if (files.Count == 0)
                {
                    throw new NotFoundException($"File not found for sample {sample.Id}");
                }
                else if (files.Count > 1)
                {
                    throw new InvalidOperationException($"Found multiple matching files in {nameof(UploadedFilesPoor)} for sample {sample.Id}");
                }
                else
                {
                    UploadedFilesPoor item = files.FirstOrDefault();

                    //Ok, this file belongs to a mapped organisation for sample and exists, so we'll use the content provider to get the data now
                    //(while the ContentProvider also gets properties, it doesn't (as of 20230201) check or tell us about StructDivisionId)

                    string token = item.Id.ToString().ToLowerInvariant().Replace("-", "");
                    (Stream Stream, Dictionary<string, string> Properties) content = await CloverRuntime.ContentProvider.GetAsync(token);
                    if (content.Stream == null) throw new InvalidOperationException($"Unexpected null Stream for {item.Id}"); //should never happen though
                    if (content.Properties == null) throw new InvalidOperationException($"Unexpected null Properties for {item.Id}"); //should never happen though
                    if(content.Properties.TryGetValue(Constants.FileProperties.IsDownloadable, out string isDownloadableString))
                    {
                        if (!bool.Parse(isDownloadableString)) throw new NotFoundException("File is marked as not downloadable");
                    }
                    return File(content.Stream, item.ContentType, item.Name);
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (NotFoundException notFound)
            {
                //nb: this can also be the case if the file does exist in dwUploadedFiles but isn't mapped to one of this sample's StructDivisions
                //    or doesn't have IsLocalStorage=1 (i.o.w its not in the local storage for the sample's struct divisions)
                //    We also throw this is the file is marked as not downloadable
                logger.LogDebug(notFound, nameof(GetFileLocalStorageContent) + " - file not found: fileName={0}", fileName);
                return NotFound("File not found in local storage");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFileLocalStorageContent) + " - caught unexpected exception: fileName={0}", fileName);
                return StatusCode(500);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.FileTokenProperties)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetFileTokenProperties(string token)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetFileTokenProperties) + " - called, token={0}", token);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (!Guid.TryParse(token, out Guid id))
                    return BadRequest();

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(GetFileTokenProperties) + " - token={1}", token);

                //Use the bearer header to retrieve the QNN_SAMPLE for the internet user
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                UploadedFilesPoor item = await UploadedFilesPoor.SelectByKey(id);
                if (item == null) throw new NotFoundException($"file not found, token={id}");

                //n.b. for legacy reasons this endpoint does not check for a struct division id
                //(TODO - can we change that or will things break?)

                Dictionary<string, string> properties = FileProperties(item);
                if(!IsFileDownloadable(properties))
                    throw new NotFoundException("File is marked as not downloadable");

                return Json(properties);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (NotFoundException notFound)
            {
                //nb: this can also be the case if the file does exist in dwUploadedFiles but isn't mapped to one of this sample's StructDivisions
                //    or doesn't have IsLocalStorage=1 (i.o.w its not in the local storage for the sample's struct divisions)
                //    We also throw this is the file is marked as not downloadable
                logger.LogDebug(notFound, nameof(GetFileTokenProperties) + " - file not found: token={0}", token);
                return NotFound("File not found in local storage");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFileTokenProperties) + " - caught unexpected exception: token={0}", token);
                return StatusCode(500);
            }
        }

        private Dictionary<string,string> FileProperties(UploadedFilesPoor file)
        {
            if (file == null) throw new ArgumentNullException(nameof(file));
            var returnProperties = new Dictionary<string, string>
                {
                    { Constants.FileProperties.Name, file.Name },
                    { Constants.FileProperties.Length, file.AttachmentLength.ToString() },
                    { Constants.FileProperties.ContentType, file.ContentType },
                    { Constants.FileProperties.CreatedBy, file.CreatedBy },
                    { Constants.FileProperties.CreatedDate, file.CreatedDate.ToString() },
                    { Constants.FileProperties.UpdatedBy, file.UpdatedBy },
                    { Constants.FileProperties.UpdatedDate , file.UpdatedDate.ToString() },
                    { Constants.FileProperties.IsLocalStorage, file.IsLocalStorage.ToString() },
                };

            //Handling for properties that only exist in the properties column and arent in the API
            dynamic itemProperties = String.IsNullOrEmpty(file.Properties) ? null : JsonConvert.DeserializeObject(file.Properties);
            if (itemProperties != null)
            {
                if (itemProperties.ContainsKey(Constants.FileProperties.IsDownloadable))
                {
                    string isDownloadableString = itemProperties.IsDownloadable.ToString();
                    returnProperties.Add(Constants.FileProperties.IsDownloadable, isDownloadableString);
                }
            }
            return returnProperties;
        }

        private bool IsFileDownloadable(Dictionary<string,string> properties)
        {
            if(properties.ContainsKey(Constants.FileProperties.IsDownloadable))
            {
                return bool.Parse(properties[Constants.FileProperties.IsDownloadable]);
            }
            else
            {
                return true;
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.FileTokenContent)]
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult> GetFileTokenContent(string token)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetFileTokenContent) + " - called, token={0}", token);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (!Guid.TryParse(token, out Guid id))
                    return BadRequest();

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(GetFileTokenContent) + " - token={1}", token);


                (Stream Stream, Dictionary<string, string> Properties) content = await CloverRuntime.ContentProvider.GetAsync(token);
                if (content.Stream == null) throw new NotFoundException($"File not found, token={token}"); 
                if (content.Properties == null) throw new InvalidOperationException($"Unexpected null Properties for {id}"); 
                if(!IsFileDownloadable(content.Properties))
                    throw new NotFoundException($"File is marked as not downloadable, token={token}");
                string contentType = content.Properties[Constants.FileProperties.ContentType];
                string fileName = content.Properties[Constants.FileProperties.Name];
                return File(content.Stream, contentType, fileName);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (NotFoundException notFound)
            {
                logger.LogDebug(notFound, nameof(GetFileTokenContent) + " - file not found: token={0}", token);
                return NotFound("File not found in local storage");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetFileTokenContent) + " - caught unexpected exception: token={0}", token);
                return StatusCode(500);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.RespondentFileUpload)]
        [HttpPost]
        public async Task<ActionResult> UploadRespondentFile()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UploadRespondentFile) + " - called");
            }

            try
            {
                if (Request.Form.Files.Count != 1)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(UploadRespondentFile) + " - Bad Request: Request.Form.Files.Count={0}", Request.Form.Files.Count);

                    return BadRequest("files");
                }
                    

                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                IFormFile file = Request.Form.Files[0];
                string contentType = file.ContentType;
                ContentDisposition cd = new ContentDisposition( file.ContentDisposition );
                string createdBy = sample.UID;
                Dictionary<string, string> properties = new Dictionary<string, string>
                {
                    { Constants.FileProperties.Name, cd.FileName }, //use name from disposition
                    { Constants.FileProperties.ContentType, contentType },
                    { Constants.FileProperties.CreatedBy, createdBy }, 
                    { Constants.FileProperties.IsDownloadable, Boolean.TrueString }
                };

                using (Stream stream = file.OpenReadStream())
                {
                    //We need to create the row in dwUploadedFiles ourselves instead of using ContentProvider.AddAsync
                    //because we need to set the createdBy to the sample UID (which it won't do for us).
                    //Following code adapted from example set by ContentDBProvider.AddAsync as at 20230201
                    UploadedFiles dwUploadedFile = new UploadedFiles()
                    {
                        Id = CloverRuntime.DbProvider.GenerateGuid(),
                        Name = cd.FileName,
                        AttachmentLength = stream.Length,
                        ContentType = contentType,
                        CreatedBy = createdBy,
                        CreatedDate = DateTime.Now,
                        Used = true,
                        Properties = JsonConvert.SerializeObject(properties),
                        IsLocalStorage = false,
                        StructDivisionId = Guid.Empty, //hmmm .... preserving existing behaviour here
                    };
                    dwUploadedFile.Data = new byte[stream.Length];
                    await stream.ReadExactlyAsync(dwUploadedFile.Data, 0, (int)stream.Length);
                    await dwUploadedFile.ApplyAsync();
                    string token = dwUploadedFile.Id.ToString("N");
                    return Json(new ItemSuccessResponse<string>(token));
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadRespondentFile) + " - caught unexpected exception");
                return Json(new FailResponse(e.Message));
            }
        }

        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.AddSurveyResponse)]
        public async Task<ActionResult> AddSurveyResponse(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(AddSurveyResponse) + " - called, dlsi={0}", dlsi);
            }

            try
            {
                string authHeader = Request.Headers[HeaderNames.Authorization];
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                //dlsi
                if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId))
                    return Json(new FailResponse("Invalid input."));

                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(Guid.Empty, sample.Id);
                Guid? auditStructDivisionId = null; //TODO - null for respondent currently, but should it use sdi from the deployment?
                Guid qnnRespId = await ResponseApplication.InsertEmptyResponse(
                    qnnDplySampleInfoId, 
                    auditBatch, 
                    auditStructDivisionId, 
                    Constants.ResponseAs.Form); //for now hardcode to Form

                return Json(new ItemSuccessResponse<Guid>(qnnRespId));
            }
            catch (MaxResponsesException mre)
            {
                return Json(new FailResponse(mre.Message)); //api client checks for this
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AddSurveyResponse) + " - caught unexpected exception, dlsi={0}", dlsi);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.DirectAccessLogin)]
        public async Task<ActionResult> DirectAccessLogin(
            string accessCode,
            string dlsiCode,
            string formCode)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DirectAccessLogin) + " - called, accessCode={0}, dlsiCode={1}, formCode={2}", accessCode, dlsiCode, formCode);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                DirectAccessLoginResult result 
                    = await InternetAccountApplication.DirectAccessLogin(
                            jwtService,
                            accessCode, 
                            dlsiCode, 
                            formCode, 
                            intranetAppSetting.UnifiedAtApp.IsEnforceRespondentSingleSession);
                return Json(result);
                //nb: since this is the intranet side, the uid isnt stored in the session here
                //    that happens on the internet side
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                if (e is IntranetApplication.InternetAccountApplication.DirectAccessRespondentLoginException rle)
                {
                    logger.LogError(rle, nameof(DirectAccessLogin) + " - caught an unexpected exception, AccessCodeString={0}, DlsiCode={0}, FormCode={2}, IsEnforceRespondentSingleSession={3}", rle.AccessCodeString, rle.DlsiCode, rle.FormCode, rle.IsEnforceRespondentSingleSession);
                }
                else
                {
                    logger.LogError(e, nameof(DirectAccessLogin) + " - caught an unexpected exception");
                }
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Send a link to reset the password (respondent self-service password reset)
        /// </summary>
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.SendPasswordResetLink)]
        public async Task<ActionResult> SendPasswordResetLink(string uid)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                //With Singpass uid would be nric, so prefer not to log it here
                logger.LogTrace(nameof(SendPasswordResetLink) + " - called, string.IsNullOrWhitespace(uid)={0}", string.IsNullOrWhiteSpace(uid));
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                //we don't have a JWT to check for sample here

                //Check sample exists, is active, and get their Id
                EntityModel qnnSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                DynamicEntity qnnSample = (await qnnSampleModel.GetAsync(Filter.And.Equal(uid, Constants.FieldName.UID)))?.FirstOrDefault();
                if (qnnSample == null)
                    throw new NotFoundException($"Failed to find {Constants.ModelName.QNN_SAMPLE} with UID={uid}");

                Guid sampleId = (Guid)qnnSample[Constants.FieldName.Id];

                if (!(bool)qnnSample[Constants.FieldName.ActiveYN])
                    throw new InvalidOperationException($"Sample {sampleId} is not active");

                //For the self-service password checks we need to verify this 
                int numRetry = (int)qnnSample[Constants.FieldName.NumRetry];
                if (numRetry > Constants.NumRetry)
                    throw new InvalidOperationException($"Sample {sampleId} has exceeded maximum number of password retries ({Constants.NumRetry})");

                int emailsQueued
                    = await InternetAccountApplication.SendRespondentPasswordResetLinksAsync(new List<Guid>() { sampleId }, isResetRetry: false);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SendPasswordResetLink) + " - caught unexpected exception, uid={0}", uid);
            }
            //To avoid disclosing information externally, we *always* return this message even if there is an error
            //(intranet application will just pass the message through to browser)
            return Json(new SuccessResponse("Please check your email for the reset link"));
        }

        /// <summary>
        /// Verify the token for resetting a password is correct, called after they click the link in the email
        /// </summary>
        /// <param name="nkt"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ValidatePasswordResetToken)]
        public async Task<ActionResult> ValidatePasswordResetToken(string nkt)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ValidatePasswordResetToken) + " - called, string.IsNullOrWhitespace(nkt)={0}", string.IsNullOrWhiteSpace(nkt));
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                string token = EncryptionHelper.DecryptStr(nkt, Constants.LoginKey, Constants.LoginIv);
                if (token == null) return BadRequest("nkt");

                ValidatePasswordResetTokenResult result
                    = await InternetAccountApplication.ValidatePasswordResetTokenAsync(token);
                return Json(result);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ValidatePasswordResetToken) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// submit new password in reset password page (after clicking the reset link in the email, passed nkt checking already)
        /// </summary>
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.PasswordReset)]
        public async Task<ActionResult> ResetPassword(string token, string newPassword)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ResetPassword) + " - called, string.IsNullOrWhiteSpace(token)={0}, string.IsNullOrWhiteSpace(newPassword)={1}", string.IsNullOrWhiteSpace(token), string.IsNullOrWhiteSpace(newPassword));
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                string decryptString = EncryptionHelper.DecryptStr(token, Constants.LoginKey, Constants.LoginIv);
                string[] strArr = decryptString.Split(Constants.QnnDelimiter);
                if (strArr.Length != 2) return Json(new FailResponse("Invalid identifier"));

                //Extract the sample id frm the nkt token and change their password. This method is called from the
                //internet application, so is authorised by the presence of the clover api key. It is the responsibility
                //of the internet side to validate the nkt before calling this.
                Guid sampleId = Guid.Parse(strArr[0]);
                await InternetAccountApplication.ResetSamplePasswordAsync(sampleId, newPassword);
                return Json(new SuccessResponse("Reset password successfully"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ResetPassword) + " - caught exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.PasswordChange)]
        public async Task<ActionResult> ChangeRespondentPassword(string password, string oldPassword = null)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ChangeRespondentPassword) + " - called, string.IsNullOrWhiteSpace(password)={0}, string.IsNullOrWhiteSpace(oldPassword)={1}", string.IsNullOrWhiteSpace(password), string.IsNullOrWhiteSpace(oldPassword));
            }

            //TODO - for invites I would like to verify the invites code here on intranet when changing, but needs
            //       more work on internet UI to pass it along, so will put off to another time

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                if (string.IsNullOrEmpty(password) || "" == oldPassword) //nb: null oldPassword means don't verify
                    return BadRequest();

                bool verifyOldPassword = (oldPassword != null);
                if(verifyOldPassword)
                {
                    string oldPasswordEncrypted = EncryptionHelper.EncryptStr(oldPassword, Constants.LoginKey, Constants.LoginIv);
                    if(!sample.Pwd.Equals(oldPasswordEncrypted))
                    {
                        if(logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(ChangeRespondentPassword) + " - old password incorrect for sample.Id={0}", sample.Id);
                        }
                        return Json(new FailResponse("Old password incorrect"));
                    }
                }
                else
                {
                    //Change without old passord is intended for InvitesChangePassword use
                    if(sample.PwdResetYN == false)
                    {
                        return Json(new FailResponse("Please use the Change Password menu to change the password"));
                    }
                }

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    //Password login respondents it will be ok to log the uid here (unlike Singpass respondents)
                    logger.LogInformation(nameof(ChangeRespondentPassword) + " - changing password for sample={0}, uid={1}", sample.Id, sample.UID);
                }                    

                string encryptedPassword = EncryptionHelper.EncryptStr(password, Constants.LoginKey, Constants.LoginIv);
                sample.Pwd = encryptedPassword;
                sample.PwdResetYN = false; //clear 'require password change on next login' flag
                                           //sample.SelfUpdatedDate = DateTime.Now; //TODO - self password change wasn't updating this before, but should it?

                //...
                //Using await sample.ApplyAsync() doesn't work here because of an ORM issue,
                //it thinks its an insertion and not an update!
                //so let's workaround the bug by using dynamic entity and the model explicitly
                DynamicEntity qnnSample = sample.AsDynamicEntity;
                EntityModel qnnSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                await qnnSampleModel.UpdateSingleAsync(qnnSample);
                //TODO - when the update issue is fixed we can come back and just do: await sample.ApplyAsync();
                //...

                return Json(new SuccessResponse("Changed password successfully"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ChangeRespondentPassword) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Endpoint exposed to the internet application to login respondents when using U@App 
        /// to authenticate samples. This is not idempotent as number of tries will be incremented
        /// and the sample locked if too many failures.
        /// </summary>
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.PasswordLogin)]
        public async Task<ActionResult> PasswordLogin(string login, string password)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(PasswordLogin) + " - called, login={0}, string.IsNullOrWhiteSpace(password)={1}", login, string.IsNullOrWhiteSpace(password));
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                LoginResult result 
                    = await InternetAccountApplication.PasswordLogin(
                        jwtService,
                        login, 
                        password,
                        intranetAppSetting.UnifiedAtApp.IsEnforceRespondentSingleSession);
                return Json(result);
                //nb: since this is the intranet side, the uid isnt stored in the session here
                //    that happens on the internet side
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PasswordLogin) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.InvitesLogin)]
        public async Task<ActionResult> InvitesLogin(string accessCode, string dlsiCode)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(InvitesLogin) + " - called, accessCode={0}, dlsiCode={1}", accessCode, dlsiCode);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                RespInvitationResult result 
                    = await InternetAccountApplication.InvitationLogin(
                        jwtService,
                        dlsiCode, 
                        accessCode,
                        intranetAppSetting.UnifiedAtApp.IsEnforceRespondentSingleSession);
                return Json(result);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                if (e is IntranetApplication.InternetAccountApplication.InvitationRespondentLoginException rle)
                {
                    logger.LogError(rle, nameof(InvitesLogin) + " - caught an unexpected exception, DlsiCode={0}, AccessCodeString={1}, IsEnforceRespondentSingleSession={2}", rle.DlsiCode, rle.AccessCodeString, rle.IsEnforceRespondentSingleSession);
                }
                else
                {
                    logger.LogError(e, nameof(InvitesLogin) + " - caught an unexpected exception");
                }
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Record the sample login via SPCP with the CPEntID or IC (which is used as the UID in SurveyPlus) and return their api jwt
        /// For SPCP logins its the SPCP on the internet side that is authenticating so here we log the login for audit purpose,
        /// update the last login date, and most importantly return the respondent user's access tokens which they will need
        /// to do anything via the api. We also handle intranet side jwt token invalidation for the single-session feature. 
        /// The endpoint requires the integration api key in the header. 
        /// </summary>
        /// <param name="uid">Sample UID</param>
        /// <returns>access tokens and last login date</returns>
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.SpcpLogin)]
        public async Task<ActionResult> RespSpcpLogin(string uid)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                //With SingPass the UID is sensitive so don't log it here
                logger.LogTrace(nameof(RespSpcpLogin) + " - called, string.IsNullOrWhiteSpace(uid)={0}", string.IsNullOrWhiteSpace(uid));
            }

            if (!intranetAppSetting.UnifiedAtApp.IsEnabled)
            {
                logger.LogWarning($"Call made to {nameof(RespSpcpLogin)} but u@app is not enabled");
                return NotFound("This endpoint is not enabled");
            }

            if (!intranetAppSetting.UnifiedAtApp.IsSPCPLoginEndpointEnabled)
            {
                logger.LogWarning($"Call made to {nameof(RespSpcpLogin)} but {nameof(UnifiedAtAppSetting.IsSPCPLoginEndpointEnabled)} is not enabled");
                return NotFound("This endpoint is not enabled");
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (string.IsNullOrEmpty(uid))
                {
                    logger.LogError(nameof(RespSpcpLogin) + " - missing uid in request");
                    return BadRequest("uid");
                }

                LoginResult result
                    = await InternetAccountApplication.SPCPLogin(
                        jwtService,
                        uid, 
                        intranetAppSetting.UnifiedAtApp.IsEnforceRespondentSingleSession);

                string applicationName = result.IsSuccess ? null : await SettingsHelper.Common.GetApplicationName();
                switch (result.Reason)
                {
                    case LoginResult.Outcome.Success:
                        LoginResult.LoginInformation info = result.Information;
                        //(nb: if we change the below to returning the LoginResult directly then remember to
                        //    adjust things so for an SPCPLogin it always returns false for ForcePwdChange)
                        Dictionary<string, object> data = new Dictionary<string, object>()
                        {
                            {"sampleId", info.SampleId},
                            {"accessToken", info.AccessToken},
                            {"renewalToken", info.RenewalToken},
                            {"lastLoginDate", info.LastLoginDate.ToString(Constants.QnnDatetimeFormat)}
                        };
                        return Json(new ItemSuccessResponse<object>(data, "SPCP login successfully"));

                    case LoginResult.Outcome.InvalidCredentials: //typically because UID does not exist
                        return Json(new FailResponse($"This {applicationName} Account is not ready. Please contact helpdesk for assistance."));

                    case LoginResult.Outcome.AccountLocked:
                        return Json(new FailResponse($"This {applicationName} Account is locked. Please contact helpdesk for assistance."));

                    default:
                        //This will only occur if we add new reasons and don't update this switch block
                        throw new NotSupportedException($"Unhandled failure result type {result.Reason}");
                }

            }
            catch (PermissionException pex)
            {
                //SessionInvalidException is raised if the clover api key is invalid
                logger.LogDebug(nameof(RespSpcpLogin) + " - caught permission exception with message {0} - request uid={1}", pex.Message, uid);
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                if(e is IntranetApplication.InternetAccountApplication.SPCPRespondentLoginException rle)
                {
                    logger.LogError(rle, nameof(RespSpcpLogin) + " - caught an unexpected exception, UID={0}, IsEnforceRespondentSingleSession={1}", rle.UID, rle.IsEnforceRespondentSingleSession);
                }
                else
                {
                    logger.LogError(e, nameof(RespSpcpLogin) + " - caught an unexpected exception");
                }
               
                //For reasons of security we don't tell client (i.e. surveyplus internet application!) the detailed reason
                //return Json(new FailResponse("Login or password is not correct."));
                return Json(new FailResponse("Unable to login. Please contact helpdesk for assistance."));
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Logoff)]
        public async Task<ActionResult> Logoff()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(Logoff) + " - called");
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (!Request.Headers.TryGetValue(HeaderNames.Authorization, out var authHeader))
                {
                    //Probably an expired internet side session (due to timeout (or server restart in dev))
                    logger.LogDebug(nameof(Logoff) + " - called without Authorization header");
                    return Json(new FailResponse("Invalid access")); //200 will show up in internet side logs
                    //Since we don't know who this respondent is we can't audit it or delete their token
                }
                else
                {
                    QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                    //It is a requirement that we log when respondents logout
                    await Clover.Core.Utils.AuditHelper.AuditLog(null, sample.Id, null, "LogOff");

                    //Delete their access token (we don't expect this to return false as we've already verified the token)
                    //(this will also delete the record in RespondentSessionTokenId via cascade delete)
                    string rawToken = authHeader.First().Substring(7); //Remove the "Bearer " prefix
                    bool success = await jwtService.InvalidateToken(rawToken);
                    if (!success)
                        throw new Exception("Unexpected fail result from LogoutUser");

                    return Json(new SuccessResponse());
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Logoff) + " - caught unexpected exception");
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Handles requests for ProcessShortLink for the U@App API
        /// </summary>
        /// <param name="linkCode">identifies the link</param>
        /// <param name="accessCode">secures the link</param>
        /// <returns>result (as JsonResult)</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ShortLink_WithCode)]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ShortLink_NoCode)]
        public async Task<ActionResult> ProcessShortLink(string linkCode, string accessCode=null)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ProcessShortLink) + " - called, linkCode={0}, accessCode={1}", linkCode, accessCode);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                ShortLinkResult result = await ShortLinkApplication.ProcessShortLink(linkCode, accessCode);
                return Json(result);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProcessShortLink) + " - caught unexpected exception, linkCode={0}", linkCode);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Help)]
        public async Task<ActionResult> GetHelpContent()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetHelpContent) + " - called");
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                //although respondents have to be logged in to see the help link,
                //I'm not going to bother checking sample here
                //since they all see the same help anyway

                EntityModel qnnHelpModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_HELP, Constants.Level.NoJoins);
                Filter filterForRespondentsAndActive = Filter.And
                    .Equal(true, Constants.FieldName.Status)
                    .Equal("resp", Constants.FieldName.Type);
                Order orderByTopicAndHeading = Order
                    .StartAsc(Constants.FieldName.Topic)
                    .Asc(Constants.FieldName.Heading);
                Paging retrieveAll = Paging.Empty;
                List<HelpItem> helpItems 
                    = (await qnnHelpModel.GetAsync(filterForRespondentsAndActive, orderByTopicAndHeading, retrieveAll))
                    .Select(help => new HelpItem(
                        id: (Guid)help[Constants.FieldName.Id],
                        topic: (string)help[Constants.FieldName.Topic],
                        heading: (string)help[Constants.FieldName.Heading],
                        content: (string)help[Constants.FieldName.Content]))
                    .ToList();
                return Json(helpItems);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetHelpContent) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.RespondentContent)]
        public async Task<ActionResult> GetRespondentContent(string type)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetRespondentContent) + " - called, type={0}", type);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                //it is not sample specific or sensitive, so we're not checking the sample jwt here
                //TODO - check the jwt if one is passed as this can give quicker feedback on an invalidated session

                if (string.IsNullOrEmpty(type))
                    return BadRequest("type");

                EntityModel qnnRespAdminModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP_ADMIN, Constants.Level.NoJoins);
                DateTime now = DateTime.Now;
                Filter filterByTypeAndVisibility = Filter.And
                    .Equal(true, Constants.FieldName.Status) //only include enabled ones
                    .Equal(type, Constants.FieldName.Type)   //i.e RespLogin vs RespDashboard
                    .LessOrEqual(now, Constants.FieldName.StartDate) //visibility period started
                    .Greater(now, Constants.FieldName.EndDate); //visibility priod not finished yet
                Order orderByNumberId 
                    = Order.StartAsc(Constants.FieldName.NumberId);
                Paging takeLatestFive 
                    = Paging.Create(skip: 0, take: 5); //TODO - make configurable (or eliminate?)
                List<RespondentContentItem> contentItems
                    = (await qnnRespAdminModel.GetAsync(filterByTypeAndVisibility, orderByNumberId, takeLatestFive))
                    .Select(content => new RespondentContentItem(
                        id: (Guid)content[Constants.FieldName.Id],
                        numberId: (int)content[Constants.FieldName.NumberId],
                        name: (string)content[Constants.FieldName.Name],
                        editorState: (string)content[Constants.FieldName.EditorState],
                        type: (string)content[Constants.FieldName.Type]))
                    .ToList();
                return Json(contentItems);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetRespondentContent) + " - caught unexpected exception, type={0}", type);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Get a single ListSampleInfo by dlsi, the row must be for the sample requesting it
        /// and visible to respondent
        /// </summary>
        /// <param name="dlsi"></param>
        /// <returns></returns>
        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.ListSampleInfoSingle)]
        public async Task<ActionResult> GetListSampleInfoSingle(string dlsi)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetListSampleInfoSingle) + " - called, dlsi={0}", dlsi);
            }

            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId))
                return BadRequest("dlsi");

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                //TODO - this is a hot method, we could replace ORM use with a direct StoredProcedure call as an optimisation

                EntityModel vSpListSampleInfoRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfoResp, Constants.Level.NoJoins);
                Filter byDlsiAndVisibleForSample = Filter.And
                    .Equal(qnnDplySampleInfoId, Constants.FieldName.Id)
                    .Equal(sample.Id, Constants.FieldName.SampleId)
                    .Equal(true, Constants.FieldName.VisibleToRespondent)
                    .Equal("Active", Constants.FieldName.DplyWorkflowState)
                    .Equal(true, Constants.FieldName.ListSampleRecordActiveYN);
                DynamicEntity vSPListSampleInfo
                    = (await vSpListSampleInfoRespModel.GetAsync(byDlsiAndVisibleForSample, Order.StartAsc(Constants.FieldName.Id), new Paging(skip:0, take:1)))
                    .FirstOrDefault();
                if (vSPListSampleInfo == null)
                {
                    throw new NotFoundException($"Failed to find dlsi={dlsi} for sample.Id={sample.Id}");
                }
                    
                //The ListSampleInfo class is not very amenable to serialisation so we're going to
                //directly return the data from the row as a simple dictionary at this side
                vSPListSampleInfo[Constants.FieldName.Remarks] = null; //Internet never needs to see this
                //TODO - actually there's quite a few columns the internet can live without, be nice to redact those too
                return Json(vSPListSampleInfo.Dictionary);
            }
            catch(NotFoundException nfe)
            {
                logger.LogWarning(nfe, nameof(GetListSampleInfoSingle) + " - not found {0}", qnnDplySampleInfoId);
                return NotFound(new FailResponse(nfe.Message));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetListSampleInfoSingle) + " - caught unexpected exception, dlsi={0}", dlsi);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Fetches data for the respondent dashboard grid.
        /// This will include both current and previous survey vSP_ListSampleInfo rows        
        /// </summary>
        [HttpGet]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.RespondentDashboardData)]
        public async Task<ActionResult> GetRespondentDashboardData()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetRespondentDashboardData) + " - called");
            }

            //The swagger-based code in InternetApiDataSource that this replaces didn't use pagination
            //it also didn't respect the default order set on the grids. Here we restore the default order
            //(but hardcoded) and continue not to support pagination, returning all the applicable records.
            //For respondent dashboards in practice the number is unlikely to be large. 
            try
            {
                await VerifyCloverApiKeyAsync(Request);

                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);

                //TODO - this is a hot method, we could replace ORM use with a direct StoredProcedure call as an optimisation

                EntityModel vSpListSampleInfoRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfoResp, Constants.Level.NoJoins);

                /*
                    Old settings from the form data mapping:

                    grid    (current surveys)
                        vSP_ListSampleInfoResp
                        DplySampleAsyncFilter
                        {UID:"@UID", DplyDateStart: "<=@NOW",  DueDate: ">=@NOW", VisibleToRespondent:1,DplyWorkflowState:"Active",ListSampleRecordActiveYN:1}

                        Default Sort=DplyCreatedDate Desc, RespDateEnd Desc  <-- seems not being applied?

                    gridview    (previous surveys)
                        vSP_ListSampleInfoResp
                        DplySampleAsyncFilter
                        {UID:"@UID",  DueDate:"<=@NOW", VisibleToRespondent:1,DplyWorkflowState:"Active", ListSampleRecordActiveYN:1,}

                        Default Sort=DplyCreatedDate Desc, RespDateEnd Desc

                    The Collections both have all columns in the view ticked in the data mapping.
                */

                Filter filter = Filter.And
                    .Equal(sample.Id, Constants.FieldName.SampleId) //Only return rows for the calling sample here
                    .Equal(true, Constants.FieldName.VisibleToRespondent)
                    .Equal("Active", Constants.FieldName.DplyWorkflowState)
                    .Equal(true, Constants.FieldName.ListSampleRecordActiveYN);
                Paging paging = Paging.Empty; 
                Order order 
                    = Order.StartDesc(Constants.FieldName.DplyCreatedDate)
                    .Desc(Constants.FieldName.RespDateEnd);

                List<IDictionary<string, object>> records
                    = (await vSpListSampleInfoRespModel.GetAsync(filter, order, paging))
                    .Select(dm => { 
                        var dict = dm.Dictionary;
                        dict[Constants.FieldName.Remarks] = null;
                        return dict; })
                    .ToList();

                return Json(records);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetRespondentDashboardData) + " - caught unexpected exception: message={0}", e.Message);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.GetSurveyDataForPrint)]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.GetSurveyDataForPrint_Resp)]
        [HttpGet]
        public async Task<ActionResult> GetSurveyDataForPrint(string formName, string dlsi, string respId, [FromQuery] bool isPDFExportForSubmittedOnly, [FromServices] SurveyResponseReader reader)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetSurveyDataForPrint) + " - called, formName={0}, dlsi={1}, respId={2}, isPDFExportForSubmittedOnly={3}", formName, dlsi, respId, isPDFExportForSubmittedOnly);
            }

            AuthenticationHeaderValue authHeader
                = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
            QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader); //Validate internet user

            if (sample == null) return Json(new FailResponse("Unauthorized"));
            if (!Guid.TryParse(dlsi, out Guid qnnDplySampleInfoId)) return BadRequest();
            if (string.IsNullOrEmpty(formName) || string.IsNullOrEmpty(formName)) return BadRequest();
            Guid.TryParse(respId, out Guid qnnRespId);

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                DateTime? respDateEnd = (qnnRespId == Guid.Empty) 
                    ? null 
                    : (DateTime?)(await ResponseApplication.GetQnnRespById(qnnRespId))[Constants.FieldName.DateComplete];
                if (isPDFExportForSubmittedOnly && respDateEnd == null)
                {  //response not completed
                    return Json(new FailResponse("Unauthorized"));
                }
                Filter filter = Filter.And.Equal(formName + "-pdftemplate.html", Constants.FieldName.Filename).Equal("metadata/forms", "Folder");
                List<swz.Clover.Core.Metadata.DbObjects.Metadata> metadataItems;

                metadataItems = await swz.Clover.Core.Metadata.DbObjects.Metadata.SelectAsync(filter);
                if(metadataItems.Count == 0)
                {
                    logger.LogError($"Failed to retrieve PDF template for form: {formName}. No matching record found in the Metadata table.");
                    throw new NotFoundException("The survey administrator has not enabled this form for PDF Export yet");
                }
                //Get survey data for print
                Dictionary<string, object> data = await reader.ResponseData(qnnDplySampleInfoId, qnnRespId, Guid.Empty, sample);

                return Json(data);
            }
            catch (NotFoundException nfe)
            {
                logger.LogDebug(nfe, nameof(GetSurveyDataForPrint) + " - not found");
                return NotFound(new FailResponse(nfe.Message));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetSurveyDataForPrint) + " - caught unexpected exception, formName={0}, dlsi={1}, respId={2}, isPDFExportForSubmittedOnly={3}", formName, dlsi, respId, isPDFExportForSubmittedOnly);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }
        public class CheckPdfExportRateLimitRequest
        {
            public Guid? DplyListSampleId { get; set; }
            public Guid? RespId { get; set; }
            public string FormName { get; set; }
            public string SurveyName { get; set; }
            public string Emails { get; set; }
            public string IpAddress { get; set; }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.CheckPdfExportRateLimit)]
        [HttpPost]
        public async Task<ActionResult> CheckPdfExportRateLimit([FromBody] CheckPdfExportRateLimitRequest request)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(CheckPdfExportRateLimit) + " - called, formName={FormName}, dlsi={Dlsi}",
                    request.FormName, request.DplyListSampleId);
            }

            AuthenticationHeaderValue authHeader
                = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
            QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader);

            if (sample == null) return Json(new FailResponse("Unauthorized"));
            if (string.IsNullOrEmpty(request.FormName)) return BadRequest();

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                PdfExportSettings settings = intranetAppSetting.PrintSettings.PdfExport;
                if (!settings.IsEnabled)
                {
                    return Json(new FailResponse("Pdf Export is disabled."));
                }

                spSP_LogPdfGeneration.LogResult logResult = await spSP_LogPdfGeneration.ExecuteAsync(
                    sampleId: sample.Id,
                    formName: request.FormName,
                    surveyName: request.SurveyName,
                    emails: request.Emails,
                    cooldownMinutes: settings.CooldownMinutes,
                    dplyListSampleId: request.DplyListSampleId,
                    respId: request.RespId);

                if (logResult.IsRateLimited)
                {
                    logger.LogWarning(nameof(CheckPdfExportRateLimit) + " - rate limited, dlsi={Dlsi}, formName={FormName}, cooldown={Minutes}min",
                        request.DplyListSampleId, request.FormName, settings.CooldownMinutes);
                }

                return Json(new { success = true, isRateLimited = logResult.IsRateLimited, cooldownMinutes = settings.CooldownMinutes, id = logResult.Id });
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CheckPdfExportRateLimit) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        public class EnqueuePrintJobRequest
        {
            public Guid LogId { get; set; }
            public string FormName { get; set; }
            public string Emails { get; set; }
            public string SurveyName { get; set; }
            public string ResponseData { get; set; }
        }

        public class UpdatePdfExportStatusRequest
        {
            public Guid Id { get; set; }
            public string Status { get; set; }
            public string ErrorMessage { get; set; }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.UpdatePdfExportStatus)]
        [HttpPost]
        public async Task<ActionResult> UpdatePdfExportStatus([FromBody] UpdatePdfExportStatusRequest request)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UpdatePdfExportStatus) + " - called, id={Id}, status={Status}", request.Id, request.Status);
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                AuthenticationHeaderValue authHeader
                    = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
                QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader);
                if (sample == null) return Json(new FailResponse("Unauthorized"));

                if (Guid.Empty.Equals(request.Id)) return BadRequest("id");
                if (string.IsNullOrEmpty(request.Status)) return BadRequest("status");

                await spSP_UpdatePdfExportStatus.ExecuteAsync(request.Id, request.Status, request.ErrorMessage);
                return Json(new SuccessResponse());
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UpdatePdfExportStatus) + " - caught unexpected exception, id={Id}", request.Id);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.EnqueuePrintJob)]
        [HttpPost]
        public async Task<ActionResult> EnqueuePrintJob([FromBody] EnqueuePrintJobRequest request)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(EnqueuePrintJob) + " - called");
            }

            AuthenticationHeaderValue authHeader
                = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
            QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader); //Validate internet user

            if (sample == null) return Json(new FailResponse("Unauthorized"));
            if (string.IsNullOrEmpty(request.FormName)) return BadRequest();
            if (string.IsNullOrEmpty(request.Emails)) return BadRequest();
            if (string.IsNullOrEmpty(request.SurveyName)) return BadRequest();
            if (string.IsNullOrEmpty(request.ResponseData)) return BadRequest();

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                PdfExportSettings settings = intranetAppSetting.PrintSettings.PdfExport;
                if (!settings.IsEnabled)
                {
                    throw new InvalidOperationException("Pdf Export is disabled.");
                }

                //create hangfire job
                BusinessProcess.Enqueue.BackendPrintSurvey(request.FormName, request.Emails, request.SurveyName, request.ResponseData);

                return Json(new SuccessResponse());
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(EnqueuePrintJob) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Verify)]
        [HttpGet]
        public async Task<ActionResult> VerifyAccessToken()
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(VerifyAccessToken) + " - called");
            }

            try
            {
                await VerifyCloverApiKeyAsync(Request);
                QNN_SAMPLE sample = await VerifySampleAuthorizationAsync(Request);
                if(logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(VerifyAccessToken) + " - verified accessToken for {0}", sample.Id);
                }
                return Json(new SuccessResponse());
            }
            catch (PermissionException pex)
            {
                //Will return an appropriate response for InvalidRespondentTokenException
                //which is a subclass of PermissionException
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(VerifyAccessToken) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [Route(Constants.UAppRoutes.ApiBase + Constants.UAppRoutes.Renew)]
        public async Task<ActionResult> RenewAccessToken(string renewalToken)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(RenewAccessToken) + " - called");
            }

            if (string.IsNullOrWhiteSpace(renewalToken))
                return BadRequest();

            try
            {
                await VerifyCloverApiKeyAsync(Request);

                if (Request.Headers.TryGetValue(HeaderNames.Authorization, out var header))
                {
                    AuthenticationHeaderValue authHeader = AuthenticationHeaderValue.Parse(header);
                    LoginResultData info = await jwtService.RenewRespondentToken(authHeader, renewalToken);
                    AccessTokenRenewalResult result = info.Success
                        ? AccessTokenRenewalResult.Success(info.AccessToken, info.RenewalToken)
                        : AccessTokenRenewalResult.Fail();
                    return Json(result);
                }
                else
                {
                    throw new PermissionException($"Missing {HeaderNames.Authorization} header");
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Logoff) + " - caught unexpected exception");
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        private static async Task<Dictionary<string, string>> GetParametersFromRequest(HttpRequest request)
        {
            var queryDictionary = request.Query.ToDictionary(c => c.Key.ToLower(), c => c.Value.ToString());

            if (!request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase)
                && !request.Method.Equals("GET", StringComparison.OrdinalIgnoreCase))
                throw new Exception($"Method {request.Method} is not supported");

            if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase)
                && !string.IsNullOrEmpty(request.ContentType)
                && !request.ContentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase)
                && !request.ContentType.Equals("application/json", StringComparison.OrdinalIgnoreCase)
                && !request.ContentType.Equals("application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase))
                throw new Exception($"Content type {request.ContentType} is not supported");

            if (string.IsNullOrEmpty(request.ContentType))
                return queryDictionary;

            if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase) && request.ContentType.Equals("application/json", StringComparison.OrdinalIgnoreCase))
            {
                request.EnableBuffering();
                string documentContents;
                using (var bodyStream = request.Body)
                {
                    using (var readStream = new StreamReader(bodyStream, Encoding.UTF8))
                    {
                        documentContents = await readStream.ReadToEndAsync().ConfigureAwait(false);
                    }
                }

                try
                {
                    var bodyDictionary = JsonConvert.DeserializeObject<Dictionary<string, JRaw>>(documentContents);

                    foreach (var kvp in bodyDictionary)
                    {
                        queryDictionary.Add(kvp.Key, kvp.Value.ToString());
                    }
                }
                catch (Exception)
                {
                    throw new Exception("Invalid request body type");
                }
            }
            else if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase) &&
                     (request.ContentType.Equals("application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase)
                      || request.ContentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase)) &&
                     request.Form != null)
            {
                foreach (var keyValuePair in request.Form)
                {
                    queryDictionary.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                }
            }

            return queryDictionary;
        }

        /// <summary>
        /// Get a list (might be empty but never null) of the StrcutDivisionId mapped to this sample in QNN_SAMPLE_STRUCT_DVISION
        /// </summary>
        private async Task<List<Guid>> GetMappedOrganisations(Guid sampleId)
        {
            EntityModel qnnSampleStructDivisionModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION, Constants.Level.NoJoins);
            Filter bySampleId = Filter.And.Equal(sampleId, Constants.FieldName.SampleId);
            List<Guid> mappedOrganisations
                = (await qnnSampleStructDivisionModel.GetAsync(bySampleId))
                .Select(m => (Guid)m[Constants.FieldName.StructDivisionId])
                .ToList();
            return mappedOrganisations;
        }

        /// <summary>
        /// Verify the clover-apikey header and if it is missing or invalid record an entry in the
        /// audit log and throw a PermissionException. 
        /// </summary>
        /// <param name="request">the request from which the headers will be checked</param>
        /// <exception cref="PermissionException"></exception>
        private async Task VerifyCloverApiKeyAsync(HttpRequest request)
        {
            request.Headers.TryGetValue(IntegrationApiKeys.HeaderApiKey, out var apiKey);
            if (!apiKey.Any() || !CloverRuntime.IntegrationApiKey.Equals(apiKey.First()))
            {
                await Clover.Core.Utils.AuditHelper.AuditLog(null, null, null, "InvalidAPIKey");
                throw new PermissionException($"Invalid or missing header for {IntegrationApiKeys.HeaderApiKey}");
            }
        }

        /// <summary>
        /// Gets the respondent QNN_SAMPLE based on the Authorization header jwt (accessToken). 
        /// If not valid will throw an InvalidRespondentToken exception.
        /// Includes logic related to the respondent single-session feature. 
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        /// <exception cref="InvalidRespondentTokenException">Thrown if the jwt is not valid or respondent session was invalidated</exception>
        private async Task<QNN_SAMPLE> VerifySampleAuthorizationAsync(HttpRequest request)
        {
            if (request.Headers.TryGetValue(HeaderNames.Authorization, out var header))
            {

                AuthenticationHeaderValue authHeader = AuthenticationHeaderValue.Parse(header);
                QNN_SAMPLE sample = await jwtService.GetRespondent(authHeader);
                if (sample == null)
                {
                    //TODO - we will now have this situation when single-session is enabled and the old session token was deleted
                    //       we may need to reconsider how we report it

                    //nb: currently the JwtController doesn't throw its errors, instead it returns null the same 
                    //    as if the sample wasn't valid. You will need to check the logs to troubleshoot this if
                    //    you are getting permission exception for what should be a valid token.
                    //With single-session feature the old tokens should be invalidated if a new session is logged in too
                    throw new InvalidRespondentTokenException($"Invalid {HeaderNames.Authorization} header. Session may have been invalidated");
                }

                bool isAnonymous = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(sample.UID);
                if (!isAnonymous && intranetAppSetting.UnifiedAtApp.IsEnforceRespondentSingleSession)
                {
                    //Single-session handling. Typically the old session token would have been deleted at logout or if the old session
                    //was not explicitly logged out (common) would have been deleted when the respondent logged in again, so we don't
                    //normally expect the below throws to occur.
                    string currentTokenId = await spSP_GetRespondentSessionTokenId.ExecuteAsync(sample.Id);
                    if (currentTokenId == null)
                    {
                        throw new InvalidRespondentTokenException($"Invalidated respondent session (No Token) {currentTokenId} for sample {sample.Id}");
                    }
                    else
                    {
                        //Does the entry in RespondentSessionTokenId match current token
                        //(we only allow one such row per sampleId)
                        string tokenId = InternetAccountApplication.ExtractTokenId(authHeader.Parameter);
                        if (currentTokenId != tokenId)
                        {
                            //This is something of an edge case, and I wouldn't expect to see it in normal use as the old
                            //token would be deleted at login time and thus caught above
                            throw new InvalidRespondentTokenException($"Invalidated respondent session (Wrong Token) {currentTokenId} for sample {sample.Id}");
                        }
                    }
                }
                
                return sample;
            }
            else
            {
                throw new PermissionException($"Missing {HeaderNames.Authorization} header");
            }
        }

        ///// <summary>
        ///// Extract the raw JWT accessToken from a header string
        ///// </summary>
        //private string ExtractAccessToken(string authenticationHeaderString)
        //{
        //    try
        //    {
        //        AuthenticationHeaderValue authenticationHeaderValue = AuthenticationHeaderValue.Parse(authenticationHeaderString);
        //        string rawToken = authenticationHeaderValue.Parameter;
        //        return rawToken;
        //    }
        //    catch(Exception e)
        //    {
        //        throw new ArgumentException("Invalid header string", e);
        //    }            
        //}
    }
}
