using System.Xml.Schema;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Provides the schema set needed to validate a saml response against the schema.
    /// i.e. saml, samlp, ds, xenc
    /// Implementations are responsible for loading the schemas and providing a compiled set
    /// on demand.
    /// </summary>
    public interface ISamlSchemaProvider
    {
        XmlSchemaSet GetSchemas();
    }
}
