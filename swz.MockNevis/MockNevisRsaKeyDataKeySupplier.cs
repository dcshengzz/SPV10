using Microsoft.IdentityModel.Tokens;
using swz.KeyUtils;
using System;

namespace swz.MockNevis
{
    /// <summary>
    /// Returns key from data in a KeyData object. 
    /// Includes factory methods to instantiate from a PEM file.
    /// n.b there is no support for invalidating the data after construction.
    /// Instances are threadsafe providing the underlying byte[] of the KeyData object is not externally modified.
    /// </summary>
    /// 
    public class MockNevisRsaKeyDataKeySupplier : IMockNevisPublicKeySupplier, IMockNevisPrivateKeySupplier
    {
        //TODO - support getting it from a store (KeyUtils now has support for this)

        public static MockNevisRsaKeyDataKeySupplier FromPublicKeyPem(string pemPath)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(pemPath);
            if (!data.IsPublic) 
                throw new ArgumentException($"{pemPath} is not a supported public key type", nameof(pemPath));
            return new MockNevisRsaKeyDataKeySupplier(data);
        }

        public static MockNevisRsaKeyDataKeySupplier FromPrivateKeyPem(string pemPath)
        {
            RsaKeyData pem = RsaKeyData.ReadFromFile(pemPath);
            if (!pem.IsPrivate)
                throw new ArgumentException($"{pemPath} is not a supported private key type", nameof(pemPath));
            return new MockNevisRsaKeyDataKeySupplier(pem);
        }


        private RsaKeyData keyData;

        public MockNevisRsaKeyDataKeySupplier(RsaKeyData keyData)
        {
            this.keyData = keyData ?? throw new ArgumentNullException(nameof(keyData));
        }

        public SecurityKey PublicKey()
        {
            return keyData.PublicSecurityKey();
        }

        public SecurityKey PrivateKey()
        {
            return keyData.PrivateSecurityKey();
        }
    }
}