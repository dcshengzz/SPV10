using System;

namespace swz.Clover.Core.Exceptions
{
    public class DeleteCancelledException : Exception
    {
        public DeleteCancelledException(string message) : base (message)
        {}
    }
}