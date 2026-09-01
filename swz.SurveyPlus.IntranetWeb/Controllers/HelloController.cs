using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.AspNetCore.Http;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.Clover.Core.Utils;
using CsvHelper;
using System.IO;
using System.Linq;
using swz.Clover.Core.Model;
using System.Threading.Tasks;
using System.Globalization;
using CsvHelper.Configuration;
using swz.Clover.Core.License;
using System.Web;
using swz.SurveyPlus.IntranetApplication;
using swz.SurveyPlus.Application;
using swz.Clover.Security.Providers;
using swz.Clover.Core.Security;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Configuration;
using Microsoft.Net.Http.Headers;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// Various live troubleshooting endpoints
    /// </summary>
	public class HelloController : Controller
	{
        private readonly ILogger logger;
        private readonly HelloControllerOptions options;

		public HelloController(
            ILogger<HelloController> logger,
            HelloControllerOptions options)
		{
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.options = options ?? throw new ArgumentNullException(nameof(options));
        }

        //note: if windows authentication is enabled and there is a license problem then you will need to use
        //      an incognito window or clear auth cookie to get here, otherwise the AuthorizationFilter will
        //      reject the request and never route here.
        [AllowAnonymous]
        [HttpGet]
        [Route("debug/license")]
        public async Task<ActionResult> GetDebugLicense(string accessCode)
        {
            try
            {
                if (!options.IsEnableDebugLicense) 
                    throw new PermissionException(nameof(GetDebugLicense) + " is not enabled");
                if(!options.DebugLicenseAccessCode.Equals(accessCode, StringComparison.InvariantCultureIgnoreCase))
                    throw new PermissionException("Incorrect accessCode");

                logger.LogInformation(nameof(GetDebugLicense) + " - returning license information");

                StringBuilder b = new StringBuilder();
                b.Append("<p>");
                AppendInfo(b, "Validated", CloverRuntime.LicenseControl.Validated.ToString());
                AppendInfo(b, "Message", CloverRuntime.LicenseControl.Message);
                AppendInfo(b, "Host for Licensing", CloverRuntime.LicenseControl.Host);
                AppendInfo(b, "Current Host", Request.Host.Value);
                AppendInfo(b, "Install Code", HardwareInfo.Value());
                AppendInfo(b, "Active License", LicenseHelper.CloverLicenseDescription());
                b.Append("</p>");

                b.Replace("\n", "\n<br />");

                string target = $"/debug/license?accessCode={HttpUtility.UrlEncode(options.DebugLicenseAccessCode)}";
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content
                        = "<html><head><title>SurveyPlus License</title></head><body style=\"font-family: monospace\"><h1>License Information</h1>"
                        + $"<form method='post' action='{target}'>"
                        + b.ToString()
                        + $"<br/><input type='submit' value='Reload License from {HttpUtility.HtmlEncode(SecurityProvider.licensefile)}' />"
                        + $"</form></body></html>"
                };
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetDebugLicense) + " - caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 500,
                    Content = $"<html><body><h1>Error</h1>License information not available, check log for error details</body></html>"
                };
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("debug/license")]
        public async Task<ActionResult> PostDebugLicense(string accessCode)
        {
            string viewUrl = $"/debug/license?accessCode={HttpUtility.UrlEncode(options.DebugLicenseAccessCode)}";
            try
            {
                if (!options.IsEnableDebugLicense)
                    throw new PermissionException(nameof(GetDebugLicense) + " is not enabled");
                if (!options.DebugLicenseAccessCode.Equals(accessCode, StringComparison.InvariantCultureIgnoreCase))
                    throw new PermissionException("Incorrect accessCode");

                string host = Request.Host.Value; //see also: https://stackoverflow.com/questions/18303334/request-url-host-vs-request-url-authority
                logger.LogInformation(nameof(PostDebugLicense) + " - reloading license from {0}, Host for licensing is {1}", SecurityProvider.licensefile, host);
                
                string licenseText = System.IO.File.ReadAllText(SecurityProvider.licensefile);
                CloverRuntime.LicenseControl.Host = host;
                CloverRuntime.RegisterLicense(licenseText);
                CloverRuntime.LicenseControl.Validated = true;

                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 500,
                    Content = $"<html><body><h1>Licence Reloaded</h1><a href='{viewUrl}'>Click here to view information</a></body></html>"
                };
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PostDebugLicense) + " - caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 500,
                    Content 
                        = $"<html><body><h1>Error</h1>Failed to register license, check log for error details<br>"
                        + $"<a href='{viewUrl}'>Click here to view information</a></body></html>"
                };
            }
        }

        //TODO - the below may not be up to date now. Consider either updating it or removing it entirely
        [Authorize]
        [HttpGet]
        [HttpPost]
        [Route("debug/importSingleResponse")]
        public async Task<ActionResult> ImportSingleResponse(string dlsi)
        {
            if (!CloverRuntime.Security.CurrentUser.IsInRole(Constants.Role.Admins)) return Forbid();

            try
            {
                if ("GET" == Request.Method)
                {
                    StringBuilder b = new StringBuilder();
                    b.Append("<html><head><title>importSingleResponse</title></head>");
                    b.Append("<body><form method='post' enctype='multipart/form-data'>");
                    b.Append("<h1>Import Single Response</h1>");
                    b.Append("DLSI: <input type='text' name='dlsi' /><br/>"); //value='E6FCE76D-1E02-4786-9C47-B24BB7463362'
                    b.Append("CSV: <input type='file' name='csv' /><br/>");
                    b.Append("<input type='submit' value='Submit' />");
                    b.Append("</form?</body></html");
                    //consider adding last saved page?
                    return new ContentResult
                    {
                        ContentType = "text/html",
                        StatusCode = 200,
                        Content = b.ToString(),
                    };
                }
                else if ("POST" == Request.Method)
                {
                    EntityModel qnnDplySampleInfoModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.DeepFetchJoins);

                    EntityModel qnnRespModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

                    EntityModel qnnRespAnsModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP_ANS, Constants.Level.NoJoins);

                    EntityModel qnnQnnFieldModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);

                    DynamicEntity dplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(Filter.And.Equal(Guid.Parse(dlsi), Constants.FieldName.Id)))
                        .FirstOrDefault();
                    if (dplySampleInfo == null) return BadRequest("dlsi not found");

                    string uid = (string)dplySampleInfo["ListSampleId_SampleId_UID"];
                    Guid qnnId = (Guid)dplySampleInfo["DplyId_QnnId"];
                    Guid dplyId = (Guid)dplySampleInfo[Constants.FieldName.DplyId];
                    Guid listSampleId = (Guid)dplySampleInfo[Constants.FieldName.ListSampleId];
                    ILookup<string, DynamicEntity> fields 
                        = (await qnnQnnFieldModel.GetAsync(Filter.And.Equal(qnnId, Constants.FieldName.QnnId)))
                            .ToLookup(f => (string)f[Constants.FieldName.Name]);

                    IFormFile file = Request.Form.Files.FirstOrDefault();
                    if (file == null) return BadRequest();
                    string[] columns;
                    List<dynamic> dynRows;
                    using (Stream stream = file.OpenReadStream())
                    {
                        //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                        CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.CurrentCulture)
                        {
                            HasHeaderRecord = true,
                        };
                        using (CsvReader csv = new CsvReader(new StreamReader(stream), csvConfiguration))
                        {
                            csv.Read();
                            csv.ReadHeader();
                            dynRows = csv.GetRecords<dynamic>().ToList();
                            columns = csv.HeaderRecord;
                        }
                    }

                    //Find the row for the appropriate UID (assuming there's only one, so not multi response!)
                    //We need it as a dictionary so we can access by column name 
                    //see also: https://stackoverflow.com/questions/41780522/dynamically-read-properties-from-c-sharp-expando-object
                    //This *should* be possible with one line of linq , but I can't get it to work :-(
                    IDictionary<string, object> row = null;
                    foreach (dynamic dynRow in dynRows)
                    {
                        IDictionary<string, object> rowDict = (IDictionary<string, object>)dynRow;
                        string rowUid = (string)rowDict[" UID"];
                        if (uid.Equals(rowUid, StringComparison.InvariantCultureIgnoreCase))
                        {
                            row = rowDict; 
                            break;
                        }
                    }
                    if (row == null) return BadRequest($"Did not find response for {uid} in file");

                    //TODO - do the work in a SharedTransaction

                    Filter filterResponsesForDlsi = Filter.And
                        .Equal(dplyId, Constants.FieldName.DplyId)
                        .Equal(listSampleId, Constants.FieldName.ListSampleId)
                        .Equal(qnnId, Constants.FieldName.QnnId);
                    List<object> responsesToDelete = (await qnnRespModel.GetAsync(filterResponsesForDlsi))
                        .Select(resp => (object)(Guid)resp[Constants.FieldName.Id])
                        .ToList();
                    await qnnRespModel.DeleteAsync(responsesToDelete);

                    DynamicEntity qnnResp = await qnnRespModel.NewAsync();
                    qnnResp[Constants.FieldName.DplyId] = dplyId;
                    qnnResp[Constants.FieldName.QnnId] = qnnId;
                    qnnResp[Constants.FieldName.ListSampleId] = listSampleId;
                    qnnResp[Constants.FieldName.InitialResponseAs] = Constants.ResponseAs.Form;
                    qnnResp[Constants.FieldName.InitialResponseBy] = Constants.ResponseBy.Editor;
                    qnnResp[Constants.FieldName.InitialResponseVia] = Constants.ResponseVia.Online;
                    qnnResp[Constants.FieldName.IsExcelResponseDE] = false;
                    //TODO - DateStart, DateComplete etc
                    await qnnRespModel.UpdateSingleAsync(qnnResp);
                    Guid respId = (Guid)qnnResp[Constants.FieldName.Id];

                    List <dynamic> answers = new List<dynamic>();
                    foreach (string column in columns)
                    {
                        if(!column.StartsWith(" "))
                        {
                            DynamicEntity field = fields[column].FirstOrDefault();
                            if(field != null)
                            {
                                string value = (string)row[column]; //todo, nulls ?
                                DynamicEntity qnnRespAns = await qnnRespAnsModel.NewAsync();
                                qnnRespAns[Constants.FieldName.RespId] = respId;
                                qnnRespAns[Constants.FieldName.QnnFieldId] = (Guid)field[Constants.FieldName.Id];
                                qnnRespAns[Constants.FieldName.AnsVal] = value;
                                answers.Add(qnnRespAns);
                            }
                        }
                    }
                    await qnnRespAnsModel.UpdateAsync(answers);


                    return StatusCode(200, "OK");
                }

                return BadRequest();
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(ImportSingleResponse) + " - caught unexpected exception");
                return StatusCode(500, e.Message);
            }
        }

        /// <summary>
        /// Set a test value in the session.
        /// (This can be useful when testing / troubleshooting 
        /// session storage to make sure there is something in session)
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [HttpPost]
        [Route("debug/settestsessionvalue")]
        public ActionResult SetTestSessionValue()
        {
            string key = "testsessionvalue"; // + Guid.NewGuid().ToString();
            HttpContext.Session.SetString(key, "Hello it is " + DateTime.Now.ToLongDateString());
            return new ContentResult
            {
                ContentType = "text/html",
                StatusCode = 200,
                Content = $"<html><head>OK, set {key}={HttpContext.Session.GetString(key)}</body></html>"
            };
        }


        [Authorize]
        [HttpGet]
        [HttpPost]
        [Route("hello")]
        [Route("debug/hello")]
        public ActionResult HelloWorld()
        {
            try
            {
                StringBuilder b = new StringBuilder();

                b.Append("<p>");
                b.Append("<h2>REQUEST:</h2>");
                AppendInfo(b, "Protocol", Request.Protocol);
                AppendInfo(b, "Scheme", Request.Scheme);
                AppendInfo(b, "Host", Request.Host.ToString());
                AppendInfo(b, "PathBase", Request.PathBase);
                AppendInfo(b, "Path", Request.Path);

                try
                {
                    AppendInfo(b, "rawTarget", ControllerUtilities.GetRawTarget(HttpContext));
                }
                catch(Exception e)
                {
                    b.AppendLine($"<i>rawTarget not available, reason={HttpUtility.HtmlEncode(e.Message)}</i>");
                }                
                b.AppendLine();
                b.Append("</p>");

                b.Append("<p>");
                AppendHeaders(b);

                b.Append("<p>");
                b.Append("<h2>ADDITIONAL INFORMATION:</h2>");

                //n.b for identity I didn't want to hit the Clover Security object in Hello
                //(20231127 - but why, even with a try/catch cannot? (Was it to do with licensing check  - but
                //still need to get past that to login and reach this endpoint)
                System.Security.Principal.IIdentity identity = HttpContext.User.Identity;
                string identityType = (identity == null) ? "null" : identity.GetType().ToString();
                AppendInfo(b, "Identity Type", identityType);
                AppendInfo(b, "Identity.Name", identity?.Name); //for AD login would be name IIS presented to us for Windows Auth
                AppendInfo(b, "Identity.IsAuthenticated", ""+identity?.IsAuthenticated);

                LogLevel logLevel = DefaultApplicationLogging.GetEnabledLogLevel(logger);
                AppendInfo(b, "LogLevel", logLevel.ToString());
                AppendInfo(b, "Logger Type", logger.GetType().FullName);

                //See: https://stackoverflow.com/a/58136318
                Version netCoreVer = System.Environment.Version;
                string runtimeVer = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription;
                AppendInfo(b, "System.Environment.Version", netCoreVer.ToString());
                AppendInfo(b, "RuntmeInformation.FrameworkDescription", runtimeVer);

                AppendInfo(b, "CurrentCulture", CultureInfo.CurrentCulture.ToString());
                AppendInfo(b, "TimeZone", TimeZoneInfo.Local.ToString());
                AppendInfo(b, "Time", DateTime.Now.ToString(Constants.QnnDatetimeFormat));

                b.Append("</p>");

                b.Replace("\n", "\n<br />"); //originally I was using a pre, but is now html, TODO - use explicit br above 
                string dump = b.ToString();
                logger.LogInformation("Call to Hello, Protocol={0}, Host={1}, Path={2}, Identity Type={3}, Identity.Name={4}, Identity.IsAuthenticated={5}", Request.Protocol, Request.Host, Request.Path, identity?.GetType(), identity?.Name, identity?.IsAuthenticated);
                logger.LogTrace(dump); //unfortunately this will be dumping html now, hopefully don't need to use it

                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content = $"<html><head><title>SurveyPlus HelloWorld</title></head><body style=\"font-family: monospace\"><h1>Hello World</h1><a href=\"/\">Return to application</a><br/><span>\n{dump}\n</span></body></html>"
                };
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(HelloWorld) + " -  caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 500,
                    Content = $"<html><head><title>SurveyPlus HelloWorld</title></head><body>Hello World<br/><pre>\n{Constants.Message.InternalErrorException}\n</pre></body></html>"
                };
            }
        }

        [Authorize]
        [HttpGet]
        [Route("debug/generate/bigtestform")]
        public async Task<ActionResult> GetGenerateDataForBigTestForm()
        {
            try
            {
                User user = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!user.IsInRole(Constants.Role.Admins))
                    throw new PermissionException();
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content = $"<html><body><form method=\"post\">dplyId=<input name=\"dplyId\" type=\"text\" />count=<input name=\"count\" type=\"text\" value=\"1024\" /><input type=\"submit\" /></form></body></html>"
                };
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetGenerateDataForBigTestForm) + " -  caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/plain",
                    StatusCode = 500,
                    Content = Constants.Message.InternalErrorException
                };
            }
        }

        [Authorize]
        [HttpPost]
        [Route("debug/generate/bigtestform")]
        public async Task<ActionResult> PostGenerateDataForBigTestForm(
            [FromServices]IDevToolsService devtools, 
            Guid dplyId,
            int count)
        {
            try
            {
                User user = await CloverRuntime.Security.GetCurrentUserAsync();
                if (!user.IsInRole(Constants.Role.Admins))
                    throw new PermissionException($"Requires {Constants.Role.Admins}");

                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                logger.LogInformation(nameof(PostGenerateDataForBigTestForm) + " - starting, count={0}, user={1} ({2})", count, user.Id, user.Name);

                await devtools.GenerateResponseData(user, dplyId, count);

                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);

                logger.LogInformation(nameof(PostGenerateDataForBigTestForm) + " - completed, count={0}, user={1} ({2}), duration={3} ms ({4} minutes)", count, user.Id, user.Name, duration, Math.Ceiling((double)duration / 1000 / 60));
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content = $"<html><body>OK, duration={duration} ms (approx {Math.Ceiling((double)duration/1000/60)} minutes)</body></html>"
                };
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PostGenerateDataForBigTestForm) + " -  caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/plain",
                    StatusCode = 500,
                    Content = Constants.Message.InternalErrorException
                };
            }
        }

        /// <summary>
        /// Used by HelloWorld to render HTML for key, value info
        /// </summary>
        private void AppendInfo(StringBuilder b, string name, string value)
        {
            b.AppendLine($"<strong>{HttpUtility.HtmlEncode(name)}=</strong><span style=\"color: blue\">{HttpUtility.HtmlEncode(value)}</span>");
        }

        private void AppendHeaders(StringBuilder b)
        {
            b.Append("<h2>Headers</h2>");
            foreach (KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> header in Request.Headers)
            {
                string key = header.Key;
                b.AppendLine($"<strong>{HttpUtility.HtmlEncode(key)}</strong>");
                if (!HeaderNames.Cookie.Equals(key, StringComparison.OrdinalIgnoreCase))
                {
                    string[] values = header.Value.ToArray();                    
                    foreach (string value in values)
                    {
                        b.AppendLine($"<span style=\"color: blue\">{value}</span>");
                    }                    
                }
                else
                {
                    b.AppendLine($"<span style=\"font-style: italic;\">(cookie values are hidden here)</span>");
                    foreach(string cookiename in Request.Cookies.Keys)
                    {
                        b.AppendLine($"<span style=\"color: blue\">{cookiename}</span>");
                    }
                }
                b.AppendLine("---");
            }
            b.Append("<p>");
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpPost]
        [Route("debug/logLevel")]
        public ActionResult LogLevel()
        {
            LogLevel logLevel = DefaultApplicationLogging.GetEnabledLogLevel(logger);
            logger.LogCritical("Call to /logLevel. Configured Level={0}", logLevel);
            logger.LogError("Test error log");
            logger.LogWarning("Test warning log");
            logger.LogInformation("Test information log");            
            logger.LogDebug("Test debug log");
            logger.LogTrace("Test trace log");
            return new ContentResult
            {
                ContentType = "text/html",
                StatusCode = 200,
                Content = $"<html><body>logLevel={logLevel}</body></html>"
            };
        }

        /// <summary>
        /// Returns a simple page to list recent File Tickets (if not an Admins user only tickets valid for the current user are shown).
        /// </summary>
        [Authorize]
        [HttpGet]
        [Route("debug/filetickets")]
        public async Task<ActionResult> ListFileTickets()
        {
            try
            {
                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                bool currentUserIsAdmins = currentUser.IsInRole(Constants.Role.Admins);

                EntityModel dwSecurityUserModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
                Dictionary<Guid, string> userNamesById 
                    = (await dwSecurityUserModel.GetAsync(Filter.Empty)).ToDictionary(
                        u => (Guid)u[Constants.FieldName.Id],
                        u => (string)u[Constants.FieldName.Name]);

                Dictionary<Guid, string> organisationById 
                    = (await StructDivision.SelectAsync()).ToDictionary(
                        s => s.Id,
                        s => s.Name);

                EntityModel qnnFileTicketModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_FILE_TICKET, Constants.Level.NoJoins);
                List<DynamicEntity> tickets 
                    = await qnnFileTicketModel.GetAsync(Filter.Empty, Order.StartDesc(Constants.FieldName.CreatedDate), new Paging(skip:0, take:64));

                StringBuilder html = new StringBuilder();
                html.Append("<html><head><title>File Tickets</title></head><body><h1>File Tickets</h1>");
                html.Append($"<p>Logged in as {HttpUtility.HtmlEncode(currentUser.Name)}</p>");
                html.Append($"<a href=\"/\">Return to Application</a><br/>");

                html.Append("<table border=\"1\" cellpadding=\"8\" cellspacing=\"0\"><thead><tr>");

                html.Append("<th>Created</th>");
                html.Append("<th>Enabled</th>");
                html.Append("<th>Organisation</th>");
                html.Append("<th>User Restriction</th>");
                html.Append("<th>Roles Restriction</th>");
                html.Append("<th>Purpose</th>");
                html.Append("<th>Valid</th>");
                html.Append("<th>Download Link</th>");
                html.Append("<th>Expires</th>");

                html.Append("</tr></thead><tbody>");
                bool noRecordsToDisplay = true;
                foreach (DynamicEntity ticket in tickets)
                {
                    FileTicketApplication.TicketValidity validity = await FileTicketApplication.IsTicketValidForUser(ticket, currentUser);
                    bool isValidForCurrentUser = (FileTicketApplication.TicketValidity.Valid == validity);
                    if (isValidForCurrentUser || currentUserIsAdmins)
                    {
                        noRecordsToDisplay = false;
                        html.Append("<tr>");

                        bool isEnabled = (bool)ticket[Constants.FieldName.IsEnabled];
                        DateTime createdDate = (DateTime)ticket[Constants.FieldName.CreatedDate];
                        DateTime? expiryDate = (DateTime?)ticket[Constants.FieldName.ExpiryDate];
                        string expiryString = expiryDate == null ? "Never" : expiryDate.Value.ToString(Constants.QnnDatetimeFormat);
                        string url = await FileTicketApplication.GetLink(ticket);
                        string purpose = (string)ticket[Constants.FieldName.Purpose];
                        Guid? restrictedToUserId = (Guid?)ticket[Constants.FieldName.RestrictedToUserId];
                        string restrictedToUserName = (restrictedToUserId == null)
                            ? "&nbsp;"
                            : userNamesById.ContainsKey(restrictedToUserId.Value)
                                ? HttpUtility.HtmlEncode(userNamesById[restrictedToUserId.Value])
                                : $"Unknown user {restrictedToUserId.ToString()}";
                        string restrictedToRoles = HttpUtility.HtmlEncode(((string)ticket[Constants.FieldName.RestrictedToRoles]) ?? "");
                        if (string.IsNullOrEmpty(restrictedToRoles)) restrictedToRoles = "&nbsp;";
                        Guid structDivisionId = (Guid)ticket[Constants.FieldName.StructDivisionId];
                        string organisation = organisationById.ContainsKey(structDivisionId)
                            ? HttpUtility.HtmlEncode(organisationById[structDivisionId])
                            : $"Unknown StructDivision {structDivisionId}";


                        html.Append($"<td>{createdDate.ToString(Constants.QnnDatetimeFormat)}</td>");
                        html.Append($"<td>{isEnabled}</td>");
                        html.Append($"<td>{organisation}</td>");
                        html.Append($"<td>{restrictedToUserName}</td>");
                        html.Append($"<td>{restrictedToRoles ?? ""}</td>");
                        html.Append($"<td>{purpose}</td>");
                        html.Append($"<td>{isValidForCurrentUser}</td>");
                        html.Append($"<td><a href=\"{url}\">{url}</a></td>");
                        html.Append($"<td>{expiryString}</td>");

                        html.Append("</tr>");
                    }                    
                } //end foreach ticket
                if (noRecordsToDisplay)
                {
                    html.Append($"<td colspan=\"9\">No records to display</td>");
                }
                html.Append("</tbody><//table>");

                
                html.Append("</body></html>");

                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content = html.ToString(),
                };
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(ListFileTickets) + " - caught unexpected exception");
                return StatusCode(500);
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("debug/authentication")]
        public async Task<ActionResult> DebugAuthentication(
            [FromServices] IntranetAppSetting intranetAppSettings,
            [FromServices] IWindowsAuthenticationChallenger configuredChallenger,
            string accessCode, 
            string challenge)
        {
            try
            {
                bool isEnabled = !string.IsNullOrEmpty(options.DebugAuthenticationAccessCode);
                if (!isEnabled)
                    return NotFound();

                if (!options.DebugAuthenticationAccessCode.Equals(accessCode, StringComparison.InvariantCultureIgnoreCase))
                    throw new PermissionException("Incorrect accessCode");

                StringBuilder b = new StringBuilder();
                
                System.Security.Principal.IIdentity identity = HttpContext.User?.Identity;
                if (identity == null)
                {
                    //I don't expect this even if anonymous
                    logger.LogInformation(nameof(DebugAuthentication) + " - called, identity object in request is null");
                    b.AppendLine("Identity object in request is null");
                }
                else
                {
                    string identityType = (identity == null) ? "null" : identity.GetType().ToString();

                    logger.LogInformation(nameof(DebugAuthentication) + " - called, identity.Name={0}, identity.GetType()={1}, identity.IsAuthenticated={2}", identity.Name, identityType, identity.IsAuthenticated);


                    if (!identity.IsAuthenticated)
                    {
                        if(!string.IsNullOrEmpty(challenge))
                        {
                            IWindowsAuthenticationChallenger challenger;
                            if ("configured".Equals(challenge, StringComparison.InvariantCultureIgnoreCase))
                            {
                                challenger = configuredChallenger;
                            }
                            else
                            {
                                CloverOptions.WA401ChallengeBehaviour behaviour;
                                try
                                {
                                    behaviour = (CloverOptions.WA401ChallengeBehaviour)Enum.Parse(typeof(CloverOptions.WA401ChallengeBehaviour), challenge);

                                }
                                catch (Exception)
                                {
                                    return BadRequest("invalid challenge value");
                                }
                                challenger = WindowsAuthenticationChallengerHelper.CreateChallenger(behaviour);
                            }
                            logger.LogDebug(nameof(DebugAuthentication) + " - issuing challenge using {0}", challenger);
                            return await challenger.IssueChallenge(HttpContext);
                        }
                    }

                    b.Append("<p><h2>NetCore Request Identity</h2>");
                    AppendInfo(b, "Identity Type", identityType);
                    AppendInfo(b, "Authentication Type", identity.AuthenticationType);
                    AppendInfo(b, "Identity.IsAuthenticated", "" + identity.IsAuthenticated);
                    AppendInfo(b, "Identity.Name", identity.Name); //for AD login would be name IIS presented to us for Windows Auth
                    b.Append("</p>");
                }

                b.Append("<p><h2>SurveyPlus User Identity</h2>");
                try
                {
                    User user = await CloverRuntime.Security.GetCurrentUserAsync();
                    logger.LogInformation(nameof(DebugAuthentication) + " - user.Name={0}", user?.Name??"(Not Authenticated in SurveyPlus)");
                    if (user == null)
                    {
                        b.Append("Not authenticated in SurveyPlus");
                    }
                    else
                    {
                        AppendInfo(b, "SurveyPlus User", user.Name);
                    }
                }
                catch(Exception e)
                {
                    logger.LogError(e, nameof(DebugAuthentication) + " - caught exception trying to get Clover user information");
                    b.Append("Failed to retrieve SurveyPlus user information, please check log for error details");
                }
                b.Append("</p>");

                b.Append("<p><h2>SurveyPlus Application Configuration</h2>");
                AppendInfo(b, "Windows Authentication Enabled", intranetAppSettings.Clover.IsWindowsAuthentication.ToString());
                AppendInfo(b, "Configured Challenger", configuredChallenger?.ToString());
                AppendInfo(b, "Password Authentication Enabled", intranetAppSettings.Clover.IsPasswordAuthentication.ToString());
                b.Append("</p>");

                if(options.IsShowHeadersInDebugAuthentication)
                {
                    AppendHeaders(b);
                }
                
                b.Replace("\n", "\n<br />");

                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 200,
                    Content = $"<html><head><title>SurveyPlus Authentication</title></head><body style=\"font-family: monospace\"><h1>Authentication</h1><a href=\"/\">Return to application</a><br/><span>\n{b.ToString()}\n</span></body></html>"
                };
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(DebugAuthentication) + " - caught unexpected exception");
                return new ContentResult
                {
                    ContentType = "text/html",
                    StatusCode = 500,
                    Content = $"<html><body><h1>Unexpected Error</h1>Check log for error details</body></html>"
                };
            }
        }

