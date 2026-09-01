using Microsoft.Extensions.Logging;
using swz.Clover.Core;
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

namespace swz.SurveyPlus.IntranetApplication
{
    public interface IPrePopulationService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task PrePopulateCSV(Guid userId, Guid targetDplyId, Guid ticketId);

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task PrePopulate(Guid userId, Guid sourceDplyId, Guid targetDplyId, IList<string> fieldNames);
    }

    /// <summary>
    /// Handles 'manual' pre-population of deployments. 
    /// (For recurrence pre-population this is handled 'on demand' elsewhere)
    /// </summary>
    public class PrePopulationService : IPrePopulationService
    {
        private readonly ILogger<PrePopulationService> logger;

        public PrePopulationService(ILogger<PrePopulationService> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task PrePopulate(
            Guid userId,
            Guid sourceDplyId,
            Guid targetDplyId,
            IList<string> fieldNames)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"No such user {userId}");

                Guid auditStructDivisionId = user.StructDivisionId.Value;
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(userId);

                logger.LogInformation(nameof(PrePopulate) + " - job starting, userId={0} ({1}), sourceDplyId={2}, targetDplyId={3}, fieldNames.Count={4}, eventBatch={5}", userId, user?.Name, sourceDplyId, targetDplyId, fieldNames?.Count, auditBatch.EventBatch);

                PrePopulator.Result result;
                using (PrePopulator.IDataSource dataSource = await PrePopulatorDeploymentDataSource.NewInstance(sourceDplyId))
                {
                    PrePopulator prePopulator = PrePopulator.NewInstance(dataSource);
                    PrePopulator.TargetContext target 
                        = await PrePopulator.TargetContext.NewInstanceTargetingSpecificAlias(targetDplyId, fieldNames);
                    result = await prePopulator.PrePopulate(target, auditBatch, auditStructDivisionId);
                }

                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                if (logger.IsEnabled(LogLevel.Information))
                {
                    //TODO - add userName
                    logger.LogInformation(nameof(PrePopulate) + " - completed, userId={0}, sourceDplyId={1}, targetDplyId={2}, duration={3} (about {4} minutes), result={5}", userId, sourceDplyId, targetDplyId, duration, ConversionUtils.ToMinutesRoundedUp(duration), result);
                }

                await SendNotification(Outcome.Success, userId, targetDplyId, duration, result);
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogError(e, nameof(PrePopulate) + " - caught unexpected exception, userId={0}, sourceDplyId={1}, targetDplyId={2}, duration={3} (about {4} minutes)", userId, sourceDplyId, targetDplyId, duration, ConversionUtils.ToMinutesRoundedUp(duration));

                await SendNotification(Outcome.Failure, userId, targetDplyId, duration, null);
            }
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task PrePopulateCSV(
            Guid userId,
            Guid targetDplyId,
            Guid ticketId)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"No such user {userId}");

                Guid auditStructDivisionId = user.StructDivisionId.Value;
                AuditBatch auditBatch = await AuditSettings.NewBatchAsync(userId);

                logger.LogInformation(nameof(PrePopulateCSV) + " - job starting, userId={0} ({1}), targetDplyId={2}, ticketId={3}, eventBatch={4}", userId, user?.Name, targetDplyId, ticketId, auditBatch.EventBatch);

                //Verify ticket and get the file token
                DynamicEntity ticket = await FileTicketApplication.GetQnnFileTicketById(ticketId);
                if (FileTicketPurpose.PrePopulation != FileTicketApplication.GetPurpose(ticket))
                    throw new InternalException("Incorrect ticket purpose");
                FileTicketApplication.TicketValidity validity = await FileTicketApplication.IsTicketValidForUser(ticket, user);
                if (FileTicketApplication.TicketValidity.Valid != validity)
                    throw new InternalException($"Ticket is invalid with reason {validity}");
                string token = FileTicketApplication.GetToken(ticket);

                try
                {
                    (Stream Stream, Dictionary<string, string> Properties) file 
                        = await CloverRuntime.ContentProvider.GetAsync(token);
                    if (file.Stream == null) throw new NotFoundException($"file not found for token {token}");

                    PrePopulator.Result result;
                    using (file.Stream)
                    {
                        using (PrePopulator.IDataSource dataSource = await PrePopulatorCsvDataSource.NewInstance(file.Stream))
                        {
                            PrePopulator prePopulator = PrePopulator.NewInstance(dataSource);
                            //At present we don't provide UI to select a subset of fields to pre-populate when
                            //pulling data from the CSV so any field for which the CSV supplies data will be
                            //pre-populated (hence user would need to remove unwanted columns from CSV).
                            PrePopulator.TargetContext target 
                                = await PrePopulator.TargetContext.NewInstanceTargetingAllAlias(targetDplyId);
                            result = await prePopulator.PrePopulate(target, auditBatch, auditStructDivisionId);
                        }
                    }

                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    long durationMinutes = duration / 1000 / 60;
                    if (logger.IsEnabled(LogLevel.Information))
                    {
                        //TODO - add userName
                        logger.LogInformation(nameof(PrePopulateCSV) + " - completed, userId={0}, targetDplyId={1}, token={2}, duration={3} (about {4} minutes), result={5}", userId, targetDplyId, token, duration, durationMinutes, result);
                    }

                    await SendNotification(Outcome.Success, userId, targetDplyId, duration, result);
                }
                finally
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(PrePopulateCSV) + " - removing file with token {0}", token);
                    //Delete the file from db now (this will also remove the ticket via on delete cascade)
                    await CloverRuntime.ContentProvider.RemoveAsync(token);
                }
            }
            catch(Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                long durationMinutes = duration / 1000 / 60;
                logger.LogError(e, nameof(PrePopulateCSV) + " - caught unexpected exception, userId={0}, targetDplyId={1}, ticketId={2}, duration={3} (about {4} minutes)", userId, targetDplyId, ticketId, duration, durationMinutes);

                await SendNotification(Outcome.Failure, userId, targetDplyId, duration, null);
            }
        }

        private enum Outcome { Success, Failure }

        //TODO - add a results report on metric from the job
        private async Task SendNotification(
            Outcome outcome, 
            Guid userId, 
            Guid dplyId, 
            long durationMilliseconds,
            PrePopulator.Result result)
        {
            try
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"No such user {userId}");

                string email = user.Email;
                if(!string.IsNullOrEmpty(email))
                {
                    int durationMinutes = ConversionUtils.ToMinutesRoundedUp(durationMilliseconds);

                    DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
                    if (qnnDply == null)
                        throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                    string dplyName = (string)qnnDply[Constants.FieldName.Name];
                    string intranetDomainAuthority = await SettingsHelper.Common.GetIntranetDomainAuthority();
                    string baseUrl = $"{Constants.MailLinksProtocol}{intranetDomainAuthority}";

                    //TODO - need to include the following info
                    //  rows with ignored UIDs
                    //  duplicate UID rows

                    string subject, body;
                    switch (outcome)
                    {
                        case Outcome.Success:
                            subject = $"Pre-populate for deployment {dplyName} complete";
                            StringBuilder b = new StringBuilder();
                            b.Append($"Pre-populate for deployment {HttpUtility.HtmlEncode(dplyName)} complete.<br />");
                            if(result != null)
                            {
                                b.Append($"Processed UID count: {result.ProcessedUids.Count}<br />");
                                b.Append($"Ignored Source UID count: {result.IgnoredUids.Count}<br />");
                                b.Append($"Duplicate Source UID count: {result.DuplicateUids.Count}<br />");
                                
                                if(result.IgnoredUids.Any())
                                {
                                    string encodedIgnored = string.Join(",",
                                    result.IgnoredUids
                                    .Order(Constants.Comparers.UidCaseInsensitive)
                                    .Select(uid => HttpUtility.HtmlEncode(uid))
                                    .ToList());
                                    b.Append($"<br />Ignored UIDs: {encodedIgnored}<br />");
                                }
                                
                                if(result.DuplicateUids.Any())
                                {
                                    string encodedDuplicates = string.Join(",",
                                    result.DuplicateUids
                                    .Order(Constants.Comparers.UidCaseInsensitive)
                                    .Select(uid => HttpUtility.HtmlEncode(uid))
                                    .ToList());
                                    b.Append($"<br />Duplicate UIDs: {encodedDuplicates}<br />");
                                }

                                //TODO - We ought to have a count of UIDs in the target that were not present in the source.
                                //       Currently the pre-populator doesn't check this (it is source driven after all)
                            }
                            b.Append($"<br />Please visit <a href='{baseUrl}'>{baseUrl}</a> for more info.<br />");
                            b.Append($"(Job duration was about {durationMinutes} minutes)<br />");
                            body = b.ToString();
                            break;

                        case Outcome.Failure:
                            subject = $"FAILED: Pre-populate for deployment {dplyName} was unsuccessful";
                            body = $"FAILED: Pre-populate for deployment {HttpUtility.HtmlEncode(dplyName)} was unsuccessful.<br />Please visit <a href='{baseUrl}'>{baseUrl}</a> for more info.<br />(Job duration was about {durationMinutes} minutes)<br />";
                            break;

                        default:
                            throw new NotImplementedException(outcome.ToString());
                    }

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: email,
                        subject: subject,
                        body: body,
                        senderDisplayName: appName);
                }
                else
                {
                    //We don't really expect this because the UI won't let you save a user without an email
                    logger.LogWarning(nameof(SendNotification) + " - user {0} ({1}) has no Email, dplyId={2}", userId, user?.Name, dplyId);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SendNotification) + " - caught an exception, outcome={0}, userId={1}, dplyId={2}, duration={3}", outcome, userId, dplyId, durationMilliseconds);
            }

        }
    }
}
