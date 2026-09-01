using Microsoft.IdentityModel.Tokens;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.KeyUtils
{
    /// <summary>
    /// Placeholder implementation of IPublicKeySupplier and IPrivateKeySupplier that always returns an empty list
    /// </summary>
    public class NoKeySupplier : IPublicKeySupplier, IPrivateKeySupplier
    {
        /// <summary>
        /// Flyweight instance
        /// </summary>
        public static readonly NoKeySupplier Instance = new NoKeySupplier();

        public Task<List<SecurityKey>> PublicKeys()
        {
            //Doesn't use flyweight list because caller is allowed to modify the returned list collection
            return Task.FromResult(new List<SecurityKey>());
        }

        public Task<List<SecurityKey>> PrivateKeys()
        {
            //Doesn't use flyweight list because caller is allowed to modify the returned list collection
            return Task.FromResult(new List<SecurityKey>());
        }
    }
}
