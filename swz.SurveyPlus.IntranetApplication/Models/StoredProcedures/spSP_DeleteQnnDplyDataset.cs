using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_DeleteQnnDplyDataset
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_DeleteQnnDplyDataset));

        public static async Task ExecuteAsync(
            Guid dplyId,
            AuditBatch auditBatch,
            Guid auditStructDivisionId)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called, dplyId={0}, eventBatch={0}", dplyId, auditBatch?.EventBatch);
                }

                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_DeleteQnnDplyDataset,
                    new Dictionary<string, object>
                    {
                        {"DplyId", dplyId},
                        {"UserId", auditBatch.UserId},
                        {"StructDivisionId", auditStructDivisionId},
                        {"EventBatch", auditBatch.EventBatch},
                        {"EventDate", DateTime.Now},
                        {"AuditOn", auditBatch.AuditOn},
                    },
                    new Dictionary<string, object>()
                );

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }
            }
            catch (Exception)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogDebug(nameof(ExecuteAsync) + " - caught exception, dplyId={0}, eventBatch={1}, duration={2}", dplyId, auditBatch?.EventBatch, duration);
                throw;
            }
        }
    }
}
