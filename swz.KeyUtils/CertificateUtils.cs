using System;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace swz.KeyUtils
{
    /// <summary>
    /// Some utility methods related to X509Certificate2
    /// </summary>
    public static class CertificateUtils
    {
        //TODO - add IsPrivateKeyExportable (in which case RsaKeyData can't be used for private key and caller
        //       would need to use something else)

        /// <summary>
        /// Given a subjectDistinuguishedName will look in the specified store for matching certificates.
        /// If none are found then an empty collection is returned.
        /// NOTE: stores in the location that cannot be opened (e.g. due to permissions issues) will be skipped
        /// </summary>
        /// <param name="location">indicates whether to look in current user store or machine store</param>
        /// <param name="subjectDistinguishedName"></param>
        /// <returns>collection of matching certificates or en empty collection if none</returns>
        public static X509Certificate2Collection FindCertificatesInStores(StoreLocation location, X500DistinguishedName subjectDistinguishedName)
        {
            if (subjectDistinguishedName == null) throw new ArgumentNullException(nameof(subjectDistinguishedName));
            X509Certificate2Collection certs = new X509Certificate2Collection();
            foreach (StoreName storeName in (StoreName[])Enum.GetValues(typeof(StoreName)))
            {
                X509Store store = new X509Store(storeName, location);
                try
                {
                    store.Open(OpenFlags.OpenExistingOnly);
                    X509Certificate2Collection foundCerts
                            = store.Certificates.Find(X509FindType.FindBySubjectDistinguishedName, subjectDistinguishedName.Name, validOnly: false);
                    foreach (var foundCert in foundCerts) certs.Add(foundCert);
                }
                catch (CryptographicException)
                {
                    ; //Some stores cannot be opened, so these we will ignore and continue searching the rest
                }
            }
            return certs;
        }

        /// <summary>
        /// Syntactic sugar to iterate the collection and call Dispose on each cert
        /// NOTE: this does not catch any exceptions that Dispose might raise
        /// </summary>
        /// <param name="collection">a collection of certificates or null</param>
        public static void DisposeAll(X509Certificate2Collection collection)
        {
            if(collection != null)
                foreach (X509Certificate2 cert in collection) 
                    cert.Dispose();
        }

        //TODO - add password support for loading
        //TODO - consider adding args to specify exportability and protection (password) of the private key in the new instance
        /// <summary>
        /// Construct an instance of X509Certificate2 from bytes. 
        /// Will use X509Certificate2.GetCertContentType to determine how to construct for supported types
        /// (i.e. PKCS12, PKCS7, Cert, while unsupported types will raise an ArgumentException).
        /// NOTE: this method does not currently support password protected certificates
        /// </summary>
        /// <param name="certificateBytes">raw cert bytes</param>
        /// <returns>certificate</returns>
        public static X509Certificate2 ConstructCertificate(byte[] certificateBytes)
        {
            const string NoPassword = null;

            X509ContentType type = X509Certificate2.GetCertContentType(certificateBytes);
            switch (type)
            {
                case X509ContentType.Pkcs12: //PFX
                    return X509CertificateLoader.LoadPkcs12(certificateBytes, NoPassword, X509KeyStorageFlags.Exportable | X509KeyStorageFlags.EphemeralKeySet);

                //Public key only
                case X509ContentType.Pkcs7: //PEM or DER encoding
                case X509ContentType.Cert:
                    return X509CertificateLoader.LoadCertificate(certificateBytes);

                case X509ContentType.SerializedStore:
                case X509ContentType.SerializedCert:
                case X509ContentType.Authenticode:
                case X509ContentType.Unknown:
                default:
                    throw new ArgumentException($"Certificate type {type.ToString()} is not supported here", nameof(certificateBytes));
            }
        }

        /// <summary>
        /// Returns true if the certificate is for RSA keys.
        /// Will return false if passed null or if the OID of the public key is not for RSA
        /// </summary>
        public static bool IsRsaKey(X509Certificate2 certificate)
        {
            return (certificate?.PublicKey?.Oid?.Value??"")
                .Equals("1.2.840.113549.1.1.1", StringComparison.Ordinal); //standard OID for RSA
        }
    }
}
