using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.SurveyPlus.InternetApplication;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using IP2Country;
using Microsoft.Extensions.Caching.Memory;
using NetTools;
using Microsoft.Extensions.Primitives;
using swz.SurveyPlus.Application;
using System.IO;
using Microsoft.Net.Http.Headers;
using System.Net.Mime;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Internet application variant of the DataController. 
    /// Due to use of U@App and other internet side features this is significantly different to the intranet DataController.
    /// </summary>
    [CheckSessionFilter]
    public class DataController : Controller
    {
        private readonly ILogger logger;
        private readonly IMemoryCache cache;
        private readonly IRespondentService respondentService;
        private readonly WogaaSettings wogaa;
        private readonly AntiVirusSettings antiVirus;
        private readonly PrintSettings printSettings;

        public DataController(
            ILogger<DataController> logger,
            IMemoryCache cache,
            WogaaSettings wogaa,
            IRespondentService respondentService,
            AntiVirusSettings antiVirus,
            PrintSettings printSettings)

        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.cache = cache ?? throw new ArgumentNullException(nameof(cache));
            this.wogaa = wogaa ?? throw new ArgumentNullException(nameof(wogaa));
            this.respondentService = respondentService ?? throw new ArgumentNullException(nameof(respondentService));
            this.antiVirus = antiVirus ?? throw new ArgumentNullException(nameof(antiVirus));
            this.printSettings = printSettings ?? throw new ArgumentNullException(nameof(printSettings));
        }

        [CheckFormNameFilter]
        [AllowAnonymous]
        [Route("data/get")]
        public async Task<ActionResult> GetData([FromServices] IDataSource dataSource, string name, string control, string urlFilter, string options,
            string filter, string paging, string sort)
        {

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(GetData) + " - name={0}, control={1}, urlFilter={2}, options={3}, filter={4}, paging={5}, sort={6},", name, control, urlFilter, options, filter, paging, sort);
            }

            if (dataSource == null) throw new ArgumentNullException(nameof(dataSource));

            if ("respdashboard".Equals(name, StringComparison.OrdinalIgnoreCase) &&
                SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
            {
                return StatusCode(403, Constants.Message.YouDontHaveThePermission);
            }

            string idValue = null;
            try
            {
                string cookie = string.Join(";",
                    Request.Cookies.Select(c => $"{c.Key}={c.Value}"));

                string filterActionName = null;
                var filterItems = new List<ClientFilterItem>();

                if (ConstraintsNotNullOrEmpty(urlFilter))
                {
                    try
                    {
                        filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(urlFilter));
                    }
                    catch
                    {
                        var filterActions = CloverRuntime.ServerActions.GetFilterNames().Where(n => n.Equals(urlFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                        string filterAction = null;
                        filterAction = filterActions.Count == 1 ? filterActions.First() 
                            : filterActions.FirstOrDefault(n => n.Equals(urlFilter, StringComparison.Ordinal));
                        
                        if (!string.IsNullOrEmpty(filterAction))
                            filterActionName = filterAction;
                        else
                        {
                            idValue = urlFilter;
                        }
                    }
                }

                if (ConstraintsNotNullOrEmpty(filter))
                {
                    filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(filter));
                }

                GetDataRequest getRequest = new GetDataRequest(name)
                {
                    RequestingControlName = control,
                    FilterActionName = filterActionName,
                    IdValue = idValue,
                    Filter = filterItems,
                    //BaseUrl = _configuration["Clover:WebApiBase"], //<--- this is now set in the respondent service (see below)
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie", cookie);
                        dataUrlParameters.Add("referer", Request.Headers["Referer"]);
                        return dataUrlParameters;
                    }
                };

                if (ConstraintsNotNullOrEmpty(options))
                {
                    getRequest.OptionsDictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(options);
                } 

                if(getRequest.OptionsDictionary == null)
                {
                    getRequest.OptionsDictionary = new Dictionary<string, object>(); 
                }
                                
                if (ConstraintsNotNullOrEmpty(paging))
                {
                    getRequest.Paging = JsonConvert.DeserializeObject<ClientPaging>(paging);
                }

                if (ConstraintsNotNullOrEmpty(sort))
                {
                    getRequest.Sort = JsonConvert.DeserializeObject<List<ClienSortItem>>(sort);
                }

                getRequest = respondentService.PrepareGetRequest(getRequest); //ensure correct baseUrl etc....
                (DynamicEntity Entity, bool IsFromUrl) data = await dataSource.GetDataForFormAsync(getRequest).ConfigureAwait(false);
                
                if (data.IsFromUrl && FailResponse.IsFailResponse(data.Entity, out FailResponse fail))
                {
                    return Json(fail);
                }

                //Troubleshooting info for a particular error condition I have been encountering
                if ("respdashboard".Equals(name, StringComparison.OrdinalIgnoreCase) && 
                    ("currentSurveyCard".Equals(control, StringComparison.OrdinalIgnoreCase) || "currentSurveyCard".Equals(control, StringComparison.OrdinalIgnoreCase))
                    && !string.IsNullOrEmpty(control))
                {
                    object controlEntityData = data.Entity[control];
                    if (controlEntityData == null)
                    {
                        //The grids in respdashboard will be empty. One thing to check is the respdashboard-settings (etc) in dwMetadata
                        logger.LogCritical("data.Entity[control] is null for control {0} of {1}", control, name);
                    }
                }
                
                //TODO - FOLLOWING TO USE IPRestrictionLogic (note that it iterates multiple entities, so may need some refactoring)
                //IP restriction logic
                var iP2CountryResolver = cache?.Get<IP2CountryResolver>("IP2CountryResolverCache");

                if (iP2CountryResolver!=null && name.Equals("respdashboard", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(control))
                {
                    //TODO - review the error handling and its associated logging below
                    //       most of the places that catch errors allow the execution to continue
                    //       Is this correct?
                    //       If so, perhaps they should log at Warning level instead of Error?
                    try
                    {
                        if (data.Entity[control] != null && (control.Equals("currentSurveyCard", StringComparison.OrdinalIgnoreCase) || control.Equals("previousSurveyCard", StringComparison.OrdinalIgnoreCase)))
                        {
                            var ipAddress = HttpContext.Connection.RemoteIpAddress;
                            var country = iP2CountryResolver.Resolve(ipAddress)?.Country;

                            var dictData = (List<DynamicEntity>)data.Entity[control];
                            var result = new List<DynamicEntity>();
                            foreach (var entity in dictData)
                            {
                                try
                                {
                                    if ((bool?)entity["RestrictIp"] == true)
                                    {
                                        if (entity["IpCountry"] == null && entity["IpRange"] == null)
                                        {
                                            entity["IpAllowed"] = true;
                                            result.Add(entity);
                                            continue;
                                        }
                                        entity["IpAllowed"] = false;
                                        if ((bool?)entity["RestrictIpInclusive"] == true)
                                        {

                                            if (entity["IpCountry"] != null) //if db has country set, but ip is local/reserved ip, add it; or country matched, add it;
                                            {
                                                var ipCountries = JsonConvert.DeserializeObject<List<string>>(entity["IpCountry"].ToString());
                                                if (country == null || ipCountries.Contains(country, StringComparer.OrdinalIgnoreCase))
                                                {
                                                    entity["IpAllowed"] = true;
                                                }

                                            }
                                            else if (entity["IpRange"] != null)
                                            {

                                                var ipRanges = JsonConvert.DeserializeObject<List<string>>(entity["IpRange"].ToString());
                                                foreach (string ipRange in ipRanges)
                                                {
                                                    try
                                                    {
                                                        var rangeA = IPAddressRange.Parse(ipRange);
                                                        if (rangeA.Contains(ipAddress))
                                                        {
                                                            entity["IpAllowed"] = true;
                                                            break;
                                                        }

                                                        entity["IpAllowed"] = false;

                                                    }
                                                    catch (Exception e)
                                                    {
                                                        logger.LogError(e, nameof(GetData) + " - [A] caught exception checking IP range {0}", ipRange);
                                                        //TODO - is it ok to just continue like this? (ignore bad range?)
                                                    }

                                                }

                                            }
                                        }
                                        else
                                        {
                                            if (entity["IpCountry"] != null)
                                            {
                                                var ipCountries = JsonConvert.DeserializeObject<List<string>>(entity["IpCountry"].ToString());
                                                if (country == null || !ipCountries.Contains(country, StringComparer.OrdinalIgnoreCase))
                                                {
                                                    entity["IpAllowed"] = true;
                                                }

                                            }
                                            else if (entity["IpRange"] != null)
                                            {
                                                try
                                                {
                                                    var ipRanges = JsonConvert.DeserializeObject<List<string>>(entity["IpRange"].ToString());
                                                    foreach (var ipRange in ipRanges)
                                                    {
                                                        try
                                                        {
                                                            var rangeA = IPAddressRange.Parse(ipRange);
                                                            if (rangeA.Contains(ipAddress))
                                                            {
                                                                entity["IpAllowed"] = false;
                                                                break;
                                                            }
                                                            entity["IpAllowed"] = true;
                                                        }
                                                        catch (Exception e)
                                                        {
                                                            logger.LogError(e, nameof(GetData) + " - [B] caught exception checking IP range {0}", ipRange);
                                                            //TODO - is it ok to just continue like this? (ignore bad range?)
                                                        }

                                                    }

                                                }
                                                catch (Exception e)
                                                {
                                                    //20220824AH - Adding a log at warning level here for now
                                                    //TODO - the code for IP here needs to be reconsiled with IPRestrictionLogic!
                                                    logger.LogWarning(e, nameof(GetData) + " - [A] caught exception in IP check");
                                                    entity["IpAllowed"] = true;
                                                }

                                            }
                                        }

                                    }
                                    else
                                    {
                                        entity["IpAllowed"] = true;
                                    }

                                }
                                catch (Exception e)
                                {
                                    entity["IpAllowed"] = true;
                                    logger.LogError(e, nameof(GetData) + " - [B] caught exception in IP check");
                                }

                                result.Add(entity);
                            }

                            data.Entity[control] = result;
                        }
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(GetData) + " - [C] caught exception in IP check");
                    }

                }
                bool isLoadingRespData = (name != null && name != "respdashboard");
                if (isLoadingRespData)
                {
                    data.Entity["IsSurvey"] = true;
                    data.Entity["wogaaEnable"] = wogaa.Enable;
                    data.Entity["wogaaTransactionalServiceOn"] = wogaa.TransactionalServiceOn;
                    data.Entity["wogaaTransactionalTrackingId"] = wogaa.TransactionalTrackingId;
                }
                data.Entity["isInternetApplication"] = true;
                data.Entity["backendPrintEnable"] = printSettings.IsRespdashboardPrintEnabled;
                data.Entity["IsPDFExportForSubmittedOnly"] = printSettings.IsPDFExportForSubmittedOnly;
                if (data.Entity["message"] != null) return Json(new ItemSuccessResponse<object>(data.Entity.ToDictionary(true), data.Entity["message"].ToString()));
                return Json(new ItemSuccessResponse<object>(data.Entity.ToDictionary(true)));
            }
            catch(SessionInvalidException)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(GetData) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetData) + " - caught unexpected exception, name={0}, control={1}", name, control );

                string errorMessage = Constants.Message.InternalErrorException;

                //This api method "GetData" is used by many processes, here is to determine and provide proper error message corresponding to the process.
                //idValue == "respid" is to determine the api call is retrieving survey data.
                //Might not be accurate if there are other process use the same pattern
                if (!string.IsNullOrEmpty(idValue) && idValue == "respid" && string.IsNullOrEmpty(paging) && string.IsNullOrEmpty(sort))
                {
                    errorMessage = Constants.Message.GetSurveyDataFailed;
                }

                return Json(new FailResponse(errorMessage));
            }
        }

        [Route("data/change")]
        [HttpPost]
        public async Task<ActionResult> ChangeData([FromServices]IDataSource dataSource, string name, string data)
        {
            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ChangeData) + " - name={0}", name);
            }

            if (dataSource == null) throw new ArgumentNullException(nameof(dataSource));

            try
            {
                var ipAddress = GetRequestIP();
				string cookie = string.Join(";",
                    Request.Cookies.Select(c => $"{c.Key}={c.Value}"));
                ChangeDataRequest postRequest = new ChangeDataRequest(name, data)
                {
                    BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value),
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie",cookie);
                        dataUrlParameters.Add("referer", Request.Headers["Referer"]);
                        dataUrlParameters.Add("savedraft", Request.Headers["savedraft"]);
                        dataUrlParameters.Add("ipaddress", ipAddress);
                        dataUrlParameters.Add("timestamp", Request.Headers["timestamp"]);
                        dataUrlParameters.Add("autosave", Request.Headers["autosave"]);

                        return dataUrlParameters;
                    }
                };

                (FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success) res = await dataSource.ChangeData(postRequest);
                if (res.success != null)
                    return Json(res.success); //FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success
                return Json(res.fail);
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(ChangeData) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ChangeData) + " - caught unexpected exception, name={0}", name);

                return Json(new FailResponse("The attempt was not successful."));
            }
        }

        [HttpPost]
        [Route("data/upload")]
        public async Task<ActionResult> UploadFile()
        {
            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(UploadFile) + " - called");
            }

            try
            {
                if (Request.Form.Files.Count > 0)
                {
                    string uid = SurveyPlusInternet.GetUid(HttpContext.Session);
                    IFormFile formFile = Request.Form.Files[0];
                    using (Stream stream = formFile.OpenReadStream())
                    {
                        StreamWithName file = new StreamWithName(stream, formFile.ContentType, formFile.FileName);
                        string token = await respondentService.UploadRespondentFileAsync(uid, file);
                        return Json(new SuccessResponse(token));
                    }
                }
                else
                {
                    //TODO - consider if we should raise or log an error here (does the ui send us here under any normal circumstance?)
                }
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(UploadFile) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (VirusDetectedException e)
            {
                return Json(new FailResponse(e.Message));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UploadFile) + " - caught unexpected exception");

                return Json(new FailResponse("The attempt was not successful."));
            }

            return Json(new FailResponse("No any files in the request!"));
        }

        /// <summary>
        /// Legacy Endpoint to support forms that still have token based urls for linked files in the file storage
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [Route("data/view/{token}")]
		public async Task<ActionResult> ViewFileInLocalStorageByToken(string token)
		{
            if (string.IsNullOrWhiteSpace(token)) return BadRequest();

            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ViewFileInLocalStorageByToken) + " - token={0}", token);
            }

            try
		    {
                //TODO - currently this doesn't check structDivisionId, but annex files will still have IsLocalStorage.
                //       GetFileDataByTokenAsync doesn't provide SDI checking services, and doesn't return the file's SDIs. 

                FileData file = await respondentService.GetFileDataByTokenAsync(token);
                (ActionResult result, ContentDisposition disposition) = FileResult(file, FileResultAction.View, FileResultAllow.LocalStorageOnly);
                if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                return result;
            }
            catch (FileNotFoundException)
            {
                return NotFound(); 
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(ViewFileInLocalStorageByToken) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (PermissionException)
            {
                return NotFound(); //use 404 instead of 403 so as not to reveal file exists
            }
            catch (Exception e)
		    {
                logger.LogError(e, nameof(ViewFileInLocalStorageByToken) + " - caught unexpected exception for token={0}", token);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
		} 

        [Route("data/file/view/{fileName}")]
        public async Task<ActionResult> ViewFileInLocalStorageByName(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName)) return BadRequest();

            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ViewFileInLocalStorageByToken) + " - name={0}", fileName);
            }

            try
            {
                if (!SurveyPlusInternet.IsLoggedIn(HttpContext))
                    throw new PermissionException("Not logged in");
                Guid sampleId = SurveyPlusInternet.GetSampleId(HttpContext.Session);

                FileData file = await respondentService.GetLocalStorageFileDataByNameAsync(fileName, sampleId);
                (ActionResult result, ContentDisposition disposition) = FileResult(file, FileResultAction.View, FileResultAllow.LocalStorageOnly);
                if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                return result;
            }
            catch (FileNotFoundException)
            {
                return NotFound(); 
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(ViewFileInLocalStorageByName) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (PermissionException pe)
            {
                logger.LogError(pe, nameof(ViewFileInLocalStorageByName) + " - viewing local storage file denied for {0}", fileName);
                return NotFound(); //404 instead of 403 as we don't even want to reveal existence of the file
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ViewFileInLocalStorageByName) + " - caught unexpected exception, fileName={0}", fileName);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        } 

        //TODO - should this be named DownloadFileInLocalStorageByToken? (confirm its 'local storage' specific)
		[Route("data/download/{token}")]
		public async Task<ActionResult> DownloadFileByToken(string token)
		{

            //This is still used in file fields for respondent's files and in legacy URLS for file storage annex files downloads.
            //TODO - migrate and end support for the legacy urls

            if (string.IsNullOrWhiteSpace(token)) return BadRequest();

            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DownloadFileByToken) + " - token={0}", token);
            }

            try
		    {
                FileData file = await respondentService.GetFileDataByTokenAsync(token);
                (ActionResult result, ContentDisposition disposition) 
                    = FileResult(file, FileResultAction.Download, FileResultAllow.AnyDownloadableFile);
                if (disposition != null)
                {
                    Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                }
                return result;
            }
            catch(FileNotFoundException)
            {
                return NotFound();
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(DownloadFileByToken) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (PermissionException)
            {
                return StatusCode(StatusCodes.Status403Forbidden);
            }
		    catch (Exception e)
		    {
                logger.LogError(e, nameof(DownloadFileByToken) + " - caught unexpected exception, token={0}", token);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
		}

        [Route("data/file/download/{fileName}")]
        public async Task<ActionResult> DownloadFileInLocalStorageByName(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName)) return BadRequest();

            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(DownloadFileInLocalStorageByName) + " - fileName={0}", fileName);
            }

            try
            {
                if (!SurveyPlusInternet.IsLoggedIn(HttpContext))
                    throw new PermissionException("Not logged in");
                Guid sampleId = SurveyPlusInternet.GetSampleId(HttpContext.Session);
                
                FileData file = await respondentService.GetLocalStorageFileDataByNameAsync(fileName, sampleId);
                (ActionResult result, ContentDisposition disposition) 
                    = FileResult(file, FileResultAction.Download, FileResultAllow.LocalStorageOnly);
                if (disposition != null)
                {
                    Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                }
                return result;
            }
            catch (FileNotFoundException)
            {
                return NotFound();
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(DownloadFileByToken) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (PermissionException)
            {
                return StatusCode(StatusCodes.Status403Forbidden);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DownloadFileInLocalStorageByName) + " - caught unexpected exception, fileName={0}", fileName);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        /// <summary>
        /// Endpoint for fetching the completion url to redirect after clicking button "exit/cancel/save&exit".
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("data/completeurl")]
        public async Task<ActionResult> GetCompleteUrl()
        {
            try
            {
                Uri referer = ControllerUtilities.Referer(Request);
                string dlsiUriSegmentString = referer.Segments?[referer.Segments.Length - 1];
                if (!Guid.TryParse(dlsiUriSegmentString, out Guid dlsi)) return BadRequest();

                string completeUrl = await respondentService.GetCompletionUrl(dlsi);

                Dictionary<string, object> result = new Dictionary<string, object>();
                result.Add(Constants.SurveyResponseProperties.SurveyRedirectUrl, completeUrl);

                return Json(new ItemSuccessResponse<Dictionary<string, object>>(result));
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(GetCompleteUrl) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndReturnFailResponse(HttpContext);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetCompleteUrl) + " - caught unexpected exception");
                return Json(new { success = false, result = false, message = Constants.Message.InternalErrorException });
            }
        } 

        private (ActionResult,ContentDisposition) FileResult(FileData file, FileResultAction action, FileResultAllow allow)
        {
            Stream stream = file.Content;
            Dictionary<string, string> properties = file.Properties;
            return ControllerFileHelper.FileResult(stream, properties, action, allow); 
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
            if (String.IsNullOrWhiteSpace(ipAddress) && Request.HttpContext?.Connection?.RemoteIpAddress != null)
                ipAddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            if (String.IsNullOrWhiteSpace(ipAddress))
                ipAddress = GetHeaderValueAs<string>("REMOTE_ADDR");

            // _httpContextAccessor.HttpContext?.Request?.Host this is the local host.

            if (String.IsNullOrWhiteSpace(ipAddress))
                throw new Exception("Unable to determine caller's IP.");

            return ipAddress;
        }

        private T GetHeaderValueAs<T>(string headerName)
        {
            StringValues values;

            if (Request.HttpContext?.Request?.Headers?.TryGetValue(headerName, out values) ?? false)
            {
                string rawValues = values.ToString();   // writes out as Csv when there are multiple.

                if (!String.IsNullOrWhiteSpace(rawValues))
                    return (T)Convert.ChangeType(values.ToString(), typeof(T));
            }
            return default(T);
        }

        private List<string> SplitCsv(string csvList, bool nullOrWhitespaceInputReturnsNull = false)
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

        /// <summary>
        /// Check if the search constraint (i.e the strings passed for urlFilter, options, paging, sort) 
        /// are null or empty (including the uncased string literal "null" which can be passed from clientside)
        /// </summary>
        private bool ConstraintsNotNullOrEmpty(string urlFilter)
        {
            return !string.IsNullOrEmpty(urlFilter) && !urlFilter.Equals("null", StringComparison.OrdinalIgnoreCase);
        }

    }
}