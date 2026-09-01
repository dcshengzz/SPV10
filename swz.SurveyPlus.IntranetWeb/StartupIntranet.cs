using System;
using System.Security.Claims;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication.Cookies;
using Hangfire;
using Hangfire.Dashboard;
using Microsoft.AspNetCore.Authorization;
using swz.SurveyPlus.IntranetWeb.Hangfire;
using Microsoft.Extensions.Hosting;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Security;
using swz.Clover.Core.Configuration;
using System.Net.Http;
using Microsoft.Data.SqlClient;
using swz.SurveyPlus.IntranetApplication.Import;
using Microsoft.AspNetCore.Http.Features;
using swz.SurveyPlus.IntranetWeb.Controllers;
using swz.SurveyPlus.IdentityAccessManagement;
using swz.Clover.AuthServices.Jwt.Services;
using StackExchange.Redis;
using swz.SurveyPlus.IntranetApplication.Utilities;
using swz.Clover.Core.ORM;
using swz.Clover.Core;
using Newtonsoft.Json;
using swz.Clover.Core.View;
using System.Net.Mime;
using System.IdentityModel.Tokens.Jwt;
using swz.SurveyPlus.Saml2;

namespace swz.SurveyPlus.IntranetWeb
{
    public class StartupIntranet
    {
        private const string applicationName = "SPIntranet";

        private static IConnectionStringProvider CreateConnectionStringProvider(IntranetAppSetting intranetAppSetting)
        {
            IConnectionStringProvider connectionStringProvider;
            if (intranetAppSetting.AWSSecretsManager.IsEnabled)
            {
                if (intranetAppSetting.AWSSecretsManager.IsUseLazyProvider)
                {
                    //nb: the lazy amazon provider wont hit the secrets manager until first demand and caches its results
                    connectionStringProvider = new LazyAWSSecretsManagerConnectionStringProvider(intranetAppSetting.AWSSecretsManager, intranetAppSetting.ConnectionStrings);
                }
                else
                {
                    //the busy one hits it everytime (use if encounter problems with lazy one)
                    connectionStringProvider = new BusyAWSSecretsManagerConnectionStringProvider(intranetAppSetting.AWSSecretsManager, intranetAppSetting.ConnectionStrings);
                }
            }
            else
            {
                connectionStringProvider = new DefaultConnectionStringProvider(intranetAppSetting.ConnectionStrings);
            }
            return connectionStringProvider;
        }

        private readonly IConfigurationRoot configuration;
        private readonly IntranetAppSetting intranetAppSetting;
        private readonly IConnectionStringProvider connectionStringProvider;
        private readonly IHostEnvironment env;
        private readonly Saml2Configurator saml2Configurator;

        public StartupIntranet(IHostEnvironment env)
        {
            this.env = env ?? throw new ArgumentNullException(nameof(env));
            try
            {
                IConfigurationBuilder builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile(
                    path: "appsettings.json",
                    optional: false,
                    reloadOnChange: false)
                .AddJsonFile(
                    path: $"appsettings.{env.EnvironmentName}.json",
                    optional: true)
                .AddEnvironmentVariables();
                configuration = builder.Build();
                intranetAppSetting = configuration.Get<IntranetAppSetting>(c => c.BindNonPublicProperties = true);
                DbHelper.Global_IsSqlBulkCopy_CheckConstraints = intranetAppSetting.SurveyPlus.IsSqlBulkCopyCheckConstraints; //kludge to configure this staticly
                ObservableEntityContainer.Global_Is_Fix_Issue_287 = !intranetAppSetting.Clover.IsDisableFixForIssue287; //kludge to configure this staticly
                ApplicationStartupException.HandleBy = intranetAppSetting.StartupExceptionHandling;
                connectionStringProvider = CreateConnectionStringProvider(intranetAppSetting); //need this in a few places during startup
                saml2Configurator = new Saml2Configurator(intranetAppSetting.Clover.IsSaml2Authentication);
            }
            catch(Exception e)
            {
                throw new ApplicationStartupException("Error loading configuration", e);
            }
        }
       
