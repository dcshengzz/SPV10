using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;

namespace swz.Clover.Security
{
    public sealed class ExtendedPrincipal : IPrincipal
    {
        private readonly ExtendedIdentity _identity;

        public ExtendedPrincipal(ExtendedIdentity identity)
        {
            _identity = identity;
        }

        public ExtendedIdentity ExtendedIdentity
        {
            get { return _identity; }
        }

        #region IPrincipal Members

        public bool IsInRole(string role)
        {
            return GetAllUserRoles().Count(p => p == role) > 0;
        }

        public IIdentity Identity
        {
            get { return _identity; }
        }

        #endregion

        public IEnumerable<string> GetAllUserRoles()
        {
            return _identity.Roles;
        }
    }
}