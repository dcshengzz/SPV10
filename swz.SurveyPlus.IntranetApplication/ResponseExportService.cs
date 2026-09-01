using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Web;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// The response export service exposes functionality to extract response data and response files and package them as
    /// csvs and zips and store temporarily so they can be downloaded by data owners.
    /// This service is used for manually invoked exports. 
    /// (There is also a similar service, the ScheduledExportService which performs similar services but on an scheduled basis
    /// and 3PA exporting has its own logic too)
    /// </summary>
    public interface IResponseExportService
    {
        public enum ExportFileType { Data, Files }

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task ExportDeploymentResponseData(Guid dplyId, Guid userId);

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task ExportDeploymentResponseFiles(Guid dplyId, Guid userId);

    }

    /// <summary>
    /// Implementation of the response export service.
    /// Your export code shouldn't use this directly, instead we prefer to use hangfire to do it as a background job
    /// and using the interface and dependency injection.
    /// The BusinessProcess.Enqueue.ExportDeploymentResponseData and ExportDeploymentResponseFiles methods may be used
    /// to queue such jobs for immediate execution.
    /// </summary>
    public class ResponseExportService : IResponseExportService
    {
        private const int cleanupDays = 2;

        private readonly ILogger<ResponseExportService> logger;
        private readonly SurveyPlusOptions surveyPlusOptions;

        public ResponseExportService(
            ILogger<ResponseExportService> logger,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        public async Task ExportDeploymentResponseData(Guid dplyId, Guid userId)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                (DynamicEntity qnnDply, Clover.Core.Security.User user) 
                    = await GetAuthorisedDeploymentAndUser(dplyId, userId);

                Guid deploymentStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                string dplyName = (String)qnnDply[Constants.FieldName.Name];

                if (string.IsNullOrWhiteSpace(user.Email))
                    throw new InvalidOperationException($"User {user.Id} ({user.Name}) has no email address configured");

                String exportResponsePath = surveyPlusOptions.ExportedDeploymentResponseFolderPath;
                if (string.IsNullOrWhiteSpace(exportResponsePath)) 
                    throw new InvalidOperationException(nameof(surveyPlusOptions.ExportedDeploymentResponseFolderPath) + " is not configured");

                string baseUrl = await SettingsHelper.Common.GetIntranetDomainAuthority();
                if (string.IsNullOrWhiteSpace(baseUrl)) 
                    throw new InvalidOperationException("IntranetDomainAuthority is not configured");

                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(ExportDeploymentResponseData) + " - Executing deployment response data export. dplyId={0}, user={1} ({2}), deployment={3}",dplyId, user.Id, user.Name, dplyName);
                }
                string zipFileName;
                try
                {
                    zipFileName = await ResponseDataExport.CreateZippedResponses(exportResponsePath, dplyId);
                }
                catch (ResponseDataExport.NoResponseDataException nrde)
                {   //previously it simply returned null filename but this caused confusion on more than
                    //one occasion when troubleshooting so now we get a bit verbose and will catch an
                    //explicit exception here.
                    //(Later the email method will send a "no data" message if passed a null filename.)
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nrde, nameof(ExportDeploymentResponseData) + " - No response data, dplyId={0}, deployment={1}", dplyId, dplyName );
                    }
                    if (logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning(nameof(ExportDeploymentResponseData) + " - no response data found for dplyId={0}, deployment={1}, message={2}", dplyId, dplyName, nrde.Message);
                    }
                    zipFileName = null;
                }

                DynamicEntity ticket = await MoveZipToDatabase(
                    userId,
                    FileTicketPurpose.ResponseData, 
                    zipFileName, 
                    deploymentStructDivisionId);

                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                await EmailDownloadLink(FileTicketPurpose.ResponseData, user, dplyId, ticket, duration);

                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(ExportDeploymentResponseData) + " - Completed for {0}. ticket={1}, email={2}, duration={3} ({4} minutes)", dplyName, (Guid)ticket[Constants.FieldName.Id], user.Email, duration, ConversionUtils.ToMinutesRoundedUp(duration));
                }
            }
            catch (PermissionException pex)
            {
                logger.LogError(pex, nameof(ExportDeploymentResponseData) + " - caught a permission exception. dplyId={0}, userId={1}",
                    dplyId, userId);
                //TODO -  would like to audit this but we don't have suitable audit methods or event type for this yet
                //swz.Clover.Core.Utils.AuditHelper.AuditLog
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogError(e, nameof(ExportDeploymentResponseData) + " - caught an unexpected exception. dplyId={0}, userId={1}, duration={2}", dplyId, userId, duration);
                await EmailFailureNotification(FileTicketPurpose.ResponseData, userId, dplyId, duration);
            }
        }

        public async Task ExportDeploymentResponseFiles(Guid dplyId, Guid userId)
        {
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                (DynamicEntity qnnDply, Clover.Core.Security.User user)
                    = await GetAuthorisedDeploymentAndUser(dplyId, userId);

                Guid deploymentStructDivisionId = (Guid)qnnDply[Constants.FieldName.StructDivisionId];
                string dplyName = (String)qnnDply[Constants.FieldName.Name];

                if (string.IsNullOrWhiteSpace(user.Email))
                    throw new InvalidOperationException($"User {user.Id} ({user.Name}) has no email address configured");

                String respFilesPath = surveyPlusOptions.RespFilesDownloadFolderPath;
                if (string.IsNullOrWhiteSpace(respFilesPath))
                    throw new InvalidOperationException(nameof(surveyPlusOptions.RespFilesDownloadFolderPath) + " is not configured");

                string baseUrl = await SettingsHelper.Common.GetIntranetDomainAuthority();
                if (string.IsNullOrWhiteSpace(baseUrl))
                    throw new InvalidOperationException("IntranetDomainAuthority is not configured");

                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(ExportDeploymentResponseFiles) + " - Executing deployment response files export. dplyId={0}, user={1} ({2}), deployment={3}", dplyId, user.Id, user.Name, dplyName);
                }

                string zipFileName = await ResponseDataExport.CreateZippedResponseUploadedFiles(dplyId, respFilesPath);
                DynamicEntity ticket = await MoveZipToDatabase(
                    userId, 
                    FileTicketPurpose.ResponseFiles, 
                    zipFileName, 
                    deploymentStructDivisionId);
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                await EmailDownloadLink(FileTicketPurpose.ResponseFiles, user, dplyId, ticket, duration);
               
                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation(nameof(ExportDeploymentResponseFiles) + " - Completed for {0}. ticket={1}, email={2}, duration={3} ({4} minutes)", dplyName, (Guid)ticket[Constants.FieldName.Id], user.Email, duration, ConversionUtils.ToMinutesRoundedUp(duration));
                }
            }
            catch (PermissionException pex)
            {
                logger.LogError(pex, nameof(ExportDeploymentResponseFiles) + " - caught a permission exception. dplyId={0}, userId={1}", dplyId, userId);
                //Note: we don't email the user in this case
            }
            catch (Exception e)
            {
                //Other errors
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                logger.LogError(e, nameof(ExportDeploymentResponseFiles) + " - caught an unexpected exception. dplyId={0}, userId={1}, duration={2}", dplyId, userId, duration);

                await EmailFailureNotification(FileTicketPurpose.ResponseFiles, userId, dplyId, duration);
            }
        }

        /// <summary>
        /// Copy the tempfile from the filesystem to database dwUploadedFiles and delete the tempfile from the file system.
        /// Return a ticket for user to access the file download.
        /// </summary>
        private async Task<DynamicEntity> MoveZipToDatabase(
            Guid userId, 
            FileTicketPurpose purpose, 
            string zipFileName, 
            Guid structDivisionId)
        {
            if (string.IsNullOrEmpty(zipFileName)) throw new ArgumentException("required", nameof(zipFileName));

            string zipFileFullPath;
            switch (purpose)
            {
                case FileTicketPurpose.ResponseData:
                    zipFileFullPath = FileUtils.CombineWithPath(surveyPlusOptions.ExportedDeploymentResponseFolderPath, zipFileName);
                    break;

                case FileTicketPurpose.ResponseFiles:
                    zipFileFullPath = FileUtils.CombineWithPath(surveyPlusOptions.RespFilesDownloadFolderPath, zipFileName);
                    break;

                default:
                    throw new ArgumentException($"Unsupported purpose {purpose}", nameof(purpose));
            }

            FileInfo file = new FileInfo(zipFileFullPath);
            if (!file.Exists)
                throw new ArgumentException($"File does not exist: {zipFileFullPath}", nameof(zipFileName));

            DateTime? expiryDate 
                = surveyPlusOptions.IsResponseDownloadLinkExpiring
                ? (DateTime?)DateTime.Now.AddHours(surveyPlusOptions.ResponseDownloadLinkExpiryHours)
                : null;
            DynamicEntity ticket = await FileTicketApplication.MoveFileToDatabaseAndIssueTicket(
                file,
                new FileTicketBuilder(purpose, structDivisionId)
                    .CreatedBy(userId)
                    .AddRoleRestriction(Constants.Role.DataOwner)
                    .Expires(expiryDate)
                    .DeleteFileOnExpiry(true));
            return ticket;
        }

        public async Task EmailDownloadLink(
            FileTicketPurpose purpose, 
            Clover.Core.Security.User user, 
            Guid dplyId, 
            DynamicEntity ticket,
            long duration)
        {
            if (user == null) throw new ArgumentException("required", nameof(user));
            if(string.IsNullOrWhiteSpace(user.Email))
            {
                logger.LogError(nameof(EmailDownloadLink) + " - user {0} has no email address", user.Name);
                return;
            }

            if (ticket == null) throw new ArgumentNullException(nameof(ticket));

            DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
            if (qnnDply == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

            string deploymentName = (string)qnnDply[Constants.FieldName.Name];

            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation(nameof(EmailDownloadLink) + " - sending {0} extraction download link for deployment {1} to {2} at {3}", purpose, deploymentName, user.Name, user.Email);
            }

            string extractType = FriendlyExtractType(purpose);

            string downloadUrl = await FileTicketApplication.GetLink(ticket);
            DateTime? expiryDate = (DateTime?)ticket[Constants.FieldName.ExpiryDate];
            string subject = $"Your {extractType} for {deploymentName} is ready to download";
            int durationMinutes = ConversionUtils.ToMinutesRoundedUp(duration);
            string body = $"Dear {HttpUtility.HtmlEncode(user.Name)},<p />"
                    + $"You requested {extractType} for deployment: {HttpUtility.HtmlEncode(deploymentName)}. <p /> "
                    + $"The export job took about {durationMinutes} minute(s) to complete. <p /> "
                    + $"You may download the file from <a href='{downloadUrl}'>{downloadUrl}</a> <p />";
            if(expiryDate != null)
            {
                body += $"The server will keep it until {expiryDate.Value.ToString(Constants.QnnDatetimeFormat)}, please download before then.";
            }

            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string appName = await SettingsHelper.Common.GetApplicationName();
            bool sentSuccessfully = await Email.SendAsync(
                mailSettings: mailSettings,
                mailTo: user.Email,
                subject: subject,
                body: body,
                senderDisplayName: appName);
            if (!sentSuccessfully)
            {
                logger.LogError(nameof(EmailDownloadLink) + " - failed to send notification for extracted response to user {0} using email address {1}", user.Name, user.Email);
            }
        }

        private string FriendlyExtractType(FileTicketPurpose purpose)
        {
            switch (purpose)
            {
                case FileTicketPurpose.ResponseData: return "Response Data Extract";
                case FileTicketPurpose.ResponseFiles: return "Response Files Extract";

                default:
                    throw new ArgumentException($"Unexpected purpose {purpose}", nameof(purpose));
            }
        }

        public async Task EmailFailureNotification(FileTicketPurpose purpose, Guid userId, Guid dplyId, long duration)
        {
            Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
            if (user == null)
            {
                logger.LogError(nameof(EmailFailureNotification) + " - user with Id {0} not found", userId);
                return;
            }
            if (string.IsNullOrWhiteSpace(user.Email))
            {
                return;
            }

            DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId);
            string deploymentName = (qnnDply == null)
                ? "[DEPLOYMENT NOT FOUND]"
                :(string)qnnDply[Constants.FieldName.Name];

            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation(nameof(EmailFailureNotification) + " - sending {0} export failure notification for deployment {1} to {2} at {3}", purpose, deploymentName, user.Name, user.Email);
            }

            string extractType = FriendlyExtractType(purpose);
            string subject = $"{extractType} for {deploymentName} failed";
            int durationMinutes = ConversionUtils.ToMinutesRoundedUp(duration);
            string body = $"Dear {HttpUtility.HtmlEncode(user.Name)},<br />"
                    + $"Your requested {extractType} for deployment: {HttpUtility.HtmlEncode(deploymentName)} was not successful. <br /> The export job ran for about {durationMinutes} minute(s) ({duration} milliseconds).<br /> ";

            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string appName = await SettingsHelper.Common.GetApplicationName();
            bool sentSuccessfully = await Email.SendAsync(
                mailSettings: mailSettings,
                mailTo: user.Email,
                subject: subject,
                body: body,
                senderDisplayName: appName);
            if (!sentSuccessfully)
            {
                logger.LogError(nameof(EmailFailureNotification) + " - failed to send failure notification to user {0} using email address {1}", user.Name, user.Email);
            }
        }

        /// <summary>
        /// Fetch the deployment and user records.
        /// Fail with a PermissionException if the specified user does not have the necessary DataOwner access to the dply
        /// </summary>
        private async Task<(DynamicEntity, Clover.Core.Security.User)> GetAuthorisedDeploymentAndUser(Guid dplyId, Guid userId)
        {
            EntityModel qnnDplyModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
            DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId, qnnDplyModel);
            if (qnnDply == null)
                throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyId);

            Clover.Core.Security.User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
            if (user == null)
                throw new NotFoundException($"Failed to find user with id={userId}");

            await DeploymentApplication.AssertDataOwner(qnnDply, user);

            return (qnnDply, user);
        }
    }
}
