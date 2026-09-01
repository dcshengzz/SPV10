namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Holds the configuration data read from the SAML2 block in appsettings.json
    /// </summary>
    public class Saml2Options
    {
        public string AssertionConsumerServiceURL { get; private set; } = "";

        public bool IsAssertionConsumerServiceURLSpecified { get => !string.IsNullOrWhiteSpace(AssertionConsumerServiceURL); }

        public string Destination { get; private set; } = "";

        /// <summary>
        /// This application's unique identifier configured in the Identity Provider.
        /// Used for the Issuer in the request sent to the IdP, and checked against the 
        /// Audience in Assertion in the Response from the IdP.
        /// This is case-sensitive.
        /// For Entra ID may look something like api://{YOUR_CLIENT_ID_OR_ENTITY_ID}
        /// </summary>
        public string ServiceProviderEntityID { get; private set; } = "";

        /// <summary>
        /// The expected identifier of the Identity Provider. (Currently we only support
        /// a single value here which we use for both Response and Assertion)
        /// This is the expected value for the IssuerID in the Response and its Assertion.
        /// It is case-sensitive.
        /// For Entra ID it may look something like https://sts.windows.net/{tenant-id}/
        /// </summary>
        public string IdentityProviderEntityID { get; private set; } = "";

        public bool IsRequireSignedResponse { get; private set; } = true;

        public bool IsRequireSignedAssertion { get; private set; } = true;

        public SessionBehaviour SessionBehaviour { get; private set; } = SessionBehaviour.Default;

        public bool IsSignAuthnRequest { get; private set; } = false;

        public string ServiceProviderVerificationPrivateKeyPath { get; private set; } = "";

        public bool IsServiceProviderVerificationPrivateKeySpecified { get => !string.IsNullOrWhiteSpace(ServiceProviderVerificationPrivateKeyPath); }

        public string IdentityProviderVerificationPublicKeyPath { get; private set; } = "";

        public bool IsIdentityProviderVerificationPublicKeyPathSpecified { get => !string.IsNullOrWhiteSpace(IdentityProviderVerificationPublicKeyPath); }

        public string ServiceProviderEncryptionPrivateKeyPath { get; private set; } = "";

        public bool IsServiceProviderEncryptionPrivateKeySpecified { get => !string.IsNullOrWhiteSpace(ServiceProviderEncryptionPrivateKeyPath); }

        public int ClockSkewSeconds { get; private set; } = 30;

        /// <summary>
        /// Check the record of recently received Assertion ID to ensure uniqueness
        /// This should be true except in test or diagnostic scenarios
        /// </summary>
        public bool IsCheckForAssertionReplay { get; private set; } = true;

        /// <summary>
        /// Expired AssertionID Cleanup Job Schedule. Cron syntax with times in UTC 
        /// If empty or not explicitly defined in the JSON then the job will be disabled. 
        /// </summary>
        public string CleanupExpiredAssertionIDSchedule { get; private set; } = ""; //json should override this

        public bool IsCleanupExpiredAssertionIDEnabled { get => !string.IsNullOrWhiteSpace(CleanupExpiredAssertionIDSchedule); }

        public string SamlCorrelationCookieName { get; private set; } = "__Host-SamlCorrelation";

        public bool IsSetCorrelationCookie { get; private set; } = true;

        /// <summary>
        /// Always require the correlation cookie to be present regardless of whether
        /// there are InResponseTo attributes in the response or not. (A true value is
        /// not compatible with IdP initiated login)
        /// </summary>
        public bool IsRequireCorrelationCookie { get; private set; } = true;

        public double CorrelationCookieExpiryMinutes { get; set; } = 15;

        public bool IsLogResponseXml { get; private set; } = false;

        public bool IsLogDecryptedAssertionXml { get; private set; } = false;
    }
}
