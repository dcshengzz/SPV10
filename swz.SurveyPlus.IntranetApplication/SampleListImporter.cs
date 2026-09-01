using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Object that performs the process of importing sample data (e.g. from a CSV) for new and updated samples. 
    /// Instances of this class are throwaway objects specific to a list and maintain mutable state for internal use
    /// during the performance of a run so are not threadsafe. Do not share instances. You should create a new
    /// instance for each import run.
    /// The current implementation gets factory references and a bunch of other stuff at creation time so please
    /// DO NOT serialise it (such as for a Hangfire job queue)
    /// </summary>
    public class SampleListImporter
    {
        public class SampleListImporterFactoryException : Exception 
        { 
            public  SampleListImporterFactoryException(Exception innerException) 
                : base("Failed to create importer", innerException) { }
        }

        /// <summary>
        /// Factory method to create a new instance of the importer.
        /// The importer is specific to the specified list and lookup of the list will be performed at creation time.
        /// </summary>
        public static async Task<SampleListImporter> NewAsync(Guid qnnListId, Guid importingUserId)
        {
            //We need a factory method as much of the initialisation is async
            try
            {
                ILogger<SampleListImporter> logger
                    = (ILogger<SampleListImporter>)DefaultApplicationLogging.CreateLogger<SampleListImporter>();

                EntityModel qnnSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                EntityModel qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
                EntityModel qnnSampleStructDivisionModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION, Constants.Level.NoJoins);
                EntityModel qnnListSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.NoJoins);
                EntityModel qnnTrkListSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_TRK_LIST_SAMPLE, Constants.Level.FetchJoins);
                EntityModel qnnListSamplePropModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE_PROP, Constants.Level.NoJoins);
                EntityModel qnnListPropModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, Constants.Level.NoJoins);

                SampleListImporter importer = new SampleListImporter(
                    logger: logger,
                    qnnListId: qnnListId,
                    importingUserId: importingUserId,
                    qnnSampleModel: qnnSampleModel,
                    qnnSampleAddressModel: qnnSampleAddressModel,
                    qnnSampleStructDivisionModel: qnnSampleStructDivisionModel,
                    qnnListSampleModel: qnnListSampleModel,
                    qnnTrkListSampleModel: qnnTrkListSampleModel,
                    qnnListSamplePropModel: qnnListSamplePropModel,
                    qnnListPropModel: qnnListPropModel);

                return importer;
            } 
            catch(Exception e)
            {
                throw new SampleListImporterFactoryException(e);
            }            
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger logger;
        private readonly Guid qnnListId;
        private readonly Guid importingUserId;
        private readonly EntityModel qnnSampleModel;
        private readonly EntityModel qnnSampleAddressModel;
        private readonly EntityModel qnnSampleStructDivisionModel;
        private readonly EntityModel qnnListSampleModel;
        private readonly EntityModel qnnTrkListSampleModel;
        private readonly EntityModel qnnListSamplePropModel;
        private readonly EntityModel qnnListPropModel;

        //Mutable state shared between methods on a run
        long start = 0;
        private AuditBatch auditBatch = null;
        private bool isTrkListActiveYN;
        private DynamicEntity qnnList;
        private User importingUser;
        private Guid listStructDivisionId = Guid.Empty;
        private Guid userStructDivisionId = Guid.Empty;

        /// <summary>
        /// Constructor is private. Please use the static factory method to create an instance.
        /// </summary>
        private SampleListImporter(
            ILogger<SampleListImporter> logger,
            Guid qnnListId,
            Guid importingUserId,
            EntityModel qnnSampleModel,
            EntityModel qnnSampleAddressModel,
            EntityModel qnnSampleStructDivisionModel,
            EntityModel qnnListSampleModel,
            EntityModel qnnTrkListSampleModel,
            EntityModel qnnListSamplePropModel,
            EntityModel qnnListPropModel)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.qnnListId = qnnListId;
            this.importingUserId = importingUserId;
            this.qnnSampleModel = qnnSampleModel ?? throw new ArgumentNullException(nameof(qnnSampleModel));
            this.qnnSampleAddressModel = qnnSampleAddressModel ?? throw new ArgumentNullException(nameof(qnnSampleAddressModel));
            this.qnnSampleStructDivisionModel = qnnSampleStructDivisionModel ?? throw new ArgumentNullException(nameof(qnnSampleStructDivisionModel));
            this.qnnListSampleModel = qnnListSampleModel ?? throw new ArgumentNullException(nameof(qnnListSampleModel));
            this.qnnTrkListSampleModel = qnnTrkListSampleModel ?? throw new ArgumentNullException(nameof(qnnTrkListSampleModel));
            this.qnnListSampleModel = qnnListSampleModel ?? throw new ArgumentNullException(nameof(qnnListSampleModel));
            this.qnnListSamplePropModel = qnnListSamplePropModel ?? throw new ArgumentNullException(nameof(qnnListSamplePropModel));
            this.qnnListPropModel = qnnListPropModel ?? throw new ArgumentNullException(nameof(qnnListPropModel));
        }

        //Does the work of importing (List entity aleady created)
        public async Task<Dictionary<string,string>> ImportListSamples(         
            string specifiedPassword,
            IList<IDictionary<string, string>> csvRows)
        {
            if (csvRows == null) throw new ArgumentNullException(nameof(csvRows));

            start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

            try
            {
                //Note that we need to manually set the user of the audit batch here, as when this code is run
                //in a background job the current user isn't available
                auditBatch = await AuditSettings.NewBatchAsync(importingUserId, Guid.Empty);

                qnnList = await SampleListApplication.GetQnnListAsync(this.qnnListId);
                if (qnnList == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_LIST, this.qnnListId);

                importingUser = await CloverRuntime.Security.GetUserByIdAsync(importingUserId);
                if (importingUser == null)
                    throw new NotFoundException($"Failed to find record for the importing user with id={importingUserId}");

                //For import/update it will perform it for the organisation the list belongs to (i.e. new entities get this org)
                listStructDivisionId = (Guid)qnnList[Constants.FieldName.StructDivisionId];

                //For audit purposes we will record the current user's organisation in the audit log records (i.e. the org who did it)
                userStructDivisionId = importingUser.StructDivisionId.Value; //should not be null for a real user

                bool isPasswordSpecified = !string.IsNullOrEmpty(specifiedPassword);

                bool isLogDebugEnabled = logger.IsEnabled(LogLevel.Debug);
                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - Importing {0} rows into list {1} qnnListId={2} by user {3} id={4}, userStructivisionId={5} , listStructDivisionId={6}, isPasswordSpecified={7}, eventBatch={8}", csvRows.Count, (string)qnnList[Constants.FieldName.Name], qnnListId, importingUser.Name, importingUserId, userStructDivisionId, listStructDivisionId, isPasswordSpecified, auditBatch.EventBatch);
                }

                //Assert the importing user's organisations include the list's organisation. Its not importer's responsibility to do permission checks
                //here - this is a consistency check - so if it fails we throw an invalid operation and not a permission exception
                bool validOrganisationTree = (await StructDivision.SelectChildrenAndThisIdSetAsync(userStructDivisionId)).Contains(listStructDivisionId);
                if(!validOrganisationTree)
                {
                    throw new InvalidOperationException($"The struct division (listStructDivisionId={listStructDivisionId}) of the list (qnnListId={qnnListId})  is not in the organisation subtree of the importing user {importingUser.Name} (importingUserId={importingUserId}, userStructDivisionId={userStructDivisionId})");
                }

                HashSet<string> uidOfEverySampleInSurveyPlus = await spSP_GetAllSampleUid.GetAllUidsAsync();
                isTrkListActiveYN = await TrkListApplication.GetTrkListActiveYN();

                //nb: The lists of new entities to be inserted below use IDictionary<string,object> rather than DynamicEntity.
                //    This lets us use an ExpandoObject instead of DynamicEntity which is convenient for using the same object for the audit
                //    list as we use for the bulk copy *and* having the json serialisation for the audit keep the attributes in a stable order.
                //    It also saves some extra work to extract the dictionaries from DynamicEntity when we call BulkCopyDataInsert 

                //QNN_SAMPLE
                DataTable samplesToInsertTable = PrepareQnnSampleTable();
                List<DynamicEntity> samplesToUpdate = new List<DynamicEntity>();
                List<DynamicEntity> sampleAddressToUpdate = new List<DynamicEntity>();

                //QNN_SAMPLE_ADDRESS
                DataTable sampleAddressToInsertTable = PrepareQnnSampleAddressTable();

                //QNN_SAMPLE_STRUCT
                DataTable sampleStructDivisionsToInsertTable = PrepareSampleStructDivisionTable();

                int exceptionCount = 0;
                int duplicateCount = 0;
                Dictionary<string, Guid> uidToSampleId = new Dictionary<string, Guid>(Constants.Comparers.UidCaseInsensitive);

                List<ImportResultInfo> lstImportResult = new List<ImportResultInfo>();

                int csvRowCount = csvRows.Count;
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - processing {0} csv rows for qnnListId={1}", csvRowCount, qnnListId);
                }
                HashSet<string> uidsProcessed = new HashSet<string>(Constants.Comparers.UidCaseInsensitive); //For duplicate detection 
                for (int iRow = 0; iRow <= csvRowCount - 1; iRow++)
                {
                    IDictionary<string, string> rowDict = csvRows[iRow];

                    bool isError = await ValidateColumnValues(
                        lstImportResult, //will have error results added to it
                        iRow,
                        rowDict);

                    if (!isError)
                    {
                        string UID = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxUid]].Trim();
                        string name = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxName]];
                        string toEmails = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxEmail]];
                        string ccEmails = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxCcEmails]];
                        string active = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxActive]];
                        string passwordReset = rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxPasswordReset]];

                        //Optional AddressBook fields (we will use null to indicate they weren't provided)
                        String addressLine1 = rowDict.ContainsKey(Constants.SampleListCsv.AddressLine1) ? rowDict[Constants.SampleListCsv.AddressLine1] : null;
                        String addressLine2 = rowDict.ContainsKey(Constants.SampleListCsv.AddressLine2) ? rowDict[Constants.SampleListCsv.AddressLine2] : null;
                        String addressLine3 = rowDict.ContainsKey(Constants.SampleListCsv.AddressLine3) ? rowDict[Constants.SampleListCsv.AddressLine3] : null;
                          
                        Guid sampleId;
                        string generatedPassword = InternetAccountApplication.GenerateRespondentPassword();
                        //Do not do anything if there are duplicated records in csv, only takes first record
                        bool sampleIsNotDuplicate = !uidsProcessed.Contains(UID);
                        if (sampleIsNotDuplicate)
                        {
                            bool sampleIsNew = !uidOfEverySampleInSurveyPlus.Contains(UID); //n.b. set's comparer is case-insensitive

                            if (sampleIsNew)
                            {
                                sampleId = Guid.NewGuid();
                                bool activeYN = ConversionUtils.IsTrueYN(active);
                                bool pwdResetYN = !isPasswordSpecified;
                                string pwd
                                    = isPasswordSpecified
                                    ? EncryptionHelper.EncryptStr(specifiedPassword, Constants.LoginKey, Constants.LoginIv)
                                    : EncryptionHelper.EncryptStr(generatedPassword, Constants.LoginKey, Constants.LoginIv);
                                //TODO - consider setting UpdatedBy and UpdatedDate for new samples too
                                samplesToInsertTable.Rows.Add(
                                    sampleId,           //Id
                                    activeYN,           //ActiveYN
                                    UID,                //UID
                                    name,               //Name
                                    importingUserId,    //CreatedBy
                                    DateTime.Now,       //CreatedDate
                                    0,                  //NumRetry
                                    pwdResetYN,         //PwdResetYN
                                    pwd);               //Pwd

                                sampleStructDivisionsToInsertTable.Rows.Add(
                                    Guid.NewGuid(),         //Id
                                    sampleId,               //SampleId
                                    listStructDivisionId);  //StructDivisionId

                                uidToSampleId[UID] = sampleId;

                                sampleAddressToInsertTable.Rows.Add(
                                    Guid.NewGuid(),         //Id
                                    sampleId,               //SampleId
                                    listStructDivisionId,   //StructDivisionId
                                    importingUserId,        //CreatedBy
                                    DateTime.Now,           //CreatedDate
                                    toEmails,               //ToEmails
                                    ccEmails,               //CcEmails
                                    addressLine1 ?? "",     //AddressLine1
                                    addressLine2 ?? "",     //AddressLine2
                                    addressLine3 ?? "");    //AddressLine3

                                uidsProcessed.Add(UID);
                            }
                            //If it is an existing record
                            else
                            {
                                DynamicEntity qnnSample
                                    = (await qnnSampleModel.GetAsync(Filter.And.Equal(UID, Constants.FieldName.UID))).FirstOrDefault();
                                bool existingSampleStillExists = (qnnSample != null);
                                if (existingSampleStillExists)
                                {
                                    //For an existing sample, the password is only reset if passwordResetYN is requested in csv
                                    //otherwise we leave the value in the entity unchanged
                                    bool isPasswordReset = ConversionUtils.IsTrueYN(passwordReset);
                                    if (isPasswordReset)
                                    {
                                        if (isPasswordSpecified)
                                        {
                                            qnnSample[Constants.FieldName.PwdResetYN] = false;
                                            qnnSample[Constants.FieldName.Pwd]
                                                = EncryptionHelper.EncryptStr(specifiedPassword, Constants.LoginKey, Constants.LoginIv);
                                        }
                                        else
                                        {
                                            qnnSample[Constants.FieldName.PwdResetYN] = true;
                                            qnnSample[Constants.FieldName.Pwd]
                                                = EncryptionHelper.EncryptStr(generatedPassword, Constants.LoginKey, Constants.LoginIv);
                                        }
                                    }

                                    qnnSample[Constants.FieldName.UpdatedBy] = importingUserId;
                                    qnnSample[Constants.FieldName.UpdatedDate] = DateTime.Now;
                                    qnnSample[Constants.FieldName.Name] = name;

                                    //if sample exists, we will not change its ActiveYN
                                    sampleId = (Guid)qnnSample[Constants.FieldName.Id];

                                    samplesToUpdate.Add(qnnSample);
                                    uidToSampleId[UID] = sampleId;

                                    //Map the sample to the specified structDivision if this has not been done yet
                                    HashSet<Guid> sampleStructDivisionIds =
                                        (await qnnSampleStructDivisionModel
                                        .GetAsync(Filter.And.Equal(qnnSample[Constants.FieldName.Id], Constants.FieldName.SampleId)))
                                        .Select(ssd => (Guid)ssd[Constants.FieldName.StructDivisionId])
                                        .ToHashSet();
                                    bool sampleHasNoStructDivisionMapping = !sampleStructDivisionIds.Contains(listStructDivisionId);
                                    if (sampleHasNoStructDivisionMapping)
                                    {
                                        sampleStructDivisionsToInsertTable.Rows.Add(
                                            Guid.NewGuid(),         //Id
                                            sampleId,               //SampleId
                                            listStructDivisionId);  //StructDivisionId
                                    }

                                    DynamicEntity qnnSampleAddress
                                        = await InternetAccountApplication.GetSampleAddressAsync(sampleId, listStructDivisionId);
                                    if (qnnSampleAddress == null)
                                    {
                                        //If for some reason they don't already have an address row (failed import maybe?) then we add it now
                                        sampleAddressToInsertTable.Rows.Add(
                                            Guid.NewGuid(),         //Id
                                            sampleId,               //SampleId
                                            listStructDivisionId,   //StructDivisionId
                                            importingUserId,        //CreatedBy
                                            DateTime.Now,           //CreatedDate
                                            toEmails,               //ToEmails
                                            ccEmails,               //CcEmails
                                            addressLine1 ?? "",     //AddressLine1
                                            addressLine2 ?? "",     //AddressLine2
                                            addressLine3 ?? "");    //AddressLine3
                                    }
                                    else
                                    {
                                        UpdateSampleAddress(qnnSampleAddress, toEmails, ccEmails, addressLine1, addressLine2, addressLine3);
                                        sampleAddressToUpdate.Add(qnnSampleAddress);
                                    }
                                    qnnSampleAddress = null;

                                    uidsProcessed.Add(UID);
                                }
                                else
                                {
                                    //TODO - if an existing sample no longer exists when we get to here we just ignore it, but I think
                                    //       still shows as updated in the updateCount? My inclination is to consider this an error and put a 
                                    //       throw here.
                                }
                            }
                        } //end if sample is not duplicate
                        else
                        {
                            duplicateCount += 1;
                        }
                    }
                    else
                    {
                        exceptionCount += 1;
                    }
                    if(iRow % 500 == 0 && logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ImportListSamples) + " - processed {0} rows from csv for qnnListId={1}, samplesToInsertTable.Rows.Count={2}, sampleAddressToInsertTable.Rows.Count={3}, sampleAddressToUpdate.Count={4}, sampleStructDivisionsToInsertTable.Rows.Count={5}, duplicateCount={6}, exceptionCount={7}", (iRow+1), qnnListId, samplesToInsertTable?.Rows?.Count, sampleAddressToInsertTable?.Rows?.Count, sampleAddressToUpdate?.Count, sampleStructDivisionsToInsertTable?.Rows?.Count, duplicateCount, exceptionCount);
                    }
                } //end iterating csv rows
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - done processing {0} rows from csv for qnnListId={1}, samplesToInsertTable.Rows.Count={2}, sampleAddressToInsertTable.Rows.Count={3}, sampleAddressToUpdate.Count={4}, sampleStructDivisionsToInsertTable.Rows.Count={5}, duplicateCount={6}, exceptionCount={7}", csvRowCount, qnnListId, samplesToInsertTable?.Rows?.Count, sampleAddressToInsertTable?.Rows?.Count, sampleAddressToUpdate?.Count, sampleStructDivisionsToInsertTable?.Rows.Count, duplicateCount, exceptionCount);
                }

                if (samplesToInsertTable.Rows.Count > 0)
                {
                    if (isLogDebugEnabled)
                    {
                        logger.LogDebug(nameof(ImportListSamples) + " - Inserting {0} new QNN_SAMPLE rows for qnnListId={2}, eventBatch={3}",
                            samplesToInsertTable.Rows.Count, qnnListId, auditBatch.EventBatch);
                    }
                    using (SharedTransaction forConnection = new SharedTransaction())
                    {
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(samplesToInsertTable, forConnection, timeoutSeconds: 120);
                    }
                        
                    if (auditBatch.AuditOn)
                    {
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(samplesToInsertTable);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_SAMPLE,
                            auditBatch,
                            userStructDivisionId,
                            newValue);
                    }

                    samplesToInsertTable.Rows.Clear();
                }

                samplesToInsertTable = null; //This can be GC already

                if (sampleStructDivisionsToInsertTable.Rows.Count > 0)
                {
                    
                    if (isLogDebugEnabled)
                    {
                        logger.LogDebug(nameof(ImportListSamples) + " - EventBatch={0}, Inserting {1} new QNN_SAMPLE_STRUCTDIVISION rows, qnnListId={2}", auditBatch?.EventBatch, sampleStructDivisionsToInsertTable?.Rows?.Count, qnnListId);
                    }
                    
                    using (SharedTransaction forConnection = new SharedTransaction())
                    {
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(sampleStructDivisionsToInsertTable, forConnection, timeoutSeconds: 120);
                    }

                    if (auditBatch.AuditOn)
                    {
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(sampleStructDivisionsToInsertTable);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION,
                            auditBatch,
                            userStructDivisionId,
                            newValue);
                    }

                    sampleStructDivisionsToInsertTable.Rows.Clear();
                }

                sampleStructDivisionsToInsertTable = null; //GC can already

                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - Updating {0} existing QNN_SAMPLE entities, eventBatch={1}, qnnListId={2}",
                        samplesToUpdate?.Count, auditBatch?.EventBatch, qnnListId);
                }
                await DbHelper.BulkDataUpdate(samplesToUpdate, qnnSampleModel);
                samplesToUpdate = null; //dont need any more

                if (sampleAddressToInsertTable.Rows.Count > 0)
                {
                    if (isLogDebugEnabled)
                    {
                        logger.LogDebug(nameof(ImportListSamples) + " - Inserting {0} new QNN_SAMPLE_ADDRESS rows for qnnListId={2}, eventBatch={3}",
                            sampleAddressToInsertTable.Rows.Count, qnnListId, auditBatch.EventBatch);
                    }
                    
                    using (SharedTransaction forConnection = new SharedTransaction())
                    {
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(sampleAddressToInsertTable, forConnection, timeoutSeconds: 120);
                    }

                    if (auditBatch.AuditOn)
                    {
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(sampleAddressToInsertTable);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_SAMPLE_ADDRESS,
                            auditBatch,
                            userStructDivisionId,
                            newValue);
                    }

                    sampleAddressToInsertTable.Rows.Clear();
                }

                sampleAddressToInsertTable = null; //can gc now

                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - Updating {0} existing QNN_SAMPLE_ADDRESS entities, eventBatch={1}",
                        sampleAddressToUpdate.Count, auditBatch.EventBatch);
                }
                await DbHelper.BulkDataUpdate(sampleAddressToUpdate, qnnSampleAddressModel);
                sampleAddressToUpdate = null; //dont need any more, can GC now

                //TODO - given how many args and return values there are, we may as well inline this function again
                //       or better - convert ImportListSamples into an object and use the fields to hold a lot of this
                //       state which means we can break out the flow even more to make the logic clearer.
                ListSamplesImportData data = await PrepareEntities(
                        rows: csvRows,
                        uidToSampleId: uidToSampleId,
                        uidOfEverySampleInSurveyPlus: uidOfEverySampleInSurveyPlus,
                        lstImportResult: lstImportResult,
                        exceptionCount: exceptionCount);

                //QNN_LIST_SAMPLE - insert new records
                if (data.ListSamplesToInsertTable.Rows.Count > 0)
                {
                    
                    if (isLogDebugEnabled)
                    {
                        logger.LogDebug(nameof(ImportListSamples) + " - Inserting {0} new QNN_LIST_SAMPLE rows for qnnListId={1}, eventBatch={2}", data.ListSamplesToInsertTable.Rows.Count, qnnListId, auditBatch.EventBatch);
                    }
                    //await DbHelper.BulkCopyDataInsert(data.ListSamplesToInsert, qnnListSampleTable, connectionString);

                    using(SharedTransaction forConnection = new SharedTransaction())
                    {
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(data.ListSamplesToInsertTable, forConnection, timeoutSeconds:120);
                    }

                    if (auditBatch.AuditOn)
                    {
                        //string newValue = JsonConvert.SerializeObject(data.ListSamplesToInsert, Formatting.Indented);
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(data.ListSamplesToInsertTable);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_LIST_SAMPLE,
                            auditBatch,
                            userStructDivisionId,
                            newValue);
                    }
                }

                data.ReleaseListSamplesToInsert();

                //QNN_LIST_SAMPLE - update existing records
                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - Updating {0} existing QNN_LIST_SAMPLE entities for qnnListId={1}, eventBatch={2}",
                        data.ListSamplesToUpdate.Count, qnnListId, auditBatch.EventBatch);
                }
                await DbHelper.BulkDataUpdate(data.ListSamplesToUpdate, qnnListSampleModel);
                data.ReleaseListSamplesToUpdate();

                //Ensure the list of sample names in the audit tables are up to date with changes made in the sample tables
                await SurveyPlusAuditHelper.SyncAuditSampleNameAsync(); //nb - (for now at least) we want to do this even when AuditOn is false

                //QNN_LIST_SAMPLE_PROP - new or recreated existing records to insert 
                //delete existing prop (we will create new ones and re-insert rather than updating existing ones)
                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + " - Deleting {0} QNN_LIST_SAMPLE_PROP entities for qnnListId={1}, eventBatch={2}", data.ListSampleIds.Count, qnnListId, auditBatch.EventBatch);
                }
                await spSP_DeleteSampleProp.ExecuteAsync(
                    qnnListId,
                    data.ListSampleIds,
                    auditBatch,
                    userStructDivisionId);
                //(Re)Insert props
                if (data.ListSamplePropsToInsertTable.Rows.Count > 0)
                {
                    
                    if (isLogDebugEnabled)
                    {
                        logger.LogDebug(nameof(ImportListSamples) + " - Inserting {0} QNN_LIST_SAMPLE_PROP rows for qnnListId={1}, eventBatch={2}", data.ListSamplePropsToInsertTable.Rows.Count, qnnListId, auditBatch.EventBatch);
                    }
                    using (SharedTransaction forConnection = new SharedTransaction())
                    {
                        await forConnection.OpenConnectionAsync();
                        DbHelper.BulkCopyDataTable(data.ListSamplePropsToInsertTable, forConnection, timeoutSeconds: 120);
                    }

                    if (auditBatch.AuditOn)
                    {
                        string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(data.ListSamplePropsToInsertTable);
                        await SurveyPlusAuditHelper.BatchImport(
                            Constants.ModelName.QNN_LIST_SAMPLE_PROP,
                            auditBatch,
                            userStructDivisionId,
                            newValue);
                    }
                }
                data.ReleaseListSamplePropsToInsert();

                //Import is complete
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                if (isLogDebugEnabled)
                {
                    logger.LogDebug(nameof(ImportListSamples) + "  Import Complete in about {0} minutes, added={1}, updated={2}, duplicated={3}, exceptionCount={4}, totalRows={5}, duration={6}ms, eventBatch={7}, qnnListId={8}", ConversionUtils.ToMinutesRoundedUp(duration), data.InsertCount, data.UpdateCount, exceptionCount, duplicateCount, csvRows.Count, duration, auditBatch.EventBatch, qnnListId);
                }

                Dictionary<string, string> report = new Dictionary<string, string>();
                report.Add("Completed", Boolean.TrueString);
                report.Add("ListName", qnnList[Constants.FieldName.Name].ToString());
                report.Add("SampleAdded", data.InsertCount.ToString());
                report.Add("SampleUpdated", data.UpdateCount.ToString());
                report.Add("SampleDuplicated", duplicateCount.ToString());
                report.Add("TotalRows", csvRows.Count.ToString());
                report.Add("ErrorCount", exceptionCount.ToString());
                report.Add("Duration", (duration).ToString());
                report.Add("DurationSeconds", (duration / 1000).ToString());
                report.Add("DurationMinutes", ConversionUtils.ToMinutesRoundedUp(duration).ToString());

                StringBuilder errorSummary = new StringBuilder();
                if(lstImportResult.Any())
                {
                    errorSummary.Append("Import summary:\nRowNo. - Field - Message\n");
                    foreach(ImportResultInfo importResult in lstImportResult)
                    {
                        errorSummary.Append($"{importResult.RowNo} - {importResult.ErrField} - {importResult.ErrMsg}\n");
                    }
                }
                report.Add("ErrorSummary", errorSummary.ToString());

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ImportListSamples) + " - prepared report, eventBatch={2}, report={3}", auditBatch.EventBatch, report);
                }

                return report;
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                string listName = (qnnList == null) ? "" : (string)qnnList[Constants.FieldName.Name];
                logger.LogError(e, nameof(ImportListSamples) + " - An unexpected exception was caught importing into {0}, qnnListId={1}, duration={3}, eventBatch={4}", listName, qnnListId, duration, auditBatch.EventBatch);

                Dictionary<string, string> report = new Dictionary<string, string>();
                report.Add("Completed", Boolean.FalseString);
                report.Add("ListName", listName);
                report.Add("ExceptionMessage", e.Message);
                report.Add("Duration", (duration).ToString());
                report.Add("DurationSeconds", (duration / 1000).ToString());
                report.Add("DurationMinutes", ConversionUtils.ToMinutesRoundedUp(duration).ToString());
                return report;
            }
        } //end of ImportListSamples

        /// <summary>
        /// Performs validation on the standard columns in the record. Will add some error information to the importResults collection for
        /// each column found to be invalid. 
        /// </summary>
        private async Task<bool> ValidateColumnValues(
            List<ImportResultInfo> importResults,
            int rowIndex,
            IDictionary<string,string> rowData)
        {
            int countOnEntry = importResults.Count;
            int rowNumber = rowIndex + 1; 
            try
            {
                // ' (1)  UID
                string uidColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxUid];
                string uid = rowData[uidColumnName];
                if (string.IsNullOrWhiteSpace(uid))
                {
                    uid = "(UID unspecified)"; //For error reporting purpose
                    importResults.Add(new ImportResultInfo(rowNumber, uid, uidColumnName, "The field is required"));
                }
                else if (uid.Length > 320)
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, uidColumnName, $"{uidColumnName} exceeds 320 characters"));
                }
                else
                {
                    if (isTrkListActiveYN)
                    {
                        //If the tracking list feature is active then we need to check
                        //if any of this lists tracking lists contain the UID (if so its presence here is considered invalid)
                        string trkListIds = qnnList?[Constants.FieldName.TrkListIds]?.ToString();
                        if (trkListIds != null)
                        {
                            // List is linked to a tracking lists
                            List<Guid> trkListIdArray = JsonConvert.DeserializeObject<List<Guid>>(trkListIds);
                            Filter filter = Filter.And.In(trkListIdArray, Constants.FieldName.TrklistId).Equal(uid, Constants.FieldName.UID);
                            DynamicEntity trkListSampleEntity = (await qnnTrkListSampleModel.GetAsync(filter)).FirstOrDefault();
                            if (trkListSampleEntity != null)
                            {
                                // UID exists in tracking list
                                string msg = $"{uidColumnName} exists in Tracking List {trkListSampleEntity["TrkListId_Name"]}";
                                importResults.Add(new ImportResultInfo(rowNumber, uid, uidColumnName, msg));
                            }
                        }
                    }
                }
                // ' (2)  NAME
                string nameColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxName];
                string name = rowData[nameColumnName];
                if (string.IsNullOrWhiteSpace(name))
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, nameColumnName, "The field is required"));
                }
                else if (name.Length > 128)
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, nameColumnName, $"{nameColumnName} exceeds 128 characters"));
                }

                // ' (3) EMAIL
                string emailColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxEmail];
                string toEmails = rowData[emailColumnName];
                if (!string.IsNullOrWhiteSpace(toEmails))
                {
                    try
                    {
                        Email.SplitAddresses(toEmails);
                    }
                    catch(FormatException)
                    {
                        importResults.Add(new ImportResultInfo(rowNumber, uid, emailColumnName, "Invalid email address list"));
                    }
                }

                // ' (4) CC_EMAIL
                string ccEmailsColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxCcEmails];
                string ccEmails = rowData[ccEmailsColumnName];
                if (!string.IsNullOrWhiteSpace(ccEmails))
                {
                    try
                    {
                        Email.SplitAddresses(ccEmails);
                    }
                    catch(FormatException)
                    {
                        importResults.Add(new ImportResultInfo(rowNumber, uid, ccEmailsColumnName, "Invalid cc email address list"));
                    }
                }

                // ' (5) ACTIVE
                string activeColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxActive];
                string active = rowData[activeColumnName];
                if (string.IsNullOrWhiteSpace(active))
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, activeColumnName, "The field is required"));
                }
                else if (!ConversionUtils.IsValidTrueYN(active))
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, activeColumnName, $"Invalid code [{active}]"));
                }

                // ' (6) PASSWORD_RESET
                string passwordResetColumnName = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxPasswordReset];
                string passwordReset = rowData[passwordResetColumnName];
                if (string.IsNullOrWhiteSpace(passwordReset))
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, passwordResetColumnName, "The field is required"));
                }
                else if (!ConversionUtils.IsValidTrueYN(passwordReset))
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, passwordResetColumnName, $"Invalid code [{passwordReset}]"));
                }

                const int addressLineMaxLength = 64;

                // ' (7) Optional Data
                String addressLine1 = rowData.ContainsKey(Constants.SampleListCsv.AddressLine1) ? rowData[Constants.SampleListCsv.AddressLine1] : null;
                if(addressLine1 != null && addressLine1.Length > addressLineMaxLength)
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, Constants.SampleListCsv.AddressLine1, $"May not exceed {addressLineMaxLength} characters"));
                }

                String addressLine2 = rowData.ContainsKey(Constants.SampleListCsv.AddressLine2) ? rowData[Constants.SampleListCsv.AddressLine2] : null;
                if (addressLine2 != null && addressLine2.Length > addressLineMaxLength)
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, Constants.SampleListCsv.AddressLine2, $"May not exceed {addressLineMaxLength} characters"));
                }

                String addressLine3 = rowData.ContainsKey(Constants.SampleListCsv.AddressLine3) ? rowData[Constants.SampleListCsv.AddressLine3] : null;
                if (addressLine3 != null && addressLine3.Length > addressLineMaxLength)
                {
                    importResults.Add(new ImportResultInfo(rowNumber, uid, Constants.SampleListCsv.AddressLine3, $"May not exceed {addressLineMaxLength} characters"));
                }

                bool foundAnyErrors = (importResults.Count > countOnEntry);
                return foundAnyErrors;
            }
            catch (Exception e)
            {
                throw new InternalException($"Unexpected exception caught while validating record at index {rowIndex}", e);
            }
        } //end of ValidateRequiredFields

        private void UpdateSampleAddress(
            DynamicEntity qnnSampleAddress, 
            string toEmails, 
            string ccEmails, 
            string addressLine1, 
            string addressLine2, 
            string addressLine3)
        {
            qnnSampleAddress[Constants.FieldName.UpdatedBy] = importingUserId;
            qnnSampleAddress[Constants.FieldName.UpdatedDate] = DateTime.Now;
            qnnSampleAddress[Constants.FieldName.ToEmails] = toEmails;
            qnnSampleAddress[Constants.FieldName.CcEmails] = ccEmails;

            //Optional address book values (we get passed null if not in csv, in which case set empty string)
            qnnSampleAddress[Constants.FieldName.AddressLine1] = addressLine1 ?? "";
            qnnSampleAddress[Constants.FieldName.AddressLine2] = addressLine2 ?? "";
            qnnSampleAddress[Constants.FieldName.AddressLine3] = addressLine3 ?? "";            
        }

        /// <summary>
        /// Mutable object to return prepared entities from the PrepareEntities method
        /// </summary>
        private class ListSamplesImportData
        {
            //TODO - we could probably rationalise some of these, e.g. are the count ints redundant since we can use list count etc?

            public DataTable ListSamplesToInsertTable { get; private set; }
            public List<DynamicEntity> ListSamplesToUpdate { get; private set; }
            public DataTable ListSamplePropsToInsertTable { get; private set; }
            public List<Guid> ListSampleIds { get; private set; }
            public int InsertCount { get; private set; }
            public int UpdateCount { get; private set; }
            public int ExceptionCount { get; private set; }

            public void ReleaseListSamplesToInsert() { ListSamplesToInsertTable = null;  } //Clear reference so GC can cleanup
            public void ReleaseListSamplesToUpdate() { ListSamplesToUpdate = null; }
            public void ReleaseListSamplePropsToInsert() { ListSamplePropsToInsertTable = null; }

            public ListSamplesImportData(
                DataTable listSamplesToInsertTable, 
                List<DynamicEntity> listSamplesToUpdate, 
                DataTable listSamplePropsToInsertTable,
                List<Guid> listSampleIds, 
                int insertCount, 
                int updateCount, 
                int exceptionCount)
            {
                this.ListSamplesToInsertTable = listSamplesToInsertTable ?? throw new ArgumentNullException(nameof(listSamplesToInsertTable));
                this.ListSamplesToUpdate = listSamplesToUpdate ?? throw new ArgumentNullException(nameof(listSamplesToUpdate));
                this.ListSamplePropsToInsertTable = listSamplePropsToInsertTable ?? throw new ArgumentNullException(nameof(listSamplePropsToInsertTable));
                this.ListSampleIds = listSampleIds ?? throw new ArgumentNullException(nameof(listSampleIds));
                this.InsertCount = insertCount;
                this.UpdateCount = updateCount;
                this.ExceptionCount = exceptionCount;
            }

            public override string ToString()
            {
                return $"{nameof(ListSamplesImportData)}[{nameof(ListSamplesToInsertTable)}.Count={ListSamplesToInsertTable?.Rows?.Count}, {nameof(ListSamplesToUpdate)}.Count={ListSamplesToUpdate?.Count}, {nameof(ListSamplePropsToInsertTable)}.Rows.Count={ListSamplePropsToInsertTable?.Rows?.Count}, {nameof(ListSampleIds)}.Count={ListSampleIds?.Count}, {nameof(InsertCount)}={InsertCount}, {nameof(UpdateCount)}={UpdateCount}, {nameof(ExceptionCount)}={ExceptionCount}]";
            }
        }

        private async Task<ListSamplesImportData> PrepareEntities(
            IList<IDictionary<string, string>> rows,
            Dictionary<string, Guid> uidToSampleId,
            HashSet<string> uidOfEverySampleInSurveyPlus,
            List<ImportResultInfo> lstImportResult,
            int exceptionCount)
        {
            Guid listId = (Guid)qnnList[Constants.FieldName.Id];

            int addedCount = 0;
            int updatedCount = 0;
            DataTable newListSampleTable = PrepareQnnListSampleTable();
            List<DynamicEntity> updateListSampleList = new List<DynamicEntity>();
            DataTable newSamplePropTable = PrepareQnnListSamplePropTable();
            List<Guid> listSampleIds = new List<Guid>();
            List<Guid> processedSampleIds = new List<Guid>();

            try
            {
                ImportResultInfo oImportRes;

                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(PrepareEntities) + " -  preparing entities for {0} rows, qnnListId={1}", rows?.Count, qnnListId);
                }
                for (int iRow = 0; iRow <= rows.Count - 1; iRow++)
                {
                    IDictionary<string, string> rowDict = rows[iRow];  //used to be string,object so you might still seem some extraneous ToString() below
                    string uid = (string)rowDict[Constants.FieldName.UID];
                    if (!uidToSampleId.ContainsKey(uid) || (processedSampleIds.Contains((Guid)uidToSampleId[uid])))
                        continue; //skip rows with error || duplicated UID
                    Guid sampleId = uidToSampleId[uid];
                    string peerUID = (string)(!rowDict.ContainsKey("PEER_UID") ? "" : rowDict["PEER_UID"]);
                    bool activeYN 
                        = ConversionUtils.IsTrueYN(rowDict[Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxActive]]);
                    Guid? samplePeerId;
                    Guid listSampleId;
                    bool hasPeer = !string.IsNullOrWhiteSpace(peerUID);
                    if (hasPeer)
                    {
                        samplePeerId = uidToSampleId.ContainsKey(peerUID)
                            ? uidToSampleId[peerUID]
                            : (Guid?)null;
                        if (samplePeerId == null) //no sample's UID in the file has that PeerUID 
                        {
                            bool notInDb = !uidOfEverySampleInSurveyPlus.Contains(peerUID);
                            if (notInDb)
                            {   //Record an error in the import results
                                oImportRes = new ImportResultInfo();
                                oImportRes.RowNo = iRow + 1;
                                oImportRes.UID = rowDict[Constants.FieldName.UID];
                                oImportRes.ErrField = Constants.SampleListCsv.REQUIRED_COLUMNS[Constants.SampleListCsv.idxPeerUid];
                                oImportRes.ErrMsg = $"Invalid PeerUID [{peerUID}]";
                                lstImportResult.Add(oImportRes);
                                exceptionCount += 1;
                                continue;
                            }
                            else
                            {
                                //samplePeerId in the db
                                DynamicEntity peer
                                    = (await qnnSampleModel.GetAsync(Filter.And.Equal(peerUID, Constants.FieldName.UID)))
                                    .FirstOrDefault();
                                samplePeerId = (Guid)peer[Constants.FieldName.Id];
                            }
                        }
                    }
                    else
                    {
                        samplePeerId = null;
                    }

                    //Insert list sample

                    Filter filter = Filter.And
                        .Equal(listId, Constants.FieldName.ListId)
                        .Equal(sampleId, Constants.FieldName.SampleId)
                        .Equal(samplePeerId, Constants.FieldName.SamplePeerId);
                    DynamicEntity listSampleEntity = (await qnnListSampleModel.GetAsync(filter)).FirstOrDefault();

                    if (listSampleEntity == null)
                    {
                        listSampleId = Guid.NewGuid();
                        newListSampleTable.Rows.Add(
                            listSampleId,           //Id
                            listId,                 //ListId
                            sampleId,               //SampleId
                            samplePeerId,           //SamplePeerId
                            activeYN,               //ActiveYN
                            importingUserId,        //CreatedBy
                            DateTime.Now);          //CreatedDate

                        addedCount += 1;
                    }
                    else
                    {
                        //Existing listSample to be updated - but only if active status needs to change
                        if (Convert.ToBoolean(listSampleEntity[Constants.FieldName.ActiveYN]) != activeYN)
                        {
                            //update
                            listSampleEntity[Constants.FieldName.ActiveYN] = activeYN;
                            listSampleEntity[Constants.FieldName.UpdatedDate] = DateTime.Now;
                            listSampleEntity[Constants.FieldName.UpdatedBy] = importingUserId;
                            updateListSampleList.Add(listSampleEntity);
                        }
                        //else no need to update
                        listSampleId = (Guid)listSampleEntity[Constants.FieldName.Id];
                        updatedCount += 1;
                    }
                    processedSampleIds.Add(uidToSampleId[uid]);
                    listSampleIds.Add(listSampleId);

                    //use listSampleId, listId, listPropId to add QNN_LIST_SAMPLE_PROP
                    //(it will have deleted existing records before these are added)
                    List<DynamicEntity> qnnListProps = await SampleListApplication.GetQnnListPropsByListIdAsync(listId);
                    foreach(DynamicEntity qnnListProp in qnnListProps)
                    {
                        string alias = (string)qnnListProp[Constants.FieldName.Alias];
                        if(!rowDict.TryGetValue(alias, out string listPropValue))
                            throw new InternalException($"No column for list sample property \"{alias}\"");
                        Guid listPropId = (Guid)qnnListProp[Constants.FieldName.Id];

                        newSamplePropTable.Rows.Add(
                            Guid.NewGuid(),         //Id
                            listId,                 //ListId
                            listSampleId,           //ListSampleId
                            listPropId,             //ListPropId
                            listPropValue);         //ListPropValue
                    }

                    if(iRow % 500 == 0 && logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(PrepareEntities) + " - prepared {0} entities for qnnListId={1}, newListSampleTable.Rows.Count={2}, updateListSampleList.Count={3}, newSamplePropTable.Rows.Count={4}, listSampleIds.Count={5}, addedCount={6}, updatedCount={7}, exceptionCount={8}", (iRow+1), qnnListId, newListSampleTable?.Rows.Count, updateListSampleList?.Count, newSamplePropTable?.Rows?.Count, listSampleIds?.Count, addedCount, updatedCount, exceptionCount);
                    }

                } //end for iRow

                //Good ending
                ListSamplesImportData result = new ListSamplesImportData(
                    listSamplesToInsertTable: newListSampleTable,
                    listSamplesToUpdate: updateListSampleList,
                    listSamplePropsToInsertTable: newSamplePropTable,
                    listSampleIds: listSampleIds,
                    insertCount: addedCount,
                    updateCount: updatedCount,
                    exceptionCount: exceptionCount);

                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(PrepareEntities) + " - completed preparing entities for qnnListId={0}, returning {1}", qnnListId, result);
                }

                return result;
            }
            catch (Exception e)
            {
                //Bad ending

                //At this point the list may be in an inconsistent state depending on what was already written when the
                //error occured. (We can't process it in one big transaction with rollback because the import takes a long
                //time and the locking that would result in the meantime can make the application unusable)
                logger.LogError(e, nameof(PrepareEntities) + " - caught an unexpected exception");

                //TODO - to review should we return this even though we caught an exception?
                //       No, it needs to return an explicit error result
                //       see example around peer stuff about line 905-ish (but what happens with that info, its just discarded?)

                exceptionCount++;

                ListSamplesImportData badResult = new ListSamplesImportData(
                        listSamplesToInsertTable: newListSampleTable,
                        listSamplesToUpdate: updateListSampleList,
                        listSamplePropsToInsertTable: newSamplePropTable,
                        listSampleIds: listSampleIds,
                        insertCount: addedCount,
                        updateCount: updatedCount,
                        exceptionCount: exceptionCount);
                logger.LogError(nameof(PrepareEntities) + " - did not complete for qnnListId={0}, returning {1}", qnnListId, badResult);
                return badResult;
            }
        }

        private DataTable PrepareQnnSampleTable()
        {
            DataTable table = new DataTable($"dbo.{Constants.ModelName.QNN_SAMPLE}");
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ActiveYN, typeof(bool));
            table.Columns.Add(Constants.FieldName.UID, typeof(string));
            table.Columns.Add(Constants.FieldName.Name, typeof(string));
            table.Columns.Add(Constants.FieldName.CreatedBy, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));
            table.Columns.Add(Constants.FieldName.NumRetry, typeof(int));
            table.Columns.Add(Constants.FieldName.PwdResetYN, typeof(bool));
            table.Columns.Add(Constants.FieldName.Pwd, typeof(string));
            return table;
        }

        private DataTable PrepareSampleStructDivisionTable()
        {
            DataTable table = new DataTable($"dbo.{Constants.ModelName.QNN_SAMPLE_STRUCTDIVISION}");
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.SampleId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.StructDivisionId, typeof(Guid));
            return table;
        }

        private DataTable PrepareQnnSampleAddressTable()
        {
            DataTable table = new DataTable($"dbo.{Constants.ModelName.QNN_SAMPLE_ADDRESS}");
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.SampleId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.StructDivisionId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedBy, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));
            table.Columns.Add(Constants.FieldName.ToEmails, typeof(string));
            table.Columns.Add(Constants.FieldName.CcEmails, typeof(string));
            table.Columns.Add(Constants.FieldName.AddressLine1, typeof(string));
            table.Columns.Add(Constants.FieldName.AddressLine2, typeof(string));
            table.Columns.Add(Constants.FieldName.AddressLine3, typeof(string));
            return table;
        }

        private DataTable PrepareQnnListSampleTable()
        {
            DataTable table = new DataTable($"dbo.{Constants.ModelName.QNN_LIST_SAMPLE}");
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ListId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.SampleId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.SamplePeerId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ActiveYN, typeof(bool));
            table.Columns.Add(Constants.FieldName.CreatedBy, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));
            return table;
        }

        private DataTable PrepareQnnListSamplePropTable()
        {
            DataTable table = new DataTable($"dbo.{Constants.ModelName.QNN_LIST_SAMPLE_PROP}");
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ListId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ListSampleId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ListPropId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.PropValue, typeof(string));
            return table;
        }

    }
}
