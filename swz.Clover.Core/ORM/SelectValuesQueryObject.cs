using System;
using System.Data.Common;
using System.Diagnostics;
using System.Text;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public abstract class SelectValuesQueryObject : SQLQueryObject
    {
        public const string SubQueryAlias = "SubQuery";
        
        protected override FilterPurpose FilterPurpose => Paging == Paging.Empty ? FilterPurpose.SelectValues : FilterPurpose.Other;

        protected readonly EntityModel Model;

        protected Filter Filter;

        protected readonly Order Order;

        protected readonly Paging Paging;

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model,
            Filter filter,
            Order order,
            Paging paging) : base(sqlProvider)
        {
            paging = paging ?? Paging.Empty;

            if (filter == null)
                throw new ArgumentNullException(nameof(filter));
            if (order == null)
                throw new ArgumentNullException(nameof(order));
            if (paging == null)
                throw new ArgumentNullException(nameof(paging));
            if (paging != Paging.Empty && order.IsEmpty) //orderBy == OrderByCriteriaSet.Empty)
                throw new ArgumentException("For Paging OrderBy clause must be set", nameof(order));

            Model = model ?? throw new ArgumentNullException(nameof(model));
            Filter = filter;
            Order = order;
            Paging = paging;
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model,
            Order order)
            : this(sqlProvider, model, Filter.Empty, order, Paging.Empty)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter, Order order)
            : this(sqlProvider, model, filter, order, Paging.Empty)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter)
            : this(sqlProvider, model, filter, Order.Empty, Paging.Empty)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model)
            : this(sqlProvider, model, Filter.Empty, Order.Empty, Paging.Empty)
        {
        }

        protected virtual bool NeedUseSubquery()
        {
            return Paging == Paging.Empty && Model.HasExtensions && (Filter.ContainsExtension(Model) || Order.ContainsExtension(Model));
        }


        public override string BuildCommandText()
        {
            var query = new StringBuilder();

            if (Paging != Paging.Empty)
                StartExternalSelectClauseForPaging(query);
            var needUseSubquery = NeedUseSubquery();
            if (needUseSubquery)
                query = StartExternalSelectClause(query);

            query = BuildSelectClause(query);

            query = BuildParameterClause(query);

            if (Paging != Paging.Empty)
                query = BuildPagingClause(query);

            query = BuildFromClause(query);
           
            if (needUseSubquery)
                query = EndExternalSelectClause(query);
            
            query = BuildWhereClause(Filter, Model, query);

            if (Paging != Paging.Empty)
                EndExternalSelectClauseForPaging(query);

            query = BuildOrderByClause(query);

#if DEBUG
            Debug.WriteLine(query.ToString());
#endif
            
            return query.ToString();
        }


        protected abstract StringBuilder BuildSelectClause(StringBuilder query);

        protected abstract StringBuilder BuildParameterClause(StringBuilder query);

        protected abstract StringBuilder BuildFromClause(StringBuilder query);

       // protected abstract StringBuilder BuildWhereClause(StringBuilder query);

        protected abstract StringBuilder BuildOrderByClause(StringBuilder query);

        protected abstract StringBuilder StartExternalSelectClauseForPaging(StringBuilder query);
        
        protected abstract StringBuilder StartExternalSelectClause(StringBuilder query);

        protected abstract StringBuilder EndExternalSelectClauseForPaging(StringBuilder query);
        
        protected abstract StringBuilder EndExternalSelectClause(StringBuilder query);

        protected abstract StringBuilder BuildPagingClause(StringBuilder query);


        protected override void AddCommandParameters(DbCommand command)
        {
            AddFilterCommandParameters(command, Model, Filter);
        }

        protected string GetPrimaryKeyColumnName(AttributeModel attribute)
        {
              return attribute.DataModel.PrimaryKeyAttributeName;
        }
        
        protected override StringBuilder BuildWhereClause(Filter filter, EntityModel model, StringBuilder query)
        {
            var needUseSubquery = NeedUseSubquery();
            string filterString = filter.Prepare(model).ToStringAsParameters(
                (needUseSubquery ? FilterPurpose.OutsideOfSubquery : FilterPurpose, needUseSubquery ?  SubQueryAlias : null));
            if (!string.IsNullOrEmpty(filterString))
                query.AppendFormat("WHERE {0} ", filterString);

            return query;
        }
    }
}
