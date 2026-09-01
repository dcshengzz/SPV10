using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_LogPdfGeneration
    {
        private static readonly ILogger logger =
            (ILogger)DefaultApplicationLogging.CreateLogger<spSP_LogPdfGeneration>();

        public class LogResult
        {
            public bool IsRateLimited { get; set; }
            public Guid Id { get; set; }
        }

        public static async Task<LogResult> ExecuteAsync(
            Guid? sampleId,
            string formName,
            string surveyName,
            string emails,
            int cooldownMinutes,
            Guid? dplyListSampleId = null,
            Guid? respId = null)
        {
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            if (cooldownMinutes < 0) throw new ArgumentOutOfRangeException(nameof(cooldownMinutes));

            Dictionary<string, object> paramsIn = new Dictionary<string, object>
            {
                ["SampleId"] = sampleId.HasValue ? (object)sampleId.Value : DBNull.Value,
                ["DplyListSampleId"] = dplyListSampleId.HasValue ? (object)dplyListSampleId.Value : DBNull.Value,
                ["RespId"] = respId.HasValue ? (object)respId.Value : DBNull.Value,
                ["FormName"] = formName,
                ["SurveyName"] = surveyName ?? (object)DBNull.Value,
                ["Emails"] = emails ?? (object)DBNull.Value,
                ["CooldownMinutes"] = cooldownMinutes
            };

            Dictionary<string, object> paramsOut = new Dictionary<string, object>
            {
                ["IsRateLimited"] = false,
                ["Id"] = Guid.Empty
            };

            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_LogPdfGeneration,
                    paramsIn,
                    paramsOut);

                return new LogResult
                {
                    IsRateLimited = Convert.ToBoolean(paramsOut["IsRateLimited"]),
                    Id = (Guid)paramsOut["Id"]
                };
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExecuteAsync) + " - failed, sampleId={SampleId}, formName={FormName}, dplyListSampleId={DplyListSampleId}",
                    sampleId, formName, dplyListSampleId);
                throw;
            }
        }
    }
}