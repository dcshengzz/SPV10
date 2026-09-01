using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;

namespace swz.SurveyPlus.Application
{
    public class ShortLinkResult
    {
        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome 
        {
            Inactive,
            InvalidShortLink, 
            InvalidAccessCode,
            RedirectToUrl,
        }

        public static ShortLinkResult Fail(Outcome reason)
        {
            switch (reason)
            {
                case Outcome.Inactive:
                case Outcome.InvalidShortLink:
                case Outcome.InvalidAccessCode:                
                    return new ShortLinkResult(reason, null);

                default:
                    throw new ArgumentException($"{reason} is not a valid failure reason", nameof(reason));
            }
        }

        public static ShortLinkResult RedirectToUrl(Uri url)
        {
            return new ShortLinkResult(Outcome.RedirectToUrl, url);
        }

        // // // // // // // // // // // // // // // // // // //

        public Outcome Response { get; private set; }

        public Uri Url { get; private set; }

        [JsonConstructor]
        private ShortLinkResult(Outcome response, Uri url )
        {
            this.Response = response;
            this.Url = url;
        }
    }
}
