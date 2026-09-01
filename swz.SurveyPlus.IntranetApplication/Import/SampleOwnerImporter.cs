using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Import
{
    public class SampleOwnerImporter
    {
        private class Columns
        {
            public const string Deployment = "DEPLOYMENT";
            public const string UserName = "USERNAME";
            public const string UID = "UID";
        }

        //TODO - yes, its copy pasted from responseimporter, and if I dont need to customise it here then
        //they could probably share the same class for this...
        //(although since its scoped to this importer that differentiates it in the logs nicely. hmm)
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

        public class ImportException : Exception
        {
            public ImportException(ImportContext context, Exception innerException)
                : base($"Error importing data editor assignments for dplyId={context.DplyId}, message={innerException.Message}", innerException) { }
        }

        public class ImportResults
        {
            public long DurationMilliseconds { get; private set; }
            public int DurationMinutes { get { return (int)Math.Round((double)DurationMilliseconds / 1000 / 60, 0, MidpointRounding.AwayFromZero); } }
            public int AssignmentCount { get; private set; }
            public HashSet<string> UnknownUsers { get; private set; }

            public ImportResults(
                long durationMilliseconds,
                int assignmentCount,
                HashSet<string> unknownUsers)
            {
                this.DurationMilliseconds = durationMilliseconds;
                this.AssignmentCount = assignmentCount;
                this.UnknownUsers = unknownUsers ?? throw new ArgumentNullException(nameof(unknownUsers));
            }

            public override string ToString()
            {
                return $"ImportResults[DurationMilliseconds={DurationMilliseconds}, AssignmentCount={AssignmentCount}, UnknownUsers.Count={UnknownUsers.Count}]";
            }
        }

        private readonly ILogger<SampleOwnerImporter> logger;
        private readonly ImportContext context;
        private readonly string dplyName;

        private EntityModel qnnDplySampleOwnerModel;
        private Dictionary<string, int> columnIndexByName;
        private readonly int flushInterval = 4096; //Number of rows between flushing datatables, etc from memory to db
        private bool hasDeploymentColumn = false;
        private HashSet<string> unknownUsers = new HashSet<string>();
        private DataTable dataForQnnDplySampleOwner;
        private AuditBatch auditBatch;
        private readonly Guid auditUserId;

        public SampleOwnerImporter(
            ILogger<SampleOwnerImporter> logger,
            ImportContext context,
            Guid auditUserId)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.context = context ?? throw new ArgumentNullException(nameof(context));
            this.dplyName = context.DplyName; //optimisation - copy now to save a few cycles on each row
            this.auditUserId = auditUserId;
        }

        public async Task<ImportResults> Import(Stream csvStream)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            bool debugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);
            bool traceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            logger.LogInformation(nameof(Import) + " - Starting import for DplyId={0}, DplyName={1}", context.DplyId, context.DplyName);

            qnnDplySampleOwnerModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_OWNER, Constants.Level.NoJoins);

            try
            {
                auditBatch = await AuditSettings.NewBatchAsync(auditUserId, Guid.Empty);

                //Audit log the start of the import
                await swz.Clover.Core.Utils.AuditHelper.AuditLog(auditUserId, context.DplyStructDivisionId, "SampleOwner Import", auditBatch.EventBatch);

                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
                {
                    HasHeaderRecord = true,
                };
                using (CsvReader csv = new CsvReader(new StreamReader(csvStream), csvConfiguration))
                {
                    csv.Read(); //The CSV Reader Row starts at 0, and will be 1 after this line
                    csv.ReadHeader();
                    InitialiseColumns(csv.HeaderRecord);

                    dataForQnnDplySampleOwner = PrepareDataTableForQnnDplySampleOwner();

                    using (SharedTransaction transaction = new SharedTransaction())
                    {
                        transaction.BeginTransactionAsync().Wait();

                        long existingAssignmentCount = await AssignmentCount();
                        if (existingAssignmentCount > 0)
                        {
                            throw new InvalidOperationException($"Deployment already has {existingAssignmentCount} sample owner assignments. This version of the importer only supports import to a deployment with no existing assignments.");
                        }

                        int recordIndex = -1; //Our recordIndex will have a sensible value of 0 for the first record
                        int importCount = 0;
                        try
                        {
                            int lastFlushAt = -1; //(based on importCount not recordIndex)
                            //At this point the csv Row is 1 (on the header), and will be 2 after the csv.Read() below.
                            //n.b. The RawRow can differ significantly from Row when there are multiline values in the CSV. 
                            while (csv.Read())
                            {
                                recordIndex++;
                                if (traceLoggingEnabled && (recordIndex % 1000 == 0))
                                {
                                    logger.LogTrace(nameof(Import) + " - processing recordIndex={0}, importCount={1}, lastFlushAt={2}", recordIndex, importCount, lastFlushAt);
                                }
                                if (IsRowToBeImported(csv))
                                {
                                    string uid = UID(csv);
                                    Guid listSampleId = context.ListSampleIdFor(uid);
                                    Guid? userId = User(csv);
                                    if (userId != null)
                                    {
                                        AddSampleOwner(userId.Value, listSampleId);
                                        importCount++;

                                        //Every so many imported records we shall write the accumulated data in memory to the db
                                        bool flushNow = (importCount > 0 && (importCount % flushInterval == 0));
                                        if (flushNow)
                                            lastFlushAt = Flush(transaction, importCount, recordIndex);
                                    }
                                }
                            }//end while reading csv
                            lastFlushAt = Flush(transaction, importCount, recordIndex);

                            transaction.Commit();
                        }
                        catch (Exception e)
                        {
                            await transaction.RollbackAsync().ConfigureAwait(false);
                            if (e is ImportException)
                                throw;
                            else
                                throw new RowImportException(csv, recordIndex, e);
                        }
                        long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                        ImportResults results = new ImportResults(duration, importCount, unknownUsers);
                        logger.LogInformation(nameof(Import) + " - Complete for dplyId={0} ({1}) in approximately {2} minutes, results={3})", context.DplyId, dplyName, results.DurationMinutes, results);
                        return results;
                    }//end using tx                
                }//end using csv reader
            }
            catch (Exception e)
            {
                if (e is ImportException)
                    throw;
                else
                    throw new ImportException(context, e);
            }
        }

        private Guid AddSampleOwner(Guid userId, Guid listSampleId)
        {
            Guid id = Guid.NewGuid();
            dataForQnnDplySampleOwner.Rows.Add(id, context.DplyId, listSampleId, userId);
            return id;
        }

        private int Flush(SharedTransaction transaction, int importCount, int recordIndex)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(Flush) + " - at recordIndex {0}, importCount={1}, flushing {2} assignments", recordIndex, importCount, dataForQnnDplySampleOwner.Rows.Count);
                }
                FlushSampleOwnersToDatabase(transaction);
                return importCount;
            }
            catch (Exception e)
            {
                throw new ImportException(context, e);
            }
        }

        private void FlushSampleOwnersToDatabase(SharedTransaction transaction)
        {
            DbHelper.BulkCopyDataTable(dataForQnnDplySampleOwner, transaction, 600);
            dataForQnnDplySampleOwner.Clear();
        }

        private void InitialiseColumns(string[] header)
        {
            if (header == null || header.Length < 2 || header.Length > 3)
                throw new InvalidOperationException($"Expected 2 or 3 columns in header but found {header?.Length ?? 0}");
            columnIndexByName
                = IndexingUtils.IndexUniqueElements(header, caseInsensitive: false);
            //Verify we have enough columns to work out how to import the thing
            hasDeploymentColumn = columnIndexByName.ContainsKey(Columns.Deployment); //Deployment column is optional
            if (!columnIndexByName.ContainsKey(Columns.UID))
                throw new InvalidOperationException($"Missing \"{Columns.UserName}\" column");
            if (!columnIndexByName.ContainsKey(Columns.UID))
                throw new InvalidOperationException($"Missing \"{Columns.UID}\" column");
        }

        private string UID(CsvReader csv)
        {
            string uid = csv.GetField(Columns.UID).Trim();
            if (string.IsNullOrWhiteSpace(uid))
                throw new InternalException($"The \"{Columns.UID}\" column does not have a value");
            return uid;
        }

        private bool IsRowToBeImported(CsvReader csv)
        {
            if(hasDeploymentColumn)
            {
                string deployment = csv.GetField(Columns.Deployment);
                if (string.IsNullOrEmpty(deployment))
                    throw new InternalException($"The \"{Columns.Deployment}\" column does not have a value");
                return dplyName.Equals(deployment);
            }
            else
            {
                return true;
            }
        }

        private Guid? User(CsvReader csv)
        {
            string username = csv.GetField(Columns.UserName);
            if (string.IsNullOrEmpty(username))
            {
                throw new InternalException($"The \"{Columns.UserName}\" column does not have a value");
            }
            else
            {
                Guid? userId = context.UserIdFor(username);
                if(userId==null) unknownUsers.Add(username);
                return userId;
            }
        }

        private async Task<long> AssignmentCount()
        {
            Filter forDplyId = Filter.And.Equal(context.DplyId, Constants.FieldName.DplyId);
            long count = await qnnDplySampleOwnerModel.GetCountAsync(forDplyId);
            return count;
        }

        private DataTable PrepareDataTableForQnnDplySampleOwner()
        {
            DataTable qnnDplySampleOwnerTable = new DataTable("dbo." + Constants.ModelName.QNN_DPLY_SAMPLE_OWNER);
            qnnDplySampleOwnerTable.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            qnnDplySampleOwnerTable.Columns.Add(Constants.FieldName.DplyId, typeof(Guid));
            qnnDplySampleOwnerTable.Columns.Add(Constants.FieldName.ListSampleId, typeof(Guid));
            qnnDplySampleOwnerTable.Columns.Add(Constants.FieldName.UserId, typeof(Guid));
            return qnnDplySampleOwnerTable;
        }
    }
}
