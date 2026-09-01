using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public class FilterPredicateIn : BaseExpression
    {
        private bool Equals(FilterPredicateIn other)
        {
            return !IsCustomExpression && PropertyName.Equals(other.PropertyName, StringComparison.Ordinal) && Invert.Equals(other.Invert) && Values.SequenceEqual(other.Values);
        }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((FilterPredicateIn) obj);
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

        protected List<string> Parameters;
        protected List<object> Values;
        protected List<string> FormattedValues;
        protected bool Invert { get; set; }

        protected FilterPredicateIn(int valuesCount)
        {
            Values = new List<object>(valuesCount);
        }

        public override string ToString()
        {
            return ToString(FilterPurpose.SelectValues, null, Parameters);
        }

        private string ToString(FilterPurpose purpose, string alias, List<string> values, string parameterSymbol = null)
        {
            if (FormattedValues.Count < 1)
            {
                if (!Invert)
                    return "1=0";
                return string.Empty;
            }

            var builder = new StringBuilder();

            var clauseBeginning = !Invert ? CloverRuntime.DbProvider.GetBeginningOfInClause : CloverRuntime.DbProvider.GetBeginningOfNotInClause;

            string attributeToString;
            if (HasAttribute)
            {
                attributeToString = CloverRuntime.DbProvider.AttributeToString(Attribute, (purpose.ConvertToAttributeLocation(), GetTableAlias(alias)));
            }
            else
            {
                attributeToString = CloverRuntime.DbProvider.PropertyToString(PropertyName, (purpose.ConvertToAttributeLocation(), alias));
            }

            builder.AppendFormat("{0} {1}", attributeToString, clauseBeginning);

            var isFirst = true;
            foreach (string value in values)
            {
                if (!isFirst)
                    builder.Append(",");
                isFirst = false;
                if (string.IsNullOrEmpty(parameterSymbol))
                    builder.Append(value);
                else
                    builder.AppendFormat("{0}{1}", parameterSymbol, value);
            }

            builder.Append(")");

            return builder.ToString();
        }

        public string ToString((FilterPurpose purpose, string alias) options)
        {
            return ToString(options.purpose, options.alias, Parameters);
        }

        public string ToStringAsParameter()
        {
            return ToString(FilterPurpose.SelectValues, null, Parameters, CloverRuntime.DbProvider.ParameterPrefix);
        }

        public string ToStringAsParameter((FilterPurpose purpose, string alias) options)
        {
            return ToString(options.purpose, options.alias, Parameters, CloverRuntime.DbProvider.ParameterPrefix);
        }

        public Dictionary<string, (AttributeModel attribute, string propertyName, object value)> GetParameters()
        {
            var result = new Dictionary<string, (AttributeModel attribute, string propertyName, object value)>();
            if (!CloverRuntime.DbProvider.UseArrayParameterForIn)
            {
                for (int i = 0; i < Parameters.Count; i++)
                {
                    var value = Parameters[i];
                    result.Add(value, (Attribute, PropertyName, Values[i]));
                }
            }
            else
            {
                var value = Parameters[0];
                result.Add(value, (Attribute, PropertyName, Values));
            }

            return result;
        }

        public FilterPredicateIn CloneAndOverrideAttribute(AttributeModel attribute)
        {
            return new FilterPredicateIn(Values.Count)
            {
                FormattedValues = FormattedValues,
                Values = Values,
                Invert = Invert,
                Parameters = Parameters,
                Attribute = attribute
            };
        }

        public override BaseExpression Clone()
        {

            if (Attribute != null)
                return new FilterPredicateIn(Values.Count)
                {
                    FormattedValues = FormattedValues,
                    Values = Values,
                    Invert = Invert,
                    Parameters = Parameters,
                    Attribute = Attribute
                };
            if (!string.IsNullOrEmpty(PropertyName))
                return new FilterPredicateIn(Values.Count)
                {
                    FormattedValues = FormattedValues,
                    Values = Values,
                    Invert = Invert,
                    Parameters = Parameters,
                    PropertyName = PropertyName
                };

            return new FilterPredicateIn(Values.Count)
            {
                FormattedValues = FormattedValues,
                Values = Values,
                Invert = Invert,
                Parameters = Parameters,
                CustomExpression = CustomExpression
            };
        }
    }

    public class FilterPredicateIn<T> : FilterPredicateIn
    {
        public FilterPredicateIn(AttributeModel attribute, List<T> values, bool invert) : base(values.Count)
        {
            Attribute = attribute;
            Construct(values, invert);
        }

        public FilterPredicateIn(string propertyName, List<T> values, bool invert) : base(values.Count)
        {
            PropertyName = propertyName;
            Construct(values, invert);
        }

        private void Construct(List<T> values, bool invert)
        {
            Parameters = new List<string>(values.Count);
            FormattedValues = new List<string>(values.Count);
            Invert = invert;

            var id = CloverRuntime.DbProvider.GenerateGuid().ToString("N");

            for (int i = 0; i < values.Count; i++)
            {
                var value = values[i];
                if (!CloverRuntime.DbProvider.UseArrayParameterForIn)
                {
                    var parameterName = $"in_{id}_{i}";
                    Parameters.Add(parameterName);
                }

                Values.Add(value);
                FormattedValues.Add(CloverRuntime.DbProvider.GetFilterCriteriaBuilder<T>().FormatWithQuatation(value));
            }

            if (CloverRuntime.DbProvider.UseArrayParameterForIn)
            {
                var parameterName = $"in_{id}";
                Parameters.Add(parameterName);
            }
        }
    }
}
