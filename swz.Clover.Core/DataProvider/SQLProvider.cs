using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Base;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.DataProvider
{
    public abstract class SQLProvider : IDbProvider
    {
        public PrimaryKeyGenerator PrimaryKeyGenerator { get; private set; }

        public  SQLProvider()
        {
            PrimaryKeyGenerator = new PrimaryKeyGenerator(this);
        }

        public  SQLProvider(PrimaryKeyGenerator primaryKeyGenerator)
        {
            PrimaryKeyGenerator = primaryKeyGenerator;
            primaryKeyGenerator.Provider = this;
        }
       
        public bool UseSquentialIdentifiers { get; set; }

        public abstract IDbCommunication DbCommunication { get; }

        public virtual Task<List<DynamicEntity>> ReadAsync(EntityModel model, Filter filter, Order order,
            Paging paging, string connection)
        {
            var select = CreateSelectValuesQueryObject(this, model, filter, order, paging);
            return DbCommandExecutor.ExecuteSelectAsync(model, select, string.IsNullOrEmpty(connection) ? CloverRuntime.ConnectionStringData : connection);
        }

        public virtual Task<long> CountAsyc(EntityModel model, Filter filter, string connection)
        {
            var select = CreateSelectCountQueryObject(this, model, filter);
            return DbCommandExecutor.ExecuteSelectCountAsync(select, string.IsNullOrEmpty(connection) ? CloverRuntime.ConnectionStringData : connection);
        }

        public abstract IFilterCriteriaBuilder<T> GetFilterCriteriaBuilder<T>();

        public virtual Task<List<DynamicEntity>> SelectQuery(string query, Dictionary<string, object> parameters = null, string connectionString = null)
        {
            return DbCommandExecutor.ExecuteSelectAsync(query, parameters, connectionString);
        }

        public abstract Task ExecuteStoredProcedureAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn, 
            Dictionary<string, object> paramsOut, 
            int? timeoutSeconds=null);

        public abstract Task<List<Dictionary<string, object>>> ExecuteStoredProcedureExAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn,
            Dictionary<string, object> paramsOut,
            int timeoutSeconds = 3600);

        public abstract string AttributeToString(AttributeModel attributeModel, (AttributeLocation location, string tableAlias) location);

        public abstract string PropertyToString(string propertyName, (AttributeLocation location, string tableAlias) location);

        public virtual string OrderByToString(OrderByExpression orderBy, (OrderByLocation location, string tableAlias) location)
        {
            if (!orderBy.IsCustomExpression)
            {
                var sort = orderBy.ExpressionOrderType == OrderByExpression.OrderType.ASC ? "ASC" : "DESC";
                if (!orderBy.HasAttribute)
                    return
                        $"{PropertyToString(orderBy.PropertyName, (location.location.ConvertToAttributeLocation(), location.tableAlias))} {sort}";

                var alias = !string.IsNullOrEmpty(location.tableAlias) ? location.tableAlias : orderBy.Attribute is JoinedAttributeModel joined ? joined.TableAlias : null;
                return $"{AttributeToString(orderBy.Attribute, (location.location.ConvertToAttributeLocation(), alias))} {sort}";
            }

            if (location.tableAlias == null)
                return orderBy.CustomExpression.Replace("@alias", string.Empty);
            return orderBy.CustomExpression.Replace("@alias", location.tableAlias);
        }

        public abstract string DefaultSchemaName { get; }
        public abstract bool IsVersionUpdatable { get; }
        public abstract byte[] GetNewVersion();
        public abstract Guid GenerateGuid();

        public virtual bool UseArrayParameterForIn => false;

        public virtual string ParameterPrefix => "@";

        public virtual string GetBeginningOfInClause => "IN (";

        public virtual string GetBeginningOfNotInClause => "NOT IN (";


        public virtual string CorrectColumnName(string modelName, string name)
        {
            return name;
        }

        public virtual string CorrectTableName(string name)
        {
            return name;
        }

        public abstract Task<List<MetaTable>> GetModelFromDatabase(string connectionString);

        public virtual AttributeModel GetAttributeByColumName(string name, EntityModel model)
        {
            return model?.GetAttributeByName(name);
        }

        public virtual object GetWorkflowProvider()
        {
            throw new NotImplementedException();
        }

        public virtual DbCommand ConfigureCommand(DbCommand command)
        {
            return command;
        }

        public virtual Task<ModifyingQueryResult> Delete(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            var deleteQueryObjects = data.Select(d => d.Filter).Select(filter => CreateDeleteQueryObject(this, model, model.Name, filter)).ToList();

            connection = string.IsNullOrEmpty(connection) ? CloverRuntime.ConnectionStringData : connection;

            return DbCommandExecutor.ExecuteDeleteAsync(deleteQueryObjects, connection);
        }

        public virtual Task<ModifyingQueryResult> Insert(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            var changeOperations = data.ToList();
            
            if (changeOperations.Any(d=>d.Entity == null))
                throw new DynamicEntitiesException("Inserts without the specified entity aren't supported");
            
            var inserted = changeOperations.ToDictionary(d => d.Entity.GetId(), d => CreateInsertQueryObject(this, model, model.Name, d.Data));

            connection = string.IsNullOrEmpty(connection) ? CloverRuntime.ConnectionStringData : connection;

            return DbCommandExecutor.ExecuteInsertAsync(inserted, connection);
        }

        public virtual Task<ModifyingQueryResult> Update(EntityModel model, IEnumerable<ChangeOperation> data, string connection)
        {
            var changeOperations = data.ToList();
            
            if (changeOperations.Any(d=>d.Entity == null))
                throw new DynamicEntitiesException("Updates without the specified entity aren't supported");

            var updates = changeOperations.ToDictionary(d => d.Entity.GetId(), d => CreateUpdateQueryObject(this, model, model.Name, d.Data, d.Filter));

            connection = string.IsNullOrEmpty(connection) ? CloverRuntime.ConnectionStringData : connection;

            return DbCommandExecutor.ExecuteUpdateAsync(updates, connection);
        }

        protected abstract SelectValuesQueryObject CreateSelectValuesQueryObject(SQLProvider dbCommunication,
            EntityModel model, Filter filter, Order order,
            Paging paging);

        protected abstract SelectValuesQueryObject CreateSelectCountQueryObject(SQLProvider dbCommunication,
            EntityModel model, Filter filter);

        protected abstract ModifyingQueryObject CreateInsertQueryObject(SQLProvider dbCommunication, EntityModel model, string modelForUpdateName,
            IEnumerable<ChangePart> changes);

        protected abstract ModifyingQueryObject CreateUpdateQueryObject(SQLProvider dbCommunication, EntityModel model, string modelForUpdateName,
            IEnumerable<ChangePart> changes, Filter filter);

        protected abstract ModifyingQueryObject CreateDeleteQueryObject(SQLProvider dbCommunication,
            EntityModel model, string modelForUpdateName, Filter filter);

        public abstract string AddCastExpression(string expession, Type from, AttributeModel attribute);

        public abstract string AddCastExpression(string expession, Type from, Type to);
    }
}