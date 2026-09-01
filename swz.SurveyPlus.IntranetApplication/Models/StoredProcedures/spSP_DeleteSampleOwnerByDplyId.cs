using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public static class spSP_DeleteSampleOwnerByDplyId
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_DeleteSampleOwnerByDplyId));

        /// <summary>
        /// Delete all sample owner by dplyId with user struct division organisation and below the organisation
        /// Audit will be log on DB store procedure.
        /// </summary>
        /// <param name="dplyId">dplyId to delete</param>
        /// <param name="userId">userId of caller</param>
        /// <param name="userStructId">userStructId of caller</param>
        /// <returns></returns>
        //TODO - this should take an AuditBatch
        public static async Task DeleteByDplyId(
            Guid dplyId, 
            Guid userId, 
            Guid userStructId, 
            bool auditOn, 
            string newValue)
        {
            if (Guid.Empty.Equals(userId))
            {
                throw new ArgumentException("userId may not be empty", nameof(userId));
            }

            if (Guid.Empty.Equals(dplyId))
            {
                throw new ArgumentException("dplyId may not be empty", nameof(dplyId));
            }

            if (Guid.Empty.Equals(userStructId))
            {
                throw new ArgumentException("userStructId may not be empty", nameof(userStructId));
            }

            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>
                    {
                        {"DplyId", dplyId},
                        {"TableName", Constants.ModelName.QNN_DPLY_SAMPLE_OWNER}, //TODO - why is this passed in, what else would it be?
                        {"UserId", userId},
                        {"SampleId", DBNull.Value}, //TODO - why is this passed in?
                        {"StructDivisionId", userStructId},
                        {"EventBatch", Guid.NewGuid()},
                        {"EventDate", DateTime.Now},
                        {"AuditOn", auditOn},
                        {"NewValue", newValue} //seems this is some info for audit about what is being cleared, TODO - more meaningful name 
                    };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_DeleteSampleOwnerByDplyId,
                    param,
                    new Dictionary<string, object>());
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(DeleteByDplyId) + " - caught unexpected exception, dplyId={0}, userId={1}", dplyId, userId);
                throw;
            }

        }
    }
}
