using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using Constants = swz.SurveyPlus.Application.Constants;
using System.Text.RegularExpressions;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.Application;
using Newtonsoft.Json.Linq;

namespace swz.SurveyPlus.IntranetApplication.ThirdPartyApi
{
    public static class ThirdPartyApiApplication
    {
        private static readonly object lockObject = new object();
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ThirdPartyApiApplication));

        public class ResponseFilesResult
        {
            public enum Outcome { Success, NoFilesFound }

            public static ResponseFilesResult Success(string filePath, string contentType)
            {
                if (String.IsNullOrEmpty(filePath)) throw new ArgumentException(nameof(filePath));
                if (String.IsNullOrEmpty(contentType)) throw new ArgumentException(nameof(contentType));
                return new ResponseFilesResult(Outcome.Success, filePath, contentType);
            }

            public static ResponseFilesResult Fail(Outcome reason)
            {
                if (reason == Outcome.Success) throw new ArgumentException(nameof(reason));
                return new ResponseFilesResult(reason, null, null);
            }

            // // // //

            public bool IsSuccess { get { return Reason == Outcome.Success; } }
            public Outcome Reason { get; private set; }
            public string FilePath { get; private set; }
            public string ContentType { get; private set; }

            public ResponseFilesResult(Outcome reason, string filePath, string contentType)
            {
                this.Reason = reason;
                this.FilePath = filePath;
                this.ContentType = contentType;
            }
        }

        /// <summary>
        /// Exception to report errors that occur when performing a data extraction
        /// </summary>
        public class ResponseExtractionException : Exception
        {
            public ResponseExtractionException(string msg, Exception rootCause) : base(msg, rootCause) { }
        }

        /// <summary>
        /// Extract the response data for the specified deployments.
        /// Throws ResponseExtractionException to wrap any unexpected exceptions that occur
        /// </summary>
        /// <param name="deployments"></param>
        /// <param name="filterToStatusIds">if not empty then only include files from responses with these status</param>
        /// <returns>list of data for each deployment (if none is an empty list, never null)</returns>
        public static async Task<List<Dictionary<string, object>>> ExtractResponseDataAsync
            (IEnumerable<DynamicEntity> deployments, 
            IEnumerable<QnnStatusId> filterToStatusIds)
        {
            try
            {
                List<Dictionary<string, object>> responseDataList = new List<Dictionary<string, object>>();
                foreach (DynamicEntity deployment in deployments)
                {
                    Dictionary<string, object> responseData = await GetResponseData(deployment, filterToStatusIds);
                    if (responseData.ContainsKey("Responses"))
                    {
                        responseDataList.Add(responseData);
                    }
                }
                return responseDataList;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(e, "Exception extracting response data"); //debug level as caller is responsible to handle
                throw new ResponseExtractionException("Unexpected error extracting response data", e);
            }
        }

        /// <summary>
        /// Generate zip file containing the response files from the specified deployments (filtering responses to the specified.
        /// Throws ResponseExtractionException to wrap any unexpected exceptions that occur.
        /// Caller is responsible for cleaning up the generated zip file. (New behaviour 20231019)
        /// </summary>
        /// <param name="contentRootPath"></param>
        /// <param name="info">collection of QNN_DPLY to pull data from</param>
        /// <param name="filterToStatusIds">if not empty then only include files from responses with these status</param>
        /// <returns>result object with path to zip or error indicator</returns>
        public static async Task<ResponseFilesResult> ExtractResponseFilesAsync(
            string contentRootPath, 
            string respFiles3PAPath, 
            IEnumerable<DynamicEntity> deployments, 
            IEnumerable<QnnStatusId> filterToStatusIds)
        {
            try
            {
                bool isFileToReturn = false;
                string respFiles3PAId = Guid.NewGuid().ToString();
                string respFiles3PAFolder = Path.Combine(contentRootPath, respFiles3PAPath); //absolute path to folder
                string respFilesSubFolder = Path.Combine(respFiles3PAFolder, respFiles3PAId);
                string statusIdString = string.Join(',', filterToStatusIds);

                //Create subfolders for each deployment with the extracted files 
                foreach (DynamicEntity deployment in deployments)
                {
                    Guid dplyId = (Guid)deployment[Constants.FieldName.Id];
                    Guid qnnId = (Guid)deployment[Constants.FieldName.QnnId];
                    List<Dictionary<string, object>> uploadedFiles 
                        = await spSP_GetDplyUploadedFilesDataCollection.GetDplyUploadedFilesDataCollection(dplyId, qnnId, statusIdString);
                    if (uploadedFiles != null && uploadedFiles.Any())
                    {
                        string respFilesDplyFolder = Path.Combine(respFilesSubFolder, dplyId.ToString());
                        isFileToReturn = CreateTemporaryResponseFiles(uploadedFiles, contentRootPath, respFilesDplyFolder);
                    }
                } //end foreach deployment

                if (isFileToReturn)
                {
                    string zipFileFullPathName = Path.Combine(respFiles3PAFolder, $"{respFiles3PAId}.zip");
                    ZipFile.CreateFromDirectory(respFilesSubFolder, zipFileFullPathName);
                    new DirectoryInfo(respFilesSubFolder).Delete(recursive: true); //20231019 - new behaviour, delete immediately after zipping

                    return ResponseFilesResult.Success(zipFileFullPathName, Constants.ContentTypes.ZipFileType);
                }
                else
                {
                    return ResponseFilesResult.Fail(ResponseFilesResult.Outcome.NoFilesFound);
                }
            }
            catch(Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(e, "Exception extracting response files"); //debug level as caller is responsible to handle
                throw new ResponseExtractionException("Unexpected error extracting response files", e);
            }
        }

        /// <summary>
        /// Extract the response files for the specified deployment to physical file system
        /// </summary>
        private static bool CreateTemporaryResponseFiles(
            List<Dictionary<string, object>> uploadedFiles,
            string rootPath, 
            string respFilesDplyFolder)
        {
            if (uploadedFiles == null) throw new ArgumentNullException(nameof(uploadedFiles));
            if (string.IsNullOrEmpty(rootPath)) throw new ArgumentException(nameof(rootPath));
            if (string.IsNullOrEmpty(respFilesDplyFolder)) throw new ArgumentException(nameof(respFilesDplyFolder));
            try
            {
                if (!uploadedFiles.Any()) return false;
                lock (lockObject)
                {
                    //check dply folder exists or not, if not create it
                    Directory.CreateDirectory(respFilesDplyFolder);

                    foreach (Dictionary<string,object> file in uploadedFiles)
                    {
                        string filename = (string)file[Constants.FieldName.Filename];
                        string filePath = Path.Combine(respFilesDplyFolder, filename);
                        if (File.Exists(filePath) || string.IsNullOrEmpty(filename)) continue;
                        try
                        {
                            if (Guid.TryParse(file[Constants.FieldName.Token].ToString(), out var id))
                            {
                                UploadedFiles item = UploadedFiles.SelectByKey(id).Result;
                                byte[] data = item.Data;
                                using (Stream fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                                {
                                    fs.Write(data, 0, data.Length);
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            if(logger.IsEnabled(LogLevel.Debug))
                            {
                                logger.LogDebug("rootPath={0}, respFilesDplyFolder={1}", rootPath, respFilesDplyFolder);
                            }
                            throw new Exception("Failed to export temporary files to filesystem", e);
                        }
                    } //end foreach file
                    return true;
                } //end lock
            }
            catch (Exception e)
            {
                //Caller's responsibility to log at error level
                logger.LogDebug(e, nameof(CreateTemporaryResponseFiles) + " - caught unexpected exception");
                throw new Exception("Unexpected exception exporting temporary files", e);
            }
        }

        private static async Task<Dictionary<string, object>> GetResponseData(DynamicEntity deployment, IEnumerable<QnnStatusId> filterToStatusIds)
        {
            if (deployment == null) throw new ArgumentNullException(nameof(deployment));
            if (filterToStatusIds == null) throw new ArgumentNullException(nameof(filterToStatusIds));

            //1. First get user info of reponses.
            //2. Then merge the response field and answer
            //	 a. Check If there is file input.

            string commaDelimitedStatusIds = string.Join(',', filterToStatusIds);

            DateTime? updatedDate = ((DateTime?)deployment[Constants.FieldName.UpdatedDate]);
            Dictionary<string, object> result = new Dictionary<string, object>
            {
                {"Deployment", deployment[Constants.FieldName.Name]},
                {"ApiIdentifier", deployment[Constants.FieldName.ApiIdentifier] },
                {"CreatedDate", ((DateTime)deployment[Constants.FieldName.CreatedDate]).ToString(Constants.QnnDatetimeFormat) },
                {"UpdatedDate",  (updatedDate==null) ? "null" : ((DateTime)updatedDate).ToString(Constants.QnnDatetimeFormat) },
                {"State", deployment[Constants.FieldName.State] },
                {"DateStart", ((DateTime)deployment[Constants.FieldName.DateStart]).ToString(Constants.QnnDatetimeFormat)},
                {"DateEnd", ((DateTime)deployment[Constants.FieldName.DateEnd]).ToString(Constants.QnnDatetimeFormat)},
                {"VisibleToRespondent", (bool)deployment[Constants.FieldName.VisibleToRespondent] },
                {"FormProperties", deployment[Constants.FieldName.QnnId+'_'+Constants.FieldName.Title]},
                {"SurveyName",deployment[Constants.FieldName.SurveyName]},
                {"SampleList", deployment[Constants.FieldName.ListId+'_'+Constants.FieldName.Name]} ,
                {"Remarks", deployment[Constants.FieldName.Remarks]},
            };

            Guid dplyId = (Guid)deployment.GetId();
            Guid qnnId = (Guid)deployment[Constants.FieldName.QnnId];
            const int take = 200;

            (int colCount, List<Dictionary<string, object>> items)
                = await spSP_GetRespAnsWithDetailsDataCollection.GetRespAnsWithDetailsDataCollectionAsync(
                    dplyId: dplyId,
                    qnnId: qnnId,
                    getProps: true,
                    skip: 0,
                    take: take,
                    commaDelimitedStatusIds: commaDelimitedStatusIds);

            if (colCount > 0)
            {
                for (int i = 0; i < colCount; i = i + take)
                {
                    //Merge Response Ans to Response User Info
                    (int _, var itemsToMerge)
                        = await spSP_GetRespAnsWithDetailsDataCollection.GetRespAnsWithDetailsDataCollectionAsync(
                            dplyId: dplyId,
                            qnnId: qnnId,
                            getProps: false,
                            skip: i,
                            take: take,
                            commaDelimitedStatusIds: commaDelimitedStatusIds);

                    if (items != null && items.Any() && itemsToMerge != null && itemsToMerge.Any())
                    {
                        for (int j = 0; j < items.Count; j++)
                        {
                            //Check if there is any File Input.
                            for (int k = 0; k < itemsToMerge[j].Count; k++)
                            {
                                string ansValue = itemsToMerge[j].ElementAt(k).Value.ToString();
                                string field = itemsToMerge[j].ElementAt(k).Key;
                                ansValue.Replace("{", "").Replace("}", "");
                                string newAnsValue = ansValue ?? "";
                                string regex = "[^0-9A-Fa-f-]";
                                if (newAnsValue.Length == 32 && !Regex.IsMatch(newAnsValue, regex))
                                {
                                    if (Guid.TryParse(newAnsValue, out Guid id))
                                    {
                                        UploadedFiles uploadfile = UploadedFiles.SelectByKey(id).Result;
                                        string fileName = uploadfile.Name;
                                        long size = uploadfile.AttachmentLength;
                                        //Concat UID, token , fileName
                                        string exportName = items[j][Constants.FieldName.UID] + "_" + ansValue + "_" + fileName;
                                        Dictionary<string, object> fileObject = new Dictionary<string, object>
                                        {
                                            {"Name", fileName },
                                            {"Token", id },
                                            {"Size", size},
                                            {"ExportName", exportName}
                                        };

                                        itemsToMerge[j][field] = fileObject;
                                    }
                                }
                            }


                            string respDataKey = "ResponseData";
                            if (items[j].ContainsKey(respDataKey)) //Merge subsequent columns/ans
                            {
                                var respDataVal = JObject.FromObject(items[j][respDataKey]).ToObject<Dictionary<string, object>>();
                                foreach (KeyValuePair<string, object> itemToMerge in itemsToMerge[j])
                                {
                                    if (!respDataVal.ContainsKey(itemToMerge.Key))
                                    {
                                        respDataVal.Add(itemToMerge.Key, itemToMerge.Value);
                                    }
                                }
                                items[j][respDataKey] = respDataVal;
                            }
                            else //Merge first 200 columns/ans
                            {
                                //Reformat the dates so they appear in desired format in the json
                                object ccEmails = items[j][Constants.FieldName.CcEmails];
                                object respDateStart = items[j][Constants.FieldName.DateStart3PA];
                                object respDateComplete = items[j][Constants.FieldName.DateComplete3PA];
                                object respUpdatedDate = items[j][Constants.FieldName.UpdatedDate3PA];
                                object respRemarksModifyOn = items[j][Constants.FieldName.RemarksModifyOn3PA];
                                object respStatusModifyOn = items[j][Constants.FieldName.StatusModifyOn3PA];
                                items[j][Constants.FieldName.CcEmails] = ccEmails.ToString() != string.Empty
                                    ? ccEmails.ToString().Split(',')
                                    : null;
                                items[j][Constants.FieldName.DateStart3PA] = respDateStart != System.DBNull.Value
                                    ? ((DateTime)respDateStart).ToString(Constants.QnnDatetimeFormat)
                                    : string.Empty;
                                items[j][Constants.FieldName.DateComplete3PA] = respDateComplete != System.DBNull.Value
                                    ? ((DateTime)respDateComplete).ToString(Constants.QnnDatetimeFormat)
                                    : string.Empty;
                                items[j][Constants.FieldName.UpdatedDate3PA] = respUpdatedDate != System.DBNull.Value
                                    ? ((DateTime)respUpdatedDate).ToString(Constants.QnnDatetimeFormat)
                                    : string.Empty;
                                items[j][Constants.FieldName.RemarksModifyOn3PA] = respRemarksModifyOn != System.DBNull.Value
                                    ? ((DateTime)respRemarksModifyOn).ToString(Constants.QnnDatetimeFormat)
                                    : string.Empty;
                                items[j][Constants.FieldName.StatusModifyOn3PA] = respStatusModifyOn != System.DBNull.Value
                                    ? ((DateTime)respStatusModifyOn).ToString(Constants.QnnDatetimeFormat)
                                    : string.Empty;

                                items[j].Add(respDataKey, itemsToMerge[j]);
                            }
                        }
                    }
                }
                if (items != null && items.Any())
                {
                    result.Add("Responses", items);
                }
            }
            return result;
        }
    }
}
