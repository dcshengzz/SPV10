using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using System.IO.Compression;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.Clover.Core.Metadata.DbObjects;
using swz.SurveyPlus.Application;
using System.Text.RegularExpressions;

namespace swz.SurveyPlus.IntranetApplication
{
    //TODO - consider refactoring as a service instance so settings and logger can be injected
    public class ResponseDataExport
    {

        public class NoResponseDataException : Exception
        {
            public NoResponseDataException(string message) : base(message) { }
        }

        public class NoResponseUploadsException : Exception
        {
            public NoResponseUploadsException() : base() { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<ResponseDataExport>();

        /// <summary>
        /// Extract responses from DB and write into csv file.
        /// Zip the csv file and return filename.
        /// </summary>
        /// <param name="exportResponsePath"></param>
        /// <param name="dplyId"></param>
        /// <returns>full zip file path and name</returns>
        public static async Task<string> CreateZippedResponses(String exportResponsePath, Guid dplyId)
        {
            if (string.IsNullOrEmpty(exportResponsePath))
                throw new ArgumentException("required", nameof(exportResponsePath));

            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(CreateZippedResponses) + " - called with exportResponsePath={0}, dplyId={1}", exportResponsePath, dplyId);
                }

                SurveyResponseExporter export = await SurveyResponseExporter.NewInstanceUsingAppSettingsAsync(dplyId);

                string archiveFolderId = Guid.NewGuid().ToString();
                string subExportResponsePath = Path.Combine(exportResponsePath, archiveFolderId);
                string csvFileName = $"ExportResponseData_{DateTime.Now.ToString("yyyyMMddhhmmss")}.csv";
                DirectoryInfo tempdir = Directory.CreateDirectory(subExportResponsePath);

                string csvPath = Path.Combine(subExportResponsePath, csvFileName);
                SurveyResponseExporter.Result result;
                using (Stream csvStream = new FileStream(csvPath, FileMode.Create, FileAccess.Write))
                {
                    result = await export.Csv(csvStream);
                    csvStream.Flush();  
                }

