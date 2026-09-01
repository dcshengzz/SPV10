using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetAllSampleUid
    {
        public class GetAllSampleUidException : Exception
        {
            public GetAllSampleUidException(Exception innerException)
                : base("Unexpected exception retrieving all UID information from database", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetAllSampleUid));

        /// <summary>
        /// Returns a set of every UID currently in the database. The set returned will have a case-insensive comparator.
        /// </summary>
        public static async Task<HashSet<string>> GetAllUidsAsync()
        {
            try
            {
                HashSet<string> uids 
                    = (await ExecuteAsync())
                    .Select(row => ((string)row[Constants.FieldName.UID]).Trim())
                    .ToHashSet(Constants.Comparers.UidCaseInsensitive);
                return uids;
            }
            catch(GetAllSampleUidException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(GetAllUidsAsync) + " - caught unexpected exception");
                throw new GetAllSampleUidException(e);
            }
        }

        private static async Task<List<Dictionary<string, object>>> ExecuteAsync()
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called");
                }

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetAllSampleUid,
                    new Dictionary<string, object>(),
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
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception");
                throw new GetAllSampleUidException(e);
            }
        }
    }
}
