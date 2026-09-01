using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core
{
    public enum OrderByLocation
    {
        /// <summary>
        /// For simple sql queries without subqueries
        /// </summary>
        Common,

        /// <summary>
        /// In OVER expression
        /// </summary>
        Paging,

        /// <summary>
        /// Outside of subquery
        /// </summary>
        OutsideOfSubquery
    }
    
    [DebuggerDisplay("ORDER BY {" + nameof(ToString) + "()}")]
    public sealed class Order
    {
        readonly SortedList<int, OrderByExpression> _sets = new SortedList<int, OrderByExpression>();

        public IEnumerable<OrderByExpression> Criteries
        {
            get
            {
                return _sets.Select(set => set.Value);
            }
        }

        public bool IsEmpty => this == Empty || !_sets.Any();

        public void AddCriteria(OrderByExpression expression)
        {
            if (this == Empty)
            {
                throw new Exception("Cannot add criteria to EmptyCriteriaSet");
            }
            _sets.Add(_sets.Count, expression);
        }

        public override string ToString()
        {
            return ToString((OrderByLocation.Common,null));
        }

        public string ToString(string tableAlias)
        {
            return ToString((OrderByLocation.OutsideOfSubquery,tableAlias));
        }

        public string ToString(OrderByLocation location)
        {
            return ToString((location,null));
        }
        
        public string ToString((OrderByLocation location, string tableAlias) location)
        {
            if (this == Empty)
                return string.Empty;

            var clause = new StringBuilder();
            for (int i = 0; i < _sets.Count; i++)
            {
                clause.AppendFormat("{0}", _sets[i].ToString(location));
                if (i < _sets.Count - 1)
                    clause.Append(",");
            }

            return clause.ToString();
        }

        public Order PrepareSimpleOrderBy(EntityModel model)
        {
            var res = new Order();
            foreach (var s in _sets)
            {
                var order = s.Value;

                if (s.Value.IsCustomExpression || s.Value.HasAttribute)
                {
                    res._sets.Add(res._sets.Count,s.Value);
                    continue;
                }
              
                var attribute = model.GetAttributeByName(order.PropertyName);
                if (attribute == null)
                    throw new DynamicEntitiesAttributeNotFoundException($"Attribute '{order.PropertyName}' is not found in '{model.Name}' model");

                var no = order.CloneAndOverrideAttribute(attribute);

                res._sets.Add(res._sets.Count, no);
            }

            return res;
        }

        
        
        public bool ContainsExtension(EntityModel model)
        {
            foreach (var s in _sets)
            {
                var attribute = s.Value.Attribute ?? model.GetAttributeByName(s.Value.PropertyName);

                if (attribute.IsExtension)
                    return true;
            }

            return false;

        }

        public static readonly Order Empty = new Order();

        public static Order StartAsc(AttributeModel attribute)
        {
            return new Order().Asc(attribute);
        }

        public static Order StartDesc(AttributeModel attribute)
        {
            return new Order().Desc(attribute);
        }

        public static Order StartAsc(string property)
        {
            return new Order().Asc(property);
        }

        public static Order StartDesc(string property)
        {
            return new Order().Desc(property);
        }
        
     
    }

    public static class SortingExtension
    {
        // ReSharper disable once MemberCanBePrivate.Global
        public static bool IsNullOrEmpty(this Order order)
        {
            return order == null || order.IsEmpty;
        }

        public static Order Asc(this Order order, AttributeModel attribute)
        {
            if (order == null || order == Order.Empty)
            {
                order = new Order();
            }
            order.AddCriteria(OrderByExpression.Asc(attribute));
            return order;
        }

        public static Order Desc(this Order order, AttributeModel attribute)
        {
            if (order == null || order == Order.Empty)
            {
                order = new Order();
            }
            order.AddCriteria(OrderByExpression.Desc(attribute));
            return order;
        }

       
        public static Order Asc(this Order order, string property)
        {
            if (order == null || order == Order.Empty)
            {
                order = new Order();
            }

            order.AddCriteria(OrderByExpression.Asc(property));
            return order;
        }

        public static Order Desc(this Order order, string property)
        {
            if (order == null || order == Order.Empty)
            {
                order = new Order();
            }

            order.AddCriteria(OrderByExpression.Desc(property));
            return order;
        }
        
        public static Order Prepare(this Order order, EntityModel model)
        {
            return order.PrepareSimpleOrderBy(model);
        }

        public static AttributeLocation ConvertToAttributeLocation(this OrderByLocation location)
        {
            switch (location)
            {
                case OrderByLocation.Common:
                    return AttributeLocation.OrderBy;
                case OrderByLocation.Paging:
                    return AttributeLocation.OrderByPaging;
                case OrderByLocation.OutsideOfSubquery:
                    return AttributeLocation.OrderByOutsideSubquery;
                default:
                    return AttributeLocation.OrderBy;
            }
        }

    }
 }
