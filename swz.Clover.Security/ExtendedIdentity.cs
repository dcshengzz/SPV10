using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;

namespace swz.Clover.Security
{
    public sealed class ExtendedIdentity : IIdentity
    {
        private readonly bool _isAuthenticated;
        private readonly string _name;
        internal IEnumerable<string> _roles;

        internal ExtendedIdentity(string name, bool isAuthenticated, IEnumerable<string> roles)
        {
            _name = name;
            _isAuthenticated = isAuthenticated;
            _roles = roles;
        }

        internal IEnumerable<string> Roles
        {
            get { return _roles.ToList(); }
        }

        #region IIdentity Members

        public string Name
        {
            get { return _name; }
        }

        public string AuthenticationType { get; set; }

        public bool IsAuthenticated
        {
            get { return _isAuthenticated; }
        }

        #endregion
    }
}