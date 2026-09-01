using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Metadata
{
    public class LicenseInfo
    {
        public string Holder;
        public Dictionary<string,string> Limits;
        public DateTime? LicenseExpiry { get; set; }
        public DateTime? ReleaseExpiry { get; set; }
        public string LicenseCheckType { get; set; }
    }
}