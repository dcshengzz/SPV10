using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class spSP_UpdateResp
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_UpdateResp + TimeoutSettings.SETTING_TIMEOUT_POSTFIX;

        public const double DEFAULT_TIMEOUT = 20;

        public class UpdateRespException : Exception
        {
            public UpdateRespException(Exception innerException)
                : base("Unexpected exception updating response", innerException) { }
        }

        public static async Task<spSP_UpdateResp> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_UpdateResp> logger
                = (ILogger<spSP_UpdateResp>)DefaultApplicationLogging.CreateLogger<spSP_UpdateResp>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_InsertResp,
                defaultTimeoutSeconds: DEFAULT_TIMEOUT,
                logger: logger);

            spSP_UpdateResp instance = new spSP_UpdateResp(logger, settings);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;

        private readonly ILogger<spSP_UpdateResp> logger;
        
        public spSP_UpdateResp(
            ILogger<spSP_UpdateResp> logger,
            TimeoutSettings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public override string ToString()
        {
            return nameof(spSP_UpdateResp) + $"[{nameof(Settings)}={Settings}]";
        }

        public async Task PrePopulate(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            Guid existingRespId,
            string strata)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            if (auditBatch.HasSample) throw new ArgumentException("SampleId is present in AuditBatch", nameof(auditBatch));
            if (!auditBatch.HasUser) throw new ArgumentException("UserId absent in AuditBatch", nameof(auditBatch));

            await ExecuteAsync(
                auditOn: auditBatch.AuditOn,
                sampleId: null,
                structDivisionId: auditStructDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                auditUserId: auditBatch.UserId,
                id: existingRespId,
                updatedDate: DateTime.Now,
                dateStart: null,
                dateComplete: null,
                isPrePopulated: true,
                lastSavedPage: null,
                ipAddress: null,
                initialResponseAs: Constants.ResponseAs.PrePopulated,
                initialResponseBy: Constants.ResponseBy.Unknown, //the response hasn't started yet
                initialResponseVia: Constants.ResponseVia.Unknown,
                initialResponseUserId: auditBatch.UserId,
                lastResponseAs: Constants.ResponseAs.PrePopulated,
                lastResponseBy: Constants.ResponseBy.Editor, //technically its a survey admin (rather than editor)
                lastResponseVia: Constants.ResponseVia.Online,
                userId: auditBatch.UserId,
                completedResponseAs: null,
                completedResponseBy: null,
                completedResponseVia: null,
                completedResponseUserId: null,
                strata: strata);
        }

        public async Task UpdateResponse(
            AuditBatch auditBatch,
            Guid? auditStructDivisionId,  //can be null for sample
            Guid existingRespId,
            DateTime updatedDate,
            DateTime? dateStart,
            DateTime? dateComplete,
            string lastSavedPage,
            string ipAddress,
            string initialResponseAs,
            string initialResponseBy,
            string initialResponseVia,
            Guid? initialResponseUserId,
            string lastResponseAs,
            string lastResponseBy,
            string lastResponseVia,
            Guid? userId, //functions as LastResponseUserId 
            string completedResponseAs,
            string completedResponseBy,
            string completedResponseVia,
            Guid? completedResponseUserId,
            string strata)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            auditBatch.AssertHasUserOrSample();

            await ExecuteAsync(
                auditOn: auditBatch.AuditOn,
                sampleId: auditBatch.HasSample ? auditBatch.SampleId : null,
                structDivisionId: auditStructDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                auditUserId: auditBatch.HasUser ? auditBatch.UserId : null,
                id: existingRespId,
                updatedDate: updatedDate,
                dateStart: dateStart,
                dateComplete: dateComplete,
                isPrePopulated: false,
                lastSavedPage: lastSavedPage,
                ipAddress: ipAddress,
                initialResponseAs: initialResponseAs,
                initialResponseBy: initialResponseBy,
                initialResponseVia: initialResponseVia,
                initialResponseUserId: initialResponseUserId,
                lastResponseAs: lastResponseAs,
                lastResponseBy: lastResponseBy,
                lastResponseVia: lastResponseVia,
                userId: userId,
                completedResponseAs: completedResponseAs,
                completedResponseBy: completedResponseBy,
                completedResponseVia: completedResponseVia,
                completedResponseUserId: completedResponseUserId,
                strata: strata);
        }

        private async Task ExecuteAsync(
            //For audit
            bool auditOn,
            Guid? sampleId,
            Guid? structDivisionId,
            Guid eventBatch,
            DateTime eventDate,
            Guid? auditUserId,
            //For the update
            Guid id,
            DateTime? updatedDate,
            DateTime? dateStart,           
            DateTime? dateComplete,   
            bool isPrePopulated,
            string lastSavedPage,
            string ipAddress,            
            string initialResponseAs,
            string initialResponseBy,
            string initialResponseVia,
            Guid? initialResponseUserId,
            string lastResponseAs,
            string lastResponseBy,
            string lastResponseVia,
            Guid? userId, //functions as LastResponseUserId 
            string completedResponseAs,
            string completedResponseBy,
            string completedResponseVia,
            Guid? completedResponseUserId,
            string strata)
        {
            //TODO - why is there no anonymousId for update? is this by design?

            if (string.IsNullOrEmpty(initialResponseAs)) throw new ArgumentException(nameof(initialResponseAs));
            if (string.IsNullOrEmpty(initialResponseBy)) throw new ArgumentException(nameof(initialResponseBy));
            if (string.IsNullOrEmpty(initialResponseVia)) throw new ArgumentException(nameof(initialResponseVia));
            if (string.IsNullOrEmpty(lastResponseAs)) throw new ArgumentException(nameof(lastResponseAs));
            if (string.IsNullOrEmpty(lastResponseBy)) throw new ArgumentException(nameof(lastResponseBy));
            if (string.IsNullOrEmpty(lastResponseVia)) throw new ArgumentException(nameof(lastResponseVia));

            //nb: the completedResponseXXX values may be null (even if DateComplete is set we still have legacy data without these values)

            Dictionary<string, object> updateRespParams = new Dictionary<string, object>();
            //Audit related params
            updateRespParams["AuditOn"] = auditOn;
            updateRespParams["SampleId"] = sampleId ?? (object)DBNull.Value;
            updateRespParams["StructDivisionId"] = structDivisionId ?? (object)DBNull.Value;
            updateRespParams["EventBatch"] = eventBatch;
            updateRespParams["EventDate"] = eventDate;
            updateRespParams["AuditUserId"] = auditUserId ?? (object)DBNull.Value;
            //Values for the QNN_RESP update
            updateRespParams["Id"] = id;
            updateRespParams["UpdatedDate"] = updatedDate ?? (object)DBNull.Value;
            updateRespParams["DateStart"] = dateStart ?? (object)DBNull.Value;
            updateRespParams["DateComplete"] = dateComplete ?? (object)DBNull.Value;
            updateRespParams["IsPrePopulated"] = isPrePopulated;
            updateRespParams["LastSavedPage"] = lastSavedPage ?? (object)DBNull.Value;
            updateRespParams["IpAddress"] = ipAddress ?? (object)DBNull.Value;
            updateRespParams["InitialResponseAs"] = initialResponseAs; //no longer nullable in v8
            updateRespParams["InitialResponseBy"] = initialResponseBy; //no longer nullable in v8
            updateRespParams["InitialResponseVia"] = initialResponseVia; //no longer nullable in v8
            updateRespParams["InitialResponseUserId"] = initialResponseUserId ?? (object)DBNull.Value;
            updateRespParams["LastResponseAs"] = lastResponseAs;
            updateRespParams["LastResponseVia"] = lastResponseVia;
            updateRespParams["LastResponseBy"] = lastResponseBy;
            updateRespParams["UserId"] = userId ?? (object)DBNull.Value; //consider as LastResponseUserId
            updateRespParams["CompletedResponseAs"] = completedResponseAs ?? (object)DBNull.Value;
            updateRespParams["CompletedResponseVia"] = completedResponseVia ?? (object)DBNull.Value;
            updateRespParams["CompletedResponseBy"] = completedResponseBy ?? (object)DBNull.Value;
            updateRespParams["CompletedResponseUserId"] = completedResponseUserId ?? (object)DBNull.Value;
            updateRespParams["Strata"] = strata ?? (object)DBNull.Value;

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ExecuteAsync) + " - Called, updateRespParams={0}", updateRespParams);
            }

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdateResp,
                    updateRespParams,
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
                logger.LogDebug(e, nameof(ExecuteAsync) + " - failed, duration={0}, id={1}, userId={2}, sampleId={3}, eventBatch={4}", duration, id, userId, sampleId, eventBatch);
                throw new UpdateRespException(e);
            }
        } //end of ExecuteAsync
    } 
}
