using CsvHelper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using Hangfire;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using Microsoft.Net.Http.Headers;
using CsvHelper.Configuration;
using swz.Clover.Core.Security;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Globalization;
using System.Collections.Immutable;
using swz.SurveyPlus.IntranetApplication.Utilities;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class DeploymentController : Controller
    {
        private static readonly object Obj = new object();
        private static readonly object ObjDataEditor = new object();

        private readonly ILogger<DeploymentController> logger;
        private readonly SurveyPlusOptions surveyPlusOptions;
        private readonly IScheduledExportService scheduledExportService;
        private readonly IProfileMailMergeService profileMailMergeService;
        private readonly IConnectionStringProvider connectionStringProvider;

        public DeploymentController(
            ILogger<DeploymentController> logger,
            SurveyPlusOptions surveyPlusOptions,
            IScheduledExportService scheduledExportService,
            IProfileMailMergeService profileMailMergeService,
            IConnectionStringProvider connectionStringProvider)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
            this.scheduledExportService = scheduledExportService ?? throw new ArgumentNullException(nameof(scheduledExportService));
            this.profileMailMergeService = profileMailMergeService ?? throw new ArgumentNullException(nameof(profileMailMergeService));
            this.connectionStringProvider = connectionStringProvider ?? throw new ArgumentNullException(nameof(connectionStringProvider));
        }

        [HttpPost]
        [Authorize]
        [Route("qnn/checkfields")]
        public async Task<ActionResult> CheckQnnFields()
        {
            string qnnId = HttpContext.Request.Form["qnnId"];
            try
            {
                var (message, latestFormFieldsUpdatedForQnn) = await FormPropertiesApplication.LatestFormFieldsUpdatedForQnn(Guid.Parse(qnnId));
                return latestFormFieldsUpdatedForQnn ? Json(new SuccessResponse(message)) : Json(new FailResponse(message));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CheckQnnFields) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Used by dplysampleowner to get data editor with access to a deployment
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="listSampleInfoId"></param>
        /// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("deployment/getDataEditor")]
        public async Task<ActionResult> GetDataEditor(Guid dplyId)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid userStructDivision = currentUser.StructDivisionId.Value;

                if (!CloverRuntime.Security.CheckPermission(currentUser.Id, Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

                if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                if (Guid.Empty.Equals(dplyId)) return Json(new FailResponse("No deployment selected"));

                Guid dplyStructDivisionId = (await QNN_DPLY.GetByDplyId(dplyId)).StructDivisionId.Value;
                List<Guid> listofStructDivisionId = await vStructDivisionParentsAndThis.GetByChildStructId(dplyStructDivisionId);

                List<Guid> userStructDivisionId = await vStructDivisionParentsAndThis.GetByParentStructId(userStructDivision);

                listofStructDivisionId = userStructDivisionId.Intersect(listofStructDivisionId).ToList();

                List<vSP_dataEditors> dataEditors = await vSP_dataEditors.GetByStructDivisionId(listofStructDivisionId);

                if (dataEditors == null) return Json(new FailResponse("NO_DATA_EDITORS"));

                return Json(new ItemSuccessResponse<List<vSP_dataEditors>>(dataEditors));
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(GetDataEditor) + " - caught unexpected exception, dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/setDataEditor")]
        public async Task<ActionResult> SetDataEditor()
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid structDivisionForAudit = currentUser.StructDivisionId.Value; //TODO - its been using that of the user, but check if it should use that of the deployment instead?

            if (!CloverRuntime.Security.CheckPermission(currentUser.Id, Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

            string userIds = HttpContext.Request.Form["userId"];
            if (string.IsNullOrEmpty(userIds)) return Json(new FailResponse("No Data Editor selected"));
            string strDplyId = HttpContext.Request.Form["dplyId"];
            string listSampleIds = HttpContext.Request.Form["listSampleIds"];
            var idsArray = string.IsNullOrEmpty(listSampleIds) ? new string[0] : listSampleIds?.Split(",").Distinct().ToArray();
            var userIdsArray = userIds.Split(",").Distinct().ToArray();

            foreach (var strUserId in userIdsArray)
            {
                if (!Guid.TryParse(strUserId, out Guid userId))
                    return Json(new FailResponse("No Data Editor selected"));
                if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    return Json(new FailResponse("No Data Editor selected"));
                if (!await IsDataEditorStructDivisionInDeploymentStructDivision(dplyId, userId))
                    return Json(new FailResponse("This data editor cannot be assigned to this deployment"));
            }

            using (var shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    var table = new DataTable(QNN_DPLY_SAMPLE_OWNER.GetTableName());
                    table.Columns.AddRange(QNN_DPLY_SAMPLE_OWNER.GetDataColumn());

                    if (idsArray != null && idsArray.Any())
                    {
                        foreach (var userId in userIdsArray)
                        {
                            var listSamplesExisted = new List<dynamic>();
                            var dplySampleOwner =
                                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_OWNER, 1);
                            var dictionary = new Dictionary<string, int>();

                            for (int i = 0; i < idsArray.Length; i = i + 500)
                            {
                                var items = idsArray.Skip(i).Take(500);
                                var entityDSO = (await dplySampleOwner.GetAsync(Filter.And.In(items.ToList(), "ListSampleId").Equal(userId, "UserId").Equal(strDplyId, "DplyId")));
                                if (entityDSO.Any())
                                    foreach (var entitie in entityDSO as dynamic)
                                    {
                                        var key = entitie.ListSampleId.ToString();
                                        if (!dictionary.ContainsKey(key))
                                            dictionary.Add(key, 0);
                                    }
                            }

                            foreach (var listSampleId in idsArray)
                            {
                                if (dictionary.ContainsKey(listSampleId))
                                    continue;

                                if (Guid.TryParse(listSampleId, out _))
                                {
                                    table.Rows.Add(Guid.NewGuid(), strDplyId, listSampleId, userId);
                                }
                            }
                        }

                        if (table.Rows.Count > 0)
                        {
                            DbHelper.BulkCopyDataTable(table, shared);

                            //audit
                            if (auditBatch.AuditOn)
                            {
                                string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(table);
                                await SurveyPlusAuditHelper.BatchImport(
                                    Constants.ModelName.QNN_DPLY_SAMPLE_OWNER,
                                    auditBatch,
                                    structDivisionForAudit,
                                    newValue);
                            }
                        }
                    }

                    shared.Commit();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(SetDataEditor) + " - caught unexpected exception");

                    await shared.RollbackAsync().ConfigureAwait(false);
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }

                return Json(new SuccessResponse("Changes have been made"));
            }
        }

        /// <summary>
        /// Used by dplySampleOwner to delete data editor by Id
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("deployment/deleteDataEditor")]
        public async Task<ActionResult> DeleteDataEditor()
        {
            int batch = 500;
            string sampleOwnerIds = HttpContext.Request.Form["sampleOwnerIds"];
            string[] idsArray = string.IsNullOrEmpty(sampleOwnerIds) ? new string[0] : sampleOwnerIds?.Split(",");
            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
            if (idsArray.Count() == 0) return Json(new FailResponse("No samples selected"));

            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    Guid eventBatch = Guid.NewGuid();
                    Guid userId = CloverRuntime.Security.CurrentUser.Id;
                    Guid userStructId = (Guid)CloverRuntime.Security.CurrentUser.StructDivisionId;

                    List<Guid> chunkIdsArray = idsArray.ToList().ConvertAll(Guid.Parse);
                    foreach (List<Guid> chunkIds in chunkIdsArray.ChunkBy(batch).ToList())
                    {
                        await spSP_DeleteSampleOwnerByIds.DeleteByIds(eventBatch, chunkIds, userId, userStructId);
                    }
                    shared.Commit();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(DeleteDataEditor) + " - caught unexpected exception");

                    await shared.RollbackAsync().ConfigureAwait(false);
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }

                return Json(new SuccessResponse("Changes have been made"));
            }
        }

        /// <summary>
        /// Used by dplySampleOwner to delete all data editor of the deployment
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("deployment/deleteAllDataEditors")]
        public async Task<ActionResult> DeleteAllDataEditors()
        {
            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

            string strDplyId = HttpContext.Request.Form["dplyId"];
            if (strDplyId == null) return Json(new FailResponse("No deployment selected"));

            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid structDivisionId = currentUser.StructDivisionId.Value;

            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    //audit
                    List<dynamic> auditData = new List<dynamic>();
                    dynamic m = new ExpandoObject();
                    m.DplyId = strDplyId;
                    m.UserId = currentUser.Id;
                    m.StructDivisionId = structDivisionId;
                    auditData.Add(m);

                    if (!Guid.TryParse(strDplyId, out Guid dplyId))
                    {
                        return Json(new FailResponse("Invalid request"));
                    }
                    else
                    {
                        string newValue = JsonConvert.SerializeObject(auditData, Formatting.Indented);
                        await spSP_DeleteSampleOwnerByDplyId.DeleteByDplyId(
                            dplyId, 
                            currentUser.Id, 
                            structDivisionId, 
                            auditBatch.AuditOn, 
                            newValue);
                    }

                    shared.Commit();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(DeleteAllDataEditors) + " - caught unexpected exception");

                    await shared.RollbackAsync().ConfigureAwait(false);
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }

                return Json(new SuccessResponse("Changes have been made"));
            }
        }

        /// <summary>
        /// Used by dplySampleOwner to add all sample to a data editor of the deployment
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("deployment/addAllSamplesToDataEditor")]
        public async Task<ActionResult> AddAllSamplesToDataEditor()
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid structDivisionForAudit = currentUser.StructDivisionId.Value;

            string strDplyId = HttpContext.Request.Form["dplyId"];
            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
            if (strDplyId == null) return Json(new FailResponse("No deployment selected"));

            if (!Guid.TryParse(strDplyId, out Guid dplyId))
                return Json(new FailResponse("Invalid request"));

            string strUserIds = HttpContext.Request.Form["userId"];
            if (string.IsNullOrEmpty(strUserIds)) return Json(new FailResponse("No Data Editor selected"));
            var strUserIdsArray = strUserIds.Split(",").Distinct().ToArray();

            foreach (var strUserId in strUserIdsArray)
            {
                if (!Guid.TryParse(strUserId, out Guid userId))
                    return Json(new FailResponse("No Data Editor selected"));
                if (!await IsDataEditorStructDivisionInDeploymentStructDivision(dplyId, userId))
                    return Json(new FailResponse("This data editor cannot be assigned to this deployment"));
            }

            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();
                    Guid eventBatch = Guid.NewGuid();

                    foreach (string strDataEditorId in strUserIdsArray)
                    {
                        Guid dataEditorId = Guid.Parse(strDataEditorId.ToString());
                        
                        //audit
                        List<dynamic> auditData = new List<dynamic>();
                        dynamic m = new ExpandoObject();
                        m.DplyId = strDplyId;
                        m.UserId = dataEditorId;
                        auditData.Add(m);

                        string newValue = JsonConvert.SerializeObject(auditData, Formatting.Indented);
                        await spSP_InsertAllSamplesToDataEditor.InsertByDplyIdAndDataEditorId(
                            dplyId, 
                            currentUser.Id, 
                            dataEditorId, 
                            structDivisionForAudit, 
                            eventBatch, 
                            auditBatch.AuditOn, 
                            newValue);
                    }

                    shared.Commit();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(AddAllSamplesToDataEditor) + " - caught unexpected exception");

                    await shared.RollbackAsync().ConfigureAwait(false);
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }

                return Json(new SuccessResponse("Changes have been made"));
            }
        }

        private static async Task<bool> IsDataEditorStructDivisionInDeploymentStructDivision(Guid dplyId, List<Guid> listUserId)
        {
            foreach (var userId in listUserId)
            {
                bool result = await IsDataEditorStructDivisionInDeploymentStructDivision(dplyId, userId);
                if (result == false)
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Checks DataEditor SturctDivision is in Deployment StuctDivision.
        /// This also checks users for data editor role
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="userId"></param>
        /// <returns>true for users is data editor role and with the correct structdivision</returns>
        private static async Task<bool> IsDataEditorStructDivisionInDeploymentStructDivision(Guid dplyId, Guid userId)
        {
            var su = await SecurityUser.SelectByKey(userId);

            if (!su.Roles.Value.Contains(Constants.Role.DataEditor))
                return false;

            //get dataeditor struct divisionid
            var dataeditorStructDivisionId = su?.StructDivisionId;

            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(dataeditorStructDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            //get deployment struct divisionid
            var dplyModel =
                await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, 1);
            var entity = (await dplyModel.GetAsync(Filter.And.Equal(dplyId, "Id"))).FirstOrDefault();
            var dplyStructDivisionId = (Guid?)entity?["StructDivisionId"];

            if (!childrenStructDivisionIds.Any() || childrenStructDivisionIds.All(id => id != dplyStructDivisionId))
                return false;

            return true;
        }

        /// <summary>
        /// Used by dplysample to get sample infomation
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="listSampleInfoId"></param>
        /// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("deployment/getDplySampleInfo")]
        public async Task<ActionResult> GetDplySampleInfo(Guid dplyId, Guid listSampleInfoId)
        {
            try
            {
                if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                if (Guid.Empty.Equals(dplyId)) return Json(new FailResponse("No deployment selected"));

                if (Guid.Empty.Equals(listSampleInfoId)) return Json(new FailResponse("No list sample info selected"));

                vSP_ListSampleInfoResp vSP_ListSampleInfoResp = await vSP_ListSampleInfoResp.GetByDplyIdAndId(dplyId, listSampleInfoId);

                if (vSP_ListSampleInfoResp == null) return Json(new FailResponse("No sample info"));

                bool isMultiResponseOrAnonymous = vSP_ListSampleInfoResp.IsMultipleResponse || vSP_ListSampleInfoResp.IsAnonymous;

                Dictionary<string, object> result = new Dictionary<string, object>()
                {
                    {"Id", vSP_ListSampleInfoResp.Id},
                    {"UID", vSP_ListSampleInfoResp.UID},
                    {"Name", vSP_ListSampleInfoResp.UIDName},
                    {"ListSampleId", vSP_ListSampleInfoResp.ListSampleId},
                    {"StatusTitle", vSP_ListSampleInfoResp.StatusTitle},
                    {"Segment", vSP_ListSampleInfoResp.Segment},
                    {"RespDateStart", vSP_ListSampleInfoResp.RespDateStart},
                    {"RespDateEnd", vSP_ListSampleInfoResp.RespDateEnd},
                    {"DueDate", vSP_ListSampleInfoResp.DueDate},
                    {"multiResponse", isMultiResponseOrAnonymous},
                    {"dataEditor", await GetDataEditorOfListSampleInfo(dplyId, listSampleInfoId)},
                };

                return Json(new ItemSuccessResponse<Dictionary<string, object>>(result));
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(GetDplySampleInfo) + " - caught unexpected exception, dplyId={0}, listSampleInfoId={1}", dplyId, listSampleInfoId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }            
        }

        /// <summary>
        /// Used for dplySample, sample tabs grid to get data owner info
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="listSampleInfoId"></param>
        /// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("deployment/getListSampleRespInfo")]
        public async Task<ActionResult> GetListSampleRespInfo(Guid dplyId, Guid listSampleInfoId)
        {
            try
            {
                if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                if (Guid.Empty.Equals(dplyId)) return Json(new FailResponse("No deployment selected"));

                if (Guid.Empty.Equals(listSampleInfoId)) return Json(new FailResponse("No list sample info selected"));

                List<object> dataEditor = await GetDataEditorOfListSampleInfo(dplyId, listSampleInfoId);

                if (dataEditor != null)
                    return Json(new ItemSuccessResponse<List<object>>(dataEditor));

                return Json(new FailResponse("NO_DATA_OWNER"));
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(GetListSampleRespInfo) + " - caught unexpected exception, dplyId={0}, listSampleInfoId={1}", dplyId, listSampleInfoId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        private async Task<List<object>> GetDataEditorOfListSampleInfo(Guid dplyId, Guid listSampleInfoId)
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            List<Guid> userAssignedStuctDivisionId = await vStructDivisionParentsAndThis.GetByParentStructId(currentUser.StructDivisionId.Value);

            List<vSP_ListSampleRespInfo> listOfListSampleRespInfo = await vSP_ListSampleRespInfo.GetByDplyIdAndDplyListSampleInfoId(dplyId, listSampleInfoId);

            if (listOfListSampleRespInfo != null)
            {
                List<object> listOfDataEditor = [];
                foreach (var sampleRespInfo in listOfListSampleRespInfo)
                {
                    var sampleRespInfoUserStruct = (await SecurityUser.GetStructIdByUserId(sampleRespInfo.UserId)).Value;
                    if (userAssignedStuctDivisionId.Contains(sampleRespInfoUserStruct))
                    {
                        Dictionary<string, string> dataEditor = new Dictionary<string, string>()
                        {
                            {"Username", sampleRespInfo.Username},
                            {"lsoId", sampleRespInfo.lsoId.ToString()},
                        };
                        listOfDataEditor.Add(dataEditor);
                    }
                }
                return listOfDataEditor;
            }
            return null;
        }

        /// <summary>
        /// Used by dplySampleOwner, sample owner grid
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="strUserIds"></param>
        /// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("deployment/getDplySampleOwner")]
        public async Task<ActionResult> GetDplySampleOwner(Guid dplyId, string strUserIds)
        {
            try
            {
                if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                if (Guid.Empty.Equals(dplyId)) return Json(new FailResponse("No deployment selected"));

                if (strUserIds.Length == 0) return Json(new FailResponse("No list sample info selected"));

                List<Guid> listUserIds = strUserIds.Split(",").Distinct().ToList().ConvertAll(Guid.Parse);

                List<vSP_ListSampleRespInfo> listOfListSampleRespInfo = await vSP_ListSampleRespInfo.GetByDplyIdAndUserId(dplyId, listUserIds);

                if (listOfListSampleRespInfo == null) return Json(new FailResponse("NO_ASSIGNMENT"));

                return Json(new ItemSuccessResponse<List<vSP_ListSampleRespInfo>>(listOfListSampleRespInfo));
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(GetDplySampleOwner) + " - caught unexpected exception, dplyId={0}, strUserIds={1}", dplyId, strUserIds);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Transfer assignments of sample to data editors
        /// Will remove old data assignment and link with new data editor
        /// If data assignment is same data editor, it will skip the remove
        /// </summary>
        /// <param name="dplyId">deployment id</param>
		/// <param name="dataEditorIds">new data editor ids</param>
		/// <param name="sampleOwnerIds">deployment sample owner ids</param>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("deployment/TsfSamplesToDataEditor")]
        public async Task<ActionResult> TransferSamplesToDataEditor()
        {
            //TODO - this method needs proper exception handling!

            int sqlBatchSize = 500;
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid structDivisionForAudit = currentUser.StructDivisionId.Value;

            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

            string strDplyId = HttpContext.Request.Form["dplyId"];
            if (!Guid.TryParse(strDplyId, out Guid dplyId))
                return Json(new FailResponse("No deployment selected"));

            string strDataEditorIds = HttpContext.Request.Form["dataEditorIds"];
            if (string.IsNullOrEmpty(strDataEditorIds))
                return Json(new FailResponse("No Data Editor selected"));
            List<Guid> listDataEditorId = strDataEditorIds.Split(",").Distinct().ToList().ConvertAll(Guid.Parse);
            foreach(Guid id in listDataEditorId)
            {
                if (await IsDataEditorStructDivisionInDeploymentStructDivision(dplyId, id) == false)
                {
                    string name = (await SecurityUser.GetUserById(id)).Name;
                    return Json(new FailResponse($"Data editor {name} cannot be assigned to this deployment"));
                }
            }
            
            string strSampleOwnerIds = HttpContext.Request.Form["sampleOwnerIds"];
            if (string.IsNullOrEmpty(strSampleOwnerIds)) return Json(new FailResponse("No Sample Owner Ids selected"));
            List<Guid> sampleOwnerIdToDelete = strSampleOwnerIds.Split(",").Distinct().ToList().ConvertAll(Guid.Parse);

            List<Guid> listSampleIdToAdd = new List<Guid>();
            foreach(List<Guid> sampleOwnerId in sampleOwnerIdToDelete.ChunkBy(sqlBatchSize))
            {
                List<QNN_DPLY_SAMPLE_OWNER> dplySampleOwner = await QNN_DPLY_SAMPLE_OWNER.GetById(sampleOwnerId);
                if (dplySampleOwner != null)
                    listSampleIdToAdd.AddRange(dplySampleOwner.Select(x => x.ListSampleId).ToList());
            }
            listSampleIdToAdd = listSampleIdToAdd.Distinct().ToList(); //A Clean list sample prepare to add

            //Prepare data table
            DataTable table = new DataTable(QNN_DPLY_SAMPLE_OWNER.GetTableName());
            table.Columns.AddRange(QNN_DPLY_SAMPLE_OWNER.GetDataColumn());

            
            foreach (var dataEditorId in listDataEditorId)
            {
                //Get dply sample owner by data editors
                List<Guid> dplySampleOwnerListSampleId = null;
                List<QNN_DPLY_SAMPLE_OWNER> dplySampleOwner = await QNN_DPLY_SAMPLE_OWNER.GetByDplyIdAndUserId(dplyId, dataEditorId);
                if (dplySampleOwner != null)
                    dplySampleOwnerListSampleId = dplySampleOwner.Select(x => x.ListSampleId).ToList();

                foreach (Guid sampleIdToAdd in listSampleIdToAdd)
                {
                    if (dplySampleOwnerListSampleId != null && dplySampleOwnerListSampleId.Contains(sampleIdToAdd))
                    {
                        //Should only have one record
                        QNN_DPLY_SAMPLE_OWNER dplySampleOwnerData = dplySampleOwner.Where(x => x.ListSampleId == sampleIdToAdd).First();
                        
                        //Remove from delete list (skip)
                        sampleOwnerIdToDelete.Remove(dplySampleOwnerData.Id);

                        //Remove from List (to speed up huge checks)
                        dplySampleOwner.Remove(dplySampleOwnerData);
                        dplySampleOwnerListSampleId.Remove(dplySampleOwnerData.Id);
                    } else
                    {
                        table.Rows.Add(Guid.NewGuid(), dplyId, sampleIdToAdd, dataEditorId);
                    }
                }
            }

            //Run the transaction
            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    //Delete Transfer
                    foreach (var ListSampleOwnerId in sampleOwnerIdToDelete.ChunkBy(sqlBatchSize))
                    {
                        if (ListSampleOwnerId.Count > 0)
                            await spSP_DeleteSampleOwnerByIds.DeleteByIds(
                                auditBatch.EventBatch, 
                                ListSampleOwnerId, 
                                currentUser.Id, 
                                structDivisionForAudit);
                    }

                    if (table.Rows.Count > 0)
                    {
                        DbHelper.BulkCopyDataTable(table, shared);

                        if (auditBatch.AuditOn)
                        {
                            var newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(table);
                            await SurveyPlusAuditHelper.BatchImport(
                                Constants.ModelName.QNN_DPLY_SAMPLE_OWNER,
                                auditBatch,
                                structDivisionForAudit,
                                newValue);
                        }
                    }

                    shared.Commit();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(TransferSamplesToDataEditor) + " - caught unexpected exception");

                    await shared.RollbackAsync().ConfigureAwait(false);
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }
            }
            return Json(new SuccessResponse("Changes have been made"));
        }

        [HttpGet]
        [Authorize]
        [Route("deployment/getSampleOwnerCSV")]
        public async Task<ActionResult> ExportSampleOwnerCSV(Guid dplyId, string fileName, string strUserIds)
        {
            //TODO - this method needs proper exception handling

            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
            if (Guid.Empty.Equals(dplyId)) return Json(new FailResponse("No deployment selected"));
            if (string.IsNullOrEmpty(fileName))
                return Json(new FailResponse("empty filename"));

            bool isLoadAllUsers = false;
            if (strUserIds == null || strUserIds == "null" || strUserIds.Length == 0)
                isLoadAllUsers = true;

            List<vSP_ListSampleRespInfo> listOfListSampleRespInfo;

            switch (isLoadAllUsers)
            {
                case true:
                    listOfListSampleRespInfo = await vSP_ListSampleRespInfo.GetByDplyIdOrderByUid(dplyId);
                    break;
                case false:
                    List<Guid> listUserIds = strUserIds.Split(",").Distinct().ToList().ConvertAll(Guid.Parse);
                    listOfListSampleRespInfo = await vSP_ListSampleRespInfo.GetByDplyIdAndUserIdOrderByUid(dplyId, listUserIds);
                    break;
            }

            if (listOfListSampleRespInfo != null && listOfListSampleRespInfo.Count > 0)
            {
                //Checks for struct
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid currentUserStructDivision = currentUser.StructDivisionId.Value;
                List<Guid> currentUserAllStructDivision = await vStructDivisionParentsAndThis.GetByParentStructId(currentUserStructDivision);

                List<Guid> listSampleUserId = listOfListSampleRespInfo.Select(x => x.UserId).Distinct().ToList();
                foreach(Guid userId in listSampleUserId)
                {
                    if(!currentUserAllStructDivision.Contains((await SecurityUser.GetUserById(userId)).StructDivisionId.Value))
                        listOfListSampleRespInfo = listOfListSampleRespInfo.Where(x => x.UserId != userId).ToList();
                }

                List<Dictionary<string, object>> items = new List<Dictionary<string, object>>();
                foreach (vSP_ListSampleRespInfo listSampleRespInfo in listOfListSampleRespInfo)
                {
                    Dictionary<string, object> item = new Dictionary<string, object>()
                    {
                        {Constants.FieldName.UID, listSampleRespInfo.UID},
                        {Constants.FieldName.UserName, listSampleRespInfo.Username}
                    };

                    items.Add(item);
                }
                var expandoObjects = items.Select(i => (dynamic)i.ToExpando());
                var memory = new MemoryStream();
                using (var ms = new MemoryStream())
                {
                    using (var writer = new StreamWriter(ms))
                    {
                        //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                        using (var csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                        {
                            csv.WriteRecords(expandoObjects);
                            csv.Flush();
                            writer.Flush();

                            ms.Seek(0, SeekOrigin.Begin);
                            ms.CopyTo(memory);
                        }
                    }
                }

                string contentType = Constants.ContentTypes.CsvFileType;
                memory.Seek(0, SeekOrigin.Begin);
                return File(memory, contentType, fileName);
            }
            else
            {
                return Json(new FailResponse("No samples found"));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/setSampleOwnerCSV")]
        public async Task<ActionResult> ImportSampleOwnerCSV()
        {
            //TODO - this method needs proper exception handling
            //TODO - move the logic parts to DeploymentApplication, controller should focus on being intermediary between messy web stuff and the business logic classes

            int sqlBatchSize = 500;
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid currentUserStructDivision = currentUser.StructDivisionId.Value;

            string strDplyId = HttpContext.Request.Form["dplyId"];
            if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.Edit))
                return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
            if (strDplyId == null) return Json(new FailResponse("No deployment selected"));

            if (!Guid.TryParse(strDplyId, out Guid dplyId))
                return Json(new FailResponse("Invalid request"));

            string strToken = HttpContext.Request.Form["token"];
            if (!Guid.TryParse(strToken, out Guid dwUploadedFileId))
                throw new ArgumentException("Invalid token (token format)", nameof(strToken));

            (Stream Stream, Dictionary<string, string> Properties) data = await CloverRuntime.ContentProvider.GetAsync(dwUploadedFileId);
            if (data.Stream == null || data.Properties == null)
                throw new ArgumentException("Invalid token (not found with content provider)", nameof(dwUploadedFileId));

            List<IDictionary<string, string>> csvRows = new List<IDictionary<string, string>>();
            ImmutableArray<string> headerRowColumns;
            using (Stream stream = data.Stream)
            {
                //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.CurrentCulture)
                {
                    HasHeaderRecord = true,
                    TrimOptions = TrimOptions.Trim, //trim unquoted whitespace (values and header names)
                };
                using (CsvReader csv = new CsvReader(new StreamReader(stream), csvConfiguration))
                {
                    csv.Read();
                    csv.ReadHeader();
                    headerRowColumns = csv.HeaderRecord.ToImmutableArray();

                    if (!(headerRowColumns.Contains(Constants.FieldName.UID) && headerRowColumns.Contains(Constants.FieldName.UserName)))
                        return Json(new FailResponse("CSV header do not have UID and UserName"));

                    while (csv.Read())
                    {
                        try
                        {
                            //Manually reading dictionary because I want to use a case-insensitive comparer for the column names
                            Dictionary<string, string> record = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                            foreach (string column in headerRowColumns)
                            {
                                string value = csv.GetField(column);
                                if (column == Constants.FieldName.UID || column == Constants.FieldName.UserName)
                                    record.Add(column, value);
                            }
                            csvRows.Add(record);
                        }
                        catch (Exception e)
                        {
                            throw new Exception(e.ToString());
                        }
                    } //end while read
                } //end using csv reader
            } //end using stream

            Dictionary<string, List<string>> csvRowsWithUserGroups = new Dictionary<string, List<string>>();
            foreach (var row in csvRows)
            {
                row.TryGetValue(Constants.FieldName.UID, out string UID);
                row.TryGetValue(Constants.FieldName.UserName, out string UserName);
                if (csvRowsWithUserGroups.ContainsKey(UserName))
                {
                    if (!csvRowsWithUserGroups[UserName].Contains(UID))
                    {
                        csvRowsWithUserGroups[UserName].Add(UID);
                    }
                }
                else
                {
                    csvRowsWithUserGroups.Add(UserName, new List<string>() { UID });
                }
            }

            //create sql
            DataTable table = new DataTable(QNN_DPLY_SAMPLE_OWNER.GetTableName());
            table.Columns.AddRange(QNN_DPLY_SAMPLE_OWNER.GetDataColumn());

            //do work here
            foreach (var row in csvRowsWithUserGroups)
            {
                SecurityUser securityUser = await SecurityUser.SelectByName(row.Key);
                if (securityUser == null)
                    return Json(new FailResponse($"Data Owner {row.Key} not found"));

                List<Guid> childSturctId = await vStructDivisionParentsAndThis.GetByParentStructId(currentUserStructDivision);
                if (!await IsDataEditorStructDivisionInDeploymentStructDivision(dplyId, securityUser.Id) || 
                    !childSturctId.Contains(securityUser.StructDivisionId.Value))
                    return Json(new FailResponse($"Data Owner {securityUser.Name} can not add to this deployment"));

                List<QNN_DPLY_SAMPLE_OWNER> listOfDplySampleOwner = await QNN_DPLY_SAMPLE_OWNER.GetByDplyIdAndUserId(dplyId, securityUser.Id);

                //this a batch of 500 Uid/insert
                foreach (List<string> listUid in row.Value.ChunkBy(sqlBatchSize))
                {
                    List<vSP_ListSampleInfoResp> listOfListSampleInfoResp = await vSP_ListSampleInfoResp.GetByDplyIdAndUid(dplyId, listUid);
                    if (listOfListSampleInfoResp == null)
                        return Json(new FailResponse($"UID {listUid.First()} not found"));

                    if (listUid.Count != listOfListSampleInfoResp.Count)
                    {
                        //count not match the retrieved list, some of the UID not in this deployment
                        List<string> errorUid = listUid.Except(listOfListSampleInfoResp.Select(x => x.UID)).ToList();
                        return Json(new FailResponse($"UID {errorUid.First()} can not add to this deployment"));
                    }

                    foreach (var listSampleInfoResp in listOfListSampleInfoResp)
                    {
                        if (listOfDplySampleOwner == null || listOfDplySampleOwner.All(x => x.ListSampleId != listSampleInfoResp.ListSampleId))
                        {
                            table.Rows.Add(Guid.NewGuid(), dplyId, listSampleInfoResp.ListSampleId, securityUser.Id);
                        }
                        else
                        {
                            //remove from the csv check list, this is to speed up the checks for large csv
                            listOfDplySampleOwner.Remove(listOfDplySampleOwner.Where(x => x.ListSampleId == listSampleInfoResp.ListSampleId).FirstOrDefault());
                        }
                    }
                }
            }

            if (table.Rows.Count > 0)
            {
                using (SharedTransaction shared = new SharedTransaction())
                {
                    await shared.BeginTransactionAsync();
                    DbHelper.BulkCopyDataTable(table, shared);

                    //audit
                    if (auditBatch.AuditOn)
                    {
                        var newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(table);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_DPLY_SAMPLE_OWNER,
                            auditBatch,
                            currentUserStructDivision,
                            newValue);
                    }

                    await shared.CommitAsync();
                }
            }
            return Json(new SuccessResponse("Changes have been made"));
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/getownersample")]
        public async Task<ActionResult> GetOwnerSample()
        {
            string userId = HttpContext.Request.Form["userId"];
            string dplyId = HttpContext.Request.Form["dplyId"];

            try
            {
                if (!CloverRuntime.Security.CheckPermission(Constants.PermissionGroup.SetDataEditor, Constants.PermissionGroup.Permission.View))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_DPLY_SAMPLE_OWNER, 0);

                var dm = await model.GetAsync(Filter.And.Equal(dplyId, "DplyId").Equal(userId, "UserId"));
                var ids = dm.Select(e => e["ListSampleId"].ToString()).ToList();
                return Json(new ItemSuccessResponse<List<string>>(ids));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetOwnerSample) + " - caught unexpected exception, userId={0}, dplyId={1}", userId, dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("/deployment/addnewsample")]
        public async Task<ActionResult> AddNewSample()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                if (!Guid.TryParse(HttpContext.Request.Form["dplyId"], out Guid dplyId) || !Guid.TryParse(HttpContext.Request.Form["listId"], out Guid listId))
                    return Json(new FailResponse("Invalid request"));

                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
                Guid auditStructDivisionId = currentUser.StructDivisionId.Value; //TODO - or should use from QNN_DPLY?
                List<string> delegationCodes = await DelegationApplication.GenerateDelegationCodes(dplyId);

                await spSP_AddDplySampleInfoByListId.ExecuteAsync(
                    dplyId,
                    listId,
                    delegationCodes,
                    auditBatch,
                    auditStructDivisionId);

                return Json(new SuccessResponse("List samples have been added to the deployment"));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AddNewSample) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/changeDueDate")]
        public async Task<ActionResult> ChangeDueDate()
        {
            string dplyId = HttpContext.Request.Form["dplyId"];
            string listSampleIds = HttpContext.Request.Form["listSampleIds"];
            DateTime dueDate = Convert.ToDateTime(HttpContext.Request.Form["dueDate"]);
            var listSampleIdArray = listSampleIds.Split(",");
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin))
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

                if (string.IsNullOrEmpty(dplyId)) throw new ArgumentNullException(nameof(dplyId));

                DateTime DplyDateStart = await GetDplyDateStart(Guid.Parse(dplyId));
                if (DplyDateStart == DateTime.MinValue) throw new Exception("Deployment Start Date is required.");

                //The reason comparing with DateStart than DateEnd:
                //If they have 10,000 sample and only one needs to be on the tighter deadline then is easier than setting the early date and extending for the other 9999
                if (dueDate <= DplyDateStart) return Json(new FailResponse($"Due Date must be after Deployment Start Date ({DplyDateStart.ToString(Constants.DatetimeFormat)})"));

                if (dueDate < DateTime.Now) return Json(new FailResponse($"Due Date may not be in the past"));

                using (var shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();
                    var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                        Constants.ModelName.QNN_DPLY_SAMPLE_DUEDATE, 0);
                    var dyObjectsList = new List<dynamic>();

                    foreach (var listSampleId in listSampleIdArray)
                    {
                        //Consider to throw an Exception and log an error? Anyhow this input is a must from frontend.
                        //Telling user "Invalid Inout" seems does not help anyone, even developer cannot tell what is that means until look into the code
                        if (!Guid.TryParse(listSampleId, out Guid _)) return Json(new FailResponse("Invalid Input"));
                        ;
                        var m = await model.NewAsync() as dynamic;
                        m.Id = Guid.NewGuid();
                        m.DplyId = dplyId;
                        m.DueDate = dueDate;
                        m.ListSampleId = listSampleId;
                        dyObjectsList.Add(m);
                    }

                    var (inserted, _) = await model.UpdateAsync(dyObjectsList);
                    shared.Commit();
                    return Json(new SuccessResponse("Due Date has been set"));
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ChangeDueDate) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Create / Update a message (mailmerge, email, profile) to specified samples
        /// (This was previously called Resend)
        /// </summary>
        /// <returns></returns>
		[HttpPost]
        [Authorize]
        [Route("deployment/profileMailMergeToSamples")]
        public async Task<ActionResult> ProfileMailMergeToSamples()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
                Guid auditStructDivisionId = currentUser.StructDivisionId.Value;

                Guid dplyId = Guid.Parse(HttpContext.Request.Form["dplyId"].FirstOrDefault());
                string dplyMsgIdString = HttpContext.Request.Form["dplyMsgId"]; //May be null, and entity type its for varies
                string delimitedListSampleIds = HttpContext.Request.Form["listSampleIds"];
                string toMailMerge = HttpContext.Request.Form["mailMerge"];
                string tosendMail = HttpContext.Request.Form["email"];
                string emailFrom = HttpContext.Request.Form["emailFrom"];
                if (!string.IsNullOrEmpty(emailFrom) && !Email.IsAddressFormatValid(emailFrom))
                {
                    return Json(new FailResponse("Invalid email address from"));
                }
                string scheduledDateString = HttpContext.Request.Form["scheduledDate"];
                var scheduledDate = !string.IsNullOrEmpty(scheduledDateString)
                    ? Convert.ToDateTime(scheduledDateString)
                    : (DateTime?)null;
                string toGenerateProfile = HttpContext.Request.Form["profile"];

                string subject = HttpContext.Request.Form["subject"];
                string body = HttpContext.Request.Form["msgContent"];
                string bodyJson = HttpContext.Request.Form["msgContentJson"];

                //nb: used for validation but can't update for existing message (yet)
                var bMailMerge = toMailMerge == "true" || toMailMerge == "1";
                var bEmail = tosendMail == "true" || tosendMail == "1";
                var bProfile = toGenerateProfile == "true" || toGenerateProfile == "1";

                if (!bMailMerge && !bEmail && !bProfile)
                    return Json(new FailResponse("Please check at least Mail Merge or Email"));
                if (bEmail && string.IsNullOrEmpty(subject))
                    return Json(new FailResponse("Please input email subject"));
                if ((bEmail || bMailMerge) && string.IsNullOrEmpty(body))
                    return Json(new FailResponse("Please input message content"));
                if (bEmail && scheduledDate != null && scheduledDate <= DateTime.Now)
                    return Json(new FailResponse("Start From must be later than current time"));

                IEnumerable<Guid> sampleIds = delimitedListSampleIds.Split(",").Select(s => Guid.Parse(s.Trim())).ToList();

                //insert to db and schedule
                bool createNewDplyMsg = string.IsNullOrEmpty(dplyMsgIdString);
                if (createNewDplyMsg)
                {
                    //TODO - eliminate the temp variables when copying to this
                    ProfileMailMergeOptions options = new ProfileMailMergeOptions(bMailMerge, bEmail, bProfile, emailFrom, body, bodyJson, subject, ProfileMailMergeOptions.DplyStep.Resend);

                    try
                    {
                        await profileMailMergeService.CreateJob(
                            auditBatch: auditBatch,
                            auditStructDivisionId: auditStructDivisionId,
                            sendTo: IProfileMailMergeService.TargetType.Samples,
                            targetIds: sampleIds,
                            dplyId: dplyId,
                            scheduledDate: scheduledDate,
                            options: options);
                    }
                    catch(Exception e)
                    {
                        logger.LogError(e, nameof(ProfileMailMergeToSamples) + " - error creating job, dplyId={0}", dplyId);
                        string msg = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(e.Message, "Check with system administrator");
                        return Json(new FailResponse($"Failed to create job. {msg}"));
                    }
                }
                else
                {
                    Guid dplyMsgId = Guid.Parse(dplyMsgIdString);   //TODO - why is this a string??????????
                    try
                    {
                        await profileMailMergeService.UpdateJob(
                            auditBatch: auditBatch,
                            auditStructDivisionId: auditStructDivisionId,
                            sendTo: IProfileMailMergeService.TargetType.Samples,
                            dplyMsgId: dplyMsgId,
                            newTargetStatusIds: null,
                            newScheduledDate: scheduledDate.Value,
                            newBody: body,
                            newBodyJson: bodyJson,
                            newSubject: subject,
                            newEmailFrom: emailFrom);
                    }
                    catch(Exception e)
                    {
                        logger.LogError(e, nameof(ProfileMailMergeToSamples) + " - error updating job, dplyMsgId={0}", dplyMsgId);
                        string msg = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(e.Message, "Check with system administrator");
                        return Json(new FailResponse($"Failed to update job. {msg}"));
                    }
                }

                return Json(new SuccessResponse("Job scheduled"));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProfileMailMergeToSamples) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Create / Update a message by status (ie: samples having the specified status)
        /// Currently this one only supports for Email (and not profile, mail-merge)
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        [Route("deployment/profileMailMergeToStatus")]
        public async Task<ActionResult> ProfileMailMergeToStatus()
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
            Guid auditStructDivisionId = currentUser.StructDivisionId.Value;

            try
            {
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                {
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");
                }

                Guid qnnDplyId = Guid.Parse(HttpContext.Request.Form["dplyId"].FirstOrDefault());
                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDplyId))
                {
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                }

                string dplyMsgIdString = HttpContext.Request.Form["dplyMsgId"]; //may be null/empty, referenced entity varies
                string emailFrom = HttpContext.Request.Form["emailFrom"];
                if (!string.IsNullOrEmpty(emailFrom) && !Email.IsAddressFormatValid(emailFrom))
                {
                    return Json(new FailResponse("Invalid email address from"));
                }
                string scheduledDateString = HttpContext.Request.Form["scheduledDate"];
                string delimitedStatusIds = HttpContext.Request.Form["status"];
                string subject = HttpContext.Request.Form["subject"];
                string body = HttpContext.Request.Form["msgContent"];
                string bodyJson = HttpContext.Request.Form["msgContentJson"];
                List<string> listIncludeTags = string.IsNullOrEmpty(HttpContext.Request.Form["includeTags"]) ? null : JsonConvert.DeserializeObject<List<string>>(HttpContext.Request.Form["includeTags"]);
                List<string> listExcludeTags = string.IsNullOrEmpty(HttpContext.Request.Form["excludeTags"]) ? null : JsonConvert.DeserializeObject<List<string>>(HttpContext.Request.Form["excludeTags"]);

                if (string.IsNullOrEmpty(subject) || string.IsNullOrEmpty(body) || string.IsNullOrEmpty(delimitedStatusIds) || string.IsNullOrEmpty(scheduledDateString))
                    return Json(new FailResponse("Please input all the fields"));
                var scheduledDate = !string.IsNullOrEmpty(scheduledDateString)
                    ? Convert.ToDateTime(scheduledDateString)
                    : (DateTime?)null;

                if (scheduledDate != null && scheduledDate <= DateTime.Now)
                    return Json(new FailResponse("Start From must be later than current time"));

                IEnumerable<Guid> statusIds = delimitedStatusIds.Split(",").Select(s => Guid.Parse(s.Trim())).ToList();

                //insert to db and schedule
                bool createNewMsg = string.IsNullOrEmpty(dplyMsgIdString);
                if (createNewMsg)
                {
                    ProfileMailMergeOptions options = new ProfileMailMergeOptions(isMailMerge: false, isEmail: true, isProfile: false, emailFrom, body, bodyJson, subject, ProfileMailMergeOptions.DplyStep.Resend);

                    try
                    {
                        await profileMailMergeService.CreateJob(
                            auditBatch: auditBatch,
                            auditStructDivisionId: auditStructDivisionId,
                            sendTo: IProfileMailMergeService.TargetType.Status,
                            targetIds: statusIds,
                            dplyId: qnnDplyId,
                            scheduledDate: scheduledDate,
                            options: options);
                    }
                    catch(Exception e)
                    {
                        logger.LogError(e, nameof(ProfileMailMergeToStatus) + " - error creating job, dplyId={0}", qnnDplyId);
                        string msg = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(e.Message, "Check with system administrator");
                        return Json(new FailResponse($"Failed to create job. {msg}"));
                    }
                }
                else
                {
                    Guid dplyMsgId = Guid.Parse(dplyMsgIdString);  //TODO - this has no business being a string!
                    try
                    {
                        await profileMailMergeService.UpdateJob(
                            auditBatch: auditBatch,
                            auditStructDivisionId: auditStructDivisionId,
                            sendTo: IProfileMailMergeService.TargetType.Status,
                            newTargetStatusIds: statusIds,
                            dplyMsgId: Guid.Parse(dplyMsgIdString),  //TODO - this has no business being a string! 
                            newScheduledDate: scheduledDate.Value,
                            newBody: body,
                            newBodyJson: bodyJson,
                            newSubject: subject,
                            newEmailFrom: emailFrom);
                    }
                    catch(Exception e)
                    {
                        logger.LogError(e, nameof(ProfileMailMergeToStatus) + " - error updating job, dplyMsgId={0}", dplyMsgId);
                        string msg = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(e.Message, "Check with system administrator");
                        return Json(new FailResponse($"Failed to update job. {msg}"));
                    }
                }

                return Json(new SuccessResponse("Job scheduled"));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProfileMailMergeToStatus) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Create a message (profile, mailmerge, email) by status (ie: samples having the specified status)
        /// Does the same thing as ProfileMailMergeToStatus except instead of passing a date for when to do it, it passes null
        /// so it is immediate and it only creates (not update since its for immediate send). 
        /// TODO: this copypasta should be merged with ProfileMailMergeToStatus so we don't have to keep maintaining the same code
        ///       in both places (also I note that ProfileMailMergeToStatus DOES actually seem to support immediate... so why does this route
        ///       even exist?)
        /// </summary>
        /// <returns></returns>
		[HttpPost]
        [Authorize]
        [Route("deployment/profileMailMergeToStatusImmediate")]
        public async Task<ActionResult> ProfileMailMergeToStatusImmediate()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(currentUser.Id);
                Guid auditStructDivisionId = currentUser.StructDivisionId.Value;
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                {
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");
                }

                Guid dplyId = Guid.Parse(HttpContext.Request.Form["dplyId"].FirstOrDefault());
                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId))
                {
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                }

                string emailFrom = HttpContext.Request.Form["emailFrom"];
                if (!string.IsNullOrEmpty(emailFrom) && !Email.IsAddressFormatValid(emailFrom))
                {
                    return Json(new FailResponse("Invalid email address from"));
                }

                string delimitedStatusIds = HttpContext.Request.Form["status"];
                string subject = HttpContext.Request.Form["subject"];
                string body = HttpContext.Request.Form["msgContent"];
                string bodyJson = HttpContext.Request.Form["msgContentJson"];

                string toMailMerge = HttpContext.Request.Form["mailMerge"];
                string tosendMail = HttpContext.Request.Form["email"];
                string toGenerateProfile = HttpContext.Request.Form["profile"];

                bool bMailMerge = toMailMerge == "true" || toMailMerge == "1";
                bool bEmail = tosendMail == "true" || tosendMail == "1";
                bool bProfile = toGenerateProfile == "true" || toGenerateProfile == "1";

                if (bMailMerge)
                {
                    if (string.IsNullOrEmpty(delimitedStatusIds) || string.IsNullOrEmpty(body))
                    {
                        return Json(new FailResponse("Please input all the fields"));
                    }

                }
                else if (bEmail)
                {
                    if (string.IsNullOrEmpty(subject) || string.IsNullOrEmpty(body) || string.IsNullOrEmpty(delimitedStatusIds))
                    {
                        return Json(new FailResponse("Please input all the fields"));
                    }

                }
                else if (bProfile)
                {
                    if (string.IsNullOrEmpty(delimitedStatusIds))
                    {
                        return Json(new FailResponse("Please input all the fields"));
                    }
                }

                IEnumerable<Guid> statusIds = delimitedStatusIds.Split(",").Select(s => Guid.Parse(s.Trim())).ToList();

                ProfileMailMergeOptions options = new ProfileMailMergeOptions(bMailMerge, bEmail, isProfile: false, emailFrom, body, bodyJson, subject, ProfileMailMergeOptions.DplyStep.Resend);

                try
                {
                    await profileMailMergeService.CreateJob(
                        auditBatch: auditBatch,
                        auditStructDivisionId: auditStructDivisionId,
                        sendTo: IProfileMailMergeService.TargetType.Status,
                        targetIds: statusIds,
                        dplyId: dplyId,
                        scheduledDate: null, //enqueue for immediate execution
                        options: options);
                }
                catch(Exception e)
                {
                    logger.LogError(e, nameof(ProfileMailMergeToStatusImmediate) + " - error creating job, dplyId={0}", dplyId);

                    string msg = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(e.Message, "Check with system administrator");                    
                    return Json(new FailResponse($"Failed to create job. {msg}"));
                }

                return Json(new SuccessResponse("Job queued"));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProfileMailMergeToStatusImmediate) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/resetresppassword")]
        public async Task<ActionResult> ResetRespPassword()
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                const string sampleIdsParam = "sampleIds";
                List<Guid> sampleIds;
                try
                {
                    sampleIds = (Request.Form[sampleIdsParam].FirstOrDefault() ?? "")
                        .Split(',')
                        .Distinct(StringComparer.InvariantCultureIgnoreCase)
                        .Select(id => Guid.Parse(id))
                        .ToList();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(ResetRespPassword) + " - error reading sample ids from request");
                    return BadRequest($"invalid {sampleIdsParam}");
                }
                if (!sampleIds.Any()) return Json(new FailResponse("No samples specified"));
                int emailsQueued = await InternetAccountApplication.SendRespondentPasswordResetLinksAsync(sampleIds, isResetRetry: true);
                string msg = (emailsQueued == sampleIds.Count)
                ? (emailsQueued == 1)
                    ? "A reset link will be sent to the selected sample"
                    : $"Reset links will be sent to all {sampleIds.Count} selected samples"
                : $"Reset links will be sent to {emailsQueued} of {sampleIds.Count} selected samples. (Not all selected samples were successful)";
                return Json(new SuccessResponse(msg));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ResetRespPassword) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

