using System;

namespace swz.Clover.Core.License
{
    /// <summary>
    /// Throw if the current instance is missing a license or operating outside the restrictions of that license
    /// </summary>
    public class LicenseException : Exception
    {
        public LicenseException(string message)
            : base(message) { }

        public LicenseException(string name, long allowed, long total)
            : base($"Max number of {name} = {allowed} is exceeded, total number = {total}.") { }

        public LicenseException(string name, long allowed, long total, string installCode)
            : base($"Max number of {name} = {allowed} is exceeded, total number = {total}. Use {installCode} to request for a license key") { }
    }
}