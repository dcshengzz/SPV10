using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Xml.Linq;
using swz.Clover.Core.Base;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.ORM
{
    public class DbObject<T> where T : DbObject<T>, new()
    {
        protected string customTableName;
        protected bool IgnorePrefix;
        protected ObservableEntityContainer ObservableEntityContainer { get; set; }

        protected dynamic _entity { get; set; }

        public dynamic AsDynamicEntity => _entity;

        public DbObject(bool ignorePrefix = false, string tableName = null)
        {
            customTableName = tableName;
            if (_dbModel == null)
            {
                lock (ObjLock)
                {
                    if (_dbModel == null)
                    {
                        IgnorePrefix = ignorePrefix;
                        _dbModel = GetModel();
                    }
                }
            }

            _entity = _dbModel.GetIntializedObject(false, true);
        }

        public static T CreateByDynamicEntity(dynamic v)
        {
            var t = new T
            {
                _entity = v as DynamicEntity
            };

            return t;
        }

        // ReSharper disable once StaticMemberInGenericType
        private static string _providerName;

        // ReSharper disable once StaticMemberInGenericType
        private static EntityModel _dbModel;

        // ReSharper disable once StaticMemberInGenericType
        private static readonly object ObjLock = new object();

        public static EntityModel Model
        {
            get
            {
                if (_providerName != CloverRuntime.DbProvider.ToString())
                {
                    lock (ObjLock)
                    {
                        _dbModel = null;
                    }
                }

                if (_dbModel == null)
                {
                    lock (ObjLock)
                    {
                        if (_dbModel == null)
                        {
                            // ReSharper disable once UnusedVariable
                            var a = new T();
                        }
                    }
                }

                return _dbModel;
            }
        }

        public EntityModel GetReferencedModel(Type type)
        {
            var pi = type?.GetTypeInfo().BaseType.GetProperty(nameof(Model));
            return (EntityModel) pi?.GetValue(null);
        }

        private EntityModel GetModel()
        {
            Type t = typeof(T);
            var tableName = string.IsNullOrEmpty(customTableName) ? t.Name : customTableName;
            string name = CloverRuntime.DbProvider.CorrectTableName(tableName);

            var prefix = IgnorePrefix ? "" : CloverRuntime.MetadataPrefix;
            EntityModel em = new EntityModel(t.Name, CloverRuntime.MetadataSchema, prefix + name);

            var properties = t.GetProperties().ToList();

            Dictionary<string, AttributeModel> attributes = new Dictionary<string, AttributeModel>();
            Dictionary<string, List<JoinedAttributeModel>> asReference = new Dictionary<string, List<JoinedAttributeModel>>();

            foreach (var pi in properties)
            {
                var pModel = pi.GetCustomAttribute<DbObjectModelAttribute>();
                if (pModel == null)
                    continue;

                var attributeName = pi.Name;
                var columnName = pModel.ColumnName ?? CloverRuntime.DbProvider.CorrectColumnName(em.Name,attributeName);

                var attributeType = AttributeType.GetDefaultType(pi.PropertyType);
                AttributeModel newAttribute;

                if (pModel.TableType == null) //Plain attribute
                {
                    if (asReference.ContainsKey(attributeName))
                    {
                        var referenced = asReference[attributeName];
                        newAttribute = AttributeModel.CreatePlainReferenceAttribute(attributeName, em, referenced.First().DataModel,
                            attributeType, columnName);
                        foreach (var referencedAttribute in referenced)
                        {
                            newAttribute.AddChild(referencedAttribute);
                            referencedAttribute.Parent = newAttribute;
                        }
                    }
                    else
                    {
                        newAttribute = AttributeModel.CreatePlainAttribute(attributeName, em, attributeType, columnName);
                    }

                    if (pModel.IsKey)
                        em.PrimaryKeyAttributeName = newAttribute.Name;
                    if (pModel.IsLogicalDelete)
                        em.LogicalDeleteAttributeName = newAttribute.Name;
                }
                else //Joined attribute
                {
                    var joinedEm = pModel.TableType != t ? GetReferencedModel(pModel.TableType) : em; //TODO Cache

                    var parentPropertyName = pModel.ParentPropertyName;
                    JoinedAttributeModel newJoinedAttribute = null;
                    var parent = attributes.ContainsKey(parentPropertyName) ? attributes[parentPropertyName] : null;

                    if (parent != null)
                        parent.ReferencedDataModel = joinedEm;

                    if (asReference.ContainsKey(attributeName))
                    {
                        var referenced = asReference[attributeName];
                        newJoinedAttribute = AttributeModel.CreateJoinedReferenceAttribute(attributeName, parent, referenced.First().DataModel,
                            attributeType, columnName);
                        foreach (var referencedAttribute in referenced)
                        {
                            newJoinedAttribute.AddChild(referencedAttribute);
                            referencedAttribute.Parent = newJoinedAttribute;
                        }
                    }
                    else
                    {
                        newJoinedAttribute = parent == null
                            ? AttributeModel.CreateJoinedAttribute(attributeName, joinedEm, attributeType, columnName)
                            : AttributeModel.CreateJoinedAttribute(attributeName, parent, attributeType, columnName);
                    }

                    parent?.AddChild(newJoinedAttribute);

                    if (!asReference.ContainsKey(parentPropertyName))
                        asReference.Add(parentPropertyName, new List<JoinedAttributeModel>());

                    asReference[parentPropertyName].Add(newJoinedAttribute);
                    newJoinedAttribute.UseNameAsPropertyName = true;
                    newAttribute = newJoinedAttribute;

                }

                em.AddAttribute(newAttribute);
                attributes.Add(newAttribute.Name, newAttribute);
            }

            _providerName = CloverRuntime.DbProvider.ToString();
            return em;
        }

        public static async Task<T> SelectByKey(object id)
        {
            if (!Model.HasPrimaryKey)
                throw new Exception("Primary key is not defined");

            var filter = Filter.And.Equal(id, Model.PrimaryKeyAttribute.Name);

            var entities = (await CloverRuntime.DbProvider.ReadAsync(Model, filter, Order.Empty, Paging.Empty,
                CloverRuntime.ConnectionStringMetadata).ConfigureAwait(false));

            var first = entities.FirstOrDefault();

            return first == null ? null : CreateByDynamicEntity(first);
        }

        public static Task<List<T>> SelectAsync(bool showDeleted)
        {
            if (showDeleted || !Model.HasLogicalDeleteAttribute)
            {
                return SelectAsync(Filter.Empty);
            }

            return SelectAsync(Filter.And.Equal(false, Model.LogicalDeleteAttribute.PropertyName)); //.Prepare(Model,FilterPurpose.SelectValues));
        }

        public static Task<List<T>> SelectAsync()
        {
            return SelectAsync(Filter.Empty);
        }

        public static async Task<List<T>> SelectAsync(Filter filter, Order order = null, Paging paging = null)
        {
            if (order == null)
                order = Order.Empty;
            if (paging == null)
                paging = Paging.Empty;
            var entities = await Model.GetAsync(filter, order, paging).ConfigureAwait(false);
            return entities.Select(e => DbObject<T>.CreateByDynamicEntity(e) as T).ToList();
        }

        public void StartTracking()
        {
            if (ObservableEntityContainer == null)
            {
                ObservableEntityContainer = new ObservableEntityContainer(new List<dynamic> {AsDynamicEntity}, Model);
            }
        }

        public void MarkAsNew()
        {
            ObservableEntityContainer = null;
        }

        public Task ApplyAsync()
        {
            if (ObservableEntityContainer != null)
                return ObservableEntityContainer.ApplyAsync();

            ObservableEntityContainer = new ObservableEntityContainer(new List<dynamic>(), Model);
            ObservableEntityContainer.Merge(new List<dynamic> {AsDynamicEntity});
            return ObservableEntityContainer.ApplyAsync();
        }

        public static async Task ApplyAsync(List<DbObject<T>> entities)
        {
            var container = new ObservableEntityContainer(new List<dynamic>(), Model);

            foreach (var entity in entities)
            {
                if (entity.ObservableEntityContainer == null)
                {
                    entity.ObservableEntityContainer = new ObservableEntityContainer(new List<dynamic>(), Model);
                    entity.ObservableEntityContainer.Merge(new List<dynamic> {entity.AsDynamicEntity});
                }

                container = container.Combine(entity.ObservableEntityContainer);
            }

            SharedTransaction.SubscribeOnCommit(() =>
            {
                foreach (var entity in entities)
                {
                    entity.ObservableEntityContainer.ResetChanges();
                }
            });

            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static Task ApplyAsync(params DbObject<T>[] entities)
        {
            return ApplyAsync(entities.ToList());
        }

        public static Task DeleteAsync<TPk>(params TPk[] ids)
        {
            if (IsDbEntity(typeof(TPk)))
            {
                return DeleteEntitiesAsync(ids.Cast<DbObject<T>>().ToList());
            }

            return DeleteAsync(ids.ToList());
        }

        public static async Task DeleteAsync<TPk>(List<TPk> ids)
        {
            if (IsDbEntity(typeof(TPk)))
            {
                await DeleteEntitiesAsync(ids.Cast<DbObject<T>>().ToList()).ConfigureAwait(false);
                return;
            }

            if (Model.HasLogicalDeleteAttribute)
            {
                var filter = Filter.And.In(ids, Model.PrimaryKeyAttribute.Name);
                var items = await SelectAsync(filter).ConfigureAwait(false);
                var container = new ObservableEntityContainer(items.Select(i => i.AsDynamicEntity).ToList(), Model);
                foreach (var item in items)
                {
                    item.AsDynamicEntity.TrySetMember(Model.LogicalDeleteAttribute.PropertyName, true);
                }

                await container.ApplyAsync().ConfigureAwait(false);
            }
            else
            {
                await Remove(ids).ConfigureAwait(false);
            }
        }

        public static async Task DeleteEntitiesAsync(List<DbObject<T>> entities)
        {
            if (entities.Count == 0)
                return;

            if (Model.HasLogicalDeleteAttribute)
            {
                var container = new ObservableEntityContainer(new List<dynamic>(), Model);

                foreach (var entity in entities)
                {
                    if (entity.ObservableEntityContainer == null)
                    {
                        entity.ObservableEntityContainer = new ObservableEntityContainer(new List<dynamic>(), Model);
                        entity.ObservableEntityContainer.Merge(new List<dynamic> {entity.AsDynamicEntity});
                    }

                    entity.AsDynamicEntity.TrySetMember(Model.LogicalDeleteAttribute.PropertyName, true);

                    container = container.Combine(entity.ObservableEntityContainer);
                }

                await container.ApplyAsync().ConfigureAwait(false);
            }
            else
            {
                await RemoveEntitiesAsync(entities).ConfigureAwait(false);
            }
        }

        public Task DeleteAsync()
        {
            return DeleteEntitiesAsync(new List<DbObject<T>> {this});
        }

        public void Remove()
        {
            Remove(AsDynamicEntity.GetId());
            ObservableEntityContainer = null;
        }

        public static Task Remove<TPk>(params TPk[] ids)
        {
            return Remove(ids.ToList());
        }

        public static async Task Remove<TPk>(List<TPk> ids)
        {
            if (IsDbEntity(typeof(TPk)))
            {
                //If we get passed a list of DbObject then will cast to that, recurse back to this method with
                //a list of their extracted Ids, and also null the observable entity containers afterwards
                await RemoveEntitiesAsync(ids.Cast<DbObject<T>>().ToList()).ConfigureAwait(false);
                return;
            }

            var filter = Filter.And.In(ids, Model.PrimaryKeyAttribute.Name);
            var operation = new ChangeOperation()
            {
                Filter = filter
            };
            //AUDIT
            await AuditHelper.AuditLogDeletionByIds(ids, Model);

            await CloverRuntime.DbProvider.Delete(Model, new List<ChangeOperation> {operation}, CloverRuntime.ConnectionStringMetadata).ConfigureAwait(false);
        }

        private static async Task RemoveEntitiesAsync(List<DbObject<T>> entities)
        {
            var ids = entities.Select(e => (object) e.AsDynamicEntity.GetId()).ToList();
            await Remove(ids).ConfigureAwait(false);
            entities.ForEach(e => e.ObservableEntityContainer = null);
        }

        public static async Task Restore<TPk>(params TPk[] ids)
        {
            if (!Model.HasLogicalDeleteAttribute) return;

            if (IsDbEntity(typeof(TPk)))
            {
                await RestoreEntitiesAsync(ids.Cast<DbObject<T>>().ToList()).ConfigureAwait(false);
                return;
            }

            var filter = Filter.And.In(ids.ToList(), Model.PrimaryKeyAttribute.Name);
            var items = await SelectAsync(filter).ConfigureAwait(false);
            var container = new ObservableEntityContainer(items.Select(i => i.AsDynamicEntity).ToList(), Model);
            foreach (var item in items)
            {
                item.AsDynamicEntity.TrySetMember(Model.LogicalDeleteAttribute.PropertyName, false);
            }

            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static async Task RestoreEntitiesAsync(List<DbObject<T>> entities)
        {
            if (!Model.HasLogicalDeleteAttribute) return;

            var container = new ObservableEntityContainer(new List<dynamic>(), Model);

            foreach (var entity in entities)
            {
                if (entity.ObservableEntityContainer == null)
                {
                    entity.ObservableEntityContainer = new ObservableEntityContainer(new List<dynamic>(), Model);
                    entity.ObservableEntityContainer.Merge(new List<dynamic> {entity.AsDynamicEntity});
                }

                entity.AsDynamicEntity.TrySetMember(Model.LogicalDeleteAttribute.PropertyName, false);

                container = container.Combine(entity.ObservableEntityContainer);
            }

            await container.ApplyAsync().ConfigureAwait(false);
        }

        private static bool IsDbEntity(Type pkType)
        {
            var pkBaseType = pkType.GetTypeInfo().BaseType;
            var baseTypeIsDbObject = pkBaseType != null && pkBaseType.GetTypeInfo().IsGenericType && pkBaseType.GetGenericTypeDefinition() == typeof(DbObject<>);
            if (baseTypeIsDbObject)
                return true;
            return pkType.GetTypeInfo().IsGenericType && pkType.GetGenericTypeDefinition() == typeof(DbObject<>);
        }

        public static Task<long> GetCountAsync()
        {
            return GetCountAsync(Filter.Empty);
        }

        public static Task<long> GetCountAsync(Filter filter)
        {
            return Model.GetCountAsync(filter);
        }

        #region GenerateXElement && SyncByXElement

        public static Task<XElement> GenerateXElement()
        {
            return GenerateXElement(c => null);
        }

        public static async Task<XElement> GenerateXElement(Func<T, XElement[]> getChilds)
        {
            return GenerateXElement(getChilds, await SelectAsync().ConfigureAwait(false));
        }

        public static XElement GenerateXElement(Func<T, XElement[]> getChilds,
            List<T> items, string tagGroupName = null, string tagName = null,
            Func<string, string> columnMapping = null)
        {
            if (string.IsNullOrEmpty(tagGroupName))
            {
                tagGroupName = Model.Name[Model.Name.Length - 1] != 'y'
                    ? string.Format("{0}s", Model.Name)
                    : string.Format("{0}ies", Model.Name.Substring(0, Model.Name.Length - 1));
            }

            if (string.IsNullOrEmpty(tagName))
                tagName = Model.Name;

            var el = new XElement(tagGroupName);
            foreach (var item in items.OrderBy(c => c.AsDynamicEntity[Model.PrimaryKeyAttributeName]))
            {
                var node = new XElement(tagName);
                foreach (var att in Model.PlainAttributes)
                {
                    var attName = att.ColumnName;
                    if (columnMapping != null)
                        attName = columnMapping(attName);

                    if (att.Type.CLRType == typeof(string))
                    {
                        string value = item.AsDynamicEntity[att.PropertyName] ?? string.Empty;
                        if (value.Contains('\n'))
                            node.Add(new XElement(attName, new XCData(value ?? string.Empty)));
                        else
                            node.SetAttributeValue(attName, value);
                    }
                    else
                    {
                        node.SetAttributeValue(attName, item.AsDynamicEntity[att.PropertyName]);
                    }
                }

                // ReSharper disable once CoVariantArrayConversion
                object[] childs = getChilds(item);
                if (childs != null)
                    node.Add(childs);

                el.Add(node);
            }

            return el;
        }

        internal static async Task DropAllAsync(params string[] presetnullColumns)
        {
            var select = await SelectAsync().ConfigureAwait(false);
            var container = new ObservableEntityContainer(select.Select(c => c.AsDynamicEntity).ToList(), Model);
            if (presetnullColumns.Length > 0)
            {
                foreach (var item in container.Entities)
                {
                    foreach (var column in presetnullColumns)
                    {
                        item[column] = null;
                    }
                }

                await container.ApplyAsync().ConfigureAwait(false);
            }

            container.RemoveAll();
            await container.ApplyAsync().ConfigureAwait(false);
        }

        public static Task ImportXElementAsync(XElement el)
        {
            var contatiner = ImportXElementAsync(el, new ObservableEntityContainer(null, Model));
            return contatiner.ApplyAsync();
        }

        public static ObservableEntityContainer ImportXElementAsync(XElement el, ObservableEntityContainer container,
            string tagGroupName = null, string tagName = null, string parentColumn = null, object parentId = null,
            Func<string, string> columnMapping = null)
        {
            if (string.IsNullOrEmpty(tagGroupName))
            {
                tagGroupName = Model.Name[Model.Name.Length - 1] != 'y'
                    ? string.Format("{0}s", Model.Name)
                    : string.Format("{0}ies", Model.Name.Substring(0, Model.Name.Length - 1));
            }

            if (string.IsNullOrEmpty(tagName))
                tagName = Model.Name;

            var itemsFormEl = new List<dynamic>();
            foreach (var node in el.Elements(tagGroupName).Elements(tagName))
            {
                DynamicEntity item = null;
                var idAttribute = node.Attribute(Model.PrimaryKeyAttributeName);
                object idValue;
                if (!string.IsNullOrEmpty(idAttribute?.Value))
                {
                    idValue = Model.PrimaryKeyAttribute.Type.ParseToCLRType(idAttribute.Value);
                    item = container.Entities.FirstOrDefault(c => ((DynamicEntity) c).GetId().Equals(idValue));
                }
                else
                {
                    idValue = CloverRuntime.DbProvider.GenerateGuid();
                }

                if (item == null)
                {
                    item = new T().AsDynamicEntity;
                    item.TrySetMember(Model.PrimaryKeyAttributeName, idValue, true);
                }

                foreach (var att in Model.PlainAttributes.Where(c => !c.IsPrimaryKey))
                {
                    var attName = att.PropertyName;
                    if (columnMapping != null)
                        attName = columnMapping(attName);

                    if (att.Type.CLRType == typeof(string))
                    {
                        if (node.Elements().Any(n => n.Name == attName))
                        {
                            var xElement = node.Element(attName);
                            if (xElement != null) item[att.PropertyName] = xElement.Value;
                        }
                        else if (node.Attributes().Any(n => n.Name == attName))
                            item[att.PropertyName] = node.Attribute(attName).Value;
                    }
                    else if (node.Attributes().Any(n => n.Name == attName))
                    {
                        item[att.PropertyName] = att.Type.ParseToCLRType(node.Attribute(attName).Value);
                    }
                }

                if (!string.IsNullOrEmpty(parentColumn))
                {
                    item[parentColumn] = parentId;
                }

                item["_Node"] = node;
                itemsFormEl.Add(item);
            }

            container.Merge(itemsFormEl);
            return container;
        }

        #endregion
    }
}