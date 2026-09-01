using System;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetWeb
{
    public class Program
    {
        /// <summary>
        /// Intranet Backoffice Application Entrypoint
        /// </summary>
        /// <param name="args"></param>
        public static void Main(string[] args)
        {
            IHost host = null;
            //Updated to follow the fix for SVP-06 for MPA SCR of 2022-04-29
            try
            {
                string contentRoot = IntranetApplicationContentRoot();
                host = Host
                    .CreateDefaultBuilder(args)
                    .UseContentRoot(contentRoot)
                    .ConfigureWebHostDefaults(webBuilder =>
                    {
                        webBuilder
                            .UseKestrel(option => option.AddServerHeader = false)
                            .UseIIS()
                            .UseStartup<StartupIntranet>();
                    }).Build();
                host.Run();
            }
            catch (ApplicationStartupException startupException)
            {
                //logging/writing exception stacktrace to stdout(if enabled) will have been handled by host already,
                //and by the time we reach here the logger factory has been disposed (if it was even created)
                switch (ApplicationStartupException.HandleBy)
                {
                    case ApplicationStartupException.ProgramBehaviour.TerminateAndExit:
                        
                        Console.Error.WriteLine($"Terminating application due to failure to start correctly: {startupException.Message}");

                        //We explicitly stop rather than raise the exception. IIS might then retry a few times as per
                        //the rapid fail configurations which might help get past some transient issues such as DB connectivity
                        //(Unfortunately the app needs db connectivity during startup, this can't be left until later)
                        //Not clean to retry here because we have a lot of static ambient context which isn't amenable to being
                        //setup multiple times so we'll need to rely on ISS or external intervention to try starting up again
                        StopAndExit(host);
                        break; //this line will never be reached

                    case ApplicationStartupException.ProgramBehaviour.Throw:
                        Console.Error.WriteLine($"Application failed to start correctly: {startupException.Message}");
                        throw;

                    default:
                        throw new NotImplementedException($"Unimplemented handling '{ApplicationStartupException.HandleBy}' for startup exception caught by {nameof(Program)}", startupException);
                }
            }
            catch (Exception unexpected) 
            {
                //logging/writing exception stacktrace to stdout(if enabled) will have been handled by host already,
                //and by the time we reach here the logger factory has been disposed (if it was even created)
                Console.Error.WriteLine($"Application failed to start correctly with an unexpected exception: {unexpected.Message}");
                throw;  
            }
        }

        private static void StopAndExit(IHost host)
        {
            if (host != null) host.StopAsync().GetAwaiter().GetResult();
            Environment.Exit(1); //n.b. for a web application returning an int from Main won't terminate
        }

        /// <summary>
        /// Return the path for the site content root.
        /// We will use the application's working directory (at startup time) for this.
        /// </summary>
        /// <returns>current directory</returns>
        private static string IntranetApplicationContentRoot()
        {
            try
            {
                return Directory.GetCurrentDirectory();
            }
            catch (UnauthorizedAccessException e)
            {
                //Specific handling for line identified in SVP-06 for MPA SCR of 2022-04-29
                //There is no recovery for this so wrap with the more generic exception noting the circumstances
                throw new ApplicationStartupException(
                    "Unable to use the application's working directory as the content root"
                    + " because the application is not authorised to get it -"
                    + " Please check installation folder permissions", e);
                //Any other exception is unexpected and we will allow it to bubble up for caller to handle
            }
        }
    }
}
