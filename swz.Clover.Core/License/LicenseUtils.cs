using System;
using System.Collections.Concurrent;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.License
{
    public static class LicenseHelper
    {
        /// <summary>
        /// Expose some information about the current Clover license (for troubleshooting) as a human friendly string
        /// </summary>
        /// <returns></returns>
        public static string CloverLicenseDescription()
        {
            try
            {
                LicenseKey<CloverRestrictions> key = Licensing.GetLicense<CloverRestrictions>();
                if (key == null) return "null"; //should be possible with current code, instead we would get exception
                string users = (key.Restrictions.MaxNumberOfUsers > 0) ? key.Restrictions.MaxNumberOfUsers.ToString() : "unlimited";
                string expiry = (key.LicenseExpiry == null) 
                    ? "with no expiry date" 
                    : "expiring " + ((DateTime)key.LicenseExpiry).ToString("s", System.Globalization.CultureInfo.InvariantCulture);

                return $"{key.LicenseType} license registered to {key.Ref} for {users} users {expiry}";
            }
            catch(Exception e)
            {
                return "Unable to get license information, reason=" + e.Message;
            }
        }

        /// <summary>
        /// Expose license expiry date info
        /// </summary>
        /// <returns></returns>
        public static DateTime? CloverLicenseExpiry()
        {
            try
            {
                LicenseKey<CloverRestrictions> key = Licensing.GetLicense<CloverRestrictions>();
                if (key == null) return null; 
                DateTime? expiry = key.LicenseExpiry;
                return expiry;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }

    /// <summary>
    /// License help methods
    /// </summary>
    internal static class Licensing
    {
        public const int DefaultMaxNumberOfThreads = 2;

        //Public key cannot be used to sign, so is not considered particularly sensitive
        private const string LicensePublicKey = "<RSAKeyValue><Modulus>v2lawBYrAZyiEDhMtAObg2rfyawBgabYgXYbveQUbT9yGeJbP3n7pZZkDAPwZv3APOdnXJCXLw44jNl9QzKU413pYbpGXYscK0CdQvwPQdEYmDtFPFE3cJgJFGSvMISYXuiWdPQLFDxm8qbJyBH9m6U1XSTPf2Kvg0qFVwDxuYU=</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";

        private static string _hardwareId;
        //private static readonly Dictionary<Type, object> Licenses = new Dictionary<Type, object>();
        private static readonly ConcurrentDictionary<Type, object> Licenses = new ConcurrentDictionary<Type, object>(); //20230310

        private static readonly LicenseKey<CloverRestrictions> DefaultClover = new LicenseKey<CloverRestrictions>()
        {
            Ref = "Clover Demo",
            Restrictions = new CloverRestrictions
            {
                MaxNumberOfInstances = 1,
                MaxNumberOfUsers = 5,
                MaxNumberOfForms = 5,
                MaxNumberOfThreads = 1,
                MaxNumberOfWorkflow = 1
            }
        };

        static Licensing()
        {
            _hardwareId = HardwareInfo.Value();
            //Licenses.Add(typeof(CloverRestrictions), DefaultClover);
            Licenses[typeof(CloverRestrictions)] = DefaultClover;
            //20220817 - Removed the assemblyDate for now as the method we used to get it no longer works in current netcore.
            //           See: https://stackoverflow.com/a/1600990
        }

        internal static void RegisterDefaultCLOVER()
        {
            //if (!Licenses.ContainsKey(typeof(CloverRestrictions)))
            //{
            //    Licenses.Add(typeof(CloverRestrictions), DefaultClover);
            //}
            //else
            //{
            //    Licenses[typeof(CloverRestrictions)] = DefaultClover;
            //}
            //Just use indexer to set or replace, see https://stackoverflow.com/a/21584960/8243046
            //And Add is not longer applicable with the change to ConcurrentDictionary
            Licenses[typeof(CloverRestrictions)] = DefaultClover;
        }

        public static LicenseKey<T> GetLicense<T>() where T : BaseRestrictions
        {
            var licenseKey = Licenses[typeof (T)] as LicenseKey<T>;
            if (licenseKey != null)
                return licenseKey.Clone();
            CloverRuntime.LicenseControl.Message = $"License of type {typeof(T).Name} not found. Use '{_hardwareId}' to request for a license key";
            throw new LicenseException(CloverRuntime.LicenseControl.Message);
        }

        /// <summary>
        /// Calling this is equivalent to calling GetLicenseRestrictions&lt;CloverRestrictions&gt;().MaxNumberOfUsers but this is a
        /// shortcut mechanism to get the max number of users without needing to make a defensive copy of the Restrictions object.
        /// (optimisation). 
        /// </summary>
        /// <returns></returns>
        public static int GetMaxNumberOfCloverUsers()
        {
            LicenseKey<CloverRestrictions> licenseKey = Licenses[typeof (CloverRestrictions)] as LicenseKey<CloverRestrictions>;
            if (licenseKey == null)
            {
                //Rather than copy and paste the error logic to throw an exception for no license key I'll fallback to calling the real
                //GetLicenseRestrictions and let it do it. (So the .MaxNumberOfUsers is technically superflous with current behaviour
                //but if we change that behaviour to return some default object or something like that then it still won't break this)
                return GetLicenseRestrictions<CloverRestrictions>().MaxNumberOfUsers; 
            }
            return licenseKey.Restrictions.MaxNumberOfUsers;
        }
        
        public static T GetLicenseRestrictions<T>() where T : BaseRestrictions
        {
            var licenseKey = Licenses[typeof (T)] as LicenseKey<T>;
            if (licenseKey != null)
                return (T) licenseKey.Restrictions.Clone();
            CloverRuntime.LicenseControl.Message = $"License of type {typeof(T).Name} not found. Use '{_hardwareId}' to request for a license key";
            throw new LicenseException(CloverRuntime.LicenseControl.Message);
        }

        internal static void RegisterLicense<T>(string licenseText) where T : BaseRestrictions
        {
            LicenseKey<T> license;

            var result = VerifyLicenseKeyText(licenseText, out license);

            if (!result)
            {
                CloverRuntime.LicenseControl.Message = $"Incorrect license. Use {_hardwareId} to request for a license key";
                throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }

            //if (!Licenses.ContainsKey(typeof (T)))
            //{
            //    Licenses.Add(typeof(T),license);
            //}
            //else
            //{
            //    Licenses[typeof (T)] = license;
            //}
            //Just use indexer to set or replace, see https://stackoverflow.com/a/21584960/8243046
            //And Add is not longer applicable with the change to ConcurrentDictionary
            Licenses[typeof(T)] = license;

            CloverRuntime.LicenseControl.Message = null;
        }
        
        internal static string GetWorkflowLicenseKey(string licenseText)
        {
            LicenseKey<CloverRestrictions> license;

            var result = VerifyLicenseKeyText(licenseText, out license);

            if (!result)
            {
                CloverRuntime.LicenseControl.Message = $"Incorrect workflow license. Use {_hardwareId} to request for a license key";
                throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }

            return license.WorkflowLicenseKey;
        }

        private static bool VerifyLicenseKeyText<T>(this string licenseKeyText, out LicenseKey<T> key) where T : BaseRestrictions
        {
            var rsa = new RSACryptoServiceProvider();
            rsa.FromXmlStringForNetCore(LicensePublicKey);
            var rsaParameter = rsa.ExportParameters(false);
            key = CheckAndReturnLicenseKey<T>(licenseKeyText);
            byte[] utf8Bytes = Encoding.UTF8.GetBytes(GetHashKeyToSign(key));
            byte[] numArray = Convert.FromBase64String(key.Hash);
            return VerifySignedHash(utf8Bytes, numArray, rsaParameter);
        }

        /// <summary>
        /// Convert the key text into a LicenseKey object, checking that it is valid for this machine and date in the process.
        /// Does not check the signature on the license. (That happens in VerifyLicenseKeyText which calls this and uses the
        /// returned LicenseKey object's bytes for the signature check)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="licenseKeyText">text from the license file</param>
        /// <returns>licenseKey</returns>
        /// <exception cref="LicenseException"></exception>
        private static LicenseKey<T> CheckAndReturnLicenseKey<T>(string licenseKeyText) where T : BaseRestrictions
        {
            string[] strArrays = SplitOnFirst(licenseKeyText, '-');
            string refStr = strArrays[0];
            string licenseStr = strArrays[1];
            var licenseKey = LicenseKey<T>.LoadFromString(licenseStr);

            if (licenseKey.Ref != refStr)
            {
                CloverRuntime.LicenseControl.Message = $"The license '{licenseKey.Ref}' is not assigned to CustomerId '{refStr}'. Use '{_hardwareId}' to request for a license key";
                throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }

            string coFactor 
                = (CloverRuntime.LicenseControl.PerServer ? _hardwareId : "") 
                + (CloverRuntime.LicenseControl.DomainNameRequired ? CloverRuntime.LicenseControl.Host : "");

            string udid = HashHelper
                .FromString(coFactor)
                .ToString().Replace("-", "");

            string[] licenseDetails = licenseKey.Ref.Contains("|") ? licenseKey.Ref.Split('|') : null;
            if (licenseDetails==null || licenseDetails[1] != udid)
            {
                CloverRuntime.LicenseControl.Message =
                    $"The installed license is not assigned to this server or domain. Use '{_hardwareId}' to request for a license key for '{CloverRuntime.LicenseControl.Host}'";
                throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }

            //20220817 - Commented out the assemblyDate check as the method we used to get it no longer works in current netcore
            //           For now we will deprecate this check and rely on the LicenseExpiry only (ignoring releaseExpiry)
            /*if (licenseKey.ReleaseExpiry < _assemblyDate.Date)
            {
                throw new LicenseException($"The license '{licenseKey.Ref}' is expired.");
            }*/

            if (licenseKey.LicenseExpiry.HasValue && licenseKey.LicenseExpiry < DateTime.Today)
            {
                CloverRuntime.LicenseControl.Message = $"The license '{licenseKey.Ref}' is expired. Use '{_hardwareId}' to request for a license key";
                throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }

            return licenseKey;
        }

        private static string[] SplitOnFirst(string strVal, char needle)
        {
            if (strVal == null)
            {
                return new string[0];
            }
            var num = strVal.IndexOf(needle);
            if (num == -1)
            {
                return new[] {strVal};
            }
            var strArrays = new[] {strVal.Substring(0, num), strVal.Substring(num + 1)};
            return strArrays;
        }

        private static bool VerifySignedHash(byte[] dataToVerify, byte[] signedData, RSAParameters key)
        {
            try
            {
                var rsaCryptoServiceProvider = new RSACryptoServiceProvider();
                rsaCryptoServiceProvider.ImportParameters(key);
                return rsaCryptoServiceProvider.VerifyData(dataToVerify, SHA1.Create(), signedData);

            }
            catch (CryptographicException)
            {
                return false;
            }
         }

        public static string LicenseKeyToString<T>(LicenseKey<T> key) where T : BaseRestrictions
        {
            var licenseWithoutHash = GetHashKeyToSign(key);
            var licenseString = $"{licenseWithoutHash}:{key.Hash}";
            return $"{key.Ref}-{Convert.ToBase64String(Encoding.UTF8.GetBytes(licenseString))}";
        }

        public static string GetHashKeyToSign<T>(LicenseKey<T> key) where T : BaseRestrictions
        {
            var releaseExpire = key.ReleaseExpiry?.ToString("MM.dd.yyyy");
            var licenseExpire = key.LicenseExpiry?.ToString("MM.dd.yyyy");
            var checkType = ((byte)key.CheckType).ToString();
            var type = ((byte)key.LicenseType).ToString();
            var restrictions = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(key.Restrictions)));
            var licenseString = $"{key.Ref}:{releaseExpire}:{licenseExpire}:{checkType}:{type}:{key.WorkflowLicenseKey}:{restrictions}";
            return licenseString;
        }

        /// <summary>
        /// Thrown by RetrieveLinkerTimestamp() if it is unable to detemine the timestamp.
        /// You can refer to the inner exceptions for finer details on the cause.
        /// </summary>
        public class LinkerTimestampRetrievalException : Exception
        {
            public LinkerTimestampRetrievalException(string message, Exception innerException) : base(message, innerException) { }
        }
    }
}