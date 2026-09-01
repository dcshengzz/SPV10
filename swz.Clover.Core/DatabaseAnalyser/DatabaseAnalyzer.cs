using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Base;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.DatabaseAnalyser
{
    public abstract class DatabaseAnalyzer
    {
        protected readonly Dictionary<string, Action<DatabaseTableInfo, IDataReader, int>> TableInfoMapping = new Dictionary<string, Action<DatabaseTableInfo, IDataReader, int>>
        {
            {"table_name", (info, reader, i) => info.TableName = reader.GetValue(i).ToString()},
            {"table_type", (info, reader, i) => info.IsView = reader.GetValue(i).ToString().Equals("VIEW", StringComparison.OrdinalIgnoreCase)},
            {"table_schema", (info, reader, i) => info.TableSchema = reader.GetValue(i).ToString()},
        };

        protected virtual Dictionary<string, Action<DatabaseColumnInfo, IDataReader, int>> ColumnInfoMapping { get; } = new Dictionary<string, Action<DatabaseColumnInfo, IDataReader, int>>
        {
            {"table_schema", (info, reader, i) => info.TableSchema = reader.GetValue(i).ToString()},
            {"table_name", (info, reader, i) => info.TableName = reader.GetValue(i).ToString()},
            {"column_name", (info, reader, i) => info.ColumnName = reader.GetValue(i).ToString()},
            {"column_default", (info, reader, i) => info.Default = reader.GetValue(i).ToString()},
            {"is_nullable", (info, reader, i) => info.IsNullable = reader.GetValue(i).ToString().Equals("YES", StringComparison.OrdinalIgnoreCase)},
            {"data_type", (info, reader, i) => info.DataType = reader.GetValue(i).ToString()},
            {"character_maximum_length", (info, reader, i) => info.CharacterMaxLength = reader.GetValue(i).ToString()},
            {"constraint_name", (info, reader, i) => info.ConstraintName = reader.GetValue(i).ToString()},
            {"ref_constraint_name", (info, reader, i) => info.RefConstraintName = reader.GetValue(i).ToString()},
            {"ref_table_schema", (info, reader, i) => info.RefTableSchema = reader.GetValue(i).ToString()},
            {"ref_table_name", (info, reader, i) => info.RefTableName = reader.GetValue(i).ToString()},
            {"update_rule", (info, reader, i) => info.IsUpdateCascade = reader.GetValue(i).ToString().Equals("CASCADE", StringComparison.OrdinalIgnoreCase)},
            {"delete_rule", (info, reader, i) => info.IsDeleteCascade = reader.GetValue(i).ToString().Equals("CASCADE", StringComparison.OrdinalIgnoreCase)},
        };

        public async Task<List<MetaTable>> FromDatabase(string connectionString)
        {
            List<DatabaseTableInfo> tables;
            List<DatabaseColumnInfo> columns;
            using (var connection = GetConnection(connectionString))
            {
                if (connection.State != ConnectionState.Open)
                {
                    await connection.OpenAsync();
                }
                tables = await GetTables(connection).ConfigureAwait(false);
                columns = await GetColumns(connection).ConfigureAwait(false);
            }

            List<MetaTable> result = tables.Select(MapTable).ToList();

            columns.ForEach(c =>
            {
                c.TableSchema = CorrectScheme(c.TableSchema);
                if (string.IsNullOrEmpty(c.RefTableSchema))
                    c.RefTableSchema = CorrectScheme(c.RefTableSchema);
            });
            
            foreach (var metaTable in result)
            {
                metaTable.Columns = columns.Where(ci => String.Compare(ci.TableSchema, metaTable.SchemeName, 
                                                            StringComparison.OrdinalIgnoreCase) == 0 &&
                                                        String.Compare(ci.TableName, metaTable.TableName,
                                                            StringComparison.OrdinalIgnoreCase) == 0)
                                            .Select(MapColumn).ToList();
            }

            return result;
        }

        public Task<List<MetaColumn>> GetColumnsByTable(string connectionString, string schemeName, string tableName)
        {
            return GetColumnsByTable(GetConnection(connectionString), schemeName, tableName);
        }

        protected async Task<List<MetaColumn>> GetColumnsByTable(DbConnection connection, string schemeName, string tableName)
        {
            var columns = await GetColumns(connection,schemeName, tableName).ConfigureAwait(false);
            return columns.Select(MapColumn).ToList();
        }

        public Task<bool> IsTableExisting (string connectionString, string schemaName, string tableName)
        {
            return IsTableExisting(GetConnection(connectionString), schemaName, tableName);
        }

        protected async Task<bool> IsTableExisting(DbConnection connection, string schemaName, string tableName)
        {
            var tables = await GetTables(connection).ConfigureAwait(false);
            return tables.Any(ti => ti.TableSchema.Equals(schemaName, StringComparison.OrdinalIgnoreCase) && ti.TableName.Equals(tableName, StringComparison.OrdinalIgnoreCase));
        }

        private MetaTable MapTable (DatabaseTableInfo tableInfo)
        {
            return new MetaTable
            {
                TableName = tableInfo.TableName,
                SchemeName = CorrectScheme(tableInfo.TableSchema),
            };
        }

        private MetaColumn MapColumn(DatabaseColumnInfo columnInfo)
        {
            bool isPrimaryKey = !string.IsNullOrEmpty(columnInfo.ConstraintName) && string.IsNullOrEmpty(columnInfo.RefConstraintName);
            
            return new MetaColumn
            {
                Caption = columnInfo.ColumnName, 
                ColumnName = columnInfo.ColumnName,
                IsPrimaryKey = isPrimaryKey,
                DataType = columnInfo.DataType,
                DefaultValue = columnInfo.Default,
                IsNullable = columnInfo.IsNullable,
                CharacterMaxLength = columnInfo.CharacterMaxLength,
                RefSchemeName = CorrectScheme(columnInfo.RefTableSchema),
                RefTableName = columnInfo.RefTableName,
                IsCreateConstraint = columnInfo.IsDeleteCascade || columnInfo.IsUpdateCascade,
                IsUpdateCascade = columnInfo.IsUpdateCascade,
                IsDeleteCascade = columnInfo.IsUpdateCascade
            };
        }

        private string CorrectScheme(string schemeName)
        {
            int compare = String.Compare(CloverRuntime.DbProvider.DefaultSchemaName,
                schemeName,
                StringComparison.OrdinalIgnoreCase);
            
            return compare == 0 ? string.Empty : schemeName;
            
        }

        protected T Map<T>(IDataReader reader, Dictionary<string, Action<T, IDataReader, int>> mappings) where T : new()
        {
            var result = new T();
            for (var i = 0; i < reader.FieldCount; i++)
            {
                var name = reader.GetName(i);
                if (mappings.ContainsKey(name.ToLower()))
                    mappings[name.ToLower()].Invoke(result, reader, i);
            }
            return result;
        }

        protected abstract DbConnection GetConnection(string connectionString);
        protected abstract Task<List<DatabaseTableInfo>> GetTables(DbConnection connection);
        protected abstract Task<List<DatabaseColumnInfo>> GetColumns(DbConnection connection, string schemaName = null, string tableName = null);
    }
}
