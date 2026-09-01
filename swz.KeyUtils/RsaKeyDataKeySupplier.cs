using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace swz.KeyUtils
{
    /// <summary>
    /// Supplies new instances of SecurityKey on demand based on RsaKeyData instances provided at construction time.
    /// A static factory methods to create from a folder of pem files or from matching certificates found in a location are 
    /// also provided.
    /// </summary>
    public class RsaKeyDataKeySupplier : IPublicKeySupplier, IPrivateKeySupplier
    {
        private const string LocalMachinePrefix = "LocalMachine:";
        private const string CurrentUserPrefix = "CurrentUser:";

        /// <summary>
        /// Utility method to create an instance from various sources as specified by a string which 
        /// indicates a file or path or store. (Later more options may be added, such as raw base64)
        /// Can load keys/certs from filesystem (file or folder) or if given a store location prefix
        /// i.e. LocalMachine: or CurrentUser: it will search stores in that location based on subject DN
        /// When searching a store, outdated certs will be ignored.
        /// 
        /// NOTE: the keys are retrieved from the source at instantiation time, not when the supplier is
        ///       asked to provided them. Changes to source after instantiation are therefore ignored during
        ///       the lifespan of the object.
        /// </summary>
        public static RsaKeyDataKeySupplier FromSource(
            string source, 
            bool ignoreNonCurrentCerts=true,
            bool ignoreUnverifiedCerts=false)
        {
            if (string.IsNullOrWhiteSpace(source)) 
                throw new ArgumentException("required", nameof(source));

            RsaKeyDataKeySupplier keySupplier;
            if (source.StartsWith(CurrentUserPrefix, StringComparison.CurrentCultureIgnoreCase))
            {   //CurrentUser:subject name
                StoreLocation location = StoreLocation.CurrentUser;
                string subject = source.Substring(CurrentUserPrefix.Length);
                keySupplier = FromStore(
                    location: location,
                    subjectDistinguishedName: new X500DistinguishedName(subject),
                    ignoreNonCurrentCerts: ignoreNonCurrentCerts,
                    ignoreUnverifiedCerts: ignoreUnverifiedCerts);
            }
            else if (source.StartsWith(LocalMachinePrefix, StringComparison.CurrentCultureIgnoreCase))
            {   //LocalMachine:subject name
                StoreLocation location = StoreLocation.LocalMachine;
                string subject = source.Substring(LocalMachinePrefix.Length);
                keySupplier = FromStore(
                    location: location,
                    subjectDistinguishedName: new X500DistinguishedName(subject),
                    ignoreNonCurrentCerts: ignoreNonCurrentCerts,
                    ignoreUnverifiedCerts: ignoreUnverifiedCerts);
            }
            else
            {   //Path to a single file or a folder containing only rsa keys/certs
                keySupplier = FromFileOrFolder(
                    path: source,
                    ignoreNonCurrentCerts: ignoreNonCurrentCerts,
                    ignoreUnverifiedCerts: ignoreUnverifiedCerts);
            }
            return keySupplier;
        }

        /// <summary>
        /// Will find certs in the specified store that match the subjectDistinguished name and return an instance
        /// of RsaKeyDataSupplier that wraps the RsaKeyData of them. 
        /// </summary>
        /// <param name="location"></param>
        /// <param name="subjectDistinguishedName"></param>
        /// <param name="ignoreNonCurrentCerts">set to true to exclude certs that are expired or not valid yet</param>
        /// <param name="ignoreUnverifiedCerts">set to true to exclude certs that cannot be verified</param>
        /// <returns>supplier</returns>
        public static RsaKeyDataKeySupplier FromStore(
            StoreLocation location,
            X500DistinguishedName subjectDistinguishedName,
            bool ignoreNonCurrentCerts = false,
            bool ignoreUnverifiedCerts = false)
        {
            if (subjectDistinguishedName == null) throw new ArgumentNullException(nameof(subjectDistinguishedName));
            X509Certificate2Collection collection = CertificateUtils.FindCertificatesInStores(location, subjectDistinguishedName);
            try
            {
                return FromCollection(collection, ignoreNonCurrentCerts, ignoreUnverifiedCerts);
            }
            finally
            {
                CertificateUtils.DisposeAll(collection);
            }
        }

        public static RsaKeyDataKeySupplier FromFileOrFolder(
            string path,
            bool ignoreNonCurrentCerts = false,
            bool ignoreUnverifiedCerts = false)
        {
            if (string.IsNullOrWhiteSpace(path)) throw new ArgumentException("must be specified", nameof(path));
            
            List<RsaKeyData> allKeysData =
                FindFiles(path)
                .Select(individualFilePath => RsaKeyData.ReadFromFile(individualFilePath))
                .ToList();
            return FromCollection(allKeysData);
        }

        public static RsaKeyDataKeySupplier FromCollection(
            X509Certificate2Collection collection,
            bool ignoreNonCurrentCerts = false,
            bool ignoreUnverifiedCerts = false)
        {
            if (collection == null) throw new ArgumentNullException(nameof(collection));
            List<RsaKeyData> allKeysData = RsaKeyData.FromCollection(collection);
            return FromCollection(allKeysData, ignoreNonCurrentCerts, ignoreUnverifiedCerts);
        }

        public static RsaKeyDataKeySupplier FromCollection(
            IEnumerable<RsaKeyData> allKeysData,
            bool ignoreNonCurrentCerts = false,
            bool ignoreUnverifiedCerts = false)
        {
            if (allKeysData == null) throw new ArgumentNullException(nameof(allKeysData));

            bool checkCerts = (ignoreNonCurrentCerts || ignoreUnverifiedCerts);
            if (checkCerts)
            {
                DateTime now = DateTime.Now; //local timezone (which is what X509Certificate2 properties also use)
                allKeysData = allKeysData.Where(keyData =>
                {
                    if (keyData.Format == RsaKeyData.KeyFormat.X509Certificate)
                    {
                        using (X509Certificate2 cert = keyData.Certificate())
                        {
                            if (ignoreNonCurrentCerts && (now < cert.NotBefore || now > cert.NotAfter))
                                return false;

                            if (ignoreUnverifiedCerts && !cert.Verify())
                                return false;
                        }
                    }
                    return true;
                }).ToList();
            }

            List<RsaKeyData> publicKeysData = allKeysData.Where(keyData => keyData.IsPublic).ToList();
            List<RsaKeyData> privateKeysData = allKeysData.Where(keyData => keyData.IsPrivate).ToList();

            return new RsaKeyDataKeySupplier(publicKeysData, privateKeysData);
        }

        /// <summary>
        /// Given a path will determine if its a directory or a single file and return a collection of paths
        /// that consists of either the single file specified or all the files in the directory specified.
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        private static List<string> FindFiles(string path)
        {
            try
            {
                FileAttributes a = File.GetAttributes(path);
                if (FileAttributes.Directory == (a & FileAttributes.Directory))
                {
                    return new List<string>(Directory.GetFiles(path));
                }
                else
                {
                    return new List<string>() { path };
                }
            }
            catch (Exception e)
            {
                throw new Exception($"Error searching path {path} for files", e);
            }
        }

        // // // // // // // // // // // // // // // // // // // // //

        private readonly List<RsaKeyData> publicKeysData;
        private readonly List<RsaKeyData> privateKeysData;

        public int PublicCount { get => publicKeysData.Count; }

        public int PrivateCount { get => privateKeysData.Count; }

        public int Count { get => PublicCount + PrivateCount; }

        public RsaKeyDataKeySupplier(IEnumerable<RsaKeyData> publicKeysData, IEnumerable<RsaKeyData> privateKeysData)
        {
            this.publicKeysData
                = ((publicKeysData == null)
                ? new List<RsaKeyData>()
                : new List<RsaKeyData>(publicKeysData))
                .OrderByDescending(rkd => rkd.NotAfter) //prioritise dated keys
                .ToList();

            this.privateKeysData
                = ((privateKeysData == null)
                ? new List<RsaKeyData>()
                : new List<RsaKeyData>(privateKeysData))
                .OrderByDescending(rkd => rkd.NotAfter) //prioritise dated keys
                .ToList();
        }

        public Task<List<SecurityKey>> PublicKeys()
        {
            //TODO - where its from a cert we should ignore those out of date ones (implies keeping that info in KeyData)
            //or maybe we verify now? 
            return Task.FromResult( publicKeysData.Select(keyData => keyData.PublicSecurityKey()).ToList() );
        }

        public Task<List<SecurityKey>> PrivateKeys()
        {
            //TODO - where its from a cert we should ignore those out of date ones (implies keeping that info in KeyData)
            return Task.FromResult(privateKeysData.Select(keyData => keyData.PrivateSecurityKey()).ToList());
        }

    }

}
