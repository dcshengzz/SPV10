using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetRespondentSessionTokenId
    {
        public class GetRespondentSessionTokenIdException : Exception
        {
            public GetRespondentSessionTokenIdException(Guid sampleId, Exception innerException)
                : base($"Failed to get respondent session token id for sampleId={sampleId}", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetRespondentSessionTokenId));

        public static async Task<string> ExecuteAsync(Guid sampleId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for sampleId={0}", sampleId);
                }

                Dictionary<string, object> inParams = new Dictionary<string, object>
                {
                    {"SampleId", sampleId},
                };

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetRespondentSessionTokenId,
                    inParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}", duration);
                }

                if (!results.Any())
                    return null;
                else if (results.Count > 1)
                    throw new InvalidOperationException("Unexpected result count:" + results.Count);
                else
                    return (string)results[0]["TokenId"];
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, sampleId={0}", sampleId);
                throw new GetRespondentSessionTokenIdException(sampleId, e);
            }
        }
    }
}
