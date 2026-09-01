using swz.Clover.Core.Configuration;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using swz.Clover.SPCP;

namespace swz.SurveyPlus.InternetApplication
{
    /// <summary>
    /// Immutable class to hold values read form configuration at startup.
    /// Instance(s) are immutable, and it is expected there will be a single shared
    /// instance made available via DI as a singleton. (See Startup.cs)
    /// Attributes common to both internet and intranet versions of this class
    /// may be put in the base AppSetting class rather than being duplicated)
    /// </summary>
    public class InternetAppSetting : AppSetting
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// How should Program.cs handle ApplicationStartupException. This will effect how IIS handles the startup failure. 
        /// </summary>
        public ApplicationStartupException.ProgramBehaviour StartupExceptionHandling { get; private set; }
            = ApplicationStartupException.ProgramBehaviour.Throw;

        /// <summary>
        /// Holds certain options from the Clover section of appsettings.json
        /// </summary>
        public CloverOptions Clover { get; }

        /// <summary>
        /// Holds the optional configuration for an additional header to apply to U@App api requests.
        /// </summary>
        public WebApiAdditionalHeaderOptions WebApiAdditionalHeader { get; }

        /// <summary>
        /// Various configuration options for the respondent portal (eg things like EnablePasswordResetFeature)
        /// </summary>
        public RespondentPortalOptions RespondentPortal { get; }

        /// <summary>
        /// Generic configuration settings related to Singpass/Corppass support.
        /// Note that some implementation-specific settings (such as CorppassOidcSettings) are not currently
        /// present in InternetAppSettings and will have seperate logic to read them in Startup (as the
        /// classes used change depend on which implementations are configured)
        /// </summary>
        public SPCPOptions SPCP { get; }

        public RestrictionsOptions Restrictions { get; }

        public WogaaSettings Wogaa { get; }

        public AntiVirusSettings AntiVirus { get; }

        public PrintSettings PrintSettings { get; }

        public LambdaIntegrationSettings LambdaIntegrationSettings { get; }

        public SurveyPlusOptions SurveyPlus { get; }

        public InternetAppSetting()
        {
            //These subsections will always exist and have default values if not set from the json
            Clover = new CloverOptions();
            WebApiAdditionalHeader = new WebApiAdditionalHeaderOptions();
            RespondentPortal = new RespondentPortalOptions();
            SPCP = new SPCPOptions();
            Restrictions = new RestrictionsOptions();
            Wogaa = new WogaaSettings();
            AntiVirus = new AntiVirusSettings();
            PrintSettings = new PrintSettings();
            LambdaIntegrationSettings = new LambdaIntegrationSettings();
            SurveyPlus = new SurveyPlusOptions();
        }
    } //end of InternetAppSetting

    public class SurveyPlusOptions : CommonSurveyPlusOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// If empty or not specififed then the /debug/apiconnectivitytest page is not enabled, otherwise this
        /// value needs to be passed as the querystring parameter value for accessCode.
        /// </summary>
        public string ApiConnectivityTestAccessCode { get; private set; } = "";

        /// <summary>
        /// Specifies the default timeout to be applied to instances of HttpClient created
        /// via the IHttpClientFactory in the application services container.
        /// </summary>
        public int HttpClientTimeoutSeconds { get; private set; } = 100;
    }

    public class RespondentPortalOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool EnablePasswordResetFeature { get; private set; } = true;

        public CommonPageSettingsOptions CommonPageSettings { get; }

        public RespondentPortalOptions()
        {
            CommonPageSettings = new CommonPageSettingsOptions();
        }
    }

    public class CommonPageSettingsOptions
    {
        public string BrandingImagePath { get; private set; } = "";

        public ExternalLinksOptions ExternalLinks { get; }

        public CopyrightOptions Copyright { get; }

        public string ApplicationName { get; private set; } = "SurveyPlus";

        public string ShortApplicationName { get; private set; } = "SurveyPlus";

        public bool IsHelpEnabled { get; private set; } = true;

        public AgencyBannerOptions AgencyBanner { get; }

        /// <summary>
        /// Set optional meta description (will be used on the public facing login page)
        /// </summary>
        public string Description { get; private set; } = string.Empty;

        public CommonPageSettingsOptions()
        {
            ExternalLinks = new ExternalLinksOptions();
            Copyright = new CopyrightOptions();
            AgencyBanner = new AgencyBannerOptions();
        }
    }

    public class ExternalLinksOptions
    {
        public string ReportVulnerabilityUrl { get; private set; } = string.Empty;
        public string ReachUrl { get; private set; } = string.Empty;
        public string ContactUrl { get; private set; } = string.Empty;
        public string FeedbackUrl { get; private set; } = string.Empty;
        public string AboutUsUrl { get; private set; } = string.Empty;
        public string PrivacyUrl { get; private set; } = string.Empty;
        public string TermOfUseUrl { get; private set; } = string.Empty;
    }

    public class CopyrightOptions
    {
        public string CopyrightYear { get; private set; } = string.Empty;
        public string LastUpdate { get; private set; } = string.Empty;
    }

    public class AgencyBannerOptions
    {
        public bool Enable { get; private set; } = false;
    }

    public class RestrictionsOptions
    {
        public bool Ip { get; private set; } = false;
        public bool DisableUploadsFromSurvey { get; private set; } = false;
    }

    public class WogaaSettings
    {
        /// <summary>
        /// Set true to enable WOGAA support
        /// </summary>
        public bool Enable { get; private set; } = false;

        /// <summary>
        /// URL of the wogaa script
        /// With current version of wogaa this would be
        /// For UAT use "https://assets.dcube.cloud/scripts/wogaa.js"
        /// For Production use "https://assets.wogaa.sg/scripts/wogaa.js"
        /// </summary>
        public string Url { get; private set; } = "";

        /// <summary>
        /// Returns the value for Url property, but only if Enable flag is set
        /// otherwise returns null
        /// </summary>
        /// <returns></returns>
        public string GetUrlIfEnabled()
        {
            return Enable ? Url : null;
        }

        public bool TransactionalServiceOn { get; private set; } = false;

        /// <summary>
        /// Agency/environment-specific tracking Id issued by Wogaa
        /// </summary>
        public string TransactionalTrackingId { get; private set; } = "";
    }

    public class AntiVirusSettings
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public ClamAVOptions ClamAV { get; }
        public TrendAVOptions TrendAV { get; }

        public AntiVirusSettings()
        {
            ClamAV = new ClamAVOptions();
            TrendAV = new TrendAVOptions();
        }
    }

    public class ClamAVOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool IsEnabled { get; private set; } = false;
        public string ApiBase { get; private set; } = string.Empty;
        public string ScanApi { get; private set; } = string.Empty;
        public string VersionApi { get; private set; } = string.Empty;
        public string AppFormKey { get; private set; } = string.Empty;
    }

    public class TrendAVOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool IsEnabled { get; private set; } = false;
        public string ApiBase { get; private set; } = string.Empty;
        public string ScanApi { get; private set; } = string.Empty;
        public string APIKEY { get; private set; } = string.Empty;
        public string USER_NAME { get; private set; } = string.Empty;
        public string AppFormKey { get; private set; } = string.Empty;
    }

    public class PrintSettings
    {
        public bool IsPDFExportForSubmittedOnly { get; private set; } = false;
        public bool IsRespdashboardPrintEnabled { get; private set; } = false;
    }

    public class LambdaIntegrationSettings
    {
        public bool IsEnabled { get; private set; } = false;
    }
}
