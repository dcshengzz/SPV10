using System.Collections.Generic;

namespace swz.SurveyPlus.IdentityAccessManagement
{
    public class BaseReturn
    {
        private IList<string> _schemas = new List<string> { "urn:ietf:params:scim:api:messages:2.0:Error" };
        public IList<string> schemas { get { return _schemas; } set { _schemas = value; } }
        public string Detail { get; set; }
        public string Status { get; set; }
    }
}
