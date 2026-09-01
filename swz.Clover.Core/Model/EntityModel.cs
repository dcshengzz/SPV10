using System;
using System.Collections.Generic;
using System.Linq;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Model
{

    public class DataModel 
    {
        public DataModel(string name, string schemaName, string tableName)
        {
            Name = string.IsNullOrEmpty(name) ? throw new ArgumentNullException(nameof(name)) : name;
            SchemaName = string.IsNullOrEmpty(schemaName) ? CloverRuntime.DbProvider.DefaultSchemaName : schemaName;
            TableName = string.IsNullOrEmpty(tableName) ? throw new ArgumentNullException(nameof(tableName)) : tableName;
            IsVirtual = false;
        }

        public DataModel(string name)
        {
            Name = name ?? throw new ArgumentNullException(nameof(name));
            IsVirtual = true;
        }

        public bool IsVirtual { get; }

        public string Name { get; }

        public string SchemaName { get; }

        public string TableName { get; }

        public string PrimaryKeyAttributeName { get; set; }

        public bool HasPrimaryKey => !string.IsNullOrEmpty(PrimaryKeyAttributeName);

       
        public string VersionAttributeName { get; set; }

        public bool HasVersionAttribute => !string.IsNullOrEmpty(VersionAttributeName);
        
        public string LogicalDeleteAttributeName { get; set; }

        public bool HasLogicalDeleteAttribute => !string.IsNullOrEmpty(LogicalDeleteAttributeName);
        
        public string ExtensionsContainerAttributeName { get; set; }
        public bool HasExtensionsContainerAttribute => !string.IsNullOrEmpty(ExtensionsContainerAttributeName);

        public bool IsSameTable(DataModel model)
        {
            return string.Equals(SchemaName, model.SchemaName, StringComparison.Ordinal) && 
                TableName.Equals(model.TableName, StringComparison.Ordinal);
        }

    }

    public sealed class EntityModel : DataModel
    {
        public string DataUrl = null;
        
        public string SourceDataModelName { get; private set; }

        private Dictionary<TriggerCallType, List<(string Name, dynamic Options)>> _triggers;

        internal void AddTrigger(string name, TriggerCallType callType, dynamic options)
        {
            if (_triggers == null)
                _triggers = new Dictionary<TriggerCallType, List<(string Name, dynamic Options)>>();
            if (!_triggers.ContainsKey(callType))
                _triggers[callType] = new List<(string Name, dynamic Options)>();
            _triggers[callType].Add((name,options));
        }

        public IEnumerable<(string Name, dynamic Options)> GetTriggers(TriggerCallType callType)
        {
            if (_triggers == null || !_triggers.ContainsKey(callType))
                return new List<(string Name, dynamic Options)>();
            return _triggers[callType];
        }
        

        public EntityModel(string name, string sourceDataModelName, string schemaName, string tableName) : base (name,schemaName,tableName)
        {
            SourceDataModelName = sourceDataModelName;
        }
        
        public EntityModel(string name, string schemaName, string tableName) : base (name,schemaName,tableName)
        {
            SourceDataModelName = name;
        }

        public EntityModel(string name) : base(name)
        {
            SourceDataModelName = name;
        }

        private readonly List<PlainAttributeModel> _plainAttributes = new List<PlainAttributeModel>();

        private readonly List<JoinedAttributeModel> _joinedAttributes = new List<JoinedAttributeModel>();
        
        private readonly List<CollectionModel> _collections = new List<CollectionModel>();

        public void AddAttribute(AttributeModel attribute)
        {
            if (attribute is PlainAttributeModel plain)
            {
                _plainAttributes.Add(plain);
                //plain.DataModel = this;
                return;
            }

            if (attribute is JoinedAttributeModel joined)
            {
                _joinedAttributes.Add(joined);
                //joined.DataModel = this;
            }
        }

        public IEnumerable<PlainAttributeModel> PlainAttributes => _plainAttributes;


        public IEnumerable<PlainAttributeModel> PlainAttributesForSelectQuery
        {
            get { return _plainAttributes.Where(attribute => !attribute.IsVirtual); }
        }

        public IEnumerable<JoinedAttributeModel> JoinedAttributes => _joinedAttributes;


        public IEnumerable<JoinedAttributeModel> JoinedAttributesForSelectQuery
        {
            get { return _joinedAttributes.Where(attribute => !attribute.IsVirtual).OrderBy(a=>a.Level); }
        }

        public IEnumerable<AttributeModel> Attributes
        {
            get
            {
                return
                    _joinedAttributes.Select(attribute => attribute as AttributeModel).Concat(
                        _plainAttributes.Select(attribute => attribute as AttributeModel));
            }
        }

        public IEnumerable<CollectionModel> Collections => _collections;

        public object GetAsync(object filter, Order orderByName)
        {
            throw new NotImplementedException();
        }

        public void AddCollection(CollectionModel collection)
        {
            _collections.Add(collection);
        }

        public AttributeModel GetAttributeByName(string propertyName)
        {
            return Attributes.FirstOrDefault(a => a.PropertyName.Equals(propertyName, StringComparison.OrdinalIgnoreCase));
        }

        public AttributeModel PrimaryKeyAttribute
        {
            get
            {
                var res = _plainAttributes.Where(p => p.PropertyName.Equals(PrimaryKeyAttributeName,StringComparison.OrdinalIgnoreCase)).ToList();
                if (!res.Any())
                    return null;
                if (res.Count > 1)
                    throw new DynamicEntitiesModelException(Name,$"The {PrimaryKeyAttributeName} attribute is present in the model more than once.");
                return res.Single();
            }
        }


        public AttributeModel VersionAttribute
        {
            get
            {
                var res = _plainAttributes.Where(p => p.PropertyName.Equals(VersionAttributeName,StringComparison.OrdinalIgnoreCase)).ToList();
                if (!res.Any())
                    return null;
                if (res.Count > 1)
                    throw new DynamicEntitiesModelException(Name,$"The {VersionAttributeName} attribute is present in the model more than once.");
                return res.Single();
            }
        }

        public AttributeModel LogicalDeleteAttribute
        {
            get
            {
                var res =  _plainAttributes.Where(p => p.PropertyName.Equals(LogicalDeleteAttributeName,StringComparison.OrdinalIgnoreCase)).ToList();
                if (!res.Any())
                    return null;
                if (res.Count > 1)
                    throw new DynamicEntitiesModelException(Name,$"The {LogicalDeleteAttributeName} attribute is present in the model more than once.");
                return res.Single();
            }
        }

        public AttributeModel ExtensionsContainerAttribute
        {
            get
            {
                var res = _plainAttributes.Where(p => p.PropertyName.Equals(ExtensionsContainerAttributeName,StringComparison.OrdinalIgnoreCase)).ToList();
                if (!res.Any())
                    return null;
                if (res.Count > 1)
                    throw new DynamicEntitiesModelException(Name,$"The {ExtensionsContainerAttributeName} attribute is present in the model more than once.");
                return res.Single();
            }
        }
      
        public void AddMissingProperties(DynamicEntity entity, bool initFields = false)
        {
            foreach (var attribute in Attributes)
            {
                if (!entity.HasProperty(attribute.PropertyName))
                {
                    AddProperty(entity, attribute, initFields);
                }
            }
        }

        public DynamicEntity GetIntializedObject(bool readOnly = false, bool initFields = false)
        {
            var entity = new DynamicEntity {ReadOnly = readOnly};


            foreach (var attribute in Attributes)
            {
                AddProperty(entity, attribute, initFields);
            }

        
           
            foreach (var collection in Collections)
            {
                var binder = new CustomBinder(collection.Name) {IsNotInitialization = true};
                if (initFields)
                {
                    entity.TrySetMember(binder, new List<DynamicEntity>(), false);
                }
                else
                {
                    entity.TrySetMember(binder, null, false);
                }
 
            }
            
            return entity;
        }

        private static void AddProperty(DynamicEntity entity, AttributeModel attribute, bool initFields)
        {
            var binder = new CustomBinder(attribute.PropertyName) {IsNotInitialization = true};

            if (attribute.IsMainPrimaryKey)
            {
                entity.TrySetMember(binder, null, true);
            }
            else if (attribute.IsVersion)
            {
                entity.TrySetMember(binder, null);
            }
            else
            {
                if (initFields)
                {
                    entity.TrySetMember(binder,
                        attribute.Type.IsNullable ? attribute.Type.ParseToCLRType(null) : attribute.Type.CLRType.GetDefaultValue());
                }
                else
                {
                    entity.TrySetMember(binder, null);
                }
            }
        }

        public bool HasExtensions => Attributes.Any(a => a.IsExtension);
        
        public bool HasCollections => Collections.Any();

        public bool HasCollectionWithName(string name)
        {
            return HasCollections && Collections.Any(c => c.Name.Equals(name, StringComparison.Ordinal));
        }

        public CollectionModel GetCollectionModelWithName(string name)
        {
            return Collections.FirstOrDefault(c => c.Name.Equals(name, StringComparison.Ordinal));
        }

        /// <summary>
        /// Returns true if the Model hasn't any Attribute or Collection
        /// </summary>
        public bool IsEmptpy
        {
            get { return !Attributes.Any() && (!_collections.Any() || _collections.All(c => c.Model.IsEmptpy)); }
        }
        
        /// <summary>
        /// Returns true if the Model has at least one Plain (not Joined) Calculated Attribute (Computed column)
        /// </summary>
        public bool HasPlainCalculatedAttributes => PlainAttributes.Any(a => a.IsCalculated);

        /// <summary>
        /// Returns all Plain (not Joined) Calculated Attributes (Computed columns)
        /// </summary>
        /// <returns></returns>
        public List<PlainAttributeModel> GetPlainCalculatedAttributes()
        {
            return PlainAttributes.Where(a => a.IsCalculated).ToList();
        }
    }
}
