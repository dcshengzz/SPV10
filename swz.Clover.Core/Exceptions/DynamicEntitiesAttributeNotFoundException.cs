using System;

namespace swz.Clover.Core.Exceptions
{
    public  class DynamicEntitiesAttributeNotFoundException : Exception
    {
          public DynamicEntitiesAttributeNotFoundException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesAttributeNotFoundException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesAttributeNotFoundException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesAttributeNotFoundException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
