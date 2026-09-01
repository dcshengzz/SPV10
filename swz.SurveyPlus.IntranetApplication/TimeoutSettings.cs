using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;


namespace swz.SurveyPlus.IntranetApplication
{
    //I ended up using the plural form of the name mainly just to sound 'consistent' with RetrySettings
    public class TimeoutSettings
    {
        public const double NO_TIMEOUT = 0d; //as per SqlCommand, 0 indicates no timeout

        public const string SETTING_TIMEOUT_POSTFIX = ".Timeout";

        private static readonly ImmutableList<String> postfixes = new List<string> {
            SETTING_TIMEOUT_POSTFIX,
        }.ToImmutableList();

        public static async Task<TimeoutSettings> GetInstanceUsingAppSettingsAsync(
            string baseName,
            double defaultTimeoutSeconds,
            ILogger logger = null)
        {
            if (baseName == null) throw new ArgumentNullException(nameof(baseName));
            List<string> names = postfixes.Select(postfix => baseName + postfix).ToList();
            SettingsWrapper settings = await SettingsHelper.GetSettingsWrapperAsync(names, assertDefined: false);
            double timeoutSeconds = settings.GetDoubleOrDefault(baseName + SETTING_TIMEOUT_POSTFIX, defaultTimeoutSeconds, logger);

            return new TimeoutSettings(timeoutSeconds);
        }

        public static TimeoutSettings GetInstanceFromSettingsWrapper(
            SettingsWrapper settings,
            string baseName,
            double defaultTimeoutSeconds,
            ILogger logger = null)
        {
            if (settings == null) throw new ArgumentNullException(nameof(settings));
            if (baseName == null) throw new ArgumentNullException(nameof(baseName));

            double timeoutSeconds
                = settings.GetDoubleOrDefault(baseName + SETTING_TIMEOUT_POSTFIX, defaultTimeoutSeconds, logger);

            return new TimeoutSettings(timeoutSeconds);
        }

        /// <summary>
        /// The configured number of seconds, which can include a fractional part
        /// </summary>
        public double TimeoutSeconds { get; private set; }

        /// <summary>
        /// Returns the timeout seconds as an int rounded up to the next whole number of seconds (Ceiling)
        /// Use this for things like CommandTimeout in SqlCommand that want an integral number of seconds
        /// </summary>
        public int TimeoutSecondsRoundedUp { get => (int)Math.Ceiling(TimeoutSeconds); }

        /// <summary>
        /// Converts the timeout seconds to a whole number of milliseconds (Floor)
        /// Use this for things like Task.Delay that want an integral number of milliseconds
        /// </summary>
        public int TimeoutMilliseconds { get => (int)Math.Floor(TimeoutSeconds * 1000); }

        /// <summary>
        /// Constructor. The value passed may be zero or positive, but not negative.
        /// </summary>
        public TimeoutSettings(double timeoutSeconds)
        {
            if (timeoutSeconds < 0) throw new ArgumentException("Must be zero or positive", nameof(timeoutSeconds));
            this.TimeoutSeconds = timeoutSeconds;
        }

        public override string ToString()
        {
            return nameof(TimeoutSettings) + $"[{nameof(TimeoutSeconds)}={TimeoutSeconds}]";
        }

    } //end of TimeoutSettings
}
