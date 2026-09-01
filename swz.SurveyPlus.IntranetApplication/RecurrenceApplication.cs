using Dates.Recurring;
using Dates.Recurring.Type;
using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using Microsoft.AspNetCore.Http.HttpResults;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Logic for recurring deployments
    /// </summary>
    public static class RecurrenceApplication
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(RecurrenceApplication));

        //TODO - rename this as it is no longer solely for deployments
        private struct DplyRecurType {
            public const string DAILY = "DAILY";
            public const string WEEKLY = "WEEKLY";
            public const string MONTHLY = "MONTHLY";
            public const string QUARTERLY = "QUARTERLY";
            public const string HALF_YEARLY = "HALF_YEARLY";
            public const string ANNUALLY = "ANNUALLY";
            public const string BIENNIALLY = "BIENNIALLY";
            public const string CUSTOM = "CUSTOM";
            public struct CustomType
            {
                public const string EXACT_DATE = "EXACT DATE";
                public const string N_DAY_N_MONTH = "N DAY N MONTH";
                public const string N_DAY_EACH_MONTH = "N DAY EACH MONTH";
                public const string N_LAST_DAY_N_MONTH = "N LAST DAY N MONTH";
                public const string N_LAST_DAY_EACH_MONTH = "N LAST DAY EACH MONTH";
                public const string N_WEEK_N_MONTH = "N WEEK N MONTH";
                public const string N_WEEK_EACH_MONTH = "N WEEK EACH MONTH";
                public const string N_LAST_WEEK_N_MONTH = "N LAST WEEK N MONTH";
                public const string N_LAST_WEEK_EACH_MONTH = "N LAST WEEK EACH MONTH";
            }
        }


        /// <summary>
        /// Schedule a job for the creation of the next recurrence of the deployment and calculate the RecurrenceNextDate value. 
        /// The previously scheduled job for this (if any) will be deleted and replaced as appropriate for the current settings.
        /// If the next deployment(s) already exist the job and RecurrenceNextDate will be scheduled for the first recurrence
        /// that has yet to be created. (So it is safe  to call this again for the same settings).
        /// If RecurrenceAdvanceDays is set then the job will be scheduled in advance of the RecurrenceNextDate.
        /// nb: entity is not saved here, caller (ie: deployment controller or job) must do that. 
        /// </summary>
        /// <param name="qnnDply">Value will be modify</param>
        /// <param name="afterDate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static async Task ScheduleNextRecurrence(DynamicEntity qnnDply, DateTime afterDate, Guid userId, SharedTransaction shared = null)
        {
            string recurrenceJobId = (string)qnnDply[Constants.FieldName.RecurrenceJobId];
            if (!string.IsNullOrEmpty(recurrenceJobId))
            {
                BackgroundJob.Delete(recurrenceJobId);
            }

            bool recurrenceEnabled = (bool)qnnDply[Constants.FieldName.RecurrenceEnabled];
            if (recurrenceEnabled)
            {
                DateTime originalDateStart = (DateTime)qnnDply[Constants.FieldName.DateStart];
                DateTime recurrenceEndDate = (DateTime)qnnDply[Constants.FieldName.RecurrenceEndDate];
                string recurrenceFrequency = (string)qnnDply[Constants.FieldName.RecurrenceFrequency];
                Guid dplyId = (Guid)qnnDply.GetId();

                //To determine the start date of the next deployment (and thus the date for the job that will
                //create it) we work out the next start date after the specified afterDate based on the original
                //starting date and the frequency, but it may be that we have already created these deployments
                //(ie: when recurrence settings are updated / saved again) in which case we don't want to recreate
                //recurrent deployments that already exist. For such a case we want to skip scheduling a job
                //for already created re-deployments (deemed as any recurrence on or after the calculated start date)
                //and move on to find the first recurrence we havent created already and schedule the job for that.
                DateTime? nextDateStart = await DateCalculator.CalculateNextRecurrenceStartDate(
                    dplyId, 
                    originalDateStart, 
                    afterDate, 
                    recurrenceFrequency, 
                    recurrenceEndDate);
                qnnDply[Constants.FieldName.RecurrenceNextDate] = nextDateStart;
                if (nextDateStart != null)
                {
                    int recurrenceAdvanceDays = (int)qnnDply[Constants.FieldName.RecurrenceAdvanceDays];
                    DateTime jobDate = (DateTime)nextDateStart - new TimeSpan(recurrenceAdvanceDays, 0, 0, 0);
                    recurrenceJobId = BackgroundJob.Schedule(
                        () => BusinessProcess.CreateNextRecurrentDeployment(dplyId, userId), jobDate);
                }
                qnnDply[Constants.FieldName.RecurrenceJobId] = recurrenceJobId;
            }
            else
            {
                qnnDply[Constants.FieldName.RecurrenceNextDate] = null;
                qnnDply[Constants.FieldName.RecurrenceJobId] = null;
            }

        }

        /// <summary>
        /// Intended to be invoked as a hangfire job, this will firstly create a new deployment based on the original deployment
        /// and the RecurrenceNextDate and secondly schedule (if still appropriate) a job to create the next one.
        /// </summary>
        /// <param name="parentDplyId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static async Task CreateNextRecurrentDeployment(Guid parentDplyId, Guid userId)
        {
            DeploymentRecurrenceEmailData emailData = new DeploymentRecurrenceEmailData();
            emailData.ParentDplyId = parentDplyId.ToString();

            using (var shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    EntityModel qnnDplyModel 
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.NoJoins);
                    DynamicEntity parentQnnDply = await DeploymentApplication.GetQnnDplyById(parentDplyId, qnnDplyModel);
                    if (parentQnnDply == null)
                        throw NotFoundException.ForModelName(qnnDplyModel.Name, parentDplyId);

                    DeploymentData deploymentData = new DeploymentData(parentQnnDply);
                    
                    emailData.DeploymentName = deploymentData.DeploymentName;
                    emailData.RecurrenceNotify = deploymentData.RecurrenceNotify;
                    emailData.NotifyDateStart = deploymentData.RecurrenceNextDate;
                    bool isDeploymentActive = IsDeploymentActive(deploymentData.State);
                    emailData.IsDeploymentActive = isDeploymentActive;

                    if (IsInvalidPeriod(deploymentData.RecurrenceNextDate, CalculateNextRecurrenceEndDate(deploymentData)))
                        throw new InvalidOperationException("Trying to create deployment that ends before it begins");

                    Guid newDeploymentId = await DuplicateDeployment(deploymentData, userId);
                    emailData.NewDeploymentId = newDeploymentId; //would be empty if didn't recur due to workflow

                    parentQnnDply[Constants.FieldName.RecurrenceJobId] = null; //avoid trying to delete the job we are running in now

                    //Even deployment state is not "Active" (Workflow), the schedule will keep running to make sure upon it become "Active" it will run as expected.
                    //This method ScheduleNextRecurrence is editing parentQnnDply value
                    await ScheduleNextRecurrence(parentQnnDply, deploymentData.RecurrenceNextDate, userId, shared);

                    await qnnDplyModel.UpdateSingleAsync(parentQnnDply);

                    shared.Commit();

                    emailData.OutCome = "The recurrent deployment was successfully created.";
                }
                catch (Exception e)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    if(Logger.IsEnabled(LogLevel.Debug))
                    {   //Log only at debug level here as the exception is rethrown to caller who should handle/log it
                        Logger.LogDebug(e, nameof(CreateNextRecurrentDeployment) + " - caught unexpected exception, parentDplyId={0}", parentDplyId);
                    }                    
                    emailData.NotifyDateStart = null;
                    emailData.OutCome = "The recurrent deployment creation failed. Please check with system administrator.";
                    throw;
                }
                finally
                {
                    //Do email notifications once the transaction has committed
                    await SendDeploymentRecurrenceEmail(emailData);
                }//end finally
            } //end using tx 
        }

        #region Deployment Recurrence

        /// <summary>
        /// To copy relevant deployment data
        /// nb: Deployment that pending on workflow will not be duplicated
        /// nb: If workflow approved on the expected recur date (after schedule trigger will got the next date)
        /// it will not recur as expected because the scheduler already update the next recurrence date.
        /// workflow approve must be done before the expected recur date, only it will be process as expected.
        /// </summary>
        private static async Task<Guid> DuplicateDeployment(
            DeploymentData deploymentData, 
            Guid userId)
        {
            Guid newDeploymentId = Guid.Empty;
            if (IsDeploymentActive(deploymentData.State))
            {
                bool auditOn = await AuditSettings.GetAuditOnAsync();
                DeploymentRecurrenceStoreProcedureData deploymentRecurrenceSPData 
                    = new DeploymentRecurrenceStoreProcedureData(userId, auditOn);

                newDeploymentId = await ExecSP_CopyRecurrentDply(deploymentData, deploymentRecurrenceSPData);
                deploymentRecurrenceSPData.NewDeploymentId = newDeploymentId;
                deploymentRecurrenceSPData.DelegationCodes = await DelegationApplication.GenerateDelegationCodes(newDeploymentId);

                await ExecSP_AddDplySampleInfoByListId(deploymentData, deploymentRecurrenceSPData);

                await ExecSP_CopySampleOwner(deploymentData, deploymentRecurrenceSPData);

                await ExecSP_CopyStrataQuota(deploymentData, deploymentRecurrenceSPData);

                //Pre Populate feature is not happens during this process, it happens when retrieve existing response.
                //Check SurveyResponseReader for more info

                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(DuplicateDeployment) + " - deployment {0} duplicated", deploymentData.DeploymentName);
                }
            }
            else
            {
                if (Logger.IsEnabled(LogLevel.Information))
                {
                    Logger.LogInformation(nameof(DuplicateDeployment) + " - deployment {0} not duplicated (not active)", deploymentData.DeploymentName);
                }
            }
            return newDeploymentId;
        }

        /// <summary>
        /// Copy values from the parent deployment to the new one. Nb: this doesn't copy every column
        /// </summary>
        private static async Task<Guid> ExecSP_CopyRecurrentDply(
            DeploymentData deploymentRecurrenceData, 
            DeploymentRecurrenceStoreProcedureData deploymentRecurrenceSPData)
        {
            const string RecurrenceDplyIdKey = "RecurrenceDplyId";
            Dictionary<string, object> copyRecurrentDplyOutParams 
                = new Dictionary<string, object>() { { RecurrenceDplyIdKey, Guid.Empty } };
            await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                Constants.StoredProcedure.spSP_CopyRecurrentDply,
                deploymentRecurrenceSPData.GetSP_CopyRecurrentDplyParams(deploymentRecurrenceData),
                copyRecurrentDplyOutParams);
            return (Guid)copyRecurrentDplyOutParams[RecurrenceDplyIdKey];
        }

        //public Dictionary<string, object> GetSP_AddDplySampleInfoByListIdParams(DeploymentData deploymentData)
        //{
        //    if (DelegationCodes == null) DelegationCodes = new List<string>();
        //    return new Dictionary<string, object>()
        //        {
        //            {"DplyId", NewDeploymentId},
        //            {"ListId", deploymentData.ListId},
        //            {"UserPass", "userpass"}, //TODO: Find out why hard code and leave a comment here.
        //            {"UserId", UserId},
        //            {"StructDivisionId", deploymentData.DbStructDivisionId },
        //            {"EventBatch", EventBatchId},
        //            {"EventDate", EventDate},
        //            {"DelegationCodes", String.Join('|', DelegationCodes) },
        //            {"AuditOn", AuditOn}
        //        };
        //}

        /// <summary>
        /// Create the deployment sample info
        /// </summary>
        private static async Task ExecSP_AddDplySampleInfoByListId(
            DeploymentData deploymentRecurrenceData, 
            DeploymentRecurrenceStoreProcedureData deploymentRecurrenceSPData)
        {
            //TODO - the audit info should be passed in by caller and
            //       shared with other activities of this recurrence creation
            AuditBatch auditBatch = await AuditSettings.NewBatchAsync(deploymentRecurrenceSPData.UserId);
            Guid auditStructDivisionId = deploymentRecurrenceData.StructDivisionId.Value; //TODO - is this from user or dply?
            //...

            await spSP_AddDplySampleInfoByListId.ExecuteAsync(
                deploymentRecurrenceSPData.NewDeploymentId,
                deploymentRecurrenceData.ListId,
                deploymentRecurrenceSPData.DelegationCodes,
                auditBatch,
                auditStructDivisionId);
        }

        /// <summary>
        /// Copy the data editor sample ownership
        /// </summary>
        private static async Task ExecSP_CopySampleOwner(
            DeploymentData deploymentRecurrenceData, 
            DeploymentRecurrenceStoreProcedureData deploymentRecurrenceSPData)
        {
            await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                Constants.StoredProcedure.spSP_CopySampleOwner,
                deploymentRecurrenceSPData.GetSP_CopySampleOwnerParams(deploymentRecurrenceData),
                new Dictionary<string, object>());
        }

        private static async Task ExecSP_CopyStrataQuota(
            DeploymentData deploymentRecurrenceData, 
            DeploymentRecurrenceStoreProcedureData deploymentRecurrenceSPData)
        {
            await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                Constants.StoredProcedure.spSP_CopyStrataQuota,
                deploymentRecurrenceSPData.GetSP_CopyStrataQuotaParams(deploymentRecurrenceData),
                new Dictionary<string, object>());
        }

        #endregion

        /// <summary>
        /// Sends notification of the recurrence. Won't halt on error (will just log it)
        /// </summary>
        /// <param name="emailData"></param>
        /// <returns></returns>
        private static async Task SendDeploymentRecurrenceEmail(DeploymentRecurrenceEmailData emailData)
        {
            //Whether to send email if deployment is not active, could be an option for user (in app setting/an input in recurrence deployment if workflow enabled and still not active)
            //Send email if deployment is not active, this could help notify user the workflow still under processing, perhaps they need to take some action
            if (emailData.NotificationsToSend && emailData.IsDeploymentActive)
            {
                try
                {
                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    await Email.FormSendAsync(
                        mailSettings: mailSettings,
                        mailTo: new string[] { emailData.RecurrenceNotify },
                        mailCc: null,
                        mailBcc: null,
                        formName: emailData.EmailTemplateName,
                        parameters: emailData.EmailParam,
                        senderDisplayName: appName);
                }
                catch (Exception e)
                {
                    Logger.LogError(e, nameof(SendDeploymentRecurrenceEmail) + " - caught unexpected exception");
                }
            }
        }

        private static bool IsInvalidPeriod(DateTime StartDate, DateTime EndDate)
        {
            return EndDate < StartDate;
        }

        private static bool IsDeploymentActive(string deploymentState)
        {
            return deploymentState == "Active";
        }

        private static bool StartImmediately(int RecurrenceAdvanceDays)
        {
            return RecurrenceAdvanceDays == 0;
        }

        private static DateTime CalculateNextRecurrenceEndDate(DeploymentData deploymentData)
        {
            return DateCalculator.CalculateNextRecurrenceEndDate(deploymentData.DateStart, deploymentData.DateEnd, deploymentData.RecurrenceNextDate);
        }

        /// <summary>
        /// Date calculation related
        /// </summary>
        public static class DateCalculator
        {
            public static async Task<DateTime?> CalculateNextRecurrenceStartDate(
                Guid dplyId, 
                DateTime originalDateStart, 
                DateTime afterDate, 
                string recurrenceFrequency, 
                DateTime recurrenceEndDate)
            {
                DateTime? result = null;
                if (recurrenceFrequency.Equals(DplyRecurType.CUSTOM))
                {
                    List<DynamicEntity> customList = await CustomRecurrence.GetDplyCustomRecurrenceList(dplyId);
                    result = await CalculateCustomRecurrenceDate(
                        customList, 
                        dplyId, 
                        originalDateStart, 
                        afterDate, 
                        recurrenceEndDate);
                }
                else
                {
                    result = await CalculateRecurrenceDate(
                        dplyId, 
                        originalDateStart, 
                        afterDate, 
                        recurrenceFrequency, 
                        recurrenceEndDate);
                }

                return result;
            }

            public static DateTime CalculateNextRecurrenceEndDate(DateTime StartDate, DateTime EndDate, DateTime RecurrenceNextDate)
            {
                //For the new deployment, initialise it with the same duration as the original
                TimeSpan Duration = EndDate - StartDate;
                return RecurrenceNextDate + Duration;
            }

            #region "Dply Recur Custom Frequency"

            private static async Task<DateTime?> CalculateCustomRecurrenceDate(
                List<DynamicEntity> customRecurList, 
                Guid dplyId, 
                DateTime originalDateStart, 
                DateTime afterDate, 
                DateTime recurrenceEndDate)
            {
                DateTime? result;
                int recurrences;
                do
                {
                    recurrences = 0;
                    result = CalculateCustomRecurrenceDate(customRecurList, originalDateStart, afterDate, recurrenceEndDate);

                    if (result != null)
                    {
                        // To avoid the next recurrence date appear as the same as original deployment start date.
                        // It happens when original deploymeny start date is a future date and over its recurrence range.
                        if (result > originalDateStart)
                        {
                            recurrences = await CountDplyRecurrenceDate(dplyId, result);

                            if (recurrences > 0)
                            {
                                afterDate = (DateTime)result;
                            }
                        }
                        else
                        {
                            afterDate = (DateTime)result;
                            recurrences = 1; //The 1 referring to the original deployment start date (future), set to 1 (already recur) make sure it loops again.
                        }

                    }
                } while (result != null && recurrences > 0);

                return result;
            }

            private static DateTime? CalculateCustomRecurrenceDate(List<DynamicEntity> customRecurList, DateTime originalDateStart, DateTime afterDate, DateTime recurrenceEndDate)
            {
                DateTime? result = null;

                if (customRecurList != null && customRecurList.Any())
                {
                    List<DateTime> checkList = new List<DateTime>();
                    foreach (DynamicEntity customRecur in customRecurList)
                    {
                        string recurType = customRecur[Constants.FieldName.CustomFrequencyType].ToString();
                        int recurDayOrWeek = int.Parse(customRecur[Constants.FieldName.RecurDay].ToString());
                        int recurMonth = int.Parse(customRecur[Constants.FieldName.RecurMonth].ToString());
                        int recurYear = int.Parse(customRecur[Constants.FieldName.RecurYear].ToString());

                        if (recurType != DplyRecurType.CustomType.EXACT_DATE)
                        {
                            recurYear = afterDate.Year;
                            if (recurType.Contains("EACH MONTH"))
                            {
                                recurMonth = afterDate.Month;
                            }
                        }

                        try
                        {
                            DateTime recurDate = CalculateCustomRecurrenceDate(originalDateStart.DayOfWeek, recurType, recurDayOrWeek, recurMonth, recurYear, afterDate, recurrenceEndDate);
                            checkList.Add(recurDate);
                        }
                        catch (ArgumentOutOfRangeException) {/*Custom handle for result over the cut off date.*/}
                        
                    }
                    checkList = checkList.Where(e => e.Date >= afterDate.Date && e.Date <= recurrenceEndDate.Date).ToList();

                    if (checkList.Any())
                    {
                        result = checkList.OrderBy(e => e).ToList().First();
                        result = result.Value.AddHours(originalDateStart.Hour);
                        result = result.Value.AddMinutes(originalDateStart.Minute);
                    }
                }

                return result;
            }

            private static DateTime CalculateCustomRecurrenceDate(DayOfWeek dayOfWeek, string recurType, int recurDayOrWeek, int recurMonth, int recurYear, DateTime afterDate, DateTime cutOffDate)
            {

                DateTime result;
                switch (recurType)
                {
                    case DplyRecurType.CustomType.EXACT_DATE:
                        result = new DateTime(recurYear, recurMonth, recurDayOrWeek);
                        break;

                    case DplyRecurType.CustomType.N_DAY_N_MONTH:
                    case DplyRecurType.CustomType.N_DAY_EACH_MONTH:
                        result = new DateTime(recurYear, recurMonth, 1).AddDays(-1).AddDays(recurDayOrWeek);
                        break;

                    case DplyRecurType.CustomType.N_LAST_DAY_N_MONTH:
                    case DplyRecurType.CustomType.N_LAST_DAY_EACH_MONTH:
                        result = new DateTime(recurYear, recurMonth, 1).AddMonths(1).AddDays(-recurDayOrWeek);
                        break;

                    case DplyRecurType.CustomType.N_WEEK_N_MONTH:
                    case DplyRecurType.CustomType.N_WEEK_EACH_MONTH:
                        result = CalculateCustomRecurrenceDateForWeek(dayOfWeek, recurDayOrWeek, recurMonth, recurYear);
                        break;

                    case DplyRecurType.CustomType.N_LAST_WEEK_N_MONTH:
                    case DplyRecurType.CustomType.N_LAST_WEEK_EACH_MONTH:
                        result = CalculateCustomRecurrenceDateForWeek(dayOfWeek, -recurDayOrWeek, recurMonth, recurYear);
                        break;

                    default:
                        throw new InvalidOperationException("Invalid CustomFrequencyType");
                }

                if (IsNextStartDateAfterCutOff((DateTime?)result, cutOffDate)) throw new ArgumentOutOfRangeException($"The date: " + result.Date + " already over cut off of date: " + cutOffDate.Date);
                if (result.Month != recurMonth) result = DateTime.MinValue; //result is not under the expected month, set to minimum for further calculation.

                //Move toward to the future.
                if (recurType != DplyRecurType.CustomType.EXACT_DATE && result.Date <= afterDate)
                {
                    if (recurType.Contains("EACH MONTH"))
                    {
                        if (recurMonth == 12)
                        {
                            recurMonth = 1;
                            recurYear += 1;
                        }
                        else
                        {
                            recurMonth += 1;
                        }
                    }
                    else
                    {
                        recurYear += 1;
                    }
                    result = CalculateCustomRecurrenceDate(dayOfWeek, recurType, recurDayOrWeek, recurMonth, recurYear, afterDate, cutOffDate);
                }

                return result;
            }

            private static DateTime CalculateCustomRecurrenceDateForWeek(DayOfWeek preferredDay, int recurWeek, int recurMonth, int recurYear)
            {
                DateTime result = new DateTime(recurYear, recurMonth, 1);
                int weekCursor = 0;
                int direction = 1;

                if (recurWeek < 0)
                {
                    result = result.AddMonths(1).AddDays(-1);
                    direction = -1;
                    recurWeek = Math.Abs(recurWeek);
                }

                while (weekCursor < recurWeek)
                {
                    if (result.DayOfWeek == preferredDay)
                    {
                        weekCursor++;
                        if (weekCursor == recurWeek) { break; }
                    }
                    result = result.AddDays(direction);
                }

                return result;
            }

            #endregion

            #region "Dply Recur Standard Frequency"

            private static async Task<DateTime?> CalculateRecurrenceDate(
                Guid dplyId, 
                DateTime originalDateStart, 
                DateTime afterDate, 
                string recurrenceFrequency, 
                DateTime recurrenceEndDate)
            {
                DateTime? result = null;
                int recurrences;
                do
                {
                    recurrences = 0;
                    result = CalculateNextStartDate(originalDateStart, afterDate, recurrenceFrequency, recurrenceEndDate);
                    if (result != null)
                    {
                        // To avoid the next recurrence date appear as the same as original deployment start date.
                        // It happens when original deploymeny start date is a future date and over its recurrence range.
                        if (result > originalDateStart)
                        {
                            recurrences = await CountDplyRecurrenceDate(dplyId, result);

                            if (recurrences > 0)
                            {
                                afterDate = (DateTime)result;
                            }
                        }
                        else
                        {
                            afterDate = (DateTime)result;
                            recurrences = 1; //The 1 referring to the original deployment start date (future), set to 1 (already recur) make sure it loops again.
                        }
                    }
                } while (result != null && recurrences > 0);

                return result;
            }

            /// <summary>
            /// Calculate the next date to start a recurring scheduled process (e.g. deployment, scheduled export etc)
            /// after the afterDate given the original dateStart, the frequency of recurrences, and the endDate after 
            /// which there may be no more recurrences (this datetime is inclusive, so if the next recurrence were to equal it it would not recur).
            /// This method was originally created for use with recurrent deployments, and its scope has now expanded to assist with 
            /// scheduled exports. 
            /// </summary>
            /// <param name="dateStart"></param>
            /// <param name="afterDate"></param>
            /// <param name="recurrenceFrequency"></param>
            /// <param name="recurrenceEndDate">end date for recurrences (inclusive)</param>
            /// <returns>date or null</returns>
            public static DateTime? CalculateNextStartDate(
                DateTime dateStart, 
                DateTime afterDate, 
                string recurrenceFrequency, 
                DateTime recurrenceEndDate)
            {
                //TODO - calculate the recurrences ourselves and remove dependency on the rather unsatisfactory Recurs package
                int day = dateStart.Day; //nb: OnDay is required to workaround library bug
                RecurrenceType rType = null; //Using the Dates.Recurring package
                switch (recurrenceFrequency)
                {
                    case DplyRecurType.DAILY:
                        rType = Recurs.Starting(dateStart).Every(1).Days().Build();
                        break;
                    case DplyRecurType.WEEKLY:
                        //TODO - the below seems to give start of the week rather than a week agter the dateStart. Is this desired?
                        rType = Recurs.Starting(dateStart).Every(1).Weeks().Build();
                        break;
                    case DplyRecurType.MONTHLY:
                        //nb: it will use last day of month if outside the range of the month
                        rType = Recurs.Starting(dateStart).Every(1).Months().OnDay(day).Build();
                        break;
                    case DplyRecurType.QUARTERLY:
                        rType = Recurs.Starting(dateStart).Every(4).Months().OnDay(day).Build();
                        break;
                    case DplyRecurType.HALF_YEARLY:
                        rType = Recurs.Starting(dateStart).Every(6).Months().OnDay(day).Build();
                        break;
                    case DplyRecurType.ANNUALLY:
                        //Use 12 months instead of 1 year to work around library issues
                        rType = Recurs.Starting(dateStart).Every(12).Months().OnDay(day).Build();
                        break;
                    case DplyRecurType.BIENNIALLY:
                        //Use 24 months instead of 2 years to work around library issues
                        rType = Recurs.Starting(dateStart).Every(24).Months().OnDay(day).Build();
                        break;
                    default:
                        throw new InvalidOperationException("Invalid RecurrenceFrequency");
                }
                DateTime? nextDateStart = rType.Next(afterDate);
                //Check the ending date ourselves as the Recurs library has somewhat different ideas about what 'after' should mean in some cases
                if (IsNextStartDateAfterCutOff(nextDateStart, recurrenceEndDate)) nextDateStart = null;
                return nextDateStart;
            }

            #endregion

            /// <summary>
            /// This is inclusive of the cutoff date.
            /// </summary>
            /// <param name="nextDateStart"></param>
            /// <param name="recurrenceEndDate"></param>
            /// <returns></returns>
            private static bool IsNextStartDateAfterCutOff(DateTime? nextDateStart, DateTime recurrenceEndDate)
            {
                return nextDateStart != null && nextDateStart >= recurrenceEndDate;
            }

            private static async Task<int> CountDplyRecurrenceDate(Guid dplyId, DateTime? checkDate)
            {
                int result;

                Dictionary<string, object> paramsIn = new Dictionary<string, object>
                    {
                        {"DplyId", dplyId},
                        {"DateStart", checkDate},
                    };
                Dictionary<string, object> paramsOut = new Dictionary<string, object>()
                    {
                        {"Recurrences", -1 }
                    };

                await CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(
                    Constants.StoredProcedure.spSP_CountRecurrenceAfter, 
                    paramsIn, 
                    paramsOut);

                result = (int)paramsOut["Recurrences"];

                return result;

            }

        }

        /// <summary>
        /// Deployment Custom Recurrence CRUD
        /// </summary>
        public static class CustomRecurrence
        {
            public static async Task<DynamicEntity> GetDplyCustomRecurrence(Guid SelectedId)
            {
                EntityModel db = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_CUSTOM_RECURRENCE);
                return (await db.GetAsync(Filter.And.Equal(SelectedId.ToString(), Constants.FieldName.Id))).FirstOrDefault();
            }

            public static async Task<DynamicEntity> GetDplyCustomRecurrence(Guid dplyIdGuid, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear)
            {
                EntityModel db = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_CUSTOM_RECURRENCE);
                Filter filter = Filter.And.Equal(dplyIdGuid.ToString(), Constants.FieldName.DplyId)
                    .Equal(frequencyType, Constants.FieldName.CustomFrequencyType)
                    .Equal(frequencyDay, Constants.FieldName.RecurDay)
                    .Equal(frequencyMonth, Constants.FieldName.RecurMonth)
                    .Equal(frequencyYear, Constants.FieldName.RecurYear);
                return (await db.GetAsync(filter)).FirstOrDefault();
            }

            public static async Task<List<DynamicEntity>> GetDplyCustomRecurrenceList(Guid dplyIdGuid)
            {
                EntityModel db = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_CUSTOM_RECURRENCE);
                Filter filter = Filter.And.Equal(dplyIdGuid.ToString(), Constants.FieldName.DplyId);
                return await db.GetAsync(filter);
            }

            public static async Task<bool> SaveDplyCustomRecurrence(Guid SelectedId, Guid dplyIdGuid, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear)
            {
                DynamicEntity dbModel = await GetDplyCustomRecurrence(SelectedId);
                if (dbModel == null)
                {
                    dbModel = await GetDplyCustomRecurrence(dplyIdGuid, frequencyType, frequencyDay, frequencyMonth, frequencyYear); // To avoid reinsert the same record
                    if (dbModel == null)
                    {
                        await InsertDplyCustomRecurrence(dplyIdGuid, frequencyType, frequencyDay, frequencyMonth, frequencyYear);
                    }
                }
                else
                {
                    await UpdateDplyCustomRecurrence(dbModel, dplyIdGuid, frequencyType, frequencyDay, frequencyMonth, frequencyYear);
                }

                return true;
            }

            private static async Task<DynamicEntity> InsertDplyCustomRecurrence(Guid dplyIdGuid, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear)
            {
                EntityModel db = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_CUSTOM_RECURRENCE);
                DynamicEntity dynamicModel = await GetDplyCustomRecurrenceEntityModel(db, dplyIdGuid, frequencyType, frequencyDay, frequencyMonth, frequencyYear);
                dynamicModel[Constants.FieldName.Id] = Guid.NewGuid();
                dynamicModel[Constants.FieldName.CreatedBy] = CloverRuntime.Security.CurrentUser.Id;
                dynamicModel[Constants.FieldName.CreatedDate] = DateTime.Now;

                using (var shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();
                    await db.InsertSingleAsync(dynamicModel);
                    shared.Commit();
                }

                return dynamicModel;
            }

            private static async Task UpdateDplyCustomRecurrence(DynamicEntity customFrequencyModel, Guid dplyIdGuid, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear)
            {
                EntityModel db = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_CUSTOM_RECURRENCE);
                DynamicEntity dynamicModel = await GetDplyCustomRecurrenceEntityModel(db, dplyIdGuid, frequencyType, frequencyDay, frequencyMonth, frequencyYear, customFrequencyModel);
                dynamicModel[Constants.FieldName.UpdatedBy] = CloverRuntime.Security.CurrentUser.Id;
                dynamicModel[Constants.FieldName.UpdatedDate] = DateTime.Now;
                using (var shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();
                    await db.UpdateSingleAsync(dynamicModel);
                    shared.Commit();
                }
            }

            private static async Task<DynamicEntity> GetDplyCustomRecurrenceEntityModel(EntityModel em, Guid dplyIdGuid, string frequencyType, int frequencyDay, int frequencyMonth, int frequencyYear, DynamicEntity dynamicModel = null)
            {
                if (dynamicModel == null)
                {
                    dynamicModel = await em.NewAsync();
                }

                dynamicModel[Constants.FieldName.DplyId] = dplyIdGuid;
                dynamicModel[Constants.FieldName.CustomFrequencyType] = frequencyType;
                dynamicModel[Constants.FieldName.RecurDay] = frequencyDay;
                dynamicModel[Constants.FieldName.RecurMonth] = frequencyMonth;
                dynamicModel[Constants.FieldName.RecurYear] = frequencyYear;

                return dynamicModel;
            }

        }

        /// <summary>
        /// This class mostly to extract data from QNN_DPLY
        /// To group all DynamicEntity value extraction process
        /// </summary>
        private class DeploymentData
        {
            /// <summary>
            /// Not sure why handle null Guid, suppose StructDivisionId column should not be null
            /// </summary>
            public Object DbStructDivisionId { get { return (Object)StructDivisionId ?? (Object)DBNull.Value; } }

            #region QNN_DPLY

            public Guid DeploymentId { get; set; }

            public string DeploymentName { get; set; }

            public Guid? StructDivisionId { get; set; }

            public DateTime DateEnd { get; set; }

            public DateTime DateStart { get; set; }

            public Guid ListId { get; set; }

            public string State { get; set; }

            #region Recurrence Related

            public string RecurrenceJobId { get; set; }

            public bool RecurrenceEnabled { get; set; }

            public string RecurrenceFrequency { get; set; }

            public DateTime RecurrenceNextDate { get; set; }

            public DateTime RecurrenceEndDate { get; set; }

            public string RecurrenceNotify { get; set; }

            public int RecurrenceAdvanceDays { get; set; }

            #endregion

            #endregion

            public DeploymentData(DynamicEntity QNN_DPLY)
            {
                DeploymentId = (Guid)QNN_DPLY.GetId();
                DeploymentName = (string)QNN_DPLY[Constants.FieldName.Name];
                DateStart = (DateTime)QNN_DPLY[Constants.FieldName.DateStart];
                DateEnd = (DateTime)QNN_DPLY[Constants.FieldName.DateEnd];

                //The recurrence will share the same structDivisionId as its parent deployment
                StructDivisionId = (Guid?)QNN_DPLY[Constants.FieldName.StructDivisionId];
                ListId = (Guid)QNN_DPLY[Constants.FieldName.ListId];

                RecurrenceEnabled = (bool)QNN_DPLY[Constants.FieldName.RecurrenceEnabled];
                RecurrenceJobId = (string)QNN_DPLY[Constants.FieldName.RecurrenceJobId];
                RecurrenceFrequency = (string)QNN_DPLY[Constants.FieldName.RecurrenceFrequency];
                RecurrenceEndDate = (DateTime)QNN_DPLY[Constants.FieldName.RecurrenceEndDate];
                RecurrenceNextDate = (DateTime)QNN_DPLY[Constants.FieldName.RecurrenceNextDate];
                RecurrenceAdvanceDays = (int)QNN_DPLY[Constants.FieldName.RecurrenceAdvanceDays];
                RecurrenceNotify = (string)QNN_DPLY[Constants.FieldName.RecurrenceNotify];
                State = (string)QNN_DPLY[Constants.FieldName.State];
            }
        }

        /// <summary>
        /// To group store procedure required input parameter
        /// </summary>
        private class DeploymentRecurrenceStoreProcedureData
        {
            public Guid UserId { get; set; }

            public Guid EventBatchId { get; set; }

            public DateTime EventDate { get; set; }

            public bool AuditOn { get; set; }

            public Guid NewDeploymentId { get; set; }

            public List<string> DelegationCodes { get; set; }

            public DeploymentRecurrenceStoreProcedureData(Guid UserId, bool AuditOn)
            {
                EventBatchId = new Guid();
                EventDate = DateTime.Now;
                this.UserId = UserId;
                this.AuditOn = AuditOn;
            }

            public Dictionary<string, object> GetSP_CopyRecurrentDplyParams(DeploymentData deploymentData)
            {
                return new Dictionary<string, object>()
                {
                    {"Id", deploymentData.DeploymentId},
                    {"UserId", UserId},
                    {"DateStart", deploymentData.RecurrenceNextDate},
                    {"DateEnd", CalculateNextRecurrenceEndDate(deploymentData)},
                    {"StartDeploymentImmediately", StartImmediately(deploymentData.RecurrenceAdvanceDays) }, //will make it visible
                    {"StructDivisionId", deploymentData.DbStructDivisionId},
                    {"EventBatch", EventBatchId },
                    {"EventDate", EventDate },
                    {"AuditOn", AuditOn }
                };
            }

            public Dictionary<string, object> GetSP_CopySampleOwnerParams(DeploymentData deploymentData)
            {
                return new Dictionary<string, object>()
                {
                    {"ParentDplyId", deploymentData.DeploymentId},
                    {"RecurrenceDplyId", NewDeploymentId },
                    {"UserId", UserId},
                    {"StructDivisionId", deploymentData.DbStructDivisionId },
                    {"EventBatch", EventBatchId},
                    {"EventDate", EventDate},
                    {"AuditOn", AuditOn}
                };
            }

            public Dictionary<string, object> GetSP_CopyStrataQuotaParams(DeploymentData deploymentData)
            {
                return new Dictionary<string, object>()
                {
                    {"ParentDplyId", deploymentData.DeploymentId},
                    {"RecurrenceDplyId", NewDeploymentId },
                    {"UserId", UserId},
                    {"StructDivisionId", deploymentData.DbStructDivisionId },
                    {"EventBatch", EventBatchId},
                    {"EventDate", EventDate},
                    {"AuditOn", AuditOn}
                };
            }
        }

        private class DeploymentRecurrenceEmailData
        {
            /// <summary>
            /// Init after create new deployment
            /// </summary>
            public Guid NewDeploymentId { get; set; }

            public bool IsDeploymentActive { get; set; }

            public string DeploymentName { get; set; }

            public string RecurrenceNotify { get; set; }

            public string ParentDplyId { get; set; }

            public string OutCome { get; set; }

            public bool NotificationsToSend { get { return !string.IsNullOrEmpty(RecurrenceNotify); } }

            public bool NewRecurrenceCreated { get { return NewDeploymentId != Guid.Empty; } }

            public DateTime? NotifyDateStart { get; set; }

            public string EmailTemplateName
            {
                get
                {
                    return NewRecurrenceCreated ?
                        Constants.EmailTemplate.RecurrenceCreatedEmailTemplate :
                        Constants.EmailTemplate.RecurrenceFailedEmailTemplate;
                }
            }

            public Dictionary<string, string> EmailParam
            {
                get
                {
                    return new Dictionary<string, string>()
                        {
                            { "Name", DeploymentName },
                            { "RecurrenceDplyId", NewRecurrenceCreated ? NewDeploymentId.ToString() : null },
                            { "Outcome", OutCome },
                            { "DateStart", (NotifyDateStart == null) ? null : ((DateTime)NotifyDateStart).ToString("d MMM yyyy HH:mm")}
                        };
                }
            }

            public DeploymentRecurrenceEmailData()
            {
                NewDeploymentId = Guid.Empty;
                OutCome = "Unknown Error"; //It is for the final process when trigger email.
            }
        }
    }
}