        // This method gets called by the runtime. Use this method to add services to the container.
        // This is called before Configure is called.
        // Warning: normal logging is not available at this point as it will be initialised later in Configure
        public void ConfigureServices(IServiceCollection services)
        {
            try
            {
                // Add framework services.
                services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
                services.AddControllersWithViews().AddRazorRuntimeCompilation();

                string loginPath = intranetAppSetting.Clover.IsWindowsAuthentication
                    ? "/Account/WindowsLogin/"
                    : "/Account/Login/";
                bool is403OnDenied = intranetAppSetting.Clover.IsWindowsAuthentication;
                //TODO - review why we don't do the 403 behaviour for password login as well

                saml2Configurator.ConfigureServices(configuration, services);
                
                services
                    .AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
                    .AddCookie(options => { // .AspNetCore.Cookies
                        options.Cookie.SameSite = intranetAppSetting.SecurityHeaders.AspSameSite;
                        options.Cookie.SecurePolicy = intranetAppSetting.SecurityHeaders.SecurePolicy;
                        TimeSpan expire = TimeSpan.FromMinutes(intranetAppSetting.SurveyPlus.AuthTimeoutMinutes);
                        options.ExpireTimeSpan = expire;
                        options.Cookie.MaxAge = expire;
                        options.SlidingExpiration = true;
                        options.LoginPath = loginPath;

                        if (is403OnDenied)
                        {   //Allow 403s to be returned directly.
                            //see: https://stackoverflow.com/questions/54461127/how-to-return-403-instead-of-redirect-to-access-denied-when-authorizefilter-fail
                            options.Events.OnRedirectToAccessDenied = rContext => {
                                rContext.Response.StatusCode = 403;
                                return rContext.Response.CompleteAsync();
                            };
                        }

                        //If login has expired return a status 403 for api calls rather than a redirect
                        options.Events.OnRedirectToLogin = async rContext =>
                        {
                            if (ControllerUtilities.RequestIsNotHumanFacing(rContext.HttpContext))
                            {
                                rContext.Response.StatusCode = StatusCodes.Status403Forbidden;
                                rContext.Response.ContentType = MediaTypeNames.Application.Json;
                                string json = JsonConvert.SerializeObject(
                                    new FailResponse(Constants.Message.SessionInvalid));
                                await rContext.Response.WriteAsync(json);
                                //Don't need Response.CompleteAsync() because we already wrote to response
                            }
                            else
                            {
                                rContext.Response.Redirect(rContext.RedirectUri);
                            }
                        };

                        //Enforce MaxAuthMinutes maximum login period
                        TimeSpan maxLoginDuration = TimeSpan.FromMinutes(intranetAppSetting.SurveyPlus.MaxAuthMinutes);
                        options.Events.OnValidatePrincipal = async cvpContext =>
                        {
                            //This event is called after the cookie has been decrypted, auth token expiration
                            //checked, and the principal created, so we are logged in at this point.
                            string authTimeClaim = cvpContext.Principal.FindFirstValue(JwtRegisteredClaimNames.AuthTime);
                            bool terminateLoginNow;
                            if (long.TryParse(authTimeClaim, out long seconds))
                            {   //auth-time claim in token records when they first logged in
                                TimeSpan loginDuration = DateTimeOffset.UtcNow - DateTimeOffset.FromUnixTimeSeconds(seconds);
                                terminateLoginNow = (loginDuration > maxLoginDuration);
                            }
                            else
                            {   //Old cookie version without the claim must be replaced
                                terminateLoginNow = true;
                            }

                            if(terminateLoginNow)
                            {
                                cvpContext.RejectPrincipal();
                                await CloverRuntime.Security.SignOutAsync();                                
                            }
                        };
                    });

                //AccountController.WindowsLogin uses a challenger to return the client a 401 response (for AD Login)
                services.AddSingleton<IWindowsAuthenticationChallenger>(
                    intranetAppSetting.Clover.IsWindowsAuthentication
                    ? WindowsAuthenticationChallengerHelper.CreateChallenger(intranetAppSetting.Clover.WindowsAuthenticationChallenge)
                    : new NotImplementedChallenger() );

                //The JwtService is used for managing tokens for the respondents and the 3PA
                //(It was previously named JwtController and obtained via a service locator, now we use DI)
                services.AddSingleton<IJwtService>(provider =>
                {   //Need to use a factory to defer construction because I can't get a logger in ConfigureServices
                    //and I want to instantiate its key supplier myself to avoid putting it into services.
                    ILogger<JwtService> logger = provider.GetRequiredService<ILogger<JwtService>>();
                    string respondentKeyBase64 = EncryptionHelper.DecryptStr(
                        intranetAppSetting.UnifiedAtApp.EncryptedTokenKey, Constants.LoginKey, Constants.LoginIv);
                    string userKeyBase64 = EncryptionHelper.DecryptStr(
                        intranetAppSetting.ThirdPartyApi.EncryptedTokenKey, Constants.LoginKey, Constants.LoginIv);
                    ISigningKeySupplier keys = new ByteArraySymmetricSigningKeySupplier(
                        userKey: Convert.FromBase64String(userKeyBase64),
                        respondentKey: Convert.FromBase64String(respondentKeyBase64));
                    return new JwtService(logger, keys);
                });
    
                services.Configure<FormOptions>(options =>
                {
                    //A limit for the length of each multipart body.
                    //Forms sections that exceed this limit will throw an InvalidDataException when parsed.
                    //Note that there is also a limit on the request size applied via web.config
                    //See: https://learn.microsoft.com/en-us/aspnet/core/mvc/models/file-uploads?view=aspnetcore-8.0  
                    options.MultipartBodyLengthLimit = 268435456; //256 MiB

                    //A limit on the length of individual form values.
                    //Forms containing values that exceed this limit will throw an InvalidDataException when parsed.
                    //ASP defaults this to 4,194,304 bytes, which is 4 MiB, but we found some requests
                    //(e.g. the survey designer saving the MP form) can reach this so lets set our default to 8 MiB.
                    options.ValueLengthLimit = 8388608;
                });
                //Allow for overriding FormOptions values by adding a FormOptions section in appsettings.json
                services.Configure<FormOptions>(configuration.GetSection("AspFormOptions"));

                string connectionString = connectionStringProvider.GetConnectionString();
                if (string.IsNullOrWhiteSpace(connectionString))
                {
                    throw new ApplicationStartupException(nameof(connectionStringProvider) + " did not return a connection string - have you configured the database connection?");
                }

                DataManagementOptions dataManagement = intranetAppSetting.DataManagement;

                IConnectionMultiplexer redisConnection 
                    = SharedStartupConfigurator.ConfigureRedis(services, dataManagement); //null when Redis not configured

                if(dataManagement.StoreSessionIn == DataManagementOptions.SessionLocation.Database)
                {
                    //(n.b. Database option is only supported in the intranet application)
                    //Stores the session data in the database. Currently (20240106) we have very little such
                    //data anyway so this option should be practical in most environments and storing the session
                    //in same db as the app data won't hurt. If we end up using a lot of session data (inadvisable!)
                    //then that would need to be reviewed.
                    //See: https://learn.microsoft.com/en-us/aspnet/core/performance/caching/distributed?view=aspnetcore-6.0#distributed-sql-server-cache
                    //(Note that multiserver environments will also require DataProtection configurations
                    // to make sure each machine in the server farm has the same encryption keys)
                    services.AddDistributedSqlServerCache(options =>
                    {
                        options.ConnectionString = connectionString;
                        options.SchemaName = "dbo";
                        options.TableName = "DotNetCoreSession";
                    });
                }
                else
                {
                    SharedStartupConfigurator.ConfigureSessionLocation(
                        applicationName,
                        services,
                        dataManagement,
                        redisConnection);
                }

                SharedStartupConfigurator.ConfigureDataProtection(
                    applicationName,
                    services,
                    dataManagement,
                    redisConnection);

                //Session cookie options. Note that this is different from the .NET
                //authorisation cookie. Intranet app doesn't use session storage much.
                //Currently just for some error messages and with 2FA handling at login.
                //n.b. session options should be configured after configuring where session is stored
                services.AddSession(options =>
                {
                    options.Cookie.HttpOnly = true;
                    options.Cookie.SameSite = intranetAppSetting.SecurityHeaders.AspSameSite;
                    options.Cookie.Name = $".AspNetCore.Session.{applicationName}";
                });

                services.Configure<AuthorizationOptions>(options => {
                    options.AddPolicy("MustBeAdmin", policy => {
                        policy.RequireAuthenticatedUser();
                        policy.RequireClaim(ClaimTypes.Role, "Admins");
                    });
                });

                services.AddMvc(options =>
                {
                    options.EnableEndpointRouting = false;
                    options.Filters.Add(new AuthorizationFilterFactory());
                }).AddNewtonsoftJson();

                services.AddRouting();
                services.AddControllersWithViews();
                services.AddRazorPages();

                //Hangfire is used for scheduled job management
                services.AddHangfire(hangfire =>
                {
                    hangfire.UseSqlServerStorage(connectionString);
                    hangfire.SetDataCompatibilityLevel(CompatibilityLevel.Version_180); 
                });
                services.AddHangfireServer(options => {
                    //The 1.7 upgrade guide recommends setting a non-zero StopTimeout
                    //https://docs.hangfire.io/en/latest/upgrade-guides/upgrading-to-hangfire-1.7.html
                    options.StopTimeout = TimeSpan.FromSeconds(30);
                });

                services.AddCors(o => o.AddPolicy("MyPolicy", builder =>
                {
                    builder.AllowAnyOrigin()
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                }));
                services.Configure<ForwardedHeadersOptions>(option => { option.ForwardedHeaders = Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders.XForward‌​edFor; });

                services.AddHttpClient();

                services.AddSingleton<IntranetAppSetting>(intranetAppSetting);
                services.AddSingleton<CloverOptions>(intranetAppSetting.Clover);
                services.AddSingleton<SurveyPlusOptions>(intranetAppSetting.SurveyPlus);
                services.AddSingleton<HelloControllerOptions>(intranetAppSetting.HelloController);
                services.AddSingleton<ConnectionStringsOptions>(intranetAppSetting.ConnectionStrings);
                services.AddSingleton<PrintSettings>(intranetAppSetting.PrintSettings);
                services.AddSingleton<AWSSecretsManagerSettings>(intranetAppSetting.AWSSecretsManager);
                services.AddSingleton<IConnectionStringProvider>(connectionStringProvider);
                services.AddSingleton<IamSettings>(intranetAppSetting.IamSettings);
                services.AddSingleton<AuditLogManager>(intranetAppSetting.AuditLogManager);

                if (String.IsNullOrWhiteSpace(intranetAppSetting.SurveyPlus.ArchivedAuditLogsFolderPath))
                    throw new InvalidOperationException("ArchivedAuditLogsFolderPath is not configured in SurveyPlus section of appsettings.");

                if (String.IsNullOrWhiteSpace(intranetAppSetting.SurveyPlus.RespFilesDownloadFolderPath))
                    throw new InvalidOperationException("SurveyPlus:RespFilesDownloadFolderPath is not configured in SurveyPlus section of appsettings.");

                if (String.IsNullOrWhiteSpace(intranetAppSetting.SurveyPlus.ExportedDeploymentResponseFolderPath))
                    throw new InvalidOperationException("SurveyPlus:ExportedDeploymentResponseFolderPath is not configured in SurveyPlus section of appsettings.");

                if (String.IsNullOrWhiteSpace(intranetAppSetting.SurveyPlus.RespFiles3PAFolderPath))
                    throw new InvalidOperationException("SurveyPlus:RespFiles3PAFolderPath is not configured in SurveyPlus section of appsettings.");

                if (intranetAppSetting.UnifiedAtDatabase.IsEnabled)
                {
                    throw new NotImplementedException("U@Db is not implemented in this version");
                }
                if (!intranetAppSetting.UnifiedAtApp.IsEnabled)
                {
                    throw new NotImplementedException("Disabling U@App is not currently supported");
                    //Later if we implement U@Db we want to be able to (optionally) disable exposing the U@App APIs
                }

                services.AddSingleton<IScheduledExportService, ScheduledExportService>();
                services.AddSingleton<IResponseExportService, ResponseExportService>();
                services.AddSingleton<IResponseImportService, ResponseImportService>();
                services.AddSingleton<ISampleOwnerImportService, SampleOwnerImportService>();
                services.AddSingleton<IPrePopulationService, PrePopulationService>();
                services.AddSingleton<IBackendPrintService, BackendPrintService>();
                services.AddSingleton<ISampleListImportService, SampleListImportService>();
                services.AddSingleton<IDeploymentInitialisationService, DeploymentInitialisationService>();
                services.AddSingleton<IProfileMailMergeService, ProfileMailMergeService >();

                services.AddScoped<IamAuthorization>();

                if(env.IsDevelopment())
                {
                    services.AddSingleton<IDevToolsService, DevtoolsService>();
                }

                IntranetConfigurator.ConfigureServices(intranetAppSetting, services);
            }
            catch (ApplicationStartupException)
            {
                throw;
            }
            catch(Exception e)
            {
                throw new StartupServicesConfigurationException(e);
            }
        }

