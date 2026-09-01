using swz.SurveyPlus.IdentityAccessManagement.Domain.Common;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace swz.SurveyPlus.IdentityAccessManagement.Domain
{
    public class User
    {
        private IList<string> _schemas = new List<string> { "urn:ietf:params:scim:schemas:core:2.0:User" };
        public IList<string> schemas { get { return _schemas; } set { _schemas = value; } }
        public string id { get; set; }

        //private string _externalId = string.Empty;
        //public string externalId { get { return _externalId; } set { _externalId = value; } }

        public Meta meta { get; set; }

        private string _userName = string.Empty;
        public string userName { get { return _userName; } set { _userName = value; } }

        private string _displayName = string.Empty;
        public string displayName { get { return _displayName; } set { _displayName = value; } }

        private bool _active = false;
        public bool active { get { return _active; } set { _active = value; } }

        public IList<Email> emails { get; set; }

        //Add SP Roles
        public IList<Roles> roles { get; set; }

        //Removed empty return
        /*
        private string _profileUrl = string.Empty;
        public string profileUrl { get { return _profileUrl; } set { _profileUrl = value; } }
        
        private string _title = string.Empty;
        public string title
        {
            get { return _title; }
            set { _title = value; }
        }

        private string _userType = string.Empty;
        public string userType { get { return _userType; } set { _userType = value; } }
        
        private IList<Resource> _groups = new List<Resource>();
        public IList<Resource> groups { get { return _groups; } set { _groups = value; } }
        
        private EnterpriseUser _enterpriseUser;

        [JsonProperty("urn:ietf:params:scim:schemas:extension:enterprise:2.0:User")]
        public EnterpriseUser enterpriseUser { 
            get { return _enterpriseUser;  } 
            set {
                if (!this.schemas.Contains("urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"))
                {
                    this.schemas.Add("urn:ietf:params:scim:schemas:extension:enterprise:2.0:User");
                }
                _enterpriseUser = value;
            } 
        }
        */
        private ExtensionCamUser _extensionCamUser;

        [JsonProperty("urn:ietf:params:scim:schemas:extension:cam:2.0:User")]
        public ExtensionCamUser extensionCamUser {
            get { return _extensionCamUser; }
            set
            {
                if (!this.schemas.Contains("urn:ietf:params:scim:schemas:extension:cam:2.0:User"))
                {
                    this.schemas.Add("urn:ietf:params:scim:schemas:extension:cam:2.0:User");
                }
                _extensionCamUser = value;
            }
        }
    }

}
