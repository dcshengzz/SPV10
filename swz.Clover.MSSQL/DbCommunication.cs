using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using Microsoft.Data.SqlClient;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.MSSQL
{
    public  class DbCommunication : IDbCommunication
    {
        private static readonly Dictionary<Type, (SqlDbType DbType,string TypeName)> Mapping =
             new Dictionary<Type, (SqlDbType,string)>
                {
                    {typeof (Boolean), (SqlDbType.Bit,"bit")},
                    {typeof (Int16), (SqlDbType.SmallInt,"smallint")},
                    {typeof (Int32), (SqlDbType.Int,"int")},
                    {typeof (Int64), (SqlDbType.BigInt,"bigint")},
                    {typeof (Double), (SqlDbType.Float,"float")},
                    {typeof (Decimal), (SqlDbType.Decimal,"decimal")},
                    {typeof (String), (SqlDbType.NVarChar,"nvarchar(max)")},
                    {typeof (DateTime), (SqlDbType.DateTime,"datetime")},
                    {typeof (Byte), (SqlDbType.TinyInt,"tinyint")},
                    {typeof (Byte[]), (SqlDbType.VarBinary,"varbinary")},
                    {typeof (Guid), (SqlDbType.UniqueIdentifier,"uniqueidentifier")},
                    {typeof (char), (SqlDbType.NChar, "nchar")},
                    {typeof(Single), (SqlDbType.Real,"real")}
                };

        public DbConnection GetConnection(string connectionString)
        {
            var connection = new SqlConnection(connectionString);
            return connection;
        }

        public DbConnection GetDataConnection()
        {
            return GetConnection(CloverRuntime.ConnectionStringData);
        }

        public void AddParameter(DbCommand command, string name, object value, AttributeType type)
        {
            AddParameter(command, name, value, ConvertToDbType(type.OriginalCLRType));

        }

        public void AddParameter(DbCommand command, string name, object value, object dbType)
        {
            var sqlCommand = command as SqlCommand;

            if (sqlCommand == null)
                return;

            SqlParameter parameter;
            if (value is string)
            {
                parameter = sqlCommand.Parameters.Add(name, SqlDbType.NVarChar);
                parameter.Value = value;
            }
            else
            {
                parameter = sqlCommand.Parameters.Add(name, (SqlDbType)dbType);
                parameter.Value = value ?? DBNull.Value;
            }

            if (value == null)
                parameter.IsNullable = true;
        }

        public void AddOutputParameter(DbCommand command, string name, AttributeType type)
        {
            var sqlCommand = command as SqlCommand;

            sqlCommand?.Parameters.Add(new SqlParameter(name,ConvertToDbType(type.OriginalCLRType))
            {
                IsNullable = type.IsNullable,
                Direction = ParameterDirection.Output
            });
        }
       
        public object ConvertToDbType(Type type, bool forceArray = false)
        {
            //SQL Have no array types
            if (forceArray)
                throw new DynamicEntitiesException($"SQL Server doesn't support array types directly");
            var underlyingType = type.GetUnderlyingType();
            if (Mapping.ContainsKey(underlyingType))
                return Mapping[underlyingType].DbType;
            return SqlDbType.NVarChar;
        }

        public string GetDbTypeName(Type type)
        {
            var underlyingType = type.GetUnderlyingType();
            return Mapping.ContainsKey(underlyingType) ? Mapping[underlyingType].TypeName : "nvarchar(max)";
        }

       

        public Type ConvertToCLRType(string dbtype)
        {
            switch (dbtype.ToLower())
            {
                case "bigint": return typeof(Int64);
                case "binary": return typeof(Byte[]);
                case "bit": return typeof(Boolean);
                case "char": return typeof(String);
                case "cursor": return typeof(String);
                case "date": return typeof(DateTime);
                case "datetime": return typeof(DateTime);
                case "datetime2": return typeof(DateTime);
                case "datetimeoffset": return typeof(DateTimeOffset);
                case "decimal": return typeof(Decimal);
                case "float": return typeof(Double);
                case "geography": return typeof(String);
                case "geometry": return typeof(String);
                case "hierarchyid": return typeof(String);
                case "image": return typeof(byte[]);
                case "int": return typeof(Int32);
                case "money": return typeof(Decimal);
                case "nchar": return typeof(String);
                case "ntext": return typeof(String);
                case "numeric": return typeof(Decimal);
                case "nvarchar": return typeof(String);
                case "real": return typeof(Single);
                case "rowversion": return typeof(Byte[]);
                case "smallint": return typeof(Int16);
                case "smallmoney": return typeof(Decimal);
                case "sql_variant": return typeof(Object);
                case "table": return typeof(String);
                case "text": return typeof(String);
                case "time": return typeof(TimeSpan);
                case "timestamp": return typeof(String);
                case "tinyint": return typeof(Byte);
                case "uniqueidentifier": return typeof(Guid);
                case "varbinary": return typeof(Byte[]);
                case "varchar": return typeof(String);
                case "xml": return typeof(String);
                default: return typeof(String);
            }
        }
    }
}
