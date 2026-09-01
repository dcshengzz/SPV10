using System;
using System.Threading.Tasks;
using swz.Clover.Core;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using swz.SurveyPlus.Application;
using System.Collections.Specialized;
using Newtonsoft.Json;
using swz.SurveyPlus.ApiSupport;
using static swz.SurveyPlus.ApiSupport.UAppUtils;
using System.IO;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// U@App support for Online Excel feature related activities.
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public static class ExcelGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ExcelGateway));
        public static async Task<StreamWithName> DownloadExcel(
            string accessToken,
            IHttpClientFactory httpClientFactory,
            Guid dlsi,
            string token,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            bool onLambdaMode = false,
            Guid? respId = null)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (Guid.Empty.Equals(dlsi)) throw new ArgumentException(nameof(dlsi));
            if (string.IsNullOrWhiteSpace(token)) throw new ArgumentException(nameof(token));
            if (respId != null && Guid.Empty.Equals(respId)) throw new ArgumentException(nameof(respId));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            try
            {
                //see: IntegrationController.ApiDownloadSurveyExcelOnline
                //string url = $"download/file/{dlsi.ToString()}/{token}/{(respId==null?"":respId.ToString())}";
                string partialUrl = (
                    (respId == null)
                        ? Constants.UAppRoutes.DownloadSurveyExcel
                        : Constants.UAppRoutes.DownloadSurveyExcel_Resp.Replace("{qnnRespIdString}", respId.ToString())
                    ).Replace("{token}", token)
                     .Replace("{dlsi}", dlsi.ToString());
                UAppUtils.TraceLogHttpClient(logger, "DownloadExcel", partialUrl);
                StreamWithName excel = await UAppUtils.SendApiRequestForStreamAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken), onLambdaMode);
                return excel;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(DownloadExcel) + " - caught unexpected exception, dlsi={0}, token={1}", dlsi, token);
                throw new SurveyRetrievalException("Internal Error", e);
            }
        }

        public static async Task UploadExcel(
            string accessToken,
            IHttpClientFactory httpClientFactory,
            IAntiVirusScanner antiVirus,
            Guid qnnId,
            Guid dplyId,
            Guid listSampleId,
            StreamWithName file, 
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            bool onLambdaMode = false)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (antiVirus == null) throw new ArgumentNullException(nameof(antiVirus));
            if (Guid.Empty.Equals(qnnId)) throw new ArgumentException(nameof(qnnId));
            if (Guid.Empty.Equals(dplyId)) throw new ArgumentException(nameof(dplyId));
            if (Guid.Empty.Equals(listSampleId)) throw new ArgumentException(nameof(listSampleId));
            if (file == null) throw new ArgumentNullException(nameof(file));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            //nb: our ApiHandleUploadedSurvey in the IntegrationApiController will verify that the sample
            //    identified in the bearer header we send is the sample identified in the specified list sample
            try
            {
                using (MemoryStream memory = new MemoryStream())
                {
                    //Pull file into memory stream so we can safely read stream twice (make a new StreamWithName referencing that)
                    //(the original stream is likely from a IFormFile.OpenReadStream but here we only know its a Stream)
                    file.Stream.CopyTo(memory);
                    file = new StreamWithName(memory, file.ContentType, file.Name);

                    bool virusFound = await antiVirus.IsVirusDetected(file);
                    if (virusFound) throw new VirusDetectedException(Constants.Message.UploadVirusDetected);

                    memory.Seek(0, SeekOrigin.Begin); //Rewind the stream so we can use it again
                
                    using (HttpClient client = httpClientFactory.CreateClient())
                    {
                        client.BaseAddress = GetApiBasePath();

                        NameValueCollection nvc = System.Web.HttpUtility.ParseQueryString(string.Empty);
                        nvc.Add("qnnId", qnnId.ToString());
                        nvc.Add("dplyId", dplyId.ToString());
                        nvc.Add("listSampleId", listSampleId.ToString());
                        string url = Constants.UAppRoutes.UploadExcelResponse + "?" + nvc.ToString();

                        HttpRequestMessage post = new HttpRequestMessage(HttpMethod.Post, url);

                        post.Headers.Add(Clover.Core.IntegrationApi.IntegrationApiKeys.HeaderApiKey, CloverRuntime.IntegrationApiKey);
                        post.Headers.Add("Authorization", $"Bearer {accessToken}");

                        
                        //post.Headers.ExpectContinue = false;
                        if(!onLambdaMode)
                        {
                            var postContent = new MultipartFormDataContent();
                            var streamContent = new StreamContent(file.Stream);
                            //eg: Content-Disposition: form-data; name="ExcelFileUpload"; filename="badQuests.xlsx"
                            streamContent.Headers.Add(
                                "Content-Disposition",
                                "form-data; name=\"ExcelFileUpload\"; filename=\"" + file.Name + "\"");
                            streamContent.Headers.Add(
                                "Content-Type",
                                file.ContentType);
                            postContent.Add(streamContent, "file", file.Name);
                            post.Content = postContent;
                        }
                        else
                        {
                            // Read stream content as base64
                            using (MemoryStream ms = new MemoryStream())
                            {
                                await file.Stream.CopyToAsync(ms);
                                byte[] fileBytes = ms.ToArray();
                                string base64String = Convert.ToBase64String(fileBytes);

                                // Set base64 content in request body
                                post.Content = new StringContent(base64String);
                                post.Content.Headers.Add("FileName", file.Name);
                                post.Content.Headers.Add("FileType", file.ContentType);
                            }
                        }

                        apiHeaderOptions.AddHeaderTo(client);
                        using (HttpResponseMessage response = await client.SendAsync(post))
                        {
                            if (response.IsSuccessStatusCode)
                            {
                                string responseContent = await response.Content.ReadAsStringAsync();
                                dynamic result = JsonConvert.DeserializeObject(responseContent);
                                bool success = (bool)result.success;
                                if (success)
                                {
                                    return; //OK
                                }
                                else
                                {
                                    string message = (string)result.message;
                                    throw new SurveySubmissionException(message);
                                }
                            } 
                            else
                            { 
                                throw new SurveySubmissionException(UAppUtils.ApiFailMessage(response.StatusCode, url));
                            }               
                        } //end using response
                    } //end using client
                }//end using memory stream
            }
            catch(SurveySubmissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(UploadExcel) + " - caught unexpected exception, qnnId={0}, dplyId={1}, listSampleId={2}", qnnId, dplyId, listSampleId);
                }                
                throw new SurveySubmissionException("INTERNAL ERROR", e);
            }
        } // end of UploadExcel

    } //end of ExcelApplication
}
