using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_UpdateDplySampleInfoForImport
    {
        public class UpdateDplySampleInfoForImportException : Exception
        {
            public UpdateDplySampleInfoForImportException(Exception innerException)
                : base("Unexpected exception updating info", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_UpdateDplySampleInfoForImport));

        public static async Task ExecuteAsync(Guid id, QnnStatusId status, string remarks)
        {
            try
            {
                bool traceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
                if (traceLoggingEnabled)
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for id={0}", id);
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("Id", id);
                spParams.Add("Status", status.Value);
                spParams.Add("Remarks", string.IsNullOrEmpty(remarks) ? DBNull.Value : (object)remarks);

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdateDplySampleInfoForImport,
                    spParams,
                    new Dictionary<string, object>());

                if (traceLoggingEnabled)
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, id={0}", id);
                throw new UpdateDplySampleInfoForImportException(e);
            }
        }
    }
}
