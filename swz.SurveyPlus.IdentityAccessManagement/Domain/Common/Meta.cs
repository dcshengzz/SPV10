using Newtonsoft.Json;
using System;

namespace swz.SurveyPlus.IdentityAccessManagement.Domain.Common
{
    public class Meta
    {
        public string resourceType { get; set; }
        [JsonIgnore]
        public DateTime? created { get; set; }
        [JsonIgnore]
        public DateTime? lastModified { get; set; }

        [JsonProperty("created")]
        public string createdStr
        {
            get
            {
                return created != null ? created.Value.ToString(Constants.dateFormat) : string.Empty;
            }

        }
        
        [JsonProperty("lastModified")]
        public string lastModifiedStr
        {
            get
            {
                return lastModified != null ? lastModified.Value.ToString(Constants.dateFormat) : string.Empty;
            }

        }
        
    }
}