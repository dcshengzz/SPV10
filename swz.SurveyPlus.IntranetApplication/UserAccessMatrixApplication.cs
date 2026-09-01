using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
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
    /// <summary>
    /// Logic related to the User Access Matrix
    /// note: report formatting code is in ReportHelper but I hope to bring it over here
    /// </summary>
    public class UserAccessMatrixApplication
    {

        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger<UserAccessMatrixApplication>();

        private class ScheduleType
        {
            public const string DAILY = "Daily";
            public const string WEEKLY = "Weekly";
            public const string MONTHLY = "Monthly";
            public const string YEARLY = "Yearly";
        }

        public static bool isValidScheduleType(string scheduleType)
        {
            if (string.IsNullOrEmpty(scheduleType)) return false;

            List<string> SCHEDULE_TYPE = new List<string>() { ScheduleType.DAILY, ScheduleType.WEEKLY, ScheduleType.MONTHLY, ScheduleType.YEARLY };
            if (!SCHEDULE_TYPE.Contains(scheduleType)) return false;

            return true;
        }

        private static string GetCronSchedule(string scheduleType)
        {
            switch (scheduleType)
            {
                case ScheduleType.DAILY:
                    return Cron.Daily();
                case ScheduleType.WEEKLY:
                    return Cron.Weekly();
                case ScheduleType.MONTHLY:
                    return Cron.Monthly();
                case ScheduleType.YEARLY:
                    return Cron.Yearly();
                default:
                    return Cron.Minutely();
            }
        }

        private static async Task<EntityModel> GetAccessReportScheduleModel()
        {
            EntityModel accessReportScheduleModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.AccessReportSchedule, Constants.Level.NoJoins);
            return accessReportScheduleModel;
        }

        /// <summary>
        /// Gets the AccessReportSchedule entity for the specified organisation (may be null)
        /// </summary>
        public static async Task<DynamicEntity> GetAccessReportSchedule(Guid structDivisionId)
        {
            EntityModel accessReportScheduleModel = await GetAccessReportScheduleModel();
            return (await accessReportScheduleModel.GetAsync(Filter.And.Equal(structDivisionId, Constants.FieldName.StructDivisionId))).FirstOrDefault();
        }

        /// <summary>
        /// Create or update the AccessReportSchedule entity for the specified organisation
        /// and schedule a recurring job to send the User Access Matrix emails
        /// </summary>
        public static async Task SaveAccessReportSchedule(
            Guid structDivisionId, 
            string scheduleType, 
            bool isEnabled, 
            string email)
        {
            DynamicEntity accessReportSchedule = await GetAccessReportSchedule(structDivisionId); //may be null
            accessReportSchedule = await CreateOrUpdateAccessReportSchedule(
                accessReportSchedule, 
                structDivisionId, 
                scheduleType, 
                isEnabled, 
                email);
            Guid scheduleId = (Guid)accessReportSchedule[Constants.FieldName.Id];
            string cronSchedule = GetCronSchedule(scheduleType);
            BusinessProcess.Schedule.SendUserAccessMatrix(scheduleId, structDivisionId, cronSchedule, isEnabled);
        }

        private static async Task<DynamicEntity> CreateOrUpdateAccessReportSchedule(
            DynamicEntity accessReportSchedulerDynamic, 
            Guid structDivisionId, 
            string scheduleType, 
            bool isEnabled, 
            string email)
        {
            if (accessReportSchedulerDynamic == null)
            {
                accessReportSchedulerDynamic = await InsertAccessReportSchedule(structDivisionId, scheduleType, isEnabled, email);
            }
            else
            {
                await UpdateAccessReportSchedule(accessReportSchedulerDynamic, scheduleType, isEnabled, email);
            }
            return accessReportSchedulerDynamic;
        }

        private static async Task<DynamicEntity> InsertAccessReportSchedule(
            Guid structDivisionId, 
            string scheduleType, 
            bool isEnabled, 
            string email)
        {
            EntityModel accessReportScheduleModel = await GetAccessReportScheduleModel();
            DynamicEntity accessReportSchedule 
                = await PrepareAccessReportSchedule(
                    accessReportScheduleModel, 
                    scheduleType, 
                    isEnabled, 
                    email);
            accessReportSchedule[Constants.FieldName.Id] = Guid.NewGuid();
            accessReportSchedule[Constants.FieldName.StructDivisionId] = structDivisionId;
            accessReportSchedule[Constants.FieldName.CreatedBy] = CloverRuntime.Security.CurrentUser.Id;
            accessReportSchedule[Constants.FieldName.CreatedDate] = DateTime.Now;

            //TODO - what is the problem this transaction is trying to solve?
            using (var shared = new SharedTransaction())
            {
                shared.BeginTransactionAsync().Wait();
                await accessReportScheduleModel.InsertSingleAsync(accessReportSchedule);
                shared.Commit();
            }

            return accessReportSchedule;
        }

        private static async Task UpdateAccessReportSchedule(
            DynamicEntity schedule, 
            string scheduleType, 
            bool isEnabled, 
            string email)
        {
            EntityModel accessReportScheduleModel = await GetAccessReportScheduleModel();
            DynamicEntity accessReportSchedule = await PrepareAccessReportSchedule(
                accessReportScheduleModel, 
                scheduleType, 
                isEnabled, 
                email, 
                schedule);

            //TODO - what is the problem this transaction is trying to solve?
            using (var shared = new SharedTransaction())
            {
                shared.BeginTransactionAsync().Wait();
                await accessReportScheduleModel.UpdateSingleAsync(accessReportSchedule);
                shared.Commit();
            }
        }

        /// <summary>
        /// Create or update an AccessReportSchedule entity (doesn't write to db)
        /// </summary>
        private static async Task<DynamicEntity> PrepareAccessReportSchedule(
            EntityModel accessReportEntityModel, 
            string scheduleType, 
            bool isEnabled, 
            string email, 
            DynamicEntity accessReportSchedule = null)
        {
            if (accessReportSchedule == null)
            {
                accessReportSchedule = await accessReportEntityModel.NewAsync();
            }

            accessReportSchedule[Constants.FieldName.ScheduleType] = scheduleType;
            accessReportSchedule[Constants.FieldName.IsEnabled] = isEnabled;
            accessReportSchedule[Constants.FieldName.Email] = email;

            accessReportSchedule[Constants.FieldName.UpdatedBy] = CloverRuntime.Security.CurrentUser.Id;
            accessReportSchedule[Constants.FieldName.UpdatedDate] = DateTime.Now;

            return accessReportSchedule;
        }

        public static async Task SendUserAccessMatrix(Guid structDivisionId)
        {
            try
            {
                DynamicEntity accessReportSchedule = await GetAccessReportSchedule(structDivisionId);
                if (accessReportSchedule != null)
                {
                    bool isEnabled = (bool)accessReportSchedule[Constants.FieldName.IsEnabled];
                    if (isEnabled)
                    {
                        string multiEmail = accessReportSchedule[Constants.FieldName.Email].ToString();
                        if (!string.IsNullOrEmpty(multiEmail))
                        {
                            //TODO - consider using MailRecipients here (at schedule's org level)
                            //but it does raise questions as to do we want to send to role-holders in lower orgs
                            //since the report covers stuff above them. Maybe MailRecipients needs an option
                            //to exclude lower orgs?

                            //Avoid duplicate email input.
                            HashSet<string> emailSet = new HashSet<string>();
                            foreach (string email in multiEmail.Split(','))
                            {
                                string trimmedEmail = email.Trim();
                                if (!string.IsNullOrEmpty(trimmedEmail))
                                {
                                    //Filter invalid email
                                    if (!emailSet.Contains(trimmedEmail) && Email.IsAddressFormatValid(trimmedEmail))
                                    {
                                        emailSet.Add(trimmedEmail);
                                    }
                                    else
                                    {
                                        Logger.LogError("Ignoring invalid email {0}", trimmedEmail);
                                    }
                                }
                            }

                            StructDivision structDivision = await StructDivision.SelectByKey(structDivisionId);
                            string organisation = WebUtility.HtmlEncode(structDivision?.Name ?? "UNKNOWN");
                            string recipients = string.Join(",", emailSet);
                            //string pdfName = "User Access Matrix " + DateTime.Now.ToString(ReportHelper.DATE_FORMAT) + ".pdf";
                            string appName = await SettingsHelper.Common.GetApplicationName();
                            string pdfName = ReportHelper.UserAccessMatrixReport.Filename(ReportHelper.UserAccessMatrixReport.AccessMatrixType.RoleExt, appName);
                            string body = $"<b>{pdfName}</b> is an auto generated User Access Matrix at organisation level '{organisation}'";
                            MemoryStream ms = await ReportHelper.UserAccessMatrixReport.GetRoleExtReportPDF(structDivisionId);

                            Logger.LogInformation(nameof(SendUserAccessMatrix) + " - sending {0} to {1} for structDivisionId {2} ({3})", pdfName, recipients, structDivisionId, organisation);

                            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                            await Email.SendAsync(
                                mailSettings: mailSettings,
                                mailTo: recipients,
                                subject: "User Access Matrix",
                                body: body,
                                senderDisplayName: appName,
                                emailFrom: Email.UseDefaultEmailFrom,
                                Email.CreatePdfAttachment(ms, pdfName));
                        }
                    }
                }
            }
            catch (Exception e)
            {
                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(e, nameof(SendUserAccessMatrix) + " - caught unexpected exception, structDivisionId={0}", structDivisionId);
                }
                throw;
            }
        }

        /// <summary>
        /// Download a CSV listing user profiles, their roles, and creation, update, dormancy dates etc
        /// Only include users in the specified organisation subtree.
        /// Caller is responsible for closing and disposing the stream.
        /// </summary>
        public static async Task<Stream> UserProfileListCSV(Guid structDivisionId)
        {
            HashSet<Guid> organisations = await StructDivision.SelectChildrenAndThisIdSetAsync(structDivisionId);
            List<Dictionary<string, object>> data = await spSP_ListUserProfiles.Execute(organisations);
            ImmutableList<string> userProfileListColumns = ImmutableList.Create(
                "Organisation", "Name", "IsLocked",
                "Login", "ADLogin", "LinkedDomainLogin", "LastLoginDate", 
                "CreatedDate", "CreatedBy", "UpdatedDate", "UpdatedBy", "DormancyDate",
                "Email", "Roles");
            return TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.CsvMemoryStream(data, userProfileListColumns);
        }
    }
}
