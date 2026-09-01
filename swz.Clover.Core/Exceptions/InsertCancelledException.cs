using System;

namespace swz.Clover.Core.Exceptions
{
    public class InsertCancelledException : Exception
    {
        public InsertCancelledException(string message) : base (message)
        {}
    }
}