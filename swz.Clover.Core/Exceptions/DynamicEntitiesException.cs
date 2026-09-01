using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesException : Exception
    {
         public DynamicEntitiesException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
