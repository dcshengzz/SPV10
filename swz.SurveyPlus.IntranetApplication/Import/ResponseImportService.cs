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
    /// <summary>
    /// Interface to the ResponseImportService for use by Hangfire
    /// </summary>
    public interface IResponseImportService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task ImportResponses(Guid ticketId, Guid dplyId, Guid userId);
    }

    public class ResponseImportService : IResponseImportService
    {
        private readonly ILogger<ResponseImportService> logger;

        public ResponseImportService(ILogger<ResponseImportService> serviceLogger)
        {
            this.logger = serviceLogger ?? throw new ArgumentNullException(nameof(serviceLogger));
        }

        public async Task ImportResponses(Guid ticketId, Guid dplyId, Guid userId)
        {
            try
            {
                logger.LogDebug(nameof(ImportResponses) + " - called for ticketId={0}, dplyId={1}, userId={2}", ticketId, dplyId, userId);

                User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"Failed to find user {userId}");
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
                if(FileTicketPurpose.ResponseImport != purpose)
                {
                    throw new InvalidOperationException($"Ticket {ticketId} has incorrect purpose {purpose}");
                }

                ImportContext context = await ImportContext.ForDeployment(dplyId);
                ResponseImporter importer = await ResponseImporter.GetInstanceUsingAppSettingsAsync(context, userId);

                //For 32K samples of MP survey I estimate the CSV response file will be maybe 100MB. The content provider
                //implementation naively loads it into memory, as does the ORM underneath. So that's 200MB++ right there,
                //maybe double depending on how it handles the encoding.
                //For this first cut of the service let's just use that, but if it proves a problem, then may need to write
                //the file to local machine disk, let the memory copies get GC'd and then stream the file from the disk.
                //This will also require cleanup etc...  so lets see how well it goes doing it the dumb way first (after all some
                //of the mail merge files are even bigger and they work).
                string token = FileTicketApplication.GetToken(ticket);
                Stream csvData = null;
                try
                {
                    Dictionary<string, string> properties;
                    (csvData, properties) = await CloverRuntime.ContentProvider.GetAsync(token);
                    if (csvData == null) throw new InternalException("Null stream returned by ContentProvider");

                    try
                    {
                        ResponseImporter.ImportResults results = await importer.Import(csvData);

                        logger.LogInformation(nameof(ImportResponses) + " - imported {0} responses in {1} minutes for deployment {2}, dplyId={3}, unknownUsers={4}", results.ResponseCount, results.DurationMinutes, context.DplyName, dplyId, results.UnknownUsers);

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
                    logger.LogDebug(nameof(ImportResponses) + " - deleted file with token {0} from database", token);
                }

                logger.LogInformation(nameof(ImportResponses) + " - completed for ticketId={0}, dplyId={1} ({2}), userId={3}", ticketId, dplyId, context.DplyName, userId);
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(ImportResponses) + " - failed for ticketId={0}, dplyId={1}, userId={2}", ticketId, dplyId, userId);
            }
        }

        private async Task EmailSuccessResultToUser(ImportContext context, User user, ResponseImporter.ImportResults results)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            if (user == null) throw new ArgumentNullException(nameof(user));
            if (results == null) throw new ArgumentNullException(nameof(results));

            string email = user.Email;
            if(string.IsNullOrWhiteSpace(email))
            {
                //nb: this case is unlikely as SurveyPlus UI makes the email mandatory
                logger.LogError(nameof(EmailSuccessResultToUser) + " - no email for user {0} ({1})", user.Id, user.Name);
            }
            else
            {
                try
                {
                    StringBuilder body = new StringBuilder();
                    body.AppendLine($"Deployment: {HttpUtility.HtmlEncode(context.DplyName)}");
                    body.AppendLine();
                    body.AppendLine($"The import completed successfully in approximately {results.DurationMinutes} minutes.");
                    body.AppendLine();
                    body.AppendLine($"Imported {results.ResponseCount} responses.");
                    body.AppendLine();
                    if(results.UnknownUsers.Any())
                    {
                        if(results.UnknownUsers.Count < 1024)
                        {
                            string formattedUnknownUsers = HttpUtility.HtmlEncode(string.Join(", ", results.UnknownUsers));
                            body.AppendLine($"There were {results.UnknownUsers.Count} unknown user names: {formattedUnknownUsers}");
                        }
                        else
                        {
                            body.Append($"There were {results.UnknownUsers.Count} unknown user names");
                        }                        
                    }

                    body.Replace("\n", "<br/>");

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    using (Email.IMailer mailer = await Email.CreateMailer(
                        mailSettings: mailSettings,
                        senderDisplayName: appName,
                        emailFrom: Email.UseDefaultEmailFrom))
                    {
                        bool success = await mailer.SendAsync(
                            mailTo: new String[] { email },
                            mailCc: null,
                            mailBcc: null,
                            subject: $"Responses imported successfully for {context.DplyName}",
                            body: body.ToString());
                        if (success)
                        {
                            logger.LogInformation(nameof(EmailSuccessResultToUser) + " - sent succcess notification to user {0} ({1}) with email {2} for deployment {3}", user.Id, user.Name, email, context.DplyName);
                        }
                        else
                        {
                            if(mailer.LastSendException != null)
                            {
                                throw mailer.LastSendException;
                            }
                            else
                            {
                                throw new InternalException("Mailer returned false but no exception recorded");
                            }
                        }
                    } // end using mailer
                }
                catch(Exception e)
                {
                    logger.LogError(e, nameof(EmailSuccessResultToUser) + " - failed to send success notification to user {0} ({1}) with email {2} for deployment {3}", user.Id, user.Name, email, context.DplyName);
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
                //nb: this case is unlikely as SurveyPlus UI makes the email mandatory
                logger.LogError(nameof(EmailFailResultToUser) + " - no email for user {0} ({1})", user.Id, user.Name);
            }
            else
            {
                try
                {
                    StringBuilder body = new StringBuilder();
                    body.AppendLine($"Deployment: {HttpUtility.HtmlEncode(context.DplyName)}");
                    body.AppendLine();
                    body.AppendLine("The import was not successful.");
                    body.AppendLine();
                    if (importException is ResponseImporter.ImportException ie)
                    {
                        body.AppendLine($"Message: {HttpUtility.HtmlEncode(ie.Message)}");
                    }
                    body.AppendLine();
                    body.AppendLine("Additional details may be found in the system application log files.");

                    body.Replace("\n", "<br/>");

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    using (Email.IMailer mailer = await Email.CreateMailer(
                        mailSettings: mailSettings,
                        senderDisplayName: appName,
                        emailFrom: Email.UseDefaultEmailFrom))
                    {
                        bool success = await mailer.SendAsync(
                            mailTo: new String[] { email },
                            mailCc: null,
                            mailBcc: null,
                            subject: $"Response import failed for {context.DplyName}",
                            body: body.ToString());
                        if (success)
                        {
                            logger.LogInformation(nameof(EmailFailResultToUser) + " - sent failure notification to user {0} ({1}) with email {2} for deployment {3}", user.Id, user.Name, email, context.DplyName);
                        }
                        else
                        {
                            if (mailer.LastSendException != null)
                            {
                                throw mailer.LastSendException;
                            }
                            else
                            {
                                throw new InternalException("Mailer returned false but no exception recorded");
                            }
                        }
                    } // end using mailer
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(EmailFailResultToUser) + " - failed to send failure notification to user {0} ({1}) with email {2} for deployment {3}", user.Id, user.Name, email, context.DplyName);
                }
            }
        }

    }
}
