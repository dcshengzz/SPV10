using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class spSP_DeleteAllRespAnsByRespId
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_DeleteAllRespAnsByRespId + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;

        public const double DEFAULT_TIMEOUT = 15;

        public class DeleteAllRespAnsByRespIdException : Exception
        {
            public Guid RespId { get; private set; }
            public long Duration { get; private set; }

            public DeleteAllRespAnsByRespIdException(Guid respId, Exception innerException, long duration)
                : base($"Failed to delete answers for RespId={respId}, duration={duration}", innerException)
            {
                this.RespId = respId;
                this.Duration = duration;
            }
        }

        public static async Task<spSP_DeleteAllRespAnsByRespId> GetInstanceUsingAppSettingsAsync()
        { 
            ILogger<spSP_DeleteAllRespAnsByRespId> logger = (ILogger<spSP_DeleteAllRespAnsByRespId>)DefaultApplicationLogging.CreateLogger<spSP_DeleteAllRespAnsByRespId>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_DeleteAllRespAnsByRespId, 
                defaultTimeoutSeconds: DEFAULT_TIMEOUT,
                logger: logger);

            spSP_DeleteAllRespAnsByRespId instance = new spSP_DeleteAllRespAnsByRespId(logger, settings);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        public readonly TimeoutSettings Settings;

        private readonly ILogger<spSP_DeleteAllRespAnsByRespId> logger;

        /// <summary>
        /// Constructor. 
        /// Note that a static helper class has been provided to create an instance using settings from dwAppSettings 
        /// </summary>
        public spSP_DeleteAllRespAnsByRespId(
            ILogger<spSP_DeleteAllRespAnsByRespId> logger,
            TimeoutSettings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public override string ToString()
        {
            return nameof(spSP_DeleteAllRespAnsByRespId) + $"[{nameof(Settings)}={Settings}]";
        }

        /// <summary>
        /// Calls the stored procedure. Any exceptions encountered will be logged and rethrown. 
        /// Note, following existing logic,if a user is provided in the audit batch then the sample will be recorded as null here.
        /// </summary>=
        public async Task DeleteResp( 
            Guid qnnRespId, 
            Guid? structDivisionId, 
            AuditBatch auditBatch)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            auditBatch.AssertHasUserOrSample();
            Dictionary<string, object> param = new Dictionary<string, object>();
            param["RespId"] = qnnRespId; //This is the business logic one, remaining param values are only used for audit
            param["StructDivisionId"] = structDivisionId ?? (object)DBNull.Value;
            param["EventBatch"] = auditBatch.EventBatch;
            param["EventDate"] = DateTime.Now;
            param["AuditOn"] = auditBatch.AuditOn;
            if (auditBatch.HasUser)
            {
                //If a user is supplied then we don't record the sample id
                //(Here user would be a data editor)
                param["UserId"] = auditBatch.UserId;
                param["SampleId"] = DBNull.Value;
            }
            else
            {
                //Only record sampleId if the user id was not supplied
                param["UserId"] = DBNull.Value;
                param["SampleId"] = auditBatch.SampleId;
            }
            await ExecuteAsync(param);
        } //end of DeleteResp

        private async Task ExecuteAsync(Dictionary<string, object> param)
        {
            if (param == null) throw new ArgumentNullException(nameof(param));
            if (!param.ContainsKey("RespId")) throw new ArgumentException("RespId must be specified", nameof(param));
            Guid respId = (Guid)param["RespId"];

            if (param == null || param.Count == 0)
            {
                throw new ArgumentException("param must be specified", "param");
            }

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - executing procedure with respId={0}, param={1}, timeout={2} seconds", respId, param, Settings.TimeoutSecondsRoundedUp);
                }

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_DeleteAllRespAnsByRespId,
                    param,
                    new Dictionary<string, object>(),
                    Settings.TimeoutSecondsRoundedUp);

                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                if (duration > 10000 && logger.IsEnabled(LogLevel.Warning))
                {
                    logger.LogWarning(nameof(ExecuteAsync) + " - took over 10 seconds! - completed in {0} ms for param={1}", duration, param);
                }
                else if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - completed in {0} ms for param={1}", duration, param);
                }

                return; //Exit now (or will retry forever!)
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogDebug(e, nameof(ExecuteAsync) + " - failed, duration={0}, message={1}, respId={2}", duration, e.Message, respId);
                throw new DeleteAllRespAnsByRespIdException(respId, e, duration);
            }
        }
    }
}
