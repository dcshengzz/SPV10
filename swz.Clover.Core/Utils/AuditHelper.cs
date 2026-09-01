using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Utils
{

    public static class AuditHelper
    {
        public static async Task<bool> GetAuditOnAsync()
        {
            AppSettings auditOnSetting = (await AppSettings.SelectAsync(Filter.And.Equal("AuditOn", "Name"))).FirstOrDefault();
            bool auditOn = auditOnSetting?.Value.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase) ?? false;
            return auditOn;
        }

        //This is used by ObservableEntityContainer
        //Most Insert and Update goes through here, and this does have support for Delete event though I think much deletion
        //goes through AuditLogDeletionByIds rather than via this.
        //2024-01-05 changed to pass in sampleId
        public static async Task AuditLog(
            IReadOnlyCollection<ChangeOperation> changes, 
            EntityModel model, 
            string eventType,
            Guid? sampleId = null)
        {
            //TODO - enforce non null changes, model, eventType

            bool auditOn = await GetAuditOnAsync();

            if (auditOn && changes.Any() && model.Name != Constants.AuditTable)
            {
                var user = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid? userId = user?.Id;
                Guid? structDivisionId = user?.StructDivisionId;
                var auditLogs = new List<DbObject<AuditLog>>();
                Guid eventBatch = Guid.NewGuid();
                DateTime eventDate = DateTime.Now;
                bool isRichUploadedFiles = IsRichUploadedFiles(model.Name);
                foreach (var change in changes)
                {
                    if (eventType == "Update")
                    {
                        foreach (var item in change.Data)
                        {
                            //for api call (respondent changes password). Add sampleId if it is null
                            if ((sampleId == null) && !userId.HasValue && model.Name.Equals("QNN_SAMPLE", StringComparison.OrdinalIgnoreCase))
                            {
                                sampleId = (Guid?)change.Entity["Id"];
                            }

                            PlainAttributeModel attribute = model.GetAttributeByName(item.PropertyName) as PlainAttributeModel;
                            string columnName = attribute?.ColumnName;

                            //For the Data column in dwUploadedFiles it can be huge, so we don't log the values anymore
                            bool isFileDataColumn = isRichUploadedFiles && "Data".Equals(columnName, StringComparison.OrdinalIgnoreCase);

                            auditLogs.Add(new AuditLog
                            {
                                //Id = Guid.NewGuid(),
                                UserId = userId,
                                SampleId = sampleId,
                                EventBatch = eventBatch,
                                EventDate = eventDate,
                                EventType = eventType,
                                TableName = model.Name,
                                RecordId = (Guid?)change.Entity["Id"],
                                ColumnName = columnName,
                                OriginalValue = isFileDataColumn ? null : item.InitialValue?.ToString(),
                                NewValue = isFileDataColumn ? null : item.NewValue?.ToString(),
                                StructDivisionId = structDivisionId
                            });
                        }
                    }
                    else if (eventType == "Delete")
                    {
                        if (change.Entity != null)
                        {
                            string originalValue;
                            if(isRichUploadedFiles)
                            {
                                //Data can be huge for files so we remove it from the audit record
                                Dictionary<string, object> value = change.Entity.ToDictionary();
                                value.Remove("Data");
                                originalValue = JsonConvert.SerializeObject(value, Formatting.Indented);
                            }
                            else
                            {
                                originalValue = change.Entity.SerializeWithIndentation();
                            }

                            auditLogs.Add(new AuditLog
                            {
                                UserId = userId,
                                SampleId = sampleId,
                                EventBatch = eventBatch,
                                EventDate = eventDate,
                                EventType = eventType,
                                TableName = model.Name,
                                RecordId = (Guid?)change.Entity["Id"],
                                ColumnName = null,
                                OriginalValue = originalValue,
                                NewValue = null,
                                StructDivisionId = structDivisionId
                            });
                        }
                    }
                    else if (eventType == "Insert")
                    {
                        string newValue;
                        if(isRichUploadedFiles)
                        {
                            //Data can be huge for files so we remove it from the audit record
                            Dictionary<string, object> value = change.Entity.ToDictionary();
                            value.Remove("Data");
                            newValue = JsonConvert.SerializeObject(value, Formatting.Indented);
                        }
                        else
                        {
                            newValue = change.Entity.SerializeWithIndentation();
                        }

                        auditLogs.Add(new AuditLog
                        {
                            //Id = Guid.NewGuid(),
                            UserId = userId,
                            SampleId = sampleId,
                            EventBatch = eventBatch,
                            EventDate = eventDate,
                            EventType = eventType,
                            TableName = model.Name,
                            RecordId = (Guid?)change.Entity["Id"],
                            ColumnName = null,
                            OriginalValue = null,
                            NewValue = newValue,
                            StructDivisionId = structDivisionId
                        });
                    }
                }

                foreach (AuditLog item in auditLogs)
                {
                    await item.InsertUsingStoredProcedureAsync();
                }
            }
        }

        //2024-01-05 - changed to take in sampleId
        //This is used by DbObject
        /// <summary>
        /// Log removals (Delete events)
        /// </summary>
        public static async Task AuditLogDeletionByIds<TPk>(
            List<TPk> ids, 
            EntityModel model, 
            Guid? sampleId=null)
        {
            if (ids == null) throw new NullReferenceException(nameof(ids)); //empty is ok, but null indicates a coding error by caller
            if (model == null) throw new NullReferenceException(nameof(model));

            //Under U@App ORM only works on intranet side where sampleId is always null in the session
            //so (20240105) have changed to pass it in instead with a default of null. If we implement U@Db
            //again may need to pass the value at the approriate time.

            bool auditOn = await GetAuditOnAsync();

            if (auditOn && ids.Any() && model.Name != Constants.AuditTable)
            {
                //TODO - the following should be batched. Firstly the IN condition has an upper limit in SQL Server
                //       and perhaps more importantly to restrict the size of each AuditLog entry here. Even though
                //       the IN limit is something like 2100 (iirc) we should probably look at batches of maybe just
                //       16 or 32? Its not a high priority change as we usually get here via a UI interaction and
                //       those typically only have 1 or a few records selected for deletion anyway.
                Filter byId = Filter.And.In(ids, "Id");
                string originalValue;                
                if(IsRichUploadedFiles(model.Name))
                {
                    //Special treatment to exclude Data column, use the UploadedFilesPoor model instead
                    originalValue = JsonConvert.SerializeObject((await UploadedFilesPoor.SelectAsync(byId)), Formatting.Indented);
                }
                else
                {
                    originalValue = JsonConvert.SerializeObject(
                        (await model.GetAsync(byId)).Select(dm => dm.Dictionary).ToList(),
                        Formatting.Indented);
                }

                Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                Guid eventBatch = Guid.NewGuid(); //TODO - need a way to provide this from a higher level (thread local?)

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: user?.Id,
                    sampleId: sampleId, 
                    eventBatch: eventBatch,
                    eventDate: DateTime.Now,
                    eventType: "Delete",  //TODO - consider whether multiple deletion by id should gets its own distinct event type
                    tableName: model.Name,
                    recordId: null,
                    columnName: null,
                    originalValue: originalValue,
                    newValue: null,
                    structDivisionId: user?.StructDivisionId);
            }
        }

        public static async Task AuditLog(Guid userId, Guid? structDivisionId, string eventType, Guid? eventBatch=null)
        {
            bool auditOn = await GetAuditOnAsync();

            if (auditOn)
            {
                if(eventBatch==null) eventBatch = Guid.NewGuid();
                var eventDate = DateTime.Now;

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: userId,
                    sampleId: null,
                    eventBatch: eventBatch.Value,
                    eventDate: eventDate,
                    eventType: eventType,
                    tableName: null,
                    recordId: null,
                    columnName: null,
                    originalValue: null,
                    newValue: null,
                    structDivisionId: structDivisionId);
            }
        }

        public static async Task AuditLog(Guid? userId, Guid? sampleId, Guid? structDivisionId, string eventType)
        {
            bool auditOn = await GetAuditOnAsync();

            if (auditOn)
            {
                var eventBatch = Guid.NewGuid();
                var eventDate = DateTime.Now;

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: userId,
                    sampleId: sampleId,
                    eventBatch: eventBatch,
                    eventDate: eventDate,
                    eventType: eventType,
                    tableName: null,
                    recordId: null,
                    columnName: null,
                    originalValue: null,
                    newValue: null,
                    structDivisionId: structDivisionId);
            }
        }

        public static async Task AuditLog(Guid? userId, Guid? sampleId, Guid? structDivisionId, string eventType, string tableName)
        {
            bool auditOn = await GetAuditOnAsync();

            if (auditOn)
            {
                //var auditLogs = new List<DbObject<AuditLog>>();
                var eventBatch = Guid.NewGuid();
                var eventDate = DateTime.Now;

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: userId,
                    sampleId: sampleId,
                    eventBatch: eventBatch,
                    eventDate: eventDate,
                    eventType: eventType,
                    tableName: tableName,
                    recordId: null,
                    columnName: null,
                    originalValue: null,
                    newValue: null,
                    structDivisionId: structDivisionId);
            }
        }

        /// <summary>
        /// Log login failed from intranet and internet with valid userId or sampleId
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="sampleId"></param>
        /// <param name="structDivisionId"></param>
        /// <returns></returns>
        public static async Task AuditLogLoginFailed(Guid? userId, Guid? sampleId, Guid? structDivisionId)
        {
            bool auditOn = await GetAuditOnAsync();

            if (auditOn)
            {
                var eventBatch = Guid.NewGuid();
                var eventDate = DateTime.Now;

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: userId,
                    sampleId: sampleId,
                    eventBatch: eventBatch,
                    eventDate: eventDate,
                    eventType: "LoginFailed",
                    tableName: null,
                    recordId: null,
                    columnName: null,
                    originalValue: null,
                    newValue: null,
                    structDivisionId: structDivisionId);
            }
        }


        /// <summary>
        /// This is use for audit log for fail login (do not have GUID or ID)
        /// This will use originalValue to log the failed login username/AD
        /// </summary>
        /// <param name="originalValue"></param>
        /// <returns></returns>
        public static async Task AuditLogLoginFailed(string originalValue)
        {
            bool auditOn = await GetAuditOnAsync();

            if (auditOn)
            {
                var eventBatch = Guid.NewGuid();
                var eventDate = DateTime.Now;

                await InsertAuditLog.InsertAuditLogAsync(
                    userId: null,
                    sampleId: null,
                    eventBatch: eventBatch,
                    eventDate: eventDate,
                    eventType: "LoginFailed",
                    tableName: null,
                    recordId: null,
                    columnName: null,
                    originalValue: originalValue,
                    newValue: null,
                    structDivisionId: null);
            }
        }

        /// <summary>
        /// Returns true if the model name is known to be a model for the dwUploadedFiles table other than UploadedFilesPoor
        /// (i.e. UploadedFiles, dwUploadedFiles). Callers will use this information as part of excluding its Data column
        /// for auditing changes to dwUploadedFiles. (Due to size concerns)
        /// </summary>
        /// <param name="modelName"></param>
        /// <returns></returns>
        private static bool IsRichUploadedFiles(string modelName)
        {
            //(Don't add UploadedFilesPoor here)
            return
                "UploadedFiles".Equals(modelName, StringComparison.OrdinalIgnoreCase)
                || "dwUploadedFiles".Equals(modelName, StringComparison.OrdinalIgnoreCase);
        }
    }
}
