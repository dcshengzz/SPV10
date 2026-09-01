using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public interface ISampleListImportService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task ImportFromCsv(Guid userId, Guid listId, Guid ticketId, string password);
    }

    public class SampleListImportService : ISampleListImportService
    {
        private readonly ILogger<SampleListImportService> logger;

        public SampleListImportService(
            ILogger<SampleListImportService> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task ImportFromCsv(Guid userId, Guid listId, Guid ticketId, string password)
        {
            if(logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(ImportFromCsv) + " - called, userId={0}, listId={1}, ticketId={2}, password specified={3}", userId, listId, ticketId, (password != null));
            
            

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"User not found {userId}");

                if (!user.IsInRole(Constants.Role.SampleAdmin))
                    throw new PermissionException($"Lacks role {Constants.Role.SampleAdmin}");

                DynamicEntity list = await SampleListApplication.GetQnnListAsync(listId);
                if (list == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_LIST, listId);

                IList<string> listPropAliases
                    = (await SampleListApplication.GetQnnListPropsByListIdAsync(listId))
                    .Select(lp => (string)lp[Constants.FieldName.Alias])
                    .ToImmutableList();

                //TODO  - below is duplicated in ListController, factor out a method like what dply has
                Guid listStructDivisionId = (Guid)list[Constants.FieldName.StructDivisionId];

                HashSet<Guid> organisations
                    = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
                if (!organisations.Contains(listStructDivisionId))
                    throw new PermissionException($"Lacks organisation access to structDivision {listStructDivisionId}");

                string token = await VerifyTicketAndGetToken(ticketId, user);

                await TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.AssertUploadedCsvAttributes(logger, token, user);

                try
                {
                    //Pull all the data into memory first
                    SampleListApplication.SampleListReadResult csvReadResult;
                    (Stream Stream, Dictionary<string, string> Properties) file 
                        = await CloverRuntime.ContentProvider.GetAsync(token);
                    using (Stream stream = file.Stream)
                    {
                        csvReadResult 
                            = await SampleListApplication.ReadSampleListCsv(
                                stream, 
                                listPropAliases,
                                SampleListApplication.ReadSampleListCsvAction.ExtractData);
                        if (!csvReadResult.IsSuccess)
                        {
                            throw new InternalException($"Failed to parse CSV file, reason={csvReadResult.Outcome}, additionalInfo={csvReadResult.AdditionalInfo}");
                        }
                    }

                    SampleListImporter importer 
                        = await SampleListImporter.NewAsync(
                            qnnListId: listId,
                            importingUserId: userId);
                    Dictionary<string,string> report 
                        = await importer.ImportListSamples(password, csvReadResult.Data);

                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    if (logger.IsEnabled(LogLevel.Information))
                    {
                        if (logger.IsEnabled(LogLevel.Debug))
                            logger.LogDebug(nameof(ImportFromCsv) + " - completed in about {0} minutes ({1} ms), userId={2}, listId={3}", ConversionUtils.ToMinutesRoundedUp(duration), duration, userId, listId);
                    }

                    Boolean.TryParse(report["Completed"], out bool completed);
                    NotificationType result = completed ? NotificationType.Complete : NotificationType.Incomplete;
                    await SendNotification(result, userId, report);
                }
                finally
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(ImportFromCsv) + " - removing file with token {0}", token);
                    //Delete the file from db now (this will also remove the ticket via on delete cascade)
                    await CloverRuntime.ContentProvider.RemoveAsync(token);
                }
            }
            catch (Exception e)
            {                
                logger.LogError(e, nameof(ImportFromCsv) + " - caught unexpected exception, userId={0}, ticketId={1}, listId={2}", userId, ticketId, listId);

                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                Dictionary<string, string> placeholderReport = new Dictionary<string, string>();
                placeholderReport.Add("Completed", Boolean.FalseString);
                placeholderReport.Add("ListName", $"[{listId}]"); //GUID for list name indicates service-caught exception (for now)
                placeholderReport.Add("ExceptionMessage", e.Message);
                placeholderReport.Add("Duration", (duration).ToString());
                placeholderReport.Add("DurationSeconds", (duration / 1000).ToString());
                placeholderReport.Add("DurationMinutes", ConversionUtils.ToMinutesRoundedUp(duration).ToString());
                await SendNotification(NotificationType.Incomplete, userId, placeholderReport);
            }
        }

        /// <summary>
        /// Checks the ticket is marked as valid for this user and sample list import and returns the file token.
        /// Exceptions are raised if not valid.
        /// </summary>
        private async Task<string> VerifyTicketAndGetToken(Guid ticketId, User user)
        {
            DynamicEntity ticket = await FileTicketApplication.GetQnnFileTicketById(ticketId);
            if (ticket == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_FILE_TICKET, ticketId);
            if (FileTicketPurpose.SampleListImport != FileTicketApplication.GetPurpose(ticket))
                throw new InternalException("Incorrect ticket purpose");
            FileTicketApplication.TicketValidity validity = await FileTicketApplication.IsTicketValidForUser(ticket, user);
            if (FileTicketApplication.TicketValidity.Valid != validity)
                throw new InternalException($"Ticket is invalid with reason {validity}");
            string token = FileTicketApplication.GetToken(ticket);
            return token;
        }

        private enum NotificationType { Complete, Incomplete }

        private async Task SendNotification(NotificationType result, Guid userId, Dictionary<string, string> report)
        {
            try
            {
                User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"User not found {userId}");

                bool sendReportToUser = !string.IsNullOrEmpty(user.Email);
                if (sendReportToUser)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(SendNotification) + " - Sending {0} result email to {1} user={2} ({3}) with report={4}", result, user.Email, user?.Id, user?.Name, report);
                    }
                    string template;
                    switch (result)
                    {
                        case NotificationType.Complete:
                            template = Constants.EmailTemplate.ListImportEmailTemplate;
                            break;

                        case NotificationType.Incomplete:
                            template = Constants.EmailTemplate.ListImportEmailErrorTemplate;
                            break;

                        default:
                            throw new NotImplementedException(result.ToString());
                    }
                    await EmailHelper.SendUserEmailByFormTemplate(user, report, template);
                }
                else
                {
                    logger.LogWarning(nameof(SendNotification) + " - no email to send {0} notification to user={2} ({3}), report={4}", result, user?.Id, user?.Name, report);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SendNotification) + " - caught unexpected exception sending notification, result={0}, userId={1}, report={2}", result, userId, report);
            }
        }
    }
}
