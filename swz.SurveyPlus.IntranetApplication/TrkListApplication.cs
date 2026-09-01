using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class TrkListApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(TrkListApplication));

        public class TrkListImportResult
        {
            public static TrkListImportResult SuccessResult(Dictionary<string,object> statistics, List<ImportResultInfo> items)
            {
                return new TrkListImportResult(true, "Imported successfully", statistics, items);
            }

            public static TrkListImportResult Fail(string message)
            {
                return new TrkListImportResult(false, message, null, null);
            }

            public bool Success { get; private set; }
            public string Message { get; private set; } //will be returned to clientside
            public Dictionary<string,object> Statistics { get; private set; }
            public List<ImportResultInfo> Items { get; private set; }

            private TrkListImportResult(bool success, string message, Dictionary<string,object> statistics, List<ImportResultInfo> items)
            {
                this.Success = success;
                this.Message = message;
                this.Statistics = statistics;
                this.Items = items;
            }

            public override string ToString()
            {
                return nameof(TrkListImportResult) + $"[Success={Success}, Message={Message}]";
            }
        }

        public static async Task<TrkListImportResult> ImportTrkList(
            User importingUser,
            Guid trkListGuid,
            string token)
        {
            bool cleanupTempFile = false; //Will set to true once satisfied that token is legitimate
            try
            {
                if (importingUser == null) throw new ArgumentNullException(nameof(importingUser));
                if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));

                Guid userId = importingUser.Id;
                Guid auditStructDivisionId = importingUser.StructDivisionId.Value;
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(userId);

                try
                {
                    await TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.AssertUploadedCsvAttributes(logger, token, importingUser);
                    
                    //At this point we are satisfied the token is legitimate and can be cleaned up afterwards
                    //(regardless of how the actual import turns out). Note this implies uploads of the wrong file
                    //type don't get cleaned up as we aren't fully sure of token's legitimacy. See issue #200
                    cleanupTempFile = true;
                }
                catch(InvalidUploadedFileException invalidFileEx)
                {
                    //Note that in this case the file is NOT cleaned up from the db (in case its some other file
                    //passed to this endpoint and not actually the one the user just uploaded)
                    return TrkListImportResult.Fail(TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(invalidFileEx.Message, "Invalid file"));
                }
                catch(NotFoundException)
                {
                    return TrkListImportResult.Fail("The upload has expired");
                }

                (Stream stream, Dictionary<string, string> properties) = await CloverRuntime.ContentProvider.GetAsync(token);
                if(stream == null || properties == null) //shouldn't happen as we already checked file above
                    throw new NotFoundException($"Failed to find file using token {token}");

                var rows = new List<dynamic>();
                var uidSampleIdHashTable = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
                string[] headerRowColumns;
                using (stream)
                {
                    CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
                    {
                        HasHeaderRecord = true,
                        DetectColumnCountChanges = true
                    };
                    using (CsvReader csv = new CsvReader(new StreamReader(stream), csvConfiguration))
                    {
                        //Parse the header
                        try
                        {
                            bool hasContent = csv.Read();
                            if (!hasContent)
                                return TrkListImportResult.Fail("File is empty");
                            csv.ReadHeader();
                            headerRowColumns = csv.HeaderRecord;
                        }
                        catch (CsvHelperException csvhex)
                        {
                            if (logger.IsEnabled(LogLevel.Trace))
                            {
                                //Log at trace level because CsvHelper tries to include the raw record
                                //which here is typically non-printable junk because its wrong file type
                                //TODO - CsvHelper has a config option to suppress raw data, to consider using it
                                logger.LogTrace(csvhex, nameof(ImportTrkList) + " - failed to read csv header (returning BadFile result)");
                            }
                            return TrkListImportResult.Fail("File is invalid");
                        }

                        //Parse all the data rows
                        try
                        {
                            rows = csv.GetRecords<dynamic>().ToList();
                        }
                        catch (CsvHelperException csvhex)
                        {
                            string badColumn 
                                = (csv.CurrentIndex > -1 && csv.CurrentIndex < csvhex.Context.Reader.HeaderRecord.Length)
                                ? csvhex.Context.Reader.HeaderRecord[csv.CurrentIndex] 
                                : "column unknown or N/A";                            
                            if (csvhex is CsvHelper.BadDataException)
                            {   //bad format, e.g unclosed quotes, wrong column count
                                if (csvhex.Context.Reader.ColumnCount != csvhex.Context.Reader.HeaderRecord.Length)
                                {
                                    return TrkListImportResult.Fail($"Invalid column count, expected {csvhex.Context.Reader.HeaderRecord.Length} but found {csvhex.Context.Reader.ColumnCount}, in row {csvhex.Context.Reader.Parser.Row}");
                                } 
                                else
                                {
                                    return TrkListImportResult.Fail($"Bad data in column {csvhex.Context.Reader.CurrentIndex} ({badColumn}), in row {csvhex.Context.Reader.Parser.Row}");
                                }
                            }
                            else
                            {
                                return TrkListImportResult.Fail($"Check column {csvhex.Context.Reader.CurrentIndex} ({badColumn}), in row {csvhex.Context.Reader.Parser.Row}");
                            }
                        }
                    } //end using csvreader
                } //end using stream

                var arrSysColName =
                    Constants.TrackListCsv.COLUMNS.Split(",", StringSplitOptions.RemoveEmptyEntries);


                // ' Check complusory columns
                for (var iCol = 0; iCol <= arrSysColName.Length - 1; iCol++)
                    if (headerRowColumns[iCol].ToUpper() != arrSysColName[iCol])
                        return TrkListImportResult.Fail("System Columns mismatch!");


                // ' Load users
                var lstImportResult = new List<ImportResultInfo>();
                bool bErr;
                var iCntExc = 0;
                var iCntTot = 0;
                var iCntTrkListSampleAdd = 0;
                var iCntTrkListSampleMod = 0;

                DataTable qnnTrkListSampleForInsert = QnnTrackListSampleDataTable();

                //Set to track which new UIDs we have already seen in the csv (for duplicate handling)
                HashSet<string> processedUids = new HashSet<string>(Constants.Comparers.UidCaseInsensitive);

                List<dynamic> qnnTrkListSampleForUpdate = new List<dynamic>();

                Dictionary<string, QnnStatusId> statusIdByCode 
                    = await ResponseApplication.GetStatusCodeToIdDictionary();

                //Get the existing QNN_TRACK_LIST_SAMPLE for this track list, index by UID for lookup convenience
                EntityModel qnnTrkListSampleModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_TRK_LIST_SAMPLE, Constants.Level.NoJoins);
                IDictionary<string,DynamicEntity> existingTrkListSampleByUid
                    = (await qnnTrkListSampleModel.GetAsync(Filter.And.Equal(trkListGuid, Constants.FieldName.TrkListId)))
                    .ToImmutableDictionary(
                        sample => (string)sample[Constants.FieldName.UID],
                        sample => sample,
                        Constants.Comparers.UidCaseInsensitive);

                for (var iRow = 0; iRow <= rows.Count - 1; iRow++)
                {
                    bErr = false;
                    iCntTot += 1;
                    var rowDict = (IDictionary<string, object>)rows[iRow];
                    string UID = rowDict[arrSysColName[Constants.TrackListCsv.idxUid]]?.ToString();
                    // ' (1)  UID
                    string uidColumnName = arrSysColName[Constants.TrackListCsv.idxUid];
                    if (string.IsNullOrEmpty(UID))
                    {
                        // ' (a) Check REQUIRED field
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, uidColumnName, "The field is required"));
                    }
                    else if (UID.Length > 320)
                    {
                        // ' (b)  Input length
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, uidColumnName, $"{uidColumnName} exceeds 320 characters"));
                    }

                    // ' (2)  NAME
                    string name = rowDict[arrSysColName[Constants.TrackListCsv.idxName]]?.ToString();
                    string nameColumnName = arrSysColName[Constants.TrackListCsv.idxName];
                    if (string.IsNullOrEmpty(name))
                    {
                        // ' (a) Check REQUIRED field
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, nameColumnName, "The field is required"));
                    }
                    else if (name.Length > 128)
                    {
                        // ' (b)  Input length
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, nameColumnName, $"{nameColumnName} exceeds 128 characters"));
                    }

                    // ' (3) EMAIL
                    string email = rowDict[arrSysColName[Constants.TrackListCsv.idxEmail]]?.ToString();
                    string emailColumnName = arrSysColName[Constants.TrackListCsv.idxEmail];
                    if (!string.IsNullOrEmpty(email) && !Clover.Core.Utils.Email.IsAddressFormatValid(email))
                    {
                        // ' (a) Format
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, emailColumnName, $"Invalid email address"));
                    }

                    // ' (4) Remarks
                    string remarks = rowDict[arrSysColName[Constants.TrackListCsv.idxRemarks]]?.ToString();

                    // ' (5) StatusCode
                    string statusCode = rowDict[arrSysColName[Constants.TrackListCsv.idxStatusCode]]?.ToString();
                    string statusCodeColumnName = arrSysColName[Constants.TrackListCsv.idxStatusCode];
                    QnnStatusId statusId;
                    if (string.IsNullOrEmpty(statusCode))
                    {
                        //Specifying a status value is optional
                        statusId = null;
                    }
                    else if (!statusIdByCode.ContainsKey(statusCode))
                    {
                        statusId = null;
                        bErr = true;
                        lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, statusCodeColumnName, "Invalid status code"));
                    }
                    else
                    {
                        statusId = statusIdByCode[statusCode];
                    }

                    if (!bErr)
                    {
                        bool uidSeenAlreadyInCsv = processedUids.Contains(UID);
                        if(uidSeenAlreadyInCsv)
                        {
                            lstImportResult.Add(new ImportResultInfo(iRow + 1, UID, uidColumnName, "Duplicate UID"));
                        }
                        else
                        {
                            processedUids.Add(UID);
                            bool isNewSampleRequiringInsertion = !existingTrkListSampleByUid.ContainsKey(UID);
                            if (isNewSampleRequiringInsertion)
                            {
                                qnnTrkListSampleForInsert.Rows.Add(
                                    UID,                //UID
                                    trkListGuid,        //TrkListId
                                    name,               //Name
                                    email,              //Email
                                    remarks,            //Remarks
                                    userId,             //CreatedBy
                                    DateTime.Now,       //CreatedDate
                                    statusId?.Value);   //Status
                                iCntTrkListSampleAdd += 1;
                            }
                            else
                            {
                                DynamicEntity trkListSampleEntity = existingTrkListSampleByUid[UID];
                                trkListSampleEntity[Constants.FieldName.UpdatedBy] = userId;
                                trkListSampleEntity[Constants.FieldName.UpdatedDate] = DateTime.Now;
                                trkListSampleEntity[Constants.FieldName.Name] = name;
                                trkListSampleEntity[Constants.FieldName.Email] = email;
                                trkListSampleEntity[Constants.FieldName.Remarks] = remarks;
                                trkListSampleEntity[Constants.FieldName.Status] = statusId?.Value;
                                qnnTrkListSampleForUpdate.Add(trkListSampleEntity);
                                iCntTrkListSampleMod += 1;                                
                            }
                        }
                    }
                    else
                    {
                        iCntExc += 1;
                    }
                }

                bool isAnyNewTrackListSamples = qnnTrkListSampleForInsert.Rows.Count > 0;
                if (isAnyNewTrackListSamples)
                {
                    using (SharedTransaction forConnection = new SharedTransaction())
                    {
                        //Not starting a tx here, just using SharedTransaction to get a connection
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(qnnTrkListSampleForInsert, forConnection, timeoutSeconds: 120);
                    }

                    //audit
                    if (auditBatch.AuditOn)
                    {
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(qnnTrkListSampleForInsert);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_TRK_LIST_SAMPLE,
                            auditBatch,
                            auditStructDivisionId,
                            newValue);
                    }
                }

                (long updated, long inserted) = await DbHelper.BulkDataUpdate(
                    qnnTrkListSampleForUpdate.Cast<DynamicEntity>().ToList(), 
                    qnnTrkListSampleModel);

                return TrkListImportResult.SuccessResult(
                    new Dictionary<string, object>
                    {
                        { "totalRows", rows.Count },
                        { "exceptionCount", iCntExc },
                        { "trkListSampleAdded", iCntTrkListSampleAdd },
                        { "trkListSampleUpdated", iCntTrkListSampleMod }
                    },
                    lstImportResult);
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ImportTrkList) + " - caught an unexpected exception, trkListGuid={0}, token={1}", trkListGuid, token);
                throw;
            }
            finally
            {
                if(cleanupTempFile)
                {
                    //We can delete the temporary file from database now
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(ImportTrkList) + " - removing file with token {0}", token);
                    await CloverRuntime.ContentProvider.RemoveAsync(token);
                }
            }
        }

        /// <summary>
        /// Checks dwAppSettings to see if the the track list feature is enabled for this instance
        /// </summary>
        /// <returns>true if track list feature enabled</returns>
        public static async Task<bool> GetTrkListActiveYN()
        {
            string trkListActiveYN = (await SettingsHelper.GetValue(Constants.dwAppSettingName.TrkListActiveYN)).Trim();
            return ConversionUtils.IsTrueYN(trkListActiveYN);
        }

        private static DataTable QnnTrackListSampleDataTable()
        {
            DataTable table = new DataTable("dbo." + Constants.ModelName.QNN_TRK_LIST_SAMPLE);
            table.Columns.Add(Constants.FieldName.UID, typeof(string));
            table.Columns.Add(Constants.FieldName.TrkListId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.Name, typeof(string));
            table.Columns.Add(Constants.FieldName.Email, typeof(string));
            table.Columns.Add(Constants.FieldName.Remarks, typeof(string));
            table.Columns.Add(Constants.FieldName.CreatedBy, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));
            table.Columns.Add(Constants.FieldName.Status, typeof(Guid));
            return table;
        }
    }
}
