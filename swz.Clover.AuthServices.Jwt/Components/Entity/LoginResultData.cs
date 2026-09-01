using System;
using Newtonsoft.Json;

namespace swz.Clover.AuthServices.Jwt.Components.Entity
{
    [JsonObject]
    public class LoginResultData
    {
        //Factory method to generate an emty instance with an error message
        public static LoginResultData EmptyWithError(string error)
        {
            return new LoginResultData { Error = error, Success = false };
        }

        [JsonProperty("userId")]
        public Guid UserId { get; set; }  //kludge: for respondent is the sampleId

        [JsonProperty("displayName")]
        public string DisplayName { get; set; }

        [JsonProperty("accessToken")]
        public string AccessToken { get; set; }

        [JsonProperty("renewalToken")]
        public string RenewalToken { get; set; }

        [JsonProperty("success")]
        public bool Success { get; set; }

        [JsonIgnore]
        public string Error { get; set; }
    }
}
