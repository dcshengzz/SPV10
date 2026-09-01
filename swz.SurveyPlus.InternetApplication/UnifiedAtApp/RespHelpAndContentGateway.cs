using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using System.Net.Http;
using swz.SurveyPlus.ApiSupport;
using static swz.SurveyPlus.ApiSupport.UAppUtils;
using Newtonsoft.Json;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// U@App support for help content and respondent content retrieval.
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public static class RespHelpAndContentGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(RespHelpAndContentGateway));

        public static async Task<List<HelpItem>> GetRespHelp(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(HttpStyleUriParser));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            try
            {
                const string partialUrl = Constants.UAppRoutes.Help;
                TraceLogHttpClient(logger, "GetRespHelp", partialUrl);
                string json = await SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.GetWithoutAccessToken(partialUrl));
                List<HelpItem> helpItems = JsonConvert.DeserializeObject<List<HelpItem>>(json);
                return helpItems;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(GetRespHelp) + " - caught unexpected exception");
                throw new HelpRetrievalException(e);
            }
        }

        public static async Task<List<RespondentContentItem>> GetRespondentContent(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string type)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(HttpStyleUriParser));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(type)) throw new ArgumentException(nameof(type));

            try
            {
                string partialUrl
                    = Constants.UAppRoutes.RespondentContent
                    .Replace("{type}", type);
                TraceLogHttpClient(logger, "GetRespondentContent", partialUrl);
                string json = await SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.GetWithoutAccessToken(partialUrl));
                List<RespondentContentItem> contentItems = JsonConvert.DeserializeObject<List<RespondentContentItem>>(json);
                return contentItems;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, "Caught unexpected exception retrieving respondent content, type={0}", type);
                throw new RespondentContentRetrievalException(e);
            }
        }

    }
}
