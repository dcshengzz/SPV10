using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class spSP_UpdateQnnRespAns
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_UpdateQnnRespAns + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;

        public const double DEFAULT_TIMEOUT = 30;

        public class UpdateQnnRespAnsException : Exception
        {
            public UpdateQnnRespAnsException(Exception innerException)
                : base("Unexpected exception updating answers", innerException) { }
        }

        public static async Task<spSP_UpdateQnnRespAns> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_UpdateQnnRespAns> logger
                = (ILogger<spSP_UpdateQnnRespAns>)DefaultApplicationLogging.CreateLogger<spSP_UpdateQnnRespAns>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_UpdateQnnRespAns,
                defaultTimeoutSeconds: 30,
                logger: logger);

            spSP_UpdateQnnRespAns instance = new spSP_UpdateQnnRespAns(logger, settings);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<spSP_UpdateQnnRespAns> logger;
        public readonly TimeoutSettings Settings;

        public spSP_UpdateQnnRespAns(
            ILogger<spSP_UpdateQnnRespAns> logger,
            TimeoutSettings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public override string ToString()
        {
            return nameof(spSP_UpdateQnnRespAns) + $"[{nameof(Settings)}={Settings}]";
        }

        public async Task ExecuteAsync(
            Guid respId,
            DataTable updatedAnswers,
            AuditBatch auditBatch,
            Guid? structDivisionIdForAudit )
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            if (Guid.Empty.Equals(respId)) throw new ArgumentException(nameof(respId));
            if (updatedAnswers == null) throw new ArgumentNullException(nameof(updatedAnswers));

            Dictionary<string, object> param = new Dictionary<string, object>();
            param["RespId"] = respId;
            param["UpdatedAnswers"] = updatedAnswers;

            param["StructDivisionId"] = structDivisionIdForAudit ?? (object)DBNull.Value;
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

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ExecuteAsync) + " - Called, param={0}", param);
            }

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                        Constants.StoredProcedure.spSP_UpdateQnnRespAns,
                        param,
                        new Dictionary<string, object>(),
                        Settings.TimeoutSecondsRoundedUp);

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogDebug(e, nameof(ExecuteAsync) + " - failed, duration={0}, respId={1}, updatedAnswers.Rows.Count={2}", duration, respId, updatedAnswers.Rows.Count);
                throw new UpdateQnnRespAnsException(e);
            }
        } //end of ExecuteAsync
    }
}
