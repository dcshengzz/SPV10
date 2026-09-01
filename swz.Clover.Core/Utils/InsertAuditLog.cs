using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.Clover.Core.Utils
{
    /// <summary>
    /// Providers static methods to call the InsertAuditLog stored procedure for use by audit logging methods.
    /// Application code performing logging should work with audit logging methods in AuditHelper class 
    /// rather than calling this directly to perform logging.
    /// Also be reminded that access to the AuditLog table should be done via the sy_AuditLog synonym rather than directly
    /// to the table so as to provide the opportunity to relocate/externalise the table by modifying the synonym.
    /// </summary>
    public class InsertAuditLog
    {
        public class InsertAuditlogException : Exception
        {
            public InsertAuditlogException(Exception innerException) 
                : base ( "An unexpected error occured when recording an audit log entry", innerException) { }
        }

        /// <summary>
        /// Write a row to the audit log.
        /// Note that this doesn't check the AuditOn setting. Caller is expected to handle that themselves, this is just a thin wrapper
        /// around the Stored Procedure call.
        /// If there is an exception when calling the stored procedure it will be wrapped with an InsertAuditLogException.
        /// </summary>
        public static async Task<Guid> InsertAuditLogAsync(
            Guid? userId,
            Guid? sampleId,
            Guid eventBatch,
            DateTime eventDate,
            string eventType,
            string tableName,
            Guid? recordId,
            string columnName,
            string originalValue,
            string newValue,
            Guid? structDivisionId)
        {
            if (string.IsNullOrWhiteSpace(eventType)) throw new ArgumentException("Not specified", nameof(eventType));
            if (eventType.Length > 20) throw new ArgumentException("Max length is 20 characters", nameof(eventType));
            if (tableName != null && tableName.Length > 100) throw new ArgumentException("Max length is 100 characters", nameof(tableName));
            if (columnName != null && columnName.Length > 100) throw new ArgumentException("Max length is 100 characters", nameof(columnName));

            try
            {
                Dictionary<string, object> param = new Dictionary<string, object>
                {
                    { "UserId", userId ?? (object)DBNull.Value },
                    { "SampleId", sampleId ?? (object)DBNull.Value },
                    { "EventBatch", eventBatch },
                    { "EventDate", eventDate },
                    { "EventType", eventType },
                    { "TableName", tableName ?? (object)DBNull.Value },
                    { "RecordId", recordId ?? (object)DBNull.Value },
                    { "ColumnName", columnName ?? (object)DBNull.Value },
                    { "OriginalValue", originalValue ?? (object)DBNull.Value },
                    { "NewValue", newValue ?? (object)DBNull.Value },
                    { "StructDivisionId", structDivisionId ?? (object)DBNull.Value }
                };

                Dictionary<string, object> outParam = new Dictionary<string, object>()
                {
                    { "Id", Guid.Empty }
                };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.InsertAuditLog,
                    param, 
                    outParam);

                Guid id = (Guid)outParam["Id"];
                return id;
            }
            catch (Exception e)
            {
                throw new InsertAuditlogException(e);
            }
        }
    }
}
