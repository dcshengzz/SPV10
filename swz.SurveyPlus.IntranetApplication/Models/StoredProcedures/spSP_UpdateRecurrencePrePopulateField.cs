using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public static class spSP_UpdateRecurrencePrePopulateField
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_UpdateRecurrencePrePopulateField));

        //TODO - this should take an auditbatch
        public static async Task UpdateRecurrencePrePopulateField(
            Guid dplyId,
            List<Guid> qnnFieldIdsToAdd,
            List<Guid> qnnFieldIdsToRemove,
            Guid userId,
            Guid userStructDivisionId,
            Guid eventBatch)
        {

            if (Guid.Empty.Equals(dplyId))
            {
                throw new ArgumentException("dplyId may not be empty", nameof(dplyId));
            }
            if (Guid.Empty.Equals(userId))
            {
                throw new ArgumentException("userId may not be empty", nameof(userId));
            }
            if (Guid.Empty.Equals(userStructDivisionId))
            {
                throw new ArgumentException("userStructDivisionId may not be empty", nameof(userStructDivisionId));
            }
            if (Guid.Empty.Equals(eventBatch))
            {
                throw new ArgumentException("eventBatch may not be empty", nameof(eventBatch));
            }
            if (qnnFieldIdsToAdd == null) throw new ArgumentNullException(nameof(qnnFieldIdsToAdd));
            if (qnnFieldIdsToRemove == null) throw new ArgumentNullException(nameof(qnnFieldIdsToRemove));

            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>();
                param["DplyId"] = dplyId;
                if (qnnFieldIdsToAdd.Count > 0)
                {
                    param["QnnFieldIdsToAdd"] = string.Join(",", qnnFieldIdsToAdd.Select(e => e.ToString("D")).ToArray());
                }
                else
                {
                    param["QnnFieldIdsToAdd"] = DBNull.Value;
                }
                if (qnnFieldIdsToRemove.Count > 0)
                {
                    param["QnnFieldIdsToRemove"] = string.Join(",", qnnFieldIdsToRemove.Select(e => e.ToString("D")).ToArray());
                }
                else
                {
                    param["QnnFieldIdsToRemove"] = DBNull.Value;
                }
                param["UserId"] = userId;
                param["StructDivisionId"] = userStructDivisionId;
                param["EventBatch"] = eventBatch;
                param["EventDate"] = DateTime.Now;
                param["AuditOn"] = await AuditSettings.GetAuditOnAsync();

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_UpdateRecurrencePrePopulateField,
                    param,
                    new Dictionary<string, object>());
            }
            catch (Exception e)
            {
                if(Logger.IsEnabled(LogLevel.Debug))
                {   //Here we log at debug level, as the exception is rethrown for caller to handle
                    Logger.LogDebug(e, nameof(UpdateRecurrencePrePopulateField) + " - caught unexpected exception, dplyId={0}", dplyId);
                }
                throw;
            }
        }
    }
}
