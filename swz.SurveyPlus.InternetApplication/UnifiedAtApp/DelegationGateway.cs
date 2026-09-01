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
    /// U@App support for survey delegation related activities.
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public static class DelegationGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(DelegationGateway));

        public static async Task<bool> IsRequireAccessCode(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            Guid dlsi)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            try
            {
                //TODO - replace this with a custom endpoint that checks only this so the whole LSI doesn't need to be serialised
                //       (if callers already have a ListSampleInfo record they shouldnt call this, conversely if all they need is
                //       this flag then we don't want them wasting effort serialising a whole ListSampleInfo)
                ListSampleInfo listSampleInfo 
                    = await DeploymentGateway.GetListSampleInfo(httpClientFactory, apiHeaderOptions, accessToken, dlsi);
                return listSampleInfo.RequireAccessCode;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(IsRequireAccessCode) + " - caught unexpected exception, dlsi={0}", dlsi);
                throw new RespondentServiceException($"Unexpected exception caught while checking if survey requires access code, dlsi={dlsi}", e);
            }
        }

        public static async Task<bool> IsDelegatedAccessRetriesExceed(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            Guid qnnDplySampleInfoId)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException(nameof(qnnDplySampleInfoId));

            try
            {
                string partialUrl = Constants.UAppRoutes.IsDelegationExceeded.Replace("{dlsi}", qnnDplySampleInfoId.ToString());
                UAppUtils.TraceLogHttpClient(logger, "IsDelegatedAccessRetriesExceeded", partialUrl);
                string responseContent 
                    = await UAppUtils.SendApiRequestAsync(httpClientFactory, apiHeaderOptions, ApiRequest.Get(partialUrl, accessToken));
                dynamic result = JsonConvert.DeserializeObject(responseContent); 
                if (result.success != true) throw new Exception("response does not have success=true");
                return (bool)result.item;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(IsDelegatedAccessRetriesExceed) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        /// <summary>
        /// Before trigger this, should trigger IsDelegatedAccessRetriesExceed to check if fail attempt exceed.
        /// </summary>
        /// <returns></returns>
        public static async Task<bool> ValidateAccessCode(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            Guid qnnDplySampleInfoId, 
            string delegationCode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrEmpty(delegationCode)) throw new ArgumentException(nameof(delegationCode));

            try
            {
                string partialUrl = Constants.UAppRoutes.ValidateDelegation.Replace("{dlsi}", qnnDplySampleInfoId.ToString());
                UAppUtils.TraceLogHttpClient(logger, "ValidateAccessCode", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostJsonWithDelegationCode(partialUrl, accessToken, delegationCode, payload: null));
                dynamic result = JsonConvert.DeserializeObject(responseContent);
                if (result.success != true) throw new Exception("response does not have success=true");
                return (bool)result.item;

            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ValidateAccessCode) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw new RespondentServiceException("Unexpected error", e);
            }
        } //end of ValidateAccessCode

        public static async Task<DelegateSurveyResult> DelegateSurvey(
            string accessToken, 
            IHttpClientFactory httpClientFactory, 
            DelegateSurveyRequest request,
            string delegationCode,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (request == null) throw new ArgumentNullException(nameof(request));
            if (string.IsNullOrWhiteSpace(delegationCode)) throw new ArgumentException(nameof(delegationCode));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.DelegateSurvey;
                UAppUtils.TraceLogHttpClient(logger, "DelegateSurvey", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostJsonWithDelegationCode(partialUrl, accessToken, delegationCode, request));
                DelegateSurveyResult result = JsonConvert.DeserializeObject<DelegateSurveyResult>(responseContent);
                return result;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(DelegateSurvey) + " - caught unexpected exception");
                throw new RespondentServiceException("Unexpected error", e);
            }
        } //end of DelegateSurvey

        public static async Task<DelegateSurveyResult> RevokeDelegation(
            string accessToken, 
            IHttpClientFactory httpClientFactory,
            string delegationCode,
            Guid qnnDplySampleInfoId, 
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            Guid? qnnRespDelegationId = null)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(delegationCode)) throw new ArgumentException(nameof(delegationCode));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = (qnnRespDelegationId == null || Guid.Empty.Equals(qnnRespDelegationId))
                        ? Constants.UAppRoutes.RevokeAllDelegation //revoke all
                        : Constants.UAppRoutes.RevokeSingleDelegation; //revoke single
                UAppUtils.TraceLogHttpClient(logger, "RevokeDelegation", partialUrl);
                var data = new Dictionary<string, string>();
                data.Add("delegateId", qnnRespDelegationId.ToString());
                data.Add("dlsi", qnnDplySampleInfoId.ToString());
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithDelegationCode(partialUrl, accessToken, delegationCode, data));
                DelegateSurveyResult result = JsonConvert.DeserializeObject<DelegateSurveyResult>(responseContent);
                return result;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(RevokeDelegation) + " - caught unexpected exception");
                throw new RespondentServiceException("INTERNAL ERROR", e);
            }
        } //end of RevokeDelegation

        public static async Task<DelegationHistoryResult> GetDelegationHistory(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            Guid qnnDplySampleInfoId,
            string delegationCode)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(delegationCode)) throw new ArgumentException(nameof(delegationCode));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(delegationCode)) throw new ArgumentException(nameof(delegationCode));
            try
            {
                string partialUrl
                    = Constants.UAppRoutes.DelegationHistory
                    .Replace("{dlsi}", qnnDplySampleInfoId.ToString());
                UAppUtils.TraceLogHttpClient(logger, "GetDelegationHistory", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                        httpClientFactory, 
                        apiHeaderOptions, 
                        ApiRequest.GetWithDelegationCode(partialUrl, accessToken, delegationCode));
                DelegationHistoryResult result = JsonConvert.DeserializeObject<DelegationHistoryResult>(responseContent);
                return result;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(GetDelegationHistory) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw new RespondentServiceException($"Failed to get delegation history for dlsi={qnnDplySampleInfoId}", e);
            }
        } //end of GetDelegationHistory

        public static async Task<int> GetDelegationAccessCodeRetriesAysnc(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOption)
        {
            string value = await SettingsGateway.GetSettingAsync(
                httpClientFactory, 
                apiHeaderOption, 
                Constants.dwAppSettingName.DelegationAccessCodeRetries);
            return int.Parse(value);
        }

    } //end of DelegationGateway


}