#if (DEBUG)
        [AllowAnonymous]
        [HttpGet]
        [Route("TROUBLESHOOTING_CLEAR_USER_CACHE")]
        public ActionResult TROUBLESHOOTING_CLEAR_USER_CACHE()
        {
            Clover.Security.Providers.SecurityProvider.TROUBLESHOOTING_CLEAR_USER_CACHE();
            logger.LogInformation("TROUBLESHOOTING_CLEAR_USER_CACHE: Cleared UserCache");
            return new ContentResult
            {
                ContentType = "text/html",
                StatusCode = 200,
                Content = $"<html><body>Cleared UserCache at {DateTime.Now.ToString(Constants.DatetimeFormat)}</body></html>"
            };
        }
#endif
        
        [AllowAnonymous]
        [HttpGet]
        [Route("debug/throw")]
        [Route("human/throw")]
        public async Task<ActionResult> ThrowException()
        {
            logger.LogInformation(nameof(ThrowException) + " - called");
            throw new Exception("Test exception");
        }

        /// <summary>
        /// Return a 418 http error for testing purposes
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("debug/teapot")]  //considered non-human facing by ErrorController
        [Route("human/teapot")]  //considered human facing by ErrorController
        public async Task<ActionResult> ThrowTeapot()
        {
            logger.LogInformation(nameof(ThrowTeapot) + " - called");
            return StatusCode(418);
        }
    }
}