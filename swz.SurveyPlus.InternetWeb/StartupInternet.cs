using System;
using System.IO;
using IP2Country;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Caching.Memory;
using System.Linq;
using IP2Country.Registries;
using swz.AspNetCore.Identity.Anonymous;
using Microsoft.Extensions.Hosting;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;
using swz.Clover.Core.Configuration;
using swz.Clover.Security;
using swz.Clover.SPCP;
using Microsoft.AspNetCore.Http.Features;
using swz.SurveyPlus.InternetWeb.Controllers;
using StackExchange.Redis;

namespace swz.SurveyPlus.InternetWeb
{
    public class StartupInternet
    {
        private readonly IConfigurationRoot configuration;
        private readonly InternetAppSetting internetAppSetting;

        public class IPResolverSetupException : Exception
        {
            public IPResolverSetupException(string message, Exception innerException) : base(message, innerException) { }
        }

        public StartupInternet(IHostEnvironment env)
        {
            IConfigurationBuilder builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: false)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            configuration = builder.Build();
            internetAppSetting = configuration.Get<InternetAppSetting>(c => c.BindNonPublicProperties = true);

            IConfigurationSection cspSection = configuration.GetSection("ContentSecurityPolicy"); 
            ContentSecurityPolicySetting cspSetting = cspSection.Get<ContentSecurityPolicySetting>(c => c.BindNonPublicProperties = true);
            ;
            ApplicationStartupException.HandleBy = internetAppSetting.StartupExceptionHandling;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //Warning , the logging environment will not be ready when this method is called. Attempt no logging here.
            //see: https://stackoverflow.com/a/46298052/8243046
            //Consider workaround here if necessary: https://stackoverflow.com/a/61488490/8243046
            //But note that exceptions that bubble up to Run can be logged via stdout if enabled in web.config
            try
            {
                // Add framework services.
                services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
                services.AddControllersWithViews().AddRazorRuntimeCompilation();

                //Kludge to pass the setting to a static method that doesn't have DI handy
                //(We hope to refactor this to something more elegant in future)
                SurveyPlusInternet.Kludge_AspSameSite_Setting = internetAppSetting.SecurityHeaders.AspSameSite;


                //Allow for overriding FormOptions values by adding a FormOptions section in appsettings.json
                services.Configure<FormOptions>(configuration.GetSection("AspFormOptions"));

                DataManagementOptions dataManagement = internetAppSetting.DataManagement;

                IConnectionMultiplexer redisConnection
                    = SharedStartupConfigurator.ConfigureRedis(services, dataManagement);

                // *** WARNING ***
                // As at 2025-09-01 the Internet Application will STILL require sticky sessions to work properly
                // because the only implementaion of IInternetApiTokenManager is InternetApiTokenManager
                // which uses an in-memory IMemoryCache to share the tokens between threads. It does use the HttpSession
                // for 'longer-term' storage with the in-memory cache intended for other threads that don't see the
                // updated session yet - BUT this too will be an issue in a multi-server environment because
                // those threads are for other simultaneous requests which would probably be directed to other servers
                // in a load-balanced scenario. (Session updates aren't visible to other requests until the
                // completion of the request doing the updating). I suspect a working implementation for Redis
                // will need to bypass the http session altogether and talk directly to Redis and make use of whatever
                // locking it can do?

                SharedStartupConfigurator.ConfigureSessionLocation(
                    SurveyPlusInternet.ApplicationName,
                    services,
                    dataManagement,
                    redisConnection);

                SharedStartupConfigurator.ConfigureDataProtection(
                    SurveyPlusInternet.ApplicationName,
                    services, 
                    dataManagement,
                    redisConnection);

                services.AddMemoryCache();

                //Internet application has custom authorisation which depends on the session.
                //Also uses it for things like keeping track of whether delegation codes
                //have already been entered, and in a few other places too.
                services.AddSession(options =>
                {
                    //n.b. this is a session cookie with no maxage/expiration, typically a browser will
                    //     delete the cookie when browser is closed, though modern browsers might preserve
                    //     it longer, so we can't count on client side removal of the cookie.
                    //     .NET8 stores only the ASP.NET session id in here, and that ID doesn't change on
                    //     login/logout. (The scope of the .NET session is thus greater than the scope of a
                    //     SurveyPlus login session which is managed by our logic). 
                    options.Cookie.SameSite = internetAppSetting.SecurityHeaders.AspSameSite;
                    options.Cookie.SecurePolicy = internetAppSetting.SecurityHeaders.SecurePolicy;
                    options.Cookie.Name = SurveyPlusInternet.InternetSessionCookie;             
                    
                    options.Cookie.HttpOnly = true;

                    //server-side drops session content after inactivity, this should be a little
                    //longer than the client-side timeout UX, so ASP.NET's default 20 minutes is ok
                    options.IdleTimeout = TimeSpan.FromMinutes(20); 
                });

                services.AddMvc(options => {
                    options.EnableEndpointRouting = false;
                    //nb: although we do have the AuthorizationFilter here,
                    //    on internet side SurveyPlusInternet.IsLoggedIn() is
                    //    responsible for validating if a respondent user is
                    //    loged in. It is called from CheckSessionAttributeFilter
                    options.Filters.Add(new AuthorizationFilterFactory());
                }).AddNewtonsoftJson();

                //See: https://docs.microsoft.com/en-us/dotnet/architecture/microservices/implement-resilient-applications/use-httpclientfactory-to-implement-resilient-http-requests
                services.AddHttpClient();
                services.ConfigureHttpClientDefaults(builder =>
                {   //Defaults for all clients created by the factory
                    builder.ConfigureHttpClient(client =>
                    {
                        client.Timeout = TimeSpan.FromSeconds(
                            internetAppSetting.SurveyPlus.HttpClientTimeoutSeconds);
                    });
                });

                services.AddSingleton<InternetAppSetting>(internetAppSetting); //n.b InternetConfiguratorUApp will directly add some classes referenced by this as the InternetApiDataSource can't see InternetAppSettingClass
                services.AddSingleton<CloverOptions>(internetAppSetting.Clover);
                services.AddSingleton<RespondentPortalOptions>(internetAppSetting.RespondentPortal);
                services.AddSingleton<CommonPageSettingsOptions>(internetAppSetting.RespondentPortal.CommonPageSettings);
                services.AddSingleton<WogaaSettings>(internetAppSetting.Wogaa);
                services.AddSingleton<AntiVirusSettings>(internetAppSetting.AntiVirus);
                services.AddSingleton<PrintSettings>(internetAppSetting.PrintSettings);
                services.AddSingleton<LambdaIntegrationSettings>(internetAppSetting.LambdaIntegrationSettings);
                services.AddSingleton<SurveyPlusOptions>(internetAppSetting.SurveyPlus);
                services.AddSingleton<SecurityHeaderSetting>(internetAppSetting.SecurityHeaders);

                //Setup the objects for Singpass/Corppass support based on the configuration
                new SPCPConfigurator().ConfigureServices(internetAppSetting.SPCP, configuration, services);

                if (internetAppSetting.UnifiedAtApp.IsEnabled)
                {
                    if (internetAppSetting.UnifiedAtDatabase.IsEnabled)
                    {
                        throw new InvalidOperationException("Internet application cannot simultaneously support both U@App and U@Db");
                    }

                    //Configure DI for U@App services
                    InternetConfiguratorUApp.ConfigureServices(services, internetAppSetting);
                } 
                else
                {
                    throw new NotImplementedException("Disabling U@App is not currently supported");
                }

                if (internetAppSetting.UnifiedAtDatabase.IsEnabled)
                {
                    throw new NotImplementedException("U@Db is not implemented in this version");
                }
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

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline etc
        public void Configure(
            IApplicationBuilder app, 
            IHostEnvironment env, 
            ILoggerFactory loggerFactory, 
            IMemoryCache cache,
            IServiceProvider serviceProvider)
        {            
            try
            {
                ILogger<StartupInternet> logger
                    = (ILogger<StartupInternet>)SharedStartupConfigurator.ConfigureLogging<StartupInternet>(
                        internetAppSetting.SurveyPlus,
                        loggerFactory,
                        env.EnvironmentName,
                        env.IsProduction());
                SharedStartupConfigurator.LogNetVersion(logger);

                if (internetAppSetting.UnifiedAtApp.IsEnabled)
                {
                    //This can only be done once the logging system is available because it uses EncryptionHelper
                    SharedStartupConfigurator.ConfigureIntegrationApiKey(internetAppSetting);
                }

                if (env.IsDevelopment())
                {
                    app.UseDeveloperExceptionPage();
                    //app.UseBrowserLink() has been removed for Net6 (Microsoft.VisualStudio.Web.BrowserLink package is deprecated)
                    //see: https://github.com/dotnet/aspnetcore/issues/37747#issuecomment-949778286
                }
                else
                {
                    app.UseExceptionHandler("/error/500");
                }

                var ipRestriction = configuration["Restrictions:Ip"]?.Equals("True", StringComparison.InvariantCultureIgnoreCase) ?? false;

               

                //Fixed for SVP-06 for MPA SCR 2022-04-29
                try
                {
                    IP2CountryResolver resolver = ipRestriction
                        ? new IP2CountryResolver(
                            Directory.GetFiles($"{env.ContentRootPath}\\delegationcache", "*.dat")
                                .Select(f => new RegistryCSVFileSource(f))
                        )
                        : null;
                    cache.Set("IP2CountryResolverCache", resolver);
                }
                catch (IOException ioEx)
                {
                    throw new IPResolverSetupException("Failed to get files from registry file source", ioEx);
                }
                catch (Exception e)
                {
                    throw new IPResolverSetupException("Unexpected exception when setting IP2CountryResolverCache", e);
                }

                app.UseAuthentication();

                SharedStartupConfigurator.ConfigureStaticFilesAndWebAssets(internetAppSetting, app);

                //Session cookie configuration has moved to AddSession as per modern .NET practice
                app.UseSession();

                app.UseAnonymousId(new AnonymousIdCookieOptionsBuilder()
                        .SetCustomCookieName("AnonymousId")             // Custom cookie name
                        .SetCustomCookieRequireSsl(false)               // Requires SSL
                        .SetCustomCookieTimeout(60 * 24 * 365 * 2)      // Custom timeout in mins (2 years)
                        .SetCustomCookieHttpOnly(true)
                        .SetCustomCookieSameSite(SameSiteMode.Strict)
                        .SetCustomCookieSlidingExpiration(true)
                );

                app.Use(async (ctx, next) =>
                {
                    await next();

                    if (ctx.Response.StatusCode == 404 && !ctx.Response.HasStarted)
                    {
                        //Re-execute the request so the user gets the error page
                        string originalPath = ctx.Request.Path.Value;
                        ctx.Items["originalPath"] = originalPath;
                        ctx.Request.Path = "/error/404";
                        await next();
                    }
                });

                string wogaaUrl = internetAppSetting.Wogaa.GetUrlIfEnabled();
                SharedStartupConfigurator.ConfigureSecurityHeaders(internetAppSetting, app, wogaaUrl);

                app.UseMvc(routes =>
                {
                    routes.MapRoute("respdashboard", "form/respdashboard/{*other}",
                        defaults: new { controller = "RespDashboard", action = "Index" });
                    routes.MapRoute("respChangePassword", "form/RespAccountChangePassword/{*other}",
                        defaults: new { controller = "RespChangePassword", action = "Index" });
                    routes.MapRoute("form", "form/{formName}/{*other}",
                        defaults: new { controller = "StarterApplication", action = "Index" });
                    routes.MapRoute(
                        name: "default",
                        template: "{controller=RespDashboard}/{action=Index}/");
                });

                //CLOVER Init
                InternetConfiguratorUApp.Configure(
                    serviceProvider: serviceProvider,
                    environment: env,
                    httpContextAccessor: (IHttpContextAccessor)app.ApplicationServices.GetService(typeof(IHttpContextAccessor)),
                    configuration: configuration,
                    internetAppSetting: internetAppSetting
                );
            }
            catch(ApplicationStartupException)
            {
                throw;
            }
            catch(Exception e)
            {
                throw new StartupConfigurationException(e);
            }
        } //end of Configure



    } //end of Startup
}
