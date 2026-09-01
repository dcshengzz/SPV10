using Xunit;
using swz.KeyUtils;
using System.Security.Cryptography.X509Certificates;
namespace swz.KeyUtilsTests
{
    public class TestRsaKeyDataKeySupplier
    {
        /// <summary>
        /// The following test requires that you have the relevant certificates in your local machine store.
        /// For the machine store you will need admin access to add the certificates, but don't need it to run the tests,
        /// however for surveyplus-dev, DO NOT set a password, and you will need to grant read acces to the private key
        /// for the account that runs the test. (Use mmc to import the certs into the store and manage, and the all tasks/manage private keys
        /// to manage the provate keys for the surveyplus-dev cert)
        /// The subject name comparison is exact so must use the same format that .net is using, right down to the exact spacing
        /// or it will not find the certs. 
        /// </summary>
        /// <param name="location"></param>
        /// <param name="subjectDNString"></param>
        /// <param name="expectedPublic"></param>
        /// <param name="expectedPrivate"></param>
        [InlineData(StoreLocation.LocalMachine, "CN=surveyplus-dev, OU=Softworkz, O=Softworkz, L=SG, S=SG, C=SG", 1, 1)]
        [InlineData(StoreLocation.LocalMachine, "CN=first, OU=Softworkz, O=Softworkz Pte Ltd, L=SG, S=SG, C=SG", 1, 0)]
        [InlineData(StoreLocation.LocalMachine, "CN=second, OU=Softworkz, O=Softworkz Pte Ltd, L=SG, S=SG, C=SG", 1, 0)]
        [InlineData(StoreLocation.LocalMachine, "CN=third, OU=Test Unit, O=Testco Pty Ltd, L=Perth, S=WA, C=AU", 1, 0)]
        [Theory]
        public void Can_Read_From_Store(StoreLocation location, string subjectDNString, int expectedPublic, int expectedPrivate)
        {
            X500DistinguishedName subjectDN = new X500DistinguishedName(subjectDNString);
            var supplier = RsaKeyDataKeySupplier.FromStore(location, subjectDN, ignoreNonCurrentCerts: false, ignoreUnverifiedCerts: false);
            Assert.Equal(expectedPublic, supplier.PublicCount);
            Assert.Equal(expectedPrivate, supplier.PrivateCount);
            Assert.Equal(expectedPublic + expectedPrivate, supplier.Count);
        }

        [InlineData("keys/folderTest1", 4, 4)]
        [Theory]
        public void Can_Read_From_Folder(string path, int expectedPublic, int expectedPrivate)
        {
            var supplier = RsaKeyDataKeySupplier.FromFileOrFolder(path, ignoreNonCurrentCerts: false, ignoreUnverifiedCerts: false);
            Assert.Equal(expectedPublic, supplier.PublicCount);
            Assert.Equal(expectedPrivate, supplier.PrivateCount);
            Assert.Equal(expectedPublic + expectedPrivate, supplier.Count);
        }
    }
}
