using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetResponseStratumCount
    {
        public const double DEFAULT_TIMEOUT = 15;
        public const int DEFAULT_RETRIES = 2;
        public const double DEFAULT_BASE_RETRY_DELAY = 5;

        public class GetResponseStratumCountException : Exception
        {
            public GetResponseStratumCountException(Guid dplyId, long duration, Exception innerException)
                : base($"Failed to get response stratum count for dplyId={dplyId}, duration={duration}", innerException) { }
        }

        /// <summary>
        /// Get an instance using default hardcoded settings
        /// </summary>
        public static spSP_GetResponseStratumCount GetInstanceUsingDefaultSettings()
        {
            ILogger<spSP_GetResponseStratumCount> logger = (ILogger<spSP_GetResponseStratumCount>)DefaultApplicationLogging.CreateLogger<spSP_GetResponseStratumCount>();

            TimeoutSettings settings = new TimeoutSettings(
                timeoutSeconds: DEFAULT_TIMEOUT);

            RetrySettings retryConfiguration = new RetrySettings(
                retries: DEFAULT_RETRIES,
                baseRetryDelaySeconds: DEFAULT_BASE_RETRY_DELAY);

            return new spSP_GetResponseStratumCount(logger, settings, retryConfiguration);
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        private readonly ILogger<spSP_GetResponseStratumCount> logger;
        
        public spSP_GetResponseStratumCount(
            ILogger<spSP_GetResponseStratumCount> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_GetResponseStratumCount) + $"[RetryConfiguration={RetryConfiguration}]";
        }

        /// <summary>
        /// Gets a dictionary of strata and their counts.
        /// Key is case-insensitive.
        /// </summary>
        public async Task<Dictionary<string,int>> GetCountByStrata(Guid dplyId)
        {
            Dictionary<string, int> counts
                = (await ExecuteAsync(dplyId))
                .Where(row => !DBNull.Value.Equals(row["Strata"])) //TODO - or should we convert to "" for this in results?
                .ToDictionary(
                    row => (string)row["Strata"],
                    row => (int)row["StrataCount"],
                    Constants.Comparers.ObjectNameCaseInsensitive);
            return counts;
        }

        private async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid dplyId)
        {
            Dictionary<string, object> spParams = new Dictionary<string, object>
            {
                {"DplyID", dplyId}
            };

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ExecuteAsync) + " - Called, spParams={0}", spParams);
            }

            int currentRetryDelayMs = RetryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = RetryConfiguration.Retries;
            while (true) //will exit loop via short-cicuit return on success or exceeding retries count in the catch block
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                try
                {
                    //returns rows with columns: Strata, StrataCount    (Strata may have DBNull)
                    List<Dictionary<string, object>> items
                        = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_GetResponseStratumCount,
                            spParams,
                            new Dictionary<string, object>(),
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (duration > 3000)
                    {
                        logger.LogWarning(nameof(ExecuteAsync) + " - completed in {0} ms (over 3 seconds) for spParams={1}, returning {2} rows",
                            duration,
                            spParams,
                            items?.Count);
                    }
                    else if (logger.IsEnabled(LogLevel.Debug))
                    {

                        logger.LogDebug(nameof(ExecuteAsync) + " - completed in {0} ms for spParams={1}, returning {2} rows",
                            duration,
                            spParams,
                            items?.Count);
                    }

                    return items;
                }
                catch (Exception e)
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    //TODO - only attempt retry if not inside a tx
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(e, nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, duration={1}, dplyId={2}", currentRetryDelayMs, duration, dplyId);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace");
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, duration={0}, dplyId={2}", duration, dplyId);
                        throw new GetResponseStratumCountException(dplyId, duration, e);
                    }
                }
            } //end retry loop
        }
    }

    
}
