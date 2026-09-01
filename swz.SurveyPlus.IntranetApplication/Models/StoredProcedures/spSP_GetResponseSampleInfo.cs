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
    /// <summary>
    /// Represents a result row from spSP_GetResponseSampleInfo.
    /// This carries information about a sample and zero or one of their responses.
    /// </summary>
    public class ResponseSampleInfo
    {
        /// <summary>
        /// Construct an instance by copying the relevant values out of the supplied dictionary
        /// (Does not keep a reference to the dictionary after construction)
        /// </summary>
        /// <param name="row">a dictionary with values from the results of spSP_GetResponseSampleInfo</param>
        /// <returns>an instance of ResponseSampleInfo class</returns>
        public static ResponseSampleInfo FromDictionary(Dictionary<string, object> row)
        {
            return new ResponseSampleInfo()
            {
                Dlsi = (Guid)row["dlsi"], //TODO - will rename to DplySampleInfoId
                ListSampleId = (Guid)row[Constants.FieldName.ListSampleId],
                UID = (string)row[Constants.FieldName.UID],
                SampleName = (string)row[Constants.FieldName.SampleName],
                ToEmails = (string)DbHelper.DBNullToNull(row[Constants.FieldName.ToEmails]),
                CcEmails = (string)DbHelper.DBNullToNull(row[Constants.FieldName.CcEmails]),
                AddressLine1 = (string)DbHelper.DBNullToNull(row[Constants.FieldName.AddressLine1]),
                AddressLine2 = (string)DbHelper.DBNullToNull(row[Constants.FieldName.AddressLine2]),
                AddressLine3 = (string)DbHelper.DBNullToNull(row[Constants.FieldName.AddressLine3]),
                Status = QnnStatusId.FromGuid((Guid)row[Constants.FieldName.Status]),
                Remarks = (string)DbHelper.DBNullToNull(row[Constants.FieldName.Remarks]),
                HasResponse = (1 == (int)row[Constants.FieldName.HasResponse]),
                RespId = (Guid?)DbHelper.DBNullToNull(row[Constants.FieldName.RespId]),
                IsPrepopulated = (1 == (int?)DbHelper.DBNullToNull(row[Constants.FieldName.IsPrePopulated])),
                UserName = (string)DbHelper.DBNullToNull(row[Constants.FieldName.UserName]),
                DateStart = (DateTime?)DbHelper.DBNullToNull(row[Constants.FieldName.DateStart]),
                DateComplete = (DateTime?)DbHelper.DBNullToNull(row[Constants.FieldName.DateComplete]),
                UpdatedDate = (DateTime?)DbHelper.DBNullToNull(row[Constants.FieldName.UpdatedDate]),
                IpAddress = (string)DbHelper.DBNullToNull(row[Constants.FieldName.IpAddress]),
                InitialResponseAs = (string)DbHelper.DBNullToNull(row[Constants.FieldName.InitialResponseAs]),
                InitialResponseBy = (string)DbHelper.DBNullToNull(row[Constants.FieldName.InitialResponseBy]),
                InitialResponseVia = (string)DbHelper.DBNullToNull(row[Constants.FieldName.InitialResponseVia]),
                InitialResponder = (string)DbHelper.DBNullToNull(row["InitialResponder"]),
                CompletedResponseAs = (string)DbHelper.DBNullToNull(row[Constants.FieldName.CompletedResponseAs]),
                CompletedResponseBy = (string)DbHelper.DBNullToNull(row[Constants.FieldName.CompletedResponseBy]),
                CompletedResponseVia = (string)DbHelper.DBNullToNull(row[Constants.FieldName.CompletedResponseVia]),
                CompletedResponder = (string)DbHelper.DBNullToNull(row["CompletedResponder"]),
                LastResponseAs = (string)DbHelper.DBNullToNull(row[Constants.FieldName.LastResponseAs]),
                LastResponseBy = (string)DbHelper.DBNullToNull(row[Constants.FieldName.LastResponseBy]),
                LastResponseVia = (string)DbHelper.DBNullToNull(row[Constants.FieldName.LastResponseVia]),
                LastResponder = (string)DbHelper.DBNullToNull(row["LastResponder"]),
            };
        }

        // // // // // // // // // // // // // // // // // // // // // //

        public Guid Dlsi { get; private set; }
        public Guid ListSampleId { get; private set; }
        public string UID { get; private set; }
        public string SampleName { get; private set; }
        public string ToEmails { get; private set; }
        public string CcEmails { get; private set; }
        public string AddressLine1 { get; private set; }
        public string AddressLine2 { get; private set; }
        public string AddressLine3 { get; private set; }
        public QnnStatusId Status { get; private set; }
        public string Remarks { get; private set; }
        public bool HasRemarks { get => !string.IsNullOrEmpty(Remarks); }
        public bool HasResponse { get; private set; }
        public Guid? RespId { get; private set; }
        public bool IsPrepopulated { get; private set; }
        public string UserName { get; private set; }
        public DateTime? DateStart { get; private set; }
        public DateTime? DateComplete { get; private set; }
        public DateTime? UpdatedDate { get; private set; }
        public string IpAddress { get; private set; }
        public string InitialResponseAs { get; private set; }
        public string InitialResponseBy { get; private set; }
        public string InitialResponseVia { get; private set; }
        public string InitialResponder { get; private set; }
        public string CompletedResponseAs { get; private set; }
        public string CompletedResponseBy { get; private set; }
        public string CompletedResponseVia { get; private set; }
        public string CompletedResponder { get; private set; }
        public string LastResponseAs { get; private set; }
        public string LastResponseBy { get; private set; }
        public string LastResponseVia { get; private set; }
        public string LastResponder { get; private set; }

        /// <summary>
        /// Constructor is private, please use the provided static factory method to get an instance
        /// </summary>
        private ResponseSampleInfo()
        {
            ;
        }
    }

    public class spSP_GetResponseSampleInfo
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_GetResponseSampleInfo + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;
        public const string SETTING_RETRIES = Constants.StoredProcedure.spSP_GetResponseSampleInfo + RetrySettings.SETTING_RETRIES_POSTFIX;
        public const string SETTING_BASE_RETRY_DELAY = Constants.StoredProcedure.spSP_GetResponseSampleInfo + RetrySettings.SETTING_BASE_RETRY_DELAY_POSTFIX;

        public const double DEFAULT_TIMEOUT = 60;
        public const int DEFAULT_RETRIES = 5;
        public const double DEFAULT_BASE_RETRY_DELAY = 15;

        private static readonly ImmutableList<String> SETTING_NAMES = new List<string> {
            SETTING_TIMEOUT,
            SETTING_RETRIES,
            SETTING_BASE_RETRY_DELAY
        }.ToImmutableList();

        public class GetResponseSampleInfoException : Exception
        {
            public Guid DplyId { get; private set; }
            public long Duration { get; private set; }

            public GetResponseSampleInfoException(Guid dplyId, Exception innerException, long duration)
                : base($"Failed to get response sample info for dplyId={dplyId}, duration={duration} ms", innerException)
            {
                this.DplyId = dplyId;
                this.Duration = duration;
            }
        }

        public static async Task<spSP_GetResponseSampleInfo> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_GetResponseSampleInfo> logger 
                = (ILogger<spSP_GetResponseSampleInfo>)DefaultApplicationLogging.CreateLogger<spSP_GetResponseSampleInfo>();
            SettingsWrapper appSettings
                = await SettingsHelper.GetSettingsWrapperAsync(SETTING_NAMES, assertDefined: false);
            double timeoutSeconds = appSettings.GetDoubleOrDefault(SETTING_TIMEOUT, DEFAULT_TIMEOUT, logger);
            int retries = appSettings.GetIntOrDefault(SETTING_RETRIES, DEFAULT_RETRIES, logger);
            double baseRetryDelaySeconds = appSettings.GetDoubleOrDefault(SETTING_BASE_RETRY_DELAY, DEFAULT_BASE_RETRY_DELAY, logger);
            spSP_GetResponseSampleInfo instance = new spSP_GetResponseSampleInfo(logger, new TimeoutSettings(timeoutSeconds), new RetrySettings(retries, baseRetryDelaySeconds));
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }

            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;
        public readonly RetrySettings RetryConfiguration;

        private readonly ILogger<spSP_GetResponseSampleInfo> logger;

        /// <summary>
        /// Constructor. 
        /// Note that a static helper class has been provided instead to create an instance using settings from
        /// dwAppSettings 
        /// </summary>
        public spSP_GetResponseSampleInfo(
            ILogger<spSP_GetResponseSampleInfo> logger,
            TimeoutSettings settings,
            RetrySettings retryConfiguration)
        {
            
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.RetryConfiguration = retryConfiguration ?? throw new ArgumentNullException(nameof(retryConfiguration));
        }

        public override string ToString()
        {
            return nameof(spSP_GetResponseSampleInfo) + $"[{nameof(Settings)}={Settings}, {nameof(RetryConfiguration)}={RetryConfiguration}]";
        }

        public async Task<List<ResponseSampleInfo>> ForDeployment(Guid dplyId)
        {
            //Copy to ResponseSample objects that
            // a) Provide a typesafe representation of the information and are more convenient to use
            // b) Let us immediatey free up all these dictionaries and their associated overhead for GC
            return (await ExecuteAsync(dplyId))
                .Select(row => ResponseSampleInfo.FromDictionary(row))
                .ToList();
        }

        private async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid dplyId)
        {
            if (Guid.Empty.Equals(dplyId)) throw new ArgumentException(nameof(dplyId));

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
                            Constants.StoredProcedure.spSP_GetResponseSampleInfo,
                            spParams,
                            new Dictionary<string, object>(),
                            Settings.TimeoutSecondsRoundedUp);

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    if (logger.IsEnabled(LogLevel.Debug)) //debug isn't too cluttery as we only get called once per export job
                    {
                        logger.LogDebug(nameof(ExecuteAsync) + " - retrieved {0} rows for dplyId={1}, duration={2} ms", items.Count, dplyId, duration);
                    }

                    const long warningDurationMs = 5000;
                    if(duration > warningDurationMs && logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(ExecuteAsync) + " - exceeded {0} ms to retrieve {1} rows, dplyId={2}, duration={3}", warningDurationMs, items.Count, dplyId, duration); 
                    }

                    return items;
                }
                catch (Exception e)
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    //TODO - only retry at this level if not in a tx
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
                        throw new GetResponseSampleInfoException(dplyId, e, duration);
                    }
                }
            } //end retry loop
        }
    }
}
