using System;

namespace swz.Clover.Core.ORM
{
    public abstract class PrimitiveFormatter<T>
    {
        protected readonly Type Type = typeof (T);

        public string Format(T value)
        {
            return FormatValue(value, false);
        }

        public string FormatWithQuotation(T value)
        {
            return FormatValue(value, true);
        }

        protected abstract string FormatValue(T value, bool quotation);

    }
}
