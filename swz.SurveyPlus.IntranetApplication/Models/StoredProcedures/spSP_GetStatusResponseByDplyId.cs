using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetStatusResponseByDplyId
    {
        public class GetStatusResponseByDplyIdException : Exception
        {
            public GetStatusResponseByDplyIdException(Guid dplyId, Exception innerException)
                : base($"Unexpected exception getting response status for dplyId={dplyId}", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetStatusResponseByDplyId));

        public static async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid dplyId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for dplyId={0}", dplyId);
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("DplyId", dplyId);
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetStatusResponseByDplyId,
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
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, dplyId={0}", dplyId);
                throw new GetStatusResponseByDplyIdException(dplyId,e);
            }
        }
    }
}
