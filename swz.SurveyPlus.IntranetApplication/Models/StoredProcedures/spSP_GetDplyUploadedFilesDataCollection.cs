using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetDplyUploadedFilesDataCollection
    {
        private static readonly ILogger logger 
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetDplyUploadedFilesDataCollection));

        public static async Task<List<Dictionary<string, object>>> GetDplyUploadedFilesDataCollection(
            Guid dplyId, 
            Guid qnnId, 
            string statusList)
        {
            try
            {
                Dictionary<string, object> spParams
                        = new Dictionary<string, object>
                        {
                            {"DplyId",dplyId},
                            {"QnnId", qnnId},
                            {"StatusList", statusList} //comma delimited status guids in string form
                        };
                List<Dictionary<string, object>> uploadedFiles
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetDplyUploadedFilesDataCollection,
                        spParams,
                        new Dictionary<string, object>());
                return uploadedFiles;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(GetDplyUploadedFilesDataCollection) + " - caught unexpected exception, dplyId={0}, qnnId={1}, statusList={2}", dplyId, qnnId, statusList);
                }
                throw;
            }

        }
    }
}
