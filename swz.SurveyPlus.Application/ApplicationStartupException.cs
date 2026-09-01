using System;
using System.Globalization;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// An exception that can be used to indicate problems when starting up / initialising the application
    /// </summary>
    public class ApplicationStartupException : Exception
    {
        public enum ProgramBehaviour { TerminateAndExit, Throw }

        //Use a global variable to pass the option of how to handle the startup exception to program.cs.
        //Its catch statement won't have access to the config directly. 
        //This is a bit kludgy, but readable enough. 
        /// <summary>
        /// Global hinting to Program.cs how exceptions of this type should be handled
        /// </summary>
        public static ProgramBehaviour HandleBy { get; set; } = ProgramBehaviour.Throw;

        private static string TimeStamp()
        {
            try
            {
                return "(" + DateTime.Now.ToString("o", CultureInfo.InvariantCulture) + ") "; //local time for convenience
            }
            catch(Exception)
            {
                return "(Unknown Time) ";
            }
        }

        public ApplicationStartupException(string message) : base(message) { }

        public ApplicationStartupException(string message, Exception innerException) : base(TimeStamp() + message, innerException) { }
    }

    /// <summary>
    /// An ApplicationStartupException to wrap errors that occur when configuring the logging in Startup.cs
    /// </summary>
    public class StartupLoggingConfigurationException : ApplicationStartupException
    {
        public StartupLoggingConfigurationException(Exception innerException) : base("Failed to setup logging in application startup", innerException) { }
    }

    /// <summary>
    /// An ApplicationStartupException to wrap errors that occur in Startup's Configure method
    /// </summary>
    public class StartupConfigurationException : ApplicationStartupException
    {
        public StartupConfigurationException(Exception innerException) : base("Failed to configure the application at startup", innerException) { }
    }

    /// <summary>
    /// An ApplicationStartupException to wrap errors that occur in Startup's ConfigureServices method to configure services
    /// </summary>
    public class StartupServicesConfigurationException : ApplicationStartupException
    {
        public StartupServicesConfigurationException(Exception innerException) : base("Failed to configure services in application startup", innerException) { }
    }
}
