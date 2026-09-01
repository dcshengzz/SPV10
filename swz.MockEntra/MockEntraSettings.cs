namespace swz.MockEntra
{
    public class MockEntraSettings
    {
        public Saml2Settings Saml2 { get; } = new Saml2Settings();
    }

    public class Saml2Settings
    {
        public string IdentityProviderEntityID { get; private set; } = "";

        public string ServiceProviderAssertionConsumerServiceURL { get; private set; } = "http://localhost:48800/saml2/acs";

        public string ServiceProviderVerificationPublicKeyPath { get; private set; } = "";

        public bool IsServiceProviderVerificationPublicKeyPathSpecified { get => !string.IsNullOrWhiteSpace(ServiceProviderVerificationPublicKeyPath); }

        public string ServiceProviderEncryptionPublicKeyPath { get; private set; } = "";

        public bool IsServiceProviderEncryptionPublicKeyPathSpecified { get => !string.IsNullOrWhiteSpace(ServiceProviderEncryptionPublicKeyPath); }

        public string IdentityProviderSigningPrivateKeyPath { get; private set; } = "";

        public bool IsIdentityProviderSigningPrivateKetPathSpecified { get => !string.IsNullOrWhiteSpace(IdentityProviderSigningPrivateKeyPath); }

        public bool IsRequireAuthnRequestSignature { get; private set; } = true;

        public bool IsSignResponse { get; private set; } = false;

        public bool IsSignAssertion { get; private set; } = true;

        public bool IsEncryptAssertion { get; private set; } = false;

        /// <summary>
        /// Disable the signature check on the Authn2Request queryString (regardless of other settings)
        /// </summary>
        public bool IsDisableAuthnRequestSignatureVerification { get; private set; } = false;

        public string DefaultUserEmail { get; private set; } = "test@example.com";
    }
}
