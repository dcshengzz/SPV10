using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesConvertException : Exception
    {
        public DynamicEntitiesConvertException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesConvertException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesConvertException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesConvertException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
