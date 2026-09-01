using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using System.IO;
using Microsoft.Net.Http.Headers;
using swz.Clover.Core.Security;
using System.Collections.Immutable;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    [Authorize]
    public class DataController : Controller
    {
        private readonly ILogger<DataController> logger;
        private readonly PrintSettings printSettings;

        public DataController(
            ILogger<DataController> logger,
            PrintSettings printSettings)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.printSettings = printSettings ?? throw new ArgumentNullException(nameof(printSettings));
        }

        [Route("data/get")]
        public async Task<ActionResult> GetData(string name, string control, string urlFilter, string options,
            string filter, string paging, string sort)
        {
            string idValue = null;
            try
            {
                if (!await CloverRuntime.Security.CheckFormPermissionAsync(name, "View"))
                    throw new Exception("Access denied!");

                string filterActionName = null;
                var filterItems = new List<ClientFilterItem>();

                if (ConstraintsNotNullOrEmpty(urlFilter))
                    try
                    {
                        filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(urlFilter));
                    }
                    catch
                    {
                        var filterActions = CloverRuntime.ServerActions.GetFilterNames()
                            .Where(n => n.Equals(urlFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                        string filterAction = null;
                        filterAction = filterActions.Count == 1
                            ? filterActions.First()
                            : filterActions.FirstOrDefault(n => n.Equals(urlFilter, StringComparison.Ordinal));

                        if (!string.IsNullOrEmpty(filterAction))
                            filterActionName = filterAction;
                        else
                            idValue = urlFilter;
                    }

                if (ConstraintsNotNullOrEmpty(filter))
                    filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(filter));

                //Kludge for survey preview mode
                //If is for preview, should have no response answer to retrieve.
                if (idValue != null && idValue.ToLower() == "preview") {
                    Dictionary<string, object> previewResponse = new Dictionary<string, object>();
                    previewResponse.Add("onPreview", true);
                    previewResponse.Add("formIsReadOnly", false);
                    return Json(new ItemSuccessResponse<object>(previewResponse));
                }

                var getRequest = new GetDataRequest(name)
                {
                    RequestingControlName = control,
                    FilterActionName = filterActionName,
                    IdValue = idValue,
                    Filter = filterItems,
                    BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value),
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie",
                            string.Join(";",
                                Request.Cookies.Select(c => $"{c.Key}={c.Value}")));
                        dataUrlParameters.Add("referer", Request.Headers["Referer"]);
                        return dataUrlParameters;
                    }
                };

                if (ConstraintsNotNullOrEmpty(options))
                    getRequest.OptionsDictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(options);

                if (ConstraintsNotNullOrEmpty(paging)) getRequest.Paging = JsonConvert.DeserializeObject<ClientPaging>(paging);

                if (ConstraintsNotNullOrEmpty(sort)) getRequest.Sort = JsonConvert.DeserializeObject<List<ClienSortItem>>(sort);

                //Kludge to ignore initial request from the grid on AuditTrail form
                //because its scope is too large and we need user to set a filter
                if (AuditLogApplication.IsUnconstrainedAuditGridRequest(getRequest))
                {   
                    return Json(
                        new ItemSuccessResponse<object>(
                            new Dictionary<string, object>()
                            {
                                { "gridAuditLog", ImmutableList<object>.Empty },
                                { "__gridAuditLog_totalcount", 0 }
                            }));
                }

                (DynamicEntity Entity, bool IsFromUrl) data 
                    = await DataSource.GetDataForFormAsync(getRequest).ConfigureAwait(false);

                //nb: Warning: if the StructDivisionId is not nullable then when opening a form without
                //    an existing entity we will get Guid.EMPTY instead of null here, and HasStructAccess will fail
                if (!await HasStructAccess((Guid?)data.Entity?["StructDivisionId"]))
                    throw new Exception("Access denied. Not within the same department!");

                if (data.IsFromUrl && FailResponse.IsFailResponse(data.Entity, out var fail)) return Json(fail);
                if (data.Entity != null)
                    data.Entity["isIntranetApplication"] = true;

                if (idValue != null && idValue.ToLower() == "view")
                {
                    data.Entity["onViewMode"] = true;
                }

                return Json(new ItemSuccessResponse<object>(data.Entity?.ToDictionary(true)));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetData) + " - an unexpected exception was caught, name={0}, control={1}, urlFilter={2}, filter={3}, paging={4}, sort={5}", name, control, urlFilter, filter, paging, sort);

                string errorMessage = Constants.Message.InternalErrorException;

                //This api method "GetData" is used by many processes, here is to determine and provide proper error message corresponding to the process.
                //idValue == "dlsi" is to determine the api call is retrieving survey data.
                //Might not be accurate if there are other process use the same pattern
                if (!string.IsNullOrEmpty(idValue) && idValue == "dlsi" && string.IsNullOrEmpty(paging) && string.IsNullOrEmpty(sort))
                {
                    errorMessage = Constants.Message.GetSurveyDataFailed;
                }

                return Json(new FailResponse(errorMessage));		
            }
        }

        [Route("data/change")]
        [HttpPost]
        public async Task<ActionResult> ChangeData(string name, string data)
        {
            try
            {
                if (!await CloverRuntime.Security.CheckFormPermissionAsync(name, "Edit"))
                    throw new Exception("Access denied!");

                var ipAddress = GetRequestIP();
                var postRequest = new ChangeDataRequest(name, data)
                {
                    BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value),
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie",
                            string.Join(";",
                                Request.Cookies.Select(c => $"{c.Key}={c.Value}")));

                        dataUrlParameters.Add("ipaddress", ipAddress);
                        dataUrlParameters.Add("referer", Request.Headers["Referer"]);
                        dataUrlParameters.Add("savedraft", Request.Headers["savedraft"]);
                        dataUrlParameters.Add("timestamp", Request.Headers["timestamp"]);
                        dataUrlParameters.Add("autosave", Request.Headers["autosave"]);
                        return dataUrlParameters;
                    }
                };

                var res = await DataSource.ChangeData(postRequest);
                if (res.success != null)
                    return Json(res.success);
                return Json(res.fail);
            }
            catch (Exception e)
            {
                //data isn't logged because its large and may be sensitive
                logger.LogError(e, nameof(ChangeData) + " - caught unexpected exception, name={0}", name);

                //ClientReportableMessage mechanism allows certain messages to be reported back if it is marked
                //with prefix. Normally we would not return the exception message to clientside for security reasons.
                string reportMessage = "Data changes were not successful. "
                    + TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(
                        e.Message, 
                        "Please check with system administrator");

                return Json(new FailResponse(reportMessage));
            }
        }

        [Route("data/delete")]
        [HttpPost]
        public async Task<ActionResult> DeleteData(string name, string requestingControl, string data)
        {
            try
            {
                if (!await CloverRuntime.Security.CheckFormPermissionAsync(name, "Edit"))
                    throw new Exception("Access denied!");

                var deleteRequest = new ChangeDataRequest(name, data, requestingControl)
                {
                    BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value),
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie",
                            string.Join(";",
                                Request.Cookies.Select(c => $"{c.Key}={c.Value}")));
                        return dataUrlParameters;
                    }
                };

                var res = await DeleteDataApplication.DeleteData(deleteRequest);

                if (res.Succeess)
                    return Json(new SuccessResponse("Data was deleted successfully"));
                return Json(new FailResponse(res.Message));
            }
            catch (Exception e)
            {
                //data may be large and sensitive so we don't log it here
                logger.LogError(e, nameof(DeleteData) + " - caught unexpected exception, name={0}, requestingControl={1}", name, requestingControl);
                var msg = "Unable to delete";
                return Json(new FailResponse(msg));
            }
        }

        [Route("data/dictionary")]
        public async Task<ActionResult> GetDictionary(string name, string sort, string columns, string paging,
            string filter)
        {
            try
            {
                var filterItems = new List<ClientFilterItem>();

                if (ConstraintsNotNullOrEmpty(filter))
                    filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(filter));

                //Dictionary has no collection filter; inject Struct filter
                var structClientFilterItem = await GetCurrentUserStructDivisionsClientFilter(name);
                if (structClientFilterItem != null) filterItems.Add(structClientFilterItem);

                var getRequest = new GetDictionaryRequest(name)
                {
                    Filter = filterItems
                };

                if (ConstraintsNotNullOrEmpty(sort)) getRequest.Sort = JsonConvert.DeserializeObject<List<ClienSortItem>>(sort);
                //ZL changed to only get first column for dictionary control. the other columns are used for filtering, not for display
                //if (NotNullOrEmpty(columns)) getRequest.Columns = JsonConvert.DeserializeObject<List<string>>(columns);
                if (ConstraintsNotNullOrEmpty(columns)) getRequest.Columns = JsonConvert.DeserializeObject<List<string>>(columns).Take(1).ToList();
                if (ConstraintsNotNullOrEmpty(paging)) getRequest.Paging = JsonConvert.DeserializeObject<ClientPaging>(paging);

                var data = await DataSource.GetDictionaryAsync(getRequest).ConfigureAwait(false);
                var res = new ItemSuccessResponse<List<KeyValuePair<object, string>>>(data.Item1.ToList());
                res.Count = data.Item2;
                return Json(res);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetDictionary) + " - caught unexpected exception, name={0}, sort={1}, columns={2}, paging={3}, filter={4}", name, sort, columns, paging, filter);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// This endpoint is used for general upload of file and return of its token to UI in the intranet side.
        /// Files intended for 'local storage' (i.e. the file annex feature) should now be using 
        /// UploadNamedFileToLocalStorage instead
        /// </summary>
        [HttpPost]
        [Route("data/upload")]
        public async Task<ActionResult> UploadFile()
        {
            try
            {
                if (Request.Form.Files.Count != 1)
                    return BadRequest("Expected 1 file");

                //TODO - does anything still call here with this as True or can we remove the logic for it?
                string isLocalStorageHeader = (string)Request.Headers[Constants.HeaderNames.isLocalStorage] ?? Boolean.FalseString;
                if (!Boolean.TryParse(isLocalStorageHeader, out bool isLocalStorage)) 
                    return BadRequest(Constants.HeaderNames.isLocalStorage);

                //TODO - does anything still call here with this set or can we remove the logic for it?
                string existingToken = Request.Headers[Constants.HeaderNames.updateFileId];
                bool isUpdatingExistingFile = !string.IsNullOrEmpty(existingToken);
                if (isUpdatingExistingFile && !Guid.TryParse(existingToken, out var __))
                    return BadRequest(Constants.HeaderNames.updateFileId);

                IFormFile file = Request.Form.Files[0];
                Dictionary<string, string> properties = new Dictionary<string, string>();
                //TODO - This set properties logic have been appear on TOO MANY PLACES, consider consolidate it by making a static class/method to avoid multi standard. Especially those flag with true/ false value.
                properties.Add(Constants.FileProperties.Name, file.FileName);
                properties.Add(Constants.FileProperties.ContentType, file.ContentType);
                properties.Add(Constants.FileProperties.IsLocalStorage, ""+isLocalStorage);
                using (Stream stream = file.OpenReadStream())                    
                {              
                    if (isUpdatingExistingFile)
                    {
                        await CloverRuntime.ContentProvider.ReplaceAsync(existingToken, stream, properties);
                        return Json(new SuccessResponse(existingToken));
                    }
                    else
                    {
                        string newToken = await CloverRuntime.ContentProvider.AddAsync(stream, properties);
                        return Json(new SuccessResponse(newToken));
                    }
                } 	
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadFile) + " - caught unexpected exception");
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Authorize]
        [Route("data/view/{token}")]
        public async Task<ActionResult> ViewFileInLocalStorageByToken(string token)
        {
            if (!Guid.TryParse(token, out Guid fileId)) return BadRequest();
            try
            {
                UploadedFilesPoor file = await UploadedFilesPoor.SelectByKey(fileId);
                if (file == null) return NotFound();
                await CheckFileStructDivision(file); //throws PermissionException when invalid
                (Stream Stream, Dictionary<string, string> Properties) data = await CloverRuntime.ContentProvider.GetAsync(token);

                (ActionResult result, ContentDisposition disposition) = ControllerFileHelper.FileResult(data.Stream, data.Properties, FileResultAction.View, FileResultAllow.AnyDownloadableFile);
                if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                return result;
            }
            catch (PermissionException pex)
            {
                var _ = ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                logger.LogError(nameof(ViewFileInLocalStorageByToken) + " - viewing local storage file denied , token={0}", token);

                return NotFound(); //404 instead of 403 as we don't even want to reveal existence of the file
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ViewFileInLocalStorageByToken) + " - caught unexpected exception, token={0}", token);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Authorize]
        [Route("data/file/view/{fileName}")]
		public async Task<ActionResult> ViewFileInLocalStorageByName(string fileName)
		{
            try
            {
                List<UploadedFilesPoor> files = await UploadedFilesPoor.GetLocalStorageFilesByNameAsync(fileName);
                if (files == null || files.Count < 1)
                {
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(ViewFileInLocalStorageByName) + " -  file not found, fileName={0}", fileName);
                    }
                    return NotFound();
                }
                else if (files.Count == 1)
                {
                    UploadedFilesPoor file = files.First();
                    await CheckFileStructDivision(file); //throws PermissionException when invalid
                    string token = file.Id.ToString();
                    (Stream Stream, Dictionary<string, string> Properties) data = await CloverRuntime.ContentProvider.GetAsync(token);

                    (ActionResult result, ContentDisposition disposition) = ControllerFileHelper.FileResult(data.Stream, data.Properties, FileResultAction.View, FileResultAllow.LocalStorageOnly);
                    if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                    return result;
                }
                else
                {
                    throw new InvalidOperationException("Multiple files named {fileName} found");
                }
            }
            catch (PermissionException pex)
            {
                var _ = ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                logger.LogError(nameof(ViewFileInLocalStorageByName) + " - viewing local storage file denied , fileName={0}", fileName);

                return NotFound(); //404 instead of 403 as we don't even want to reveal existence of the file
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ViewFileInLocalStorageByName) + " - caught unexpected exception, fileName={0}", fileName);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

		[Route("data/download/{token}")]
        public async Task<ActionResult> DownloadFileByToken(string token)
        {
            if (!Guid.TryParse(token, out Guid fileId)) return BadRequest();
            try
            {
                UploadedFilesPoor file = await UploadedFilesPoor.SelectByKey(fileId);
                //TODO - currently there is no structDivisionId check here so any file can be downloaded by any intranet user if they know its Id (token)
                //       Going fwd we want a check here, but compication is there's no SDI applied on respondent uploaded files (I think we should apply the SDI of the survey they are responding to
                //       but also means we need a strategy to update existing data (eg for sims, vanilla sp etc))
                (Stream Stream, Dictionary<string, string> Properties) data = await CloverRuntime.ContentProvider.GetAsync(token);

                (ActionResult result, ContentDisposition disposition) = ControllerFileHelper.FileResult(data.Stream, data.Properties, FileResultAction.Download, FileResultAllow.AnyDownloadableFile);
                if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                return result;
            }
            catch (PermissionException pex)
            {
                var _ = ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                logger.LogError(nameof(DownloadFileByToken) + " - download file denied , token={0}", token);

                return NotFound(); //404 instead of 403 as we don't even want to reveal existence of the file
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadFileByToken) + " - caught unexpected exception, token={0}", token);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [Authorize]
        [Route("data/file/download/{fileName}")]
        public async Task<ActionResult> DownloadFileInLocalStorageByName(string fileName)
        {
            try
            {
                List<UploadedFilesPoor> files = await UploadedFilesPoor.GetLocalStorageFilesByNameAsync(fileName);
                if (files == null || files.Count < 1)
                {
                    return NotFound();
                }
                else if (files.Count == 1)
                {
                    UploadedFilesPoor file = files.First();
                    await CheckFileStructDivision(file); //throws PermissionException when invalid
                    string token = file.Id.ToString();
                    (Stream Stream, Dictionary<string, string> Properties) data = await CloverRuntime.ContentProvider.GetAsync(token);

                    (ActionResult result, ContentDisposition disposition) = ControllerFileHelper.FileResult(data.Stream, data.Properties, FileResultAction.Download, FileResultAllow.LocalStorageOnly);
                    if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                    return result;
                }
                else
                {
                    throw new InvalidOperationException("Multiple files named {fileName} found");
                }
            }
            catch(PermissionException pex)
            {
                var _ = ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
                logger.LogError(nameof(DownloadFileInLocalStorageByName) + " - download local storage file denied , fileName={0}", fileName);

                return NotFound(); //404 instead of 403 as we don't even want to reveal existence of the file
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadFileInLocalStorageByName) + " - caught unexpected exception, fileName={0}", fileName);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Throw a PermissionException if this file's struct division isn't under the current user
        /// </summary>
        /// <param name="file"></param>
        private async Task CheckFileStructDivision(UploadedFilesPoor file)
        {
            if (file == null) throw new ArgumentNullException(nameof(file));

            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            if(currentUser == null)
            {
                throw new PermissionException($"There is no current user when checking organisation access for file {file.Id} ({file.Name})");
            }
            else
            {
                bool ok = await currentUser.IsInStructDivisionAsync(file.StructDivisionId);
                if(!ok)
                {
                    throw new PermissionException($"User {currentUser.Id} ({currentUser.Name}) in structDivision {currentUser.StructDivisionId} does not have access to structDivision {file.StructDivisionId} required for file {file.Id} ({file.Name})");
                }
            } 
        }

        /// <summary>
        /// Endpoint for use with annex files (IsLocalStorage) only. Not intended for use with other types of file.
        /// Will add new files to the local storage or fail if that name is in use, or given the token id will update an existing local storage file in place.
        /// As a confirmation, and to support future enhancements, clientside is expected to pass an isLocalStorage header with "True", and this request will fail if that is not done. 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("data/file/upload")]
        public async Task<ActionResult> UploadNamedFileToLocalStorage()
        {
            User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
            if (!currentUser.IsInRole(Constants.Role.SurveyDesigner) 
                && !currentUser.IsInRole(Constants.Role.SurveyAdmin))
            {
                return Unauthorized();
            }
                    
            try
            {
                if (Request.Form.Files.Any())
                {
                    IFormFile uploadedFile = Request.Form.Files.First(); //nb: we only suport one file here. Extra files in the request will just be ignored (TODO - should we fail fast if there are extra?)
                    if (!Boolean.TryParse(Request.Headers[Constants.HeaderNames.isLocalStorage], out bool isLocalStorage)) return FileFieldFailResponse("Header " + Constants.HeaderNames.isLocalStorage + " missing or invalid");
                    if (isLocalStorage == false) throw new NotImplementedException("This endpoint is only for local file storage");

                    string tokenToUpdate = Request.Headers.ContainsKey(Constants.HeaderNames.updateFileId) ? Request.Headers[Constants.HeaderNames.updateFileId].FirstOrDefault() : null;
                    //validate the token format if present (but note that token used stays in string form to work with provider)
                    bool tokenSpecified = !string.IsNullOrWhiteSpace(tokenToUpdate);
                    Guid dwUploadedFileId = Guid.Empty;
                    if (tokenSpecified && !Guid.TryParse(tokenToUpdate, out dwUploadedFileId)) return FileFieldFailResponse("Invalid token to update");

                    string filename = uploadedFile.FileName;
                    if (!FileStorageApplication.IsValidFileName(filename)) return FileFieldFailResponse("Invalid File Name");
                    string fileContentType = uploadedFile.ContentType;
                    using (Stream stream = uploadedFile.OpenReadStream())
                    {
                        //Use a new dictionary for the properties, this implies any not set here won't be copied from the previous existing file (if any)
                        Dictionary<string, string> properties = new Dictionary<string, string>(); //new properties object, will use in Add/Update of the file
                        properties.Add(Constants.FileProperties.IsLocalStorage, isLocalStorage.ToString()); //In current impl this is always True
                        properties.Add(Constants.FileProperties.Name, filename); //nb: currently we will also check this matches existing and is valie
                        properties.Add(Constants.FileProperties.ContentType, fileContentType);
                        properties.Add(Constants.FileProperties.IsDownloadable, Boolean.TrueString);

                        bool updatingExistingFileInLocalStorage = tokenSpecified; //if client also gave token then we are trying to update that existing one
                        if (updatingExistingFileInLocalStorage)
                        {                            
                            (Stream Stream, Dictionary<string, string> Properties) data;
                            try
                            {
                                data = await CloverRuntime.ContentProvider.GetAsync(tokenToUpdate);
                            }
                            catch(Exception cantGetFileInDb)
                            {
                                //ContentDbProvider doesn't report 'not found' very well, so this might be due to that (NRE on item.Data dereference) or maybe its something else
                                throw new Exception("ContentProvider.GetAsync raised an exception retrieving file " + tokenToUpdate, cantGetFileInDb);
                            }
                            
                            string existingFilename = data.Properties.ContainsKey(Constants.FileProperties.Name) ? data.Properties[Constants.FileProperties.Name] : null;
                            string existingContentType = data.Properties.ContainsKey(Constants.FileProperties.ContentType) ? data.Properties[Constants.FileProperties.ContentType] : null;
                            bool existingIsLocalStorage = data.Properties.ContainsKey(Constants.FileProperties.IsLocalStorage) ? Boolean.Parse(data.Properties[Constants.FileProperties.IsLocalStorage]) : false;
                            if (existingIsLocalStorage==false)
                            {
                                throw new InvalidOperationException($"An attempt was made to update existing file {tokenToUpdate} via local storage api but it isn't an IsLocalStorage file");
                            }

                            bool existingFileInvalid = string.IsNullOrWhiteSpace(existingFilename) || string.IsNullOrWhiteSpace(existingContentType); //TODO is this check necessary?
                            if (existingFileInvalid) throw new InvalidOperationException($"Existing file {tokenToUpdate} isn't valid for update");

                            //Verify that the specified file is actually in the current user's struct divisions
                            UploadedFilesPoor dwUploadedFile = await UploadedFilesPoor.SelectByKey(dwUploadedFileId);
                            await CheckFileStructDivision(dwUploadedFile);

                            //Currently we require users to upload from file of same name
                            //TODO - when we have time consider the ux impact of being able to overwrite from file of different name (with the idea of keeping persisted name and ignoring upload name)
                            bool uploadedFilenameIsCorrect = filename.Equals(existingFilename); 
                            if (!uploadedFilenameIsCorrect) return FileFieldFailResponse("File update failed. Please update the file using the original name");

                            await CloverRuntime.ContentProvider.ReplaceAsync(tokenToUpdate, stream, properties);

                            logger.LogDebug("File Storage - Updated existing file {0} in local storage with filename {1}", tokenToUpdate, filename);

                        } //end if updatingExistingFileInLocalStorage
                        else
                        {
                            //create a new file record in database - provided there is no local storage file with that name already
                            bool nameAlreadyUsed = !Guid.Empty.Equals(await UploadedFilesPoor.GetLocalStorageIdByNameAsync(filename));
                            if (nameAlreadyUsed)
                            {
                                //TODO - currently we require that the filename be unique globally, but I think we could narrow this scope to the structDivision (with
                                //       a little thought as regards to hierarchy and which to use if user has multiple SDI. For respondent would need to be based on sample's mapped SDIs)

                                return FileFieldFailResponse("This filename is already in storage, please change the file name. To update the file please find the file and press update");
                                //TODO - going fowards a ux we could consider is replacing all the update button with a single one in the header (which could be the exsiting upload button) and prompting the user to
                                //       replace if it already exists, but in terms of pokayoke the current method has quite a bit of merit, so maybe keep it
                            }
                            else
                            {
                                string newFileToken = await CloverRuntime.ContentProvider.AddAsync(stream, properties);
                                logger.LogDebug("File Annex Storage - Created new file {0} in local storage with filename {1}", newFileToken, filename);
                            }


                        } //end else block for saving new file 
                        return Json(new ItemSuccessResponse<string>(filename, "Successful"));
                    } //end using file stream

                } //end if any files
                else
                {
                    return Json(new FailResponse("No any files in the request!"));
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadNamedFileToLocalStorage) + " - caught unexpected exception");
                return FileFieldFailResponse(Constants.Message.InternalErrorException);
            }           
        }

        /// <summary>
        /// Endpoint for fetching the completion url to redirect after clicking button "exit/cancel/save&exit".
        /// Return null as DataEditor do not redirect to completion url for now.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("data/completeurl")]
        public async Task<ActionResult> GetCompleteUrl()
        {
            //Intranet Data Editor will not redirect to completion URL
            return Json(new ItemSuccessResponse<Dictionary<string, object>>(null));
        }

        /// <summary>
        /// Return a response to indicate an error processing the file upload
        /// </summary>
        /// <param name="reason"></param>
        /// <returns></returns>
        private ActionResult FileFieldFailResponse(string reason)
        {
            //Although we are indicating an error condition
            //a success result is used here to workaround isues with the file control on the frontend,
            //this lets us pass back a message in place of a token, and our
            //clientside code can look at the message.
            //We've put this in its own method to make the intent clear in code that needs to do this
            return Json(new ItemSuccessResponse<string>(String.Empty, reason));
        }

        /// <summary>
        /// Check if the search constraint (i.e the strings passed for urlFilter, options, paging, sort) 
        /// are null or empty (including the uncased string literal "null" which can be passed from clientside)
        /// </summary>
        private static bool ConstraintsNotNullOrEmpty(string urlFilter)
        {
            return !string.IsNullOrEmpty(urlFilter) && !urlFilter.Equals("null", StringComparison.OrdinalIgnoreCase);
        }

        private static async Task<bool> HasStructAccess(string createdBy)
        {
            if (string.IsNullOrEmpty(createdBy)) return true;
            var su = await SecurityUser.SelectByKey(createdBy);
            if (su.StructDivisionId == null) return true;
            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            return childrenStructDivisionIds.Contains(su.StructDivisionId.Value);
        }

        private static async Task<bool> HasStructAccess(Guid? accessingStructDivisionId)
        {
            if (!accessingStructDivisionId.HasValue) return true;

            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();

            return childrenStructDivisionIds.Contains(accessingStructDivisionId.Value);
        }

        public string GetRequestIP(bool tryUseXForwardHeader = true)
        {
            string ipAddress = null;

            // todo support new "Forwarded" header (2014) https://en.wikipedia.org/wiki/X-Forwarded-For

            // X-Forwarded-For (csv list):  Using the First entry in the list seems to work
            // for 99% of cases however it has been suggested that a better (although tedious)
            // approach might be to read each IP from right to left and use the first public IP.
            // http://stackoverflow.com/a/43554000/538763
            //
            if (tryUseXForwardHeader)
                ipAddress = SplitCsv(GetHeaderValueAs<string>("X-Forwarded-For")).FirstOrDefault();

            // RemoteIpAddress is always null in DNX RC1 Update1 (bug).
            if (IsNullOrWhitespace(ipAddress) && Request.HttpContext?.Connection?.RemoteIpAddress != null)
                ipAddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            if (IsNullOrWhitespace(ipAddress))
                ipAddress = GetHeaderValueAs<string>("REMOTE_ADDR");

            // _httpContextAccessor.HttpContext?.Request?.Host this is the local host.

            if (IsNullOrWhitespace(ipAddress))
                throw new Exception("Unable to determine caller's IP.");

            return ipAddress;
        }

        public T GetHeaderValueAs<T>(string headerName)
        {
            StringValues values;

            if (Request.HttpContext?.Request?.Headers?.TryGetValue(headerName, out values) ?? false)
            {
                string rawValues = values.ToString();   // writes out as Csv when there are multiple.

                if (!IsNullOrWhitespace(rawValues))
                    return (T)Convert.ChangeType(values.ToString(), typeof(T));
            }
            return default(T);
        }
        public static List<string> SplitCsv(string csvList, bool nullOrWhitespaceInputReturnsNull = false)
        {
            if (string.IsNullOrWhiteSpace(csvList))
                return nullOrWhitespaceInputReturnsNull ? null : new List<string>();

            return csvList
                .TrimEnd(',')
                .Split(',')
                .AsEnumerable<string>()
                .Select(s => s.Trim())
                .ToList();
        }

        public static bool IsNullOrWhitespace(string s)
        {
            return String.IsNullOrWhiteSpace(s);
        }

        private static async Task<ClientFilterItem> GetCurrentUserStructDivisionsClientFilter(string name)
        {
            var monitoredModelNames = new List<string>
            {
                Constants.ModelName.vSP_dataEditors,
                Constants.ModelName.QNN_QNN,
                Constants.ModelName.QNN_DPLY,
                Constants.ModelName.QNN_CATEGORY,
                Constants.ModelName.QNN_LIST,
                Constants.ModelName.QNN_TRK_LIST,
                Constants.ModelName.vSP_ListWithCount,
                Constants.ModelName.vSP_QnnSampleActive,
                Constants.ModelName.vSP_StructDivision,
                Constants.ModelName.vSP_SurveyForm,
                Constants.ModelName.vSP_DeploymentOnline
            };

            if (!monitoredModelNames.Contains(name, StringComparer.InvariantCultureIgnoreCase))
                return null;
            var structDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId;
            var childrenStructDivisionIds =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                "ParentId"))).Select(p => p.Id).Distinct().ToList();
            if (!childrenStructDivisionIds.Any()) return null;
            //return Filter.And.In(childrenStructDivisionIds, "StructDivisionId");
            return new ClientFilterItem
            {
                Column = "StructDivisionId",
                Term = "in",
                Value = JArray.FromObject(childrenStructDivisionIds)
            };
        }
    }
}