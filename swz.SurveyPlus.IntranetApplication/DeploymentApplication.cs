using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.SurveyPlus.IntranetApplication.Utilities;
using swz.Clover.Core.Utils;
using System.Text;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using System.Data;
using swz.Clover.Core.Security;
using System.Collections.ObjectModel;
using System.IO;
using CsvHelper.Configuration;
using System.Globalization;
using CsvHelper;
using Newtonsoft.Json;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class DeploymentApplication
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(DeploymentApplication));

        /// <summary>
        /// Checks QNN_DPLY_SAMPLE_OWNER to see that the user is authorised for the deployment and list sample
        /// identified in the specified dsi/lsi.
        /// nb: doesn't check whether the user has the data editor role
        /// </summary>
        /// <param name="qnnDplySampleInfo">The QNN_DPLY_SAMPLE_INFO entity (dsi), this specifies which sample and deployment. 
        /// vSP_ListSampleInfo (lsi) entity is also compatible here</param>
        /// <param name="dataEditorId">optional id of the clover security user to check for, if null will check for the current user, empty always returns false</param>
        /// <returns>true if user authorised for this sample in this deployment</returns>
        public static async Task<bool> CheckEditorsAccess(dynamic qnnDplySampleInfo, Guid? dataEditorId = null)
        {
            //This method was previously named BusinessProcess.CheckAccess

            //nb: if you get an exception about ListSampleId not being present then check that what you passed in is
            //    actually an entity. The dynamic keyword allows any old rubbish (and DynamicEntity is only marginally better)
            //    and its not uncommon to use the wrong entity or forget an await somewhere and end up passing in a Task instead

            if (Guid.Empty.Equals(dataEditorId)) return false;

            if (dataEditorId == null)
            {
                dataEditorId = CloverRuntime.Security.CurrentUser.Id;
                if (dataEditorId == null)
                    throw new ArgumentException("There is no current user and dataEditorId was not specified");
            }
            return await CheckEditorsAccess(
                listSampleId: (Guid)qnnDplySampleInfo.ListSampleId,
                dplyId: (Guid)qnnDplySampleInfo.DplyId,
                dataEditorId: dataEditorId.Value);
        }

        public static async Task<bool> CheckEditorsAccess(Guid listSampleId, Guid dplyId, Guid dataEditorId)
        {
            if (Guid.Empty.Equals(dataEditorId)) return false;

            //TODO - the below could be done more efficiently with a stored procedure
            EntityModel qnnDplySampleOwnerModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_OWNER, Constants.Level.NoJoins);
            Filter byUserAndSampleAndDeployment = Filter.And
                .Equal(dataEditorId, Constants.FieldName.UserId)
                .Equal(listSampleId, Constants.FieldName.ListSampleId)
                .Equal(dplyId, Constants.FieldName.DplyId);
            DynamicEntity owner = (await qnnDplySampleOwnerModel.GetAsync(byUserAndSampleAndDeployment)).FirstOrDefault();
            //Presence of a row in the ownership table indicates the specified user is assigned this sample in this deployment
            return (owner != null);
        }

        /// <summary>
        /// Will assert that the specified user is an unlocked DataOwner with StructDivision access to the specified deployment.
        /// A descriptive PermissionException will be thrown if this is not the case.
        /// This method is async. Don't forget to await it!
        /// </summary>
        /// <exception cref="PermissionException"></exception>
        public static async Task AssertDataOwner(DynamicEntity qnnDply, Clover.Core.Security.User user)
        {
            if (user.IsLocked)
                throw new PermissionException($"User {user.Id} ({user.Name}) is locked");

            if (!user.IsInRole(Constants.Role.DataOwner))
                throw new PermissionException($"User {user.Id} ({user.Name}) lacks {Constants.Role.DataOwner} role");

            HashSet<Guid> usersOrganisations = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!usersOrganisations.Contains((Guid)qnnDply[Constants.FieldName.StructDivisionId]))
                throw new PermissionException($"User {user.Id} ({user.Name}) in SructDivision {user.StructDivisionId} does not have organisation access for QNN_DPLY {(Guid)qnnDply[Constants.FieldName.Id]} in StructDivision {(Guid)qnnDply[Constants.FieldName.StructDivisionId]}");
        }

        /// <summary>
        /// Wraps some information from the CSV pre-population (e.g. for use in the email)
        /// </summary>
        public class PrePopulateFromCsvInfo
        {
            public ReadOnlyCollection<string> InvalidHeaders { get; private set; }
            public ReadOnlyCollection<int> IgnoredUIDRows { get; private set; }
            public ReadOnlyCollection<int> DuplicateUIDRows { get; private set; }
            public ReadOnlyCollection<int> InvalidRows { get; private set; }

            public PrePopulateFromCsvInfo(
                List<string> invalidHeaders,
                List<int> ignoredUIDRows,
                List<int> duplicateUIDRows,
                List<int> invalidRows)
            {
                this.InvalidHeaders = invalidHeaders.AsReadOnly();
                this.IgnoredUIDRows = ignoredUIDRows.AsReadOnly();
                this.DuplicateUIDRows = duplicateUIDRows.AsReadOnly();
                this.InvalidRows = invalidRows.AsReadOnly();
            }
        }

        /// <summary>
        /// Helper method to get an instance of entity QNN_DPLY_SAMPLE_INFO by its id.
        /// Will throw an argument exception on empty Guid or invalid model reference
        /// </summary>
        /// <param name="id">id, may not be empty</param>
        /// <param name="qnnDplySampleInfoModel">optional model to use. Will use NoJoins fetch if not specified.</param>
        /// <returns>entity or null if not found</returns>
        public static async Task<DynamicEntity> GetQnnDplySampleInfoById(Guid id, EntityModel qnnDplySampleInfoModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_DPLY_SAMPLE_INFO, qnnDplySampleInfoModel);
        }

        /// <summary>
        /// Helper method to get an instance of entity QNN_DPLY by its id.
        /// Will throw an argument exception on empty Guid or invalid model reference
        /// </summary>
        /// <param name="id">id, may not be empty</param>
        /// <param name="qnnDplyModel">optional model to use. Will use NoJoins fetch if not specified.</param>
        /// <returns>entity or null if not found</returns>
        public static async Task<DynamicEntity> GetQnnDplyById(Guid id, EntityModel qnnDplyModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_DPLY, qnnDplyModel);
        }

        /// <summary>
        /// Returns the report snapshot settings for the given deployment.
        /// Note that while this retrieves data from QNN_DPLY_SCHEDULER, the id it takes is that of the relevant QNN_DPLY
        /// </summary>
        /// <param name="dplyId">deployment id</param>
        /// <param name="qnnDplySchedulerModel">optional model to reuse</param>
        /// <returns>report snapshot settings or null if there are none for this deployment</returns>
        public static async Task<DynamicEntity> GetQnnDplySchedulerByDplyId(Guid dplyId, EntityModel qnnDplySchedulerModel = null)
        {
            //TODO - I hope one day to rename QNN_DPLY_SCHEDULER to something clearer like QNN_DPLY_SNAPSHOT_SETTINGS maybe
            if (qnnDplySchedulerModel==null)
            {
                qnnDplySchedulerModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SCHEDULER, Constants.Level.NoJoins);
            }
            DynamicEntity qnnDplyScheduler
                = (await qnnDplySchedulerModel.GetAsync(Filter.And.Equal(dplyId, Constants.FieldName.DplyId))).FirstOrDefault();
            return qnnDplyScheduler;
        }

        /// <summary>
        /// Returns QR Code images and URL information for each form (e.g. language) in the survey. 
        /// </summary>
        /// <param name="dplyId"></param>
        /// <returns></returns>
        public static async Task<List<AnonymousSurveyUrl>> GenerateAnonymousSurveyUrl(Guid dplyId)
        {
            if (dplyId == Guid.Empty) throw new ArgumentException("May not be empty", nameof(dplyId));

            //EntityModel qnnDplyModel
            //    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
            DynamicEntity qnnDply = await GetQnnDplyById(dplyId);
            if (qnnDply == null) throw new ArgumentException($"QNN_DPLY {dplyId} not found", nameof(qnnDply));
            bool isAnonymousSurvey = (bool)qnnDply[Constants.FieldName.IsAnonymous];
            if (!isAnonymousSurvey) throw new InvalidOperationException($"QNN_DPLY {dplyId} is not an anonymous survey");

            Guid anonymousDSLI = await GetSWZAnonymousDLSI(dplyId);

            string internetDomainAuthority
                = await SettingsHelper.Common.GetInternetDomainAuthority();
            List<(string, string)> qnnFormNameAndLangDict = await GetQNNFormNameAndLang((Guid)qnnDply[Constants.FieldName.QnnId]);

            List<AnonymousSurveyUrl> result = new List<AnonymousSurveyUrl>();

            foreach ((string, string) formAndLang in qnnFormNameAndLangDict)
            {
                AnonymousSurveyUrl anonymousSurvey = new AnonymousSurveyUrl();
                anonymousSurvey.url = SurveyUrl(internetDomainAuthority, formAndLang.Item1, anonymousDSLI);
                anonymousSurvey.language = System.Web.HttpUtility.HtmlEncode(formAndLang.Item2);
                anonymousSurvey.qrCode = QRCodeUtils.GenerateQrCodePng(anonymousSurvey.url);
                result.Add(anonymousSurvey);
            }

            return result.OrderBy(e => e.language).ToList();
        }

        /// <summary>
        /// Format a URL for a survey (without a respId)
        /// </summary>
        /// <param name="internetDomainAuthority"></param>
        /// <param name="formName"></param>
        /// <param name="dlsi"></param>
        /// <returns></returns>
        public static string SurveyUrl(string internetDomainAuthority, string formName, Guid dlsi)
        {
            if (string.IsNullOrEmpty(internetDomainAuthority)) throw new ArgumentException("required", nameof(internetDomainAuthority));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException("required", nameof(formName));
            //string urlSplit = internetDomainAuthority[internetDomainAuthority.Length - 1] == '/' ? string.Empty : "/";
            //return $"{internetDomainAuthority}{urlSplit}form/{formName}/dlsi/{dlsi}";
            StringBuilder b = new StringBuilder();
            if(! (internetDomainAuthority.StartsWith("https://",StringComparison.InvariantCultureIgnoreCase) 
                || (internetDomainAuthority.StartsWith("http://", StringComparison.InvariantCultureIgnoreCase))))
            {
                //The internetDomainAuthority is usually (and assumed to be) configured without protocol so we need to add it here
                b.Append("https://"); //TODO: would be convenient to make it http when running locally or in an http demo instance
            }
            b.Append(internetDomainAuthority);
            if(!internetDomainAuthority.EndsWith('/')) 
                b.Append('/');
            b.Append("form/");
            b.Append(formName);
            b.Append("/dlsi/");
            b.Append(dlsi);
            return b.ToString();
        }

        /// <summary>
        /// Find the Id in QNN_DPLY_SAMPLE_INFO (the DLSI) for the swzAnonymous sample in the specified deployment.
        /// </summary>
        /// <param name="dplyId"></param>
        /// <returns>dlsi</returns>
        public static async Task<Guid> GetSWZAnonymousDLSI(Guid dplyId)
        {
            if (dplyId == Guid.Empty) throw new ArgumentException("required", nameof(dplyId));

            EntityModel dsliEntityModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

            //Get ALL the QNN_DPLY_SAMPLE_INFO for this deployment (i.e. every sample)
            //This method would normally only be used with an anonymous survey however, so typically swzAnonymous would be the only one
            //but if you pass a deployment with 20,0000 samples it won't be very efficient
            List<DynamicEntity> dlsiList = await dsliEntityModel.GetAsync(Filter.And.Equal(dplyId, Constants.FieldName.DplyId));
            if (dlsiList == null || dlsiList.Count == 0) throw new Exception($"Unable to found swzAnonymous DSLI with DplyId {dplyId}");

            //<ListSampleId, DLSI>
            Dictionary<Guid, Guid> dlsiGuidDict
                = dlsiList.ToDictionary(d => (Guid)d[Constants.FieldName.ListSampleId], d => (Guid)d[Constants.FieldName.Id]);
            //Dictionary<Guid, Guid> dlsiGuidDict = new Dictionary<Guid, Guid>();
            //foreach (DynamicEntity deDLSI in dlsiList)
            //    dlsiGuidDict[Guid.Parse(deDLSI.Dictionary[Constants.FieldName.ListSampleId].ToString())] = Guid.Parse(deDLSI.Dictionary[Constants.FieldName.Id].ToString());

            EntityModel listSampleEntityModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.FetchJoins);

            List<DynamicEntity> sampleList = await listSampleEntityModel.GetAsync(Filter.And.In(dlsiGuidDict.Keys.ToList<Guid>(), Constants.FieldName.Id));
            if (sampleList == null || sampleList.Count == 0) 
                throw new InvalidOperationException($"[1] Unable to find swzAnonymous DSLI with DplyId {dplyId}");

            //Filter out swzanonymous
            List<DynamicEntity> anonymousList = sampleList.Where(sample => sample.Dictionary["SampleId_" + Constants.FieldName.UID].ToString() == Constants.SwzAnonymous.Uid).ToList();
            if (anonymousList == null || anonymousList.Count == 0) 
                throw new InvalidOperationException($"[2] Unable to find swzAnonymous DSLI with DplyId {dplyId}");

            //Should only have one swzanonymous in the listing
            Guid anonymousListSampleId = Guid.Parse(anonymousList.FirstOrDefault().Dictionary[Constants.FieldName.Id].ToString());
            if(!dlsiGuidDict.ContainsKey(anonymousListSampleId)) 
                throw new InvalidOperationException($"[3] Unable to find swzAnonymous DSLI with DplyId {dplyId}");

            Guid anonymousDLSI = dlsiGuidDict[anonymousListSampleId];
            return anonymousDLSI;
        }

        private static async Task<List<(string, string)>> GetQNNFormNameAndLang(Guid qnnId)
        {
            EntityModel qnnFormEntityModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);
            List<DynamicEntity> qnnFormList = await qnnFormEntityModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId));
            if (qnnFormList == null || qnnFormList.Count == 0)
                throw new Exception($"Unable to found Form Properties Questionnaire with QnnId {qnnId}");

            List<(string, string)> result = new List<(string, string)>();
            foreach (DynamicEntity deQnnForm in qnnFormList)
            {
                if(deQnnForm.Dictionary[Constants.FieldName.Language] != null)
                {
                    string qnnName = deQnnForm.Dictionary[Constants.FieldName.Name].ToString();
                    string lang = deQnnForm.Dictionary[Constants.FieldName.Language].ToString();
                    if (!string.IsNullOrEmpty(lang))
                        result.Add((qnnName, lang));
                }
            }

            return result;
        }

        public struct AnonymousSurveyUrl {
            public string url;
            public string language;
            public byte[] qrCode;
        }

        /// <summary>
        /// Returns false if the QNN_DPLY doesn't belong to one of the CURRENT user's struct divisions.
        /// A NotFoundException is raised if the QNN_DPLY is not found.
        /// (If you want to pass in a different user to check, please use the other overload of this method 
        /// that takes a user reference.)
        /// </summary>
        /// <param name="qnnDplyId"></param>
        /// <returns>true if users organistions include that of the specified deployment</returns>
        public static async Task<bool> CheckDeploymentStructDivisionAccessAsync(Guid qnnDplyId, EntityModel qnnDplyModel=null)
        {
            DynamicEntity qnnDply = await GetQnnDplyById(qnnDplyId, qnnDplyModel);
            if (qnnDply == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, qnnDplyId);
            return await CheckDeploymentStructDivisionAccessAsync(qnnDply);
        }

        /// <summary>
        /// Returns false if the QNN_DPLY doesn't belong to one of the specified user's struct divisions.
        /// If you pass null for the user it will use the current user. (If you want it to check the current user
        /// and you already happen to have a reference to the current user, please pass it in to save an extra lookup!)
        /// </summary>
        /// <param name="qnnDply">A QNN_DPLY entity</param>
        /// <param name="user">The user whose access to check, if null will check the current user</param>
        /// <returns>true if users organistions include that of the specified deployment</returns>
        public static async Task<bool> CheckDeploymentStructDivisionAccessAsync(DynamicEntity qnnDply, User user=null)
        {
            if (qnnDply == null) throw new ArgumentNullException(nameof(qnnDply));
            if (user == null)
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                if (currentUser == null)
                    throw new InvalidOperationException("There is no current user"); //Would be the case in a hangfire job
                user = currentUser;
            }
                
            Guid? dplyStructDivisionId = (Guid?)qnnDply?[Constants.FieldName.StructDivisionId]; //TODO - why is column nullable?
            return (dplyStructDivisionId == null)
                ? false
                : await user.IsInStructDivisionAsync((Guid)dplyStructDivisionId);
        }

        /// <summary>
        /// Given Id in QNN_DPLY_SAMPLE_INFO returns whether or not the associated deployment is anonymous.
        /// An exception is raised if the dlsi is not valid. 
        /// </summary>
        /// <param name="dlsi"></param>
        /// <returns></returns>
        public static async Task<bool> IsAnonymousSurvey(Guid dlsi)
        {
            EntityModel vSPListSampleInfoModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);
            Filter byDlsi = Filter.And.Equal(dlsi, Constants.FieldName.Id);
            DynamicEntity vSPListSampleInfo = (await vSPListSampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
            if (vSPListSampleInfo == null) throw NotFoundException.ForModelName(Constants.ModelName.vSP_ListSampleInfo, dlsi);
            bool isAnonymous = (bool)vSPListSampleInfo[Constants.FieldName.IsAnonymous];
            if (isAnonymous && !Constants.SwzAnonymous.Uid.Equals((string)vSPListSampleInfo[Constants.FieldName.UID]))
            {
                //We have encountered invalid application state so throw an exception. 

                //deploy to wrong sample - anonymous survey should only be deployed to anonymous users
                //TODO - evaluate this in terms of business case. Do we want such survey to be deployable to other samples
                //       (If so also need consider implications of doing so and test)  

                //We don't support an identified sample for an anonymous survey (at least not in this version)
                throw new InvalidOperationException(
                    $"Survey is an anonymous survey but the sample specified in dlsi {dlsi} is not {Constants.SwzAnonymous.Uid}");
            }
            return isAnonymous;
        }

        //TODO - use constants for model names and fetch level and entity columns
        //TODO - explicit types instead of var
        /// <summary>
        /// Utility method to get the Name of the form properties used by the specified deployment.
        /// </summary>
        /// <param name="dplyId">Id in QNN_DPLY</param>
        /// <returns>Name in QNN_QNN (Form Properties)</returns>
        public static async Task<string> GetDplyFormName(Guid dplyId)
        {
            try
            {
                var dplyModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, 0);
                var entity = (await dplyModel.GetAsync(Filter.And.Equal(dplyId, "Id"))).FirstOrDefault();
                if (entity == null) return null;
                var qnnId = (Guid)entity["QnnId"];
                var qnnFormModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, 0);
                var qnnFormEntity = (await qnnFormModel.GetAsync(Filter.And.Equal(qnnId, "QnnId"))).FirstOrDefault();
                if (qnnFormEntity == null) return null;
                return (string)qnnFormEntity["Name"];
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(GetDplyFormName) + " - caught unexpected exception, dplyId={0}", dplyId);
                return null;
            }
        }

        public class InvalidValidationDatasetException : Exception
        {
            /// <summary>
            /// reasonString is intended to be returned to the clientside file field by the controller
            /// </summary>
            public InvalidValidationDatasetException(string reasonString) : base(reasonString) { }
        }

        public static async Task<Dictionary<string, object>> UploadValidationDatasetsFromCSV(
            User user, 
            Guid dplyId, 
            Stream stream)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));
            if (stream == null) throw new ArgumentNullException(nameof(stream));

            //TODO - previously transaction around the whole operation was removed (due to size issues?)
            //       to review this and see if practical to bring back. Bear in mind that deployments may
            //       have tens of thousands of samples.

            try
            {
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(user.Id);
                Guid auditStructDivisionId = user.StructDivisionId.Value;

                string[] headerRowColumns = null;

                DataTable dataTable = new DataTable(Constants.ModelName.QNN_DPLY_DATASET);
                dataTable.Columns.Add(Constants.FieldName.Id, typeof(Guid));
                dataTable.Columns.Add(Constants.FieldName.DplyId, typeof(Guid));
                dataTable.Columns.Add(Constants.FieldName.SampleId, typeof(Guid));
                dataTable.Columns.Add(Constants.FieldName.Data, typeof(string));
                dataTable.Columns.Add(Constants.FieldName.CreatedBy, typeof(Guid));
                dataTable.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));

                //Build a lookup table of the UID and SampleId of the samples in this deployment
                Dictionary<string, Guid> sampleIdByUID = new Dictionary<string, Guid>(StringComparer.InvariantCultureIgnoreCase);
                {
                    EntityModel vSPListSampleInfoModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);
                    Filter filterByDplyId = Filter.And.Equal(dplyId, Constants.FieldName.DplyId);
                    List<DynamicEntity> sampleInfoCollection = await vSPListSampleInfoModel.GetAsync(filterByDplyId);
                    foreach (DynamicEntity lsi in sampleInfoCollection)
                    {
                        //Use TryAdd as UID may already be there for a multiple response survey
                        sampleIdByUID.TryAdd((string)lsi[Constants.FieldName.UID], (Guid)lsi[Constants.FieldName.SampleId]);
                    }
                }

                DateTime uploadDate = DateTime.Now;
                List<int> invalidRows = new List<int>();
                List<int> duplicateUIDRows = new List<int>();
                List<int> ignoredUIDRows = new List<int>();

                HashSet<string> importedUIDs = new HashSet<string>(Constants.Comparers.UidCaseInsensitive); //20250421 comparer

                bool isRecordBad = false;
                //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.CurrentCulture)
                {
                    BadDataFound = (args) =>
                    {
                        isRecordBad = true;
                        invalidRows.Add(args.Context.Parser.Row);
                    },
                    HasHeaderRecord = true,
                    PrepareHeaderForMatch = (args) => args.Header.Trim(),
                };
                using (CsvReader csv = new CsvReader(new StreamReader(stream), csvConfiguration))
                {
                    csv.Read();
                    csv.ReadHeader();
                    headerRowColumns = csv.HeaderRecord.Select(header => header.Trim()).ToArray();

                    //Fail immediately if the CSV doesn't contain a UID column
                    //TODO - explicitly specify the comparer to use (from Constants.Comparers)
                    if (!headerRowColumns.Any(header => Constants.FieldName.UID.Equals(header)))
                    {
                        throw new InvalidValidationDatasetException("NO UID COLUMN");
                    }

                    //Read the contents of the csv to build a DataTable
                    //ignoring rows for samples not in this deployment		
                    //(nb: if we want to support uploading for samples not yet in the deployment
                    //it should not be a problem to change as it doesnt refer to the list sample here)
                    //Will also ignore rows for UIDs we have already seen in the import
                    while (csv.Read())
                    {
                        int rowNumber = csv.Context.Parser.Row;
                        IDictionary<string, object> record = csv.GetRecord<dynamic>();
                        string uid = (string)record[Constants.FieldName.UID];
                        if (String.IsNullOrWhiteSpace(uid))
                        {
                            invalidRows.Add(rowNumber);
                        }
                        else
                        {
                            bool uidInListForDeployment = sampleIdByUID.ContainsKey(uid);
                            if (!isRecordBad && uidInListForDeployment)
                            {
                                bool uidAlreadyImported = importedUIDs.Contains(uid);
                                if (!uidAlreadyImported)
                                {
                                    Guid sampleId = sampleIdByUID[uid];
                                    //nb: this will serialize all the values as strings, including the numbers and the
                                    //multiple value arrays for multiple valued dropdowns, but this is the format
                                    //these values appear to validation expressions already.
                                    string data = JsonConvert.SerializeObject(record);
                                    dataTable.Rows.Add(
                                        Guid.NewGuid(),
                                        dplyId,
                                        sampleId,
                                        data,
                                        auditBatch.UserId,
                                        uploadDate
                                    );
                                    importedUIDs.Add(uid);
                                }
                                else
                                {
                                    duplicateUIDRows.Add(rowNumber);
                                }
                            }
                            else
                            {
                                ignoredUIDRows.Add(rowNumber);
                            }
                        }
                        isRecordBad = false; //reset for the next row
                    }
                }

                //We're not going to try and be clever with update in this first cut
                //Just erase the old datasets associated with the deployment then re-insert whatever was uploaded
                await spSP_DeleteQnnDplyDataset.ExecuteAsync(dplyId, auditBatch, auditStructDivisionId);

                using (SharedTransaction shared = new SharedTransaction())
                {
                    await shared.OpenConnectionAsync(); //dont begin tx here, just using it to get connection
                    DbHelper.BulkCopyDataTable(dataTable, shared, timeoutSeconds: 1500);
                }

                //TODO - add audit entry for the datasets here?
                
                Dictionary<string, object> importReport = new Dictionary<string, object>();
                importReport.Add("importCount", importedUIDs.Count);
                importReport.Add("invalidCount", invalidRows.Count);
                importReport.Add("ignoredCount", ignoredUIDRows.Count);
                importReport.Add("duplicateCount", duplicateUIDRows.Count);

                return importReport;                
            }
            catch(InvalidValidationDatasetException)
            {
                throw;
            }
            catch (Exception e)
            {
                if(Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(e, nameof(UploadValidationDatasetsFromCSV) + " - caught unexpected exception, dplyId={0}", dplyId);
                }
                throw new InternalException($"Validation dataset import failed for dplyId={dplyId}", e);
            }
        }

        public static async Task ClearValidationDatasets(Guid dplyId, User user)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));
            try
            {
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(user.Id);
                await spSP_DeleteQnnDplyDataset.ExecuteAsync(dplyId, auditBatch, user.StructDivisionId.Value);
            }
            catch (Exception e)
            {
                if(Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(e, nameof(ClearValidationDatasets) + " - caught unexpected exception, dplyId={0}", dplyId);
                }
                throw new InternalException($"Failed to clear validation datasets for dplyId={dplyId}", e);
            }
        }

        /// <summary>
        /// Check on fields to be updated in a QNN_DPLY, intended to be called from a trigger.
        /// This will stop on the first failure encountered. It is expected that the client will have
        /// done user-friendly error checking with nice messages already.
        /// </summary>
        public static async Task<int> ValidateQnnDplyForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            (object pk, object clientId, object ogClientId) = data.GetClientIdAndPrimaryKey();
            Guid id = (Guid)pk;

            //Verify user has rights for this organisation
            Guid structDivisionId = (Guid)data[Constants.FieldName.StructDivisionId];
            HashSet<Guid> allowedOrganisations
                = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!allowedOrganisations.Contains(structDivisionId)) return 2;

            //Required field checks (note that data is based on the component id in the form)
            string name = (string)data["textName"];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 300) return 101;

            string surveyName = (string)data[Constants.FieldName.SurveyName];
            if (string.IsNullOrWhiteSpace(surveyName) || surveyName.Length > 300) return 102;

            Guid? formProperties = (Guid?)data["dictQuestionnaire"];
            if (formProperties == null || formProperties == Guid.Empty) return 103;

            Guid? sampleList = (Guid?)data["dictList"];
            if (sampleList == null || sampleList == Guid.Empty) return 104;

            DateTime? dateStart = (DateTime?)data[Constants.FieldName.DateStart];
            if (dateStart == null) return 105;

            DateTime? dateEnd = (DateTime?)data[Constants.FieldName.DateEnd];
            if (dateEnd == null) return 106;

            //Validate the feature interaction
            bool isExcelEnabled = (bool)data[Constants.FieldName.IsExcelEnabled];
            bool isDelegationEnabled = (bool)data[Constants.FieldName.RequireAccessCode];
            bool isAnonymous = (bool)data[Constants.FieldName.IsAnonymous];
            bool isMultipleResponse = (bool)data[Constants.FieldName.IsMultipleResponse];
            if (isAnonymous)
            {
                if (isExcelEnabled) return 1000; 
                if (isDelegationEnabled) return 1001;
            }
            if (isMultipleResponse)
            {
                if (isExcelEnabled) return 1002;
            }

            return 0;
        }
    }
}
