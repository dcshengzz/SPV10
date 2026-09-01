using System;
using System.Collections.Generic;
using System.Text;

namespace swz.Clover.Core.License
{


    public class DefaultLicenseControlProvider : ILicenseControlProvider
    {
        public DefaultLicenseControlProvider(bool domainNameRequired = true, bool perServer = true,
            string host = "localhost", string message = null, bool validated = false)
        {
            DomainNameRequired = domainNameRequired;
            Host = host;
            PerServer = perServer;
            Message = Message;
            Validated = validated;


        }

        public bool DomainNameRequired { get; set; }
        public string Host { get; set; }
        public bool PerServer { get; set; }
        public string Message { get; set; }
        public bool Validated { get; set; }
    }
}