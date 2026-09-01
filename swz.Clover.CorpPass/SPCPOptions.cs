using System;

namespace swz.Clover.SPCP
{
    /// <summary>
    /// Holds appsettings value for Singpass/Corppass configuration
    /// </summary>
    public class SPCPOptions
    {
        public enum SPCPEnvironment { Uat, Production }

        public class LoginUrlOptions
        {
            public class LoginPaths
            {
                public string Singpass { get; private set; } = "";
                public string Corppass { get; private set; } = "";
            }

            public LoginPaths Uat { get; }  = new LoginPaths();
            public LoginPaths Production { get; } = new LoginPaths();

            public LoginPaths GetLoginPaths(SPCPEnvironment environment)
            {
                switch (environment)
                {
                    case SPCPEnvironment.Uat: return Uat;                        
                    case SPCPEnvironment.Production: return Production;
                    default: throw new NotImplementedException(environment.ToString());
                }
            }
        }

        public static readonly string Agency_None = "NONE";

        // // // // // // // // // // // // // // // // // // // // // // // //

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// True if the CorpPass/Singpass support is enabled. 
        /// When this is set the respondent login by password is replaced with SPCP login. 
        /// (Note that nowadays Corppass login uses Singpass badging, but is still technically a bit different)
        /// Implementation to be used will be determined by the specified agency.)
        /// </summary>
        public bool IsSPCPLogin { get; private set; } = false;

        public bool IsCorppassSupported { get; private set; } = false;

        public bool IsSingpassSupported { get; private set; } = false;

        //TODO - Make agency an enum
        private string agency = Agency_None;
        /// <summary>
        /// This takes an agency name, not the name of the application we deploy at that agency.
        /// Default is NONE (which means the SPCP login won't actually function as this isn't a valid agency.
        /// Value will be automatically converted to uppercase when it is set.
        /// </summary>
        public string Agency 
        { 
            get => agency;
            private set => agency = string.IsNullOrWhiteSpace(value) ? Agency_None : value.ToUpperInvariant(); 
        }

        /// <summary>
        /// Enables additional SPCP debugging behaviour for troubleshooting purposes.
        /// </summary>
        public bool Debug { get; private set; } = false;

        /// <summary>
        /// Indicates whether to use Production or Uat settings. When false (the default) the Uat settings
        /// would be used. The settings used is also determined in part by which agency is configured as
        /// that determines implementation.
        /// Having this switch allows us to switch back and forth without having to comment out.
        /// See also the Environment property which this is backed by. 
        /// </summary>
        public bool IsProduction 
        { 
            get => Environment.Equals(SPCPEnvironment.Production);
            private set => Environment = value ? SPCPEnvironment.Production : SPCPEnvironment.Uat;
        }

        /// <summary>
        /// Specifies the SPCP environment. 
        /// If setting in appsetings JSON (ie instead of using IsProduction to set it) then use "Uat" or "Production"
        /// </summary>
        public SPCPEnvironment Environment { get; private set; } = SPCPEnvironment.Uat;

        /// <summary>
        /// The URL to which the user will be sent when they click the login button on the login form
        /// </summary>
        public LoginUrlOptions LoginUrl { get; } = new LoginUrlOptions();

        /// <summary>
        /// If enabled, will add an intermediate page when using AspSameSite=Strict
        /// </summary>
        public bool IsEnableSameSiteDashboardInterstitial { get; private set; } = true;

        /// <summary>
        /// Subject to IsEnableSameSiteDashboardInterstitial, render the interstitial even if the
        /// session cookie was actually set in the redirected request from SPCP.
        /// (Only applicable if AspSameSite=Strict)
        /// </summary>
        public bool IsRenderInterstitialNotwithstandingSession { get; private set; } = false;
    }
}
