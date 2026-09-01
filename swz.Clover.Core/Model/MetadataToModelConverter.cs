using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Metadata;

namespace swz.Clover.Core.Model
{
    public enum BuildModelStartegy
    {
        ForGet,
        ForChange
    }

    public class BuildModelOptions
    {
       public BuildModelOptions(string requestingControl = null, bool ignoreNameCase = false, BuildModelStartegy strategy = BuildModelStartegy.ForGet)
        {
            RequestingControl = requestingControl;
            IgnoreNameCase = ignoreNameCase;
            Strategy = strategy;
            if (!string.IsNullOrEmpty(RequestingControl) && strategy == BuildModelStartegy.ForChange)
                throw new NotImplementedException($"This case requestingControl={requestingControl} and strtegy={strategy:G} is not implemented");
        }

        public string RequestingControl { get; }
        public bool IgnoreNameCase { get; }
        public BuildModelStartegy Strategy { get; }

        public static BuildModelOptions Default => new BuildModelOptions();
    }

    public static class MetadataToModelConverter 
    {
        private static MetadataCaches metadataCaches;
        
        /// <summary>
        /// Call at startup to initialise the reference to the metadata caches
        /// </summary>
        public static void SetMetadataCaches(MetadataCaches cachesInstance)
        {
            metadataCaches = cachesInstance ?? throw new ArgumentNullException(nameof(cachesInstance));
        }

        public static async Task<FormDataMapping> GetMappingByForm(string name, bool ignoreNameCase = false)
        {
            FormDataMapping result;
            if (CloverRuntime.UseMetadataCache)
            {
                var key = string.Format($"form_mapping_{name}");
                if (!metadataCaches.TryGetMapping(key, out result))
                {
                    result = await GetMappingByFormInternal(name, ignoreNameCase);
                    metadataCaches.SetMapping(key, result);
                }
                return result;
            }
            else
            {
                return await GetMappingByFormInternal(name, ignoreNameCase);
            }
        }

        private static async Task<FormDataMapping> GetMappingByFormInternal(string name, bool ignoreNameCase = false)
        {
            FormDataMapping result;

            var dataModelQuery = new MetadataSectionQuery(MetadataSections.Datamodel);
            Metadata.Metadata applicationMetadata = await CloverRuntime.Metadata.PartialMetadata(new List<MetadataSectionQuery> { dataModelQuery });

            var form = CloverRuntime.Metadata.GetForm(name);

            if (form == null)
                throw new DynamicEntitiesException($"Form {name} is not found");

            result = new FormDataMapping();

            if (form.EntityId.HasValue)
            {
                var model = applicationMetadata.DataModel.FirstOrDefault(m => m.Id == form.EntityId.Value);
                if (model == null)
                {
                    throw new DynamicEntitiesException($"Model {form.EntityId.Value} is not found");
                }

                foreach (var dm in form.DataMap)
                {
                    AddMapping(model, dm, result.ToData, result.ToForm);
                }
            }

            if (form.DataColl != null)
            {
                foreach (var formDataColl in form.DataColl)
                {
                    if (string.IsNullOrEmpty(formDataColl.Control))
                        continue;

                    var mappingToData = new Dictionary<string, object>();
                    var mappingToForm = new Dictionary<string, object>();

                    var model = applicationMetadata.DataModel.FirstOrDefault(m => m.Id == formDataColl.EntityId);

                    if (model == null)
                    {
                        throw new DynamicEntitiesException($"Model {formDataColl.EntityId} is not found");
                    }

                    foreach (var dm in formDataColl.DataMap)
                    {
                        AddMapping(model, dm, mappingToData, mappingToForm);
                    }


                    result.ToData.Add(formDataColl.Control, mappingToData);
                    result.ToForm.Add(formDataColl.Control, mappingToForm);
                }
            }

            return result;
        }

