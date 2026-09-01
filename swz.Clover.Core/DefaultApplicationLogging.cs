using Microsoft.Extensions.Logging;
using __LoggerFactory = Microsoft.Extensions.Logging.LoggerFactory;
using System;

namespace swz.Clover.Core
{
    /// <summary>
    /// Provides access to the global logger factory
    /// </summary>
    public class DefaultApplicationLogging
    {
        private static readonly ILoggerFactory DefaultLoggerFactory; //Placeholder until the real one can be set

        /// <summary>
        /// Global logger factory reference
        /// nb: if you wish to create a logger, there are some CreateLogger convenience methods here
        /// </summary>
        public static ILoggerFactory LoggerFactory { get; private set; }

        static DefaultApplicationLogging()
        {
            //Need to at least set a placeholder, otherwise any class that tries to get logger has an error
            //and since many do so in their own static code it means those classes cant even be loaded.
            //And this is a disaster for unit tests
            DefaultLoggerFactory = new __LoggerFactory();
            LoggerFactory = DefaultLoggerFactory;
        }

        /// <summary>
        /// Intended to be called from Startup.cs , use this to set the global reference to the logger factory.
        /// This method will fail if called more than once.
        /// It is not threadsafe either.
        /// </summary>
        /// <param name="loggerFactory">loggerFactory to use, may not be null</param>
        public static void InitialiseLoggerFactory(ILoggerFactory loggerFactory)
        {
            if(LoggerFactory==DefaultLoggerFactory || LoggerFactory==null)
            {
                if (loggerFactory == null) throw new ArgumentException("loggerFactory may not be null");
                LoggerFactory = loggerFactory;
            }
            else
            {
                throw new InvalidOperationException("LoggerFactory has already been set");
            }
        }

        //TODO - can we update this to return Logger<T> without breaking things?
        /// <summary>
        /// Convenience method to use the global logger factory to create a logger with a category named after the specified type.
        /// (This wasn't initially coded to return Logger&lt;T&gt; so you may need to cast)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static ILogger CreateLogger<T>()
        {
            return LoggerFactory.CreateLogger<T>();
        }

        /// <summary>
        /// Convenience method to use the global logger factory to create a logger with a category named after the specified type.
        /// For non static types you should prefer CreateLogger&lt;T&gt;()
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static ILogger CreateLogger(Type type)
        {
            return LoggerFactory.CreateLogger(type.FullName);
        }

        /// <summary>
        /// This will return the level level the logger is configured for by checking
        /// against each one that is enabled, however be aware that the overall minimum
        /// level may be higher than this, so you can't actually count on anything being
        /// logged even if this logegr thinks it is enabled for the desired level.
        /// </summary>
        /// <param name="logger"></param>
        /// <returns>logLevel</returns>
        public static LogLevel GetEnabledLogLevel(ILogger logger)
        {
            if (logger.IsEnabled(LogLevel.Trace)) return LogLevel.Trace;
            if (logger.IsEnabled(LogLevel.Debug)) return LogLevel.Debug;
            if (logger.IsEnabled(LogLevel.Information)) return LogLevel.Information;
            if (logger.IsEnabled(LogLevel.Warning)) return LogLevel.Warning;
            if (logger.IsEnabled(LogLevel.Error)) return LogLevel.Error;
            if (logger.IsEnabled(LogLevel.Critical)) return LogLevel.Critical;
            if (logger.IsEnabled(LogLevel.None)) return LogLevel.None;
            throw new InvalidOperationException("Unable to determine log level"); //This shouldnt happen
        }
    }
}