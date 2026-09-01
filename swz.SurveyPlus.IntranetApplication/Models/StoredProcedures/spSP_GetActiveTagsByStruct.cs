using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetActiveTagsByStruct
    {
        private static readonly ILogger logger 
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetActiveTagsByStruct));

        public static async Task<List<Dictionary<string, object>>> GetActiveTagsByStruct(
            Guid userStructDivisionId, 
            int numOfTags)
        {
            try
            {
                Dictionary<string, object> spParams = new Dictionary<string, object>
                    {
                        {"UserStructDivisionId",userStructDivisionId},
                        {"NumOfTags", numOfTags}
                    };
                List<Dictionary<string, object>> result = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetActiveTagsByStruct,
                    spParams,
                    new Dictionary<string, object>());
                return result.Count > 0 ? result : null;
            }
            catch (Exception e)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetActiveTagsByStruct) + " - caught unexpected exception, userStructDivisionId={0}, numOfTags={1}", userStructDivisionId, numOfTags);
                }
                throw;
            }
        }
    }
}
