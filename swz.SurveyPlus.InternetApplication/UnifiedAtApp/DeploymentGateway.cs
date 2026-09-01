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
    /// <summary>
    /// U@App support for deployment related activities (eg: to get information about deployment settings etc).
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    class DeploymentGateway
    {
        //TODO - notice how GetIPRestriction and IsAnonymousSurvey both fetch lsi to check something.
        //       Implies multiple swagger fetches in same request. Ideally should be just one and then maybe use a request item to cache this info
        //       This will require changes outside the service. Service to have object encapusalting the desired info (or maybe just a non-swagger/non-dynamic entity
        //       immutable object with all the data for it... let's see how when we do the deswaggerification of UserInterfaceController)
        // see also: https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.http.features.iitemsfeature?view=aspnetcore-3.1

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(DeploymentGateway));

        /// <summary>
        /// Returns true if the survey IsAnonymous flag is set.
        /// </summary>
        public static async Task<bool> IsAnonymousSurvey(
            IHttpClientFactory httpClientFactory, 
            Guid dlsi,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (Guid.Empty.Equals(dlsi)) throw new ArgumentException(nameof(dlsi));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            try
            {
                string partialUrl = Constants.UAppRoutes.IsAnonymousSurvey
                    .Replace("{dlsi}", dlsi.ToString());
                UAppUtils.TraceLogHttpClient(logger, "IsAnonymousSurvey", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.GetWithoutAccessToken(partialUrl));
                dynamic result = JsonConvert.DeserializeObject(responseContent);
                if (result.success != true) throw new AnonymousFlagRetrievalException("response does not have success=true");
                bool isAnonymous = (bool)result.item;
                return isAnonymous;
            }
            catch (AnonymousFlagRetrievalException)
            {
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(IsAnonymousSurvey) + " - caught unexpected exception, dlsi={0}", dlsi);
                }
                throw new AnonymousFlagRetrievalException("Unexpected error checking for " + dlsi, e);
            }
        }

        public static async Task<ListSampleInfo> GetListSampleInfo(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            Guid dlsi)          
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken)); 

            try
            {
                string partialUrl 
                    = Constants.UAppRoutes.ListSampleInfoSingle
                    .Replace("{dlsi}", dlsi.ToString());
                TraceLogHttpClient(logger, "GetListSampleInfo", partialUrl);
                string json = await SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                dynamic data = JsonConvert.DeserializeObject(json); //it sends back vSP_ListSampleInfoResp in dictionary format
                ListSampleInfo listSampleInfo = ListSampleInfo.FromDynamic(data);
                return listSampleInfo;
            }
            catch(NotFoundException)
            {
                throw new InvalidOperationException("Invalid or missing dlsi");
            }
            catch (PermissionException)
            {
                throw;
            }
            catch(Exception e)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetListSampleInfo) + " - caught unexpected exception, dlsi={0}", dlsi);
                }                
                throw new ListSampleInfoRetrievalException("Unexpected error retrieving ListSampleInfo with dlsi " + dlsi, e);
            }
        }

        public static async Task<string> GetCompletionUrl(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken, 
            Guid dlsi)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));            
            try
            {
                //TODO - implement this with a custom endpoint so we can avoid all the weight of serialising a ListSampleInfo
                //       when only this column is required (as is the case in the request to get it on a survey completion)
                ListSampleInfo listSampleInfo = await GetListSampleInfo(httpClientFactory, apiHeaderOptions, accessToken, dlsi);
                return listSampleInfo.CompleteURL;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetCompletionUrl) + " - caught unexpected exception, dlsi={0}", dlsi);
                }
                throw new RespondentServiceException("Unable to retrieve CompleteUrl for " + dlsi, e);
            }
        }

        public static async Task<RespInvitationResult> DeploymentAcknowledge(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string encryptedDlsi)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(encryptedDlsi)) throw new ArgumentException(nameof(encryptedDlsi));
            try
            {
                string partialUrl = Constants.UAppRoutes.InvitesLogin;
                var formData = new Dictionary<string, string>();
                formData.Add("encryptedDlsi", encryptedDlsi);
                UAppUtils.TraceLogHttpClient(logger, "DeploymentAcknowledge", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                dynamic result = JsonConvert.DeserializeObject<RespInvitationResult>(responseContent);
                return result;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(DeploymentAcknowledge) + " - caught unexpected exception");
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

    } //end of DeploymentGateway
}
