using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetListSampleProfile
    {
        public class GetListSampleProfileException : Exception
        {
            public GetListSampleProfileException(string message, Exception innerException)
                : base(message, innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetListSampleProfile));

        public static async Task<List<Dictionary<string, object>>> GetForListExport(Guid listId)
        {
            return await ExecuteAsync(listId, null, PasswordAction.Exclude);
        }

        public static async Task<List<Dictionary<string, object>>> GetForProfile(Guid listId, IEnumerable<Guid> listSampleIds)
        {
            if (listSampleIds == null) 
                throw new ArgumentNullException(nameof(listSampleIds)); //empty is fine, null suggests a caller mistake

            string concatListSampleIds = string.Join(',', listSampleIds);
            //example: 8B1DE6FD-8FD0-43EB-A26F-02009126A11C,08B2CF4D-E8E5-4F6D-91C0-15FDC9500CC6,260D4E1F-142B-4C2A-AC2F-219019708712
            return await ExecuteAsync(listId, concatListSampleIds, PasswordAction.Include);
        }

        private enum PasswordAction { Include, Exclude }

        private static async Task<List<Dictionary<string, object>>> ExecuteAsync(
            Guid listId,
            string listSampleIds,
            PasswordAction passwordAction)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - Called");
                }

                Dictionary<string, object> spParams = new Dictionary<string, object>();
                spParams.Add("ListId", listId);
                spParams.Add("ListSampleIds", (object)listSampleIds ?? DBNull.Value);
                spParams.Add("IncludePassword", (passwordAction==PasswordAction.Include) );

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<Dictionary<string, object>> results = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetListSampleProfile,
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
                //log at debug level here, caller responsible for handling and/or error level logging as they see fit
                logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, listId={0}", listId);
                throw new GetListSampleProfileException(
                    $"Failed for listId={listId}", e);
            }
        }
    }
}
