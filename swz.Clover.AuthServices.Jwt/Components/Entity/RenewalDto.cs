using Newtonsoft.Json;

namespace swz.Clover.AuthServices.Jwt.Components.Entity
{
    [JsonObject]
    public class RenewalDto
    {
        [JsonProperty("rtoken")]
        public string RenewalToken;
    }
}
