using System;

namespace swz.Clover.Core.Exceptions
{
    public  class DynamicEntitiesConcurrencyException : Exception
    {
          public DynamicEntitiesConcurrencyException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesConcurrencyException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesConcurrencyException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesConcurrencyException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
