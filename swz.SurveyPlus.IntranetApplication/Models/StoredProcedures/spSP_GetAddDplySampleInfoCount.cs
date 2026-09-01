using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetAddDplySampleInfoCount
    {
        public class GetAddDplySampleInfoCountException : Exception
        {
            public GetAddDplySampleInfoCountException(string message, Exception innerException)
                : base(message, innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetAddDplySampleInfoCount));

        public static async Task<int> GetSampleCountAsync(Guid dplyId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(GetSampleCountAsync) + " - Called");
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("DplyId", dplyId);

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetAddDplySampleInfoCount,
                    spParams,
                    new Dictionary<string, object>());
                int sampleCount = (int)results.FirstOrDefault()["SampleCount"]; 
                
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(GetSampleCountAsync) + " - stored procedure call complete, duration={0}, sample count={1}", duration, sampleCount);
                }

                return sampleCount;
            }
            catch (Exception e)
            {
                //log at debug level here, caller responsible for handling and/or error level logging as they see fit
                logger.LogDebug(e, nameof(GetSampleCountAsync) + " - caught unexpected exception, dplyId={0}", dplyId);
                throw new GetAddDplySampleInfoCountException($"Failed for dplyId={dplyId}", e);
            }
        }
    }
}
