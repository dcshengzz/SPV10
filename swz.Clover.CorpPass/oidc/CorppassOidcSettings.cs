using System;
using static swz.Clover.SPCP.SPCPOptions;

namespace swz.Clover.SPCP.OIDC
{
    /// <summary>
    /// Holds settings read from appsettings.json for the OIDC implementations of Corppass.
    /// </summary>
    public class CorppassOidcSettings
    {
        public static readonly string AppSettings_Key = "Corppass:Oidc";

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public OidcSettings GetOidcSettings(SPCPEnvironment environment)
        {
            switch (environment)
            {
                case SPCPEnvironment.Uat: return Uat;
                case SPCPEnvironment.Production: return Production;
                default: throw new NotImplementedException(environment.ToString());
            }
        }

        /// <summary>
        /// Settings to use if the SPCP.IsProduction is false
        /// </summary>
        public OidcSettings Uat { get; }

        /// <summary>
        /// Settings to use when the SPCP.IsProduction is true
        /// </summary>
        public OidcSettings Production { get; }

        public CorppassOidcSettings()
        {
            Uat = new OidcSettings();

            Production = new OidcSettings();
        }
    }
}
