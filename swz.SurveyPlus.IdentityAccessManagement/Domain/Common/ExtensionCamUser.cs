using Newtonsoft.Json;
using System;

namespace swz.SurveyPlus.IdentityAccessManagement.Domain.Common
{
    public class ExtensionCamUser
    {
        [Newtonsoft.Json.JsonIgnore]
        public DateTime? lastLogin { get; set; }
        /*
        [Newtonsoft.Json.JsonIgnore]
        public DateTime lastPasswordChanged { get; set; }
        */
        public bool isPrivileged { get; set; }

        [JsonProperty("lastLogin")]
        public String lastLoginStr
        {
            get
            {
                return lastLogin != null ? lastLogin.Value.ToString(Constants.dateFormat) : string.Empty;
            }

        }

        /*
        [JsonProperty("lastPasswordChanged")]
        public String lastPasswordChangedStr
        {
            get
            {
                return lastPasswordChanged.ToString(Constants.dateFormat);
            }

        }
        */

    }
}