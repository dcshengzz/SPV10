using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_DeleteSampleProp
    {
        public class DeleteSamplePropException : Exception
        {
            public DeleteSamplePropException(Exception innerException)
                : base("Unexpected exception deleting sample properties", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_DeleteSampleProp));

        /// <summary>
        /// Delete QNN_LIST_SAMPLE_PROP rows for the specified listSampleIds if the specified list exists
        /// </summary>
        public static async Task ExecuteAsync(
            Guid listId,
            List<Guid> listSampleIds,
            AuditBatch auditBatch,
            Guid structDivisionId)
        {
            try
            {
                if (listSampleIds == null) throw new ArgumentNullException(nameof(listSampleIds));

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for listId={0}, listSampleIds.Count={1}, structDivisionId={2}, eventBatch={3}", listId, listSampleIds.Count, structDivisionId, auditBatch.EventBatch);
                }
                    
                //delete existing prop  (the below was factored out of ImportListSamples and modified to use AuditBatch)
                Dictionary<string, object> spParams = new Dictionary<string, object>
                {
                    {"ListId", listId},
                    {"ListSampleIds", string.Join(",", listSampleIds)},
                    {"UserId", auditBatch.HasUser ? auditBatch.UserId : (object)DBNull.Value },
                    {"StructDivisionId", structDivisionId},
                    {"EventBatch", auditBatch.EventBatch},
                    {"EventDate", DateTime.Now},
                    {"AuditOn", auditBatch.AuditOn}
                };

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_DeleteSampleProp,
                    spParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}, eventBatch={1}",
                        duration, auditBatch.EventBatch);
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, listId={0}", listId);
                throw new DeleteSamplePropException(e);
            }
        }
    }
}
