using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using CsvHelper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using System.Globalization;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.Clover.Core.Security;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class TrkListController : Controller
    {
        private readonly ILogger logger;
        
        public TrkListController(ILogger<TrkListController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        [Route("/trklist/exportsample")]
        public async Task<ActionResult> ExportSample(string trkListId)
        {
            try
            {
                if (!Guid.TryParse(trkListId, out Guid qnnTrkListId)) return BadRequest();

                await ControllerUtilities.CheckPermission(Constants.PermissionGroup.List, Constants.PermissionGroup.Permission.View);

                //TODO - need to verify the current user has struct division access to this trklist

                List<Dictionary<string, object>> items = await spSP_GetTrkListSample.ExecuteAsync(qnnTrkListId);

                if (items != null && items.Any())
                {
                    var expandoObjects = items.Select(i => (dynamic)i.ToExpando());
                    var memory = new MemoryStream();
                    using (var ms = new MemoryStream())
                    {
                        using (var writer = new StreamWriter(ms))
                        {
                            //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                            using (CsvWriter csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                            {
                                csv.WriteRecords(expandoObjects);
                                csv.Flush();
                                writer.Flush(); //important to flush, or else streamTemp length can be anything


                                ms.Seek(0, SeekOrigin.Begin);
                                ms.CopyTo(memory);
                            }
                        }
                    }

                    var filename = "trklist_sample.csv";
                    var contentType = Constants.ContentTypes.CsvFileType;
                    memory.Seek(0, SeekOrigin.Begin);
                    return File(memory, contentType, filename);
                }
                else
                {
                    return Json(new FailResponse("No tracklist samples to export"));
                }
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExportSample) + " - caught an unexpected exception, trkListId={0}", trkListId);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Route("/trklist/importsamples")]
        public async Task<ActionResult> Import(string trkListId, string token)
        {
            try
            {
                if (!Guid.TryParse(trkListId, out var trkListGuid)) 
                    return BadRequest(new FailResponse("Invalid trkListId!"));

                if (!Guid.TryParse(token, out var _)) 
                    return BadRequest(new FailResponse("Invalid token!"));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid userId = currentUser.Id;
                Guid structDivisionId = currentUser.StructDivisionId.Value;
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(userId);

                //20241009 - simplified to checking for SurveyAdmin (as per sidemenu) instead of List.Edit
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                EntityModel qnnTrkListModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_TRK_LIST, Constants.Level.NoJoins);
                DynamicEntity trkList = (await qnnTrkListModel.GetAsync(Filter.And.Equal(trkListGuid, Constants.FieldName.Id))).FirstOrDefault();
                if (trkList == null)
                    throw NotFoundException.ForModelName(qnnTrkListModel.Name, trkListGuid);
                string trkListName = (string)trkList[Constants.FieldName.Name];

                //Verify organisation access to this track list
                Guid trkListStructDivisionId = (Guid)trkList[Constants.FieldName.StructDivisionId];
                bool isListInUsersStructDivisions
                    = (await StructDivision.SelectChildrenAndThisIdSetAsync(structDivisionId))
                    .Contains(trkListStructDivisionId);
                if (!isListInUsersStructDivisions)
                {
                    throw new PermissionException(
                        $"Track List {trkListGuid} ({trkListName}) with StructDivision {trkListStructDivisionId} is not in the organisation subtree of user {currentUser.Id} ({currentUser.Name}) in StructDivision {currentUser.StructDivisionId}");
                }

                //Now do the actual import work...
                TrkListApplication.TrkListImportResult result 
                    = await TrkListApplication.ImportTrkList(currentUser, trkListGuid, token);

                if(result.Success && logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(Import) + " - completed successfully for {0}, currentUser={1} ({2}), Statistics={3}, IRI count={4}", trkListName, currentUser.Id, currentUser.Name, result.Statistics, result.Items?.Count);
                }
                else
                {
                    logger.LogError(nameof(Import) + " - failed for {0}, result={1}, currentUser={2} ({3}), trkListGuid={4}, token={5}", trkListName, result, currentUser.Id, currentUser.Name, trkListGuid, token);
                }
                
                return Json(result);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Import) + " - caught an unexpected exception, trkListId={0}, token={1}", trkListId, token);
                return Json(new FailResponse(
                    TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(
                        e.Message, 
                        Constants.Message.InternalErrorException)));
            }
        }


    }
}