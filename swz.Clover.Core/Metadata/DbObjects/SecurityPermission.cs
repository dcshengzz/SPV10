using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Linq;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class SecurityPermission : DbObject<SecurityPermission>
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
        public Guid GroupId
        {
            get => _entity.GroupId;
            set => _entity.GroupId = value;
        }

        [DbObjectModel(TableType = typeof(SecurityPermissionGroup), ParentPropertyName = "GroupId", ColumnName = "Name")]
        public string GroupName
        {
            get => _entity.GroupName;
            set => _entity.GroupName = value;
        }

        [DbObjectModel(TableType = typeof(SecurityPermissionGroup), ParentPropertyName = "GroupId", ColumnName = "Code")]
        public string GroupCode
        {
            get => _entity.GroupCode;
            set => _entity.GroupCode = value;
        }

        public static async Task<SecurityPermission> SelectByCode(string groupCode, string permissionCode)
        {
            var filter = Filter.And.Equal(groupCode, "GroupId_Code").Equal(permissionCode, "Code");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            if (result.Count > 0)
                return result[0];
            return null;
        }

        public static Task<List<SecurityPermission>> GetByGroupId(Guid groupId)
        {
            var filter = Filter.And.Equal(groupId, "GroupId");
            return SelectAsync(filter);
        }
    }

    public class SecurityPermissionGroup : DbObject<SecurityPermissionGroup>
    {
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

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        public DbReferencedProperty<List<SecurityPermission>> SecurityPermission;

        public SecurityPermissionGroup()
        {
            SecurityPermission = new DbReferencedProperty<List<SecurityPermission>>(() => DbObjects.SecurityPermission.GetByGroupId(Id));
        }


        public static async Task<XElement> GenerateXElementAsync()
        {
            var permissions = await DbObjects.SecurityPermission.SelectAsync().ConfigureAwait(false);
            return await GenerateXElement(
                c => new[]
                {
                    DbObjects.SecurityPermission.GenerateXElement(n => null, permissions.Where(a => a.GroupId == c.Id).ToList(), "Permissions", "Permission")
                }).ConfigureAwait(false);
        }

        public static async Task SyncXElementAsync(XElement el)
        {
            var permissionContainers = new ObservableEntityContainer((await DbObjects.SecurityPermission.SelectAsync().ConfigureAwait(false)).Select(c => c.AsDynamicEntity),
                DbObjects.SecurityPermission.Model);

            var container = ImportXElementAsync(el, new ObservableEntityContainer((await SelectAsync().ConfigureAwait(false)).Select(c => c.AsDynamicEntity), Model));

            foreach (DynamicEntity item in container.Entities)
            {
                if (item.HasProperty("_Node"))
                {
                    DbObjects.SecurityPermission.ImportXElementAsync(item["_Node"] as XElement, permissionContainers, "Permissions", "Permission", "GroupId", item.GetId());
                }
            }

            await container.ApplyAsync().ConfigureAwait(false);
            await permissionContainers.ApplyAsync().ConfigureAwait(false);
        }
    }
}