        private static void AddMapping(Metadata.DataModel model, FormDataMap dm, Dictionary<string, object> mappingToData, Dictionary<string, object> mappingToForm)
        {
            var attribute = model.Attributes.FirstOrDefault(a => a.Id == dm.AttributeId);
            if (attribute == null)
                return;
            var toDataKey = !string.IsNullOrEmpty(dm.Control) ? dm.Control : attribute.Name;
            var toFormKey = attribute.Name;
            mappingToData.Add(toDataKey, toFormKey);
            mappingToForm.Add(toFormKey, toDataKey);
        }

        #region GettingMetadata

        public static async Task<EntityModel> GetEntityModelByModelAsync(
            string name, 
            byte maxLevel = 1, 
            bool ignoreCase = false, 
            List<string> attributsToInclude = null)
        {
            if (CloverRuntime.UseMetadataCache)
            {
                string key = string.Format("entity_model_{0}_{1}", name, maxLevel);
                if (attributsToInclude != null && maxLevel == 0 && attributsToInclude.Any())
                    key = $"{key}_{string.Join("_", attributsToInclude)}";
                if (!metadataCaches.TryGetModel(key, out var resultModel))
                {                    
                    resultModel = await GetEntityModelByModelInternalAsync(name, maxLevel, ignoreCase, attributsToInclude);
                    metadataCaches.SetModel(key, resultModel); //In a race this will be last wins
                }
                return resultModel;
            }
            else
            {
                return await GetEntityModelByModelInternalAsync(name, maxLevel, ignoreCase, attributsToInclude);
            }
        }

        private static async Task<EntityModel> GetEntityModelByModelInternalAsync(
            string name, 
            byte maxLevel = 1, 
            bool ignoreCase = false, 
            List<string> attributsToInclude = null)
        {
            EntityModel resultModel;
            var query = new MetadataSectionQuery(MetadataSections.Datamodel);
            var collection = await CloverRuntime.Metadata.PartialMetadata(new List<MetadataSectionQuery> { query }).ConfigureAwait(false);

            var rootContract = collection.DataModel.FirstOrDefault(m => m.Name.Equals(name, ignoreCase ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal));
            if (rootContract == null)
                throw new DynamicEntitiesException($"Model {name} is not found");

            resultModel = ContractToEntityModel(rootContract);

            foreach (var attribute in rootContract.Attributes)
            {
                if (maxLevel == 0 && attributsToInclude != null && attributsToInclude.Any() && !attributsToInclude.Contains(attribute.Name, StringComparer.InvariantCultureIgnoreCase)) continue;
                var attrbuteType = GetAttrbuteType(attribute);

                if (!attribute.ReferenceEntityId.HasValue)
                {
                    var attributeModel = AttributeModel.CreatePlainAttribute(attribute.Name, resultModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);

                    resultModel.AddAttribute(attributeModel);
                }
                else
                {
                    if (attributsToInclude != null && attributsToInclude.Any()) { }
                    var referencedContract = collection.DataModel.FirstOrDefault(m => m.Id.Equals(attribute.ReferenceEntityId.Value));

                    var referencedModel = ContractToDataModel(referencedContract);

                    //Get true PK type from model directly
                    attrbuteType = GetAttributeTypeForReference(referencedContract, attribute.IsNullable) ?? attrbuteType;

                    var attributeModel = AttributeModel.CreatePlainReferenceAttribute(attribute.Name, resultModel, referencedModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);

                    resultModel.AddAttribute(attributeModel);

                    RecursiveAddAll(collection.DataModel, resultModel, referencedContract, 1, maxLevel, attributeModel);

                }
            }

            return resultModel;
        }


        private static EntityModel ContractToEntityModel(Metadata.DataModel rootContract, string name = null)
        {
            return new EntityModel(name ?? rootContract.Name, rootContract.Name, rootContract.SchemaName, rootContract.DbObjectName)
            {
                LogicalDeleteAttributeName = rootContract.LogicalDeleteAttribute,
                PrimaryKeyAttributeName = rootContract.PrimaryKeyAttribute,
                VersionAttributeName = rootContract.VersionAttribute,
                ExtensionsContainerAttributeName = rootContract.ExtensionsContainerAttribute
            };
        }

