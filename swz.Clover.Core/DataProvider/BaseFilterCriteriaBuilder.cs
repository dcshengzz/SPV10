using System;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.DataProvider
{
    public abstract class BaseFilterCriteriaBuilder<T> : IFilterCriteriaBuilder<T>
    {
        protected PrimitiveFormatter<T> Formatter;

        private string AttributeToString(AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            return CloverRuntime.DbProvider.AttributeToString(attribute, (purpose.ConvertToAttributeLocation(), tableAlias));
        }

        private string PropertyToString(string property, FilterPurpose purpose, string tableAlias)
        {
            return CloverRuntime.DbProvider.PropertyToString(property, (purpose.ConvertToAttributeLocation(), tableAlias));
        }

        protected abstract string LikeRight(T value, string attributeToString);

        protected abstract string NotLikeRight(T value, string attributeToString);

        protected abstract string LikeLeft(T value, string attributeToString);

        protected abstract string NotLikeLeft(T value, string attributeToString);

        protected abstract string LikeRightLeft(T value, string attributeToString);

        protected abstract string NotLikeRightLeft(T value, string attributeToString);

        protected virtual string Equal(T value, string attributeToString) =>
            string.Format(value is Null ? $"{attributeToString} IS NULL" : $"{attributeToString} = {Formatter.FormatWithQuotation(value)}");

        protected virtual string NotEqual(T value, string attributeToString) =>
            string.Format(value is Null ? $"{attributeToString} IS NOT NULL" : $"{attributeToString} <> {Formatter.FormatWithQuotation(value)}");

        protected virtual string Greater(T value, string attributeToString) => string.Format("{0} > {1}", attributeToString, Formatter.FormatWithQuotation(value));

        protected virtual string GreaterOrEqual(T value, string attributeToString) => string.Format("{0} >= {1}", attributeToString, Formatter.FormatWithQuotation(value));

        protected virtual string LessOrEqual(T value, string attributeToString) => string.Format("{0} <= {1}", attributeToString, Formatter.FormatWithQuotation(value));

        protected virtual string Less(T value, string attributeToString) => string.Format("{0} < {1}", attributeToString, Formatter.FormatWithQuotation(value));

        public string LikeRight(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return LikeRight(value, attributeToString);
        }

        public string LikeRight(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return LikeRight(value, propertyToString);
        }

        public string NotLikeRight(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return NotLikeRight(value, attributeToString);
        }

        public string NotLikeRight(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return NotLikeRight(value, propertyToString);
        }

        public string LikeLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return LikeLeft(value, attributeToString);
        }

        public string LikeLeft(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return LikeLeft(value, propertyToString);
        }

        public string NotLikeLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return NotLikeLeft(value, attributeToString);
        }

        public string NotLikeLeft(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return NotLikeLeft(value, propertyToString);
        }

        public string LikeRightLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return LikeRightLeft(value, attributeToString);
        }

        public string LikeRightLeft(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = this.PropertyToString(property, purpose, tableAlias);
            return LikeRightLeft(value, propertyToString);
        }


        public string NotLikeRightLeft(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return NotLikeRightLeft(value, attributeToString);
        }

        public string NotLikeRightLeft(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return NotLikeRightLeft(value, propertyToString);
        }

        public string Equal(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);

            return Equal(value, attributeToString);
        }

        public string Equal(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            var propertyToString = PropertyToString(property, purpose, tableAlias);

            return Equal(value, propertyToString);
        }

        public string NotEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return NotEqual(value, attributeToString);
        }

        public string NotEqual(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return NotEqual(value, propertyToString);
        }

        public string Greater(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);

            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return Greater(value, attributeToString);
        }

        public string Greater(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return Greater(value, propertyToString);
        }


        public string GreaterOrEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return GreaterOrEqual(value, attributeToString);
        }

        public string GreaterOrEqual(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return GreaterOrEqual(value, propertyToString);
        }

        public string Less(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var attributeToString = AttributeToString(attribute, purpose, tableAlias);
            return Less(value, attributeToString);
        }

        public string Less(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);
            var propertyToString = PropertyToString(property, purpose, tableAlias);
            return Less(value, propertyToString);
        }

        public string LessOrEqual(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);

            var attributeToString = AttributeToString(attribute, purpose, tableAlias);

            return LessOrEqual(value, attributeToString);
        }

        public string LessOrEqual(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            CheckNotNull(value);

            var propertyToString = PropertyToString(property, purpose, tableAlias);

            return LessOrEqual(value, propertyToString);
        }

        public string Format(T value)
        {
            return Formatter.Format(value);
        }

        public string FormatWithQuatation(T value)
        {
            return Formatter.FormatWithQuotation(value);
        }

        protected bool IsParameter(T value)
        {
            return (value is Parameter);
        }

        private void CheckNotNull(T value)
        {
            if (value is Null)
                throw new NotSupportedException("Can not build criteria with Null");
        }

    }
}