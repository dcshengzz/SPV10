using System;
using System.Collections.Generic;
using System.Data.Common;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.Core.Base;
using swz.Clover.Core.DatabaseAnalyser;

namespace swz.Clover.MSSQL
{
    public class MSSQLAnalyzer : DatabaseAnalyzer
    {
        protected override DbConnection GetConnection(string connectionString)
        {
            return new SqlConnection(connectionString);
        }

        protected override async Task<List<DatabaseTableInfo>> GetTables(DbConnection connection)
        {
            var result = new List<DatabaseTableInfo>();
            var tableQuery = @"
SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES 
ORDER BY TABLE_SCHEMA, TABLE_NAME";

            using (var command = new SqlCommand(tableQuery))
            {
                command.Connection = connection as SqlConnection;

                using (var reader = await command.ExecuteReaderAsync().ConfigureAwait(false))
                {
                    while (await reader.ReadAsync().ConfigureAwait(false))
                    {
                        result.Add(Map(reader, TableInfoMapping));
                    }
                }
            }

            return result;
        }

        protected override async Task<List<DatabaseColumnInfo>> GetColumns(DbConnection connection, string schemaName = null, string tableName = null)
        {
            var result = new List<DatabaseColumnInfo>();

            string filter = string.IsNullOrWhiteSpace(tableName) || string.IsNullOrWhiteSpace(schemaName)
                ? string.Empty
                : $"WHERE col.[TABLE_SCHEMA] = '{schemaName}' AND col.[TABLE_NAME] = '{tableName}'";

            var columnQuery = $@"SELECT 
	col.[TABLE_SCHEMA],
	col.[TABLE_NAME],
	col.[COLUMN_NAME],
	col.[COLUMN_DEFAULT],
	col.[IS_NULLABLE],
	col.[DATA_TYPE],
	col.[CHARACTER_MAXIMUM_LENGTH],
	RefConst.[CONSTRAINT_NAME],
	refCol.[CONSTRAINT_NAME] as [REF_CONSTRAINT_NAME],
	refCol.[TABLE_SCHEMA] as [REF_TABLE_SCHEMA],
	refCol.[TABLE_NAME] as [REF_TABLE_NAME],
	RefConst.[UPDATE_RULE],
	RefConst.[DELETE_RULE]
FROM [INFORMATION_SCHEMA].[COLUMNS] col
LEFT JOIN (SELECT keyCol.[CONSTRAINT_NAME], keyCol.[TABLE_NAME], keyCol.[COLUMN_NAME], ref.UNIQUE_CONSTRAINT_NAME,ref.[UPDATE_RULE],ref.[DELETE_RULE] 
				 FROM [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE] keyCol 
					LEFT OUTER JOIN [INFORMATION_SCHEMA].[REFERENTIAL_CONSTRAINTS] ref on ref.[CONSTRAINT_NAME] = keyCol.[CONSTRAINT_NAME]
					LEFT OUTER JOIN [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] pk on pk.[CONSTRAINT_NAME] = keyCol.[CONSTRAINT_NAME]
					WHERE ref.[CONSTRAINT_NAME] IS NOT NULL OR (pk.[CONSTRAINT_NAME] IS NOT NULL AND CONSTRAINT_TYPE = 'PRIMARY KEY')
					)
					 AS RefConst on RefConst.[TABLE_NAME] = col.[TABLE_NAME] AND RefConst.[COLUMN_NAME] = col.[COLUMN_NAME] 
LEFT JOIN [INFORMATION_SCHEMA].[CONSTRAINT_COLUMN_USAGE] refCol on refCol.[CONSTRAINT_NAME] = RefConst.[UNIQUE_CONSTRAINT_NAME] 
{filter}
ORDER BY col.TABLE_SCHEMA, col.TABLE_NAME, col.COLUMN_NAME 
";
            using (var command = new SqlCommand(columnQuery))
            {
                command.Connection = connection as SqlConnection;

                using (var reader = await command.ExecuteReaderAsync().ConfigureAwait(false))
                {
                    while (await reader.ReadAsync().ConfigureAwait(false))
                    {
                        result.Add(Map(reader, ColumnInfoMapping));
                    }
                }
            }

            return result;
        }
    }

}


