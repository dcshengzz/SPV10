using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CsvHelper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using static System.String;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Security;
using System.Globalization;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Collections.Immutable;
using Microsoft.Extensions.Primitives;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class ListController : Controller
    {
        private readonly ILogger logger;
        private readonly IConnectionStringProvider connectionStringProvider;

        public ListController(
            ILogger<ListController> logger, 
            IConnectionStringProvider connectionStringProvider)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.connectionStringProvider = connectionStringProvider ?? throw new ArgumentNullException(nameof(connectionStringProvider));
        }

        [HttpGet]
        [Route("list/genListprop/{listId?}/{listSampleId?}")]
        public async Task<ActionResult> GenListPropJson(string listId, string listSampleId)
        {
            //TODO - verify that user is in an appropriate structDivision for the list

            try
            {
                await ControllerUtilities.CheckPermission(Constants.PermissionGroup.List, Constants.PermissionGroup.Permission.View);

                List<DynamicEntity> entities;
                if(!string.IsNullOrWhiteSpace(listSampleId))
                {
                    var sampleModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE);
                    var sample = (await sampleModel.GetAsync(Filter.And.Equal(listSampleId, "Id"))).FirstOrDefault();
                    if (sample == null) return Json(new FailResponse("Cannot get list sample properties"));
                    var model = await MetadataToModelConverter.GetEntityModelByModelAsync("QNN_LIST_PROP", 0);
                    entities = await model.GetAsync(Filter.And.Equal(sample["ListId"], "ListId"),
                        Order.StartAsc("NumberId"), Paging.Empty);
                }

                else
                {
                    var model = await MetadataToModelConverter.GetEntityModelByModelAsync("QNN_LIST_PROP", 0);
                    entities = await model.GetAsync(Filter.And.Equal(listId, "ListId"), Order.StartAsc("NumberId"),
                        Paging.Empty);
                }


                if (!entities.Any())
                    return Json(new ItemSuccessResponse<string>($"{{\"model\":[], \"data\":{{}}, \"rule\":{{}}}}"));

                //var initJson = JsonConvert.DeserializeObject()
                var sbRules = new StringBuilder($"\"rule\":{{");
                var sbData = new StringBuilder($"\"data\":{{");
                var sbModel =
                    new StringBuilder(
                        $"{{\"model\":[{{\"key\": \"listPropContainer\",\"data-buildertype\": \"container\",\"children\": [{{\"key\": \"listPropMainContainer\",\"data-buildertype\": \"container\",\"children\": [");
                foreach (var entity in entities)
                {
                    var control = await GenControl(entity, listSampleId, false);
                    if (control == null) continue;
                    sbModel.Append(control);
                    var controlToken = JToken.Parse(control.TrimEnd(','));
                    var defaultValue = JsonConvert.ToString(controlToken["defaultValue"]?.ToString());
                    var key = controlToken["key"]?.ToString();

                    var reqd = controlToken["other-required"]?.ToString();
                    var readOnly = controlToken["other-readOnlyConition"]?.ToString();
                    var customValidation = controlToken["other-customValidation"]?.ToString();
                    var txtRegExp = "\"\"";
                    var txtRegExpErr = "\"\"";
                    if(!string.IsNullOrWhiteSpace(customValidation))
                    {
                        txtRegExp = JsonConvert.ToString(customValidation.Split("?true:")[0]);
                        txtRegExpErr =
                            JsonConvert.ToString(customValidation.Split("?true:")[1].Trim('\''));
                    }

                    //empty means false, "true" means true
                    sbRules.Append(
                        $"\"{key}\":{{  \"defaultValue\":{defaultValue}, \"reqd\":\"{reqd}\",  \"readOnly\":\"{readOnly}\", \"txtRegExp\":{txtRegExp}, \"txtRegExpErr\":{txtRegExpErr}}},");
                    sbData.Append($"\"{key}\":{defaultValue},");
                }

                sbRules.Length--;
                sbRules.Append($"}}");
                sbData.Length--;
                sbData.Append($"}},");
                sbModel.Length--;
                sbModel.Append($"]}}]}}],");

                sbModel.Append(sbData).Append(sbRules).Append($"}}");
                return Json(new ItemSuccessResponse<string>(sbModel.ToString()));
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GenListPropJson) + " - caught unexpected exception, listId={0}, listSampleId={1}", listId, listSampleId);
				return Json(new FailResponse("Cannot get list sample properties"));
            }
        }

        private static async Task<string> GenControl(DynamicEntity entity, string listSampleId, bool forResp)
        {
            var rows = Convert.ToInt32(entity["TxtRow"]);
            var alias = entity["Alias"].ToString();
            var reqd = Convert.ToBoolean(entity["ReqdYN"]);
            var usrEdit = Convert.ToBoolean(entity["UsrEditYN"]);
            var txtRegExp = entity["TxtRegExp"]?.ToString();
            var txtRegExpErr = JsonConvert.ToString(entity["TxtRegExpErr"]);
            var usrVisible = Convert.ToBoolean(entity["UsrVisibleYN"]);
            var respVisible = Convert.ToBoolean(entity["RespVisibleYN"]);
            var visible = forResp ? respVisible : usrVisible;
            var listPropId = Convert.ToString(entity["Id"]);
            var defaultValue = "\"\"";
            if (!IsNullOrEmpty(listSampleId))
            {
                var model = await MetadataToModelConverter.GetEntityModelByModelAsync(
                    Constants.ModelName.QNN_LIST_SAMPLE_PROP, 0);
                var sampleProp =
                (await model.GetAsync(
                    Filter.And.Equal(listSampleId, "ListSampleId").Equal(listPropId, "ListPropId"))).FirstOrDefault();
                if (sampleProp != null) defaultValue = JsonConvert.ToString(sampleProp["PropValue"].ToString());
            }

            if (!visible) return null;
            if (rows > 1)
                return
                    $"{{\"key\":\"{alias}\",\"style-customcss\": \"field\",\"data-buildertype\":\"textarea\",\"label\":\"{alias}{(reqd ? "**" : "")}\",\"fluid\":true,\"onChangeTimeout\":200,\"placeholder\":\"{alias}\",{(true ? "\"events\":{\"onChange\":{\"active\":true,\"actions\":[\"propertyOnChange\"],\"targets\":[],\"parameters\":[]}}," : "")}\"style-width\":\"100%\",{(reqd ? "\"other-required\":true," : "")}{(!IsNullOrEmpty(txtRegExp) ? "\"other-customValidation\":" + JsonConvert.ToString(txtRegExp).TrimEnd('"') + "?true:'" + txtRegExpErr.Trim('"') + "'\"," : "")}{(!usrEdit ? "\"other-readOnlyConition\":\"true\"," : "")}\"defaultValue\":{defaultValue}}},";

            return
                $"{{\"key\":\"{alias}\",\"style-customcss\": \"field\",\"data-buildertype\":\"input\",\"label\":\"{alias}{(reqd ? "**" : "")}\",{(!IsNullOrEmpty(txtRegExp) ? "\"title\":" + txtRegExpErr + "," : "")}\"fluid\":true,\"onChangeTimeout\":200,\"placeholder\":\"\",{(true ? "\"events\":{\"onChange\":{\"active\":true,\"actions\":[\"propertyOnChange\"],\"targets\":[],\"parameters\":[]}}," : "")}\"style-width\":\"100%\",{(reqd ? "\"other-required\":true," : "")}{(!IsNullOrEmpty(txtRegExp) ? "\"other-customValidation\":" + JsonConvert.ToString(txtRegExp).TrimEnd('"') + "?true:'" + txtRegExpErr.Trim('"') + "'\"," : "")}{(!usrEdit ? "\"other-readOnlyConition\":\"true\"," : "")}\"defaultValue\":{defaultValue}}},";
        }

        [HttpPost]
        [Route("list/savelistprop")]
        public async Task<ActionResult> SaveListSampleProp()
        {
            //TODO - the copypaste exception handling in this method could be tidied up a bit
            try
            {
                await ControllerUtilities.CheckPermission(Constants.PermissionGroup.List, Constants.PermissionGroup.Permission.Edit);

                string listId = HttpContext.Request.Form["listId"];
                if (IsNullOrEmpty(listId) || !Guid.TryParse(listId, out Guid _))
                    return Json(new FailResponse("List must be set"));

                string listSampleProp = HttpContext.Request.Form["listSampleProp"];

                var controls = JToken.Parse(listSampleProp);
                var sampleId = controls["dictionarySample"]?.ToString();
                if (IsNullOrEmpty(sampleId) || !Guid.TryParse(sampleId, out Guid _))
                    return Json(new FailResponse("List sample must be set"));

                //TODO - verify that user's has the access to this listId under struct division

                var samplePeerId = controls["dictionarySamplePeer"]?.ToString();
                if (!IsNullOrEmpty(samplePeerId) && !Guid.TryParse(samplePeerId, out Guid _))
                    return Json(new FailResponse("List sample peer invalid"));

                var listSampleModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE,
                        0);

                var id = controls["Id"]?.ToString();
                var active = Convert.ToBoolean(controls["ActiveYN"]);
                var dyObjectsList = new List<dynamic>();

                if (IsNullOrEmpty(id))
                {
                    bool trkListIsActive = await TrkListApplication.GetTrkListActiveYN();
                    if (trkListIsActive)
                    {
                        var listModel =
                            await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST,
                                0, true);
                        string trkListsString = ((await listModel.GetAsync(Filter.And.Equal(listId, Constants.FieldName.Id))).FirstOrDefault())?[Constants.FieldName.TrkListIds]?.ToString();
                        var trkListList = new List<string>();
                        if (!string.IsNullOrEmpty(trkListsString))
                        {
                            trkListList = JsonConvert.DeserializeObject<List<string>>(trkListsString);
                        }
                        var trkListSampleModel =
                            await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_TRK_LIST_SAMPLE,
                                0, true);

                        var sampleModel =
                            await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE,
                                0, true);

                        var uid = (await sampleModel.GetAsync(Filter.And.Equal(sampleId, "Id"))).FirstOrDefault()?["UID"];
                        var uidTrkListIdList = (await trkListSampleModel.GetAsync(Filter.And.Equal(uid, "UID"))).Select(e => e["TrkListId"].ToString()).ToList();
                        if (uidTrkListIdList.Intersect(trkListList).Any())
                        {
                            return Json(new FailResponse("Sample exists in track lists of the list."));
                        }
                    }

                    id = Guid.NewGuid().ToString();

                    //add new list sample
                    try
                    {
                        var listSample = await listSampleModel.NewAsync() as dynamic;
                        listSample.Id = new Guid(id);
                        listSample.SampleId = new Guid(sampleId);
                        listSample.ListId = new Guid(listId);
                        listSample.SamplePeerId =
                            IsNullOrEmpty(samplePeerId) ? (Guid?)null : new Guid(samplePeerId);
                        listSample.CreatedBy = CloverRuntime.Security.CurrentUser.Id;
                        listSample.CreatedDate = DateTime.Now;
                        listSample.ActiveYN = active;
                        dyObjectsList.Add(listSample);
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(SaveListSampleProp) + " - caught unexpected exception [A]");
						return Json(new FailResponse("Cannot create list sample. Record could have been existed"));
                    }
                }
                else
                {
                    try
                    {
                        var listSample =
                            (await listSampleModel.GetAsync(Filter.And.Equal(id, "Id")))
                            .FirstOrDefault() as dynamic;
                        if (listSample == null) return Json(new FailResponse("Invalid input"));

                        listSample.SampleId = new Guid(sampleId);
                        listSample.SamplePeerId =
                            IsNullOrEmpty(samplePeerId) ? (Guid?)null : new Guid(samplePeerId);
                        listSample.UpdatedBy = CloverRuntime.Security.CurrentUser.Id;
                        listSample.UpdatedDate = DateTime.Now;
                        listSample.ActiveYN = active;
                        dyObjectsList.Add(listSample);

                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(SaveListSampleProp) + " - caught unexpected exception [B]");
                        return Json(new FailResponse("Cannot create list sample. Record could have been existed"));
                    }
                }

                var dyObjectsList2 = new List<dynamic>();

                var model =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, 0);
                var listProps = await model.GetAsync(Filter.And.Equal(listId, "ListId"), Order.StartAsc("NumberId"),
                    Paging.Empty);
                var samplePropModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(
                        Constants.ModelName.QNN_LIST_SAMPLE_PROP, 0);


                foreach (var listProp in listProps)
                {
                    var propValue = controls[listProp["Alias"]]?.ToString();
                    if (propValue != null)
                    {
                        var dm = (await samplePropModel.GetAsync(Filter.And.Equal(id, "ListSampleId")
                                .Equal(listId, "ListId").Equal(listProp["Id"], "ListPropId")))
                            .FirstOrDefault() as dynamic;
                        if (dm == null)
                        {
                            dm = await samplePropModel.NewAsync();
                            dm.Id = Guid.NewGuid();
                            dm.ListId = new Guid(listId);
                            dm.ListPropId = new Guid(listProp["Id"].ToString());
                            dm.ListSampleId = new Guid(id);
                            dm.PropValue = propValue;
                        }
                        else
                        {
                            dm.PropValue = propValue;
                        }

                        dyObjectsList2.Add(dm);
                    }
                }



                using (var shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();

                    try
                    {
                        await listSampleModel.UpdateAsync(dyObjectsList);
                    }
                    catch (Exception e)
                    {
                        await shared.RollbackAsync().ConfigureAwait(false);
                        logger.LogError(e, nameof(SaveListSampleProp) + " - caught unexpected exception [C]");
                        return Json(new FailResponse("Cannot create list sample. Record could have been existed"));
                    }


                    try
                    {
                        await samplePropModel.UpdateAsync(dyObjectsList2);
                    }
                    catch (Exception e)
                    {
                        await shared.RollbackAsync().ConfigureAwait(false);
                        logger.LogError(e, nameof(SaveListSampleProp) + " - caught unexpected exception [D]");
                        return Json(new FailResponse("Cannot change list sample properties"));
                    }


                    shared.Commit();
                    return Json(new ItemSuccessResponse<string>(listId));
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SaveListSampleProp) + " - caught unexpected exception");
                return Json(new FailResponse("Cannot change list sample properties"));
            }
        }

        [HttpGet]
        [Route("/list/exportsample")]
        public async Task<ActionResult> ExportSample(string listId, string fileName)
        {
            try
            {
                if (!Guid.TryParse(listId, out Guid qnnListId))
                    return BadRequest("listId");
                if (string.IsNullOrEmpty(fileName)) 
                    return BadRequest("fileName");

                await ControllerUtilities.CheckPermission(Constants.PermissionGroup.List, Constants.PermissionGroup.Permission.View);
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                
                DynamicEntity qnnList = await SampleListApplication.GetQnnListAsync(qnnListId);
                if (qnnList == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_LIST, qnnListId);
                Guid listStructDivisionId = (Guid)qnnList[Constants.FieldName.StructDivisionId];
                bool isListInUsersStructDivisions 
                    = (await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser.StructDivisionId.Value))
                    .Contains(listStructDivisionId);
                if(!isListInUsersStructDivisions)
                {
                    throw new PermissionException(
                        $"List {qnnListId} with StructDivisionId={listStructDivisionId} is not in the organisation subtree of user {currentUser.Id} ({currentUser.Name}) with StructDivisionId={currentUser.StructDivisionId}");
                }

                List<Dictionary<string, object>> items = await spSP_GetListSampleProfile.GetForListExport(qnnListId);

                if (items.Any())
                {
                    var expandoObjects = items.Select(i => (dynamic) i.ToExpando());
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
                                writer.Flush(); //important to flush, or else streamTemp length can be anything


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
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
				logger.LogError(e, nameof(ExportSample) + " - caught an unexpected exception for listId={0}, fileName={1}", listId, fileName);
                return Json(new FailResponse("Something went wrong. Please approach system administrator for help."));
            }
        }

        [HttpPost]
        [Route("/list/importcsv")]
        public async Task<ActionResult> ImportSamplesFromCsv()
        {
            try
            {
                EntityModel qnnListModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST, Constants.Level.NoJoins);
                EntityModel qnnListPropModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, Constants.Level.NoJoins);

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                if (!currentUser.IsInRole(Constants.Role.SampleAdmin))
                    throw new PermissionException($"Lacks {Constants.Role.SampleAdmin}");

                //For new list we are passed: listName, token, password (optional)
                //For existing list we are passed: listId, token, password (optional)

                //Note that password is only applied to new samples being imported to the SurveyPlus instance.
                //or those where PASSWORD_RESET is TRUE in CSV. It won't change it for other samples in the list.

                IFormCollection form = Request.Form;
                string token = form["token"];
                if (string.IsNullOrEmpty(token))
                    return BadRequest("token");
                bool importToExistingList = Guid.TryParse(form["listId"], out var existingListId);
                string nameForNewList = StringValues.Empty.Equals(form["listName"]) ? null : form["listName"].ToString().Trim();
                if (!importToExistingList && string.IsNullOrWhiteSpace(nameForNewList))
                    return BadRequest("listName");
                string password = StringValues.Empty.Equals(form["password"]) ? null : (string)form["password"]; //optional
                
                if(!importToExistingList)
                {
                    Filter byProposedNameAndStructDivision
                        = Filter.And
                        .Equal(currentUser.StructDivisionId.Value, Constants.FieldName.StructDivisionId)
                        .Equal(nameForNewList, Constants.FieldName.Name);
                    if(await qnnListModel.GetCountAsync(byProposedNameAndStructDivision) > 0)
                    {
                        return Json(new FailResponse("NAME EXISTS")); //client side will check for this message
                    }
                }

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(ImportSamplesFromCsv) + " - called, user={0} ({1}), importToExistingList={2}, existingListId={3}, nameForNewList={4}, token={5}", currentUser?.Id, currentUser?.Name, importToExistingList, existingListId, nameForNewList, token);
                }

                IList<string> expectedProps;
                if (importToExistingList)
                {
                    if (nameForNewList != null)
                        return BadRequest("nameForNewList not allowed if list exists");

                    DynamicEntity qnnList = await SampleListApplication.GetQnnListAsync(existingListId, qnnListModel);
                    if (qnnList == null)
                        throw NotFoundException.ForModelName(qnnListModel.Name, existingListId);

                    //TODO - factor out org check below, duplicated in the service
                    Guid listStructDivisionId = (Guid)qnnList[Constants.FieldName.StructDivisionId];
                    HashSet<Guid> organisations
                        = await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser.StructDivisionId.Value);
                    if (!organisations.Contains(listStructDivisionId))
                        throw new PermissionException($"Lacks organisation access to structDivision {listStructDivisionId}");

                    expectedProps
                        = (await SampleListApplication.GetQnnListPropsByListIdAsync(existingListId, qnnListPropModel))
                        .Select(lp => (string)lp[Constants.FieldName.Alias])
                        .ToImmutableList();
                }
                else
                {
                    expectedProps = new List<string>(); //new list so we don't 'expect' any yet
                }

                await TaiSengCharitableAdoptionShelterForHomelessUtilityMethods
                    .AssertUploadedCsvAttributes(logger, token, currentUser); //throws InvalidUploadedFileException

                //Now scan the CSV for any parsing errors or bad columns etc
                SampleListApplication.SampleListReadResult result;
                (Stream Stream, Dictionary<string, string> Properties) file 
                    = await CloverRuntime.ContentProvider.GetAsync(token);
                using (Stream stream = file.Stream)
                {
                    result 
                        = await SampleListApplication.ReadSampleListCsv(
                            stream, 
                            expectedProps,
                            SampleListApplication.ReadSampleListCsvAction.ScanForErrors);
                    switch (result.Outcome)
                    {
                        //gee, enums get a bit long with nested classes don't they?
                        //btw, in Java if it is clear what the type is then you just need
                        //to put the value in the case. Maybe c# will support such syntax eventually too...

                        case SampleListApplication.SampleListReadResult.Validity.Valid:
                            break; //OK!

                        case SampleListApplication.SampleListReadResult.Validity.DuplicateColumns:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}There are duplicate columns: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.InvalidPropertyNames:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}There are invalid property columns: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.InvalidData:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}There is invalid data: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.SystemColumnMismatch:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}System columns mismatch: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.UnexpectedColumns:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}Found unexpected columns: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.MissingProperties:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}Missing expected property columns: {result.AdditionalInfo}", token);

                        case SampleListApplication.SampleListReadResult.Validity.EmptyFile:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}The file is empty.", token);

                        case SampleListApplication.SampleListReadResult.Validity.BadFile:
                            //Get this if its not even a csv file or if the header syntax is invalid, such as unclosed quotes
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}The file is not a valid CSV. Check the file type or the header row syntax.{result.AdditionalInfo}", token);

                        default:
                            throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}{result.Outcome}. {result.AdditionalInfo}", token);
                    }
                }

                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(ImportSamplesFromCsv) + " - CSV analysis successful, propFields={1}", result.PropFields);

                //Use a ticket to ensure file will be deleted later even if the job fails to do so
                DateTime ticketExpiry = DateTime.Now.AddHours(24);
                Guid ticketId = await FileTicketApplication.SaveFileTicket(
                    await new FileTicketBuilder(
                        token,
                        FileTicketPurpose.SampleListImport,
                        currentUser.StructDivisionId.Value)
                    .DeleteFileOnExpiry(true)
                    .Expires(ticketExpiry)
                    .RestrictToUser(currentUser.Id)
                    .AddRoleRestriction(Constants.Role.SampleAdmin)
                    .Build());

                Guid importToListId;
                if(!importToExistingList)
                {
                    //Sample list is created in advance, a nice side effect of which is you can monitor import progress from the UI
                    //so we'll keep it this way rather than creating it in the hangfire job (list entity creation is light, its the
                    //sample import that is heavy)
                    importToListId
                        = await SampleListApplication.CreateSampleList(
                            listName: nameForNewList,
                            propFields: result.PropFields,
                            createdBy: currentUser.Id,
                            structDivisionId: currentUser.StructDivisionId.Value,
                            qnnListModel,
                            qnnListPropModel);
                }
                else
                {
                    importToListId = existingListId;
                }

                await BusinessProcess.Enqueue.ImportSampleListCSV(
                    user: currentUser, 
                    listId: importToListId, 
                    ticketId: ticketId, 
                    password: password);

                return Json(new SuccessResponse("The system is processing the list in the background. You will be informed of the outcome via email when it is done."));
            }
            catch (PermissionException pex)
            {
                //nb: permission exceptions from dodgy token mean file isnt deleted (to prevent this being used to delete
                //    unrelated files for which caller happens to know token)
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (InvalidUploadedFileException slce)
            {
                logger.LogError(slce, nameof(ImportSamplesFromCsv) + " - CSV file failed checks, deleting file with token={0}", slce.Token);
                if(slce.Token != null)
                {
                    await CloverRuntime.ContentProvider.RemoveAsync(slce.Token);
                }
                string clientReportable 
                    = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(
                        slce.Message, 
                        "Please check it is correct.");
                return Json(new FailResponse($"There was a problem with the CSV file. {clientReportable}"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ImportSamplesFromCsv) + " - An unexpected exception was caught");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [HttpPost]
        [Authorize]
        [Route("list/deletelistsample")]
        public async Task<ActionResult> DeleteListSample()
        {
            //TODO - tidy up exception handling, use of constants

            string listId = HttpContext.Request.Form["listId"];
            string listSampleIds = HttpContext.Request.Form["listSampleIds"];
            var listSampleIdArray = listSampleIds.Split(",");

            if (!CloverRuntime.Security.CurrentUser.IsInRole("SurveyAdmin"))
                return Json(new FailResponse("You don't have the permission"));
            try
            {
                var listSampleModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, 0);
                var respModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, 0);
                var listSamplePropModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(
                        Constants.ModelName.QNN_LIST_SAMPLE_PROP, 0);


                using (var shared = new SharedTransaction())
                {
                    try
                    {
                        shared.BeginTransactionAsync().Wait();

                        foreach (var listSampleId in listSampleIdArray)
                        {
                            if (!Guid.TryParse(listSampleId, out Guid _)) return Json(new FailResponse("Invalid Input"));


                            var ids = (await listSamplePropModel.GetAsync(Filter.And.Equal(listSampleId,
                                    Constants.FieldName.ListSampleId)))
                                .Select(lsp => lsp.GetId());
                            await listSamplePropModel.DeleteAsync(ids);

                            ids = (await respModel.GetAsync(
                                    Filter.And.Equal(listSampleId, Constants.FieldName.ListSampleId)))
                                .Select(r => r.GetId());
                            await respModel.DeleteAsync(ids);
                        }

                        await listSampleModel.DeleteAsync(listSampleIdArray);
                        shared.Commit();
                        return Json(new SuccessResponse("Selected List Samples have been deleted successfully"));
                    }
                    catch (Exception e)
                    {
                        await shared.RollbackAsync();
                        logger.LogError(e, nameof(DeleteListSample) + " -  caught unexpected exception [A]");
						return Json("Exception Thrown. Check with system administrator");
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DeleteListSample) + " -  caught unexpected exception");
                return Json("Exception Thrown. Check with system administrator");
            }


        } //end of DeleteListSample

        private const string route_disableListSamples = "list/disablelistsamples";
        private const string route_enableListSamples = "list/enablelistsamples";

        [HttpPost]
        [Authorize]
        [Route(route_disableListSamples, Name=route_disableListSamples)]
        [Route(route_enableListSamples, Name=route_enableListSamples)]
        public async Task<ActionResult> ToggleListSamplesActiveYN()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                await ControllerUtilities.CheckPermission(Constants.PermissionGroup.List, Constants.PermissionGroup.Permission.Edit);

                string listSampleIdsParam = HttpContext.Request.Form["listSampleIds"];
                string[] listSampleIdStrings = listSampleIdsParam.Split(",");

                if (listSampleIdStrings.Length==0) 
                    return Json(new FailResponse("No samples selected"));

                EntityModel qnnListModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST, Constants.Level.NoJoins);

                Guid listId = Guid.Parse(HttpContext.Request.Form["listId"].ToString()); //FormatException if invalid
                Filter byListId = Filter.And.Equal(listId, Constants.FieldName.Id);
                DynamicEntity qnnList = (await qnnListModel.GetAsync(byListId)).FirstOrDefault();
                if(qnnList==null) throw new ArgumentNullException("List not found");
                Guid listStructDivisionId = (Guid)qnnList[Constants.FieldName.StructDivisionId];
                if (false==await currentUser.IsInStructDivisionAsync(listStructDivisionId))
                {
                    throw new PermissionException($"User {currentUser.Id} ({currentUser.Name} is in structDivision {currentUser.StructDivisionId} and does not have organisational subtree access to list {listId} in structDivision {listStructDivisionId}");
                }
                string invokingRoute = ControllerContext.ActionDescriptor.AttributeRouteInfo.Name;
                bool activeYN =
                      route_enableListSamples.Equals(invokingRoute) ? true
                    : route_disableListSamples.Equals(invokingRoute) ? false
                    : throw new ArgumentException("Unexpected route: " + invokingRoute);

                //Convert string ids to guid, will throw a FormatException on bad ones thus validating our input. This is important
                //to ensure we are looking for the ids the user thinks they are looking for. (e.g. with high selection counts the ui
                //currently sometimes passes blank strings. I we passed that directly to GetAsync as a string it wouldn't notice 
                //the fact that it was passing garbage and give the impression of working while actually only processing a subset)
                List<Guid> listSampleIds = new List<Guid>(listSampleIdStrings.Length);
                for (int i = 0; i < listSampleIdStrings.Length; i++)
                {
                    string listSampleIdStr = listSampleIdStrings[i];
                    if (!Guid.TryParse(listSampleIdStr, out Guid listSampleId))
                    {
                        throw new FormatException($"Invalid value for GUID, listSampleIdStrings[{i}]=\"{listSampleIdStr}\")");
                    }
                    listSampleIds.Add(listSampleId);
                }

                using (SharedTransaction shared = new SharedTransaction())
                {
                    try
                    {
                        shared.BeginTransactionAsync().Wait();

                        long updatedCount = await SampleListApplication.SetListSamplesActiveYN(listId, listSampleIds, activeYN);
                        
                        shared.Commit();
                        string action = activeYN ? "enabled" : "disabled";
                        string outcome = (updatedCount == 1)
                            ? $"1 sample was {action}"
                            : $"{updatedCount} samples were {action}";
                        return Json(new SuccessResponse(outcome));
                    }
                    catch (Exception)
                    {
                        await shared.RollbackAsync();
                        throw;
                    }
                }
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ToggleListSamplesActiveYN) + " - caught an unexpected exception");
				return Json(Constants.Message.InternalErrorException);
            }
        } //end of ToggleListSamplesActiveYN

		[Authorize]
		[HttpPost]
		[Route("list/duplicate")]
		public async Task<ActionResult> DuplicateSampleList(string sampleListId, string title)
		{
			try
			{
                if (!Guid.TryParse(sampleListId, out Guid listId))
                    return BadRequest(nameof(sampleListId));

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SampleAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SampleAdmin}");
                
				(string msg, bool isSucessful) = await SampleListApplication.DuplicateSampleList(listId, title, currentUser);
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
                logger.LogError(e, "Failed to duplicate sample list, sampleListId={0}, title={1}", sampleListId, title);
				return Json(new FailResponse(Constants.Message.InternalErrorException));
			}
		}

    }
}