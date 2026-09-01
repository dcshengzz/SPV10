using System;

namespace swz.Clover.Core.Exceptions
{
    public class NewEntityCreationCancelledException  : Exception
    {
        public NewEntityCreationCancelledException(string message) : base (message)
        {}
    }
}