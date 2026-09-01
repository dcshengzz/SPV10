using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core
{
    /// <summary>
    /// Dynamic entity, properties can be accessed two ways
    /// de["propertyName"] or (de as dynamic).propertyName
    /// Property names are case sensitive
    /// </summary>
    public sealed class DynamicEntity : DynamicObject
    {
        // ReSharper disable once MemberCanBePrivate.Global
        internal bool ReadOnly { get; set; }

        private object _id;

        private object _clientId;
        
        private object _originalClientId; //for public api mapping purposes

        private void SetId(object value)
        {
            _id = value;
        }

        /// <summary>
        /// Returns the record Primary key, if the Primary key is not specified, returns null.
        /// </summary>
        /// <returns>Primary key value</returns>
        public object GetPrimaryKey()
        {
            return _id;
        }
        
        /// <summary>
        /// Returns the record Primary key, if the Primary key is not specified, then the generated client Id.
        /// </summary>
        /// <returns>Primary key or client identifier value</returns>
        public object GetId()
        {
            var value = _id ?? _clientId;
            if (value != null) return value;
            _clientId = ClientIdsProcessor.GenerateClientId();
            return _clientId;
        }

        /// <summary>
        /// Returns true is the entity has the Primary Key. Do not confuse it with Id, which is always there, but it can be client.
        /// </summary>
        public bool HasPrimaryKey => _id != null;

        public void SetClientId(object clientId)
        {
            _clientId = clientId;
            _originalClientId = clientId;
        }

        private string IdName { get; set; }

        public void SetIdName(string name)
        {
            IdName = name;
            if (HasProperty(name))
            {
                SetId(this[name]);
            }
            else
            {
                TrySetMember(name, null, true);
            }
        }

        private readonly Dictionary<string, object> _dictionary = new Dictionary<string, object>();

        private readonly HashSet<string> _changedProperties = new HashSet<string>();

        private readonly HashSet<string> _initializedProperties = new HashSet<string>();

        public IDictionary<string, object> Dictionary => _dictionary;
        
        
        public DynamicEntity (){}

        public DynamicEntity(Dictionary<string,object> properties)
        {
            if (properties != null)
                _dictionary = properties;
        }


        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            string name = binder.Name;//.ToLower();
            return _dictionary.TryGetValue(name, out result);
        }

        public bool TrySetMember(string name, object value, bool isPrimaryKey = false, bool suppressEventCall = false)
        {
            return TrySetMember(new CustomBinder(name), value, isPrimaryKey, suppressEventCall);
        }

        public bool TrySetMember(SetMemberBinder binder, object value, bool isPrimaryKey, bool suppressEventCall = false)
        {
            if (isPrimaryKey)
            {
                SetId(value);
                IdName = binder.Name;
            }
            else if (binder.Name.Equals(IdName, StringComparison.OrdinalIgnoreCase))
            {
                SetId(value);
            }
            return TrySetMemberInternal(binder, value, suppressEventCall);
        }

        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            return TrySetMemberInternal(binder, value,false);
        }

        private bool TrySetMemberInternal(SetMemberBinder binder, object value, bool suppressEventCall)
        {
            if (ReadOnly)
                return false;

            if (binder.Name.Equals(IdName, StringComparison.OrdinalIgnoreCase))
            {
                SetId(value);
            }

            object oldValue;

            var name = binder.Name; //.ToLower();

            if (!_dictionary.ContainsKey(name))
            {
                var customBunder = binder as CustomBinder;

                if (customBunder == null || !customBunder.IsNotInitialization)
                {
                    if (!_initializedProperties.Contains(name))
                        _initializedProperties.Add(name);
                }

                _dictionary.Add(name, value);
            }

            _dictionary.TryGetValue(name, out oldValue);


            _dictionary[name] = value;

            if ((oldValue == null && value != null) || (oldValue != null && value == null) || (oldValue != null && !oldValue.Equals(value)))
            {
                if (!suppressEventCall)
                {
                    PropertyChanged?.Invoke(this, new DynamicPropertyChangedEventArgs {Id = GetId(), NewValue = value, OldValue = oldValue, PropertyName = binder.Name});
                }

                if (!_changedProperties.Contains(name))
                    _changedProperties.Add(name);
            }

            return true;
        }

        internal event EventHandler<DynamicPropertyChangedEventArgs> PropertyChanged;

        public object GetProperty(string propertyName)
        {
            string name = propertyName;//.ToLower();
            _dictionary.TryGetValue(name, out var result);
            return result;
        }

        public object this[string propertyName]
        {
            set => TrySetMember(propertyName, value);
            get => GetProperty(propertyName);
        }
        
        public bool PropertyWasChanged(string propertyName)
        {
            string name = propertyName;//.ToLower();
            return _changedProperties.Contains(name);
        }

        public bool PropertyWasInitialized(string propertyName)
        {
            string name = propertyName;//.ToLower();
            return _initializedProperties.Contains(name);
        }

        public bool HasProperty(string propertyName)
        {
            string name = propertyName;//.ToLower();
            return _dictionary.ContainsKey(name);
        }

        public void MergeProperties(DynamicEntity dynamicEntity, bool ignoreNotChanged) 
        {
            if (Equals(dynamicEntity))
                return;

            if (!CheckIsSameType(dynamicEntity))
                throw new DynamicEntitiesException("The dynamic entities have a different set of properties. Hence they are of different types. Merge is impossible.");

            MergePropertiesPrivate(dynamicEntity,ignoreNotChanged);
        }

        private void MergePropertiesPrivate(DynamicEntity dynamicEntity, bool ignoreNotChanged)
        {
            foreach (var theirsProperty in dynamicEntity._dictionary)
            {

                if (theirsProperty.Value is IEnumerable<DynamicEntity> theirsEntities)
                {
                    var minePropertyValue = this[theirsProperty.Key];

                    if (minePropertyValue == null || theirsProperty.Value == null)
                    {
                        TrySetMember(new CustomBinder(theirsProperty.Key), theirsProperty.Value);
                    }
                    else
                    {
                        if (minePropertyValue is IEnumerable<DynamicEntity> mineEntities)
                        {
                            var dynamicEntities = mineEntities as IList<DynamicEntity> ?? mineEntities.ToList();
                            foreach (var theirsEntity in theirsEntities)
                            {
                                var mineEntity = dynamicEntities.FirstOrDefault(me => me.GetId() == theirsEntity.GetId());
                                if (mineEntity != null)
                                    mineEntity.MergeProperties(theirsEntity, ignoreNotChanged);
                                else
                                    dynamicEntities.Add(theirsEntity);
                            }
                            
                            TrySetMember(new CustomBinder(theirsProperty.Key), dynamicEntities); 
                        }
                        else
                        {
                            throw new DynamicEntitiesException("The dynamic entities have a different set of properties. Hence they are of different types. Merge is impossible.");
                        }
                    }
                }
                else
                {

                    if (ignoreNotChanged && !dynamicEntity._changedProperties.Contains(theirsProperty.Key) && !dynamicEntity._initializedProperties.Contains(theirsProperty.Key))
                        continue;


                    TrySetMember(new CustomBinder(theirsProperty.Key), theirsProperty.Value);
                }
            }
        }

        public bool CheckIsSameType(DynamicEntity dynamicEntity)
        {
            foreach (var theirsProperty in dynamicEntity._dictionary)
            {
                if (!_dictionary.ContainsKey(theirsProperty.Key))
                    return false;

                var mineValue = _dictionary[theirsProperty.Key];
                var theirsValue = theirsProperty.Value;
                
                if (mineValue == null || theirsValue == null) //We can't compare types in this case
                    continue;

                if (mineValue is IEnumerable<DynamicEntity> mineEntities)
                {
                    if (theirsValue is IEnumerable<DynamicEntity> theirsEntities)
                    {
                        var dynamicEntities = mineEntities as IList<DynamicEntity> ?? mineEntities.ToList();
                        var enumerable = theirsEntities as IList<DynamicEntity> ?? theirsEntities.ToList();
                        if (!dynamicEntities.Any() || (!enumerable.Any()))  //We can't compare types in this case
                            continue;
                        if (!dynamicEntities.First().CheckIsSameType(enumerable.First()))
                            return false;
                    }
                }

                if (!mineValue.GetType().IsInstanceOfType(theirsValue))
                {
                    List<Type> compInt = new List<Type>(){typeof (Int16),
                                                        typeof (Int32),
                                                        typeof (Int64),
                                                        typeof (Byte)};

                    if (compInt.Contains(mineValue.GetType()) && compInt.Contains(theirsValue.GetType()))
                        continue;
                    return false;
                }
            }

            return true;
        }

        public string Serialize(bool addSystemFields = false)
        {
            return JsonConvert.SerializeObject(ToDictionary(addSystemFields));
        }
        public string SerializeWithIndentation(bool addSystemFields = false)
        {
            return JsonConvert.SerializeObject(ToDictionary(addSystemFields), Formatting.Indented);
        }

        public Dictionary<string, object> ToDictionary(bool addSystemFields = false)
        {
            var de = _dictionary.Where(kvp => kvp.Value is List<DynamicEntity>).ToDictionary(kvp => kvp.Key, kvp => kvp.Value as List<DynamicEntity>);
            if (!de.Any())
            {
                var ds = _dictionary.ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
                if (addSystemFields)
                    ds.Add("__id", GetPrimaryKey());
                return ds;
            }
            else
            {
                var ds = _dictionary.Where(kvp => !de.ContainsKey(kvp.Key)).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

                if (addSystemFields)
                    ds.Add("__id", GetPrimaryKey());

                foreach (var deKvp in de)
                {
                    ds.Add(deKvp.Key, deKvp.Value.Select(v => v.ToDictionary(addSystemFields)));
                }

                return ds;
            }
        }

        public static DynamicEntity ParseJSON(string json)
        {
            Dictionary<string, object> props = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
            return new DynamicEntity(props);
        }

        public (object primaryKey, object clientId, object originalClientId) GetClientIdAndPrimaryKey()
        {
            return (_id, _clientId, _originalClientId);
        }
    }
}
