using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class SecurityGroup : DbObject<SecurityGroup>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public string Comment { get => _entity.Comment; set => _entity.Comment = value; }

        [DbObjectModel]
        public bool IsSyncWithDomainGroup { get => _entity.IsSyncWithDomainGroup; set => _entity.IsSyncWithDomainGroup = value; }
        
        public DbReferencedProperty<List<Guid>> Roles;
        
        public SecurityGroup()
        {
            Roles = new DbReferencedProperty<List<Guid>>(async ()=> (await SecurityGroupToSecurityRole.SelectByGroup(Id).ConfigureAwait(false)).Select(c => c.SecurityRoleId).ToList());
        }

        public static async Task IncludeUsersAsync(Guid groupId, Guid[] userIds)
        {
            var filter = Filter.And.Equal(groupId, "SecurityGroupId").In(userIds.ToList(), "SecurityUserId");
            var existMapping = await SecurityGroupToSecurityUser.SelectAsync(filter).ConfigureAwait(false);

            var mapping = new List<dynamic>();
            foreach(var userId in userIds)
            {
                if(existMapping.All(c => c.SecurityUserId != userId))
                {
                    mapping.Add(new SecurityGroupToSecurityUser(){
                        Id = CloverRuntime.DbProvider.GenerateGuid(),
                        SecurityGroupId = groupId,
                        SecurityUserId = userId
                    }.AsDynamicEntity);
                }
            }

            var container = new ObservableEntityContainer(null, SecurityGroupToSecurityUser.Model);
            container.Merge(mapping);
            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task ExcludeUsersAsync(Guid groupId, Guid[] userIds)
        {
            var filter = Filter.And.Equal(groupId, "SecurityGroupId").In(userIds.ToList(), "SecurityUserId");
            var existMapping = await SecurityGroupToSecurityUser.SelectAsync(filter).ConfigureAwait(false);

            var container = new ObservableEntityContainer(existMapping.Select(c=> c.AsDynamicEntity).ToList(), SecurityGroupToSecurityUser.Model);
            container.Remove(
                existMapping
                .Where(c=> userIds.Contains(c.SecurityUserId))
                .Select(c=> c.AsDynamicEntity));
            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task<List<SecurityUser>> GetUsersByGroupIdAsync(Guid groupId)
        {
            var userIds = (await SecurityGroupToSecurityUser.SelectByGroup(groupId).ConfigureAwait(false)).Select(c => c.SecurityUserId).ToList();
            if (userIds.Count == 0)
                return new List<SecurityUser>();

            var filter = Filter.And.In(userIds, "Id");
            return await SecurityUser.SelectAsync(filter).ConfigureAwait(false);
        }
    }

    public class SecurityGroupToSecurityRole : DbObject<SecurityGroupToSecurityRole>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid SecurityGroupId { get => _entity.SecurityGroupId; set => _entity.SecurityGroupId = value; }

        [DbObjectModel]
        public Guid SecurityRoleId { get => _entity.SecurityRoleId; set => _entity.SecurityRoleId = value; }

        public static Task<List<SecurityGroupToSecurityRole>> SelectByGroup(Guid groupId)
        {
            var filter = Filter.And.Equal(groupId, "SecurityGroupId");
            return SelectAsync(filter);
        }

        public static Task<List<SecurityGroupToSecurityRole>> SelectByRole(Guid roleId)
        {
            var filter = Filter.And.Equal(roleId, "SecurityRoleId");
            return SelectAsync(filter);
        }
    }

    public class SecurityGroupToSecurityUser : DbObject<SecurityGroupToSecurityUser>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid SecurityGroupId { get => _entity.SecurityGroupId; set => _entity.SecurityGroupId = value; }

        [DbObjectModel(TableType = typeof(SecurityPermissionGroup), ParentPropertyName = "SecurityGroupId", ColumnName = "Code")]
        public string SecurityGroupCode
        {
            get => _entity.SecurityGroupCode;
            set => _entity.SecurityGroupCode = value;
        }
        
        [DbObjectModel]
        public Guid SecurityUserId { get => _entity.SecurityUserId; set => _entity.SecurityUserId = value; }

        public static Task<List<SecurityGroupToSecurityUser>> SelectByGroup(Guid groupId)
        {
            var filter = Filter.And.Equal(groupId, "SecurityGroupId");
            return SelectAsync(filter);
        }

        public static Task<List<SecurityGroupToSecurityUser>> SelectByUser(Guid userId)
        {
            var filter = Filter.And.Equal(userId, "SecurityUserId");
            return SelectAsync(filter);
        }
    }
}