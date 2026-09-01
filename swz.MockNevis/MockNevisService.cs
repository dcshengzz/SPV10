using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;
using System;
using System.Collections.Generic;

namespace swz.MockNevis
{
    public interface IMockNevisService
    {
        JsonWebToken CreateNewToken();
    }

    public class MockNevisService<T> : IMockNevisService
    {
        private readonly TokenOptions tokenOptions;
        private readonly IMockNevisPrivateKeySupplier signingKeySupplier;
        private readonly IMockNevisPublicKeySupplier encryptionKeySupplier;

        public MockNevisService(
            TokenOptions tokenOptions, 
            IMockNevisPrivateKeySupplier signingKeySupplier, 
            IMockNevisPublicKeySupplier encryptionKeySupplier = null)
        {
            if (tokenOptions == null) 
                throw new ArgumentNullException(nameof(tokenOptions));
            if (signingKeySupplier == null) 
                throw new ArgumentNullException(nameof(signingKeySupplier));
            if (tokenOptions.IsUsingEncryption && encryptionKeySupplier == null)
                throw new ArgumentNullException("may not be null if using encryption", nameof(encryptionKeySupplier));
            this.tokenOptions = tokenOptions;
            this.signingKeySupplier = signingKeySupplier;
            this.encryptionKeySupplier = encryptionKeySupplier;
        }

        /// <summary>
        /// Create a new JWT token that looks like one we would expect from Nevis
        /// The entityInfo identifies the respondent UEN.
        /// The entityInfo and various other settings for the token come from our
        /// appsettings.
        /// </summary>
        /// <returns>signed jwt</returns>
        public JsonWebToken CreateNewToken()
        {
            Dictionary<string, object> claims = new Dictionary<string, object>();
            claims.Add(tokenOptions.EntityInfoClaim, tokenOptions.EntityInfo);
            if ("sub" != tokenOptions.EntityInfoClaim) claims.Add("sub", "NevisCorppass");

            SecurityTokenDescriptor descriptor = new SecurityTokenDescriptor()
            {
                Expires = DateTime.Now.AddSeconds(tokenOptions.ExpirySeconds),
                Audience = tokenOptions.Audience,
                Issuer = tokenOptions.Issuer,
                SigningCredentials = new SigningCredentials(signingKeySupplier.PrivateKey(), tokenOptions.SignatureAlgorithm),
                Claims = claims,
            };

            if(tokenOptions.IsUsingEncryption)
            {
                //provide the cryptographic key and encrypting algorithm that are used to encrypt the proof key (CEK).
                descriptor.EncryptingCredentials = new EncryptingCredentials(
                    key: encryptionKeySupplier.PublicKey(),
                    alg: tokenOptions.WrapEncryptionAlgorithm,
                    enc: tokenOptions.DataEncryptionAlgorithm);
            }

            JsonWebToken token = new JsonWebToken(new JsonWebTokenHandler().CreateToken(descriptor));
            return token;
        }

    }
}
