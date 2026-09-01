using System;
using swz.Clover.Core.Model;
#pragma warning disable 1591

namespace swz.Clover.Core.ORM
{
    
    public sealed class FilterPredicateWithValue : BaseExpression
    {
        private bool Equals(FilterPredicateWithValue other)
        {
            return !IsCustomExpression && Predicate == other.Predicate
                                       && ParameterPredicate == other.ParameterPredicate && Equals(Value, other.Value) &&
                                       PropertyName.Equals(other.PropertyName, StringComparison.Ordinal);
        }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((FilterPredicateWithValue) obj);
        }

        public override int GetHashCode()
        {
            //20231214 - We will borrow the hashcodes from the PropertyName or CustomExpression to use for this object. 
            //The hashcode for two objects where Equals is true has to be the same (but different objects don't have
            //to have different hashcodes). (Use-cases for this class see it rarely used in Hashtables, indeed until today
            //it didn't correctly implement GetHashCode() so performance considerations of the hashcode used are likely a moot
            //point and we can focus on correctness)
            return PropertyName?.GetHashCode() ?? CustomExpression?.GetHashCode() ?? 0;
        }

        public object Value { get; private set; }

        public IFilterPredicate Predicate { get; private set; }

        public IFilterPredicate ParameterPredicate { get; private set; }

        public override string ToString()
        {
            if (Attribute != null)
                return Predicate.Build(Value, Attribute, FilterPurpose.SelectValues, GetTableAlias());

            return Predicate.Build(Value, PropertyName, FilterPurpose.SelectValues, string.Empty);
        }

        public string ToString((FilterPurpose purpose, string alias) options)
        {
            if (Attribute != null)
                return Predicate.Build(Value, Attribute, options.purpose, GetTableAlias(options.alias));
            return Predicate.Build(Value, PropertyName, options.purpose, options.alias);
        }

        public string ToStringAsParameter(string parameterName)
        {
           if (Attribute != null)
                return ParameterPredicate.Build(new Parameter(parameterName), Attribute, FilterPurpose.SelectValues, GetTableAlias());
            return ParameterPredicate.Build(new Parameter(parameterName), PropertyName, FilterPurpose.SelectValues, string.Empty);
            
        }

        public string ToStringAsParameter(string parameterName,(FilterPurpose purpose, string alias) options)
        {
            if (Attribute != null)
                return ParameterPredicate.Build(new Parameter(parameterName), Attribute, options.purpose, GetTableAlias(options.alias));

            return ParameterPredicate.Build(new Parameter(parameterName), PropertyName, options.purpose, options.alias);
        }

        public static FilterPredicateWithValue Create(IFilterPredicate predicate, IFilterPredicate parameterPredicate, object value, AttributeModel attribute)
        {
            return new FilterPredicateWithValue {Predicate = predicate,ParameterPredicate = parameterPredicate,Value = value,Attribute = attribute};
        }
        
        public static FilterPredicateWithValue Create(IFilterPredicate predicate, IFilterPredicate parameterPredicate, object value, string property)
        {
            return new FilterPredicateWithValue {Predicate = predicate,ParameterPredicate = parameterPredicate,Value = value,PropertyName = property};
        }

        public FilterPredicateWithValue CloneAndOverrideAttribute(AttributeModel attribute)
        {
            var res = new FilterPredicateWithValue
            {
                Attribute = attribute,
                Value = Value,
                ParameterPredicate = ParameterPredicate,
                Predicate = Predicate
            };
            return res;
        }

        public override BaseExpression Clone()
        {
            if (Attribute != null)
                return Create(Predicate, ParameterPredicate, Value, Attribute);
            if (!string.IsNullOrEmpty(PropertyName))
                return Create(Predicate, ParameterPredicate, Value, PropertyName);

            return new FilterPredicateWithValue()
            {
                CustomExpression = CustomExpression,
                ParameterPredicate = ParameterPredicate,
                Predicate = Predicate,
                Value = Value
            };

        }
    }
}