using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using swz.Clover.Core.CodeActions;
using swz.Clover.Core.License;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;
using swz.Clover.Core.View;
using swz.Workflow.Core.Runtime;
using swz.Workflow.Core.Persistence;

namespace swz.Clover.Core.Metadata
{

    /// <summary>
    /// SurveyPlus implementation of the Clover IMetadataProvider
    /// </summary>
    public class MSSQLMetadataProvider : IMetadataProvider
    {
        //kiv: if using endswith to determine type of metadata, do remember that endswith .json will be true for xxxx-settings.json too
        //     and this implies that localizations will get confused with forms, unless you check for a -settings.json of that name.
        //     It will also get confused with metadata.json, and maybe other types of metadata (if any).
        private const string formPostfix = ".json";
        private const string formSettingsPostfix = "-settings.json";
        private const string formCodePostfix = "-code.js";
        private const string formCssCodePostfix = ".css";
        private const string localizationPostfix = ".json";
        private const string baselocalization = "base";

        private readonly string metadataFolderName;
        private readonly string metadataFileName;
        private readonly string metadataFormsFolderName;
        private readonly string metadataLocalizationFolderName;
        private readonly ILogger<MSSQLMetadataProvider> logger;
        private readonly MetadataCaches metadataCaches;

        private static readonly List<String> ProtectedRoles = new List<string> { Constants.Role.AuditAdmin, Constants.Role.HelpEditor };

        public MSSQLMetadataProvider(
            ILogger<MSSQLMetadataProvider> logger,
            MetadataCaches metadataCaches,
            bool blockMetadataChanges,
            string metadataFolder = "metadata", 
            string path = "metadata.json", 
            string formFolder = "metadata/forms", 
            string localizationFolder = "metadata/localization")
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.metadataCaches = metadataCaches ?? throw new ArgumentNullException(nameof(metadataCaches));
            BlockMetadataChanges = blockMetadataChanges;
            metadataFileName = path;
            metadataFolderName = metadataFolder;
            metadataFormsFolderName = formFolder;
            metadataLocalizationFolderName = localizationFolder;
            BlockMetadataChanges = false;
        }

        //Moved here from MetadataToModelConverter
        public string GetBusinessObjects()
        {
            if (!metadataCaches.TryGetBusinessObjects(out string businessObjects))
            {
                businessObjects = GetFormsBusinessCode(name: null);
                metadataCaches.SetBusinessObjects(businessObjects);
            }
            return businessObjects;            
        }

        public async Task<object> ConfigAPI(NameValueCollection form, Stream filestream = null)
        {
            if (string.IsNullOrWhiteSpace(form["operation"]))
            {
                return new FailResponse("The request hasn't the required parameter 'operation'!");
            }
            var operation = form["operation"].ToLower();
            var items = form["items"];

            switch (operation)
            {
                case MetadataOperations.Load:
                    return new ItemSuccessResponse<Metadata>(await FullMetadata());
                case MetadataOperations.LoadForm:
                    return await LoadForm(form);
                case MetadataOperations.LoadForms:
                    return await LoadForms(form);
                case MetadataOperations.LoadLocalization:
                    return await LoadLocalization(form);
                case MetadataOperations.LocalizationUpdateTemplate:
                    return await LocalizationUpdateTemplate(form);
                case MetadataOperations.Compile:
                    var item = JToken.Parse(form["item"]);
                    var ca = item.ToObject<CodeAction>();
                    try
                    {
                        var res = CodeActionsCompiler.GetCodeActionsInvoker(new List<CodeAction>() { ca }, out _, false, Guid.NewGuid().ToString());
                        return new SuccessResponse("Compilation succeed");
                    }
                    catch (Exception e)
                    {
                        if(logger != null && logger.IsEnabled(LogLevel.Error))
                        {
                            logger.LogError(e, nameof(ConfigAPI) + " - caught unexpected exception");
                        }
                        
                        return new FailResponse("An error occured");
                    }
                case MetadataOperations.Change:
                    if (BlockMetadataChanges)
                        throw new Exception("ConfigAPI: Changes are locked!");
                    await UpdateCollectionAsync(items);
                    break;
                case MetadataOperations.ResetAppCache:
                    CloverRuntime.ResetAppCache();
                    return new SuccessResponse();
                case MetadataOperations.UploadLicense:
                    if (BlockMetadataChanges)
                        throw new Exception("ConfigAPI: Changes are locked!");

                    //Fixed for SVP-07 for MPA SCR 2022-04-29
                    using (StreamReader reader = new StreamReader(filestream))
                    {
                        string licensetext = reader.ReadToEnd();
                        CloverRuntime.UploadLicense(licensetext);
                    }
                    return new SuccessResponse();
                case MetadataOperations.AnalyseDb:
                    return new ListSuccessResponse<SyncMetadata>(await AnalyseDb());
                case MetadataOperations.Workflow:
                    return await WorkflowProcessing(form);
                case MetadataOperations.Users:
                    return await UsersProcessing(form);
                default:
                    return new FailResponse($"Unknown operation - {operation}");
            }

            return new SuccessResponse();
        }

        private async Task<object> WorkflowProcessing(NameValueCollection form)
        {
            if (string.IsNullOrWhiteSpace(form["suboperation"]))
            {
                return new FailResponse("The request hasn't the required parameter 'suboperation'!");
            }

            var suboperation = form["suboperation"];
            var wfruntime = CloverRuntime.GetCreatedWorkflowRuntime();
            if (wfruntime == null &&
                suboperation != MetadataWorkflowOperations.Load &&
                suboperation != MetadataWorkflowOperations.LoadList)
            {
                throw new Exception("WorkflowRuntime must be initialized before call ConfigAPI!");
            }

            switch (suboperation)
            {
                case MetadataWorkflowOperations.Load:
                    if (!Guid.TryParse(form["instanceId"], out Guid instanceId))
                    {
                        throw new Exception("Set correct value in 'instanceId' parameter!");
                    }
                    return new ItemSuccessResponse<WorkflowInstance>(await WorkflowInstance.LoadById(instanceId));
                case MetadataWorkflowOperations.LoadList:

                    if (!int.TryParse(form["skip"], out int skip))
                    {
                        throw new Exception("Set 'skip' parameter!");
                    }

                    if (!int.TryParse(form["take"], out int take))
                    {
                        throw new Exception("Set 'take' parameter!");
                    }

                    return new ItemSuccessResponse<object>(await WorkflowInstance.LoadInstances(
                        skip, take,
                        form["id"], form["scheme"], form["status"], form["activity"], form["state"],
                        form["sort"]));
                case MetadataWorkflowOperations.Create:
                    {
                        if (string.IsNullOrEmpty(form["scheme"]))
                        {
                            throw new Exception("Set 'scheme' parameter!");
                        }

                        if (!Guid.TryParse(form["processId"], out Guid processId))
                        {
                            throw new Exception("Set guid-value to 'processId' parameter!");
                        }

                        await wfruntime.CreateInstanceAsync(new CreateInstanceParams(form["scheme"], processId));
                        return new SuccessResponse($"The instance '{processId}' has created!");
                    }
                case MetadataWorkflowOperations.Delete:
                    {
                        if (string.IsNullOrEmpty(form["processIds"]))
                        {
                            throw new Exception("Set 'processIds' parameter!");
                        }

                        var processIds = JsonConvert.DeserializeObject<List<Guid>>(form["processIds"]);

                        foreach (var processId in processIds)
                            await wfruntime.DeleteInstanceAsync(processId);
                        return new SuccessResponse("Instances have deleted!");
                    }
                case MetadataWorkflowOperations.SetState:
                    {
                        if (!Guid.TryParse(form["processId"], out Guid processId))
                        {
                            throw new Exception("Set guid-value to 'processId' parameter!");
                        }

                        if (string.IsNullOrEmpty(form["state"]))
                        {
                            throw new Exception("Set 'state' parameter!");
                        }

                        await wfruntime.SetStateAsync(processId, "", "", form["state"]);
                        return new SuccessResponse($"The process '{processId}' state = '{form["state"]}'!");
                    }
                case MetadataWorkflowOperations.SetInstanceStatus:
                    {
                        if (!Guid.TryParse(form["processId"], out Guid processId))
                        {
                            throw new Exception("Set guid-value to 'processId' parameter!");
                        }

                        var status = form["status"];
                        var pi = await wfruntime.GetProcessInstanceAndFillProcessParametersAsync(processId);
                        if (status == ProcessStatus.Initialized.Id.ToString())
                        {
                            wfruntime.PersistenceProvider.SetWorkflowIniialized(pi);
                        }
                        else if (status == ProcessStatus.Running.Id.ToString())
                        {
                            wfruntime.PersistenceProvider.SetWorkflowRunning(pi);
                        }
                        else if (status == ProcessStatus.Idled.Id.ToString())
                        {
                            wfruntime.PersistenceProvider.SetWorkflowIdled(pi);
                        }
                        else if (status == ProcessStatus.Finalized.Id.ToString())
                        {
                            wfruntime.PersistenceProvider.SetWorkflowFinalized(pi);
                        }
                        else
                        {
                            throw new Exception($"Status '{status}' is not support for setting!");
                        }

                        return new SuccessResponse($"The process '{processId}' status = '{status}'!");
                    }
                case MetadataWorkflowOperations.GetStates:
                    {
                        var scheme = form["scheme"];
                        if (string.IsNullOrEmpty(scheme))
                        {
                            throw new Exception("Set 'scheme' parameter!");
                        }

                        var schemeDef = wfruntime.Builder.GetProcessScheme(scheme);
                        if (schemeDef == null)
                        {
                            throw new Exception($"The scheme '{scheme}' is not found!");
                        }

                        var states = schemeDef.Activities.Select(c => c.State).Where(c => !string.IsNullOrWhiteSpace(c)).Distinct().ToArray();
                        return new ItemSuccessResponse<string[]>(states);
                    }

                default:
                    return new FailResponse($"Unknown suboperation - {suboperation}");
            }

        }

