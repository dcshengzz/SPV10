using System;

namespace swz.Clover.Core.Exceptions
{
    public class DynamicEntitiesModelException : Exception
    {
        public DynamicEntitiesModelException (string modelName, string message) : base($"The model {modelName} has following error. {message}")
        {}
    }
}