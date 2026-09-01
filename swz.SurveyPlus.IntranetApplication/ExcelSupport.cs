using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using ClosedXML.Excel;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Utilities;

namespace swz.SurveyPlus.IntranetApplication
{

    // Note: ClosedXML used to use the IXLNamedRange class for Excel Named Ranges
    //       but has changed this to IXLDefinedName in 0.104.2 - see #62

    /// <summary>
    /// Handles survery response create/update from an excel source.
    /// (Which is not handled in SurveyResponseUpdater)
    /// </summary>
    public static class ExcelSupport
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(ExcelSupport));

        private const string UenName = "UEN"; //Name of NamedRange for repondent UEN (aka Sample UID)
        private const string SampleNameName = "SAMPLE_NAME"; //Name of NamedRange for sample Name
        private const string NamedRangeOptionalPrefix = "QUESTION_";

        private const string WorkBook_DateTime_Format = "yyyy-MM-dd HH:mm:ss";
        private const string WorkBook_Date_Format = "yyyy-MM-dd";

        /// <summary>
        /// Check that the specified name meets some rules we have set for the excel filename to ensure it is
        /// reasonable.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static bool IsValidExcelFileName(string name)
        {
            //For info on valid filenames in windows, see: https://stackoverflow.com/a/62888/8243046
            //However we want to be more restrictive than that to avoid any nasty surprises later
            //TODO - consider maybe only allowing ASCII and no unicode stuff (but impairs foreign language support)
            
            //1. not null or empty or all whitespace
            if (string.IsNullOrWhiteSpace(name)) return false;

            //2. not too long
            if (name.Length > 255) return false;

            //3. has .xlsx extension (also takes care of blocking trailing whitespace)
            if (!name.EndsWith(".xlsx", StringComparison.InvariantCultureIgnoreCase)) return false;

            //4. only starts with alphanumeric
            if (!char.IsLetterOrDigit(name[0])) return false;

            //5. doesn't use anything in Path.GetInvalidFileNameChars            
            if (Constants.FilenameValidation.InvalidFileNameCharsRegex.IsMatch(name)) { return false; };

            //6. isn't using any of the names windows won't like
            if (Constants.FilenameValidation.WindowsBadFileNames.Any(badName =>
            {
                string nameBeforeExtension = name.Substring(0, name.IndexOf('.')); //nb: at this point already know got '.'
                return badName.Equals(nameBeforeExtension, StringComparison.InvariantCultureIgnoreCase);
            })) return false;

            return true;
        }

        /// <summary>
        /// Validate the file mentioned by a QNN_QNN_FILE (intended to be called by the ValidateQnnFilesTrigger in CustomActionProvider)
        /// </summary>
        /// <param name="qnnQnnFile"></param>
        /// <param name="dbFormFieldNames"></param>
        /// <returns>(Message, IsSuccessful</returns>
        public static async Task<(string Message, bool IsSuccessful)> ValidateQnnQnnFile(DynamicEntity qnnQnnFile, HashSet<string> dbFormFieldNames)
        {
            //get names of ranges in the excel and validate that its actually an excel file

            HashSet<string> excelRangeNames;
            string fileToken = (string)qnnQnnFile[Constants.FieldName.Token];
            if (String.IsNullOrEmpty(fileToken))
            {
                return ("Missing File.", false);
            }

            (Stream Stream, Dictionary<string, string> Properties) uploadedExcelFile = await CloverRuntime.ContentProvider.GetAsync(fileToken);
            string filename = uploadedExcelFile.Properties.GetValueOrDefault(Constants.FileProperties.Name, Constants.UnknownFileName);
            string contentType = uploadedExcelFile.Properties.GetValueOrDefault(Constants.FileProperties.ContentType, Constants.ContentTypes.UnknownApplicationType);
            if (!IsValidExcelFileName(filename))
            {
                if (!filename.EndsWith(".xlsx", StringComparison.InvariantCultureIgnoreCase))
                    return ($"Uploaded filename '{filename}' lacks xlsx extension.", false);
                else
                    return ($"Uploaded filename '{filename}' is invalid.", false);
            }
            if (!Constants.ContentTypes.XlsxFileType.Equals(contentType))
            {
                return ($"File '{filename}' is not an xlsx file.", false);
            }
             
            try
            {
                using (XLWorkbook workbook = new XLWorkbook(uploadedExcelFile.Stream))
                {
                    //extract set of names of all the NamedRanges, discard any null or empty names
                    //and strip the QUESTION_ prefix from names that have it
                    excelRangeNames = workbook.DefinedNames
                        .Select((range) => range.Name)
                        .Where(name => !String.IsNullOrWhiteSpace(name))
                        .Select(name => name.StartsWith(NamedRangeOptionalPrefix) ? name.Substring(NamedRangeOptionalPrefix.Length) : name) //strip QUESTION_ prefix
                        .ToHashSet<string>(Constants.Comparers.AliasCaseInsensitive);

                    const bool checkForUnreadableCells = true;
                    if(checkForUnreadableCells)
                    {
                        //Check for ranges that ClosedXML cannot read by iterating all ranges and trying to read cell.Value
                        List<string> badRanges = new List<string>();
                        foreach (string rangeName in excelRangeNames)
                        {
                            IXLDefinedName range = workbook.DefinedName(rangeName);
                            List<IXLCell> cells = GetCellsForRange(range);
                            try
                            {
                                foreach (var cell in cells)
                                {
                                    object tmp = cell.Value;
                                }
                            }
                            catch (Exception)
                            {
                                badRanges.Add(rangeName);
                            }
                        }
                        if (badRanges.Count > 0)
                        {
                            string reportRanges = String.Join(", ", badRanges);
                            return ($"There are unreadable cells in NamedRanges of file. {filename} - {reportRanges}", false);
                        }
                    } //end if checkForUnreadableCells
                } //end using workbook
            }
            catch (FileFormatException)
            {
                return ($"File not valid. {filename}", false);
            }
            catch(Exception e)
            {
                //I've seen this error occur with unsupported image formats in the excel, and something
                //in System.Drawing raises an exception. Presumably there may be other undiscovered
                //incompatabilities that will reach here too?
                Logger.LogError(e, nameof(ValidateQnnQnnFile) + " - An unexpected exception was caught validating {0}", filename);
                return ($"Unable to process file. {filename}", false);
            }

            //check that all fields in the online form have a corresponding range in the excel
            //nb: we don't test the other way because the excel can have many NamedRanges that don't relate to a form field
            List<string> diff = dbFormFieldNames.Except(excelRangeNames).OrderBy(name => name.ToUpperInvariant()).ToList<string>();
            if (diff.Any())
            {
                return ($"{Constants.Message.FieldsNotMatched} {filename}: {string.Join(", ", diff)}", false);
            }
            return (null, true); //ok!
        } //end of validateQnnQnnFile

        //returns true on failure
        public static async Task<(string Message, bool IsFailed)> DataProcessingExcelOnline(
            Guid dplyId,
            Guid listSampleId,
            Guid? dataEditorUserId, //pass null for a respondent upload
            Stream fileStream)
        {
            try
            {
                bool isDataEditor = (dataEditorUserId != null);
                bool isRespondent = (!isDataEditor); //For readability

                if (fileStream == null) throw new ArgumentNullException(nameof(fileStream));

                EntityModel qnnDplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

                EntityModel qnnQnnModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN, Constants.Level.NoJoins);

                EntityModel qnnRespModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

                EntityModel qnnDplySampleDueDateModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_DUEDATE, Constants.Level.NoJoins);

                //Get the Deployment Sample Info (dsi) from QNN_DPLY_SAMPLE_INFO
                //This is a join table that links QNN_DPLY to QNN_LIST_SAMPLE and maintains remarks and status too
                Filter byDplyIdAndListSampleId 
                    = Filter.And
                    .Equal(dplyId, Constants.FieldName.DplyId)
                    .Equal(listSampleId, Constants.FieldName.ListSampleId);
                DynamicEntity dplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byDplyIdAndListSampleId)).FirstOrDefault();
                if (dplySampleInfo == null)
                {
                    //If we can't find a dsi linking the deployment and the sample then this survey isnt for them at all
                    //This shouldn't occur in practice unless we get passed invalid ids (so we do need to check!)
                    return ("Sample is not linked with this survey.", true);
                }
                QnnStatusId status = QnnStatusId.FromGuid((Guid)dplySampleInfo[Constants.FieldName.Status]);
                
                //Even Data Editor cannot update a cleared survey (they would need to move it back to Submitted first)
                if (QnnStatusId.Cleared.Equals(status))
                {
                    return ("Survey has been cleared -cannot update survey.", true);
                }
                
                if(isRespondent)
                {
                    //This also mitigates SP-01 in MPA Pentest of 2022-05-10

                    //nb: We don't respect the DaysUpdate for a submitted survey in the Excel upload (just the online form)
                    //because we need the respondent to then verify their uploaded data in the online form, but in
                    //submitted status there is nothing to stop them leaving unvalidated data in the submitted status.
                    //The simple kludge to address this is just to not let them upload at that point. We will consider
                    //a better solution if customer feedback highlights this is an issue for them.

                    //Following the UI to only allow for pending and in progress for a respondent.
                    //(This might later change to allow for anything that isn't submitted or cleared)
                    bool isAllowedStatusForUpload
                        = QnnStatusId.Pending.Equals(status)
                        || QnnStatusId.InProgress.Equals(status);
                    if(!isAllowedStatusForUpload)
                    {
                        return ("Survey status does not permit respondent excel upload -cannot update survey.", true);
                    }
                }

                //Is this survey open for responses?
                DynamicEntity dply = await DeploymentApplication.GetQnnDplyById(dplyId);
                if (dply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);
                Guid qnnId = (Guid)dply[Constants.FieldName.QnnId];
                bool dplyStatus = (bool)dply[Constants.FieldName.Status];
                bool visibleToRespondent = (bool)dply[Constants.FieldName.VisibleToRespondent]; //TODO - should ignore for a dataEditor?
                if (!dplyStatus || !visibleToRespondent)
                {
                    return ("Invalid survey.", true);
                }
                bool excelEnabled = (bool)dply[Constants.FieldName.IsExcelEnabled];
                if (!isDataEditor && !excelEnabled)
                {
                    return (Constants.ExcelUploadErrors.NotEnabled, true);
                }

                //nb: We aren't checking the response count from vSP_DeploymentRespCount because we aren't submitting yet

                //Find the response in QNN_RESP (nb: might not be one yet)
                DynamicEntity qnnResp 
                    = (await ResponseApplication.GetResponsesForSample(
                        dplyId: dplyId, 
                        listSampleId: listSampleId, 
                        qnnRespModel: qnnRespModel))
                    .FirstOrDefault(); //Currently we don't support multi-response surveys here
                bool hasExistingResponse = (qnnResp != null);

                //For respondents (but not data editors) check that due date hasn't expired already
                bool isForSample = !dataEditorUserId.HasValue;
                bool isForDataEditor = !isForSample;
                if (isForSample)
                {
                    //Filters get mutated and can't safely be re-used with another model?
                    Filter byDplyIdAndListSampleId2 = Filter.And.Equal(dplyId, Constants.FieldName.DplyId).Equal(listSampleId, Constants.FieldName.ListSampleId);
                    DynamicEntity dplySampleDueDate 
                        = (await qnnDplySampleDueDateModel.GetAsync(byDplyIdAndListSampleId2)).FirstOrDefault();
                    if(dplySampleDueDate != null)
                    {
                        DateTime dueDate
                            = (dplySampleDueDate[Constants.FieldName.DueDate] == null)
                            ? DateTime.MaxValue
                            : (DateTime)dplySampleDueDate[Constants.FieldName.DueDate];
                        if (dueDate < DateTime.Now)
                        {
                            return ("Survey has been closed.", true);
                        }
                    }

                    //nb: this check may be redundant based on status checks above, however the ones above may well change independently in future.
                    int daysUpdate = Convert.ToInt32(dply[Constants.FieldName.DaysUpdate] ?? -1);
                    //TODO - below gives DateTime.MinValue if no DateComplete, is this correct?
                    DateTime respDateEnd = Convert.ToDateTime(qnnResp == null? null : qnnResp[Constants.FieldName.DateComplete]);
                    if (!ResponseApplication.IsUpdateAllowedAfterResponse(daysUpdate, respDateEnd))
                    {
                        return ("You can no longer update the survey.", true);
                    }
                }

                DynamicEntity qnnQnn 
                    = (await qnnQnnModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.Id))).FirstOrDefault();
                if (!(bool)qnnQnn[Constants.FieldName.Status])
                {
                    return ("Invalid survey.", true);
                }

                //Excel upload isn't supported for offline surveys
                if (!Constants.QnnType.Online.Equals((string)qnnQnn[Constants.FieldName.Type]))
                {
                    return ("Not an Online survey.", true);
                }

                //Get the list of fields in the db (we will use this to import against)
                List<DynamicEntity> dbQnnFieldList 
                    = await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(qnnId);                
                //Short-circuit exit if there are no questions in this survey. This is an error condition.
                if (!dbQnnFieldList.Any())
                {
                    return ("No questions in survey.", true);
                }

                //Names of all the Questions from QNN_FIELD (alphabetical order)
                List<string> dbQnnFieldNameList = dbQnnFieldList
                    .OrderBy(f => f[Constants.FieldName.Name].ToString())
                    .Select(f => f[Constants.FieldName.Name].ToString())
                    .ToList();

                Dictionary<string, FormItem> fieldItemLookup = null;
                try
                {
                    ////Get the actual design of one of the forms for this qnn, we can use this to determine
                    ////if fields are multivalued or singlevalued (and thus apply the proper formatting to the answer)
                    ////nb: in theory the field should be the same in all the forms
                    fieldItemLookup = await GetFirstFormFields(qnnId);
                }
                catch (ArgumentException gffEx)//Expecting GetFirstFormFields only throw ArgumentException
                {
                    return (gffEx.Message, true);
                }

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    string excelToken = null; //Later will populate with ExcelToken from QNN_RESP (if any)

                    //For sims we need to store a copy of the file after we process it so we
                    //will pull the whole thing into memory to facilitate this
                    fileStream.CopyTo(memoryStream);
                    memoryStream.Seek(0, SeekOrigin.Begin);

                    //Now extract the values from Named Ranges that have corresponding form fields
                    Dictionary<string, string> answers;
                    string uenInExcel = null;
                    try
                    {
                        using (var workbook = new XLWorkbook(memoryStream))
                        {
                            //nb: we *don't* call workbook.RecalculateAllFormulas because some may well be
                            //    unsupported by ClosedXML and fail. Instead we rely on CachedValue when we
                            //    can't read cell Value (see GetCellValue )
                            //(But it seems that in some cases this also fails. So we now have a check on uploading the
                            //excel template to verify that in the template all the NamedRange can be read)
                            answers = ExtractFieldValuesFromWorkbook(workbook, fieldItemLookup);
                            uenInExcel = ExtractUENFromWorkbook(workbook);
                        }
                    }
                    catch (FileFormatException)
                    {
                        //ClosedXML cannot parse the file, so its not a valid openxml file
                        return (Constants.ExcelUploadErrors.IncorrectFileType, true);
                    }
                    memoryStream.Seek(0, SeekOrigin.Begin); //later we need to read it again to copy to dwUploadedFiles

                    //Get the uid for comparison and for use in filename
                    (Guid sampleId, string sampleUid) 
                        = await SampleListApplication.GetSampleIdentityFromListSampleId(listSampleId);
                    
                    //If the Excel contains a UEN value then we validate that it matches the sample's UID
                    if (uenInExcel != null)
                    {
                        if(!uenInExcel.Equals(sampleUid, StringComparison.InvariantCultureIgnoreCase))
                        {
                            return (Constants.ExcelUploadErrors.IncorrectUEN, true);
                        }
                    }

                    //Names of all the NamedRanges in the Excel (alphabetical order)
                    List<string> formFieldNameList = answers.Keys.OrderBy(f => f).ToList();

                    Guid respId = hasExistingResponse ? (Guid)qnnResp?[Constants.FieldName.Id] : Guid.NewGuid();
                    excelToken = (string)qnnResp?[Constants.FieldName.ExcelToken];

                    //1. Keep the start date if there is already a response, otherwise start now.
                    //2. Prepopulate will generate a new response without DateStart, if DateStart is null, use start now.
                    DateTime dateStart = (qnnResp == null || qnnResp[Constants.FieldName.DateStart] == null) ? DateTime.Now : (DateTime)qnnResp[Constants.FieldName.DateStart];

                    //The structDivisionId for audit comes from that of the user if specified, 
                    //otherwise from that of the deployment
                    Guid? sampleIdForAuditPurpose;
                    Guid? structDivisionIdForAuditPurpose;
                    if (dataEditorUserId != null)
                    {
                        sampleIdForAuditPurpose = null;
                        Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(dataEditorUserId.Value);
                        structDivisionIdForAuditPurpose = user.StructDivisionId;
                    }
                    else
                    {
                        sampleIdForAuditPurpose = (Guid?)sampleId;
                        structDivisionIdForAuditPurpose = (Guid?)dply?[Constants.FieldName.StructDivisionId]; //See #157
                    }

                    AuditBatch auditBatch = await AuditSettings.NewBatchAsync(dataEditorUserId??Guid.Empty, sampleIdForAuditPurpose??Guid.Empty);
                    auditBatch.AssertHasUserOrSample();

                    //DataTable will be used to pass all the answer info to a stored procedure which will
                    //write to QNN_RESP_ANS
                    DataTable newQnnRespAnsRows = ResponseApplication.DataTableForQnnRespAns();

                    //Iterate the db fields in order and add answers for those questions extracted from the excel to the datatable
                    List<DynamicEntity> orderedDbQnnFieldList 
                        = dbQnnFieldList.OrderBy(f => f[Constants.FieldName.NumberId])
                        .ToList();
                    foreach (DynamicEntity field in orderedDbQnnFieldList)
                    {
                        string fieldType = field.GetProperty(Constants.FieldName.Type).ToString();
                        if (fieldType == Constants.PdfFieldType.PushButton) continue; //Dont expect to see this for online though
                        string fieldName = (string)field[Constants.FieldName.Name];
                        if (!answers.ContainsKey(fieldName))
                        {
                            Logger.LogError(nameof(DataProcessingExcelOnline) + "- {0} not found in the excel file",fieldName);
                            return (Constants.ExcelUploadErrors.MissingRanges, true); //callers may check for this exact message
                        }

                        //Answer was formatted for our AnsVal column in db when we extracted it
                        string answer = answers.GetValueOrDefault(fieldName, "");

                        //Add this answer to our datatable for writing to db later
                        newQnnRespAnsRows.Rows.Add(respId, field[Constants.FieldName.Id], answer, false);                      
                    }

                    string strataSource = (string)dply[Constants.FieldName.StrataSource];
                    string strata = !string.IsNullOrEmpty(strataSource)
                        ? answers.GetValueOrDefault(strataSource, null)
                        : null;

                    string responseBy = isDataEditor ? Constants.ResponseBy.Editor : Constants.ResponseBy.Sample;

                    spSP_DeleteAllRespAnsByRespId spSP_DeleteAllRespAnsByRespId
                        = (hasExistingResponse)
                        ? await spSP_DeleteAllRespAnsByRespId.GetInstanceUsingAppSettingsAsync()
                        : null; //don't waste query looking up settings if not going to use it
                    spSP_InsertResp spSP_InsertResp
                        = (hasExistingResponse)
                        ? null //don't waste query looking up settings if not going to use it
                        : await spSP_InsertResp.GetInstanceUsingAppSettingsAsync();
                    spSP_UpdateResp spSP_UpdateResp
                        = (hasExistingResponse)
                        ? await spSP_UpdateResp.GetInstanceUsingAppSettingsAsync()
                        : null; //don't waste query looking up settings if not going to use it

                    //We are now ready to start writing to the db...
                    using (SharedTransaction transaction = new SharedTransaction())
                    {
                        try
                        {
                            transaction.BeginTransactionAsync().Wait();

                            //If they have already started a response to this survey then delete all the
                            //existing answers for it in the database first
                            if (hasExistingResponse)
                            {
                                await spSP_DeleteAllRespAnsByRespId.DeleteResp(
                                    qnnRespId: respId,
                                    structDivisionId: structDivisionIdForAuditPurpose,
                                    auditBatch: auditBatch);
                            }

                            DateTime now = DateTime.Now;
                            string lastResponseBy = isRespondent ? Constants.ResponseBy.Sample : Constants.ResponseBy.Editor;

                            //Now create or update the response row in QNN_RESP
                            if (!hasExistingResponse)
                            {
                                //No response row yet, so insert one
                                Guid? responseUserId = (isDataEditor) ? dataEditorUserId : null;
                                await spSP_InsertResp.InsertResponse(
                                    auditBatch: auditBatch,
                                    auditStructDivisionId: structDivisionIdForAuditPurpose,
                                    newRespId: respId,
                                    updatedDate: now,
                                    qnnId: qnnId,
                                    listSampleId: listSampleId,
                                    dplyId: dplyId,
                                    dateStart: dateStart,
                                    dateComplete: null,
                                    lastSavedPage: null,
                                    anonymousId: null, //TODO
                                    ipAddress: null,  //TODO
                                    initialResponseAs: Constants.ResponseAs.Excel,
                                    initialResponseBy: responseBy,
                                    initialResponseVia: Constants.ResponseVia.Online,
                                    initialResponseUserId: responseUserId,
                                    lastResponseAs: Constants.ResponseAs.Excel,
                                    lastResponseBy: lastResponseBy,
                                    lastResponseVia: Constants.ResponseVia.Online,
                                    userId: responseUserId,
                                    completedResponseAs: null,
                                    completedResponseBy: null,
                                    completedResponseVia: null,
                                    completedResponseUserId: null,
                                    strata: strata);
                            }
                            else //respEntity is not null
                            {
                                //Just because there is an existing response doesn't mean it has started. For example
                                //pre-population will create rows in QNN_RESP in advance. We check DateStart rather than
                                //IsPrePopulated so as to capture other such possibilities too.
                                bool isResponseStartedAlready
                                    = ((DateTime?)qnnResp[Constants.FieldName.DateStart] != null);

                                string initialResponseAs, initialResponseBy, initialResponseVia;
                                Guid? initialResponseUserId;
                                if (isResponseStartedAlready)
                                {
                                    initialResponseAs = (string)qnnResp[Constants.FieldName.InitialResponseAs];
                                    initialResponseBy = (string)qnnResp[Constants.FieldName.InitialResponseBy];
                                    initialResponseVia = (string)qnnResp[Constants.FieldName.InitialResponseVia];
                                    initialResponseUserId = (Guid?)qnnResp[Constants.FieldName.InitialResponseUserId];
                                }
                                else
                                {
                                    initialResponseAs = Constants.ResponseAs.Excel;
                                    initialResponseBy = lastResponseBy;
                                    initialResponseVia = Constants.ResponseVia.Online;
                                    initialResponseUserId = isDataEditor ? dataEditorUserId : null;
                                }

                                await spSP_UpdateResp.UpdateResponse(
                                    auditBatch: auditBatch,
                                    auditStructDivisionId: structDivisionIdForAuditPurpose,
                                    existingRespId: respId,
                                    updatedDate: now,
                                    dateStart: (DateTime?)qnnResp[Constants.FieldName.DateStart],
                                    dateComplete: (DateTime?)qnnResp[Constants.FieldName.DateComplete],
                                    lastSavedPage: null, //send back to first page as need to validate again!
                                    ipAddress: null,
                                    initialResponseAs: initialResponseAs,
                                    initialResponseBy: initialResponseBy,
                                    initialResponseVia: initialResponseVia,
                                    initialResponseUserId: initialResponseUserId,
                                    lastResponseAs: Constants.ResponseAs.Excel,
                                    lastResponseBy: lastResponseBy,
                                    lastResponseVia: Constants.ResponseVia.Online,
                                    userId: isDataEditor ? dataEditorUserId : (Guid?)qnnResp[Constants.FieldName.UserId],
                                    completedResponseAs: (string)qnnResp[Constants.FieldName.CompletedResponseAs],
                                    completedResponseBy: (string)qnnResp[Constants.FieldName.CompletedResponseBy],
                                    completedResponseVia: (string)qnnResp[Constants.FieldName.CompletedResponseVia],
                                    completedResponseUserId: (Guid?)qnnResp[Constants.FieldName.CompletedResponseUserId],
                                    strata: strata);
                            }

                            //Now write all the answers to QNN_RESP_ANS
                            DbHelper.BulkCopyDataTable(newQnnRespAnsRows, transaction, timeoutSeconds: 120);

                            //audit
                            if (auditBatch.AuditOn)
                            {
                                string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(newQnnRespAnsRows);
                                await SurveyPlusAuditHelper.BatchImport(
                                    Constants.ModelName.QNN_RESP_ANS,
                                    auditBatch,
                                    structDivisionIdForAuditPurpose,
                                    newValue);
                            }

                            //Ensure status in deployment sample info is up to date and record an audit entry if we change it
                            if (dplySampleInfo != null)
                            {
                                QnnStatusId newStatus = QnnStatusId.InProgress;
                                //TODO - do we still have status at this line? can use that?
                                QnnStatusId oldStatus = QnnStatusId.FromGuid((Guid)dplySampleInfo[Constants.FieldName.Status]);
                                bool needUpdate = !newStatus.Equals(oldStatus);
                                if (needUpdate)
                                {
                                    spSP_UpdateDplySampleInfo spSP_UpdateDplySampleInfo
                                        = await spSP_UpdateDplySampleInfo.GetInstanceUsingAppSettingsAsync();

                                    Guid dlsi = (Guid)dplySampleInfo[Constants.FieldName.Id];
                                    await spSP_UpdateDplySampleInfo.UpdateDsiStatus(
                                        id: dlsi,
                                        structDivisionId: structDivisionIdForAuditPurpose,
                                        oldStatus: oldStatus,
                                        newStatus: newStatus,
                                        auditBatch: auditBatch);
                                }
                            }

                            //Remove the older excel upload file from database
                            if(excelToken != null)
                            {
                                if (await CloverRuntime.ContentProvider.ExistAsync(excelToken))
                                {
                                    await CloverRuntime.ContentProvider.RemoveAsync(excelToken);
                                }
                                excelToken = null;
                            }

                            DateTime excelUploadDate = DateTime.Now;

                            //For SIMS we record that the response was updated via excel and keep a copy of the uploaded file
                            var properties = new Dictionary<string, string>();                            
                            string filename = "response_" + sampleUid + "_" + excelUploadDate.ToString("yyyyMMdd_HHmm") + ".xlsx";
                            properties.Add(Constants.FileProperties.Name, filename);
                            properties.Add(Constants.FileProperties.ContentType, Constants.ContentTypes.XlsxFileType);
                            properties.Add(Constants.FileProperties.IsDownloadable, "false"); //Have added logic to DataController not to serve files if this is present and not True
                            excelToken = await CloverRuntime.ContentProvider.AddAsync(memoryStream, properties);
                            qnnResp = (await ResponseApplication.GetResponsesForSample(dplyId, listSampleId)).FirstOrDefault(); //Get updated row
                            qnnResp[Constants.FieldName.IsExcelResponse] = true; //Was excel uploaded (by respondent or a data editor)
                            qnnResp[Constants.FieldName.IsExcelResponseDE] = (dataEditorUserId != null); //Was excel uploaded by a data editor?
                            qnnResp[Constants.FieldName.ExcelToken] = excelToken;
                            qnnResp[Constants.FieldName.ExcelUploadDate] = excelUploadDate;
                            await qnnRespModel.UpdateSingleAsync(qnnResp);

                            transaction.Commit();
                        }
                        catch (Exception e)
                        {
                            await transaction.RollbackAsync().ConfigureAwait(false);
                            Logger.LogError(e, nameof(DataProcessingExcelOnline) + " - caught unexpected exception");
                            return (Constants.Message.InternalErrorException, true);
                        }
                    }//end using shared
                }//end using memoryStream

                return ("OK", false);
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(DataProcessingExcelOnline) + " - caught unexpected exception");
                return (Constants.Message.InternalErrorException, true);
            }
        } //end of DataProcessingExcelOnline

        private static string ExtractUENFromWorkbook(XLWorkbook workbook)
        {
            string uen = null;
            IXLDefinedName uenNamedRange = workbook.DefinedName(UenName);
            if (uenNamedRange != null)
            {
                List<IXLCell> cells = GetCellsForRange(uenNamedRange);
                uen = cells.Count > 0 ? GetCellString(cells[0]) : null;
            }
            return uen;
        } //end of ExtractUENFromWorkbook

        //TODO - can return Stream rather than specifically MemoryStream (or caller relies on using ms?)
        /// <summary>
        /// Create an excel file stream based on the specified excel file in QNN_QNN_FILE (identified by QnnId and token)
        /// and optionally populate based on the existing response data (if any) from the specified response. (In SIMS we don't populate)
        /// nb: Checking of respondent or data editor's access to this response and survey is responsibility of the caller.
        /// </summary>
        /// <param name="qnnDplySampleId">Guid of row in QNN_DPLY_SAMPLE_INFO (required)</param>
        /// <param name="token">File token in QNN_QNN_FILE and dwUploadedFiles (required)</param>
        /// <param name="qnnRespId">Guid of response in QNN_RESP (pass Guid.Empty if no response)</param>
        /// <returns></returns>
        public static async Task<(MemoryStream, string, string, string)> DownloadSurveyExcelOnline(
            Guid qnnDplySampleInfoId,
            string token,
            Guid qnnRespId,
            bool populateFromResponseData = false)
        {
            try
            {
                //Deployment sample info links the respondent (sample) to the survey
                //Fetch at level 1 so we also get the QNN_DPLY referenced by DplyId and also the QNN_LIST_SAMPLE in ListSampleId
                EntityModel qnnDplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);

                //QNN_QNN_FILE entities describe the Excel files for a survey (eg, language and file token)
                EntityModel qnnQnnFileModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FILE, Constants.Level.NoJoins);

                EntityModel qnnRespAnsModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP_ANS, Constants.Level.NoJoins);

                EntityModel qnnQnnFieldModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);

                DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.Id))).FirstOrDefault();
                if (qnnDplySampleInfo == null)
                {
                    return (null, null, null, "invalid qnnDplySampleInfoId");
                }

                //bool excelEnabled = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsExcelEnabled];
                bool excelEnabled = true;
                if (!excelEnabled)
                {
                    return (null, null, null, "NOT ENABLED");
                }

                Guid qnnId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.QnnId];
                Guid dplyId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId];
                Guid listSampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId];

                //If a response was specified, verify it is really for the identified deployment and sample
                if (!Guid.Empty.Equals(qnnRespId))
                {
                    var qnnRespModel 
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.FetchJoins);
                    DynamicEntity qnnResp = (await qnnRespModel.GetAsync(Filter.And.Equal(qnnRespId, Constants.FieldName.Id))).FirstOrDefault();
                    if (qnnResp == null
                        || !dplyId.Equals(qnnResp[Constants.FieldName.DplyId])
                        || !listSampleId.Equals(qnnResp[Constants.FieldName.ListSampleId])
                        || !qnnId.Equals(qnnResp[Constants.FieldName.QnnId]))
                    {
                        return (null, null, null, "INVALID qnnRespId");
                    }
                }

                //Get the QNN_QNN_FILE for this deployment
                var byQnnIdAndToken = Filter.And.Equal(qnnId, Constants.FieldName.QnnId).Equal(token, Constants.FieldName.Token);
                DynamicEntity qnnQnnFile = (await qnnQnnFileModel.GetAsync(byQnnIdAndToken)).FirstOrDefault();
                if (qnnQnnFile == null)
                {
                    throw new NotFoundException("specified qnn file not found");
                }
                string filename = (string)qnnQnnFile[Constants.FieldName.Name];
                filename = string.IsNullOrWhiteSpace(filename) ? "survey.xlsx" : filename.Trim();
                //Automatically add the xlsx extension if no extension was provided
                filename = (filename.IndexOf('.') == -1) ? (filename + ".xlsx") : filename;
                (Stream Stream, Dictionary<string, string> Properties) dwUploadedFile 
                    = await CloverRuntime.ContentProvider.GetAsync(token);
                Dictionary<string, string> properties = dwUploadedFile.Properties;
                if (properties == null)
                {
                    throw new InternalException("no file properties found");
                }
                //TODO - This extract properties logic have been appear on TOO MANY PLACES, consider consolidate it by making a static class/method to avoid multi standard
                if (String.IsNullOrEmpty(filename))
                {
                    //Use the original uploaded name (as is) from dwUploadedFiles if no Name was cleared in the QNN_QNN_FILE
                    filename = properties.GetValueOrDefault(Constants.FileProperties.Name, Constants.UnknownFileName);
                }
                string contentType 
                    = properties.GetValueOrDefault(
                        key: Constants.FileProperties.ContentType, 
                        defaultValue: Constants.ContentTypes.UnknownApplicationType);
                if (Constants.UnknownFileName.Equals(filename) || !Constants.ContentTypes.XlsxFileType.Equals(contentType))
                {
                    throw new InternalException("file missing required properties or of wrong type");
                }

                Dictionary<Guid, DynamicEntity> respAnsByFieldId = new Dictionary<Guid, DynamicEntity>();
                //Build lookup table of the existing answers from the db for this response, keyed by fieldId
                //nb: here we assume 1-1 QNN_RESP_ANS --> QNN_QNN_FIELD (if there are more than only one of them will be used)
                //Multivalues for dropdown in online surveys will use a JSON encoded list (unlike offline pdfs which use a CSV encoded list)
                if (populateFromResponseData && !Guid.Empty.Equals(qnnRespId))
                {
                    List<DynamicEntity> answers = await qnnRespAnsModel.GetAsync(Filter.And.Equal(qnnRespId, Constants.FieldName.RespId));
                    foreach (DynamicEntity qnnRespAns in answers)
                    {
                        Guid fieldId = (Guid)qnnRespAns[Constants.FieldName.QnnFieldId];
                        respAnsByFieldId.Add(fieldId, qnnRespAns);
                    }
                }

                List<DynamicEntity> fields = populateFromResponseData 
                    ? await qnnQnnFieldModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId)) 
                    : null;

                using (Stream fileStream = dwUploadedFile.Stream)
                {
                    using (var workbook = new XLWorkbook(fileStream))
                    {

                        //Fill in the field values from the existing reponse (if any)
                        if(fields != null)
                        {
                            foreach (DynamicEntity field in fields)
                            {
                                string name = (string)field[Constants.FieldName.Name];
                                if (String.IsNullOrEmpty(name))
                                {   //This should not happen
                                    throw new InternalException("No Name for field " + field.GetId());
                                }
                                try
                                {
                                    respAnsByFieldId.TryGetValue((Guid)field.GetId(), out DynamicEntity qnnRespAns);
                                    //string type = (string)field[Constants.FieldName.Type];
                                    string rawAnswer = (qnnRespAns == null) 
                                        ? "" 
                                        : (string)qnnRespAns[Constants.FieldName.AnsVal];
                                    IXLDefinedName namedRange = workbook.DefinedName(name);
                                    SetValuesToRange(namedRange, rawAnswer);
                                }
                                catch (Exception e)
                                {
                                    throw new InternalException("Unable to set ranges for field \"" + name + "\"", e);
                                }
                            }
                        }

                        //Write UEN and/or Enterprise Name to the excel if ranges have been provided for this
                        IXLDefinedName uenNamedRange = workbook.DefinedName(UenName);
                        IXLDefinedName sampleNameNamedRange = workbook.DefinedName(SampleNameName);
                        if(uenNamedRange != null || sampleNameNamedRange != null)
                        {
                            Guid sampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.SampleId];
                            DynamicEntity qnnSample = await RetrieveQnnSample(sampleId);
                            if (uenNamedRange != null)
                            {
                                SetValuesToRange(uenNamedRange, (string)qnnSample[Constants.FieldName.UID]);
                            }
                            if (sampleNameNamedRange != null)
                            {
                                SetValuesToRange(sampleNameNamedRange, (string)qnnSample[Constants.FieldName.Name]);
                            }
                        }
                        
                        MemoryStream ms = new MemoryStream(); //Caller responsible to close
                        workbook.SaveAs(ms);
                        ms.Position = 0;
                        return (ms, contentType, filename, null);
                    }//end using workbook
                }//end using fileStream
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(DownloadSurveyExcelOnline) + " - caught an unexpected exception, qnnDplySampleInfoId={0}, token={1}, qnnRespId={2}, populateFromResponseData]{3}", qnnDplySampleInfoId, token, qnnRespId, populateFromResponseData);
                return (null, null, null, e.Message);
            }
        } //end of DownloadSurveyExcelOnline

        private static async Task<DynamicEntity> RetrieveQnnSample(Guid sampleId) 
        {
            EntityModel qnnSampleModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
            Filter byId = Filter.And.Equal(sampleId, Constants.FieldName.Id);
            DynamicEntity qnnSample = (await qnnSampleModel.GetAsync(byId)).FirstOrDefault();
            return qnnSample;
        } //end of RetrieveQnnSample

        private static Dictionary<string, string> ExtractFieldValuesFromWorkbook(XLWorkbook workbook, Dictionary<string, FormItem> fieldItems)
        {
            Dictionary<string, string> answers = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);
            IXLDefinedNames namedRanges = workbook.DefinedNames;

            //We will look through all the named ranges in the spreadsheet. Some of these may be for internal spreadsheet use and of no interest
            //to us. These we will ignore. We are interested only in the ones that correspond to fields in the form (which makes them values for
            //aliases in the response)
            foreach (IXLDefinedName namedRange in namedRanges)
            {
                string alias = namedRange.Name;
                if (String.IsNullOrWhiteSpace(alias)) continue;

                //Excel won't allow certain names for NamedRange (such as those that look like a cell address. eg: A4, B3 etc)
                //We allow for these cases by supporting the well-known prefix QUESTION_ in the NamedRange. If the range name starts
                //with this we will strip the prefix to determine the Alias name
                if(alias.StartsWith(NamedRangeOptionalPrefix))
                {
                    alias = alias.Substring(NamedRangeOptionalPrefix.Length);
                }

                //If we find a field with same name as this NamedRange then the contents of the NamedRange represent a response value
                //for the alias with this name. 
                FormItem fieldItem = fieldItems.GetValueOrDefault(alias);
                if (fieldItem != null)
                {
                    List<IXLCell> cells = GetCellsForRange(namedRange);
                    if (Constants.Comparers.ObjectNameCaseInsensitive.Equals("input", fieldItem.Type)
                        && fieldItem.Properties.ContainsKey("type"))
                    {
                        string inputType = (string)fieldItem.Properties["type"];
                        if (    Constants.Comparers.ObjectNameCaseInsensitive.Equals("date", inputType)
                            ||  Constants.Comparers.ObjectNameCaseInsensitive.Equals("datetime", inputType)
                            ||  Constants.Comparers.ObjectNameCaseInsensitive.Equals("time", inputType) )
                        {
                            try
                            {
                                DateTime? dt = null;
                                object value = (cells.Count > 0) ? GetCellValue(cells[0]) : null;
                                if (value is DateTime)
                                {
                                    dt = (DateTime)value;
                                }
                                else if (value is double)
                                {
                                    //Excel doesn't really have dates, it stores them as a number
                                    dt = DateTime.FromOADate((double)value);
                                }
                                else if (value is string)
                                {
                                    dt = Convert.ToDateTime((string)value);
                                }
                                //TODO - review the below with respect to "time" and make a comment about why it includes date
                                //       and also with respect to the formats that can be specified in the control and how these
                                //       are stored 
                                bool valueHasTimeElement = (
                                    Constants.Comparers.ObjectNameCaseInsensitive.Equals("datetime", inputType)
                                 || Constants.Comparers.ObjectNameCaseInsensitive.Equals("time", inputType));
                                string format = valueHasTimeElement
                                    ? WorkBook_DateTime_Format
                                    : WorkBook_Date_Format;
                                answers.Add(alias, (dt == null) ? "" : ((DateTime)dt).ToString(format));
                            }
                            catch (Exception)
                            {
                                answers.Add(alias, "");
                            }
                        }
                        else if (
                            Constants.Comparers.ObjectNameCaseInsensitive.Equals("file", inputType)
                            || Constants.Comparers.ObjectNameCaseInsensitive.Equals("image", inputType))
                        {
                            //Not currently supported for excel - ignore
                            answers.Add(alias, "");
                        }
                        else //other types of input (ie: text, number)
                        {
                            string answer = (cells.Count > 0) ? GetCellString(cells[0]) : "";
                            answers.Add(alias, answer);
                        }
                    } //end if input
                    else if (Constants.Comparers.ObjectNameCaseInsensitive.Equals("dropdown", fieldItem.Type))
                    {
                        bool multiple = (fieldItem.Properties.ContainsKey("multiple") && (bool)fieldItem.Properties["multiple"]);

                        HashSet<string> allowedOptions = fieldItem.Properties.ContainsKey("data-elements")
                            ? ((IEnumerable<dynamic>)fieldItem.Properties["data-elements"])
                                .Select(dataElement => (string)dataElement.value)
                                .ToHashSet(StringComparer.InvariantCultureIgnoreCase)
                            : new HashSet<string>(Constants.Comparers.ObjectNameCaseSensitive); //nb: options are case-sensitive

                        if (multiple)
                        {
                            //For online forms, multivalued fields use JSON formatting
                            //(This is in contrast to offline forms which use an escaped CSV style format in RESP_ANS)
                            List<string> values = cells
                                .Select(c => GetCellString(c))
                                .Where(v => allowedOptions.Contains(v))
                                .ToList();
                            string answer = JsonConvert.SerializeObject(values);
                            answers.Add(alias, answer);
                        }
                        else
                        {
                            //For a single value dropdown we ignore any superflous cells
                            string answer = (cells.Count > 0) ? GetCellString(cells[0]) : "";
                            answers.Add(alias, answer);
                        }

                    } //end if dropdown
                    else if (Constants.Comparers.ObjectNameCaseInsensitive.Equals("checkbox", fieldItem.Type))
                    {
                        string answer = (cells.Count > 0) ? GetCellString(cells[0]).Trim() : "";
                        if (answer.Equals("0") || answer.Equals("1"))
                        {
                            ;
                        }
                        else if (answer.Equals(Boolean.TrueString, StringComparison.InvariantCultureIgnoreCase))
                        {
                            answer = "1";
                        }
                        else if (answer.Equals(Boolean.FalseString, StringComparison.InvariantCultureIgnoreCase))
                        {
                            answer = "0";
                        }
                        else
                        {
                            //Use false for anything else (including empty string)
                            answer = "0";
                        }
                        answers.Add(alias, answer);
                    } //end if checkbox
                    else //other types of field
                    {
                        string answer = (cells.Count > 0) ? GetCellString(cells[0]) : "";
                        answers.Add(alias, answer);
                    }
                }
            }
            return answers;
        } //end of ExtractFieldValuesFromWorkbook

        public static async Task<Dictionary<string, FormItem>> GetFirstFormFields(Guid qnnId)
        {
            EntityModel qnnQnnFormModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM);
            DynamicEntity firstForm = (await qnnQnnFormModel.GetAsync(
                    Filter.And.Equal(qnnId, Constants.FieldName.QnnId),
                    Order.StartAsc(Constants.FieldName.NumberId),
                    Paging.Empty)
                ).FirstOrDefault();
            string firstFormName = (string)firstForm[Constants.FieldName.Name];
            if (string.IsNullOrEmpty(firstFormName))
            {
                throw new ArgumentException("First form name not specified for QNN");
            }
            string formSource = CloverRuntime.Metadata.GetFormSource(firstFormName);
            List<FormItem> allFormItems = FormSerializer.Deserialize(formSource);
            List<FormItem> fieldItems = FormPropertiesApplication.GetAllFormItems(allFormItems, new List<FormItem>());
            if (fieldItems == null || !fieldItems.Any(i => Constants.OnlineFormControls.Contains(i.Type)))
            {
                throw new ArgumentException($"{firstFormName} form is invalid");
            }
            Dictionary<string, FormItem> fieldItemLookup 
                = fieldItems.ToDictionary(i => i.Key, i => i, Constants.Comparers.AliasCaseInsensitive);
            return fieldItemLookup;
        } //End of GetFirstFormFields

        /// <summary>
        /// Returns a new list of all the cells in all the ranges of this named range (a named range can have multiple ranges)
        /// </summary>
        /// <param name="namedRange"></param>
        /// <returns>list of cells (empty list if namedRange is null)</returns>
        private static List<IXLCell> GetCellsForRange(IXLDefinedName namedRange)
        {
            List<IXLCell> cells = new List<IXLCell>();
            if (namedRange != null)
            {
                IXLRanges ranges = namedRange.Ranges;
                foreach (IXLRange range in ranges)
                {
                    IXLCells c = range.Cells();
                    cells.AddRange(c);
                }
            }
            return cells;
        } //end of GetCellsForRange

        private static void SetValuesToRange(IXLDefinedName namedRange, string rawAnswer)
        {
            if (namedRange == null) throw new ArgumentNullException(nameof(namedRange));                
            try
            {
                rawAnswer = (rawAnswer == null) ? "" : rawAnswer.Trim();
                List<IXLCell> cells = GetCellsForRange(namedRange);

                if (cells.Count == 0)
                {
                    return; //nothing to do here (qnn validations ought to have caught this but its not our problem here...)
                }
                else if (cells.Count == 1)
                {
                    //We assume single cell implies a single value question. 
                    //This is the common case and single values answers are simply recorded in RESP_ANS as-is without escaping etc
                    //warning: giving a mult-dropdown a single cell in the excel will thus result in json in the spreadsheet...

                    //Set value using property. ClosedXML will try to be clever wrt to type conversions
                    cells.First().Value = rawAnswer;
                }
                else if (cells.Count > 1)
                {
                    //We assume multiple cells for a name implies multi-value
                    //Multiple values (eg: multi-dropdown) are recorded in json format for online surveys
                    //(values from offline pdfs used csv format instead but for now excel is only for online surveys
                    //and the offline pdf feature was removed already )

                    List<string> values = String.IsNullOrEmpty(rawAnswer)
                        ? new List<string>(0)
                        : JsonConvert.DeserializeObject<List<string>>(rawAnswer);
                    //Overwrite all cells in the range with either a value from the db or a blank
                    //CLosedXML could also help with copying values from ranges and to tables, but we want to be explicit about
                    //how we do it and also make sure unused cells are cleared so we will use our own loop.
                    int valueCount = (values == null) ? 0 : values.Count;
                    for (int i = 0; i < cells.Count; i++)
                    {
                        //Set value using property. ClosedXML will try to be clever wrt to type conversions
                        cells[i].Value = (valueCount > i) ? values[i] : "";
                    }
                }
            }
            catch (Exception ex)
            {
                throw new InternalException("Failed to set values to range", ex);
            }
        } //end of SetValuesToRanges

        /// <summary>
        /// Try to get the value from the cell but fallback to the cached value if there
        /// is an error (as might happen when there are formulas, such as those that ClosedXML
        /// does not support). Warning: the cached value may need recalculation (but in such
        /// cases we cant)
        /// </summary>
        /// <param name="cell">the cell (may not be null)</param>
        /// <returns>Value or CachedValue if value is not readable</returns>
        private static Object GetCellValue(IXLCell cell)
        {
            try
            {
                return cell.Value; //Cells based on formula might fail (eg cast exceptions)
            }
            catch (Exception)
            {
                //In theory this may be an out of date value (see the NeedsRecalculation property)
                //but since we are just importing and haven't updated cells ourself it should
                //still be valid based on what the Respondent's Excel application calculated
                return cell.CachedValue;
            }
        } //end of GetCellValue

        /// <summary>
        /// Calls GetCellValue to get the Value or CachedValue if the value is not readable and the
        /// returns its ToString (or null if value is null)
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private static string GetCellString(IXLCell cell)
        {
            object value = GetCellValue(cell);
            return (value == null) ? "" : value.ToString();
        }

    } //end of class ExcelSupport
}
