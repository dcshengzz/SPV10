using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetMonthlyAccessLogs
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetMonthlyAccessLogs));

        /// <summary>
        /// Fetch audit log data relating to access control. 
        /// i.e. logins, user and role changes, etc
        /// </summary>
        public static async Task<List<Dictionary<string, object>>> ForPeriod(DateTime startDate, DateTime endDate)
        {
            if (endDate < startDate)
                throw new ArgumentException($"must be after {nameof(startDate)}", nameof(endDate));
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ForPeriod) + " - called, startDate={0}, endDate={1}", startDate, endDate);
                }
                Dictionary<string, object> param = new Dictionary<string, object>();
                param.Add("StartDate", startDate);
                param.Add("EndDate", endDate);
                List<Dictionary<string, object>> result = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetMonthlyAccessLogs, 
                    param, 
                    new Dictionary<string, object>(),
                    timeoutSeconds: 3600);
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    long durationMinutes = (duration / 1000) / 60;
                    logger.LogTrace(nameof(ForPeriod) + " - completed, startDate={0}, endDate={1}, procedure duration={2} (about {3} minutes), rows={4}", startDate, endDate, duration, durationMinutes, result?.Count);
                }
                return result;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    logger.LogDebug(e, nameof(ForPeriod) + $" - caught unexpected exception, start={startDate}, end={endDate}, procedure duration={duration}");
                }
                throw;
            }
        }
    }
}
