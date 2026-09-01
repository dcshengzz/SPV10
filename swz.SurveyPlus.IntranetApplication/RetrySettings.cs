using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Holds a group of common retry settings and provides a static factory method to get an instance
    /// from the dwAppSettings given a basename. Intended for use with stored procedure, queries, api calls,
    /// and similar things, to help encapsulate these settings.
    /// (The Timeout value has now been broken into its own class, TimeoutSettings)
    /// </summary>
    public class RetrySettings
    {
        /// <summary>
        /// Flyweight instance configured with 0 retries
        /// </summary>
        public static RetrySettings NO_RETRIES_INSTANCE 
            = new RetrySettings(retries: NO_RETRIES, baseRetryDelaySeconds: 0);

        public const int NO_RETRIES = 0;

        public const string SETTING_RETRIES_POSTFIX = ".Retries";
        public const string SETTING_BASE_RETRY_DELAY_POSTFIX = ".RetryDelay";

        private static readonly ImmutableList<String> postfixes = new List<string> {
            SETTING_RETRIES_POSTFIX,
            SETTING_BASE_RETRY_DELAY_POSTFIX,
        }.ToImmutableList();

        //TODO - factory method to get instance with timeout from settings, would return a tupple
        //       with a RetrySettings and a TimeoutSettings, using a single call to get a settings
        //       wrapper. To add once I actually have something using it.

        /// <summary>
        /// Get the retry settings from dwAppSettings based on the basename (which is typicaly the name of the stored procedure).
        /// The default values passed will be used if dwAppSettings does not have a value configured. In that case the usual
        /// behaviour is to log a warning that the fallback value is being used. If you wish to suppress this warning then pass
        /// null for the logger. (A common pattern here is where such settings are not provided out of the box as the ones provided
        /// in code are expected to be satisfactory and not require per-instance tuning, yet it is still desired to provide a mechanism
        /// to override these if necessary by adding them later in the database to a live instance without deploying code changes).
        /// </summary>
        /// <param name="baseName"></param>
        /// <param name="defaultRetries">fallback value for total number of tries if none found in dwAppSettings (use 1 for no extra tries)</param>
        /// <param name="defaultBaseRetryDelaySeconds">fallback value for delay before retry if none found in dwAppSettings, note that delay is increased for each subsequent retry</param>
        /// <param name="logger">(optional) if null then warnings about missing appSettings will be suppressed</param>
        /// <returns>a populated instance of RetrySettings</returns
        public static async Task<RetrySettings> GetInstanceUsingAppSettingsAsync(
            string baseName,
            int defaultRetries,
            double defaultBaseRetryDelaySeconds,
            ILogger logger = null)
        {
            if (baseName == null) throw new ArgumentNullException(nameof(baseName));
            List<string> names = postfixes.Select(postfix => baseName + postfix).ToList();
            SettingsWrapper settings = await SettingsHelper.GetSettingsWrapperAsync(names, assertDefined: false);
            return GetInstanceFromSettingsWrapper(
                settings,
                baseName,
                defaultRetries,
                defaultBaseRetryDelaySeconds,
                logger);
        }

        public static RetrySettings GetInstanceFromSettingsWrapper(
            SettingsWrapper settings,
            string baseName, 
            int defaultRetries,
            double defaultBaseRetryDelaySeconds,
            ILogger logger=null)
        {
            if (settings == null) throw new ArgumentNullException(nameof(settings));
            if (baseName == null) throw new ArgumentNullException(nameof(baseName));

            int retries 
                = settings.GetIntOrDefault(baseName + SETTING_RETRIES_POSTFIX, defaultRetries, logger);
            double baseRetryDelaySeconds 
                = settings.GetDoubleOrDefault(baseName + SETTING_BASE_RETRY_DELAY_POSTFIX, defaultBaseRetryDelaySeconds, logger);
            
            return new RetrySettings(retries, baseRetryDelaySeconds);
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public int Retries { get; private set; }
        public double BaseRetryDelaySeconds { get; private set; }
        public int BaseRetryDelayMilliseconds { get => (int)Math.Floor(BaseRetryDelaySeconds * 1000); }

        //TODO - add RetryDelayMultiplier here

        public RetrySettings(int retries, double baseRetryDelaySeconds)
        {
            if (retries < 0) throw new ArgumentException("Must be zero or positive", nameof(retries));
            if (baseRetryDelaySeconds < 0) throw new ArgumentException("Must be zero or positive", nameof(baseRetryDelaySeconds));
            this.Retries = retries;
            this.BaseRetryDelaySeconds = baseRetryDelaySeconds;
        }

        public override string ToString()
        {
            return nameof(RetrySettings) + $"[{nameof(Retries)}={Retries}, BaseRetryDelaySeconds={BaseRetryDelaySeconds}]";
        }

    }
}
