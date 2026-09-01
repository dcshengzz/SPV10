namespace swz.Clover.Core.License
{
    public interface ILicenseControlProvider
    {   
        /// <summary>
        /// True if license requires domain name
        /// </summary>
        bool DomainNameRequired { get; set; }

        /// <summary>
        /// Will be set to the current Authority (used to check against the host named in the license)
        /// </summary>
        string Host { get; set; }

        /// <summary>
        /// True if license is server specific (hardware id based)
        /// </summary>
        bool PerServer { get; set; }

        /// <summary>
        /// An error string here indicates that the license is not valid
        /// (Would be set at time of validation)
        /// </summary>
        string Message { get; set; }

        /// <summary>
        /// Indicates that the validation check has been performed
        /// (Does not indicate whether or not it succeeded)
        /// </summary>
        bool Validated { get; set; }
    }

}
