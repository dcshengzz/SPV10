using System;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using Serilog;
using Serilog.Events;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.FileProviders;
using System.Reflection;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.DependencyInjection;
using System.IO;
using System.Text.RegularExpressions;
using System.Globalization;
using StackExchange.Redis;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Shares the common Startup Configure logic for various items (such as logging, content security policy)
    /// so both intranet and internet side can be maintained in the same place where they are doing the same thing.
    /// </summary>
    public static class SharedStartupConfigurator
    {
        /// <summary>
        /// To be called from Startup.Configure to initialise the logging infrastructure in accordance with appsettings.json for the current environment
        /// </summary>
        /// <typeparam name="TStartup">The Startup type who is calling (will be used for the logger that is returned, and category of logging here)</typeparam>
        /// <param name="configuration">Pass the configuration that was built from appsettings.json please</param>
        /// <param name="loggerFactory">pass your ILoggerFactory reference to be prepared</param>
        /// <param name="environmentName">pass your IHostEnvironment.EnvironmentName please</param>
        /// <param name="isProduction">pass your IHostEnvironment.IsProduction please</param>
        /// <param name="surveyPlus">pass the SurveyPlusOptions settings object</param>
        /// <returns>logger for TStartup</returns>
        public static Microsoft.Extensions.Logging.ILogger ConfigureLogging<TStartup>(
            CommonSurveyPlusOptions surveyPlus,
            ILoggerFactory loggerFactory,
            string environmentName,
            bool isProduction)
        {
            if (loggerFactory == null) throw new ArgumentNullException(nameof(LoggerFactory));
            if (surveyPlus == null) throw new ArgumentNullException(nameof(surveyPlus));

            //nb: we could check environmentName here in the method to determine isProduction, but we would have to hard code the name
            //    as we can't see Microsoft.Extensions.Hosting.EnvironmentName.Production here so, whatever, lets just pass it in instead eh?
            try
            {
                if (String.IsNullOrWhiteSpace(surveyPlus.LogPath))
                    throw new InvalidOperationException("SurveyPlus:LogPath is not configured");

                int? retainedFileCountLimit = surveyPlus.LogRetainedFileCountLimit != Constants.Unlimited 
                    ? (int?)surveyPlus.LogRetainedFileCountLimit 
                    : null;
                if (retainedFileCountLimit < -1 || retainedFileCountLimit == 0)
                    throw new InvalidOperationException("SurveyPlus:LogRetainedFileCountLimit is not valid (must be -1, or >= 1");

                //Logging configuration (netcore logging will be redirected to serilog)
                //For more information refer to: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-3.1
                //
                //For safety we don't allow levels lower than Information to be configured in appsettings in production without the extra step of
                //adding the EnableSpammyLogsInProductionBecauseImTroubleshooting settings to the Clover section.
                //Silly name is deliberate. You shouldn't need to use this setting regularly, and when you do, you shouldn't leave it switched on.
                LogEventLevel lowestAllowedLogLevel = LogEventLevel.Verbose;
                if (isProduction && !surveyPlus.EnableSpammyLogsInProductionBecauseImTroubleshooting)
                {
                    lowestAllowedLogLevel = LogEventLevel.Information;
                }
                
                loggerFactory.AddSerilog(new LoggerConfiguration()
                    .MinimumLevel.Is(lowestAllowedLogLevel)
                    .Enrich.FromLogContext()
                    .WriteTo.RollingFile(
                        pathFormat: surveyPlus.LogPath,
                        formatProvider: DefaultLoggingCultureInfo(),
                        restrictedToMinimumLevel: lowestAllowedLogLevel,
                        outputTemplate: Constants.LogFormat,
                        retainedFileCountLimit: retainedFileCountLimit,
                        buffered: surveyPlus.LogBuffered)
                    .CreateLogger()
                );
                DefaultApplicationLogging.InitialiseLoggerFactory(loggerFactory);
                Microsoft.Extensions.Logging.ILogger logger = DefaultApplicationLogging.CreateLogger<TStartup>();
                logger.LogInformation("Application startup. Logging has been configured. EnvironmentName={0}, lowestAllowedLogLevel={1}, logFilePath={2}",
                    environmentName,
                    lowestAllowedLogLevel,
                    surveyPlus.LogPath);
                if (surveyPlus.EnableSpammyLogsInProductionBecauseImTroubleshooting)
                {
                    logger.LogWarning("Lower log levels have been enabled " + (isProduction
                        ? " in production -please remember to disable once you have completed your troubleshooting"
                        : " (but setting is not applicable for non-production environment where restriction is already relaxed)"));
                }
                return logger;
            }
            catch (Exception e)
            {
                throw new StartupLoggingConfigurationException(e);
            }
        }//end of ConfigureLogging

        /// <summary>
        /// Configure the CSP header handling and certain other security headers (eg XFrameOptions etc). 
        /// This applies to controller routes. (Static file security headers are applied in ConfigureStaticFiles)
        /// When Wogaa support is enabled it must also allow the loading of those scripts from their domain.
        /// AppSettings can be used to specify additional sources such as specific hashes
        /// </summary>
        /// <param name="app"></param>
        /// <param name="wogaaUrl">pass null if wogaa is not in use (e.g. intranet, disabled), otherwise pass the url of the wogaa script</param>
        public static void ConfigureSecurityHeaders(AppSetting appSetting, IApplicationBuilder app, string wogaaUrl = null)
        {
            try
            {
                SecurityHeaderSetter setter = new SecurityHeaderSetter(appSetting.SecurityHeaders, wogaaUrl);
                app.Use(async (context, next) =>
                {
                    setter.SetSecurityHeaders(context);
                    await next();
                });
            }
            catch (Exception e)
            {
                throw new StartupConfigurationException(e);
            }
        }

        /// <summary>
        /// Configure serving of static assets
        /// </summary>
        /// <param name="appSetting"></param>
        /// <param name="app"></param>
        public static void ConfigureStaticFilesAndWebAssets(AppSetting appSetting, IApplicationBuilder app)
        {
            SecurityHeaderSetter setter = new SecurityHeaderSetter(appSetting.SecurityHeaders); //(no wogaa here)

            //Normal serving of assets under wwwroot
            app.UseStaticFiles(new StaticFileOptions()
            {
                OnPrepareResponse = (context) =>
                {
                    setter.SetSecurityHeaders(context.Context);
                },
            });

            //Also serve additional files from swz.SurveyPlus.Application/WebAssets
            UseWebAssets(app, setter);

            //For more info on configuring static files see: 
            //https://docs.microsoft.com/en-us/aspnet/core/fundamentals/static-files?view=aspnetcore-3.1
        }

        /// <summary>
        /// Add a file provider to serve static assets declared as EmbeddedResputrces from WebAssets folder in swz.SurveyPlus.Application.
        /// These assets are thus available in both intranet and internet side. For example: surveyplus-utils.js
        /// (This would be called from the SharedStartupConfigurator when setting up handling for static files)
        /// </summary>
        /// <param name="app"></param>
        /// <param name="setter">Instance of SecurityHeaderSetter that will be used to add headers to the response when serving the asset</param>
        private static void UseWebAssets(IApplicationBuilder app, SecurityHeaderSetter setter)
        {
            if (app == null) throw new ArgumentNullException(nameof(app));
            if (setter == null) throw new ArgumentNullException(nameof(setter));

            //Add a provider to serve static files from the WebAssets folder of swz.SurveyPlusApplication
            //For info on ManifestEmbeddedFileProvider, see:
            //  https://docs.microsoft.com/en-us/aspnet/core/fundamentals/file-providers?view=aspnetcore-3.1#manifest-embedded-file-provider
            //These are files we want to share between both Intranet and Internet and only maintain in one place
            //The files to be embedded in the assembly are configured in csproj for swz.SurveyPlus.Application
            //eg: <EmbeddedResource Include="WebAssets\**" />
            //Note: Edits to such files won't be reflected until recompile (which is rather unfortunate for live debugging)
            //      May also need to clear browser cache for it to pull the updated file
            //      If VS still isn't updating it on a rebuild try cleaning the solution
            //      If cleaning the solution doesnt work then restart VS
            //      https://stackoverflow.com/questions/27172273/embedded-resource-txt-file-is-not-updating

            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new ManifestEmbeddedFileProvider(Assembly.GetExecutingAssembly(), root: "WebAssets"),
                OnPrepareResponse = (context) =>
                {
                    setter.SetSecurityHeaders(context.Context);
                }
            });

            //TODO
            //If we had more time we could make the fileprovider smart. Have it cache 'hot' files that
            //everyone will request in memory (like surveyplus-utils.js , which at the time of writing
            //is the only file we have under WebAssets so far -20211022AH).
            //Could also add value added services like something to strip certain comments from the js
            //if they have a certain prefix, so we can put better comments in there without sharing them
            //to the client.
        }

        /// <summary>
        /// Initialise the global IntegrationApiKey in the CloverRuntime based on the encrypted value in the appsettings
        /// for UnifiedAtApp.
        /// Note this uses EncryptionHelper which means it can only be called after DefaultApplicationLogging is intialised.
        /// </summary>
        /// <param name="appSetting"></param>
        public static void ConfigureIntegrationApiKey(AppSetting appSetting)
        {
            try
            {
                string encryptedApiKey = appSetting.UnifiedAtApp.EncryptedApiKey;
                string apiKey = EncryptionHelper.DecryptStr(encryptedApiKey, Constants.LoginKey, Constants.LoginIv);
                CloverRuntime.IntegrationApiKey = apiKey;
            }
            catch (Exception e)
            {
                throw new StartupConfigurationException(e);
            }
        }

        public static void LogNetVersion<TStartup>(ILogger<TStartup> logger)
        {
            //See: https://stackoverflow.com/a/58136318
            Version netCoreVer = System.Environment.Version;
            string runtimeVer = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription;
            logger.LogInformation("System.Environment.Version={0}, FrameworkDescription={1}", netCoreVer, runtimeVer);
        }

        /// <summary>
        /// Configures where the session state is stored based on the setting in dataManagement.StoreSessionIn
        /// Note that this method only implements the options that both intranet and internet application support,
        /// so Database is not supported here. (Caller should check and handle such special options themselves 
        /// instead of here)
        /// </summary>
        public static void ConfigureSessionLocation(
            string applicationName,
            IServiceCollection services,
            DataManagementOptions dataManagement,
            IConnectionMultiplexer redisConnection)
        {
            switch (dataManagement.StoreSessionIn)
            {
                //Store session in memory, only suitable for single-server environments or where there
                //are sticky sessions (server affinity)
                //See: https://learn.microsoft.com/en-us/aspnet/core/performance/caching/distributed?view=aspnetcore-6.0#distributed-memory-cache
                case DataManagementOptions.SessionLocation.Memory:
                    services.AddDistributedMemoryCache();
                    break;

                case DataManagementOptions.SessionLocation.Redis:
                    if (redisConnection == null) throw new InvalidOperationException("Redis connection not configured");
                    services.AddStackExchangeRedisCache(options =>
                    {
                        options.ConnectionMultiplexerFactory = () => Task.FromResult(redisConnection);
                        options.InstanceName = $"{applicationName}_";
                    });
                    break;

                default:
                    throw new NotImplementedException($"Unimplemented {nameof(DataManagementOptions.SessionLocation)} {dataManagement.StoreSessionIn}");
            }
        }

