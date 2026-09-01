using System;
using System.Collections.Generic;
using System.Linq;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.Clover.Core.Metadata
{
    public class Group : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string DomainGroup;
        public List<Guid> Roles;
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as Group)?.Id == Id);

        public static List<Group> Create(List<SecurityGroup> groups,
            List<SecurityGroupToSecurityRole> grouproles)
        {
            return groups.Select(c => new Group()
            {
                Id = c.Id,
                Name = c.Name,
                Roles = grouproles.Where(p => p.SecurityGroupId == c.Id).Select(p => p.SecurityRoleId).ToList()
            }).ToList();
        }

        public SecurityGroup ToDbObject()
        {
            return new SecurityGroup()
            {
                Id = Id,
                Name = Name
            };
        }
    }
}