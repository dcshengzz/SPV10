using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetDplyWordCount
    {
        private static readonly ILogger logger 
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetDplyWordCount));

        public static async Task<List<Dictionary<string, object>>> GetDplyWordCount(
            Guid dplyId, 
            string qnnField)
        {
            try
            {
                Dictionary<string, object> spParams
                        = new Dictionary<string, object>
                        {
                            {"DplyId",dplyId},
                            {"QnnField", qnnField}
                        };
                List<Dictionary<string, object>> wordCounts
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetDplyWordCount,
                        spParams,
                        new Dictionary<string, object>());
                return wordCounts;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetDplyWordCount) + " - caught unexpected exception, dplyId={0}, qnnField={1}", dplyId, qnnField);
                }
                throw;
            }

        }
    }
}
