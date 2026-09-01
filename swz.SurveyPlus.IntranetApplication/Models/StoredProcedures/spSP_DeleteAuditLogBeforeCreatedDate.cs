using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_DeleteAuditLogBeforeCreatedDate
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_DeleteAuditLogBeforeCreatedDate));

        public static async Task ExecuteAsync(
            DateTime createdBefore,
            AuditBatch auditBatch,
            Guid auditStructDivisionId)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called, eventBatch={0}", auditBatch?.EventBatch);
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>
                    {
                        //this procedure doesn't currently take auditOn
                        {"UserId", auditBatch.UserId},
                        {"EventBatch", auditBatch.EventBatch},
                        {"EventDate", DateTime.Now},
                        {"StructDivisionId", auditStructDivisionId}, //only used for audit, logs from ALL orgs are deleted
                        {"DataCreatedBefore", createdBefore }
                    };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_DeleteAuditLogBeforeCreatedDate,
                    spParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }
            }
            catch (Exception)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogDebug(nameof(ExecuteAsync) + " - caught exception, eventBatch={0}, duration={1}", auditBatch?.EventBatch, duration);
                throw;
            }
        }
    }
}
