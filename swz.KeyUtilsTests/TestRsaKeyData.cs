using Xunit;
using swz.KeyUtils;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography;
using System.Globalization;

namespace swz.KeyUtilsTests
{
    public class TestRsaKeyData
    {
        // first / second / third are three pairs of keys and we have various representations
        // first & third are 2048 bit keys, and second is 4096
        // nb: if tests cant find a file by path, check that its set to "Copy if newer" or "Copy always" in the VS file properties

        [Fact]
        public void Constructor_Requires_Bytes()
        {
            Assert.Throws<ArgumentException>(() => new RsaKeyData(RsaKeyData.KeyFormat.X509PublicKey, null));
            Assert.Throws<ArgumentException>(() => new RsaKeyData(RsaKeyData.KeyFormat.X509PublicKey, new byte[] { }));
        }

        [InlineData("keys/first-public-certificate-x509.cer", 2048, "B79D41A7B9DC13E1FA46F371F0CD64AC6060A3F0")]
        [InlineData("keys/second-public-certificate-x509.cer", 4096, "1769B369F264C1C4E7CAB3120E22DAFD505272B0")]
        [InlineData("keys/third-public-certificate-x509.cer", 2048, "7B939ABCC9F85DE6D2585C82D2FFA80CBAE79A2B")]
        [InlineData("keys/surveyplus-dev-public.cer", 2048, "77437EDD5AA2EC25992D7E811AE83C6DDE507427")]
        [Theory]
        public void Can_Read_X509_Public_Certificate_And_Export_SecurityKey(string path, int expectedKeySize, string expectedThumbPrint)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.Equal(RsaKeyData.KeyFormat.X509Certificate, data.Format);
            Assert.True(data.IsPublic);
            Assert.False(data.IsPrivate);
            Assert.Equal(expectedThumbPrint, data.Thumbprint); //For x509Cert we init ThumbPrint

            SecurityKey key = data.PublicSecurityKey();
            Assert.Equal(expectedKeySize, key.KeySize);            
            Assert.Equal(expectedThumbPrint, key.KeyId); //For x509Cert we set id to thumbprint
        }

        [InlineData("keys/first-public-certificate-x509.cer", "2022-11-21 06:01:52", "2052-11-13 06:01:52")]
        [InlineData("keys/second-public-certificate-x509.cer", "2022-11-21 06:02:54", "2052-11-13 06:02:54")]
        [InlineData("keys/third-public-certificate-x509.cer", "2022-11-21 06:05:11", "2052-11-13 06:05:11")]
        [Theory]
        public void Initialises_Dates_From_X509Certificates(string path, string expectedNotBeforeString, string expectedNotAfterString)
        {
            DateTime expectedNotBefore = DateTime.ParseExact(expectedNotBeforeString, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);
            DateTime? expectedNotAfter = DateTime.ParseExact(expectedNotAfterString, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);

            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.NotNull(data.NotBefore);
            Assert.Equal(expectedNotBefore, data?.NotBefore?.ToUniversalTime());
            Assert.NotNull(data.NotAfter);
            Assert.Equal(expectedNotAfter, data?.NotAfter?.ToUniversalTime());
        }

        [InlineData("keys/first-public-key-x509.pem", 2048)]
        [InlineData("keys/second-public-key-x509.pem", 4096)]
        [InlineData("keys/third-public-key-x509.pem", 2048)]
        [InlineData("keys/surveyplus-dev-public.pem", 2048)]
        [Theory]
        public void Can_Read_X509_Public_Key_And_Export_SecurityKey(string path, int expectedKeySize)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.Equal(RsaKeyData.KeyFormat.X509PublicKey, data.Format);
            Assert.True(data.IsPublic);
            Assert.False(data.IsPrivate);
            SecurityKey key = data.PublicSecurityKey();
            Assert.Equal(expectedKeySize, key.KeySize);
        }

        [InlineData("keys/first-public-key-pkcs1.pem",2048)]
        [InlineData("keys/second-public-key-pkcs1.pem",4096)]
        [InlineData("keys/third-public-key-pkcs1.pem",2048)]
        [Theory]
        public void Can_Read_PKCS1_Public_Key_And_Export_SecurityKey(string path, int expectedKeySize)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.Equal(RsaKeyData.KeyFormat.Pkcs1PublicKey, data.Format);
            Assert.True(data.IsPublic);
            Assert.False(data.IsPrivate);
            SecurityKey key = data.PublicSecurityKey();
            Assert.Equal(expectedKeySize, key.KeySize);
        }

        [InlineData("keys/first-private-key-pkcs1.pem",2048)]
        [InlineData("keys/second-private-key-pkcs1.pem", 4096)]
        [InlineData("keys/third-private-key-pkcs1.pem", 2048)]
        [Theory]
        public void Can_Read_PKCS1_Private_Key_And_Export_SecurityKey(string path, int expectedKeySize)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.Equal(RsaKeyData.KeyFormat.Pkcs1PrivateKey, data.Format);
            Assert.False(data.IsPublic);
            Assert.True(data.IsPrivate);
            SecurityKey key = data.PrivateSecurityKey();
            Assert.Equal(expectedKeySize, key.KeySize);
        }

        [InlineData("keys/first-private-key-pkcs8.pem", 2048)]
        [InlineData("keys/second-private-key-pkcs8.pem", 4096)]
        [InlineData("keys/third-private-key-pkcs8.pem", 2048)]
        [Theory]
        public void Can_Read_PKCS8_Private_Key_And_Export_SecurityKey(string path, int expectedKeySize)
        {
            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.Equal(RsaKeyData.KeyFormat.Pkcs8PrivateKey, data.Format);
            Assert.False(data.IsPublic);
            Assert.True(data.IsPrivate);
            SecurityKey key = data.PrivateSecurityKey();
            Assert.Equal(expectedKeySize, key.KeySize);
        }

        [Fact]
        public void Can_Read_SurveyPlusDevPrivateKey()
        {
            RsaKeyData data = RsaKeyData.ReadFromFile("keys/surveyplus-dev-private-key.pem");
            Assert.False(data.IsPublic);
            Assert.True(data.IsPrivate);
            SecurityKey key = data.PrivateSecurityKey();
            Assert.Equal(2048,key.KeySize);
        }

        //these pfx all have a private and public key
        [InlineData("keys/first-certificate-x509.pfx", 2048)]
        [InlineData("keys/second-certificate-x509.pfx", 4096)]
        [InlineData("keys/third-certificate-x509.p12", 2048)]
        [Theory]
        public void Can_Read_Pfx_With_PrivateKey_And_Export_Keys_And_Certificate(string path, int expectedKeySize)
        {
            //nb: at present we don't support pfx/p12 with a password

            RsaKeyData data = RsaKeyData.ReadFromFile(path);
            Assert.True(data.IsPublic);
            Assert.True(data.IsPrivate);
            SecurityKey publicKey = data.PublicSecurityKey();
            Assert.Equal(expectedKeySize, publicKey.KeySize);
            SecurityKey privateKey = data.PrivateSecurityKey();
            Assert.Equal(expectedKeySize, privateKey.KeySize);

            //Verify that we can not only get back a certificate from the bytes
            //but that this rehydrated cert still contains the PK data from original
            using (X509Certificate2 cert = data.Certificate())
            {
                Assert.True(cert.HasPrivateKey);
                using (RSA rsa = cert.GetRSAPublicKey())
                {
                    Assert.NotNull(rsa);
                }
                using (RSA rsa = cert.GetRSAPrivateKey())
                {
                    Assert.NotNull(rsa);
                }
            }
        }

    }
}
