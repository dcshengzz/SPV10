using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// U@App support for file management related activities (respondent file upload, file download (both respondent and other) ).
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public static class FileGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(FileGateway));
        /// <summary>
        /// This method will be used by internet survey upload file through file input control.
        /// The flag isLocalStorage should be expected to be false (NOT True).
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="apiInstance"></param>
        /// <param name="file"></param>
        /// <returns>token identifying file in dwUploadedFiles</returns>
        public static async Task<string> UploadRespondentFile(
            IHttpClientFactory httpClientFactory,
            IAntiVirusScanner antiVirus,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            StreamWithName file,
            bool onLambdaMode = false)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if(antiVirus==null) throw new ArgumentNullException(nameof(antiVirus));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (accessToken == null) throw new ArgumentNullException(nameof(accessToken));
            if (file == null) throw new ArgumentNullException(nameof(file));
            
            try
            {
                using (MemoryStream memory = new MemoryStream())
                {
                    //Pull file into memory stream so we can safely read stream twice (make a new StreamWithName referencing that)
                    file.Stream.CopyTo(memory);
                    file = new StreamWithName(memory, file.ContentType, file.Name);

                    bool virusFound = await antiVirus.IsVirusDetected(file);
                    if (virusFound) throw new VirusDetectedException(Constants.Message.UploadVirusDetected);

                    file.Stream.Seek(0, SeekOrigin.Begin); //Rewind stream to read it again below

                    HashSet<string> whitelistedExt = await GetWhiteListedFileExtension(httpClientFactory, apiHeaderOptions);
                    bool isWhiteListed = FileStorageApplication.IsFileWhitelisted(whitelistedExt, file.Name);
                    if (!isWhiteListed) 
                        throw new Exception($"" + FileStorageApplication.FILE_BLACKLISTED_MSG + " Whitelisting file name mismatched: " + file.Name);

                    (bool isBlackListed, string sign) = FileStorageApplication.IsFileBlacklisted(file);
                    if (isBlackListed) 
                        throw new Exception($"" + FileStorageApplication.FILE_BLACKLISTED_MSG + " Blacklisted file signature matched: " + sign);

                    // Allow only alphanumeric characters, underscores, hyphens, dots, and parentheses
                    string sanitizedFilename = Regex.Replace(file.Name, @"[^a-zA-Z0-9_\.\-\(\)]", "");

                    file.Stream.Seek(0, SeekOrigin.Begin); //Rewind stream to read it again below

                    //Fixed for SVP-06 for MPA SCR 2022-04-29, but reworked to use new endpoint 20230201
                    //TODO - check if the above are still applicable, can remove comment if not
                    const string partialUrl = Constants.UAppRoutes.RespondentFileUpload;
                    using (HttpClient client = httpClientFactory.CreateClient())
                    {
                        client.BaseAddress = GetApiBasePath();

                        HttpRequestMessage post = new HttpRequestMessage(HttpMethod.Post, partialUrl);

                        post.Headers.Add(Clover.Core.IntegrationApi.IntegrationApiKeys.HeaderApiKey, CloverRuntime.IntegrationApiKey);
                        post.Headers.Add("Authorization", $"Bearer {accessToken}");
                        using (MultipartFormDataContent postContent = new MultipartFormDataContent())
                        {
                            if (!onLambdaMode)
                            {
                                StreamContent streamContent = new StreamContent(file.Stream);
                                //eg: Content-Disposition: form-data; name="UploadRespondentFile"; filename="photo.jpg"
                                streamContent.Headers.Add(
                                "Content-Disposition",
                                "form-data; name=\"UploadRespondentFile\"; filename=\"" + sanitizedFilename + "\"");
                                streamContent.Headers.Add(
                                "Content-Type",
                                file.ContentType);
                                postContent.Add(streamContent, "file", sanitizedFilename);

                                post.Content = postContent;


                            }
                            else
                            {
                                using (MemoryStream ms = new MemoryStream())
                                {
                                    await file.Stream.CopyToAsync(ms);
                                    byte[] fileBytes = ms.ToArray();
                                    string base64String = Convert.ToBase64String(fileBytes);

                                    // Set base64 content in request body
                                    post.Content = new StringContent(base64String);
                                    post.Content.Headers.Add("FileName", sanitizedFilename);
                                    post.Content.Headers.Add("FileType", file.ContentType);
                                }
                            }
                            apiHeaderOptions.AddHeaderTo(client);
                            UAppUtils.TraceLogHttpClient(logger, "UploadRespondentFile", partialUrl);

                            using (HttpResponseMessage response = await client.SendAsync(post))
                            {
                                if (response.IsSuccessStatusCode)
                                {
                                    string responseContent = await response.Content.ReadAsStringAsync();
                                    dynamic result = JsonConvert.DeserializeObject(responseContent);
                                    bool success = (bool)result.success;
                                    if (success)
                                    {
                                        string token = (string)result.item;
                                        return token;
                                    }
                                    else
                                    {
                                        string message = (string)result.message;
                                        throw new InvalidOperationException($"Upload rejected by u@app endpoint - {message}");
                                    }
                                }
                                else
                                {
                                    string content = await response.Content.ReadAsStringAsync();
                                    if (UAppUtils.IsSessionInvalid(response, content))
                                        throw new SessionInvalidException();
                                    else
                                        throw new Exception(UAppUtils.ApiFailMessage(response.StatusCode, partialUrl));
                                }
                            } //end using response       
                        } //end using MultipartFormDataContent
                    } //end using client  
                }//end using memory stream
            }
            catch (InvalidOperationException) 
            {
                throw;
            }
            catch (IOException ioEx)
            {
                throw new UploadRespondentFileException("Failed to read bytes from respondent file", ioEx);
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                throw new UploadRespondentFileException("Unexpected exception when upload respondent file", e);
            }
        }

        /// <summary>
        /// Get a file via its token. Going forward this is primarily used with files uploaded by respondents to a survey
        /// (for the Download button in the file control), however it also exists to support legacy forms that still use the old
        /// token based urls for annex files. 
        /// </summary>
        public static async Task<FileData> GetFileDataByToken(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken, 
            string fileToken,
            bool onLambdaMode = false)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (!Guid.TryParse(fileToken, out var _)) throw new ArgumentException(nameof(fileToken));
            
            try
            {
                Dictionary<string, string> properties = await GetFileTokenProperties(httpClientFactory, apiHeaderOptions, accessToken, fileToken);
                Stream content = await GetFileTokenContent(httpClientFactory, apiHeaderOptions, accessToken, fileToken, onLambdaMode);
                return new FileData(content, properties);
            }
            catch (FileNotFoundException)
            {
                throw;
            }
            catch (SessionInvalidException)
            {
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetFileDataByToken) + " - caught exception, fileToken={0}, onLambdaMode={1}", fileToken, onLambdaMode);
                }
                throw new RespondentServiceException($"{nameof(GetFileDataByToken)} failed because {e.Message}", e);
            }
        } 

        public static async Task<FileData> GetLocalStorageFileDataByName(
            IHttpClientFactory httpClientFactory, 
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken, 
            string fileName, 
            Guid sampleId,
            bool onLambdaMode = false)
        {
            try
            {
                //I'd considered making it one endpoint returning multipart content (for the properties and the file) but this looked
                //to be rather tricky, so for now we'll use two endpoints, but if we do end up taking the time to understand how to do
                //that we could come back and rework this too to save on some redundant work at intranet side and the extra request
                Dictionary<string, string> properties = await GetFileLocalStorageProperties(httpClientFactory, apiHeaderOptions, accessToken, fileName);
                Stream content = await GetFileLocalStorageContent(httpClientFactory, apiHeaderOptions, accessToken, fileName, onLambdaMode);
                return new FileData(content, properties);
            }
            catch (NotFoundException nfe)
            {
                throw new FileNotFoundException(nfe.Message, nfe); //caller expects this one, not NotFoundException
            }
            catch(SessionInvalidException)
            {
                throw;
            }
            catch(Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetLocalStorageFileDataByName) + " - caught exception, fileName={0}, sampleId={1}, onLambdaMode={2}", fileName, sampleId, onLambdaMode);
                }
                throw new RespondentServiceException("Unexpected error getting a LocalStorage file by name", e);
            }
        }

        public static async Task<HashSet<string>> GetWhiteListedFileExtension(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            string whitelistedFileExtSetting = await SettingsGateway.GetSettingAsync(
                httpClientFactory,
                apiHeaderOptions,
                Constants.dwAppSettingName.WhitelistedFileExt);

            HashSet<string> extListing = new HashSet<string>();

            if (!string.IsNullOrEmpty(whitelistedFileExtSetting))
            {
                foreach (string ext in whitelistedFileExtSetting.Split(","))
                {
                    if (!string.IsNullOrEmpty(ext.Trim()))
                    {
                        extListing.Add(ext.Trim());
                    }
                }
            }

            return extListing;
        }

        private static async Task<Dictionary<string,string>> GetFileLocalStorageProperties(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            string fileName)
        {
            try
            {
                string partialUrl 
                    = Constants.UAppRoutes.FileLocalStorageProperties
                    .Replace("{fileName}", fileName);
                UAppUtils.TraceLogHttpClient(logger, "GetFileLocalStorageProperties", partialUrl);
                string json = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                Dictionary<string, string> properties = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                return properties;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch(ApiRequestException are)
            {
                if (HttpStatusCode.NotFound == are.StatusCode)
                {
                    if (logger.IsEnabled(LogLevel.Debug)) 
                        logger.LogDebug(nameof(GetFileLocalStorageProperties) + " - file not found: fileName={0}", fileName);
                    throw new NotFoundException("File not found");
                }
                else
                {
                    throw;
                }
            }
        }

        private static async Task<Dictionary<string, string>> GetFileTokenProperties(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            string fileToken)
        {
            try
            {
                string partialUrl
                    = Constants.UAppRoutes.FileTokenProperties
                    .Replace("{token}", fileToken);
                UAppUtils.TraceLogHttpClient(logger, "GetFileTokenProperties", partialUrl);
                string json = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                Dictionary<string, string> properties = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                return properties;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (ApiRequestException are)
            {
                if (HttpStatusCode.NotFound == are.StatusCode)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(GetFileLocalStorageProperties) + " - file not found: fileToken={0}", fileToken);
                    throw new NotFoundException("File not found");
                }
                else
                {
                    throw;
                }
            }
        }

        private static async Task<Stream> GetFileLocalStorageContent(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            string fileName,
            bool onLambdaMode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrEmpty(fileName)) throw new ArgumentException(nameof(fileName));

            try
            {
                string partialUrl
                    = Constants.UAppRoutes.FileLocalStorageContent
                    .Replace("{fileName}", fileName);
                UAppUtils.TraceLogHttpClient(logger, "GetFileLocalStorageContent", partialUrl);
                StreamWithName content = await UAppUtils.SendApiRequestForStreamAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken), onLambdaMode);
                return content.Stream;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (ApiRequestException are)
            {
                if (HttpStatusCode.NotFound == are.StatusCode)
                    throw new NotFoundException($"File not found");
                else
                    throw;
            }
            catch (Exception e)
            {
                throw new Exception($"{nameof(GetFileLocalStorageContent)} failed because {e.Message}", e);
            }
        }

        private static async Task<Stream> GetFileTokenContent(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            string fileToken,
            bool onLambdaMode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrEmpty(fileToken)) throw new ArgumentException(nameof(fileToken));

            try
            {
                string partialUrl
                        = Constants.UAppRoutes.FileTokenContent
                        .Replace("{token}", fileToken);
                UAppUtils.TraceLogHttpClient(logger, "GetFileTokenContent", partialUrl);
                StreamWithName content = await UAppUtils.SendApiRequestForStreamAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken), onLambdaMode);
                return content.Stream;
            }
            catch(ApiRequestException are)
            {
                if (HttpStatusCode.NotFound == are.StatusCode)
                    throw new NotFoundException($"File not found, token={fileToken}");
                else
                    throw;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                throw new Exception($"{nameof(GetFileTokenContent)} failed because {e.Message}", e);
            }
        }

    } //end of FileGateway
}
