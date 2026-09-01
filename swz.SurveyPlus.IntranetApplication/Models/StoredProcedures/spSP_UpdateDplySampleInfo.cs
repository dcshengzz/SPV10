using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class spSP_UpdateDplySampleInfo
    {
        public class UpdateDplySampleInfoException : Exception
        {
            public UpdateDplySampleInfoException(Exception innerException)
                : base("Failed to update QNN_DPLY_SAMPLE_INFO", innerException) { }
        }

        public static async Task<spSP_UpdateDplySampleInfo> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_UpdateDplySampleInfo> logger
                = (ILogger<spSP_UpdateDplySampleInfo>)DefaultApplicationLogging.CreateLogger<spSP_UpdateDplySampleInfo>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_InsertResp,
                defaultTimeoutSeconds: 20,
                logger: logger);

            spSP_UpdateDplySampleInfo instance = new spSP_UpdateDplySampleInfo(logger, settings);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger<spSP_UpdateDplySampleInfo> logger;
        public readonly TimeoutSettings Settings;

        public spSP_UpdateDplySampleInfo(
            ILogger<spSP_UpdateDplySampleInfo> logger,
            TimeoutSettings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public override string ToString()
        {
            return nameof(spSP_UpdateDplySampleInfo) + $"[{nameof(Settings)}={Settings}]";
        }

        //TODO - I don't think its actually necessary to explicitly pass the tx for it to be included in the tx? To check.
        //see #239

        public async Task UpdateDsiStatus(
            Guid id, //qnnDplySampleInfoId
            Guid? structDivisionId,
            QnnStatusId oldStatus,
            QnnStatusId newStatus,
            AuditBatch auditBatch)
        {
            if (auditBatch == null)
                throw new ArgumentNullException(nameof(auditBatch));
            auditBatch.AssertHasUserOrSample();

            await ExecuteAsync(
                //For audit
                auditOn: auditBatch.AuditOn,
                sampleId: auditBatch.HasSample ? auditBatch.SampleId : null,
                structDivisionId: structDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                userId: auditBatch.HasUser ? auditBatch.UserId : null,
                //For the update
                id: id,
                oldStatus: oldStatus,
                newStatus: newStatus);
        }

        /// <summary>
        /// Update the status of a QNN_DPLY_SAMPLE_INFO row and record audit information
        /// </summary>
        /// <param name="transaction"></param>
        /// <param name="id">an id in QNN_DPLY_SAMPLE_INFO (aka dlsi)</param>
        /// <param name="structDivisionId"></param>
        /// <param name="oldStatus"></param>
        /// <param name="newStatus"></param>
        /// <param name="auditBatch"></param>
        /// <returns></returns>
        private async Task ExecuteAsync(
            //For audit
            bool auditOn,
            Guid? sampleId,
            Guid? structDivisionId,
            Guid eventBatch,
            DateTime eventDate,
            Guid? userId,
            //For the update
            Guid id, //qnnDplySampleInfoId            
            QnnStatusId oldStatus,
            QnnStatusId newStatus)
        {
            if (newStatus == null) throw new ArgumentNullException(nameof(newStatus));
            if (oldStatus == null) throw new ArgumentNullException(nameof(oldStatus));

            Dictionary<string, object> param = new Dictionary<string, object>();
            //For audit
            param["AuditOn"] = auditOn;
            param["SampleId"] = sampleId ?? (object)DBNull.Value;
            param["StructDivisionId"] = structDivisionId ?? (object)DBNull.Value;
            param["EventBatch"] = eventBatch;
            param["EventDate"] = eventDate;
            param["UserId"] = userId ?? (object)DBNull.Value;
            //For update
            param["Id"] = id;
            param["OldStatus"] = (oldStatus == null)
                ? (object)DBNull.Value
                : oldStatus.Value; //think this can't be null, but old code checked for it
            param["NewStatus"] = newStatus.Value; //this may never be null

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UpdateDsiStatus) + " - Called, param={0}", param);
            }

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdateDplySampleInfo,
                    param,
                    new Dictionary<string, object>(),
                    Settings.TimeoutSecondsRoundedUp);
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogDebug(e, nameof(ExecuteAsync) + " - failed, duration={0}, id={1}, userId={2}, sampleId={3}, eventBatch={4}, message={5}", duration, id, userId, sampleId, eventBatch, e.Message);
                throw new UpdateDplySampleInfoException(e);
            }
        } //end of ExecuteAsync
    } //end of spSP_UpdateDplySampleInfo
}
