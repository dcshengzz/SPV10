using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public static class spSP_DeleteSampleOwnerByIds
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_DeleteSampleOwnerByIds));

        /// <summary>
        /// Delete sample owner by id
        /// Audit will be log on DB store procedure.
        /// </summary>
        /// <param name="eventBatch">Event Batch Id</param>
        /// <param name="listIdtoDelete">string array of QNN_DPLY_SAMPLE_OWNER ids</param>
        /// <param name="callerUserId">userId of caller</param>
        /// <param name="callerStructDivisionId">userStructId of caller</param>
        /// <returns></returns>
        public static async Task DeleteByIds(
            Guid eventBatch, 
            List<Guid> listIdtoDelete, 
            Guid callerUserId, 
            Guid callerStructDivisionId)
        {
            if (listIdtoDelete == null) throw new ArgumentNullException(nameof(listIdtoDelete));

            if (listIdtoDelete.Count() == 0)
                throw new ArgumentException("listIdtoDelete may not be empty", "listIdtoDelete");

            if (Guid.Empty.Equals(eventBatch))
                throw new ArgumentException("eventBatch may not be empty", "eventBatch");

            if (Guid.Empty.Equals(callerUserId))
                throw new ArgumentException("userId may not be empty", "userId");

            if (Guid.Empty.Equals(callerStructDivisionId))
                throw new ArgumentException("callerStructDivisionId may not be empty", "callerStructDivisionId");

            try
            {
                bool auditOn = await AuditSettings.GetAuditOnAsync();
                string idsList = string.Join(",", listIdtoDelete);
                Dictionary<string, object> param = new Dictionary<string, object>
                    {
                        {"Ids", idsList},
                        {"TableName", Constants.ModelName.QNN_DPLY_SAMPLE_OWNER},
                        {"UserId", callerUserId},
                        {"SampleId", DBNull.Value},
                        {"StructDivisionId", callerStructDivisionId},
                        {"EventBatch", eventBatch},
                        {"EventDate", DateTime.Now},
                        {"AuditOn", auditOn}
                    };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_DeleteSampleOwnerByIds,
                    param,
                    new Dictionary<string, object>());
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(DeleteByIds) + " - caught unexpected exception");
                throw;
            }
        }
    }
}
