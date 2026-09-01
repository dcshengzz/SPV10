using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using System;
using System.Net.Http;
using System.Threading.Tasks;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    public class SettingRetrievalException : Exception
    {
        public SettingRetrievalException(string message) : base(message) { }

        public SettingRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class ConnectivityTestException : Exception
    {
        //public ConnectivityTestException(string message) : base(message) { }

        public ConnectivityTestException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class SettingsGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(SettingsGateway));

        public static async Task<string> GetSettingAsync(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string name)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(HttpStyleUriParser));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));

            try
            {
                string partialUrl 
                    = Constants.UAppRoutes.Setting
                    .Replace("{name}", name);
                UAppUtils.TraceLogHttpClient(logger, "GetSettingAsync", partialUrl);
                string json = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.GetWithoutAccessToken(partialUrl));
                string value = JsonConvert.DeserializeObject<string>(json);
                return value;
            }
            catch (Exception e)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetSettingAsync) + " - caught unexpected exception, name={0}", name);
                }                
                throw new SettingRetrievalException($"Unexpected error retrieving settings for {name}", e);
            }
        }

        public static async Task<string> ConnectivityTest(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(HttpStyleUriParser));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            try
            {
                string partialUrl = Constants.UAppRoutes.ConnectivityTest;
                UAppUtils.TraceLogHttpClient(logger, "ConnectivityTest", partialUrl);
                //don't pass real jwt here, we just want to see if header gets passed
                string accessToken = "SWZCONNECTIVITYTESTTOKEN";
                string result = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken), 
                    applyResponseValidationHeuristics: true);
                return result;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ConnectivityTest) + " - caught exception");
                throw new ConnectivityTestException("An error was encountered", e);
            }
        }
    }
}
