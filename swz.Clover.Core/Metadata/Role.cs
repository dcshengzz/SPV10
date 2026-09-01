using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.Clover.Core.Metadata
{
    public class Role : IMetadataItem
    {
        public Guid Id;
        public string Code;
        public string Name;
        public List<RolePermission> permissions;

        public static List<Role> Create(List<SecurityRole> roles,
            List<SecurityRoleToSecurityPermission> permissions)
        {
            return roles.Select(c => new Role()
            {
                Id = c.Id,
                Code = c.Code,
                Name = c.Name,
                permissions = permissions.Where(p => p.SecurityRoleId == c.Id)
                    .Select(p => new RolePermission()
                    {
                        Id = p.SecurityPermissionId,
                        AccessType = p.AccessType
                    }).ToList()
            }).ToList();
        }
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as Role)?.Id == Id);
        
        public SecurityRole ToDbObject()
        {
            return new SecurityRole()
            {
                Id = Id,
                Code = Code,
                Name = Name
            };
        }
        
        public List<SecurityRoleToSecurityPermission> ToPermissionsDbObject()
        {
            return this.permissions.Select(p => new SecurityRoleToSecurityPermission()
            {
                Id = Guid.NewGuid(),
                SecurityPermissionId = p.Id,
                SecurityRoleId = this.Id
            }).ToList();
        }
    }

    public class RolePermission
    {
        public Guid Id;
        public byte AccessType;
    }
}