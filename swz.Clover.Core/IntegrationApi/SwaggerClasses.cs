using System.Collections.Generic;
using Microsoft.CodeAnalysis;
using YamlDotNet.Core;
using YamlDotNet.Serialization;

namespace swz.Clover.Core.IntegrationApi
{
    public class SwaggerDocument
    {
        public SwaggerDocument()
        {
            swagger = "2.0";
        }

        [YamlMember(ScalarStyle = ScalarStyle.SingleQuoted)]
        public string swagger { get; set; }

        public SwaggerInfo info { get; set; }
        public string host { get; set; }
        public string basePath { get; set; }
        public List<string> schemes { get; set; }
        public List<string> consumes { get; set; }
        public List<string> produces { get; set; }
        public Dictionary<string, SwaggerPath> paths { get; set; }
        public Dictionary<string, SwaggerSchema> definitions { get; set; }
    }

    public class SwaggerInfo
    {
        public string version { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public string termsOfService { get; set; }
        public SwaggerContact contact { get; set; }
        public SwaggerLicense license { get; set; }
    }

    public class SwaggerContact
    {
        public string name { get; set; }
        public string email { get; set; }
        public string url { get; set; }
    }

    public class SwaggerLicense
    {
        public string name { get; set; }
        public string url { get; set; }
    }

    public class SwaggerPath
    {
        public SwaggerMethod get { get; set; }
        public SwaggerMethod post { get; set; }
    }

    public class SwaggerMethod
    {
        public string description { get; set; }
        public string operationId { get; set; }
        public string summary { get; set; }
        public List<SwaggerParameter> parameters { get; set; }

        public Dictionary<string, object> responses { get; set; }

        public SwaggerMethod(string responseSchema, string description)
        {
            responses = new Dictionary<string, object>();
            responses.Add("200", new
            {
                description,
                schema = new Dictionary<string, string>
                {
                    {"$ref", $"#/definitions/{responseSchema}"}
                }
            });
        }
    }



    public abstract class SwaggerParameter
    {
        public string name { get; set; }
        public bool required { get; set; }
        public string description { get; set; }
    }

    public class SwaggerPathParameter : SwaggerParameter
    {
        public string @in => "path";
        public string type { get; set; }
        public string format { get; set; }
    }

    public class SwaggerQueryParameter : SwaggerParameter
    {
        public string @in => "query";
        public string type { get; set; }
        public string format { get; set; }
    }
    
    public class SwaggerHeaderParameter : SwaggerParameter
    {
        public string @in => "header";
        public string type { get; set; }
        public string format { get; set; }
    }

    public class SwaggerBodyParameter : SwaggerParameter
    {
        public SwaggerBodyParameter(string schemaVal)
        {
            schema = new Dictionary<string, string>
            {
                {"$ref", $"#/definitions/{schemaVal}"}
            };
        }

        public string @in => "body";
        public Dictionary<string, string> schema { get; set; }
    }

    public class SwaggerSchema
    {
        public string type { get; set; }
        public List<string> required { get; set; }
        public Dictionary<string, SwaggerSchemaProperty> properties { get; set; }
    }

    public abstract class SwaggerSchemaProperty
    {
        public string type { get; set; }
    }

    public class SwaggerEnumSchemaProperty : SwaggerSchemaProperty
    {
        public List<object> @enum { get; set; }
    }

    public class SwaggerPlainSchemaProperty : SwaggerSchemaProperty
    {

        public string format { get; set; }
    }

    public class SwaggerPlainObjectSchemaProperty : SwaggerSchemaProperty
    {
        public SwaggerPlainObjectSchemaProperty(string refSchema)
        {
            @ref = $"#/definitions/{refSchema}";
        }

        [YamlMember(Alias = "$ref")]
        public string @ref { get; }
    }



public class SwaggerCollectionSchemaProperty : SwaggerSchemaProperty
    {
        public SwaggerCollectionSchemaProperty(string refSchema)
        {
            type = "array";
            items = new Dictionary<string, string>();
            items.Add("$ref", $"#/definitions/{refSchema}");
        }


        public Dictionary<string, string> items { get; private set; }
    }

    public class SwaggerCollectionTypeProperty : SwaggerSchemaProperty
    {
        public SwaggerCollectionTypeProperty(string itemType, string format)
        {
            type = "array";
            items = new SwaggerPlainSchemaProperty {type = itemType, format = format};
        }


        public SwaggerPlainSchemaProperty items { get; private set; }
    }

}

