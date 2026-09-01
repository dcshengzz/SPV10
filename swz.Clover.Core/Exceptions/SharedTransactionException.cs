using System;

namespace swz.Clover.Core.Exceptions
{
    public class SharedTransactionRolledbackException : Exception
    {
        public SharedTransactionRolledbackException () : base ("The transaction was rolled back. Commit is impossible"){}
    }
}