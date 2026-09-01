using Hangfire;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using swz.KeyUtils;
using swz.SurveyPlus.Application;
using System;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Performs SAML related configuration tasks at application startup
    /// </summary>
    public class Saml2Configurator
    {
        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly bool isSaml2AuthenticationEnabled;

        private Saml2Options saml2Options;

        public Saml2Configurator(bool isSaml2AuthenticationEnabled)
        {
            this.isSaml2AuthenticationEnabled = isSaml2AuthenticationEnabled;
        }

        public void ConfigureServices(
            IConfigurationRoot configuration,
            IServiceCollection services)
        {
            //Warning , the logging environment will not be ready when this method is called. Do not log here.
            //see: https://stackoverflow.com/a/46298052/8243046
            try
            {
                saml2Options = ConfigureSaml2Options(configuration);
                services.AddSingleton(saml2Options);
                services.AddSingleton(ConfigureSaml2Keys(saml2Options));
                services.AddSingleton<ISamlSchemaProvider>(new LocalSamlSchemaProvider());
            }
            catch(Exception e)
            {
                throw new ApplicationStartupException("Exception caught configuring Saml2 Services", e);
            }
        }

        public void Configure(
            IApplicationBuilder app, 
            IHostEnvironment env, 
            ILoggerFactory loggerFactory)
        {
            if (saml2Options.IsCleanupExpiredAssertionIDEnabled)
            {
                RecurringJob.AddOrUpdate(
                    Saml2Application.JobId_CleanupRecentSamlAssertion,
                    () => Saml2Application.CleanupRecentSamlAssertionJob(),
                    saml2Options.CleanupExpiredAssertionIDSchedule);
            }
            else
            {
                RecurringJob.RemoveIfExists(Saml2Application.JobId_CleanupRecentSamlAssertion);
            }
        }

        private Saml2Options ConfigureSaml2Options(IConfigurationRoot configuration)
        {
            if(isSaml2AuthenticationEnabled)
            {
                //Only read the configured json when the SAML2 is actually enabled
                IConfigurationSection saml2Section = configuration.GetSection("SAML2");
                if (saml2Section.Exists())
                    return saml2Section.Get<Saml2Options>(c => c.BindNonPublicProperties = true);
                else
                    throw new NotFoundException("Missing SAML2 section in appsettings.json");
            }
            else
            {
                //Otherwise we create a default placeholder instance
                //so we can setup the necessary DI objects
                return new Saml2Options(); 
            }
        }

        private Saml2Keys ConfigureSaml2Keys(Saml2Options saml2Options)
        {
            IPrivateKeySupplier spVerificationKeySupplier 
                = saml2Options.IsServiceProviderVerificationPrivateKeySpecified
                ? RsaKeyDataKeySupplier.FromSource(saml2Options.ServiceProviderVerificationPrivateKeyPath)
                : new NoKeySupplier();

            IPublicKeySupplier idpVerificationKeySupplier
                = saml2Options.IsIdentityProviderVerificationPublicKeyPathSpecified
                ? RsaKeyDataKeySupplier.FromSource(saml2Options.IdentityProviderVerificationPublicKeyPath)
                : new NoKeySupplier();

            IPrivateKeySupplier spEncryptionKeySupplier
                = saml2Options.IsServiceProviderEncryptionPrivateKeySpecified
                ? RsaKeyDataKeySupplier.FromSource(saml2Options.ServiceProviderEncryptionPrivateKeyPath)
                : new NoKeySupplier();

            return new Saml2Keys(spVerificationKeySupplier, idpVerificationKeySupplier, spEncryptionKeySupplier);
        }
    }
}
