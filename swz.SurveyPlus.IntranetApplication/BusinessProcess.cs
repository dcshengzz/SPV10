using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.Clover.Security.Providers;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;
using System.Web;
using swz.SurveyPlus.IntranetApplication.Import;
using swz.Clover.Core.Security;
using swz.Clover.AuthServices.Jwt.Data;
using swz.Clover.Core.Metadata;
using User = swz.Clover.Core.Security.User;

namespace swz.SurveyPlus.IntranetApplication
{
    //n.b All the Enqueue, Schedule, and entrypoint methods are declated async (even where unnecessary)
    //    for consistency and to facilitate future changes (as changing entrypoints can affect existing instances)

    //Note: we are trying to refactor to move out all actual logic from here and leave this class as
    //a central point for simple scheduled trigger methods (eg with hangfire)
    //that will delegate elsewhere to do the actual work. 
    public static class BusinessProcess
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(BusinessProcess));

        /// <summary>
        /// Methods for scheduling certain jobs. 
        /// Note that most *recurring* jobs would typically be scheduled from StartupIntranet.
        /// </summary>
        public static class Schedule
        {
            private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(Schedule));

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            // The Schedule static class is to put the methods that will schedule the job.   //
            // DO NOT PUT JOB ENTRYPOINTS IN Schedule!                                       //
            // Those to be sceduled for immediate execution should go in Enqueue             //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// (You should prefer to use the FileTicket mechanism instead of this)
            /// Schedule a hangfire job to cleanup the specified file in dwUploadedFiles in the near future.
            /// Caller is responsible for checking access rights etc.
            /// Note: we now also have the QNN_FILE_TICKET mechanism that may be more appropriate to use for file cleanup in many cases.
            /// </summary>
            /// <param name="token">file token from the ContentProvider</param>
            /// <param name="hours">(optional) how many hours later (default is 48)</param>
            public static void CleanupDwFile(string token, int hours = 48)
            {
                if (hours < 0 || hours > (7 * 24))
                {
                    throw new ArgumentOutOfRangeException("Invalid delay: " + hours, nameof(hours));
                }
                else if (hours == 0)
                {
                    BackgroundJob.Enqueue(() => BusinessProcess.CleanupDwFile(token));
                }
                else
                {
                    BackgroundJob.Schedule(() => BusinessProcess.CleanupDwFile(token), TimeSpan.FromHours(hours));
                }
            }

            public static async Task<string> PrePopulate(
                DateTime scheduledTime,                
                User user,
                Guid sourceDplyId,
                Guid targetDplyId,
                List<string> fieldNames)
            {
                if (user == null) throw new ArgumentNullException(nameof(user));
                if (fieldNames == null) throw new ArgumentNullException(nameof(fieldNames));

                string jobId = BackgroundJob.Schedule<IPrePopulationService>(service =>
                    service.PrePopulate(user.Id, sourceDplyId, targetDplyId, fieldNames),
                    new DateTimeOffset(scheduledTime));

                Logger.LogInformation(nameof(PrePopulate) + " - scheduled jobId {0} for {1}, userId={2} ({3}), sourceDplyId={4}, targetDplyId={5}, prePopulateFieldNames.Count={6}", jobId, scheduledTime.ToString(Constants.QnnDatetimeFormat), user?.Id, user?.Name, sourceDplyId, targetDplyId, fieldNames?.Count);

                return jobId;
            }

            public static async Task<string> PrePopulateCSV(
                DateTime scheduledTime,
                User user,
                Guid targetDplyId,
                Guid ticketId)
            {
                if (user == null) throw new ArgumentNullException(nameof(user));

                string jobId = BackgroundJob.Schedule<IPrePopulationService>(service =>
                    service.PrePopulateCSV(user.Id, targetDplyId, ticketId),
                    new DateTimeOffset(scheduledTime));

                Logger.LogInformation(nameof(PrePopulateCSV) + " - scheduled jobId {0} for {1}, userId={2} ({3}), targetDplyId={4}, ticketId={5}", jobId, scheduledTime.ToString(Constants.QnnDatetimeFormat), user?.Id, user?.Name, targetDplyId, ticketId);

                return jobId;
            }

            /// <summary>
            /// Add/update/or remove a SendUserAccessMatrix job
            /// </summary>
            public static void SendUserAccessMatrix(
                Guid scheduleId,
                Guid structDivisionId,
                string cronSchedule,
                bool isEnabled)
            {
                //for convenience we borrow the guid to use as a unique jobId
                //...but I thought each organisation would only have one schedule, so why not borrow from structDivisionId?
                //well since this is already in use and there will be legacy jobs scheduled, we'll keep using it
                string jobId = scheduleId.ToString();
                if (isEnabled)
                {
                    //Note the entrypoint name has been changed. The old entrypoint still exists to support
                    //legacy jobs in existing production instances and will appear in the hangfire dashboard
                    //as BusinessProcess.SendAccessReportScheduleEmail
                    //While new jobs will use BusinessProcess.SendUserAccessMatrix
                    //Both forms continue to share the Id of their relevant AccessReportSchedule entity as their jobId.
                    RecurringJob.AddOrUpdate(
                        jobId, 
                        () => BusinessProcess.SendUserAccessMatrix(structDivisionId),
                        cronSchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(jobId);
                }
            }

        } //end of static class Schedule


        // // // // // // // // // // // // // // // // // // // // // // // //


        /// <summary>
        /// Methods to Enqueue various business process methods for immediate background execution
        /// </summary>
        public static class Enqueue
        {
            private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(Enqueue));

            // // // // // // // // // // // // // // // // // // // // // // // // // // // //
            // The Enqueue static class is to put the methods that will enqueue the job.     //
            // DO NOT PUT JOB ENTRYPOINTS IN Enqueue!                                        //
            // // // // // // // // // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// Send an email in the background immediately (using Hangfire). 
            /// </summary>
            public static async Task SendEmail(MailSettings mailSettings, string email, string subject, string body, string appName)
            {
                //This method was previously named SendEmailBackground and renamed to avoid confusion with BackgroundSendEmail
                //I haven't made a version that gets the MailSettings for you, if called in a loop it would be considerably
                //less efficient, and with the MailSettings factory method its trivial for the caller to get them now.

                //email can now be a comma delimited set of address and will be split in the job to pass multiple To address

                //nb: we break out the settings from the MailSettings class here so we don't have to think about any issues
                //    relating to its serialisation for recording in the hangfire tables such as when the MailSettings is
                //    modified which would make serialised instances out of date. Thankfully this doesn't happen often.
                BackgroundJob.Enqueue(() => BusinessProcess.BackgroundSendEmail(
                    mailSettings.MailServerLogin,
                    email,
                    subject,
                    body,
                    appName,
                    mailSettings.MailServer,
                    mailSettings.MailServerPort,
                    mailSettings.MailServerPass,
                    mailSettings.MailServerSsl,
                    mailSettings.MailServerDefaultFrom));
            }

            /// <summary>
            /// Enqueue an immediate hangfire job to send a QR Code for a Google Authenticator seed in the background
            /// (queues a background job for BackgroundSendQrCodeEmail)
            /// </summary>
            /// <param name="mailTo"></param>
            /// <param name="issuer">Pass the application name here (issuer of the code)</param>
            /// <param name="accountName">Name of user for whom code is intended</param>
            /// <param name="secret">the GA secret</param>
            public static async Task SendGoogleAuthenticatorSeed(
                string mailTo,
                string issuer,
                string accountName,
                byte[] secret)
            {
                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(SendGoogleAuthenticatorSeed) + " - called for accountName={0}, mailTo={1}", accountName, mailTo);
                }
                //20220929 - I have simplified this code and the mail settings are now looked up in the background job.
                //           This does have the negative impact that when called in a loop for multiple users we will
                //           perform multiple lookups, however we don't expect vast numbers of intranet users to be
                //           done at once, and even if they are it is not a regular occurence.
                //           TODO - ideally the re-salting could be done in the job to and the job passed a list
                if (string.IsNullOrEmpty(mailTo)) throw new ArgumentException("required", nameof(mailTo));
                if (string.IsNullOrEmpty(issuer)) throw new ArgumentException("required", nameof(issuer));
                if (string.IsNullOrEmpty(accountName)) throw new ArgumentException("required", nameof(accountName));
                if (secret == null || secret.Length == 0) throw new ArgumentException("required", nameof(secret));
                string secretBase64 = Convert.ToBase64String(secret);
                string jobSecret = EncryptionHelper.EncryptStr(secretBase64, Constants.LoginKey, Constants.LoginIv); //obfuscate value in hangfire table
                BackgroundJob.Enqueue(() => BusinessProcess.BackgroundSendQrCodeEmail(mailTo, issuer, accountName, jobSecret));
            }

            /// <summary>
            /// Immediately run a background job to extract the response data for the specific deployment 
            /// and email a download link to the current user when it is done. 
            /// Current user must have DataOwner role and StructDivision access to the specified deployment.
            /// </summary>
            public static async Task ExportDeploymentResponseData(Guid dplyId)
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                Logger.LogInformation(nameof(ExportDeploymentResponseData) + " - user={0} ({1}), dplyId={2}", user?.Id, user?.Name, dplyId);
                BackgroundJob.Enqueue<IResponseExportService>(service => service.ExportDeploymentResponseData(dplyId, user.Id));
            }

            /// <summary>
            /// Enqueue a background job for immediate execution to prepare a zip file containing the files uploaded by respondents
            /// as part of their response for the specified deployment and email a download link to the current user when it is done.
            /// Current user must have DataOwner role and StructDivision access to the specified deployment.
            /// </summary>
            public static async Task ExportDeploymentResponseFiles(Guid dplyId)
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                Logger.LogInformation(nameof(ExportDeploymentResponseFiles) + " - user={0} ({1}), dplyId={2}", user?.Id, user?.Name, dplyId);
                BackgroundJob.Enqueue<IResponseExportService>(service => service.ExportDeploymentResponseFiles(dplyId, user.Id));
            }

            public static async Task ExportFrequencyCountReport(Guid dplyId)
            {
                BackgroundJob.Enqueue(() =>
                    BusinessProcess.ExportFrequencyCountReport(dplyId, CloverRuntime.Security.CurrentUser));
            }

            /// <summary>
            /// Enqueue hangfire job to run the Respondent Participation Report in the background
            /// </summary>
            /// <param name="UID"></param>
            /// <param name="RespName"></param>
            /// <param name="StatusIDs"></param>
            /// <param name="DplyIDs"></param>
            /// <returns></returns>
            public static async Task ExportParticipationReport(
                string UID,
                string RespName,
                List<Guid> StatusIDs,
                List<Guid> DplyIDs)
            {
                //TODO - try to avoid serialising the SecurityUser objects (eg better to pass an Id and lookup in the job)
                BackgroundJob.Enqueue(() =>
                    BusinessProcess.ExportParticipationReport(UID, RespName, StatusIDs, DplyIDs, CloverRuntime.Security.CurrentUser));

            }

            public static async Task ExportStatusResponseDetails(Guid dplyId, List<string> statusTitles, bool isExcludeExempted)
            {
                Guid currentUserId = (await CloverRuntime.Security.GetCurrentUserAsync()).Id;
                BackgroundJob.Enqueue(() =>
                    BusinessProcess.ExportStatusResponseDetails(dplyId, statusTitles, isExcludeExempted, currentUserId));

            }

            public static async Task ResponseImport(Guid ticketId, Guid dplyId)
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                Logger.LogInformation(nameof(ResponseImport) + " - user={0} ({1}), dplyId={2}, ticketId={3}", user?.Id, user?.Name, dplyId, ticketId);
                BackgroundJob.Enqueue<IResponseImportService>(service => service.ImportResponses(ticketId, dplyId, user.Id));
            }

            public static async Task SampleOwnerImport(Guid ticketId, Guid dplyId)
            {
                Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                Logger.LogInformation(nameof(SampleOwnerImport) + " - user={0} ({1}), dplyId={2}, ticketId={3}", user?.Id, user?.Name, dplyId, ticketId);
                BackgroundJob.Enqueue<ISampleOwnerImportService>(service => service.ImportSampleOwners(ticketId, dplyId, user.Id));
            }

            public static async Task MaintenancePerformSmtpTest(Guid structDivisionId)
            {
                if(Logger.IsEnabled(LogLevel.Trace))
                {
                    Clover.Core.Security.User user = await CloverRuntime.Security.GetCurrentUserAsync();
                    Logger.LogTrace(nameof(MaintenancePerformSmtpTest) + " - user={0} ({1}), structDivisionId={2}", user?.Id, user?.Name, structDivisionId);
                }
                BackgroundJob.Enqueue(() => BusinessProcess.MaintenancePerformSmtpTest(structDivisionId));
            }

            public static async Task PrePopulate(
                User user,
                Guid sourceDplyId,
                Guid targetDplyId,
                List<string> fieldNames)
            {
                if (user == null) throw new ArgumentNullException(nameof(user));
                if (fieldNames == null) throw new ArgumentNullException(nameof(fieldNames));

                string jobId = BackgroundJob.Enqueue<IPrePopulationService>(service =>
                    service.PrePopulate(user.Id, sourceDplyId, targetDplyId, fieldNames));

                Logger.LogInformation(nameof(PrePopulate) + " - enqueued jobId={0}, userId={1} ({2}), sourceDplyId={3}, targetDplyId={3}, prePopulateFieldNames.Count={4}", jobId, user?.Id, user?.Name, sourceDplyId, targetDplyId, fieldNames?.Count);
            }

            public static async Task PrePopulateCSV(
                User user,
                Guid targetDplyId,
                Guid ticketId)
            {
                if (user == null) throw new ArgumentNullException(nameof(user));

                string jobId = BackgroundJob.Enqueue<IPrePopulationService>(service =>
                    service.PrePopulateCSV(user.Id, targetDplyId, ticketId));

                Logger.LogInformation(nameof(PrePopulateCSV) + " - enqueued jobId {0} , userId={1} ({2}), targetDplyId={3}, ticketId={4}", jobId, user?.Id, user?.Name, targetDplyId, ticketId);
            }

            public static async Task ImportSampleListCSV(
                User user,
                Guid listId, 
                Guid ticketId,
                string password)
            {
                if (user == null) 
                    throw new ArgumentNullException(nameof(user));
                if (password != null && password.Trim() == "") 
                    throw new ArgumentException("must have value or be null, not empty", nameof(password));

                string jobId = BackgroundJob.Enqueue<ISampleListImportService>(service =>
                    service.ImportFromCsv(user.Id, listId, ticketId, password));

                Logger.LogInformation(nameof(ImportSampleListCSV) + " - enqueued jobId {0} , userId={1} ({2}), listId={3}, ticketId={4}, password specified={5}", jobId, user?.Id, user?.Name, listId, ticketId, (password!=null));
            }

            public static async Task InitialiseDeployment(
                Guid dplyId,
                bool isMailMerge,
                bool isEmail,
                bool isProfile,
                string emailFrom,
                string body,
                string bodyJson,
                string subject)
            {
                Guid currentUserId = (await CloverRuntime.Security.GetCurrentUserAsync()).Id;
                BackgroundJob.Enqueue<IDeploymentInitialisationService>(service =>
                    service.InitialiseDeployment(
                        currentUserId, 
                        dplyId,
                        isMailMerge,
                        isEmail,
                        isProfile,
                        emailFrom,
                        body,
                        bodyJson,
                        subject));
            }

            /// <summary>
            /// Use a background job to print survey in pdf and email to user.
            /// </summary>
            /// <param name="formName"></param>
            /// <param name="emails"></param>
            /// <param name="surveyName"></param>
            /// <returns></returns>
            public static void BackendPrintSurvey(
                string formName,
                string emails,
                string surveyName,
                string responseData)
            {
                BackgroundJob.Enqueue<IBackendPrintService>(service =>
                    service.BackendPrintSurvey(formName, emails, surveyName, responseData));
            }

        } //end of static class Enqueue


        // // // // // // // // // // // // // // // // // // // // // // // //


        //TODO - ideally I would like to be able to inject the SurveyPlusOptions for the hangfire job, but this means
        //       changing the signature and figuring out how to set it up in hangfire, so for now I will just use a raw
        //       static variable to pass this. Don't change the value of this after startup!
        //       20230313 - first got one kludge var, now grown to three... sigh
        //                  (NO!, I dont want a global reference to SurveyPlusOptions here - it should be injected!)
        //       20230314 - and now there are 4!
        //       20230802 - You can refer to the scheduled exports feature to see how to use injection with hangfire
        public static string KludgeToPassMailMergeFolderPath = null;
        public static string KludgeToPassMailMergeArchivedFolderCommand = null;
        public static string KludgeToPassMailMergeArchivedFolderCommandArguments = null;
        public static string KludgeToPassMailMergeArchivedFolderExtension = null;

        /// <summary>
        /// Legacy entrypoint for profile mail merge.
        /// This will be removed in a future version. It is left here for now to support any existing jobs with
        /// this signature that might still be scheduled for the future in a production environment.
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        [Obsolete]
        public static async Task<bool> SendEmailsAndMailMergeAndGenerateProfile(
            StringBuilder subject,
            StringBuilder body, 
            List<Guid> listSampleIds, 
            Guid dplyId, 
            bool bMailMerge, 
            bool bEmail,
            bool bGenerateProfile, 
            Guid dplyMsgId, 
            Guid userId, 
            string emailFrom, 
            List<Guid> listStatusIds)
        {
            //nb: dplyId is somewhat redundant here as we could look it up from QNN_DPLY_MSG, however since we don't
            //    want to change the method signature we may as well just leave it for now

            bool success = false;
            try
            {
                if (bMailMerge || bEmail || bGenerateProfile)
                {
                    ProfileMailMerger profileMailMerger
                        = await ProfileMailMerger.NewInstanceAsync(userId, dplyId, body.ToString());
                    profileMailMerger.GenerateMailMerge = bMailMerge;
                    profileMailMerger.GenerateProfile = bGenerateProfile;
                    
                    if(bMailMerge)
                    {
                        //TODO - we should inject the options into this job rather than rely on this ugly kludge to pass them
                        profileMailMerger.MailMergeFolderPath = KludgeToPassMailMergeFolderPath;
                        profileMailMerger.MailMergeArchivedFolderCommand = KludgeToPassMailMergeArchivedFolderCommand;
                        profileMailMerger.MailMergeArchivedFolderCommandArguments = KludgeToPassMailMergeArchivedFolderCommandArguments;
                        profileMailMerger.MailMergeArchivedFolderExtension = KludgeToPassMailMergeArchivedFolderExtension;
                    }

                    //Apply mail merge defaults from dwAppSettings (don't waste the query if just doing profile)
                    if (bMailMerge || bEmail)
                    {
                        (await MailMergeSettings.GetFromAppSettingsAsync())
                            .ApplyTo(profileMailMerger);
                    }

                    if (bEmail)
                    {
                        profileMailMerger.GenerateEmail = true;
                        profileMailMerger.EmailFrom = emailFrom;
                        profileMailMerger.EmailSubject = subject?.ToString();
                    }

                    profileMailMerger.ApplyOptionsFromTemplate();

                    if (listSampleIds != null && listSampleIds.Count > 0)
                    {
                        success = profileMailMerger.ExecuteBySamples(dplyMsgId, listSampleIds);
                    }
                    else if (listStatusIds != null && listStatusIds.Count > 0)
                    {
                        success = profileMailMerger.ExecuteByStatus(dplyMsgId, listStatusIds);
                    }
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(SendEmailsAndMailMergeAndGenerateProfile) + " - caught unexpected exception, dplyId={0}, dplyMsgId={1}", dplyId, dplyMsgId);
                return false;
            }
            return success;
        } // end of SendEmailsAndMailMergeAndGenerateProfile

        /// <summary>
        /// Well-known identifier for the CleanupMailMerge job. This job has been removed as the ProfileMailMerger 
        /// will now clean up the file immediately after copying it to the database. The identifier remains to allow
        /// for removing the old job in existing instances.
        /// </summary>
        public static readonly string ObsoleteJobId_CleanupMailMerge = "CleanupMailMerge";

        /// <summary>
        /// This is an unused variant of BackgroundSendEmail that remains here in case there are any production 
        /// instances with hangfire jobs still using this signature. It will be removed in a future build.
        /// It does a lookup to get the new MailServerDefaultFrom setting and include this in the call to the new
        /// variant.
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        [Obsolete]
        public static async Task BackgroundSendEmail(
            string mailServerLogin,
            string mailTo,
            string subject,
            string body,
            string senderDisplayName,
            string mailServer,
            int mailServerPort,
            string mailServerPass,
            bool mailServerSsl)
        {
            Logger.LogWarning(nameof(BackgroundSendEmail) + " - call made to the obsolete variant of this method");
            String mailServerDefaultFrom 
                = await SettingsHelper.GetValue(MailSettings.MAIL_SERVER_DEFAULT_FROM, assertDefined: true);
            await BackgroundSendEmail(
                mailServerLogin: mailServerLogin,
                mailTo: mailTo,
                subject: subject,
                body: body,
                senderDisplayName: senderDisplayName,
                mailServer: mailServer,
                mailServerPort: mailServerPort,
                mailServerPass: mailServerPass,
                mailServerSsl: mailServerSsl,
                mailServerDefaultFrom: mailServerDefaultFrom);
        }

        /// <summary>
        /// This is a HangFire Entrypoint. If you wish to enqueue the sending of an email in the background please use EnqueueSendEmail,
        /// or if you wish to send directly call the Email or EmailHelper methods. This is not intended to be called directly by
        /// application code. It is public only because Hangfire needs that.
        /// Note that this method takes in the mail server settings, so these will be in the job. For Enqueue this is ok, but if
        /// setup as a job in the future they may be stale by the time the job runs. You are advised instead to use a custom job that
        /// can retrieve up to date settings at that point. 
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task BackgroundSendEmail(
            string mailServerLogin,
            string mailTo,
            string subject,
            string body,
            string senderDisplayName,
            string mailServer,
            int mailServerPort,
            string mailServerPass,
            bool mailServerSsl,
            string mailServerDefaultFrom)
        {
            //nb: I have chosen to take the individual settings and the reconstruct the MailSettings object here,
            //    so that we avoid the small overhead of serialization of the MailSettings object for hangfire jobs
            //    in the database, and it takes the settings instead of looking them up here as calling code might
            //    be calling this in a loop (NOT RECOMMENDED!) so making them be passed gives the caller the opportunity
            //    to at least optimise that to a single settings lookup.
            // TODO - however , I don't really like this design, especially as if the job is scheduled for non-immediate
            //        execution the settings may change before it is called. Id prefer if we had a new method like
            //        BackgroundSendSingleEmail that does the lookup etc itself, or it could take a collection of
            //        emails and use a sender or something. To consider.
            await Email.SendAsync(
                mailSettings: new MailSettings(
                    mailServer: mailServer,
                    mailServerPort: mailServerPort,
                    mailServerLogin: mailServerLogin,
                    mailServerPass: mailServerPass,
                    mailServerSsl: mailServerSsl,
                    mailServerDefaultFrom: mailServerDefaultFrom),
                mailTo: Email.SplitAddresses(mailTo), //this can be multivalued comma delimited list now
                mailCc: null,
                mailBcc: null,
                subject: subject,
                body: body,
                senderDisplayName: senderDisplayName);
        }

        /// <summary>
        /// Hangfire EntryPoint for sending a Google Authenticator seed QR code (enqueued by EnqueueSendGoogleAuthenticatorSeed)
        /// Not intended to be called directly.
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task BackgroundSendQrCodeEmail(
            string mailTo,
            string issuer,
            string accountName,
            string jobSecret)
        {
            try
            {
                if (string.IsNullOrEmpty(mailTo)) throw new ArgumentException("required", nameof(mailTo));
                if (string.IsNullOrEmpty(issuer)) throw new ArgumentException("required", nameof(issuer));
                if (string.IsNullOrEmpty(accountName)) throw new ArgumentException("required", nameof(accountName));
                if (string.IsNullOrEmpty(jobSecret)) throw new ArgumentException("required", nameof(jobSecret));
                jobSecret = EncryptionHelper.DecryptStr(jobSecret, Constants.LoginKey, Constants.LoginIv);
                byte[] secret = Convert.FromBase64String(jobSecret);

                string subject = $"{accountName} authenticator key QR code for {issuer}";

                string googleAuthenticatorKey = GoogleAuthenticator.GenerateEncodedKey(secret); //Base32, should be URL-safe
                string slightlyMoreReadableKey = GoogleAuthenticator.PrettyPrintEncodedKey(googleAuthenticatorKey);

                //Issuer and appname should be uri encoded (using %20 for space and not +) and no colons in either
                //See: https://github.com/google/google-authenticator/wiki/Key-Uri-Format
                string encodedIssuer = Uri.EscapeDataString(issuer.Replace(":", ""));
                string encodedAccountName = Uri.EscapeDataString(accountName.Replace(":", ""));
                string label = $"{encodedIssuer}:{encodedAccountName}";
                string qrCodeString = $"otpauth://totp/{label}?secret={googleAuthenticatorKey}&issuer={encodedIssuer}";
                byte[] qrCode = GoogleAuthenticator.GenerateQrCodePng(qrCodeString);

                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(BackgroundSendQrCodeEmail) + " - sending authenticator key QR code to {0}", mailTo);
                }

                using (Stream qrCodeStream = new MemoryStream(qrCode))
                {
                    string cid = "key.png";
                    string body =
                          $"Dear {HttpUtility.HtmlEncode(accountName)},<p />"
                        + $"<p>Here is your Google Authenticator key for {HttpUtility.HtmlEncode(issuer)}.<br />"
                        + $"Please keep it strictly confidential and delete this email as soon as possible. </p>"
                        + $"<p>Use your Authenticator app to scan the attached QR Code for quick &amp; easy setup.<br />"
                        + $"<img src=\"cid:{cid}\"><br/>"
                        + $"Alternatively, you may copy the following key into your Authenticator app if you are unable to scan the QR code:<br />"
                        + $"<span style=\"font-size: large;\">{slightlyMoreReadableKey}</span></p>";                        
                    try
                    {
                        MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                        await Email.SendAsync(
                            mailSettings: mailSettings,
                            mailTo: mailTo,
                            subject: subject,
                            body: body,
                            senderDisplayName: issuer,
                            emailFrom: Email.UseDefaultEmailFrom,
                            items: Email.CreatePngEmbed(qrCodeStream, cid));
                    }
                    catch (Exception e)
                    {
                        Logger.LogError(e, nameof(BackgroundSendQrCodeEmail) + " - failed to send authenticator key QR code to {0}", mailTo);
                        //Don't raise this any further
                    }
                } //end using qrCodeStream
            }
            catch(Exception e)
            {
                //This is a hangfire job, so we don't raise the error out of here.
                Logger.LogError(e, nameof(BackgroundSendQrCodeEmail) + " - failed for mailTo={1}", mailTo);
            }
        }

        /// <summary>
        /// LEGACY ENTRYPOINT REPLACED BY TakeReportSnapShot
        /// This will be removed in a future version and exists to support existing jobs in the db, although by rights
        /// they should have already been updated by code in StartupIntranet. 
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task ProcessDplyReport(List<string> unused)
        {
            //unused argument used to be dplyIds and was list of *all* the dplyId values from
            //QNN_DPLY_SCHEDULER. Since its always used for all (in one job), and never just specific ones anymore we have refactored
            //it to do the lookup in the job itself. The job has been renamed TakeReportSnapshot to make its purpose clearer.
            Logger.LogWarning(nameof(ProcessDplyReport) + " - legacy job entrypoint invoked, the job should have been updated. If this warning persists in future days please investigate");
            await TakeReportSnapshot(); 
        }

        public static readonly string ObsoleteJobId_ProcessDplyReport = "BusinessProcess.ProcessDplyReport"; //old id for removal

        public static readonly string JobId_TakeReportSnapshot = "TakeReportSnapshot-Global"; //well-known hangfire job id

        /// <summary>
        /// Called as a recurring job, makes snapshots of certain data used in certain SIMS reports.
        /// (i.e ImdaDailyReport etc)
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task TakeReportSnapshot()
        {
            try
            {
                EntityModel qnnDplySchedulerModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SCHEDULER, Constants.Level.NoJoins);
                List<DynamicEntity> allReportSnapshotSettings = await qnnDplySchedulerModel.GetAsync(Filter.Empty);

                foreach (DynamicEntity reportSnapshotSetting in allReportSnapshotSettings)
                {
                    await ReportHelper.ReportSnapshot.TakeReportSnapshot(reportSnapshotSetting);
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(TakeReportSnapshot) + " - caught unexpected exception");
            }
        }

        /// <summary>
        /// Scheduler Entry Point
        /// sync over async
        /// </summary>
        /// <param name="parentDplyId"></param>
        /// <param name="userId"></param>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static void CreateNextRecurrentDeployment(Guid parentDplyId, Guid userId)
        {
            //20220824 - Am adding an awaiter so we can log any exceptions that aren't handled inside the method
            //           but need to do this with sync-over-async as I don't want to change the entrypoint signature
            //           (ie to async) as that would probably break existing schedules in the database?
            try
            {
                RecurrenceApplication.CreateNextRecurrentDeployment(parentDplyId, userId)
                    .ConfigureAwait(false) //don't actually need this in netcore https://blog.stephencleary.com/2017/03/aspnetcore-synchronization-context.html
                    .GetAwaiter().GetResult();
            }
            catch(Exception e)
            {
                Logger.LogError(e, nameof(CreateNextRecurrentDeployment) + " - caught unexpected exception, parentDplyId={0}", parentDplyId);
				//nb: we don't rethrow here as we don't want Hangfire to keep retrying
            }
        }

        /// <summary>
        /// This is the legacy name for this job, do not remove it as there may be existing jobs in production that
        /// are still scheduled under this name.
        /// This method doesn't schedule the report it is the actual job which sends the report (which runs on a schedule...)
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        //DO NOT REMOVE OR RENAME THIS METHOD UNTIL ITS KNOWN ALL PROD INSTANCES HAVE NO JOBS SCHEDULED FOR IT
        public static void SendAccessReportScheduleEmail(Guid unused_scheduleId, Guid structDivisionId)
        {
            //20231213 - Am adding an awaiter to remove the warning about unawaited code
            //           but doing this with sync-over-async as I don't want to change the entrypoint signature
            //           (ie to async) as that would probably break existing schedules in the database so needs more work.
            //           (Following example set by CreateNextRecurrentDeployment - don't do this in new methods please!)
            //20251123 - Now we delegate to SendUserAccessMatrix so put the awaiter here for the legacy jobs
            SendUserAccessMatrix(structDivisionId)
                    .ConfigureAwait(false)
                    .GetAwaiter()
                    .GetResult();
        }

        /// <summary>
        /// Sends email with the User Access Matrix attached
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task SendUserAccessMatrix(Guid structDivisionId)
        {
            try
            {
                Logger.LogInformation(nameof(SendUserAccessMatrix) + " - job starting for structDivisionId={0}", structDivisionId);

                await UserAccessMatrixApplication.SendUserAccessMatrix(structDivisionId);

                Logger.LogInformation(nameof(SendUserAccessMatrix) + " - completed job for structDivisionId={0}", structDivisionId);
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(SendUserAccessMatrix) + " - caught unexpected exception, structDivisionId={0}", structDivisionId);
            }
        }

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task<bool> SendGlobalEmailsToUsers(List<Guid> listStructDivisionId, Guid globalMsgId, string emailFrom, string subject, string body)
        {
            return await GlobalMailer.SendToUsersAsync(listStructDivisionId, globalMsgId, emailFrom, subject, body);
        }

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task<bool> SendGlobalEmailsToStatus(List<Guid> listStructDivisionId, Guid globalMsgId, string emailFrom, string subject, string body, List<Guid> listStatusIds)
        {
            return await GlobalMailer.SendToStatusAsync(listStructDivisionId, globalMsgId, emailFrom, subject, body, listStatusIds);
        }

        //Well-known job-id for updating the recurrent job settings in HangFire
        public static readonly string JobId_ProcessDormantUsers = "ProcessDormantUsers-Global";

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task ProcessDormantUsers()
        {
            try
            {
                Logger.LogInformation(nameof(ProcessDormantUsers) + " - job starting");
                DormantUsersProcessor processor = await DormantUsersProcessor.NewInstanceAsync();
                await processor.ExecuteAsync();
                if (Logger.IsEnabled(LogLevel.Information)) 
                {
                    Logger.LogInformation(nameof(ProcessDormantUsers) + " - Completed processing dormant users. {0} users were locked, {1} users were warned",
                        processor.Results.Where(r => r.ActionTaken == UserDormancyResult.Type.Lock).Count(),
                        processor.Results.Where(r => r.ActionTaken == UserDormancyResult.Type.Warning).Count());
                }
                await processor.SendReportAsync();
            }
            catch(Exception e)
            {
                Logger.LogError(e, nameof(ProcessDormantUsers) + " - caught unexpected exception");
            }
        }

        //Previous job id.
        public static readonly string ObsoleteJobId_GenerateMonthlyAccessReport = "GenerateMonthlyAccessReport-Global";
        
        public static readonly string JobId_MonthlyAuditAccessLogExport = "MonthlyAuditAccessLogExport-Global";

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task MonthlyAuditAccessLogExport()
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                bool auditEnabled = await AuditSettings.GetAuditOnAsync();
                if(auditEnabled)
                {
                    Logger.LogInformation(nameof(MonthlyAuditAccessLogExport) + " - job starting"); 
                    
                    await AuditLogApplication.MonthlyAccessReport.Execute();

                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    long durationMinutes = (duration / 1000) / 60;
                    Logger.LogInformation(nameof(MonthlyAuditAccessLogExport) + " - job completed, duration={0} milliseconds (about {1} minutes)", duration, durationMinutes);
                }
                else
                {
                    if (Logger.IsEnabled(LogLevel.Debug)) 
                        Logger.LogDebug(nameof(MonthlyAuditAccessLogExport) + " - skipping job because audit is not enabled");                    
                }
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                Logger.LogError(e, nameof(MonthlyAuditAccessLogExport) + " - caught an unexpected exception, duration={0} milliseconds", duration);
            }
        }

        /// <summary>
        /// Extract frequency count report into csv and email to user.
        /// </summary>
        //*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task ExportFrequencyCountReport(Guid dplyId, Clover.Core.Security.User user)
        {
            try
            {
                if (user.Email == null) throw new ArgumentNullException(nameof(user.Email));
                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportFrequencyCountReport) + " - starting job");
                }

                MemoryStream frequencyCountReportCSV = await ReportHelper.FrequencyCountReport.GetCSV(dplyId);
                if (frequencyCountReportCSV != null)
                {
                    frequencyCountReportCSV.Seek(0, SeekOrigin.Begin);
                }
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                await Email.SendAsync(
                    mailSettings: mailSettings,
                    mailTo: user.Email,
                    subject: "Frequency Count Report",
                    body: "This is an auto generated email.",
                    senderDisplayName: appName,
                    emailFrom: Email.UseDefaultEmailFrom,
                    Email.CreateCsvAttachment(frequencyCountReportCSV, "FrequencyCountReport.csv"));

                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportFrequencyCountReport) + " - completed job");
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(ExportFrequencyCountReport) + " - caught unexpected exception, dplyId={0}", dplyId);
            } 
        }

        /// <summary>
        /// Extract respondent participation report into csv and email to user.
        /// </summary>
        //*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task ExportParticipationReport(
            string UID, 
            string RespName, 
            List<Guid> StatusIDs, 
            List<Guid> DplyIDs,  
            Clover.Core.Security.User user)
        {
            try
            {
                if (user.Email == null) throw new ArgumentNullException(nameof(user.Email));
                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportParticipationReport) + " - starting job");
                }

                MemoryStream participationReportCSV 
                    = await ReportHelper.RespondentParticipationReport.GetCSV(UID, RespName, StatusIDs, DplyIDs, user);
                if (participationReportCSV != null)
                {
                    participationReportCSV.Seek(0, SeekOrigin.Begin);
                }
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                await Email.SendAsync(
                    mailSettings: mailSettings,
                    mailTo: user.Email,
                    subject: "Respondent Participation Report",
                    body: "This is an auto generated email.",
                    senderDisplayName: appName,
                    emailFrom: Email.UseDefaultEmailFrom,
                    Email.CreateCsvAttachment(participationReportCSV, "RespondentParticipationReport.csv"));

                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportParticipationReport) + " - completed job");
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(ExportParticipationReport) + " - caught unexpected exception");
            }
        }

        /// <summary>
        /// Hangfire Entrypoint to export the status response details 
        /// (hangfire job queued for immediate execution by ProcessExportStatusResponseDetails)
        /// </summary>
        /// <param name="dplyId"></param>
        /// <param name="statusTitles"></param>
        /// <returns></returns>
        //*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task ExportStatusResponseDetails(
            Guid dplyId, 
            List<string> statusTitles, 
            bool isExcludeExempted, 
            Guid userId)
        {
            try
            {
                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportStatusResponseDetails) + " - starting job");
                }

                SecurityUser user = await SecurityUser.GetUserById(userId);
                if (string.IsNullOrWhiteSpace(user.Email))
                {
                    Logger.LogWarning(nameof(ExportStatusResponseDetails) + " - User {0} has no email configured", user.Name);
                    return;
                }
                
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();

                StringBuilder body = new StringBuilder();

                //TODO - in the body include the actual report details (status counts)


                List<Models.StoredProcedures.spSP_GetStatusResponseDetails.Item> details 
                    = await ReportHelper.ResponseStatusDashboard.GetCaseDetails(dplyId, statusTitles, isExcludeExempted);
                if(details.Any())
                {
                    string domainAuthority = await SettingsHelper.Common.GetIntranetDomainAuthority();
                    string token = await ReportHelper.ResponseStatusDashboard.PersistDetailsCSV(dplyId, details);
                    Schedule.CleanupDwFile(token);

                    string url = $"https://{domainAuthority}/report/dashboard/statusresponse/download/{HttpUtility.UrlEncode(token)}";
                    body.Append("Exported case status and remarks may be downloaded at <a href=\"");
                    body.Append(url);
                    body.Append("\" >");
                    body.Append(url);
                    body.AppendLine("</a><br />");
                    body.AppendLine("The link will only remain available for download for a limited time.<br />");
                } 
                else
                {
                    body.AppendLine("There are no cases to export.<br />");                    
                }

                body.AppendLine("This is an auto generated email.");

                await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: user.Email,
                        subject: "Status Response Details",
                        body: body.ToString(),
                        senderDisplayName: appName,
                        emailFrom: Email.UseDefaultEmailFrom);

                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(ExportStatusResponseDetails) + " - completed job");
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(ExportStatusResponseDetails) + " - caught unexpected exception, dplyId={0}", dplyId);
            }
        }



        /// <summary>
        /// Scheduled job to delete a specific file from dwUploadedFiles.
        /// This method is intended for use in scheduled cleanup jobs to cleanup temporary
        /// files. Please do not call it as a general purpose file deletion method.
        /// </summary>
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task CleanupDwFile(string token)
        {
            try
            {                
                if(await CloverRuntime.ContentProvider.ExistAsync(token))
                {
                    if(Logger.IsEnabled(LogLevel.Trace))
                        Logger.LogTrace(nameof(CleanupDwFile) + " - removing file with token {0}", token);
                    await CloverRuntime.ContentProvider.RemoveAsync(token);
                }
                else
                {
                    if(Logger.IsEnabled(LogLevel.Debug))
                        Logger.LogDebug(nameof(CleanupDwFile) + " - token not found {0}", token);
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(CleanupDwFile) + " - caught unexpected exception, token={0}", token);
                throw; //Rethrow to let hangfire retry the job
            }
        }

        public static readonly string JobId_CleanupExpiredFileTickets = "CleanupExpiredFileTickets"; //well-known hangfire job id

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task CleanupExpiredFileTickets()
        {
            try
            {
                await FileTicketApplication.CleanupExpiredTickets();
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(CleanupExpiredFileTickets) + " - caught unexpected exception");
            }
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task MaintenancePerformSmtpTest(Guid structDivisionId)
        {
            try
            {
                Logger.LogTrace(nameof(MaintenancePerformSmtpTest) + " - starting, structDivisionId={0}", structDivisionId);
                bool result = await MaintenanceApplication.PerformSmtpTest(structDivisionId);
                Logger.LogInformation(nameof(MaintenancePerformSmtpTest) + " - " + nameof(MaintenanceApplication.PerformSmtpTest) + " returned {0}", result);
            }
            catch(Exception e)
            {
                Logger.LogError(e, nameof(MaintenancePerformSmtpTest) + " - caught unexpected exceptionn");
            }
        }

        //Well-known job-id for updating the recurrent job settings in HangFire
        public static readonly string JobId_ValidateLicenseExpiry = "ValidateLicenseExpiry-Global";

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        /// <summary>
        /// This method checks the expiration status of the Surveyplus license.
        /// If the license has expired or expires today, it retrieves a list of security users
        /// with the Maintenance role and sends email notifications to each user.
        /// </summary>
        public static async Task ValidateLicenseExpiry()
        {
            try
            {
                if(Logger.IsEnabled(LogLevel.Debug))
                {   //start and complete for this partcular job we do at debug level to avoid clutter (previously was trace level)
                    Logger.LogDebug(nameof(ValidateLicenseExpiry) + " - starting job");
                }

                DateTime? licenseExpiry = swz.Clover.Core.License.LicenseHelper.CloverLicenseExpiry();
                if (licenseExpiry.HasValue && licenseExpiry <= DateTime.Now)
                {
                    bool result = await LicenseValidationService.SendLicenseExpiryNotification(licenseExpiry);
                    if (Logger.IsEnabled(LogLevel.Debug))
                    {
                        Logger.LogDebug(nameof(ValidateLicenseExpiry) + " - " + nameof(LicenseValidationService.SendLicenseExpiryNotification) + " returned {0}", result);
                    }
                }

                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(ValidateLicenseExpiry) + " - completed job");
                }
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(ValidateLicenseExpiry) + " - caught unexpected exceptionn");
            }
        }

        //Well-known job-id for AuditLogExport (ABLR)
        public static readonly string JobId_AuditLogExport = "AuditLogExport-Global";

        /// <summary>
        /// ABLR export job
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task AuditLogExport(bool isEnabledAuditExport, int daysInDB, string localTempPath, string cloudProvider, string cloudPath, string auditLogFileName, bool isEnabledAblr, string ablrPath, string ablrFileName, string projectReference)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                Logger.LogInformation(nameof(AuditLogExport) + " - job starting");

                bool result = AuditLogApplication.AuditLogExport(isEnabledAuditExport, daysInDB, localTempPath, cloudProvider, cloudPath, auditLogFileName, isEnabledAblr, ablrPath, ablrFileName, projectReference);

                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                Logger.LogInformation(nameof(AuditLogExport) + " - job completed, returned={0}, duration={1} milliseconds", result, duration);

            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                Logger.LogError(e, nameof(AuditLogExport) + " - caught unexpected exception, duration={0} milliseconds", duration);
            }

        }

        public static readonly string JobId_CleanupExpiredJsonWebTokens = "CleanupExpiredJsonWebTokens"; //well-known hangfire job id

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task CleanupExpiredJsonWebTokens()
        {
            try
            {
                if (Logger.IsEnabled(LogLevel.Trace)) 
                    Logger.LogTrace("Executing " + nameof(CleanupExpiredJsonWebTokens) + " job");

                await DataService.DeleteExpiredTokens();
            }
            catch (Exception e)
            {
                Logger.LogError(e, nameof(CleanupExpiredJsonWebTokens) + " - caught unexpected exception");
            }
        }

    }
}