#pragma warning disable CA1416 // Validate platform compatibility (SurveyPlus only supports Windows for now)
        /// <summary>
        /// Configure DataProtection which is used for things like cookie encryption among other things.
        /// See: https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/configuration/overview?view=aspnetcore-6.0
        /// We support only a small subset of the possibilities in NetCore. The option we use being
        /// configured in appsettings.json under the DataManagement block (see AppSetting.cs )
        /// </summary>
        public static void ConfigureDataProtection(
            string applicationName,
            IServiceCollection services, 
            DataManagementOptions dataManagement,
            IConnectionMultiplexer redisConnection)
        {
            if (string.IsNullOrEmpty(applicationName)) throw new ArgumentException(nameof(applicationName));
            if (services == null) throw new ArgumentNullException(nameof(services));
            if (dataManagement == null) throw new ArgumentNullException(nameof(dataManagement));
            
            if (dataManagement.IsSpecifyDataProtection)
            {
                IDataProtectionBuilder dataProtectionBuilder = services.AddDataProtection();

                //n.b. our old behaviour was not to set this explicitly, so we only set this when specifying
                //     a non-default data protection mechanism.
                dataProtectionBuilder.SetApplicationName(applicationName); //Use explicit Application Discriminator

                switch (dataManagement.DataProtection)
                {
                    //Stores keys in memory only (they will be lost when application restarts)
                    case DataManagementOptions.DataProtectionMethod.Ephemeral:
                        dataProtectionBuilder.UseEphemeralDataProtectionProvider();
                        break;

                    //Stores the keys in the specified directory
                    case DataManagementOptions.DataProtectionMethod.FileSystem:
                        string keydir = dataManagement.KeyDir;
                        if (string.IsNullOrWhiteSpace(keydir))
                        {
                            throw new ApplicationStartupException($"{nameof(dataManagement.KeyDir)} not specified in application settings");
                        }
                        DirectoryInfo keyDirectory = new DirectoryInfo(keydir);
                        if (!keyDirectory.Exists)
                        {
                            throw new ApplicationStartupException($"{nameof(dataManagement.KeyDir)} does not specify an existing directory");
                        }
                        dataProtectionBuilder.PersistKeysToFileSystem(keyDirectory);
                        break;

                    //Stores the keys in the AWS Systems Manager Parameter Store
                    //See: https://github.com/aws/aws-ssm-data-protection-provider-for-aspnet
                    case DataManagementOptions.DataProtectionMethod.AmazonSSM:
                        dataProtectionBuilder.PersistKeysToAWSSystemsManager($"/{applicationName}/DataProtection");
                        break;

                    case DataManagementOptions.DataProtectionMethod.Redis:
                        if (redisConnection == null) throw new InvalidOperationException("Redis connection not configured");
                        dataProtectionBuilder.PersistKeysToStackExchangeRedis(redisConnection, $"{applicationName}_DPK");
                        break;

                    default:
                        throw new NotImplementedException($"Unimplemented {nameof(DataManagementOptions.DataProtectionMethod)} {dataManagement.DataProtection}");
                }

                if (!string.IsNullOrEmpty(dataManagement.ProtectKeysWith))
                {
                    if ("Dpapi".Equals(dataManagement.ProtectKeysWith, StringComparison.InvariantCultureIgnoreCase))
                    {
                        dataProtectionBuilder.ProtectKeysWithDpapi();
                    }
                    else if ("DpapiNG".Equals(dataManagement.ProtectKeysWith, StringComparison.InvariantCultureIgnoreCase))
                    {
                        //I believe this option requires a domain to work.
                        //e.g. https://github.com/dotnet/aspnetcore/issues/42769#issuecomment-1186932733

                        //Uses SID of the current Windows user account
                        //"In this scenario, the AD domain controller is responsible for distributing the encryption keys
                        //used by the DPAPI-NG operations. The target user will be able to decipher the encrypted payload
                        //from any domain-joined machine (provided that the process is running under their identity)."
                        //ref: https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/implementation/key-encryption-at-rest?view=aspnetcore-6.0#windows-dpapi-ng
                        //So I presume for same-user across multiple machines would need to use a service account in AD
                        //rather than a local machine or AppPool identity.
                        dataProtectionBuilder.ProtectKeysWithDpapiNG();
                    }
                    else if(IsCertificateThumbprint(dataManagement.ProtectKeysWith))
                    {
                        //n.b I think the cert needs to be 'valid' for this to work otherwise it says
                        //    it can't find it (so needs to be properly signed, and will fail for self-signed)
                        //see: https://github.com/dotnet/aspnetcore/issues/12068
                        //Indeed it failed for a ssc on my machine that my account has permissions for...

                        //We could workaround this by searching for the cert ourselves
                        //the ProtectKeysWithCertificate has overload that takes an X509Certificate2 object
                        //(I also want to add searching for the cert by name like we do for nevis spcp)

                        //normalise to all uppercase with no spaces
                        string thumbprint = dataManagement.ProtectKeysWith.ToUpperInvariant().Replace(" ", "");
                        dataProtectionBuilder.ProtectKeysWithCertificate(thumbprint);
                        //TODO - check: Will this affect us here?
                        //https://github.com/dotnet/aspnetcore/issues/35602
                    }
                    else
                    {
                        //TODO - if its a filepath try to load the certificate from it
                        //       or if its a cert name try and load from store using that like we do for nevis spcp
                        //but we may still run into this? https://stackoverflow.com/a/48722079/8243046
                        //or have they fixed that already? Looks like yes, but I haven't tried it yet
                        //https://github.com/dotnet/aspnetcore/issues/2321

                        throw new ApplicationStartupException($"Invalid or unsupported value for {nameof(dataManagement.ProtectKeysWith)}");
                    }
                }
            }
            else
            {
                //Let ASP.Net core try to figure it out for us using its default discovery mechanism
                //See: https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/configuration/default-settings?view=aspnetcore-6.0
            }
        }