                if (result.IsNoRecordsExported)
                {
                    //The new exporter will generate a CSV file with just the header row if there are no responses but
                    //for now we don't want to use that file for anything so here we will just throw away the generated
                    //file and report 'no responses' to caller with an exception as per the previous behaviour

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(CreateZippedResponses) + " - there were no responses exported. Deleting the tempdir {0}", subExportResponsePath);
                    }
                    tempdir.Delete(recursive: true);
                    throw new NoResponseDataException("There are no responses for this deployment");
                }
                else
                {
                    //Normal case: Zip the csv, cleanup the temp folder, and return archive filename to caller
                    string zipFileName = archiveFolderId + ".zip";
                    string zipFileFullPathName = Path.Combine(exportResponsePath, zipFileName);
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(CreateZippedResponses) + " - exported {0} records, will now create archive {1} from {2}", result.ExportCount, zipFileFullPathName, subExportResponsePath);
                    }
                    //TODO - support using the external archive tool if configured. e.g. 7Z is faster and more compact
                    ZipFile.CreateFromDirectory(tempdir.FullName, zipFileFullPathName);
                    tempdir.Delete(recursive: true);

                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(CreateZippedResponses) + " - completed for dplyId={0}. zipFileName={1},", dplyId, zipFileFullPathName);
                    }

                    return zipFileName;
                }
            }
            catch (NoResponseDataException)
            {
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {   //Caller is responsible for error level logging
                    logger.LogDebug(e, nameof(CreateZippedResponses) + " - caught unexpected exception, dplyId={0}, exportResponsePath={1}", dplyId, exportResponsePath);
                }
                throw new InternalException($"Unexpected exception creating zipped response file for dplyId={dplyId}", e);
            }
        }

        /// <summary>
        /// Old response data file cleanup job. This is left in place to serve any pending jobs in existing surveyplus
        /// instances and wil be removed in a future version.
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        [Obsolete]
        public static void CleanUpExportedDeploymentResponses(string exportedDeploymentResponsePath, string zipFileFullPathName)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(CleanUpExportedDeploymentResponses) + " - cleaning up exported deployment responses in {0}", exportedDeploymentResponsePath);
                }
                DirectoryInfo di = new DirectoryInfo(exportedDeploymentResponsePath);
                if (di.Exists)
                    di.Delete(true);

                if (File.Exists(zipFileFullPathName))
                    File.Delete(zipFileFullPathName);

            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CleanUpExportedDeploymentResponses) + " - caught unexpected exception, exportedDeploymentResponsePath={0}, zipFileFullPathName={1}", exportedDeploymentResponsePath, zipFileFullPathName);
            }
        }

        /// <summary>
        /// Extracts and zips the respondent uploaded files in the deployment response. Returns the filename of the generated zip.
        /// If there are none this will now throw an explicit NoResponseUploadsException (previously would return null)
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="respFilesPath"></param>
        /// <returns></returns>
        public static async Task<string> CreateZippedResponseUploadedFiles(Guid dplyId, string respFilesPath)
        {
            if (Guid.Empty.Equals(dplyId)) throw new ArgumentException("required", nameof(dplyId));
            if (string.IsNullOrEmpty(respFilesPath)) throw new ArgumentException("required", nameof(respFilesPath));

            string folderName = $"{dplyId}_{DateTime.Now.Ticks}";
            string respFilesFolderPath = Path.Combine(respFilesPath, folderName);
            string zipFileName = folderName + ".zip";
            string zippedFolderPath = Path.Combine(respFilesPath, zipFileName);

            HashSet<string> whitelistedExt = await GetWhiteListedFileExtension();

            try
            {
                List<spSP_GetDplyUploadedFiles.DbFile> dbFiles = await spSP_GetDplyUploadedFiles.GetUploadedFilenames(dplyId);
                if (dbFiles.Any())
                {
                    DirectoryInfo tempdir = Directory.CreateDirectory(respFilesFolderPath);

                    foreach (var dbFile in dbFiles)
                    {
                        string filename = dbFile.Filename;

                        filename = await VerifyAndSanitizeFilename(filename, whitelistedExt);

                        //TODO - should the below use FileUtils.CombineWithPath?
                        string filePath = Path.Combine(respFilesFolderPath, filename);
                        try
                        {
                            if (Guid.TryParse(dbFile.Token, out Guid id))
                            {
                                UploadedFiles item = UploadedFiles.SelectByKey(id).Result;
                                byte[] data = item.Data;
                                using (FileStream fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                                {
                                    fs.Write(data, 0, data.Length);
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            logger.LogError(e, nameof(CreateZippedResponseUploadedFiles) + " - caught exception writing file, dplyId={0}, respFilesPath={1}", dplyId, respFilesPath);
                            //TODO - why do we continue here? Shouldn't we fail?
                        }
                    }

                    ZipFile.CreateFromDirectory(tempdir.FullName, zippedFolderPath);
                    tempdir.Delete(recursive: true);
                } 
                else
                {
                    throw new NoResponseUploadsException();
                }
                
                return zipFileName;
            }
            catch (NoResponseUploadsException)
            {
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(CreateZippedResponseUploadedFiles) + " - caught unexpected exception, dplyId={0}, respFilesPath={1}", dplyId, respFilesPath);
                }
                throw new Exception($"Unexpected exception creating zipped deployment uploaded files for dplyId={dplyId}", e);
            }
        }

        public static async Task<HashSet<string>> GetWhiteListedFileExtension()
        {
            ILookup<string, string> settings = (await AppSettings
                            .SelectAsync(Filter.And.Equal(swz.SurveyPlus.Application.Constants.dwAppSettingName.WhitelistedFileExt, swz.SurveyPlus.Application.Constants.FieldName.Name)))
                            .ToLookup(s => s.Name, s => s.Value);
            string extensions = settings[swz.SurveyPlus.Application.Constants.dwAppSettingName.WhitelistedFileExt].FirstOrDefault();

            HashSet<string> extListing = new HashSet<string>();

            if (!string.IsNullOrEmpty(extensions))
            {
                foreach (string ext in extensions.Split(","))
                {
                    if (!string.IsNullOrEmpty(ext.Trim()))
                    {
                        extListing.Add(ext.Trim());
                    }
                }
            }

            return extListing;
        }

        public static async Task<string> VerifyAndSanitizeFilename(string filename, HashSet<string> whitelistedExt)
        {
            // Whitelisting
            bool isWhiteListed = FileStorageApplication.IsFileWhitelisted(whitelistedExt, filename);
            if (!isWhiteListed)
                throw new Exception($"File export failed:" + filename + " is not an allowed file type.");

            // Allow only alphanumeric characters, underscores, hyphens, dots, and parentheses
            string sanitizedFilename = Regex.Replace(filename, @"[^a-zA-Z0-9_\.\-\(\)]", "");

            // Prevent directory traversal by removing any "../" or "..\" sequences
            return sanitizedFilename.Replace("..", "");
             
        }

        /// <summary>
        /// This method is retained for now to serve any remaining hangfire jobs calling it in existing surveyplus
        /// instances. It will be removed in a future version.
        /// </summary>
        //*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        [Obsolete]
        public static void CleanUpExportedUploadedFiles(string respFilesFolder, string zipFileFullPathName)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug("Cleaning up exported deployment uploaded files in {0}", respFilesFolder);
                DirectoryInfo di = new DirectoryInfo(respFilesFolder);
                if (di.Exists)
                    di.Delete(true);

                if (File.Exists(zipFileFullPathName))
                    File.Delete(zipFileFullPathName);

            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(CleanUpExportedUploadedFiles) + " - caught unexpected exception");
            }
        }

    }
}
