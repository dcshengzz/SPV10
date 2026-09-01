using Microsoft.IdentityModel.Tokens;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.KeyUtils
{
    /// <summary>
    /// Interface that allows us to abstract the logic to get public SecurityKey
    /// /// For RSA keys the general-purpose implementation is RsaKeyDataKeySupplier
    /// </summary>
    public interface IPublicKeySupplier
    {
        /// <summary>
        /// Returns a list of SecurityKey. This may be empty but will not be null.
        /// Caller may mutate the list collection that is returned. 
        /// </summary>
        /// <returns>public keys</returns>
        Task<List<SecurityKey>> PublicKeys();
    }
}
