using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    public abstract class MSSQLModifyingQueryObject : ModifyingQueryObject
    {
        protected MSSQLModifyingQueryObject(SQLProvider sqlProvider, EntityModel model, string modelForUpdateName, IEnumerable<ChangePart> changes) : base(sqlProvider, model, modelForUpdateName, changes)
        {
        }
        
        protected virtual StringBuilder BuildOutputClause(StringBuilder query)
        {
            var columns = Model.GetPlainCalculatedAttributes().Select(a => $"inserted.[{a.ColumnName}] AS [{a.PropertyName}]");
            query.Append($" OUTPUT {String.Join(",", columns)}");
            return query;
        }
    }
}