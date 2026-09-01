using Microsoft.IdentityModel.Tokens;
using System;

namespace swz.Clover.AuthServices.Jwt.Services
{
    /// <summary>
    /// Interface that the jwt service will use to get a key for signing and checking signature. 
    /// The service will call this each time it needs the key. If retrieval of the key is a heavy
    /// task the implementation of this interface may wish to cache it, in which case it must take
    /// care to handle this in a threadsafe manner because the service is a singleton. (The supplier
    /// is injected into the service and it holds the reference after that).
    /// </summary>
    public interface ISigningKeySupplier
    {
        /// <summary>
        /// Provide the key used for intranet 3PA/User token signatures
        /// </summary>
        public SecurityKey GetUserKey();

        /// <summary>
        /// Provide the key used for internet respondent U@App token signatures
        /// </summary>
        public SecurityKey GetRespondentKey();
    }

    /// <summary>
    /// Basic implementation of ISigningKeySupplier that creates SymmetricSecurityKey instances for the
    /// provided byte arrays.
    /// </summary>
    public class ByteArraySymmetricSigningKeySupplier : ISigningKeySupplier
    {
        //For HS256 general practice for key size is 32 or 64 bytes (i.e 256 or 512 bits).
        //Smaller than 32 is insecure, larger than 64 adds no further security benefit. 
        //Gemini states "the performance difference between using a 32-byte (256-bit) key and a 64-byte (512-bit)
        //key for HS256 signing with libraries like Microsoft.IdentityModel.JsonWebTokens is generally considered
        //not significant and is likely negligible in most real-world applications."

        //On re-using the SecurityKey object instead of creating it on each request, Gemini notes:
        //Yes, generally instances of `Microsoft.IdentityModel.Tokens.SecurityKey` and its common derivatives
        //(`SymmetricSecurityKey`, `RsaSecurityKey`, `ECDsaSecurityKey`, `JsonWebKey`)
        //**are considered thread-safe** for the purpose of being used repeatedly for signing and validation operations.

        private readonly SecurityKey userKey;
        private readonly SecurityKey respondentKey;

        public ByteArraySymmetricSigningKeySupplier(byte[] userKey, byte[] respondentKey)
        {
            if (userKey == null) throw new ArgumentNullException(nameof(userKey));
            if (userKey.Length == 0) throw new ArgumentException("may not be empty", nameof(userKey));
            if (respondentKey == null) throw new ArgumentNullException(nameof(respondentKey));
            if (respondentKey.Length == 0) throw new ArgumentException("may not be empty", nameof(respondentKey));
            this.userKey = new SymmetricSecurityKey(userKey);
            this.respondentKey = new SymmetricSecurityKey(respondentKey);
        }

        public SecurityKey GetUserKey()
        {
            return userKey;
        }

        public SecurityKey GetRespondentKey()
        {
            return respondentKey;
        }
    }
}
