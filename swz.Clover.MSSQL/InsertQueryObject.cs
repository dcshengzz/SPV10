using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.Extensions.Primitives;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    internal class InsertQueryObject : MSSQLModifyingQueryObject
    {
        public override string BuildCommandText()
        {
            var query = new StringBuilder();
            query = BuildInsertClause(query);
            query = BuildParametersClause(query);
            if (CalculatedColumnsReturnType != CalculatedColumnsReturnType.None)
            {
                query = BuildOutputClause(query);
            }
            query = BuildValuesClause(query);
#if DEBUG
            Debug.WriteLine(query.ToString());
#endif
            return query.ToString();
        }

        private StringBuilder BuildValuesClause(StringBuilder query)
        {
            query.Append(" VALUES (");
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
                query.AppendFormat(" @{0},", GetValueParameterName(attribute));
            }

            if (extensionChanges.Any() && Model.HasExtensionsContainerAttribute)
            {
                var jsonSetString = string.Empty;
                foreach (var extensionChange in extensionChanges)
                {
                    var attribute = AttributesForUpdate.SingleOrDefault(a => a.PropertyName.Equals(extensionChange.PropertyName, StringComparison.OrdinalIgnoreCase));
                    
                    if (attribute == null)
                        continue;
                    string ToCastParameterExpression()
                    {
                        if (attribute.Type.OriginalCLRType != typeof(DateTime) && attribute.Type.OriginalCLRType != typeof(Guid))
                            return $"@{GetValueParameterName(attribute)}";
                        return SQLProvider.AddCastExpression($"@{GetValueParameterName(attribute)}", attribute.Type.CLRType, typeof(string));
                    }

                    //CAST (@p AS nvarchar)
                    if (jsonSetString == string.Empty)
                        jsonSetString = $"JSON_MODIFY('{{}}','$.{attribute.ColumnName}', {ToCastParameterExpression()})";
                    else
                        jsonSetString = $"JSON_MODIFY({jsonSetString},'$.{attribute.ColumnName}', {ToCastParameterExpression()})";
                }

                if (jsonSetString != string.Empty)
                    query.Append(jsonSetString);
            }
            else
            {
                query.Remove(query.Length - 1, 1);
            }
           
            query.Append(" )");
            return query;
        }

        private StringBuilder BuildParametersClause(StringBuilder query)
        {
            query.Append(" (");
            bool changesInExtensions = false;
            foreach (var change in Changes)
            {
                var attribute = AttributesForUpdate.SingleOrDefault(a => a.PropertyName.Equals(change.PropertyName, StringComparison.OrdinalIgnoreCase));
                if (attribute == null || attribute.IsExtensionsContainer)
                    continue;
                if (attribute.IsExtension)
                {
                    changesInExtensions = true;
                    continue;
                }

                if (!string.IsNullOrEmpty(SchemaName))
                    query.AppendFormat("[{0}].", SchemaName);
                else
                    query.Append(" ");
                query.AppendFormat(" [{0}].[{1}],", TableName, attribute.ColumnName);
            }

            if (changesInExtensions && Model.HasExtensionsContainerAttribute)
            {
                if (!string.IsNullOrEmpty(SchemaName))
                    query.AppendFormat("[{0}].", SchemaName);
                else
                    query.Append(" ");
                query.AppendFormat(" [{0}].[{1}],", TableName, Model.ExtensionsContainerAttribute.ColumnName);
            }

            query.Remove(query.Length - 1, 1);
            query.Append(" )");
            return query;
        }

        private StringBuilder BuildInsertClause(StringBuilder query)
        {
            if (!string.IsNullOrEmpty(SchemaName))
                query.AppendFormat("INSERT INTO [{0}].[{1}]", SchemaName, TableName);
            else
                query.AppendFormat("INSERT INTO [{0}]", TableName);
            return query;
        }

        internal InsertQueryObject(SQLProvider sqlProvider, EntityModel model,
            string modelForUpdateName, IEnumerable<ChangePart> changes)
            : base(sqlProvider, model, modelForUpdateName, changes)
        {
        }

        protected override CalculatedColumnsReturnType BaseCalculatedColumnsReturnType => CalculatedColumnsReturnType.AsTableRow;
    }
}