        private async Task<object> UsersProcessing(NameValueCollection form)
        {
            if (string.IsNullOrWhiteSpace(form["suboperation"]))
            {
                return new FailResponse("The request hasn't the required parameter 'suboperation'!");
            }

            var suboperation = form["suboperation"];
            switch (suboperation)
            {
                case MetadataWorkflowOperations.Load:
                    if (!Guid.TryParse(form["id"], out Guid userId))
                    {
                        throw new Exception("Set correct value in 'id' parameter!");
                    }
                    var user = await SecurityUser.SelectByKey(userId);
                    var parentIds =
                        (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(user.StructDivisionId,
                            "Id"))).Where(p=>p.ParentId!=null).Select(p=>p.ParentId).ToList();
                    var structDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;
                    if(structDivisionId!=null && (!parentIds.Any() || !parentIds.Contains(structDivisionId)))
                        throw new Exception("No permission!");
                    SecurityCredential[] credentials = await SecurityUser.GetCredentialByUserId(userId);
                    return new ItemSuccessResponse<User>(User.Create(user, credentials.ToList(),
                                            await SecurityGroupToSecurityUser.SelectByUser(userId),
                                            await SecurityUserToSecurityRole.SelectByUser(userId)));

                case MetadataWorkflowOperations.LoadList:
                    if (!int.TryParse(form["skip"], out int skip))
                    {
                        throw new Exception("Set 'skip' parameter!");
                    }

                    if (!int.TryParse(form["take"], out int take))
                    {
                        throw new Exception("Set 'take' parameter!");
                    }

                    return new ItemSuccessResponse<object>(await User.LoadList(skip, take, form["filter"], form["sort"], form["structDivisionId"]));
                default:
                    return new FailResponse($"Unknown suboperation - {suboperation}");
            }

        }


        private async Task<List<SyncMetadata>> AnalyseDb()
        {
            var tables = await CloverRuntime.DbProvider.GetModelFromDatabase(
                CloverRuntime.ConnectionStringData);
            var coll = await PartialMetadata(new List<MetadataSectionQuery>()
            {
                new MetadataSectionQuery(MetadataSections.Datamodel)
            });
            var changes = SyncMetadata.Create(tables, coll.DataModel);
            return changes;
        }

        private async Task UpdateCollectionAsync(string changesJson)
        {
            JArray changes = JArray.Parse(changesJson);
            string content = GetMetadataContent(metadataFileName, metadataFolderName, out var metadataItem);
            Metadata coll = content.Length > 0
                ? JsonConvert.DeserializeObject<Metadata>(content)
                : new Metadata();

            using (var shared = new SharedTransaction())
            {
                try
                {
                    await shared.BeginTransactionAsync().ConfigureAwait(false);
                    bool isNeedSaveMetadata = false;
                    bool isNeedCommitTransaction = false;

                    for (var i = 0; i < changes.Count; i++)
                    {
                        var item = changes[i];
                        if (item["__type"] == null || item["__state"] == null)
                            continue;

                        var type = item["__type"].ToObject<string>();
                        MetadataObjectState state = MetadataObjectState.Unchanged;
                        Enum.TryParse(item["__state"].ToObject<string>(), true, out state);
                        if (state == MetadataObjectState.Unchanged)
                            continue;

                        switch (type)
                        {
                            //Objects from DB
                            case MetadataSections.AppSettings:
                                isNeedCommitTransaction = true;
                                var asNewRow = item.ToObject<AppSettings>();
                                var asExistsRow = await AppSettings.SelectByKey(asNewRow.Name);
                                await UpdateDbObject(asExistsRow, asNewRow, state);
                                break;
                            case MetadataSections.Form:
                                isNeedCommitTransaction = true;
                                await UpdateForm(item, state);
                                break;
                            case MetadataSections.FormMapping:
                                isNeedCommitTransaction = true;
                                await UpdateFormMapping(item, state);
                                break;
                            case MetadataSections.FormCode:
                                isNeedCommitTransaction = true;
                                await UpdateFormCode(item, state);
                                break;
                            case MetadataSections.CssCode:
                                isNeedCommitTransaction = true;
                                await UpdateCssCode(item, state);
                                break;
                            case MetadataSections.Workflow:
                                if (state == MetadataObjectState.Deleted)
                                {
                                    isNeedCommitTransaction = true;
                                    var wf = item.ToObject<WorkflowScheme>();
                                    await WorkflowScheme.DeleteAsync(new List<string>() { wf.Code });
                                }
                                else
                                {
                                    new Exception("Insert and update operations must be processing via WorkflowEngine API!");
                                }
                                break;
                            case MetadataSections.Groups:
                                isNeedCommitTransaction = true;
                                await UpdateGroupAsync(item, state);
                                break;
                            case MetadataSections.Permissions:
                                isNeedCommitTransaction = true;
                                await UpdatePermissionAsync(item, state);
                                break;

                            case MetadataSections.Roles:
                                isNeedCommitTransaction = true;
                                await UpdateRoleAsync(item, state);
                                break;
                            case MetadataSections.Users:
                                isNeedCommitTransaction = true;
                                await UpdateUserAsync(item, state);
                                break;
                            case MetadataSections.DataSync:
                                isNeedCommitTransaction = true;
                                isNeedSaveMetadata = true;
                                SyncMetadata.ApplyModelChanges(coll, item, state);
                                break;
                            case MetadataSections.Localization:
                                isNeedCommitTransaction = true;
                                await UpdateLocalization(item, state);
                                break;
							case MetadataSections.FilesUpload:
							    isNeedCommitTransaction = true;
                                await UpdateFilesUploadAsync(item, state);
								break;

							default:
                                isNeedCommitTransaction = true;
                                isNeedSaveMetadata = true;
                                coll.Update(item, type, state);
                                break;
                        }
                    }

                    if (isNeedSaveMetadata)
                    {
                        metadataItem.StartTracking();
                        metadataItem.Data = JsonConvert.SerializeObject(coll, Formatting.Indented,
                            new JsonSerializerSettings()
                            {
                                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                                NullValueHandling = NullValueHandling.Ignore
                            });
                        metadataItem.UpdatedBy = CloverRuntime.Security.CurrentUser.Id;
                        metadataItem.UpdatedDate = DateTime.Now;
                        await metadataItem.ApplyAsync();

                    }

                    if (isNeedCommitTransaction)
                        await shared.CommitAsync().ConfigureAwait(false);
                    else
                        await shared.RollbackAsync().ConfigureAwait(false);
                }
                catch (Exception ex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception("Update metadata error: " + ex.Message, ex);
                }
            }
        }



