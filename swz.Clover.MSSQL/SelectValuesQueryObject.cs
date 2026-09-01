using System.Collections.Generic;
using System.Globalization;
using System.Text;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.MSSQL
{
    internal class SelectValuesQueryObject : Core.ORM.SelectValuesQueryObject
    {
        public const string PagingSubQueryAlias = "PagingTable";
        
        public SelectValuesQueryObject(SQLProvider sqlProvider,EntityModel model,
                                       Filter filter,
                                       Order order,
                                       Paging paging)
            : base(sqlProvider,model, filter, order, paging)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model, Order order)
            : base(sqlProvider, model, order)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter, Order order)
            : base(sqlProvider, model, filter, order)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model, Filter filter)
            : base(sqlProvider, model, filter)
        {
        }

        public SelectValuesQueryObject(SQLProvider sqlProvider, EntityModel model)
            : base(sqlProvider, model)
        {
        }

        protected override StringBuilder BuildSelectClause(StringBuilder query)
        {
            query.Append("SELECT ");
            return query;
        }

        protected override StringBuilder BuildParameterClause(StringBuilder query)
        {
            //TODO HIGNH REWRITE ON Attribute .tosting
            var extensinContainerColumn = Model.HasExtensionsContainerAttribute
                ? !string.IsNullOrEmpty(Model.SchemaName) ? $" [{Model.SchemaName}].[{Model.TableName}].[{Model.ExtensionsContainerAttribute.ColumnName}]" :
                $" [{Model.TableName}].[{Model.ExtensionsContainerAttribute.ColumnName}]"
                : null;


            foreach (var plain in Model.PlainAttributesForSelectQuery)
            {
                if (plain.IsExtensionsContainer)
                    continue;

                if (plain.IsExtension)
                {
                    query.Append(
                        $" {SQLProvider.AddCastExpression($"JSON_VALUE({extensinContainerColumn}, '$.{plain.ColumnName}')", typeof(string), plain)} AS [{plain.PropertyName}],");
                }
                else
                {
                    var columnName = !string.IsNullOrEmpty(Model.SchemaName)
                        ? $" [{Model.SchemaName}].[{Model.TableName}].[{plain.ColumnName}]"
                        : $" [{Model.TableName}].[{plain.ColumnName}]";
                    query.Append($"{columnName} [{plain.PropertyName}],");
                }
            }

            Dictionary<string,string> joinedContainerColumns = new Dictionary<string, string>();

            foreach (var joined in Model.JoinedAttributesForSelectQuery)
            {
                if (joined.IsExtensionsContainer)
                    continue;
                
                if (joined.DataModel.HasExtensionsContainerAttribute)
                {
                    if (!joinedContainerColumns.ContainsKey(joined.DataModel.Name))
                    {
                        var joinedExtensionColumnName = $"[{joined.TableAlias}].[{joined.DataModel.ExtensionsContainerAttributeName}]";
                        joinedContainerColumns.Add(joined.DataModel.Name, joinedExtensionColumnName);
                    }

                }

                if (joined.IsExtension)
                {
                    query.Append(
                        $" {SQLProvider.AddCastExpression($"JSON_VALUE({joinedContainerColumns[joined.DataModel.Name]}, '$.{joined.ColumnName}')", typeof(string), joined)} AS [{joined.PropertyName}],");
                }
                else
                {
                    query.AppendFormat(" [{0}].[{1}] [{2}],", joined.TableAlias,
                        joined.ColumnName,
                        joined.PropertyName);
                }

            }


            query.Remove(query.Length - 1, 1);

            query.Append(" ");

            return query;
        }

        protected override StringBuilder BuildFromClause(StringBuilder query)
        {
            if (!string.IsNullOrEmpty(Model.SchemaName))
                query.AppendFormat("FROM [{0}].[{1}] ", Model.SchemaName, Model.TableName);
            else
                query.AppendFormat("FROM [{0}] ", Model.TableName);

            var usedParentsList = new List<string>();

            foreach (var joined in Model.JoinedAttributesForSelectQuery)
            {
                string key = string.Format("{0}_{1}", joined.TableAlias, joined.Parent.ColumnName);
                if (!usedParentsList.Contains(key))
                    usedParentsList.Add(key);
                else
                    continue;

                var fromTableName = !string.IsNullOrEmpty(Model.SchemaName)
                    ? string.Format("[{0}].[{1}]", Model.SchemaName, Model.TableName)
                    : string.Format("[{0}]", Model.TableName);


                if (joined.Parent is JoinedAttributeModel joinedParent)
                    fromTableName = string.Format("[{0}]", joinedParent.TableAlias);

                query.Append(joined.Parent.Type.IsNullable ? " LEFT OUTER JOIN " : " INNER JOIN ");
                if (joined.Parent.IsExtension && joined.Parent.DataModel.HasExtensionsContainerAttribute)
                {
                    var extensionColumnName = $"{fromTableName}.[{joined.Parent.DataModel.ExtensionsContainerAttributeName}]";
                    var getValueExpression = SQLProvider.AddCastExpression($"JSON_VALUE({extensionColumnName}, '$.{joined.Parent.ColumnName}')", typeof(string),joined.Parent);
                    query.AppendFormat("{0}[{1}] {2} ON [{2}].[{3}] = {4} ",
                        !string.IsNullOrEmpty(joined.DataModel.SchemaName) ? string.Format("[{0}].", joined.DataModel.SchemaName) : string.Empty,
                        joined.DataModel.TableName,
                        joined.TableAlias,
                        GetPrimaryKeyColumnName(joined),
                        getValueExpression);
                }
                else
                {
                    query.AppendFormat("{0}[{1}] {2} ON [{2}].[{3}] = {4}.[{5}] ",
                        !string.IsNullOrEmpty(joined.DataModel.SchemaName) ? string.Format("[{0}].", joined.DataModel.SchemaName) : string.Empty,
                        joined.DataModel.TableName,
                        joined.TableAlias,
                        GetPrimaryKeyColumnName(joined),
                        fromTableName, joined.Parent.ColumnName);
                }
            }

            return query;
        }


        protected override StringBuilder BuildOrderByClause(StringBuilder query)
        {
            if (!Order.IsEmpty)
            {
                if (Paging == Paging.Empty)
                {
                    var order = Order.Prepare(Model);
                    query.AppendFormat("ORDER BY {0} ", NeedUseSubquery() ? order.ToString(SubQueryAlias) : order.ToString());
                }
                else
                {
                    var order = Order.Prepare(Model);
                    query.AppendFormat("ORDER BY {0} ", order.ToString(PagingSubQueryAlias));
                }
            }

            return query;
        }

        protected override StringBuilder StartExternalSelectClauseForPaging(StringBuilder query)
        {
            var topClause = string.Format(CultureInfo.InvariantCulture, "TOP {0}", Paging.Take);
            query.AppendFormat("SELECT {0} * FROM (", topClause);
            return query;
        }
        
        protected override StringBuilder StartExternalSelectClause(StringBuilder query)
        {
            query.Append("SELECT * FROM (");
            return query;
        }

        protected override StringBuilder EndExternalSelectClauseForPaging(StringBuilder query)
        {
            var pageFilter = Filter.And.Greater(Paging.Skip, Constants.PagingColumnName);
            query.AppendFormat(") AS {0} WHERE {1}", PagingSubQueryAlias,
                               pageFilter.ToString((FilterPurpose.Other,PagingSubQueryAlias)));
            return query;
        }

        protected override StringBuilder EndExternalSelectClause(StringBuilder query)
        {
            query.Append($") AS {SubQueryAlias} ");
            return query;
        }

        protected override StringBuilder BuildPagingClause(StringBuilder query)
        {
            query.Append(",");

          

//            foreach (var criteria in Order.Criteries)
//            {
//                Column col = null;
//
//                var plain = Model.GetPlainAttributeByColumn(criteria.Column);
//
//                if (plain != null)
//                    col = new Column(Model.SchemaName, Model.TableName, plain.ColumnName, plain.PropertyName)
//                    {
//                        EntityModel = Model,
//                        Attribute = plain,
//                        Location = AttributeLocation.OrderByPaging
//                    };
//                else
//                {
//                    var joined = Model.GetJoinedAttributeByColumn(criteria.Column);
//                    if (joined != null)
//                        col = new Column(joined.TableAlias, joined.ColumnName,joined.PropertyName){
//                            EntityModel = Model,
//                            Attribute = joined,
//                            Location = AttributeLocation.OrderByPaging
//                        };
//                }
//
//                if (col != null)
//                {
//                    orderForPaging = orderForPaging == null
//                                           ? (criteria.ExpressionOrderType == OrderByExpression.OrderType.ASC
//                                                  ? Order.StartAsc(col)
//                                                  : Order.StartDesc(col))
//                                           : (criteria.ExpressionOrderType == OrderByExpression.OrderType.ASC
//                                                  ? SortingExtension.Asc(orderForPaging, col)
//                                                  : SortingExtension.Desc(orderForPaging, col));
//                }
//                else
//                {
//                    if (orderForPaging == null)
//                        orderForPaging = new Order();
//
//                    
//                    orderForPaging.AddCriteria(OrderByExpression.Expression(criteria.ToString(Model.TableName)));
//                }
//            }
            
            var orderForPaging = Order.Prepare(Model);

            var rowNumberClause = string.Format("row_number() OVER (ORDER BY {0})", orderForPaging.ToString(OrderByLocation.Paging));

            query.AppendFormat("{0} {1} ", rowNumberClause, Constants.PagingColumnName);

            return query;

        }
    }
}
