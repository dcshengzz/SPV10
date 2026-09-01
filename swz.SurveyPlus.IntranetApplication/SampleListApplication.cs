using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class SampleListApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(SampleListApplication));

        public static async Task<(string Message, bool IsSuccessful)> DuplicateSampleList(
            Guid sourceId, 
            string name, 
            User user)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));
            try
            {
                if (string.IsNullOrWhiteSpace(name))
                {
                    return ("Title is not specified", false);
                }

                DateTime now = DateTime.Now;

                EntityModel qnnListModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST, Constants.Level.NoJoins);
                EntityModel qnnListSampleModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.NoJoins);
                EntityModel qnnListPropModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, Constants.Level.NoJoins);
                EntityModel qnnListSamplePropModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE_PROP, Constants.Level.NoJoins);

                using (SharedTransaction shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();
                    int sqlMaxTransaction = 500;

                    //Verify the name is free first
                    if (qnnListModel.GetAsync(Filter.And.Equal(name, Constants.FieldName.Name))
                        .Result
                        .FirstOrDefault() != null)
                    {
                        return ("A sample list with this name already exists", false);
                    }

                    DynamicEntity sourceList = await SampleListApplication.GetQnnListAsync(sourceId, qnnListModel);
                    if (sourceList == null)
                        throw NotFoundException.ForModelName(qnnListModel.Name, sourceId);

                    List<DynamicEntity> sourceSamples = await qnnListSampleModel.GetAsync(Filter.And.Equal(sourceId, Constants.FieldName.ListId));
                    List<DynamicEntity> sourceProps = await qnnListPropModel.GetAsync(Filter.And.Equal(sourceId, Constants.FieldName.ListId));

                    //Copy qnn first (this is the aggregate root)
                    DynamicEntity destQnnList = await qnnListModel.NewAsync();
                    destQnnList[Constants.FieldName.Name] = name;
                    destQnnList[Constants.FieldName.Description] = sourceList[Constants.FieldName.Description];
                    destQnnList[Constants.FieldName.Status] = sourceList[Constants.FieldName.Status];
                    destQnnList[Constants.FieldName.CategoryId] = sourceList[Constants.FieldName.CategoryId];
                    destQnnList[Constants.FieldName.UIDUsrEditYN] = sourceList[Constants.FieldName.UIDUsrEditYN];
                    destQnnList[Constants.FieldName.NameUsrEditYN] = sourceList[Constants.FieldName.NameUsrEditYN];
                    destQnnList[Constants.FieldName.EmailUsrEditYN] = sourceList[Constants.FieldName.EmailUsrEditYN];
                    destQnnList[Constants.FieldName.ActiveUsrEditYN] = sourceList[Constants.FieldName.ActiveUsrEditYN];
                    destQnnList[Constants.FieldName.PasswordUsrEditYN] = sourceList[Constants.FieldName.PasswordUsrEditYN];
                    destQnnList[Constants.FieldName.CreatedBy] = user.Id;
                    destQnnList[Constants.FieldName.CreatedDate] = now;
                    destQnnList[Constants.FieldName.UpdatedBy] = user.Id;
                    destQnnList[Constants.FieldName.UpdatedDate] = now;
                    destQnnList[Constants.FieldName.StructDivisionId] = user.StructDivisionId.Value;
                    destQnnList[Constants.FieldName.Tags] = sourceList[Constants.FieldName.Tags];

                    await qnnListModel.UpdateSingleAsync(destQnnList);
                    Guid destQnnListId = (Guid)destQnnList.GetId();

                    //Copy QNN_LIST_SAMPLE
                    Dictionary<Guid, Guid> previousListSampleIdLinkNewListSampleId = new Dictionary<Guid, Guid>();
                    List<dynamic> destSamples = new List<dynamic>();
                    foreach (DynamicEntity sourceSample in sourceSamples)
                    {
                        Guid oldListSampleId = Guid.Parse(sourceSample[Constants.FieldName.Id].ToString());
                        Guid newListSampleId = Guid.NewGuid();
                        previousListSampleIdLinkNewListSampleId.Add(oldListSampleId, newListSampleId);

                        DynamicEntity destSample = await qnnListSampleModel.NewAsync();
                        destSample[Constants.FieldName.Id] = newListSampleId;
                        destSample[Constants.FieldName.ListId] = destQnnListId;
                        destSample[Constants.FieldName.ActiveYN] = sourceSample[Constants.FieldName.ActiveYN];
                        destSample[Constants.FieldName.CreatedBy] = user.Id;
                        destSample[Constants.FieldName.CreatedDate] = now;
                        destSample[Constants.FieldName.UpdatedBy] = user.Id;
                        destSample[Constants.FieldName.UpdatedDate] = now;
                        destSample[Constants.FieldName.SampleId] = sourceSample[Constants.FieldName.SampleId];
                        destSample[Constants.FieldName.SamplePeerId] = sourceSample[Constants.FieldName.SamplePeerId];
                        destSamples.Add(destSample);
                    }
                    foreach (List<dynamic> batchDestSamples in destSamples.ChunkBy(sqlMaxTransaction).ToList())
                    {
                        await qnnListSampleModel.UpdateAsync(batchDestSamples);
                    }

                    //Copy QNN_LIST_PROP
                    List<dynamic> destProps = new List<dynamic>();
                    List<dynamic> destSampleProps = new List<dynamic>();
                    foreach (DynamicEntity sourceProp in sourceProps)
                    {
                        DynamicEntity destProp = await qnnListPropModel.NewAsync();
                        Guid listPropId = Guid.NewGuid();
                        destProp[Constants.FieldName.Id] = listPropId;
                        destProp[Constants.FieldName.ListId] = destQnnListId;
                        destProp[Constants.FieldName.Type] = sourceProp[Constants.FieldName.Type];
                        destProp[Constants.FieldName.Alias] = sourceProp[Constants.FieldName.Alias];
                        destProp[Constants.FieldName.ReqdYN] = sourceProp[Constants.FieldName.ReqdYN];
                        destProp[Constants.FieldName.UsrEditYN] = sourceProp[Constants.FieldName.UsrEditYN];
                        destProp[Constants.FieldName.TxtRow] = sourceProp[Constants.FieldName.TxtRow];
                        destProp[Constants.FieldName.TxtRegExp] = sourceProp[Constants.FieldName.TxtRegExp];
                        destProp[Constants.FieldName.TxtRegExpErr] = sourceProp[Constants.FieldName.TxtRegExpErr];
                        destProp[Constants.FieldName.OptType] = sourceProp[Constants.FieldName.OptType];
                        destProp[Constants.FieldName.UsrVisibleYN] = sourceProp[Constants.FieldName.UsrVisibleYN];
                        destProp[Constants.FieldName.RespVisibleYN] = sourceProp[Constants.FieldName.RespVisibleYN];
                        destProps.Add(destProp);

                        List<DynamicEntity> sourceSampleProps = await qnnListSamplePropModel.GetAsync(Filter.And.Equal(sourceId, Constants.FieldName.ListId).NestAnd().Equal(sourceProp[Constants.FieldName.Id], Constants.FieldName.ListPropId));

                        //Copy QNN_LIST_SAMPLE_PROP Value
                        foreach (DynamicEntity sourceSampleProp in sourceSampleProps)
                        {
                            Guid previousListSampleId = Guid.Parse(sourceSampleProp[Constants.FieldName.ListSampleId].ToString());
                            previousListSampleIdLinkNewListSampleId.TryGetValue(previousListSampleId, out Guid newListSampleId);

                            DynamicEntity destSampleProp = await qnnListSamplePropModel.NewAsync();
                            destSampleProp[Constants.FieldName.ListId] = destQnnListId;
                            destSampleProp[Constants.FieldName.ListSampleId] = newListSampleId;
                            destSampleProp[Constants.FieldName.ListPropId] = listPropId;
                            destSampleProp[Constants.FieldName.PropValue] = sourceSampleProp[Constants.FieldName.PropValue];
                            destSampleProps.Add(destSampleProp);
                        }
                    }
                    foreach (List<dynamic> batchDestProps in destProps.ChunkBy(sqlMaxTransaction).ToList())
                    {
                        await qnnListPropModel.UpdateAsync(batchDestProps);
                    }
                    foreach (List<dynamic> batchDestSampleProps in destSampleProps.ChunkBy(sqlMaxTransaction).ToList())
                    {
                        await qnnListSamplePropModel.UpdateAsync(batchDestSampleProps);
                    }

                    shared.Commit();
                    return (destQnnListId.ToString(), true);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DuplicateSampleList) + " - caught unexpected exception, sourceId={0}, name={1}", sourceId, name);
                return (Constants.Message.InternalErrorException, false);
            }           
        }

        /// <summary>
        /// Convenience method to retrieve a QNN_LIST entity, given its Id
        /// </summary>
        /// <param name="id">The Id of the QNN_LIST</param>
        /// <param name="qnnListModel">(optional) a QNN_LIST EntityModel to use</param>
        /// <returns>a QNN_LIST entity, or null if it is not found</returns>
        public static async Task<DynamicEntity> GetQnnListAsync(Guid id, EntityModel qnnListModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_LIST, qnnListModel);
        }

        /// <summary>
        /// Returns the collection of QNN_LIST_PROP entitities for the specified list in NumberId order. 
        /// If there are none then an empty collection is returned. (Note that this method doesn't check if the 
        /// list actually exists, so an invalid listId will just return an empty collection).
        /// </summary>
        public static async Task<List<DynamicEntity>> GetQnnListPropsByListIdAsync(Guid listId, EntityModel qnnListPropModel = null)
        {
            if (qnnListPropModel == null)
                qnnListPropModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, Constants.Level.NoJoins);
            Filter byListId = Filter.And.Equal(listId, Constants.FieldName.ListId);
            List<DynamicEntity> qnnListProps
                = await qnnListPropModel.GetAsync(byListId, Order.StartAsc(Constants.FieldName.NumberId), Paging.Empty);
            return qnnListProps;
        }

        private static readonly Regex ValidListPropPattern = new Regex(@"^[\w]*$", RegexOptions.None, TimeSpan.FromSeconds(1));

        public static bool IsValidListPropName(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return false;
            if (name.Length > 50) return false;
            return ValidListPropPattern.IsMatch(name);
        }

        public static async Task<long> SetListSamplesActiveYN(Guid listId, List<Guid> listSampleIds, bool activeYN)
        {
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync();
            Guid structDivisionId = (await CloverRuntime.Security.GetCurrentUserAsync()).StructDivisionId.Value;
            long updated = await spSP_SetListSamplesActiveYN.ExecuteAsync(
                listId,
                listSampleIds,
                activeYN,
                auditBatch,
                structDivisionId);
            return updated;
        }

        /// <summary>
        /// Queries the QNN_LIST_SAMPLE table to get the SampleId (Id in QNN_SAMPLE) given a ListSampleId (Id in QNN_LIST_SAMPLE)
        /// A NotFoundException is thrown if the ListSampleId doesn't refer to an existing record.
        /// n.b. if you already have the QNN_LIST_SAMPLE entity, just get the sampleId out of it
        /// </summary>
        public static async Task<(Guid SampleId, string Uid)> GetSampleIdentityFromListSampleId(Guid listSampleId)
        {
            return await spSP_GetSampleIdentity.FromListSampleId(listSampleId);
        }

        public static async Task<(Guid SampleId, string Uid)> GetSampleIdentityFromDplySampleInfo(Guid dplySampleInfoId)
        {
            return await spSP_GetSampleIdentity.FromDplySampleInfoId(dplySampleInfoId);
        }

        public class SampleListReadResult
        {
            public enum Validity { Valid, DuplicateColumns, InvalidPropertyNames, InvalidData, SystemColumnMismatch, UnexpectedColumns, MissingProperties, EmptyFile, BadFile }

            public static SampleListReadResult Success(ImmutableList<string> propFields, List<IDictionary<string, string>> data)
            {
                if (propFields == null) throw new ArgumentNullException(nameof(propFields));
                return new SampleListReadResult(
                    outcome: Validity.Valid, 
                    additionalInfo: null,
                    propFields: propFields, 
                    data: data);
            }

            public static SampleListReadResult Failure(Validity reason, string additionalInfo)
            {
                if (Validity.Valid == reason) throw new ArgumentNullException(nameof(reason));
                return new SampleListReadResult(
                    outcome: reason,
                    additionalInfo: additionalInfo,
                    propFields: null,
                    data: null);
            }

            public Validity Outcome { get; private set; }
            public bool IsSuccess { get => Validity.Valid == Outcome; }
            public string AdditionalInfo { get; private set; }
            public IList<string> PropFields { get; private set; }
            public IList<IDictionary<string, string>> Data { get; private set; }

            private SampleListReadResult(Validity outcome, string additionalInfo, ImmutableList<string> propFields, List<IDictionary<string, string>> data)
            {
                this.Outcome = outcome;
                this.AdditionalInfo = additionalInfo;
                this.PropFields = propFields;
                this.Data = data;
            }
        }

        public enum ReadSampleListCsvAction { ScanForErrors, ExtractData }

        /// <summary>
        /// Run some basic checks on the CSV to try and determine is is valid for sample list import
        /// and extract the column names that relate to list sample properties. Note that this will 
        /// parse the entire CSV looking for trouble.
        /// Caller is responsible for closing the stream.
        /// </summary>
        public static async Task<SampleListReadResult> ReadSampleListCsv(
            Stream stream, 
            IList<string> expectedProps,
            ReadSampleListCsvAction readAction)
        {
            if (stream == null) throw new ArgumentNullException(nameof(stream));
            if (expectedProps == null) throw new ArgumentNullException(nameof(expectedProps)); //may be empty, but not null
            bool isValidateExpectedProps = (expectedProps.Any());

            bool isExtractingData = (ReadSampleListCsvAction.ExtractData == readAction);
            List<IDictionary<string, string>> extractedData = isExtractingData
                ? new List<IDictionary<string, string>>()
                : null;
            CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                HasHeaderRecord = true,
                TrimOptions = TrimOptions.Trim, //trim unquoted whitespace (values and header names)
            };
            using (CsvReader csv = new CsvReader(new StreamReader(stream), csvConfiguration))
            {
                try
                {
                    bool hasContent = csv.Read();
                    if (!hasContent)
                    {
                        return SampleListReadResult.Failure(
                                SampleListReadResult.Validity.EmptyFile,
                                null);
                    }
                    csv.ReadHeader();
                }
                catch (CsvHelperException csvhex)
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        //This is at trace level because CsvHelper tries to include the raw record in its message and when we have
                        //this error it typically contains non-printable junk because its often not even a text file
                        logger.LogTrace(csvhex, nameof(ReadSampleListCsv) + " - failed to read csv header (returning BadFile result)");
                    }
                    return SampleListReadResult.Failure(
                        SampleListReadResult.Validity.BadFile,
                        null);
                }
                ImmutableList<string> headerRowColumns = csv.HeaderRecord.ToImmutableList();
                
                ImmutableList<string> duplicateColumnNames = headerRowColumns
                    .GroupBy(columnName => columnName.ToUpperInvariant())
                    .Where(grouping => grouping.Count() > 1)
                    .Select(grouping => grouping.Key)
                    .ToImmutableList();
                if (duplicateColumnNames.Any())
                {
                    return SampleListReadResult.Failure(
                        SampleListReadResult.Validity.DuplicateColumns, 
                        string.Join(", ", duplicateColumnNames));
                }

                //which of the optional fields (eg address lines etc) have columns in this file?
                ImmutableList<string> optionalFieldsFound
                    = headerRowColumns
                    .Intersect(Constants.SampleListCsv.OPTIONAL_COLUMNS.ToList(), Constants.Comparers.ObjectNameCaseInsensitive)
                    .ToImmutableList();

                //Any column that isn't a required 'core' sample property or one of the optional fields (eg AddressLine1,2,3 etc)
                //is currently assumed to be a list sample prop. We will keep the casing from file when creating the property
                //n.b we know there is no clash with the required/optional column names because we checked for duplicate names above
                ImmutableList<string> propFields
                    = headerRowColumns
                    .Except(Constants.SampleListCsv.REQUIRED_COLUMNS.ToList(), Constants.Comparers.ObjectNameCaseInsensitive)
                    .Except(optionalFieldsFound, Constants.Comparers.ObjectNameCaseInsensitive)
                    .ToImmutableList();

                ImmutableList<string> invalidPropertyNames
                    = propFields
                    .Where(propName => !SampleListApplication.IsValidListPropName(propName))
                    .ToImmutableList();
                if (invalidPropertyNames.Any())
                {
                    return SampleListReadResult.Failure(
                        SampleListReadResult.Validity.InvalidPropertyNames,
                        string.Join(", ", invalidPropertyNames));
                }

                //Check expected number of system columns (n.b this check doesn't check vs expected props)
                int expectedNumberOfColumns 
                    = Constants.SampleListCsv.REQUIRED_COLUMNS.Length + optionalFieldsFound.Count + propFields.Count;
                int actualNumberOfColumns = headerRowColumns.Count;
                if (actualNumberOfColumns != expectedNumberOfColumns)
                {
                    return SampleListReadResult.Failure(
                        SampleListReadResult.Validity.SystemColumnMismatch,
                        $"Expected {expectedNumberOfColumns} columns but found {actualNumberOfColumns}");
                }

                //Check Compulsory Columns - These required columns still need to be found in the specific order
                for (int iCol = 0; iCol < Constants.SampleListCsv.REQUIRED_COLUMNS.Length; iCol++)
                {
                    string expectedColumn = Constants.SampleListCsv.REQUIRED_COLUMNS[iCol];
                    string actualColumn = headerRowColumns[iCol];
                    if (!expectedColumn.Equals(actualColumn, StringComparison.OrdinalIgnoreCase))
                    {
                        return SampleListReadResult.Failure(
                            SampleListReadResult.Validity.SystemColumnMismatch,
                            $"Expected column {expectedColumn} but found {actualColumn} at index {iCol}");
                    }
                }

                // Look for any unexpected columns in the remaining columns
                ISet<string> optionalFieldsAndProps 
                    = optionalFieldsFound
                    .Union( isValidateExpectedProps ? expectedProps : propFields)
                    .ToHashSet(Constants.Comparers.ObjectNameCaseInsensitive);
                List<string> unexpectedColumns = new List<string>();
                for (int iCol = Constants.SampleListCsv.REQUIRED_COLUMNS.Length; iCol < headerRowColumns.Count; iCol++)
                {
                    //For these subsequent columns they could be a prop column or they could be an optional column.
                    //Need to make sure they are one of the two, but the order no longer matters.
                    //n.b. optionalFieldsFound is just a tiny list, so don't bother making it a hashset
                    string columnName = headerRowColumns[iCol];                    
                    if (!optionalFieldsAndProps.Contains(columnName))
                    {
                        unexpectedColumns.Add(columnName);
                    }
                }
                if(unexpectedColumns.Any())
                {
                    return SampleListReadResult.Failure(
                            SampleListReadResult.Validity.UnexpectedColumns,
                            string.Join(", ", unexpectedColumns));
                }

                //Find any missing columns for expected list sample properties
                if(isValidateExpectedProps)
                {
                    IList<string> missingProps 
                        = expectedProps
                        .Where(ep => !propFields.Contains(ep, Constants.Comparers.ObjectNameCaseInsensitive))
                        .ToImmutableList();
                    if(missingProps.Any())
                    {
                        return SampleListReadResult.Failure(
                            SampleListReadResult.Validity.MissingProperties,
                            string.Join(", ", missingProps));
                    }
                }

                while (csv.Read())
                {
                    try
                    {
                        if(isExtractingData)
                        {   //Extract rows into memory to return 

                            //Manually reading the dictionary so we can make it case-insensitive
                            IDictionary<string, string> record
                                = new Dictionary<string, string>(Constants.Comparers.ObjectNameCaseInsensitive);
                            foreach (string column in headerRowColumns)
                            {
                                string value = csv.GetField(column);
                                record.Add(column, value);
                            }
                            extractedData.Add(record);
                        }
                        else
                        {   //Just scan for parsing errors
                            int colCount = headerRowColumns.Count;
                            for (int i = 0; i < colCount; i++)
                            {
                                string _ = csv.GetField(i);
                            }
                        }
                    }
                    catch (CsvHelperException csvhex)
                    {
                        string badColumn = csvhex.Context.Reader.HeaderRecord[csv.CurrentIndex];
                        StringBuilder additionalInfo = new StringBuilder();
                        if (csvhex is CsvHelper.MissingFieldException)
                        {
                            additionalInfo.Append("Missing column ");
                        }
                        else if (csvhex is CsvHelper.BadDataException)
                        {   //bad format, e.g unclosed quotes
                            additionalInfo.Append("Bad data in column ");
                        }
                        else
                        {
                            additionalInfo.Append($"{csvhex.GetType().Name} - check column ");
                        }
                        additionalInfo.Append($"{csvhex.Context.Reader.CurrentIndex} ({badColumn}), row {csvhex.Context.Reader.Parser.Row}");
                        return SampleListReadResult.Failure(
                            SampleListReadResult.Validity.InvalidData,
                            additionalInfo.ToString());
                    }
                } //end while read
                return SampleListReadResult.Success(propFields, extractedData);
            } //end using csv reader
        }

        public class SampleListCreationException : Exception
        {
            public SampleListCreationException(Exception innerException) 
                : base("Failed to create new SampleList", innerException) { }
        }

        public static async Task<Guid> CreateSampleList(
            string listName, 
            IList<string> propFields, 
            Guid createdBy, 
            Guid structDivisionId,
            EntityModel qnnListModel=null,
            EntityModel qnnListPropModel=null)
        {
            if (string.IsNullOrEmpty(listName)) throw new ArgumentNullException(nameof(listName));
            bool hasProps = (propFields != null && propFields.Any());

            if (qnnListModel == null)
            {
                qnnListModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST, Constants.Level.NoJoins);
            }
            else if (!Constants.ModelName.QNN_LIST.Equals(qnnListModel.Name))
            {   
                throw new ArgumentException($"Expected model for {Constants.ModelName.QNN_LIST} but passed {qnnListModel.Name}", nameof(qnnListModel));
            }

            if (hasProps)
            {
                if(qnnListPropModel == null)
                {
                    qnnListPropModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP);
                }
                else if (!Constants.ModelName.QNN_LIST_PROP.Equals(qnnListPropModel.Name))
                {
                    throw new ArgumentException($"Expected model for {Constants.ModelName.QNN_LIST_PROP} but passed {qnnListPropModel.Name}", nameof(qnnListPropModel));
                }
            }

            try
            {
                using (SharedTransaction transaction = new SharedTransaction())
                {
                    try
                    {
                        transaction.BeginTransactionAsync().Wait();

                        DateTime now = DateTime.Now;

                        DynamicEntity qnnList = await qnnListModel.NewAsync();
                        qnnList[Constants.FieldName.Name] = listName;
                        qnnList[Constants.FieldName.Status] = true;
                        qnnList[Constants.FieldName.UIDUsrEditYN] = false;
                        qnnList[Constants.FieldName.NameUsrEditYN] = false;
                        qnnList[Constants.FieldName.EmailUsrEditYN] = false;
                        qnnList[Constants.FieldName.ActiveUsrEditYN] = false;
                        qnnList[Constants.FieldName.PasswordUsrEditYN] = false;
                        qnnList[Constants.FieldName.CreatedBy] = createdBy;
                        qnnList[Constants.FieldName.CreatedDate] = now;
                        qnnList[Constants.FieldName.UpdatedBy] = createdBy;
                        qnnList[Constants.FieldName.UpdatedDate] = now;
                        qnnList[Constants.FieldName.StructDivisionId] = structDivisionId;
                        qnnList[Constants.FieldName.TrkListIds] = null;

                        await qnnListModel.UpdateSingleAsync(qnnList);
                        Guid listId = (Guid)qnnList[Constants.FieldName.Id];

                        //Insert ListProps
                        if (hasProps)
                        {
                            List<DynamicEntity> listSampleProps = new List<DynamicEntity>();
                            foreach (string prop in propFields)
                            {
                                DynamicEntity qnnListProp = await qnnListPropModel.NewAsync();
                                qnnListProp[Constants.FieldName.ListId] = listId;
                                qnnListProp[Constants.FieldName.Type] = 1;
                                qnnListProp[Constants.FieldName.Alias] = prop;
                                qnnListProp[Constants.FieldName.ReqdYN] = false;
                                qnnListProp[Constants.FieldName.UsrEditYN] = false;
                                qnnListProp[Constants.FieldName.TxtRow] = null;
                                qnnListProp[Constants.FieldName.TxtRegExp] = null;
                                qnnListProp[Constants.FieldName.TxtRegExpErr] = null;
                                qnnListProp[Constants.FieldName.OptType] = null;
                                qnnListProp[Constants.FieldName.UsrVisibleYN] = true;
                                qnnListProp[Constants.FieldName.RespVisibleYN] = true;
                                listSampleProps.Add(qnnListProp);
                            }
                            await qnnListPropModel.UpdateAsync(listSampleProps.Cast<dynamic>().ToList());
                        }

                        await transaction.CommitAsync();

                        return listId;
                    }
                    catch (Exception)
                    {
                        await transaction.RollbackAsync();
                        throw;
                    }
                } //end using
            }
            catch(Exception e)
            {
                throw new SampleListCreationException(e);
            }
        }

        /// <summary>
        /// Checks the state of a list in terms of its suitability for use in a deployment. Will return 
        /// whether it has any samples and whether it is composed solely of the anonymous sample. 
        /// </summary>
        public static async Task<(bool IsNotEmpty, bool IsAnonymousSampleOnly)> CheckListForDeployment(Guid listId)
        {
            //TODO - this logic could probably be optimised further by putting it into a single query stored procedure
            EntityModel listSampleEntityModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.NoJoins);
            Filter byListId = Filter.And.Equal(listId, Constants.FieldName.ListId);
            long totalSamplesInList = await listSampleEntityModel.GetCountAsync(byListId);
            bool hasAnySamples = totalSamplesInList > 0;
            if(totalSamplesInList==1)
            {   //The anonymous list should only have one sample, if this list has only one could it be
                //the anonymous list? We shall count again, but only anonymous samples.
                Filter byListIdAndAnonymous = Filter.And
                    .Equal(listId, Constants.FieldName.ListId)
                    .Equal(Constants.SwzAnonymous.SampleId, Constants.FieldName.SampleId);
                long anonymousSamplesInList = await listSampleEntityModel.GetCountAsync(byListIdAndAnonymous); //1 or 0 expected
                return (hasAnySamples, (anonymousSamplesInList == totalSamplesInList)); //and they are both 1
            }
            else
            {   //If there are no samples or more than one then this list isn't composed of only the anonymous sample
                return (hasAnySamples, false);
            }
        }

        public static async Task<int> ValidateQnnListForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            //Verify user has rights for this organisation
            Guid structDivisionId = (Guid)data[Constants.FieldName.StructDivisionId];
            HashSet<Guid> allowedOrganisations
                = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!allowedOrganisations.Contains(structDivisionId)) return 2;

            //Required field checks (note that data is based on the component id in the form)
            string name = (string)data["nameInput"];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 300) return 101;
            return 0;
        }

        public static async Task<int> ValidateQnnTrkListForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            //Verify user has rights for this organisation
            Guid structDivisionId = (Guid)data[Constants.FieldName.StructDivisionId];
            HashSet<Guid> allowedOrganisations
                = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!allowedOrganisations.Contains(structDivisionId)) return 2;

            //Required field checks (note that data is based on the component id in the form)
            string name = (string)data[Constants.FieldName.Name];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 300) return 101;
            return 0;
        }

    }
}
