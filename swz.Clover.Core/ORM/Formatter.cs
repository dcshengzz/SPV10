using System;
using System.Globalization;

namespace swz.Clover.Core.ORM
{
    public class Formatter<T> : PrimitiveFormatter<T> 
    {
        protected override string FormatValue(T value, bool quotation)
        {

            if (Type == typeof(string) || Type == typeof(Guid))
            {
                return quotation ? string.Format("'{0}'", value) : string.Format("{0}", value);
            }
            if (Type == typeof(DateTime))
            {
                return quotation ? string.Format("'{0:yyyy-MM-dd HH:mm:ss.fff}'", value as IFormattable) : string.Format("{0:yyyy-MM-dd HH:mm:ss.fff}", value as IFormattable);
            }
            if (Type == typeof(bool))
            {
                return quotation ? (value.Equals(true) ? "'1'" : "'0'") : (value.Equals(true) ? "1" : "0");
            }
            if (Type == typeof(Parameter))
            {
                return value.ToString();
            }
            return quotation ? string.Format(CultureInfo.InvariantCulture, "'{0}'", value) : string.Format(CultureInfo.InvariantCulture, "{0}", value);

        }

    }

}
