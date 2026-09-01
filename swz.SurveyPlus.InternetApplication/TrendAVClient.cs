using System;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using swz.SurveyPlus.Application;
using Newtonsoft.Json;
using swz.SurveyPlus.ApiSupport;
using UAppUtils = swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication
{
    public class TrendAVResult
    {
        public string ResultCode { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public string Detail { get; set; } = string.Empty;
        public string Reference { get; set; } = string.Empty;
        public string Filename { get; set; } = string.Empty;
        public string version { get; set; } = string.Empty;
        public string TransactionDate { get; set; } = string.Empty;

        public TrendAVResult(string ResultCode, string Message, string Detail, string Reference, string Filename, string version, string TransactionDate)
        {
            this.ResultCode = ResultCode;
            this.Message = Message;
            this.Detail = Detail;
            this.Reference = Reference;
            this.Filename = Filename;
            this.version = version;
            this.TransactionDate = TransactionDate;
        }
    }

    public class TrendAVClient : IAntiVirusScanner
    {
        public const string TRENDAV_SETTING_DISABLED_MSG = "TrendAV setting is disabled.";
        public const string TRENDAV_SETTING_INCOMPLETE_MSG = "TrendAV setting is incomplete.";

        private readonly ILogger logger;
        private readonly IHttpClientFactory httpClientFactory;
        private readonly TrendAVOptions trendAVSettings;
        private readonly WebApiAdditionalHeaderOptions apiHeaderOptions;

        public TrendAVClient(
            ILogger<TrendAVClient> logger, 
            IHttpClientFactory httpClientFactory,
            TrendAVOptions trendAVSettings,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(logger));
            this.trendAVSettings = trendAVSettings ?? throw new ArgumentNullException(nameof(trendAVSettings));
            this.apiHeaderOptions = apiHeaderOptions ?? throw new ArgumentNullException(nameof(apiHeaderOptions));

            if (string.IsNullOrEmpty(trendAVSettings?.ApiBase) || string.IsNullOrEmpty(trendAVSettings?.ScanApi) || string.IsNullOrEmpty(trendAVSettings.APIKEY))
            {
                throw new ArgumentException(TRENDAV_SETTING_INCOMPLETE_MSG);
            }
        }

        public async Task<bool> IsVirusDetected(StreamWithName file)
        {
            if (!trendAVSettings.IsEnabled) 
                throw new AntiVirusScanningException(TRENDAV_SETTING_DISABLED_MSG);

            if (file == null) 
                throw new ArgumentNullException(nameof(file));

            bool virusFound = false;
            try
            {
                using (HttpClient client = httpClientFactory.CreateClient())
                {
                    client.BaseAddress = new Uri(trendAVSettings.ApiBase);
                    StreamContent streamContent = new StreamContent(file.Stream);

                    streamContent.Headers.Add("Content-Disposition", "form-data; name=\"" + trendAVSettings.AppFormKey + "\"; filename=\"" + file.Name + "\"");
                    streamContent.Headers.Add("Content-Type", file.ContentType);

                    MultipartFormDataContent postContent = new MultipartFormDataContent();
                    postContent.Add(streamContent, "file", file.Name);

                    string url = trendAVSettings.ScanApi;
                    HttpRequestMessage post = new HttpRequestMessage(HttpMethod.Post, url);
                    post.Content = postContent;
                    post.Headers.Add("APIKEY", trendAVSettings.APIKEY);
                    post.Headers.Add("username", trendAVSettings.USER_NAME);
                    post.Headers.Add("file_name", file.Name);

                    apiHeaderOptions.AddHeaderTo(client);
                    UAppUtils.TraceLogHttpClient(logger, "TrendAVScanFile", trendAVSettings.ApiBase + url);

                    using (HttpResponseMessage response = await client.SendAsync(post))
                    {
                        if (!response.IsSuccessStatusCode) throw new AntiVirusScanningException($"Response status failed: {response.ReasonPhrase}; Request message: {response.RequestMessage}");
                        string responseContent = await response.Content.ReadAsStringAsync();
                        dynamic result = JsonConvert.DeserializeObject<TrendAVResult>(responseContent);
                        //Throw exception if result is not success or virus found
                        bool success = result.ResultCode == "200" || result.ResultCode == "450";

                        if (!success) throw new AntiVirusScanningException($"Response result failed: {responseContent}");

                        //The file we sent for scanning is not found in the scan result
                        if ((string)result.Filename != file.Name) throw new AntiVirusScanningException($"File {file.Name} is missing from the virus scanning result, the scan result: {responseContent}");

                        //The file we sent for scanning is not found in the scan result
                        if ((string)result.ResultCode == "450")
                        {
                            virusFound = true;
                            string fileName = result?.Filename;
                            logger.LogWarning(nameof(TrendAVClient) + " - Trend AV detected the file {0} may be infected, Response result={1}", fileName, responseContent);
                        }
                    } //end using response
                } //end using client         
            }
            catch (Exception e)
            {
                //Logged at error level because the root cause exception isn't passed back to caller
                //TODO - why?
                logger.LogError(e, nameof(IsVirusDetected) + " - caught unexpected exception, file.Name={0}", file.Name);

                throw new AntiVirusScanningException(Constants.Message.InternalErrorException);
            }

            return virusFound;
        }
    }
}
