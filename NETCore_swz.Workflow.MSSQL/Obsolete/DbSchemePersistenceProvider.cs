#if !NETCOREAPP
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using swz.Workflow.Core;
using swz.Workflow.Core.Fault;
using swz.Workflow.Core.Model;
using swz.Workflow.Core.Persistence;

namespace swz.Workflow.DbPersistence
{
    [Obsolete("Use class swz.Workflow.DbPersistence.MSSQLProvider")]
    public sealed class DbSchemePersistenceProvider : MSSQLProvider
    {
        public DbSchemePersistenceProvider(string connectionStringName) : base(connectionStringName)
        {
        }
    }
}
#endif
