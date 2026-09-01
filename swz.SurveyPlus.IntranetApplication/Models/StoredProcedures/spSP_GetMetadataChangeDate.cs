using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetMetadataChangeDate
    {
        private static readonly ILogger logger 
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetMetadataChangeDate));

        /// <summary>
        /// Returns the most recent value for UpdatedDate or CreatedDate from any row in dwMetadata
        /// </summary>
        public static async Task<DateTime> MostRecentChange()
        {
            try
            {
                //The below would happen if the MetadataCachesFlusher tries to do its logic too early (should be fixed now)
                if (CloverRuntime.DbProvider == null) //roll against SAN
                    throw new NullReferenceException($"{nameof(CloverRuntime.DbProvider)} is null, {nameof(CloverRuntime)} is not initialised properly");

                const int timeoutSeconds = 60;
                Dictionary<string, object> param = new Dictionary<string, object>();
                Dictionary<string, object> outParams = new Dictionary<string, object>();
                outParams["MostRecentChange"] = DateTime.MinValue;  //ExecuteStoredProcedureExAsync will fail for DbNull here                
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetMetadataChangeDate,
                    param,
                    outParams,
                    timeoutSeconds);
                DateTime? mostRecentChange = (DateTime?)outParams["MostRecentChange"];
                return (mostRecentChange == null)
                    ? DateTime.MinValue //very unlikely edge case
                    : mostRecentChange.Value;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(MostRecentChange) + " - caught unexpected exception");
                }
                throw;
            }
        }
    }
}
