using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_AddDplySampleInfoByListId
    {
        public class AddDplySampleInfoByListIdException : Exception
        {
            public Guid DplyId { get; }
            public Guid ListId { get; }

            public AddDplySampleInfoByListIdException(
                Guid dplyId,
                Guid listId,
                Exception innerException)
                : base($"AddDplySampleInfoByListId failed for dplyId={dplyId}, listId={listId}", innerException)
            {
                this.DplyId = dplyId;
                this.ListId = listId;
            }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_AddDplySampleInfoByListId));

        public static async Task ExecuteAsync(
            Guid dplyId, 
            Guid listId, 
            List<string> delegationCodes,
            AuditBatch auditBatch,
            Guid auditStructDivisionId)
        {
            if (delegationCodes == null) throw new ArgumentNullException(nameof(delegationCodes));
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            if (auditBatch.HasSample) throw new ArgumentException("Audit batch has sample", nameof(auditBatch));

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for dplyId={0}, listIdId={1}, delegationCodes.Count={2}, eventBatch={3}", dplyId, listId, delegationCodes?.Count, auditBatch?.EventBatch);
                }

                string pipeDelimitedCodes = String.Join('|', delegationCodes);

                Dictionary<string, object> spParams = new Dictionary<string, object>
                {
                    {"DplyId", dplyId},
                    {"ListId", listId},
                    {"UserId", auditBatch.UserId},
                    {"StructDivisionId", auditStructDivisionId},
                    {"EventBatch", auditBatch.EventBatch},
                    {"EventDate", DateTime.Now},
                    {"DelegationCodes", pipeDelimitedCodes },
                    {"AuditOn", auditBatch.AuditOn}
                    //we aren't passing @Status so procedure will use its default
                };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_AddDplySampleInfoByListId,
                    spParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }

            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught exception for dplyId={0}, listIdId={1}, delegationCodes.Count={2}, eventBatch={3}", dplyId, listId, delegationCodes?.Count, auditBatch?.EventBatch);
                throw new AddDplySampleInfoByListIdException(dplyId, listId, e);
            }
        }
    }
}
