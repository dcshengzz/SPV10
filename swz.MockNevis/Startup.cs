using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace swz.MockNevis
{
    public class Startup
    {
        private readonly Settings settings;

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            settings = configuration.Get<Settings>(c => c.BindNonPublicProperties = true);
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            //Add various settings options to the services for things that need them injected
            services.AddSingleton<Settings>(settings);

            //Create & register the services that will create and sign tokens

            //Corppass
            IMockNevisPrivateKeySupplier corppassPrivateSigningKey
                = MockNevisRsaKeyDataKeySupplier.FromPrivateKeyPem(settings.Corppass.Locations.SignaturePrivateKeyPath);
            IMockNevisPublicKeySupplier corppassPublicEncryptionKey 
                = settings.Corppass.Token.IsUsingEncryption
                ? MockNevisRsaKeyDataKeySupplier.FromPublicKeyPem(settings.Corppass.Locations.EncryptionPublicKeyPath)
                : null;
            services.AddSingleton<MockNevisService<Flow.Corppass>>(
                new MockNevisService<Flow.Corppass>(
                    settings.Corppass.Token, 
                    corppassPrivateSigningKey,
                    corppassPublicEncryptionKey));

            //Singpass
            IMockNevisPrivateKeySupplier singpassPrivateSigningKey
                = MockNevisRsaKeyDataKeySupplier.FromPrivateKeyPem(settings.Singpass.Locations.SignaturePrivateKeyPath);
            IMockNevisPublicKeySupplier singpassPublicEncryptionKey 
                = settings.Singpass.Token.IsUsingEncryption
                ? MockNevisRsaKeyDataKeySupplier.FromPublicKeyPem(settings.Singpass.Locations.EncryptionPublicKeyPath)
                : null;
            services.AddSingleton<MockNevisService<Flow.Singpass>>(
                new MockNevisService<Flow.Singpass>(
                    settings.Singpass.Token,
                    singpassPrivateSigningKey,
                    singpassPublicEncryptionKey));

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            app.UseStaticFiles();
        }
    }
}
