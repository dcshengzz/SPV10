namespace swz.Clover.Core.Configuration
{
    /// <summary>
    /// Object to hold configuration information read from the Clover block in appsettings.json
    /// </summary>
    public class CloverOptions
    {
        //TODO - some of these could be better placed in the SurveyPlus block, in particular the
        //       windows authentication and saml2 settings, because their support code is in
        //       surveyplus and not clover core

        //code responsible for instantiating this would go in Startup.cs

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public bool BlockMetadataChanges { get; private set; } = false;

        //TODO - why is there no default value here?
        public string AdminRole { get; private set; }

        /// <summary>
        /// Enables the SAML2 Authentication (i.e. Entra ID) features. 
        /// (These are mostly handled outside core in surveyplus code)
        /// Setting this also requires adding a saml2 block to the json to configure it
        /// </summary>
        public bool IsSaml2Authentication { get; private set; } = false;

        /// <summary>
        /// Configurable text for the Login With Windows Authentication button on the login page
        /// (When using SAML2 Authentication)
        /// </summary>
        public string LoginWithSaml2AuthenticationLabel { get; private set; } = "Login with Identity Provider";

        /// <summary>
        /// Enables the Windows Authentication features. 
        /// (These are partly handled outside core in surveyplus code. Also need IIS configured appropriately)
        /// </summary>
        public bool IsWindowsAuthentication { get; private set; } = false;

        /// <summary>
        /// Specifies how the application should issue a 401 challenge for Windows Authentication.
        /// </summary>
        public enum WA401ChallengeBehaviour
        {
            /// <summary>
            /// The application will choose its preferred option from one of the behaviours below.
            /// (As of 20231209 this choice is made in 
            ///  swz.SurveyPlus.IntranetWeb.Controllers.WindowsAuthenticationChallengerHelper.CreateChallenger
            ///  and it will use windowsChallenge)
            /// </summary>
            auto,

            /// <summary>
            /// Issue a 401 challenge without explicitly adding Www-Authenticate headers to the response.
            /// In this case we expect  IIS/HTTP.sys to add the Www-Authenticate headers to our response for us.
            /// </summary>
            status401,

            /// <summary>
            /// Issue a challenge using HttpContext.ChallengeAsync method.
            /// In this case we expect IIS/HTTP.sys to add both Www-Authenticate headers to our response for us.
            /// </summary>
            windowsChallenge,

            /// <summary>
            /// Issue a 401 and add both a 'Www-Authenticate: Negotiate' and a 'Www-Authenticate: NTLM' header to response
            /// (n.b. IIS/HTTP.sys will already add Www-Autheticate headers to 401 responses so these will be send to
            /// client as well as any the application adds itself)
            /// </summary>
            headers,

            /// <summary>
            /// Issue a 401 and add just a 'Www-Authenticate: Negotiate' header to response
            /// (n.b. IIS/HTTP.sys will already add Www-Authenticate headers to 401 responses so these will be send to
            /// client as well as any the application adds itself)
            /// </summary>
            negotiateOnly,

            /// <summary>
            /// Issue a 401 and add just a 'Www-Authenticate: NTLM' header to response
            /// (n.b. IIS/HTTP.sys will already add Www-Authenticate headers to 401 responses so these will be send to
            /// client as well as any the application adds itself)
            /// </summary>
            ntlmOnly,

            /// <summary>
            /// Old behaviour, issue a 401 and add 'Www-Authenticate: Negotiate,NTLM' header to response
            /// (n.b. IIS/HTTP.sys will already add Www-Authenticate headers to 401 responses so these will be send to
            /// client as well as any the application adds itself)
            /// </summary>
            legacy,
        }

        /// <summary>
        /// Allows modifying the behaviour when issuing a 401 challenge for Windows Authentication (i.e. AD Login).
        /// (Challenge logic is implemented outside core in the controllers. Also need IIS configured appropriately)
        /// </summary>
        public WA401ChallengeBehaviour WindowsAuthenticationChallenge { get; private set; } = WA401ChallengeBehaviour.auto;

        /// <summary>
        /// Configurable text for the Login With Windows Authentication button on the login page
        /// (When using Windows Authentication)
        /// </summary>
        public string LoginWithWindowsAuthenticationLabel { get; private set; } = "Login with Windows Authentication";

        /// <summary>
        /// Enables the username:password login screen
        /// </summary>
        public bool IsPasswordAuthentication { get; private set; } = true;

        /// <summary>
        /// Location for temporary file generation in the CodeActionsCompiler.
        /// Default is Temp (relative to instance folder).
        /// </summary>
        public string CodeActionFolderPath { get; private set; } = "Temp";

        /// <summary>
        /// Enables Debug mode for the CodeActionsCompiler.
        /// Default is false.
        /// </summary>
        public bool CodeActionDebugMode { get; private set; } = false;

        /// <summary>
        /// Enable the GetSwaggerFile endpoint that generates the clover.yaml api description
        /// (Default is false)
        /// </summary>
        public bool IsEnableSwaggerFile { get; private set; } = false;

        /// <summary>
        /// Disable the fix made for issue #287
        /// This flag will be removed in a future version
        /// </summary>
        public bool IsDisableFixForIssue287 { get; private set; } = false;

        /// <summary>
        /// Set the UseMetadata flag in CloverRuntime.
        /// Previously this was set depending on whether application is running in DEBUG env or not
        /// </summary>
        public bool UseMetadataCache { get; private set; } = true;
    }
}
