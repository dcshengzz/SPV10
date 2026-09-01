using Microsoft.IdentityModel.Tokens;
using swz.KeyUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Saml2
{
    public class Saml2Keys
    {
        private readonly IPrivateKeySupplier spVerificationKeySupplier;
        private readonly IPublicKeySupplier idpVerificationKeySupplier;
        private readonly IPrivateKeySupplier spEncryptionKeySupplier;

        public Saml2Keys(
            IPrivateKeySupplier spVerificationKeySupplier,
            IPublicKeySupplier idpVerificationKeySupplier,
            IPrivateKeySupplier spEncryptionKeySupplier)
        {
            this.spVerificationKeySupplier = spVerificationKeySupplier ?? throw new ArgumentNullException(nameof(spVerificationKeySupplier));
            this.idpVerificationKeySupplier = idpVerificationKeySupplier ?? throw new ArgumentNullException(nameof(idpVerificationKeySupplier));
            this.spEncryptionKeySupplier = spEncryptionKeySupplier ?? throw new ArgumentNullException(nameof(spEncryptionKeySupplier));
        }

        /// <summary>
        /// Return the application's private key for signing the AuthnRequest.
        /// An exception is raised if no keys are available
        /// </summary>
        public async Task<RsaSecurityKey> GetServiceProviderVerificationPrivateKey()
        {
            SecurityKey key = (await spVerificationKeySupplier.PrivateKeys())
                .FirstOrDefault(k => k is RsaSecurityKey);
            if (key == null)
                throw new InvalidOperationException($"No {nameof(RsaSecurityKey)} available for request signing");
            return (RsaSecurityKey)key;
        }

        /// <summary>
        /// Return the identity provider's public keys available for checking response and assertion
        /// signatures.
        /// An exception is raised if no keys are available
        /// </summary>
        /// <returns>keys</returns>
        public async Task<IEnumerable<RsaSecurityKey>> GetIdentityProviderVerificationPublicKeys()
        {
            List<RsaSecurityKey> keys = (await idpVerificationKeySupplier.PublicKeys())
                .Where(k => k is RsaSecurityKey)
                .Cast<RsaSecurityKey>()
                .ToList();
            if (!keys.Any())
                throw new InvalidOperationException($"No {nameof(RsaSecurityKey)} available to verify identity provider signatures");
            return keys;
        }

        /// <summary>
        /// Get application's private keys available for decryption of the assertion.
        /// An exception is raised if no keys are available.
        /// </summary>
        public async Task<IEnumerable<RsaSecurityKey>> GetServiceProviderEncryptionPrivateKeys()
        {
            List<RsaSecurityKey> keys = (await spEncryptionKeySupplier.PrivateKeys())
                .Where(k => k is RsaSecurityKey)
                .Cast<RsaSecurityKey>()
                .ToList();
            if (!keys.Any())
                throw new InvalidOperationException($"No {nameof(RsaSecurityKey)} available for decryption");
            return keys;
        }

    }
}
