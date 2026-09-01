using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.Clover.Core.Security
{
    public class User
    {
        public User(Guid id, string name)
        {
            Id = id;
            Name = name;
        }

        public Guid Id { get; set; }
        public string Name { get; set; }

        public string Email { get; set; }

        public bool IsLocked { get; set; }

        public List<string> Roles { get; set; }
        public List<string> Groups { get; set; }

        public bool IsInRole(string role, bool caseSensitive = false)
        {
            if (caseSensitive)
                return Roles.Any(r => r.Equals(role));
            return Roles.Any(r => r.Equals(role,StringComparison.OrdinalIgnoreCase));
        }
        
        public bool IsInGroup(string group, bool caseSensitive = false)
        {
            if (caseSensitive)
                return Groups.Any(r => r.Equals(group));
            return Groups.Any(r => r.Equals(group,StringComparison.OrdinalIgnoreCase));
        }

        public async Task<bool> IsInStructDivisionAsync(Guid structDivisionId)
        {
            HashSet<Guid> structDivisions = await StructDivision.SelectChildrenAndThisIdSetAsync(this);
            return structDivisions.Contains(structDivisionId);
        }

        public string Timezone { get; set; }
        public string Localization { get; set; }
        public Guid? ImpersonatedUserId { get; set; }
        public string ImpersonatedUserName { get; set; }
        public Guid? StructDivisionId { get; set; }
        public string GaSalt { get; set; }
        public DateTime? LastLoginDate { get; set; }
		public int NumRetry { get; set; }
		public string IpAddress { get; set; }
		public string BrowserType { get; set; }
        public string LinkedDomainLogin { get; set; }

        public Guid GetOperationUserId()
        {
            return ImpersonatedUserId.HasValue ? ImpersonatedUserId.Value : Id;
        }

        public string GetOperationUserName()
        {
            return ImpersonatedUserId.HasValue ? ImpersonatedUserName : Name;
        }

        public bool IsImpersonated => ImpersonatedUserId.HasValue;
        
        public List<string> ImpersonatedUserRoles = new List<string>();
    }
}
