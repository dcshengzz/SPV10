using swz.KeyUtils;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Xunit;

namespace swz.KeyUtilsTests
{
    public class TestCertificateUtils
    {
        [Theory]
        [InlineData("keys/first-public-certificate-x509.cer", true)]
        [InlineData("keys/second-public-certificate-x509.cer", true)]
        [InlineData("keys/third-public-certificate-x509.cer", true)]
        [InlineData("keys/ecdsa_cert.pem", false)]
        public void IsRsaKey_true_only_for_rsa(string path, bool expected)
        {
            //n.b. directly calling X509Certificate2.CreateFromPemFile(path) fails due to UTF-8 BOM
            //     so we use ReadAllText to get the BOM free PEM text instead
            using X509Certificate2 cert = X509Certificate2.CreateFromPem(
                File.ReadAllText(path));
            Assert.Equal(expected, CertificateUtils.IsRsaKey(cert));
        }

        [Fact]
        public void IsRsaKey_false_for_null()
        {
            Assert.False(CertificateUtils.IsRsaKey(null));
        }
    }
}
