using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Diagnostics;
using System.Linq;
using System.Text;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    internal class UpdateQueryObject : MSSQLModifyingQueryObject
    {
        protected Filter Filter;

        internal UpdateQueryObject(SQLProvider sqlProvider, EntityModel model, string modelForUpdateName, IEnumerable<ChangePart> changes,
            Filter filter)
            : base(sqlProvider, model, modelForUpdateName, changes)
        {
            Filter = filter;
        }

        public override string BuildCommandText()
        {
            var query = new StringBuilder();
            query = BuildUpdateClause(query);
            query = BuildSetClause(query);
            if (CalculatedColumnsReturnType != CalculatedColumnsReturnType.None)
            {
                query = BuildOutputClause(query);
            }
            query = BuildWhereClause(Filter,Model,query);
#if DEBUG
            Debug.WriteLine(query.ToString());
#endif
            return query.ToString();
        }
        
      

        protected virtual StringBuilder BuildUpdateClause(StringBuilder query)
        {
            query.AppendFormat("UPDATE {0}[{1}]",
                !string.IsNullOrEmpty(SchemaName) ? string.Format("[{0}].", SchemaName) : string.Empty, TableName);
            return query;
        }

        protected virtual StringBuilder BuildSetClause(StringBuilder query)
        {
            query.Append(" SET");
            var extensionChanges = new List<ChangePart>();
            foreach (var change in Changes)
            {
                var attribute = AttributesForUpdate.SingleOrDefault(a => a.PropertyName.Equals(change.PropertyName, StringComparison.OrdinalIgnoreCase));
                if (attribute == null || attribute.IsExtensionsContainer)
                    continue;
                if (attribute.IsExtension)
                {
                    extensionChanges.Add(change);
                    continue;
                }

                query.AppendFormat(" {0}[{1}].[{2}] = @{3},", !string.IsNullOrEmpty(SchemaName) ? string.Format("[{0}].", SchemaName) : string.Empty, TableName, attribute.ColumnName,
                    GetValueParameterName(attribute));
            }

            if (extensionChanges.Any() && Model.HasExtensionsContainerAttribute)
            {

               var extensionsSet = string.Format(" {0}[{1}].[{2}] = ", !string.IsNullOrEmpty(SchemaName) ? string.Format("[{0}].", SchemaName) : string.Empty, TableName,
                    Model.ExtensionsContainerAttribute.ColumnName);

                var jsonSetString = string.Empty;
                var extensionsColumn = !string.IsNullOrEmpty(Model.SchemaName)
                    ? $" [{Model.SchemaName}].[{Model.TableName}].[{Model.ExtensionsContainerAttribute.ColumnName}]"
                    : $" [{Model.TableName}].[{Model.ExtensionsContainerAttribute.ColumnName}]";
                foreach (var extensionChange in extensionChanges)
                {
                    var attribute = AttributesForUpdate.SingleOrDefault(a => a.PropertyName.Equals(extensionChange.PropertyName, StringComparison.OrdinalIgnoreCase));
                    
                    if (attribute == null)
                        continue;
                    //string ToCastParameterExpression() => SQLProvider.AddCastExpression($"@{GetValueParameterName(attribute)}", attribute.Type.CLRType, typeof(string)); //CAST (@p AS nvarchar)
                    string ToCastParameterExpression()
                    {
                        if (attribute.Type.OriginalCLRType != typeof(DateTime) && attribute.Type.OriginalCLRType != typeof(Guid))
                            return $"@{GetValueParameterName(attribute)}";
                        return SQLProvider.AddCastExpression($"@{GetValueParameterName(attribute)}", attribute.Type.CLRType, typeof(string));
                    }
                    if (jsonSetString == string.Empty)
                        jsonSetString = $"JSON_MODIFY(COALESCE({extensionsColumn},'{{}}'),'$.{attribute.ColumnName}', {ToCastParameterExpression()})";
                    else
                        jsonSetString  = $"JSON_MODIFY({jsonSetString},'$.{attribute.ColumnName}', {ToCastParameterExpression()})";
                }

                if (jsonSetString != string.Empty)
                    query.Append($"{extensionsSet}{jsonSetString}");
            }
            else
            {
                query.Remove(query.Length - 1, 1);
            }
            
            query.Append(' ');
            
            return query;

        }

    
        protected override void AddCommandParameters(DbCommand command)
        {
            base.AddCommandParameters(command);
            AddFilterCommandParameters(command, Model, Filter);
        }

        protected override CalculatedColumnsReturnType BaseCalculatedColumnsReturnType => CalculatedColumnsReturnType.AsTableRow;
    }
}
