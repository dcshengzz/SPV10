using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    /// <summary>
    /// Simple wrapper for the spSP_SyncAuditSampleName stored procedure that will update or insert changed sample names and UIDs into sy_AuditSampleName.
    /// Details:
    /// We now keep a separate table of sampleId, Name, UID specifically for audit purpose (accessed via the sy_AuditSampleName synonym)
    /// however we can't use a trigger to keep it up to date with any name changes in QNN_SAMPLE because QNN_SAMPLE also has the NumberId column
    /// which is managed by the database which means we have to mark it as 'calculated' in Clover , and Clover ORM will use OUTPUT paramaters in its
    /// INSERT and UPDATE queries for calculated columns, and SQL Server will reject any query with an OUTPUT parameter if the table has 
    /// *any* triggers which means we have to forego the use of a triger here and instead add application logic to keep the table in sync. 
    /// (We need this table now as the view that is used to look at audit data needs to have sample name. And this view may now be in
    /// an external database on the same server (or it may be local to the SurveyPlus database - the default) so we access it via a synonym, 
    /// and it has a full text index, which requires it to be schema bound, which means it has to use inner joins, which is why we ended up 
    /// having this AuditSampleName table in the first place instead of just using a left join.
    /// (fyi: We also have AuditUserName and AuditDivisionName, and the synonyms sy_AuditUserName, and sy_AuditDivisionName, 
    /// but since dwSecurityUser and StructDivision don't have any 'calculated' fields we use triggers to keep them up to date 
    /// with any changes as they happen, which is somewhat more convenient for maintenance simplicity and reliability).
    /// </summary>
    public class spSP_SyncAuditSampleName
    {
        public class SyncAuditSampleNameException : Exception
        {
            public SyncAuditSampleNameException(long duration, Exception innerException) 
                : base($"Unexpected exception syncing sample names to audit tables, duration={duration}", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_SyncAuditSampleName));

        /// <summary>
        /// Application code should use swz.SurveyPlus.IntranetApplication.AuditHelper.SyncAuditSampleName instead of calling this directly
        /// </summary>
        public static async Task ExecuteAsync()
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(ExecuteAsync) + " - called");

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                        Constants.StoredProcedure.spSP_SyncAuditSampleName,
                        new Dictionary<string, object>(),
                        new Dictionary<string, object>());

                const int durationWarningSeconds = 10;
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                if (duration > (durationWarningSeconds*1000)  && logger.IsEnabled(LogLevel.Warning))
                {
                    logger.LogWarning(nameof(ExecuteAsync) + " - stored procedure took over {0} seconds, completing in {1} ms", durationWarningSeconds, duration);
                }
                else if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure completed in {0} ms", duration);
                }
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogDebug(e, nameof(ExecuteAsync) + " caught unexpected exception, duration={0}", duration);
                throw new SyncAuditSampleNameException(duration, e);
            }
        }
    }
}
