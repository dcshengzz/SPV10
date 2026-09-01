using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Security;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication.Import
{
    public interface ISampleOwnerImportService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task ImportSampleOwners(Guid ticketId, Guid dplyId, Guid userId);
    }

    public class SampleOwnerImportService : ISampleOwnerImportService
    {
        private readonly ILogger<SampleOwnerImportService> logger;
        private readonly ILogger<SampleOwnerImporter> importerLogger;

        public SampleOwnerImportService(
            ILogger<SampleOwnerImportService> serviceLogger, 
            ILogger<SampleOwnerImporter> importerLogger)
        {
            this.logger = serviceLogger ?? throw new ArgumentNullException(nameof(serviceLogger));
            this.importerLogger = importerLogger ?? throw new ArgumentNullException(nameof(importerLogger));
        }

        public async Task ImportSampleOwners(Guid ticketId, Guid dplyId, Guid userId)
        {
            try
            {
                logger.LogDebug(nameof(ImportSampleOwners) + " - called for ticketId={0}, dplyId={1}, userId={2}", ticketId, dplyId, userId);

                User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (!user.IsInRole(Constants.Role.Admins))
                    throw new PermissionException($"User {user.Id} ({user.Name}) does not have {Constants.Role.Admins} role");

                DynamicEntity ticket = await FileTicketApplication.GetQnnFileTicketById(ticketId);
                if (ticket == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_FILE_TICKET, ticketId);
                FileTicketApplication.TicketValidity validity = await FileTicketApplication.IsTicketValidForUser(ticket, user);
                if (FileTicketApplication.TicketValidity.Valid != validity)
                {
                    throw new InvalidOperationException($"Ticket {ticketId} is not valid for user {user.Id} ({user.Name}), reason={validity}");
                }

                FileTicketPurpose purpose = FileTicketApplication.GetPurpose(ticket);
                if(FileTicketPurpose.SampleOwnerImport != purpose)
                {
                    throw new InvalidOperationException($"Ticket {ticketId} has incorrect purpose {purpose}");
                }

                ImportContext context = await ImportContext.ForDeployment(dplyId);
                SampleOwnerImporter importer = new SampleOwnerImporter(importerLogger, context, userId);

                string token = FileTicketApplication.GetToken(ticket);
                Stream csvData = null;
                try
                {
                    Dictionary<string, string> properties;
                    (csvData, properties) = await CloverRuntime.ContentProvider.GetAsync(token);
                    if (csvData == null) throw new InternalException("Null stream returned by ContentProvider");

                    //TODO - perform some more checks on the properties to make sure its the type of file we expected

                    try
                    {
                        SampleOwnerImporter.ImportResults results = await importer.Import(csvData);
                        await EmailSuccessResultToUser(context, user, results);
                    }
                    catch(Exception e)
                    {
                        await EmailFailResultToUser(context, user, e);
                        throw;
                    }                    
                }
                finally
                {
                    //Close the stream and delete the file from the database
                    csvData?.Close();
                    await CloverRuntime.ContentProvider.RemoveAsync(token);
                    logger.LogDebug(nameof(ImportSampleOwners) + " - deleted file with token {0} from database", token);
                }

                logger.LogInformation(nameof(ImportSampleOwners) + " - completed for ticketId={0}, dplyId={1}, userId={2}", ticketId, dplyId, userId);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(ImportSampleOwners) + " - failed for ticketId={0}, dplyId={1}, userId={2}", ticketId, dplyId, userId);
            }
        }

        private async Task EmailSuccessResultToUser(ImportContext context, User user, SampleOwnerImporter.ImportResults results)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            if (user == null) throw new ArgumentNullException(nameof(user));
            if (results == null) throw new ArgumentNullException(nameof(results));

            string email = user.Email;
            if(string.IsNullOrWhiteSpace(email))
            {
                logger.LogError(nameof(EmailSuccessResultToUser) + " - no email for user {0} ({1})", user.Id, user.Name);
            }
            else
            {
                try
                {
                    StringBuilder body = new StringBuilder();
                    body.Append($"<p><b>{HttpUtility.HtmlEncode(context.DplyName)}</b></p>");
                    body.Append($"<p>The import completed successfully in approximately {results.DurationMinutes} minutes.</p>");
                    body.Append($"<p>Imported {results.AssignmentCount} sample owner assignments</p>");
                    if(results.UnknownUsers.Any())
                    {
                        if(results.UnknownUsers.Count < 1024)
                        {
                            string formattedUnknownUsers = HttpUtility.HtmlEncode(string.Join(", ", results.UnknownUsers));
                            body.Append($"<p><b>There were {results.UnknownUsers.Count} unknown user names:&nbsp;</b>{formattedUnknownUsers}</p>");
                        }
                        else
                        {
                            body.Append($"<p><b>There were {results.UnknownUsers.Count} unknown user names</b></p>");
                        }                        
                    }

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: email,
                        subject: $"Sample Owner Assignments imported successfully for {context.DplyName}",
                        body: body.ToString(),
                        senderDisplayName: appName);
                }
                catch(Exception e)
                {
                    logger.LogError(e, nameof(EmailSuccessResultToUser) + " - failed to send succcess notification to user {0} ({1}) with email {2}", user.Id, user.Name, email);
                }
            }
        }

        private async Task EmailFailResultToUser(ImportContext context, User user, Exception importException)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            if (user == null) throw new ArgumentNullException(nameof(user));
            if (importException == null) throw new ArgumentNullException(nameof(importException));

            string email = user.Email;
            if (string.IsNullOrWhiteSpace(email))
            {
                logger.LogError(nameof(EmailFailResultToUser) + " - no email for user {0} ({1})", user.Id, user.Name);
            }
            else
            {
                try
                {
                    StringBuilder body = new StringBuilder();
                    body.Append($"<p><b>{HttpUtility.HtmlEncode(context.DplyName)}</b></p>");
                    body.Append("<p>The import was not successful.</p>");
                    if(importException is SampleOwnerImporter.ImportException ie)
                    {
                        body.Append($"<p><b>Message:&nbsp;</b> {HttpUtility.HtmlEncode(ie.Message)}</p>");
                    }
                    body.Append("<p>Additional details may be found in the system application log files.</p>");

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: email,
                        subject: $"Sample Owner Assignment import failed for {context.DplyName}",
                        body: body.ToString(),
                        senderDisplayName: appName);
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(EmailFailResultToUser) + " - failed to send failure notification to user {0} ({1}) with email {2}", user.Id, user.Name, email);
                }
            }
        }
    }
}