#pragma warning disable CS0649 //Fields in this struct *are* assigned to, but its by reflection when doing JSON deserialisation
        /// <summary>
        /// For use in deserialising request to ResetRespDelegationCode
        /// </summary>
        private struct SampleAndInfoId
        {
            public Guid sampleId;
            public Guid sampleInfoId; //dlsi
        }
#pragma warning restore CS0649

        [HttpPost]
        [Authorize]
        [Route("deployment/resetrespdelegationcode")]
        public async Task<ActionResult> ResetRespDelegationCode()
        {
            EntityModel vSPListSampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);

            try
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                if (user == null || !user.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException();
                HashSet<Guid> allowedStructDivisions = await StructDivision.SelectChildrenAndThisIdSetAsync(user);

                //TODO - we don't use the sampleId passed in json anymore, we could rework request to just pass a simple list of dlsi
                List<SampleAndInfoId> sampleAndInfoIds;
                try
                {
                    string samplesIds = HttpContext.Request.Form["sampleIds"];
                    sampleAndInfoIds = JsonConvert.DeserializeObject<List<SampleAndInfoId>>(samplesIds);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(ResetRespDelegationCode) + " - caught error reading sampleIds");
                    return BadRequest("Invalid sampleIds");
                }

                //TODO - review if the business logic around sample and list activeYN here is actually correct
                //       currently we ignore the sample here if it is not active or active in the list
                //       nb: I have already updated SendNewDelegationCodes to reset delegation code in inactive ones
                //           but only email to the active ones 
                List<Guid> sampleInfoIds = sampleAndInfoIds.Select(ids => ids.sampleInfoId).ToList();
                Filter byDlsiList = Filter.And
                        .In(sampleInfoIds, Constants.FieldName.Id)
                        .Equal(true, Constants.FieldName.ListSampleRecordActiveYN)
                        .Equal(true, Constants.FieldName.SampleRecordActiveYN);
                List<DynamicEntity> vSPListSampleInfos = await vSPListSampleInfoModel.GetAsync(byDlsiList);

                if (!vSPListSampleInfos.Any())
                    return Json(new FailResponse("No active samples were specified"));

                //Verify Organisation access to the specified dlsi
                foreach (DynamicEntity vSPListSampleInfo in vSPListSampleInfos)
                {
                    Guid structDivisionId = (Guid)vSPListSampleInfo[Constants.FieldName.StructDivisionId];
                    if (!allowedStructDivisions.Contains(structDivisionId))
                    {
                        Guid dlsi = (Guid)vSPListSampleInfo[Constants.FieldName.Id];
                        throw new PermissionException($"StructDivision {structDivisionId} for dlsi {dlsi} is not in the user's organisation subtree");
                    }
                }

                int resetCount = await InternetAccountApplication.SendNewDelegationCodes(vSPListSampleInfos);
                return Json(new SuccessResponse($"Reset delegation code for {resetCount} samples and queued notification emails."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ResetRespDelegationCode) + " - caught an unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Authorize]
        [Route("/deployment/downloadMailMerge/{dplyMsgId}/{dplyId}")]
        public async Task<ActionResult> DownloadMailMerge(string dplyMsgId, string dplyId)
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole("SurveyAdmin")) //to add permission in the frontend
                    return Json(new FailResponse("You don't have the permission"));

                if (!Guid.TryParse(dplyId, out Guid _) || !Guid.TryParse(dplyMsgId, out Guid _))
                    return Json(new FailResponse("Invalid request"));

                //var virtualFilePath = $"temp/{dplyId}/{dplyMsgId}.pdf";
                //return File(virtualFilePath, System.Net.Mime.MediaTypeNames.Application.Octet, Path.GetFileName(virtualFilePath));
                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG,
                    0);
                var dm = (await model.GetAsync(Filter.And.Equal(dplyMsgId, "Id"))).FirstOrDefault() as dynamic;
                if (dm == null || dm.IsDeleted) return Json(new FailResponse("Invalid input"));
                return File(new MemoryStream(dm.MergeOutputFile), MediaTypeNames.Application.Octet,
                    $"{dplyMsgId}.pdf");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadMailMerge) + " - caught unexpected exception, dplyMsgId={0}, dplyId={1}", dplyMsgId, dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpGet]
        [Authorize]
        [Route("/deployment/downloadMailMerge/{token}")]
        [Route("/deployment/downloadProfile/{token}")]
        public async Task<ActionResult> DownloadMailMerge(string token)
        {
            if (!CloverRuntime.Security.CurrentUser.IsInRole("SurveyAdmin")) //to add permission in the frontend
                return Json(new FailResponse("You don't have the permission"));

            try
            {
                var data = await CloverRuntime.ContentProvider.GetAsync(token);
                var properties = data.Properties;
                var stream = data.Stream;

                var filename = "unknown";
                var contentType = "application/unknown";
                //TODO - This extract properties logic have been appear on TOO MANY PLACES, consider consolidate it by making a static class/method to avoid multi standard
                if (properties != null)
                {
                    if (properties.ContainsKey(Constants.FileProperties.Name) && properties[Constants.FileProperties.Name] != null) filename = properties[Constants.FileProperties.Name];

                    if (properties.ContainsKey(Constants.FileProperties.ContentType) && properties[Constants.FileProperties.ContentType] == null)
                        contentType = properties[Constants.FileProperties.ContentType];
                }

                return File(stream, contentType, filename);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadMailMerge) + " - caught unexpected exception, token={0}", token);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route(Constants.IntranetRoutes.DeploymentExportResponsePrepare)]
        public async Task<ActionResult> ExportResponsePrepare(string dplyIdStr)
        {
            if (!Guid.TryParse(dplyIdStr, out Guid dplyId)) return BadRequest("dplyId");
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.DataOwner))
                    throw new PermissionException($"Requires {Constants.Role.DataOwner}");

                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId))
                    throw new PermissionException($"Invalid organisation for dplyId={dplyId}");

                //TODO - rework the below job to use DI&SurveyPlus options etc... and not take settings from here

                //nb, end task only seems to use baseUrl if IntranetDomainAuthority missing now...
                Uri refererUri = new Uri(Request.Headers[HeaderNames.Referer]);
                string baseUrl = $"{refererUri.Scheme}://{refererUri.Authority}";

                if (string.IsNullOrEmpty(CloverRuntime.Security.CurrentUser.Email))
                {
                    return Json(new FailResponse("This operation requires your profile to have an email address to send the download link"));
                }

                //string exportResponsePath = Path.Combine(env.ContentRootPath, surveyPlusOptions.ExportedDeploymentResponseFolderPath);
                //await BusinessProcess.Enqueue.ExportDeploymentResponse(exportResponsePath, baseUrl, dplyId);
                await BusinessProcess.Enqueue.ExportDeploymentResponseData(dplyId);

                return Json(new SuccessResponse("The system is running the response export in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExportResponsePrepare) + " - caught an unexpected exception, dplyId={0}", dplyId);
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

        /// <summary>
        /// Queue a background job that will zip the uploaded respondent files for the deployment and send the 
        /// intranet user a link to download it when ready. 
        /// </summary>
        [HttpPost]
        [Authorize]
        [Route(Constants.IntranetRoutes.DeploymentExportUploadedFilesPrepare)]
        public async Task<ActionResult> ExportUploadedFilesPrepare(string dplyIdStr)
        {
            if (!Guid.TryParse(dplyIdStr, out Guid dplyId)) return BadRequest();
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.DataOwner))
                    throw new PermissionException($"Requires {Constants.Role.DataOwner}");

                if (string.IsNullOrEmpty(currentUser.Email))
                {
                    return Json(new FailResponse("This operation requires your profile to have an email address to send the download link"));
                }

                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId))
                    throw new PermissionException($"Invalid organisation for dplyId={dplyId}");

                bool isAnyFiles = await spSP_GetDplyUploadedFiles.HasAnyUploadedFiles(dplyId);
                if (!isAnyFiles)
                {
                    return Json(new FailResponse("No file to download. Probably this deployment has no file type question"));
                }

                await BusinessProcess.Enqueue.ExportDeploymentResponseFiles(dplyId);

                return Json(new SuccessResponse("The system is running the response file zipping process in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExportUploadedFilesPrepare) + " - caught unexpected exception for dplyId={0}", dplyId);
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/canceljob")]
        public async Task<ActionResult> CancelJob()
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole("SurveyAdmin")) //to add permission in the frontend
                    return Json(new FailResponse("You don't have the permission"));

                string strDplyMsgId = HttpContext.Request.Form["dplyMsgId"];

                if (string.IsNullOrEmpty(strDplyMsgId) || !Guid.TryParse(strDplyMsgId, out Guid dplyMsgId))
                    return Json(new FailResponse("Invalid access"));

                var userId = CloverRuntime.Security.CurrentUser?.Id;
                var userStructDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;


                var childrenStructDivisionIds =
                (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(userStructDivisionId,
                    "ParentId"))).Select(p => p.Id).Distinct().ToList();


                //get struct divisionid
                var dplyMsgModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG);
                var entity = (await dplyMsgModel.GetAsync(Filter.And.Equal(dplyMsgId, "Id"))).FirstOrDefault();
                if (entity == null || (bool?)entity["JobIsCanceled"] == true || entity["ScheduledDate"] == null)
                    return Json(new FailResponse("Invalid access"));
                var msgStructDivisionId = (Guid?)entity["DplyId_StructDivisionId"];

                if (!childrenStructDivisionIds.Any() || childrenStructDivisionIds.All(id => id != msgStructDivisionId))
                    return Json(new FailResponse("You don't have the permission"));
                if ((DateTime)entity["ScheduledDate"] < DateTime.Now)
                    return Json(new FailResponse("Cannot cancel an executed job"));
                BackgroundJob.Delete(entity["JobId"]?.ToString());
                entity["JobIsCanceled"] = true;
                entity["UpdatedDate"] = DateTime.Now;
                entity["UpdatedBy"] = userId;

                await dplyMsgModel.UpdateSingleAsync(entity);

                return Json(new SuccessResponse("Scheduled job has been canceled"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CancelJob) + " - caught unexpected exception");
            }

            return Json(new FailResponse("Job cancelation was not successful. Please contact system administrator"));
        }

        [HttpDelete]
        [Route("deployment/dataset/{dplyId}")]
        public async Task<ActionResult> ClearValidationDatasets(string dplyId)
        {
            try
            {
                if (!Guid.TryParse(dplyId, out Guid dplyGuid))
                    return BadRequest(nameof(dplyId));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                //Check the deployment's structDivisionId is under this user
                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyGuid))
                {
                    throw new PermissionException($"User {currentUser.Id} ({currentUser.Name} lacks organisation access for deployment {dplyGuid}");
                }

                await DeploymentApplication.ClearValidationDatasets(dplyGuid, currentUser);

                return Json(new SuccessResponse());
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ClearValidationDatasets) + " - caught unexpected exception, dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }		
        }

        [HttpPost]
        [Route("deployment/dataset/{dplyId}")]
        public async Task<ActionResult> UploadValidationDatasetsFromCSV(string dplyId)
        {
            try
            {
                if (!Guid.TryParse(dplyId, out Guid dplyGuid))
                    return BadRequest(nameof(dplyId));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyGuid))
                {
                    throw new PermissionException($"User {currentUser.Id} ({currentUser.Name}) lacks organisation access for dply {dplyGuid}");
                }

                if (Request.Form.Files.Count > 0)
                {
                    IFormFile file = Request.Form.Files[0];
                    if (!file.FileName.EndsWith(".csv", StringComparison.InvariantCultureIgnoreCase))
                    {   //Always need to use 'success' type for file fields
                        return Json(new SuccessResponse("INCORRECT FILE TYPE"));
                    }
                    
                    using (Stream stream = file.OpenReadStream())
                    {
                        try
                        {
                            Dictionary<string, object> importReport = await DeploymentApplication.UploadValidationDatasetsFromCSV(
                                currentUser,
                                dplyGuid,
                                stream);
                            return Json(new ItemSuccessResponse<Dictionary<string, object>>(importReport, "OK"));
                        }
                        catch(DeploymentApplication.InvalidValidationDatasetException ivde)
                        {
                            //e.g. "NO UID COLUMN" etc (clientside js checks this message)
                            //This is a fail, but need to use SuccessResponse due to file field issues
                            return Json(new SuccessResponse(ivde.Message)); 
                        }
                        catch(Exception)
                        {
                            throw; //handle in outer catch
                        }
                    }
                } 
                else
                {   //No file in request
                    return BadRequest("no file");
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadValidationDatasetsFromCSV) + " - failed with exception, dplyId={0}", dplyId);
                //nb: we have to use SuccessResponse to have the clientside onChange get called for the file input control
                return Json(new SuccessResponse("FAIL"));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/updaterecurrence")]
        public async Task<ActionResult> UpdateRecurrenceSettings()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                string body;
                using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    body = await reader.ReadToEndAsync();
                }
                dynamic data = JsonConvert.DeserializeObject(body) as dynamic;

                Guid dplyGuid = Guid.Parse((string)data.Id);
                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyGuid))
                    throw new PermissionException($"Lacks organisation access to dply {dplyGuid}");

                using (SharedTransaction shared = new SharedTransaction())
                {
                    try
                    {
                        shared.BeginTransactionAsync().Wait();
                        EntityModel qnnDplyModel 
                            = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
                        DynamicEntity qnnDply
                            = await DeploymentApplication.GetQnnDplyById(dplyGuid, qnnDplyModel);
                        if (qnnDply == null)
                            throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyGuid);
                        if (qnnDply[Constants.FieldName.RecurrenceOfDplyId] != null)
                        {
                            return Json(new FailResponse("Cannot set recurrence for a child deployment"));
                        }

                        bool recurrenceEnabled = (bool)data.RecurrenceEnabled;
                        qnnDply[Constants.FieldName.RecurrenceEnabled] = recurrenceEnabled;

                        //We persist the other settings passed even if not enabled as later they might want to enable and use them
                        qnnDply[Constants.FieldName.RecurrenceFrequency] = (string)data.RecurrenceFrequency;
                        qnnDply[Constants.FieldName.RecurrenceEndDate] = data.RecurrenceEndDate != null ? DateTime.SpecifyKind((DateTime)data.RecurrenceEndDate, DateTimeKind.Utc).ToLocalTime() : (DateTime?)null;
                        qnnDply[Constants.FieldName.RecurrenceAdvanceDays] = (int)data.RecurrenceAdvanceDays;
                        string recurrenceNotify = (string)data.RecurrenceNotify;
                        recurrenceNotify = (recurrenceNotify == null) ? null : recurrenceNotify.Trim();
                        qnnDply[Constants.FieldName.RecurrenceNotify] 
                            = string.IsNullOrEmpty(recurrenceNotify) 
                            ? null 
                            : recurrenceNotify; //nb: we will parse multiple address when sending
                        //nb: we only validate it if is is going to be used
                        string[] emailsArr = (recurrenceNotify == null) ? null : recurrenceNotify.Split(',');

                        if (recurrenceEnabled && emailsArr != null && emailsArr.Length > 0)
                        {
                            foreach (string emailAddr in emailsArr)
                            {
                                if (!Email.IsAddressFormatValid(emailAddr.Trim()))
                                {
                                    return Json(new FailResponse("Invalid email addresses for notification"));
                                }
                            }
                        }

                        //Recurrence PrePopulate Enabled
                        bool isRecurrencePrePopulateEnabled = data.IsRecurrencePrePopulateEnabled != null ? (bool)data.IsRecurrencePrePopulateEnabled : false;
                        if (isRecurrencePrePopulateEnabled)
                        {
                            bool unsupportedSourceDeploymentType
                                = (bool)qnnDply[Constants.FieldName.IsMultipleResponse]
                                || (bool)qnnDply[Constants.FieldName.IsAnonymous];
                            if (unsupportedSourceDeploymentType)
                            {
                                return Json(new FailResponse("Pre-population is not supported for multiple-response or anonymous survey types."));
                            }
                        }
                        qnnDply[Constants.FieldName.IsRecurrencePrePopulateEnabled] = isRecurrencePrePopulateEnabled;
                        if (isRecurrencePrePopulateEnabled && data.PrePopulateFields != null)
                        {
                            List<Guid> prePopulateQnnFieldIdsEnabled = new List<Guid>();
                            foreach (dynamic prePopulateField in data.PrePopulateFields)
                            {
                                if (prePopulateField.PrePopulate != null && (bool)prePopulateField.PrePopulate)
                                {
                                    prePopulateQnnFieldIdsEnabled.Add((Guid)prePopulateField.Id);
                                }
                            }

                            List<QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD> qnnDplyRecurrencePrePopulateFields = await QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD.GetByDplyId(dplyGuid);

                            List<Guid> qnnFieldIdsToRemove = new List<Guid>();
                            List<Guid> qnnFieldIdsToAdd = new List<Guid>();
                            if (qnnDplyRecurrencePrePopulateFields != null)
                            {
                                List<Guid> databaseQnnFieldIds = qnnDplyRecurrencePrePopulateFields.Select(e => e.QnnFieldId).ToList();
                                qnnFieldIdsToRemove = databaseQnnFieldIds.Except(prePopulateQnnFieldIdsEnabled).ToList();
                                qnnFieldIdsToAdd = prePopulateQnnFieldIdsEnabled.Except(databaseQnnFieldIds).ToList();
                            }
                            else
                            {
                                qnnFieldIdsToAdd = prePopulateQnnFieldIdsEnabled;
                            }

                            if (qnnFieldIdsToAdd.Count > 0 || qnnFieldIdsToRemove.Count > 0)
                            {
                                await spSP_UpdateRecurrencePrePopulateField.UpdateRecurrencePrePopulateField(
                                    dplyId: dplyGuid,
                                    qnnFieldIdsToAdd: qnnFieldIdsToAdd,
                                    qnnFieldIdsToRemove: qnnFieldIdsToRemove,
                                    userId: CloverRuntime.Security.CurrentUser.Id,
                                    userStructDivisionId: (Guid)CloverRuntime.Security.CurrentUser.StructDivisionId,
                                    eventBatch: Guid.NewGuid());
                            }
                        }//End of Recurrence PrePopulate Enabled

                        //Calculate the next start date and set up the hangfire job that will copy the deployment
                        Guid userId = CloverRuntime.Security.CurrentUser.Id;
                        await RecurrenceApplication.ScheduleNextRecurrence(qnnDply, DateTime.Now, userId);

                        qnnDply[Constants.FieldName.UpdatedBy] = userId;
                        qnnDply[Constants.FieldName.UpdatedDate] = DateTime.Now;

                        await qnnDplyModel.UpdateSingleAsync(qnnDply);
                        shared.Commit();

                        return Json(new SuccessResponse("Updated recurrence settings"));
                    }
                    catch (Exception)
                    {   //Rollback here, handle ex in outer catch
                        await shared.RollbackAsync().ConfigureAwait(false);
                        throw;
                    }
                }//end using tx
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UpdateRecurrenceSettings) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        private bool TryReadOptionalDateTime(IFormCollection form, string name, out DateTime? result)
        {
            result = null;
            string dateStr = (string)form[name];
            if (string.IsNullOrEmpty(dateStr))
            {
                return true;
            }
            else
            {
                if (!DateTime.TryParse(dateStr, out DateTime value))
                    return false;
                result = value;
                return true;
            }

        }

        [HttpPost]
        [Authorize]
        [Route("deployment/updatescheduledexport")]
        public async Task<ActionResult> UpdateScheduledExportSettings()
        {
            using (SharedTransaction shared = new SharedTransaction())
            {
                string jobId = null;
                try
                {

                    User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                    if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                        throw new PermissionException($"Not a {Constants.Role.SurveyAdmin}");

                    IFormCollection form = HttpContext.Request.Form;
                    if (!Guid.TryParse((string)form["dplyId"], out Guid dplyId))
                        return BadRequest("dplyId");
                    if (!Boolean.TryParse((string)form["scheduledExportEnabled"], out bool scheduledExportEnabled))
                        return BadRequest("scheduledExportEnabled");
                    string scheduledExportFrequency = (string)form["scheduledExportFrequency"]; //TODO - validate
                    if (!TryReadOptionalDateTime(form, "scheduledExportStartDate", out DateTime? scheduledExportStartDate))
                        return BadRequest("scheduledExportStartDate");
                    if (!TryReadOptionalDateTime(form, "scheduledExportEndDate", out DateTime? scheduledExportEndDate))
                        return BadRequest("scheduledExportEndDate");

                    HashSet<Guid> updatedRecipientIds = new HashSet<Guid>();
                    foreach (string recipientIdString in form["recipients"].ToArray())
                    {
                        if (!Guid.TryParse(recipientIdString, out Guid recipientId))
                            return BadRequest("recipients");
                        updatedRecipientIds.Add(recipientId);
                    }

                    shared.BeginTransactionAsync().Wait();

                    EntityModel qnnDplyModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
                    DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId, qnnDplyModel);
                    if (qnnDply == null)
                    {
                        throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyId);
                    }

                    if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyId, qnnDplyModel))
                    {
                        throw new PermissionException($"User does not have StructDivision access to QNN_DPLY {dplyId}");
                    }

                    qnnDply[Constants.FieldName.UpdatedBy] = currentUser.Id;
                    qnnDply[Constants.FieldName.UpdatedDate] = DateTime.Now;
                    qnnDply[Constants.FieldName.ScheduledExportEnabled] = scheduledExportEnabled;
                    //We always persist the other settings passed even if not enabled as later they might want to enable and use them
                    //so they can switch off the exports, and switch on later without losing their settings (though this will mean a
                    //reschedule of the next job based on setttings and current time)
                    qnnDply[Constants.FieldName.ScheduledExportFrequency] = (string)scheduledExportFrequency;
                    qnnDply[Constants.FieldName.ScheduledExportStartDate] = scheduledExportStartDate;
                    qnnDply[Constants.FieldName.ScheduledExportEndDate] = scheduledExportEndDate;

                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(UpdateScheduledExportSettings) + " - ScheduledExportEnabled={0}, ScheduledExportStartDate={1}, ScheduledExportEndDate={2}, recipients={3}",
                            scheduledExportEnabled,
                            scheduledExportStartDate,
                            scheduledExportEndDate,
                            updatedRecipientIds.Count);
                    }

                    if (scheduledExportEnabled)
                    {
                        //Some basic validation. We leave friendly validation to the UI
                        //n.b validity of recipients is checked at the time the job runs and could have changed since now,
                        //    so we don't worry about it here

                        if (scheduledExportEndDate < scheduledExportStartDate) return BadRequest("scheduledExportEndDate");

                        //TODO - check frequency value constant (not high priority as will fail when scheduling if not valid)
                    }

                    EntityModel dwSecurityUserModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
                    EntityModel qnnScheduledExportRecipientModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SCHEDULED_EXPORT_RECIPIENT, Constants.Level.NoJoins);
                    Filter byDplyId = Filter.And.Equal(dplyId, Constants.FieldName.DplyId);
                    Dictionary<Guid, DynamicEntity> existingRecipientsByRecipientId
                        = (await qnnScheduledExportRecipientModel.GetAsync(byDplyId))
                        .GroupBy(qser => (Guid)qser[Constants.FieldName.SecurityUserId]).Select(qser => qser.First()) //remove duplicates
                        .ToDictionary(qser => (Guid)qser[Constants.FieldName.SecurityUserId], qser => qser);
                    List<DynamicEntity> newRecipientEntitiesToAdd = new List<DynamicEntity>();
                    List<Guid> qserIdsToRemove = new List<Guid>();
                    List<Guid> recipientIdSpace = existingRecipientsByRecipientId.Keys.Union(updatedRecipientIds).ToList();
                    foreach (Guid recipientId in recipientIdSpace)
                    {
                        if (!updatedRecipientIds.Contains(recipientId))
                        {
                            Guid qserId = (Guid)existingRecipientsByRecipientId[recipientId][Constants.FieldName.Id];
                            qserIdsToRemove.Add(qserId);
                        }
                        else
                        {
                            //New and existing one we need to revalidate that they can be in the list
                            DynamicEntity recipient = await IntranetAccountApplication.GetDwSecurityUserByIdAsync(recipientId, dwSecurityUserModel);
                            if (recipient == null) return Json(new FailResponse("Invalid recipients"));

                            bool alreadyRecipient = existingRecipientsByRecipientId.ContainsKey(recipientId);
                            if (!alreadyRecipient)
                            {
                                DynamicEntity newRecipient = await qnnScheduledExportRecipientModel.NewAsync();
                                newRecipient[Constants.FieldName.DplyId] = dplyId;
                                newRecipient[Constants.FieldName.SecurityUserId] = recipientId;
                                newRecipientEntitiesToAdd.Add(newRecipient);
                            }
                            else
                            {
                                ; //no further action if there is already a child row in qser table
                            }
                        }
                    }
                    await qnnScheduledExportRecipientModel.DeleteAsync(qserIdsToRemove.Cast<object>().ToList());
                    await qnnScheduledExportRecipientModel.UpdateAsync(newRecipientEntitiesToAdd.Cast<dynamic>().ToList());

                    jobId = await scheduledExportService.ScheduleNextExport(qnnDply);
                    await qnnDplyModel.UpdateSingleAsync(qnnDply);
                    //warning: if the entity update above fails the hangfire job change isnt rolled back (even though we have a SharedTransaction)
                    shared.Commit();

                    return Json(new SuccessResponse("Updated scheduled export settings"));
                }
                catch (PermissionException pex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(UpdateScheduledExportSettings) + " - encountered an unexpected exception");
                    await shared.RollbackAsync().ConfigureAwait(false);
                    if (jobId != null) BackgroundJob.Delete(jobId); //rollback job if the update failed
                    return Json(new FailResponse(Constants.Message.InternalErrorException));
                }
            }
        }

        [HttpGet]
        [Authorize]
        [Route("deployment/{targetDplyId}/prepopulationfieldlist")] //sourceDplyId will be passed as query param
        public async Task<ActionResult> GetPrePopulationFieldList(Guid sourceDplyId, Guid targetDplyId)
        {
            if (Guid.Empty.Equals(sourceDplyId)) return BadRequest("sourceDplyId");
            if (Guid.Empty.Equals(targetDplyId)) return BadRequest("targetDplyId");
            if (sourceDplyId.Equals(targetDplyId)) return BadRequest("source==target");

            EntityModel qnnDplyModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);

            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.PrePopulate))
                    throw new PermissionException($"Lacks {Constants.Role.PrePopulate}");

                DynamicEntity sourceDply = await DeploymentApplication.GetQnnDplyById(sourceDplyId);
                if (sourceDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, sourceDplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(sourceDply, currentUser))
                    throw new PermissionException($"Lacks access to source deployment {sourceDplyId}");

                DynamicEntity targetDply = await DeploymentApplication.GetQnnDplyById(targetDplyId);
                if (targetDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, targetDplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(targetDply, currentUser))
                    throw new PermissionException($"Lacks access to target deployment {targetDplyId}");

                Guid sourceQnnId = (Guid)sourceDply[Constants.FieldName.QnnId];
                Guid targetQnnId = (Guid)targetDply[Constants.FieldName.QnnId];

                HashSet<string> sourceFieldNames
                    = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(sourceQnnId))
                    .Select(f => (string)f[Constants.FieldName.Name])
                    .ToHashSet(StringComparer.InvariantCultureIgnoreCase);

                ImmutableList<DynamicEntity> targetFields
                    = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(targetQnnId))
                    .ToImmutableList();

                List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();
                foreach (DynamicEntity targetField in targetFields)
                {
                    string name = (string)targetField[Constants.FieldName.Name];
                    if (sourceFieldNames.Contains(name))
                    {
                        results.Add(
                            new Dictionary<string, object>()
                            {
                                { "Id", (Guid)targetField[Constants.FieldName.Id] },
                                { "Name", name },
                                { "Type", (string)targetField[Constants.FieldName.Type] },
                                { "PrePopulate", false },
                            });
                    }
                }

                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(results));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetPrePopulationFieldList) + " - caught unexpected exception, sourceDplyId={0}, targetDplyId={1}", sourceDplyId, targetDplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("deployment/savedplycustomfrequencyrecurrence")]
        public async Task<ActionResult> SaveDplyCustomFrequencyRecurrence(string selectedId, string dplyId, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear)
        {
            try
            {
                if (!CloverRuntime.Security.CurrentUser.IsInRole("SurveyAdmin")) //to add permission in the frontend
                    return Json(new FailResponse("You don't have the permission"));

                bool result = await RecurrenceApplication.CustomRecurrence.SaveDplyCustomRecurrence(String.IsNullOrEmpty(selectedId) ? Guid.Empty : Guid.Parse(selectedId), Guid.Parse(dplyId), frequencyType, frequencyDay, frequencyMonth, frequencyYear);
                if (!result)
                {
                    return Json(new FailResponse("Failed to save. Please check with system administrator"));
                }

            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SaveDplyCustomFrequencyRecurrence) + " - caught unexpected exception, selectedId={0}, dplyId={0}", selectedId, dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }

            return Json(new SuccessResponse("The changes have been saved successfully"));
        }

        [HttpGet]
        [Authorize]
        [Route("deployment/CheckListHasSample/{listId}")]
        public async Task<ActionResult> CheckSampleList(Guid listId)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SurveyAdmin}");
                HashSet<Guid> allowedOrganisations 
                    = await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser.StructDivisionId.Value);

                DynamicEntity qnnList = await SampleListApplication.GetQnnListAsync(listId);
                if (qnnList == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_LIST, listId);
                Guid listStructDivisionId = (Guid)qnnList[Constants.FieldName.StructDivisionId];
                if (!allowedOrganisations.Contains(listStructDivisionId))
                    throw new PermissionException($"Lacks organisation access to list {listId}");

                (bool IsNotEmpty, bool IsAnonymousSampleOnly) list 
                    = await SampleListApplication.CheckListForDeployment(listId);

                return Json(new { 
                    success = true, 
                    result = list.IsNotEmpty, 
                    isAnonymousSampleOnly = list.IsAnonymousSampleOnly });
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CheckSampleList) + " - caught unexpected exception, listId={0}", listId);
                return Json(new { 
                    success = false, 
                    result = false, 
                    message = Constants.Message.InternalErrorException });
            }
        }

        [HttpGet]
        [Authorize]
        [Route("deployment/GenerateAnonymousSurveyURL/{dplyId}/{qnnId}")]
        public async Task<ActionResult> GenerateAnonymousSurveyURL(Guid dplyId, Guid qnnId)
        {
            //n.b qnnId is not longer used (GenerateAnonymousSurveyUrl uses the value from the deployment now)
            try
            {
                if (dplyId == Guid.Empty) throw new ArgumentException($"Invalid value: {dplyId}", nameof(dplyId));
                List<DeploymentApplication.AnonymousSurveyUrl> surveyLinkList = await DeploymentApplication.GenerateAnonymousSurveyUrl(dplyId);
                return Json(new { success = true, result = surveyLinkList });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GenerateAnonymousSurveyURL) + " - caught unexpected exception, dplyId={0}, qnnId={1}", dplyId, qnnId);
                //TODO - why cannot use FailResponse here?
                return Json(new { success = false, result = false, message = Constants.Message.InternalErrorException });
            }
        }

        [HttpGet]
        [Authorize]
        [Route("deployment/getForms")]
        public async Task<ActionResult> GetForms(Guid dplyId)
        {
            try
            {
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null) return BadRequest();

                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply))
                    return Unauthorized();

                Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];
                EntityModel qnnQnnFormModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);
                Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
                List<DynamicEntity> forms = await qnnQnnFormModel.GetAsync(byQnnId);
                List<IDictionary<string, object>> response = forms.Select(f => f.Dictionary).ToList();
                return Json(new ItemSuccessResponse<List<IDictionary<string, object>>>(response));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetForms) + " - caught unexpected exception, dplyId={0}", dplyId);
                return StatusCode(500);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("deployment/dataowners/{dplyIdStr}")]
        public async Task<ActionResult> GetDataOwners(string dplyIdStr)
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin)) throw new PermissionException();

                if (!Guid.TryParse(dplyIdStr, out Guid dplyId)) return BadRequest("dplyIdStr");

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                Guid dplyStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];

                List<DynamicEntity> dataOwners
                    = await IntranetAccountApplication.GetDwSecurityUsersInRoleAsync(
                        roleCode: Constants.Role.DataOwner,
                        inStructDivisionId: dplyStructDivisionId,
                        isExcludeLockedUsers: false);
                List<Dictionary<string, object>> namesAndIds = dataOwners.Select(
                    su => new Dictionary<string, object>
                    {
                        { Constants.FieldName.Id, (Guid)su[Constants.FieldName.Id] },
                        { Constants.FieldName.Name, (string)su[Constants.FieldName.Name] },
                    }).ToList();
                return Json(new ItemSuccessResponse<List<Dictionary<string, object>>>(namesAndIds));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetDataOwners) + " - caught an unexpected exception, dplyIdStr={0}", dplyIdStr);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("deployment/import/responseupload/{dplyId}")]
        public async Task<ActionResult> ImportResponseUpload(string dplyId)
        {
            //WARNING: the response export files may potentially be quite large, for example I estimate a 32k respondent MP response
            //         could be maybe 100Mb. This may exceed the allowed upload size for aspnetcore, it may be necessary to configure
            //         IIS to allow larger files for this scenario.
            // https://learn.microsoft.com/en-us/iis/configuration/system.webServer/security/requestFiltering/requestLimits/

            try
            {
                Guid dplyGuid = Guid.Parse(dplyId);
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                logger.LogDebug(nameof(ImportResponseUpload) + " - called for dplyId={0} by user={1} ({2})", dplyId, currentUser.Id, currentUser.Name);

                if (!currentUser.IsInRole(Constants.Role.Admins))
                {
                    throw new PermissionException($"Requires {Constants.Role.Admins}");
                }

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyGuid);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyGuid);

                if (false == await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(dplyGuid))
                {
                    throw new PermissionException("Lacks structDivision access");
                }

                if (Request.Form.Files.Count == 1)
                {
                    IFormFile file = Request.Form.Files[0];
                    if (!file.FileName.EndsWith(".csv", StringComparison.InvariantCultureIgnoreCase))
                    {
                        return Json(new SuccessResponse("INCORRECT FILE TYPE"));
                    }

                    Guid dplyStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                    string filename = $"ImportResponse_{dplyGuid}_{DateTime.Now.ToString("yyyyMMddTHHmmss")}.csv";
                    Dictionary<string, string> properties = new Dictionary<string, string>();
                    properties.Add(Constants.FileProperties.IsLocalStorage, Boolean.FalseString);
                    properties.Add(Constants.FileProperties.Name, filename);
                    properties.Add(Constants.FileProperties.ContentType, Constants.ContentTypes.CsvFileType);
                    properties.Add(Constants.FileProperties.IsDownloadable, Boolean.FalseString);
                    FileTicketBuilder ticketBuilder
                        = new FileTicketBuilder(FileTicketPurpose.ResponseImport, dplyStructDivisionId)
                            .CreatedBy(currentUser.Id)
                            .AddRoleRestriction(Constants.Role.Admins)
                            .RestrictToUser(currentUser.Id)
                            .Expires(DateTime.Now.AddHours(24))
                            .DeleteFileOnExpiry(true);

                    using (SharedTransaction shared = new SharedTransaction())
                    {
                        try
                        {
                            shared.BeginTransactionAsync().Wait();

                            using (Stream stream = file.OpenReadStream())
                            {
                                string token = await CloverRuntime.ContentProvider.AddAsync(stream, properties);
                                DynamicEntity ticket = await ticketBuilder.Build(token);
                                Guid ticketId = await FileTicketApplication.SaveFileTicket(ticket);
                                await BusinessProcess.Enqueue.ResponseImport(ticketId, dplyGuid);
                            }

                            shared.Commit();
                        }
                        catch (Exception)
                        {
                            await shared.RollbackAsync().ConfigureAwait(false);
                            throw;
                        }
                        return Json(new SuccessResponse("OK"));
                    }
                }
                else
                {
                    return BadRequest($"Expected 1 file upload but found {Request.Form.Files.Count}");
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ImportResponseUpload) + " - caught unexpected exception, dplyId={0}", dplyId);
            }
            //nb: we have to use SuccessResponse to have the clientside onChange get called
            return Json(new SuccessResponse("FAIL"));
        }

        [HttpPost]
        [Route("deployment/maintenance/applyDates")]
        public async Task<ActionResult> MaintenanceApplyDates(string dplyId, string dateStart, string dateEnd)
        {
            try
            {
                Guid dplyGuid; DateTime start, end;
                try
                {
                    dplyGuid = Guid.Parse(dplyId);
                    start = DateTime.Parse(dateStart);
                    end = DateTime.Parse(dateEnd);
                }
                catch (FormatException fe)
                {
                    logger.LogError(fe, nameof(MaintenanceApplyDates) + " - bad request data");
                    return BadRequest();
                }

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Admins))
                    throw new PermissionException($"Needs {Constants.Role.Admins}");

                EntityModel qnnDplyModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyGuid, qnnDplyModel);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyGuid);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply))
                    throw new PermissionException($"Lacks StructDivision access to QNN_DPLY {dplyGuid}");

                qnnDply[Constants.FieldName.UpdatedBy] = currentUser.Id;
                qnnDply[Constants.FieldName.UpdatedDate] = DateTime.Now;
                qnnDply[Constants.FieldName.DateStart] = start;
                qnnDply[Constants.FieldName.DateEnd] = end;

                await qnnDplyModel.UpdateSingleAsync(qnnDply);

                logger.LogDebug(nameof(MaintenanceApplyDates) + " - updated deployment {0} ({1}) dates. DateStart={2}, DateEnd={3}", dplyGuid, (string)qnnDply[Constants.FieldName.Name], start, end);

                return Json(new SuccessResponse());
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(MaintenanceApplyDates) + " - caught unexpected exception. dplyId={0}, dateStart={1}, dateEnd={2}", dplyId, dateStart, dateEnd);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Schedule a Pre-Populate from an online deployment
        /// </summary>
        [HttpPost]
        [Authorize]
        [Route("deployment/{targetDplyId}/prepopulate")]
        public async Task<ActionResult> PrePopulate(Guid targetDplyId)
        {
            if (Guid.Empty.Equals(targetDplyId)) return BadRequest("targetDplyId");

            EntityModel qnnDplyModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);

            try
            {
                IFormCollection form = HttpContext.Request.Form;

                if (!Guid.TryParse(form["sourceDplyId"], out Guid sourceDplyId))
                    return BadRequest("sourceDplyId");

                if (targetDplyId.Equals(sourceDplyId))
                    return BadRequest("source==target");

                if (!ConversionUtils.TryParseCommaDelimitedGuids((string)form["fieldIds"], out List<Guid> fieldIds))
                    return BadRequest("fieldIds (invalid)");
                if (!fieldIds.Any())
                    return BadRequest("fieldIds (required)");

                TryReadOptionalDateTime(form, "scheduledTime", out DateTime? scheduledTime);
                if (scheduledTime != null)
                {
                    DateTime now = DateTime.Now;
                    if (scheduledTime < now) return BadRequest("scheduledTime");
                    if (scheduledTime > now.AddDays(1)) return BadRequest("scheduledTime");
                }

                //We need to verify that the current user is allowed to use the pre-populate feature and that
                //they have access to both the source and target deployments (and that these exist)
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.PrePopulate))
                    throw new PermissionException($"Lacks {Constants.Role.PrePopulate}");

                DynamicEntity sourceDply = await DeploymentApplication.GetQnnDplyById(sourceDplyId);
                if (sourceDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, sourceDplyId);
                
                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(sourceDply, currentUser))
                    throw new PermissionException($"Lacks access to source deployment {sourceDplyId}");

                DynamicEntity targetDply = await DeploymentApplication.GetQnnDplyById(targetDplyId);
                if (targetDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, targetDplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(targetDply, currentUser))
                    throw new PermissionException($"Lacks access to target deployment {targetDplyId}");

                bool unsupportedSourceDeploymentType
                    = (bool)sourceDply[Constants.FieldName.IsMultipleResponse]
                    || (bool)sourceDply[Constants.FieldName.IsAnonymous];
                if(unsupportedSourceDeploymentType)
                {
                    return Json(new FailResponse("Source deployment may not be a multiple-response or anonymous survey."));
                }

                //Having verified access to the deployments we need to verify that the requested fields are valid
                //in both the source and target deloyment. We get passed the field's Id values in the target deployment
                //so we need to get the name to check against the source deployment which is likely using a different
                //but similar form. (We don't bother checking that types match here, just that field is present in both)
                Guid sourceQnnId = (Guid)sourceDply[Constants.FieldName.QnnId];
                Guid targetQnnId = (Guid)targetDply[Constants.FieldName.QnnId];

                ImmutableDictionary<Guid, DynamicEntity> targetFieldsByIds
                    = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(targetQnnId))
                    .ToImmutableDictionary(
                        f => (Guid)f[Constants.FieldName.Id],
                        f => f);

                HashSet<string> sourceFieldNames
                    = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(sourceQnnId))
                    .Select(f => (string)f[Constants.FieldName.Name])
                    .ToHashSet(StringComparer.InvariantCultureIgnoreCase);

                //Check all the supplied fieldIds. We get the name and check if the source deployment has a field
                //by that name too. At this point we expect the UI to only be giving us valid data so out error is
                //an unfriendly 400
                List<string> prePopulateFieldNames = new List<string>();
                foreach (Guid fieldId in fieldIds)
                {
                    if (targetFieldsByIds.TryGetValue(fieldId, out DynamicEntity targetField))
                    {
                        string fieldName = (string)targetField[Constants.FieldName.Name];
                        if (!sourceFieldNames.Contains(fieldName))
                            return BadRequest($"fieldIds {fieldId} (not in source:{fieldName})");
                        prePopulateFieldNames.Add(fieldName);
                    }
                    else
                    {
                        return BadRequest($"fieldIds {fieldId} (not in target)");
                    }
                }

                string scheduledFor;
                if (scheduledTime != null)
                {
                    scheduledFor = scheduledTime.Value.ToString(Constants.DatetimeFormat);
                    string jobId = await BusinessProcess.Schedule.PrePopulate(
                        scheduledTime: scheduledTime.Value,
                        user: currentUser,
                        sourceDplyId: sourceDplyId,
                        targetDplyId: targetDplyId,
                        fieldNames: prePopulateFieldNames);
                }
                else
                {
                    scheduledFor = "immediate execution";
                    await BusinessProcess.Enqueue.PrePopulate(
                        user: currentUser,
                        sourceDplyId: sourceDplyId,
                        targetDplyId: targetDplyId,
                        fieldNames: prePopulateFieldNames);
                }

                return Json(new SuccessResponse($"Pre-populate from online deployment scheduled for {scheduledFor}. An email will be sent on completion."));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PrePopulate) + " - caught unexpected exception, targetDplyId={0}", targetDplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Schedule a Pre-Populate from an uploaded CSV file
        /// </summary>
        [HttpPost]
        [Authorize]
        [Route("deployment/{targetDplyId}/prepopulatecsv")]
        public async Task<ActionResult> PrePopulateCSV(Guid targetDplyId)
        {
            if (Guid.Empty.Equals(targetDplyId)) return BadRequest("targetDplyId");

            EntityModel qnnDplyModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);

            try
            {
                IFormCollection form = HttpContext.Request.Form;

                string token = (string)form["token"];
                if (string.IsNullOrEmpty(token))
                    return BadRequest("token");

                TryReadOptionalDateTime(form, "scheduledTime", out DateTime? scheduledTime);
                if (scheduledTime != null)
                {
                    DateTime now = DateTime.Now;
                    if (scheduledTime < now) return BadRequest("scheduledTime (must be future)");
                    if (scheduledTime > now.AddDays(1)) return BadRequest("scheduledTime (max 24 hours ahead)");
                }

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.PrePopulate))
                    throw new PermissionException($"Lacks role {Constants.Role.PrePopulate}");

                DynamicEntity targetDply = await DeploymentApplication.GetQnnDplyById(targetDplyId);
                if (targetDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, targetDplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(targetDply, currentUser))
                    throw new PermissionException($"Lacks access to target deployment {targetDplyId}");

                Guid targetQnnId = (Guid)targetDply[Constants.FieldName.QnnId];

                ISet<string> targetDplyFields
                    = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(targetQnnId))
                    .Select(f => (string)f[Constants.FieldName.Name])
                    .ToImmutableHashSet();

                (PrePopCSVValidity Outcome, object AdditionalInfo) validity 
                    = await VerifyPrePopulationCSV(token, targetDplyFields);

                if(PrePopCSVValidity.Valid!=validity.Outcome)
                {
                    await CloverRuntime.ContentProvider.RemoveAsync(token);

                    switch (validity.Outcome)
                    {
                        case PrePopCSVValidity.Valid: //checked this one already
                            throw new InternalException("Execution should not reach here");

                        case PrePopCSVValidity.IncorrectFileType:
                            return Json(new FailResponse("Incorrect file type. Please upload a CSV file."));

                        case PrePopCSVValidity.NoUIDColumn:
                            return Json(new FailResponse("Invalid file. A UID column is required to identify samples."));

                        case PrePopCSVValidity.NoAliasColumn:
                            return Json(new FailResponse("Uploaded file does not have valid alias for this deployment. Did you select the correct CSV file?"));

                        case PrePopCSVValidity.BadFile:
                            return Json(new FailResponse($"The CSV file could not be parsed. Please check format. {validity.AdditionalInfo??""}"));

                        case PrePopCSVValidity.EmptyFile:
                            return Json(new FailResponse("The file is empty"));

                        case PrePopCSVValidity.NoData:
                            return Json(new FailResponse("The file has no data after the header row"));

                        case PrePopCSVValidity.DuplicateHeaderDetected:
                            IEnumerable<string> duplicateColumnNames = (IEnumerable<string>)validity.AdditionalInfo;
                            return Json(new FailResponse($"Uploaded file contains duplicate header(s). Please remove duplicates and try again. {string.Join(",", duplicateColumnNames)}"));

                        default:
                            return Json(new FailResponse($"The file was not valid: {validity.Outcome}"));
                    }
                }
                else
                {
                    bool isScheduled = (scheduledTime != null);

                    //Use a ticket to ensure file will be deleted even if the job fails to do so
                    DateTime ticketExpiry = isScheduled ? scheduledTime.Value.AddHours(24) : DateTime.Now.AddHours(24);
                    Guid ticketId = await FileTicketApplication.SaveFileTicket(
                        await new FileTicketBuilder(
                            token,
                            FileTicketPurpose.PrePopulation,
                            (Guid)targetDply[Constants.FieldName.StructDivisionId])
                        .DeleteFileOnExpiry(true)
                        .Expires(ticketExpiry)
                        .RestrictToUser(currentUser.Id)
                        .AddRoleRestriction(Constants.Role.PrePopulate)
                        .Build());

                    string scheduledFor;
                    if (isScheduled)
                    {
                        scheduledFor = scheduledTime.Value.ToString(Constants.DatetimeFormat);
                        string jobId = await BusinessProcess.Schedule.PrePopulateCSV(scheduledTime.Value, currentUser, targetDplyId, ticketId);
                    }
                    else
                    {
                        scheduledFor = "immediate execution";
                        await BusinessProcess.Enqueue.PrePopulateCSV(currentUser, targetDplyId, ticketId);
                    }

                    return Json(new SuccessResponse($"Pre-populate from CSV scheduled for {scheduledFor}. An email will be sent on completion. {validity.AdditionalInfo}"));
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(PrePopulateCSV) + " - caught unexpected exception, targetDplyId={0}", targetDplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("deployment/maintenance/purgeresponses")]
        public async Task<ActionResult> MaintenancePurgeResponses(Guid dplyId)
        {
            try
            {
                if (Guid.Empty.Equals(dplyId))
                    return BadRequest("dplyId");

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.Admins))
                    throw new PermissionException($"Needs {Constants.Role.Admins}");
                Guid structDivisionForAuditPurposes = currentUser.StructDivisionId.Value;

                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                if (!await DeploymentApplication.CheckDeploymentStructDivisionAccessAsync(qnnDply))
                    throw new PermissionException($"Lacks StructDivision access to QNN_DPLY {dplyId}");

                if(logger.IsEnabled(LogLevel.Warning))
                {
                    logger.LogWarning(nameof(MaintenancePurgeResponses) + " - purging responses for dplyId={0} ({1}), user={2} ({3})", dplyId, (string)qnnDply[Constants.FieldName.Name], currentUser.Id, currentUser.Name);
                }

                AuditBatch auditBatch = await AuditSettings.NewBatchAsync();
                await spSP_PurgeResp.DeleteResponsesForDeployment(auditBatch, structDivisionForAuditPurposes, dplyId);

                return Json(new SuccessResponse($"All responses to {qnnDply[Constants.FieldName.Name]} have been deleted"));
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(MaintenancePurgeResponses) + " - caught unexpected exception. dplyId={0}", dplyId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        enum PrePopCSVValidity { Valid, IncorrectFileType, NoUIDColumn, NoAliasColumn, DuplicateHeaderDetected, BadFile, EmptyFile, NoData }

        //TODO - move to DeploymentApplication
        /// <summary>
        /// Scan through the uploaded file looking for trouble
        /// </summary>
        private async Task<(PrePopCSVValidity Outcome, object AdditionalInfo)> VerifyPrePopulationCSV(
            string token, 
            ISet<string> fieldNames)
        {
            if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));
            if (fieldNames == null) throw new ArgumentNullException(nameof(fieldNames));

            (Stream Stream, Dictionary<string, string> Properties) file 
                = await CloverRuntime.ContentProvider.GetAsync(token);
            if (file.Stream == null) throw new NotFoundException($"file not found for token {token}");

            string fileName = file.Properties[Constants.FileProperties.Name];
            if (!fileName.EndsWith(".csv", StringComparison.InvariantCultureIgnoreCase))
            {
                return (PrePopCSVValidity.IncorrectFileType, null);
            }

            //TODO - consider if we need a content type check here

            using (file.Stream)
            {
                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
                {
                    HasHeaderRecord = true,
                    PrepareHeaderForMatch = (args) => args.Header.Trim(),
                };
                using (CsvReader csv = new CsvReader(new StreamReader(file.Stream), csvConfiguration))
                {
                    try
                    {
                        bool hasContent = csv.Read(); //move to first row
                        if(!hasContent)
                        {
                            return (PrePopCSVValidity.EmptyFile, null);
                        }
                        csv.ReadHeader(); //read this first row as the header names                     
                        IList<string> headerRowColumns
                            = csv.HeaderRecord
                            .Select(header => header.Trim())
                            .ToImmutableList();

                        //Fail immediately if the CSV doesn't contain a UID column
                        if (!headerRowColumns.Contains(PrePopulatorCsvDataSource.UID_COLUMN, Constants.Comparers.AliasCaseInsensitive))
                        {
                            return (PrePopCSVValidity.NoUIDColumn, null);
                        }

                        //Fail if CSV contain duplicate column names 
                        //TODO - this could be made to ignore those duplicates that aren't in the set of target fields
                        IList<string> duplicateColumnNames = headerRowColumns
                            .GroupBy(columnName => columnName.ToUpperInvariant())
                            .Where(grouping => grouping.Count() > 1)
                            .Select(grouping => grouping.Key)
                            .ToImmutableList();
                        if (duplicateColumnNames.Any())
                        {
                            return (PrePopCSVValidity.DuplicateHeaderDetected, duplicateColumnNames);
                        }

                        //Fail if CSV does not contain any alias from the target deployment
                        if (!headerRowColumns.Intersect(fieldNames, Constants.Comparers.AliasCaseInsensitive).Any())
                        {
                            return (PrePopCSVValidity.NoAliasColumn, null);
                        }

                        //Scan the whole file here just to check it can parse and has no missing fields
                        //(CSVHelper can be made to not treat these as an error,
                        //but we prefer to fail-fast if they upload bad data)
                        int rowCount = 0;
                        while (csv.Read()) 
                        {
                            for(int column=0; column < headerRowColumns.Count; column++)
                            {
                                string value = csv.GetField(column); //Will throw MissingFieldException if not enough columns
                            }
                            rowCount++;
                        }

                        //Fail if there is no data after the header row
                        if (rowCount == 0) 
                        {
                            return (PrePopCSVValidity.NoData, null);
                        }

                        return (PrePopCSVValidity.Valid, $"File has {rowCount} rows of data");
                    }
                    catch (CsvHelperException csvhex)
                    {
                        string badColumn = csvhex.Context.Reader.HeaderRecord[csv.CurrentIndex];
                        StringBuilder additionalInfo = new StringBuilder();
                        if(csvhex is CsvHelper.MissingFieldException)
                        {   //need moar commas
                            additionalInfo.Append("Missing column ");
                        }
                        else if (csvhex is CsvHelper.BadDataException)
                        {   //caused by bad format, e.g unclosed quotes
                            additionalInfo.Append("Bad data in column ");
                        }
                        else
                        {
                            additionalInfo.Append($"{csvhex.GetType().Name} - check column ");
                        }
                        additionalInfo.Append($"{csvhex.Context.Reader.CurrentIndex} ({badColumn}), row {csvhex.Context.Reader.Parser.Row}");
                        logger.LogError(csvhex, nameof(VerifyPrePopulationCSV) + " - failed to read the file, fileName={0}, additionalInfo={1}", fileName, additionalInfo);
                        return (PrePopCSVValidity.BadFile, additionalInfo);
                    }
                } //end using csvreader                
            }//end using file stream
        }

        //TODO - move to DeploymentApplication (or refactor out to use GetQnnDplyById instead)
        private async Task<DateTime> GetDplyDateStart(Guid dplyId)
        {
            DateTime result = DateTime.MinValue;
            EntityModel model = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, 0);
            Filter filter = Filter.And.Equal(dplyId, Constants.FieldName.Id);
            List<DynamicEntity> entityList = await model.GetAsync(filter);
            //TODO - why is the below so convoluted?
            if (entityList != null && entityList.Any() && entityList.FirstOrDefault() != null && entityList.FirstOrDefault().Dictionary.ContainsKey(Constants.FieldName.DateStart))
            {
                result = Convert.ToDateTime(entityList.FirstOrDefault().Dictionary[Constants.FieldName.DateStart]);
            }
            return result;    //TODO - so we really want to return DateTime.MinValue if the deployment doesnt exist?
        }

    }
}
