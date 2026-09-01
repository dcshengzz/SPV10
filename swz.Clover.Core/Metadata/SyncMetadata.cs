using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Base;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata
{
    public class SyncChanges
    {
        public Guid Id;
        public string Parameter;
        public string OriginalValue;
        public string NewValue;
        public string ChangedType;
        public MetaColumn Column;
    }
    
    public class SyncMetadata : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string ChangedType;
        public List<SyncChanges> Changes;
        public MetaTable Table;
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as SyncMetadata)?.Id == Id);

        public static List<SyncMetadata> Create(List<MetaTable> tables, List<DataModel> models)
        {
            var res = new List<SyncMetadata>();
            foreach (var model in models)
            {
                SyncMetadata item = null;
                var table = tables
                    //.FirstOrDefault(c => c.TableName == model.DbObjectName);
                    .FirstOrDefault(c => c.TableName != null && c.TableName.Equals(model.DbObjectName,StringComparison.OrdinalIgnoreCase));
                
                if (table == null)
                {
                    item = new SyncMetadata()
                    {
                        Id = model.Id,
                        Name = model.Name,
                        ChangedType = "deleted",
                    };
                }
                else
                {
                    var changes = new List<SyncChanges>();
                    
                    //Scheme
                    if (String.Compare(table.SchemeName, model.SchemaName, StringComparison.OrdinalIgnoreCase) != 0)
                    {
                        changes.Add(new SyncChanges()
                        {
                            Id = Guid.NewGuid(),
                            ChangedType = "changed",
                            NewValue = table.SchemeName,
                            OriginalValue = model.SchemaName,
                            Parameter = "Scheme"
                        });
                    }
                    
                    //Primary key
                    var primaryKeyColumns = table.Columns.Where(c => c.IsPrimaryKey).ToArray();
                    if(primaryKeyColumns.Length > 1)
                        continue;
                    
                    if (primaryKeyColumns.Length == 0)
                    {
                        if (!string.IsNullOrWhiteSpace(model.PrimaryKeyAttribute))
                        {
                            changes.Add(new SyncChanges()
                            {
                                Id = Guid.NewGuid(),
                                ChangedType = "changed",
                                NewValue = "",
                                OriginalValue = model.PrimaryKeyAttribute,
                                Parameter = "Primary key"
                            });
                        }
                    }
                    else
                    {
                        if (model.PrimaryKeyAttribute != null 
                            && !model.PrimaryKeyAttribute.Equals(primaryKeyColumns[0].ColumnName, StringComparison.OrdinalIgnoreCase)
                            || model.PrimaryKeyAttribute == null && primaryKeyColumns[0].ColumnName != null)
                        // if (model.PrimaryKeyAttribute != primaryKeyColumns[0].ColumnName)
                        {
                            changes.Add(new SyncChanges()
                            {
                                Id = Guid.NewGuid(),
                                ChangedType = "changed",
                                NewValue = primaryKeyColumns[0].ColumnName,
                                OriginalValue = model.PrimaryKeyAttribute,
                                Parameter = "Primary key",
                                Column = primaryKeyColumns[0]
                            });
                        }
                    }

                    //Columns
                    List<SyncChanges> changesColumns = GetChangesByColumns(model, table, models);
                    if(changesColumns.Count > 0)
                        changes.AddRange(changesColumns);
                    
                    if (changes.Count > 0)
                    {
                        item = new SyncMetadata()
                        {
                            Id = model.Id,
                            Name = model.Name,
                            ChangedType = "changed",
                            Changes = changes,
                            Table = table
                        };
                    }
                }
                
                if(item != null)
                    res.Add(item);
            }

            foreach (var table in tables)
            {
                // if(models.Exists(c => c.DbObjectName == table.TableName))
                if (models.Exists(c => c.DbObjectName != null && c.DbObjectName.Equals(table.TableName, StringComparison.OrdinalIgnoreCase)))
                    continue;

                var item = new SyncMetadata()
                {
                    Id = Guid.NewGuid(),
                    Name = $"{table.TableName}",
                    ChangedType = "new",
                    Table = table
// For more usability interface
//                  ,Changes = table.Columns.Select(c=> new SyncChangesDataContract()
//                    {
//                        Id = Guid.NewGuid(),
//                        NewValue = string.Format("{0}", c.ColumnName),
//                        ChangedType = "new",
//                        Parameter = c.ColumnName,
//                        Column = c
//                    }).ToList()
                };
                res.Add(item);
            }

            return res;
        }

        private static List<SyncChanges> GetChangesByColumns(DataModel model, MetaTable table, List<DataModel> models)
        {
            var res = new List<SyncChanges>();

            foreach (var att in model.Attributes)
            {
                if(att.IsVirtual || att.IsExtension)
                    continue;
                
                //var column = table.Columns.FirstOrDefault(c => c.ColumnName == att.Name);
                var column = table.Columns.FirstOrDefault(c => att.Name.Equals(c.ColumnName,StringComparison.OrdinalIgnoreCase));
                if (column == null)
                {
                    var item = new SyncChanges
                    {
                        Id = att.Id,
                        ChangedType = "deleted",
                        Parameter = att.Name
                    };
                    res.Add(item);
                }
                else
                {
                    var refModel = att.ReferenceEntityId.HasValue ? 
                        models.FirstOrDefault(m => m.Id == att.ReferenceEntityId.Value) 
                        : null;
                    if(!string.IsNullOrWhiteSpace(column.RefTableName))
                    {
                        //if (column.RefTableName != refModel?.DbObjectName || att.IsNullable != column.IsNullable)
                        if (!column.RefTableName.Equals(refModel?.DbObjectName,StringComparison.CurrentCultureIgnoreCase) || att.IsNullable != column.IsNullable)
                        {
                            var item = new SyncChanges
                            {
                                Id = att.Id,
                                ChangedType = "changed",
                                OriginalValue = att.ReferenceEntityId.HasValue ? 
                                    refModel?.Name : $"{ParsedType.GetFriendlyName(att.Type)}{(att.IsNullable ? "?" : "")}",
                                NewValue = $"Ref {column.RefTableName}",
                                Parameter = column.ColumnName,
                                Column = column
                            };
                            res.Add(item);
                        }
                    }
                    else
                    { 
                        Type type = CloverRuntime.DbProvider.DbCommunication.ConvertToCLRType(column.DataType);
                        if (type != null && (type != att.Type || att.IsNullable != column.IsNullable || att.TypeId == 1))
                        {
                           var item = new SyncChanges
                            {
                                Id = att.Id,
                                ChangedType = "changed",
                                OriginalValue = att.ReferenceEntityId.HasValue ? $"Ref {refModel?.Name}" : $"{ParsedType.GetFriendlyName(att.Type)}{(att.IsNullable ? "?" : "")}",
                                NewValue = $"{ParsedType.GetFriendlyName(type)}{(column.IsNullable ? "?" : "")}",
                                Parameter = column.ColumnName,
                                Column = column
                            };
                            res.Add(item);
                        }
                    }
                }
            }
            
            foreach (var column in table.Columns)
            {
                if(model.Attributes.Exists(attribute => attribute.Name != null && attribute.Name.Equals(column.ColumnName,StringComparison.InvariantCultureIgnoreCase)))
                    continue;

                var item = new SyncChanges
                {
                    Id = Guid.NewGuid(),
                    ChangedType = "new",
                    NewValue = $"{column.ColumnName}",
                    Parameter = column.ColumnName,
                    Column = column
                };
                res.Add(item);
            }
            
            return res;
        }

        public static void ApplyModelChanges(Metadata coll, JToken item, MetadataObjectState state)
        {
            var sync = item.ToObject<SyncMetadata>();
            if (sync.ChangedType == "deleted")
             {
                 coll.DataModel.RemoveAt(coll.DataModel.FindIndex(c=> c.Id == sync.Id));
             }
            else if (sync.ChangedType == "new")
            {
                var primaryKey = sync.Table.Columns.FirstOrDefault(c => c.IsPrimaryKey)?.ColumnName;
                var logicalDelete = sync.Table.Columns.FirstOrDefault(c => c.ColumnName == "IsDeleted")?.ColumnName;
                var lockVersion = sync.Table.Columns.FirstOrDefault(c => c.ColumnName == "LockVersion")?.ColumnName;
                
                coll.DataModel.Add(new DataModel()
                {
                    Id = sync.Id,
                    Name = sync.Table.TableName,
                    DbObjectName = sync.Table.TableName,
                    SchemaName = sync.Table.SchemeName,
                    PrimaryKeyAttribute = primaryKey,
                    LogicalDeleteAttribute = logicalDelete,
                    VersionAttribute = lockVersion,
                    Attributes = sync.Table.Columns.Select(c => MetaColumnToMetadataAttribute(coll, c)).ToList()
                });
            }
            else
            {
                var model = coll.DataModel.FirstOrDefault(c => c.Id == sync.Id);
                if (model == null)
                    return;
                
                for (var i = 0; i < sync.Changes.Count; i++)
                {
                    var change = sync.Changes[i];
                    if (change.Parameter == "Primary key")
                    {
                        model.PrimaryKeyAttribute = change.Column.ColumnName;
                    }
                    else if (change.Parameter == "Scheme")
                    {
                        model.SchemaName = change.NewValue;
                    }
                    else if(change.ChangedType == "new")
                    {
                        model.Attributes.Add(MetaColumnToMetadataAttribute(coll, change.Column));
                    }
                    else if (change.ChangedType == "deleted")
                    {
                        model.Attributes.RemoveAt(
                            model.Attributes.FindIndex(a => a.Id == change.Id)
                        );
                    }
                    else
                    {
                        model.Attributes.RemoveAt(
                            model.Attributes.FindIndex(a => a.Id == change.Id)
                        );
                        model.Attributes.Add(MetaColumnToMetadataAttribute(coll, change.Column));
                    }
                }
            }
            
        }

        private static MetadataAttribute MetaColumnToMetadataAttribute(Metadata coll, MetaColumn c)
        {
            return new MetadataAttribute()
            {
                Id = Guid.NewGuid(),
                IsCalculated = false,
                IsNullable = c.IsNullable,
                IsVirtual = false,
                Name = c.ColumnName,
                ReferenceEntityId = string.IsNullOrWhiteSpace(c.RefTableName)
                    ? null
                    : coll.DataModel.FirstOrDefault(r => r.Name == c.RefTableName)?.Id,
                Type = string.IsNullOrWhiteSpace(c.RefTableName)
                    ? CloverRuntime.DbProvider.DbCommunication.ConvertToCLRType(c.DataType)
                    : null,
                TypeId = string.IsNullOrWhiteSpace(c.RefTableName) ? (byte) 0 : (byte) 1
            };
        }
    }
}