using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.Base;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.MSSQL
{
    public class SQLServerProvider : SQLProvider
    {
        private readonly IDbCommunication _dbCommunication = new DbCommunication();

        private readonly int StoredProcedureTimeoutSeconds = 30; //nb: NOT used by ExecuteStoredProcedureExAsyc which is hardcoded at 3600

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="storedProcedureTimeoutSeconds">alternate timeout to be used for calls to stored procedures from
        /// ExecuteStoredProcedureAsync (default is 30)</param>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        public SQLServerProvider(int? storedProcedureTimeoutSeconds=null)
        {
            if (storedProcedureTimeoutSeconds != null)
            {
                if (storedProcedureTimeoutSeconds < 0) throw new ArgumentOutOfRangeException(nameof(storedProcedureTimeoutSeconds), "Must be 0 or positive");
                StoredProcedureTimeoutSeconds = storedProcedureTimeoutSeconds.Value;
            }
        }

        public SQLServerProvider(PrimaryKeyGenerator primaryKeyGenerator, int? storedProcedureTimeoutSeconds = null) : base(primaryKeyGenerator)
        {
            if (storedProcedureTimeoutSeconds != null)
            {
                if (storedProcedureTimeoutSeconds < 0) throw new ArgumentOutOfRangeException(nameof(storedProcedureTimeoutSeconds), "Must be 0 or positive");
                StoredProcedureTimeoutSeconds = storedProcedureTimeoutSeconds.Value;
            }
        }

        public override IFilterCriteriaBuilder<T> GetFilterCriteriaBuilder<T>()
        {
            return new SQLFilterCriteriaBuilder<T>(new Formatter<T>());
        }

        public override IDbCommunication DbCommunication => _dbCommunication;

        /// <summary>
        /// Execute a stored procedure, returns no resultset, may return out params
        /// </summary>
        public override async Task ExecuteStoredProcedureAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn,
            Dictionary<string, object> paramsOut,
            int? timeoutSeconds=null)
        {

            SqlCommand cmd = new SqlCommand(storedProcedure) {CommandType = CommandType.StoredProcedure};

            #region Add parameters

            foreach (var pair in paramsIn)
            {
                var parameter = new SqlParameter("@" + pair.Key, DbCommunication.ConvertToDbType(pair.Value.GetType()))
                {
                    Value = pair.Value
                };
                cmd.Parameters.Add(parameter);
            }

            foreach (var pair in paramsOut)
            {
                var parameter = new SqlParameter("@" + pair.Key, DbCommunication.ConvertToDbType(pair.Value.GetType()))
                {
                    Value = pair.Value,
                    Direction = ParameterDirection.Output
                };
                if (pair.Value is string)
                    parameter.Size = 4000;

                cmd.Parameters.Add(parameter);
            }

            #endregion

            using (var shared = new SharedTransaction())
            {
                await shared.OpenConnectionAsync().ConfigureAwait(false);
                var connectionAndTransaction = shared.ConnectionAndTransaction;
                cmd.Connection = connectionAndTransaction.Connection as SqlConnection;
                cmd.Transaction = connectionAndTransaction.Transaction as SqlTransaction;
                cmd.CommandTimeout = (timeoutSeconds==null) ? StoredProcedureTimeoutSeconds : timeoutSeconds.Value;
                await cmd.ExecuteNonQueryAsync().ConfigureAwait(false);
            }
            
            foreach (SqlParameter par in cmd.Parameters)
            {
                if (par.Direction == ParameterDirection.Output || par.Direction == ParameterDirection.InputOutput)
                {
                    var key = par.ParameterName.Substring(1);
                    paramsOut[key] = par.Value;
                }
            }
        }

        /// <summary>
        /// Execute a stored procedure and return a result set
        /// n.b This method uses a default imeout of 3600 seconds if not otherwise specified
        /// </summary>
        /// <param name="storedProcedure"></param>
        /// <param name="paramsIn"></param>
        /// <param name="paramsOut"></param>
        /// <returns></returns>
        public override async Task<List<Dictionary<string, object>>> ExecuteStoredProcedureExAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn,
            Dictionary<string, object> paramsOut,
            int timeoutSeconds = 3600)
        {

            SqlCommand cmd = new SqlCommand(storedProcedure) { CommandType = CommandType.StoredProcedure };

            #region Add parameters

            foreach (var pair in paramsIn)
            {
                var parameter = new SqlParameter("@" + pair.Key, DbCommunication.ConvertToDbType(pair.Value.GetType()))
                {
                    Value = pair.Value
                };
                cmd.Parameters.Add(parameter);
            }

            foreach (var pair in paramsOut)
            {
                var parameter = new SqlParameter("@" + pair.Key, DbCommunication.ConvertToDbType(pair.Value.GetType()))
                {
                    Value = pair.Value,
                    Direction = ParameterDirection.Output
                };
                if (pair.Value is string)
                    parameter.Size = 4000;

                cmd.Parameters.Add(parameter);
            }

            #endregion

            List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();

            using (var shared = new SharedTransaction())
            {
                await shared.OpenConnectionAsync().ConfigureAwait(false);
                var connectionAndTransaction = shared.ConnectionAndTransaction;
                cmd.Connection = connectionAndTransaction.Connection as SqlConnection;
                cmd.Transaction = connectionAndTransaction.Transaction as SqlTransaction;
                cmd.CommandTimeout = timeoutSeconds;
                using (var reader = await cmd.ExecuteReaderAsync().ConfigureAwait(false))
                {
                    while (await reader.ReadAsync().ConfigureAwait(false))
                    {
                        var row = new Dictionary<string, object>();
                        for (var i = 0; i < reader.FieldCount; i++)
                        {
                            var name = reader.GetName(i);
                            var obj = reader.GetValue(i);
                            if (row.ContainsKey(name))
                                row[name] = obj;
                            else
                                row.Add(name, obj);
                        }
                        result.Add(row);
                    }
                }
            }

            foreach (SqlParameter par in cmd.Parameters)
            {
                if (par.Direction == ParameterDirection.Output || par.Direction == ParameterDirection.InputOutput)
                {
                    var key = par.ParameterName.Substring(1);
                    paramsOut[key] = par.Value;
                }
            }

            return result;
        }

        public override string AttributeToString(AttributeModel attribute, (AttributeLocation location, string tableAlias) location)
        {
            return AttributeToString((attribute, null), location);
        }

        public override string PropertyToString(string propertyName, (AttributeLocation location, string tableAlias) location)
        {
            return AttributeToString((null, propertyName), location);
        }

        private  string AttributeToString((AttributeModel attributeModel, string propertyName) attributeOrProperty, (AttributeLocation location, string tableAlias)  location)
        {
            var attribute = attributeOrProperty.attributeModel;
            var property = attributeOrProperty.propertyName;
            string ToTableName(DataModel dataModel)
            {
                if (!string.IsNullOrEmpty(location.tableAlias))
                    return $"[{location.tableAlias}].";
                return !string.IsNullOrEmpty(dataModel.SchemaName) ? $"[{dataModel.SchemaName}].[{dataModel.TableName}]." : $"[{dataModel.TableName}].";
            }

            string AddAlias()
            {
                if (!string.IsNullOrEmpty(location.tableAlias))
                    return $"[{location.tableAlias}].";
                return string.Empty;
            }

            if (attribute != null)
            {
                if (!attribute.IsExtension)
                {
                    if (location.location == AttributeLocation.FilterOutsideSubquery || location.location == AttributeLocation.OrderByOutsideSubquery)
                    {
                        return $"{AddAlias()}[{attribute.PropertyName}]";
                    }
                    return $"{ToTableName(attribute.DataModel)}[{attribute.ColumnName}]";

                }
                
                //Extensions

                if (location.location == AttributeLocation.ColumnList || location.location == AttributeLocation.OtherFilter ||
                    location.location == AttributeLocation.OrderByPaging)
                {
                    if (attribute is JoinedAttributeModel joined)
                    {
                        if (!joined.DataModel.HasExtensionsContainerAttribute)
                            throw new DynamicEntitiesException($"Model {joined.DataModel.Name} contains extensions but haven't a container attribute");
                        var extensinContainerColumn = $"[{joined.TableAlias}].[{joined.DataModel.ExtensionsContainerAttributeName}]";

                        return $" {AddCastExpression($"JSON_VALUE({extensinContainerColumn}, '$.{joined.ColumnName}')", typeof(string), joined)}";
                    }
                    else
                    {
                        if (!attribute.DataModel.HasExtensionsContainerAttribute)
                            throw new DynamicEntitiesException($"Model {attribute.DataModel.Name} contains extensions but haven't a container attribute");
                        var extensinContainerColumn = $"{ToTableName(attribute.DataModel)}[{attribute.DataModel.ExtensionsContainerAttributeName}]";
                            
                        return $" {AddCastExpression($"JSON_VALUE({extensinContainerColumn}, '$.{attribute.ColumnName}')", typeof(string), attribute)}";
                    }

                }

                return $"{AddAlias()}[{attribute.PropertyName}]";
            }

            return  $"{AddAlias()}[{property}]";
        }

     

        public override string DefaultSchemaName => "dbo";

        public override bool IsVersionUpdatable => false;

        public override byte[] GetNewVersion()
        {
            throw new NotImplementedException();
        }

        public override Guid GenerateGuid()
        {
            if (UseSquentialIdentifiers)
                return SequentialGuidGenerator.NewSequentialGuid(SequentialGuidType.SequentialAtEnd);
            return Guid.NewGuid();
        }

        protected override Core.ORM.SelectValuesQueryObject CreateSelectValuesQueryObject(SQLProvider dbCommunication, EntityModel model,
            Filter filter, Order order, Paging paging)
        {
            return new SelectValuesQueryObject(dbCommunication, model, filter, order, paging);
        }

        protected override Core.ORM.SelectValuesQueryObject CreateSelectCountQueryObject(SQLProvider dbCommunication,
            EntityModel model,
            Filter filter)
        {
            return new SelectCountQueryObject(dbCommunication, model, filter);
        }

        protected override ModifyingQueryObject CreateInsertQueryObject(SQLProvider dbCommunication, EntityModel model,
            string modelForUpdateName, IEnumerable<ChangePart> changes)
        {
            return new InsertQueryObject(dbCommunication, model, modelForUpdateName, changes);
        }

        protected override ModifyingQueryObject CreateUpdateQueryObject(SQLProvider dbCommunication, EntityModel model,
            string modelForUpdateName, IEnumerable<ChangePart> changes, Filter filter)
        {
            return new UpdateQueryObject(dbCommunication, model, modelForUpdateName, changes, filter);
        }

        protected override ModifyingQueryObject CreateDeleteQueryObject(SQLProvider dbCommunication, EntityModel model,
            string modelForUpdateName, Filter filter)
        {
            return new DeleteQueryObject(dbCommunication, model, modelForUpdateName, filter);
        }

        public override Task<List<MetaTable>> GetModelFromDatabase(string connectionString)
        {
            var a = new MSSQLAnalyzer();
            return a.FromDatabase(connectionString);
        }

        public override object GetWorkflowProvider()
        {
            return new swz.Workflow.DbPersistence.MSSQLProvider(CloverRuntime.ConnectionStringData);
        }

        public override string AddCastExpression(string expession, Type from, AttributeModel attribute)
        {
            return AddCastExpression(expession,from, attribute.Type.CLRType);
        }
        
        public override string AddCastExpression(string expession, Type from, Type to)
        {
//            if (from != null && to == typeof(string) && from.GetUnderlyingType() == typeof(DateTime))
//            {
//                return $"CONVERT({DbCommunication.GetDbTypeName(to)},{expession},21)"; //yyyy-mm-dd hh:mi:ss.mmm
//            }

            if (from != null && to == typeof(string))
            {
                var dbType = (SqlDbType)DbCommunication.ConvertToDbType(from.GetUnderlyingType());

                if (dbType == SqlDbType.DateTime)
                {
                    return $"CONVERT({DbCommunication.GetDbTypeName(to)},{expession},21)"; //yyyy-mm-dd hh:mi:ss.mmm
                }

                if (dbType == SqlDbType.Float || dbType == SqlDbType.Real)
                {
                    return $"CONVERT({DbCommunication.GetDbTypeName(to)},{expession},3)"; //max precision
                }
            }

            if (from == typeof(string))
            {
                var dbType = DbCommunication.ConvertToDbType(to);
                if ((SqlDbType)dbType == SqlDbType.Decimal)
                {
                    return $"CAST({expession} AS {DbCommunication.GetDbTypeName(to)}(38,4))"; //TODO CLOVER-71 this fix is temporary. We need to specify Decimal precison in Metadata 
                }
            }
            
            return $"CAST({expession} AS {DbCommunication.GetDbTypeName(to)})";
        }
    }
}
