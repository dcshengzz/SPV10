using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesParseException : Exception
    {
        public DynamicEntitiesParseException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesParseException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesParseException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesParseException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