#region Update DBObjects
		private async Task UpdateFilesUploadAsync(JToken item, MetadataObjectState state)
		{
			var file = item.ToObject<UploadedFilesPoor>();
			var list = new List<Guid>() { file.Id };
			
			//if (user.StructDivisionId == null) user.StructDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;

			if (state == MetadataObjectState.Deleted)
			{
				//await DbObjects.UploadedFilesPoor.Remove(new List<String>() { file.Id });
				await DbObjects.UploadedFilesPoor.DeleteAsync(new List<Guid>() { file.Id });
			}
		}

		private async Task UpdateUserAsync(JToken item, MetadataObjectState state)
        {
            User user = item.ToObject<User>();

            //Only have user.Id passed in when deleting user and user.struct will be null and skip checking struct access. 
            if (state == MetadataObjectState.Deleted && user.StructDivisionId == null)
            {
                user.StructDivisionId = (await SecurityUser.GetStructIdByUserId(user.Id)).GetValueOrDefault();
            }

            //user's struct division could be null when create user without setting organization.
            if (state == MetadataObjectState.Inserted && user.StructDivisionId == null)
            {
                user.StructDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;
            }
            else
            {
                //cannot update user in other divisions
                var hasStructAccess = await HasStructAccess(user.StructDivisionId);
                if (!hasStructAccess) throw new Exception("No permission");
            }

            bool hasPermission = await CheckPermission(user, state);
            if (!hasPermission)
            {
                throw new Exception("No permission");
            }

            if (state == MetadataObjectState.Deleted)
            {
                var userroles = await SecurityUserToSecurityRole.SelectByUser(user.Id);
                //Only have user.Id passed in when deleting user, get user login
                //To just remove user identified in cache instead of clearing cache when running ResetUserCache.
                user.Login = await SecurityCredential.GetLoginByUserId(user.Id);
                if (userroles.Count > 0)
                    await SecurityUserToSecurityRole.DeleteEntitiesAsync(userroles.Select(c => c as DbObject<SecurityUserToSecurityRole>).ToList());

                var usergroup = await SecurityGroupToSecurityUser.SelectByUser(user.Id);
                if (usergroup.Count > 0)
                    await SecurityGroupToSecurityUser.DeleteEntitiesAsync(usergroup.Select(c => c as DbObject<SecurityGroupToSecurityUser>).ToList());

                await SecurityUser.DeleteAsync(new List<Guid>() { user.Id }); 
                //skip reset cache for self delete, reset cache ll take place in controller for this case
                //controller will need the CurrentUser.Id and tell frontend to redirect to logoff the user.
                if (CloverRuntime.Security.CurrentUser?.Id != user.Id)
                    CloverRuntime.Security.ResetUserCache(user.Login);
            }
            else if (state == MetadataObjectState.Inserted)
            {
                //login and name are mandatory
                if (string.IsNullOrEmpty(user.Login)) throw new Exception("Login is required");
                if (string.IsNullOrEmpty(user.Name)) throw new Exception("Name is required");

                //if (await SecurityUser.SelectByPrincipal(user.Login)!=null) throw new Exception($"User {user.Login} exists");
                if (await SecurityCredential.IsLoginCredentialExist(user.Login, Guid.Empty))
                    throw new Exception($"User {user.Login} exists");

                if (!string.IsNullOrEmpty(user.DomainLogin) && await SecurityCredential.IsLoginCredentialExist(user.DomainLogin, Guid.Empty))
                    throw new Exception($"This window identity is already mapped.");

                user.CreatedDate = DateTime.Now;
                user.CreatedBy = CloverRuntime.Security.CurrentUser.Id;
                var su = user.ToDbObject();
                su.ResetTotpSecret();
                await su.ApplyAsync();
                await SecurityCredential.ApplyAsync(user.GetCredentials());

                if (user.Roles != null)
                {
                    await SecurityUserToSecurityRole.ApplyAsync(
                        user.Roles.Select(roleId =>
                            (DbObject<SecurityUserToSecurityRole>)new SecurityUserToSecurityRole()
                            {
                                Id = Guid.NewGuid(),
                                SecurityUserId = su.Id,
                                SecurityRoleId = roleId
                            }).ToArray());
                }

                if (user.Groups != null)
                {
                    var groupUser = user.Groups.Select(groupId =>
                        (DbObject<SecurityGroupToSecurityUser>)new SecurityGroupToSecurityUser()
                        {
                            Id = Guid.NewGuid(),
                            SecurityUserId = su.Id,
                            SecurityGroupId = groupId
                        }).ToArray();
                    await SecurityGroupToSecurityUser.ApplyAsync(groupUser);
                }
            }
            else if (state == MetadataObjectState.Updated)
            {
                //login and name are mandatory
                if (string.IsNullOrEmpty(user.Login)) throw new Exception("Login is required");
                if (string.IsNullOrEmpty(user.Name)) throw new Exception("Name is required");
                if(!string.IsNullOrEmpty(user.DomainLogin) && await SecurityCredential.IsLoginCredentialExist(user.DomainLogin, user.Id)) 
                    throw new Exception($"This Windows identity is already mapped.");

                user.UpdatedDate = DateTime.Now;
                user.UpdatedBy = CloverRuntime.Security.CurrentUser.Id;
                var su = user.ToDbObject();
                var existsRow = await SecurityUser.SelectByKey(su.Id);
                SecurityCredential[] credentials = await SecurityUser.GetCredentialByUserId(su.Id);
                var sutosr = await SecurityUserToSecurityRole.SelectByUser(su.Id);
                var sgtosu = await SecurityGroupToSecurityUser.SelectByUser(su.Id);

                if (existsRow == null) return;

                //kludge to preserve the GA salt across edits without exposing it to UI
                string existingGaSalt = existsRow.GaSalt;

                existsRow.StartTracking();
                (existsRow.AsDynamicEntity as DynamicEntity)?
                    .MergeProperties(su.AsDynamicEntity as DynamicEntity, false);

                //kludge to preserve the GA salt across edits without exposing it to UI
                existsRow.GaSalt = existingGaSalt;

                var containerCredential = new ObservableEntityContainer(credentials.Select(c => c.AsDynamicEntity), SecurityCredential.Model);
                SyncCredential(user, credentials, containerCredential, authenticationType: 0); //custom
                SyncCredential(user, credentials, containerCredential, authenticationType: 1); //domain

                var roles = user.Roles ?? new List<Guid>();
                var groups = user.Groups ?? new List<Guid>();

                var containersutosr = new ObservableEntityContainer(sutosr.Select(c => c.AsDynamicEntity), SecurityUserToSecurityRole.Model);
                containersutosr.Merge(roles.Select(roleId => new SecurityUserToSecurityRole()
                {
                    Id = Guid.NewGuid(),
                    SecurityUserId = su.Id,
                    SecurityRoleId = roleId
                }.AsDynamicEntity), true);


                var containersgtosu = new ObservableEntityContainer(sgtosu.Select(c => c.AsDynamicEntity), SecurityGroupToSecurityUser.Model);
                containersgtosu.Merge(groups.Select(groupId => new SecurityGroupToSecurityUser()
                {
                    Id = Guid.NewGuid(),
                    SecurityUserId = su.Id,
                    SecurityGroupId = groupId
                }.AsDynamicEntity), true);

                await existsRow.ApplyAsync();
                await containerCredential.ApplyAsync();
                await containersutosr.ApplyAsync();
                await containersgtosu.ApplyAsync();
                //skip reset cache for self delete, reset cache ll take place in controller for this case
                //controller will need the CurrentUser.Id and tell frontend to redirect to logoff the user.
                if (CloverRuntime.Security.CurrentUser?.Id != user.Id)
                    CloverRuntime.Security.ResetUserCache(user.Login);
            }
        }

        private static void SyncCredential(User user, SecurityCredential[] credentials,
            ObservableEntityContainer containerCredential, byte authenticationType)
        {
            var credential = (authenticationType == 0
                ? user.GetCustomCredential() : user.GetDomainCredential());
            var existsCredList = credentials.Where(c => c.AuthenticationType == authenticationType).ToArray();
            if (credential == null)
            {
                containerCredential.Remove(existsCredList.Select(c => c.AsDynamicEntity));
            }
            else if (existsCredList.Length == 0)
            {
                containerCredential.Merge(new List<dynamic>() { credential.AsDynamicEntity });
            }
            else
            {
                var existsCredential = existsCredList.First();
                if (authenticationType == 0 && string.IsNullOrWhiteSpace(credential.PasswordHash))
                {
                    existsCredential.Login = credential.Login;
                    existsCredential.RequireTotp = credential.RequireTotp;
                    //Leave existing password as is if they didnt enter one in UI
                }
                else
                {
                    existsCredential.Login = credential.Login;
                    existsCredential.RequireTotp = credential.RequireTotp;
                    existsCredential.PasswordHash = credential.PasswordHash;
                    existsCredential.PasswordSalt = credential.PasswordSalt;

                    if (existsCredList.Length > 1)
                    {
                        containerCredential.Remove(existsCredList.Skip(1).Select(c => c.AsDynamicEntity));
                    }
                }
            }
        }

        private async Task UpdatePermissionAsync(JToken item, MetadataObjectState state)
        {
            Permission permission = item.ToObject<Permission>();

            if (state == MetadataObjectState.Deleted)
            {
                if (permission.IsGroup)
                    await SecurityPermissionGroup.DeleteAsync(new List<Guid>() { permission.Id });
                else
                    await SecurityPermission.DeleteAsync(new List<Guid>() { permission.Id });
            }
            else if (state == MetadataObjectState.Inserted)
            {
                if (permission.IsGroup)
                {
                    SecurityPermissionGroup group = permission.ToGroupDbObject();

                    await group.ApplyAsync();
                    await SecurityPermission.Model.InsertAsync(permission.ChildrenToDbObject()
                        .Select(c => c.AsDynamicEntity).ToList());
                }
                else
                {
                    throw new Exception("For inserting a permission using group object.");
                }
            }
            else if (state == MetadataObjectState.Updated)
            {
                if (permission.IsGroup)
                {
                    var groupRow = permission.ToGroupDbObject();
                    var existsRow = await SecurityPermissionGroup.SelectByKey(groupRow.Id);
                    if (existsRow == null) return;
                    existsRow.StartTracking();
                    (existsRow.AsDynamicEntity as DynamicEntity)?
                        .MergeProperties(groupRow.AsDynamicEntity as DynamicEntity, false);

                    var permissions = permission.ChildrenToDbObject();
                    var existsPermissions = await existsRow.SecurityPermission.AsyncValue;
                    var containerPermissions = new ObservableEntityContainer(existsPermissions.Select(c => c.AsDynamicEntity), SecurityPermission.Model);
                    containerPermissions.Remove(existsPermissions.Where(c => !permissions.Any(p => p.Id == c.Id)).Select(c => c.AsDynamicEntity));
                    containerPermissions.Merge(permissions.Select(c => c.AsDynamicEntity));

                    await existsRow.ApplyAsync();
                    await containerPermissions.ApplyAsync();
                }
                else
                {
                    throw new Exception("For updating a permission using group object.");
                }
            }
        }

        private async Task UpdateRoleAsync(JToken item, MetadataObjectState state)
        {
            Role role = item.ToObject<Role>();

            if (state == MetadataObjectState.Deleted)
            {
                var rolemap = await SecurityRoleToSecurityPermission.SelectByRole(role.Id);
                await SecurityRoleToSecurityPermission.DeleteEntitiesAsync(
                    rolemap.Select(c => c as DbObject<SecurityRoleToSecurityPermission>).ToList());
                await SecurityRole.DeleteAsync(new List<Guid>() { role.Id });
            }
            else if (state == MetadataObjectState.Inserted)
            {
                SecurityRole sr = role.ToDbObject();

                await sr.ApplyAsync();
                await SecurityRoleToSecurityPermission.ApplyAsync(
                    role.ToPermissionsDbObject().Select(c => c as DbObject<SecurityRoleToSecurityPermission>).ToList());

            }
            else if (state == MetadataObjectState.Updated)
            {
                SecurityRole sr = role.ToDbObject();
                var existsRow = await SecurityRole.SelectByKey(sr.Id);
                var sRtoSp = await SecurityRoleToSecurityPermission.SelectByRole(sr.Id);

                if (existsRow == null) return;
                existsRow.StartTracking();
                (existsRow.AsDynamicEntity as DynamicEntity)?
                    .MergeProperties(sr.AsDynamicEntity as DynamicEntity, false);

                var containerSRtoSp = new ObservableEntityContainer(sRtoSp.Select(c => c.AsDynamicEntity), SecurityRoleToSecurityPermission.Model);
                containerSRtoSp.Remove(
                    sRtoSp.Where(c => !role.permissions.Any(p => p.Id == c.SecurityPermissionId)).Select(c => c.AsDynamicEntity));

                foreach (SecurityRoleToSecurityPermission t in sRtoSp)
                {
                    foreach (RolePermission p in role.permissions)
                    {
                        if (t.SecurityPermissionId == p.Id)
                            t.AccessType = p.AccessType;
                    }
                }

                containerSRtoSp.Merge(
                    role.permissions
                        .Where(p => !sRtoSp.Any(c => c.SecurityPermissionId == p.Id))
                        .Select(c => new SecurityRoleToSecurityPermission()
                        {
                            Id = Guid.NewGuid(),
                            SecurityPermissionId = c.Id,
                            SecurityRoleId = sr.Id,
                            AccessType = c.AccessType
                        }.AsDynamicEntity));

                await existsRow.ApplyAsync();
                await containerSRtoSp.ApplyAsync();
            }
        }

        private async Task UpdateGroupAsync(JToken item, MetadataObjectState state)
        {
            var group = item.ToObject<Group>();

            if (state == MetadataObjectState.Deleted)
            {
                var grouprole = await SecurityGroupToSecurityRole.SelectByGroup(group.Id);
                await SecurityGroupToSecurityRole.DeleteEntitiesAsync(
                    grouprole.Select(c => c as DbObject<SecurityGroupToSecurityRole>).ToList());

                await SecurityGroup.DeleteAsync(new List<Guid>() { group.Id });
            }
            else if (state == MetadataObjectState.Inserted)
            {
                var sg = group.ToDbObject();
                await sg.ApplyAsync();
                if (group.Roles != null)
                {
                    var sGtoSr = group.Roles.Select(roleId => new SecurityGroupToSecurityRole()
                    {
                        Id = Guid.NewGuid(),
                        SecurityGroupId = sg.Id,
                        SecurityRoleId = roleId
                    });
                    await SecurityGroupToSecurityRole.ApplyAsync(sGtoSr.Select(c => c as DbObject<SecurityGroupToSecurityRole>).ToList());
                }
            }
            else if (state == MetadataObjectState.Updated)
            {
                SecurityGroup sg = group.ToDbObject();
                var existsRow = await SecurityGroup.SelectByKey(sg.Id);
                var sGtoSr = await SecurityGroupToSecurityRole.SelectByGroup(sg.Id);

                if (existsRow == null) return;
                existsRow.StartTracking();
                (existsRow.AsDynamicEntity as DynamicEntity)?
                    .MergeProperties(sg.AsDynamicEntity as DynamicEntity, false);

                var containerSGtoSr = new ObservableEntityContainer(sGtoSr.Select(c => c.AsDynamicEntity), SecurityGroupToSecurityRole.Model);
                containerSGtoSr.Merge(group.Roles.Select(
                    roleId => new SecurityGroupToSecurityRole()
                    {
                        Id = Guid.NewGuid(),
                        SecurityRoleId = roleId,
                        SecurityGroupId = sg.Id
                    }.AsDynamicEntity), true);

                await existsRow.ApplyAsync();
                await containerSGtoSr.ApplyAsync();
            }
        }

        private async Task UpdateDbObject<T>(DbObject<T> existsRow, DbObject<T> newRow, MetadataObjectState state)
            where T : DbObject<T>, new()
        {
            if (state == MetadataObjectState.Deleted)
            {
                if (existsRow == null) return;
                await existsRow.DeleteAsync();
            }
            else if (state == MetadataObjectState.Inserted)
            {
                if (newRow == null) return;
                await newRow.ApplyAsync();
            }
            else if (state == MetadataObjectState.Updated)
            {
                if (newRow == null) return;
                if (existsRow == null)
                {
                    await newRow.ApplyAsync();
                }
                else
                {
                    existsRow.StartTracking();
                    (existsRow.AsDynamicEntity as DynamicEntity)?
                        .MergeProperties(newRow.AsDynamicEntity as DynamicEntity, false);
                    await existsRow.ApplyAsync();
                }
            }
        }
        #endregion

        public async Task<Metadata> PartialMetadata(List<MetadataSectionQuery> queries)
        {
            if (queries == null || !queries.Any()) 
                throw new ArgumentException(nameof(queries), "At least one section must be specified here");

            List<SecurityUser> users = null;
            List<SecurityCredential> credentials = null;
            //List<SecurityRole> roles = null;
            //List<SecurityRoleToSecurityPermission> rolespermission = null;
            //List<SecurityGroup> groups = null;
            //List<SecurityGroupToSecurityRole> groupsroles = null;
            List<SecurityPermissionGroup> permissionGroups = null;
            List<SecurityPermission> permissions = null;

			Metadata coll;

            coll = new Metadata();

            Metadata loadedColl = null;
            foreach (var query in queries)
            {
                switch (query.Section)
                {
                    case MetadataSections.Datamodel:
                        if (loadedColl == null)
                        {
                            string content = GetMetadataContent(metadataFileName, metadataFolderName, out _);
                            loadedColl = content.Length > 0 ?
                                JsonConvert.DeserializeObject<Metadata>(content) :
                                new Metadata();
                        }

                        coll.DataModel = loadedColl.DataModel ?? new List<DataModel>();
                        break;
                    case MetadataSections.Businessflow:
                        if (loadedColl == null)
                        {
                            string content = GetMetadataContent(metadataFileName, metadataFolderName, out _);
                            loadedColl = content.Length > 0 ?
                                JsonConvert.DeserializeObject<Metadata>(content) :
                                new Metadata();
                        }

                        coll.BusinessFlow = loadedColl.BusinessFlow ?? new List<BusinessFlow>();
                        break;
                    case MetadataSections.Form:
                        coll.Forms = CopyFormsCache();
                        //Added to include survey form, since no idea the method reference to here need web app form or survey form.
                        //Preview Survey Form did flow through here
                        Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                        List<Form> tempSurveyFromList = CopySurveyFormsCache(currentUser?.StructDivisionId);
                        coll.Forms.AddRange(tempSurveyFromList);
                        break;
                    case MetadataSections.AppSettings:
                        coll.AppSettings = await AppSettings.SelectAsync();
                        break;
                    case MetadataSections.Users:
                        users = await SecurityUser.SelectAsync();
                        credentials = await SecurityCredential.SelectAsync();
                        break;
                    case MetadataSections.Roles:
                        //TODO - why is this commented out? (in 136d9f5e of 2019-08-02) 
                        //They are still returned for the 'full' retrieval (in GetMetadataAsync now) 
                        //roles = await SecurityRole.SelectAsync();
                        //rolespermission = await SecurityRoleToSecurityPermission.SelectAsync();
                        break;
                    case MetadataSections.Groups:
                        //TODO - why is this commented out? (in 136d9f5e of 2019-08-02)
                        //They are still returned for the 'full' retrieval (in GetMetadataAsync now) 
                        //groups = await SecurityGroup.SelectAsync();
                        //groupsroles = await SecurityGroupToSecurityRole.SelectAsync();

                        break;
                    case MetadataSections.Permissions:
                        permissions = await SecurityPermission.SelectAsync();
                        permissionGroups = await SecurityPermissionGroup.SelectAsync();
                        coll.Permissions = Permission.Create(permissionGroups, permissions);
                        break;
                    case MetadataSections.Workflow:
                        coll.Workflow = await WorkflowScheme.SelectAsync();
                        break;
                    case MetadataSections.Codeactions:
                        if (loadedColl == null)
                        {
                            string content = GetMetadataContent(metadataFileName, metadataFolderName, out _);
                            loadedColl = content.Length > 0 ?
                                JsonConvert.DeserializeObject<Metadata>(content) :
                                new Metadata();
                        }

                        coll.CodeActions = loadedColl.CodeActions ?? new List<CodeAction>();
                        coll.CodeActions.AddRange(GetCodeActionsDefinedOnServer());
                        break;
                    case MetadataSections.Localization:
                        coll.localization = GetLocalizationList();
                        break;
                        //structdivisions and fileuploads (poor) aren't returned here but are in the 'full' retrieval (in GetMetadataAsync now) 
                }
            }
            return coll;
        }

        public async Task<Metadata> FullMetadata()
        {
            //List<SecurityUser> users = null;
            //List<SecurityCredential> credentials = null;
            List<SecurityRole> roles = null;
            List<SecurityRoleToSecurityPermission> rolespermission = null;
            List<SecurityGroup> groups = null;
            List<SecurityGroupToSecurityRole> groupsroles = null;
            List<SecurityPermissionGroup> permissionGroups = null;
            List<SecurityPermission> permissions = null;
            List<StructDivision> structDivisions = null;
            List<UploadedFilesPoor> fileUploads = null;

            Metadata coll;

            string content = GetMetadataContent(metadataFileName, metadataFolderName, out _);
            coll = content.Length > 0 ?
                JsonConvert.DeserializeObject<Metadata>(content) :
                new Metadata();

            #region License
            var license = Licensing.GetLicense<CloverRestrictions>();
            coll.LicenseInfo = new LicenseInfo()
            {
                Holder = license.Ref,
                LicenseExpiry = license.LicenseExpiry,
                ReleaseExpiry = license.ReleaseExpiry,
                LicenseCheckType = license.CheckType.ToString("G"),
                Limits = new Dictionary<string, string>
                {
                    {"Instances", license.Restrictions.MaxNumberOfInstances.ToString()},
                    {"Threads", license.Restrictions.MaxNumberOfThreads.ToString()},
                    {"Users", license.Restrictions.MaxNumberOfUsers.ToString()},
                    {"Forms", license.Restrictions.MaxNumberOfForms.ToString()},
                    {"Workflow", license.Restrictions.MaxNumberOfWorkflow.ToString()}
                }
            };
            #endregion

            //users and credentials were commented out in 136d9f5e of 2019-08-02
            //users = await SecurityUser.SelectAsync();
            //credentials = await SecurityCredential.SelectAsync();
            roles = await SecurityRole.SelectAsync();
            rolespermission = await SecurityRoleToSecurityPermission.SelectAsync();
            groups = await SecurityGroup.SelectAsync();
            groupsroles = await SecurityGroupToSecurityRole.SelectAsync();
            permissionGroups = await SecurityPermissionGroup.SelectAsync();
            permissions = await SecurityPermission.SelectAsync();

            //20221018AH - Note that this change is still preserving the old behaviour which was to fetch these
            //             only for the current user. (Previously SelectChildrenAndThis would assume current user if not speciffied otherwise)
            Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            structDivisions = (currentUser == null || currentUser.StructDivisionId == null)
                ? new List<StructDivision>()
                : await StructDivision.SelectChildrenAndThisAsync((Guid)currentUser.StructDivisionId);

            coll.AppSettings = await AppSettings.SelectAsync();
            coll.Forms = CopyFormsCache();
            coll.Workflow = await WorkflowScheme.SelectAsync();
            coll.Users = new List<User>();
            coll.Groups = Group.Create(groups, groupsroles);
            coll.Roles = Role.Create(roles, rolespermission);
            coll.Permissions = Permission.Create(permissionGroups, permissions);
            if (coll.CodeActions == null)
                coll.CodeActions = new List<CodeAction>();
            coll.CodeActions.AddRange(GetCodeActionsDefinedOnServer());
            coll.AdditionalParams = new Dictionary<string, object>();
            coll.AdditionalParams.Add("Types", CloverRuntime.RegisteredTypeNames);
            coll.localization = GetLocalizationList();
            coll.StructDivisions = structDivisions;
            coll.FileUploads = fileUploads;
            return coll;
        }

        private List<CodeAction> GetCodeActionsDefinedOnServer()
        {
            List<CodeAction> res = new List<CodeAction>();
            var actions = CloverRuntime.ServerActions.GetActionNamesFromProviders();
            res.AddRange(actions.Select(c => new CodeAction()
            {
                Name = c,
                DefinedOnServer = true,
                Id = HashHelper.FromString(c),
                Type = CodeActionType.Action
            }));

            var filters = CloverRuntime.ServerActions.GetFilterNamesFromProviders();
            res.AddRange(filters.Select(c => new CodeAction()
            {
                Name = c,
                DefinedOnServer = true,
                Id = HashHelper.FromString(c),
                Type = CodeActionType.Filter
            }));

            var triggers = CloverRuntime.ServerActions.GetTriggerNamesFromProviders();
            res.AddRange(triggers.Select(c => new CodeAction()
            {
                Name = c,
                DefinedOnServer = true,
                Id = HashHelper.FromString(c),
                Type = CodeActionType.Trigger
            }));

            return res;
        }

