using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core;
using System.Net.Http;
using Newtonsoft.Json;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.ApiSupport;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// U@App support for survey response related activities (retrieval / update).
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public static class ResponseGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ResponseGateway));

        public static async Task<AddResponseResult> AddNewResponse(
            string accessToken, 
            IHttpClientFactory httpClientFactory,
            Guid qnnDplySampleInfoId,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException(nameof(qnnDplySampleInfoId));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl
                    = Constants.UAppRoutes.AddSurveyResponse
                    .Replace("{dlsi}", qnnDplySampleInfoId.ToString());
                var emptyForm = new Dictionary<string, string>();
                UAppUtils.TraceLogHttpClient(logger, "AddNewResponse", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostForm(partialUrl, accessToken, emptyForm));
                dynamic apiResult = JsonConvert.DeserializeObject(responseContent);
                bool success = (bool)apiResult.success;
                if (success)
                {
                    Guid qnnRespId = apiResult.item;
                    return AddResponseResult.Success(qnnRespId);
                }
                else
                {
                    string message = (string)apiResult.message;
                    if (Constants.Message.SurveyHasReachedMaximumResponses.Equals(message))
                    {
                        return AddResponseResult.Fail(Constants.Message.SurveyHasReachedMaximumResponses);
                    }
                    else
                    {
                        throw new Exception(message); //Report as internal error
                    }
                }
            }
            catch (AddResponseException)
            {
                throw;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                //Just log at debug level here, caller to handle/log exceptions
                logger.LogDebug(e, nameof(AddNewResponse) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw new AddResponseException($"An error occured adding a response for dlsi {qnnDplySampleInfoId}", e);
            }
        } //end of AddNewResponse

    } ///end of ResponseGateway
}
