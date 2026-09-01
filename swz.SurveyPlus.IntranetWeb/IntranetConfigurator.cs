using System;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;
using Microsoft.CSharp.RuntimeBinder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.CodeActions;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using swz.Clover.MSSQL;
using swz.Clover.Security.Providers;
using swz.Workflow.Core.Runtime;
using swz.Clover.Core.License;
using swz.SurveyPlus.IntranetApplication;
using System.Net.Http;
using Microsoft.Extensions.DependencyInjection;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using Constants = swz.SurveyPlus.Application.Constants;
using System.Linq;
using swz.Clover.Core.Model;

namespace swz.SurveyPlus.IntranetWeb
{
    public static class IntranetConfigurator
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(IntranetConfigurator));

        public static void ConfigureServices(
            IntranetAppSetting intranetAppSetting,
            IServiceCollection services)
        {
            //Configure http client for DataSource (certain methods need one with AllowAutoRedirect & UseDefaultCredentials)
            //Here we set UseCookies to false because we don't want cookies set in one place to be used in other unrelated places
            //services
            services
                .AddHttpClient(nameof(DataSource))
                .ConfigurePrimaryHttpMessageHandler(
                    () => new HttpClientHandler() { UseCookies = false, })
                .ConfigurePrimaryHttpMessageHandler(
                    (builder) => new HttpClientHandler() { AllowAutoRedirect = true, UseDefaultCredentials = true, UseCookies = false });

            //20231227 - the above previously used 
            //      .ConfigureHttpMessageHandlerBuilder(
            //        (builder) => new HttpClientHandler() { AllowAutoRedirect = true, UseDefaultCredentials = true, UseCookies = false });
            //  which is now obsolete
            //  see: https://devblogs.microsoft.com/dotnet/dotnet-8-networking-improvements/ 

            services.AddSingleton<UnifiedAtAppSetting>(intranetAppSetting.UnifiedAtApp);
            services.AddSingleton<UnifiedAtDatabaseSetting>(intranetAppSetting.UnifiedAtDatabase);
            services.AddSingleton<SurveyResponseReader>();
            services.AddSingleton<MetadataCaches>();

            if(intranetAppSetting.Clover.UseMetadataCache && intranetAppSetting.SurveyPlus.MetadataCacheCheckMinutes > 0)
            {   //Add background service to check dwMetadata UpdatedDate to see if need to flush cache (for multiserver envs)
                services.AddHostedService<MetadataCachesFlusher>();
            }
        }

        public static void Configure(
            IServiceProvider applicationServices,
            IConnectionStringProvider connectionStringProvider,
            IntranetAppSetting intranetAppSetting,
            IHttpContextAccessor httpContextAccessor,
            IHubContext<ClientNotificationHub> notificationHubContext,
            IHttpClientFactory httpClientFactory,
            IConfigurationRoot configuration)
        {
            //The following remain here to support any instances of the legacy job in BusinessProcess, however new instances
            //of the mail merge job are handled by the service which has the surveyplus options injected. To remove the kludge
            //when we remove the legacy job (BusinessProcess.SendEmailsAndMailMergeAndGenerateProfile)
            BusinessProcess.KludgeToPassMailMergeFolderPath = intranetAppSetting.SurveyPlus.MailMergeFolderPath;
            BusinessProcess.KludgeToPassMailMergeArchivedFolderCommand = intranetAppSetting.SurveyPlus.MailMergeArchivedFolderCommand;
            BusinessProcess.KludgeToPassMailMergeArchivedFolderCommandArguments = intranetAppSetting.SurveyPlus.MailMergeArchivedFolderCommandArguments;
            BusinessProcess.KludgeToPassMailMergeArchivedFolderExtension = intranetAppSetting.SurveyPlus.MailMergeArchivedFolderExtension;

            //For SignalR
            CloverRuntime.HubContext = notificationHubContext;

            #region License
            CloverRuntime.LicenseControl = new DefaultLicenseControlProvider();
            if (configuration["LicenseControl:DomainNameRequired"] != "True")
            {
                CloverRuntime.LicenseControl.DomainNameRequired = false;
            }

            if (configuration["LicenseControl:PerServer"] != "True")
            {
                CloverRuntime.LicenseControl.PerServer = false;
            }

            //var licensefile = "license.key";
            //if (File.Exists(licensefile))
            //    try
            //    {
            //        var licenseText = File.ReadAllText(licensefile);
            //        CloverRuntime.RegisterLicense(licenseText);
            //    }
            //    catch(Exception e)
            //    {
            //        Logger.LogErrorException(e);
            //    }

            #endregion

            string connectionString = connectionStringProvider.GetConnectionString();
            CloverRuntime.ConnectionStringData = connectionString;

            //Create DBProvider
            int storedProcedureTimeoutSeconds;
            const string sptosSettingName = "Clover:StoredProcedureTimeoutSeconds";
            string sptosSettingValue = configuration[sptosSettingName]; //(configuration indexer returns null if missing)
            if (!string.IsNullOrEmpty(sptosSettingValue))
            {
                try {
                    storedProcedureTimeoutSeconds = int.Parse(sptosSettingValue);
                    if (storedProcedureTimeoutSeconds < 0) throw new ArgumentOutOfRangeException(sptosSettingName, "May not be negative");
                } catch (Exception e) {
                    throw new ApplicationStartupException($"Invalid value in appsettings for {sptosSettingName}", e);
                }
            } 
            else
            {
                storedProcedureTimeoutSeconds = 30; //normal default for SqlCommand is 30
            }
            CloverRuntime.DbProvider = new SQLServerProvider(storedProcedureTimeoutSeconds);

            CloverRuntime.UseMetadataCache = intranetAppSetting.Clover.UseMetadataCache; //previously true if RELEASE, false if DEBUG

            //Provision SecurityProvider
            ILogger securityProviderLogger = DefaultApplicationLogging.CreateLogger<SecurityProvider>();
            CloverRuntime.Security = new SecurityProvider(httpContextAccessor, securityProviderLogger);

            //Updated 2FA support sees us obfuscating the totp secret in db going forwards
            SecurityUser.InitTotpSecretEncryptionKey(Constants.LoginKey.Select(x => (byte)x).ToArray());

            //We cannot check the validity of the license at this point as we must wait for a request to determine the host name
            //however we can fail fast for SurveyPlus if the license.key is not present, which should cover most such cases
            if(!File.Exists(SecurityProvider.licensefile))
            {
                throw new ApplicationStartupException($"License key file {SecurityProvider.licensefile} is not installed. Use {HardwareInfo.Value()} to request for a license key");
            }

            //Configure the appropriate provider here. For internet it uses a different one to the intranet.
            bool blockMetadataChanges = (configuration["Clover:BlockMetadataChanges"] == "True");
            MetadataCaches metadataCaches = (MetadataCaches)applicationServices.GetService(typeof(MetadataCaches));
            if (metadataCaches == null) throw new ApplicationStartupException($"{nameof(MetadataCaches)} not found in services"); //see ConfigureServices
            CloverRuntime.SetMetadataCaches(metadataCaches);
            CloverRuntime.Metadata = new MSSQLMetadataProvider(
                (ILogger<MSSQLMetadataProvider>)DefaultApplicationLogging.CreateLogger<MSSQLMetadataProvider>(), 
                metadataCaches,
                blockMetadataChanges);
            MetadataToModelConverter.SetMetadataCaches(metadataCaches);

            CodeActionsCompiler.RegisterAssembly(typeof(WorkflowRuntime).Assembly);
            //It is necessary to have this assembly for compile code with dynamic
            CodeActionsCompiler.RegisterAssembly(typeof(Binder).Assembly);
            CodeActionsCompiler.TempDirectory = intranetAppSetting.Clover.CodeActionFolderPath;
            CodeActionsCompiler.DebugMode = intranetAppSetting.Clover.CodeActionDebugMode;
            CloverRuntime.CompileAllCodeActionsAsync().Wait();
            CloverRuntime.ServerActions.RegisterUsersProvider("filters", new Filters());
            CloverRuntime.ServerActions.RegisterUsersProvider("triggers", new Triggers());
            //ZL 2018-10-26 Added the following one line --Start
            CloverRuntime.ServerActions.RegisterUsersProvider("provider",
                new CustomActionsProvider(httpContextAccessor)); 
            //ZL 2018-10-26 Added the following one line --End

            //Initial inbox/outbox notifiers
            //CloverRuntime.AddClientNotifier(typeof(ClientNotificationHub), ClientNotifiers.NotifyClientsAboutInboxStatus);
            CloverRuntime.AddClientNotifier(typeof(ClientNotificationHub), ClientNotifiers.SpNotifyClients);
            //Remove process after the document was removed
            DynamicEntityOperationNotifier.SubscribeToDeleteByTableName("Document", "WorkflowDelete", (e, c) =>
            {
                Func<Task> task = async () => { await ClientNotifiers.DeleteWokflowAndNotifyClients(e, c); };
                task.FireAndForgetWithDefaultExceptionLogger();
            });
            //Forcing the creation of a WF runtime to initialize timers and the Flow.
            try
            {
                WorkflowInit.ForceInit();
            }
            catch (Exception e)
            {
                if (Debugger.IsAttached)
                {
                    var info = ExceptionUtils.GetExceptionInfo(e);
                    var errorBuilder = new StringBuilder();
                    errorBuilder.AppendLine("Workflow engine start failed.");
                    errorBuilder.AppendLine($"Message: {info.Message}");
                    errorBuilder.AppendLine($"Exceptions: {info.Exeptions}");
                    errorBuilder.Append($"StackTrace: {info.StackTrace}");
                    Debug.WriteLine(errorBuilder);
                }
            }

            Clover.Core.View.DataSource.InitialiseHttpClientFactory(httpClientFactory);
        }
    }
}