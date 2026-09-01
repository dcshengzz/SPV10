using System;

namespace swz.Workflow.Core.License
{
    public class LicenseException : Exception
    {
        public LicenseException(string message)
            : base(message)
        {
        }
    }
}
