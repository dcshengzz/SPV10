using swz.Clover.Core;
using swz.Clover.Core.Base;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Threading.Tasks;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// A placeholder implementation of IDbProvider with most functions not implemented and
    /// will throw NotImplementedExceptions.
    /// </summary>
    public class MinimalDbProvider : IDbProvider
    {
        //TODO - this attempts to implement a minimal set of functions & properties (ie: DefaultSchemaName)
        //       to keep internet side happy. If more are needed can copy and adapt from SQLServerProvider
        //       (worst case can switch back to using SQLServerProvider, but the bulk of of its methods won't work under u@app)

        //private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<DbProviderNotSupported>();

        private const string ApiNotSupported = "The complete IDbProvider API is not supported here";

        public IDbCommunication DbCommunication => throw new NotImplementedException();

        public string DefaultSchemaName => "dbo";

        public bool IsVersionUpdatable => false;

        public bool UseArrayParameterForIn => throw new NotImplementedException(ApiNotSupported);

        public string ParameterPrefix => throw new NotImplementedException(ApiNotSupported);

        public string GetBeginningOfInClause => throw new NotImplementedException(ApiNotSupported);

        public string GetBeginningOfNotInClause => throw new NotImplementedException(ApiNotSupported);

        public PrimaryKeyGenerator PrimaryKeyGenerator => throw new NotImplementedException(ApiNotSupported);

        public string AttributeToString(AttributeModel attributeModel, (AttributeLocation location, string tableAlias) location)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public DbCommand ConfigureCommand(DbCommand command)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public string CorrectColumnName(string modelName, string name)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public string CorrectTableName(string name)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<long> CountAsyc(EntityModel model, Filter filter, string connection)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<ModifyingQueryResult> Delete(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task ExecuteStoredProcedureAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn, 
            Dictionary<string, object> paramsOut,
            int? timeoutSeconds=null)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<List<Dictionary<string, object>>> ExecuteStoredProcedureExAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn, 
            Dictionary<string, object> paramsOut, 
            int timeoutSeconds = 3600)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        /// <summary>
        /// Returns a new Guid using Guid.NewGuid
        /// </summary>
        /// <returns></returns>
        public Guid GenerateGuid()
        {
            return Guid.NewGuid();
        }

        public AttributeModel GetAttributeByColumName(string name, EntityModel model)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public IFilterCriteriaBuilder<T> GetFilterCriteriaBuilder<T>()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<List<MetaTable>> GetModelFromDatabase(string connectionString)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public byte[] GetNewVersion()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public object GetWorkflowProvider()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<ModifyingQueryResult> Insert(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public string OrderByToString(OrderByExpression orderBy, (OrderByLocation location, string tableAlias) location)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public string PropertyToString(string propertyName, (AttributeLocation location, string tableAlias) location)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<List<DynamicEntity>> ReadAsync(EntityModel model, Filter filter, Order order, Paging paging, string connection)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<List<DynamicEntity>> SelectQuery(string query, Dictionary<string, object> parameters = null, string connectionString = null)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<ModifyingQueryResult> Update(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

    }
}
