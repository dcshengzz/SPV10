using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using swz.Clover.SPCP.OIDC;
using System;

namespace swz.Clover.SPCP.oidc
{
    /// <summary>
    /// Configures services for integration with the OIDC gateway (i.e. used at IMDA)
    /// </summary>
    public class OidcConfigurator
    {
        public OidcConfigurator()
        {
            ;
        }

        public void ConfigureOidcServices(
            SPCPOptions spcpOptions,
            IConfigurationRoot configuration,
            IServiceCollection services)
        {
            //Warning , the logging environment will not be ready when this method is called. Do not log here.

            IConfigurationSection corppassOidcSection
                = configuration.GetSection(CorppassOidcSettings.AppSettings_Key); //ie Corppass:Oidc
            if (corppassOidcSection.Exists() == false)
            {
                throw new InvalidOperationException(
                    $"An OIDC Agency ({spcpOptions.Agency}) was specified for SPCP, but configuration is missing the {CorppassOidcSettings.AppSettings_Key} section");
            }

            CorppassOidcSettings corppassOidcSettings
                = corppassOidcSection.Get<CorppassOidcSettings>(c => c.BindNonPublicProperties = true);
            OidcSettings oidcSettings = corppassOidcSettings.GetOidcSettings(spcpOptions.Environment);
            if (oidcSettings.IsInvalid())
            {
                throw new InvalidOperationException(
                    $"An OIDC Agency ({spcpOptions.Agency}) was specified for SPCP, but configuration section {CorppassOidcSettings.AppSettings_Key} is invalid");
            }

            IOidcProcessor oidcProcessor = CreateOidcProcessor(spcpOptions, oidcSettings);
            services.AddSingleton<IOidcProcessor>(oidcProcessor);
            services.AddSingleton<ISPCPHandler, OidcCorppassHandler>();
            services.AddSingleton<CorppassOidcSettings>(corppassOidcSettings); //RespController needs it (for now)
        }

        private IOidcProcessor CreateOidcProcessor(SPCPOptions spcpOptions, OidcSettings oidcSettings)
        {
            if (spcpOptions == null) throw new ArgumentNullException(nameof(spcpOptions));
            switch (spcpOptions.Agency)
            {
                case "IMDA": return new SimsCorpPassOidcProcessor(oidcSettings, spcpOptions.Debug);
                case "EMA": return new OssCorpPassOidcProcessor(oidcSettings, spcpOptions.Debug);
                default: throw new NotImplementedException($"Agency \"{spcpOptions.Agency}\" has no IOidcProcessor implementation");
            }
        }
    }
}
