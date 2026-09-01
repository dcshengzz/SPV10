using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using swz.Clover.SPCP.Nevis;
using swz.Clover.SPCP.oidc;
using System;

namespace swz.Clover.SPCP
{
    public class SPCPConfigurator
    {
        public SPCPConfigurator()
        {
            ;
        }

        public void ConfigureServices(
            SPCPOptions spcpOptions,
            IConfigurationRoot configuration, 
            IServiceCollection services)
        {
            //Warning , the logging environment will not be ready when this method is called. Do not log here.
            //see: https://stackoverflow.com/a/46298052/8243046

            services.AddSingleton<SPCPOptions>(spcpOptions);

            switch(spcpOptions.Agency)
            {
                case "NONE":
                    break;

                case "IMDA":
                    new OidcConfigurator().ConfigureOidcServices(spcpOptions, configuration, services);
                    break;

                case "MPA":
                    new NevisConfigurator().ConfigureNevisServices(spcpOptions, configuration, services);
                    break;

                default:
                    throw new NotImplementedException(spcpOptions.Agency.ToString());
            }

        }
    }
}
