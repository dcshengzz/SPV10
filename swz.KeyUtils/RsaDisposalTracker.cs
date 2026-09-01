using Microsoft.IdentityModel.Tokens;
using System;
using System.Security.Cryptography;

namespace swz.KeyUtils
{
    /// <summary>
    /// Utility object that holds a reference to an RSA instance 
    /// and implements IDisposal, tracking whether the referenced
    /// RSA should actually be disposed when Dispose is closed or not.
    /// </summary>
    public class RsaDisposalTracker : IDisposable
    {
        public static RsaDisposalTracker FromKey(RsaSecurityKey key)
        {
            if (key == null) throw new ArgumentNullException(nameof(key));
            return (key.Rsa == null)
                ? new RsaDisposalTracker(RSA.Create(key.Parameters), true)
                : new RsaDisposalTracker(key.Rsa, false);
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly RSA Rsa;
        
        /// <summary>
        /// Is it our responsibility to Dispose of this RSA instance?
        /// </summary>
        public readonly bool IsOurResponsibilityToDispose;

        public RsaDisposalTracker(RSA rsa, bool disposeOnDispose)
        {
            this.Rsa = rsa ?? throw new ArgumentNullException(nameof(rsa));
            this.IsOurResponsibilityToDispose = disposeOnDispose;
        }

        public void Dispose()
        {
            if (IsOurResponsibilityToDispose) 
                Rsa.Dispose();
        }
    }
}
