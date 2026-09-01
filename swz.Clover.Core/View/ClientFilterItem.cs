using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.View
{
    public enum GridFilterTerm
    {
        Like,
        StartsWith,
        EndsWith,
        Eq,
        Gt,
        Lt,
        GtEq,
        LtEq,
        NotEq,
        In,
        Contains
    }

    public static class GridFilterTermExtensions
    {
        public static bool IsLike(this GridFilterTerm term)
        {
            return term == GridFilterTerm.EndsWith || term == GridFilterTerm.StartsWith || term == GridFilterTerm.Like;
        }
    }

    public sealed class ClientFilterItem
    {
        private static Dictionary<string, GridFilterTerm> _mapping = new Dictionary<string, GridFilterTerm>
        {
            {"*like", GridFilterTerm.EndsWith},
            {"=", GridFilterTerm.Eq},
            {">", GridFilterTerm.Gt},
            {">=", GridFilterTerm.GtEq},
            {"like", GridFilterTerm.Like},
            {"*like*", GridFilterTerm.Like},
            {"<", GridFilterTerm.Lt},
            {"<=", GridFilterTerm.LtEq},
            {"!=", GridFilterTerm.NotEq},
            {"like*", GridFilterTerm.StartsWith},
            {"in", GridFilterTerm.In},
            {"contains", GridFilterTerm.Contains}
        };

        private string _term;
        private string _column;

        public string Term
        {
            get => _term;
            set
            {
                ParsedTerm = _mapping[value.ToLower().Trim()];
                _term = value;
            }
        }

        public string Column
        {
            get => _column;
            set
            {
                _column = value;
                Columns = _column.Trim().Split(',').ToList();
            }
        }

        public List<string> Columns { get; set; }
        public object Value { get; set; }
        public GridFilterTerm ParsedTerm { get; private set; }
        public bool IsMulticolumn => Columns.Count > 1;

    }

    public static class ClientFilterExtensions
    {
        public static Filter ToORMFilter(this IEnumerable<ClientFilterItem> clientFilter, EntityModel model)
        {
            var clientFilterItems = clientFilter.ToList();

            if (clientFilterItems.Any())
            {
                var filter = Filter.And;
                foreach (var item in clientFilterItems)
                {

                    if (item.IsMulticolumn)
                    {
                        filter = filter.NestOr();

                        foreach (var column in item.Columns)
                        {
                            filter = AddColumnFilter(column, model, item, filter);
                        }


                        filter = filter.Parent;
                    }
                    else
                    {
                        filter = AddColumnFilter(item.Columns.First(), model, item, filter);
                    }
                }

                return filter;
            }

            return Filter.Empty;
        }

        private static Filter AddColumnFilter(string column, EntityModel model, ClientFilterItem gridFilterItem, Filter filterFromGrid)
        {
            var propertyName = column.Equals("__id", StringComparison.Ordinal) ? model.PrimaryKeyAttributeName : column;

            var propertyValue = gridFilterItem.Value;

            if (!gridFilterItem.ParsedTerm.IsLike() && gridFilterItem.ParsedTerm != GridFilterTerm.In)
            {
                var attribute = model.GetAttributeByName(propertyName);
                if (attribute != null)
                    propertyValue = attribute.Type.ParseToCLRType(gridFilterItem.Value);
            }

            switch (gridFilterItem.ParsedTerm)
            {
                case GridFilterTerm.Like:
                    filterFromGrid = filterFromGrid.LikeRightLeft(propertyValue, propertyName);
                    break;
                case GridFilterTerm.Eq:
                    filterFromGrid = filterFromGrid.Equal(propertyValue, propertyName);
                    break;
                case GridFilterTerm.Gt:
                    filterFromGrid = filterFromGrid.Greater(propertyValue, propertyName);
                    break;
                case GridFilterTerm.Lt:
                    filterFromGrid = filterFromGrid.Less(propertyValue, propertyName);
                    break;
                case GridFilterTerm.GtEq:
                    filterFromGrid = filterFromGrid.GreaterOrEqual(propertyValue, propertyName);
                    break;
                case GridFilterTerm.LtEq:
                    filterFromGrid = filterFromGrid.LessOrEqual(propertyValue, propertyName);
                    break;
                case GridFilterTerm.EndsWith:
                    filterFromGrid = filterFromGrid.LikeLeft(propertyValue, propertyName);
                    break;
                case GridFilterTerm.StartsWith:
                    filterFromGrid = filterFromGrid.LikeRight(propertyValue, propertyName);
                    break;
                case GridFilterTerm.NotEq:
                    filterFromGrid = filterFromGrid.NotEqual(propertyValue, propertyName);
                    break;
                case GridFilterTerm.Contains:
                    filterFromGrid = filterFromGrid.Contains(propertyValue, propertyName);
                    break;
                case GridFilterTerm.In:
                    if (propertyValue is JArray)
                    {
                        var att = model.GetAttributeByName(propertyName);
                        var values = ((JArray)propertyValue).Select(c => c.ToObject(att.Type.CLRType)).ToList();
                        filterFromGrid = filterFromGrid.In(values, propertyName);
                    }
                    else
                    {
                        throw new Exception(string.Format("Unsupported value: {0}, type: {0}.", propertyValue, propertyValue.GetType()));
                    }
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
            //{([NewValue] like ('%AnsVal%'))}
            return filterFromGrid;
        }
    }
}