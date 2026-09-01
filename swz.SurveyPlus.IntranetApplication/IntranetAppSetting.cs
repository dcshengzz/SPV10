using swz.Clover.Core.Configuration;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Immutable class to hold values read form configuration at startup.
    /// Instance(s) are immutable, and it is expected there will be a single shared
    /// instance made available via DI as a singleton. (See Startup.cs)
    /// Attributes common to both internet and intranet versions of this class
    /// may be put in the base AppSetting class rather than being duplicated)
    /// </summary>
    public class IntranetAppSetting : AppSetting
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// How Program.cs should handle ApplicationStartupException. 
        /// This will effect how IIS handles the startup failure. 
        /// </summary>
        public ApplicationStartupException.ProgramBehaviour StartupExceptionHandling { get; private set; }
            = ApplicationStartupException.ProgramBehaviour.Throw; //TODO - move the exception class to core and this to CloverOptions

        //Convention for below properties:
        //  the class with the properties should have suffix like Settings or Options (etc) and the property
        //  itself needs to follow what is in the json so it can be initialised by netcore when we construct this object

        public CloverOptions Clover { get; }

        public SurveyPlusOptions SurveyPlus { get; }

        public ThirdPartyPartyApiOptions ThirdPartyApi { get; }

        public HelloControllerOptions HelloController { get; }

        public ConnectionStringsOptions ConnectionStrings { get; }

        public PrintSettings PrintSettings { get; }

        public AWSSecretsManagerSettings AWSSecretsManager { get; }

        public IamSettings IamSettings { get; }

        public AuditLogManager AuditLogManager { get; }

        public IntranetAppSetting()
        {
            Clover = new CloverOptions();
            SurveyPlus = new SurveyPlusOptions();
            ThirdPartyApi = new ThirdPartyPartyApiOptions();
            HelloController = new HelloControllerOptions();
            ConnectionStrings = new ConnectionStringsOptions();
            PrintSettings = new PrintSettings();
            AWSSecretsManager = new AWSSecretsManagerSettings();
            IamSettings = new IamSettings();
            AuditLogManager = new AuditLogManager();
        }

    } //end of IntranetAppSetting

    public class SurveyPlusOptions : CommonSurveyPlusOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Enable the Help link in the header. (Turning this off will not turn off Online Help Content
        /// management for HelpEditor users.)
        /// </summary>
        public string BrandingImagePath { get; private set; } = "surveyplus";

        /// <summary>
        /// Enable the Help link in the header. (Turning this off will not turn off Online Help Content
        /// management for HelpEditor users.)
        /// </summary>
        public bool IsHelpEnabled { get; private set; } = true;

        /// <summary>
        /// Intranet UI succinct name of the application used in tab titles
        /// nb: email and reports still use a value configured in dwappsettings and footer name is still in the footer form
        /// </summary>
        public string ShortApplicationName { get; private set; } = "SurveyPlus";

        /// <summary>
        /// Duration before user is shown warning of session timout (in minutes)
        /// </summary>
        public int SessionTimeoutAlertMinutes { get; private set; } = 13;

        /// <summary>
        /// Client-side user-friendly session Timeout duration (in minutes)
        /// (Note: this is not for the ASP.NET HttpSession)
        /// </summary>
        public int SessionTimeoutMinutes { get; private set; } = 15;

        /// <summary>
        /// Auth token timeout duration (in minutes)
        /// </summary>
        public int AuthTimeoutMinutes { get; private set; } = 20;

        /// <summary>
        /// Maximum duration we allow the auth cookie to be used regardless of extension
        /// (Note this does not currently have user-friendly handling clientside)
        /// </summary>
        public int MaxAuthMinutes { get; private set; } = 24 * 60;

        /// <summary>
        /// This folder is used to temporarily hold audit log files after an audit archive+purge.
        /// The admin has some time to delete them before they are removed by a file-specific scehduled job
        /// Path can be relative to application root, or can be an absolute path.
        /// (This allows us to keep it external to the deployment folder).
        /// </summary>
        public string ArchivedAuditLogsFolderPath { get; private set; }

        /// <summary>
        /// This folder is used to temporarily hold response data export files.
        /// The user has some time to delete them before they are removed by a file-specific scehduled job
        /// Path can be relative to application root, or can be an absolute path.
        /// (This allows us to keep it external to the deployment folder).
        /// </summary>
        public string ExportedDeploymentResponseFolderPath { get; private set; }

        /// <summary>
        /// This folder is used to temporarily hold response file zip export files.
        /// The user has some time to delete them before they are removed by a file-specific scehduled job
        /// Path can be relative to application root, or can be an absolute path.
        /// (This allows us to keep it external to the deployment folder).
        /// </summary>
        public string RespFilesDownloadFolderPath { get; private set; }

        public string MailMergeFolderPath { get; private set; }

        //n.b. the command is configured through appsettings instead of dwAppSettings for security reasons
        //     the dwAppSettings is modifiable via web ui, and I don't want anyone (not even Admins) controlling
        //     the content of command line calls from the web!

        public string MailMergeArchivedFolderCommand { get; private set; }

        public string MailMergeArchivedFolderCommandArguments { get; private set; }

        public string MailMergeArchivedFolderExtension { get; private set; }

        /// <summary>
        /// This folder is used to temporarily hold response data export files for 3PA.
        /// There is a substantial delay before they are removed by a file-specific scehduled job to allow time for
        /// them to stream to 3pa caller.
        /// Path can be relative to application root, or can be an absolute path.
        /// (This allows us to keep it external to the deployment folder).
        /// </summary>
        public string RespFiles3PAFolderPath { get; private set; }

        public long ScheduledExportResponseAttachmentBytes { get; private set; } = 0;

        public long ScheduledExportUploadsAttachmentBytes { get; private set; } = 0;

        /// <summary>
        /// Used by the ResponseExportService to set the file ticket expiry.
        /// </summary>
        public int ResponseDownloadLinkExpiryHours { get; private set; } = 48;

        public bool IsResponseDownloadLinkExpiring { get { return ResponseDownloadLinkExpiryHours > 0; } }

        /// <summary>
        /// Dormant Users Job Schedule (disabled if not explicity set in appsettings.json)
        ///Cron syntax UTC(minute hour dayM month dayW) - Subtract 8 hours from desired SGT for UTC
        /// </summary>
        public string ProcessDormantUsersSchedule { get; private set; }

        public bool IsProcessDormantUsersEnabled { get => !string.IsNullOrWhiteSpace(ProcessDormantUsersSchedule); }

        /// <summary>
        /// Access audit export job schedule (disabled if not explicity set in appsettings.json)
        /// Exports for previous month, so at start of month is best (eg: 17 Last day UTC is 1am First day SGT)
        /// </summary>
        public string MonthlyAuditAccessLogExportSchedule { get; private set; }

        public bool IsMonthlyAuditAccessLogExportEnabled { get => !string.IsNullOrWhiteSpace(MonthlyAuditAccessLogExportSchedule); }

        /// <summary>
        /// Dormant Users Job Schedule (disabled if not explicity set in appsettings.json)
        /// cron syntax UTC(minute hour dayM month dayW) - Subtract 8 hours from desired SGT for UTC
        /// </summary>
        public string CleanupExpiredFileTicketsSchedule { get; private set; }

        public bool IsCleanupExpiredFileTicketsEnabled { get => !string.IsNullOrWhiteSpace(CleanupExpiredFileTicketsSchedule); }

        /// <summary>
        /// Timing of the daily report snapshots job - currently only applicable for SIMS. 
        /// (Disabled if not explicity set in appsettings.json)
        /// IMPORTANT NOTE: 
        ///     If changing the default timing, please continue to ensure the job is run on a DAILY basis
        ///     to ensure report accuracy
        /// Cron syntax UTC(minute hour dayM month dayW) - Subtract 8 hours from desired SGT for UTC.
        /// Usual value is "30 15 * * *"
        /// </summary>
        public string TakeReportSnapshotSchedule { get; private set; }

        public bool IsTakeReportSnapshotEnabled { get => !string.IsNullOrWhiteSpace(TakeReportSnapshotSchedule); }

        public int LicenseExpiryDays { get; private set; } = 30;

        /// <summary>
        /// Validate License Expiry Schedule (Disabled if not explicity set in appsettings.json)
        /// This job is for the warning message that the license is about to expire 
        /// (disabling it won't bypass the actual license check)
        /// Cron syntax UTC(minute hour dayM month dayW) - Subtract 8 hours from desired SGT for UTC
        /// </summary>
        public string ValidateLicenseExpirySchedule { get; private set; }

        public bool IsValidateLicenseExpiryEnabled { get => !string.IsNullOrWhiteSpace(ValidateLicenseExpirySchedule); }

        public bool IsEnableResponseVersionCheck { get; private set; } = true;

        /// <summary>
        /// Enable the legacy check of reponse date vs timestamp from clientside
        /// This is now disabled by default, and likely to be removed in a future version of SurveyPlus.
        /// </summary>
        public bool IsEnableResponseTimestampCheck { get; private set; } = false;

        /// <summary>
        /// The legacy updater will not be supported in future versios and will be removed soon.
        /// Note that certain features (such as ExcelSupport) still use their own update logic
        /// </summary>
        public bool IsUseLegacySurveyResponseUpdater { get; private set; } = false;

        /// <summary>
        /// Expired JWT Cleanup Job Schedule. Cron syntax with times in UTC 
        /// If empty or not exlicitly defined in the JSON then the job will be disabled. 
        /// </summary>
        public string CleanupExpiredJsonWebTokensSchedule { get; private set; }

        public bool IsCleanupExpiredJsonWebTokensEnabled { get => !string.IsNullOrWhiteSpace(CleanupExpiredJsonWebTokensSchedule); }

        public bool IsSqlBulkCopyCheckConstraints { get; private set; } = false;

        /// <summary>
        /// Interval for the MetadataCachesFlusher to check the database for changes to metadata
        /// </summary>
        public double MetadataCacheCheckMinutes { get; private set; } = 5;
    }

    public class ThirdPartyPartyApiOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool IsEnabled { get; private set; } = false;

        /// <summary>
        /// Used for signing respondent tokens for 3PA API.
        /// Value here is obfuscated as per EncryptionHelper using the constants LoginKey and LoginIv.
        /// Recommend to generate the key from 64 crypto-random bytes (represented as base64) (and then encrypt)
        /// WARNING: Default value here is only for development purposes, a new unique secret must be
        ///          set when deploying in uat and production environments.
        /// </summary>
        public string EncryptedTokenKey { get; private set; } = "8V41u4wiKGsOYSzERMGE4jfZKLM9s+HVqTb8M1ko3wfyXRo1Isks8VDm82FT68Z0zT3i/VqUj/w9LR4czLUn6leok0jcLH/9iInFseCDtC6u+yQ6zFXWXloger9OyF20";

        /// <summary>
        /// Is the endpoint to service swagger client enabled (3PA itself must also be enabled)
        /// </summary>
        public bool IsModelApiEnabled { get; private set; } = false;

        /// <summary>
        /// Models allowed my ModelApi (if enabled) without client specific accessToken
        /// </summary>
        public string[] AllowedModelsWithoutToken { get; private set; } = new string[] { };

        /// <summary>
        /// Models allowed my ModelApi (if enabled) with client specific accessToken
        /// </summary>
        public string[] AllowedModelsWithToken { get; private set; } = new string[] { };

    }

    public class HelloControllerOptions
    {
        public string DebugLicenseAccessCode { get; private set; } = null;

        public bool IsEnableDebugLicense => !string.IsNullOrWhiteSpace(DebugLicenseAccessCode);

        public string DebugAuthenticationAccessCode { get; private set; } = null;

        public bool IsEnableDebugAuthentication => !string.IsNullOrWhiteSpace(DebugAuthenticationAccessCode);

        public bool IsShowHeadersInDebugAuthentication { get; private set; } = true;
    }

    public class ConnectionStringsOptions
    {
        public string Default { get; private set; } = null;
    }

    public class PrintSettings
    {
        public PdfExportSettings PdfExport { get; }

        public PrintSettings()
        {
            PdfExport = new PdfExportSettings();
        }
    }

    public class PdfExportSettings
    {
        public bool IsEnabled { get; private set; } = false;

        public int CooldownMinutes { get; set; }
    }

    public class AWSSecretsManagerSettings
    {
        public bool IsEnabled { get; private set; } = false;
        public bool IsUseLazyProvider { get; private set; } = true;
        public string SecretName { get; private set; } = string.Empty;
        public string Region { get; private set; } = string.Empty;
        public string VersionStage { get; private set; } = string.Empty;
    }

    public class IamSettings
    {
        public bool IsEnabled { get; private set; } = false;
        public string SecretKey { get; private set; } = string.Empty;
        public string RequestExpiry { get; private set; } = string.Empty;
    }

    public class AuditLogManager
    {
        public string Schedule { get; private set; } = string.Empty;
        public AuditExport AuditExport { get; private set; } = new AuditExport();
        public AblrExport AblrExport { get; private set; } = new AblrExport();
    }

    public class AuditExport
    {
        public bool IsEnabled { get; private set; } = false;
        public int KeepInDbDays { get; private set; } = -1;
        public string LocalTempPath { get; private set; } = string.Empty;
        public string CloudProvider { get; private set; } = string.Empty;
        public string CloudPath { get; private set; } = string.Empty;
        public string FileName { get; private set; } = string.Empty;
    }

    public class AblrExport
    {
        public bool IsEnabled { get; private set; } = false;
        public string Path { get; private set; } = string.Empty;
        public string FileName { get; private set; } = string.Empty;
        public string ProjectReference { get; private set; } = string.Empty;
    }

}
