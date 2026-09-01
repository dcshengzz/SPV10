using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    public class ShortLinkGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ShortLinkGateway));

        public static async Task<ShortLinkResult> ProcessShortLink(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string shortLinkCode,
            string accessCode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(shortLinkCode)) throw new ArgumentException(nameof(shortLinkCode));
            try
            {
                bool useAccessCode = !string.IsNullOrEmpty(accessCode);
                string partialUrl =
                    useAccessCode
                        ? Constants.UAppRoutes.ShortLink_WithCode
                            .Replace("{linkCode}", shortLinkCode)
                            .Replace("{accessCode}", accessCode)
                        : Constants.UAppRoutes.ShortLink_NoCode
                            .Replace("{linkCode}", shortLinkCode);            
                var emptyForm = new Dictionary<string, string>();                
                UAppUtils.TraceLogHttpClient(logger, "ProcessShortLink", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, emptyForm));
                ShortLinkResult result = JsonConvert.DeserializeObject<ShortLinkResult>(responseContent);
                return result;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ProcessShortLink) + " - caught unexpected exception, shortLinkCode={0}", shortLinkCode);
                throw new RespondentServiceException("Unexpected error processing ShortLink", e);
            }
        }
    }
}
