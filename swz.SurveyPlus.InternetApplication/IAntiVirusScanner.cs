using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.InternetApplication
{
    /// <summary>
    /// Thrown by scanner implementations when they encounter a problem performing the scan
    /// </summary>
    public class AntiVirusScanningException : Exception
    {
        public AntiVirusScanningException(string message) : base(message) { }

        public AntiVirusScanningException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// No-Op implementation of IAntiVirusScanner that always returns false from ScanFile.
    /// This will be used as a placeholder when an antivirus provider is not configured.
    /// </summary>
    public class NullAntiVirusScanner : IAntiVirusScanner
    {
        /// <summary>
        /// Immediately returns a completed task with the value false. 
        /// </summary>
        /// <param name="file">will be ignored, caller's responsibility to close any stream passed in</param>
        /// <returns></returns>
        public Task<bool> IsVirusDetected(StreamWithName file)
        {
            return Task.FromResult(false);
        }
    }

    public interface IAntiVirusScanner
    {
        /// <summary>
        /// Pass the file to the underlying antivirus to scan. Returns true if a virus was found.
        /// It is the caller's responsibility to manage disposal of the stream that is passed.
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        Task<bool> IsVirusDetected(StreamWithName file);
    }
}
