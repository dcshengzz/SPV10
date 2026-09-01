using System.Security.Cryptography;
using System.Security.Cryptography.Xml;
using System.Security.Cryptography.X509Certificates;
using Microsoft.IdentityModel.Tokens;
using System.Collections.Generic;
using System.Xml;
using System.Linq;
using swz.KeyUtils;
using System;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Subclass of EncryptedXml to provide keys for decrypting SAML EncryptedAssertion
    /// using the service provider encryption private key(s).
    /// Takes an enumerable of keys and will try the one matching any thumbprint hint in the
    /// encrypted section first before trying the rest.
    /// </summary>
    public class SamlEncryptedXml : EncryptedXml
    {
        public class UnableToDecryptKeyException : CryptographicException
        {
            public UnableToDecryptKeyException(int attemptedKeyCount, string thumbprintHint) 
                : base($"{nameof(SamlEncryptedXml)} failed to decrypt the session key, {attemptedKeyCount} keys were tried, thumbPrintHint={thumbprintHint ?? "null"}") 
            { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(SamlEncryptedXml));

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly IEnumerable<RsaSecurityKey> privateKeys;

        public SamlEncryptedXml(XmlDocument document, IEnumerable<RsaSecurityKey> privateKeys)
            : base(document)
        {
            this.privateKeys = privateKeys ?? throw new ArgumentNullException(nameof(privateKeys));
        }

        public override byte[] DecryptEncryptedKey(EncryptedKey encryptedKey)
        {
            //There may be a thumbprint hint from IdP, if we can match that to a key we'll try that key first
            string thumbprintHint = GetThumbprintHint(encryptedKey);
            IEnumerable<RsaSecurityKey> orderedKeys
                = (thumbprintHint != null)
                ? privateKeys.OrderByDescending(k => k.KeyId == thumbprintHint)
                : privateKeys;
            int attemptedKeyCount = 0;
            foreach (RsaSecurityKey key in orderedKeys)
            {
                using RsaDisposalTracker t = RsaDisposalTracker.FromKey(key);
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(DecryptEncryptedKey) + " - attempting decrypt, KeyId={0}, keySize={1}, IsOurResponsibilityToDispose={2}, attempted keyCount={3}", key.KeyId, key.KeySize, t.IsOurResponsibilityToDispose, attemptedKeyCount);
                try
                {
                    // SAML supports both RSA-OAEP and the older RSA-v1.5
                    bool useOaep = encryptedKey.EncryptionMethod?.KeyAlgorithm == EncryptedXml.XmlEncRSAOAEPUrl;

                    // Attempt to decrypt the AES session key
                    return DecryptKey(encryptedKey.CipherData.CipherValue, t.Rsa, useOaep);
                }
                catch (CryptographicException cEx)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(cEx, nameof(DecryptEncryptedKey) + " - failed to decrypt the encrypted key in the XML. KeyAlgorithm={0}, thumbPrintHint={1}, using KeyId={0}", encryptedKey.EncryptionMethod?.KeyAlgorithm, thumbprintHint,  key.KeyId );
                    // This private key failed (incorrect key). Move to the next one.
                    attemptedKeyCount++;
                    continue;
                }
            }
            throw new UnableToDecryptKeyException(attemptedKeyCount, thumbprintHint);
        }

        private string GetThumbprintHint(EncryptedKey encryptedKey)
        {
            foreach (KeyInfoClause clause in encryptedKey.KeyInfo)
            {
                if (clause is KeyInfoX509Data x509Data && x509Data.Certificates.Count > 0)
                {
                    return ((X509Certificate2)x509Data.Certificates[0]).Thumbprint;
                }
            }
            return null;
        }
    }
}
