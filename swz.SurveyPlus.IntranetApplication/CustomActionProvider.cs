using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
	public class CustomActionsProvider : IServerActionsProvider
    {
        private readonly IHttpContextAccessor _accessor;


        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<CustomActionsProvider>();

        private readonly Dictionary<string, Func<dynamic, dynamic>> _actions
            = new Dictionary<string, Func<dynamic, dynamic>>();

        private readonly Dictionary<string, Func<dynamic, Task<dynamic>>> _actionsAsync
            = new Dictionary<string, Func<dynamic, Task<dynamic>>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>> _filters
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>> _filtersAsync
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>>();

        private readonly Dictionary<string,
                Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>>
            _triggers
                = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>
                >();

        private readonly Dictionary<string,
                Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>
            _triggersAsync
                = new Dictionary<string,
                    Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>();

        public CustomActionsProvider(IHttpContextAccessor accessor) : this()
        {
            _accessor = accessor;
        }

        public CustomActionsProvider()
        {
            _filtersAsync.Add("StructAsyncFilter", StructAsyncFilter);
            _filtersAsync.Add("DplySampleAsyncFilter", DplySampleAsyncFilter);
            _filtersAsync.Add("FilterAsyncByModelIdAndStruct", FilterAsyncByModelIdAndStruct);
            _filtersAsync.Add("FilterAsyncFieldsAndStruct", FilterAsyncFieldsAndStruct);
            _filters.Add("DplySampleFilter", DplySampleFilter);
            _filtersAsync.Add("AuditStructAsyncFilter", AuditStructAsyncFilter);
            _filtersAsync.Add("FilterByModelId", FilterByModelId);
            _filtersAsync.Add("ParentAsyncFilter", ParentAsyncFilter);
            _filtersAsync.Add("SampleMappingsFilter", SampleMappingsFilter);

            _triggersAsync.Add("CustomAsyncTrigger", CustomAsyncTrigger);
            _triggers.Add("CustomTrigger", CustomTrigger);

            _triggersAsync.Add("UpdateModelAsyncTrigger", UpdateModelAsyncTrigger);
            _triggers.Add("UpdateModelTrigger", UpdateModelTrigger);

            _triggersAsync.Add("EncryptPasswordAsyncTrigger", EncryptPasswordAsyncTrigger);
            _triggersAsync.Add("DecryptPasswordAsyncTrigger", DecryptPasswordAsyncTrigger);

            _triggersAsync.Add("InsertQnnOnlineFormFieldsTrigger", InsertQnnOnlineFormFieldsTrigger);
            _triggersAsync.Add("ValidateOnlineFormTrigger", ValidateOnlineFormTrigger);
            _triggersAsync.Add("ValidateQnnFilesTrigger", ValidateQnnFilesTrigger);
            _triggersAsync.Add("ValidateQnnDplyTrigger", ValidateQnnDplyTrigger);
            _triggersAsync.Add("ValidateQnnSampleTrigger", ValidateQnnSampleTrigger);
            _triggersAsync.Add("ValidateRequireFieldsTrigger", ValidateRequireFieldsTrigger);
            _triggersAsync.Add("ValidateQnnStyleTrigger", ValidateQnnStyleTrigger);
            _triggersAsync.Add("ValidateQnnListTrigger", ValidateQnnListTrigger);
            _triggersAsync.Add("ValidateQnnTrkListTrigger", ValidateQnnTrkListTrigger);
            _triggersAsync.Add("ValidateShortlinkTrigger", ValidateShortlinkTrigger);
            _triggersAsync.Add("ValidateQnnRespAdminTrigger", ValidateQnnRespAdminTrigger);
            _triggersAsync.Add("ValidateQnnHelpTrigger", ValidateQnnHelpTrigger);
            _triggersAsync.Add("ValidateQnnQnnTrigger", ValidateQnnQnnTrigger);

            _triggersAsync.Add("InitDplyAsync", InitDplyAsync);
            _triggersAsync.Add("InsertSampleStructDivisionAsync", InsertSampleStructDivisionAsync);
            _triggersAsync.Add("InsertSampleAddressAsync", InsertSampleAddressAsync);
            _triggersAsync.Add("InsertAnonymousSampleStructDivisionAsync", InsertAnonymousSampleStructDivisionAsync);

            _triggersAsync.Add("NullifyOrganizationParentAsyncTrigger", NullifyOrganizationParentAsyncTrigger);

            _triggersAsync.Add("IsTopLevelStructDivisionAsync", IsTopLevelStructDivisionAsync);

            _triggersAsync.Add("SyncAuditSampleNameAsync", SyncAuditSampleNameAsync);
            
            _actionsAsync.Add("CustomAsyncAction", CustomAsyncAction);
            _actions.Add("CustomAction", CustomAction);
        }

        private IEnumerable<DynamicEntity> GetAllEntitiesInCollection(IList<dynamic> entitiesList,
            CollectionModel collection)
        {
            var allEntitiesInCollection = new Dictionary<object, DynamicEntity>();
            foreach (DynamicEntity entity in entitiesList)
                if (entity.HasProperty(collection.Name))
                    if (entity[collection.Name] is IEnumerable<DynamicEntity> collectionValue)
                        foreach (var dynamicEntity in collectionValue)
                        {
                            var key = dynamicEntity.GetId();
                            if (!allEntitiesInCollection.ContainsKey(key))
                                allEntitiesInCollection.Add(key, dynamicEntity);
                        }

            return allEntitiesInCollection.Values;
        }

        private (string, HashSet<string>) GetTokensInCollection(IList<dynamic> entityList, CollectionModel collection)
        {
            var allTokens = new HashSet<string>();
            var id = "";
            foreach (DynamicEntity entity in entityList)
                if (entity.HasProperty(collection.Name) && entity.HasProperty(Constants.FieldName.Type) &&
                    entity[Constants.FieldName.Type].ToString() == Constants.QnnType.Pdf)
                    if (entity[collection.Name] is IEnumerable<DynamicEntity> collectionValue)
                        foreach (var dynamicEntity in collectionValue)
                        {
                            if (dynamicEntity.HasProperty("Token"))
                                allTokens.Add(dynamicEntity["Token"].ToString());
                            if (dynamicEntity.HasProperty("QnnId"))
                                id = dynamicEntity["QnnId"].ToString();
                        }

            return (id, allTokens);
        }

        private (string, HashSet<string>) GetFormsInCollection(IList<dynamic> entityList, CollectionModel collection)
        {
            var allForms = new HashSet<string>();
            var id = "";
            foreach (DynamicEntity entity in entityList)
                if (entity.HasProperty(collection.Name) && entity.HasProperty(Constants.FieldName.Type) &&
                    entity[Constants.FieldName.Type].ToString() == Constants.QnnType.Online)
                    if (entity[collection.Name] is IEnumerable<DynamicEntity> collectionValue)
                        foreach (var dynamicEntity in collectionValue)
                        {
                            if (dynamicEntity.HasProperty("Name"))
                                allForms.Add(dynamicEntity["Name"]?.ToString() ?? string.Empty);
                            else
                                allForms.Add(string.Empty); //To handle empty name property
                            if (dynamicEntity.HasProperty("QnnId"))
                                id = dynamicEntity["QnnId"].ToString();
                        }

            return (id, allForms);
        }


        private async Task<(bool, string)> FormExists(dynamic entity, CollectionModel collection)
        {
            if (entity[collection.Name] is IEnumerable<DynamicEntity> collectionValue)
                foreach (var dynamicEntity in collectionValue)
                    if (dynamicEntity.HasProperty("Name"))
                    {
                        var formName = dynamicEntity["Name"].ToString();
                        if (!await FormExists(formName)) return (false, formName);
                    }

            return (true, null);
        }


        private async Task<dynamic> GetEntity()
        {
            if (_accessor.HttpContext != null && _accessor.HttpContext.Request != null &&
                _accessor.HttpContext.Request.Query.ContainsKey("urlFilter") &&
                _accessor.HttpContext.Request.Query.ContainsKey("name")
            )
            {
                string modelId = _accessor.HttpContext.Request.Query["urlFilter"];
                string name = _accessor.HttpContext.Request.Query["name"];
                if (!string.IsNullOrEmpty(modelId) && Guid.TryParse(modelId, out Guid _) && !string.IsNullOrEmpty(name))
                {
                    var model = await MetadataToModelConverter.GetEntityModelByFormAsync(name,
                        new BuildModelOptions(null, true));
                    return (await model.GetAsync(Filter.And.Equal(modelId, "Id"))).FirstOrDefault();
                }
            }

            return null;
        }

        private async Task<bool> FormExists(string formName, bool isIntranet = true)
        {
            if (isIntranet)
            {
                var form = CloverRuntime.Metadata.GetFormsSettings(formName);
                if (form == null || !form.IsSurvey || form.StructDivisionId == null) return false;
                var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
                var childrenStructDivisionIds =
                (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                    "ParentId"))).Select(p => p.Id).Distinct().ToList();
                return childrenStructDivisionIds.Contains(form.StructDivisionId.Value);
            }

            var formSource = CloverRuntime.Metadata.GetFormSource(formName);
            return formSource != null;
        }

        private async Task<bool> AnsExists(string respId)
        {
            var qnnRespAnsModel =
                await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP_ANS);
            return (await qnnRespAnsModel.GetAsync(Filter.And.Equal(respId, Constants.FieldName.RespId))).Any();
        }

        private async Task UpdateFormSettings(string formName)
        {
            var form = CloverRuntime.Metadata.GetFormsSettings(formName) ?? new Form();
            var settings = await AppSettings.SelectAsync(Filter.And.In(new List<string> {"SurveyDataUrl"}, "Name"));
            var surveyDataUrl = settings.FirstOrDefault(c => c.Name == "SurveyDataUrl")?.Value ?? "/survey/data";
            form.DataSourceType = "url";
            form.Name = formName;
            form.IsSurvey = true;
            form.DataUrl = surveyDataUrl;
            var content = JsonConvert.SerializeObject(form, Formatting.Indented,
                new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    NullValueHandling = NullValueHandling.Ignore
                });

            var obj = JObject.Parse(content);
            obj.Add(new JProperty("__type", "formmapping"));
            obj.Add(new JProperty("__state", "updated"));

            var pars = new NameValueCollection {{"operation", "change"}};

            var sbChanges = new StringBuilder("[");
            sbChanges.Append(obj);
            sbChanges.Append("]");
            pars.Add("items", sbChanges.ToString());
            await CloverRuntime.Metadata.ConfigAPI(pars);
        }

        #region IServerActionsProvider implementation

        public List<string> GetFilterNames()
        {
            return _filters.Keys.Concat(_filtersAsync.Keys).ToList();
        }

        public bool IsFilterAsync(string name)
        {
            return _filtersAsync.ContainsKey(name);
        }

        public bool ContainsFilter(string name)
        {
            return _filtersAsync.ContainsKey(name) || _filters.ContainsKey(name);
        }

        public Filter GetFilter(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            if (_filters.ContainsKey(name))
                return _filters[name](model, entities, options);
            throw new NotImplementedException();
        }

        public Task<Filter> GetFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            if (_filtersAsync.ContainsKey(name))
                return _filtersAsync[name](model, entities, options);
            throw new NotImplementedException();
        }

        public List<string> GetTriggerNames()
        {
            return _triggers.Keys.Concat(_triggersAsync.Keys).ToList();
        }

        public bool IsTriggerAsync(string name)
        {
            return _triggersAsync.ContainsKey(name);
        }

        public bool ContainsTrigger(string name)
        {
            return _triggersAsync.ContainsKey(name) || _triggers.ContainsKey(name);
        }

        public (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            if (_triggers.ContainsKey(name))
                return _triggers[name](model, entities, options);
            throw new NotImplementedException();
        }

        public Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            if (_triggersAsync.ContainsKey(name))
                return _triggersAsync[name](model, entities, options);
            throw new NotImplementedException();
        }

        public List<string> GetActionNames()
        {
            return _actions.Keys.Concat(_actionsAsync.Keys).ToList();
        }

        public bool IsActionAsync(string name)
        {
            return _actionsAsync.ContainsKey(name);
        }

        public bool ContainsAction(string name)
        {
            return _actions.ContainsKey(name) || _actionsAsync.ContainsKey(name);
        }

        public dynamic ExecuteAction(string name, dynamic request)
        {
            if (_actions.ContainsKey(name))
                return _actions[name](request);
            throw new NotImplementedException();
        }

        public async Task<dynamic> ExecuteActionAsync(string name, dynamic request)
        {
            if (_actionsAsync.ContainsKey(name))
                return _actionsAsync[name](request);
            throw new NotImplementedException();
        }

        #endregion

        #region Filters

        private async Task<Filter> DplySampleAsyncFilter(EntityModel model, List<object> entities, dynamic options)
        {
            if (_accessor.HttpContext != null && _accessor.HttpContext.Session != null &&
                _accessor.HttpContext.Session.Keys.Any(k => k == "uId")
            )
            {
                var uId = _accessor.HttpContext.Session.GetString("uId");
                var fields = options as DynamicEntity;
                var filter = Filter.Empty;
                if (fields != null)
                    foreach (var field in fields.Dictionary)
                    {
                        if (field.Value == null || field.Key == null) continue;
                        if (field.Key.ToUpper() == "UID" && ((string) field.Value).ToUpper() == "@UID")
                            filter = filter.Merge(Filter.And.Equal(uId, field.Key));

                        if (field.Key.ToUpper() == "DplyWorkflowState" && (string)field.Value == "Active")
                            filter = filter.Merge(Filter.And.Equal("Active", field.Key));

                        //current
                        if (field.Key.ToUpper() == "DplyDateStart".ToUpper() &&
                            ((string) field.Value).ToUpper() == "<=@NOW")
                            filter = filter.Merge(Filter.And.LessOrEqual(DateTime.Now, field.Key));
                        if (field.Key.ToUpper() == "DueDate".ToUpper() && ((string) field.Value).ToUpper() == ">=@NOW")
                            filter = filter.Merge(Filter.And.Greater(DateTime.Now, field.Key));

                        //previous
                        if (field.Key.ToUpper() == "DueDate".ToUpper() && ((string) field.Value).ToUpper() == "<=@NOW")
                            filter = filter.Merge(Filter.And.LessOrEqual(DateTime.Now, field.Key));
                    }

                return filter;
            }


            return Filter.Empty;
        }

        private async Task<Filter> StructAsyncFilter(EntityModel model, List<object> entities, dynamic options)
        {
            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            if (structDivisionId == null) return Filter.Empty;

            List<Guid> childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            return Filter.And.In(childrenStructDivisionIds, "StructDivisionId");
        }

        private async Task<Filter> AuditStructAsyncFilter(EntityModel model, List<object> entities, dynamic options)
        {
            Guid? currentUserStruct = CloverRuntime.Security.CurrentUser.StructDivisionId;
            if (currentUserStruct == null) return Filter.Empty;

            var fields = options as DynamicEntity;
            List<Guid> childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(currentUserStruct,
                Constants.FieldName.ParentId))).Select(p => p.Id).Distinct().ToList();

            return Filter.And.NestOr().In(childrenStructDivisionIds, Constants.FieldName.StructDivisionId).Equal(Null.Value,Constants.FieldName.StructDivisionId).Parent();
        }


        public async Task<Filter> FilterAsyncFieldsAndStruct(EntityModel model, List<dynamic> entities, dynamic options)
        {
            var fields = options as DynamicEntity;
            var filter = Filter.Empty;
            if (fields != null)
                foreach (var field in fields.Dictionary)
                    filter = filter.Merge(Filter.And.Equal(await Triggers.ReplaceVariable(field.Value, model),
                        field.Key));
            var structFilter = (Filter) await StructAsyncFilter(model, entities, options);
            return filter.Merge(structFilter);
        }


        private Filter DplySampleFilter(EntityModel model, List<object> entities, dynamic options)
        {
            return Filter.Empty;
        }

        public async Task<Filter> FilterByModelId(EntityModel model, List<dynamic> entities, dynamic options)
        {
            //logger.LogInformation("Calling FilterByModelId");
            var fields = options as DynamicEntity;
            var entity = entities.FirstOrDefault() as DynamicEntity;
            var filter = Filter.And.Equal(Guid.Empty, "Id");
            //Filter filter = Filter.Empty;
            if (entity == null || !entity.HasPrimaryKey) entity = await GetEntity();

            if (fields != null && entity != null)
            {
                filter = Filter.Empty;
                foreach (var field in fields.Dictionary)
                    filter = filter.Merge(Filter.And.Equal(ReplaceVariable(field.Value, entity), field.Key));
            }

            return filter;
        }

        public async Task<Filter> FilterAsyncByModelIdAndStruct(EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            var filter = (Filter) await FilterByModelId(model, entities, options);
            var structFilter = (Filter) await StructAsyncFilter(model, entities, options);
            return filter.Merge(structFilter);
        }

        /// <summary>
        /// For Organization table purpose only, due to it use ParentId instead StructDivisionId as other table standard.
        /// If Organization table column is use StructDivisionId instead ParentId, then this method is not needed.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="entities"></param>
        /// <param name="options"></param>
        /// <returns></returns>
        public async Task<Filter> ParentAsyncFilter(EntityModel model, List<object> entities, dynamic options)
        {
            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            if (structDivisionId == null) return Filter.Empty;

            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                Constants.FieldName.ParentId))).Select(p => p.Id).Distinct().ToList();

            return Filter.And.In(childrenStructDivisionIds, Constants.FieldName.Id);
        }

        private object ReplaceVariable(object val, dynamic entity)
        {
            var str = (string) val;
            if (str == null) return val;
            switch (str)
            {
                case "@Id":
                    val = entity["Id"];
                    break;
                case "@UserId":
                    val = CloverRuntime.Security.CurrentUser.Id;
                    break;
                default:
                    if (entity[str] != null)
                        val = entity[str] ?? str;
                    break;
            }

            return val;
        }

        /// <summary>
        /// For use on the QNN_SAMPLE form, will filter out the QNN_SAMPLE_ADDRESS or QNN_SAMPLE_STRUCTDIVISION that are not applicable to this
        /// sample or not visible to this user.
        /// </summary>
        private async Task<Filter> SampleMappingsFilter(EntityModel model, List<object> entities, dynamic options)
        {
           if(!Constants.Comparers.ObjectNameCaseInsensitive.Equals(model?.Name, Constants.ModelName.QNN_SAMPLE))
                throw new ArgumentException($"Wrong model, expected {Constants.ModelName.QNN_SAMPLE} but received {model?.Name}", nameof(model));
            if (entities == null || entities.Count != 1) 
                throw new ArgumentException($"Unexpected data, entities.Count={entities?.Count}", nameof(entities));

            DynamicEntity qnnSample = (DynamicEntity)entities.FirstOrDefault();
            Guid sampleId = (Guid)qnnSample[Constants.FieldName.Id];

            Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            List<Guid> allowedStructDivisionId = await StructDivision.SelectChildrenAndThisIdListAsync(currentUser.StructDivisionId.Value);

            //following will work for both sample address and mapped struct divisions
            Filter filter = Filter.And
                .Equal(sampleId, Constants.FieldName.SampleId)
                .In(allowedStructDivisionId, Constants.FieldName.StructDivisionId);
            return filter;
        }

        #endregion

        #region Triggers

        private async Task<(string Message, bool IsCancelled)> UpdateModelAsyncTrigger(EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            var user = CloverRuntime.Security.CurrentUser;

            foreach (var entity in entities)
                if (entity.Id != null)
                {
                }

            return (null, false);
        }

        public async Task<(string Message, bool IsCancelled)> EncryptPasswordAsyncTrigger(EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            var fields = options as DynamicEntity;
            var beforeUpdateTrigger = true;
            if (fields != null)
            {
                beforeUpdateTrigger = (string) fields.Dictionary["BeforeUpdateTrigger"] == "1";   
            }
            foreach (DynamicEntity entity in entities)
            {
                if (!string.IsNullOrEmpty(entity["Pwd"]?.ToString()) && (!beforeUpdateTrigger || entity["UpdatedBy"]!=null) && (CloverRuntime.Security.IsInRole("Admins") || CloverRuntime.Security.IsInRole("SurveyAdmin")))
                    entity.TrySetMember("Pwd", EncryptionHelper.EncryptStr(entity["Pwd"].ToString(), Constants.LoginKey, Constants.LoginIv));

            }

            return (null, false);
        }

        public async Task<(string Message, bool IsCancelled)> DecryptPasswordAsyncTrigger(EntityModel model, List<dynamic> entities,
            dynamic options)
        {

            foreach (DynamicEntity entity in entities)
            {
                if (!string.IsNullOrEmpty(entity["Pwd"]?.ToString()) && CloverRuntime.Security.IsInRole("Admins"))
                    entity.TrySetMember("Pwd", EncryptionHelper.DecryptStr(entity["Pwd"].ToString(), Constants.LoginKey, Constants.LoginIv));
                else
                {
                    entity.TrySetMember("Pwd", null);
                }
            }

            return (null, false);
        }

        private async Task<(string Message, bool IsCancelled)> InitDplyAsync(
            EntityModel model,
            List<object> entities, 
            dynamic options)
        {
            try
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!currentUser.IsInRole(Constants.Role.SurveyAdmin))
                    throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                
                DynamicEntity qnnDply = entities.FirstOrDefault() as DynamicEntity;
                //if (qnnDply == null || !qnnDply.HasPrimaryKey) qnnDply = await GetEntity();
                if (qnnDply == null)
                    throw new InternalException("null deployment entity");
                Guid dplyId = (Guid)qnnDply[Constants.FieldName.Id];

                //The below code for reading message options from UI was extracted from the old InsertDplyMessageAsync
                //We need to grab the json from the request and parse it again because these UI fields aren't part
                //of the QNN_DPLY entity
                string strFormData = _accessor.HttpContext?.Request?.Form?["data"];
                if (strFormData == null)
                    throw new InvalidOperationException("No form data in request!");
                var formEntity = DynamicEntity.ParseJSON(strFormData);
                var bMailMerge = Convert.ToBoolean(formEntity["cbMailMerge"]);
                var bEmail = Convert.ToBoolean(formEntity["cbEmail"]);
                var bProfile = Convert.ToBoolean(formEntity["cbProfile"]);
                var strSubject = formEntity["subject"].ToString();
                var emailFrom = bEmail ? formEntity["emailFrom"]?.ToString() : null; //may be null/empty to indicate default sender
                if (!string.IsNullOrEmpty(emailFrom) && !Email.IsAddressFormatValid(emailFrom))
                {
                    return ("Invalid email address from", true);
                }
                var scheduledDate = formEntity["scheduledDate"]?.ToString().toDate("yyyy-MM-dd HH:mm");
                var msgContent = formEntity["msgContent"].ToString();
                var msgContentJson = formEntity["msgContentJson"]?.ToString();
                //...

                //We now perform the dlsi provisioning and initial notification setup in the background
                await BusinessProcess.Enqueue.InitialiseDeployment(
                    dplyId,
                    bMailMerge,
                    bEmail,
                    bProfile,
                    emailFrom,
                    msgContent,
                    msgContentJson,
                    strSubject);

                return (string.Empty, false); //ok
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(InitDplyAsync) + " - caught unexpected exception");
                return ("Deployment initialisation failed", true);
            }
        }

        private async Task<(string Message, bool IsCancelled)> InsertSampleStructDivisionAsync(EntityModel model,
            List<object> entities, dynamic options)
        {
            try
            {

                var entity = entities.FirstOrDefault() as DynamicEntity;
                if (entity == null || !entity.HasPrimaryKey) entity = await GetEntity();

                var sampleStructDivisionModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION,
                        0);
                var dmSampleStructDivision = await sampleStructDivisionModel.NewAsync() as dynamic;
                dmSampleStructDivision.Id = Guid.NewGuid();
                dmSampleStructDivision.SampleId = entity["Id"];
                dmSampleStructDivision.StructDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
                await sampleStructDivisionModel.InsertSingleAsync((DynamicEntity)dmSampleStructDivision);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(InsertSampleAddressAsync) + " - caught unexpected exception");
                return ("Sample division was not inserted", true);
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> InsertSampleAddressAsync(
            EntityModel model,
            List<object> entities, 
            dynamic options)
        {
            if(!Constants.Comparers.ObjectNameCaseInsensitive.Equals(model?.Name, Constants.ModelName.QNN_SAMPLE))
                throw new ArgumentException($"Wrong model, expected {Constants.ModelName.QNN_SAMPLE} but received {model?.Name}", nameof(model));
            if (entities == null || entities.Count != 1)
                throw new ArgumentException($"Unexpected data, count={entities?.Count}", nameof(entities));
            try
            {

                DynamicEntity qnnSample = (DynamicEntity)entities.FirstOrDefault();
                Guid sampleId = (Guid)qnnSample[Constants.FieldName.Id];

                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                //List<Guid> allowedStructDivisionId = await StructDivision.SelectChildrenAndThisIdListAsync(currentUser.StructDivisionId.Value);

                EntityModel qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
                DynamicEntity qnnSampleAddress = await qnnSampleAddressModel.NewAsync();
                qnnSampleAddress[Constants.FieldName.SampleId] = sampleId;
                qnnSampleAddress[Constants.FieldName.StructDivisionId] = (Guid)currentUser.StructDivisionId;
                qnnSampleAddress[Constants.FieldName.CreatedBy] = currentUser.Id;
                qnnSampleAddress[Constants.FieldName.CreatedDate] = DateTime.Now;
                qnnSampleAddress[Constants.FieldName.ToEmails] = "";
                qnnSampleAddress[Constants.FieldName.CcEmails] = "";
                qnnSampleAddress[Constants.FieldName.AddressLine1] = "";
                qnnSampleAddress[Constants.FieldName.AddressLine2] = "";
                qnnSampleAddress[Constants.FieldName.AddressLine3] = "";

                await qnnSampleAddressModel.InsertSingleAsync(qnnSampleAddress);                
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(InsertSampleAddressAsync) + " - caught unexpected exception");
                return ("Sample division was not inserted", true);
            }
            return (string.Empty, false);
        }

        //Validate that all qnn fields in the db are to be found in the excel files (For QNN_QNN_FILE under a QNN_QNN)
        private async Task<(string Message, bool IsCancelled)> ValidateQnnFilesTrigger (
            EntityModel model,
            List<object> entities, 
            dynamic options)
        {
            try
            {
                //Exit trigger if no entities in collection or not an online survey
                if (!entities.Any() ||
                    !entities.Any(e => ((DynamicEntity)e).HasProperty(Constants.FieldName.Type)) ||
                    entities.All(e =>
                        ((DynamicEntity)e).GetProperty(Constants.FieldName.Type)?.ToString() !=
                        Constants.QnnType.Online))
                {
                    return (string.Empty, false);
                }

                CollectionModel qnnQnnFormCollectionModel = model.Collections.FirstOrDefault((cm) => Constants.ModelName.QNN_QNN_FORM.Equals(cm.Model.Name));
                CollectionModel qnnQnnFileCollectionModel = model.Collections.FirstOrDefault((cm) => Constants.ModelName.QNN_QNN_FILE.Equals(cm.Model.Name));
                if (qnnQnnFileCollectionModel == null || qnnQnnFileCollectionModel == null)
                {
                    return (string.Empty, false);
                }

                foreach (DynamicEntity qnnQnn in entities)
                {
                    bool isReallyAQnnQnnProbably = qnnQnn.HasProperty(qnnQnnFileCollectionModel.Name) && qnnQnn.HasProperty(Constants.FieldName.Type);

                    //Only process qnnQnn if its an online QNN
                    if (isReallyAQnnQnnProbably && qnnQnn[Constants.FieldName.Type].ToString() == Constants.QnnType.Online)
                    {
                        Guid qnnId = (Guid)qnnQnn.GetId();
                        IEnumerable<DynamicEntity> qnnQnnFiles = (IEnumerable<DynamicEntity>)qnnQnn[qnnQnnFileCollectionModel.Name];
                        if (qnnQnnFiles == null || !qnnQnnFiles.Any())
                        {
                            continue; //skip to next entity as no files to check here
                        }

                        //Get the first online form and find its field names
                        //Other triggers enforce that all the forms will have compatible fields 
                        //so we only need to check against one form here and we use the first one.
                        IEnumerable<DynamicEntity> qnnQnnForms = (IEnumerable<DynamicEntity>)qnnQnn[qnnQnnFormCollectionModel.Name];
                        if(qnnQnnForms == null || !qnnQnnForms.Any())
                        {
                            return ("No online forms specified.", true);
                        }
                        DynamicEntity qnnQnnForm = qnnQnnForms.FirstOrDefault();
                        string firstFormName = (string)qnnQnnForm[Constants.FieldName.Name];
                        if(string.IsNullOrEmpty(firstFormName))
                        {
                            return ("First form name not specified.", true);
                        }
                        string formSource = CloverRuntime.Metadata.GetFormSource(firstFormName);
                        var formItems = FormSerializer.Deserialize(formSource);
                        var items = FormPropertiesApplication.GetAllFormItems(formItems, new List<FormItem>());
                        if (items == null || !items.Any(i => Constants.OnlineFormControls.Contains(i.Type)))
                        {
                            return ($"{firstFormName} form is invalid.", true);
                        }
                        HashSet<string> dbFormFieldNames = items.Select(i => i.Key).ToHashSet();

                        //Now check each file against the form
                        var msg = "";
                        var failed = false;
                        HashSet<string> filesValidated = new HashSet<string>();
                        foreach (DynamicEntity qnnQnnFile in qnnQnnFiles)
                        {
                            //Avoid duplicate work created by Clover bug
                            //See: https://gitlab.com/softworkz-sg/swz-appbuilder-clover/-/issues/30
                            string id = qnnQnnFile.GetId().ToString();
                            if( !filesValidated.Add(id) )
                            {
                                continue; //skip to next file
                            }
                            /////////////////////////////////

                            //Require the download file name to have xlsx extension
                            string name = ((string)qnnQnnFile[Constants.FieldName.Name])?.Trim();
                            if (string.IsNullOrEmpty(name))
                            {
                                failed = true;
                                msg += "Excel file name may not be empty. ";
                            }
                            else if (!ExcelSupport.IsValidExcelFileName(name))
                            {
                                failed = true;
                                msg += (!name.EndsWith(".xlsx", StringComparison.InvariantCultureIgnoreCase))
                                    ? $"Excel File Name '{name}' is missing xlsx extension. "
                                    : $"Excel File Name '{name}' is invalid. ";
                            }

                            //Verify the required NamedRanges are present and readable
                            (string Message, bool IsSuccessful) result = await ExcelSupport.ValidateQnnQnnFile(qnnQnnFile, dbFormFieldNames);
                            if(result.IsSuccessful==false)
                            {
                                failed = true;
                                msg += result.Message + " ";
                            }
                        } //end foreach qnnQnnFile

                        if (failed)
                        {
                            return (msg==null ? null : Constants.Message.Prefix.ClientReportable +msg, true); //Cancel the save
                        }
                    }
                } // end foreach entity
                return (string.Empty, false);
            }
            catch(Exception e)
            {
                _logger.LogError(e, nameof(ValidateQnnFilesTrigger) + " - caught unexpected exception");
                return (e.Message, true);
            }
        }

        //validate that online forms exist and have the same fields
        private async Task<(string Message, bool IsCancelled)> ValidateOnlineFormTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (!entities.Any() ||
                !entities.Any(e => ((DynamicEntity) e).HasProperty(Constants.FieldName.Type)) ||
                entities.All(e =>
                    ((DynamicEntity) e).GetProperty(Constants.FieldName.Type)?.ToString() !=
                    Constants.QnnType.Online) //is not qnn of type online form
                )
                //not online form type of qnn, no validation needed
                return (string.Empty, false);

            if (!model.Collections.Any()) return (string.Empty, false); //no online form

            foreach (var collectionModel in model.Collections)
            {
                //ensure QNN_QNN_FORM collection
                if(!Constants.Comparers.ObjectNameCaseInsensitive.Equals(collectionModel.Model.Name, Constants.ModelName.QNN_QNN_FORM))
                    continue;

                (var qnnId, var allFormNamesInCollection) = GetFormsInCollection(entities, collectionModel);

                //check form exists
                foreach (var formName in allFormNamesInCollection)
                {
                    if (formName == null || formName == string.Empty)
                        return ($"{Constants.Message.Prefix.ClientReportable}Form Name is required.", true);
                    if (!await FormExists(formName))
                        return ($"{Constants.Message.Prefix.ClientReportable}Form {formName} does not exist or have no access.", true);
                }

                //check not more than 2 forms
                if (allFormNamesInCollection.Count < 2) continue;

                var firstLoop = true;
                var firstFieldList = new List<string>();
                var firstFormName = "";
                //Simply "Fields Not Match" is confusing when there are many other input fields on the screen.
                //The problem here is when the difference got too much, the pop up message definitely shock user.
                //Although the information is there but that bulky messy message will simply bring down the quality experience.
                //Perhaps need a better organize look for those information to cover bulky message scenario.
                var msg = $"{Constants.Message.Prefix.ClientReportable}All fields must match between the Forms. Please verify the following Forms: "; //Constants.Message.FieldsNotMatched;
                var isDiff = false;

                //check form fields
                foreach (var formName in allFormNamesInCollection)
                {
                    var source = CloverRuntime.Metadata.GetFormSource(formName);
                    var formItems = FormSerializer.Deserialize(source);
                    var items = new List<FormItem>();
                    items = FormPropertiesApplication.GetAllFormItems(formItems, items);

                    //Unless we can tell user why it is invalid or some other useful information, else this "invalid" could make user feel helpless.
                    //Feel like indirectly asking user to contact administration to check why the form is invalid...
                    //e.g Input for name, we know somehow it is invalid, then we tell you "Name is invalid". You want to guess why it is invalid?
                    if (items == null || !items.Any(i => Constants.OnlineFormControls.Contains(i.Type)))
                        return ($"{Constants.Message.Prefix.ClientReportable}{formName} form is invalid!", true);

                    var fields = items.OrderBy(i => i.Key).Select(i => i.Key + " " + i.Type)
                        .ToList();
                    if (firstLoop)
                    {
                        firstFieldList = fields;
                        firstFormName = formName;
                        firstLoop = false;
                    }
                    else
                    {
                        
                        //var diff = firstFieldList.Except(fields).Concat(fields.Except(firstFieldList)).ToList();
                        var diff = firstFieldList.Except(fields).ToList();
                        if (diff.Any())
                        {
                            isDiff = true;
                            msg += $"{firstFormName}: {string.Join(", ", diff)}; ";
                        }

                        diff = fields.Except(firstFieldList).ToList();
                        if (diff.Any())
                        {
                            isDiff = true;
                            msg += $"{formName}: {string.Join(", ", diff)}; ";
                        }

                        if (isDiff) return (msg, true);
                    }
                }
            }


            return (string.Empty, false);
        } //end of ValidateOnlineFormTrigger

        private async Task<(string Message, bool IsCancelled)> ValidateQnnDplyTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if(Constants.ModelName.QNN_DPLY.Equals(model.Name))
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity formEntity = (DynamicEntity)entities.FirstOrDefault();
                int error = await DeploymentApplication.ValidateQnnDplyForm(formEntity, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return error switch
                    {
                        1001 => ($"{crp}Online Excel forms are not supported for anonymous surveys", true),
                        1002 => ($"{crp}Delegation Access Code is not supported for anonymous surveys", true),
                        1003 => ($"{crp}Online Excel forms are not supported for multiple response surveys", true),
                        _ => ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true),
                    };
                }
            }
            return (string.Empty, false);
        } //end of ValidateQnnDplyTrigger

        private async Task<(string Message, bool IsCancelled)> ValidateQnnStyleTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (Constants.ModelName.QNN_STYLE.Equals(model.Name))
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await StyleApplication.ValidateQnnStyleForm(data, currentUser);
                if (error != 0)                    
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateQnnListTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (Constants.ModelName.QNN_LIST.Equals(model.Name))
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await SampleListApplication.ValidateQnnListForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateQnnTrkListTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (Constants.ModelName.QNN_TRK_LIST.Equals(model.Name))
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await SampleListApplication.ValidateQnnTrkListForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateShortlinkTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if ("ShortLink" == model.Name) //its the form model, not the entity model. here the names differ
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await ShortLinkApplication.ValidateShortlinkForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateQnnRespAdminTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (Constants.ModelName.QNN_RESP_ADMIN == model.Name)
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await HelpApplication.ValidateQnnRespAdminForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateQnnHelpTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (Constants.ModelName.QNN_HELP == model.Name)
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await HelpApplication.ValidateQnnHelpForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> ValidateQnnQnnTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            //note that validation of the forms is done in ValidateOnlineFormTrigger rather than here
            if (Constants.ModelName.QNN_QNN == model.Name)
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                DynamicEntity data = (DynamicEntity)entities.FirstOrDefault();
                int error = await FormPropertiesApplication.ValidateQnnQnnForm(data, currentUser);
                if (error != 0)
                {
                    const string crp = Constants.Message.Prefix.ClientReportable;
                    return ($"{crp}Error {error}, some fields are not valid. Please check and retry.", true);
                }
            }
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> InsertQnnOnlineFormFieldsTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            if (!entities.Any() ||
                !entities.Any(e => ((DynamicEntity) e).HasProperty(Constants.FieldName.Type)) ||
                entities.All(e =>
                    ((DynamicEntity) e).GetProperty(Constants.FieldName.Type)?.ToString() !=
                    Constants.QnnType.Online) //is not qnn of type online form
            )
                return (string.Empty, false);
            if (!model.Collections.Any()) return (string.Empty, false); //no online form

            foreach (var collectionModel in model.Collections)
            {
                if (collectionModel.Model.Name != Constants.ModelName.QNN_QNN_FORM) continue;
                (var qnnId, var allFormNamesInCollection) = GetFormsInCollection(entities, collectionModel); //

                //if deployed, cannot change fields
                var dplyModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY);
                var qnnDply = await dplyModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId));
                if (qnnDply.Any(r => !((dynamic) r).IsDeleted))
                    //if qnn has been deployed, do nothing
                    return (string.Empty, false);

                //var qnnRespModel =
                //    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP);
                //var qnnResps = await qnnRespModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId));
                //if (qnnResps.Any(r => ((dynamic)r).QnnId_Status && AnsExists(((dynamic)r).Id.ToString())))
                //    //if qnn is active and and has responses, do nothing
                //    return (string.Empty, false);

                foreach (var formName in allFormNamesInCollection
                ) //only first form is processed (multiple languages questionnaire)
                {
                    //gen fields for each form
                    (var message, var isSuccessful) = await FormPropertiesApplication.GenQnnOnlineFormFields(qnnId, formName);

                    //update dataurl for each form
                    await UpdateFormSettings(formName);

                    return (message, !isSuccessful); //IsCancelled = !isSuccessful
                }
            }


            return (string.Empty, false);
        }

        private (string Message, bool IsCancelled) UpdateModelTrigger(EntityModel model, List<object> entities,
            dynamic options)
        {
            return (string.Empty, false);
        }

        private async Task<(string Message, bool IsCancelled)> CustomAsyncTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            return (string.Empty, false);
        }

        private (string Message, bool IsCancelled) CustomTrigger(EntityModel model, List<object> entities,
            dynamic options)
        {
            return (string.Empty, false);
        }

        /// <summary>
        /// This is ONLY for Organization form purpose. Expecting the top node only have one (without any sibling).
        /// This method is to make the ParentId of top node to be null for Hierarchical display type requirement.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="entities"></param>
        /// <param name="options"></param>
        /// <returns></returns>
        private async Task<(string Message, bool IsCancelled)> NullifyOrganizationParentAsyncTrigger(EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            var user = CloverRuntime.Security.CurrentUser;

            var fields = options as DynamicEntity;
            foreach (var entity in entities)
            {
                //Please take note that "collectioneditor_1" is reference to the name on the interface control.
                foreach (var organization in entity.Dictionary["collectioneditor_1"])
                {
                    if (organization[Constants.FieldName.Id] == user.StructDivisionId)
                    {
                        foreach (var field in fields.Dictionary)
                            organization.TrySetMember(field.Key, null);

                        break;
                    }
                }
            }

            return (null, false);
        }

        /// <summary>
        /// This is ONLY for Organization form purpose.
        /// This method is to make the sample-structdivision mapping gets provisioned for swzanonymous for a new organisation.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="entities"></param>
        /// <param name="options"></param>
        /// <returns></returns>
        private async Task<(string Message, bool IsCancelled)> InsertAnonymousSampleStructDivisionAsync(EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            try
            {
                List<dynamic> qnnSampleStructs = new List<dynamic>();
                EntityModel qnnSampleStructModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION, Constants.Level.NoJoins);
                List<DynamicEntity> anonymousSampleStructList = (await qnnSampleStructModel.GetAsync(Filter.And.Equal(Constants.SwzAnonymous.SampleId, Constants.FieldName.SampleId)));

                foreach (var entity in entities)
                {
                    //Please take note that "collectioneditor_1" is reference to the name on the interface control.
                    foreach (var organization in entity.Dictionary["collectioneditor_1"])
                    {
                        //add sample-structdivision mapping for swzanonymous for new organization
                        if (!anonymousSampleStructList.Any(anonymousSampleStruct => anonymousSampleStruct[Constants.FieldName.StructDivisionId].Equals(organization[Constants.FieldName.Id])))
                        {
                            dynamic newSampleStruct = await qnnSampleStructModel.NewAsync() as dynamic;
                            newSampleStruct.Id = Guid.NewGuid();
                            newSampleStruct.SampleId = Constants.SwzAnonymous.SampleId;
                            newSampleStruct.StructDivisionId = organization[Constants.FieldName.Id];

                            qnnSampleStructs.Add(newSampleStruct);
                        }
                    }
                }
                await qnnSampleStructModel.InsertAsync(qnnSampleStructs);
                return (string.Empty, false);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(InsertAnonymousSampleStructDivisionAsync) + " - caught unexpected exception");
                return ("Error occurs when sample-structdivision mapping gets provisioned for swzanonymous for a new organisation", true);
            }
        }

        private async Task<(string Message, bool IsCancelled)> IsTopLevelStructDivisionAsync(
            EntityModel model,
            List<object> entities, 
            dynamic options)
        {
            //To use this configure with afterSelect, and your form will need a main entity with at least one
            //column ticked (eg Id) otherwise the entity gets discarded by Clover and won't make it to the client
            //side. Be warned that that giving a form a Main entity has its own implications too. 

            try
            {
                DynamicEntity entity = entities.FirstOrDefault() as DynamicEntity;
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                StructDivision structDivision = await StructDivision.SelectByKey(user.StructDivisionId);
                bool isTopLevelStructDivision = structDivision.ParentId == null;
                entity["_isTopLevelStructDivision"] = isTopLevelStructDivision; //add to the form data object
                return (string.Empty, false);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(IsTopLevelStructDivisionAsync) + " - caught unexpected exception");
                return ("IsTopLevelStructDivisionAsync failed", true);
            }            
        }

        /// <summary>
        /// Use with AfterInsert and AfterUpdate for changes to QNN_SAMPLE
        /// Will call the stored procedure to re-sync AuditSampleName from QNN_SAMPLE table for all samples.
        /// </summary>m>
        /// <returns></returns>
        private async Task<(string Message, bool IsCancelled)> SyncAuditSampleNameAsync(
            EntityModel model,
            List<object> entities,
            dynamic options)
        {
            try
            {
                //Update AuditSampleName with any changed sample name or UID (note that updates ALL such changed samples,
                //and is not specific to whichever one happened to cause this trigger to be invoked)
                await SurveyPlusAuditHelper.SyncAuditSampleNameAsync();
                return (string.Empty, false);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(SyncAuditSampleNameAsync) + " - caught unexpected exception");
                return ("SyncAuditSampleName failed", true);
            }
        }

        /// <summary>
        /// Server-side validation for certain fields in QNN_SAMPLE
        /// Note the UI does friendly validation so this can do 'unfriendly' double-checking of things
        /// the client can't be trusted for. (For things like column length db will also catch)
        /// </summary>
        private async Task<(string Message, bool IsCancelled)> ValidateQnnSampleTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            try
            {
                DynamicEntity data = entities.FirstOrDefault() as DynamicEntity;
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();

                HashSet<Guid> allowedStructDivisionIds = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);

                foreach (DynamicEntity organisationRemark in (List<DynamicEntity>)data["OrganisationRemarks"])
                {
                    Guid organisation = (Guid)organisationRemark[Constants.FieldName.StructDivisionId];
                    if (!allowedStructDivisionIds.Contains(organisation))
                        throw new PermissionException($"Invalid organisation {organisation} for remarks, user={user.Id}");
                }

                foreach (DynamicEntity organisationRemark in (List<DynamicEntity>)data["AddressBook"])
                {
                    Guid organisation = (Guid)organisationRemark[Constants.FieldName.StructDivisionId];
                    if (!allowedStructDivisionIds.Contains(organisation))
                        throw new PermissionException($"Invalid organisation {organisation} for address, user={user.Id}");
                }

                string name = (string)data[Constants.FieldName.Name];
                if (string.IsNullOrWhiteSpace(name) || name.Length > 128) return ("Invalid name", true);

                string uid = (string)data[Constants.FieldName.UID];
                if (string.IsNullOrWhiteSpace(uid) || uid.Length > 320) return ("Invalid UID", true);

                int? numRetry = (int?)data[Constants.FieldName.NumRetry];
                if (numRetry == null || numRetry < 0) return ("Invalid NumRetry", true);

                return (string.Empty, false);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(ValidateQnnSampleTrigger) + " - caught unexpected exception");
                return ($"{nameof(ValidateQnnSampleTrigger)} failed", true);
            }
        }

        //validate that forms require fields are not empty
        private async Task<(string Message, bool IsCancelled)> ValidateRequireFieldsTrigger(EntityModel model,
            List<object> entities, dynamic options)
        {
            DynamicEntity entity = entities.FirstOrDefault() as DynamicEntity;
            Clover.Core.Metadata.Form form = CloverRuntime.Metadata.GetForm(options.Form); //20260701 - was CR.M

            FormFieldAnalyzer analyzer = new FormFieldAnalyzer();

            List<FormField> requiredFields = analyzer.GetRequiredFields(form.Source);
            foreach (FormField field in requiredFields)
                {
                    string submittedValue = entity[field.Key]?.ToString();

                    if (string.IsNullOrWhiteSpace(submittedValue))
                    {
                        return ($"{Constants.Message.Prefix.ClientReportable}Required information is missing or formatted incorrectly.", true);
                    }
                }
            return (string.Empty, false);
        } //end of ValidateRequireFieldsTrigger
        #endregion

        #region Actions

        private async Task<dynamic> CustomAsyncAction(dynamic request)
        {
            return null;
        }

        private dynamic CustomAction(dynamic request)
        {
            return null;
        }

        #endregion
    }
}