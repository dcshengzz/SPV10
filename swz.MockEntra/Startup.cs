using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using swz.KeyUtils;

namespace swz.MockEntra
{
    public class Startup
    {
        private readonly MockEntraSettings settings;
        private readonly IConfiguration configuration;

        public Startup(IConfiguration configuration)
        {
            this.configuration = configuration;
            this.settings = configuration.Get<MockEntraSettings>(c => c.BindNonPublicProperties = true);
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddSingleton(settings);

            Saml2Settings saml2 = settings.Saml2;
            services.AddSingleton(saml2);
            IPublicKeySupplier spVerificationKeySupplier 
                = settings.Saml2.IsServiceProviderVerificationPublicKeyPathSpecified
                ? RsaKeyDataKeySupplier.FromSource(saml2.ServiceProviderVerificationPublicKeyPath)
                : NoKeySupplier.Instance;
            IPublicKeySupplier spEncryptionKeySupplier
                = settings.Saml2.IsServiceProviderEncryptionPublicKeyPathSpecified
                ? RsaKeyDataKeySupplier.FromSource(saml2.ServiceProviderEncryptionPublicKeyPath)
                : NoKeySupplier.Instance;
            IPrivateKeySupplier idpSigningKeySupplier
                = settings.Saml2.IsIdentityProviderSigningPrivateKetPathSpecified
                ? RsaKeyDataKeySupplier.FromSource(settings.Saml2.IdentityProviderSigningPrivateKeyPath)
                : NoKeySupplier.Instance;
            services.AddSingleton(new MockEntraSamlKeySuppliers(
                spVerificationKeySupplier, 
                spEncryptionKeySupplier, 
                idpSigningKeySupplier));
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
