using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;
using static swz.SurveyPlus.IntranetWeb.Controllers.SurveyControllerCommon;
using swz.Clover.Core.Security;
using System.IO;
using System.Collections.Immutable;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    //nb: previously this controller also housed enpoints called by internet side over u@app api
    //    these have moved to IntegrationApiController so they can be with their friends.
    //    Some common code has therefore moved to SurveyControllerCommon so it can be used in both controllers

    /// <summary>
    /// Data editor functions
    /// </summary>
    [Authorize]
    public class DataEditController : Controller
    {
        private readonly ILogger logger;

        public DataEditController(ILogger<DataEditController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/setremarks")]
        public async Task<ActionResult> SetRemarks()
        {
            string id = HttpContext.Request.Form["id"];
            string remarks = HttpContext.Request.Form["remarks"];
            try
            {
                if (!CloverRuntime.Security.CheckPermission("SetRemarks", "View")) //to add permission in the frontend
                    return Json(new FailResponse("You don't have the permission"));
                //if (string.IsNullOrEmpty(remarks) || remarks.Length <= 5)
                //    return Json(new FailResponse("Remarks must be more than 5 characters"));

                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_DPLY_SAMPLE_INFO, 0);
                var dyObjectsList = new List<dynamic>();
                var dm = (await model.GetAsync(Filter.And.Equal(id, "Id"))).FirstOrDefault() as dynamic;
                if (dm == null) return Json(new FailResponse("Invalid input"));
                if (!await DeploymentApplication.CheckEditorsAccess(dm))
                    return Json(new FailResponse("You don't have the permission"));

                dm.RemarksModifyOn = DateTime.Now;
                dm.RemarksModifyBy = CloverRuntime.Security.CurrentUser?.Id;
                dm.Remarks = remarks;
                if (string.IsNullOrEmpty(remarks)) dm.Remarks = (string)null; //to avoid null being saved as string 'null'
                dyObjectsList.Add(dm);
                var (_, updated) = await model.UpdateAsync(dyObjectsList);
                return Json(updated > 0
                    ? new SuccessResponse("Remarks Changed")
                    : new SuccessResponse("Remarks Not Changed"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SetRemarks) + " - caught unexpected exception");
                //TODO - shouldn't the below be a FailResponse?
                return Json("Exception Thrown. Check with system administrator");
            }
        }
          
        [HttpPost]
        [Authorize]
        [Route("dataeditor/getremarks")]
        public async Task<ActionResult> GetRemarks()
        {
            string id = HttpContext.Request.Form["id"];
            try
            {
                //
                if (!CloverRuntime.Security.CheckPermission("SetRemarks", "View")) //to add permission in the frontend
                    return Json(new FailResponse("You don't have the permission"));
                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_DPLY_SAMPLE_INFO, 0);
                var dm = (await model.GetAsync(Filter.And.Equal(id, "Id"))).FirstOrDefault() as dynamic;
                if (dm == null) return Json(new FailResponse("Invalid input"));
                if (!await DeploymentApplication.CheckEditorsAccess(dm))
                    return Json(new FailResponse("You don't have the permission"));

                return Json(new ItemSuccessResponse<string>(dm.Remarks));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetRemarks) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/setStatus")]
        public async Task<ActionResult> SetStatus(string id, string selectedStatusId)
        {
            try
            {
                if (!Guid.TryParse(id, out Guid dlsi))
                    return BadRequest(nameof(id));
                QnnStatusId status = QnnStatusId.FromString(selectedStatusId);

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                    throw new PermissionException($"Requires {Constants.Role.DataEditor}");

                await ResponseApplication.SetStatus(dlsi, status, currentUser.Id);

                return Json(new SuccessResponse("Status Changed"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(InvalidStatusFlowException isfe)
            {
                logger.LogError(nameof(SetStatus) + " - {0}, dlsi={1}", isfe.Message, id);
                return Json(new FailResponse("The selected status is not valid here"));
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(SetStatus) + " - caught unexpected exception, id={0}, selectedStatusId={1}", id, selectedStatusId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/resetStatus")]
        public async Task<ActionResult> ResetStatus(string id, string respId)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                    throw new PermissionException($"requires {Constants.Role.DataEditor}");

                if (!Guid.TryParse(id, out Guid qnnDplySampleInfoId))
                    return BadRequest("id");

                Guid? qnnRespId = null;
                bool hasResponseToDelete = !string.IsNullOrEmpty(respId);
                if (hasResponseToDelete)
                {
                    if (!Guid.TryParse(respId, out Guid parsedId))
                        return BadRequest("respId");
                    else
                        qnnRespId = parsedId;
                }

                ResponseApplication.ResetStatusResult result 
                    = await ResponseApplication.ResetStatus(
                        qnnDplySampleInfoId: qnnDplySampleInfoId,
                        qnnRespId: qnnRespId, 
                        dataEditorId: currentUser.Id);

                string messageForUi =
                    (result.IsResponseCleared ? "Response was cleared, " : "No response to clear, ")
                    +
                    (result.IsStatusReset ? "Status was reset" : "Status unchanged");
                return Json(new SuccessResponse(messageForUi));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ResetStatus) + " - caught unexpected exception, id={0}, respId={1}", id, respId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/getStatusItems")]
        public async Task<ActionResult> GetStatusItems(string id)
        {
            if (!Guid.TryParse(id, out Guid dlsi))
                return BadRequest("id");
            try
            {
                //Check role
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                    throw new PermissionException($"Requires {Constants.Role.DataEditor}");

                //Check sample access
                DynamicEntity dplySampleInfo = await DeploymentApplication.GetQnnDplySampleInfoById(dlsi);
                if (dplySampleInfo == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, dlsi);
                if (!await DeploymentApplication.CheckEditorsAccess(dplySampleInfo, currentUser.Id))
                    throw new PermissionException();

                //Fetch the options
                QnnStatusId currentStatus = QnnStatusId.FromGuid((Guid)dplySampleInfo[Constants.FieldName.Status]);
                List<Dictionary<string, object>> flows 
                    = (await ResponseApplication.GetStatusFlows(currentStatus))
                    .Select(flow => 
                    {   
                        return new Dictionary<string, object>()
                        {
                            {"key", (Guid)flow[Constants.FieldName.ToStatus] },
                            {"value", (Guid)flow[Constants.FieldName.ToStatus] },
                            {"text", (string)flow[Constants.FieldName.ToStatus+'_'+Constants.FieldName.Title]}
                        };
                    }).ToList();
                return flows.Any()
                    ? Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(flows))
                    : Json(new FailResponse("No options are available for this status"));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetStatusItems) + " - caught unexpected exception");
                return Json("Exception Thrown. Check with system administrator");
            }
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/gettrklistsbyuid")]
        public async Task<ActionResult> GetTrkListByUID()
        {
            try
            {
                string uid = HttpContext.Request.Form["uid"];
                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_TRK_LIST_SAMPLE, 0);
                var dyObjectsList = new List<dynamic>();
                var de = (await model.GetAsync(Filter.And.Equal(uid, "UID")));
                if (de == null || !de.Any()) return Json(new SuccessResponse());

                var item = de.Select(e => ((dynamic)e).TrkListId).ToList();

                if (item.Any())
                {
                    var res = Json(new
                    {
                        Item = item,
                        Success = true,
                        Message = "Get track list successfully"
                    });

                    return res;
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetTrkListByUID) + " - caught unexpected exception");
                return Json(new FailResponse("Failed to get track list for this UID"));
            }
            return Json(new SuccessResponse());
        }

        [HttpPost]
        [Authorize]
        [Route("dataeditor/settrklists")]
        public async Task<ActionResult> SetTrkLists()
        {
            try
            {
                string uid = HttpContext.Request.Form["uid"];
                string name = HttpContext.Request.Form["name"];
                string email = HttpContext.Request.Form["email"];
                string remarks = HttpContext.Request.Form["remarks"];
                string status = HttpContext.Request.Form["status"];
                string trkListIds = HttpContext.Request.Form["trkListIds"];
                var trkListIdList = trkListIds.Split(",", StringSplitOptions.RemoveEmptyEntries);

                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_TRK_LIST_SAMPLE, 0, true);

                var dynamicEntities = (await model.GetAsync(Filter.And.Equal(uid, "UID"))).ToList();
                var ids = new List<object>();
                var dyObjectsList = new List<dynamic>();
                foreach (var dynamicEntity in dynamicEntities)
                {
                    if (!trkListIdList.Any() || !trkListIdList.Contains(dynamicEntity["TrkListId"].ToString(), StringComparer.InvariantCultureIgnoreCase))
                    {
                        ids.Add(dynamicEntity["Id"]);
                    }
                }

                foreach (string trkListId in trkListIdList)
                {

                    var dm = (await model.GetAsync(Filter.And.Equal(uid, "UID").Equal(trkListId, "TrkListId"))).FirstOrDefault();
                    if (dm == null)
                    {
                        //insert
                        dm = await model.NewAsync();
                        dm["UID"] = uid;
                        dm["TrkListId"] = new Guid(trkListId);
                        dm["CreatedBy"] = CloverRuntime.Security.CurrentUser?.Id;
                        dm["CreatedDate"] = DateTime.Now;
                        dm["Name"] = name ?? "";
                        dm["Email"] = email;
                        dm["Remarks"] = remarks;
                        dm["Status"] = new Guid(status);
                    }
                    else
                    {
                        //update
                        dm["UpdatedBy"] = CloverRuntime.Security.CurrentUser?.Id;
                        dm["UpdatedDate"] = DateTime.Now;
                        dm["Name"] = name ?? "";
                        dm["Email"] = email;
                        dm["Remarks"] = remarks;
                        dm["Status"] = new Guid(status);
                    }
                    dyObjectsList.Add(dm);

                }

                using (var shared = new SharedTransaction())
                {
                    try
                    {
                        shared.BeginTransactionAsync().Wait();
                        if (ids.Any()) await model.DeleteAsync(ids);
                        await model.UpdateAsync(dyObjectsList);
                        await shared.CommitAsync();
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(SetTrkLists) + " - [A] caught unexpected exception");
                        await shared.RollbackAsync().ConfigureAwait(false);
                        return Json("Exception Thrown. Check with system administrator");
                    }
                }

                return Json(new SuccessResponse("Changes have been made."));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SetTrkLists) + " - [B] caught unexpected exception");
                return Json("Exception Thrown. Check with system administrator");
            }
        }

        /// <summary>
        /// Data editor survey calls here (intranet)
        /// </summary>
        /// <returns>json</returns>
        [HttpGet]
        [Authorize]
        [Route("resp/data")]
        public async Task<ActionResult> GetRespAns([FromServices] SurveyResponseReader reader)
        {
            try
            {
                (Guid dplySampleInfoId, Guid? qnnRespId, Guid anonymousId) = SurveyResponseIds(Request);

                Dictionary<string, object> data
                    = await reader.ResponseData(dplySampleInfoId, qnnRespId, anonymousId, sample: null);
                return Json(data);
            }
            catch (SurveyResponseReader.ReadFailedException rfe)
            {
                logger.LogError(rfe, nameof(GetRespAns) + " - Failed to retrieve survey response data, reason={0}", rfe.Reason);
                DynamicEntity failed = SurveyResponseDataForFail(msg: rfe.Reason, details: null, formIsReadOnly: rfe.IsFormReadOnly);
                return Json(failed.ToDictionary());
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetRespAns) + " - caught unexpected exception");
                DynamicEntity failed = SurveyResponseDataForFail(msg: "Internal Error", details: null, formIsReadOnly: true);
                return Json(failed.ToDictionary());
            }
        }

        /// <summary>
        /// Intranet's Data editor survey / submit calls here
        /// </summary>
        /// <returns>json</returns>
        [HttpPost]
        [Authorize]
        [Route("resp/data")]
        public async Task<ActionResult> PostRespAns([FromServices]SurveyPlusOptions surveyPlusOptions)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                {
                    throw new PermissionException($"User {currentUser.Id} ({currentUser.Name}) is not a {Constants.Role.DataEditor}");
                }

                object result = await UpdateSurveyResponseAsync(
                    logger, 
                    HttpContext, 
                    surveyPlusOptions, 
                    forDataEditor: currentUser, 
                    forRespondent: null);
                return Json(result);
            }
            catch (PermissionException pex)
            {
                //n.b. those PEX returned in an updater result from the updater were already handled
                ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PostRespAns) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("dataedit/upload/xlsx")]
        public async Task<ActionResult> UploadResponse(string qnnId, string dplyId, string listSampleId)
        {
            if (Request.Form.Files.Count == 0) return BadRequest("No file in request");
            if (!Guid.TryParse(qnnId, out Guid qnnGuid)) return BadRequest("qnnId");
            if (!Guid.TryParse(dplyId, out Guid dplyGuid)) return BadRequest("dplyId");
            if (!Guid.TryParse(listSampleId, out Guid listSampleGuid)) return BadRequest("listSampleId");
            try
            {
                EntityModel dplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);

                //Check if the user ( a data editor) is authorised for this survey & sample
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid? dataEditorUserId = currentUser.Id;

                Filter byDplyIdAndListSampleId = Filter.And
                        .Equal(dplyGuid, Constants.FieldName.DplyId)
                        .Equal(listSampleGuid, Constants.FieldName.ListSampleId);
                DynamicEntity dsi = (await dplySampleInfoModel.GetAsync(byDplyIdAndListSampleId)).FirstOrDefault();
                if (!await DeploymentApplication.CheckEditorsAccess(dsi))
                {
                    throw new PermissionException($"Lacks data editor access to sample, listSampleId={listSampleGuid}");
                }

                //nb: Checking if the survey is in an appropriate state for answering is done in the business logic
                var file = Request.Form.Files[0];
                string contentType = file.ContentType;
                if (!Constants.ContentTypes.XlsxFileType.Equals(contentType))
                {
                    return Json(new SuccessResponse("INCORRECT FILE TYPE")); //nb: deliberate use of SuccessMessage, action handler will check for this exact message 
                }

                //Filename must end in xlsx
                string name = file.FileName;
                if (name == null || !name.EndsWith("xlsx", StringComparison.InvariantCultureIgnoreCase))
                {
                    return Json(new SuccessResponse("INCORRECT FILE TYPE")); //nb: deliberate use of SuccessMessage, action handler will check for this exact message
                }
                using (Stream stream = file.OpenReadStream())
                {
                    var (msg, failed)
                        = await ExcelSupport.DataProcessingExcelOnline(
                            dplyId: dplyGuid,
                            listSampleId: listSampleGuid,
                            dataEditorUserId: dataEditorUserId,
                            fileStream: stream);
                    return Json(new SuccessResponse(msg)); //use of SuccessResponse for both success and failed is deliberate (clientside checks msg)
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadResponse) + " - caught unexpected exception, qnnId={0}, dplyId={1}, listSampleId={2}", qnnGuid, dplyGuid, listSampleGuid);
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Download an Excel file for an online survey
        /// </summary>
        /// <param name="qnnDplySampleInfoIdString">id of QNN_DPLY_SAMPLE_INFO</param>
        /// <param name="token">the file token</param>
        /// <param name="qnnRespIdString">id of QNN_RESP (will be unspecified if they havent responded yet)</param>
        /// <returns></returns>
        [Authorize]
        [Route("/dataedit/download/xlsx/{qnnDplySampleInfoIdString}/{token}/{qnnRespIdString}")]
        public async Task<ActionResult> DownloadSurveyExcelOnline(string qnnDplySampleInfoIdString, string token, string qnnRespIdString)
        {
            try
            {
                EntityModel qnnDplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);

                Guid qnnDplySampleInfoId = Guid.Parse(qnnDplySampleInfoIdString);
                Guid.TryParse(qnnRespIdString, out Guid respId); //would be empty if there was no response yet

                //Check that data editor (current Clover user) has rights for this survey and sample
                Filter byDlsi = Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.Id);
                DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
                if (qnnDplySampleInfo == null)
                {
                    return BadRequest("Invalid dlsi");
                }
                if (!await DeploymentApplication.CheckEditorsAccess(qnnDplySampleInfo))
                {
                    return Unauthorized();
                }

                (var memoryStream, var contentType, var fileName, var errorMessage) =
                    await ExcelSupport.DownloadSurveyExcelOnline(qnnDplySampleInfoId, token, respId, populateFromResponseData: false);
                if ("NOT ENABLED".Equals(errorMessage))
                {
                    return Json(new FailResponse("Excel support is not enabled for this survey"));
                }
                if (memoryStream == null)
                {
                    throw new ArgumentException($"Unable to prepare the stream: {errorMessage}");
                }
                return File(memoryStream, contentType, fileName);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadSurveyExcelOnline) + " - caught unexpected exception, qnnDplySampleInfoIdString={0}, qnnRespIdString={1}", qnnDplySampleInfoIdString, qnnRespIdString);
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Download the previously uploaded excel file.
        /// Will check access and then stream the file out of dwUploadedFiles
        /// </summary>
        /// <param name="qnnDplySampleInfoIdString">id of QNN_DPLY_SAMPLE_INFO</param>
        /// <param name="qnnRespIdString">id of QNN_RESP</param>
        /// <returns></returns>
        [Authorize]
        [Route("/dataedit/download/response/{qnnDplySampleInfoIdString}/{qnnRespIdString}")]
        public async Task<ActionResult> DownloadUploadedResponseFile(string qnnDplySampleInfoIdString, string qnnRespIdString)
        {
            try
            {
                EntityModel qnnDplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);

                EntityModel qnnRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

                Guid qnnDplySampleInfoId = Guid.Parse(qnnDplySampleInfoIdString);
                Guid.TryParse(qnnRespIdString, out Guid respId); //would be empty if there was no response yet

                //Check that data editor (current Clover user) has rights for this survey and sample
                Filter byDlsi = Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.Id);
                DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
                if (qnnDplySampleInfo == null)
                {
                    return BadRequest("Invalid dlsi");
                }
                if (!await DeploymentApplication.CheckEditorsAccess(qnnDplySampleInfo))
                {
                    return Unauthorized();
                }

                if (Guid.Empty.Equals(respId))
                {
                    return BadRequest("There is no survey response");
                }
                Filter byQnnRespId = Filter.And.Equal(respId, Constants.FieldName.Id);
                DynamicEntity qnnResp = (await qnnRespModel.GetAsync(byQnnRespId)).FirstOrDefault();
                if (qnnResp == null)
                {
                    return BadRequest("Invalid qnnRespIdString");
                }

                string excelToken = (string)qnnResp[Constants.FieldName.ExcelToken];
                var data = await CloverRuntime.ContentProvider.GetAsync(excelToken);
                var properties = data.Properties;
                var stream = data.Stream;

                var filename = "unknown";
                var contentType = "application/unknown";
                //TODO - This extract properties logic have been appear on TOO MANY PLACES, consider consolidate it by making a static class/method to avoid multi standard
                if (properties != null)
                {
                    if (properties.ContainsKey(Constants.FileProperties.Name) && properties[Constants.FileProperties.Name] != null)
                        filename = properties[Constants.FileProperties.Name];

                    if (properties.ContainsKey(Constants.FileProperties.ContentType) && properties[Constants.FileProperties.ContentType] != null)
                        contentType = properties[Constants.FileProperties.ContentType];
                }

                return File(stream, contentType, filename);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadUploadedResponseFile) + " - caught unexpected exception, qnnDplySampleInfoIdString={0}, qnnRespIdString={1}", qnnDplySampleInfoIdString, qnnRespIdString);
                return new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Implements the Reject Response With Comments feature
        /// </summary>
        /// <param name="remarks">comments (will be sent to respondent and set in the response remarks column)</param>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("dataeditor/rejectresponse")]
        public async Task<ActionResult> RejectResponse(
            bool isSendEmail,
            string messageToRespondent, 
            string remarks)
        {
            if (!(Guid.TryParse(Request.Form["id"].ToString(), out var qnnDplySampleInfoId)
                && Guid.TryParse(Request.Form["respId"].ToString(), out var qnnRespId)))
            {
                return Json(new FailResponse("Invalid input"));
            }

            User dataEditor = await CloverRuntime.Security.GetCurrentUserAsync();
            try
            {
                string successMessage;
                ResponseApplication.Result_RejectResponseWithComments result 
                    = await ResponseApplication.RejectResponseWithComments(
                        qnnDplySampleInfoId: qnnDplySampleInfoId,
                        qnnRespId: qnnRespId,
                        isSendEmail: isSendEmail,
                        messageToRespondent: messageToRespondent,
                        remarks: remarks,
                        dataEditor: dataEditor);
                switch (result)
                {
                    case ResponseApplication.Result_RejectResponseWithComments.SuccessWithEmail:
                        successMessage = "Response rejected and status has been reset to pending. A notification email has been sent to the sample";
                        break;

                    case ResponseApplication.Result_RejectResponseWithComments.SuccessRejectOnly:
                        successMessage = "Response rejected and status has been reset to pending. No email sent";
                        break;

                    case ResponseApplication.Result_RejectResponseWithComments.SuccessWithEmailFailure:
                        successMessage = "Response rejected and status has been reset to pending but there was an ERROR SENDING NOTIFICATION EMAIL";
                        break;

                    case ResponseApplication.Result_RejectResponseWithComments.SuccessWithoutEmail:
                        successMessage = "Response rejected and status has been reset to pending but there is NO EMAIL address for this sample";
                        break;
                    case ResponseApplication.Result_RejectResponseWithComments.InvalidStatus:
                        successMessage = "This response cannot be rejected because it does not have the Submitted status";
                        break;

                    default:
                        throw new NotImplementedException(result.ToString());
                }
                return Json(new SuccessResponse(successMessage));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RejectResponse) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        } //end of RejectResponse

        /// <summary>
        /// Get the delegation history from QNN_RESP_DELEGATION by DplyListSampleId
        /// </summary>
        /// <returns>Data of RespDelegation</returns>
        [HttpGet]
        [Authorize]
        [Route("dataeditor/viewdelegatelist")]
        public async Task<ActionResult> ViewDelegationByDlsi(string dlsi)
        {
            try
            {
                Guid dplyListSampleId = Guid.Parse(dlsi);
                List<vSP_RespDelegationGrid> listRespDelegationGrid = await vSP_RespDelegationGrid.GetByDplyListSampleId(dplyListSampleId);

                if (listRespDelegationGrid == null)
                    return Json(new FailResponse("Delegate history not found"));

                List<Dictionary<string, object>> listGridResult = new List<Dictionary<string, object>>();
                foreach (var respDelegationGrid in listRespDelegationGrid)
                {
                    Dictionary<string, object> gridRow = new Dictionary<string, object>()
                    {
                        { "CreatedDate", respDelegationGrid.CreatedDate },
                        { "FromName", respDelegationGrid.FromName },
                        { "Name", respDelegationGrid.Name },
                        { "ValidityStart", respDelegationGrid.ValidityStart },
                        { "ValidityEnd", respDelegationGrid.ValidityEnd },
                        { "Comments", respDelegationGrid.Comments },
                        { "RevokedDate", respDelegationGrid.RevokedDate },
                        { "Status", respDelegationGrid.Status },
                    };

                    listGridResult.Add(gridRow);
                }

                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(listGridResult));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ViewDelegationByDlsi) + " - caught unexpected exception, dlsi={0}", dlsi);
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        } //end of ViewDelegationByDlsi

        [HttpPost]
        [Authorize]
        [Route("dataeditor/newresponse")]
        public async Task<ActionResult> AddNewResponse()
        {
            if (!Guid.TryParse(HttpContext.Request.Form["id"].ToString(), out Guid dlsi)) return BadRequest("id");
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                    throw new PermissionException($"Lacks {Constants.Role.DataEditor} role, dlsi={dlsi}");

                DynamicEntity qnnDplySampleInfo = await DeploymentApplication.GetQnnDplySampleInfoById(dlsi);
                if (qnnDplySampleInfo == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, dlsi);

                bool isSampleAssignedToThisEditor = await DeploymentApplication.CheckEditorsAccess(qnnDplySampleInfo, currentUser.Id);
                if (isSampleAssignedToThisEditor)
                {
                    AuditBatch auditBatch = await AuditSettings.NewBatchAsync();
                    Guid auditStructDivisionId = currentUser.StructDivisionId.Value; //TODO - review if should use user's or deployment's?
                    Guid qnnRespId = await ResponseApplication.InsertEmptyResponse(
                        dlsi, 
                        auditBatch, 
                        auditStructDivisionId,
                        Constants.ResponseAs.Form);
                    return Json(new ItemSuccessResponse<Guid>(qnnRespId));
                }
                else
                {
                    Guid dplyId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId];
                    throw new PermissionException($"Lacks editor assignment, dlsi={dlsi}, dplyId={dplyId}");
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (MaxResponsesException mre)
            {
                return Json(new FailResponse(mre.Message)); //message will display in UI
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AddNewResponse) + " - caught unexpected exception, dlsi={0}", dlsi);
                return Json(new FailResponse( Constants.Message.InternalErrorException));
            }
        } //end of AddNewResponse

        [HttpGet]
        [Authorize]
        [Route("dataeditor/getanonymoussampleinfo")]
        public async Task<ActionResult> GetAnonymousSampleInfo(string dplyid)
        {
            try
            {
                Guid deploymentId = Guid.Parse(dplyid);
                EntityModel qnnDplySampleInfoModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
                //Anonymous Deployment only expecting to have swzAnonymous in the Sample List, thats the rule when create Anonymous Survey Deployment.
                var sampleModel = (await qnnDplySampleInfoModel.GetAsync(Filter.And.Equal(deploymentId, Constants.FieldName.DplyId))).FirstOrDefault() as dynamic;
                EntityModel qnnStatusModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);
                var statusModel = (await qnnStatusModel.GetAsync(Filter.And.Equal((Guid)sampleModel.Status, Constants.FieldName.Id))).FirstOrDefault() as dynamic;
                Dictionary<string, string> result = new Dictionary<string, string>();
                result.Add("swzAnonymousSampleInfoId", sampleModel.Id.ToString());
                result.Add("statusTitle", statusModel.Title);

                return Json(new ItemSuccessResponse<object>(new { swzAnonymousSampleInfoId = sampleModel.Id.ToString(), status = statusModel.Title }));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetAnonymousSampleInfo) + " - caught unexpected exception, dplyid={0}", dplyid);
                return Json(new FailResponse("INTERNAL ERROR"));
            }
        }

        /// <summary>
        /// Returns id and name of deployments for which the current user is a data editor. 
        /// The current user must have the data editor role. 
        /// </summary>
        [HttpGet]
        [Authorize]
        [Route("dataeditor/mydeployments")]
        public async Task<ActionResult> GetMyDeployments()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataEditor))
                    throw new PermissionException($"Not in {Constants.Role.DataEditor} role");

                EntityModel vSPDataEditorDeploymentModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_DataEditorDeployment, Constants.Level.NoJoins);
                Filter byUserId = Filter.And.Equal(currentUser.Id, Constants.FieldName.UserId);
                List<DynamicEntity> deployments = await vSPDataEditorDeploymentModel.GetAsync(byUserId);

                List<Dictionary<string, object>> result = deployments
                    .OrderBy(deDply => (string)deDply[Constants.FieldName.Name])
                    .Select(deDply => 
                        new Dictionary<string, object>()
                        {
                            { "dplyId", (Guid)deDply[Constants.FieldName.DplyId] },
                            { "name", (string)deDply[Constants.FieldName.Name] }
                        })
                    .ToList();

                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(result));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(GetMyDeployments) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
    }
}