#region Localization
        private List<object> GetLocalizationList()
        {
            List<object> res = new List<object>();
            var filter = Filter.And.Equal(metadataLocalizationFolderName, "Folder");
            var metadataItems = DbObjects.Metadata.SelectAsync(filter).Result;
            foreach (var metadataItem in metadataItems)
            {
                if (metadataItem.Filename.EndsWith(localizationPostfix))
                {
                    res.Add(new { name = GetSubName(metadataItem.Filename, localizationPostfix) });
                }
            }

            if (res.All(c => ((dynamic)c).name != baselocalization))
            {
                res.Add(new { name = baselocalization });
            }

            return res;

        }

        private async Task<object> LocalizationUpdateTemplate(NameValueCollection p)
        {
            var name = p["name"];
            var source = p["source"];
            if (string.IsNullOrWhiteSpace(name))
            {
                return new FailResponse("The request hasn't the required parameter 'name'!");
            }

            if (string.IsNullOrWhiteSpace(source))
            {
                source = ((dynamic)GetLocalization(name)).source as string;
            }

            JToken obj = null;
            if (source != null)
            {
                try
                {
                    obj = JToken.Parse(source);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(LocalizationUpdateTemplate) + " - failed to parse source");
                }
            }

            if (obj == null)
                obj = JToken.Parse("{}");

            //base form
            if (name != baselocalization)
            {
                var baselocal = GetLocalization(baselocalization);
                if (baselocal != null)
                {
                    JToken baseJSON = null;
                    try
                    {
                        baseJSON = JToken.Parse(((dynamic)baselocal).source);
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(LocalizationUpdateTemplate) + " - failed to parse source");
                    }
                    if (baseJSON != null)
                        LocalizationSyncWithBase(obj, baseJSON);
                }
            }

            //forms block
            var forms = CopyFormsCache();
            //Added to include survey form, since no idea the method reference to here need web app form or survey form.
            Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            List<Form> tempSurveyFromList = CopySurveyFormsCache(currentUser?.StructDivisionId);
            forms.AddRange(tempSurveyFromList);
            if (obj["forms"] == null)
                obj["forms"] = JToken.Parse("{}");

            var objForm = obj["forms"];

            foreach (var form in forms)
            {
                var formsource = GetFormSource(form.Name);
                JToken sourceJSON = null;
                try
                {
                    sourceJSON = JToken.Parse(formsource);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(LocalizationUpdateTemplate) + " - failed to parse formsource, form.Name={0}", form?.Name);
                }

                if (objForm[form.Name] == null)
                {
                    objForm[form.Name] = JToken.Parse("{}");
                }

                if (sourceJSON == null)
                    continue;

                LocalizationUpdateTemplateFillGaps(objForm[form.Name], sourceJSON);
            }

            return new ItemSuccessResponse<object>(obj.ToString(Formatting.Indented));
        }

        public void LocalizationSyncWithBase(JToken target, JToken source)
        {
            foreach (var s in source)
            {
                if (s is JProperty)
                {
                    var p = (JProperty)s;
                    if (target[p.Name] == null)
                    {
                        target[p.Name] = p.Value.DeepClone();
                    }
                    else
                    {
                        LocalizationSyncWithBase(target[p.Name], p.Value);
                    }
                }
            }
        }

        private void LocalizationUpdateTemplateFillGaps(JToken local, JToken controls)
        {
            foreach (var control in controls)
            {
                var key = control["key"].ToString();

                if (string.IsNullOrWhiteSpace(key))
                    continue;

                var attributes = Form.GetAttributesForLocalization(control);

                if (attributes != null)
                {
                    foreach (var att in attributes)
                    {
                        string name = $"{key}_{att.Key}";
                        if (local[name] == null && att.Value != null)
                        {
                            local[name] = att.Value.ToString();
                        }
                    }
                }

                if (control["children"] != null)
                {
                    LocalizationUpdateTemplateFillGaps(local, control["children"]);
                }
            }
        }

        private async Task<object> LoadLocalization(NameValueCollection p)
        {
            var name = p["name"];
            if (string.IsNullOrWhiteSpace(name))
            {
                return new FailResponse("The request hasn't the required parameter 'name'!");
            }
            return new ItemSuccessResponse<object>(GetLocalization(name));
        }

        public object GetLocalization(string local)
        {

            string source = null;
            if (TryGetMetadataSource(local + localizationPostfix, metadataLocalizationFolderName, out string localSource))
            {
                source = localSource;
            }
            else if (local == baselocalization)
            {
                source = @"{
    ""common"": {

    },
    ""msg"":{
        
    }
}";
            }
            else
            {
                var baseobj = GetLocalization(baselocalization);
                source = ((dynamic)baseobj).source;
            }

            return new
            {
                name = local,
                source
            };
        }

        private async Task UpdateLocalization(JToken item, MetadataObjectState state)
        {
            dynamic local = item.ToObject<dynamic>();
            string metadataLocalizationFilename = (string)local.name+localizationPostfix;
            if (state == MetadataObjectState.Deleted)
            {
                if (TryGetMetadata(metadataLocalizationFilename, metadataLocalizationFolderName, out DbObjects.Metadata metadata))
                {
                    await metadata.DeleteAsync();
                }
            }
            else if (state == MetadataObjectState.Inserted || state == MetadataObjectState.Updated)
            {
                await ChangeMetadata(metadataLocalizationFilename, metadataLocalizationFolderName, (string)local.source);
            }
        }

        public JToken GetLocalizationForForm(string name, string lang)
        {
            string metadataLocalizationFilename = lang + localizationPostfix;
            if (!TryGetMetadataSource(metadataLocalizationFilename, metadataLocalizationFolderName, out string localSource)) 
                return null;
            var json = JToken.Parse(localSource);
            var item = json?["forms"]?.FirstOrDefault(c => name.Equals((c as JProperty)?.Name, StringComparison.OrdinalIgnoreCase));
            return item?.First();
        }
