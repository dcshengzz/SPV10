using System.Collections.Generic;

namespace swz.SurveyPlus.IdentityAccessManagement.Domain
{
    public class UserList
    {
        private IList<string> _schemas = new List<string> { "urn:ietf:params:scim:api:messsages:2.0:ListResponse" };
        public IList<string> schemas { get { return _schemas; } set { _schemas = value; } }

        public int totalResults { get; set; }

        public IList<User> Resources { get; set; }

        public int startIndex { get; set; }

        public int itemsPerPage { get; set; }
    }
}
