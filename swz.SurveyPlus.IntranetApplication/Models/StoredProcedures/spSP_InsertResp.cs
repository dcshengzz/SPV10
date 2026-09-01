using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class spSP_InsertResp
    {
        public const string SETTING_TIMEOUT = Constants.StoredProcedure.spSP_InsertResp+TimeoutSettings.SETTING_TIMEOUT_POSTFIX;

        public const double DEFAULT_TIMEOUT = 20;

        public class InsertRespException : Exception
        {
            public InsertRespException(Exception innerException)
                : base("Failed to insert response row", innerException) { }
        }

        public static async Task<spSP_InsertResp> GetInstanceUsingAppSettingsAsync()
        {
            ILogger<spSP_InsertResp> logger 
                = (ILogger<spSP_InsertResp>)DefaultApplicationLogging.CreateLogger<spSP_InsertResp>();

            TimeoutSettings settings = await TimeoutSettings.GetInstanceUsingAppSettingsAsync(
                baseName: Constants.StoredProcedure.spSP_InsertResp,
                defaultTimeoutSeconds: DEFAULT_TIMEOUT,
                logger: logger);

            spSP_InsertResp instance = new spSP_InsertResp(logger, settings);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetInstanceUsingAppSettingsAsync) + " - created wrapper instance {0}", instance);
            }
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        public readonly TimeoutSettings Settings;

        private readonly ILogger<spSP_InsertResp> logger;
        
        public spSP_InsertResp(
            ILogger<spSP_InsertResp> logger,
            TimeoutSettings settings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.Settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public override string ToString()
        {
            return nameof(spSP_InsertResp) + $"[{nameof(Settings)}={Settings}]";
        }

        public async Task PrePopulate(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            DateTime updatedDate,
            Guid newRespId,
            Guid dplyId,
            Guid qnnId,
            Guid listSampleId,
            string strata)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            if (auditBatch.HasSample) throw new ArgumentException("SampleId is present in AuditBatch", nameof(auditBatch));
            if (!auditBatch.HasUser) throw new ArgumentException("UserId absent in AuditBatch", nameof(auditBatch));

            await ExecuteAsync(
                //for audit
                auditOn: auditBatch.AuditOn,
                sampleId: auditBatch.HasSample ? auditBatch.SampleId : null,
                structDivisionId: auditStructDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                auditUserId: auditBatch.UserId,
                //for the insert
                id: newRespId,
                updatedDate: updatedDate,
                qnnId: qnnId,
                listSampleId: listSampleId,
                dplyId: dplyId,
                dateStart: null,
                dateComplete: null,
                isPrePopulated: true,
                lastSavedPage: null,
                anonymousId: null,
                ipAddress: null,
                initialResponseAs: Constants.ResponseAs.PrePopulated,
                initialResponseBy: Constants.ResponseBy.Unknown,
                initialResponseVia: Constants.ResponseBy.Unknown,
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

        /// <summary>
        /// Insert a new row into QNN_RESP
        /// Intended for use when saving/submitting survey response answers
        /// </summary>
        public async Task InsertResponse(
            AuditBatch auditBatch,
            Guid? auditStructDivisionId,
            Guid newRespId,
            DateTime updatedDate,
            Guid qnnId,
            Guid listSampleId,
            Guid dplyId,
            DateTime dateStart,
            DateTime? dateComplete,
            string lastSavedPage,
            Guid? anonymousId,
            string ipAddress,
            string initialResponseAs,
            string initialResponseBy,
            string initialResponseVia,
            Guid? initialResponseUserId,
            string lastResponseAs,
            string lastResponseBy,
            string lastResponseVia,
            Guid? userId,
            string completedResponseAs,
            string completedResponseBy,
            string completedResponseVia,
            Guid? completedResponseUserId,
            string strata)
        {
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));
            auditBatch.AssertHasUserOrSample();

            if (Guid.Empty.Equals(anonymousId)) anonymousId = null;

            //n.b. MISP v6 has new changes around the initialResponseXXX and new origin indicators that are still to be ported to v8

            if (string.IsNullOrEmpty(initialResponseAs)) throw new ArgumentException(nameof(initialResponseAs));
            if (string.IsNullOrEmpty(initialResponseBy)) throw new ArgumentException(nameof(initialResponseBy));
            if (string.IsNullOrEmpty(initialResponseVia)) throw new ArgumentException(nameof(initialResponseVia));

            await ExecuteAsync(
                //for audit
                auditOn: auditBatch.AuditOn,
                sampleId: auditBatch.HasSample ? auditBatch.SampleId : null,
                structDivisionId: auditStructDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                auditUserId: auditBatch.UserId,
                //for the insert
                id: newRespId,
                updatedDate: updatedDate,
                qnnId: qnnId,
                listSampleId: listSampleId,
                dplyId: dplyId,
                dateStart: dateStart,
                dateComplete: dateComplete,
                isPrePopulated: false,
                lastSavedPage: lastSavedPage,
                anonymousId: anonymousId,
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

        //TODO - is InsertResponse now suitable for things that directly call ExecuteAsync to call it instead?
        /// <summary>
        /// Raw call to the procedure (other than converting null to DBNull). 
        /// Most business code should work with the other methods here for calling the procedure.
        /// This method is exposed for the benefit of special cases like the ResponseImporter, but should otherwise be
        /// considered internal to this class.
        /// </summary>
        public async Task ExecuteAsync(
            //For audit
            bool auditOn,
            Guid? sampleId,
            Guid? structDivisionId,
            Guid eventBatch,
            DateTime eventDate,
            Guid? auditUserId,
            //For the insert
            Guid id,
            DateTime? updatedDate,
            Guid qnnId,
            Guid listSampleId,
            Guid dplyId,
            DateTime? dateStart,
            DateTime? dateComplete,
            bool isPrePopulated,
            string lastSavedPage,     
            Guid? anonymousId,
            string ipAddress,
            string initialResponseAs,
            string initialResponseBy,
            string initialResponseVia,
            Guid? initialResponseUserId,
            string lastResponseAs,
            string lastResponseBy,
            string lastResponseVia,
            Guid? userId,
            string completedResponseAs,
            string completedResponseBy,
            string completedResponseVia,
            Guid? completedResponseUserId,
            string strata)
        {
            if (Guid.Empty.Equals(anonymousId)) anonymousId = null;

            if (string.IsNullOrEmpty(initialResponseAs)) throw new ArgumentException(nameof(initialResponseAs));
            if (string.IsNullOrEmpty(initialResponseBy)) throw new ArgumentException(nameof(initialResponseBy));
            if (string.IsNullOrEmpty(initialResponseVia)) throw new ArgumentException(nameof(initialResponseVia));
            if (string.IsNullOrEmpty(lastResponseAs)) throw new ArgumentException(nameof(lastResponseAs));
            if (string.IsNullOrEmpty(lastResponseBy)) throw new ArgumentException(nameof(lastResponseBy));
            if (string.IsNullOrEmpty(lastResponseVia)) throw new ArgumentException(nameof(lastResponseVia));
            //n.b. values for completedResponseXXX may be null

            Dictionary<string, object> insertRespParams = new Dictionary<string, object>();
            insertRespParams["AuditOn"] = auditOn;
            insertRespParams["SampleId"] = sampleId ?? (object)DBNull.Value;
            insertRespParams["StructDivisionId"] = structDivisionId ?? (object)DBNull.Value;
            insertRespParams["EventBatch"] = eventBatch;
            insertRespParams["EventDate"] = eventDate;
            insertRespParams["AuditUserId"] = auditUserId ?? (object)DBNull.Value;

            insertRespParams["Id"] = id;
            insertRespParams["UpdatedDate"] = updatedDate ?? (object)DBNull.Value;
            insertRespParams["QnnId"] = qnnId;
            insertRespParams["ListSampleId"] = listSampleId;
            insertRespParams["DplyId"] = dplyId;            
            insertRespParams["DateStart"] = dateStart ?? (object)DBNull.Value;
            insertRespParams["DateComplete"] = dateComplete ?? (object)DBNull.Value;
            insertRespParams["IsPrePopulated"] = isPrePopulated;
            insertRespParams["LastSavedPage"] = lastSavedPage ?? (object)DBNull.Value;
            insertRespParams["AnonymousId"] = anonymousId ?? (object)DBNull.Value;
            insertRespParams["IpAddress"] = ipAddress ?? (object)DBNull.Value;
            insertRespParams["InitialResponseAs"] = initialResponseAs;
            insertRespParams["InitialResponseBy"] = initialResponseBy;
            insertRespParams["InitialResponseVia"] = initialResponseVia;
            insertRespParams["InitialResponseUserId"] = initialResponseUserId ?? (object)DBNull.Value;
            insertRespParams["LastResponseAs"] = lastResponseAs;
            insertRespParams["LastResponseBy"] = lastResponseBy;
            insertRespParams["LastResponseVia"] = lastResponseVia;
            insertRespParams["UserId"] = userId ?? (object)DBNull.Value;
            insertRespParams["CompletedResponseAs"] = completedResponseAs ?? (object)DBNull.Value;
            insertRespParams["CompletedResponseBy"] = completedResponseBy ?? (object)DBNull.Value;
            insertRespParams["CompletedResponseVia"] = completedResponseVia ?? (object)DBNull.Value;
            insertRespParams["CompletedResponseUserId"] = completedResponseUserId ?? (object)DBNull.Value;
            insertRespParams["Strata"] = strata ?? (object)DBNull.Value;

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ExecuteAsync) + " - Called, insertRespParams={0}", insertRespParams);
            }

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_InsertResp,
                    insertRespParams,
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
                throw new InsertRespException(e);
            }
        } //end of ExecuteAsync
    } //end of spSP_InsertResp
} // end of namespace
