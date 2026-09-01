using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Metadata;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.Application;
using System.Text.RegularExpressions;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication.Utilities;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class FormPropertiesApplication
    {
        private static readonly ILogger Logger 
            = DefaultApplicationLogging.CreateLogger(typeof(FormPropertiesApplication));

        /// <summary>
        /// Duplicates an existing form properties
        /// n.b. caller is responsible for checking access rights.
        /// On error, the message returned is sent to clientside for display to end user.
        /// On success returns the new QNN_QNN id (as a string)
        /// </summary>
        public static async Task<(string Message, bool IsSuccessful)> DuplicateQnn(
            Guid sourceId, 
            string title, 
            swz.Clover.Core.Security.User creator)
        {
            try
            {
                //TODO - revalidate title
                if (string.IsNullOrWhiteSpace(title)) return ("Title is not specified", false);

                DateTime now = DateTime.Now;
                EntityModel qnnModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN, Constants.Level.NoJoins); 
                EntityModel qnnQnnFieldModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);
                EntityModel qnnQnnFormModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);
                EntityModel qnnQnnFileModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FILE, Constants.Level.NoJoins);
                EntityModel dwUploadedFilesModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwUploadedFiles, Constants.Level.NoJoins);
                using (SharedTransaction shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();
                    
                    //TODO - should the below be local to user's structdivision?
                    if ( (await qnnModel.GetAsync(Filter.And.Equal(title, Constants.FieldName.Title)))
                        .FirstOrDefault() != null)
                    {
                        return ("A Form Properties record with this title already exists", false);
                    }

                    DynamicEntity sourceQnn = await GetQnnQnnById(sourceId, qnnModel);
                    if (sourceQnn == null)
                        throw NotFoundException.ForModelName(qnnModel.Name, sourceId);

                    string qnnType = (string)sourceQnn[Constants.FieldName.Type];

                    List<DynamicEntity> sourceFields 
                        = await GetQnnQnnFieldsByQnnIdAsync(sourceId);
                    List<DynamicEntity> sourceForms
                        = await qnnQnnFormModel.GetAsync(Filter.And.Equal(sourceId, Constants.FieldName.QnnId));
                    List<DynamicEntity> sourceFiles 
                        = await qnnQnnFileModel.GetAsync(Filter.And.Equal(sourceId, Constants.FieldName.QnnId));

                    //Copy qnn first (this is the aggregate root)
                    DynamicEntity destQnn = await qnnModel.NewAsync();
                    destQnn[Constants.FieldName.Title] = title;
                    destQnn[Constants.FieldName.Alias] = null;
                    destQnn[Constants.FieldName.Description] = sourceQnn[Constants.FieldName.Description];
                    destQnn[Constants.FieldName.FieldCount] = sourceQnn[Constants.FieldName.FieldCount];
                    destQnn[Constants.FieldName.Type] = qnnType;
                    destQnn[Constants.FieldName.Status] = sourceQnn["Status"];
                    destQnn[Constants.FieldName.CategoryId] = sourceQnn["CategoryId"];
                    destQnn[Constants.FieldName.CreatedBy] = creator.Id;
                    destQnn[Constants.FieldName.CreatedDate] = now;
                    destQnn[Constants.FieldName.UpdatedBy] = creator.Id;
                    destQnn[Constants.FieldName.UpdatedDate] = now;
                    destQnn[Constants.FieldName.StructDivisionId] = creator.StructDivisionId.Value;
                    destQnn[Constants.FieldName.Tags] = sourceQnn[Constants.FieldName.Tags];

                    await qnnModel.UpdateSingleAsync(destQnn);
                    Guid destQnnId = (Guid)destQnn.GetId();

                    //Copy all the fields
                    List<dynamic> destFields = new List<dynamic>();
                    foreach (DynamicEntity sourceField in sourceFields)
                    {
                        DynamicEntity destField = await qnnQnnFieldModel.NewAsync();
                        destField[Constants.FieldName.QnnId] = destQnnId;
                        destField[Constants.FieldName.Name] = sourceField[Constants.FieldName.Name];
                        destField[Constants.FieldName.Type] = sourceField[Constants.FieldName.Type];
                        destField[Constants.FieldName.Required] = sourceField[Constants.FieldName.Required];
                        destField[Constants.FieldName.ReadOnly] = sourceField[Constants.FieldName.ReadOnly];
                        destField[Constants.FieldName.ValidationExp] = sourceField[Constants.FieldName.ValidationExp];
                        destField[Constants.FieldName.ValidationErr] = sourceField[Constants.FieldName.ValidationErr];
                        destFields.Add(destField);
                    }
                    await qnnQnnFieldModel.UpdateAsync(destFields);

                    //Copy the forms (currently only type is online now that pdf feature is removed)
                    if (Constants.QnnType.Online.Equals(qnnType))
                    {
                        //Online questionnaire, will have QNN_QNN_FORM
                        List<dynamic> destForms = new List<dynamic>();
                        foreach (DynamicEntity sourceForm in sourceForms)
                        {
                            DynamicEntity destForm = await qnnQnnFormModel.NewAsync();
                            destForm[Constants.FieldName.QnnId] = destQnnId;
                            destForm[Constants.FieldName.Name] = sourceForm[Constants.FieldName.Name];
                            destForm[Constants.FieldName.Language] = sourceForm[Constants.FieldName.Language];
                            destForm[Constants.FieldName.Remarks] = sourceForm[Constants.FieldName.Remarks];
                            destForms.Add(destForm);
                        }
                        await qnnQnnFormModel.UpdateAsync(destForms);

                        //Online excel file copy from QNN_QNN_FILE
                        List<dynamic> destFiles = new List<dynamic>();
                        foreach (DynamicEntity sourceFile in sourceFiles)
                        {
                            String token = (String)sourceFile[Constants.FieldName.Token];
                            Guid fileId = Guid.Parse(token);

                            //Copy the file first so we dont have two form refer to same file in db
                            DynamicEntity dwUploadedFile 
                                = (await dwUploadedFilesModel.GetAsync(Filter.And.Equal(fileId, Constants.FieldName.Id)))
                                .FirstOrDefault();
                            if (dwUploadedFile == null)
                            {
                                throw new NotFoundException("File not found for token " + token, token);
                            }
                            DynamicEntity newUploadFile = await dwUploadedFilesModel.NewAsync();
                            newUploadFile[Constants.FieldName.Data] = dwUploadedFile[Constants.FieldName.Data];
                            newUploadFile[Constants.FieldName.AttachmentLength] = dwUploadedFile[Constants.FieldName.AttachmentLength];
                            newUploadFile[Constants.FieldName.Used] = dwUploadedFile[Constants.FieldName.Used];
                            newUploadFile[Constants.FieldName.Name] = dwUploadedFile[Constants.FieldName.Name];
                            newUploadFile[Constants.FieldName.ContentType] = dwUploadedFile[Constants.FieldName.ContentType];
                            newUploadFile[Constants.FieldName.Properties] = dwUploadedFile[Constants.FieldName.Properties];
                            newUploadFile[Constants.FieldName.CreatedBy] = creator.Name; //not a guid!
                            newUploadFile[Constants.FieldName.CreatedDate] = now;
                            newUploadFile[Constants.FieldName.UpdatedBy] = creator.Name;
                            newUploadFile[Constants.FieldName.UpdatedDate] = now;
                            newUploadFile[Constants.FieldName.IsLocalStorage] = dwUploadedFile[Constants.FieldName.IsLocalStorage];
                            await dwUploadedFilesModel.UpdateSingleAsync(newUploadFile);
                            string newFileToken = ConversionUtils.ToFileToken((Guid)newUploadFile.GetId());

                            DynamicEntity newQnnFile = await qnnQnnFileModel.NewAsync();
                            newQnnFile[Constants.FieldName.QnnId] = destQnnId;
                            newQnnFile[Constants.FieldName.Name] = sourceFile[Constants.FieldName.Name];
                            newQnnFile[Constants.FieldName.Token] = newFileToken;
                            newQnnFile[Constants.FieldName.Size] = sourceFile[Constants.FieldName.Size];
                            newQnnFile[Constants.FieldName.ContentType] = sourceFile[Constants.FieldName.ContentType];
                            newQnnFile[Constants.FieldName.Language] = sourceFile[Constants.FieldName.Language];
                            newQnnFile[Constants.FieldName.Remarks] = sourceFile[Constants.FieldName.Remarks];
                            newQnnFile[Constants.FieldName.CreatedBy] = creator.Id;
                            newQnnFile[Constants.FieldName.CreatedDate] = now;
                            newQnnFile[Constants.FieldName.UpdatedBy] = creator.Id;
                            newQnnFile[Constants.FieldName.UpdatedDate] = now;
                            destFiles.Add(newQnnFile);
                        }
                        await qnnQnnFileModel.UpdateAsync(destFiles);
                    }  //end if online type O                   
                    else
                    {
                        return ("Unsupported Form Properties type " + qnnType, false);
                    }

                    shared.Commit();
                    return (destQnnId.ToString(), true);
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(DuplicateQnn) + " - caught unexpected exception, sourceId={0}, title={1}", sourceId, title);
                return (Constants.Message.InternalErrorException, false);
            }
        }

        /// <summary>
        /// Utility method to create a flat list of all the form items.
        /// Given a list of FormItem (items) will recursively add references to the supplied finalItems list of those
        /// elements containing a "Type".  
        /// </summary>
        /// <param name="items"></param>
        /// <param name="finalIems"></param>
        /// <returns></returns>
        public static List<FormItem> GetAllFormItems(List<FormItem> items, List<FormItem> finalIems)
        {
            if (items != null && items.Any())
                foreach (var item in items)
                {
                    if (Constants.OnlineFormControls.Contains(item.Type))
                        finalIems.Add(item);
                    if (item.Children.Any()) 
                        GetAllFormItems(item.Children, finalIems);
                }

            return finalIems;
        }

        //supports LatestFormFieldsUpdatedForQnn
        private static bool ScrambledEquals<T>(IEnumerable<T> list1, IEnumerable<T> list2)
        {
            var cnt = new Dictionary<T, int>();
            foreach (T s in list1)
            {
                if (cnt.ContainsKey(s))
                {
                    cnt[s]++;
                }
                else
                {
                    cnt.Add(s, 1);
                }
            }
            foreach (T s in list2)
            {
                if (cnt.ContainsKey(s))
                {
                    cnt[s]--;
                }
                else
                {
                    return false;
                }
            }
            return cnt.Values.All(c => c == 0);
        }

        //TODO - Id prefer to have this return a structure with enum result and details on the failures instead of a message and move out the logging too
        public static async Task<(string Message, bool latestFormFieldsUpdatedForQnn)> LatestFormFieldsUpdatedForQnn(Guid qnnId)
        {
            //n.b. Please keep Message client reportable (i.e end users should be able to see it (and repeat it when seeking support))

            try
            {
                EntityModel qnnFormModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);
                EntityModel qnnFieldModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);

                List<DynamicEntity> qnnFormEntities = (await qnnFormModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId)));
                if (qnnFormEntities == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_QNN_FORM, qnnId);

                foreach (DynamicEntity qnnFormEntity in qnnFormEntities)
                {
                    string formName = (string)qnnFormEntity[Constants.FieldName.Name];
                    string source = CloverRuntime.Metadata.GetFormSource(formName);
                    List<FormItem> formItems = FormSerializer.Deserialize(source);
                    List<FormItem> items = new List<FormItem>();
                    items = GetAllFormItems(formItems, items);
                    if (items == null || !items.Any(i => Constants.OnlineFormControls.Contains(i.Type)))
                        return ("Survey form does not contain valid fields", false); //Empty form
                    List<string> formFields = items.Select(i => i.Key).ToList();

                    Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
                    Order orderByNumberId = Order.StartAsc(Constants.FieldName.NumberId);

                    List<string> qnnFields = (await qnnFieldModel.GetAsync(byQnnId, orderByNumberId, paging: null))
                        .Select(qnnQnnField => (string)qnnQnnField[Constants.FieldName.Name])
                        .ToList();

                    bool latestFormFieldsUpdatedForQnn = ScrambledEquals(formFields, qnnFields);
                    if (!latestFormFieldsUpdatedForQnn)
                    {
                        const string notUpdatedMsg = "Latest survey form fields are not updated for collecting data";
                        if(Logger.IsEnabled(LogLevel.Debug))
                        {   //dump both field lists at debug level (big forms like MP will have a huge list)
                            Logger.LogDebug(nameof(LatestFormFieldsUpdatedForQnn) + " - {0}\n--formFields:\n{1}\n--qnnFields:\n{2}", notUpdatedMsg, formFields, qnnFields);
                        }
                        if(Logger.IsEnabled(LogLevel.Warning))
                        {   //At warning level output what is actually different, or duplicated
                            //We log this at warning level rather than error because it is the caller's responsibility to decide
                            //how to handle it. Actually we shouldn't log anything here, and if we ever have time I'd like to have this
                            //method return this info instead and leave any logging to caller to do (which means it can log stuff like
                            //the form name etc that we don't even know in here.
                            IEnumerable<string> diffBetweenFormAndDb 
                                = formFields.Except(qnnFields);
                            List<string> formFieldDuplicates 
                                = formFields.GroupBy(fname => fname).Where(grp => grp.Count() > 1).Select(grp => grp.Key).ToList();
                            List<string> dbFieldDuplicates 
                                = qnnFields.GroupBy(fname => fname).Where(grp => grp.Count() > 1).Select(grp => grp.Key).ToList();
                            Logger.LogWarning(nameof(LatestFormFieldsUpdatedForQnn) + " - {0}, form field count={1}, qnn field count={2}, differences={3}, form duplicates={4}, db duplicates={5}", notUpdatedMsg, formFields.Count, qnnFields.Count, diffBetweenFormAndDb, formFieldDuplicates, dbFieldDuplicates);
                        }
                        
                        return (notUpdatedMsg, false);
                    }

                }

                return ("", true);

            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(LatestFormFieldsUpdatedForQnn) + " - caught unexpected exception, qnnId={0}", qnnId);
                return ("", false);
            }
        }

        /// <summary>
        /// Check if the provided Survey Form is in used by Form Properties.
        /// </summary>
        /// <param name="formNameList"></param>
        /// <returns></returns>
        public static async Task<HashSet<string>> IsFormInUse(List<string> formNameList)
        {
            HashSet<string> result = new HashSet<string>();
            if(formNameList != null && formNameList.Any())
            {
                EntityModel qnnFormModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);
                Filter filter = Filter.And.In(formNameList, Constants.FieldName.Name);
                List<DynamicEntity> qnnList =  await qnnFormModel.GetAsync(filter);
                if (qnnList != null && qnnList.Any())
                {
                    foreach(DynamicEntity item in qnnList)
                    {
                        if (!item.Dictionary.ContainsKey(Constants.FieldName.Name)) continue;

                        string formName = item.Dictionary[Constants.FieldName.Name].ToString();
                        if (!string.IsNullOrEmpty(formName)) result.Add(formName);
                    }
                }
            }
            return result;
        }

        //called from a InsertQnnOnlineFormFields trigger
        public static async Task<(string Message, bool IsSuccessful)> GenQnnOnlineFormFields(string qnnId,
            string formName)
        {
            try
            {
                var source = CloverRuntime.Metadata.GetFormSource(formName);
                var formItems = FormSerializer.Deserialize(source);
                var items = new List<FormItem>();
                items = FormPropertiesApplication.GetAllFormItems(formItems, items);
                if (items == null || !items.Any(i => Constants.OnlineFormControls.Contains(i.Type)))
                {
                    //throw new Exception($"{formName} form is invalid!");
                    return (Constants.Message.Prefix.ClientReportable + $"{formName} form is invalid!", false);
                }

                var qnnFieldModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, 0);
                const int batchSize = 2000; 

                var ids = (await qnnFieldModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId)))
                            .Select(m => m.GetId())
                            .ToList();

                for (int i = 0; i < ids.Count; i += batchSize)
                {
                    var batch = ids.Skip(i).Take(batchSize).ToList();
                    await qnnFieldModel.DeleteAsync(batch);
                }

                var dyObjectsList = new List<dynamic>();

                foreach (var item in items)
                {
                    if (!Constants.OnlineFormControls.Contains(item.Type)) continue;
                    if (dyObjectsList.Any(o => o.Name == item.Key)) continue;
                    var readOnly =
                        item.Properties.ContainsKey("readonly") && Convert.ToBoolean(item.Properties["readonly"]);
                    var required =
                        item.Properties.ContainsKey("other-required") &&
                        Convert.ToBoolean(item.Properties["other-required"]);
                    var customValidation = item.Properties.ContainsKey("other-customvalidation")
                        ? item.Properties["other-customvalidation"].ToString()
                        : null;

                    string validationExp = null, validationErr = null;
                    if (customValidation != null)
                    {
                        var expArray = Regex.Split(customValidation, @"\s*\?\s*true\s*\:", RegexOptions.IgnoreCase);
                        if (expArray.Length == 2)
                        {
                            validationExp = expArray[0].Trim();
                            validationErr = expArray[1].Trim();
                        }
                    }

                    var dm = await qnnFieldModel.NewAsync() as dynamic;

                    dm.Id = Guid.NewGuid();
                    dm.QnnId = qnnId;
                    dm.Name = item.Key;
                    dm.Type = item.Type;
                    dm.ReadOnly = readOnly;
                    dm.Required = required;
                    dm.ValidationExp = validationExp;
                    dm.ValidationErr = validationErr;

                    dyObjectsList.Add(dm);
                }


                await qnnFieldModel.InsertAsync(dyObjectsList);

                return (Constants.Message.FieldsCreatedSucccessfully, true);
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(GenQnnOnlineFormFields) + " - caught unexpected exception, qnnId={0}, formName={1}", qnnId, formName);
                return ("Form fields were not captured", false);
            }
        }

        public static async Task<Dictionary<string, object>> GetDplyOnlineFormFieldChoices(Guid dplyId)
        {
            try
            {
                var formName = await DeploymentApplication.GetDplyFormName(dplyId);
                var source = CloverRuntime.Metadata.GetFormSource(formName);
                var formItems = FormSerializer.Deserialize(source);
                var items = new List<FormItem>();

                items = FormPropertiesApplication.GetAllFormItems(formItems, items);
                if (items == null || !items.Any(i => Constants.OnlineFormChoiceControls.Contains(i.Type)))
                    return null;

                var dyObjectsList = new Dictionary<string, object>();

                foreach (var item in items)
                {
                    if (!Constants.OnlineFormChoiceControls.Contains(item.Type)) continue;
                    if (item.Type == "checkbox")
                    {
                        dyObjectsList[item.Key] = new JArray()
                        {
                            JObject.FromObject( new {text = (string)item.Properties["label"], value="0", key=0}),
                            JObject.FromObject( new {text = (string)item.Properties["label"], value="1", key=1})
                        };
                    }
                    else
                    {
                        dyObjectsList[item.Key] = (JArray)item.Properties["data-elements"];
                    }
                }

                return dyObjectsList;
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(GetDplyOnlineFormFieldChoices) + " - caught unexpected exception, dplyId={0}", dplyId);
                return null;
            }
        }

        public static async Task<List<DynamicEntity>> GetQnnQnnFieldsByQnnIdAsync(Guid qnnId, EntityModel qnnQnnFieldModel = null)
        {
            if(qnnQnnFieldModel == null)
            {
                qnnQnnFieldModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);
            }
            Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
            //TODO - sort in memory instead of db (helps avoid bad sql server resource guestimates)
            List<DynamicEntity> qnnQnnFields
                = await qnnQnnFieldModel.GetAsync(byQnnId, Order.StartAsc(Constants.FieldName.NumberId), Paging.Empty);
            return qnnQnnFields;
        }

        public static async Task<List<QNN_QNN_FIELD>> GetQNN_QNN_FIELDsByQnnIdAsync(Guid qnnId)
        {
            Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
            return (await QNN_QNN_FIELD.SelectAsync(byQnnId, Order.Empty, paging: null))
                .OrderBy(f => f.NumberId)
                .ToList();
        }

        /// <summary>
        /// Retrieve a Form Properties entity from the QNN_QNN table using the ORM
        /// </summary>
        /// <param name="id">Id of the row in QNN_QNN</param>
        /// <param name="qnnQnnModel">optional QNN_QNN model to use</param>
        /// <returns>the Form Properties entity or null if not found</returns>
        public static async Task<DynamicEntity> GetQnnQnnById(Guid id, EntityModel qnnQnnModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_QNN, qnnQnnModel);
        }

        public static async Task<int> ValidateQnnQnnForm(DynamicEntity data, Clover.Core.Security.User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            //Verify user has rights for this organisation
            Guid structDivisionId = (Guid)data[Constants.FieldName.StructDivisionId];
            HashSet<Guid> allowedOrganisations
                = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!allowedOrganisations.Contains(structDivisionId)) return 2;

            string title = (string)data[Constants.FieldName.Title];
            if (string.IsNullOrWhiteSpace(title) || title.Length > 300) return 101;

            //QNN_QNN_FORM entities are in collectioneditor_2
            List<DynamicEntity> forms = (List<DynamicEntity>)data["collectioneditor_2"];
            if (forms == null || !forms.Any()) return 102;

            return 0;
        }

    } //end of FormPropertiesApplication
}
