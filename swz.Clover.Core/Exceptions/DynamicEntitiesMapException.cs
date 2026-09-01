using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesMapException : Exception
    {
        public DynamicEntitiesMapException(string name, string attributeName, string message, Exception inner = null)
            : base($"When mapping data to the {name} model {attributeName} attribute, the following error occurred. {message}",inner)
        {
        }
    }
}
