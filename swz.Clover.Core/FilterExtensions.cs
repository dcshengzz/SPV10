using System.Collections.Generic;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core
{

    public static class FilterExtension
    {
        public static Filter LikeRight<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeRight, FilterPredicate<Parameter>.LikeRight, value, attribute);
            return filter;
        }

        public static Filter LikeLeft<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeLeft, FilterPredicate<Parameter>.LikeLeft, value, attribute);
            return filter;
        }

        public static Filter LikeRightLeft<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeRightLeft, FilterPredicate<Parameter>.LikeRightLeft, value, attribute);
            return filter;
        }

        public static Filter NotLikeRight<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeRight, FilterPredicate<Parameter>.NotLikeRight, value, attribute);
            return filter;
        }

        public static Filter NotLikeLeft<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeLeft, FilterPredicate<Parameter>.NotLikeLeft, value, attribute);
            return filter;
        }

        public static Filter NotLikeRightLeft<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeRightLeft, FilterPredicate<Parameter>.NotLikeRightLeft, value, attribute);
            return filter;
        }

        public static Filter Equal<T>(this Filter filter, T value, AttributeModel attribute)
        {
            if (value != null)
                filter.AddCriteria(FilterPredicate<T>.Equal, FilterPredicate<Parameter>.Equal, value, attribute);
            else
                filter.Equal(Null.Value, attribute);

            return filter;
        }

        public static Filter NotEqual<T>(this Filter filter, T value, AttributeModel attribute)
        {
            if (value != null)
                filter.AddCriteria(FilterPredicate<T>.NotEqual, FilterPredicate<Parameter>.NotEqual, value, attribute);
            else
                filter.NotEqual(Null.Value, attribute);

            return filter;
        }

        public static Filter Greater<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.Greater, FilterPredicate<Parameter>.Greater, value, attribute);
            return filter;
        }

        public static Filter Less<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.Less, FilterPredicate<Parameter>.Less, value, attribute);
            return filter;
        }

        public static Filter GreaterOrEqual<T>(this Filter filter, T value, AttributeModel attribute)
        {
            filter.AddCriteria(FilterPredicate<T>.GreaterOrEqual, FilterPredicate<Parameter>.GreaterOrEqual, value, attribute);
            return filter;
        }

        public static Filter LessOrEqual<T>(this Filter filter, T value, AttributeModel attributeModel)
        {
            filter.AddCriteria(FilterPredicate<T>.LessOrEqual, FilterPredicate<Parameter>.LessOrEqual, value, attributeModel);
            return filter;
        }

        public static Filter LikeRight<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeRight, FilterPredicate<Parameter>.LikeRight, value, property);
            return filter;
        }

        public static Filter LikeLeft<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeLeft, FilterPredicate<Parameter>.LikeLeft, value, property);
            return filter;
        }

        public static Filter LikeRightLeft<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.LikeRightLeft, FilterPredicate<Parameter>.LikeRightLeft, value, property);
            return filter;
        }

        public static Filter NotLikeRight<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeRight, FilterPredicate<Parameter>.NotLikeRight, value, property);
            return filter;
        }

        public static Filter NotLikeLeft<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeLeft, FilterPredicate<Parameter>.NotLikeLeft, value, property);
            return filter;
        }

        public static Filter NotLikeRightLeft<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.NotLikeRightLeft, FilterPredicate<Parameter>.NotLikeRightLeft, value, property);
            return filter;
        }

        public static Filter Equal<T>(this Filter filter, T value, string property)
        {
            if (value != null)
                filter.AddCriteria(FilterPredicate<T>.Equal, FilterPredicate<Parameter>.Equal, value, property);
            else
                filter.Equal(Null.Value, property);

            return filter;
        }

        public static Filter NotEqual<T>(this Filter filter, T value, string property)
        {
            if (value != null)
                filter.AddCriteria(FilterPredicate<T>.NotEqual, FilterPredicate<Parameter>.NotEqual, value, property);
            else
                filter.NotEqual(Null.Value, property);

            return filter;
        }

        public static Filter Greater<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.Greater, FilterPredicate<Parameter>.Greater, value, property);
            return filter;
        }

        public static Filter Less<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.Less, FilterPredicate<Parameter>.Less, value, property);
            return filter;
        }

        public static Filter GreaterOrEqual<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.GreaterOrEqual, FilterPredicate<Parameter>.GreaterOrEqual, value, property);
            return filter;
        }

        public static Filter LessOrEqual<T>(this Filter filter, T value, string property)
        {
            filter.AddCriteria(FilterPredicate<T>.LessOrEqual, FilterPredicate<Parameter>.LessOrEqual, value, property);
            return filter;
        }

        public static Filter Custom(this Filter filter, string criteria, Dictionary<string, object> parameters)
        {
            filter.AddCustom(criteria, parameters);
            return filter;
        }

        public static Filter Custom(this Filter filter, string criteria)
        {
            filter.AddCustom(criteria, new Dictionary<string, object>());
            return filter;
        }

        public static Filter In<T>(this Filter filter, List<T> values, AttributeModel attribute)
        {
            filter.AddIn(attribute, values, false);
            return filter;
        }

        public static Filter NotIn<T>(this Filter filter, List<T> values, AttributeModel attribute)
        {
            filter.AddIn(attribute, values, true);
            return filter;
        }

        public static Filter In<T>(this Filter filter, List<T> values, string property)
        {
            filter.AddIn(property, values, false);
            return filter;
        }

        public static Filter Contains<T>(this Filter filter, T value, string property)
        {
            filter.AddContains(property, value, false);
            return filter;
        }

        public static Filter NotIn<T>(this Filter filter, List<T> values, string property)
        {
            filter.AddIn(property, values, true);
            return filter;
        }


        public static Filter NestOr(this Filter filter)
        {
            if (filter == Filter.Empty)
                return filter;
            return filter.CreateNestedFilter(filter, Filter.CriteriaConcatenationType.Or);
        }

        public static Filter NestAnd(this Filter filter)
        {
            if (filter == Filter.Empty)
                return filter;
            return filter.CreateNestedFilter(filter, Filter.CriteriaConcatenationType.And);
        }

        public static Filter Parent(this Filter filter)
        {
            return filter.Parent;
        }

        public static Filter Merge(this Filter filter, Filter merged)
        {
            if (filter == Filter.Empty)
                return merged;
            if (merged == Filter.Empty)
                return filter;

            var mergedRoot = merged.FindRoot().Clone();
            filter.AddCriteria(mergedRoot);
            mergedRoot.Parent = filter;
            return filter;
        }

        public static Filter Prepare(this Filter filter, EntityModel model)
        {
            return filter.PrepareSimpleFilter(model);
        }

    }
}
