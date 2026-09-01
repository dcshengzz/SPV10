using Microsoft.IdentityModel.Tokens;

namespace swz.MockNevis
{
    /// <summary>
    /// Provides a single private key on demand.
    /// Implementations must be threadsafe and must provide a key that has an indepenend lifecycle from the objects
    /// that the implementation uses to create it (e.g. impl responsible for creating and disposing RSA etc).
    /// </summary>
    public interface IMockNevisPrivateKeySupplier
    {
        public SecurityKey PrivateKey();
    }
}
