using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_TakeReportSnapshot
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_TakeReportSnapshot + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;
        public const string SETTING_RETRIES = Constants.StoredProcedure.spSP_TakeReportSnapshot + RetrySettings.SETTING_RETRIES_POSTFIX;
        public const string SETTING_BASE_RETRY_DELAY = Constants.StoredProcedure.spSP_TakeReportSnapshot + RetrySettings.SETTING_BASE_RETRY_DELAY_POSTFIX;

        public const double DEFAULT_TIMEOUT = 180;
        public const int DEFAULT_RETRIES = RetrySettings.NO_RETRIES;
        public const double DEFAULT_BASE_RETRY_DELAY = 0;

        private static readonly ImmutableList<String> SETTING_NAMES = new List<string> {
            SETTING_TIMEOUT,
            SETTING_RETRIES,
            SETTING_BASE_RETRY_DELAY
        }.ToImmutableList();

        public class TakeReportSnapshotException : Exception
        {
            public Guid DplyId { get; private set; }
            public long Duration { get; private set; }

            public TakeReportSnapshotException(Guid dplyId, Exception innerException, long duration)
                : base($"Failed to take report snapshot for dplyId={dplyId}, duration={duration} ms", innerException)
            {
                this.DplyId = dplyId;
                this.Duration = duration;
            }
        }

        /// <summary>
        /// Return an instance with defaults for the retry configuration. These defaults can be overridden by adding the appropriate
        /// settings to dwAppSettings, however in a normal instance it will use hardcoded settings
        /// </summary>
        /// <returns></returns>
        public static async Task<spSP_TakeReportSnapshot> GetInstanceUsingAppSettingsAsync()
        {
            //For this procedure, I don't intend on providing dwAppSettings for its retry settings out of the box, but I do want to
            //allow for manually adding them to db later in existing instances so we can still tweak if we have unexpected issues.
            //So we will pass null for the logger here to suppress RetrySetting's warnings about not finding the settings in appSettings.
            //(n.b. If we do add them later as a standard thing, then remove this comment and change below to pass the logger)
            SettingsWrapper appSettings
                = await SettingsHelper.GetSettingsWrapperAsync(SETTING_NAMES, assertDefined: false);
            double timeoutSeconds = appSettings.GetDoubleOrDefault(SETTING_TIMEOUT, DEFAULT_TIMEOUT, warningLogger: null);
            int retries = appSettings.GetIntOrDefault(SETTING_RETRIES, DEFAULT_RETRIES, warningLogger: null);
            double baseRetryDelaySeconds = appSettings.GetDoubleOrDefault(SETTING_BASE_RETRY_DELAY, DEFAULT_BASE_RETRY_DELAY, warningLogger: null);
            ILogger<spSP_TakeReportSnapshot> logger
                = (ILogger<spSP_TakeReportSnapshot>)DefaultApplicationLogging.CreateLogger<spSP_TakeReportSnapshot>();
            spSP_TakeReportSnapshot instance = new spSP_TakeReportSnapshot(logger, new TimeoutSettings(timeoutSeconds), new RetrySettings(retries, baseRetryDelaySeconds));
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        private readonly ILogger<spSP_TakeReportSnapshot> logger;

        /// <summary>
        /// Constructor. 
        /// Note that a static helper class has been provided instead to create an instance using settings from
        /// dwAppSettings 
        /// </summary>
        public spSP_TakeReportSnapshot(
            ILogger<spSP_TakeReportSnapshot> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_TakeReportSnapshot) + $"[{nameof(Settings)}={Settings}, {nameof(RetryConfiguration)}={RetryConfiguration}]";
        }

        public async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid dplyId)
        {
            if (Guid.Empty.Equals(dplyId)) throw new ArgumentException(nameof(dplyId));

            //TODO - this procedures modifies db data, so we shouldnt allow for procedure level retries as this
            //       becomes callers responsibility to provide a transaction and do retries at the tx level, or
            //       alternately we push the tx declaration down to the procedure itself with error handling and
            //       rollback in the procedure, and an assertion here that there is no transaction yet
            //       See issue #237
            int currentRetryDelayMs = RetryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = RetryConfiguration.Retries;
            while (true) //will exit loop via short-cicuit return on success or exceeding retries count in the catch block
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                try
                {
                    Dictionary<string, object> spParams = new Dictionary<string, object>
                    {
                        {"DplyID", dplyId},
                    };

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ExecuteAsync) + " - executing procedure with spParams={1}, timeout={2} seconds", spParams, Settings.TimeoutSecondsRoundedUp);
                    }

                    List<Dictionary<string, object>> items
                        = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_TakeReportSnapshot,
                            spParams,
                            new Dictionary<string, object>(),
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (logger.IsEnabled(LogLevel.Debug)) //debug isn't too cluttery as we only get called once per export job
                    {
                        logger.LogDebug(nameof(ExecuteAsync) + " - result set contained {0} rows for dplyId={1}, duration={2} ms", items.Count, dplyId, duration);
                    }

                    const long warningDurationMs = 3000;
                    if (duration > warningDurationMs && logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(ExecuteAsync) + " - exceeded {0} ms, for {1} rows, dplyId={2}, duration={3}", warningDurationMs, items.Count, dplyId, duration);
                    }

                    return items;
                }
                catch (Exception e)
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, dplyId={1}, duration={2}, remainingRetries={3}, message={4}",
                            currentRetryDelayMs,
                            dplyId,
                            duration,
                            remainingRetries,
                            e.Message);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            //Message is usually enough, so we'll only add the stacktrace in the most verbose logging mode
                            //included the dplyId so can correlate with the warning if there's a lot of other logging happening
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace, dplyId={0}", dplyId);
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught exception and will fail, dplyId={0}, duration={1}, remainingRetries={2}, message={3}",
                            dplyId,
                            duration,
                            remainingRetries,
                            e.Message);
                        throw new TakeReportSnapshotException(dplyId, e, duration);
                    }
                }
            } //end retry loop
        }
    }
}
