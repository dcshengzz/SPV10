using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class MaintenanceApplication
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(MaintenanceApplication));

        public static async Task<Stream> ObjectPageUsageCSV()
        {
            List<Dictionary<string, object>> data = await GetObjectPageUsage.Execute();
            ImmutableList<string> objectPageUsageColumns = ImmutableList.Create(
                "SchemaName", "TableName", "Name", "IndexType", "UsageCategory", "AllocationType",
                "TotalMiB", "UsedMiB", "UnusedMiB",
                "TotalPages", "UsedPages", "UnusedPages",
                "PartitionRowCount");
            return TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.CsvMemoryStream(data, objectPageUsageColumns);            
        }

        public static async Task<bool> PerformSmtpTest(Guid structDivisionId)
        {
            List<string> recipientEmails = await MaintenanceApplication.GetAllSMTPTestRecipients(structDivisionId);
            if (!recipientEmails.Any())
                throw new InvalidOperationException(Constants.Message.Prefix.ClientReportable + "There are no recipients for the test email");
            return await SendSmtpTestMessage(recipientEmails, structDivisionId);
        }

        /// <summary>
        /// Send a simple test email to the specified recipients.
        /// </summary>
        /// <param name="recipientEmails">list of emails to send to, at least one is required</param>
        /// <returns>true if successfully passed to the mail server (does not indicate delivery to recipient)</returns>
        private static async Task<bool> SendSmtpTestMessage(List<string> recipientEmails, Guid structDivisionId)
        {
            if (recipientEmails == null) throw new ArgumentNullException(nameof(recipientEmails));
            if (!recipientEmails.Any()) throw new ArgumentException("At least one address is required", nameof(recipientEmails));

            DateTime now = DateTime.Now;

            Logger.LogInformation(nameof(SendSmtpTestMessage) + " - sending test message to {0}, at {1}", recipientEmails, now);

            StructDivision structDivision = await StructDivision.SelectByKey(structDivisionId);
            string organisation = WebUtility.HtmlEncode(structDivision?.Name ?? "UNKNOWN");

            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string applicationName = await SettingsHelper.Common.GetApplicationName();
            string message = $"This is a test email sent from {applicationName} at organisation level '{organisation}' at {now.ToString(Constants.QnnDatetimeFormat)}";
            bool ok = await Email.SendAsync(
                mailSettings: mailSettings,
                mailTo: recipientEmails,
                mailCc: null,
                mailBcc: null,
                subject: $"{applicationName} Test Message",
                body: message,
                senderDisplayName: Email.UseDefaultSenderDisplayName,
                emailFrom: Email.UseDefaultEmailFrom);
            return ok;
        }

        public class SmtpTestRecipientRetrievalException : Exception
        {
            public SmtpTestRecipientRetrievalException(string message, Exception innerException) : base(message, innerException) { }
        }

        /// <summary>
        /// Get the emails for recipients of the test message based on the configuration
        /// in dwAppSettings (we now use MailRecipients class to support role, email, login
        /// names in the comma separated list
        /// </summary>
        public static async Task<List<string>> GetAllSMTPTestRecipients(Guid structDivisionId)
        {
            try
            {
                string setting = await SettingsHelper.GetValue(Constants.dwAppSettingName.SMTPTestRecipients);
                MailRecipients recipients = await MailRecipients.FromString(setting, structDivisionId);
                if (recipients.IsAnyInvalid && Logger.IsEnabled(LogLevel.Warning))
                {   //Not fatal, just log any with bad addresses
                    Logger.LogWarning(nameof(GetAllSMTPTestRecipients) + " - some address resolutions were invalid: {0}", recipients.GetInvalidResolutions());
                }
                List<string> recipientEmails =  recipients.GetValidDistinctEmails();
                return recipientEmails;
            }
            catch (Exception e)
            {
                throw new SmtpTestRecipientRetrievalException($"{Constants.Message.Prefix.ClientReportable}Failed to collate the list of recipient addresses",e);
            }
        }
    }
}
