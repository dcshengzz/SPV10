using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.View
{
    public sealed class DynamicEntityDeserializer
    {
        private DictionaryToDynamicMapper _mainMapper;
        private EntityModel _model;

        public DynamicEntityDeserializer(EntityModel model)
        {
            _mainMapper = new DictionaryToDynamicMapper(model);
            _model = model;
        }

        public List<DynamicEntity> DeserializeList(string json, EntityModel model, bool fillClientId = false,
            bool initMissingFields = false)
        {
            return DeserializeList(json, model, _mainMapper, fillClientId: fillClientId, initMissingFields: initMissingFields);
        }

        private List<DynamicEntity> DeserializeList(string json, EntityModel model, DictionaryToDynamicMapper mapper,
            bool fillClientId = false, bool initMissingFields = false)
        {
            var rawValues = new List<Dictionary<string, JToken>>();
            var rawList = JsonConvert.DeserializeObject<List<JRaw>>(json);
            foreach (var raw in rawList)
            {
                rawValues.Add(JsonConvert.DeserializeObject<Dictionary<string, JToken>>(raw.ToString()));
            }

            if (fillClientId && model.HasPrimaryKey)
            {
                foreach (var rawValue in rawValues)
                {
                    var rawPkAttributeName = rawValue?.Keys.FirstOrDefault(k => k.Equals(model.PrimaryKeyAttributeName, StringComparison.OrdinalIgnoreCase));
                    if (rawPkAttributeName != null)
                    {
                        var jToken = rawValue[rawPkAttributeName];
                        if (jToken != null && jToken.Type == JTokenType.String && jToken.Value<string>().StartsWith("client_", StringComparison.OrdinalIgnoreCase))
                        {
                            rawValue[rawPkAttributeName] = null;
                            rawValue["__id"] = jToken;
                        }
                    }

                }
            }

            return GetDynamicEntities(model, mapper, rawValues, fillClientId, initMissingFields);
        }

        private List<DynamicEntity> GetDynamicEntities(EntityModel model, DictionaryToDynamicMapper mapper, List<Dictionary<string, JToken>> rawValues,
            bool fillClientId = false, bool initMissingFields = false)
        {
            if (model == null)
                model = _model;
            if (mapper == null)
                mapper = _mainMapper;


            var result = mapper.Map(rawValues, useParse: true, initMissingFields: initMissingFields);

            if (!model.HasCollections)
                return result;

            foreach (var de in result)
            {
                foreach (var collection in model.Collections)
                {
                    if (de.HasProperty(collection.Name))
                        de[collection.Name] = DeserializeList(de[collection.Name].ToString(), collection.Model, new DictionaryToDynamicMapper(collection.Model),
                            fillClientId: fillClientId, initMissingFields: initMissingFields);
                }
            }

            return result;
        }


        public DynamicEntity DeserializeSingle(string json, bool initMissingFields = false)
        {
            var rawValues = new List<Dictionary<string, JToken>>
            {
                JsonConvert.DeserializeObject<Dictionary<string, JToken>>(json, new JsonSerializerSettings
                {
                    DateParseHandling = DateParseHandling.None
                })
            };
            return GetDynamicEntities(_model, _mainMapper, rawValues, initMissingFields: initMissingFields).First();
        }

    }

    public sealed class DictionaryToDynamicMapper
    {
        private readonly EntityModel _model;

        public DictionaryToDynamicMapper(EntityModel model)
        {
            _model = model;
        }

        public DictionaryToDynamicMapper(string formName)
        {
            _model = DynamicRepository.GetMetadataByForm(formName).Result;
        }

        public List<DynamicEntity> Map(IDictionary<string, object> value)
        {
            return Map(new List<IDictionary<string, object>> {value});
        }

        public List<DynamicEntity> Map(IEnumerable<IDictionary<string, object>> values)
        {
            return MapDictionary(values, true, true);
        }

        public List<DynamicEntity> Map(IEnumerable<IDictionary<string, object>> values, bool useParse, bool initMissingFields)
        {
            return MapDictionary(values, useParse, initMissingFields);
        }

        public List<DynamicEntity> Map(IEnumerable<IDictionary<string, JToken>> values, bool useParse, bool initMissingFields)
        {
            return MapDictionary(values, useParse, initMissingFields);
        }

        private List<DynamicEntity> MapDictionary(IEnumerable<IDictionary<string, JToken>> values, bool useParse, bool initMissingFields)
        {
            bool CheckIsEmpty(JToken value)
            {
                return value == null || value.Type == JTokenType.Null;
            }

            object GetValue(JToken value)
            {
                if (value is JArray jArray)
                    return JsonConvert.SerializeObject(jArray);
                if (value is JObject jObject)
                    return JsonConvert.SerializeObject(jObject);
                if (value.Type == JTokenType.Boolean)
                    return value.Value<bool>();
                if (value.Type == JTokenType.Date)
                    return value.Value<DateTime>();
                if (value is JValue jValue)
                    return jValue.ToString(CultureInfo.InvariantCulture);
                return value;
            }

            return MapAlgorithm(values, CheckIsEmpty, GetValue, (useParse, initMissingFields));
        }

        private List<DynamicEntity> MapDictionary(IEnumerable<IDictionary<string, object>> values, bool useParse, bool initMissingFields)
        {
            bool CheckIsEmpty(object value)
            {
                return value == DBNull.Value || value == null ||
                       value is string str && string.IsNullOrEmpty(str);
            }

            return MapAlgorithm(values, CheckIsEmpty, (v) => v, (useParse, initMissingFields));
        }

        private List<DynamicEntity> MapAlgorithm<T>(IEnumerable<IDictionary<string, T>> values, Func<T, bool> checkIsEmpty, Func<T, object> getValue,
            (bool useParse, bool initMissingFields) parameters)
        {
            var returnValue = new List<DynamicEntity>();

            var collections = new HashSet<string>();
            foreach (var modelCollection in _model.Collections)
            {
                collections.Add(modelCollection.Name.ToLower());
            }

            foreach (var entityInDictionary in values)
            {
                var dynamicEntity = new DynamicEntity();

                foreach (var property in entityInDictionary)
                {
                    if (property.Key.StartsWith("__")) //Set clientId to entity
                    {

                        if (property.Key.Equals("__id", StringComparison.OrdinalIgnoreCase))
                        {
                            var value = property.Value?.ToString();
                            if (ClientIdsProcessor.IsClientId(value))
                            {
                                dynamicEntity.SetClientId(value);
                            }
                        }

                        continue;
                    }

                    if (collections.Contains(property.Key.ToLower()))
                    {
                        dynamicEntity[property.Key] = property.Value;
                        continue;
                    }


                    var attribute = _model.GetAttributeByName(property.Key);

                    if (attribute == null)
                        continue;

                    var isEmpty = checkIsEmpty(property.Value);

                    if (isEmpty)
                    {
                        if (!attribute.IsVersion)
                            dynamicEntity.TrySetMember(new CustomBinder(property.Key), null, attribute.IsMainPrimaryKey);
                    }
                    else
                    {
                        try
                        {
                            var value = getValue(property.Value);
                            if (parameters.useParse)
                            {
                                dynamicEntity.TrySetMember(new CustomBinder(property.Key),
                                    attribute.Type.ParseToCLRType(value),
                                    attribute.IsMainPrimaryKey);
                            }
                            else
                            {
                                dynamicEntity.TrySetMember(new CustomBinder(property.Key),
                                    attribute.Type.CastToCLRType(value),
                                    attribute.IsMainPrimaryKey);
                            }

                        }
                        catch (DynamicEntitiesParseException entitiesParseException)
                        {
                            throw new DynamicEntitiesMapException(_model.Name, property.Key, entitiesParseException.Message, entitiesParseException);
                        }
                    }
                }

                if (parameters.initMissingFields)
                    _model.AddMissingProperties(dynamicEntity, parameters.initMissingFields);

                returnValue.Add(dynamicEntity);
            }



            return returnValue;
        }

    }
}
