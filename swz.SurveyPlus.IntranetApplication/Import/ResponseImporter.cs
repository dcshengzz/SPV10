using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Import
{
    public class ResponseImporter
    {
        /// <summary>
        /// Thrown for errors that occur while reading rows from the csv
        /// </summary>
        public class RowImportException : Exception
        {
            public int RecordIndex { get; private set; }
            public int CsvRow { get; private set; }
            public int RawRow { get; private set; }

            public RowImportException(CsvReader csv, int recordIndex, Exception innerException) 
                : base($"Error in row import at recordIndex={recordIndex}, csv row={csv.Parser.Row}, raw file row={csv.Parser.RawRow}, message={innerException.Message}", innerException)
            {
                this.RecordIndex = recordIndex;
                this.CsvRow = csv.Parser.Row;
                this.RawRow = csv.Parser.RawRow;
            }
        }

        public class ImportResults
        {
            public long DurationMilliseconds { get; private set; }
            public int DurationMinutes { get { return (int)Math.Round((double)DurationMilliseconds / 1000 / 60, 0, MidpointRounding.AwayFromZero); } }
            public int ResponseCount { get; private set; }
            public HashSet<string> UnknownUsers { get; private set; }

            public ImportResults(
                long durationMilliseconds,
                int responseCount,
                HashSet<string> unknownUsers)
            {
                this.DurationMilliseconds = durationMilliseconds;
                this.ResponseCount = responseCount;
                this.UnknownUsers = unknownUsers ?? throw new ArgumentNullException(nameof(unknownUsers));
            }

            public override string ToString()
            {
                return $"ImportResults[DurationMilliseconds={DurationMilliseconds}, ResponseCount={ResponseCount}, UnknownUsers.Count={UnknownUsers.Count}]";
            }
        }

        /// <summary>
        /// Thrown for general errors caught outside the response reading loop
        /// </summary>
        public class ImportException : Exception
        {
            public ImportException(ImportContext context, Exception innerException)
                : base($"Error importing responses for dplyId={context.DplyId}, message={innerException.Message}", innerException) { }
        }

        /// <summary>
        /// Well-known response export csv column names 
        /// </summary>
        private class Columns
        {
            //(note how the non-response-data SurveyPlus columns use a space prefix)
            public const string UID = " UID";
            public const string DateStart = " Date Start";
            public const string DateComplete = " Date Complete";
            public const string Status = " Status";
            public const string Username = " Username";
            public const string Remarks = " Remarks";
            public const string IpAddress = " IP Address";
            public const string DateUpdated = " Date Updated"; //not present in v6 and earlier exports
            //(Origin indicator column names defined elsewhere)
        }

        private struct DplySampleInfoData
        {
            public Guid Id;
            public QnnStatusId Status;
            public string Remarks;
        }

        public static async Task<ResponseImporter> GetInstanceUsingAppSettingsAsync(ImportContext context, Guid auditUserId)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            if (Guid.Empty.Equals(auditUserId)) throw new ArgumentException("may not be empty", nameof(auditUserId));
            ILogger<ResponseImporter> logger 
                = (ILogger<ResponseImporter>)DefaultApplicationLogging.CreateLogger<ResponseImporter>();
            EntityModel qnnRespModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);
            spSP_InsertResp spSP_InsertResp 
                = await spSP_InsertResp.GetInstanceUsingAppSettingsAsync();
            return new ResponseImporter(logger, context, auditUserId, qnnRespModel, spSP_InsertResp);
        }

        private readonly ILogger<ResponseImporter> logger;
        private readonly ImportContext context;
        private readonly Guid auditUserId;
        private Dictionary<string, int> columnIndexByName;
        private readonly int flushInterval = 64; //Number of rows between flushing datatables, etc from memory to db
        private DateTime importDate;
        private AuditBatch auditBatch = null;

        //Data being imported to batch up for writing to the db
        private DataTable dataForQnnRespAns;
        private List<DplySampleInfoData> dataForDplySampleInfo;

        //For reporting / checking
        private HashSet<string> processedUids = new HashSet<string>();
        private HashSet<string> unknownUsers = new HashSet<string>();

        private readonly EntityModel qnnRespModel;
        private readonly spSP_InsertResp spSP_InsertResp;

        private ResponseImporter(
            ILogger<ResponseImporter> logger, 
            ImportContext context, 
            Guid auditUserId,
            EntityModel qnnRespModel,
            spSP_InsertResp spSP_InsertResp)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.context = context ?? throw new ArgumentNullException(nameof(context));
            this.qnnRespModel = qnnRespModel ?? throw new ArgumentNullException(nameof(qnnRespModel));
            this.spSP_InsertResp = spSP_InsertResp ?? throw new ArgumentNullException(nameof(spSP_InsertResp));
            this.auditUserId = auditUserId;
        }

        /// <summary>
        /// Perform the import using data from the provided CSV stream.
        /// Warning: concurrent modification of the database records for the deployment may result in undefined behaviour. 
        /// </summary>
        public async Task<ImportResults> Import(Stream csvStream)
        {
            this.importDate = DateTime.Now;
            long start = importDate.Ticks / TimeSpan.TicksPerMillisecond;
            bool debugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);
            bool traceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            bool isStrataEnabled = !string.IsNullOrEmpty(context.StrataSource);
            logger.LogInformation(nameof(Import) + " - Starting import for DplyId={0}, DplyName={1}, SampleCount={2}", context.DplyId, context.DplyName, context.SampleCount);
            try
            {
                auditBatch = await AuditSettings.NewBatchAsync(auditUserId, Guid.Empty);

                //Audit log the start of the import
                await swz.Clover.Core.Utils.AuditHelper.AuditLog(auditUserId, context.DplyStructDivisionId, "Response Import", auditBatch.EventBatch);

                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
                {
                    HasHeaderRecord = true,
                };
                using (CsvReader csv = new CsvReader(new StreamReader(csvStream), csvConfiguration))
                {
                    //TODO - throw error if the below returns false
                    csv.Read(); //The CSV Reader Row starts at 0, and will be 1 after this line
                    csv.ReadHeader();
                    InitialiseColumns(csv.HeaderRecord);

                    dataForQnnRespAns = PrepareDataTableForQnnRespAns();
                    dataForDplySampleInfo = new List<DplySampleInfoData>();

                    //TODO - tx support
                    //SQL Server can handle a huge amount of rows in a transaction , unfortunately for the importer
                    //we hit that after about 15k responses (testing with MP dummy data), likely due to the millions
                    //of rows being inserted into qnn_resp_ans. To workaround this I have commented out the transaction code
                    //for now. It may be possible to work it a different way later, such as grabbing table locks up front
                    //maybe? (is that possible)
                    using (SharedTransaction transaction = new SharedTransaction())
                    {
                        //transaction.BeginTransactionAsync().Wait(); //TODO FIX
                        long existingResponseCount = await ResponseCount();
                        if (existingResponseCount > 0)
                        {
                            throw new InvalidOperationException($"Deployment already has {existingResponseCount} existing responses. This version of the importer only supports import to a deployment with no existing responses.");
                        }

                        int recordIndex = -1; //Our recordIndex will have a sensible value of 0 for the first record
                        try
                        {
                            int lastFlushAt = -1;
                            //At this point the csv Row is 1 (on the header), and will be 2 after the csv.Read() below.
                            //n.b. The RawRow can differ significantly from Row when there are multiline values in the CSV. 
                            while (csv.Read())
                            {
                                recordIndex++;
                                if (traceLoggingEnabled && (recordIndex % 1000 == 0))
                                {
                                    logger.LogTrace(nameof(Import) + " - processing recordIndex={0}, lastFlushAt={2}", recordIndex, lastFlushAt);
                                }
                                string uid = UID(csv);
                                Guid listSampleId = context.ListSampleIdFor(uid);
                                string strata = isStrataEnabled ? Strata(csv) : null;
                                Guid respId = await CreateResponse(transaction, csv, listSampleId, strata);
                                AddDplySampleInfoData(csv, listSampleId);
                                AddResponseAnswers(respId, csv);

                                //Every so many responses we shall write the accumulated data in memory to the db
                                bool flushNow = (recordIndex > 0 && (recordIndex % flushInterval == 0));
                                if (flushNow)
                                    lastFlushAt = await Flush(transaction, recordIndex);
                            }

                            if (lastFlushAt != recordIndex)
                                lastFlushAt = await Flush(transaction, recordIndex);

                            //transaction.Commit(); //TODO - FIX

                            int responseCount = recordIndex + 1;
                            long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                            ImportResults results = new ImportResults(duration, responseCount, unknownUsers);
                            logger.LogInformation(nameof(Import) + " - Complete for dplyId={0} ({1}) in approximately {2} minutes, results={3})", context.DplyId, context.DplyName, results.DurationMinutes, results);
                            return results;
                        }
                        catch (Exception e)
                        {
                            //await transaction.RollbackAsync().ConfigureAwait(false); /?TODO FIX
                            if (e is ImportException)
                                throw;
                            else
                                throw new RowImportException(csv, recordIndex, e);
                        }
                    }//end using tx                
                }//end using csv reader
            }
            catch(Exception e)
            {
                if (e is ImportException)
                    throw;
                else
                    throw new ImportException(context, e);
            }
        }

        private async Task<int> Flush(SharedTransaction transaction, int recordIndex)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(Flush) + " - at recordIndex {0}, flushing {1} answers and {3} status updates", recordIndex, dataForQnnRespAns.Rows.Count, dataForDplySampleInfo.Count);
                }
                FlushResponseAnswersToDatabase(transaction);
                await FlushDplySampleInfoDataToDatabase();
                return recordIndex;
            }
            catch(Exception e)
            {
                throw new ImportException(context, e);
            }
        }

        private string UID(CsvReader csv)
        {
            string uid = csv.GetField(Columns.UID).Trim();
            if (string.IsNullOrWhiteSpace(uid))
                throw new InternalException($"The \"{Columns.UID}\" column does not have a value");
            if (processedUids.Contains(uid))
                throw new InternalException($"The UID \"{uid}\" has already been processed");
            else
                processedUids.Add(uid);
            return uid;
        }

        /// <summary>
        /// Lookup the Id of the user (i.e data editor) based on name in the csv, 
        /// but if absent in this instance then return null and note absense for reporting
        /// </summary>
        private Guid? ResponseUpdatedBy(CsvReader csv)
        {
            string username = ColumnValueOrDefault(Columns.Username, null, csv);
            if (string.IsNullOrEmpty(username))
            {
                //I assume this would be the case if it was only ever edited by the sample via internet side
                return null;
            }
            else
            {
                Guid? userId = context.UserIdFor(username);
                if (userId == null) unknownUsers.Add(username);
                return userId;
            }
        }

        private enum Origin { As, By, Via }
        private enum Indicator { Initial, Completed, Last }

        private string IndicatorColumn(Indicator indicator, Origin origin)
        {
            //There are much less verbose ways to implement this, but its going to be called a lot
            //so I want it to be quick
            switch (indicator)
            {
                case Indicator.Initial:
                    switch (origin)
                    {
                        case Origin.As:     return " InitialResponseAs";                            
                        case Origin.By:     return " InitialResponseBy";
                        case Origin.Via:    return " InitialResponseVia";
                        default: throw new NotImplementedException(origin.ToString());
                    }

                case Indicator.Completed:
                    switch (origin)
                    {
                        case Origin.As:     return " CompletedResponseAs";
                        case Origin.By:     return " CompletedResponseBy";
                        case Origin.Via:    return " CompletedResponseVia";
                        default: throw new NotImplementedException(origin.ToString());
                    }

                case Indicator.Last:
                    switch (origin)
                    {
                        case Origin.As:     return " LastResponseAs";
                        case Origin.By:     return " LastResponseBy";
                        case Origin.Via:    return " LastResponseVia";
                        default: throw new NotImplementedException(origin.ToString());
                    }

                default:
                    throw new NotImplementedException(indicator.ToString());
            }
        }

        private string Unknown(Origin origin)
        {
            switch (origin)
            {
                //Right now the value for all of these are "Unknown" and they are likely to stay that way
                //but for the sake of technical correctness we need to use the known unknown
                //and not an unknown unknown right?
                case Origin.As:     return Constants.ResponseAs.Unknown;
                case Origin.By:     return Constants.ResponseAs.Unknown;
                case Origin.Via:    return Constants.ResponseAs.Unknown;
                default:  throw new NotImplementedException(origin.ToString());
            }
        }

        private bool IsValidOrigin(Indicator indicator, Origin origin, string indicatorValue)
        {
            if(string.IsNullOrEmpty(indicatorValue))
            {
                switch (indicator)
                {
                    case Indicator.Initial:     return false;
                    case Indicator.Completed:   return true;  //incomplete responses won't have this value
                    case Indicator.Last:        return false;                       
                    default: throw new NotImplementedException(origin.ToString());
                }
            }
            else
            {
                switch (origin)
                {
                    case Origin.As: return ResponseApplication.IsValidResponseAs(indicatorValue);
                    case Origin.By: return ResponseApplication.IsValidResponseBy(indicatorValue);
                    case Origin.Via: return ResponseApplication.IsValidResponseVia(indicatorValue);
                    default: throw new NotImplementedException(origin.ToString());
                }
            }
        }

        private string OriginIndicator(Indicator indicator, Origin origin, CsvReader csv)
        {
            string indicatorColumnName = IndicatorColumn(indicator, origin);
            if (columnIndexByName.TryGetValue(indicatorColumnName, out int indicatorColumnIndex))
            {
                string indicatorValue = csv.GetField(indicatorColumnIndex);
                bool isValidOrigin = IsValidOrigin(indicator, origin, indicatorValue);
                if(!isValidOrigin)
                {
                    if(string.IsNullOrEmpty(indicatorValue))
                    {   //The indicator column is present but has no data. We shall treat this as Unknown
                        //(Common case of this is exported Pending rows where there was no response yet)
                        return Unknown(origin);
                    }
                    else
                    {   //The column is present but has an unrecognised value. This is an error condition.
                        throw new InternalException($"Unsupported {indicatorColumnName} value \"{indicatorValue}\"");
                    }
                }
                else
                {
                    return string.IsNullOrEmpty(indicatorValue) ? null : indicatorValue;
                }
            }            
            else
            {   //The indicator column is not present in the CSV so the indicator is Unknown 
                return Unknown(origin);
            }
        }

        private string ResponderColumn(Indicator indicator)
        {
            switch (indicator)
            {
                case Indicator.Initial:     return "InitialResponder";
                case Indicator.Completed:   return "CompletedResponder";
                case Indicator.Last:        return "LastResponder";
                default: throw new NotImplementedException(indicator.ToString());
            }
        }

        private Guid? ResponderUserId(Indicator indicator, CsvReader csv)
        {
            string originIndicator = OriginIndicator(indicator, Origin.By, csv);
            if (Constants.ResponseBy.Sample.Equals(originIndicator))
            {
                return null;
            }
            else
            {
                string responderColumnName = ResponderColumn(indicator);
                if(columnIndexByName.TryGetValue(responderColumnName, out int responderColumnIndex))
                {
                    string username = csv.GetField(responderColumnIndex);
                    if(Constants.ResponseBy.Unknown.Equals(username) || string.IsNullOrWhiteSpace(username))
                    {
                        return null;
                    }
                    else
                    {
                        Guid? userId = context.UserIdFor(username);
                        if (userId == null) unknownUsers.Add(username);
                        return userId;
                    }
                }
                else
                {
                    return null;
                }
            }
        }

        private string Strata(CsvReader csv)
        {
            return context.IsStrataEnabled
                ? ColumnValueOrDefault(context.StrataSource, null, csv)
                : null;
        }

        /// <summary>
        /// Case-insensitive read of value from csv, will return defaultValue if the column is not present.
        /// </summary>
        private string ColumnValueOrDefault(string columnName, string defaultValue, CsvReader csv)
        {
            if (columnIndexByName.TryGetValue(columnName, out int columnIndex))
                return csv.GetField(columnIndex);
            else
                return defaultValue;
        }

        private async Task<Guid> CreateResponse(SharedTransaction transaction, CsvReader csv, Guid listSampleId, String strata)
        {
            //note that we already checked for the presence of the 'essential' columns when reading header
            DateTime? dateStart 
                = ConversionUtils.ConvertToDateTimeUsingHeuristics(ColumnValueOrDefault(Columns.DateStart, null, csv)); ;
            DateTime? dateComplete 
                = ConversionUtils.ConvertToDateTimeUsingHeuristics(ColumnValueOrDefault(Columns.DateComplete, null, csv));
            DateTime? updatedDate 
                = ConversionUtils.ConvertToDateTimeUsingHeuristics(ColumnValueOrDefault(Columns.DateUpdated, null, csv)); //new column in v8 exports
            Guid? userId = ResponseUpdatedBy(csv);
            
            string ipAddress = ColumnValueOrDefault(Columns.IpAddress, null, csv);
            string initialResponseAs = OriginIndicator(Indicator.Initial, Origin.As, csv);
            string initialResponseBy = OriginIndicator(Indicator.Initial, Origin.By, csv);
            string initialResponseVia = OriginIndicator(Indicator.Initial, Origin.Via, csv);

            //New indicators introduced in MISP v6 or SurveyPlus v8
            Guid? initialResponseUserId = ResponderUserId(Indicator.Initial, csv);
            string completedResponseAs = OriginIndicator(Indicator.Completed, Origin.As, csv);
            string completedResponseBy = OriginIndicator(Indicator.Completed, Origin.By, csv);
            string completedResponseVia = OriginIndicator(Indicator.Completed, Origin.Via, csv);
            Guid? completedResponseUserId = ResponderUserId(Indicator.Completed, csv);
            string lastResponseAs = OriginIndicator(Indicator.Last, Origin.As, csv);
            string lastResponseBy = OriginIndicator(Indicator.Last, Origin.By, csv);
            string lastResponseVia = OriginIndicator(Indicator.Last, Origin.Via, csv);
            //n.b. for LastResponseUserId is based on Username (i.e. userId)

            Guid respId = Guid.NewGuid();
            await spSP_InsertResp.ExecuteAsync(
                //For audit
                auditOn: auditBatch.AuditOn,
                sampleId: null,
                structDivisionId: context.DplyStructDivisionId,
                eventBatch: auditBatch.EventBatch,
                eventDate: DateTime.Now,
                auditUserId: auditBatch.UserId,
                //For response insertion
                id: respId,
                updatedDate: updatedDate ?? importDate, //For v8 we preserve the DateUpdated if CSV has this column
                qnnId: context.QnnId,
                listSampleId: listSampleId,
                dplyId: context.DplyId,                
                dateStart: dateStart,
                dateComplete: dateComplete,
                isPrePopulated: false, //We can't actually tell is this the case if the status was Pending in csv
                lastSavedPage: null,
                anonymousId: null,
                ipAddress: ipAddress,
                initialResponseAs: initialResponseAs,
                initialResponseBy: initialResponseBy,
                initialResponseVia: initialResponseVia,
                initialResponseUserId: initialResponseUserId,
                lastResponseAs: lastResponseAs,
                lastResponseBy: lastResponseBy,
                lastResponseVia: lastResponseVia,
                userId: userId, //works as LastResponseUserId
                completedResponseAs: completedResponseAs,
                completedResponseBy: completedResponseBy,
                completedResponseVia: completedResponseVia,
                completedResponseUserId: completedResponseUserId,
                strata: strata);

            return respId;
        }

        private void AddDplySampleInfoData(CsvReader csv, Guid listSampleId)
        {
            DplySampleInfoData data = new DplySampleInfoData();
            data.Id = context.DlsiFor(listSampleId);

            string statusTitle = csv.GetField(Columns.Status);
            data.Status = context.StatusFor(statusTitle);

            data.Remarks = csv.GetField(Columns.Remarks);

            dataForDplySampleInfo.Add(data);
        }

        /// <summary>
        /// Add rows to qnnDataForRespAns for a single row (a response) in the csv
        /// </summary>
        private void AddResponseAnswers(Guid qnnRespId, CsvReader csv)
        {
            foreach(string fieldName in context.FieldNames)
            {
                string ansVal = csv.GetField(fieldName);
                Guid qnnFieldId = context.FieldIdFor(fieldName);
                bool isPrePopulated = false;
                dataForQnnRespAns.Rows.Add(qnnRespId, qnnFieldId, ansVal, isPrePopulated);
            }
        }

        private DataTable PrepareDataTableForQnnRespAns()
        {
            DataTable qnnRespAnsTable = new DataTable("dbo." + Constants.ModelName.QNN_RESP_ANS);
            qnnRespAnsTable.Columns.Add(Constants.FieldName.RespId, typeof(Guid));
            qnnRespAnsTable.Columns.Add(Constants.FieldName.QnnFieldId, typeof(Guid));
            qnnRespAnsTable.Columns.Add(Constants.FieldName.AnsVal, typeof(string));
            qnnRespAnsTable.Columns.Add(Constants.FieldName.IsPrePopulated, typeof(bool));
            return qnnRespAnsTable;
        }

        /// <summary>
        /// Write any data in dataForQnnRespAns to the db and then clear dataForQnnRespAns
        /// </summary>
        private void FlushResponseAnswersToDatabase(SharedTransaction transaction)
        {
            DbHelper.BulkCopyDataTable(dataForQnnRespAns, transaction, 600);
            dataForQnnRespAns.Clear();
        }

        /// <summary>
        /// Write any data in dataForDplySampleInfo to db and then clear dataForDplySampleInfo. Note that this
        /// is performing updates on existing rows. 
        /// </summary>
        private async Task FlushDplySampleInfoDataToDatabase()
        {
            //not efficient as it going to be calling the procedure thousands of times,
            //but lets see if its 'good enough' before trying to optimise it
            foreach(DplySampleInfoData data in dataForDplySampleInfo)
            {
                await spSP_UpdateDplySampleInfoForImport.ExecuteAsync(data.Id, data.Status, data.Remarks);
            }
            dataForDplySampleInfo.Clear();
        }

        private void InitialiseColumns(string[] header)
        {
            //TODO - if there are props with same name as alias then columns wont be unique
            //TODO - how should we be handling case-sensitivity here?
            //20231031 - IMDA have a REMARKS prop, but it should be ok because our normal remarks column has a space prefix and different case
            //20240227 - But if they roundtrip the csv through excel it might strip quotes and spaces in column headers
            try
            {
                columnIndexByName = IndexingUtils.IndexUniqueElements(NormaliseV6ColumnNamesToV8(header), caseInsensitive: false);
            }
            catch(IndexingUtils.ElementNotUniqueException duplicateColumnName)
            {
                throw new InvalidOperationException($"Duplicate \"{duplicateColumnName.ElementValue}\" column at columns {duplicateColumnName.PreviousIndex} and {duplicateColumnName.Index}");
                //(there may even be more duplicates but we fail immediately on the first one found)
            }

            //Verify we have enough columns to work out how to import the thing
            if (!columnIndexByName.ContainsKey(Columns.UID))
                throw new InvalidOperationException($"Missing \"{Columns.UID}\" column");
            if (!columnIndexByName.ContainsKey(Columns.DateStart))
                throw new InvalidOperationException($"Missing \"{Columns.DateStart}\" column");
            if (!columnIndexByName.ContainsKey(Columns.DateComplete))
                throw new InvalidOperationException($"Missing \"{Columns.DateComplete}\" column");

            //Verify we have a column for every mentioned field
            //TODO - this isn't properly handling conflicts between props and fields if there is a name clash
            List<string> missingColumns = context.FieldNames.Where(fieldName => !columnIndexByName.ContainsKey(fieldName)).ToList();
            if (missingColumns.Any())
                throw new InvalidOperationException($"Missing columns for the following fields:{string.Join(", ",missingColumns)}");
        }

        /// <summary>
        /// v6 origin indicators for 'Initial' lacked the standard space character prefix in their export
        /// column name. This method wil adjust those columns to the v8 format with space prefix.
        /// </summary>
        private string[] NormaliseV6ColumnNamesToV8(string[] header)
        {
            List<string> columns = new List<string>(header.Length);
            foreach (string columnName in header)
            {
                if (Constants.Comparers.ObjectNameCaseInsensitive.Equals(columnName, "InitialResponseAs"))
                    columns.Add(" InitialResponseAs");
                else if (Constants.Comparers.ObjectNameCaseInsensitive.Equals(columnName, "InitialResponseBy"))
                    columns.Add(" InitialResponseBy");
                else if (Constants.Comparers.ObjectNameCaseInsensitive.Equals(columnName, "InitialResponseVia"))
                    columns.Add(" InitialResponseVia");
                else
                    columns.Add(columnName);
            }
            return columns.ToArray();
        }

        private async Task<long> ResponseCount()
        {
            Filter forDplyId = Filter.And.Equal(context.DplyId, Constants.FieldName.DplyId);
            long count = await qnnRespModel.GetCountAsync(forDplyId);
            return count;
        }

    }
}