#endregion

#region Form
        /// <summary>
        /// Returns a new independent shallow copy of the AllFormsCache list (note: referred Form objects are still shared)
        /// This method only retrieve form that is NOT SURVEY, should be for admin/clover purpose to load the webapp form
        /// THIS METHOD IS NOT READ-ONLY, IT ALSO does the initial preparation of the list and 
        /// calls MetadataCaches.SetAllFormsCache with it if cache was empty when called.
        /// (Renamed from GetFormsList() )
        /// </summary>
        /// <returns>copy of allforms</returns>
        private List<Form> CopyFormsCache()
        {

            List<Form> sharedAllFormsCache = metadataCaches.GetAllFormsCache();
            if (!sharedAllFormsCache.Any())
            {
                sharedAllFormsCache = PrepareNonSurveyFormsList();
                metadataCaches.SetAllFormsCache(sharedAllFormsCache);
                return sharedAllFormsCache;
            }
            return new List<Form>(sharedAllFormsCache);
        }

        private List<Form> PrepareNonSurveyFormsList()
        {
            List<Form> forms = new List<Form>();
            var filter = Filter.And.Equal(metadataFormsFolderName, "Folder");
            var metadataItems = DbObjects.Metadata.SelectAsync(filter).Result;
            HashSet<string> selectedForm = new HashSet<string>();
            foreach (var metadataItem in metadataItems)
            {
                if (metadataItem.Filename.EndsWith(formSettingsPostfix))
                {
                    var content = metadataItem.Data;
                    var form = JsonConvert.DeserializeObject<Form>(content);
                    if (form.IsSurvey) continue;
                    form.Name = GetSubName(metadataItem.Filename, formSettingsPostfix);
                    selectedForm.Add(form.Name);
                    forms.Add(form);
                }
            }

            var formWithoutSettings = new List<string>();

            foreach (var metadataItem in metadataItems)
            {

                if (metadataItem.Filename.EndsWith(formSettingsPostfix) || metadataItem.Filename.EndsWith(formCodePostfix))
                    continue;

                if (metadataItem.Filename.EndsWith(formPostfix))
                {
                    var formname = GetSubName(metadataItem.Filename, formPostfix);
                    if (!forms.Exists(c => c.Name == formname) && selectedForm.Contains(formname))
                    {
                        formWithoutSettings.Add(formname);
                    }
                }
            }

            forms.AddRange(formWithoutSettings.Select(c => new Form() { Name = c }));

            return forms;
        }

        /// <summary>
        /// Returns a new independent shallow-copy of the survey forms list for the current user's organisation
        /// or all the survey forms if no organisation is specified
        /// (Renamed from GetSurveyFormsList)
        /// </summary>
        public List<Form> CopySurveyFormsCache(Guid? structDivisionId)
        {
            List<Form> surveyFormsCache = metadataCaches.GetSurveyFormsCache(structDivisionId);
            bool cacheInitialised = surveyFormsCache.Any();
            if(!cacheInitialised)
            {
                //TODO -  I see that there is no locking while we prepare the cache. As cache preparation is far from instant
                //        can this lead to situations where a form update does not get cached if another thread is
                //        already in the middle of rebuilding the cache and misses it and then the cache is replaced?

                surveyFormsCache = PrepareSurveyFormsList(structDivisionId);
                metadataCaches.SetSurveyFormsCache(structDivisionId, surveyFormsCache);

            }
            List<Form> shallowCopy = new List<Form>(surveyFormsCache);
            return shallowCopy;
        }

        /// <summary>
        /// This method was extracted from CopySurveyForms cache to make the control flow more easier to see at a glance.
        /// It prepares the the list of survey forms from the settings files in dwMetadata. This method doesn't change 
        /// cache state (that is left up to caller to handle)
        /// </summary>
        /// <param name="currentUserSdi"></param>
        /// <returns></returns>
        private List<Form> PrepareSurveyFormsList(Guid? currentUserSdi) 
        { 
            List<Form> surveyForms = new List<Form>();
            Filter filter = Filter.And.Equal(metadataFormsFolderName, "Folder");

            List<Guid> structDivisionIdList = (currentUserSdi ==null)
                ? new List<Guid>()
                : StructDivision.SelectChildrenAndThisIdListAsync((Guid)currentUserSdi).Result; //sync over async :-(
            filter.AddCriteria(Filter.And.In(structDivisionIdList, "StructDivisionId"));
            List<DbObjects.Metadata> metadataItems = DbObjects.Metadata.SelectAsync(filter).Result;
            HashSet<string> selectedForm = new HashSet<string>();
            foreach (DbObjects.Metadata metadataItem in metadataItems)
            {
                if (metadataItem.Filename.EndsWith(formSettingsPostfix))
                {
                    string content = metadataItem.Data;
                    Form form = JsonConvert.DeserializeObject<Form>(content);
                    if (!form.IsSurvey) continue;
                    form.Name = GetSubName(metadataItem.Filename, formSettingsPostfix);
                    selectedForm.Add(form.Name);
                    form.CreatedBy = metadataItem.CreatedBy != null ? metadataItem.CreatedBy.ToString() : string.Empty;
                    form.UpdatedBy = metadataItem.UpdatedBy != null ? metadataItem.UpdatedBy.ToString() : string.Empty;
                    form.UpdatedDate = metadataItem.UpdatedDate == null ? metadataItem.CreatedDate : metadataItem.UpdatedDate;
                    surveyForms.Add(form);
                }
            }

            //TODO - It is unclear if much or any of the following is necessary. It looks like it was copy pasted from older
            //       general purpose form code and may not be applicable for survey forms?
            //       Can we have survey forms without a related -settings.json? Should we even try to support that?
            //       Are there such legacy forms in SIMS perhaps?
            //       If not then get rid of the below, and can tweak the above filter to only get %-settings.json too

            List<string> formWithoutSettings = new List<string>();

            foreach (DbObjects.Metadata metadataItem in metadataItems)
            {

                if (metadataItem.Filename.EndsWith(formSettingsPostfix) || metadataItem.Filename.EndsWith(formCodePostfix))
                    continue;

                if (metadataItem.Filename.EndsWith(formPostfix))
                {
                    var formname = GetSubName(metadataItem.Filename, formPostfix);
                    if (!surveyForms.Exists(c => c.Name == formname) && selectedForm.Contains(formname))
                    {
                        formWithoutSettings.Add(formname);
                    }
                }
            }

            surveyForms.AddRange(formWithoutSettings.Select(c => new Form() { Name = c }));

            HashSet<string> userIdSet = new HashSet<string>();
            if (metadataItems != null && metadataItems.Count > 0)
            {
                userIdSet.UnionWith(metadataItems.Select(i => i.UpdatedBy.ToString()).ToList());
                userIdSet.UnionWith(metadataItems.Select(i => i.CreatedBy.ToString()).ToList());
                userIdSet.Remove(null);
                userIdSet.Remove(string.Empty);
                userIdSet.Remove(Guid.Empty.ToString());
                Filter userFilter = Filter.And.In<string>(userIdSet.ToList(), "Id");
                var securityUsers = DbObjects.SecurityUser.SelectAsync(userFilter).Result.ToDictionary(u => u.Id.ToString());
                if (securityUsers != null && securityUsers.Count > 0)
                {
                    foreach (Form item in surveyForms)
                    {
                        if (!string.IsNullOrEmpty(item.CreatedBy) && securityUsers.ContainsKey(item.CreatedBy))
                        {
                            item.CreatedByUsername = securityUsers[item.CreatedBy].Name;
                        }
                        if (!string.IsNullOrEmpty(item.UpdatedBy) && securityUsers.ContainsKey(item.UpdatedBy))
                        {
                            item.UpdatedByUsername = securityUsers[item.UpdatedBy].Name;
                        }
                    }
                }
            }

            return surveyForms;
        }

        public Form GetFormsSettings(string formName)
        {
            Form form = null;

            if (TryGetMetadataSource(formName + formSettingsPostfix, metadataFormsFolderName, out string source))
            {
                form = JsonConvert.DeserializeObject<Form>(source);
            }
            return form;
        }

        public string GetLocalizationScript(string lang)
        {
            dynamic locale = GetLocalization(lang); //use dynamic so we can refer to 'source' below
            if (locale != null)
            {
                return $"window.CloverLang = {(string)locale.source}";
            }
            return string.Empty;
        }

        public string GetFormsBusinessCode(string name)
        {

            if (!string.IsNullOrEmpty(name))
            {
                var jscode = GetFormCode(name);
                StringBuilder formcodesource = new StringBuilder();
                formcodesource.AppendFormat("var {0}UserActions = {1};", name.ToLower(), string.IsNullOrWhiteSpace(jscode) ? "{}" : jscode);
                return formcodesource.ToString();
            }

            var forms = CopyFormsCache();
            //This method is trying to build UserActions for businessobjects.js, survey form has no related at all.
            //List<Form> tempSurveyFromList = CopySurveyFormsCache();
            //forms.AddRange(tempSurveyFromList);
            
            var items = new Dictionary<string, string>();
            var formTemplates = new Dictionary<string, List<string>>();

            foreach (var form in forms)
            {
                form.JavaScriptCode = GetFormCode(form.Name);
                form.Source = GetFormSource(form.Name);
                items.Add(form.Name, string.IsNullOrWhiteSpace(form.JavaScriptCode) ? "{}" : form.JavaScriptCode);
                //nb: if the following line throws exception about 'same key' then db probably has duplicate form names
                formTemplates.Add(form.Name, form.GetTemplates()); 
            }

            StringBuilder source = new StringBuilder();
            foreach (var i in items)
            {
                source.AppendLine($"var {i.Key.ToLower()}UserActions = {i.Value};");
            }

            if (formTemplates.Count > 0)
            {
                //TODO - can the js 'var' be replaced by a 'let' or 'const' below?
                source.AppendLine("//Init user actions by template");
                source.AppendLine(@"function cloverInitUserActionsFromTemplates(obj, templates){
                        if(templates === undefined || obj === undefined)
                            return;
        
                        obj.templates = templates;
                        for(var templateName in obj.templates){
                            var template = obj.templates[templateName];
                            for(var tp in template){
                                if(obj[tp] == undefined){
                                    obj[tp] = template[tp];
                                }
                            }
                        }
                    }");
                //source.AppendLine(string.Format("cloverInitUserActionsFromTemplates({0}UserActions, {{{1}}});",
                //    t.Key.ToLower(),
                //    String.Join(",", t.Value.Select(c =>
                //        string.Format("\"{0}\": {0}", c.ToLower() + "UserActions")))));
                foreach (KeyValuePair<string, List<string>> template in formTemplates)
                {
                    //none of the existing forms actually seem to have anything in the Value
                    string templates = string.Join(", ", template.Value.Select(t =>
                    {
                        string templateActionsName = $"{t.ToLower()}UserActions";
                        return $"\"{templateActionsName}\": {templateActionsName}";
                    }));
                    source.AppendLine($"cloverInitUserActionsFromTemplates({template.Key.ToLower()}UserActions, {{{templates}}});");
                }
            }

            return source.ToString();
        }

        public bool BlockMetadataChanges { get; private set; }

        public List<string> GetWorkflowByForm(string formName)
        {
            var form = GetFormsSettings(formName);
            return form?.Schemes;
        }


        //Moved here from MetadataToModelConverter, merged with the existing GetForm
        public Form GetForm(string formName)
        {
            if(CloverRuntime.UseMetadataCache)
            {
                if (!metadataCaches.TryGetForm(formName, out Form form))
                {
                    form = GetFormInternal(formName);
                    //For intranet application we always add to the form cache even if it's a survey form
                    metadataCaches.SetForm(formName, form);
                }
                return form;
            }
            else
            {
                return GetFormInternal(formName);
            }
        }

        //previously this implemented GetForm but then we merged in the one from MetadataToModelCache
        private Form GetFormInternal(string formName)
        {
            var form = GetFormsSettings(formName) ?? new Form();
            form.Name = formName;
            form.Source = GetFormSource(formName);
            form.JavaScriptCode = GetFormCode(formName);
            form.CssCode = GetCssCode(formName);
            return form;
        }

        private List<Form> GetForms(string[] formNames)
        {
            var arr = new List<Form>();
            for (var i = 0; i < formNames.Length; i++)
            {
                var form = GetFormsSettings(formNames[i]) ?? new Form();
                form.Name = formNames[i];
                form.Source = GetFormSource(formNames[i]);
                form.JavaScriptCode = GetFormCode(formNames[i]);
                form.CssCode = GetCssCode(formNames[i]);

                arr.Add(form);
            }

            return arr;
        }

        private async Task<object> LoadForm(NameValueCollection p)
        {
            var name = p["name"];
            if (string.IsNullOrWhiteSpace(name))
            {
                return new FailResponse("The request hasn't the required parameter 'name'!");
            }
            return new ItemSuccessResponse<Form>(GetForm(name));
        }

        private async Task<object> LoadForms(NameValueCollection p)
        {
            dynamic names = p["names"].Split(',');
            if (names.Length < 1)
            {
                return new FailResponse("The request hasn't the required parameter 'name'!");
            }
            return new ItemSuccessResponse<object>(GetForms(names));
        }

        private string GetFormPath(string formName)
        {
            return Path.Combine(metadataFormsFolderName, formName);
        }

        public string GetFormSource(string name)
        {
            return TryGetMetadataSource(name + formPostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        private string GetFormCode(string name)
        {
            return TryGetMetadataSource(name + formCodePostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        private string GetCssCode(string name)
        {
            return TryGetMetadataSource(name + formCssCodePostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        private string GetSubName(string s, string prefix, string postfix)
        {
            var index = prefix.Length;
            if (s[index] == '/' || s[index] == '\\')
                index++;

            return s.Substring(index, s.Length - postfix.Length - index);
        }

        private async Task UpdateForm(JToken item, MetadataObjectState state)
        {
            var form = item.ToObject<Form>();

            using (var shared = new SharedTransaction())
            {
                try
                {
                    await shared.BeginTransactionAsync().ConfigureAwait(false);

                    if (state == MetadataObjectState.Deleted)
                    {
                        var fileNames = new string[]
                        {
                            form.Name + formPostfix,
                            form.Name + formSettingsPostfix,
                            form.Name + formCodePostfix
                        };

                        foreach (var file in fileNames)
                        {
                            if (TryGetMetadata(file,
                                metadataFormsFolderName, out DbObjects.Metadata metadata))
                            {
                                await metadata.DeleteAsync();
                            }
                        }

                    }
                    else if (state == MetadataObjectState.Inserted || state == MetadataObjectState.Updated)
                    {
                        var sourceJson = JsonConvert.DeserializeObject(form.Source);
                        var source = JsonConvert.SerializeObject(sourceJson,
                            Formatting.Indented,
                            new JsonSerializerSettings()
                            {
                                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                                NullValueHandling = NullValueHandling.Ignore
                            });
                        await ChangeMetadata(form.Name + formPostfix, metadataFormsFolderName, source);

                        //Update Schemes and SecurityGroup
                        var content = GetMetadataContent(form.Name + formSettingsPostfix, metadataFormsFolderName,
                            out var metadataItem);

                        Form formsettings;
                        if (metadataItem == null)
                        {
                            formsettings = new Form();
                            formsettings.IsSurvey = false;
                        }
                        else if (state == MetadataObjectState.Inserted)
                        {
                            throw new Exception("Form name already been used.");
                        }
                        else
                        {
                            formsettings = JsonConvert.DeserializeObject<Form>(content);
                        }
                        formsettings.Schemes = form.Schemes;
                        formsettings.SecurityGroup = form.SecurityGroup;
                        formsettings.IsTemplate = form.IsTemplate;
                        formsettings.LastUpdate = DateTime.Now;
                        formsettings.IsSurvey = form.IsSurvey;
                        formsettings.StructDivisionId = form.StructDivisionId ?? CloverRuntime.Security.CurrentUser.StructDivisionId; //state == MetadataObjectState.Inserted ? CloverRuntime.Security.CurrentUser.StructDivisionId : form.StructDivisionId;
						formsettings.DataUrl = form.DataUrl;
                        formsettings.DataSourceType = form.DataSourceType;
                        formsettings.isArchived = form.isArchived;

                        var formatedContent = JsonConvert.SerializeObject(formsettings, Formatting.Indented,
                            new JsonSerializerSettings()
                            {
                                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                                NullValueHandling = NullValueHandling.Ignore
                            });

                        if (metadataItem == null)
                        {
                            await AddMetadata(form.Name + formSettingsPostfix, metadataFormsFolderName, formatedContent);
                        }
                        else
                        {
                            await ChangeMetadata(metadataItem, formatedContent);

                        }

                        if (item["dwMetadata"] != null)
                        {
                            var dwMetadataStr = item["dwMetadata"].ToString();
                            if (!string.IsNullOrEmpty(dwMetadataStr)) 
                            {
                                var dwMetadataArr = JArray.Parse(dwMetadataStr);
                                foreach(var dwItem in dwMetadataArr)
                                {
                                    string filename = dwItem["filename"]?.ToString();
                                    string sourceHtml = dwItem["source"]?.ToString();
                                    if (!string.IsNullOrEmpty(filename) && sourceHtml != null)
                                    {
                                        if (TryGetMetadata(filename, metadataFormsFolderName, out DbObjects.Metadata existingDwMetadata))
                                        {
                                            await ChangeMetadata(existingDwMetadata, sourceHtml);
                                        }
                                        else
                                        {
                                            await AddMetadata(filename, metadataFormsFolderName, sourceHtml);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    await shared.CommitAsync().ConfigureAwait(false);
                    metadataCaches.Flush();
                }
                catch (Exception ex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception("Update form error", ex);
                }
            }


        }

        private async Task UpdateFormMapping(JToken item, MetadataObjectState state)
        {
            var form = item.ToObject<Form>();

            if (state == MetadataObjectState.Deleted)
            {
                throw new Exception("For deleting use __type = 'form'!");
            }
            else if (state == MetadataObjectState.Inserted || state == MetadataObjectState.Updated)
            {
                form.Source = null;
                form.JavaScriptCode = null;
                form.LastUpdate = DateTime.Now;

                //if (form.DataColl != null && form.DataMap != null)
                form.ClearEmptyDataMap();

                var content = JsonConvert.SerializeObject(form, Formatting.Indented,
                    new JsonSerializerSettings()
                    {
                        ContractResolver = new CamelCasePropertyNamesContractResolver(),
                        NullValueHandling = NullValueHandling.Ignore
                    });

                await ChangeMetadata(form.Name + formSettingsPostfix, metadataFormsFolderName, content);

                metadataCaches.Flush();
            }
        }

        private async Task UpdateFormCode(JToken item, MetadataObjectState state)
        {
            var form = item.ToObject<Form>();

            if (state == MetadataObjectState.Deleted)
            {
                throw new Exception("For deleting use __type = 'form'!");
            }
            else if (state == MetadataObjectState.Inserted || state == MetadataObjectState.Updated)
            {
                await ChangeMetadata(form.Name + formCodePostfix, metadataFormsFolderName, form.JavaScriptCode);
            }
            metadataCaches.Flush();
        }

        private async Task UpdateCssCode(JToken item, MetadataObjectState state)
        {
            var form = item.ToObject<Form>();

            if (state == MetadataObjectState.Deleted)
            {
                throw new Exception("For deleting use __type = 'form'!");
            }
            else if (state == MetadataObjectState.Inserted || state == MetadataObjectState.Updated)
            {
                await ChangeMetadata(form.Name + formCssCodePostfix, metadataFormsFolderName, form.CssCode);
            }
            metadataCaches.Flush();
        }
        #endregion


        private string GetMetadataContent(string fileName, string folderName, out DbObjects.Metadata metadataItem)
        {
            var filter = Filter.And.Equal(fileName, "Filename").Equal(folderName, "Folder");
            metadataItem = DbObjects.Metadata.SelectAsync(filter).Result.FirstOrDefault();
            if (metadataItem == null) return string.Empty;
            var content = metadataItem.Data;
            return content;
        }

        private string GetSubName(string s, string postfix)
        {
            return s.Substring(0, s.Length - postfix.Length);
        }

        /// <summary>
        /// Will try to load the specified Metadata item from the database, returning false if it cannot be loaded.
        /// On success the item will be returned via the out arg metadataItem.
        /// (This method was previously named MetadataExists)
        /// </summary>
        private bool TryGetMetadata(string fileName, string folderName, out DbObjects.Metadata metadataItem)
        {
            var filter = Filter.And.Equal(fileName, "Filename").Equal(folderName, "Folder");
            metadataItem = DbObjects.Metadata.SelectAsync(filter).Result.FirstOrDefault();
            return metadataItem != null;
        }

        /// <summary>
        /// Will try to load the specified Metadata item from the database, returning false if it cannot be loaded.
        /// On success the item's Source value will be returned via the out arg source.
        /// (This method was previously named MetadataExists)
        /// </summary>
        private bool TryGetMetadataSource(string fileName, string folderName, out string source)
        {
            var filter = Filter.And.Equal(fileName, "Filename").Equal(folderName, "Folder");
            var metadataItem = DbObjects.Metadata.SelectAsync(filter).Result.FirstOrDefault();
            source = null;
            if (metadataItem == null) return false;
            source = metadataItem.Data;
            return true;
        }

        private async Task ChangeMetadata(string fileName, string folderName, string source)
        {
            var filter = Filter.And.Equal(fileName, "Filename").Equal(folderName, "Folder");
            var metadataItem = DbObjects.Metadata.SelectAsync(filter).Result.FirstOrDefault();

            using (var shared = new SharedTransaction())
            {
                await shared.BeginTransactionAsync().ConfigureAwait(false);
                try
                {

                    if (metadataItem == null)
                    {
                        metadataItem = new DbObjects.Metadata()
                        {
                            Id = Guid.NewGuid(),
                            Folder = folderName,
                            Filename = fileName,
                            CreatedBy = CloverRuntime.Security.CurrentUser.Id,
                            CreatedDate = DateTime.Now,
                            StructDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId,
                            Data = source
                        };
                        metadataItem.ApplyAsync().Wait();
                    }
                    else
                    {
                        metadataItem.StartTracking();
                        metadataItem.Data = source;
                        metadataItem.UpdatedBy = CloverRuntime.Security.CurrentUser.Id;
                        metadataItem.UpdatedDate = DateTime.Now;
                        metadataItem.ApplyAsync().Wait();
                    }
                    await shared.CommitAsync().ConfigureAwait(false);

                }
                catch (Exception ex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception("Change metadata error", ex);
                }
            }
        }


        private async Task AddMetadata(string fileName, string folderName, string source)
        {

            using (var shared = new SharedTransaction())
            {
                await shared.BeginTransactionAsync().ConfigureAwait(false);
                try
                {

                    var metadataItem = new DbObjects.Metadata()
                    {
                        Id = Guid.NewGuid(),
                        Folder = folderName,
                        Filename = fileName,
                        CreatedBy = CloverRuntime.Security.CurrentUser.Id,
                        CreatedDate = DateTime.Now,
                        StructDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId,
                        Data = source
                    };
                    metadataItem.ApplyAsync().Wait();
                    await shared.CommitAsync().ConfigureAwait(false);

                }
                catch (Exception ex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception("Change metadata error", ex);
                }
            }
        }



        private async Task ChangeMetadata(DbObjects.Metadata metadataItem, string source)
        {
            using (var shared = new SharedTransaction())
            {
                await shared.BeginTransactionAsync().ConfigureAwait(false);
                try
                {
                    metadataItem.StartTracking();
                    metadataItem.UpdatedBy = CloverRuntime.Security.CurrentUser.Id;
                    metadataItem.UpdatedDate = DateTime.Now;
                    metadataItem.Data = source;
                    metadataItem.ApplyAsync().Wait();
                    await shared.CommitAsync().ConfigureAwait(false);

                }
                catch (Exception ex)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new Exception("Change metadata error", ex);
                }
            }
        }

        private static async Task<bool> HasStructAccess(Guid? accessingStructDivisionId)
        {
            if (!accessingStructDivisionId.HasValue) return true;

            var structDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;
            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            return childrenStructDivisionIds.Contains(accessingStructDivisionId.Value);
        }

        private static async Task<bool> CheckPermission(User user, MetadataObjectState state)
        {
            //1. Admins    - can grant Admins, AuditAdmin, HelpEditor.
            //2. UserAdmin - can grant all roles except Admins.
            //             - UserAdmin in Top Level Organization can grant protected role : AuditAdmin, HelpEditor.
            if (!CloverRuntime.Security.HasAnyRole(new List<string>() { Constants.Role.Admins, Constants.Role.UserAdmin }))
            {
                return false;
            }

            //User Admin
            if (!CloverRuntime.Security.IsInRole(Constants.Role.Admins) && state != MetadataObjectState.Deleted)
            {
                //Restrcit User Admin elevate themselves as Admins 
                bool IsAddingAdmin = await IsUpdatingRole(user, Constants.Role.Admins);
                if (IsAddingAdmin) return false;

                //Compare the roles in db and the roles in user update, to determine user update is delete/adding protected roles.
                StructDivision currentStructDivison = await StructDivision.SelectByKey(CloverRuntime.Security.CurrentUser.StructDivisionId);
                bool currentOrganisationIsNotRoot = currentStructDivison.ParentId != null;
                bool IsUpdatingProtectedRoles = false;
                foreach (string roleCode in ProtectedRoles)
                {
                    IsUpdatingProtectedRoles = await IsUpdatingRole(user, roleCode);
                    if (IsUpdatingProtectedRoles)
                        break;
                }
                if (currentOrganisationIsNotRoot && IsUpdatingProtectedRoles)
                    return false;
            }
            return true;
        }

        private static async Task<bool> IsUpdatingRole(User user,string roleCode)
        {
            if (user.Roles == null) return false; //can be null if try to create new user with no roles selected
            return (!await SecurityUserToSecurityRole.HasUserRole(user.Id, roleCode) && user.Roles.Contains((await SecurityRole.SelectByCode(roleCode)).Id)) 
                || (await SecurityUserToSecurityRole.HasUserRole(user.Id, roleCode) && !user.Roles.Contains((await SecurityRole.SelectByCode(roleCode)).Id));

        }

    }
}