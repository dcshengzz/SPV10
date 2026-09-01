using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using Newtonsoft.Json;
using swz.Clover.Core.Utils;
using System.Net.Http;
using System.Web;
using System.Collections.Specialized;
using System.Text;

namespace swz.Clover.SPCP.OIDC
{
    public class SimsCorpPassOidcProcessor : IOidcProcessor
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<SimsCorpPassOidcProcessor>();

        //Private configuration settings for IMDA (SIMS)
        private static readonly bool isPost = true; //IMDA is using POST for OIDC Resolver (Netrust)
        private static readonly string header = "x-api-key";

        private readonly OidcSettings settings;
        private readonly bool debug;

        public SimsCorpPassOidcProcessor(OidcSettings settings, bool debug)
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
            int webProxyServerPort = settings.WebProxyServerPort??80;
            string webProxyApiKey = settings.WebProxyApiKey;

            try
            {
                SocketsHttpHandler socketsHttpHandler = new SocketsHttpHandler { PooledConnectionLifetime = TimeSpan.FromMinutes(15) };

                if (useWebProxyServerToAccessGateway)
                {
                    WebProxy webProxy = new WebProxy(webProxyServer, webProxyServerPort);
                    socketsHttpHandler.Proxy = webProxy;
                }

                //HttpClient should be static, but it does not work correctly. 
                using (HttpClient httpClient = new HttpClient(socketsHttpHandler))
                {
                    if (!string.IsNullOrEmpty(webProxyApiKey))
                    {
                        httpClient.DefaultRequestHeaders.Remove(header);
                        httpClient.DefaultRequestHeaders.Add(header, webProxyApiKey);
                    }

                    NameValueCollection values = HttpUtility.ParseQueryString(string.Empty);
                    values.Add("code", code);
                    values.Add("grant_type", "authorization_code");
                    values.Add("client_id", clientId);
                    values.Add("redirect_uri", redirectUrl);

                    HttpResponseMessage httpResponseMessage = null;
                    if (isPost)
                    {
                        Uri uri = new Uri(gatewayUrl);
                        HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(values.ToDictionary<string, string>()), Encoding.UTF8, "application/json");
                        httpResponseMessage = await httpClient.PostAsync(uri, httpContent);

                        if (debug && logger.IsEnabled(LogLevel.Debug))
                        {
                            string postContent = await httpContent.ReadAsStringAsync();
                            logger.LogDebug(nameof(GetAccessToken) + " - isPost={0}, httpClient to Gateway Url: {1} \nPOST Content: {2}", isPost, uri.ToString(), postContent);
                    }
                    }
                    else
                    {
                        UriBuilder uriBuilder = new UriBuilder(gatewayUrl);
                        uriBuilder.Query = values.ToString();
                        httpResponseMessage = await httpClient.GetAsync(uriBuilder.ToString());

                        if (debug && logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(GetAccessToken) + " - isPost={0}, httpClient to Gateway Url: {1}", isPost, uriBuilder.ToString());
                        }
                    }

                    if (debug && logger.IsEnabled(LogLevel.Debug))
                    {
                        string content = await httpResponseMessage.Content.ReadAsStringAsync();
                        logger.LogDebug(nameof(GetAccessToken) + " - httpResponseMessage from Gateway: {0} \nContent: {1}", httpResponseMessage.ToString(), content);
                    }

                    if (httpResponseMessage.IsSuccessStatusCode)
                    {
                        return await httpResponseMessage.Content.ReadAsStringAsync();
                    }

                    return null;
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
                IMDAToken token = JsonConvert.DeserializeObject<IMDAToken>(accessToken);

                //TODO - should this handle a null tokenid_token_value.nonce as an invalid nonce rather than raise an exception?
                if (token.id_token_value.nonce.Equals(nonce, StringComparison.Ordinal)) //check nonce from the browser
                {
                    cPEntID = token.id_token_value.entityInfo.CPEntID;
                }
                else
                {
                    logger.LogError(nameof(ProcessAccessToken) + " - Invalid nonce, expected={0}, received={1}", nonce, token.id_token_value.nonce);
                    return null;
                }

                if (string.IsNullOrEmpty(cPEntID))
                {
                    logger.LogError(nameof(ProcessAccessToken) + " - CPEntID not found in accessToken");
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

