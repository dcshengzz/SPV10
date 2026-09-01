using System;
using System.Diagnostics;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    [DebuggerDisplay("{" + nameof(ToString) + "()}")]
    public sealed class OrderByExpression : BaseExpression
    {
        public enum OrderType
        {
            ASC, DESC
        }

        public OrderType ExpressionOrderType { get; set; }

        
        private OrderByExpression()
        {
        }

        public static OrderByExpression Asc(AttributeModel attribute)
        {
            return new OrderByExpression {Attribute = attribute, ExpressionOrderType = OrderType.ASC };
        }
        
        public static OrderByExpression Asc(string property)
        {
            return new OrderByExpression {PropertyName = property, ExpressionOrderType = OrderType.ASC };
        }

        public static OrderByExpression Desc(AttributeModel attribute)
        {
            return new OrderByExpression {Attribute = attribute, ExpressionOrderType = OrderType.DESC };
        }

        public static OrderByExpression Desc(string property)
        {
            return new OrderByExpression {PropertyName = property, ExpressionOrderType = OrderType.DESC };
        }
        
        public static OrderByExpression Expression(string custom)
        {
            return new OrderByExpression { CustomExpression = custom };
        }

        public override string ToString()
        {
            return CloverRuntime.DbProvider.OrderByToString(this, (OrderByLocation.Common, null));
        }
        
       

        internal string ToString((OrderByLocation location, string tableAlias) location)
        {
            return CloverRuntime.DbProvider.OrderByToString(this, location);
        }
        
        public OrderByExpression CloneAndOverrideAttribute(AttributeModel attribute)
        {
            return new OrderByExpression()
            {
                ExpressionOrderType = ExpressionOrderType,
                Attribute = attribute
            };
        }

        public override BaseExpression Clone()
        {
            if (Attribute != null)
                return new OrderByExpression()
                {
                    Attribute = Attribute,
                    ExpressionOrderType = ExpressionOrderType
                };
            if (!string.IsNullOrEmpty(PropertyName))
                return new OrderByExpression()
                {
                    PropertyName = PropertyName,
                    ExpressionOrderType = ExpressionOrderType
                };
            
            return new OrderByExpression()
            {
                CustomExpression = CustomExpression,
                Attribute = Attribute
            };
        }
    }
}
