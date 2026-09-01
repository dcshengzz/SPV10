using System;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.ApiSupport;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using Microsoft.Extensions.Hosting;
using swz.SurveyPlus.InternetApplication;
using Microsoft.Extensions.DependencyInjection;
using swz.Clover.Core.View;
using System.Net.Http;
using swz.SurveyPlus.Application;
using swz.Clover.Core.Metadata;

namespace swz.SurveyPlus.InternetWeb
{
    /// <summary>
    /// Wraps unexpected exceptions thrown in Configure
    /// </summary>
    public class ConfiguratorException : Exception
    {
        public ConfiguratorException(string message, Exception innerException) : base(message, innerException) { }
    }

    //TODO - make non-static, pass logger to constructor (for use in Configure, but not ConfigureServices)
    /// <summary>
    /// Configurator for the Unified @ App (API) scenario
    /// </summary>
    public static class InternetConfiguratorUApp
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(InternetConfiguratorUApp));

        /// <summary>
        /// Invoked by Startup to initialise the Clover framework for the internet web application using API scenario (U@APP)
        /// (will be called after ConfigureServices has already been called, any serive added there will be available here)
        /// </summary>
        public static void Configure(
            IServiceProvider serviceProvider,
            IHostEnvironment environment,
            IHttpContextAccessor httpContextAccessor,
            IConfigurationRoot configuration,
            InternetAppSetting internetAppSetting)
        {
            CloverRuntime.DbProvider = new MinimalDbProvider(); //nb: internet side has no db connection, but a DbProvider instance is still required for some tasks

            //Set placeholder content provider whose methods throw NotImplementedException (without this the runtime would try to instantiate ContentDBProvider)
            CloverRuntime.ContentProvider = new ContentProviderNotSupported(); 

            MetadataCaches metadataCaches = serviceProvider.GetService<MetadataCaches>();
            CloverRuntime.SetMetadataCaches(metadataCaches);
            MetadataToModelConverter.SetMetadataCaches(metadataCaches); //nb internet also has source cache (below)
            CloverRuntime.UseMetadataCache = internetAppSetting.Clover.UseMetadataCache; //Internet in dev can can use resp/resetappcache to flush cache

            if (environment.IsDevelopment())
            {
                //CodeActionsCompiler.DebugMode = true;
            }
            
            CloverRuntime.Security = new MinimalSecurityProvider(httpContextAccessor);
            
            try
            {
                string webApiBase = configuration["Clover:WebApiBase"];
                UAppUtils.InitApiBasePath(webApiBase);
            }
            catch(Exception e)
            {
                const string message = "Unable to initialise API Base Path. Check value of WebApiBase in Clover section of appsettings.";
                Logger.LogCritical(e, message);
                throw new ConfiguratorException(message, e);
            }

            ILogger<InternetApiMetadataProvider> metadataLogger = serviceProvider.GetService<ILogger<InternetApiMetadataProvider>>();
            IHttpClientFactory httpClientFactory = serviceProvider.GetService<IHttpClientFactory>();
            IMetadataSourceCache metadataCache = serviceProvider.GetService<IMetadataSourceCache>();
            CloverRuntime.Metadata = new InternetApiMetadataProvider(
                metadataLogger, 
                internetAppSetting.WebApiAdditionalHeader,
                httpClientFactory,
                metadataCache);

            CloverRuntime.ServerActions.RegisterUsersProvider("filters", new Filters());
            CloverRuntime.ServerActions.RegisterUsersProvider("triggers", new Triggers());
            CloverRuntime.ServerActions.RegisterUsersProvider("provider", new CustomActionProvider(httpContextAccessor));

            //n.b. SurveyPlus internet application does not use the CodeActionsCompiler
        }

        //This gets called before Configure
        public static void ConfigureServices(IServiceCollection services, InternetAppSetting internetAppSetting)
        {
            //Warning , the logging environment will not be ready when this method is called. Do not log here.
            //see: https://stackoverflow.com/a/46298052/8243046

            //InternetApiDataSource, and other classes in ApiSupport, can't see the InternetAppSetting class
            //so we need to directly add these ApiSupport config classes
            services.AddSingleton<WebApiAdditionalHeaderOptions>(internetAppSetting.WebApiAdditionalHeader);
            services.AddSingleton<UnifiedAtAppSetting>(internetAppSetting.UnifiedAtApp);

            services.AddSingleton<IInternetApiTokenManager, InternetApiTokenManager>();

            //RespondentServiceUApp and InternetApiDataSource no longer use the DefaultApi and don't maintain
            //other mutable state, so they can be registered as singletons with the DI container now (20230207)
            services.AddSingleton<IRespondentService, InternetApplication.UnifiedAtApp.RespondentServiceUApp>();
            services.AddSingleton<IDataSource, InternetApiDataSource>();

            ConfigureAntiVirus(services, internetAppSetting.AntiVirus);

            if (internetAppSetting.UnifiedAtApp.MetadataSourceCacheSeconds > 0)
                services.AddSingleton<IMetadataSourceCache, MemoryMetadataSourceCache>();
            else
                services.AddSingleton<IMetadataSourceCache, NullMetadataSourceCache>();
            //Currently we do need to init the MetadataCaches object even is UseMetadataCache is false 
            services.AddSingleton<MetadataCaches>();
        }

        private static void ConfigureAntiVirus(IServiceCollection services, AntiVirusSettings antiVirus)
        {
            if (antiVirus.ClamAV.IsEnabled && antiVirus.TrendAV.IsEnabled)
            {
                throw new InvalidOperationException("TrendAV and ClamAV cannot both be enabled simultaneously");
            }
            else if (antiVirus.TrendAV.IsEnabled)
            {
                services.AddSingleton<TrendAVOptions>(antiVirus.TrendAV);
                services.AddSingleton<IAntiVirusScanner, TrendAVClient>();
            }
            else if (antiVirus.TrendAV.IsEnabled)
            {
                services.AddSingleton<ClamAVOptions>(antiVirus.ClamAV);
                services.AddSingleton<IAntiVirusScanner, ClamAVClient>();
            }
            else
            {
                //placeholder do-nothing service
                services.AddSingleton<IAntiVirusScanner, NullAntiVirusScanner>();
            }
        }
    }
}