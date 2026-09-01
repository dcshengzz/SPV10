using System.Net;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using Newtonsoft.Json;
using System.Text;
using System.IO;
using System.Net.Http.Headers;
using Microsoft.Net.Http.Headers;
using System.Net.Mime;
using Microsoft.AspNetCore.Http;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// Some shared utility methods for use in the UnifiedAtApp implementation.
    /// Only. 
    /// Not intended for use by callers outside of UnifiedAtApp!
    /// </summary>
    public static class UAppUtils
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(UAppUtils));

        private static Uri apiBasePath; //UAppUtils code should use GetApiBasePath rather than reading directly

        /// <summary>
        /// Return the u@app api base path.
        /// Will fail-fast with an InvalidOperationException if it hasn't been initialised yet
        /// This was moved here from InternetApiMetadataProvider
        /// </summary>
        public static Uri GetApiBasePath()
        {
            if (apiBasePath == null) throw new InvalidOperationException("apiBasePath has not been initialised yet");
            return apiBasePath;
        }

        /// <summary>
        /// Must be called once only at startup to initilise the u@app API base path
        /// </summary>
        public static void InitApiBasePath(string path)
        {
            if (apiBasePath != null) throw new InvalidOperationException("apiBasePath already initialised");
            if (string.IsNullOrEmpty(path)) throw new ArgumentException(nameof(path));            
            apiBasePath = new Uri(path);
        }

        /// <summary>
        /// Get the uId from the session or null if the user is not logged in.
        /// </summary>
        public static string GetUidFromSession(ISession session)
        {
            return session?.GetString(Constants.RespondentHttpSession.uId);
        }

        /// <summary>
        /// Assemble an "Error from API" message string with a code and url.
        /// </summary>
        /// <param name="code"></param>
        /// <param name="urlExcludingBasePath"></param>
        /// <returns>message</returns>
        public static string ApiFailMessage(HttpStatusCode code, string urlExcludingBasePath)
        {
            return
                "Error from API: "
                + (int)code
                + " "
                + code
                + ", partial url=\""
                + urlExcludingBasePath
                + "\"";
        }

        public static void TraceLogHttpClient(ILogger logger, string method, string url)
        {
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace("TraceLogHttpClient: {0} url={1}", method, url);
        }

        /// <summary>
        /// Thrown by SendApiRequestAsync when a problem is encountered. 
        /// </summary>
        public class ApiRequestException : Exception
        {
            /// <summary>
            /// When the response isn't an HttpSuccess response
            /// </summary>
            public static ApiRequestException HttpError(HttpStatusCode statusCode, ApiRequest request)
            {
                //nb: actually there could be content for a non-200, but for now we aren't really interested in it
                //    and depending on the error type we might hit snags trying to read it
                return new ApiRequestException(
                    message: ApiFailMessage(statusCode, request.PartialUrl),
                    innerException: null,
                    statusCode: statusCode,
                    isInvalidResponse: false,
                    request: request,
                    responseContent: null);
            }

            /// <summary>
            /// The api returned malformed response data.
            /// </summary>
            public static ApiRequestException InvalidResponseData(string responseContent, ApiRequest request)
            {
                return new ApiRequestException(
                    message: $"Invalid api response from PartialUrl={request.PartialUrl}",
                    innerException: null,
                    statusCode: HttpStatusCode.OK,
                    isInvalidResponse: false,
                    request: request,
                    responseContent: responseContent);
            }

            public static ApiRequestException WrappingException(ApiRequest request, string message, Exception innerException)
            {
                if (message == null) throw new ArgumentNullException(nameof(message));
                if (innerException == null) throw new ArgumentNullException(nameof(innerException));
                return new ApiRequestException(
                    message: message,
                    innerException: innerException,
                    statusCode: null,
                    isInvalidResponse: false,
                    request: request,
                    responseContent: null);
            }

            // // // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// When SendApiRequestAsync gets back a 'failure' status code it will be set here. 
            /// </summary>
            public HttpStatusCode? StatusCode { get; private set; } = null;

            /// <summary>
            /// Request path and method details
            /// </summary>
            public ApiRequest Request { get; private set; } = null;

            /// <summary>
            /// This flag is set is the api returned a response but the response content is not considered to be valid
            /// (e.g. typically because it is empty or starts with >)
            /// The returned content will be available via the ResponseContent property in such cases
            /// </summary>
            public bool IsInvalidResponse { get; private set; } = false;

            /// <summary>
            /// When IsInvalidResponse flag is set this will contain the response content that was deemed to be invalid
            /// </summary>
            public string ResponseContent { get; private set; } = null;

            private ApiRequestException(
                string message,
                Exception innerException,
                HttpStatusCode? statusCode, 
                bool isInvalidResponse,
                ApiRequest request,
                string responseContent) : base(message, innerException)
            {
                this.StatusCode = statusCode;
                this.IsInvalidResponse = isInvalidResponse;
                this.Request = request;
                this.ResponseContent = responseContent;
            }
        }

        /// <summary>
        /// Represents a request to the u@app api (non-swagger endpoints).
        /// Note that where HttpContent is created by the PostXXXX factory methods it will need to be disposed, however the HttpClient
        /// used in SendApiRequestAsync will do this as a convenience, however that in turn implies you can't always re-use the ApiRequest object
        /// after passing it to SendApiRequestAsync. 
        /// </summary>
        public class ApiRequest
        {
            /// <summary>
            /// Factory method for a GET request to the u@app api that does not include an accessToken (unusual case)
            /// </summary>
            public static ApiRequest GetWithoutAccessToken(string partialUrl, Dictionary<string, string> extraHeaders = null)
            {
                return new ApiRequest(HttpMethod.Get, partialUrl, null, extraHeaders, null);
            }

            /// <summary>
            /// Factory method for a GET request to the u@app api
            /// </summary>
            public static ApiRequest Get(string partialUrl, string accessToken, Dictionary<string, string> extraHeaders = null)
            {
                if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
                return new ApiRequest(HttpMethod.Get, partialUrl, accessToken, extraHeaders, null);
            }

            /// <summary>
            /// Factory method for a GET request to the u@app api that includes a delegation master code or access code
            /// </summary>
            public static ApiRequest GetWithDelegationCode(string partialUrl, string accessToken, string delegationCode)
            {

                if (string.IsNullOrEmpty(delegationCode)) throw new ArgumentException(nameof(delegationCode));
                var extraHeaders = new Dictionary<string, string>();
                extraHeaders.Add(
                    Constants.HeaderNames.DelegationCode,
                    EncryptionHelper.EncryptStr(delegationCode.Trim(), Constants.LoginKey, Constants.LoginIv));
                return Get(partialUrl, accessToken, extraHeaders);
            }

            /// <summary>
            /// Factory methed to serialise the specified data object as json with utf8 encoding for use as the content of a POST request 
            /// Note that this creates an instance of HttpContent in the Content property which will need to be disposed later
            /// </summary>
            public static ApiRequest PostJson(string partialUrl, string accessToken, object payload, Dictionary<string, string> extraHeaders = null)
            {
                if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
                HttpContent content = new StringContent(
                        (payload == null) ? "" : JsonConvert.SerializeObject(payload),
                        Encoding.UTF8,
                        "application/json");
                return new ApiRequest(HttpMethod.Post, partialUrl, accessToken, extraHeaders, content);
            }

            /// <summary>
            /// Factory methed to serialise the specified data object as json with utf8 encoding for use as the content of a POST request
            /// and include delegation code header.
            /// Note that this creates an instance of HttpContent in the Content property and that content is disposable, so that means
            /// instances of ApiRequest aren't as immutable as they look. However I recommend not keeping them long, this class just exists more
            /// as a way to make the SendApiRequestAsync method a little more 'fluent'. 
            /// </summary>
            public static ApiRequest PostJsonWithDelegationCode(string partialUrl, string accessToken, string delegationCode, object payload)
            {
                if (string.IsNullOrEmpty(delegationCode)) throw new ArgumentException(nameof(delegationCode));
                var extraHeaders = new Dictionary<string, string>();
                extraHeaders.Add(
                    Constants.HeaderNames.DelegationCode,
                    EncryptionHelper.EncryptStr(delegationCode.Trim(), Constants.LoginKey, Constants.LoginIv));
                return PostJson(partialUrl, accessToken, payload, extraHeaders);
            }

            public static ApiRequest PostFormWithoutAccessToken(string partialUrl, Dictionary<string, string> formData, Dictionary<string, string> extraHeaders = null)
            {
                if (formData == null) throw new ArgumentNullException(nameof(formData));
                HttpContent content = new FormUrlEncodedContent(formData);
                return new ApiRequest(HttpMethod.Post, partialUrl, null, extraHeaders, content);
            }

            //I did have a Post() method for no content posts, but kept calling it by accident as extraHeaders and formData are both just dictionary
            //so kept wondering why my forms were empty at the server, so I have removed that. If you wish to call post with extra headers use PostJson
            //with null payload instead.

            public static ApiRequest PostForm(string partialUrl, string accessToken, Dictionary<string, string> formData, Dictionary<string, string> extraHeaders = null)
            {
                if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
                if (formData == null) throw new ArgumentNullException(nameof(formData));
                HttpContent content = new FormUrlEncodedContent(formData);
                return new ApiRequest(HttpMethod.Post, partialUrl, accessToken, extraHeaders, content);
            }

            public static ApiRequest PostFormWithDelegationCode(string partialUrl, string accessToken, String delegationCode, Dictionary<string, string> formData)
            {
                if (string.IsNullOrEmpty(delegationCode)) throw new ArgumentException(nameof(delegationCode));
                var extraHeaders = new Dictionary<string, string>();
                extraHeaders.Add(
                    Constants.HeaderNames.DelegationCode,
                    EncryptionHelper.EncryptStr(delegationCode.Trim(), Constants.LoginKey, Constants.LoginIv));
                return PostForm(partialUrl, accessToken, formData, extraHeaders);
            }

            public static ApiRequest PostFormForPrint(string partialUrl, string accessToken, Dictionary<string, string> formData, Dictionary<string, string> extraHeaders = null)
            {
                if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
                if (formData == null) throw new ArgumentNullException(nameof(formData));

                string jsonString = JsonConvert.SerializeObject(formData);

                HttpContent content = new StringContent(jsonString, Encoding.UTF8, "application/json");

                return new ApiRequest(HttpMethod.Post, partialUrl, accessToken, extraHeaders, content);
            }

            public HttpContent Content { get; private set; }

            public bool HasContent { get => Content != null; }

            public HttpMethod Method { get; private set; }

            /// <summary>
            /// Part of the url after the api base path
            /// </summary>
            public string PartialUrl { get; private set; }

            public string AccessToken { get; private set; }

            public bool UseAccessToken { get => !string.IsNullOrEmpty(AccessToken); }

            public Dictionary<string, string> ExtraHeaders { get; private set; }

            public bool HasExtraHeaders { get => ExtraHeaders != null && ExtraHeaders.Any(); }

            private ApiRequest(
                HttpMethod method,
                string partialUrl,
                string accessToken,
                Dictionary<string, string> extraHeaders,
                HttpContent content)
            {
                this.Method = method ?? throw new ArgumentNullException(nameof(method));
                this.PartialUrl = partialUrl ?? throw new ArgumentNullException(nameof(partialUrl));
                this.AccessToken = accessToken;
                this.ExtraHeaders = extraHeaders;
                this.Content = content;
            }
        }

        /// <summary>
        /// Use an HttpClient to send a request to the u@app api.
        /// Usage note: If there is an instance of HttpContent in the Content property of the ApiRequest it will be disposed before returning. 
        /// </summary>
        /// <param name="httpClientFactory"></param>
        /// <param name="apiHeaderOptions"></param>
        /// <param name="request">Specifies the target and content of request. NOTE THAT Content WILL BE DISPOSED BY THIS CALL</param>
        /// <param name="applyResponseValidationHeuristics">(optional) if true (the default) will apply some checks the response content (such as not empty and doesn't start with &lt;)</param>
        /// <returns>response content</returns>
        public static async Task<string> SendApiRequestAsync(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            ApiRequest request,
            bool applyResponseValidationHeuristics = true)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (request == null) throw new ArgumentNullException(nameof(request));

            try
            {
                using (HttpClient client = httpClientFactory.CreateClient())
                {
                    client.BaseAddress = GetApiBasePath();
                    using (HttpRequestMessage message = new HttpRequestMessage(request.Method, request.PartialUrl))
                    {
                        if (request.UseAccessToken)
                        {
                            message.Headers.Add("Authorization", $"Bearer {request.AccessToken}");
                        }

                        client.DefaultRequestHeaders.Add(
                            Clover.Core.IntegrationApi.IntegrationApiKeys.HeaderApiKey,
                            CloverRuntime.IntegrationApiKey);

                        apiHeaderOptions.AddHeaderTo(client);

                        if (request.HasExtraHeaders)
                        {
                            foreach (KeyValuePair<string, string> extraHeader in request.ExtraHeaders)
                            {
                                message.Headers.Add(name: extraHeader.Key, value: extraHeader.Value);
                            }
                        }

                        if (request.HasContent)
                        {
                            message.Content = request.Content;
                        }

                        long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

                        using (HttpResponseMessage response = await client.SendAsync(message))
                        {
                            long end = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                            long duration = end - start;
                            
                            if(duration > 60000 && Logger.IsEnabled(LogLevel.Warning))
                            {
                                Logger.LogWarning(nameof(SendApiRequestAsync) + " has completed the call in over 60 seconds: PartialUrl={0}, StatusCode={1}, start={2}, end={3}, duration={4}", request.PartialUrl, (int)response.StatusCode, start, end, duration);
                            }
                            else if (Logger.IsEnabled(LogLevel.Trace))
                            {
                                Logger.LogTrace(nameof(SendApiRequestAsync) + " has completed the call: PartialUrl={0}, StatusCode={1}, start={2}, end={3}, duration={4}", request.PartialUrl, (int)response.StatusCode, start, end, duration);
                            }

                            if (!response.IsSuccessStatusCode)
                            {
                                string content = await response.Content.ReadAsStringAsync();
                                if (IsSessionInvalid(response, content))
                                {
                                    throw new SessionInvalidException();
                                }
                                else
                                {
                                    LogUnsuccessfulResponse(nameof(SendApiRequestAsync), request, response, content);
                                    throw ApiRequestException.HttpError(response.StatusCode, request);
                                }
                            }

                            string responseContent = await response.Content.ReadAsStringAsync();

                            if(applyResponseValidationHeuristics)
                            {
                                if (response.StatusCode != HttpStatusCode.NoContent)
                                {
                                    //TODO - better to check the response type rather than '<', if its html then its probably an error page
                                    if (string.IsNullOrEmpty(responseContent) || responseContent.StartsWith("<"))
                                    {
                                        //Typically because intranet side redirected us to the login or 404 page
                                        throw ApiRequestException.InvalidResponseData(responseContent, request);
                                    }
                                }
                            }

                            return responseContent;
                        }//end using response
                    }//end using message
                }//end using client
            }
            finally
            {
                //Here we standardise (for this specific SendApiRequest with ApiRequest class situtation only) that the content will be
                //disposed. For HttpClient before netcore 3.0 the behaviour was to dispose in client. For HttpClient this was a design flaw
                //so they fixed it to make user responsible for the disposal. My intended use patterns for the ApiRequest class is that
                //instances aren't reused, so for us it will be convenient to always dispose. 
                //see also:
                //  https://github.com/dotnet/corefx/pull/19082
                //  https://makolyte.com/csharp-disposing-the-request-httpcontent-when-using-httpclient/
                if (request.HasContent) request.Content.Dispose();
            }
        }

        /// <summary>
        /// Log some details for troubleshooting, in particular some of the content if possible (it may contain an error message).
        /// Broken this out into a seperate method because its quite fiddly and othagonal to whatever the caller is tryng 
        /// to achieve. Typically our request utils method will call this to log more detail before throwing an exception
        /// to its caller, but that exception usually wont include response content data, just status code and url.
        /// Some known-common-unsuccessful responses (like ubiquitous .css 404s) will be ignored.
        /// </summary>
        private static void LogUnsuccessfulResponse(string methodName, ApiRequest request, HttpResponseMessage response, string content)
        {   
            if (Logger.IsEnabled(LogLevel.Error) && !IsCommonApiErrorUnworthyOfLogging(request, response, content))
            {
                //Our serilog format includes timestamp, but its ommitted in the stdout logs
                string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff zzz");
                string contentType = response?.Content?.Headers?.ContentType?.MediaType;
                string logableContent = LogableContent(response, content);
                if (logableContent == null)
                {
                    Logger.LogError(methodName + " - received unsuccessful response before {0}. PartialUrl={1}, StatusCode={2}, Response ContentType={3}, (response content not considered logable)", timestamp, request.PartialUrl, (int)response.StatusCode, contentType);
                }
                else
                {
                    Logger.LogError(methodName + " - received unsuccessful response before {0}. PartialUrl={1}, StatusCode={2}, Response ContentType={3}, Response Content={4}", timestamp,  request.PartialUrl, (int)response.StatusCode, contentType, logableContent);
                }
            }
        }
        
        private static bool IsCommonApiErrorUnworthyOfLogging(ApiRequest request, HttpResponseMessage response, string content)
        {
            //Most forms don't have an associated .css so we get a 404 when asking for them
            if ((content != null) && (404 == (int)response.StatusCode) && content.EndsWith(".css", StringComparison.InvariantCultureIgnoreCase)) 
                return true;

            //Absent -code.js also common (and is always the case for survey forms)
            if ((content != null) && (404 == (int)response.StatusCode) && content.EndsWith("-code.js", StringComparison.InvariantCultureIgnoreCase))
                return true;

            //TODO - we can add more such cases here...

            return false;
        }

        /// <summary>
        /// Extract 'logabble' content from the response. That is if its text of json then we'll try and get some of it
        /// for logging for troubleshooting (but truncate if its too big, along with a note to that effect). 
        /// </summary>
        /// <returns>logable content or null</returns>
        private static string LogableContent(HttpResponseMessage response, string content)
        {
            try
            {
                string contentType = response?.Content?.Headers?.ContentType?.MediaType;
                bool isLogable //is it some non-binary response that we can likely read if it's logged?
                    = MediaTypeNames.Text.Plain.Equals(contentType)
                    || MediaTypeNames.Application.Json.Equals(contentType)
                    || MediaTypeNames.Application.Xml.Equals(contentType)                    
                    || MediaTypeNames.Text.Html.Equals(contentType);
                if (isLogable)
                {
                    if(string.IsNullOrEmpty(content))
                    {
                        return "[no content in response]";
                    }
                    else
                    {
                        const int truncateAt = 256; //should be enough for most simple error messsages (or is that 640? :p)
                        string logableContent = (content.Length > truncateAt)
                            ? content.Substring(0, truncateAt) + $"[first {truncateAt} of {content.Length} chars]"
                            : content;
                        return logableContent;
                    }                    
                }
                else
                {
                    return null;
                }
            }
            catch(Exception e)
            {
                //We don't expect to get any exceptions here but if we do we return null so as to not interfere with
                //the caller code which is already in the process of reporting a more important problem!
                Logger.LogError(e, nameof(LogableContent) + " - caught unexpected exception extracting logable content from content");
                return null; 
            }            
        }

        /// <summary>
        /// Check if this is a 403 specific to the invalid/invalidated respondent session case (based on ReasonPhrase)
        /// (i.e. their respondent jwt got invalidated, such as by logging on again elsewhere if single session is active)
        /// </summary>
        public static bool IsSessionInvalid(HttpResponseMessage response, string content)
        {
            return
                !response.IsSuccessStatusCode
                && HttpStatusCode.Forbidden == response.StatusCode
                && Constants.Message.SessionInvalid == content;
        }

        /// <summary>
        /// Use an HttpClient to send a request to the u@app api and get back a stream result (caller is responsible for closing the 
        /// stream that is referenced in the returned StreamWithName object). This method will also try to get the content type and name from
        /// the response headers if available (or will default to use "application/unknown" and "untitled" if they are not). 
        /// Usage note: If there is an instance of HttpContent in the Content property of the ApiRequest it will be disposed before returning. 
        /// </summary>
        /// <param name="httpClientFactory"></param>
        /// <param name="apiHeaderOptions"></param>
        /// <param name="request">Specifies the target and content of request. NOTE THAT Content WILL BE DISPOSED BY THIS CALL</param>
        /// <returns>StreamWithName with STream reference and filename and contentType read from headers (if available)</returns>
        public static async Task<StreamWithName> SendApiRequestForStreamAsync(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            ApiRequest request,
            bool isLambdaMode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (request == null) throw new ArgumentNullException(nameof(request));

            try
            {
                using (HttpClient client = httpClientFactory.CreateClient())
                {
                    client.BaseAddress = GetApiBasePath();
                    using (HttpRequestMessage message = new HttpRequestMessage(request.Method, request.PartialUrl))
                    {
                        if (request.UseAccessToken)
                        {
                            message.Headers.Add("Authorization", $"Bearer {request.AccessToken}");
                        }

                        client.DefaultRequestHeaders.Add(
                            Clover.Core.IntegrationApi.IntegrationApiKeys.HeaderApiKey,
                            CloverRuntime.IntegrationApiKey);

                        apiHeaderOptions.AddHeaderTo(client);

                        if (request.HasExtraHeaders)
                        {
                            foreach (KeyValuePair<string, string> extraHeader in request.ExtraHeaders)
                            {
                                message.Headers.Add(name: extraHeader.Key, value: extraHeader.Value);
                            }
                        }

                        if (request.HasContent)
                        {
                            message.Content = request.Content;
                        }

                        long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

                        using (HttpResponseMessage response = await client.SendAsync(message))
                        {
                            long end = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                            long duration = end - start;

                            if (duration > 60000 && Logger.IsEnabled(LogLevel.Warning))
                            {
                                Logger.LogWarning(nameof(SendApiRequestForStreamAsync) + " has completed the call in over 60 seconds: PartialUrl={0}, StatusCode={1}, start={2}, end={3}, duration={4}", request.PartialUrl, (int)response.StatusCode, start, end, duration);
                            }
                            else if (Logger.IsEnabled(LogLevel.Trace))
                            {
                                Logger.LogTrace(nameof(SendApiRequestForStreamAsync) + " has completed the call: PartialUrl={0}, StatusCode={1}, start={2}, end={3}, duration={4}", request.PartialUrl, (int)response.StatusCode, start, end, duration);
                            }

                            if (response.IsSuccessStatusCode)
                            {
                                //TODO - what if its 204? (let's consider that next time if we need it...)

                                //We are going to buffer the whole file returned by the intranet api into memory here on the internet side
                                //and return that as a memory stream to caller, as the stream from httpclient will be disposed when the
                                //response is disposed.
                                //Looking at this again found this answer also recommends doing it like this
                                //so I will continue with this pattern for now
                                //see: https://stackoverflow.com/a/52189405/8243046
                                MemoryStream memory = new MemoryStream(BufferSize(response.Content.Headers));
                                using (Stream contentStream = GetContentStream(response.Content, isLambdaMode))
                                {
                                    await contentStream.CopyToAsync(memory);
                                    memory.Position = 0; //reset stream position so it can be read from the start by caller

                                    //Read the filename and content type if they were specified in the headers, or use
                                    //some defaults if not.
                                    string contentType = "application/unknown";
                                    string filename = "untitled";
                                    foreach (var header in response.Content.Headers)
                                    {
                                        if (HeaderNames.ContentType.Equals(header.Key))
                                        {
                                            contentType = header.Value.FirstOrDefault();
                                        }
                                        else if (HeaderNames.ContentDisposition.Equals(header.Key))
                                        {
                                            ContentDisposition cd = new ContentDisposition(header.Value.FirstOrDefault());
                                            filename = cd.FileName;
                                        }
                                    }
                                    return new StreamWithName(memory, contentType, filename);
                                }
                            }
                            else
                            {   //Handle error code
                                string content = await response.Content.ReadAsStringAsync();
                                if (IsSessionInvalid(response, content))
                                {
                                    throw new SessionInvalidException();
                                }
                                else
                                {
                                    LogUnsuccessfulResponse(nameof(SendApiRequestForStreamAsync), request, response, content);
                                    throw ApiRequestException.HttpError(response.StatusCode, request);
                                }
                            }
                        }//end using response
                    }//end using message
                }//end using client
            }
            finally
            {
                //Here we standardise (for this specific SendApiRequest with ApiRequest class situtation only) that the content will be
                //disposed. For HttpClient before netcore 3.0 the behaviour was to dispose in client. For HttpClient this was a design flaw
                //so they fixed it to make user responsible for the disposal. My intended use patterns for the ApiRequest class is that
                //instances aren't reused, so for us it will be convenient to always dispose. 
                //see also:
                //  https://github.com/dotnet/corefx/pull/19082
                //  https://makolyte.com/csharp-disposing-the-request-httpcontent-when-using-httpclient/
                if (request.HasContent) request.Content.Dispose();
            }
        }

        public static Stream GetContentStream(HttpContent content, bool isLambdaMode)
        {
            Stream contentStream;

            if (isLambdaMode)
            {
                var base64Content = content.ReadAsStringAsync().Result;
                byte[] binaryData = Convert.FromBase64String(base64Content);
                contentStream = new MemoryStream(binaryData);
            }
            else
            {
                contentStream = content.ReadAsStreamAsync().Result;
            }

            return contentStream;
        }

        public static int BufferSize(HttpContentHeaders headers, int defaultSize = 16384)
        {
            if (headers != null)
            {
                foreach (KeyValuePair<string, IEnumerable<string>> header in headers)
                {
                    if (HeaderNames.ContentLength.Equals(header.Key))
                    {
                        int contentLength = int.Parse(header.Value.FirstOrDefault());
                        return contentLength;
                    }
                }
            }
            return defaultSize;
        }
    }
}
