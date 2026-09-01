using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Linq;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class SecurityRole : DbObject<SecurityRole>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string Code
        {
            get => _entity.Code;
            set => _entity.Code = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public string Comment
        {
            get => _entity.Comment;
            set => _entity.Comment = value;
        }

        [DbObjectModel]
        public string DomainGroup
        {
            get => _entity.DomainGroup;
            set => _entity.DomainGroup = value;
        }

        public DbReferencedProperty<List<Guid>> Groups;

        public SecurityRole()
        {
            Groups = new DbReferencedProperty<List<Guid>>(async () => (await SecurityGroupToSecurityRole.SelectByRole(Id).ConfigureAwait(false)).Select(c => c.SecurityGroupId).ToList());
        }

        public static async Task<SecurityRole> SelectByCode(string code)
        {
            var filter = Filter.And.Equal(code, "Code");
            return (await SelectAsync(filter).ConfigureAwait(false)).FirstOrDefault();
        }

        /// <summary>
        /// Select role by either its Code or Name with priority on Code.
        /// Case-insensitive. 
        /// </summary>
        public static async Task<SecurityRole> SelectByCodeOrName(string codeOrName)
        {
            Filter filter = Filter.Or
                .Equal(codeOrName, "Code")
                .Equal(codeOrName, "Name");
            return (await SelectAsync(filter).ConfigureAwait(false))
                .OrderByDescending(x => string.Equals(x.Code, codeOrName, StringComparison.OrdinalIgnoreCase)) //if both match then we prefer by code
                .FirstOrDefault();
        }

        public static async Task SyncWithDomainGroupAsync(Guid userId, List<string> groups)
        {
            var roles = (await SelectAsync().ConfigureAwait(false)).Where(c => !string.IsNullOrEmpty(c.DomainGroup)).ToList();
            if (roles.Count == 0)
                return;

            var user = await SecurityUser.SelectByKey(userId).ConfigureAwait(false);
            if (user == null)
                return;

            var userRoles = await SecurityUserToSecurityRole.SelectByUser(user.Id).ConfigureAwait(false);

            var container = new ObservableEntityContainer(userRoles.Select(c => c.AsDynamicEntity), SecurityUserToSecurityRole.Model);

            foreach (var g in userRoles)
            {
                var role = roles.FirstOrDefault(c => !string.IsNullOrEmpty(c.DomainGroup) && c.Id == g.SecurityRoleId);
                if (role != null && !groups.Contains(role.DomainGroup))
                    container.Remove(g.AsDynamicEntity);
            }

            foreach (SecurityRole item in roles.Where(c => groups.Contains(c.DomainGroup)))
            {
                if (userRoles.All(any => item.Id != any.Id))
                {
                    container.Merge(new List<SecurityUserToSecurityRole>()
                    {
                        new SecurityUserToSecurityRole()
                        {
                            Id = CloverRuntime.DbProvider.GenerateGuid(),
                            SecurityRoleId = item.Id,
                            SecurityUserId = userId
                        }
                    });
                }
            }

            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task<List<SecurityUser>> GetUsersByRoleId(Guid roleId)
        {
            var mapping = await SecurityUserToSecurityRole.SelectByRole(roleId).ConfigureAwait(false);
            if (mapping.Count == 0)
                return new List<SecurityUser>();

            var filter = Filter.And.In(mapping.Select(c => c.SecurityUserId).ToList(), "Id");
            return await SecurityUser.SelectAsync(filter).ConfigureAwait(false);
        }

        public static async Task PermissionChangeStatusAsync(Guid roleId, Guid[] permissionIds, byte status)
        {
            if (permissionIds.Length == 0)
                return;

            var filter = Filter.And.Equal(roleId, "SecurityRoleId").In(permissionIds.ToList(), "SecurityPermissionId");
            var permissions = await SecurityRoleToSecurityPermission.SelectAsync(filter).ConfigureAwait(false);
            var container = new ObservableEntityContainer(permissions.Select(c => c.AsDynamicEntity).ToList(), SecurityRoleToSecurityPermission.Model);
            if (status == 255)
            {
                container.RemoveAll();
            }
            else
            {
                foreach (SecurityRoleToSecurityPermission p in permissions)
                    p.AccessType = status;

                container.Merge(permissionIds.Where(permissionId => permissions.All(c => c.SecurityPermissionId != permissionId)).Select(
                    permissionId => new SecurityRoleToSecurityPermission()
                    {
                        Id = CloverRuntime.DbProvider.GenerateGuid(),
                        SecurityRoleId = roleId,
                        SecurityPermissionId = permissionId,
                        AccessType = status
                    }.AsDynamicEntity));
            }

            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task IncludeUsersAsync(Guid roleId, Guid[] userIds)
        {
            var filter = Filter.And.Equal(roleId, "SecurityRoleId").In(userIds.ToList(), "SecurityUserId");
            var existMapping = await SecurityUserToSecurityRole.SelectAsync(filter).ConfigureAwait(false);

            var mapping = new List<dynamic>();
            foreach (var userId in userIds)
            {
                if (existMapping.All(c => c.SecurityUserId != userId))
                {
                    mapping.Add(new SecurityUserToSecurityRole()
                    {
                        Id = CloverRuntime.DbProvider.GenerateGuid(),
                        SecurityRoleId = roleId,
                        SecurityUserId = userId
                    }.AsDynamicEntity);
                }
            }

            var container = new ObservableEntityContainer(null, SecurityUserToSecurityRole.Model);
            container.Merge(mapping);
            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task ExcludeUsersAsync(Guid roleId, Guid[] userIds)
        {
            var filter = Filter.And.Equal(roleId, "SecurityRoleId").In(userIds.ToList(), "SecurityUserId");
            var existMapping = await SecurityUserToSecurityRole.SelectAsync(filter).ConfigureAwait(false);

            var container = new ObservableEntityContainer(existMapping.Select(c => c.AsDynamicEntity).ToList(), SecurityUserToSecurityRole.Model);
            container.Remove(
                existMapping
                    .Where(c => userIds.Contains(c.SecurityUserId))
                    .Select(c => c.AsDynamicEntity));
            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task<IList<SecurityRoleToSecurityPermission>> GetPermissionByRoleId(Guid roleId, bool addNotDefined = false)
        {
            var result = await SecurityRoleToSecurityPermission.SelectByRole(roleId).ConfigureAwait(false);

            if (addNotDefined)
            {
                var permissions = await SecurityPermission.SelectAsync().ConfigureAwait(false);

                foreach (SecurityPermission perm in permissions)
                {
                    if (result.Any(c => c.SecurityPermissionId == perm.Id))
                        continue;

                    result.Add(new SecurityRoleToSecurityPermission
                    {
                        AccessType = 255,
                        SecurityPermissionGroupId = perm.GroupId,
                        SecurityPermissionGroupName = perm.GroupName,
                        SecurityPermissionId = perm.Id,
                        SecurityPermissionName = perm.Name,
                        SecurityRoleId = roleId
                    });
                }
            }

            return (from r in result orderby r.SecurityPermissionGroupName, r.SecurityPermissionName select r).ToList();
        }

        public new static async Task<XElement> GenerateXElement()
        {
            var roles = await SelectAsync().ConfigureAwait(false);
            var permissions = await SecurityRoleToSecurityPermission.SelectAsync().ConfigureAwait(false);
            return GenerateXElement(
                c => new[]
                {
                    SecurityRoleToSecurityPermission.GenerateXElement(n => null,
                        permissions.Where(a => a.SecurityRoleId == c.Id).ToList(),
                        "Permissions",
                        "Permission",
                        column =>
                        {
                            if (column == "SecurityPermissionId")
                                return "PermissionId";
                            return column;
                        })
                }, roles);
        }

        public static async Task SyncXElementAsync(XElement el)
        {
            var mappingContainers = new ObservableEntityContainer((await SecurityRoleToSecurityPermission.SelectAsync().ConfigureAwait(false)).Select(c => c.AsDynamicEntity),
                SecurityRoleToSecurityPermission.Model);

            var container = ImportXElementAsync(el, new ObservableEntityContainer((await SelectAsync().ConfigureAwait(false)).Select(c => c.AsDynamicEntity), Model));

            foreach (DynamicEntity item in container.Entities)
            {
                if (item.HasProperty("_Node"))
                {
                    SecurityRoleToSecurityPermission.ImportXElementAsync(item["_Node"] as XElement, mappingContainers, "Permissions", "Permission", "SecurityRoleId", item.GetId(),
                        c =>
                        {
                            if (c == "SecurityPermissionId")
                                return "PermissionId";
                            return c;
                        });
                }
            }

            await container.ApplyAsync().ConfigureAwait(false);
            await mappingContainers.ApplyAsync().ConfigureAwait(false);
        }
    }

    public class SecurityRoleToSecurityPermission : DbObject<SecurityRoleToSecurityPermission>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid SecurityPermissionId { get => _entity.SecurityPermissionId; set => _entity.SecurityPermissionId = value; }

        [DbObjectModel]
        public Guid SecurityRoleId { get => _entity.SecurityRoleId; set => _entity.SecurityRoleId = value; }

        [DbObjectModel]
        public byte AccessType { get => _entity.AccessType; set => _entity.AccessType = value; }

        [DbObjectModel(TableType = typeof(SecurityPermission), ParentPropertyName = "SecurityPermissionId", ColumnName = "GroupId")]
        public Guid SecurityPermissionGroupId { get => _entity.SecurityPermissionGroupId; set => _entity.SecurityPermissionGroupId = value; }

        [DbObjectModel(TableType = typeof(SecurityPermissionGroup), ParentPropertyName = "SecurityPermissionGroupId", ColumnName = "Name")]
        public string SecurityPermissionGroupName { get => _entity.SecurityPermissionGroupName; set => _entity.SecurityPermissionGroupName = value; }

        [DbObjectModel(TableType = typeof(SecurityPermission), ParentPropertyName = "SecurityPermissionId", ColumnName = "Name")]
        public string SecurityPermissionName { get => _entity.SecurityPermissionName; set => _entity.SecurityPermissionName = value; }

        public static Task<List<SecurityRoleToSecurityPermission>> SelectByRole(Guid roleId)
        {
            var filter = Filter.And.Equal(roleId, "SecurityRoleId");
            return SelectAsync(filter);
        }
    }
}