using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using System.IO;
using Constants = swz.SurveyPlus.Application.Constants;
using CsvHelper;
using Hangfire;
using System.IO.Compression;
using System.Web;
using Winnovative;
using swz.Clover.Core.Utils;
using System.Globalization;
using System.Collections.Immutable;
using Amazon.S3;
using CsvHelper.Configuration.Attributes;
using Amazon.S3.Model;
using Newtonsoft.Json.Linq;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using CsvHelper.Configuration;
using swz.SurveyPlus.IntranetApplication.Utilities;
using swz.Clover.Core.View;
using CsvHelper.TypeConversion;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Functionality related to the SurveyPlus AuditLog.
    /// (If you're looking for the MonthlyAccessReport its here too in a nested class of that name)
    /// </summary>
    public class AuditLogApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<AuditLogApplication>();
        private const string emailDateFormat = "MMM yyyy";

        private const int Winnovate_ConversionDelay = 0; //dont allow a delay for js to reformat the pages (winnovate default is 2 seconds)
        private const bool Winnovate_CompressCrossReference = true;

        private const string auditLogFileNameFormat = "yyyyMMdd";
        private const string auditLogFileExtension = "txt";

        private const string ablrFileNameFormat = "yyyyMMdd";
        private const string ablrFileExtension = "txt";
        private const string ablrTimestampFormat = "dd'-'MM'-'yyyy HH':'mm':'ss";

        public static class MonthlyAccessReport
        {

            public static async Task Execute()
            {
                try
                {
                    ImmutableList<string> recipients = await GetRecipients();
                    if (recipients.Any())
                    {
                        MemoryStream accessLogsCSV
                            = await ExtractMonthlyAccessLogsCSV();
                        //20260831 we will disable the PDF generation for now in v10
                        //It issues a second request and in prod the data is huge,
                        //and so the PDF generation will also be very heavy on the SQL and
                        //the application server, and it seems the CSV is the one that gets
                        //used more anyway
                        //MemoryStream accessLogsPDF
                        //    = await ExtractMonthlyAccessLogsPDF();
                        MemoryStream accessLogsPDF = null;
                        await SendMonthlyAccessReport(
                            recipients,
                            accessLogsCSV,
                            accessLogsPDF);
                    }
                    else
                    {
                        logger.LogWarning(nameof(Execute) + " - skipping report generation because no valid recipients were found");
                    }                    
                }
                catch (Exception e)
                {
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(e, nameof(Execute) + " - caught an unexpected exception");
                    }
                    throw new InternalException("Failed to execute the monthly access report", e);
                }
            }

            private static async Task<ImmutableList<string>> GetRecipients()
            {
                string maalrSetting
                    = await SettingsHelper.GetValue(Constants.dwAppSettingName.MonthlyAuditAccessLogRecipients);
                if (logger.IsEnabled(LogLevel.Debug)) 
                {
                    logger.LogDebug(nameof(GetRecipients) + " - Configured MonthlyAuditAccessLogRecipients={0}", maalrSetting);
                }
                //Resolve configuration to a list of actual valid addresses
                MailRecipients recipients 
                    = await MailRecipients.FromStringForAllOrganisations(maalrSetting);
                if (recipients.IsAnyInvalid && logger.IsEnabled(LogLevel.Warning))
                {   //Not fatal, just log any with bad addresses
                    logger.LogWarning(nameof(GetRecipients) + " - some address resolutions were invalid: {0}", recipients.GetInvalidResolutions());
                }
                return recipients.GetValidDistinctEmails().ToImmutableList();
            }

            /// <summary>
            /// Instantiate a Winnovate PdfConverter with settings appropriate for monthly access report pdf
            /// </summary>
            /// <returns></returns>
            private static PdfConverter CreatePdfConverter()
            {
                PdfConverter htmlToPdfConverter = HtmlToPdfStream.NewConverterInstance();
                htmlToPdfConverter.ConversionDelay = Winnovate_ConversionDelay;
                htmlToPdfConverter.PdfDocumentOptions.CompressCrossReference = Winnovate_CompressCrossReference;
                htmlToPdfConverter.PdfDocumentOptions.EmbedFonts = false;
                return htmlToPdfConverter;
            }

            /// <summary>
            /// Create a pdf document from the monthly access report html using reasonable settings
            /// and write it to a memory stream which is then reset to position 0 and returned.
            /// </summary>
            /// <param name="html"></param>
            /// <returns></returns>
            public static MemoryStream CreateDocument(string html, PdfPageOrientation orientation = PdfPageOrientation.Portrait)
            {
                PdfConverter oPdfConverter = CreatePdfConverter();
                MemoryStream ms = new MemoryStream();
                oPdfConverter.SavePdfFromHtmlStringToStream(html, ms);
                ms.Seek(0, SeekOrigin.Begin);
                return ms;
            }

            /// <summary>
            /// Extract monthly access data for previous month from audit logs table in DB and write into csv file.
            /// nb: This returns a MemoryStream specifically. This is convenient for the scheduled job to send these monthly access data
            ///     (This may get refactored in future iterations)
            /// </summary>
            public static async Task<MemoryStream> ExtractMonthlyAccessLogsCSV()
            {
                try
                {
                    DateTime today = DateTime.Today; // Local time 00:00
                    DateTime endDate = new DateTime(today.Year, today.Month, 1);
                    DateTime startDate = endDate.AddMonths(-1);

                    List<Dictionary<string, object>> auditLogs 
                        = await spSP_GetMonthlyAccessLogs.ForPeriod(startDate, endDate);

                    if (auditLogs != null && auditLogs.Any())
                    {
                        IEnumerable<dynamic> expandoObjects = auditLogs.Select(i => (dynamic)i.ToExpando());
                        MemoryStream memory = new MemoryStream();
                        using (MemoryStream ms = new MemoryStream())
                        {
                            using (StreamWriter writer = new StreamWriter(ms))
                            {
                                //20251123 changed to InvariantCulture.
                                //See: https://github.com/JoshClose/CsvHelper/issues/1441
                                //and: https://github.com/JoshClose/CsvHelper/issues/1203
                                //For surveyplus we prefer certainty on what its doing so we
                                //can provide better support so I'm using InvariantCulture now.
                                using (CsvWriter csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                                {
                                    //Use same standardised dateformat that we do in the response export
                                    TypeConverterOptions options
                                        = new TypeConverterOptions { Formats = new[] { Constants.QnnDatetimeFormat } };
                                                csv.Context.TypeConverterOptionsCache.AddOptions<DateTime>(options);
                                                csv.Context.TypeConverterOptionsCache.AddOptions<DateTime?>(options);
                                    csv.WriteRecords(expandoObjects);
                                    csv.Flush();
                                    writer.Flush();
                                    ms.Seek(0, SeekOrigin.Begin);
                                    ms.CopyTo(memory);
                                }
                            }
                        }
                        memory.Seek(0, SeekOrigin.Begin);
                        return memory;
                    }
                    else
                    {
                        return null;
                    }
                }
                catch (Exception e)
                {
                    logger.LogDebug(e, nameof(ExtractMonthlyAccessLogsCSV) + " - caught unexpected exception");
                    throw new Exception("Unexpected exception extracting monthly access logs into csv", e);
                }
            }

            /// <summary>
            /// Extract monthly access data for previous month from audit logs table in DB and write into pdf file.
            /// nb: This returns a MemoryStream specifically. This is convenient for the scheduled job to send these monthly access data
            ///     (This may get refactored in future iterations)
            /// </summary>
            public static async Task<MemoryStream> ExtractMonthlyAccessLogsPDF()
            {
                try
                {
                    string content = await GetMonthlyAccessReportHtmlContent();
                    MemoryStream result = CreateDocument(content);
                    return result;
                }
                catch (Exception e)
                {
                    logger.LogDebug(e, nameof(ExtractMonthlyAccessLogsPDF) + " - caught unexpected exception");
                    throw new Exception("Unexpected exception extracting monthly access logs into pdf", e);
                }
            }

            private static async Task<string> GetMonthlyAccessReportHtmlContent()
            {
                DateTime today = DateTime.Today; // Local time 00:00
                DateTime endDate = new DateTime(today.Year, today.Month, 1);
                DateTime startDate = endDate.AddMonths(-1);

                string result = GetStyle();
                MonthlyAccessLogs data = new MonthlyAccessLogs();
                await data.InitData(startDate, endDate);
                string tableHeader = GetMonthlyAccessReportTableHeader();

                string tableStart = "<table class='monthly-access-report'><tbody>";
                string tableEnd = "</tbody></table>";

                if (data.accessLogs.Count > 0)
                {
                    result += "<div class='monthly-access-report'>";
                    result += GetReportHeader(data.GeneratedDate, data.accessLogs.Count);
                    result += tableStart + tableHeader;

                    for (int i = 1; i <= data.accessLogs.Count; i++)
                    {
                        result += GetMonthlyAccessReportRow(data.accessLogs[i - 1]);
                    }
                    result += tableEnd;
                    result += "</div>";
                }
                else
                {
                    result += "<div class='monthly-access-report'>";
                    result += GetReportHeader(data.GeneratedDate, data.accessLogs.Count);
                    result += tableStart + tableHeader;
                    result += "<tr><td colspan='" + (data.accessLogs.Count > 0 ? (data.accessLogs.Count + 1) + "" : "2") + "'>No record found.</td></tr>";
                    result += tableEnd + "</div>";
                }

                return result;
            }

            private static string GetMonthlyAccessReportTableHeader()
            {

                string result = "<thead><tr><td class='bold' rowspan='2'>Date</td>";
                result += "<td class='bold' rowspan='2'>User Name</td>";
                result += "<td class='bold' rowspan='2'>Sample UID</td>";
                result += "<td class='bold' rowspan='2'>Sample Name</td>";
                result += "<td class='bold' rowspan='2'>Batch Job ID</td>";
                result += "<td class='bold' rowspan='2'>Event Type</td>";
                result += "<td class='bold' rowspan='2'>Table Name</td>";
                result += "<td class='bold' rowspan='2'>Field Modified</td>";
                result += "<td class='bold' rowspan='2'>Original Value</td>";
                result += "<td class='bold' rowspan='2'>New Value</td>";
                result += "<tr>";
                result += "</tr></thead>";

                return result;
            }

            private static string GetMonthlyAccessReportRow(Dictionary<string, object> auditLog)
            {
                string result = "<tr><td>" + HttpUtility.HtmlEncode(auditLog[Constants.MonthlyAccessReportField.Date]) + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.UserName] != null ? auditLog[Constants.MonthlyAccessReportField.UserName] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.SampleUID] != null ? auditLog[Constants.MonthlyAccessReportField.SampleUID] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.SampleName] != null ? auditLog[Constants.MonthlyAccessReportField.SampleName] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.BatchJobID] != null ? auditLog[Constants.MonthlyAccessReportField.BatchJobID] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.EventType] != null ? auditLog[Constants.MonthlyAccessReportField.EventType] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.TableName] != null ? auditLog[Constants.MonthlyAccessReportField.TableName] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.FieldModified] != null ? auditLog[Constants.MonthlyAccessReportField.FieldModified] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.OriginalValue] != null ? auditLog[Constants.MonthlyAccessReportField.OriginalValue] : "N/A") + "</td>";
                result += "<td>" + (auditLog[Constants.MonthlyAccessReportField.NewValue] != null ? auditLog[Constants.MonthlyAccessReportField.NewValue] : "N/A") + "</td>";
                result += "</tr>";
                return result;
            }

            private static string GetStyle()
            {
                string result = "<style>";
                result += "body{ font-family: Lato,'Helvetica Neue',Arial,Helvetica,sans-serif; }";
                result += "table.monthly-access-report{ width: 100%; text-align: center; border-collapse: collapse; border-spacing: 0; margin-bottom: 20px}";
                result += "table.monthly-access-report thead tr { background-color: #6B7AE0; color: #FFF; }";
                result += "table.monthly-access-report tr td.aspect-name-header{ max-width: 140px; min-width: 140px; width: 140px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;}";
                result += "table.monthly-access-report tbody{ border-color: #cccccc; }";
                result += "table.monthly-access-report tr td{ padding: 8px 4px; border:1px solid #dee2e6;}";
                result += "table.monthly-access-report tr td.bold{font-weight: bold;}";
                result += "table.monthly-access-report tr td.nowrap{white-space: nowrap;}";
                result += "table.monthly-access-report tr td .center{display: flex; justify-content: center; flex-direction: column;}";
                result += "table.report-info tr td { padding: 0px 4px;}";
                result += "div.monthly-access-report { margin-bottom:12px;}";
                result += "div.monthly-access-report .report-header {margin-bottom:12px;}";
                result += "div.monthly-access-report .report-footer {text-align: right;}";
                result += "</style>";
                return result;
            }

            private static string GetReportHeader(DateTime generatedDate, int totalRecord)
            {
                string previousMonth = DateTime.Now.AddMonths(-1).ToString(emailDateFormat);
                string result = "<div class='report-header'><table class='report-info'>";

                result += "<tr><td class='col-props'>Monthly Audit Access Logs for " + previousMonth + "</td></tr>";
                result += "<tr><td class='col-props'>Date Generated</td><td class='col-props'>:</td><td class='col-value'>" + generatedDate.ToString("dd MMM yyyy HH:mm:ss") + "</td></tr>";
                result += "<tr><td class='col-props'>Number of Record(s)</td><td class='col-props'>:</td><td class='col-value'>" + totalRecord + "</td></tr>";
                result += "</table></div>";
                return result;
            }

            private class MonthlyAccessLogs : UserAccessMatrixData
            {
                public DateTime GeneratedDate { get; set; }

                public List<Dictionary<string, object>> accessLogs { get; set; }

                public MonthlyAccessLogs() { }

                public async Task InitData(DateTime startDate, DateTime endDate)
                {
                    GeneratedDate = DateTime.Now;

                    accessLogs = await spSP_GetMonthlyAccessLogs.ForPeriod(startDate, endDate);

                }
            }

            /// <summary>
            /// Email monthly audit access logs in pdf and csv format as attachments 
            /// to the recipients.
            /// </summary>
            // nb: uses a MemoryStream specifically. This is for our convenience so we
            //     can rewind when doing the second attachement
            public static async Task SendMonthlyAccessReport(
                IEnumerable<string> recipients,
                MemoryStream accessLogsCSV, 
                MemoryStream accessLogsPDF)
            {
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                string previousMonth = DateTime.Now.AddMonths(-1).ToString(emailDateFormat);

                if(logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(SendMonthlyAccessReport) + " - sending monthly audit access logs - accessLogsCSV.Length={0}, accessLogsPDF.Length={1}, recipients={2}", accessLogsCSV?.Length, accessLogsPDF?.Length, string.Join(';',recipients));
                }
                
                List<Email.Item> attachments = new List<Email.Item>();

                if (accessLogsCSV != null)
                {
                    string csvFileName = $"{appName} Monthly Audit Access Log Export {previousMonth}.csv"
                        .Replace(' ', '_'); //eg: "SurveyPlus_Monthly_Audit_Access_Log_Export_Jan_2022.csv";
                    attachments.Add(Email.CreateCsvAttachment(accessLogsCSV, csvFileName));
                } 

                if (accessLogsPDF != null)
                {
                    string pdfFileName = $"{appName} Monthly Audit Access Log Export {previousMonth}.pdf"
                        .Replace(' ', '_'); //eg: "SurveyPlus_Monthly_Audit_Access_Log_Export_Jan_2022.pdf"
                    attachments.Add(Email.CreatePdfAttachment(accessLogsPDF, pdfFileName));
                }

                using (Email.IMailer mailer = await Email.CreateMailer(
                    mailSettings: mailSettings,
                    senderDisplayName: appName,
                    emailFrom: Email.UseDefaultEmailFrom))
                {
                    string body =
                        "This is an auto generated email.<br />"
                        + ((accessLogsCSV == null && accessLogsPDF == null)
                        ? $"No access logs found for {HttpUtility.HtmlEncode(previousMonth)}.<br />"
                        : $"Attached are the monthly audit access logs.<br />This report contains an extract of the audit log events related to system access during {HttpUtility.HtmlEncode(previousMonth)} and is sent on a monthly basis.<br/>");

                    bool sentSuccessfully = await mailer.SendAsync(
                        mailTo: recipients,
                        mailCc: null,
                        mailBcc: null,
                        subject: $"{appName} Monthly Audit Access Log Export for {previousMonth}",
                        body: body,
                        items: attachments.ToArray() );

                    if (!sentSuccessfully)
                    {
                        //Mail error (stacktrace would have been logged by SendAsync so we'll just log message again here)
                        logger.LogError(nameof(SendMonthlyAccessReport) + " - failed to send monthly audit access logs to Audit Admins, reason={0}", mailer.LastSendException?.Message);
                    }
                }
            }
        } // end class MonthlyAccessReport

        /// <summary>
        /// This is a workaround called by DataController for each and every GetData request
        /// on the off-chance it just maybe happens to be for the grid on the audit page, in
        /// which case we check to validate that its got a filter on EventDate start and end.
        /// If we return true GetData will return an empty dummy response instead of hitting the db.
        /// </summary>
        public static bool IsUnconstrainedAuditGridRequest(GetDataRequest getRequest)
        {
            bool isAuditGrid
                = getRequest != null
                && "audittrail".Equals(getRequest.Name, StringComparison.OrdinalIgnoreCase)
                && "gridAuditLog".Equals(getRequest.RequestingControlName, StringComparison.OrdinalIgnoreCase);
            if(isAuditGrid)
            {
                ClientFilterItem start 
                    = getRequest.Filter.Find(f => f.Column == "EventDate" && f.Term == ">=");
                ClientFilterItem end
                    = getRequest.Filter.Find(f => f.Column == "EventDate" && f.Term == "<");
                if((start == null) || (end == null))
                {
                    return true; //Not constrained on EventDate
                }
                else
                {
                    DateTime startDate = Convert.ToDateTime(start.Value);
                    DateTime endDate = Convert.ToDateTime(end.Value);
                    return (endDate.Subtract(startDate) > TimeSpan.FromDays(62));
                }
            }
            else
            {
                return false;
            }
            
        }

        public static async Task SchedulePurgeAuditLogs(
            string auditLogsPath, 
            DateTime dataCreatedBefore, 
            DateTime? archiveDate, 
            bool isArchive, 
            Clover.Core.Security.User user)
        {
            BackgroundJob.Schedule(() => PurgeAuditLogs(null, auditLogsPath, isArchive, dataCreatedBefore, archiveDate, DateTime.Now, user), !isArchive ? DateTime.Now : new DateTimeOffset((archiveDate.Value)));
        }

        //TODO - move this to a service class and inject the configuration instead. Also pass userId not the actual user!
        //Also - need to (re)verify the user rights here
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        /// <summary>
        /// Create archive before purging audit log if "Require Archive" option is enabled.
        /// Delete audit logs created before dataCreatedBefore date.
        /// Email purging result to user. (With download link for archiving).
        /// </summary>
        public static async Task PurgeAuditLogs(
            string unused, 
            string auditLogsPath, 
            bool isArchive, 
            DateTime dataCreatedBefore, 
            DateTime? archiveDate, 
            DateTime triggerDate, 
            Clover.Core.Security.User user)
        {
            try
            {
                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(PurgeAuditLogs) + " - starting job");
                }

                DynamicEntity fileTicket = null;
                if (isArchive)
                {
                    fileTicket = await CreateArchivedAuditLogsFile(user,auditLogsPath, dataCreatedBefore);
                }

                await DeleteAuditLogsBeforeCreatedDate(user, dataCreatedBefore);
                await SendPurgeResult(user, dataCreatedBefore, archiveDate, fileTicket, isArchive, triggerDate);

                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(PurgeAuditLogs) + " - completed job");
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(PurgeAuditLogs) + " - caught unexpected exception");
            }
        }

        /// <summary>
        /// Extract audit logs created before dataCreatedBefore date specified by user from DB and write into csv file.
        /// Zip the csv file and return for sending email.
        /// Schedule a job to clean up extracted audit logs after 2 days.
        /// </summary>
        /// <param name="user"></param>
        /// <param name="auditLogsPath"></param>
        /// <param name="dataCreatedBefore">audit data created before this date is to be archived</param>
        public static async Task<DynamicEntity> CreateArchivedAuditLogsFile(
            Clover.Core.Security.User user,
            String auditLogsPath, 
            DateTime dataCreatedBefore)
        {
            try
            {
                if (string.IsNullOrEmpty(auditLogsPath)) throw new ArgumentException(nameof(auditLogsPath));

                string archiveFolderId = Guid.NewGuid().ToString();
                string subAuditLogsPath = Path.Combine(auditLogsPath, archiveFolderId);
                string csvFileName = $"ArchivedAuditLogs_{DateTime.Now.ToString("ddMMyyyy")}.csv";

                List<Dictionary<string, object>> auditLogs = await GetAuditLogsCreatedBefore(dataCreatedBefore);

                if (auditLogs != null && auditLogs.Any())
                {
                    DirectoryInfo directory = Directory.CreateDirectory(subAuditLogsPath);
                    IEnumerable<dynamic> expandoObjects = auditLogs.Select(i => (dynamic)i.ToExpando());
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (StreamWriter writer = new StreamWriter(ms))
                        {
                            //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                            using (CsvWriter csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                            {
                                csv.WriteRecords(expandoObjects);
                                csv.Flush();
                                writer.Flush();
                                ms.Seek(0, SeekOrigin.Begin);
                                using (Stream fs = new FileStream(Path.Combine(subAuditLogsPath, csvFileName), FileMode.Create, FileAccess.Write))
                                {
                                    ms.CopyTo(fs);
                                    fs.Flush();
                                }
                            }
                        }
                    }
                    string zipFileName = archiveFolderId + ".zip";
                    string zipFileFullPathName = Path.Combine(auditLogsPath, zipFileName);
                    ZipFile.CreateFromDirectory(directory.FullName, zipFileFullPathName);
                    directory.Delete(recursive: true); //20231019 - new behaviour is to cleanup the directory immediately

                    FileInfo file = new FileInfo(zipFileFullPathName);

                    using (SharedTransaction shared = new SharedTransaction())
                    {
                        try
                        {
                            shared.BeginTransactionAsync().Wait();
                            Dictionary<string, string> properties = new Dictionary<string, string>();
                            properties.Add(Constants.FileProperties.Name, file.Name);
                            properties.Add(Constants.FileProperties.ContentType, Constants.ContentTypes.ZipFileType);
                            //properties.Add(Constants.FileProperties.IsLocalStorage, isLocalStorage);

                            String token;
                            Guid ticketId;
                            DynamicEntity ticket;
                            DateTime? expiryDate = DateTime.Now.AddHours(48);
                            using (Stream stream = file.OpenRead())
                            {
                                token = await CloverRuntime.ContentProvider.AddAsync(stream, properties);
                                FileTicketBuilder ticketBuilder 
                                    = new FileTicketBuilder(token, FileTicketPurpose.AuditArchive, user.StructDivisionId.Value)
                                        .CreatedBy(user.Id)
                                        .AddRoleRestriction(Constants.Role.AuditAdmin)
                                        .Expires(expiryDate)
                                        .DeleteFileOnExpiry(true);
                                ticket = await ticketBuilder.Build();
                                ticketId = await FileTicketApplication.SaveFileTicket(ticket);
                            }
                            file.Delete();
                            shared.Commit();
                            if (logger.IsEnabled(LogLevel.Information))
                                logger.LogInformation(nameof(CreateArchivedAuditLogsFile) + " - copied {0} to database with token {1} and issued ticket {2} with expiry {3}", zipFileFullPathName, token, ticketId, expiryDate);

                            //Audit
                            await Clover.Core.Utils.AuditHelper.AuditLog(user.Id, null, user.StructDivisionId, "Audit Archive", "AuditLog");

                            return ticket;
                        }
                        catch (Exception e)
                        {
                            await shared.RollbackAsync().ConfigureAwait(false);
                            throw new InternalException($"Error moving file to database and creating ticket, fullPath={zipFileFullPathName}", e);
                        }
                    }
                }
                else
                {
                    return null;
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(CreateArchivedAuditLogsFile) + " - caught unexpected exception");
                throw new Exception("Unexpected exception archiving audit logs", e);
            }
        }

        /// <summary>
        /// Email purge audit logs report to user who triggered the purge function.
        /// </summary>
        public static async Task SendPurgeResult(
            Clover.Core.Security.User user, 
            DateTime dataCreatedBefore, 
            DateTime? archiveDate, 
            DynamicEntity fileTicket, 
            bool isArchive, 
            DateTime triggerDate)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));

            if (isArchive)
            {
                if (archiveDate == null) throw new ArgumentNullException(nameof(archiveDate));
            }

            if (!string.IsNullOrEmpty(user.Email))
            {
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();

                if (logger.IsEnabled(LogLevel.Information))
                    logger.LogInformation("Sending purge audit logs to {0} at {1}", user.Name, user.Email);

                string subject = $"{appName} Purge Audit Logs";
                string body = $"Dear {user.Name}, <p />You clicked \"Purge Data\" at {triggerDate}. <p />";
                string emailDateFormat = "dd/MM/yyyy";

                if (isArchive)
                {
                    if (fileTicket == null)
                    {
                        body += "No audit log is archived as there is no audit log record for purging.";
                    }
                    else
                    {
                        string downloadUrl = await FileTicketApplication.GetLink(fileTicket);
                        body += $"Purged audit logs created before {dataCreatedBefore.ToString(emailDateFormat)} successfully. "
                            + $"You may download the archive file <a href='{downloadUrl}'>{downloadUrl}</a>. <p /> "
                            + "The server will keep it for a 48 hours only, please download as soon as you can.";
                    }
                }
                else
                {
                    body += $"Purged audit logs created before {dataCreatedBefore.ToString(emailDateFormat)} successfully.";
                }

                bool sentSuccessfully = await Email.SendAsync(
                    mailSettings: mailSettings,
                    mailTo: user.Email,
                    subject: subject,
                    body: body,
                    senderDisplayName: appName);
                if (!sentSuccessfully)
                {
                    //Mail error (exception details would have been logged in Send)
                    if (logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(SendPurgeResult) + " - failed to send notification for purge audit log to user {0} using email address {1}", user.Name, user.Email);
                    }
                }
            }
            else
            {
                //User has no email (in theory this shouldn't happen)
                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(SendPurgeResult) + " - user {0} does not have an e-mail to receive notification for purge audit log.", user.Name);
                }
            }
        }

        /// <summary>
        /// Fetch audit log data (for all struct division) created before dataCreatedBefore date from db for archiving
        /// </summary>
        private static async Task<List<Dictionary<string, object>>> GetAuditLogsCreatedBefore(DateTime dataCreatedBefore)
        {
            Dictionary<string, object> spParams = new Dictionary<string, object>
            {
                {"DataCreatedBefore", dataCreatedBefore}
            };
            return await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(Constants.StoredProcedure.spSP_GetAuditLogsCreatedBeforeDate
                , spParams, new Dictionary<string, object>());
        }

        /// <summary>
        /// Delete audit log data created before dataCreatedBefore date from DB
        /// This will affect *all* struct division
        /// </summary>
        private static async Task DeleteAuditLogsBeforeCreatedDate(Clover.Core.Security.User user, DateTime dataCreatedBefore)
        {
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(user.Id);
            await spSP_DeleteAuditLogBeforeCreatedDate.ExecuteAsync(
                dataCreatedBefore, 
                auditBatch, 
                user.StructDivisionId.Value);
        }

        /// <summary>
        /// ABLR Export Job
        /// </summary>
        public static bool AuditLogExport(bool isEnabledAuditExport, int daysInDB, string localTempPath, string cloudProvider, string cloudPath, string auditLogExportFileName, bool isEnabledAblr, string ablrPath, string ablrFileName, string projectReference)
        {
            bool result = true;
            if (isEnabledAblr)
            {
                try
                {
                    AblrExport(ablrPath, ablrFileName, projectReference);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(AblrExport) + " - caught unexpected exceptionn");
                    result = false;
                }
            }

            if (isEnabledAuditExport)
            {
                try
                {
                    DateTime dateToUpload = DateTime.Now.AddDays(-daysInDB).Date;
                    string localFileName = $"{auditLogExportFileName}{dateToUpload.ToString(auditLogFileNameFormat)}.{auditLogFileExtension}";
                    string localFilePath = Path.Combine(localTempPath, localFileName);

                    List<AuditLog> auditLogs = AuditLog.GetAuditLogsOfDate(dateToUpload).Result;
                    if (auditLogs == null)
                        auditLogs = new List<AuditLog>();

                    WriteAuditLogsToPath(auditLogs, localFilePath);

                    bool isExportCompleted = AuditExport(cloudProvider, cloudPath, localFilePath, localFileName);
                    if (isExportCompleted)
                    {
                        logger.LogTrace(nameof(AuditExport) + " - upload is completed");
                        //remove from DB audit log, remove localTempPath File
                        File.Delete(localFilePath);
                        AuditLog.DeleteAuditLogsOfDate(dateToUpload);
                    }
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(AuditExport) + " - caught unexpected exceptionn");
                    result = false;
                }
            }

            return result;
        }

        private static bool AuditExport(string provider, string cloudPath, string filePath, string fileName)
        {
            provider = string.IsNullOrEmpty(provider) ? null : provider.ToLower();

            switch (provider)
            {
                case "aws":
                    return UploadToAWS(cloudPath, filePath, fileName);
                    //break;
                case "azure":
                    return false;
                    //break;
                case null:
                    return false;
            }

            return true;
        }

        private static bool UploadToAWS(string bucketName, string filePath, string fileName)
        {
            IAmazonS3 client = new AmazonS3Client();
            bool isBucketExist = ListBucketContentsAsync(client, bucketName).Result;
            if (isBucketExist)
            {
                //Start Upload
                return UploadFileAsync(client, bucketName, fileName, filePath).Result;
            }
            else
            {
                //error, must have folder to upload
                return false;
            }
        }

        private class AblrLog
        {
            public string Timestamp { get; set; }
            public string Action { get; set; }
            public string Object { get; set; }
            public string ActionBy { get; set; }
            public string AdminGroup { get; set; }
            public string Roles { get; set; }
            [Name("Project Reference")]
            public string Project_Reference { get; set; }
            [Name("Event Description")]
            public string Event_Description { get; set; }
        }

        private static void AblrExport(string filePath, string fileName, string projectReference)
        {
            try
            {
                DateTime yesterday = DateTime.Now.AddDays(-1).Date;

                List<AuditLog> auditLog = AuditLog.GetAblrLogs(yesterday).Result;

                List<AblrLog> ablrLog = new List<AblrLog>();
                if (auditLog != null)
                {
                    auditLog.Sort((x, y) => DateTime.Compare(x.EventDate, y.EventDate));
                    foreach (var row in auditLog)
                    {
                        //skip for non-user and non-sample
                        if (row.UserId == null && row.SampleId == null)
                            continue;

                        //remove sensitive info, SecurityCredential -> PasswordHash and PasswordSalt value
                        if (row.TableName == "SecurityCredential" && (row.ColumnName == "PasswordHash" || row.ColumnName == "PasswordSalt"))
                            row.NewValue = null;

                        JObject ablrLogObject = new JObject
                        {
                            ["Organisation"] = row.StructDivisionId != null ? StructDivision.SelectByKey(row.StructDivisionId).Result.Name : null,
                            ["Tablename"] = row.TableName,
                            ["Record Id"] = row.RecordId,
                        };

                        string actionBy = null;
                        string roles = null;
                        if (row.UserId != null)
                        {
                            actionBy = SecurityUser.GetUserById((Guid)row.UserId).Result.Name;

                            string[] userRoles = SecurityUserToSecurityRole.SelectByUser((Guid)row.UserId).Result.Select(x => x.SecurityRoleCode).ToArray();
                            roles = $"[{string.Join(',', userRoles)}]";
                        }
                        else
                        {
                            actionBy = QNN_SAMPLE.SelectByKey(row.SampleId).Result.UID;
                        }

                        JObject ablrLogEventDescription = new JObject
                        {
                            ["ColumnName"] = row.ColumnName,
                            ["OriginalValue"] = ValidateJSON(row.OriginalValue) ? JObject.Parse(row.OriginalValue) : row.OriginalValue,
                            ["NewValue"] = ValidateJSON(row.NewValue) ? JObject.Parse(row.NewValue) : row.NewValue,
                        };

                        AblrLog ablrLogRow = new AblrLog
                        {
                            Timestamp = row.EventDate.ToString(ablrTimestampFormat),
                            Action = row.EventType,
                            Object = ablrLogObject.ToString(Newtonsoft.Json.Formatting.None),
                            ActionBy = actionBy,
                            AdminGroup = roles,
                            Roles = roles,
                            Project_Reference = projectReference,
                            Event_Description = ablrLogEventDescription.ToString(Newtonsoft.Json.Formatting.None),
                        };
                        ablrLog.Add(ablrLogRow);
                    }
                }
                string localFileName = $"{fileName}{yesterday.ToString(ablrFileNameFormat)}.{ablrFileExtension}";
                string localFilePath = Path.Combine(filePath, localFileName);
                WriteAuditLogsToPath(ablrLog, localFilePath, "|");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(AblrExport) + " - caught unexpected exception");
                throw new Exception("Unexpected exception extracting ablr logs into txt", e);
            }
        }

        private static void WriteAuditLogsToPath<T>(List<T> auditLogs, string filePath, string delimiter = ",")
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (StreamWriter writer = new StreamWriter(ms))
                {
                    CsvConfiguration csvConfig = new CsvConfiguration(CultureInfo.CurrentCulture)
                    {
                        Delimiter = delimiter,
                    };
                    using (CsvWriter csv = new CsvWriter(writer, csvConfig))
                    {
                        csv.WriteRecords(auditLogs);
                        csv.Flush();
                        writer.Flush();
                        ms.Seek(0, SeekOrigin.Begin);

                        using (Stream fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                        {
                            ms.CopyTo(fs);
                            fs.Flush();
                        }
                    }
                }
            }
        }

        private static bool ValidateJSON(string s)
        {
            try
            {
                JObject.Parse(s);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        #region aws s3 function
        /// <summary>
        /// Shows how to upload a file from the local computer to an Amazon S3
        /// bucket.
        /// </summary>
        /// <param name="client">An initialized Amazon S3 client object.</param>
        /// <param name="bucketName">The Amazon S3 bucket to which the object
        /// will be uploaded.</param>
        /// <param name="objectName">The object to upload.</param>
        /// <param name="filePath">The path, including file name, of the object
        /// on the local computer to upload.</param>
        /// <returns>A boolean value indicating the success or failure of the
        /// upload procedure.</returns>
        private static async Task<bool> UploadFileAsync(
            IAmazonS3 client,
            string bucketName,
            string objectName,
            string filePath)
        {
            var request = new PutObjectRequest
            {
                BucketName = bucketName,
                Key = objectName,
                FilePath = filePath,
            };

            var response = await client.PutObjectAsync(request);
            if (response.HttpStatusCode == System.Net.HttpStatusCode.OK)
            {
                Console.WriteLine($"Successfully uploaded {objectName} to {bucketName}.");
                return true;
            }
            else
            {
                Console.WriteLine($"Could not upload {objectName} to {bucketName}.");
                return false;
            }
        }

        /// <summary>
        /// Shows how to list the objects in an Amazon S3 bucket.
        /// </summary>
        /// <param name="client">An initialized Amazon S3 client object.</param>
        /// <param name="bucketName">The name of the bucket for which to list
        /// the contents.</param>
        /// <returns>A boolean value indicating the success or failure of the
        /// operation.</returns>
        private static async Task<bool> ListBucketContentsAsync(IAmazonS3 client, string bucketName)
        {
            try
            {
                var request = new ListObjectsV2Request
                {
                    BucketName = bucketName,
                    MaxKeys = 1,
                };

                ListObjectsV2Response response;

                do
                {
                    response = await client.ListObjectsV2Async(request);


                    response.S3Objects
                        .ForEach(obj => Console.WriteLine($"{obj.Key,-35}{obj.LastModified.ToShortDateString(),10}{obj.Size,10}"));

                    // If the response is truncated, set the request ContinuationToken
                    // from the NextContinuationToken property of the response.
                    request.ContinuationToken = response.NextContinuationToken;
                }
                while (response.IsTruncated);

                return true;
            }
            catch (AmazonS3Exception ex)
            {
                Console.WriteLine($"Error encountered on server. Message:'{ex.Message}' getting list of objects.");
                return false;
            }
        }

        #endregion

    }
}
