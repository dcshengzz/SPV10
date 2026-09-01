using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using static swz.Clover.SPCP.SPCPOptions;

namespace swz.Clover.SPCP.Nevis
{
    /// <summary>
    /// Settings that determine how to handle the JWT passed to us from Nevis
    /// </summary>
    public class NevisSettings
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Form parameter in which the Nevis JWT will be supplied
        /// </summary>
        public string TokenParameter { get; private set; } = "nevisToken";

        public string IssuerPublicKeyPath { get; private set; } 

        public string DecryptionPrivateKeyPath { get; private set; }

        public string ExpectedAudience { get; private set; }

        public string ExpectedIssuer { get; private set; }

        /// <summary>
        /// Getter needs to be immutable, so use GetValidAlgorithms() to get it in application code.
        /// Setter will be called by netcore to initialse the list from an array in appsettings.
        /// Can't make the type as IEnumerable&lt;string&gt; because then netcore won't read it!
        /// If empty then no algroithm restriction will be applied. 
        /// </summary>
        private List<string> ValidAlgorithms { get;  set; } = new List<string>();

        /// <summary>
        /// Indicates if we are restricting the allowed algorithms for the JWT.
        /// If this returns true then only those algorithms set in ValidAlgorithms are allowed.
        /// </summary>
        public bool IsRestrictAlgorithms { get =>  ValidAlgorithms.Any(); }

        public int ClockSkewSeconds { get; private set; } = 0;

        /// <summary>
        /// Property to facilitate overriding the name of the claim in which we expect to find the entity information
        /// included amongst which will be the UEN.
        /// Default is "entityInfo" (for corppass), for Singpass need to change this to "sub"
        /// </summary>
        public string IdentityClaimName {get; private set;} = "entityInfo";

        /// <summary>
        /// Returns true if the required values aren't configured
        /// </summary>
        /// <returns></returns>
        public bool IsInvalid()
        {
            return (string.IsNullOrEmpty(IssuerPublicKeyPath) 
                || string.IsNullOrEmpty(ExpectedAudience)
                ||string.IsNullOrEmpty(ExpectedIssuer)
                || string.IsNullOrEmpty(TokenParameter));
        }

        /// <summary>
        /// Returns an enumerable of the algorithms (based on hidden ValidAgorithms property which
        /// is hidden since List could be mutated by caller.)
        /// </summary>
        /// <returns></returns>
        public IEnumerable<string> GetValidAlgorithms()
        {
            return new ReadOnlyCollection<string>(ValidAlgorithms);
        }
    }

    /// <summary>
    /// Contains both UAT and Production settings and a convenience method to get one of them for specified environment
    /// </summary>
    public abstract class NevisSettingsWrapper
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Settings to use if the SPCP.IsProduction is false
        /// </summary>
        public NevisSettings Uat { get; }

        /// <summary>
        /// Settings to use when the SPCP.IsProduction is true
        /// </summary>
        public NevisSettings Production { get; }

        public NevisSettings GetNevisSettings(SPCPEnvironment environment)
        {
            switch (environment)
            {
                case SPCPEnvironment.Uat: return Uat;
                case SPCPEnvironment.Production: return Production;
                default: throw new NotImplementedException(environment.ToString());
            }
        }

        public NevisSettingsWrapper()
        {
            Uat = new NevisSettings();

            Production = new NevisSettings();
        }
    }

    public class CorppassNevisSettingsWrapper : NevisSettingsWrapper
    {
        public static readonly string AppSettings_Key = "Corppass:Nevis";

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public CorppassNevisSettingsWrapper() { }
    }

    public class SingpassNevisSettingsWrapper : NevisSettingsWrapper
    {
        public static readonly string AppSettings_Key = "Singpass:Nevis";

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public SingpassNevisSettingsWrapper() { }
    }
}
