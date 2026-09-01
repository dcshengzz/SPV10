using swz.SurveyPlus.Application;
using System;
using System.IO;
using System.Reflection;
using System.Xml;
using System.Xml.Schema;

namespace swz.SurveyPlus.Saml2
{
    
    /// <summary>
    /// Caches a shared compiles instance of XmlSchemaSet, created and compiled on first
    /// demand from local copies of the relevant schemas.
    /// </summary>
    public class LocalSamlSchemaProvider : ISamlSchemaProvider
    {
        //Since we are embedding these files in the DLL they should be set to
        //Build Action=Embedded Resource
        //Copy to Output directory=Do Not Copy
        private static readonly string[] SchemaResources = {
            "swz.SurveyPlus.Saml2.Schemas.xmldsig-core-schema.xsd",
            "swz.SurveyPlus.Saml2.Schemas.xenc-schema.xsd",
            "swz.SurveyPlus.Saml2.Schemas.saml-schema-assertion-2.0.xsd",
            "swz.SurveyPlus.Saml2.Schemas.saml-schema-protocol-2.0.xsd"
        };

        private readonly Lazy<XmlSchemaSet> schemaSet;

        public LocalSamlSchemaProvider()
        {
            schemaSet = new Lazy<XmlSchemaSet>(BuildSchemaSet, isThreadSafe: true);
        }

        public XmlSchemaSet GetSchemas()
        {
            XmlSchemaSet schemas = schemaSet.Value;

            if (!schemas.IsCompiled)
            {
                // Internal assertion - If false, something illegally mutated our global instance.
                // Unfortunately there is no way to enforce immutability on the XmlSchemaSet class
                // n.b. This check won't catch mutations that also recompile it
                throw new InternalException(
                    "Fail-Fast - the global SAML XmlSchemaSet was illegally mutated after initialization. " +
                    "This object must be treated as strictly read-only to maintain thread safety");
            }

            return schemas;
        }

        private XmlSchemaSet BuildSchemaSet()
        {
            XmlSchemaSet schemas = new XmlSchemaSet()
            {
                XmlResolver = null, //Prevent schema compiler downloading anything external
            };
            Assembly assembly = typeof(LocalSamlSchemaProvider).Assembly;
            XmlReaderSettings settings = new XmlReaderSettings
            {
                DtdProcessing = DtdProcessing.Parse, // To allow the legacy W3C DTD syntax here (neccessary)
                XmlResolver = null                   // Need to block external network resolution here too
            };
            foreach (string name in SchemaResources)
            {
                using Stream stream = assembly.GetManifestResourceStream(name)
                    ?? throw new FileNotFoundException($"Could not find embedded schema '{name}'.");
                using XmlReader reader = XmlReader.Create(stream, settings);
                schemas.Add(null, reader); //schema will define namespace so pass it as null here
            }
            schemas.Compile();
            return schemas;
        }
    }
}
