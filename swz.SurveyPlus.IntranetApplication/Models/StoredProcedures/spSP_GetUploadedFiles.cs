using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    /// <summary>
    /// Wraps stored procedure that gets tokens of files uploaded for a specific response
    /// </summary>
    public static class spSP_GetUploadedFiles
    {
        public class GetUploadedFilesException : Exception
        {
            public readonly Guid QnnRespId;
            public long Duration;

            public GetUploadedFilesException(Guid qnnRespId, long duration, Exception innerException)
                : base($"Error retrieving tokens of files uploaded for {qnnRespId}, duration={duration} ms", innerException)
            {
                this.QnnRespId = qnnRespId;
                this.Duration = duration;
            }
        }

        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetUploadedFiles));

        /// <summary>
        /// Get files for the response
        /// </summary>
        /// <param name="qnnRespId">response id</param>
        /// <returns>a list of file tokens, may be empty but is never null</returns>
        public static async Task<ImmutableList<string>> ForResponse(Guid qnnRespId)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

            try
            {
                Dictionary<string, object> spParams = new Dictionary<string, object>
                {
                    {Constants.FieldName.RespId, qnnRespId}
                };

                Dictionary<string, object> spOutParams = new Dictionary<string, object>
                {
                    {"UploadedFilesToken", string.Empty}
                };

                List<Dictionary<string, object>> getUploadedFilesResult
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetUploadedFiles,
                        spParams,
                        spOutParams);

                string commaDelimitedTokens
                    = (spOutParams["UploadedFilesToken"] == null || DBNull.Value.Equals(spOutParams["UploadedFilesToken"]))
                    ? ""
                    : (string)spOutParams["UploadedFilesToken"];

                ImmutableList<string> uploadedFilesToken 
                    = commaDelimitedTokens
                    .Split(',')
                    .Select(token => token.Trim())
                    .ToImmutableList();

                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                if (duration > 5000)
                {
                    logger.LogWarning(nameof(ForResponse) + " - completed in {0} ms (over 5 seconds) for qnnRespId={1}, uploadedFilesToken.Count={1}",
                        duration,
                        qnnRespId,
                        uploadedFilesToken.Count);
                }

                return uploadedFilesToken;
            }
            catch(Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(ForResponse) + " - caught unexpected exception for qnnRespId={0}, duration={1}", qnnRespId, duration);
                }
                
                throw new GetUploadedFilesException(qnnRespId, duration, e);
            }
        }
    }
}
