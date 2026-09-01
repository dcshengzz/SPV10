using System;
using System.Globalization;
using System.Text;
using Newtonsoft.Json;

namespace swz.Clover.Core.License
{
    internal abstract class BaseRestrictions
    {
        public abstract object Clone();
    }

    /// <summary>
    /// Represent restriction settings for WorkflowEngine .Net
    /// </summary>
    internal sealed class CloverRestrictions : BaseRestrictions
    {
        //n.b. SurveyPlus only asserts a subset of these (in paricular MaxNumberOfUsers)

        [JsonProperty(Order = 1)]
        public int MaxNumberOfUsers { get; set; }
        [JsonProperty(Order = 2)]
        public int MaxNumberOfForms { get; set; }
        [JsonProperty(Order = 3)]
        public int MaxNumberOfThreads { get; set; }
        [JsonProperty(Order = 4)]
        public int MaxNumberOfInstances { get; set; }
        [JsonProperty(Order = 5)]
        public int MaxNumberOfWorkflow { get; set; }

        


        public override object Clone()
        {
            return new CloverRestrictions()
            {
                MaxNumberOfUsers = MaxNumberOfUsers,
                MaxNumberOfForms = MaxNumberOfForms,
                MaxNumberOfThreads = MaxNumberOfThreads,
                MaxNumberOfInstances = MaxNumberOfInstances,
                MaxNumberOfWorkflow = MaxNumberOfWorkflow
            };
        }
    }

    public enum LicenseCheckType : byte
    {
        Offline,
        Online
    }

    public enum LicenseType : byte
    {
        Common,
        Trial
    }

    /// <summary>
    /// Represents a license key
    /// </summary>
    /// <typeparam name="T">Type of restriction object</typeparam>
    internal sealed class LicenseKey<T> where T : BaseRestrictions
    {
        public DateTime? ReleaseExpiry { get; set; }
        
        public DateTime? LicenseExpiry { get; set; }
        
        public String Hash { get; set; }

        public String Ref { get; set; }

        public T Restrictions { get; set; }
        
        public string WorkflowLicenseKey { get; set; }

        public LicenseCheckType CheckType { get; set; }

        public LicenseType LicenseType { get; set; }


        internal static LicenseKey<T> LoadFromString(string p)
        {
            var str = FromUtf8Bytes(Convert.FromBase64String(p)).Split(':');
            var restrictions = JsonConvert.DeserializeObject<T>(FromUtf8Bytes(Convert.FromBase64String(str[6])));

            DateTime? releaseExpiry = null;
            string releaseExpiryStr = str[1];
            if (!string.IsNullOrWhiteSpace(releaseExpiryStr))
            {
                releaseExpiry = DateTime.ParseExact(releaseExpiryStr, "MM.dd.yyyy", CultureInfo.InvariantCulture);
            }

            DateTime? licenseExpiry = null;
            string licenseExpiryStr = str[2];
            if (!string.IsNullOrWhiteSpace(licenseExpiryStr))
            {
                licenseExpiry = DateTime.ParseExact(licenseExpiryStr, "MM.dd.yyyy", CultureInfo.InvariantCulture);
            }

            return new LicenseKey<T>
            {
                Ref = str[0],
                ReleaseExpiry = releaseExpiry,
                LicenseExpiry = licenseExpiry,
                CheckType = (LicenseCheckType)Byte.Parse(str[3]),
                LicenseType = (LicenseType)Byte.Parse(str[4]),
                WorkflowLicenseKey = str[5],
                Restrictions = restrictions, //6
                Hash = str[7],
            };
        }

        
        private static string FromUtf8Bytes(byte[] bytes)
        {
            if (bytes == null)
            {
                return null;
            }
            return Encoding.UTF8.GetString(bytes, 0, bytes.Length);
        }

        public LicenseKey<T> Clone()
        {
            var lk = (LicenseKey<T>)MemberwiseClone();
            lk.Restrictions = Restrictions = (T) Restrictions.Clone();
            return new LicenseKey<T>
            {
                Ref = Ref,
                ReleaseExpiry = ReleaseExpiry,
                LicenseExpiry = LicenseExpiry,
                Restrictions = (T)Restrictions.Clone(),
                WorkflowLicenseKey = WorkflowLicenseKey
            };
        }
    }
}