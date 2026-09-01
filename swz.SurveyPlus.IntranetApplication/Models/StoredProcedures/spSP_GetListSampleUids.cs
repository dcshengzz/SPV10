using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetListSampleUids
    {
        public class GetListSampleUidsException : Exception
        {
            public GetListSampleUidsException(Exception innerException)
                : base("Unexpected exception retrieving UID and ListSample Id information from database", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetListSampleUids));

        public static async Task<Dictionary<string, Guid>> MapListSampleIdsByUidAsync(Guid listId)
        {
            try
            {
                Dictionary<string, Guid> mappings 
                    = (await ExecuteAsync(listId))
                    .ToDictionary(
                    row => (string)row[Constants.FieldName.UID],
                    row => (Guid)row[Constants.FieldName.ListSampleId]);
                return mappings;
            }
            catch (GetListSampleUidsException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(MapListSampleIdsByUidAsync) + " - caught unexpected exception, listId={0}", listId);
                throw new GetListSampleUidsException(e);
            }
        }

        private static async Task<List<Dictionary<string, object>>> ExecuteAsync(Guid listId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called");
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("ListId", listId);

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetListSampleUids,
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
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, listId={0}", listId);
                throw new GetListSampleUidsException(e);
            }
        }
    }
}
