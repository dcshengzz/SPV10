using System;

namespace swz.Clover.Core.Exceptions
{
    public class SelectCancelledException : Exception
    {
        public SelectCancelledException(string message) : base (message)
        {}
    }
}