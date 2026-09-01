using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public static class spSP_InsertAllSamplesToDataEditor
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_InsertAllSamplesToDataEditor));

        /// <summary>
        /// Assign all sample to Data Editors
        /// </summary>
        //TODO - this should take an AuditBatch
        public static async Task InsertByDplyIdAndDataEditorId(
            Guid dplyId, 
            Guid userId, 
            Guid dataEditorId, 
            Guid userStructId, 
            Guid eventBatch, 
            bool auditOn, 
            string newValue)
        {
            if (Guid.Empty.Equals(dplyId))
                throw new ArgumentException("dplyId may not be empty", nameof(dplyId));

            if (Guid.Empty.Equals(userId))
                throw new ArgumentException("userId may not be empty", nameof(userId));

            if (Guid.Empty.Equals(dataEditorId))
                throw new ArgumentException("dataEditorId may not be empty", nameof(dataEditorId));

            if (Guid.Empty.Equals(userStructId))
                throw new ArgumentException("userStructId may not be empty", nameof(userStructId));

            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>
                    {
                        {"DplyId", dplyId},
                        {"DataEditorId", dataEditorId},
                        {"TableName", Constants.ModelName.QNN_DPLY_SAMPLE_OWNER}, //TODO - why this must be passed?
                        {"UserId", userId},
                        {"SampleId", DBNull.Value}, //TODO - why is this even passed?
                        {"StructDivisionId", userStructId},
                        {"EventBatch", eventBatch},
                        {"EventDate", DateTime.Now},
                        {"AuditOn", auditOn},
                        {"NewValue", newValue}
                    };
                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_InsertAllSamplesToDataEditor,
                    param,
                    new Dictionary<string, object>());
            }
            catch (Exception e)
            {
                if(Logger.IsEnabled(LogLevel.Debug))
                {   //Log at debug level here, error level logging is the choice and responsibility of caller
                    Logger.LogDebug(e, nameof(InsertByDplyIdAndDataEditorId) + " - caught unexpected exception, dplyId={0}, userId={1}, dataEditorId={2}, userStructId={3}", dplyId, userId, dataEditorId, userStructId);
                }                
                throw;
            }
        }
    }
}
