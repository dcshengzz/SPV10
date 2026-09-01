using System;

namespace swz.Workflow.Core.Fault
{
    public class TimerManagerException : Exception
    {
        public TimerManagerException(string message) : base(message)
        {
        }
    }
}
