using Microsoft.IdentityModel.Tokens;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Security.Cryptography.Xml;
using System.Text;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Object that represents the data in the query string of a SAML2 request 
    /// (the query string in the redirected GET to the IdP). 
    /// Currently this is only implemented with Entra ID in mind.
    /// </summary>
    public class SamlRedirect
    {

        private static byte[] Sign(byte[] data, string algorithm, SecurityKey key)
        {
            SignatureProvider provider = key.CryptoProviderFactory.CreateForSigning(key, algorithm);
            try
            {
                return provider.Sign(data);
            }
            finally
            {
                //n.b. CryptoProviderFactory would cache instances and so we should NOT dispose them ourselves
                //     (such as with a 'using' block) but must rather release the provider back to the factory by
                //     passing it to ReleaseSignatureProvider
                //see: https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/wiki/Caching-in-Microsoft.IdentityModel
                key.CryptoProviderFactory.ReleaseSignatureProvider(provider);
            }
        }

        private static bool Verify(byte[] data, string algorithm, SecurityKey key, byte[] signature)
        {
            SignatureProvider provider = key.CryptoProviderFactory.CreateForVerifying(key, algorithm);
            try
            {
                return provider.Verify(data, signature);
            }
            finally
            {
                //n.b. CryptoProviderFactory would cache instances and so we should NOT dispose them ourselves
                //     (such as with a 'using' block) but must rather release the provider back to the factory by
                //     passing it to ReleaseSignatureProvider
                //see: https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/wiki/Caching-in-Microsoft.IdentityModel
                key.CryptoProviderFactory.ReleaseSignatureProvider(provider);
            }
        }

        /// <summary>
        /// Names of SAML2 parameters in a query string
        /// </summary>
        public static class Parameters
        {
            /// <summary>
            /// Name of query parameter holding the DEFLATEd and base64 encoded XML of the AuthnRequest
            /// </summary>
            public const string SAMLRequest = "SAMLRequest";

            /// <summary>
            /// Name of query parameter holding the value of the RelayState
            /// Aside from uri-unescaping and re-escaping when sending back the response this value will be opaque to an IdP.
            /// </summary>
            public const string RelayState = "RelayState";

            /// <summary>
            /// Name of query parameter holding the algorithm used to sign the request (if it is signed).
            /// In practice this will be http://www.w3.org/2001/04/xmldsig-more#rsa-sha256 
            /// indicating RSASSA-PKCS1-v1_5 using SHA-256
            /// </summary>
            public const string SigAlg = "SigAlg";

            /// <summary>
            /// The base64 encoded bytes of the Signature. 
            /// The signature is signed with the SPs private key and signs a payload consisting of the query string 
            /// without a leading '?' and the parameters SAMLRequest, RelayState (optional), and SigAlg in precisely 
            /// that order with the values uri-escaped as normal for a query string and the usual '&' delimiter 
            /// between parameters. 
            /// </summary>
            public const string Signature = "Signature";
        }

        /// <summary>
        /// Create an instance fron the provided AuthnRequest.
        /// If a private key is provided it will be used to sign it.
        /// </summary>
        /// <param name="authnRequest">the request</param>
        /// <param name="relayState">optional relay state</param>
        /// <param name="privateKey">optional key to sign the request</param>
        /// <returns>object to prepare the redirect request query string</returns>
        public static SamlRedirect FromAuthnRequest(
            AuthnRequest authnRequest, 
            string relayState, 
            RsaSecurityKey privateKey = null)
        {
            bool isRelayStateProvided = (relayState != null);
            bool isRequestBeingSigned = (privateKey != null);

            SamlRedirect sr = new SamlRedirect();
            string rawxml = authnRequest.ToXml().ToString(System.Xml.Linq.SaveOptions.DisableFormatting);           
            string samlRequest = ConversionUtils.DeflateAndBase64Encode(rawxml);
            sr.UriEscapedSamlRequest = Uri.EscapeDataString(samlRequest);
            if (isRelayStateProvided)
            {
                sr.UriEscapedRelayState = Uri.EscapeDataString(relayState);
            }
            if(isRequestBeingSigned)
            {
                sr.UriEscapedSigAlg = Uri.EscapeDataString(SignedXml.XmlDsigRSASHA256Url); //Must set before assembling payload
                byte[] payload = Encoding.UTF8.GetBytes(sr.BaseQueryString(true));
                sr.Signature = Sign(payload, SecurityAlgorithms.RsaSha256, privateKey);                
                sr.UriEscapedSignature = Uri.EscapeDataString(Convert.ToBase64String(sr.Signature));                
            }
            sr.AssertComplete();
            return sr;
        }

        /// <summary>
        /// Factory method that constructs an instance based on a literal query string (where parameter values are still
        /// uri-escaped). i.e. the string you would get from Request.QueryString.Value
        /// An improperly formed SAML2 redirect query will raise an exception (e.g. invalid base64, Signature without SigAlg,
        /// duplicate parameters, missing SAMLRequest), but the authenticity of the signature or the validity of the request 
        /// XML itself is not checked here.
        /// Unrelated query parameters in the query string are ignored
        /// </summary>
        /// <param name="rawQuery">a literal query string (the initial ? is optional)</param>
        /// <returns>a parsed instance of SamlRequest</returns>
        public static SamlRedirect FromQueryString(string rawQueryString)
        {
            if (string.IsNullOrWhiteSpace(rawQueryString))
                throw new ArgumentException(nameof(rawQueryString));

            SamlRedirect sr = new SamlRedirect();
            string queryString = rawQueryString.TrimStart('?');

            string[] parameters = queryString.Split('&');
            foreach (string param in parameters)
            {
                string[] parts = param.Split(new[] { '=' }, 2);
                string key = parts[0];
                string value = (parts.Length==2) ? parts[1] : "";  //check length in case passed as &foo&bar&baz with no value!
                switch (key)
                {
                    case Parameters.SAMLRequest: sr.InitSAMLRequest(value); break;
                    case Parameters.RelayState: sr.InitRelayState(value); break;
                    case Parameters.SigAlg: sr.InitSigAlg(value); break;
                    case Parameters.Signature: sr.InitSignature(value); break;
                    default:
                        //here we ignore superflous parameters
                        //do note any such parameters are considered unrelated to SAML2 and aren't protected by signature
                        break;
                }
            }
            sr.AssertComplete();
            return sr;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public string UriEscapedSamlRequest { get; private set; }

        public string UriEscapedRelayState { get; private set; }

        public string UriEscapedSigAlg { get; private set; }

        public string UriEscapedSignature { get; private set; }

        /// <summary>
        /// The value of the SAMLRequest token (this is the base64 encoding of the DEFLATE compressed XML)
        /// </summary>
        public string SAMLRequest { get => Uri.UnescapeDataString(UriEscapedSamlRequest); }

        public string RelayState { get => IsRelayStateProvided ? Uri.UnescapeDataString(UriEscapedRelayState) : null; }

        public bool IsRelayStateProvided { get => (UriEscapedRelayState != null); }

        public string SigAlg { get => (UriEscapedSigAlg != null) ? Uri.UnescapeDataString(UriEscapedSigAlg) : null; }

        public bool IsSigAlgRsaSha256 { get => SignedXml.XmlDsigRSASHA256Url.Equals(SigAlg, StringComparison.Ordinal); }

        public byte[] Signature { get; private set; }

        public bool IsSignatureProvided { get => Signature != null; }

        public string QueryString { get => IsSignatureProvided
                ? $"{BaseQueryString(true)}&{Parameters.Signature}={UriEscapedSignature}"
                : BaseQueryString(false); }

        /// <summary>
        /// Constructor is private, other classes must use factory method to instantiate
        /// </summary>
        private SamlRedirect()
        {
            //Construction is managed by the static factory methods that can access private properties
            //Factory methods are responsible for ensuring a completely initialised objects and should
            //invoke AssertComplete before returning the instance to their caller.
            //Instances of SamlRedirect are intended to be immutable once they have been returned by the
            //factory method. Please do not add any public setters to them.
        }

        public override string ToString()
        {
            string relayState = IsRelayStateProvided ? $",{nameof(RelayState)}={RelayState}" : "";
            string sig = IsSignatureProvided ? $",{nameof(SigAlg)}={SigAlg}, {nameof(Signature)}={Signature}" : "";
            return $"{nameof(SamlRedirect)}[{nameof(SAMLRequest)}={SAMLRequest}{relayState}, ]";
        }

        /// <summary>
        /// Convenience method to call IsSignedWith to check with each key in turn until one succeeds.
        /// If none succeed then an exception is raised. 
        /// An exception is raised if no keys are provided.
        /// </summary>
        /// <param name="keys">the keys to check signature with, may not be null or empty</param>
        /// <exception cref="Exception">raised on error or failure to verify signature</exception>
        public void AssertSignatureIsValid(IEnumerable<SecurityKey> keys)
        {
            if (keys == null) 
                throw new ArgumentNullException(nameof(keys));
            ImmutableList<RsaSecurityKey> rsaKeys 
                = keys.Where(key => key is RsaSecurityKey)
                .Cast<RsaSecurityKey>()
                .ToImmutableList();
            if (!rsaKeys.Any()) 
                throw new Exception($"No instances of {nameof(RsaSecurityKey)} were provided");            
            if(!rsaKeys.Any(key => IsSignedWith(key)))
                throw new Exception($"The signature failed validation, {rsaKeys.Count()} key(s) tried");
        }

        public bool IsSignedWith(RsaSecurityKey signerPublicKey)
        {
            if (!IsSignatureProvided)
                return false;
            if (!IsSigAlgRsaSha256)
                throw new InvalidOperationException($"{SigAlg} is not supported for {Parameters.SigAlg}");
            byte[] payload = Encoding.UTF8.GetBytes(BaseQueryString(true));
            return Verify(payload, SecurityAlgorithms.RsaSha256, signerPublicKey, Signature);
        }

        /// <summary>
        /// Inflate the SAMLRequest and use it to construct an AuthnRequest object
        /// </summary>
        /// <returns>authnRequest</returns>
        public AuthnRequest ToAuthnRequest()
        {
            string rawxml = ConversionUtils.Base64DecodeAndInflate(SAMLRequest);
            return AuthnRequest.FromXml(rawxml);
        }

        private void AssertComplete()
        { 
            if (UriEscapedSamlRequest == null)
                throw new InvalidOperationException($"{Parameters.SAMLRequest} was not specified"); //missing param in URL

            if (IsSignatureProvided)
            {
                if(string.IsNullOrWhiteSpace(UriEscapedSigAlg))
                    throw new InvalidOperationException($"{Parameters.Signature} is present but {Parameters.SigAlg} was not specified"); //missing param in URL

                if(UriEscapedSignature == null)
                    throw new InvalidOperationException($"Unexpected Error - {nameof(Signature)} has value but {nameof(UriEscapedSignature)} is not initialised");  //This would only result from internal logic error in code
            }
        }

        /// <summary>
        /// For use by factory method that constructs an instance from a URL query string
        /// </summary>
        private void InitSAMLRequest(string uriEncodedSamlRequest)
        {
            //Note that we have implemented it to take in the uri-encoded one (and decode here) rather than the
            //other way around because for the signature verification case (e.g. in our mock IdP or test cases)
            //we want to preserve the exact literal uri-encoded text that came from the url rather than be subject
            //to any possible round-trip induced changes our local encoding impl might introduce that result in a
            //difference from what caller sent in the URL (this consideration also applies to the other init methods
            //in this class that also take uri-encoded values). The signature is going to be based on the exact bits in
            //how the caller encoded it (eg %2f vs %2F etc)
            if (uriEncodedSamlRequest == null)
                throw new ArgumentNullException(nameof(uriEncodedSamlRequest));
            if (this.UriEscapedSamlRequest != null)
                throw new InvalidOperationException($"Only one {Parameters.SAMLRequest} is permitted");
            this.UriEscapedSamlRequest = uriEncodedSamlRequest;
        }

        /// <summary>
        /// For use by factory method that constructs an instance from a URL query string
        /// </summary>
        private void InitRelayState(string uriEncodedRelayState)
        {
            if (uriEncodedRelayState == null)
                throw new ArgumentNullException(nameof(uriEncodedRelayState));
            if(this.UriEscapedRelayState != null)
                throw new InvalidOperationException($"Only one {Parameters.RelayState} is permitted");
            this.UriEscapedRelayState = uriEncodedRelayState;
        }

        /// <summary>
        /// For use by factory method that constructs an instance from a URL query string
        /// </summary>
        private void InitSigAlg(string uriEncodedSigAlg)
        {
            if (uriEncodedSigAlg == null)
                throw new ArgumentNullException(nameof(uriEncodedSigAlg));
            if(this.UriEscapedSigAlg != null)
                throw new InvalidOperationException($"Only one {Parameters.SigAlg} is permitted");
            this.UriEscapedSigAlg = uriEncodedSigAlg;
        }

        /// <summary>
        /// For use by factory method that constructs an instance from a URL query string
        /// </summary>
        private void InitSignature(string uriEncodedSignature)
        {
            if(this.UriEscapedSignature != null)
                throw new InvalidOperationException($"Only one {Parameters.Signature} is permitted");
            if (uriEncodedSignature != null)
            {
                this.UriEscapedSignature = uriEncodedSignature;
                try
                {
                    this.Signature = Convert.FromBase64String(Uri.UnescapeDataString(uriEncodedSignature));
                }
                catch(FormatException fe)
                {
                    throw new InvalidOperationException($"{Parameters.Signature} is not valid uri-escaped Base64", fe);
                }
            }            
        }

        /// <summary>
        /// The query string without the Signature parameter. If the request is being signed this
        /// gives the utf 8 form of the payload that is signed including the SigAlg. 
        /// When not being signed then this is already the entire query string for the request.
        /// Be sure that the SAMLRequest, RelayState (if in use), and SigAlg are all initialised
        /// before calling this as these formed the base query string for signing.
        /// </summary>
        /// <returns>query string without signature appended yet</returns>
        private string BaseQueryString(bool isBeingSigned)
        {
            //We assemble the string ourselves rather than use QueryBuilder (et al)
            //so that we maintain exact control over the assembly and encoding and avoid any surprises
            //from .NET trying to be 'smart' with optimisations or order.
            StringBuilder queryString = new StringBuilder();
            queryString.Append($"{Parameters.SAMLRequest}={UriEscapedSamlRequest}");
            if (IsRelayStateProvided)
                queryString.Append($"&{Parameters.RelayState}={UriEscapedRelayState}");
            if(isBeingSigned)
            {
                if (UriEscapedSigAlg == null) //factories should have set already (here explicit "" is also considered as set)
                    throw new NullReferenceException(nameof(UriEscapedSigAlg));
                queryString.Append($"&{Parameters.SigAlg}={UriEscapedSigAlg}");
            }                
            return queryString.ToString();
        }

    }
}
