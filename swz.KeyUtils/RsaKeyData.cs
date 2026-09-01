using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace swz.KeyUtils
{
    public class RsaKeyDataReadException : Exception
    {
        public RsaKeyDataReadException(string message, Exception inner) : base(message, inner) { }
    }

    public class RsaKeyDataPemReadException : RsaKeyDataReadException
    {
        public RsaKeyDataPemReadException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Utility object for reading key/certificate data from PEM or pfx files and stashing the bytes 
    /// for use later without needing to keep a reference to any managed object. This helps abstract away
    /// some of the finer details of using the various cert and cipher objects, in particular the fiddly
    /// lifecycle and mutability aspects (e.g. avoiding the dreaded ObjectDisposedException you might get 
    /// when an underlying object to a SecurityKey goes out of scope and is disposed while the key instance
    /// itself is still in use).
    /// RsaKeyData is basically a warpper around a byte array. You can create an instance from various types
    /// of keys and it will extract out the raw bytes, keep track of their format, and later let you use them
    /// to create SecurityKey instances. 
    /// Note that this means you can't use it for the case of non-exportable private keys (such as 
    /// non-exportable keys in a windows certificate store, hardware security module, or AWS MKS / Azure 
    /// Key Vault, etc... Because of the very nature of its design and intent it isn't holding a reference 
    /// to the original RSA instance. This implies some performance & scaling implications for creating
    /// instances of RsaSecurityKey because it needs to instantiate a temporary RSA instance. 
    /// Bear these constraints in mind when using this class. It is convenient, but there are trade offs.
    /// Instances of this class are immutable once constructed and may be safely shared across threads.
    /// It also plays host to various related static utility methods that work with various types of 
    /// rsa key data bytes.
    /// </summary>
    public class RsaKeyData
    {
        /// <summary>
        /// Start marker for an X509 Certificate
        /// </summary>
        /// 
        public const string BEGIN_CERTIFICATE       = "-----BEGIN CERTIFICATE-----";
        /// <summary>
        /// End marker for an X509 Certificate
        /// </summary>
        public const string END_CERTIFICATE         = "-----END CERTIFICATE-----";

        /// <summary>
        /// Start marker for an X509 Public Key (SubjectPublicKeyInfo)
        /// </summary>
        public const string BEGIN_PUBLIC_KEY        = "-----BEGIN PUBLIC KEY-----";

        /// <summary>
        /// End marker for an X509 Public Key
        /// </summary>
        public const string END_PUBLIC_KEY          = "-----END PUBLIC KEY-----";

        /// <summary>
        /// Start marker for a PKCS1 Public Key 
        /// (RSA only)
        /// </summary>
        public const string BEGIN_RSA_PUBLIC_KEY    = "-----BEGIN RSA PUBLIC KEY-----";

        /// <summary>
        /// End marker for a PKCS1 Public Key
        /// </summary>
        public const string END_RSA_PUBLIC_KEY      = "-----END RSA PUBLIC KEY-----";

        /// <summary>
        /// Start marker for a PKCS8 Private Key
        /// (PKCS#8 is a universal container for private keys of any algorithm including RSA)
        /// </summary>
        public const string BEGIN_PRIVATE_KEY       = "-----BEGIN PRIVATE KEY-----";

        /// <summary>
        /// End marker for a PKCS8 Private Key
        /// </summary>
        public const string END_PRIVATE_KEY         = "-----END PRIVATE KEY-----";

        /// <summary>
        /// Start marker for a PKCS1 Private Key
        /// (RSA only)
        /// </summary>
        public const string BEGIN_RSA_PRIVATE_KEY   = "-----BEGIN RSA PRIVATE KEY-----";

        /// <summary>
        /// End marker for a PKCS1 Private Key
        /// </summary>
        public const string END_RSA_PRIVATE_KEY     = "-----END RSA PRIVATE KEY-----";

        /// <summary>
        /// Enumeration of formats for key bytes
        /// n.b. X509Certificate conflates several formats like X509 or PKCS12
        /// </summary>
        public enum KeyFormat { X509Certificate, X509PublicKey, Pkcs1PublicKey, Pkcs8PrivateKey, Pkcs1PrivateKey }

        //TODO: public static List<PemData> ReadPemsFromFile(string path)
        //      will find all the begin/end markers and extract all the blocks (for multi block files)

        /// <summary>
        /// Factory method that will read the .pfx or .p12 or first block of pem data from the file. 
        /// (For PEM file must start with one of the BEGIN markers & additional blocks are ignored.)
        /// Note that most types have no verification that the bytes are valid 
        /// (for a certificate it may try to instantiate and read extra metadata though)
        /// n.b. pfx with a password are not currently supported
        /// </summary>
        /// <param name="path">Path to file, if ends with .p12 or .pfx assumes PKCS12, 
        /// otherwise assumes a PEM that starts with one of the supported markers</param>
        /// <returns>New instance of RsaKeyData</returns>
        public static RsaKeyData ReadFromFile(string path)
        {
            if (string.IsNullOrWhiteSpace(path)) throw new ArgumentException("must be specified", nameof(path));

            try
            {
                //A PKCS#12 file (often ending in .p12 or .pfx) physically contains private keys
                if (path.EndsWith(".pfx", StringComparison.InvariantCultureIgnoreCase)
                    || path.EndsWith(".p12", StringComparison.InvariantCultureIgnoreCase))
                {
                    byte[] fileBytes = File.ReadAllBytes(path);
                    using (X509Certificate2 certificate = CertificateUtils.ConstructCertificate(fileBytes))
                    {
                        //nb: we don't support password protecting from export
                        return new RsaKeyData(certificate);
                    }
                }
            }
            catch(Exception e)
            {
                throw new RsaKeyDataReadException($"Failed to read pkcs12 data from {path}", e);
            }

            try
            {
                //otherwise assume its a PEM of some sort and try to read that
                string pem = System.IO.File.ReadAllText(path, System.Text.Encoding.ASCII);
                if(pem.StartsWith(BEGIN_CERTIFICATE))
                { 
                    return new RsaKeyData(KeyFormat.X509Certificate, ExtractPemData(pem, BEGIN_CERTIFICATE, END_CERTIFICATE));
                }
                else if(pem.StartsWith(BEGIN_PUBLIC_KEY))
                {
                    return new RsaKeyData(KeyFormat.X509PublicKey, ExtractPemData(pem, BEGIN_PUBLIC_KEY, END_PUBLIC_KEY));
                }
                else if (pem.StartsWith(BEGIN_RSA_PUBLIC_KEY))
                {
                    return new RsaKeyData(KeyFormat.Pkcs1PublicKey, ExtractPemData(pem, BEGIN_RSA_PUBLIC_KEY, END_RSA_PUBLIC_KEY));
                }
                else if (pem.StartsWith(BEGIN_PRIVATE_KEY))
                {
                    return new RsaKeyData(KeyFormat.Pkcs8PrivateKey, ExtractPemData(pem, BEGIN_PRIVATE_KEY, END_PRIVATE_KEY));
                }
                else if (pem.StartsWith(BEGIN_RSA_PRIVATE_KEY))
                {
                    return new RsaKeyData(KeyFormat.Pkcs1PrivateKey, ExtractPemData(pem, BEGIN_RSA_PRIVATE_KEY, END_RSA_PRIVATE_KEY));
                }
                else
                {
                    throw new NotImplementedException($"Unsupported file type {path}");
                }                
            }
            catch (Exception e)
            {
                throw new RsaKeyDataPemReadException($"Failed to read PEM data from {path}", e);
            }
        }

        /// <summary>
        /// Reads PEM data between the startMarker and endMarker from the specified ASCII file.
        /// An exception is raised if there is an error.
        /// (This calls ExtractPemData once the file is read)
        /// </summary>
        /// <param name="keyPath">path to the PEM file</param>
        /// <param name="startMarker">text after which to start extracting</param>
        /// <param name="endMarker">text before which to stop extracting</param>
        /// <returns></returns>
        public static byte[] ReadPemData(string keyPath, string startMarker, string endMarker)
        {
            try
            {
                string pem = System.IO.File.ReadAllText(keyPath, System.Text.Encoding.ASCII);
                byte[] key = ExtractPemData(pem, startMarker, endMarker);
                return key;
            }
            catch (Exception e)
            {
                throw new Exception("Failed to extract bytes from file", e);
            }
        }

        /// <summary>
        /// Extract data from an ascii cert or key file that has start and end markers
        /// wrapping a bunch of base64 with linebreaks
        /// </summary>
        /// <param name="fileContent">text content of the PEM file (should be ASCII)</param>
        /// <param name="startMarker">text after which to start extracting</param>
        /// <param name="endMarker">text before which to stop extracting</param>
        /// <returns>data</returns>
        public static byte[] ExtractPemData(string fileContent, string startMarker, string endMarker)
        {
            if (string.IsNullOrWhiteSpace(fileContent)) throw new ArgumentException(nameof(fileContent));
            if (string.IsNullOrEmpty(startMarker)) throw new ArgumentException(nameof(startMarker));
            if (string.IsNullOrEmpty(endMarker)) throw new ArgumentException(nameof(endMarker));
            try
            {
                int start = fileContent.IndexOf(startMarker) + startMarker.Length;
                int end = fileContent.IndexOf(endMarker); //todo - search only after start
                //TODO - sanity check on start and end
                string block = fileContent.Substring(start, (end - start))
                    .Replace("\n", null)
                    .Replace("\r", null);
                byte[] data = Convert.FromBase64String(block);
                return data;
            }
            catch (Exception e)
            {
                throw new ArgumentException("Invalid block or markers", e);
            }
        }

        /// <summary>
        /// Given an instance of X509Certificate2, create an instance of RsaSecurityKey containing the public key.
        /// Will use rsa.ExportParameters internally so that it is safe for caller to dispose the X509Certificate2
        /// when desired without fear of the RsaSecurityKey retaining a reference to it.
        /// </summary>
        /// <param name="certificate"></param>
        /// <returns>key</returns>
        public static RsaSecurityKey PublicSecurityKeyFromX509Certificate(X509Certificate2 certificate)
        {
            if (certificate == null)
                throw new ArgumentNullException(nameof(certificate));
            if (!CertificateUtils.IsRsaKey(certificate))
                throw new ArgumentException($"certificate {certificate.SerialNumber} is not RSA", nameof(certificate));
            using (RSA rsa = certificate.GetRSAPublicKey())
            {
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: false))
                {
                    KeyId = certificate.Thumbprint,
                };
            }
        }

        //TODO - password support
        /// <summary>
        /// Given an X509Certificate2, create an instance of RsaSecurityKey.
        /// NOTE: currently this does not support password protected certs and the key must be exportable
        /// (If the key is not exportable then a CryptographicException is raised)
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PrivateSecurityKeyFromX509Certificate(X509Certificate2 certificate)
        {
            if (certificate == null)
                throw new ArgumentNullException(nameof(certificate));
            if (!CertificateUtils.IsRsaKey(certificate))
                throw new ArgumentException($"certificate {certificate.SerialNumber} is not RSA", nameof(certificate));
            if (!certificate.HasPrivateKey) throw new InvalidOperationException($"certificate {certificate.SerialNumber} does not contain a private key");
            using (RSA rsa = certificate.GetRSAPrivateKey())
            {
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: true))
                {
                    KeyId = certificate.Thumbprint,
                };
            }
        }

        /// <summary>
        /// Given the bytes of an RSA public key in X509 certificate format, create an instance of RsaSecurityKey.
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PublicSecurityKeyFromX509Certificate(byte[] certificateBytes)
        {
            if (certificateBytes == null || certificateBytes.Length == 0)
                throw new ArgumentException("byte array may not be null or empty", nameof(certificateBytes));
            using (X509Certificate2 cert = CertificateUtils.ConstructCertificate(certificateBytes))
            {
                return PublicSecurityKeyFromX509Certificate(cert);
            }
        }

        /// <summary>
        /// Given the bytes of an RSA public key in X509 key format, create an instance of RsaSecurityKey.
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PublicSecurityKeyFromX509Key(byte[] keyBytes)
        {
            if (keyBytes == null || keyBytes.Length == 0) 
                throw new ArgumentException("byte array may not be null or empty", nameof(keyBytes));
            using (RSA rsa = RSA.Create())
            {
                rsa.ImportSubjectPublicKeyInfo(keyBytes, out _);
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: false));
            }
        }

        /// <summary>
        /// Given the bytes of an RSA public key in PKCS1 format, create an instance of RsaSecurityKey.
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PublicSecurityKeyFromPkcs1(byte[] keyBytes)
        {
            if (keyBytes == null || keyBytes.Length == 0) 
                throw new ArgumentException("byte array may not be null or empty", nameof(keyBytes));
            using (RSA rsa = RSA.Create())
            {
                rsa.ImportRSAPublicKey(keyBytes, out _);
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: false));
            }
        }

        //TODO - password support
        /// <summary>
        /// Given the bytes of an RSA private key in X509 certificate format, create an instance of RsaSecurityKey.
        /// NOTE: currently this does not support password protected certs
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PrivateSecurityKeyFromX509Certificate(byte[] certificateBytes)
        {
            if (certificateBytes == null || certificateBytes.Length == 0) 
                throw new ArgumentException("byte array may not be null or empty", nameof(certificateBytes));
            using (X509Certificate2 cert = CertificateUtils.ConstructCertificate(certificateBytes))
            {
                return PrivateSecurityKeyFromX509Certificate(cert);
            }
        }

        /// <summary>
        /// Given the bytes of an RSA private key in PKCS8 format, create an instance of RsaSecurityKey
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PrivateSecurityKeyFromPkcs8(byte[] keyBytes)
        {
            if (keyBytes == null || keyBytes.Length == 0)
                throw new ArgumentException("byte array may not be null or empty", nameof(keyBytes));
            using (RSA rsa = RSA.Create())
            {
                rsa.ImportPkcs8PrivateKey(keyBytes, out _);
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: true));
            }
        }

        /// <summary>
        /// Given the bytes of an RSA private key in PKCS1 format, create an instance of RsaSecurityKey.
        /// </summary>
        /// <param name="keyBytes">bytes</param>
        /// <returns>key</returns>
        public static RsaSecurityKey PrivateSecurityKeyFromPkcs1(byte[] keyBytes)
        {
            if (keyBytes == null || keyBytes.Length == 0)
                throw new ArgumentException("byte array may not be null or empty", nameof(keyBytes));
            using (RSA rsa = RSA.Create())
            {
                rsa.ImportRSAPrivateKey(keyBytes, out _);
                return new RsaSecurityKey(rsa.ExportParameters(includePrivateParameters: true));
            }
        }

        /// <summary>
        /// Given an X509Certificate2Collection will create an instance of RsaKeyData for each item in the collection.
        /// NOTE: this method does not currently support password protected certs
        /// </summary>
        /// <param name="collection">x509 cert collection</param>
        /// <returns>list of keys</returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static List<RsaKeyData> FromCollection(X509Certificate2Collection collection)
        {
            if (collection == null) throw new ArgumentNullException(nameof(collection));
            List<RsaKeyData> keysData = new List<RsaKeyData>();
            foreach(X509Certificate2 certificate in collection)
            {
                keysData.Add(new RsaKeyData(certificate));
            }
            return keysData;
        }

        /// <summary>
        /// Constant used for password arg to make it clear to reader that we explicitly aren't passing a password here
        /// </summary>
        private const string NoPassword = null;

        // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. DO NOT ADD PUBLIC SETTERS!//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        private byte[] value;

        /// <summary>
        /// Identifies the format of the value bytes stored in this instance.
        /// NOTE: This might be different to the format of the object or bytes that were used to initially create this instance.
        /// </summary>
        public KeyFormat Format { get; private set; }

        /// <summary>
        /// Returns the certificate's NotBefore date
        /// Only applicable when Format is X509Certificate (null for other formats)
        /// </summary>
        public DateTime? NotBefore { get; private set; } = null;

        /// <summary>
        /// Returns the certificate's NotAfter date
        /// Only applicable when Format is X509Certificate (null for other formats)
        /// </summary>
        public DateTime? NotAfter { get; private set; } = null;

        /// <summary>
        /// Returns the certificate's Thumbprint
        /// Only applicable when Format is X509Certificate (null for other formats)
        /// </summary>
        public string Thumbprint { get; private set; } = null;

        /// <summary>
        /// When constructed from bytes of a certificate this internal flag notes whether it also contains a private key
        /// </summary>
        private bool isCertificateWithPrivateKey = false;

        //TODO - add support for password protected certs
        /// <summary>
        /// Constructs an instance from an X509Certificate2.
        /// Caller is responsible for the disposal of the certificate.
        /// RsaKeyData does not retain a reference to the certificate instance and caller can safely dispose it when desired.
        /// This constructor will also initialise the NotBefore, NotAfter properties
        /// and note whether the certificate contains a private key or not.
        /// NOTE: currently this constructor does not support passwords, and if this is a cert in a store then 
        ///       the user this code is running as must have read permission for the private key 
        ///       or you will get an error like "Keyset does not exist". 
        /// </summary>
        /// <param name="certificate">an X509 cert from which to extract key data (public and also privat if available)</param>
        public RsaKeyData(X509Certificate2 certificate)
        {
            InitialiseFromCertificate(certificate);
        }

        //TODO - add support for password protected certs
        /// <summary>
        /// Construct instance from raw bytes. 
        /// It is recommended to use one of the static factory methods to construct instances 
        /// (e.g. when reading from a file) rather than calling this constructor. 
        /// Note that for an X509Certificate type it will try to instantiate a certificate to check if
        /// it has a private key and note its validity dates. For all other types it makes no check on 
        /// whether the bytes are actually valid for the specified type. 
        /// NOTE: currently this constructor does not support cert passwords
        /// </summary>
        /// <param name="format">Identifies what format the raw bytes are provided in</param>
        /// <param name="bytes">The raw bytes</param>
        public RsaKeyData(KeyFormat format, byte[] bytes)
        {
            if (bytes == null || bytes.Length == 0) throw new ArgumentException("may not be null or empty", nameof(bytes));
            if (format == KeyFormat.X509Certificate)
            {
                using (X509Certificate2 certificate = CertificateUtils.ConstructCertificate(bytes))
                {
                    InitialiseFromCertificate(certificate);
                }
            }
            else
            {
                this.Format = format;
                this.value = bytes ?? throw new ArgumentNullException(nameof(bytes));
                this.isCertificateWithPrivateKey = false;
            }
        }

        /// <summary>
        /// Returns a copy of the raw bytes.
        /// Their format can be found via the Format property. 
        /// Note that this might not be the same as the object or data that was used to initially construct
        /// this instance of RsaKeyData.
        /// </summary>
        /// <returns>a new independent byte array containing the raw bytes</returns>
        public byte[] GetValue()
        {
            //We return a copy instead of the actual byte array because array is mutable and we want this class
            //to be immutable and threadsafe.
            byte[] result = new byte[value.Length];
            Array.Copy(value, result, value.Length);
            return result;
        }

        /// <summary>
        /// Can this instance provide a public key?
        /// (This is not mutually-exclusive with IsPrivate as some formats (i.e. certificates) can hold both)
        /// </summary>
        public bool IsPublic
        {
            get
            {
                switch (Format)
                {
                    case KeyFormat.X509Certificate: return true;
                    case KeyFormat.X509PublicKey: return true;
                    case KeyFormat.Pkcs1PublicKey: return true;
                    default: return false;
                }
            }
        }

        /// <summary>
        /// Can this instance provide a private key?
        /// (This is not mutually-exclusive with IsPublic as some formats (i.e. certificates) can hold both)
        /// </summary>
        public bool IsPrivate
        {
            get
            {
                switch (Format)
                {
                    case KeyFormat.X509Certificate: return isCertificateWithPrivateKey;
                    case KeyFormat.Pkcs8PrivateKey: return true;
                    case KeyFormat.Pkcs1PrivateKey: return true;
                    default: return false;
                }
            }
        }

        /// <summary>
        /// Return an instance of SecurityKey
        /// The key is based on the value bytes stored in this RsaKeyData and independent of the lifecycle of
        /// whatever object was used to initially construct the RsaKeyData instance.
        /// </summary>
        /// <returns>key</returns>
        public SecurityKey PublicSecurityKey()
        {
            //TODO - internally we can cache the key we ourselves create below because we have already ensured that
            //       is made from clean bytes without retaining a reference to managed objects (unlike a key
            //       created externally where it might or might not be cacheable and you could get ObjectDisposedException)
            //       Once we can return the same key instance everytime then things like CryptoProviderFactory
            //       can use optimisations like provider caching. 
            //       Consider whether to use a lazy or instantiate it at construction time. 
            //   ***BUT*** SecurityKey is mutable (for the KeyId and CryptoProviderFactory)
            //And Gemini now warns me "The Microsoft.IdentityModel libraries (which process SAML and JWTs) are notoriously aggressive about modifying keys under the hood."
            //but we may be able to subclass securitykey and make it ignore such changes
            switch (Format)
            {
                case KeyFormat.X509Certificate: return PublicSecurityKeyFromX509Certificate(value);
                case KeyFormat.X509PublicKey: return PublicSecurityKeyFromX509Key(value);
                case KeyFormat.Pkcs1PublicKey: return PublicSecurityKeyFromPkcs1(value);

                default:
                    throw new NotImplementedException($"Creating a {nameof(SecurityKey)} for {Format} is not implemented for {nameof(PublicSecurityKey)}");
            }
        }

        public SecurityKey PrivateSecurityKey()
        {
            //TODO - internal caching (see the TODO note in PublicSecurityKey)
            switch (Format)
            {
                case KeyFormat.X509Certificate: return PrivateSecurityKeyFromX509Certificate(value);
                case KeyFormat.Pkcs8PrivateKey: return PrivateSecurityKeyFromPkcs8(value);
                case KeyFormat.Pkcs1PrivateKey: return PrivateSecurityKeyFromPkcs1(value);

                default:
                    throw new NotImplementedException($"Creating a {nameof(SecurityKey)} for {Format} is not implemented for {nameof(PrivateSecurityKey)}");
            }
        }

        /// <summary>
        /// Return a new instance of X509Certificate2 constructed from the key data.
        /// Callers are reminded that X509Certificate2 is disposable and they are responsible for its disposal.
        /// WARNING: if there is a private key it is marked exportable and is not password protected
        /// </summary>
        /// <returns>certificate</returns>
        public X509Certificate2 Certificate()
        {
            return CertificateUtils.ConstructCertificate(value);
        }

        //TODO - password support
        private void InitialiseFromCertificate(X509Certificate2 certificate)
        {
            if (certificate == null) 
                throw new ArgumentNullException(nameof(certificate));
            if (!CertificateUtils.IsRsaKey(certificate))
                throw new ArgumentException($"certificate {certificate.SerialNumber} is not RSA", nameof(certificate));

            this.Format = KeyFormat.X509Certificate;
            //n.b. while an actual X509 cert only contains public key, the X509Certificate2
            //     class in .NET also represents a logical bundling of that with the private key
            //     when loaded from a source containing both, such as if the cert is loaded from
            //     a store and has a private key linked, or from a .pfx or .p12  file
            this.isCertificateWithPrivateKey = certificate.HasPrivateKey;
            if (this.isCertificateWithPrivateKey)
            {
                //note: if this is a cert in a store then the user running this code must have read permission
                //      for the private key, without which you will get an error such as "Keyset does not exist"
                //      Also the cert must not have a password set as we don't support that here.
                //      This would also fail for other cases where the private key can't be exported such
                //      as hardware security modules, azure key vault etc...

                //Export both the private and public keys in a PKCS12 envelope
                this.value = certificate.Export(X509ContentType.Pkcs12, NoPassword);
            }
            else
            {
                //Just use a normal X509 format if its only got a public key
                this.value = certificate.Export(X509ContentType.Cert, NoPassword);
            }
            this.NotBefore = certificate.NotBefore;
            this.NotAfter = certificate.NotAfter;
            //Thumbprint property is SHA-1 hash of the certificate's raw DER-encoded ASN.1 bytes
            //so later if we construct a new instance from value bytes it will still be the same
            this.Thumbprint = certificate.Thumbprint;
        }

    }
}
