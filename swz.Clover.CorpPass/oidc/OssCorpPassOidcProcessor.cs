using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using Newtonsoft.Json;
using swz.Clover.Core.Utils;
using System.Net.Http;
using System.Net.Http.Json;
using System.Collections.Specialized;
using System.Web;

namespace swz.Clover.SPCP.OIDC
{
    public class OssCorpPassOidcProcessor : IOidcProcessor
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<OssCorpPassOidcProcessor>();

        //Private configuration settings for OSS
        private static readonly bool isPost = false; //OSS is using GET for OIDC Resolver
        private static readonly string header = "";

        private readonly OidcSettings settings;
        private readonly bool debug;

        public OssCorpPassOidcProcessor(OidcSettings settings, bool debug)
        {
            if (settings == null) throw new ArgumentNullException(nameof(settings));
            if (settings.IsInvalid()) throw new ArgumentException(nameof(settings));
            this.settings = settings;
            this.debug = debug;
        }

        public async Task<string> GetAccessToken(string code)
        {
            string clientId = settings.ClientId;
            string gatewayUrl = settings.GatewayUrl;
            string redirectUrl = settings.RedirectUrl;
            bool useWebProxyServerToAccessGateway = settings.UseWebProxyServerToAccessGateway;
            string webProxyServer = settings.WebProxyServer;
            int webProxyServerPort = settings.WebProxyServerPort ?? 80;
            string webProxyApiKey = settings.WebProxyApiKey;

            try
            {
                NameValueCollection values = HttpUtility.ParseQueryString(string.Empty);
                values.Add("code", code);
                values.Add("grant_type", "authorization_code");
                values.Add("client_id", clientId);
                values.Add("redirect_uri", redirectUrl);
                //values.Add("nonce", nonce); //OSS may need to send user browser nonce to OIDC resolver for checking


                HttpClientHandler httpClientHander = new HttpClientHandler();
                if (useWebProxyServerToAccessGateway)
                {
                    WebProxy webProxy = new WebProxy(webProxyServer, webProxyServerPort);
                    httpClientHander = new HttpClientHandler
                    {
                        Proxy = webProxy,
                    };
                }

                using (HttpClient httpClient = new HttpClient(httpClientHander))
                {
                    if (!string.IsNullOrEmpty(webProxyApiKey))
                    {
                        httpClient.DefaultRequestHeaders.Remove(header);
                        httpClient.DefaultRequestHeaders.Add(header, webProxyApiKey);
                    }

                    HttpResponseMessage httpResponseMessage = null;
                    if (isPost)
                    {
                        httpResponseMessage = await httpClient.PostAsJsonAsync(new Uri(gatewayUrl), values);
                    }
                    else
                    {
                        UriBuilder uriBuilder = new UriBuilder(gatewayUrl);
                        uriBuilder.Query = values.ToString();
                        httpResponseMessage = await httpClient.GetAsync(uriBuilder.ToString());
                    }

                    if (debug)
                        logger.LogDebug("responseString from Gateway: {0} \nContent: {1}", httpResponseMessage.ToString(), await httpResponseMessage.Content.ReadAsStringAsync());

                    if (httpResponseMessage.IsSuccessStatusCode)
                    {
                        return await httpResponseMessage.Content.ReadAsStringAsync();
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetAccessToken) + " - Unable to get Access Tokens from Gateway");
            }
            return null;
        }

        public async Task<string> ProcessAccessToken(string accessToken, string nonce)
        { 
            try
            {
                string cPEntID = null;
                EMAToken token = JsonConvert.DeserializeObject<EMAToken>(accessToken);

                if (token.status == true)
                {
                    cPEntID = token.attributes.UserInfo.CPEntID;
                } 
                else
                {
                    logger.LogCritical("Gateway status return false");
                    return null;
                }

                if (string.IsNullOrEmpty(cPEntID))
                {
                    logger.LogCritical("CPEntID not found in accessToken");
                    return null;
                }

                return cPEntID;
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProcessAccessToken) + " - Unable to process accessToken returned from GateWay");
            }
            return null;
        }

    }
}

