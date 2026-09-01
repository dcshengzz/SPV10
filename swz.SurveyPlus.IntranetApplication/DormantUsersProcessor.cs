using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Action taken for a specific user and whether there were any issues sending the relevent email to them
    /// </summary>
    public class UserDormancyResult
    {
        public enum Type { Warning, Lock};
        public enum MailOutcome { Sent, NoEmailAddress, SendFailed }

        public static UserDormancyResult Lock(DynamicEntity user, MailOutcome mailStatus)
        {
            return new UserDormancyResult(user, Type.Lock, mailStatus);
        }

        public static UserDormancyResult Warning(DynamicEntity user, MailOutcome mailStatus)
        {
            return new UserDormancyResult(user, Type.Warning, mailStatus);
        }

        public Type ActionTaken { get; private set; }
        public MailOutcome MailStatus { get; private set; }
        public Guid Id { get; private set; }
        public string Name { get; private set; }
        public DateTime InactiveSince { get; private set; }

        private UserDormancyResult(DynamicEntity user, Type action, MailOutcome mailStatus)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));
            this.ActionTaken = action;
            this.MailStatus = mailStatus;
            this.Id = (Guid)user.GetId();
            this.Name = (string)user[Constants.FieldName.Name];
            this.InactiveSince = DormantUsersProcessor.GetInactiveSince(user);
        }
    }

    /// <summary>
    /// Mutable class to assist with marshalling and encapsulating settings for the DormantUsersProcessor
    /// </summary>
    public class UserDormancySettings
    {
        //dwAppSettings names
        private const string USER_DORMANCY_REPORT_RECIPIENTS = "UserDormancyReportRecipients";
        private const string USER_LOCK_INACTIVE_DAYS = "UserLockInactiveDays";
        private const string USER_LOCK_WARN_DAYS = "UserLockWarnDays";
        private const string USER_DORMANCY_EXCLUDE_LOGINS = "UserDormancyExcludeLogins";

        //TODO - I'd prefer this to be immutablelist, but filter expects list
        //       so for now lets keep it private and take care not to mess with it
        //       (Alt approach is make it immutable here and use ToList when making filter)
        private static readonly List<String> settingNames = new List<string> {
            USER_DORMANCY_REPORT_RECIPIENTS, USER_LOCK_INACTIVE_DAYS, USER_LOCK_WARN_DAYS, USER_DORMANCY_EXCLUDE_LOGINS };

        public static int Disabled = -1;
        public static readonly IEnumerable<Guid> All_StructDivisions = null;

        /// <summary>
        /// Returns an instance with locking and warning disabled and no report recipients
        /// </summary>
        /// <returns></returns>
        public static UserDormancySettings NewDefaultInstance()
        {
            return new UserDormancySettings(
                filterToStructDivisions: All_StructDivisions,
                lockInactiveDays: Disabled,
                warnInactiveDays: Disabled,
                reportRecipients: null,
                excludeLogins: Constants.Flyweights.Empty_ReadOnlyCollection_String
            );
        }

        /// <summary>
        /// Returns an instance read from the AppSettings.
        /// This method may be removed or refactored in the future when we add support for organisation level settings
        /// </summary>
        /// <returns></returns>
        public static async Task<UserDormancySettings> GetFromAppSettingsAsync()
        {
            UserDormancySettings dormancySettings = NewDefaultInstance();
            Dictionary<string, string> appSettings 
                = (await AppSettings.SelectAsync(Filter.And.In(settingNames, Constants.FieldName.Name)))
                .ToDictionary( s => s.Name, s => s.Value);

            if(appSettings.TryGetValue(USER_DORMANCY_REPORT_RECIPIENTS, out string reportRecipientsSetting))
            {
                dormancySettings.ReportRecipients = await MailRecipients.FromStringForAllOrganisations(reportRecipientsSetting);
            }
            else
            {
                dormancySettings.ReportRecipients = null;
            }

            if (appSettings.ContainsKey(USER_LOCK_INACTIVE_DAYS) && int.TryParse(appSettings[USER_LOCK_INACTIVE_DAYS], out int lockInactiveDays))
                dormancySettings.LockInactiveDays = lockInactiveDays;

            if (appSettings.ContainsKey(USER_LOCK_WARN_DAYS) && int.TryParse(appSettings[USER_LOCK_WARN_DAYS], out int warnInactiveDays))
                dormancySettings.WarnInactiveDays = warnInactiveDays;

            if (appSettings.ContainsKey(USER_DORMANCY_EXCLUDE_LOGINS))
                dormancySettings.ExcludeLogins = appSettings[USER_DORMANCY_EXCLUDE_LOGINS].Split(',').Select(e => e.Trim()).Distinct().ToList();

            return dormancySettings;
        }

        // // // //

        /// <summary>
        /// Days since last activity after which to lock the account.
        /// Set 0 to disable the locking and also the warnings.
        /// </summary>
        public int LockInactiveDays { get; set; }

        /// <summary>
        /// Days since last activity after which to warn the account that it will be locked.
        /// Set 0 or to disable the warnings. Will also be disabled if LockInactiveDays is 0.
        /// </summary>
        public int WarnInactiveDays { get; set; }

        public bool LockInactiveAccounts {  get { return LockInactiveDays > 0; } }

        public bool WarnInactiveAccounts {  get { return LockInactiveAccounts && (WarnInactiveDays > 0); } }

        /// <summary>
        /// Who is to receieve report. This may also be null (no recipients). 
        /// </summary>
        public MailRecipients ReportRecipients { get; set; }

        public bool IsAnyReportRecipients { get => ReportRecipients?.IsAnyValid ?? false; }

        /// <summary>
        /// Logins (not Name) of users to exclude from the dormancy processing 
        /// (intended to put the vital but infequently accessed superuser account here)
        /// </summary>
        public IEnumerable<string> ExcludeLogins
        {
            get { return excludeLogins; }
            set { if (value == null) throw new ArgumentNullException(nameof(ExcludeLogins)); excludeLogins = value; }
        }

        /// <summary>
        /// Filter to users in the specified structdivisions
        /// If null will consider all struct divisions.
        /// (For future enhancement - currently we don't support changing this and the recipients
        /// isn't filtering either)
        /// </summary>
        public IEnumerable<Guid> FilterToStructDivisions { get; } = All_StructDivisions;

        private IEnumerable<string> excludeLogins = Constants.Flyweights.Empty_ReadOnlyCollection_String;

        private UserDormancySettings(
            IEnumerable<Guid> filterToStructDivisions, 
            int lockInactiveDays, 
            int warnInactiveDays, 
            MailRecipients reportRecipients,
            IEnumerable<string> excludeLogins)
        {
            this.FilterToStructDivisions = filterToStructDivisions; //null if no SD filter
            this.LockInactiveDays = lockInactiveDays;
            this.WarnInactiveDays = warnInactiveDays;
            this.ReportRecipients = reportRecipients;
            this.ExcludeLogins = excludeLogins;
        }
    } //end class UserDormancySettings

    /// <summary>
    /// Processor to perform the sending of warning emails and the locking of users who have been inactive too long.
    /// Inactivity periods are configured by an instance of UserDormancySettings.
    /// To use this class create an instance - typically by using the convenience NewInstanceAsyc factory method rather than the constructor, and call the ExecuteAsync() method,
    /// You may adjust the settings via the DormancySettings property, and make multiple calls to ExecuteAsync. 
    /// When done use the Results property to get a report on the outcomes. Use SendReportAsync() to send the
    /// results to the admins specified in the current DormancySettings. To clear results you can call Reset().
    /// nb: instances of this class should NOT be considered threadsafe (even if the implementation at the time you read this happens to be threadsafe by coincidence)
    /// </summary>
    public class DormantUsersProcessor
    {
        /// <summary>
        /// Create a new instance of the processor using its classname as the logger category, and dormancy and mail settings read from
        /// the AppSettings. Will use current datetime as the effectiveDate.
        /// </summary>
        /// <returns></returns>
        public static async Task<DormantUsersProcessor> NewInstanceAsync()
        {
            ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(DormantUsersProcessor));
            UserDormancySettings dormancySettings = await UserDormancySettings.GetFromAppSettingsAsync();
            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string appName = await SettingsHelper.Common.GetApplicationName();
            DormantUsersProcessor processor = new DormantUsersProcessor(logger, dormancySettings, mailSettings, appName, DateTime.Now);
            await processor.InitialiseAsync();
            return processor;
        }
        
        /// <summary>
        /// LastLoginDate or the CreatedDate if they never logged in
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public static DateTime GetInactiveSince(DynamicEntity user)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));
            return (DateTime?)user[Constants.FieldName.LastLoginDate] ?? (DateTime)user[Constants.FieldName.CreatedDate];
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public UserDormancySettings DormancySettings { get; set; }

        /// <summary>
        /// List of results about users that have been warned or locked.
        /// (To clear the results use the Reset() method)
        /// </summary>
        public List<UserDormancyResult> Results { get; private set; }

        private const string emailDateFormat = "dd MMM yyyy"; //date format used in emails

        private readonly ILogger logger;
        
        private readonly MailSettings mailSettings;
        private readonly string appName;
        private readonly DateTime effectiveDate;

        private EntityModel dwSecurityUserModel; //set in InitialiseAsync
        private Order ascCreatedDate = Order.StartAsc(Constants.FieldName.CreatedDate);

        /// <summary>
        /// Constructor - mainly intended for use by test cases and factory methods, can also be used for special cases .
        /// If using this constructor instead of a factory method you will need to call InitialiseAsync before first use.
        /// To conveniently get a standard instance you can use the CreateStandardInstanceAsync static factory method instead of this constructor
        /// </summary>
        /// <param name="logger"></param>
        public DormantUsersProcessor(
            ILogger logger, 
            UserDormancySettings dormancySettings, 
            MailSettings mailSettings, 
            string appName,
            DateTime effectiveDate)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (dormancySettings == null) throw new ArgumentNullException(nameof(dormancySettings));
            if (mailSettings == null) throw new ArgumentNullException(nameof(mailSettings));
            if (string.IsNullOrWhiteSpace(appName)) throw new ArgumentException(nameof(appName));
            this.logger = logger;
            this.DormancySettings = dormancySettings;
            this.mailSettings = mailSettings;
            this.appName = appName;
            this.effectiveDate = effectiveDate;
            Reset();
        }

        /// <summary>
        /// Should be called once only after construction to perform further async initialisation tasks.
        /// If you use the factory method this will be done for you.
        /// </summary>
        /// <returns></returns>
        public async Task InitialiseAsync()
        {
            //if we call this twice it suggest a logic error somewhere that we want to investigate so fail fast
            bool alreadyInitialised = (dwSecurityUserModel != null);
            if (alreadyInitialised) throw new InvalidOperationException("Already initialised");

            dwSecurityUserModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
        }

        /// <summary>
        /// Clears any accumulated results
        /// </summary>
        public void Reset()
        {
            Results = new List<UserDormancyResult>();
        }

        /// <summary>
        /// Find any accounts that have not logged in recently and lock them, marking their dormancy.
        /// Email the locked accounts to notify them. For accounts approaching inactivity send them an email to warn them.
        /// To get the results check the Results property when ready. Calls to ExceuteAsync will add items to that list.
        /// </summary>
        /// <returns></returns>
        public async Task ExecuteAsync()
        {
            if (DormancySettings == null) 
                throw new InvalidOperationException("DormancySettings has not been set");

            HashSet<Guid> ignoreUsers = await ExcludedUsers();

            //Process locking first so we don't warn users who are going to get locked now
            if (DormancySettings.LockInactiveAccounts)
                await ProcessAccountLocking(ignoreUsers);

            if (DormancySettings.WarnInactiveAccounts)
                await ProcessSendWarnings(ignoreUsers);
        }

        /// <summary>
        /// Email a report about the current Results to the recipients
        /// specified in the current DormancySettings.
        /// If there are no results then no report is sent.
        /// </summary>
        public async Task SendReportAsync()
        {
            if(DormancySettings.IsAnyReportRecipients)
            {
                string report = GenerateReportHtml();
                if (report != null)
                {
                    foreach (string recipient in DormancySettings.ReportRecipients.GetValidDistinctEmails())
                    {
                        if (logger.IsEnabled(LogLevel.Information)) logger.LogInformation("Sending dormancy report to {0}", recipient);
                        await Email.SendAsync(
                            mailSettings: mailSettings,
                            mailTo: recipient,
                            subject: $"{appName} inactive users for {effectiveDate.ToString(emailDateFormat)}",
                            body: report,
                            senderDisplayName: appName);
                    }
                }
            }
            else if(DormancySettings.ReportRecipients != null)
            {
                if (DormancySettings.ReportRecipients.IsAnyInvalid && logger.IsEnabled(LogLevel.Warning))
                {   //Not fatal, just log any with bad addresses
                    logger.LogWarning(nameof(SendReportAsync) + " - some address resolutions were invalid: {0}", DormancySettings.ReportRecipients.GetInvalidResolutions());
                }
            }                
        }

        /// <summary>
        /// Generate a report on the users that were locked and warned.
        /// If there are no results to report then will not generate a report and will instead return null.
        /// </summary>
        /// <returns>null if no results to report</returns>
        public string GenerateReportHtml() 
        {
            if (DormancySettings == null) 
                throw new InvalidOperationException("DormancySettings has not been set");

            if(Results.Any())
            {
                IEnumerable<UserDormancyResult> resultsSortedByName = new ReadOnlyCollection<UserDormancyResult>( Results.OrderBy(r => r.Name).ToList() );

                StringBuilder report = new StringBuilder();
                report.AppendLine("<html><body>");

                int totalCount = Results.Count;
                report.AppendLine($"Inactivity actions were taken for {totalCount} users.<br/>");
                report.AppendLine("<br/>");

                Func<UserDormancyResult, string> MailStatusText = (r) => 
                {
                    switch (r.MailStatus)
                    {
                        case UserDormancyResult.MailOutcome.Sent: return "notification was sent";
                        case UserDormancyResult.MailOutcome.NoEmailAddress: return "no email address to notify";
                        case UserDormancyResult.MailOutcome.SendFailed: return "failed to send notification";
                        default: throw new NotImplementedException(r.MailStatus.ToString());
                    }
                };

                if(DormancySettings.LockInactiveAccounts)
                {
                    List<UserDormancyResult> lockedResults = resultsSortedByName.Where(r => r.ActionTaken == UserDormancyResult.Type.Lock).ToList();
                    report.AppendLine($"{lockedResults.Count()} users were locked for being inactive in excess of {DormancySettings.LockInactiveDays} days.<br/>");
                    foreach (UserDormancyResult lockedUser in lockedResults)
                    {
                        string name = WebUtility.HtmlEncode(lockedUser.Name);
                        report.AppendLine($"- {name} ({MailStatusText(lockedUser)})<br/>");
                    }
                } 
                else
                {
                    report.AppendLine("Locking of inactive users is not enabled.<br/>");
                }

                if (DormancySettings.WarnInactiveAccounts)
                {
                    report.AppendLine("<br/>");
                    List<UserDormancyResult> warnedResults = resultsSortedByName.Where(r => r.ActionTaken == UserDormancyResult.Type.Warning).ToList();
                    report.AppendLine($"{warnedResults.Count} users were warned for being inactive in excess of {DormancySettings.WarnInactiveDays} days.<br/>");
                    foreach(UserDormancyResult warnedUser in warnedResults)
                    {
                        string name = WebUtility.HtmlEncode(warnedUser.Name);
                        report.AppendLine($"- {name} ({MailStatusText(warnedUser)})<br/>");
                    }
                }
                else
                {
                    report.AppendLine("Warning of inactive users is not enabled.<br/>");
                }

                report.AppendLine("</body></html>");
                return report.ToString();
            }
            else
            {
                //Return null to indicate that a report was not generated
                return null;
            }
        }

        private async Task ProcessAccountLocking(HashSet<Guid> ignoreUsersWithId)
        {
            DateTime lockDate = effectiveDate.AddDays(0 - DormancySettings.LockInactiveDays); //will compare with last login or creation if never logged in
            Filter byUsersToBeLocked = UserFilter(after: null, before: lockDate, DormancySettings.FilterToStructDivisions);

            List<DynamicEntity> usersToLock
                = (await dwSecurityUserModel.GetAsync(filter: byUsersToBeLocked, order: ascCreatedDate, paging: null))
                .Where(u=>!ignoreUsersWithId.Contains((Guid)u.GetId()))
                .ToList();

            //Lock the accounts first (mutate the entities in the collection)
            foreach (DynamicEntity user in usersToLock)
            {
                user[Constants.FieldName.IsLocked] = true;
                user[Constants.FieldName.DormancyDate] = effectiveDate;
            }
            await dwSecurityUserModel.UpdateAsync(usersToLock.Cast<dynamic>().ToList());

            //Then try to send the emails
            foreach (DynamicEntity user in usersToLock)
            {
                string name = (string)user[Constants.FieldName.Name];
                string email = (string)user[Constants.FieldName.Email];
                if (!string.IsNullOrWhiteSpace(email))
                {
                    DateTime inactiveSince = GetInactiveSince(user);
                    string lockSubject = $"Inactive {appName} account locked";
                    string lockMessage
                        = "Your login for " + WebUtility.HtmlEncode(appName)
                        + " under the name " + WebUtility.HtmlEncode(name)
                        + " has been inactive since " + inactiveSince.ToString(emailDateFormat)
                        + " in excess of " + DormancySettings.LockInactiveDays + " days"
                        + " and has now been locked.";
                    bool sentSuccessfully = await Email.SendAsync(
                        mailSettings: mailSettings, 
                        mailTo: email, 
                        subject: lockSubject, 
                        body: lockMessage,
                        senderDisplayName: appName);
                    if (sentSuccessfully)
                    {
                        //Ok!
                        Results.Add(UserDormancyResult.Lock(user, UserDormancyResult.MailOutcome.Sent));
                    }
                    else
                    {
                        //Mail error
                        Results.Add(UserDormancyResult.Lock(user, UserDormancyResult.MailOutcome.SendFailed));
                        if (logger.IsEnabled(LogLevel.Warning))
                            logger.LogWarning("Failed to send inactivity warning to user {0} using email address {1}", name, email);
                    }
                }
                else
                {
                    //No email address
                    Results.Add(UserDormancyResult.Lock(user, UserDormancyResult.MailOutcome.NoEmailAddress));
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogWarning("Did not send inactivity warning to user {0} (no email address)", name);
                }
            }
        }

        private async Task ProcessSendWarnings(HashSet<Guid> ignoreUsersWithId)
        {
            DateTime warningAfter = effectiveDate.AddDays(-1 - DormancySettings.WarnInactiveDays);
            DateTime warningBefore = effectiveDate.AddDays(0 - DormancySettings.WarnInactiveDays); //will compare with last login or creation if never logged in
            Filter byUsersToBeWarned = UserFilter(warningAfter, warningBefore, DormancySettings.FilterToStructDivisions);

            List<DynamicEntity> usersToWarn
                = (await dwSecurityUserModel.GetAsync(filter: byUsersToBeWarned, order: ascCreatedDate, paging: null))
                .Where(u => !ignoreUsersWithId.Contains((Guid)u.GetId()))
                .ToList(); ;

            foreach (DynamicEntity user in usersToWarn)
            {
                string name = (string)user[Constants.FieldName.Name];
                string email = (string)user[Constants.FieldName.Email];
                if (!string.IsNullOrWhiteSpace(email))
                {
                    DateTime inactiveSince = GetInactiveSince(user);
                    DateTime dateToSetDormant = inactiveSince.AddDays(DormancySettings.LockInactiveDays);
                    string warnSubject = $"{appName} account inactivity warning";
                    string warningMessage
                        = "Your login for " + WebUtility.HtmlEncode(appName)
                        + " under the name " + WebUtility.HtmlEncode(name)
                        + " has been inactive since " + inactiveSince.ToString(emailDateFormat)
                        + " and will be set as dormant after " + dateToSetDormant.ToString(emailDateFormat)
                        + " if you do not login before then.";
                    bool sentSuccessfully = await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: email,
                        subject: warnSubject,
                        body: warningMessage,
                        senderDisplayName: appName);
                    if (sentSuccessfully)
                    {
                        //Ok!
                        Results.Add(UserDormancyResult.Warning(user, UserDormancyResult.MailOutcome.Sent));
                    }
                    else
                    {
                        //Mail error
                        Results.Add(UserDormancyResult.Warning(user, UserDormancyResult.MailOutcome.SendFailed));
                        if (logger.IsEnabled(LogLevel.Warning))
                            logger.LogWarning("Failed to send inactivity warning to user {0} using email address {1}", name, email);
                    }
                }
                else
                {
                    //No email address
                    Results.Add(UserDormancyResult.Warning(user, UserDormancyResult.MailOutcome.NoEmailAddress));
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogWarning("Did not send inactivity warning to user {0} because they have no email address", name);
                }
            }
        }

        /// <summary>
        /// Create filter to find unlocked users who were last active before the specified cutoff date.
        /// </summary>
        /// <param name="after">optional - last activity must have been > this time</param>
        /// <param name="before">required - last activity must have been <= this time</param>
        /// <param name="structDivisionIds">ignored if null, when specified users must be in one of the listed struct divisions</param>
        /// <returns></returns>
        private Filter UserFilter(DateTime? after, DateTime before, IEnumerable<Guid> structDivisionIds)
        {
            Filter isUnlocked = Filter.And.Equal(0, Constants.FieldName.IsLocked);

            //(LastLoginDate IS NULL AND CreatedDate <= cutoffDate) OR (LastLoginDate IS NOT NULL AND LastLoginDate <= cutoffDate)
            Filter lastActiveBeforeCutoffDate = Filter.Or
                .NestAnd()
                    .Equal(Null.Value, Constants.FieldName.LastLoginDate)
                    .LessOrEqual(before, Constants.FieldName.CreatedDate) //would 'ignore' users for whom this is null
                    .Parent()
                .NestAnd()
                    .NotEqual(Null.Value, Constants.FieldName.LastLoginDate)
                    .LessOrEqual(before, Constants.FieldName.LastLoginDate);

            Filter filter = isUnlocked.Merge(lastActiveBeforeCutoffDate);
            if (structDivisionIds != UserDormancySettings.All_StructDivisions)
            {
                Filter inStructDivisions = Filter.And.In(structDivisionIds.Distinct().ToList(), Constants.FieldName.StructDivisionId);
                filter.Merge(inStructDivisions);
            }
            if (after != null)
            {
                //uses > rather than >= 
                Filter lastActiveAfterCutoffDate = Filter.Or
                .NestAnd()
                    .Equal(Null.Value, Constants.FieldName.LastLoginDate)
                    .Greater(after, Constants.FieldName.CreatedDate) //would 'ignore' users for whom this is null
                    .Parent()
                .NestAnd()
                    .NotEqual(Null.Value, Constants.FieldName.LastLoginDate)
                    .Greater(after, Constants.FieldName.LastLoginDate);
                filter = filter.Merge(lastActiveAfterCutoffDate);
            }
            return filter;
        }

        /// <summary>
        /// Based on the logins in the domancy settings find the users to ignore for warnings and locking
        /// </summary>
        /// <returns>Id of users to ignore</returns>
        private async Task<HashSet<Guid>> ExcludedUsers()
        {
            List<string> loginsToExclude = DormancySettings.ExcludeLogins.Distinct().ToList();
            Filter byLogins = Filter.And.In(loginsToExclude, Constants.FieldName.Login);
            HashSet<Guid> userIds = (await SecurityCredential.SelectAsync(byLogins)).Select(c => c.SecurityUserId).ToHashSet();
            return userIds;
        }
    }
}