        // This method gets called by the runtime (on first http request, not at actual startup).
        // Use this method to configure the HTTP request pipeline etc
        //ConfigureServices will have already been called when this is called and you can use 
        //app.ApplicationServices.GetService to locate a service from the container if you need to use it.
        public void Configure(IApplicationBuilder app, IHostEnvironment env, ILoggerFactory loggerFactory)
        {
            try
            {
                Microsoft.Extensions.Logging.ILogger<StartupIntranet> logger
                    = (ILogger<StartupIntranet>)SharedStartupConfigurator.ConfigureLogging<StartupIntranet>(
                        intranetAppSetting.SurveyPlus,
                        loggerFactory,
                        env.EnvironmentName,
                        env.IsProduction());

                SharedStartupConfigurator.LogNetVersion(logger);

                if (intranetAppSetting.UnifiedAtApp.IsEnabled)
                {
                    //This can only be done once the logging system is up because it uses EncryptionHelper
                    SharedStartupConfigurator.ConfigureIntegrationApiKey(intranetAppSetting);
                }

                //Check we can connect database before setting up anything else
                CheckDatabaseConnection(logger);

                //Development environment cross-origin scripting enable (for use when running the clientside react apps standalone)
                if (env.IsDevelopment())
                {
                    // Make sure you call this before calling app.UseMvc()
                    app.UseCors(
                        options => options.WithOrigins("http://localhost:8091").AllowAnyMethod()
                    );
                }

                //Exception configuration
                if (env.IsDevelopment())
                {
                    app.UseDeveloperExceptionPage();
                }
                else
                {
                    //Detailed error information is not sent back to the clientside in production
                    //environment due to security concerns (it might reveal too much about the system)
                }

                //Have all error pages generated by the ErrorController
                app.UseStatusCodePagesWithReExecute("/error/{0}");

                app.UseAuthentication();

                SharedStartupConfigurator.ConfigureStaticFilesAndWebAssets(intranetAppSetting, app);

                //Session cookie configuration moved to AddSession as per modern .NET practice
                app.UseSession();

                SharedStartupConfigurator.ConfigureSecurityHeaders(intranetAppSetting, app);

                app.UseMvc(routes =>
                {
                    routes.MapRoute("public", "form/thankyou/{*other}",
                        defaults: new { controller = "Public", action = "Index" });

                    routes.MapRoute("account", "account/{action}",
                        defaults: new { controller = "Account", action = "Index" });

                    IntranetIndexPageController.MapRoutes(routes); //includes form, flow, and the default route
                });

                //CLOVER Init
                IntranetConfigurator.Configure(
                    app.ApplicationServices,
                    connectionStringProvider: connectionStringProvider,
                    intranetAppSetting: intranetAppSetting,
                    httpContextAccessor: (IHttpContextAccessor)app.ApplicationServices.GetService(typeof(IHttpContextAccessor)),
                    notificationHubContext: null,
                    httpClientFactory: (IHttpClientFactory)app.ApplicationServices.GetService(typeof(IHttpClientFactory)),
                    configuration: configuration);

                //Hangfire is used for scheduled job management
                //In development can see the hangfire dashboard (if an Admins) at: http://localhost:48800/hangfire/jobs/scheduled
                app.UseHangfireDashboard("/hangfire", new DashboardOptions
                {
                    Authorization = new IDashboardAuthorizationFilter[] {
                    new HangfireAuthorizationFilter("MustBeAdmin")
                }
                });

                //Note: in a multiserver environment we will see each server update the hangfire tables for recurring jobs when
                //      they start up. While redundant, this should be safe SO LONG AS ALL HAVE SAME appsettings.json VALUES FOR THE JOBS!

                //ProcessDormantUsers
                //Ensure the DormantUsersProcessor schedule is up to date in hangfire as per appsettings
                //Uses UTC cron syntax. eg "0 18 0 0" for 2am daily in Singapore (UTC+8)
                if(intranetAppSetting.SurveyPlus.IsProcessDormantUsersEnabled)
                {
                    //Currently we are just using a single global job for all the organisations in the instance.
                    //Recommended to use a daily frequency.
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_ProcessDormantUsers,
                        () => BusinessProcess.ProcessDormantUsers(), 
                        intranetAppSetting.SurveyPlus.ProcessDormantUsersSchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_ProcessDormantUsers);
                }

                //MonthlyAuditAccessLogExport
                //Clearing the previous job Id after renamed from monthly access report to monthly audit access log export.
                RecurringJob.RemoveIfExists(BusinessProcess.ObsoleteJobId_GenerateMonthlyAccessReport);                
                if(intranetAppSetting.SurveyPlus.IsMonthlyAuditAccessLogExportEnabled)
                {
                    //Uses UTC cron syntax. eg "0 16 L * *" 1st day of month at 00:00 in Singapore (UTC+8)
                    //Currently we are just using a single global job for all the organisations in the instance.
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_MonthlyAuditAccessLogExport,
                        () => BusinessProcess.MonthlyAuditAccessLogExport(), 
                        intranetAppSetting.SurveyPlus.MonthlyAuditAccessLogExportSchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_MonthlyAuditAccessLogExport);
                }