        private static DataModel ContractToDataModel(Metadata.DataModel rootContract)
        {
            return new DataModel(rootContract.Name, rootContract.SchemaName, rootContract.DbObjectName)
            {
                LogicalDeleteAttributeName = rootContract.LogicalDeleteAttribute,
                PrimaryKeyAttributeName = rootContract.PrimaryKeyAttribute,
                VersionAttributeName = rootContract.VersionAttribute,
                ExtensionsContainerAttributeName = rootContract.ExtensionsContainerAttribute
            };
        }

        private static void RecursiveAddAll(List<Metadata.DataModel> contracts, EntityModel rootModel, Metadata.DataModel currentContract, int currentLevel, int maxLevel,
            AttributeModel parentAttribute)
        {
            if (currentLevel > maxLevel)
                return;
            
            foreach (var attribute in currentContract.Attributes)
            {
                var attrbuteType = GetAttrbuteType(attribute);
                
                if (!attribute.ReferenceEntityId.HasValue)
                {
                    var attributeModel = AttributeModel.CreateJoinedAttribute(attribute.Name, parentAttribute, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);
                    parentAttribute.AddChild(attributeModel);
                    rootModel.AddAttribute(attributeModel);
                }
                else
                {
                    var referencedContract = contracts.FirstOrDefault(m => m.Id.Equals(attribute.ReferenceEntityId.Value));
                    var referencedModel = ContractToDataModel(referencedContract);
                    
                    //Get true PK type from model directly
                    attrbuteType = GetAttributeTypeForReference(referencedContract, attribute.IsNullable) ?? attrbuteType;

                    var attributeModel = AttributeModel.CreateJoinedReferenceAttribute(attribute.Name, parentAttribute, referencedModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);
                    parentAttribute.AddChild(attributeModel);
                    rootModel.AddAttribute(attributeModel);

                    RecursiveAddAll(contracts, rootModel,referencedContract, currentLevel + 1, maxLevel, attributeModel);
                    
                   
                }
            }
        }

        private static AttributeType GetAttributeTypeForReference(Metadata.DataModel referencedContract, bool isNullable)
        {
            AttributeType attrbuteType = null;
            var pkAttr = referencedContract?.Attributes.FirstOrDefault(a => a.Name.Equals(referencedContract.PrimaryKeyAttribute));
            if (pkAttr != null)
                attrbuteType = AttributeType.Get(pkAttr.Type, isNullable);
            return attrbuteType;
        }

        /// <summary>
        /// It will exclude any collection with paging.
        /// </summary>
        public static async Task<EntityModel> GetEntityModelByFormAsync (string name, BuildModelOptions buildModelOptions)
        {
            if (CloverRuntime.UseMetadataCache)
            {
                var key = string.IsNullOrEmpty(buildModelOptions.RequestingControl)
                ? $"entity_form_{name}_{buildModelOptions.Strategy:G}"
                : $"entity_form_{name}_{buildModelOptions.RequestingControl}_{buildModelOptions.Strategy:G}";
                if (!metadataCaches.TryGetModel(key, out EntityModel resultModel))
                {
                    resultModel = await GetEntityModelByFormInternalAsync(name, buildModelOptions);
                    metadataCaches.SetModel(key, resultModel);
                }
                return resultModel;
            }
            else
            {
                return await GetEntityModelByFormInternalAsync(name, buildModelOptions);
            }            
        }

