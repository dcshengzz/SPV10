using System;
using System.Text;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    internal class SelectCountQueryObject : SelectValuesQueryObject
    {
        protected override FilterPurpose FilterPurpose => FilterPurpose.Other;
        private string _countParameterName = "count";

        public string CountParameterName
        {
            get { return _countParameterName; }
            set { _countParameterName = value; }
        }

        public SelectCountQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter, Order order, Paging paging)
            : base(sqlProvider, model, filter, order, paging)
        {
            throw new NotSupportedException();
        }

        public SelectCountQueryObject(SQLProvider sqlProvider, EntityModel model, Order order)
            : base(sqlProvider, model, order)
        {
        }

        public SelectCountQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter, Order order)
            : base(sqlProvider, model, filter, order)
        {
        }

        public SelectCountQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter)
            : base(sqlProvider, model, filter)
        {
        }

        public SelectCountQueryObject(SQLProvider sqlProvider, EntityModel model)
            : base(sqlProvider, model)
        {
        }

        protected override StringBuilder BuildParameterClause(StringBuilder query)
        {
            query.AppendFormat(" COUNT(*) {0} ", _countParameterName);
            return query;
        }

        protected override bool NeedUseSubquery()
        {
            return false;
        }
    }
}
