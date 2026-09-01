using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.Clover.Core.Utils
{
    /// <summary>
    /// Readonly class that holds the mail settings required to work with the SMTP server.
    /// </summary>
    public class MailSettings
    {
        /// <summary>
        /// Thrown by the GetFromAppSettingsAsync to indicate that required mail settings read 
        /// from the dwAppSettings table are missing
        /// </summary>
        public class MailSettingsNotSetException : InvalidOperationException
        {
            public MailSettingsNotSetException(IEnumerable<string> missingSettings) 
                : base("Settings not configured in database: " + String.Join(",",missingSettings)) { }
        }

        public const string MAIL_SERVER = "MailServer";
        public const string MAIL_SERVER_LOGIN = "MailServerLogin";
        public const string MAIL_SERVER_PASS = "MailServerPass";
        public const string MAIL_SERVER_PORT = "MailServerPort";
        public const string MAIL_SERVER_SSL = "MailServerSsl";
        public const string MAIL_SERVER_DEFAULT_FROM = "MailServerDefaultFrom";

        private static readonly List<String> settingNames = new List<string> {
            MAIL_SERVER, 
            MAIL_SERVER_LOGIN,
            MAIL_SERVER_PASS, 
            MAIL_SERVER_PORT, 
            MAIL_SERVER_SSL,
            MAIL_SERVER_DEFAULT_FROM,
        };

        /// <summary>
        /// Factory method to read the current values from the Clover AppSettings (in the db) 
        /// and return a populated MailSettings instance.
        /// </summary>
        /// <returns>mailSettings</returns>
        public static async Task<MailSettings> GetFromAppSettingsAsync()
        {
            ILookup<string, string> settings = (await AppSettings
                .SelectAsync(Filter.And.In(settingNames, "Name")))
                .ToLookup(s => s.Name, s => s.Value);
            string mailServer = settings[MAIL_SERVER].FirstOrDefault();
            string mailServerPortString = settings[MAIL_SERVER_PORT].FirstOrDefault();
            string mailServerLogin = settings[MAIL_SERVER_LOGIN].FirstOrDefault();
            string mailServerPass = settings[MAIL_SERVER_PASS].FirstOrDefault();
            string mailServerSslString = settings[MAIL_SERVER_SSL].FirstOrDefault();
            string mailServerDefaultFrom = settings[MAIL_SERVER_DEFAULT_FROM].FirstOrDefault();
            AssertMailSettingsAreConfigured(
                mailServer: mailServer, 
                mailServerPortString: mailServerPortString, 
                mailServerLogin: mailServerLogin, 
                mailServerPass: mailServerPass, 
                mailServerSslString: mailServerSslString,
                mailServerDefaultFrom: mailServerDefaultFrom);
            if(!int.TryParse(mailServerPortString, out int mailServerPort))
            {
                throw new FormatException($"Value for {MAIL_SERVER_PORT} cannot be parsed as an int");
            }
            if(!bool.TryParse(mailServerSslString, out bool mailServerSsl))
            {
                throw new FormatException($"Value for {MAIL_SERVER_SSL} cannot be parsed as a bool");
            }
            MailSettings instance = new MailSettings(
                mailServer: mailServer,
                mailServerPort: mailServerPort,
                mailServerLogin: mailServerLogin,
                mailServerPass: mailServerPass,
                mailServerSsl: mailServerSsl,
                mailServerDefaultFrom: mailServerDefaultFrom);
            return instance;
        }
        
        /// <summary>
        /// Validate that string values pulled from the database for the mail server settings have
        /// been initialised and raise a descriptive MailServerSettingsNotSetException if not. Note that
        /// this does NOT verify the values make sense, just that they are set and, where applicable, not
        /// merely whitespace.
        /// </summary>
        private static void AssertMailSettingsAreConfigured(
            string mailServer,
            string mailServerPortString,
            string mailServerLogin,
            string mailServerPass,
            string mailServerSslString,
            string mailServerDefaultFrom)
        {
            List<string> missingSettings = new List<string>(5);
            if (string.IsNullOrWhiteSpace(mailServer)) missingSettings.Add(MAIL_SERVER);
            if (string.IsNullOrWhiteSpace(mailServerPortString)) missingSettings.Add(MAIL_SERVER_PORT);
            if (string.IsNullOrWhiteSpace(mailServerLogin)) missingSettings.Add(MAIL_SERVER_LOGIN);
            if (mailServerPass==null) missingSettings.Add(MAIL_SERVER_PASS); //this one can be empty in certain environments
            if (string.IsNullOrEmpty(mailServerSslString)) missingSettings.Add(MAIL_SERVER_SSL);
            if (string.IsNullOrWhiteSpace(mailServerDefaultFrom)) missingSettings.Add(MAIL_SERVER_DEFAULT_FROM);
            if(missingSettings.Any())
            {
                throw new MailSettingsNotSetException(missingSettings);
            }
        }

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public string MailServer { get; }
        public int MailServerPort { get; } 
        public string MailServerLogin { get; }
        public string MailServerPass { get; }
        public bool MailServerSsl { get; }
        public string MailServerDefaultFrom { get; }

        /// <summary>
        /// Constructor for a MailSettings object.
        /// Normally you wouldn't need to call this in application code as you can use the static factory
        /// method GetFromAppSettingsAsync to create one based on the values in dwAppSettings.
        /// All arguments are required, but password can be empty (we do not support anonymous login currently).
        /// </summary>
        public MailSettings(
            string mailServer,
            int mailServerPort,
            string mailServerLogin,
            string mailServerPass,
            bool mailServerSsl,
            string mailServerDefaultFrom)
        {
            if (string.IsNullOrWhiteSpace(mailServer)) throw new ArgumentException(nameof(mailServer));
            if (mailServerPort < 0) throw new ArgumentException(nameof(mailServerPort));
            if (string.IsNullOrWhiteSpace(mailServerLogin)) throw new ArgumentException(mailServerLogin);
            if (mailServerPass == null) throw new ArgumentNullException(nameof(mailServerPass)); //may be empty but not null
            if (string.IsNullOrWhiteSpace(mailServerDefaultFrom)) throw new ArgumentException(nameof(mailServerDefaultFrom));

            this.MailServer = mailServer;
            this.MailServerPort = mailServerPort;
            this.MailServerLogin = mailServerLogin;
            this.MailServerPass = mailServerPass;
            this.MailServerSsl = mailServerSsl;
            this.MailServerDefaultFrom = mailServerDefaultFrom;
        }
    }
}
