using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.Core.Utils;
using System.Collections.Generic;
using System.Linq;

namespace swz.SurveyPlus.IntranetApplication
{
    public interface IBackendPrintService
    {
        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        Task BackendPrintSurvey(string formName, string emails, string surveyName, string responseData);
    }

    public class BackendPrintService : IBackendPrintService
    {
        private readonly ILogger<BackendPrintService> logger;

        public BackendPrintService(ILogger<BackendPrintService> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task BackendPrintSurvey(string formName, string emails, string surveyName, string responseData)
        {
            try
            {
                logger.LogInformation(nameof(BackendPrintSurvey) + " - starting job. surveyName={surveyName} emails={emails}", surveyName, emails);

                //Winnovative generate pdf stream
                Stream pdfStream = await SurveyPrinting.WinnovativeGeneratePdf(formName, responseData);

                //Email
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                
                StringBuilder builder = new StringBuilder();
                builder.AppendLine("This is a system auto-generated email attached with a PDF export of your response.");
                builder.AppendLine();
                builder.AppendLine("Please contact system administrator if you have any further queries.");
                string body = builder.ToString();
                List<string> recipients = Email.SplitAddresses(emails);
                bool sentSuccessfully = await Email.SendAsync(
                    mailSettings: mailSettings,
                    mailTo: recipients,
                    mailCc: Enumerable.Empty<string>(),
                    mailBcc: Enumerable.Empty<string>(),
                    subject: $"Exported PDF for survey '{surveyName}'",
                    body: body,
                    senderDisplayName: appName,
                    emailFrom: Email.UseDefaultEmailFrom,
                    Email.CreatePdfAttachment(pdfStream, surveyName + ".pdf"));

                if (!sentSuccessfully)
                {
                    logger.LogWarning(nameof(BackendPrintSurvey) + " - failed to send PDF exported for survey {0} to email address {1}", surveyName, emails);
                }

                logger.LogInformation(nameof(BackendPrintSurvey) + " - completed job");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(BackendPrintSurvey) + " - caught unexpected exception, survey={0}", surveyName);
                throw; // Rethrow to let hangfire retry the job
            }
        }
    }
}
