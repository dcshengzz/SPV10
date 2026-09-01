using System;
using System.Data.Common;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.DataProvider
{
    public interface IDbCommunication
    {
        DbConnection GetConnection(string connectionString);
        DbConnection GetDataConnection();
        void AddParameter(DbCommand command, string name, object value, AttributeType type);
        void AddParameter(DbCommand command, string name, object value, object dbType);
        void AddOutputParameter(DbCommand command, string name, AttributeType type);
        object ConvertToDbType(Type type, bool forceArray = false);
        Type ConvertToCLRType(string dbtype);
        string GetDbTypeName(Type type);
    }
}