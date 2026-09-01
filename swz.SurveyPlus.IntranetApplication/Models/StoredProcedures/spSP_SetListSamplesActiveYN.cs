using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_SetListSamplesActiveYN
    {
        public class SetListSamplesActiveYNException : Exception
        {
            public SetListSamplesActiveYNException(                
                Guid listId, 
                List<Guid> listSampleIds, 
                bool activeYN,
                AuditBatch auditBatch,
                Exception innerException)
                : base($"Unexpected exception setting ActiveYN for List Samples. listId={listId}, listSampleIds.Count={listSampleIds.Count}, activeYN-{activeYN}, auditBatch.AuditOn={auditBatch.AuditOn}, auditBatch.UserId={auditBatch.UserId} ", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_SetListSamplesActiveYN));

        public static async Task<long> ExecuteAsync(
            Guid listId,
            List<Guid> listSampleIds,
            bool activeYN,
            AuditBatch auditBatch,
            Guid structDivisionId)
        {
            if (listSampleIds == null) throw new ArgumentNullException(nameof(listSampleIds));
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for listId={0}, listSampleIds.Count={1}, structDivisionId={2}, eventBatch={3}", listId, listSampleIds.Count, structDivisionId, auditBatch.EventBatch);
                }

                Dictionary<string, object> inParams = new Dictionary<string, object>
                {
                    {"ListId", listId},
                    {"ListSampleIds", string.Join(",", listSampleIds)},
                    {"ActiveYN", activeYN },
                    {"UserId", auditBatch.HasUser ? auditBatch.UserId : (object)DBNull.Value },
                    {"StructDivisionId", structDivisionId},
                    {"EventBatch", auditBatch.EventBatch},
                    {"EventDate", DateTime.Now},
                    {"AuditOn", auditBatch.AuditOn}
                };

                Dictionary<string, object> outParams = new Dictionary<string, object>
                {
                    {"Updated", (long)0 },
                };

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_SetListSamplesActiveYN,
                    inParams,
                    outParams);

                long updated = (long)outParams["Updated"];

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}, eventBatch={1}, updated={2}",
                        duration, auditBatch.EventBatch, updated);
                }

                return updated;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, listId={0}", listId);
                throw new SetListSamplesActiveYNException(listId, listSampleIds, activeYN, auditBatch, e);
            }
        }
    }
}