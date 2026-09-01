using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Logging;
using swz.KeyUtils;
using System;

namespace swz.Clover.SPCP.Nevis
{
    /// <summary>
    /// Configures services for SPCP integration with the Nevis gateway
    /// </summary>
    public class NevisConfigurator
    {
        public NevisConfigurator()
        {
            ;
        }

        public void ConfigureNevisServices(
            SPCPOptions spcpOptions,
            IConfigurationRoot configuration,
            IServiceCollection services)
        {
            //Warning , the logging environment will not be ready when this method is called. Do not log here.

            if (spcpOptions.Debug)
            {
                //Enable inclusion of PII (sensitive!) in exception messages (eg when validating token).
                //See: https://docs.microsoft.com/en-us/dotnet/api/microsoft.identitymodel.logging.identitymodeleventsource.showpii?view=azure-dotnet
                //
                //In a Release build ShowPII would be false by default, so that sensitive information doesn't end up in
                //logs and error messages. In Debig builds its true and so don't need SPCP::Debug to see it there.
                //When this is set you might see a message like:
                //  IDX10205: Issuer validation failed.
                //  Issuer: 'swz.MockNevis'. Did not match: validationParameters.ValidIssuer:
                //  'swz.MockNevisXXXX' or validationParameters.ValidIssuers: 'null'
                //When it is false (in Release build) it would redact the useful bits thusly:
                //    IDX10205: Issuer validation failed. Issuer: '[PII of type 'System.String' is hidden.
                //    For more details, see https://aka.ms/IdentityModel/PII.]'.
                //    Did not match: validationParameters.ValidIssuer: '[PII of type 'System.String' is hidden.
                //    For more details, see https://aka.ms/IdentityModel/PII.]'
                //    or validationParameters.ValidIssuers: '[PII of type 'System.String' is hidden.
                IdentityModelEventSource.ShowPII = true;
            }

            IConfigurationSection corppassNevisSection
                = configuration.GetSection(CorppassNevisSettingsWrapper.AppSettings_Key); //ie Corppass:Nevis
            if (corppassNevisSection.Exists() == false)
            {
                throw new InvalidOperationException(
                    $"A Nevis Agency ({spcpOptions.Agency}) was specified for SPCP, but configuration is missing the {CorppassNevisSettingsWrapper.AppSettings_Key} section");
            }
            CorppassNevisSettingsWrapper corppassNevisSettings
                = corppassNevisSection.Get<CorppassNevisSettingsWrapper>(c => c.BindNonPublicProperties = true);
            services.AddSingleton<CorppassNevisSettingsWrapper>(corppassNevisSettings);

            IConfigurationSection singpassNevisSection
                    = configuration.GetSection(SingpassNevisSettingsWrapper.AppSettings_Key);
            if (singpassNevisSection.Exists() == false)
            {
                throw new InvalidOperationException(
                    $"A Nevis Agency ({spcpOptions.Agency}) was specified for SPCP, but configuration is missing the {SingpassNevisSettingsWrapper.AppSettings_Key} section");
            }
            SingpassNevisSettingsWrapper singpassNevisSettings
                = singpassNevisSection.Get<SingpassNevisSettingsWrapper>(c => c.BindNonPublicProperties = true);

            services.AddSingleton<SingpassNevisSettingsWrapper>(singpassNevisSettings);

            //I'd prefer to have the below constructed *after* logging is ready so errors loading the keys can go in the log files too
            //can this be done using DI factories or something?

            services.AddSingleton<NevisJwtHandler.IssuerPublicKeySuppliers>(
                new NevisJwtHandler.IssuerPublicKeySuppliers(
                    corppass: CreateIssuerPublicKeySupplierForNevis(corppassNevisSettings.GetNevisSettings(spcpOptions.Environment)),
                    singpass: CreateIssuerPublicKeySupplierForNevis(singpassNevisSettings.GetNevisSettings(spcpOptions.Environment))
                )
            );

            services.AddSingleton<NevisJwtHandler.DecryptionPrivateKeySuppliers>(
                new NevisJwtHandler.DecryptionPrivateKeySuppliers(
                    corppass: CreateDecryptionPrivateKeySupplierForNevis(corppassNevisSettings.GetNevisSettings(spcpOptions.Environment)),
                    singpass: CreateDecryptionPrivateKeySupplierForNevis(singpassNevisSettings.GetNevisSettings(spcpOptions.Environment))
                )
            );

            //The handler needs to be constructed on demand because we can't construct it here
            //it needs a logger and logging is not ready yet
            services.AddSingleton<ISPCPHandler, NevisJwtHandler>();

        }

        private IPublicKeySupplier CreateIssuerPublicKeySupplierForNevis(NevisSettings nevisSettings)
        {
            string path = nevisSettings.IssuerPublicKeyPath;
            if (string.IsNullOrWhiteSpace(path))
                throw new InvalidOperationException($"{nameof(NevisSettings.IssuerPublicKeyPath)} is not configured");
            RsaKeyDataKeySupplier keySupplier = RsaKeyDataKeySupplier.FromSource(path);
            if (keySupplier.PublicCount == 0) throw new ArgumentException($"No public keys found from {path}");
            return keySupplier;
        }

        private IPrivateKeySupplier CreateDecryptionPrivateKeySupplierForNevis(NevisSettings nevisSettings)
        {
            string path = nevisSettings.DecryptionPrivateKeyPath;
            if (string.IsNullOrWhiteSpace(path))
            {
                return new NoKeySupplier();
            }
            else
            {
                RsaKeyDataKeySupplier keySupplier = RsaKeyDataKeySupplier.FromSource(path);
                if (keySupplier.PrivateCount == 0) throw new ArgumentException($"No private keys found from {path}");
                return keySupplier;
            }

        }
    }
}
