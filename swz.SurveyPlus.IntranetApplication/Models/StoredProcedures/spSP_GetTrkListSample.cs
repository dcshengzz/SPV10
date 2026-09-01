using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetTrkListSample
    {
        public class GetTrkListSampleException : Exception
        {
            public GetTrkListSampleException(string message, Exception innerException)
                : base(message, innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetTrkListSample));

        public static async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid trkListId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called");
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("TrkListId", trkListId);

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetTrkListSample,
                    spParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}, count={1}", duration, results.Count);
                }

                return results;
            }
            catch (Exception e)
            {
                //log at debug level here, caller responsible for handling and/or error level logging as they see fit
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, trkListId={0}", trkListId);
                throw new GetTrkListSampleException($"Failed for trkListId={trkListId}", e);
            }
        }
    }
}
