using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_UpdatePdfExportStatus
    {
        private static readonly ILogger logger =
            (ILogger)DefaultApplicationLogging.CreateLogger<spSP_UpdatePdfExportStatus>();

        public static async Task ExecuteAsync(Guid id, string status, string errorMessage = null)
        {
            if (Guid.Empty.Equals(id)) throw new ArgumentException(nameof(id));
            if (string.IsNullOrEmpty(status)) throw new ArgumentException(nameof(status));

            Dictionary<string, object> paramsIn = new Dictionary<string, object>
            {
                ["Id"] = id,
                ["Status"] = status,
                ["ErrorMessage"] = errorMessage ?? (object)DBNull.Value
            };

            try
            {
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdatePdfExportStatus,
                    paramsIn,
                    new Dictionary<string, object>()); 
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ExecuteAsync) + " - failed, id={Id}, status={Status}", id, status);
                throw;
            }
        }
    }
}