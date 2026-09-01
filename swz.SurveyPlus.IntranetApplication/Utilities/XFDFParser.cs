using System.Collections.Generic;
using System.Xml.Serialization;

namespace swz.SurveyPlus.IntranetApplication.Utilities
{
    public class XFDFParser
    {
    }

    [XmlRoot(ElementName = "field", Namespace = "http://ns.adobe.com/xfdf/")]
    public class Field
    {
        [XmlElement(ElementName = "value", Namespace = "http://ns.adobe.com/xfdf/")]
        public List<string> Value { get; set; }

        [XmlAttribute(AttributeName = "name")] public string Name { get; set; }
    }

    [XmlRoot(ElementName = "fields", Namespace = "http://ns.adobe.com/xfdf/")]
    public class Fields
    {
        [XmlElement(ElementName = "field", Namespace = "http://ns.adobe.com/xfdf/")]
        public List<Field> Field { get; set; }
    }

    [XmlRoot(ElementName = "xfdf", Namespace = "http://ns.adobe.com/xfdf/")]
    public class Xfdf
    {
        [XmlElement(ElementName = "fields", Namespace = "http://ns.adobe.com/xfdf/")]
        public Fields Fields { get; set; }

        [XmlAttribute(AttributeName = "xmlns")]
        public string Xmlns { get; set; }

        [XmlAttribute(AttributeName = "space", Namespace = "http://www.w3.org/XML/1998/namespace")]
        public string Space { get; set; }
    }
}