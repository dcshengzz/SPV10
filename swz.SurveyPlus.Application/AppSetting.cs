using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
using System.Collections.ObjectModel;
using System;
using System.Linq;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Class to wrap some commonly used settings from the appsettings.json to make it convenient to expose them
    /// to various services in the application. Extended by IntranetAppSetting, InternetAppSetting.
    /// (Not to be confused with the AppSettings class which is the one you want if you're reading from table dwAppSettings)
    /// </summary>
    public abstract class AppSetting
    {

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //      Exercise caution around the mutability of property types,          //
        //      (such as List etc)                                                 //
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        //extended by IntranetAppSettings (in the internet side)
        //extended by InternetAppSettings (in the internet side)

        public SecurityHeaderSetting SecurityHeaders { get; }

        public UnifiedAtAppSetting UnifiedAtApp { get; }

        public UnifiedAtDatabaseSetting UnifiedAtDatabase { get; }

        public DataManagementOptions DataManagement { get; }

        public AppSetting()
        {
            SecurityHeaders = new SecurityHeaderSetting();
            UnifiedAtApp = new UnifiedAtAppSetting();
            UnifiedAtDatabase = new UnifiedAtDatabaseSetting();
            DataManagement = new DataManagementOptions();
        }
    }

    /// <summary>
    /// Settings that are common to both intranet and internet SurveyPlusOptions
    /// </summary>
    public abstract class CommonSurveyPlusOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool EnableSpammyLogsInProductionBecauseImTroubleshooting { get; private set; } = false;

        public string LogPath { get; private set; } = null;

        public int LogRetainedFileCountLimit { get; private set; } = 31;

        public bool LogBuffered { get; private set; } = false;
    }

    /// <summary>
    /// Options for ASP.NET core DataProtection and Session management.
    /// Note that some options may not be supported in the Internet application.
    /// </summary>
    public class DataManagementOptions
    {
        public enum SessionLocation {
            /// <summary>
            /// Will use AddDistributedMemoryCache to store session in memory only.
            /// </summary>
            Memory,

            /// <summary>
            /// Will store the session in the database in the DotNetCoreSession table
            /// using AddDistributedSqlServerCache. Note that a mult-server environment will
            /// also need to have an appropriate DataProtection setting configured.
            /// This option is not available in the Internet application with U@App.
            /// </summary>
            Database,
            
            /// <summary>
            /// Store session data in Redis.
            /// If specifying this you will also need to provide a redis connection string
            /// </summary>
            Redis,

        }

        /// <summary>
        /// Specifies where to store the http session data. 
        /// This value is used by StartupIntranet and StartupInternet.
        /// </summary>
        public SessionLocation StoreSessionIn { get; private set; } = SessionLocation.Memory;

        /// <summary>
        /// Specifies how the data protection keyring is obtained / located
        /// TODO - consider renaming this enum and its associated configuration attribute 
        ///        to avoid confusion with the ProtectKeysWith configuration attribute
        /// </summary>
        public enum DataProtectionMethod { 
            /// <summary>
            /// Don't explicitly setup DataProtection and instead rely on AspNetCore default discovery mechanism
            /// </summary>
            DefaultDiscovery, 

            /// <summary>
            /// Use Amazon Systems Manager Parameter Store to store the keys (for use in AWS environment only)
            /// </summary>
            AmazonSSM, 

            /// <summary>
            /// Store keys in memory only
            /// </summary>
            Ephemeral, 

            /// <summary>
            /// Store keys in the file system (specify directory using KeyDir property)
            /// </summary>
            FileSystem,

            /// <summary>
            /// Store the keys in Redis
            /// </summary>
            Redis
        }

        /// <summary>
        /// Specifies how to configure DataProtection (e.g. where to put the keys).
        /// This value is used by SharedStartupConfigurator.ConfigureDataProtection which is
        /// called from StartupIntranet and StartupInternet
        /// </summary>
        public DataProtectionMethod DataProtection { get; private set; } = DataProtectionMethod.DefaultDiscovery;

        /// <summary>
        /// If an explicit mechanism is set instead of the default discovery mechanism then this returns true
        /// </summary>
        public bool IsSpecifyDataProtection { get => (DataProtection != DataProtectionMethod.DefaultDiscovery); }

        /// <summary>
        /// Location of the file system directory to store keys when using FileSystem for the DataProtection.
        /// (Ignored by other methods)
        /// It is important for security that this location has appropriate permissions set.
        /// </summary>
        public string KeyDir { get; private set; } = "";

        /// <summary>
        /// Connection configuration for Redis. 
        /// If using Redis for both session state and data protection keys this connection will be used for both. 
        /// This will be used to register an IConnectionMultiplexer singleton, which might also be used by future
        /// features that need to connect to Redis too. 
        /// </summary>
        public string RedisConnectionString { get; private set; } = "";

        public bool IsRedisConnectionStringSpecified { get => !string.IsNullOrWhiteSpace(RedisConnectionString); }

        /// <summary>
        /// Specify an option for protecting the keys in storage. (This is only applied if a non-default method
        /// is specified for DataProtection and will be ignored if using DefaultDiscovery).
        /// </summary>
        public string ProtectKeysWith { get; private set; } = "";

    }

    /// <summary>
    /// Settings for U@Db configuration
    /// (Not implemented yet)
    /// </summary>
    public class UnifiedAtDatabaseSetting
    {
        /// <summary>
        /// We haven't implemented support for this yet, so MUST be false
        /// </summary>
        public bool IsEnabled { get; private set; } = false;
    }

    /// <summary>
    /// Settings for U@App configuration
    /// </summary>
    public class UnifiedAtAppSetting
    {
        /// <summary>
        /// Is the U@App API enabled.
        /// Currently we only support this so the value MUST be true.
        /// Later we may add support for U@Db (looking increasingly less likely) in which case this would
        /// configure whether or not to expose the api on intranet side and which IRespondentService etc to
        /// use on internet side. 
        /// </summary>
        public bool IsEnabled { get; private set; } = true;

        /// <summary>
        /// Shared secret between the internet and intranet side for the U@App API.
        /// Value here is obfuscated as per EncryptionHelper using the constants LoginKey and LoginIv.
        /// Generate the key from 32 crypto-random bytes represented as base64 and then encrypt that base64
        /// WARNING: Default value here is only for development purposes, a new unique secret must be
        ///          set when deploying in uat and production environments.
        /// </summary>
        public string EncryptedApiKey { get; private set; } = "JYeCuJkCf1iFovC1M9EoVWkRgk60Rd/6dSbWuLErszKLPloInIAyNuwsu8gMTk6x";

        /// <summary>
        /// To be configured only on intranet side, used for signing respondent tokens for U@App API.
        /// Value here is obfuscated as per EncryptionHelper using the constants LoginKey and LoginIv.
        /// Recommend to generate the key from 64 crypto-random bytes (represented as base64) (and then encrypt)
        /// WARNING: Default value here is only for development purposes, a new unique secret must be
        ///          set when deploying in uat and production environments.
        /// </summary>
        public string EncryptedTokenKey { get; private set; } = "FC/7EBb97C5vXqIlBvd+B4A/96drVP41702bthnKhOLMB/KWgVAffNY79JoswAZvrQIF+USYGm1hn6YLNACio8MJ6/A4gb887saLrzBxeSiuEcG11EWd2w5kOCtx6FsY";

        /// <summary>
        /// Enable the u@app API endpoint on the Intranet side that is used in the SPCP login
        /// (This setting is not used on the Internet side)
        /// </summary>
        public bool IsSPCPLoginEndpointEnabled { get; private set; } = false;

        /// <summary>
        /// If set to a value above zero then caching is applied to metadata source files retrieved from the intranet side.
        /// (This setting is not used on the Intranet side)
        /// </summary>
        public int MetadataSourceCacheSeconds { get; private set; } = 0;

        /// <summary>
        /// If set to true will enable the Respondent Single-Session feature. With this enabled the respondent is only
        /// permitted a single active session, and the previous session will be invalidated if they login again.
        /// (This setting is not used on the internet side at present but this is likely to change soon, so it should be
        /// initialised on both applications with the same value).
        /// </summary>
        public bool IsEnforceRespondentSingleSession { get; private set; } = false;

        /// <summary>
        /// Controls how much info is returned for the connectivity test on the intranet side (the test page on
        /// internet side is disabled via the accessCode setting). When disabled the endpoint just returns a 204.
        /// When enabled the endpoint returns a plain text string with some information.
        /// </summary>
        public bool IsEnableConnectivityTestResult { get; private set; } = true;

        /// <summary>
        /// If True then the MachineName of the intranet server will be revealed in the result
        /// returned by the connectivity test. 
        /// </summary>
        public bool IsConnectivityTestIncludeMachineInfo { get; private set; } = false;

        /// <summary>
        /// Internet application may choose to request an access token renewal early
        /// without waiting for it to expire when it sees that the token is expiring 
        /// within this many minutes.
        /// This setting is only applicable to the Internet Application.
        /// </summary>
        public double TokenManagerEarlyRenewalMinutes { get; private set; } = 0;

        /// <summary>
        /// Period of time in which tokens are also stored short-term in a memory cache 
        /// to allow them to be shared by requests that might not yet be able to see 
        /// new tokens recently set in the session by an incomplete concurrent request.
        /// This setting is only applicable to the Internet Application.
        /// </summary>
        public double TokenManagerTokenCacheMinutes { get; private set; } = 5;
    }

    public class SecurityHeaderSetting
    {
        /// <summary>
        /// Settings to enable and manage Content Security Policy headeer. 
        /// </summary>
        public ContentSecurityPolicySetting ContentSecurityPolicy { get; }

        /// <summary>
        /// If true will set a header with 
        /// X-Content-Type-Options: nosniff
        /// </summary>
        public bool NoSniff { get; private set; } = true;

        /// <summary>
        /// Options for XFrameOptions property
        /// </summary>
        public enum XFrameOptionsChoices { NONE, DENY, SAMEORIGIN }

        /// <summary>
        /// If set to a value other than NONE will cause SurveyPlus to set an X-Frame-Options header
        /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
        /// Default is DENY
        /// </summary>
        public XFrameOptionsChoices XFrameOptions { get; private set; } = XFrameOptionsChoices.DENY;

        /// <summary>
        /// XXSSProtection property
        /// </summary>
        public string XXSSProtection { get; private set; } = null;

        /// <summary>
        /// If set to a value other than Unspecified will cause SurveyPlus to
        /// set the SameSite status for the .NET authentication (intranet) and 
        /// session (internet) cookies when setting these cookie headers. 
        /// see: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#samesitesamesite-value
        /// Default is Strict.
        /// </summary>
        public SameSiteMode AspSameSite { get; private set; } = SameSiteMode.Strict;

        /// Controls the Secure flag for the .NET authentication (intranet) and 
        /// session (internet) cookies when setting these cookie headers.
        /// Default is SameAsRequest
        /// </summary>
        public CookieSecurePolicy SecurePolicy = CookieSecurePolicy.SameAsRequest;

        /// <summary>
        /// Cache-Control property
        /// </summary>
        public string CacheControl { get; private set; } = null;

        /// <summary>
        /// Pragma property
        /// </summary>
        public string Pragma { get; private set; } = null;

        /// <summary>
        /// Expires property
        /// </summary>
        public string Expires { get; private set; } = null;

        /// <summary>
        /// If not empty then SurveyPlus will set a Referrer-Policy header. 
        /// Recommended value is "same-origin".
        /// Note that current versions of SurveyPlus requires some requests to the application to pass the
        /// referrer, so use of "no-referrer" will break features.
        /// </summary>
        public string ReferrerPolicy
        {
            get => referrerPolicy;
            private set => referrerPolicy = value switch
            {
                "" or
                "no-referrer" or
                "no-referrer-when-downgrade" or
                "origin" or
                "origin-when-cross-origin" or
                "same-origin" or
                "strict-origin" or
                "strict-origin-when-cross-origin" or
                "unsafe-url" => value,
                _ => throw new ArgumentOutOfRangeException(nameof(value), value, "Invalid Referrer-Policy value.")
            };
        }
        private string referrerPolicy = "same-origin";

        public SecurityHeaderSetting()
        {
            ContentSecurityPolicy = new ContentSecurityPolicySetting();
        }
    }

    /// <summary>
    /// Settings to manage Content Security Policy. 
    /// We don't allow the whole thing to be configured here, this is more just for allowing it to be
    /// disabled if necessary, and for tweaking the hashes. 
    /// </summary>
    public class ContentSecurityPolicySetting
    {
        public bool IsEnabled { get; private set; } = true;

        /// <summary>
        /// In addition to 'self' and the wogaa domain (where applicable), these script-src will be added.
        /// Typically this would be used to add specific hashes. 
        /// In appsettings.json you need to specify this as an array and so include the single quotes where they are appplicable. e.g:
        /// "AdditionalScriptSrc": [ "'sha256-6wRdeNJzEHNIsDAMAdKbdVLWIqu8b6+Bs+xVNZqplQw='" ]
        /// Use GetAdditionalScriptSrc to read this.
        /// </summary>
        private List<string> AdditionalScriptSrc { get; set; } = new List<string>();

        /// <summary>
        /// Additional values for script-src 
        /// </summary>
        /// <returns>immutable enumerable of the values in AdditionalScriptSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetAdditionalScriptSrc()
        {
            return new ReadOnlyCollection<string>(AdditionalScriptSrc);
        }

        /// <summary>
        /// Use GetAdditionalImgSrc to read this.
        /// </summary>
        private List<string> AdditionalImgSrc { get; set; } = new List<string>();

        /// <summary>
        /// Additional values for img-src 
        /// </summary>
        /// <returns>immutable enumerable of the values in AdditionalImgSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetAdditionalImgSrc()
        {
            return new ReadOnlyCollection<string>(AdditionalImgSrc);
        }

        //(A quick note on the List<string> values below - if you try to provide some default
        //values then the configuration binder will append to the existing list rather than replace it). 

        /// <summary>
        /// Use GetAdditionalConnectSrc to read this.
        /// </summary>
        private List<string> AdditionalConnectSrc { get; set; } = new List<string>();

        /// <summary>
        /// Additional values for connect-src 
        /// </summary>
        /// <returns>immutable enumerable of the values in AdditionalConnectSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetAdditionalConnectSrc()
        {
            return new ReadOnlyCollection<string>(AdditionalConnectSrc);
        }

        /// <summary>
        /// Use GetAdditionalStyleSrc to read this.
        /// </summary>
        private List<string> AdditionalStyleSrc { get; set; } = new List<string>();

        /// <summary>
        /// Additional values for style-src 
        /// </summary>
        /// <returns>immutable enumerable of the values in AdditionalStyleSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetAdditionalStyleSrc()
        {
            return new ReadOnlyCollection<string>(AdditionalStyleSrc);
        }

        /// <summary>
        /// Use GetAdditionalFontSrc to read this.
        /// </summary>
        private List<string> AdditionalFontSrc { get; set; } = new List<string>();

        /// <summary>
        /// Additional values for font-src 
        /// </summary>
        /// <returns>immutable enumerable of the values in AdditionalFontSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetAdditionalFontSrc()
        {
            return new ReadOnlyCollection<string>(AdditionalFontSrc);
        }

        public bool IsUsingFrameSrc { get => FrameSrc?.Any()??false; }

        /// <summary>
        /// Use GetFrameSrc to read this
        /// </summary>
        private List<string> FrameSrc { get; set; } = new List<string>();

        /// <summary>
        /// Values for frame-src
        /// </summary>
        /// <returns>immutable enumerable of values in FrameSrc (may be empty but never null)</returns>
        public IEnumerable<string> GetFrameSrc()
        {
            return new ReadOnlyCollection<string>(FrameSrc);
        }

        public bool IsUsingFrameAncestors { get => FrameAncestors?.Any()??false; }

        private List<string> FrameAncestors { get; set; } = new List<string>();

        /// <summary>
        /// Values for frame-ancestors
        /// </summary>
        /// <returns>immutable enumerable of values in FrameAncestors (may be empty but never null)</returns>
        public IEnumerable<string> GetFrameAncestors()
        {
            return new ReadOnlyCollection<string>(FrameAncestors);
        }

        public bool IsUsingBaseUri { get => BaseUri?.Any() ?? false; }

        private List<string> BaseUri { get; set; } = new List<string>();

        /// <summary>
        /// Values for base-uri
        /// </summary>
        /// <returns>immutable enumerable of values in BaseUri (may be empty but never null)</returns>
        public IEnumerable<string> GetBaseUri()
        {
            return new ReadOnlyCollection<string>(BaseUri);
        }
    }
}
