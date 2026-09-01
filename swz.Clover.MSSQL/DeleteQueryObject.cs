using System.Collections.Generic;
using System.Data.Common;
using System.Diagnostics;
using System.Text;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    internal class DeleteQueryObject : MSSQLModifyingQueryObject
    {
        protected Filter Filter;

        internal DeleteQueryObject(SQLProvider sqlProvider, EntityModel model, string modelForUpdateName, Filter filter)
            : base(sqlProvider, model, modelForUpdateName, new List<ChangePart>())
        {
            Filter = filter;
        }

        public override string BuildCommandText()
        {
            var query = new StringBuilder();

            query = BuildDeleteClause(query);
            query = BuildWhereClause(Filter, Model, query);
#if DEBUG
            Debug.WriteLine(query.ToString());
#endif
            return query.ToString();
        }

        private StringBuilder BuildDeleteClause(StringBuilder query)
        {
            if (!string.IsNullOrEmpty(SchemaName))
             return query.AppendFormat("DELETE FROM [{0}].[{1}]", SchemaName, TableName);
            return query.AppendFormat("DELETE FROM [{0}]", TableName);
        }

        protected override void AddCommandParameters(DbCommand command)
        {
            base.AddCommandParameters(command);
            AddFilterCommandParameters(command, Model, Filter);
        }

    }
}
