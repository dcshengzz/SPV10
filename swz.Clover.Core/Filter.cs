using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core
{
    public enum FilterPurpose
    {
        SelectValues,
        Other,
        OutsideOfSubquery //POSTGERES
    }

    public static class FilterPurposeExtension
    {
        public static AttributeLocation ConvertToAttributeLocation(this FilterPurpose purpose)
        {
            switch (purpose)
            {
                case FilterPurpose.SelectValues:
                    return AttributeLocation.SelectValuesFilter;
                case FilterPurpose.Other:
                    return AttributeLocation.OtherFilter;
                case FilterPurpose.OutsideOfSubquery:
                    return AttributeLocation.FilterOutsideSubquery;
                default:
                    return AttributeLocation.SelectValuesFilter;
            }
        }
    }

    public sealed class Filter
    {
        public bool IsOr => _type == CriteriaConcatenationType.Or;

        public bool IsAnd => _type == CriteriaConcatenationType.And;

        public bool IsEmpty => _type == CriteriaConcatenationType.Empty || !_criteries.Any();

        private string _filterParametreName;

        private string FilterParameterName => _parent == null ? _filterParametreName : $"{_parent.FilterParameterName}_{_filterParametreName}";

        internal enum CriteriaConcatenationType
        {
            Or,
            And,
            Empty
        }

        private readonly CriteriaConcatenationType _type;

        private Filter _parent;

        private readonly SortedList<int, object> _criteries = new SortedList<int, object>();

        private Filter(CriteriaConcatenationType type)
        {
            _type = type;
        }

        public static Filter Or => new Filter(CriteriaConcatenationType.Or) { _filterParametreName = "filter" };

        public static Filter And => new Filter(CriteriaConcatenationType.And) { _filterParametreName = "filter" };

        public static Filter Empty { get; } = new Filter(CriteriaConcatenationType.Empty);


        internal void AddCriteria<T>(FilterPredicate<T> filterPredicate, FilterPredicate<Parameter> parameterPredicate, T value, string property)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count, FilterPredicateWithValue.Create(filterPredicate, parameterPredicate, value, property));
        }

        internal void AddCriteria<T>(FilterPredicate<T> filterPredicate, FilterPredicate<Parameter> parameterPredicate, T value, AttributeModel attribute)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count, FilterPredicateWithValue.Create(filterPredicate, parameterPredicate, value, attribute));
        }

        internal void AddCustom(string criteria, Dictionary<string, object> parameters)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count,
                           new FilterPredicateCustom { Criteria = criteria, Parameters = parameters });
        }

        internal void AddIn<T>(AttributeModel attribute, List<T> values, bool invert)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count,
                           new FilterPredicateIn<T>(attribute, values, invert));
        }

        internal void AddIn<T>(string property, List<T> values, bool invert)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count,
                new FilterPredicateIn<T>(property, values, invert));
        }

        internal void AddContains<T>(string property, T value, bool invert)
        {
            if (_type == CriteriaConcatenationType.Empty)
                return;
            _criteries.Add(_criteries.Count,
                new FilterPredicateContains<T>(property, value, invert));
        }

        internal Filter Parent
        {
            get
            {
                if (_parent == null)
                    throw new InvalidOperationException("Parent filter is null");
                return _parent;
            }
            set
            {
                if (_parent != null)
                    throw new InvalidOperationException("Parent filter must be null");
                _parent = value;
            }
        }

        internal void AddCriteria(Filter filter)
        {
            _criteries.Add(_criteries.Count, filter);
        }

        public Filter FindRoot()
        {
            if (_parent == null)
                return this;
            return Parent.FindRoot();
        }

        internal Filter CreateNestedFilter(Filter filter, CriteriaConcatenationType type)
        {
            var count = _criteries.Count;
            var newQueryCriteriaSet = new Filter(type)
            {
                _parent = filter,
                _filterParametreName = $"n{count}"
            };
            _criteries.Add(count, newQueryCriteriaSet);
            return newQueryCriteriaSet;
        }

        public override string ToString()
        {
            var parametersCount = 0;
            return ToString(true, false, (FilterPurpose.SelectValues, null), ref parametersCount);
        }


        public string ToStringAsParameters((FilterPurpose purpose, string alias) options)
        {
            var parametersCount = 0;
            return ToString(true, true, options, ref parametersCount);
        }

        public string ToStringAsParameters()
        {
            var parametersCount = 0;
            return ToString(true, true, (FilterPurpose.SelectValues, null), ref parametersCount);
        }


        public string ToString((FilterPurpose purpose, string alias) options)
        {
            var parametersCount = 0;
            return ToString(true, false, options, ref parametersCount);
        }


        private string ToString(bool searchParent, bool useParameters, (FilterPurpose purpose, string alias) options, ref int parametersCount)
        {
            if (_parent != null && searchParent)
            {
                return _parent.ToString(true, useParameters, options, ref parametersCount);
            }

            if (IsEmpty)
                return string.Empty;

            var builder = new StringBuilder();
            if (_parent != null)
                builder.Append("(");

            for (int i = 0; i < _criteries.Count; i++)
            {
                var value = _criteries[i];

                if (value is Filter filter)
                    builder.Append(filter.ToString(false, useParameters, options, ref parametersCount));
                else
                {
                    if (value is FilterPredicateWithValue qcp)
                    {
                        if (useParameters && !(qcp.Value is Null))
                        {

                            var parameterName = GetParameterName(parametersCount);
                            parametersCount++;
                            builder.Append(qcp.ToStringAsParameter(parameterName, options));
                        }
                        else
                            builder.Append(qcp.ToString(options));
                    }
                    else
                    {
                        if (value is FilterPredicateCustom custom)
                        {
                            builder.Append(custom.Criteria);
                        }
                        else
                        {
                            if (value is FilterPredicateIn inc)
                            {
                                builder.Append(useParameters ? inc.ToStringAsParameter(options) : inc.ToString(options));
                            }
                            else if (value is FilterPredicateContains contains)
                            {
                                builder.Append(useParameters ? contains.ToStringAsParameter(options) : contains.ToString(options));
                            }
                        }
                    }
                }

                if (i != _criteries.Count - 1 &&
                    (!(_criteries[i + 1] is Filter) || (_criteries[i + 1] != null &&
                    !((Filter)_criteries[i + 1]).IsEmpty)))
                    builder.Append(_type == CriteriaConcatenationType.Or ? " OR " : " AND ");
            }

            if (_parent != null)
                builder.Append(")");

            return builder.ToString();
        }

        private string GetParameterName(int i)
        {
            return string.Format("{0}_{1}", FilterParameterName, i);
        }


        public Dictionary<string, (AttributeModel attribute, string propertyName, object value)> GetParametersWithValues()
        {
            if (_parent != null)
            {
                return _parent.GetParametersWithValues();
            }

            var parameters = new Dictionary<string, (AttributeModel attribute, string propertyName, object value)>();

            int filterParametersCount = 0;

            GetParametersWithValues(parameters, ref filterParametersCount);

            return parameters;
        }

        private void GetParametersWithValues(Dictionary<string, (AttributeModel attribute, string propertyName, object value)> parameters, ref int filterParametersCount)
        {
            if (IsEmpty)
                return;

            foreach (var t in _criteries)
            {
                if (t.Value is Filter filter)
                {
                    filter.GetParametersWithValues(parameters, ref filterParametersCount);
                }
                else
                {
                    if (t.Value is FilterPredicateWithValue qcp && !(qcp.Value is Null))
                    {
                        parameters.Add(GetParameterName(filterParametersCount), (qcp.Attribute, qcp.PropertyName, qcp.Value));
                        filterParametersCount++;

                    }
                    else if (t.Value is FilterPredicateCustom custom)
                    {
                        foreach (var parameter in custom.Parameters)
                            parameters.Add(parameter.Key, (null, parameter.Key, value: parameter.Value));

                    }
                    else if (t.Value is FilterPredicateIn inc)
                    {
                        var inParameters = inc.GetParameters();
                        foreach (var parameter in inParameters)
                            parameters.Add(parameter.Key, parameter.Value);
                    }
                    else if (t.Value is FilterPredicateContains contains)
                    {
                        var containsParameters = contains.GetParameters();
                        foreach (var parameter in containsParameters)
                            parameters.Add(parameter.Key, parameter.Value);
                    }
                }
            }
        }

        public Filter PrepareSimpleFilter(EntityModel model)
        {
            if (_parent != null)
            {
                return _parent.PrepareSimpleFilter(model);
            }

            return ReplaceAllPropertiesByColumnsPrivate(model);
        }

        private Filter ReplaceAllPropertiesByColumnsPrivate(EntityModel model, Filter parent = null)
        {
            var res = new Filter(_type) { _filterParametreName = _filterParametreName, _parent = parent };
            foreach (var t in _criteries)
            {
                if (t.Value is Filter filter)
                {
                    var repl = filter.ReplaceAllPropertiesByColumnsPrivate(model, res);
                    res._criteries.Add(res._criteries.Count, repl);
                }
                else
                {

                    if (t.Value is FilterPredicateWithValue pwv)
                    {
                        if (pwv.IsCustomExpression || pwv.HasAttribute)
                        {
                            res._criteries.Add(res._criteries.Count, pwv);
                        }
                        else
                        {
                            var attribute = model.GetAttributeByName(pwv.PropertyName);
                            if (attribute == null)
                                throw new DynamicEntitiesAttributeNotFoundException($"Attribute '{pwv.PropertyName}' is not found in '{model.Name}' model");
                            var newpwv = pwv.CloneAndOverrideAttribute(attribute);
                            res._criteries.Add(res._criteries.Count, newpwv);
                        }
                    }
                    else if (t.Value is FilterPredicateIn incriteria)
                    {

                        if (incriteria.IsCustomExpression || incriteria.HasAttribute)
                        {
                            res._criteries.Add(res._criteries.Count, incriteria);
                        }
                        else
                        {
                            var attribute = model.GetAttributeByName(incriteria.PropertyName);
                            if (attribute == null)
                                throw new DynamicEntitiesAttributeNotFoundException($"Attribute '{incriteria.PropertyName}' is not found in '{model.Name}' model");
                            var newin = incriteria.CloneAndOverrideAttribute(attribute);
                            res._criteries.Add(res._criteries.Count, newin);
                        }
                    }
                    else if (t.Value is FilterPredicateCustom custom)
                    {
                        res._criteries.Add(res._criteries.Count, custom);
                    }
                    else if (t.Value is FilterPredicateContains contains)
                    {
                        if (contains.IsCustomExpression || contains.HasAttribute)
                        {
                            res._criteries.Add(res._criteries.Count, contains);
                        }
                        else
                        {
                            var attribute = model.GetAttributeByName(contains.PropertyName);
                            if (attribute == null)
                                throw new DynamicEntitiesAttributeNotFoundException($"Attribute '{contains.PropertyName}' is not found in '{model.Name}' model");
                            var newin = contains.CloneAndOverrideAttribute(attribute);
                            res._criteries.Add(res._criteries.Count, newin);
                        }
                    }
                    else
                    {
                        throw new DynamicEntitiesException($"Unknown filter part {t.Value.GetType()}");
                    }


                }
            }

            return res;
        }


        public bool IsInFilter(string property)
        {
            var p = FindRoot();

            return IsInFilter(p, property);
        }

        private bool IsInFilter(Filter criteria, string property)
        {
            foreach (var c in criteria._criteries)
            {
                if (c.Value is FilterPredicateWithValue valCr)
                {
                    if (property.Equals(valCr.PropertyName, StringComparison.Ordinal))
                        return true;

                    continue;
                }

                var inCr = c.Value as FilterPredicateIn;

                if (inCr != null)
                {
                    if (property.Equals(inCr.PropertyName, StringComparison.Ordinal))
                        return true;

                    continue;
                }

                var sCr = c.Value as Filter;

                if (sCr != null)
                {
                    var res = IsInFilter(sCr, property);
                    if (res)
                        return true;
                }
            }

            return false;
        }

        #region Replace Criteries


        public void Replace(object oldValue, object newValue)
        {
            Replace(new List<object> { oldValue }, newValue);
        }

        public void Replace(List<object> oldValues, object newValue)
        {
            var p = FindRoot();

            Replace(p, oldValues, newValue);
        }

        private bool Replace(Filter filter, List<object> oldValues, object newValue)
        {
            var toRemove = new List<int>();
            var allFound = true;
            foreach (var oldValue in oldValues)
            {
                object value = oldValue;
                var oldValuesInFilter = filter._criteries.Where(c => value.Equals(c.Value)).ToList();

                if (!oldValuesInFilter.Any())
                {
                    allFound = false;
                    break;
                }
                else
                {
                    toRemove.AddRange(oldValuesInFilter.Select(oldValueInFilter => oldValueInFilter.Key));
                }
            }

            if (allFound)
            {
                toRemove.ForEach(tr => filter._criteries.Remove(tr));
                var firstId = toRemove.First();
                filter._criteries[firstId] = newValue;
                return true;
            }

            foreach (var criteria in filter._criteries)
            {
                var fcs = criteria.Value as Filter;

                if (fcs != null)
                {
                    var r = Replace(fcs, oldValues, newValue);
                    if (r)
                        return true;
                }
            }

            return false;
        }

        #endregion


        public bool ContainsExtension(EntityModel model)
        {
            if (_parent != null)
                return _parent.ContainsExtension(model);

            return ContainsExtensionIntenal(model);
        }

        private bool ContainsExtensionIntenal(EntityModel model)
        {
            foreach (var t in _criteries)
            {
                if (t.Value is Filter filter)
                {
                    if (filter.ContainsExtensionIntenal(model))
                        return true;
                }
                else
                {
                    if (t.Value is BaseExpression expression)
                    {
                        if (expression.HasAttribute && expression.Attribute.IsExtension)
                            return true;

                        if (expression.IsCustomExpression)
                            continue;

                        if (!expression.HasAttribute)
                        {
                            var attribute = model.GetAttributeByName(expression.PropertyName);

                            if (attribute == null)
                                throw new DynamicEntitiesAttributeNotFoundException($"Attribute '{expression.PropertyName}' is not found in '{model.Name}' model");

                            if (attribute.IsExtension)
                                return true;
                        }
                    }
                }
            }

            return false;
        }

        public Filter Clone(Filter parent = null)
        {
            var filter = new Filter(_type) { _filterParametreName = _filterParametreName, _parent = parent };
            foreach (var criteria in _criteries)
            {
                if (criteria.Value is Filter subfilter)
                {
                    var newValue = subfilter.Clone(filter);
                    filter._criteries.Add(criteria.Key, newValue);
                }
                else if (criteria.Value is BaseExpression expression)
                {
                    var newBaseCriteria = expression.Clone();
                    filter._criteries.Add(criteria.Key, newBaseCriteria);
                }
            }
            return filter;
        }
    }
}
