using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    /// <summary>
    /// Get data for a single response.
    /// This is similar to spSP_GetRespAnsRows but doesn't have a join to fetch the alias.
    /// </summary>
    public class spSP_GetSingleResponseData
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_GetSingleResponseData + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;

        public const double DEFAULT_TIMEOUT = 30;
        public const int DEFAULT_RETRIES = 3;
        public const double DEFAULT_BASE_RETRY_DELAY_SECONDS = 20;

        public class GetSingleResponseDataException : Exception
        {
            public Guid RespId { get; private set; }
            public long Duration { get; private set; }

            public GetSingleResponseDataException(Guid respId, Exception innerException, long duration)
                : base($"Failed to get response answers for respId={respId}, duration={duration} ms", innerException)
            {
                this.RespId = respId;
                this.Duration = duration;
            }
        }

        public static async Task<spSP_GetSingleResponseData> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_GetSingleResponseData> logger = (ILogger<spSP_GetSingleResponseData>)DefaultApplicationLogging.CreateLogger<spSP_GetSingleResponseData>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_GetSingleResponseData,
                defaultTimeoutSeconds: DEFAULT_TIMEOUT,
                logger: logger);

            RetrySettings retryConfiguration = await RetrySettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_GetSingleResponseData,
                defaultRetries: DEFAULT_RETRIES,
                defaultBaseRetryDelaySeconds: DEFAULT_BASE_RETRY_DELAY_SECONDS,
                logger: logger);

            spSP_GetSingleResponseData instance = new spSP_GetSingleResponseData(logger, settings, retryConfiguration);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<spSP_GetSingleResponseData> logger;

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        /// <summary>
        /// Constructor. 
        /// Note that a static helper class has been provided instead to create an instance using settings from
        /// dwAppSettings 
        /// </summary>
        public spSP_GetSingleResponseData(
            ILogger<spSP_GetSingleResponseData> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            //TODO - removal of statement level retries, or impl it to only retry if no tx
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_GetSingleResponseData) + $"[{nameof(Settings)}={Settings}, {nameof(RetryConfiguration)}={RetryConfiguration}]";
        }

        /// <summary>
        /// Returns a list of dictionary each with keys "QnnFieldId", and "AnsVal" and "Id".
        /// Values under QnnFieldId will always be Guid, those under AnsVal can be string or DbNull
        /// </summary>
        public async Task<List<Dictionary<string, object>>> ForResponse(Guid respId)
        {
            return await ExecuteAsync(respId);
        }

        private async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid respId)
        {

            //TODO - given this is called thousands of times in a tight loop (for response exporter)
            //we should consider bypassing the IDbProvider and using the connection directly ourselves

            if (Guid.Empty.Equals(respId)) throw new ArgumentException(nameof(respId));

            int currentRetryDelayMs = RetryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = RetryConfiguration.Retries;
            while (true) //will exit loop via short-cicuit return on success or exceeding retries count in the catch block
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

                try
                {
                    Dictionary<string, object> spParams = new Dictionary<string, object>
                    {
                        {"RespId", respId},
                    };

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ExecuteAsync) + " - executing procedure with spParams={1}, timeout={2} seconds", spParams, Settings.TimeoutSecondsRoundedUp);
                    }

                    List<Dictionary<string, object>> items
                        = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_GetSingleResponseData,
                            spParams,
                            new Dictionary<string, object>(),
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (logger.IsEnabled(LogLevel.Trace)) //trace rather than debug as we get called per-response
                    {
                        
                        logger.LogTrace(nameof(ForResponse) + " - retrieved {0} answers for respId={1}, duration={2} ms", items.Count, respId, duration);
                    }

                    const long warningDurationMs = 2000; //Normally would be under 50ms if not blocked/delayed by something
                    if (duration > warningDurationMs && logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(ExecuteAsync) + " - exceeded {0} ms to retrieve {1} rows, respId={2}, duration={3}", warningDurationMs, items.Count, respId, duration);
                    }
                    return items;
                }
                catch (Exception e)
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    //TODO - should only do procedure level retries if not in a TX
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, dplyId={1}, duration={2}, remainingRetries={3}, message={4}",
                            currentRetryDelayMs,
                            respId,
                            duration,
                            remainingRetries,
                            e.Message);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            //Message is usually enough, so we'll only add the stacktrace in the most verbose logging mode
                            //included the dplyId so can correlate with the warning if there's a lot of other logging happening
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace, respId={0}", respId);
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught exception and will fail, respId={0}, duration={1}, remainingRetries={2}, message={3}",
                            respId,
                            duration,
                            remainingRetries,
                            e.Message);
                        throw new GetSingleResponseDataException(respId, e, duration);
                    }
                }
            } //end retry loop
        }
    }
}