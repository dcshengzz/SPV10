using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesMergeException: Exception
    {
        public DynamicEntitiesMergeException(string message)
            : base(message)
        {
        }

        public DynamicEntitiesMergeException(string message, params object[] parameters)
            : base(string.Format(message, parameters))
        {
        }

        public DynamicEntitiesMergeException(Exception exception, string message)
            : base(message, exception)
        {
        }

        public DynamicEntitiesMergeException(Exception exception, string message, params object[] parameters)
            : base(string.Format(message, parameters), exception)
        {
        }
    }
}
