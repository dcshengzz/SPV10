using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    //TODO - considering that MailSettings is in Core, we could consider moving this code there too? But not important now

    /// <summary>
    /// Some utility methods and exception related to the dwAppSettings.
    /// Note that many common settings have specific classes to assist with their retrieval, for example:
    ///     swz.Clover.Core.Utils.MailSettings
    /// </summary>
    public static class SettingsHelper
    {
        /// <summary>
        /// Utility methods to fetch the value of certain commonly used settings
        /// </summary>
        public static class Common
        {
            public static readonly string INTRANET_DOMAIN_AUTHORITY = "IntranetDomainAuthority";
            public static readonly string INTERNET_DOMAIN_AUTHORITY = "InternetDomainAuthority";
            public static readonly string APPLICATION_NAME = "ApplicationName";

            /// <summary>
            /// Get the value for IntranetDomainAuthority from dwAppSettings
            /// Will return null if it is not found (no exception thrown!)
            /// </summary>
            /// <returns>intranet domain (should be host and port but not the protocol)</returns>
            public static async Task<string> GetIntranetDomainAuthority()
            {
                List<AppSettings> settings = await AppSettings.SelectAsync(Filter.And.Equal(INTRANET_DOMAIN_AUTHORITY, Constants.FieldName.Name));
                string domain = settings.FirstOrDefault()?.Value;
                return domain;
            }

            /// <summary>
            /// Get the value for InternetDomainAuthority from dwAppSettings
            /// Will return null if it is not found  (no exception thrown!)
            /// </summary>
            /// <returns>internet domain (should be host and port but not the protocol)</returns>
            public static async Task<string> GetInternetDomainAuthority()
            {
                List<AppSettings> settings = await AppSettings.SelectAsync(Filter.And.Equal(INTERNET_DOMAIN_AUTHORITY, Constants.FieldName.Name));
                string domain = settings.FirstOrDefault()?.Value;
                return domain;
            }

            /// <summary>
            /// Get the setting for ApplicationName from dwAppSettings.
            /// Will return null if it is not found  (no exception thrown!)
            /// </summary>
            /// <returns>ApplicatioName</returns>
            public static async Task<string> GetApplicationName()
            {
                List<AppSettings> settings = await AppSettings.SelectAsync(Filter.And.Equal(APPLICATION_NAME, Constants.FieldName.Name));
                string appName = settings.FirstOrDefault()?.Value;
                return appName;
            }
        }

        public class SettingRetrievalException : Exception
        {
            /// <summary>
            /// Name of the missing setting for reporting purposes.
            /// Note that in some cases this may be null or contain multiple comma delimited names. 
            /// </summary>
            public string Name { get; private set; }

            public SettingRetrievalException(string message, string name) : base(message)
            {
                this.Name = name;
            }

            public SettingRetrievalException(string message, String name, Exception innerException) : base(message, innerException)
            {
                this.Name = name;
            }
        }

        public class NoSuchSettingException : SettingRetrievalException
        {
            public NoSuchSettingException(string name) : base($"Setting \"{name}\" does not exist", name) { }
        }

        /// <summary>
        /// Get the (string) value for the specified dwAppSettings setting from the database. 
        /// By default a NoSuchSettingException is raised if there is no row present for it, 
        /// but if you specify assertDefined=false then such cases will return an empty string (not null). 
        /// If the value in the database itself is an empty string it is returned as such and no exception is raised. 
        /// The column in the database is not null and this method will never return null. 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="assertDefined">verify this is a known setting. This is recommended for all settings that are expected to exist</param>
        /// <returns>value of the setting, may be empty but never null. Note that this value is not trimmed as this method can't know whether extra whitespace is meaningful to the caller or not</returns>
        public static async Task<string> GetValue(string name, bool assertDefined = true)
        {
            if (name == null) throw new ArgumentNullException(nameof(name));
            if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException("Must be specified", nameof(name));
            try
            {
                Filter byName = Filter.And.Equal(name, Constants.FieldName.Name);
                AppSettings setting = (await AppSettings.SelectAsync(byName)).FirstOrDefault();
                if (setting == null)
                {
                    if (assertDefined)
                        throw new NoSuchSettingException(name);
                    else
                        return "";
                } 
                else
                {
                    //n.b. db column is (currently) not-null so the ??"" should be redundant
                    //     but we do this to maintain consistent behaviour lest the db be changed yet caller expectations aren't
                    return setting.Value??""; 
                }
            }
            catch(SettingRetrievalException)
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SettingRetrievalException($"Failed to retrieve setting \"{name}\" from database", name, e);
            }
        }

        /// <summary>
        /// Returns a SettingsWrapper utility object to make it easier to get and parse the specified settings.
        /// </summary>
        /// <param name="settingNames">names of settings to retrieve</param>
        /// <returns></returns>
        public static async Task<SettingsWrapper> GetSettingsWrapperAsync(IEnumerable<string> settingNames, bool assertDefined=true)
        {
            var wrapper = new SettingsWrapper(await GetLookupAsync(settingNames));
            if(assertDefined)
            {
                List<string> missing = settingNames.Where(name => !wrapper.Contains(name)).ToList();
                if (missing.Any()) throw new SettingRetrievalException("One or more settings not found", String.Join(',',missing));
            }
            return wrapper;
        }

        /// <summary>
        /// Returns a lookup for the specified settings. (Does NOT validate if they are all present.)
        /// This is useful for retrieving multiple settings with one db call.
        /// You can use FirstOrDefault to get single values out of the returned lookup.
        /// e.g.    string timeoutSecondsStr = settings[SETTING_TIMEOUT].FirstOrDefault();
        ///         where 'settings' is the returned ILookup, and SETTING_TIMEOUT a constant with the setting name.
        ///         
        /// (Note that you should consider using GetSettingsWrapperAsync as a higher level alternative to this)
        /// </summary>
        public static async Task<ILookup<string, string>> GetLookupAsync(IEnumerable<string> settingNames)
        {
            if (settingNames == null) throw new ArgumentNullException(nameof(settingNames));
            List<string> namesAsList = (settingNames is List<string>) ? (List<string>)settingNames : settingNames.ToList();
            ILookup<string, string> settings = (await AppSettings
                .SelectAsync(Filter.And.In(namesAsList, Constants.FieldName.Name))) //Name is PK so unique across all the setting groups too
                .ToLookup(s => s.Name, s => s.Value);
            return settings;
        }

        public static async Task<ILookup<string, string>> GetLookupAsync(params string[] settingNames)
        {
            return await GetLookupAsync((settingNames ?? new string[] { }).ToList());
        }
    }

    /// <summary>
    /// Wraps an ILookup containing settings with some convenient methods to access the values
    /// </summary>
    public class SettingsWrapper
    {
        /// <summary>
        /// Thrown by the indexer if a setting is not found
        /// The difference between this and a SettingNotFoundException is the setting may be present in the db itself
        /// but was not passed to this wrapper.
        /// </summary>
        public class SettingNotPresentException : SettingsHelper.SettingRetrievalException
        {
            public SettingNotPresentException(string name) : base($"Setting \"{name}\" was not provided to this wrapper", name) { }
        }

        public static async Task<SettingsWrapper> ForNames(params string[] settingNames)
        {
            return new SettingsWrapper(await SettingsHelper.GetLookupAsync(settingNames));
        }

        public static async Task<SettingsWrapper> ForNames(IEnumerable<string> settingNames)
        {
            return new SettingsWrapper( await SettingsHelper.GetLookupAsync(settingNames) );
        }

        private readonly ILookup<string, string> settings;

        public SettingsWrapper(ILookup<string, string>settings)
        {
            this.settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        //indexer
        public string this[string settingName]
        {
            get
            {
                if (!TryGetString(settingName, out string value))
                    throw new SettingNotPresentException(settingName);
                return value;
            }
        }

        public bool Contains(string settingName)
        {
            if (settingName == null) throw new ArgumentNullException(nameof(settingName));
            return settings.Contains(settingName);
        }

        public bool TryGetString(string settingName, out string stringValue)
        {
            if (settingName == null) throw new ArgumentNullException(nameof(settingName));
            if (string.IsNullOrWhiteSpace(settingName)) throw new ArgumentException(nameof(settingName));
            stringValue = settings[settingName].FirstOrDefault();
            return (stringValue != null);
        }

        public bool TryGetInt(string settingName, out int intValue)
        {
            intValue = 0; //output if finding/parsing fail
            if (!TryGetString(settingName, out string stringValue)) return false;
            if (!int.TryParse(stringValue, out int value)) return false;
            intValue = value;
            return true;
        }

        public bool TryGetLong(string settingName, out long longValue)
        {
            longValue = 0; //output if finding/parsing fail
            if (!TryGetString(settingName, out string stringValue)) return false;
            if (!long.TryParse(stringValue, out long value)) return false;
            longValue = value;
            return true;
        }

        public bool TryGetDouble(string settingName, out double doubleValue)
        {
            doubleValue = 0; //output if finding/parsing fail
            if (!TryGetString(settingName, out string stringValue)) return false;
            if (!double.TryParse(stringValue, out double value)) return false;
            doubleValue = value;
            return true;
        }

        public bool TryGetBool(string settingName, out bool boolValue)
        {
            boolValue = false; //output if finding/parsing fail
            if (!TryGetString(settingName, out string stringValue)) return false;
            if (!bool.TryParse(stringValue, out bool value)) return false;
            boolValue = value;
            return true;
        }

        /// <summary>
        /// Try to get an int value from the settings wrapper, if it isn't present use the defaultValue and
        /// log a warning message about its absense if a logger is provided.
        /// </summary>
        public int GetIntOrDefault(string name, int defaultValue, ILogger warningLogger=null)
        {
            int value;
            {
                if (TryGetInt(name, out int parsedValue))
                {
                    value = parsedValue;
                }
                else
                {
                    if (warningLogger != null && warningLogger.IsEnabled(LogLevel.Warning))
                    {
                        warningLogger.LogWarning(nameof(GetIntOrDefault) + " - {0} value is not set, using default value {1}", name, defaultValue);
                    }
                    value = defaultValue;
                }
            }
            return value;
        }

        public double GetDoubleOrDefault(string name, double defaultValue, ILogger warningLogger)
        {
            double value;
            {
                if (TryGetDouble(name, out double parsedValue))
                {
                    value = parsedValue;
                }
                else
                {
                    if (warningLogger != null && warningLogger.IsEnabled(LogLevel.Warning))
                    {
                        warningLogger.LogWarning(nameof(GetDoubleOrDefault) + " - {0} value is not set, using default value {1}", name, defaultValue);
                    }
                    value = defaultValue;
                }
            }
            return value;
        }

        public string GetStringOrDefault(string name, string defaultValue, ILogger warningLogger)
        {
            string value;
            {
                if (TryGetString(name, out string stringValue))
                {
                    value = stringValue;
                }
                else
                {
                    if (warningLogger != null && warningLogger.IsEnabled(LogLevel.Warning))
                    {
                        warningLogger.LogWarning(nameof(GetStringOrDefault) + " - {0} value is not set, using default value {1}", name, defaultValue);
                    }
                    value = defaultValue;
                }
            }
            return value;
        }

        public bool GetBoolOrDefault(string name, bool defaultValue, ILogger warningLogger)
        {
            bool value;
            {
                if (TryGetBool(name, out bool boolValue))
                {
                    value = boolValue;
                }
                else
                {
                    if (warningLogger != null && warningLogger.IsEnabled(LogLevel.Warning))
                    {
                        warningLogger.LogWarning(nameof(GetStringOrDefault) + " - {0} value is not set, using default value {1}", name, defaultValue);
                    }
                    value = defaultValue;
                }
            }
            return value;
        }
    }
}
