using System.Diagnostics;
using swz.Clover.Core;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.ORM;

namespace swz.Clover.MSSQL
{
    public sealed class SQLFilterCriteriaBuilder<T> : BaseFilterCriteriaBuilder<T>
    {
        protected override string LikeRight(T value, string attributeToString) => string.Format(IsParameter(value) ? "{0} like CAST ({1} as nvarchar) + '%'" : "{0} like ('{1}%')",
            attributeToString,
            Formatter.Format(value));

        protected override string NotLikeRight(T value, string attributeToString) => string.Format(
            IsParameter(value) ? "{0} not like CAST ({1} as nvarchar) + '%'" : "{0} not like ('{1}%')",
            attributeToString, Formatter.Format(value));

        protected override string LikeLeft(T value, string attributeToString) => string.Format(IsParameter(value) ? "{0} like '%' + CAST ({1} as nvarchar)" : "{0} like ('%{1}')",
            attributeToString,
            Formatter.Format(value));

        protected override string NotLikeLeft(T value, string attributeToString) => string.Format(
            IsParameter(value) ? "{0} not like '%' + CAST ({1} as nvarchar)" : "{0} not like ('%{1}')",
            attributeToString,
            Formatter.Format(value));

        protected override string LikeRightLeft(T value, string attributeToString) => string.Format(
            IsParameter(value) ? "{0} like '%' + CAST ({1} as nvarchar) + '%'" : "{0} like ('%{1}%')",
            attributeToString,
            Formatter.Format(value));

        protected override string NotLikeRightLeft(T value, string attributeToString) => string.Format(
            IsParameter(value) ? "{0} not like '%' + CAST ({1} as nvarchar) + '%'" : "{0} not like ('%{1}%')",
            attributeToString,
            Formatter.Format(value));

     
        public SQLFilterCriteriaBuilder(PrimitiveFormatter<T> formatter)
        {
            Formatter = formatter;
        }
    }
}
