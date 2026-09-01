namespace swz.Clover.SPCP.OIDC
{
    public class OidcSettings
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool UseWebProxyServerToAccessGateway { get; private set; } = false;

        public bool IsStateCheckEnabled { get; private set; } = true;

        public bool IsNonceCleanupEnabled { get; private set; } = true;

        public string WebProxyServer { get; private set; }

        public int? WebProxyServerPort { get; private set; } = null;

        public string WebProxyApiKey { get; private set; }

        public string GatewayUrl { get; private set; }

        public string SpcpUrl { get; private set; }

        public string RedirectUrl { get; private set; }

        public string ClientId { get; private set; }

        /// <summary>
        /// Returns true if the required values aren't configured
        /// </summary>
        /// <returns></returns>
        public bool IsInvalid()
        {
            return (string.IsNullOrEmpty(GatewayUrl) || string.IsNullOrEmpty(RedirectUrl) || string.IsNullOrEmpty(ClientId));
        }
    }
}
