#if !NETCOREAPP
using System;
using System.Configuration;

namespace swz.Workflow.DbPersistence
{
    [Obsolete("Use class swz.Workflow.DbPersistence.MSSQLProvider")]
    public abstract class DbProvider : MSSQLProvider
    {
        public DbProvider(string connectionString) : base (connectionString)
        {
            
        }
    }
}
#endif