using System;

namespace swz.Workflow.Core.Fault
{
    public class InvalidCommandException : Exception
    {
        public InvalidCommandException(string message, params object[] args)
            : base(string.Format(message, args))
        {
            
        }
    }
}
