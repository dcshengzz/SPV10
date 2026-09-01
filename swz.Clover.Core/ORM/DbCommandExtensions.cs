using System.Collections.Generic;
using System.Data.Common;
using System.Threading.Tasks;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public static class DbCommandExtensions
    {
        internal static DbCommand BuildCommand(this DbCommand command, SQLQueryObject query)
        {
            command.CommandTimeout = CloverRuntime.CommandTimeout;
            command = query.BuildCommand(command);
            return command;
        }

        public static DbCommand AssignTransaction(this DbCommand command, DbTransaction transaction)
        {
            command.Transaction = transaction;
            return command;
        }

        public static Task<List<DynamicEntity>> MapAsync(this DbCommand command, EntityModel model)
        {
            var mapper = new SQLToDynamicMapper(model);
            return mapper.Map(command, useMetadataTypeForMapping:model != null,addMissingProperties:model != null);
        }
        
        public static Task<List<DynamicEntity>> MapWithoutAddMissingPropertiesAsync(this DbCommand command, EntityModel model)
        {
            var mapper = new SQLToDynamicMapper(model);
            return mapper.Map(command, useMetadataTypeForMapping:model != null,addMissingProperties:false);
        }
    }
}
