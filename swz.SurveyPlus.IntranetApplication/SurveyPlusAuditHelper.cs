using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// AuditSettings.NewBatchAsync is the preferred way to get an instance of this. 
    /// Simple object to reify the concept of an audit batch and bundle the batchId and user information with the AuditOn setting
    /// so they can be passed around. This is commonly used by the stored procedures etc.
    /// nb: this does not include the structDivisionId, this is a deliberate choice to exclude it here as it is often NOT 
    /// that of the current user depending on the actions being taken and the calling code needs to consider it properly.
    /// Likewise, we don't carry the date here as it should be the time of the audited action which might differ considerably
    /// from the time this object was constructed for long running jobs.
    /// </summary>
    public class AuditBatch
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        public bool AuditOn { get; }
        public Guid EventBatch { get; }

        //n.b. I now consider it a mistake to use Guid.Empty instead of null, but do not intend changing it at this point! -AH

        /// <summary>
        /// Returns the Id of the responsible user for audit purposes. If there is none this will
        /// return Guid.Empty rather than null. The HasUser property is a convenience to check for this.
        /// </summary>
        public Guid UserId { get; }

        /// <summary>
        /// Returns the Id of the responsible QNN_SAMPLE for audit purposes. If there is none (the usual case)
        /// then this returns Guid.Empty rather than null. The HasSample property is a convenience to check for this.
        /// </summary>
        public Guid SampleId { get; }

        /// <summary>
        /// True if UserId is specified
        /// </summary>
        public bool HasUser
        {
            get { return !Guid.Empty.Equals(UserId); }
        }

        /// <summary>
        /// True if SampleId is specified
        /// </summary>
        public bool HasSample
        {
            get { return !Guid.Empty.Equals(SampleId); }
        }

        //Not all things using an AuditBatch need to have a user or sample, but its a common enough requirement to justify
        /// <summary>
        /// Throw an InvalidOperationException if both UserId and SampleId are not specified
        /// </summary>
        public void AssertHasUserOrSample()
        {
            if ((!HasUser && !HasSample))
            {
                throw new InvalidOperationException("This AuditBatch must have a userId or a sampleId");
            }
        }

        /// <summary>
        /// Constructor.
        /// You should generally prefer to use the NewBatchAsync factory methods in AuditSettings to get an instance for a batch
        /// but can use this constructor if you have special requirements.
        /// </summary>
        /// <param name="auditOn">is the auditFeature actually in use?</param>
        /// <param name="eventBatch">a unique identifier to distinguish audit events that form a group/batch</param>
        /// <param name="userId">id of the user (if not applicable use Guid.Empty)</param>
        /// <param name="sampleId">id of the respondent in QNN_SAMPLE (can use Guid.Empty if not applicable)</param>
        public AuditBatch(bool auditOn, Guid eventBatch, Guid userId, Guid sampleId)
        {
            AuditOn = auditOn;
            if (Guid.Empty.Equals(eventBatch)) 
                throw new ArgumentException($"{nameof(eventBatch)} not specified", nameof(eventBatch));
            EventBatch = eventBatch;
            UserId = userId; //nb: Empty is allowed
            SampleId = sampleId; //nb: Empty is allowed
        }

        public override string ToString()
        {
            return $"[AuditBatch {nameof(EventBatch)}={EventBatch}, {nameof(UserId)}={UserId}, {nameof(SampleId)}={SampleId}, {nameof(AuditOn)}={AuditOn}]";
        }

    } //end of AuditBatch

    public static class AuditSettings
    {
        public const string AUDIT_ON = "AuditOn";

        /// <summary>
        /// Returns the value of the AuditOn setting in the AppSettings that specifies whether the audit trail feature is enabled.
        /// </summary>
        /// <returns>true is audit information should be recorded</returns>
        public static async Task<bool> GetAuditOnAsync()
        {
            AppSettings auditOnSetting = (await AppSettings.SelectAsync(Filter.And.Equal(AUDIT_ON, Constants.FieldName.Name))).FirstOrDefault();
            bool auditOn = auditOnSetting?.Value.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            return auditOn;
        }

        /// <summary>
        /// Utility method to return a new AuditBatch with its AuditOn initialised as per settings
        /// </summary>
        /// <param name="userId">id of the user (if not applicable use Guid.Empty)</param>
        /// <returns>a batch with a new unique id</returns>
        public static async Task<AuditBatch> NewBatchAsync(Guid userId)
        {
            return await NewBatchAsync(userId, Guid.Empty);
        }

        /// <summary>
        /// Utility method to return a new AuditBatch with its AuditOn initialised as per settings
        /// </summary>
        /// <param name="userId">id of the user (if not applicable use Guid.Empty)</param>
        /// <param name="sampleId">id of the respondent in QNN_SAMPLE (can use Guid.Empty if not applicable)</param>
        /// <returns>a batch with a new unique id</returns>
        public static async Task<AuditBatch> NewBatchAsync(Guid userId, Guid sampleId)
        {
            bool auditOn = await GetAuditOnAsync();
            Guid eventBatch = Guid.NewGuid();
            return new AuditBatch(auditOn, eventBatch, userId, sampleId);
        }

        /// <summary>
        /// Utility method to return a new AuditBatch with its AuditOn initialised as per settings.
        /// This variant of the constructor will use the current user's UserId and no SampleId.
        /// </summary>
        /// <returns>a batch with a new unique id</returns>
        public static async Task<AuditBatch> NewBatchAsync()
        {
            Guid? userId = (await CloverRuntime.Security.GetCurrentUserAsync()).Id;
            return await NewBatchAsync(((userId == null) ? Guid.Empty : (Guid)userId), Guid.Empty);
        }

    } //end of AuditSettings

    public class SurveyPlusAuditHelper
    {
        public static async Task SyncAuditSampleNameAsync()
        {
            await spSP_SyncAuditSampleName.ExecuteAsync();
        }

        /// <summary>
        /// Record a batch of Insert events (will record in a single Insert event)
        /// </summary>
        /// <param name="tableName">Name of the table being inserted to (you should pass the model name here)</param>
        /// <param name="auditBatch">The audit batch, will specify the EventBatch and user, sample ids etc</param>
        /// <param name="auditStructDivisionId">The struct division to use for audit purposes (affects who can see). Note that an Empty value will be treated as null and converted to such.</param>
        /// <param name="insertedData">A representation of the data being inserted, typically this would take the form of a JSON representation of the list of entities being inserted. It will be written to the NewValue column.</param>
        /// <returns></returns>
        public static async Task BatchImport(
            string tableName,
            AuditBatch auditBatch,
            Guid? auditStructDivisionId,
            string insertedData)
        {
            if (string.IsNullOrEmpty(tableName)) throw new ArgumentException("required", nameof(tableName));
            if (auditBatch == null) throw new ArgumentNullException(nameof(auditBatch));

            if (auditBatch.AuditOn)
            {
                //Check this to avoid inserting invalid 00000000-0000-0000-0000-000000000000 records into AuditLog
                //There actually IS such a row for each of these, but its there to support the inner joins in the
                //audit log view. 
                bool isStructDivisionSpecified = !Guid.Empty.Equals(auditStructDivisionId??Guid.Empty);

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: auditBatch.HasUser ? auditBatch.UserId : null,
                    sampleId: auditBatch.HasSample ? auditBatch.SampleId : null,
                    eventBatch: auditBatch.EventBatch,
                    eventDate: DateTime.Now,
                    eventType: "Insert",
                    tableName: tableName,
                    recordId: null,
                    columnName: null,
                    originalValue: null,
                    newValue: insertedData,
                    structDivisionId: isStructDivisionSpecified ? auditStructDivisionId : null);
            }
        }

        /// <summary>
        /// Given a DataTable will create JSON based on its contents for use in audit events.
        /// If the table is huge this can be a heavy operation.
        /// Note: if passed null table reference will return a null without throwing exception
        /// </summary>
        /// <param name="table">DataTable</param>
        /// <returns>json or null</returns>
        public static string SerialiseDataTableToJson(DataTable table)
        {
            if (table == null) return null;
            if (table.Rows.Count == 0) return "[]"; //optimisation for empty table

            //TODO - the below could be optimised, e.g maybe we could render the JSON ourselves directly
            //       into a StringBuilder (need to take care of escaping), or maybe concatentate JSON for
            //       each item ourselves instead of holding them all in memory to serialise at once. 
            //       (If doing such optimisation do try to test the actual improvement, it may be less than
            //       you think!)
            List<Dictionary<string, object>> items = new List<Dictionary<string, object>>(table.Rows.Count);
            DataColumnCollection columns = table.Columns;
            foreach(DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>();
                foreach (DataColumn column in columns)
                {
                    string name = column.ColumnName;
                    object value = row[column];
                    item[name] = DBNull.Value.Equals(value) ? null : value;
                }
                items.Add(item);
            }
            string json = JsonConvert.SerializeObject(items, Formatting.Indented);
            return json;
        }

    } //end of AuditHelper
}
