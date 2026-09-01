using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.Clover.Core.Metadata.DbObjects;
using System.Linq;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.SurveyPlus.Application;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Metadata;
using swz.SurveyPlus.IntranetApplication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Endpoints for SurveyDesigner SPA and the SurveyPlus user management Security SPA
    /// </summary>
	[Authorize]
    public class ConfigAPIUserAdminController : Controller
    {
        private readonly SurveyPlusOptions surveyPlusOptions;
        private readonly ILogger<ConfigAPIUserAdminController> logger;
        private readonly MetadataCaches metadataCaches;

        public ConfigAPIUserAdminController(
            ILogger<ConfigAPIUserAdminController> logger,
            SurveyPlusOptions surveyPlusOptions,
            MetadataCaches metadataCaches)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
            this.metadataCaches = metadataCaches ?? throw new ArgumentNullException(nameof(metadataCaches));
        }

        [Route("SurveyDesigner")]
        public ActionResult SurveyAdmin()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(new List<string>() { Constants.Role.SurveyDesigner }))
                    throw new PermissionException();
                ViewData["SurveyPlusOptions"] = surveyPlusOptions;
                return View("SurveyAdmin");
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SurveyAdmin) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route("UserAdmin")]
        public ActionResult SecurityAdmin()
        {
            try
            {
                if (!CloverRuntime.Security.HasAnyRole(new List<string>() { Constants.Role.UserAdmin }))
                    throw new PermissionException();
                ViewData["SurveyPlusOptions"] = surveyPlusOptions;
                return View("UserAdmin");
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SecurityAdmin) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Route("ConfigAPIUserAdmin")]
        public async Task<ActionResult> API()
        {
            try
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();

                bool isUserAdmin = currentUser.IsInRole(Constants.Role.UserAdmin);
                bool isSurveyDesigner = currentUser.IsInRole(Constants.Role.SurveyDesigner);
                if (!isSurveyDesigner && !isUserAdmin) 
                    throw new PermissionException($"This endpoint requires {Constants.Role.UserAdmin} or {Constants.Role.SurveyDesigner} role");

                var pars = new NameValueCollection();
                foreach (var item in Request.Query) pars.Add(item.Key, item.Value);

                if (Request.HasFormContentType)
                    foreach (var item in Request.Form)
                        pars.Add(item.Key, item.Value);

                pars.Add("structDivisionId", currentUser.StructDivisionId?.ToString());

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(API) + " - {0} - called by {1} ({2}), with pars={3}, operation={4}, contentLength={5}", Request.Method, currentUser?.Id, currentUser?.Name, string.Join(',',pars.AllKeys), pars["operation"], Request.ContentLength);
                }

                Stream filestream = null;
                var isPost = Request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase);
                if (isPost && Request.HasFormContentType && Request.Form.Files.Count > 0)
                    filestream = Request.Form.Files[0].OpenReadStream();

                MetadataIdentifier metadataIdentifier = new MetadataIdentifier(pars);

                if (isPost)
                {
                    if (metadataIdentifier.isDuplicateForm())
                    {
                        if (!isSurveyDesigner)
                            throw new PermissionException($"User lacks {Constants.Role.SurveyDesigner} role");
                        return await DuplicateForm(pars);
                    }
                    else if (metadataIdentifier.isDeletingSurvey())
                    {
                        List<string> formNameList = metadataIdentifier.getDeletingFormNameList();
                        if(formNameList != null && formNameList.Any())
                        {
                            HashSet<string> formIsUsed = await FormPropertiesApplication.IsFormInUse(formNameList);
                            if (formIsUsed != null && formIsUsed.Any()) return Json(new FailResponse($"The following form cannot be deleted as it is in use: {string.Join(", ", formIsUsed)}"));
                        }
                    }
                }

                //20230113 ------------
                string operation = pars["operation"];
                switch (operation)
                {
                    case MetadataOperations.Load:
                        break;

                    case MetadataOperations.Users:
                        if (!isUserAdmin) 
                            throw new PermissionException($"User lacks {Constants.Role.UserAdmin} role");
                        break;

                    case MetadataOperations.LoadForm:
                    case MetadataOperations.LoadForms: //adding from template needs loadforms 
                        if (!isSurveyDesigner) 
                            throw new PermissionException($"User lacks {Constants.Role.SurveyDesigner} role");
                        break;

                    case MetadataOperations.Change:
                        string changesJson = pars["items"];
                        JArray changes = JArray.Parse(changesJson);
                        foreach (JToken item in changes)
                        {
                            string type = item["__type"].ToObject<string>();
                            switch (type)
                            {
                                case MetadataSections.Users:
                                    if (!isUserAdmin) 
                                        throw new PermissionException($"User lacks {Constants.Role.UserAdmin} role");
                                    break;

                                case MetadataSections.Form:
                                    if (!isSurveyDesigner) 
                                        throw new PermissionException($"User lacks {Constants.Role.SurveyDesigner} role");

                                    Form form = item.ToObject<Form>();
                                    if (!form.IsSurvey) 
                                        throw new PermissionException($"Submitted item {form.Name} is not a survey form");

                                    string stateString = item["__state"].ToObject<string>();
                                    if (!Enum.TryParse(stateString, ignoreCase: true, out MetadataObjectState state))
                                        throw new InvalidOperationException($"Unknown __state {stateString}");
                                    switch (state)
                                    {
                                        case MetadataObjectState.Inserted:
                                            break;

                                        case MetadataObjectState.Updated:
                                        case MetadataObjectState.Deleted:
                                            string filename = form.Name + "-settings.json";
                                            Filter filter = Filter.And.Equal(filename, Constants.FieldName.Filename).Equal("metadata/forms", "Folder");
                                            Clover.Core.Metadata.DbObjects.Metadata metadataItem 
                                                = (await swz.Clover.Core.Metadata.DbObjects.Metadata.SelectAsync(filter)).FirstOrDefault();
                                            if(metadataItem != null)
                                            {
                                                Form dbForm = JsonConvert.DeserializeObject<Form>(metadataItem.Data);
                                                if (!dbForm.IsSurvey) 
                                                    throw new PermissionException($"Existing form {form.Name} is not a survey form");
                                            }
                                            else
                                            {
                                                throw new InvalidOperationException($"did not find existing metadata for {filename}, state={state}");
                                            }
                                            break;

                                        default:
                                            throw new PermissionException($"Invalid state {state}");

                                    }
                                    break;

                                case MetadataSections.FilesUpload:
                                case MetadataSections.CssCode:
                                    if (!isSurveyDesigner) 
                                        throw new PermissionException($"User lacks {Constants.Role.SurveyDesigner} role");
                                    break;
                                

                                default:
                                    throw new PermissionException($"Invalid type {type}");
                            }
                        }
                        break;

                    default:
                        throw new PermissionException($"Invalid operation {operation}");
                }
                //---------------------

                object res = await CloverRuntime.Metadata.ConfigAPI(pars, filestream);

                //20230113 ------------
                if(res == null)
                {
                    throw new InvalidOperationException($"ConfigAPI returned null");
                }
                else if (res is ItemSuccessResponse<swz.Clover.Core.Metadata.Metadata> coll)
                {
                    coll.Item.Users = null;
                    coll.Item.AppSettings = new List<AppSettings>();
                    coll.Item.CodeActions = new List<CodeAction>(); ;
                    coll.Item.LicenseInfo = null;
                    coll.Item.Workflow = new List<WorkflowScheme>();
                    coll.Item.BusinessFlow = new List<BusinessFlow>();
                    coll.Item.DataModel = new List<Clover.Core.Metadata.DataModel>();

                    if (!isSurveyDesigner)
                    {
                        coll.Item.FileUploads = new List<UploadedFilesPoor>();
                    }
                }
                else if (res is ItemSuccessResponse<object> response)
                {
                    if ((response.Item.GetType().GetProperty("users") != null) && (response.Item.GetType().GetProperty("count") != null))
                    {
                        if (!isUserAdmin)
                        {
                            throw new PermissionException($"Unpermitted response type {response.GetType().FullName} (with users,count) for user lacking {Constants.Role.UserAdmin} role");
                        }
                    }
                    else if(response.Item.GetType().Equals(typeof(List<swz.Clover.Core.Metadata.Form>)))
                    {
                        if (!isSurveyDesigner)
                        {
                            throw new PermissionException($"Unpermitted response type {response.GetType().FullName} with item of type {response.Item.GetType().FullName} for user lacking {Constants.Role.SurveyDesigner} role");
                        }
                    }
                    else
                    {
                        throw new PermissionException($"Unpermitted response type {response.GetType().FullName} with item of type {response.Item.GetType().FullName}");
                    }
                }
                else if (res is ItemSuccessResponse<User> userResponse)
                {
                    if (!isUserAdmin)
                    {
                        throw new PermissionException($"Unpermitted response type {userResponse.GetType().FullName} for user lacking {Constants.Role.UserAdmin} role");
                    }
                }
                else if (res is ItemSuccessResponse<Form> formResponse)
                {
                    if (!isSurveyDesigner) 
                        throw new PermissionException($"User lacks {Constants.Role.SurveyDesigner} role");
                    if (!formResponse.Item.IsSurvey) 
                        throw new PermissionException($"Form {formResponse.Item.Name} in response is not s survey form");
                }
                else if (res is SuccessResponse || res is FailResponse)
                {
                    ;
                }
                else
                {
                    throw new PermissionException($"Unpermitted response type {res.GetType().FullName}");
                }
                //---------------------

                ActionResult result = await CheckSecuritySelfEdit(pars,res);
                return result;
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, nameof(API) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Called from API() to perform the duplicate-form operation
        /// (API is responsible for checking permissions)
        /// </summary>
        /// <param name="pars"></param>
        /// <returns></returns>
        private async Task<ActionResult> DuplicateForm(NameValueCollection pars)
        {
            try
            {
                string sourceForm = pars["sourceForm"].Trim();
                string destForm = pars["destForm"].Trim();

                //check the supplied destination form name is valid
                if(string.IsNullOrWhiteSpace(destForm))
                {
                    return Json(new FailResponse("Name of copy not specified"));
                }
                Regex reg = new Regex("[^A-Za-z0-9_-]", RegexOptions.None, TimeSpan.FromSeconds(1));//only accept alphabet/digit/underscores/hyphen
                if (reg.IsMatch(destForm))
                {
                    return Json(new FailResponse("Invalid name for copy of form"));
                }

                //TODO - review why does the below use Task.Run ?
                Clover.Core.Metadata.Form surveyform = await Task.Run(() => { return CloverRuntime.Metadata.GetFormsSettings(destForm); });
                if(surveyform != null)
                {
                    return Json(new FailResponse("Form name already been used."));
                }

                EntityModel dwMetadataModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwMetadata, Constants.Level.NoJoins);

                using (var shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();

                    string sourceFormDesign = sourceForm + ".json";
                    string sourceFormSettings = sourceForm + "-settings.json";
                    string destFormDesign = destForm + ".json";
                    string destFormSettings = destForm + "-settings.json";

                    //Check there isn't already a form under this name (even if IsDeleted or in another StructDivisionId)
                    List<string> filesToCheck = new List<string> { destFormDesign, destFormSettings };
                    Filter filter = Filter.And.Equal(Constants.MetadataFormsFolder, Constants.FieldName.Folder)
                        .Merge(Filter.And.In(filesToCheck, Constants.FieldName.Filename));
                    List<DynamicEntity> existingEntities = await dwMetadataModel.GetAsync(filter);
                    if(existingEntities.Count > 0)
                    {
                        return Json(new FailResponse("Name already in use"));
                    }

                    //Get related metadata for the source form
                    List<string> filesToCopy = new List<string> { sourceFormDesign, sourceFormSettings };
                    filter = 
                        Filter.And
                        .Equal(Constants.MetadataFormsFolder, Constants.FieldName.Folder)
                        .Merge(Filter.And.In(filesToCopy, Constants.FieldName.Filename));

                    List<DynamicEntity> dwMetadataEntities = await dwMetadataModel.GetAsync(filter);
                    if(dwMetadataEntities.Count==0)
                    {
                        return Json(new FailResponse("Source form not found"));
                    }

                    Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                    Guid currentUserId = currentUser.Id;

                    //Set of StructDivision this user can see, we will verify the forms we copy have one of these
                    HashSet<Guid> usersStructDivisionIds = await StructDivision.SelectChildrenAndThisIdSetAsync(currentUser);

                    //Create a copy of all the metadata files for this form under the new name
                    DateTime now = DateTime.Now;
                    foreach (DynamicEntity dwMetadataEntity in dwMetadataEntities)
                    {
                        string filename = (string)dwMetadataEntity[Constants.FieldName.Filename];
                        Guid? formStructDivisionId = (Guid?)dwMetadataEntity[Constants.FieldName.StructDivisionId];
                        if(formStructDivisionId != null && !usersStructDivisionIds.Contains((Guid)formStructDivisionId))
                        {
                            //They shouldn't be seeing this form
                            //Might occur if they logged-in in another tab/window as a different StructDivision (likely during development - can do this to test it too) 
                            //Or also if they know the name of another division's form and are trying to exfiltrate!
                            //ApplicationException?
                            throw new PermissionException("Form " + filename + " cannot be duplicated because it is not under StructDivision of current user");
                        }

                        string copyAsFilename = ((string)dwMetadataEntity[Constants.FieldName.Filename]).Replace(sourceForm, destForm);
                        string data = (string)dwMetadataEntity[Constants.FieldName.Data];

                        //Clear the template flag so that when a template form is copied, the template is not a copy.
                        //This lets users spawn entire new survey forms directly from a template form.
                        //(If they want to copy it as a new template then they must set back the template flag manually in UI)
                        if (destFormSettings.Equals(copyAsFilename))
                        {
                            dynamic settings = JsonConvert.DeserializeObject(data);
                            bool isTemplate = settings.ContainsKey("isTemplate") && (bool)settings.isTemplate;
                            if (isTemplate)
                            {
                                settings.isTemplate = false;
                            }
                            data = JsonConvert.SerializeObject(settings, Formatting.Indented);
                        }

                        DynamicEntity dest = await dwMetadataModel.NewAsync();
                        dest[Constants.FieldName.Folder] = dwMetadataEntity[Constants.FieldName.Folder];
                        dest[Constants.FieldName.Filename] = copyAsFilename;
                        dest[Constants.FieldName.CreatedBy] = currentUserId;
                        dest[Constants.FieldName.CreatedDate] = now;
                        dest[Constants.FieldName.UpdatedBy] = currentUserId;
                        dest[Constants.FieldName.UpdatedDate] = now;
                        dest[Constants.FieldName.Data] = data;
                        dest[Constants.FieldName.StructDivisionId] = formStructDivisionId;
                        await dwMetadataModel.UpdateSingleAsync(dest);
                    }
                    shared.Commit();
                }
                metadataCaches.Flush();
                return Json(new SuccessResponse(destForm));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DuplicateForm) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// To check if user is self-deleting or self-updating.
        /// Pass bool to frontend to redirect to account/logoff if self editing.
        /// </summary>
        /// <param name="pars"></param>
        /// <returns></returns>
        private async Task<ActionResult> CheckSecuritySelfEdit(NameValueCollection pars, Object res)
        {
            if (!String.IsNullOrWhiteSpace(pars["operation"]) && pars["operation"].ToLower() == MetadataOperations.Change)
            {
                JArray changes = JArray.Parse(pars["items"]);
                for (var i = 0; i < changes.Count; i++)
                {
                    var item = changes[i];
                    MetadataObjectState state = MetadataObjectState.Unchanged;
                    Enum.TryParse(item["__state"].ToObject<string>(), true, out state);
                    if (item["__type"].ToObject<string>() == MetadataSections.Users)
                    {
                        User user = item.ToObject<User>();
                        bool isSelfEdit = ((state == MetadataObjectState.Updated || state == MetadataObjectState.Deleted) && user.Id == CloverRuntime.Security.CurrentUser?.Id);
                        if (isSelfEdit)
                        {
                            user.Login = await SecurityCredential.GetLoginByUserId(user.Id);
                            CloverRuntime.Security.ResetUserCache(user.Login);
                            return Json(new ItemSuccessResponse<bool>(true));
                        }
                    }
                }
            }
            return Json(res);
        }
    }
}