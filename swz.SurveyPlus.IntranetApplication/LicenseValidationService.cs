using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class LicenseValidationService
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(LicenseValidationService));

        /// <summary>
        /// retrieves a list of security users with the Maintenance role and sends email notifications to each user.
        /// </summary>
        public static async Task<bool> SendLicenseExpiryNotification(DateTime? licenseExpiry)
        {
            Guid maintenanceUserIds = (await SecurityRole.SelectByCode(Constants.Role.Maintenance)).Id;
            List<SecurityUser> maintenanceUsers
                = (await SecurityRole.GetUsersByRoleId(maintenanceUserIds))
                .Where(su => !su.IsLocked)
                .Where(su => !String.IsNullOrWhiteSpace(su.Email))
                .ToList();

            HashSet<string> recipientEmails = new HashSet<string>();
            foreach (SecurityUser recipient in maintenanceUsers)
            {
                recipientEmails.Add(recipient.Email);
            }

            if (Logger.IsEnabled(LogLevel.Trace))
            {
                Logger.LogTrace(nameof(SendLicenseExpiryNotification) + " - sending license expiry notification to {0}", recipientEmails);
            }

            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string applicationName = await SettingsHelper.Common.GetApplicationName();
            string message = $"Surveyplus license has expired on {licenseExpiry}. To ensure uninterrupted access and continued support, we kindly request that you take action to renew your license at your earliest convenience.";
            bool ok = await Email.SendAsync(
            mailSettings: mailSettings,
                mailTo: recipientEmails,
                mailCc: null,
                mailBcc: null,
                subject: $"{applicationName} License Expiry Notification",
                body: message,
                senderDisplayName: Email.UseDefaultSenderDisplayName,
                emailFrom: Email.UseDefaultEmailFrom);
            return ok;
        }
    }
}
