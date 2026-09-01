#if !NETCOREAPP
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Serialization;
using swz.Workflow.Core.Fault;
using swz.Workflow.Core.Model;
using swz.Workflow.Core.Persistence;
using swz.Workflow.Core.Runtime;

namespace swz.Workflow.DbPersistence
{
    [Obsolete("Use class swz.Workflow.DbPersistence.MSSQLProvider")]
    public sealed class DbPersistenceProvider : MSSQLProvider
    {
        public DbPersistenceProvider(string connectionString) : base(connectionString)
        {
        }
    }
}
#endif