using Amazon.Runtime.Internal.Transform;
using DocumentFormat.OpenXml.Spreadsheet;
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
    class PdfExportGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(PdfExportGateway));

        public static async Task<PdfExportRateLimitResult> CheckPdfExportRateLimit(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            Guid dlsi,
            Guid? respId,
            string formName,
            string surveyName,
            string emails,
            string accessToken)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (Guid.Empty.Equals(dlsi)) throw new ArgumentException(nameof(dlsi));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            try
            {
                string partialUrl = Constants.UAppRoutes.CheckPdfExportRateLimit;
                UAppUtils.TraceLogHttpClient(logger, "CheckPdfExportRateLimit", partialUrl);

                var payload = new
                {
                    DplyListSampleId = dlsi,
                    RespId = respId,
                    FormName = formName,
                    SurveyName = surveyName,
                    Emails = emails
                };

                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostJson(partialUrl, accessToken, payload));

                dynamic response = JsonConvert.DeserializeObject(responseContent);
                if (!(bool)response.success)
                {
                    string serverMessage = response.message?.ToString();
                    throw new RespondentServiceException(serverMessage ?? "Rate limit check failed", null);
                }

                return new PdfExportRateLimitResult
                {
                    IsRateLimited = (bool)response.isRateLimited,
                    CooldownMinutes = (int)response.cooldownMinutes,
                    LogId = Guid.Parse((string)response.id)
                };
            }
            catch (RespondentServiceException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(CheckPdfExportRateLimit) + " - caught unexpected exception");
                throw new ExportPdfException("Unexpected error when checking PDF export rate limit", e);
            }
        }

        public static async Task<DynamicEntity> GetSurveyDataForPrint(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            Guid dlsi,
            Guid? respId,
            string formName,
            bool IsPDFExportForSubmittedOnly,
            string accessToken)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            if (Guid.Empty.Equals(dlsi)) throw new ArgumentException(nameof(dlsi));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            try
            {
                string partialUrl = (
                    (respId == null)
                        ? Constants.UAppRoutes.GetSurveyDataForPrint
                        : Constants.UAppRoutes.GetSurveyDataForPrint_Resp.Replace("{respId}", respId.ToString())
                    ).Replace("{formName}", formName)
                     .Replace("{dlsi}", dlsi.ToString());

                partialUrl += $"?IsPDFExportForSubmittedOnly={IsPDFExportForSubmittedOnly.ToString().ToLower()}";

                UAppUtils.TraceLogHttpClient(logger, "GetSurveyDataForPrint", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                DynamicEntity result = null;
                if (responseContent != null)
                {
                    try
                    {
                        result = DynamicEntity.ParseJSON(responseContent);
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                }
                return result;
            }
            catch (ApiRequestException e)
            {
                if (e.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    throw new NotFoundException("The survey administrator has not enabled this form for PDF Export yet", e);
                }

                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        public static async Task EnqueuePrintJob(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            Guid logId,
            string formName,
            string emails,
            string surveyName,
            string responseData,
            string accessToken)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (Guid.Empty.Equals(logId)) throw new ArgumentException(nameof(logId));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            if (string.IsNullOrEmpty(emails)) throw new ArgumentException(nameof(emails));
            if (string.IsNullOrEmpty(surveyName)) throw new ArgumentException(nameof(surveyName));
            if (string.IsNullOrEmpty(responseData)) throw new ArgumentException(nameof(responseData));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            try
            {
                string partialUrl = (Constants.UAppRoutes.EnqueuePrintJob);
                UAppUtils.TraceLogHttpClient(logger, "EnqueuePrintJob", partialUrl);
                Dictionary<string, string> form = new Dictionary<string, string>();
                form.Add("formName", formName);
                form.Add("emails", emails);
                form.Add("responseData", responseData);
                form.Add("surveyName", surveyName);
                form.Add("logId", logId.ToString());
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormForPrint(partialUrl, accessToken, form));
                dynamic response = JsonConvert.DeserializeObject(responseContent);
                if ((bool)response.success)
                    return;
                else
                    throw new InternalException("response does not have expected success=true");

            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(EnqueuePrintJob) + " - caught unexpected exception");
                throw new ExportPdfException("Unexpected error when enqueue print job", e);
            }
        }

        public static async Task UpdatePdfExportStatus(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            Guid logId,
            string status,
            string errorMessage,
            string accessToken)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (Guid.Empty.Equals(logId)) throw new ArgumentException(nameof(logId));
            if (string.IsNullOrEmpty(status)) throw new ArgumentException(nameof(status));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            try
            {
                string partialUrl = Constants.UAppRoutes.UpdatePdfExportStatus;
                UAppUtils.TraceLogHttpClient(logger, "UpdatePdfExportStatus", partialUrl);

                var payload = new
                {
                    Id = logId,
                    Status = status,
                    ErrorMessage = errorMessage
                };

                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostJson(partialUrl, accessToken, payload));

                dynamic response = JsonConvert.DeserializeObject(responseContent);
                if (!(bool)response.success)
                {
                    logger.LogWarning(nameof(UpdatePdfExportStatus) + " - server returned failure for logId={LogId}", logId);
                }
            }
            catch (Exception e)
            {
                logger.LogWarning(e, nameof(UpdatePdfExportStatus) + " - failed to update status for logId={LogId}, status={Status}", logId, status);
            }
        }

    } //end of DeploymentGateway
}
