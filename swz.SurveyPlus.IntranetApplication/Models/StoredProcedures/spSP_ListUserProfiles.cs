using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_ListUserProfiles
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_ListUserProfiles));

        public static async Task<List<Dictionary<string, object>>> Execute(IEnumerable<Guid> structDivisionIds)
        {
            ArgumentNullException.ThrowIfNull(structDivisionIds, nameof(structDivisionIds));
            if (!structDivisionIds.Any()) throw new ArgumentException("Needs at least one value", nameof(structDivisionIds));
            try
            {
                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("StructDivisionIds", string.Join(',', structDivisionIds));
                List<Dictionary<string, object>> results
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_ListUserProfiles,
                        spParams,
                        new Dictionary<string, object>(),
                        timeoutSeconds: 90);
                return results;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(Execute) + " - caught unexpected exception");
                }
                throw;
            }

        }
    }
}
