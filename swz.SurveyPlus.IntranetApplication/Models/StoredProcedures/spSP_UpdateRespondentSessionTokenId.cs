using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_UpdateRespondentSessionTokenId
    {
        public class UpdateRespondentSessionTokenIdException : Exception
        {
            public UpdateRespondentSessionTokenIdException(
                Guid sampleId,
                string tokenId,
                Exception innerException)
                : base($"Failed to update respondent session token id {tokenId} for sampleId={sampleId}", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_UpdateRespondentSessionTokenId));

        /// <summary>
        /// Create, update, or remove the row in RespondentSessionTokenId
        /// </summary>
        /// <param name="sampleId">required, id in QNN_SAMPLE</param>
        /// <param name="tokenId">TokenIUd in JsonWebTokens, or null</param>
        /// <returns></returns>
        /// <exception cref="UpdateRespondentSessionTokenIdException"></exception>
        public static async Task ExecuteAsync(Guid sampleId, string tokenId)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called for sampleId={0}, tokenId={1}", sampleId, tokenId);
                }

                Dictionary<string, object> inParams = new Dictionary<string, object>
                {
                    {"SampleId", sampleId},
                    {"TokenId", (object)tokenId??DBNull.Value}  //May be null, in which case SP deletes the row
                };

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdateRespondentSessionTokenId,
                    inParams,
                    new Dictionary<string, object>());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    logger.LogTrace(nameof(ExecuteAsync) + " - stored procedure call complete, duration={0}",duration);
                }

            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, sampleId={0}, tokenId={1}", sampleId, tokenId);
                throw new UpdateRespondentSessionTokenIdException(sampleId, tokenId, e);
            }
        }
    }
}
