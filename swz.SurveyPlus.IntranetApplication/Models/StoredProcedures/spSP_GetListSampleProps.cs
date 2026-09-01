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
    /// <summary>
    /// Used by the new (20240426) response exporter
    /// </summary>
    public class spSP_GetListSampleProps
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_GetListSampleProps + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;
        public const string SETTING_RETRIES = Constants.StoredProcedure.spSP_GetListSampleProps + RetrySettings.SETTING_RETRIES_POSTFIX;
        public const string SETTING_BASE_RETRY_DELAY = Constants.StoredProcedure.spSP_GetListSampleProps + RetrySettings.SETTING_BASE_RETRY_DELAY_POSTFIX;

        public const double DEFAULT_TIMEOUT = 30;
        public const int DEFAULT_RETRIES = 3;
        public const double DEFAULT_BASE_RETRY_DELAY = 20;

        private static readonly ImmutableList<String> SETTING_NAMES = new List<string> {
            SETTING_TIMEOUT,
            SETTING_RETRIES,
            SETTING_BASE_RETRY_DELAY
        }.ToImmutableList();

        public class GetListSamplePropsException : Exception
        {
            public Guid ListSampleId { get; private set; }
            public long Duration { get; private set; }

            public GetListSamplePropsException(Guid listSampleId, Exception innerException, long duration)
                : base($"Failed to get List Sample Props for ListSampleId={listSampleId}, duration={duration}", innerException)
            {
                this.ListSampleId = listSampleId;
                this.Duration = duration;
            }
        }

        public static async Task<spSP_GetListSampleProps> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_GetListSampleProps> logger = (ILogger<spSP_GetListSampleProps>)DefaultApplicationLogging.CreateLogger<spSP_GetListSampleProps>();
            SettingsWrapper appSettings = await SettingsHelper.GetSettingsWrapperAsync(SETTING_NAMES, assertDefined: false);
            double timeoutSeconds = appSettings.GetDoubleOrDefault(SETTING_TIMEOUT, DEFAULT_TIMEOUT, logger);
            int retries = appSettings.GetIntOrDefault(SETTING_RETRIES, DEFAULT_RETRIES, logger);
            double baseRetryDelaySeconds = appSettings.GetDoubleOrDefault(SETTING_BASE_RETRY_DELAY, DEFAULT_BASE_RETRY_DELAY, logger);
            spSP_GetListSampleProps instance = new spSP_GetListSampleProps(logger, new TimeoutSettings(timeoutSeconds), new RetrySettings(retries, baseRetryDelaySeconds));
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<spSP_GetListSampleProps> logger;

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        /// <summary>
        /// Constructor. 
        /// Note that a static helper class has been provided instead to create an instance using settings from
        /// dwAppSettings 
        /// </summary>
        public spSP_GetListSampleProps(
            ILogger<spSP_GetListSampleProps> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_GetSingleResponseData) + $"[{nameof(Settings)}={Settings}, {nameof(RetrySettings)}={RetryConfiguration}]";
        }

        /// <summary>
        /// Returns a List of Dictionarys with keys ListPropId and PropValue for the specified ListSampleId.
        /// If there are none (including invalid id) then list returned is empty, never null.
        /// Exceptions that occur will be wrapped and thrown in a GetListSamplePropsException
        /// </summary>
        public async Task<List<Dictionary<string, object>>> ForListSample(Guid listSampleId)
        {
            return await ExecuteAsync(listSampleId);
        }

        private async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid listSampleId)
        {

            //TODO - given this is called thousands of times in a tight loop we should consider bypassing 
            //       the IDbProvider and using the connection directly with SqlClient ourselves

            if (Guid.Empty.Equals(listSampleId)) throw new ArgumentException(nameof(listSampleId));

            int currentRetryDelayMs = RetryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = RetryConfiguration.Retries;
            while (true) //will exit loop via short-cicuit return on success or exceeding retries count in the catch block
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                try
                {
                    
                    Dictionary<string, object> spParams = new Dictionary<string, object>
                    {
                        {"ListSampleId", listSampleId },
                    };

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ExecuteAsync) + " - executing procedure with spParams={1}, timeout={2} seconds", spParams, Settings.TimeoutSecondsRoundedUp);
                    }

                    List<Dictionary<string, object>> items
                        = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_GetListSampleProps,
                            spParams,
                            new Dictionary<string, object>(),
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (logger.IsEnabled(LogLevel.Trace)) //trace rather than debug as this is called per-response
                    {
                        
                        logger.LogTrace(nameof(ForListSample) + " - retrieved for listSampleId={0}, duration={1} ms", listSampleId, duration);
                    }

                    const long warningDurationMs = 2000; //Normally would be under 50ms if not blocked/delayed by something
                    if (duration > warningDurationMs && logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(ExecuteAsync) + " - exceeded {0} ms to retrieve {1} rows, listSampleId={2}, duration={3}", warningDurationMs, items.Count, listSampleId, duration);
                    }

                    return items;
                }
                catch (Exception e)
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    //TODO - only attempt retry at procedure level if not inside a transaction
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, dplyId={1}, duration={2}, remainingRetries={3}, message={4}",
                            currentRetryDelayMs,
                            listSampleId,
                            duration,
                            remainingRetries,
                            e.Message);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            //Message is usually enough, so we'll only add the stacktrace in the most verbose logging mode
                            //included the dplyId so can correlate with the warning if there's a lot of other logging happening
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace, respId={0}", listSampleId);
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught exception and will fail, respId={0}, duration={1}, remainingRetries={2}, message={3}",
                            listSampleId,
                            duration,
                            remainingRetries,
                            e.Message);
                        throw new GetListSamplePropsException(listSampleId, e, duration);
                    }
                }
            } //end retry loop
        }
    }
}
