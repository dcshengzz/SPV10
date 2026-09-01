#if !NETCOREAPP
using System;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Data.Linq;
using System.Linq;
using swz.Workflow.Core.Generator;

namespace swz.Workflow.DbPersistence
{
    [Obsolete("Use class swz.Workflow.DbPersistence.MSSQLProvider")]
    public class DbXmlWorkflowGenerator : MSSQLProvider
    {
        public DbXmlWorkflowGenerator(string connectionStringName) : base(connectionStringName)
        {
        }
    }
}
#endif