                //CleanupMailMerge (obsolete)
                //The CleanupMailMerge job is no longer used. For existing instances cleanup the hangfire job for it.
                RecurringJob.RemoveIfExists(BusinessProcess.ObsoleteJobId_CleanupMailMerge);

                //CleanupExpiredFileTickets
                if(intranetAppSetting.SurveyPlus.IsCleanupExpiredFileTicketsEnabled)
                {
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_CleanupExpiredFileTickets,
                        () => BusinessProcess.CleanupExpiredFileTickets(),
                        intranetAppSetting.SurveyPlus.CleanupExpiredFileTicketsSchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_CleanupExpiredFileTickets);
                }

                //TakeReportSnapshot (f.k.a ProcessDplyReport)
                //Recurring job for the SIMS report snapshots. (Previously this was setup by BusinessProcess.Schedule.GetSchedulerAsync)
                RecurringJob.RemoveIfExists(BusinessProcess.ObsoleteJobId_ProcessDplyReport); //ensure old name no longer used
                if(intranetAppSetting.SurveyPlus.IsTakeReportSnapshotEnabled)
                {
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_TakeReportSnapshot, 
                        () => BusinessProcess.TakeReportSnapshot(), 
                        intranetAppSetting.SurveyPlus.TakeReportSnapshotSchedule); //i.e. "30 15 * * *"
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_TakeReportSnapshot);
                }

                //ValidateLicenseExpirySchedule
                //Ensure the ValidateLicenseExpiry schedule is up to date in hangfire as per appsettings
                //Uses UTC cron syntax. eg "0 16 0 0" for 12am daily in Singapore (UTC+8)
                if(intranetAppSetting.SurveyPlus.IsValidateLicenseExpiryEnabled)
                {
                    //Currently we are just using a single global job for all the organisations in the instance.
                    //Recommended to use a daily frequency.
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_ValidateLicenseExpiry,
                        () => BusinessProcess.ValidateLicenseExpiry(), 
                        intranetAppSetting.SurveyPlus.ValidateLicenseExpirySchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_ValidateLicenseExpiry);
                }

                //AuditLogExport
                string auditLogExportSchedule
                    = (string)this.configuration.GetValue(typeof(string), "AuditLogManager:Schedule");
                bool disableAuditManager = string.IsNullOrWhiteSpace(auditLogExportSchedule);
                if (disableAuditManager)
                {
                    //Clearing the setting in the appsettings indicates we want to disable the job
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_AuditLogExport);
                }
                else
                {
                    AuditExport auditExport = intranetAppSetting.AuditLogManager.AuditExport;
                    AblrExport ablrExport = intranetAppSetting.AuditLogManager.AblrExport;

                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_AuditLogExport,
                        () => BusinessProcess.AuditLogExport(auditExport.IsEnabled, auditExport.KeepInDbDays, auditExport.LocalTempPath, auditExport.CloudProvider, auditExport.CloudPath, auditExport.FileName, ablrExport.IsEnabled, ablrExport.Path, ablrExport.FileName, ablrExport.ProjectReference), auditLogExportSchedule);
                }

                //CleanupExpiredJsonWebTokens
                if (intranetAppSetting.SurveyPlus.IsCleanupExpiredJsonWebTokensEnabled)
                {
                    RecurringJob.AddOrUpdate(
                        BusinessProcess.JobId_CleanupExpiredJsonWebTokens,
                        () => BusinessProcess.CleanupExpiredJsonWebTokens(),
                        intranetAppSetting.SurveyPlus.CleanupExpiredJsonWebTokensSchedule);
                }
                else
                {
                    RecurringJob.RemoveIfExists(BusinessProcess.JobId_CleanupExpiredJsonWebTokens);
                }

                saml2Configurator.Configure(app, env, loggerFactory);
            }
            catch (ApplicationStartupException)
            {
                throw;
            }
            catch(Exception e)
            {
                throw new StartupConfigurationException(e);
            }
        } //end of Configure

        /// <summary>
        /// Verifies that the application can connect to the database. 
        /// There are several aspects of the startup process that
        /// need to use the database (e.g. hangfire) and the startup will fail if they cannot. 
        /// Therefore we explicitly check this condition before they try as this makes the cause
        /// of failure more explicit in the logs. 
        /// </summary>
        private void CheckDatabaseConnection(ILogger logger)
        {
            try
            {
                string connectionString = connectionStringProvider.GetConnectionString();
                if (String.IsNullOrWhiteSpace(connectionString))
                    throw new InvalidOperationException("Connection string was not provided");

                using (SqlConnection connection = new SqlConnection(connectionString)) 
                {
                    connection.Open();
                    logger.LogDebug(nameof(CheckDatabaseConnection) + " - ConnectionStringProvider={0}", connectionStringProvider);
                    logger.LogInformation("Database connection string verified. Database={0}, ServerVersion={1}",
                        connection.Database,
                        connection.ServerVersion);
                }; //using will close the connection
            }
            catch (Exception e)
            {
                throw new ApplicationStartupException($"Error connecting to database (please check connection string or database connectivity/status/permissions etc): {e.Message}", e);
            }
        }

    } //end of Startup
}