        private static async Task<EntityModel> GetEntityModelByFormInternalAsync(string name, BuildModelOptions buildModelOptions)
        {
            EntityModel resultModel;

            var dataModelQuery = new MetadataSectionQuery(MetadataSections.Datamodel);
            var codeActionQuery = new MetadataSectionQuery(MetadataSections.Codeactions);

            Metadata.Metadata applicationMetadata = await CloverRuntime.Metadata.PartialMetadata(new List<MetadataSectionQuery> { dataModelQuery, codeActionQuery });

            var form = CloverRuntime.Metadata.GetForm(name); //but this is case-sensitive?

            if (form == null)
                throw new DynamicEntitiesException($"Form {name} is not found");

            if (string.IsNullOrEmpty(form.DataSourceType))
            {
                if (form.EntityId.HasValue && string.IsNullOrEmpty(buildModelOptions.RequestingControl))
                {
                    var rootContract = applicationMetadata.DataModel.FirstOrDefault(m => m.Id == form.EntityId.Value);
                    if (rootContract == null)
                        throw new DynamicEntitiesException($"Model {name} is not found");
                    resultModel = ContractToEntityModel(rootContract, form.Name);
                    var zeroLevelDataMap = form.DataMap?.Where(dm => !dm.ParentId.HasValue).ToList() ?? new List<FormDataMap>();
                    var alwaysInclude = !string.IsNullOrEmpty(rootContract.ExtensionsContainerAttribute)
                        ? new List<string> { rootContract.ExtensionsContainerAttribute }
                        : new List<string>();

                    foreach (var attribute in rootContract.Attributes)
                    {
                        if (!NeedLoad(attribute, form.DataMap, zeroLevelDataMap, alwaysInclude) && buildModelOptions.Strategy != BuildModelStartegy.ForChange)
                            continue;

                        var attrbuteType = GetAttrbuteType(attribute);
                        var dataMapItem = zeroLevelDataMap.FirstOrDefault(dm => dm.AttributeId == attribute.Id);
                        var controlName = dataMapItem?.Control;
                        var attributeName = !string.IsNullOrEmpty(controlName) ? controlName : attribute.Name;

                        if (!attribute.ReferenceEntityId.HasValue)
                        {
                            var attributeModel = AttributeModel.CreatePlainAttribute(attributeName, resultModel, attrbuteType, attribute.Name,
                                attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);

                            resultModel.AddAttribute(attributeModel);
                        }
                        else
                        {
                            var referencedContract = applicationMetadata.DataModel.FirstOrDefault(m => m.Id.Equals(attribute.ReferenceEntityId.Value));

                            var referencedModel = ContractToDataModel(referencedContract);

                            //Get true PK type from model directly
                            attrbuteType = GetAttributeTypeForReference(referencedContract, attribute.IsNullable) ?? attrbuteType;

                            var attributeModel = AttributeModel.CreatePlainReferenceAttribute(attributeName, resultModel, referencedModel, attrbuteType, attribute.Name,
                                attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);

                            resultModel.AddAttribute(attributeModel);

                            if (buildModelOptions.Strategy != BuildModelStartegy.ForChange)
                            {
                                var nextLevelDataMap = form.DataMap?.Where(dm => dataMapItem != null && dm.ParentId == dataMapItem.Id).ToList() ?? new List<FormDataMap>();
                                if (nextLevelDataMap.Any())
                                    RecursiveAddAllForForm(applicationMetadata.DataModel, resultModel, referencedContract, form.DataMap, nextLevelDataMap, attributeModel);
                            }

                        }
                    }
                }
                else
                {
                    resultModel = new EntityModel(form.Name);
                }
            }
            else if (form.DataSourceType == "url")
            {
                resultModel = new EntityModel(form.Name);
                if (!string.IsNullOrEmpty(form.DataUrl))
                {
                    resultModel.DataUrl = form.DataUrl;
                }
            }
            else
            {
                resultModel = new EntityModel(form.Name);
            }

            if (form.DataColl != null && form.DataColl.Any())
            {

                if (string.IsNullOrEmpty(buildModelOptions.RequestingControl))
                {
                    var collsToExcude = new List<string>();
                    var formSource = CloverRuntime.Metadata.GetFormSource(name);
                    var formStructure = FormSerializer.Deserialize(formSource);

                    //Excluding collection if it has paging type server.
                    void AddCollsToExclude(List<FormItem> fis, List<string> acc)
                    {
                        foreach (var formItem in fis)
                        {
                            //ZL 2018-11-01 commented out the following if statement and added a replacement one --Start
                            //if (formItem.Type.Equals("gridview", StringComparison.OrdinalIgnoreCase)
                            //    && formItem.Properties.ContainsKey("pagertype") &&
                            //    formItem.Properties["pagertype"].ToString().Equals("server", StringComparison.OrdinalIgnoreCase))

                            if ((formItem.Type.Equals("gridview", StringComparison.OrdinalIgnoreCase) || formItem.Type.Equals("gridviewwithactions", StringComparison.OrdinalIgnoreCase))
                                && formItem.Properties.ContainsKey("pagertype") &&
                                formItem.Properties["pagertype"].ToString().Equals("server", StringComparison.OrdinalIgnoreCase))
                            //ZL 2018-11-01 commented out the following if statement and added a replacement one --End                                
                            {
                                acc.Add(formItem.Key);
                                //AddCollsToExclude(formItem.Children, acc);
                            }
                            AddCollsToExclude(formItem.Children, acc);

                        }
                    }

                    AddCollsToExclude(formStructure, collsToExcude);

                    //Adding collections
                    foreach (var col in form.DataColl.Where(dc => !string.IsNullOrEmpty(dc.Control) && !collsToExcude.Contains(dc.Control)))
                    {
                        var collectionModel = GetCollectionModel(col, applicationMetadata, resultModel, buildModelOptions.Strategy);

                        resultModel.AddCollection(collectionModel);
                    }
                }
                else
                {
                    var dataCollItem = form.DataColl.FirstOrDefault(c => c.Control.Equals(buildModelOptions.RequestingControl));
                    if (dataCollItem != null)
                    {
                        var collectionModel = GetCollectionModel(dataCollItem, applicationMetadata, resultModel, buildModelOptions.Strategy);

                        resultModel.AddCollection(collectionModel);
                    }
                }
            }

            //Add triggers
            if (form.Triggers != null && form.Triggers.Any())
            {
                foreach (var triggers in form.Triggers)
                {
                    var codeActionName = triggers.CodeAction;//applicationMetadata.CodeActions.FirstOrDefault(ca => ca.Id == triggers.CodeActionId)?.Name;
                    if (string.IsNullOrEmpty(codeActionName))
                        continue;

                    dynamic options = null;
                    if (!string.IsNullOrEmpty(triggers.Parameter))
                    {
                        var dictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(triggers.Parameter);
                        options = new DynamicEntity(dictionary);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.Validate))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.BeforeInsert, options);
                        resultModel.AddTrigger(codeActionName, TriggerCallType.BeforeUpdate, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.AfterSelect))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.AfterSelect, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.BeforeInsert))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.BeforeInsert, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.AfterInsert))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.AfterInsert, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.BeforeUpdate))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.BeforeUpdate, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.AfterUpdate))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.AfterUpdate, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.BeforeDelete))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.BeforeDelete, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.AfterDelete))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.AfterDelete, options);
                    }

                    if (triggers.Triggers.Contains(CodeActionTriggerType.AfterNew))
                    {
                        resultModel.AddTrigger(codeActionName, TriggerCallType.AfterNew, options);
                    }
                }
            }

            return resultModel;
            
        }

        private static CollectionModel GetCollectionModel(FormDataColl col, Metadata.Metadata collection, EntityModel resultModel, BuildModelStartegy strategy)
        {
            var collectionEntityModel = GetCollectionEntityModel(col, collection.DataModel, strategy);
            var refAttribute =
                collectionEntityModel.Attributes.FirstOrDefault(a => 
                a.IsReference && a.ReferencedDataModel.TableName.Equals(resultModel.TableName, StringComparison.Ordinal)
                              && string.Equals(a.ReferencedDataModel.SchemaName, resultModel.SchemaName, StringComparison.Ordinal));

            Filter Filter(IEnumerable<DynamicEntity> parents)
            {
                if (!string.IsNullOrWhiteSpace(col.Filter))
                {
                    if (CloverRuntime.ServerActions.ContainsFilter(col.Filter))
                    {
                        dynamic options = null;
                        if (!string.IsNullOrEmpty(col.Parameter))
                        {
                            var dictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(col.Parameter);
                            options = new DynamicEntity(dictionary);
                        }
                        return CloverRuntime.ServerActions.GetFilter(col.Filter, resultModel, parents.Select(c=>c as dynamic).ToList(), options);
                    }

                    throw new DynamicEntitiesException($"Filter {col.Filter} is not found!");
                }

                if (parents == null)
                    return Core.Filter.Empty;

                return refAttribute == null
                    ? Core.Filter.Empty
                    : Core.Filter.And.In(parents.Select(p => p.GetId()).ToList(), refAttribute);
            }

            List<DynamicEntity> Getter(DynamicEntity parentEntity, IEnumerable<DynamicEntity> children)
            {
                return refAttribute == null
                    ? new List<DynamicEntity>()
                    : children.Where(c => c[refAttribute.Name].Equals(parentEntity.GetId())).ToList();
            }

            var collectionModel = new CollectionModel(col.Control, collectionEntityModel, Filter, Getter, col.ReadOnly);
            return collectionModel;
        }

        private static EntityModel GetCollectionEntityModel(FormDataColl collection, List<Metadata.DataModel> model, BuildModelStartegy strategy)
        {
            
            var rootContract = model.FirstOrDefault(m => m.Id == collection.EntityId);
            if (rootContract == null)
                throw new DynamicEntitiesException($"Model {collection.EntityId} is not found");
            
            var resultModel = ContractToEntityModel(rootContract);
            var zeroLevelDataMap = collection.DataMap.Where(dm => !dm.ParentId.HasValue).ToList();
            var alwaysInclude = !string.IsNullOrEmpty(rootContract.ExtensionsContainerAttribute)
                ? new List<string> {rootContract.ExtensionsContainerAttribute}
                : new List<string>();
            foreach (var attribute in rootContract.Attributes)
            {
                var needLoad = NeedLoad(attribute,collection.DataMap, zeroLevelDataMap, alwaysInclude) || strategy == BuildModelStartegy.ForChange;
               
                if (!needLoad)
                    continue;
                
                var attrbuteType = GetAttrbuteType(attribute);
                var dataMapItem = zeroLevelDataMap.FirstOrDefault(dm => dm.AttributeId == attribute.Id);
                var control = dataMapItem?.Control;
                var attributeName = !string.IsNullOrEmpty(control) ? control : attribute.Name;
                
                if (!attribute.ReferenceEntityId.HasValue)
                {
                    var attributeModel = AttributeModel.CreatePlainAttribute(attributeName, resultModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);
                    
                    resultModel.AddAttribute(attributeModel);
                }
                else
                {
                    var referencedContract = model.FirstOrDefault(m => m.Id.Equals(attribute.ReferenceEntityId.Value));

                    var referencedModel = ContractToDataModel(referencedContract);

                    //Get true PK type from model directly
                    attrbuteType = GetAttributeTypeForReference(referencedContract, attribute.IsNullable) ?? attrbuteType;

                    var attributeModel = AttributeModel.CreatePlainReferenceAttribute(attributeName, resultModel, referencedModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);

                    resultModel.AddAttribute(attributeModel);

                    if (strategy != BuildModelStartegy.ForChange)
                    {
                        var nextLevelDataMap = collection.DataMap?.Where(dm => dataMapItem != null && dm.ParentId == dataMapItem.Id).ToList();
                        if (nextLevelDataMap.Any())
                            RecursiveAddAllForForm(model, resultModel, referencedContract, collection.DataMap, nextLevelDataMap, attributeModel);
                    }
                }
            }

            return resultModel;

        }

        private static AttributeType GetAttrbuteType(MetadataAttribute attribute)
        {
            if (attribute.ReferenceEntityId.HasValue)
                return AttributeType.Get((typeof(Guid)), attribute.IsNullable); //TEMPORARY add GUID as most common case

            return AttributeType.Get(attribute.Type, attribute.IsNullable);
        }

        private static void RecursiveAddAllForForm(List<Metadata.DataModel> contracts, EntityModel rootModel, Metadata.DataModel currentContract, List<FormDataMap> dataMap,
            List<FormDataMap> thisLevelDataMap, AttributeModel parentAttribute)
        {
            var alwaysInclude = !string.IsNullOrEmpty(currentContract.ExtensionsContainerAttribute)
                ? new List<string> {currentContract.ExtensionsContainerAttribute}
                : new List<string>();
            
            foreach (var attribute in currentContract.Attributes)
            {
                if (!NeedLoad(attribute, dataMap, thisLevelDataMap, alwaysInclude))
                    continue;
                var dataMapItem = thisLevelDataMap.FirstOrDefault(dm => dm.AttributeId == attribute.Id);
                var control = dataMapItem?.Control;
                var attributeName = !string.IsNullOrEmpty(control) ? control : attribute.Name;
                var attrbuteType = GetAttrbuteType(attribute);
                var useNameAsPropertyName = !string.IsNullOrEmpty(control);

                if (!attribute.ReferenceEntityId.HasValue)
                {
                    var attributeModel = AttributeModel.CreateJoinedAttribute(attributeName, parentAttribute, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated,  attribute.IsExtension);
                    attributeModel.UseNameAsPropertyName = useNameAsPropertyName;
                    parentAttribute.AddChild(attributeModel);
                    rootModel.AddAttribute(attributeModel);
                }
                else
                {
                    var referencedContract = contracts.FirstOrDefault(m => m.Id.Equals(attribute.ReferenceEntityId.Value));

                    var referencedModel = ContractToDataModel(referencedContract);

                    //Get true PK type from model directly
                    attrbuteType = GetAttributeTypeForReference(referencedContract, attribute.IsNullable) ?? attrbuteType;

                    var attributeModel = AttributeModel.CreateJoinedReferenceAttribute(attributeName, parentAttribute, referencedModel, attrbuteType, attribute.Name,
                        attribute.IsVirtual, attribute.IsCalculated, attribute.IsExtension);
                    attributeModel.UseNameAsPropertyName = useNameAsPropertyName;
                    parentAttribute.AddChild(attributeModel);
                    rootModel.AddAttribute(attributeModel);

                    var nextLevelDataMap = dataMap.Where(dm => dataMapItem != null && dm.ParentId == dataMapItem.Id).ToList();
                    if (nextLevelDataMap.Any())
                        RecursiveAddAllForForm(contracts, rootModel, referencedContract, dataMap, nextLevelDataMap, attributeModel);
                }
            }
        }



        private static bool NeedLoad(MetadataAttribute attribute, List<FormDataMap> dataMap, List<FormDataMap> thisLevelDataMap, List<string> includeAlways)
        {
            if (includeAlways.Contains(attribute.Name))
                return true;
            var map = thisLevelDataMap.FirstOrDefault(dm => dm.AttributeId == attribute.Id);
            if (map == null)
                return false;
            if (map.IsLoadable)
                return true;
            return NeedLoad(map, dataMap);
        }

        private static bool NeedLoad(FormDataMap parent, List<FormDataMap> dataMap)
        {
            var children = dataMap.Where(dm => dm.ParentId == parent.Id).ToList();

            if (!children.Any())
                return false;

            foreach (var child in children)
            {
                if (child.IsLoadable)
                    return true;

                if (NeedLoad(child, dataMap))
                    return true;
            }

            return false;
        }



        #endregion
    }
}
