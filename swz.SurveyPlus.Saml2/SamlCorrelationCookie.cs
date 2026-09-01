using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.Application;
using System;
using System.Security.Cryptography;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// The correlation cookie is used to tie the original AuthnRequest ID to the user's browser
    /// while they go over to the IdP to authenticate. 
    /// </summary>
    public class SamlCorrelationCookie
    {

        public static SamlCorrelationCookie FromAuthnRequest(AuthnRequest authnRequest)
        {
            if (authnRequest == null) throw new ArgumentNullException(nameof(authnRequest));
            return new SamlCorrelationCookie(authnRequest.ID);
        }

        public static bool TryLoad(string name, HttpRequest httpRequest, ITimeLimitedDataProtector protector, out SamlCorrelationCookie cookie)
        {
            if (name == null) throw new ArgumentNullException(nameof(name));
            if (httpRequest == null) throw new ArgumentNullException(nameof(httpRequest));
            if (protector == null) throw new ArgumentNullException(nameof(protector));

            try
            {
                cookie = null;
                if (httpRequest.Cookies.ContainsKey(name))
                {
                    string correlationCookie = httpRequest.Cookies[name];
                    try
                    {
                        string value = protector.Unprotect(correlationCookie);
                        cookie = SamlCorrelationCookie.FromCookieValue(value);
                    }
                    catch (CryptographicException) { } //Can't be read after 15 minutes
                }
                return (cookie != null);
            }
            catch (Exception e)
            {
                throw new InternalException("Unexpected exception retrieving cookie", e);
            }
        }

        public static SamlCorrelationCookie FromCookieValue(string value)
        {
            return new SamlCorrelationCookie(originalRequestID: value);
        }

        public string OriginalRequestID { get; private set; }

        public SamlCorrelationCookie(string originalRequestID)
        {
            if (string.IsNullOrWhiteSpace(originalRequestID)) throw new ArgumentException(nameof(originalRequestID));
            this.OriginalRequestID = originalRequestID;
        }

        /// <summary>
        /// Returns the (unprotected) value to use when setting the cookie
        /// </summary>
        /// <returns></returns>
        public string ToCookieValue()
        {
            return OriginalRequestID;
        }

        public void Save(string name, HttpResponse httpResponse, ITimeLimitedDataProtector protector, double expiryMinutes)
        {
            try
            {
                string encryptedValue = protector.Protect(ToCookieValue(), lifetime: TimeSpan.FromMinutes(expiryMinutes));
                httpResponse.Cookies.Append(
                    name,
                    encryptedValue,
                    new CookieOptions
                    {
                        HttpOnly = true,
                        Secure = true,
                        SameSite = SameSiteMode.None,
                        MaxAge = TimeSpan.FromMinutes(expiryMinutes)
                    });
            }
            catch (Exception e)
            {
                throw new InternalException($"Failed to save cookie", e);
            }
        }
    }
}
