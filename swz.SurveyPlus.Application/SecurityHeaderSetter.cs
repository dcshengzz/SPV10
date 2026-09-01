using Microsoft.AspNetCore.Http;
using Microsoft.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Object that encapsulates the logic to set the CSP and certain other headers (e.g. nosniff, frames) 
    /// as per app settings. 
    /// Will be used by ConfigureSecurityHeaders and ConfigureStaticFiles (see: SharedStartupConfigurator).
    /// Instances of this class are immutable and threadsafe.
    /// </summary>
    public class SecurityHeaderSetter
    {
        private SecurityHeaderSetting settings;
        private readonly string defaultSrc;
        private readonly string scriptSrc;
        private readonly string imgSrc;
        private readonly string connectSrc;
        private readonly string styleSrc;
        private readonly string fontSrc;
        private readonly string frameSrc;
        private readonly string frameAncestors;
        private readonly string baseUri;

        public SecurityHeaderSetter(SecurityHeaderSetting settings, string wogaaUrl = null)
        {
            //n.b If later we need to do different logic for Static file requests
            //    then can add enum RequestType {Static, Other } and pass to ctor
            //    to note (since they will use different instances)

            if (settings == null) throw new ArgumentNullException(nameof(settings));
            this.settings = settings;

            ContentSecurityPolicySetting cspSettings = settings.ContentSecurityPolicy;
            if (cspSettings.IsEnabled)
            {
                bool isWogaaEnabled = !string.IsNullOrWhiteSpace(wogaaUrl);
                bool isWogaaProduction = false;
                if (isWogaaEnabled)
                {
                    string wogaaDomain = new Uri(wogaaUrl).GetLeftPart(UriPartial.Authority);
                    switch (wogaaDomain)
                    {
                        case "https://assets.dcube.cloud":
                            isWogaaProduction = false;
                            break;
                        case "https://assets.wogaa.sg":
                            isWogaaProduction = true;
                            break;
                        default:
                            isWogaaProduction = false;
                            isWogaaEnabled = false;
                            break;
                    }
                }
                //Build the src string
                StringBuilder buildDefaultSrc = new StringBuilder();
                StringBuilder buildScriptSrc = new StringBuilder();
                StringBuilder buildImgSrc = new StringBuilder();
                StringBuilder buildConnectSrc = new StringBuilder();
                StringBuilder buildStyleSrc = new StringBuilder();
                StringBuilder buildFontSrc = new StringBuilder();

                if (isWogaaEnabled)
                {
                    if (isWogaaProduction)
                    {
                        buildDefaultSrc.Append("https://*.wogaa.sg");
                        buildScriptSrc.Append("blob: https://*.wogaa.sg");
                        buildConnectSrc.Append("https://*.wogaa.sg");
                        buildStyleSrc.Append("https://assets.wogaa.sg/");
                        buildFontSrc.Append("data: https://assets.wogaa.sg/fonts/");
                    }
                    else
                    {
                        buildDefaultSrc.Append("https://*.dcube.cloud/");
                        buildScriptSrc.Append("blob: https://*.dcube.cloud");
                        buildConnectSrc.Append("https://*.dcube.cloud");
                        buildStyleSrc.Append("https://assets.dcube.cloud/");
                        buildFontSrc.Append("data: https://assets.dcube.cloud/fonts/");
                    }
                    defaultSrc = buildDefaultSrc.ToString();
                }

                foreach (string extraSrc in cspSettings.GetAdditionalScriptSrc())
                {
                    buildScriptSrc.Append(' ');
                    buildScriptSrc.Append(extraSrc); //Most would need quotes, but we expect that to be added in the setting, not here
                }
                scriptSrc = buildScriptSrc.ToString();

                foreach (string extraSrc in cspSettings.GetAdditionalImgSrc())
                {
                    buildImgSrc.Append(' ');
                    buildImgSrc.Append(extraSrc);
                }
                imgSrc = buildImgSrc.ToString();

                foreach (string extraSrc in cspSettings.GetAdditionalConnectSrc())
                {
                    buildConnectSrc.Append(' ');
                    buildConnectSrc.Append(extraSrc);
                }
                connectSrc = buildConnectSrc.ToString();

                foreach (string extraSrc in cspSettings.GetAdditionalStyleSrc())
                {
                    buildStyleSrc.Append(' ');
                    buildStyleSrc.Append(extraSrc);
                }
                styleSrc = buildStyleSrc.ToString();

                foreach (string extraSrc in cspSettings.GetAdditionalFontSrc())
                {
                    buildFontSrc.Append(' ');
                    buildFontSrc.Append(extraSrc);
                }
                fontSrc = buildFontSrc.ToString();

                if (cspSettings.IsUsingFrameSrc)
                {
                    StringBuilder buildFrameSrc = new StringBuilder();
                    IEnumerator<string> e = cspSettings.GetFrameSrc().GetEnumerator();
                    e.MoveNext();
                    buildFrameSrc.Append(e.Current);
                    while(e.MoveNext())
                    {
                        buildFrameSrc.Append(' ');
                        buildFrameSrc.Append(e.Current);
                    }
                    frameSrc = buildFrameSrc.ToString();
                }
                else
                {
                    frameSrc = null;
                }

                if (cspSettings.IsUsingFrameAncestors)
                {
                    StringBuilder buildFrameAncestors = new StringBuilder();
                    IEnumerator<string> e = cspSettings.GetFrameAncestors().GetEnumerator();
                    e.MoveNext();
                    buildFrameAncestors.Append(e.Current);
                    while (e.MoveNext())
                    {
                        buildFrameAncestors.Append(' ');
                        buildFrameAncestors.Append(e.Current);
                    }
                    frameAncestors = buildFrameAncestors.ToString();
                }
                else
                {
                    frameAncestors = null;
                }

                if(cspSettings.IsUsingBaseUri)
                {
                    StringBuilder buildBaseUri = new StringBuilder();
                    IEnumerator<string> e = cspSettings.GetBaseUri().GetEnumerator();
                    e.MoveNext();
                    buildBaseUri.Append(e.Current);
                    while(e.MoveNext())
                    {
                        buildBaseUri.Append(' ');
                        buildBaseUri.Append(e.Current);
                    }
                    baseUri = buildBaseUri.ToString();
                }
                else
                {
                    baseUri = null;
                }
            }
        }

        public void SetSecurityHeaders(HttpContext context)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            SetContentSecurityPolicy(context);
            SetXFrameOptions(context);
            SetXContentTypeOptions(context); //nosniff
            SetXXSSProtection(context);
            SetReferrerPolicy(context);
            SetCacheControl(context);
        }

        private void SetXContentTypeOptions(HttpContext context)
        {
            bool isAddNoSniffHeader
                = settings.NoSniff
                && (!context.Response.Headers.ContainsKey(Constants.HeaderNames.XContentTypeOptions));

            if (isAddNoSniffHeader)
            {
                //context.Response.Headers.Add(Constants.HeaderNames.XContentTypeOptions, "nosniff");
                context.Response.Headers[Constants.HeaderNames.XContentTypeOptions] = "nosniff";
            }
        }

        private void SetXFrameOptions(HttpContext context)
        {
            bool isAddXFrameOptionsHeader
                = (settings.XFrameOptions != SecurityHeaderSetting.XFrameOptionsChoices.NONE)
                && (!context.Response.Headers.ContainsKey(Constants.HeaderNames.XFrameOptions));

            if (isAddXFrameOptionsHeader)
            {
                switch (settings.XFrameOptions)
                {
                    case SecurityHeaderSetting.XFrameOptionsChoices.DENY:
                        context.Response.Headers[Constants.HeaderNames.XFrameOptions] = "DENY";
                        break;

                    case SecurityHeaderSetting.XFrameOptionsChoices.SAMEORIGIN:
                        context.Response.Headers[Constants.HeaderNames.XFrameOptions] = "SAMEORIGIN";
                        break;

                    default:
                        throw new NotSupportedException(settings.XFrameOptions.ToString());
                }
            }
        }

        private void SetXXSSProtection(HttpContext context)
        {
            bool isAddXXSSProtection = (!string.IsNullOrEmpty(settings.XXSSProtection))
                && (!context.Response.Headers.ContainsKey(Constants.HeaderNames.XXSSProtection)); ;

            if (isAddXXSSProtection)
            {
                context.Response.Headers[Constants.HeaderNames.XXSSProtection] = settings.XXSSProtection;
            }
        }

        private void SetContentSecurityPolicy(HttpContext context)
        {
            if (settings.ContentSecurityPolicy.IsEnabled)
            {
                //nb: With the 401 login challenge (intranet AD) the nonce is already set
                //    This is because of the request replay, so will also see it for 404 and other errors
                //    So we need to check before generating the nonce
                if (!context.Items.TryGetValue("CSP_NONCE", out object nonce))
                {
                    //Some references:
                    //  https://content-security-policy.com/
                    //  https://csp.withgoogle.com/docs/strict-csp.html
                    //  https://stackoverflow.com/questions/37155270/content-security-policy-csp-safe-usage-of-unsafe-eval

                    //CSP nonces must be used for a single request only and generated by a cryptoworthy rng
                    //Code that emits inline script from the current request must use this value so we'll make it available in the context
                    nonce = Convert.ToBase64String(EncryptionHelper.GenerateBytes(24));
                    context.Items.Add("CSP_NONCE", nonce);
                }
                //In practice if the nonce was already generated then this header would also be set, but
                //lets check anyway and set it again if for some reason it was cleared.
                if (!context.Response.Headers.ContainsKey(HeaderNames.ContentSecurityPolicy))
                {
                    string fs = (frameSrc == null) ? "" : $"frame-src {frameSrc} ; ";
                    string fa = (frameAncestors == null) ? "" : $"frame-ancestors {frameAncestors} ; ";
                    string bu = (baseUri == null) ? "" : $"base-uri {baseUri} ; ";

                    context.Response.Headers[HeaderNames.ContentSecurityPolicy] = $"default-src 'self' {defaultSrc} ; script-src 'self' 'unsafe-eval' 'nonce-{nonce}' {scriptSrc} ; img-src 'self' data: {imgSrc} ; connect-src 'self' 'unsafe-eval' ws: {connectSrc} ; style-src 'self' 'unsafe-inline' {styleSrc} ; font-src 'self' data: {fontSrc} ; {fs}{fa}{bu}";
                }
            }
        }

        private void SetReferrerPolicy(HttpContext context)
        {
            bool isAddReferrerPolicy = (!string.IsNullOrEmpty(settings.ReferrerPolicy))
                && (!context.Response.Headers.ContainsKey(Constants.HeaderNames.ReferrerPolicy));

            if (isAddReferrerPolicy)
            {
                context.Response.Headers[Constants.HeaderNames.ReferrerPolicy] = settings.ReferrerPolicy;
            }
        }

        private void SetCacheControl(HttpContext context)
        {
            bool isAddCacheControl = (!string.IsNullOrEmpty(settings.CacheControl))
                && (!context.Response.Headers.ContainsKey(Constants.HeaderNames.CacheControl));
            if (isAddCacheControl)
            {
                var path = context.Request.Path.Value?.ToLowerInvariant();
                if (!(path != null && Constants.HeaderNames.StaticFileExtensions.Any(ext => path.EndsWith(ext, StringComparison.OrdinalIgnoreCase))))
                {
                    context.Response.Headers.CacheControl = settings.CacheControl;
                    context.Response.Headers.Pragma = settings.Pragma;
                    context.Response.Headers.Expires = settings.Expires;
                }
            }
        }
    }
}
