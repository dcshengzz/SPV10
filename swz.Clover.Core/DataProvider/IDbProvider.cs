using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Threading.Tasks;
using swz.Clover.Core.Base;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.DataProvider
{
    public interface IDbProvider
    {
        Task<List<DynamicEntity>> ReadAsync(EntityModel model, Filter filter, Order order, Paging paging, string connection);

        Task<long> CountAsyc(EntityModel model, Filter filter, string connection);

        Task<ModifyingQueryResult> Delete(EntityModel model, IEnumerable<ChangeOperation> data, string connection);

        Task<ModifyingQueryResult> Insert(EntityModel model, IEnumerable<ChangeOperation> data, string connection);

        Task<ModifyingQueryResult> Update(EntityModel model, IEnumerable<ChangeOperation> data, string connection);

        IFilterCriteriaBuilder<T> GetFilterCriteriaBuilder<T>();

        IDbCommunication DbCommunication { get; }

        Task<List<DynamicEntity>> SelectQuery(string query, Dictionary<string, object> parameters = null, string connectionString = null);

        Task ExecuteStoredProcedureAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn, 
            Dictionary<string, object> paramsOut, 
            int? timeoutSeconds=null);

        Task<List<Dictionary<string,object>>> ExecuteStoredProcedureExAsync(
            string storedProcedure, 
            Dictionary<string, object> paramsIn, 
            Dictionary<string, object> paramsOut, 
            int timeoutSeconds = 3600);

        string AttributeToString(AttributeModel attributeModel, (AttributeLocation location, string tableAlias)  location);
        
        string PropertyToString(string propertyName, (AttributeLocation location, string tableAlias)  location);

        string OrderByToString(OrderByExpression orderBy, (OrderByLocation location, string tableAlias) location);

        string DefaultSchemaName { get; }

        bool IsVersionUpdatable { get; }

        byte[] GetNewVersion();

        Guid GenerateGuid();

        bool UseArrayParameterForIn { get; }

        string ParameterPrefix { get; }

        string GetBeginningOfInClause { get; }

        string GetBeginningOfNotInClause { get; }

        string CorrectTableName(string name);

        string CorrectColumnName(string modelName, string name);

        Task<List<MetaTable>> GetModelFromDatabase(string connectionString);

        AttributeModel GetAttributeByColumName(string name, EntityModel model);

        object GetWorkflowProvider();

        DbCommand ConfigureCommand(DbCommand command);

        PrimaryKeyGenerator PrimaryKeyGenerator { get; }
    }

    public class ChangeOperation
    {
        public DynamicEntity Entity { get; set; }
        public Filter Filter { get; set; }
        public IEnumerable<ChangePart> Data { get; set; }
    }

    public interface IFilterCriteriaBuilder<in T>
    {
        string LikeRight(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string NotLikeRight(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string LikeLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string NotLikeLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string LikeRightLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string NotLikeRightLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string Equal(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string NotEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string Greater(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string GreaterOrEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string Less(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string LessOrEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias);
        string LikeRight(T value, string property, FilterPurpose purpose, string tableAlias);
        string NotLikeRight(T value, string property, FilterPurpose purpose, string tableAlias);
        string LikeLeft(T value, string property, FilterPurpose purpose, string tableAlias);
        string NotLikeLeft(T value, string property, FilterPurpose purpose, string tableAlias);
        string LikeRightLeft(T value, string property, FilterPurpose purpose, string tableAlias);
        string NotLikeRightLeft(T value, string property, FilterPurpose purpose, string tableAlias);
        string Equal(T value, string property, FilterPurpose purpose, string tableAlias);
        string NotEqual(T value, string property, FilterPurpose purpose, string tableAlias);
        string Greater(T value, string property, FilterPurpose purpose, string tableAlias);
        string GreaterOrEqual(T value, string property, FilterPurpose purpose, string tableAlias);
        string Less(T value, string property, FilterPurpose purpose, string tableAlias);
        string LessOrEqual(T value, string property, FilterPurpose purpose, string tableAlias);
        string Format(T value);
        string FormatWithQuatation(T value);
    }
}
