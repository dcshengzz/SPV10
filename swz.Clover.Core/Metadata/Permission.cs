using System;
using System.Collections.Generic;
using System.Linq;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.Clover.Core.Metadata
{
    public class Permission : IMetadataItem
    {
        public Guid Id;
        public string Code;
        public string Name;
        public bool IsGroup = false;
        public List<Permission> children = new List<Permission>();

        public static List<Permission> Create(List<SecurityPermissionGroup> groups,
            List<SecurityPermission> permissions)
        {
            return groups.Select(g => new Permission()
            {
                Id = g.Id,
                Code = g.Code,
                Name = g.Name,
                IsGroup = true,
                children = permissions.Where(p => p.GroupId == g.Id).Select(p =>
                    new Permission()
                    {
                        Id = p.Id,
                        Code = p.Code,
                        Name = p.Name
                    }).ToList()
            }).ToList();
        }
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as Permission)?.Id == Id);

        public SecurityPermissionGroup ToGroupDbObject()
        {
            if (!IsGroup)
                return null;

            return new SecurityPermissionGroup()
            {
                Id = Id,
                Code = Code,
                Name = Name
            };
        }
        
        public List<SecurityPermission> ChildrenToDbObject()
        {
            if (!IsGroup)
                return null;

            return children.Select(c => c.ToDbObject(Id)).ToList();
        }
        
        public SecurityPermission ToDbObject(Guid groupId)
        {
            if (IsGroup)
                return null;

            return new SecurityPermission()
            {
                Id = Id,
                Code = Code,
                Name = Name,
                GroupId = groupId
            };
        }
    }
}