using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using static swz.SurveyPlus.IntranetApplication.RecurrenceApplication;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public interface IScheduledExportService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task Export(Guid dplyId);

        public Task<string> ScheduleNextExport(DynamicEntity qnnDply);
    }

    public class ScheduledExportService : IScheduledExportService
    {
        private readonly ILogger<ScheduledExportService> logger;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public ScheduledExportService(
            ILogger<ScheduledExportService> logger, 
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task Export(Guid dplyId)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                logger.LogInformation(nameof(Export) + " - job starting, dplyId={0}", dplyId);

                EntityModel qnnDplyModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
                DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId, qnnDplyModel);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyId);

                bool scheduledExportEnabled = (bool)qnnDply[Constants.FieldName.ScheduledExportEnabled];
                if(!scheduledExportEnabled)
                {
                    //log at warning instead of info, as normally if you disable the export (via ui) it should have removed this job
                    logger.LogWarning(nameof(Export) + " - scheduled export is no longer enabled for dplyId={0} (job terminating)", dplyId);
                    return;
                }
                
                try
                {
                    //Response File contains the answer data (i.e a zip with a csv)
                    FileInfo responseFileInfo;                    
                    try
                    {
                        //create the zip file of response data on file system and also schedule the job to clean it up later
                        string responseFileName = await ResponseDataExport.CreateZippedResponses(surveyPlusOptions.ExportedDeploymentResponseFolderPath, dplyId);
                        responseFileInfo = new FileInfo(Path.Combine(surveyPlusOptions.ExportedDeploymentResponseFolderPath, responseFileName));
                        logger.LogDebug(nameof(Export) + " - created export zip for dplyId={0}, response file name={1}, response file size={2} bytes", dplyId, responseFileInfo.Name, responseFileInfo.Length);
                    }
                    catch (ResponseDataExport.NoResponseDataException nrde)
                    {
                        if(logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(Export) + " - no response data found for dplyId={0}, message={1}", dplyId, nrde.Message);
                        }
                        responseFileInfo = null;
                    }

                    //The Uploads File contains the respondent uploaded files
                    FileInfo uploadsFileInfo;
                    try
                    {
                        //create the zip file of respondent uploaded files (and schedule job to clean it up later)
                        //returns null if no uploaded files found for the deployment
                        string uploadsFileName = await ResponseDataExport.CreateZippedResponseUploadedFiles(dplyId, surveyPlusOptions.RespFilesDownloadFolderPath);
                        uploadsFileInfo = new FileInfo(Path.Combine(surveyPlusOptions.RespFilesDownloadFolderPath, uploadsFileName));
                    }
                    catch (ResponseDataExport.NoResponseUploadsException)
                    {
                        if(logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(Export) + " - no respondent uploads files found for dplyId={0}", dplyId);
                        }
                        uploadsFileInfo = null;
                    }                  

                    await AttachOrMoveFilesAndSendEmails(qnnDply, responseFileInfo, uploadsFileInfo);
                }
                finally
                {
                    //Setup the next export job
                    string nextJobId = null;
                    try
                    {
                        nextJobId = await ScheduleNextExport(qnnDply);
                        await qnnDplyModel.UpdateSingleAsync(qnnDply);
                    }
                    catch (Exception scheduleUpdateException)
                    {
                        throw new InternalException($"Error scheduling the next export and updating entity, nextJobId={nextJobId}", scheduleUpdateException);
                    }
                }
                
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogInformation(nameof(Export) + " - job completed. duration={0} ms", duration);
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogError(e, nameof(Export) + " caught an unexpected exception. dplyId={0}, duration={1} ms", dplyId, duration);
            }
            logger.LogDebug(nameof(Export) + " - end of method, dplyId={0}", dplyId);
        }

        /// <summary>
        /// Sends the email notification and file or file link to the user. These links will be restricted to data owners with 
        /// the deployment's struct division acces
        /// Depending on the file size and appsettings it will either be attached to the email directly or moved to the database and
        /// a file ticket link sent in the email. 
        /// </summary>
        /// <param name="qnnDply">deployment entity</param>
        /// <param name="responseDataFile">extract archive on filesystem for the response data (csv zip) from survey</param>
        /// <param name="responseFilesFile">extract archive on filesystem for the files uploaded by respondents</param>
        /// <returns></returns>
        private async Task AttachOrMoveFilesAndSendEmails(
            DynamicEntity qnnDply, 
            FileInfo responseDataFile, 
            FileInfo responseFilesFile)
        {
            Guid dplyId = (Guid)qnnDply[Constants.FieldName.Id];
            
            List<DynamicEntity> recipients = await GetRecipients(dplyId);
            if (!recipients.Any())
            {
                logger.LogWarning(nameof(AttachOrMoveFilesAndSendEmails) + " - no recipients configured for scheduled export of dplyId={0}", dplyId);
            }
            else
            {
                Guid deploymentStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];

                bool hasResponseData = (responseDataFile != null);
                bool hasResponseFiles = (responseFilesFile != null);
                long? responseDataLength = hasResponseData ? responseDataFile.Length : null;
                long? responseFilesLength = hasResponseFiles ? responseFilesFile.Length : null;

                //Here we will check if the file is short enough to attach to the email, if so we will
                //pull it into memory and delete the file from disk immediately. If it is too large then 
                //we will leave it in place and handle it differently later (in which case the byte
                //array will be null)
                byte[] responseData = ReadFileAndDeleteIfShortEnough(surveyPlusOptions.ScheduledExportResponseAttachmentBytes, responseDataFile);
                byte[] responseFiles = ReadFileAndDeleteIfShortEnough(surveyPlusOptions.ScheduledExportUploadsAttachmentBytes, responseFilesFile);
                bool useAttachmentForResponseData = (responseData != null);
                bool useAttachmentForResponseFiles = (responseFiles != null);

                DateTime? ticketExpiry = surveyPlusOptions.IsResponseDownloadLinkExpiring
                    ? DateTime.Now.AddHours(surveyPlusOptions.ResponseDownloadLinkExpiryHours)
                    : (DateTime?)null;

                DynamicEntity responseDataTicket;
                string responseDataDownloadUrl;
                if (hasResponseData && !useAttachmentForResponseData)
                {
                    responseDataTicket = await FileTicketApplication.MoveFileToDatabaseAndIssueTicket(
                        responseDataFile,
                        new FileTicketBuilder(FileTicketPurpose.ResponseData, deploymentStructDivisionId)
                            .AddRoleRestriction(Constants.Role.DataOwner)
                            .Expires(ticketExpiry)
                            .DeleteFileOnExpiry(true));
                    responseDataDownloadUrl = await FileTicketApplication.GetLink(responseDataTicket);
                }
                else
                {
                    responseDataTicket = null;
                    responseDataDownloadUrl = null;
                }

                DynamicEntity responseFilesTicket;
                string responseFilesDownloadUrl;
                if (hasResponseFiles && !useAttachmentForResponseFiles)
                {
                    responseFilesTicket = await FileTicketApplication.MoveFileToDatabaseAndIssueTicket(
                        responseFilesFile,
                        new FileTicketBuilder(FileTicketPurpose.ResponseFiles, deploymentStructDivisionId)
                            .AddRoleRestriction(Constants.Role.DataOwner)
                            .Expires(ticketExpiry)
                            .DeleteFileOnExpiry(true));
                    responseFilesDownloadUrl = await FileTicketApplication.GetLink(responseFilesTicket);
                }
                else
                {
                    responseFilesTicket = null;
                    responseFilesDownloadUrl = null;
                }

                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                string intranetDomainAuthority = await SettingsHelper.Common.GetIntranetDomainAuthority();
                using (Email.IMailer mailer = await Email.CreateMailer(mailSettings, appName))
                {
                    Guid dplyStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                    string dplyName = (String)qnnDply[Constants.FieldName.Name];
                    string subject = $"Scheduled response export for {dplyName}"; //subject does not require html encoding

                    foreach (DynamicEntity recipient in recipients)
                    {
                        Stream responseFileStream = null;
                        Stream uploadsFileStream = null;
                        try
                        {
                            Guid recipientId = (Guid)recipient[Constants.FieldName.SecurityUserId];
                            String userName = (string)recipient[Constants.FieldName.SecurityUserId + '_' + Constants.FieldName.Name];
                            String email = (string)recipient[Constants.FieldName.SecurityUserId + '_' + Constants.FieldName.Email];

                            bool okToSend = true;

                            bool isLocked = (bool)recipient[Constants.FieldName.SecurityUserId + '_' + Constants.FieldName.IsLocked];
                            if (isLocked)
                            {
                                logger.LogWarning(nameof(AttachOrMoveFilesAndSendEmails) + " - user {0} ({1}) is locked and will be ignored, dplyId={2}", recipientId, userName, dplyId);
                                okToSend = false;
                            }

                            bool hasNoEmail = string.IsNullOrWhiteSpace(email);
                            if (hasNoEmail)
                            {
                                logger.LogWarning(nameof(AttachOrMoveFilesAndSendEmails) + " - user {0} ({1}) has no email and will be ignored, dplyId={2}", recipientId, userName, dplyId);
                                okToSend = false;
                            }

                            bool isDataOwner = await IntranetAccountApplication.IsUserInRoleAsync(recipientId, Constants.Role.DataOwner);
                            if (!isDataOwner)
                            {
                                logger.LogWarning(nameof(AttachOrMoveFilesAndSendEmails) + " - user {0} ({1}) is not a DataOwner and will be ignored, dplyId={2}", recipientId, userName, dplyId);
                                okToSend = false;
                            }

                            //20231020 - we now check organisation subtree access for each recipient
                            Guid recipientStructDivisionId 
                                = (Guid)recipient[Constants.FieldName.SecurityUserId + '_' + Constants.FieldName.StructDivisionId];
                            HashSet<Guid> recipientOrganisations = await StructDivision.SelectChildrenAndThisIdSetAsync(recipientStructDivisionId);
                            bool isInDeploymentsOrganisation = recipientOrganisations.Contains(deploymentStructDivisionId);
                            if (!isInDeploymentsOrganisation)
                            {
                                logger.LogWarning(nameof(AttachOrMoveFilesAndSendEmails) + " - user {0} ({1}) is not in a valid organisation to access this deployment and will be ignored, dplyId={2}", recipientId, userName, dplyId);
                                okToSend = false;
                            }

                            if (okToSend)
                            {
                                bool responseAttached = false;
                                bool uploadsAttached = false;
                                List<Email.Item> attachments = new List<Email.Item>();
                                string body
                                    = $"<p>Dear {HttpUtility.HtmlEncode(userName)},<br />"
                                    + $"Scheduled Export of the responses for deployment: <strong>{HttpUtility.HtmlEncode(dplyName)}</strong>. </p>";
                                if (!hasResponseData)
                                {
                                    body += $"<p>No response was extracted as there is no response data.</p>";
                                }
                                else
                                {
                                    if (useAttachmentForResponseData)
                                    {
                                        body += $"<p>The responses file <b>{HttpUtility.HtmlEncode(responseDataFile.Name)}</b> has been attached to this email.</p>";
                                        //Need to create a new stream each time because smtp client disposes its attachments and they
                                        //dispose the stream they are based on, so we can't just keep the same memory stream and rewind
                                        responseFileStream = new MemoryStream(responseData);                                        
                                        attachments.Add( Email.CreateZipAttachment(responseFileStream, responseDataFile.Name) );
                                        responseAttached = true;
                                    }
                                    else
                                    {
                                        body += $"<p>You may download the response zip file from <a href='{responseDataDownloadUrl}'>{responseDataDownloadUrl}</a><br />";
                                        if(ticketExpiry != null)
                                        {
                                            body += $"The server will keep it until {ticketExpiry.Value.ToString(Constants.QnnDatetimeFormat)}, please download before then.</p>";
                                        }
                                            
                                    }

                                    if(!hasResponseFiles)
                                    {
                                        body += $"<p>There are no respondent uploaded files to extract.</p>";
                                    }
                                    else
                                    {
                                        if (useAttachmentForResponseFiles)
                                        {
                                            body += $"<p>The respondent uploads zip file <b>{HttpUtility.HtmlEncode(responseFilesFile.Name)}</b> has been attached to this email.</p>";
                                            uploadsFileStream = new MemoryStream(responseFiles);
                                            attachments.Add(Email.CreateZipAttachment(uploadsFileStream, responseFilesFile.Name));
                                            uploadsAttached = true;
                                        }
                                        else
                                        {
                                            body += $"<p>You may download the respondent uploads zip file from <a href='{responseFilesDownloadUrl}'>{responseFilesDownloadUrl}</a><br/>";

                                            if (ticketExpiry != null)
                                            {
                                                body += $"The server will keep it until {ticketExpiry.Value.ToString(Constants.QnnDatetimeFormat)}, please download before then.</p>";
                                            }
                                        }
                                    }
                                }
                                try
                                {
                                    bool sentOk = await mailer.SendAsync(
                                        mailTo: new string[] { email },
                                        mailCc: null,
                                        mailBcc: null,
                                        subject: subject,
                                        body: body,
                                        items: attachments.ToArray() );
                                    if (!sentOk) throw new InternalException("Send not successful", mailer.LastSendException);
                                    logger.LogInformation(nameof(AttachOrMoveFilesAndSendEmails) + " - sent email to user {0} ({1}), dplyId={2}, email={3}, Response File Size={4} bytes, Response File Attached={5}, Uploads File Size={6}, Uploads File Attached={7}", recipientId, userName, dplyId, email, responseDataLength, responseAttached, responseFilesLength, uploadsAttached);
                                }
                                catch (Exception sendFailed)
                                {
                                    logger.LogError(sendFailed, nameof(AttachOrMoveFilesAndSendEmails) + " - failed to send email to user {0} ({1}), dplyId={2}, email={3}", recipientId, userName, dplyId, email);
                                    //No further recovery. We will continue on and try the next recipient. 
                                }
                            } //end if okToSend
                        }
                        finally
                        {
                            responseFileStream?.Dispose();
                            uploadsFileStream?.Dispose();
                        }
                    } //end foreach recipient
                } //end using mailer
            } //end else block for when there are recipients
        }

        /// <summary>
        /// Returns a collection of QNN_SCHEDULED_EXPORT_RECIPIENT with the dwSecurityUser joined (fetch level 1)
        /// </summary>
        private async Task<List<DynamicEntity>> GetRecipients(Guid dplyId)
        {
            EntityModel qnnScheduledExportRecipientModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SCHEDULED_EXPORT_RECIPIENT, Constants.Level.FetchJoins);
            Filter byDplyId = Filter.And.Equal(dplyId, Constants.FieldName.DplyId);
            Order orderByUserName = Order.StartAsc(Constants.FieldName.SecurityUserId + '_' + Constants.FieldName.Name);
            List<DynamicEntity> recipients 
                = await qnnScheduledExportRecipientModel.GetAsync(byDplyId, orderByUserName, Paging.Empty);

            //Ensure distinct users so we don't notify anyone more than once
            recipients = recipients
                .GroupBy(r => (Guid)r[Constants.FieldName.SecurityUserId])
                .Select(r => r.First())
                .ToList(); 
            
            return recipients;
        }

        /// <summary>
        /// If a file is specified, and its length does not exceed maxBytes, then load it into a byte array and
        /// immediately remove the file from the file system.
        /// Otherwise take no action here and return null (caller to handle the file another way).
        /// </summary>
        /// <param name="fileInfo"></param>
        /// <returns>data or null</returns>
        private byte[] ReadFileAndDeleteIfShortEnough(long maxBytes, FileInfo fileInfo)
        {
            if (fileInfo == null)
                return null;

            if (!fileInfo.Exists)
                throw new ArgumentException($"{fileInfo.FullName} does not exist");

            if (fileInfo.Length > maxBytes)
            {
                //Leave file on disk and return null if it is too big
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ReadFileAndDeleteIfShortEnough) + " - did not read {0} because size={1} and maxBytes={2}", fileInfo.FullName, fileInfo.Length, maxBytes);
                }
                //Don't read or delete the file here. Caller will handle it (i.e. by copying to db and issuing ticket)
                return null;
            }
            else
            {
                //Delete file from disk and return its contents to caller if small enough to attach
                byte[] data = File.ReadAllBytes(fileInfo.FullName);
                fileInfo.Delete(); //20231020 - new behaviour, delete immediately if we read it here
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ReadFileAndDeleteIfShortEnough) + " - read {0} bytes from {1} and deleted file", data.Length, fileInfo.FullName);
                }
                return data;
            }
        }

        /// <summary>
        /// Schedule the next Scheduled Export job in hangfire, including setting relevant values in the QNN_DPLY, 
        /// but note that this DOES NOT save the modified entity (caller is expected to do so itself as the caller will
        /// usually have other changes to make too). (Please note however, that hangfire DOES NOT share the transaction with
        /// clover ORM, in other words if the ORM unit of work fails and the changes to the entity arent persisted, the
        /// changes to the job in the table will not get rolled back! - TODO - need to address this issue).
        /// This method will use scheduling values from the entity to determine when to next run the job and will delete
        /// the existing job (if any) mentioned in ScheduledExportJobId and set the new jobId there. 
        /// </summary>
        /// <param name="qnnDply">the QNN_DPLY entity (will be modified)</param>
        /// <returns>the new hangfire jobId (may be null)</returns>
        public async Task<string> ScheduleNextExport(DynamicEntity qnnDply)
        {
            string scheduledExportJobId = (string)qnnDply[Constants.FieldName.ScheduledExportJobId];
            if (!string.IsNullOrEmpty(scheduledExportJobId))
            {
                bool success = BackgroundJob.Delete(scheduledExportJobId); //(safe to call even if job doesn't exist anymore)
                logger.LogDebug(nameof(ScheduleNextExport) + " - deleted previous jobId={0}, success={1}", scheduledExportJobId, success);
            }

            bool scheduledExportEnabledOnEntry = (bool)qnnDply[Constants.FieldName.ScheduledExportEnabled];
            if (scheduledExportEnabledOnEntry)
            {
                DateTime now = DateTime.Now;

                Guid dplyId = (Guid)qnnDply[Constants.FieldName.Id];
                DateTime scheduledExportStartDate = (DateTime)qnnDply[Constants.FieldName.ScheduledExportStartDate];
                DateTime? scheduledExportEndDate = (DateTime?)qnnDply[Constants.FieldName.ScheduledExportEndDate];

                //Simple case for first export
                DateTime? scheduledExportNextDate;
                if (scheduledExportStartDate >= now 
                    && (scheduledExportEndDate==null || scheduledExportEndDate >= scheduledExportStartDate))
                {
                    scheduledExportNextDate = scheduledExportStartDate;
                }
                else
                {
                    string scheduledExportFrequency = (string)qnnDply[Constants.FieldName.ScheduledExportFrequency];
                    DateTime after = scheduledExportStartDate > now ? scheduledExportStartDate : now;
                    scheduledExportNextDate
                        = DateCalculator.CalculateNextStartDate(
                            dateStart: scheduledExportStartDate,
                            afterDate: after,
                            recurrenceFrequency: scheduledExportFrequency,
                            recurrenceEndDate: scheduledExportEndDate ?? DateTime.MaxValue);
                }

                qnnDply[Constants.FieldName.ScheduledExportNextDate] = scheduledExportNextDate;
                if (scheduledExportNextDate != null)
                {
                    scheduledExportJobId = BackgroundJob.Schedule<IScheduledExportService>(
                        service => service.Export(dplyId), scheduledExportNextDate.Value);
                } 
                else
                {
                    scheduledExportJobId = null;
                }
                qnnDply[Constants.FieldName.ScheduledExportJobId] = scheduledExportJobId;
                qnnDply[Constants.FieldName.ScheduledExportEnabled] = (scheduledExportJobId != null); //turn off if no more jobs to run
            }
            else
            {
                qnnDply[Constants.FieldName.ScheduledExportNextDate] = null;
                qnnDply[Constants.FieldName.ScheduledExportJobId] = null;
            }

            if(logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(ScheduleNextExport) + " - updated scheduled export for dplyId={0}, ScheduledExportStartDate={1}, ScheduledExportEndDate={2}, ScheduledExportFrequency={3}, ScheduledExportNextDate={4}, ScheduledExportJobId={5}, ScheduledExportEnabled={6} (was {7} on entry)",
                    (Guid)qnnDply[Constants.FieldName.Id],
                    (DateTime?)qnnDply[Constants.FieldName.ScheduledExportStartDate],
                    (DateTime?)qnnDply[Constants.FieldName.ScheduledExportEndDate],
                    (string)qnnDply[Constants.FieldName.ScheduledExportFrequency],
                    (DateTime?)qnnDply[Constants.FieldName.ScheduledExportNextDate],
                    (string)qnnDply[Constants.FieldName.ScheduledExportJobId],
                    (bool)qnnDply[Constants.FieldName.ScheduledExportEnabled],
                    scheduledExportEnabledOnEntry);
            }

            return (String)qnnDply[Constants.FieldName.ScheduledExportJobId];
        }
    }
}
