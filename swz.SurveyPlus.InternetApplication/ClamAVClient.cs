using System;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using swz.SurveyPlus.Application;
using Newtonsoft.Json;
using swz.SurveyPlus.ApiSupport;
using System.Collections.Generic;
using UAppUtils = swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication
{
    public class ClamAVResult
    {
        public bool success { get; set; } = false;
        public ClamAVData data { get; set; } = new ClamAVData();
        public string message { get; set; } = string.Empty;
    }

    public class ClamAVData
    {
        public ClamAVDataItem[] result { get; set; } = new ClamAVDataItem[0];
    }

    public class ClamAVDataItem
    {
        public string name { get; set; }
        public bool is_infected { get; set; }
        public string[] viruses { get; set; }

        public ClamAVDataItem() { }

        public ClamAVDataItem(string name)
        {
            this.name = name;
            this.is_infected = false;
            this.viruses = new string[0];
        }

        public ClamAVDataItem(string name, bool isInfected, string[] viruses)
        {
            this.name = name;
            this.is_infected = isInfected;
            this.viruses = viruses;
        }
    }

    /*
     * For running with actual Clam rather than the mock:
     * Currently this is build by referring to https://github.com/benzino77/clamav-rest-api
     * 1. Get Clamav running, make sure with proper clamd.conf setup (TCPSocket enabled to allow clamav-rest-api work with it)
     * 2. Get that clamav-rest-api running with proper .env setup
     * 3. Trigger ScanFile method to work with clamav-rest-api
     */

    public class ClamAVClient : IAntiVirusScanner
    {
        public const string CLAMAV_SETTING_DISABLED_MSG = "ClamAV setting is disabled.";
        public const string CLAMAV_SETTING_INCOMPLETE_MSG = "ClamAV setting is incomplete.";

        private readonly ILogger logger;
        private readonly IHttpClientFactory httpClientFactory;
        private readonly ClamAVOptions clamAVSettings;
        private readonly WebApiAdditionalHeaderOptions apiHeaderOptions;

        public ClamAVClient(
            ILogger<TrendAVClient> logger,
            IHttpClientFactory httpClientFactory,
            ClamAVOptions clamAVOptions,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(logger));
            this.clamAVSettings = clamAVOptions ?? throw new ArgumentNullException(nameof(clamAVOptions));
            this.apiHeaderOptions = apiHeaderOptions ?? throw new ArgumentNullException(nameof(apiHeaderOptions));

            if (string.IsNullOrEmpty(clamAVSettings?.ApiBase) || string.IsNullOrEmpty(clamAVSettings?.ScanApi) || string.IsNullOrEmpty(clamAVSettings.AppFormKey))
            {
                throw new ArgumentException(CLAMAV_SETTING_INCOMPLETE_MSG);
            }
        }

        #region Info from MPA
        //It returns the following result as in the example below. The API can scan multiple files.
        //For info, there are certain limits which are set as follows for now.
        //Max File Size: 26,214,400 bytes
        //Max File per scan: 4
        //Timeout: 30,000 milliseconds

        #region Example of Clam AV Scan File Result
        //{
        //  "success": true,
        //  "data": {
        //    "result": [
        //      {
        //        "name": "1Mfile01.rnd",
        //        "is_infected": false,
        //        "viruses": []
        //    },
        //      {
        //        "name": "eicar_com.zip",
        //        "is_infected": true,
        //        "viruses": [
        //          "Win.Test.EICAR_HDB-1"
        //        ]
        //}
        //    ]
        //  }
        //}
        #endregion
        #endregion

        public async Task<bool> IsVirusDetected(StreamWithName file)
        {
            if (!clamAVSettings.IsEnabled) 
                throw new AntiVirusScanningException(CLAMAV_SETTING_DISABLED_MSG);

            bool virusFound = false;
            try
            {
                List<ClamAVDataItem> dataList = new List<ClamAVDataItem>();
                using (HttpClient client = httpClientFactory.CreateClient())
                {
                    client.BaseAddress = new Uri(clamAVSettings.ApiBase);
                    StreamContent streamContent = new StreamContent(file.Stream);

                    streamContent.Headers.Add("Content-Disposition", "form-data; name=\"" + clamAVSettings.AppFormKey + "\"; filename=\"" + file.Name + "\"");
                    streamContent.Headers.Add("Content-Type", file.ContentType);

                    MultipartFormDataContent postContent = new MultipartFormDataContent();
                    postContent.Add(streamContent, "file", file.Name);

                    string url = clamAVSettings.ScanApi;
                    HttpRequestMessage post = new HttpRequestMessage(HttpMethod.Post, url);
                    post.Content = postContent;
                    //post.Headers.Add("Authorization", $"Bearer {accessToken}"); This post is target for Clam Antivirus, not target intranet

                    apiHeaderOptions.AddHeaderTo(client);
                    UAppUtils.TraceLogHttpClient(logger, "ClamAVScanFile", clamAVSettings.ApiBase + url);

                    using (HttpResponseMessage response = await client.SendAsync(post))
                    {
                        if (!response.IsSuccessStatusCode) throw new AntiVirusScanningException($"Response status failed: {response.ReasonPhrase}; Request message: {response.RequestMessage}");
                        string responseContent = await response.Content.ReadAsStringAsync();
                        dynamic result = JsonConvert.DeserializeObject(responseContent);
                        bool success = (bool)result.success;

                        if (!success) throw new AntiVirusScanningException($"Response result failed: {responseContent}");
                        if (result.data?.result == null) throw new AntiVirusScanningException($"Invalid result data: {responseContent}");

                        bool isFound = false;
                        foreach (dynamic item in result.data.result)
                        {
                            //Make sure to check what we sent for scan
                            if ((string)item.name != file.Name) continue;

                            isFound = true;
                            ClamAVDataItem data = new ClamAVDataItem();
                            data.name = (string)item.name;
                            data.is_infected = (bool)item.is_infected;
                            if (!data.is_infected) continue;

                            List<string> viruses = new List<string>();
                            foreach (dynamic virus in item.viruses) viruses.Add((string)virus);

                            data.viruses = viruses.ToArray();
                            virusFound = true;
                            dataList.Add(data);
                        }

                        //The file we sent for scanning is not found in the scan result
                        if (!isFound) { throw new AntiVirusScanningException($"File {file.Name} is missing from the virus scanning result, the scan result: {responseContent}"); }
                    } //end using response
                } //end using client         

                //logging
                if (virusFound)
                {
                    foreach (ClamAVDataItem data in dataList)
                    {
                        if (data.is_infected)
                        {
                            logger.LogWarning(nameof(IsVirusDetected) + " - Clam AV detected the file {0} may be infected with the following viruses: {1}", data.name, string.Join(',', data.viruses));
                        }
                    }
                }
            }
            catch (Exception e)
            {
                //We log this at error level as the root exception is not passed back to the caller for logging
                //TODO - why not?
                logger.LogError(e, nameof(IsVirusDetected) + " - caught unexpected exception, file.name={0}", file.Name);

                throw new AntiVirusScanningException(Constants.Message.InternalErrorException);
            }

            return virusFound;
        }
    }
}
