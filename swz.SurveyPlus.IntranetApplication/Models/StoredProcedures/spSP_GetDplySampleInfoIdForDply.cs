using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetDplySampleInfoIdForDply
    {
        public class GetDplySampleInfoIdForDplyException : Exception
        {
            public GetDplySampleInfoIdForDplyException(Exception innerException)
                : base("Unexpected exception retrieving DLSI information from database", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetDplySampleInfoIdForDply));

        /// <summary>
        /// For the specified deployment, returns a lookup table to get the DLSI for each list sample. 
        /// </summary>
        public static async Task<Dictionary<Guid, Guid>> MapDplySampleInfoIdsByListSampleId(Guid dplyId)
        {
            try
            {
                Dictionary<Guid, Guid> mappings
                    = (await ExecuteAsync(dplyId)).ToDictionary(
                        row => (Guid)row[Constants.FieldName.ListSampleId],
                        row => (Guid)row["DplySampleInfoId"]);
                return mappings;
            }
            catch (GetDplySampleInfoIdForDplyException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(MapDplySampleInfoIdsByListSampleId) + " - caught unexpected exception, dplyId={0}", dplyId);
                throw new GetDplySampleInfoIdForDplyException(e);
            }
        }

        private static async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid dplyId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called");
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("DplyId", dplyId);

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetDplySampleInfoIdForDply,
                    spParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}, count={1}", duration, results.Count);
                }

                return results;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, dplyId={0}", dplyId);
                throw new GetDplySampleInfoIdForDplyException(e);
            }
        }
    }
}
