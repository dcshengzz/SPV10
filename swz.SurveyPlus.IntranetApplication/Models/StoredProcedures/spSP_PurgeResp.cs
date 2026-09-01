using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    /// <summary>
    /// For use in the dplyMaintenance screen. Delete all responses from a deployment.
    /// For audit would log a "Purge Responses" event with just their Ids (no data).
    /// </summary>
    public class spSP_PurgeResp
    {
        public class PurgeRespException : Exception
        {
            public Guid DplyId { get; private set; }

            public PurgeRespException(Guid dplyId, Exception innerException)
                : base($"Unexpected exception purging responses for DplyId={dplyId} from database", innerException)
            {
                this.DplyId = dplyId;
            }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_PurgeResp));

        public static async Task DeleteResponsesForDeployment(AuditBatch auditBatch, Guid? structDivisionId, Guid dplyId)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            if (!auditBatch.HasUser) throw new ArgumentException("AuditBatch must have user for this procedure", nameof(auditBatch));
            await ExecuteAsync(
                auditOn: auditBatch.AuditOn,
                structDivisionId: structDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                userId: auditBatch.UserId,
                dplyId: dplyId);
        }

        private static async Task ExecuteAsync(
            bool auditOn,
            Guid? structDivisionId,
            Guid eventBatch,
            DateTime eventDate,
            Guid? userId,
            Guid dplyId)
        {
            //We have hardcoded the timeout settings for this procedure because it only used in the maintenance
            //screen for deployments (so hardly ever used) so no point cluttering the admin settings screen.
            //If we expand the uses of this procedure then consider making them configurable.
            TimeoutSettings settings = new TimeoutSettings(timeoutSeconds: 45);

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>();
                param.Add("AuditOn", auditOn);
                param.Add("StructDivisionId", structDivisionId ?? (object)DBNull.Value);
                param.Add("EventBatch", eventBatch);
                param.Add("EventDate", eventDate);
                param.Add("UserId", userId ?? (object)DBNull.Value);
                param.Add("DplyId", dplyId);

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called, param={0}", param);
                }

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_PurgeResp,
                    param,
                    new Dictionary<string, object>(),
                    settings.TimeoutSecondsRoundedUp);

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }

                return;
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;                
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, duration={0}, dplyId={1}", duration, dplyId);
                throw new PurgeRespException(dplyId, e);
            }
        }
    }
}
