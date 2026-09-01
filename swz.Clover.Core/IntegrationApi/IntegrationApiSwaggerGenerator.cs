using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;
using YamlDotNet.Serialization;

namespace swz.Clover.Core.IntegrationApi
{
    public static class IntegrationApiSwaggerGenerator
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(IntegrationApiSwaggerGenerator));

        public static async Task<string> GenerateAsync(Dictionary<string, string> parameters, string baseUrl)
        {
            var allModels = false;
            var allForms = false;
            string name = null;
            var mode = IntegrationApiMode.Model;

            if (!parameters.ContainsKey(IntegrationApiKeys.Mode))
            {
                allModels = true;
                allForms = true;
            }
            else
            {

                Enum.TryParse(parameters[IntegrationApiKeys.Mode], true, out mode);
                if (parameters.ContainsKey(IntegrationApiKeys.Name))
                    name = parameters[IntegrationApiKeys.Name];
                if (mode == IntegrationApiMode.Form && string.IsNullOrEmpty(name))
                    allForms = true;
                if (mode == IntegrationApiMode.Model && string.IsNullOrEmpty(name))
                    allModels = true;
            }


            var baseUri = new Uri(baseUrl);
            var isHttps = baseUri.Scheme == Uri.UriSchemeHttps;

            var swaggerDocument = new SwaggerDocument
            {
                info = new SwaggerInfo()
                {
                    version = Assembly.GetExecutingAssembly().GetName().Version.ToString(),
                    contact = new SwaggerContact()
                    {
                        name = "swz",
                        url = "http://softworkz.net/",
                        email = "sales@softworkz.net"
                    },
                    description = "CLOVER integration API",
                    license = new SwaggerLicense()
                    {
                        name = "CLOVER EULA 1.0",
                        url = "http://softworkz.net/agreements/eula/"
                    },
                    termsOfService = "http://softworkz.net/",
                    title = "CLOVER integration API"
                },
                host = baseUrl,
                basePath = IntegrationApiPath.ApiPath,
                schemes = isHttps ? new List<string> {"https"} : new List<string> {"http"},
                consumes = new List<string> {"application/json"},
                produces = new List<string> {"application/json"},
                paths = new Dictionary<string, SwaggerPath>(),
                definitions = new Dictionary<string, SwaggerSchema>()
            };

            if (allForms || allModels)
            {
                var dataModelQuery = new MetadataSectionQuery(MetadataSections.Datamodel);
                var formModelQuery = new MetadataSectionQuery(MetadataSections.Form);
                var applicationMetadata = await CloverRuntime.Metadata.PartialMetadata(new List<MetadataSectionQuery> {dataModelQuery, formModelQuery}).ConfigureAwait(false);


                if (allModels)
                {
                    foreach (var modelName in applicationMetadata.DataModel.Select(f => f.Name))
                    {
                        await GenerateAndAddForModel(modelName, swaggerDocument);
                    }
                }

                if (allForms)
                {
                    foreach (var formName 
                        in applicationMetadata.Forms.Where(f=>f.DataMap != null && f.DataMap.Any() || f.DataColl != null && f.DataColl.Any() )
                            .Select(f => f.Name))
                    {
                        try
                        {
                            await GenerateAndAddForForm(formName, swaggerDocument);
                        }
                        catch(DynamicEntitiesException dee)
                        {
                            if((dee.Message ?? "").StartsWith("Model") && (dee.Message ?? "").EndsWith("not found"))
                            {
                                Logger.LogWarning("Ignoring formName {0} because {1}", formName, dee.Message);
                            }
                        }
                    }
                }

            }
            else
            {
                switch (mode)
                {
                    case IntegrationApiMode.Form:
                        await GenerateAndAddForForm(name, swaggerDocument);
                        break;
                    case IntegrationApiMode.Model:
                        await GenerateAndAddForModel(name, swaggerDocument);
                        break;
                    default:
                        throw new Exception("Unknown api mode, must be form or model");
                }
            }


            AddCommonDefinitions(swaggerDocument);

            var serializer = new SerializerBuilder().Build();
            return serializer.Serialize(swaggerDocument);
        }

        private static void AddCommonDefinitions(SwaggerDocument swaggerSwaggerDocument)
        {
            var schemes = swaggerSwaggerDocument.definitions;

            //GetRequest

            var getRequest = new SwaggerSchema
            {
                type = "object",
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            getRequest.properties.Add(IntegrationApiKeys.Filter, new SwaggerCollectionSchemaProperty("FilterItem"));

            getRequest.properties.Add(IntegrationApiKeys.Order, new SwaggerCollectionSchemaProperty("SortItem"));

            getRequest.properties.Add(IntegrationApiKeys.Skip, new SwaggerPlainSchemaProperty()
            {
                type = "integer",
                format = "int64"
            });

            getRequest.properties.Add(IntegrationApiKeys.Take, new SwaggerPlainSchemaProperty()
            {
                type = "integer",
                format = "int64"
            });

            schemes.Add("GetRequest", getRequest);

            //DeleteRequest
            var deleteRequest = new SwaggerSchema
            {
                type = "object",
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            deleteRequest.properties.Add(IntegrationApiKeys.Ids, new SwaggerCollectionTypeProperty("string", null));

            deleteRequest.properties.Add(IntegrationApiKeys.Filter, new SwaggerCollectionSchemaProperty("FilterItem"));

            schemes.Add("DeleteRequest", deleteRequest);

            //FilterItem
            var filterItem = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"Columns", "Term", "Value"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            filterItem.properties.Add("Columns", new SwaggerCollectionTypeProperty("string", null));

            filterItem.properties.Add("Term", new SwaggerPlainSchemaProperty
            {
                type = "string"
            });

            filterItem.properties.Add("Value", new SwaggerPlainSchemaProperty
            {
                type = "string"
            });

            schemes.Add("FilterItem", filterItem);


            //SortItem 
            var sortItem = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"Column", "Order"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            sortItem.properties.Add("Column", new SwaggerPlainSchemaProperty
            {
                type = "string"
            });

            sortItem.properties.Add("Order", new SwaggerEnumSchemaProperty
            {
                type = "string",
                @enum = new List<object> {"Asc", "Desc"}
            });

            schemes.Add("SortItem", sortItem);

            //responses 
            //ChangeResponse
            
            var сhangeResponse = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"success"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };
            
            сhangeResponse.properties.Add("success",new SwaggerPlainSchemaProperty(){type = "boolean"});
            сhangeResponse.properties.Add("error",new SwaggerPlainSchemaProperty(){type = "string"});
            сhangeResponse.properties.Add("message",new SwaggerPlainSchemaProperty(){type = "string"});
            сhangeResponse.properties.Add("data",new SwaggerPlainObjectSchemaProperty("ChangeResponseData"));

            schemes.Add("ChangeResponse", сhangeResponse);
            
            var сhangeResponseData = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"inserted", "updated"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            сhangeResponseData.properties.Add("inserted", new SwaggerPlainSchemaProperty()
            {
                type = "integer",
                format = "int32"
            });

            сhangeResponseData.properties.Add("updated", new SwaggerPlainSchemaProperty()
            {
                type = "integer",
                format = "int32"
            });

            сhangeResponseData.properties.Add("originalIds", new SwaggerCollectionTypeProperty("string", null));

            сhangeResponseData.properties.Add("insertedIds", new SwaggerCollectionTypeProperty("string", null));

            schemes.Add("ChangeResponseData", сhangeResponseData);

            //DeleteResponse
            
            var deleteResponse = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"success"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };
            
            deleteResponse.properties.Add("success",new SwaggerPlainSchemaProperty(){type = "boolean"});
            deleteResponse.properties.Add("error",new SwaggerPlainSchemaProperty(){type = "string"});
            deleteResponse.properties.Add("message",new SwaggerPlainSchemaProperty(){type = "string"});
            deleteResponse.properties.Add("data",new SwaggerPlainObjectSchemaProperty("DeleteResponseData"));

            schemes.Add("DeleteResponse", deleteResponse);

            var deleteResponseData = new SwaggerSchema
            {
                type = "object",
                required = new List<string> {"deleted"},
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            deleteResponseData.properties.Add("deleted", new SwaggerPlainSchemaProperty()
            {
                type = "integer",
                format = "int32"
            });


            schemes.Add("DeleteResponseData", deleteResponseData);
        }


        private static async Task GenerateAndAddForModel(string name, SwaggerDocument swaggerSwaggerDocument)
        {
            var getModel = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 1, true);
            var changeModel = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 0, true);
            var paths = swaggerSwaggerDocument.paths;
            var schemes = swaggerSwaggerDocument.definitions;
            GenerateAndAdd(name, paths, getModel, schemes, changeModel, IntegrationApiMode.Model);
        }

        private static async Task GenerateAndAddForForm(string name, SwaggerDocument swaggerSwaggerDocument)
        {
            var getModel = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null, true, BuildModelStartegy.ForGet));
            var changeModel = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null, true, BuildModelStartegy.ForChange));
            var paths = swaggerSwaggerDocument.paths;
            var schemes = swaggerSwaggerDocument.definitions;
            GenerateAndAdd(name, paths, getModel, schemes, changeModel, IntegrationApiMode.Form);
        }

        private static void GenerateAndAdd(string name, Dictionary<string, SwaggerPath> paths, EntityModel getModel, Dictionary<string, SwaggerSchema> schemes,
            EntityModel changeModel, IntegrationApiMode modeEnum)
        {
            var mode = modeEnum.ToString("G");
            //api/get/{mode}/{name}/{id}
            //get
            var url = $"/get/{mode}/{name}/{{id}}";

            var getItemSchema = $"{name}{mode}Get";
            var changeItemSchema = $"{name}{mode}Change";

            var path = new SwaggerPath()
            {
                get = new SwaggerMethod(GetItemsSchemaName(getItemSchema), $"{name} {mode} Items")
                {
                    operationId = $"Get{name}{mode}ById",
                    description = $"Get {name} {mode} by id",
                    parameters = new List<SwaggerParameter>
                    {
                        new SwaggerPathParameter()
                        {
                            type = "string",
                            name = "id",
                            required = true,
                        },
                        new SwaggerQueryParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.ApiKey,
                            required = false,
                        },
                        new SwaggerHeaderParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.HeaderApiKey,
                            required = false,
                        }
                    }
                }
            };

            paths.Add(url, path);

            //api/get/{mode}/{name}/
            //post
            url = $"/get/{mode}/{name}";

            path = new SwaggerPath()
            {
                post = new SwaggerMethod(GetItemsSchemaName(getItemSchema), $"{name} {mode} Items")
                {
                    operationId = $"Get{name}{mode}",
                    description = $"Get {name} {mode} with request",
                    parameters = new List<SwaggerParameter>
                    {
                        new SwaggerQueryParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.ApiKey,
                            required = false,
                        },
                        new SwaggerHeaderParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.HeaderApiKey,
                            required = false,
                        },
                        new SwaggerBodyParameter("GetRequest")
                        {
                            name = "GetRequest",
                            required = true,
                        }                        
                    }
                }
            };

            paths.Add(url, path);

            //api/change/{mode}/{name}/
            //post
            url = $"/change/{mode}/{name}";

            path = new SwaggerPath()
            {
                post = new SwaggerMethod("ChangeResponse", "Change response")
                {
                    operationId = $"Change{name}{mode}",
                    description = $"Change {name} {mode}",
                    parameters = new List<SwaggerParameter>
                    {
                        new SwaggerQueryParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.ApiKey,
                            required = false,
                        },
                        new SwaggerHeaderParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.HeaderApiKey,
                            required = false,
                        },
                        new SwaggerBodyParameter(GetItemsSchemaName(changeItemSchema))
                        {
                            name = "ChangeDataRequest",
                            required = true,
                        }
                    }
                }
            };

            paths.Add(url, path);

            //api/delete/{mode}/{name}/{id}
            //post

            url = $"/delete/{mode}/{name}/{{id}}";

            path = new SwaggerPath()
            {
                post = new SwaggerMethod("DeleteResponse", "Delete response")
                {
                    operationId = $"Delete{name}{mode}ById",
                    description = $"Delete {name} {mode} by id",
                    parameters = new List<SwaggerParameter>
                    {
                        new SwaggerPathParameter()
                        {
                            type = "string",
                            name = "id",
                            required = true,
                        },
                        new SwaggerQueryParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.ApiKey,
                            required = false,
                        },
                        new SwaggerHeaderParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.HeaderApiKey,
                            required = false,
                        },
                    }
                }
            };

            paths.Add(url, path);

            //api/delete/{mode}/{name}/
            //post
            url = $"/delete/{mode}/{name}/";
            path = new SwaggerPath()
            {
                post = new SwaggerMethod("DeleteResponse", "Delete response")
                {
                    operationId = $"Delete{name}{mode}",
                    description = $"Delete {name} {mode}",
                    parameters = new List<SwaggerParameter>
                    {
                        new SwaggerQueryParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.ApiKey,
                            required = false,
                        },
                        new SwaggerHeaderParameter()
                        {
                            type = "string",
                            name = IntegrationApiKeys.HeaderApiKey,
                            required = false,
                        },
                        new SwaggerBodyParameter("DeleteRequest")
                        {
                            name = "DeleteRequest",
                            required = true,
                        }
                    }
                }
            };

            paths.Add(url, path);

            //form getItemSchema

            AddSchema(getItemSchema, getModel, schemes, false);
            AddSchema(changeItemSchema, changeModel, schemes, true);
        }

        private static void AddSchema(string name, EntityModel model, Dictionary<string, SwaggerSchema> schemes, bool isChange, EntityModel parent = null)
        {
            var itemSchemaName = $"{name}Item";
            var isCollection = parent != null;
            if (!isCollection)
            {
                var items = new SwaggerSchema()
                {

                    type = "object",
                    required = new List<string>(),
                    properties = new Dictionary<string, SwaggerSchemaProperty>()
                };

                if (!isChange)
                {
                    items.required.Add("success");
                    items.properties.Add("success", new SwaggerPlainSchemaProperty() {type = "boolean"});
                    items.properties.Add("error", new SwaggerPlainSchemaProperty() {type = "string"});
                    items.properties.Add("message", new SwaggerPlainSchemaProperty() {type = "string"});
                }

                items.required.Add("data");
                items.properties.Add("data", new SwaggerCollectionSchemaProperty(itemSchemaName));

                schemes.Add(GetItemsSchemaName(name), items);
            }

            var schema = new SwaggerSchema
            {
                type = "object",
                required = new List<string>(),
                properties = new Dictionary<string, SwaggerSchemaProperty>()
            };

            //attributes
            var attributes = model.Attributes.Where(a => !a.IsExtensionsContainer).OrderBy(a => a.PropertyName).ToList();

            foreach (var attribute in attributes)
            {
                var isCollectionFk = isCollection && attribute.IsReference && attribute.ReferencedDataModel.IsSameTable(parent);
                if (isCollectionFk) //skip collection foreign keys
                    continue;
                if (!attribute.Type.IsNullable) //collection
                {
                    schema.required.Add(attribute.PropertyName);
                }

                //we need to have possibility pass ids like client_1, client_2 etc
                var swaggerType = (isChange && attribute.IsPrimaryKey) ? GetSwaggerType(typeof(string)) : GetSwaggerType(attribute.Type.OriginalCLRType);

                schema.properties.Add(attribute.PropertyName, new SwaggerPlainSchemaProperty()
                {
                    type = swaggerType.type,
                    format = swaggerType.format
                });
            }

            //collections
            if (model.HasCollections)
            {
                foreach (var collectionModel in model.Collections.Where(c => !c.ReadOnly || !isChange))
                {
                    var collectionEntityModel = collectionModel.Model;
                    var getOrchange = isChange ? "Change" : "Get";
                    var collectionSchemaName = $"{collectionEntityModel.Name}{getOrchange}CollectionItem";
                    schema.properties.Add(collectionModel.Name, new SwaggerCollectionSchemaProperty(collectionSchemaName));
                    if (!schemes.ContainsKey(collectionSchemaName))
                    {
                        AddSchema(collectionSchemaName, collectionEntityModel, schemes, isChange, model);
                    }
                }
            }


            //swagger 2 requires at least one element in required

            if (!schema.required.Any())
                schema.required = null;
            
            schemes.Add(isCollection ? name : itemSchemaName, schema);
        }

        private static string GetItemsSchemaName(string name)
        {
            return $"{name}Items";
        }

        private static (string type, string format) GetSwaggerType(Type type)
        {
            if (Types.ContainsKey(type))
                return Types[type];
            return ("string", null);
        }

        private static Dictionary<Type, (string type, string format)> Types = new Dictionary<Type, (string type, string format)>
        {
            {typeof(Boolean), ("boolean", null)},
            {typeof(Int16), ("integer", "int32")},
            {typeof(Int32), ("integer", "int32")},
            {typeof(Int64), ("integer", "int64")},
            {typeof(Double), ("number", "double")},
            {typeof(Decimal), ("number", null)},
            {typeof(String), ("string", null)},
            {typeof(DateTime), ("string", "date-time")},
            {typeof(Byte), ("integer", "int32")},
            {typeof(Byte[]), ("string", "byte")},
            {typeof(Guid), ("string", "uuid")},
            {typeof(char), ("string", null)},
            {typeof(Single), ("number", "float")}
        };

    }
}
