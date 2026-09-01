using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class GetObjectPageUsage
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(GetObjectPageUsage));

        public static async Task<List<Dictionary<string, object>>> Execute()
        {
            try
            {
                List<Dictionary<string, object>> results
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.GetObjectPageUsage,
                        new Dictionary<string, object>(),
                        new Dictionary<string, object>(),
                        timeoutSeconds: 60); //but this one should be very quick
                return results;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(Execute) + " - caught unexpected exception");
                }
                throw;
            }

        }
    }
}
