using System;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System.Threading.Tasks;
using System.Linq;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System.Collections.Immutable;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    /// <summary>
    /// Gets answer data for a single response, used by SurveyResponseReader and SurveyResponseUpdater
    /// Note that we also have the similar spSP_GetSingleResponseData which is used by the exporter (but that one
    /// returns keyed by fieldId).
    /// Note that the dictionary returned is mutable (and we expect reader / updater to mutate it).
    /// </summary>
    public class spSP_GetRespAnsRows
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_GetRespAnsRows + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;
        public const string SETTING_RETRIES = Constants.StoredProcedure.spSP_GetRespAnsRows + RetrySettings.SETTING_RETRIES_POSTFIX;
        public const string SETTING_BASE_RETRY_DELAY = Constants.StoredProcedure.spSP_GetRespAnsRows + RetrySettings.SETTING_BASE_RETRY_DELAY_POSTFIX;

        public const double DEFAULT_TIMEOUT = 30;
        public const int DEFAULT_RETRIES = 3;
        public const double DEFAULT_BASE_RETRY_DELAY = 5;

        private static readonly ImmutableList<String> SETTING_NAMES = new List<string> {
            SETTING_TIMEOUT,
            SETTING_RETRIES,
            SETTING_BASE_RETRY_DELAY
        }.ToImmutableList();

        public class Result
        {
            public Guid RespId { get; private set; }
            public int NumberId { get; private set; }
            public string LastSavedPage { get; private set; }            
            public ISet<string> PrePopulatedAliases { get; private set; }

            public bool HasAnswers { get => Answers?.Any()??false; }
            public Dictionary<string, object> Answers { get; private set; }

            public Result(Guid respId, int numberId, string lastSavedPage, ISet<string>prePopulatedAliases, Dictionary<string,object> answers)
            {
                this.RespId = respId;
                this.NumberId = numberId;
                this.LastSavedPage = lastSavedPage;
                this.PrePopulatedAliases = prePopulatedAliases;
                this.Answers = answers;
            }
        }

        public class GetRespAnsRowsException : Exception
        {
            public GetRespAnsRowsException(Guid respId, long duration, Exception innerException)
                : base($"{Constants.StoredProcedure.spSP_GetRespAnsRows} encountered an error for respId={respId}, duration={duration} ms", innerException) { }
        }

        public static async Task<spSP_GetRespAnsRows> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_GetRespAnsRows> logger
                = (ILogger<spSP_GetRespAnsRows>)DefaultApplicationLogging.CreateLogger<spSP_GetRespAnsRows>();
            SettingsWrapper appSettings
                = await SettingsHelper.GetSettingsWrapperAsync(SETTING_NAMES, assertDefined: false);
            double timeoutSeconds = appSettings.GetDoubleOrDefault(SETTING_TIMEOUT, DEFAULT_TIMEOUT, logger);
            int retries = appSettings.GetIntOrDefault(SETTING_RETRIES, DEFAULT_RETRIES, logger);
            double baseRetryDelaySeconds = appSettings.GetDoubleOrDefault(SETTING_BASE_RETRY_DELAY, DEFAULT_BASE_RETRY_DELAY, logger);
            spSP_GetRespAnsRows instance = new spSP_GetRespAnsRows(logger, new TimeoutSettings(timeoutSeconds), new RetrySettings(retries, baseRetryDelaySeconds));
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        private readonly ILogger<spSP_GetRespAnsRows> logger;
        
        public spSP_GetRespAnsRows(
            ILogger<spSP_GetRespAnsRows> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_GetRespAnsRows) + $"[{nameof(Settings)}={Settings}, {nameof(RetryConfiguration)}={RetryConfiguration}]";
        }

        /// <summary>
        /// Specifies what to include in the dictionary of answer data
        /// </summary>
        public enum Include 
        { 
            /// <summary>
            /// Only include answer values in dictionary
            /// </summary>
            ResponseDataOnly, 

            /// <summary>
            /// Will add RespId, LastSavedPage, NumberId to the dictionary
            /// </summary>
            ResponseDataAndMetainfo
        }

        /// <summary>
        /// Get response data for the specified response given the RespId.
        /// n.b. if there is no data in QNN_RESP_ANS this will return null to indicate this
        /// </summary>
        /// <param name="respId">The reponse Id</param>
        /// <param name="include">if ResponseDataAndMetainfo will add RespId, LastSavedPage, NumberId to the dictionary too</param>
        public async Task<Result> ExecuteAsync(Guid respId, Include include)
        {
            Dictionary<string, object> spParams = new Dictionary<string, object>
            {
                {"RespId", respId}
            };

            Dictionary<string, object> outParams = new Dictionary<string, object>()
            {
                {"LastSavedPage", "" },
                {"NumberId", 0 }
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
                    List<Dictionary<string, object>> items
                        = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_GetRespAnsRows,
                            spParams,
                            outParams,
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (duration > 10000)
                    {
                        //On an unencumbered db server is almost instant, any waiting is due to waits on locks and grants
                        logger.LogWarning(nameof(ExecuteAsync) + " - completed in {0} ms (over 10 seconds) for spParams={1}, returning {2} rows",
                            duration,
                            spParams,
                            items?.Count);
                    }
                    else if (logger.IsEnabled(LogLevel.Debug))
                    {

                        logger.LogDebug(nameof(ExecuteAsync) + " - completed in {0} ms for spParams={1}, returning {2} answer rows",
                            duration,
                            spParams,
                            items?.Count);
                    }

                    if(!items.Any())
                    {
                        return null;
                    }
                    else
                    {
                        Dictionary<string, object> answers 
                            = items.ToDictionary(
                                ans => (string)ans["Name"],
                                ans => (object)(DBNull.Value.Equals(ans["AnsVal"]) ? null : ans["AnsVal"]),
                                Constants.Comparers.AliasCaseInsensitive);

                        ISet<string> prePopulatedAliases
                            = items
                            .Where(ans => (bool)ans["IsPrePopulated"])
                            .Select(ans => (string)ans["Name"])
                            .ToImmutableHashSet(Constants.Comparers.AliasCaseInsensitive);

                        int numberId = (int)outParams["NumberId"];
                        string lastSavedPage = DBNull.Value.Equals(outParams["LastSavedPage"]) 
                            ? null 
                            : (string)outParams["LastSavedPage"];

                        if (Include.ResponseDataAndMetainfo == include)
                        {
                            answers["RespId"] = respId;
                            answers["LastSavedPage"] = lastSavedPage;
                            answers["NumberId"] = numberId;
                        }

                        return new Result(respId, numberId, lastSavedPage, prePopulatedAliases, answers);
                    }
                }
                catch (Exception e)
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    //todo - only retry if not inside a tx
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(e, nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, duration={1}, respId={2}", currentRetryDelayMs, duration, respId);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace");
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, duration={0}, respId={2}", duration, respId);
                        throw new GetRespAnsRowsException(respId, duration, e);
                    }
                }
            } //end retry loop
        }
    }
}