#pragma warning restore CA1416 // Validate platform compatibility

        /// <summary>
        /// If a redis connection string is configured this will create the multiplexer, add it to the service collection
        /// and return a reference to it.
        /// </summary>
        /// <param name="services"></param>
        /// <param name="dataManagement"></param>
        /// <returns>null if redis not configured, or a reference to the redis connection multiplexer</returns>
        public static IConnectionMultiplexer ConfigureRedis(IServiceCollection services, DataManagementOptions dataManagement)
        {
            if (dataManagement.IsRedisConnectionStringSpecified)
            {
                IConnectionMultiplexer redisConnection = ConnectionMultiplexer.Connect(dataManagement.RedisConnectionString);
                services.AddSingleton<IConnectionMultiplexer>(redisConnection);
                return redisConnection;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Heuristic to evaluate if the value (e.g. for StoreSessionIn) looks like a certficate thumbprint
        /// </summary>
        private static bool IsCertificateThumbprint(string s)
        {
            return !string.IsNullOrWhiteSpace(s) && Regex.IsMatch(s, @"^[A-Fa-f0-9 ]*$");
        }

        /// <summary>
        /// Configures a standardised date pattern for the logging
        /// </summary>
        private static CultureInfo DefaultLoggingCultureInfo()
        {
            CultureInfo logCulture = (CultureInfo)CultureInfo.InvariantCulture.Clone();
            logCulture.DateTimeFormat.ShortDatePattern = "yyyy-MM-dd";
            logCulture.DateTimeFormat.LongTimePattern = "HH:mm:ss.fff zzz";
            return logCulture;
        }
    }
}
