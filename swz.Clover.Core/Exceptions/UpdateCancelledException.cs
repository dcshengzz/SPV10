using System;

namespace swz.Clover.Core.Exceptions
{
    public class UpdateCancelledException: Exception
    {
        public UpdateCancelledException(string message) : base (message)
        {}
    }
}