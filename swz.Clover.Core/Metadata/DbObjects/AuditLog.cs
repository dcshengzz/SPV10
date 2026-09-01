using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.Clover.Core.Metadata.DbObjects
{
    /// <summary>
    /// Represents a row in the AuditLog table.
    /// 20230411 - Please note that SurveyPlus now works with the AuditLog table via the sy_AuditLog synonym rather than
    /// directly with the AuditLog table (so the Clover metadata in SurveyPlus for AuditLog now refers to that as the db object).
    /// This is so that we have the option to point the synonym at another database and externalise the audit table.  
    /// </summary>
    public class AuditLog : DbObject<AuditLog>
    {
        public AuditLog() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public Guid? UserId
        {
            get => _entity.UserId;
            set => _entity.UserId = value;
        }

        [DbObjectModel]
        public Guid? SampleId
        {
            get => _entity.SampleId;
            set => _entity.SampleId = value;
        }

        [DbObjectModel]
        public Guid? EventBatch
        {
            get => _entity.EventBatch;
            set => _entity.EventBatch = value;
        }

        [DbObjectModel]
        public DateTime EventDate
        {
            get => _entity.EventDate;
            set => _entity.EventDate = value;
        }

        [DbObjectModel]
        public string EventType
        {
            get => _entity.EventType;
            set => _entity.EventType = value;
        }

        [DbObjectModel]
        public string TableName
        {
            get => _entity.TableName;
            set => _entity.TableName = value;
        }

        [DbObjectModel]
        public Guid? RecordId

        {
            get => _entity.RecordId;
            set => _entity.RecordId = value;
        }

        [DbObjectModel]
        public string ColumnName
        {
            get => _entity.ColumnName;
            set => _entity.ColumnName = value;
        }

        [DbObjectModel]
        public string OriginalValue
        {
            get => _entity.OriginalValue;
            set => _entity.OriginalValue = value;
        }

        [DbObjectModel]
        public string NewValue
        {
            get => _entity.NewValue;
            set => _entity.NewValue = value;
        }

        [DbObjectModel]
        public Guid? StructDivisionId
        {
            get => _entity.StructDivisionId;
            set => _entity.StructDivisionId = value;
        }

        /// <summary>
        /// Insert this record using the InsertAuditLog stored procedure (uses DbProvider and bypasses usual ORM mapping).
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public async Task InsertUsingStoredProcedureAsync()
        {
            if ((object)_entity["Id"] != null) throw new InvalidOperationException("Id already assigned, entry is not new");
            if (EventBatch == null) throw new InvalidOperationException("No EventBatch specified");
            Guid id = await InsertAuditLog.InsertAuditLogAsync(
                userId: UserId,
                sampleId: SampleId,
                eventBatch: (Guid)EventBatch, //in db is NOT NULL
                eventDate: EventDate,
                eventType: EventType,
                tableName: TableName,
                recordId: RecordId,
                columnName: ColumnName,
                originalValue: OriginalValue,
                newValue: NewValue,
                structDivisionId: StructDivisionId);
            Id = id;
        }

        const string SQLDatePatten = "yyyy'-'MM'-'dd HH':'mm':'ss";

        public static async Task<List<AuditLog>> GetAblrLogs(DateTime datetime)
        {
            List<string> AblrEventType = new List<string>
            {
                "Delete",
                "Insert",
                "Read",
                "Update",
                "Audit Purge",
            };
            List<string> AblrTables = new List<string>
            {
                "Appsettings",
                "Auditlog",
                "Uploadedfiles",
                "UploadedFilesPoor",
                "dwSecurityUser",
                "SecurityCredential",
                "SecurityUser",
                "SecurityUserToSecurityRole",
            };

            var filter = Filter.And.GreaterOrEqual(datetime.ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate).Less(datetime.AddDays(1).ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate)
                .In(AblrEventType, Constants.FieldName.AuditLog.EventType).In(AblrTables, Constants.FieldName.AuditLog.TableName);
            var result = await SelectAsync(filter).ConfigureAwait(false);

            List<string> ablrEventTypeWithoutTable = new List<string>
            {
                "Login",
                "LoginFailed",
                "LogOff",
            };
            var filter2 = Filter.And.GreaterOrEqual(datetime.ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate).Less(datetime.AddDays(1).ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate).In(ablrEventTypeWithoutTable, Constants.FieldName.AuditLog.EventType);
            result.AddRange(await SelectAsync(filter2).ConfigureAwait(false));

            return (result.Count > 0) ? result : null;
        }

        public static async Task<List<AuditLog>> GetAuditLogsOfDate(DateTime datetime)
        {
            var filter = Filter.And.GreaterOrEqual(datetime.ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate).Less(datetime.AddDays(1).ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate);
            var order = Order.StartAsc(Constants.FieldName.AuditLog.EventDate);
            var result = await SelectAsync(filter, order).ConfigureAwait(false);
            return (result.Count > 0) ? result : null;
        }

        public static async void DeleteAuditLogsOfDate(DateTime datetime)
        {
            var filter = Filter.And.GreaterOrEqual(datetime.ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate).Less(datetime.AddDays(1).ToString(SQLDatePatten), Constants.FieldName.AuditLog.EventDate);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            if (result.Count > 0)
                await DeleteAsync(result.Select(x => x.Id).ToList());
        }
    }
}
