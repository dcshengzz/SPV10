using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetSampleIdentity
    {
        public const double DEFAULT_TIMEOUT = 15;
        public const int DEFAULT_RETRIES = 2;
        public const double DEFAULT_BASE_RETRY_DELAY = 5;

        public class GetSampleIdentityException : Exception
        {
            public GetSampleIdentityException(Exception innerException)
                : base("Unexpected exception retrieving sample information from database", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetSampleIdentity));

        public static async Task<(Guid SampleId, string Uid)>FromListSampleId(Guid listSampleId)
        {
            Dictionary<string, object> result = await ExecuteAsync(listSampleId, null);
            if (result == null) 
                throw new NotFoundException($"Failed to get sample identity with ListSampleId={listSampleId}");
            return AsTuple(result);
        }

        public static async Task<(Guid SampleId, string Uid)> FromDplySampleInfoId(Guid dplySampleInfoId)
        {
            Dictionary<string, object> result = await ExecuteAsync(null, dplySampleInfoId);
            if (result == null)
                throw new NotFoundException($"Failed to get sample identity with DplySampleInfoId={dplySampleInfoId}");
            return AsTuple(result);
        }

        private static (Guid SampleId, string Uid) AsTuple(Dictionary<string, object> result)
        {
            return ((Guid)result["SampleId"], (string)result["UID"]);
        }

        private static async Task<Dictionary<string, object>> ExecuteAsync(
            Guid? listSampleId, 
            Guid? dplySampleInfoId)
        {
            //We have hardcoded the timeout & retry settings for this procedure
            //to avoid the extra overhead of getting from db
            TimeoutSettings settings = new TimeoutSettings(
                timeoutSeconds: DEFAULT_TIMEOUT);

            RetrySettings retryConfiguration = new RetrySettings(
                retries: DEFAULT_RETRIES,
                baseRetryDelaySeconds: DEFAULT_BASE_RETRY_DELAY);

            int currentRetryDelayMs = retryConfiguration.BaseRetryDelayMilliseconds;
            int remainingRetries = retryConfiguration.Retries;
            while (true) //will exit loop via short-cicuit return on success or exceeding retries count in the catch block
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                try
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ExecuteAsync) + " - Called, listSampleId={0}, dplySampleInfoId={1}", listSampleId, dplySampleInfoId);
                    }

                    Dictionary<string, object> spParams = new Dictionary<string, object>();
                    spParams.Add("ListSampleId", listSampleId ?? (object)DBNull.Value);
                    spParams.Add("DplySampleInfoId", dplySampleInfoId ?? (object)DBNull.Value);

                    Dictionary<string, object> result
                        = (await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                            Constants.StoredProcedure.spSP_GetSampleIdentity,
                            spParams,
                            new Dictionary<string, object>(),
                            settings.TimeoutSecondsRoundedUp))
                        .FirstOrDefault();

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                        logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}, found={1}", duration, (result != null));
                    }

                    return result;
                }
                catch (Exception e)
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    //TODO - only retry if in a tx
                    bool doRetry = remainingRetries > 0 && DbHelper.IsStatementRetryable(e);
                    if (doRetry)
                    {
                        remainingRetries--;
                        logger.LogWarning(e, nameof(ExecuteAsync) + " - caught exception but will retry in {0} ms, duration={1}, listSampleId={2}, dplySampleInfoId={3}", currentRetryDelayMs, duration, listSampleId, dplySampleInfoId);
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            logger.LogTrace(e, nameof(ExecuteAsync) + " - exception with stacktrace");
                        }
                        await Task.Delay(currentRetryDelayMs);
                        currentRetryDelayMs *= 2; //if it fails again the next retry delay will be twice as long
                    }
                    else
                    {
                        logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, duration={0}, listSampleId={1}, dplySampleInfoId={2}", duration, listSampleId, dplySampleInfoId);
                        throw new GetSampleIdentityException(e);
                    }
                }
            } //end retry loop
        }
    }
}
