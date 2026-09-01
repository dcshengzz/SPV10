using swz.KeyUtils;
using System;

namespace swz.MockEntra
{
    public class MockEntraSamlKeySuppliers
    {
        public IPublicKeySupplier SpVerificationKeySupplier { get; private set; }

        public IPublicKeySupplier SpEncryptionKeySupplier { get; private set; }

        public IPrivateKeySupplier IdpSigningKeySupplier { get; private set; }

        //TODO - reorder these to match order in Saml projects key thinghy
        public MockEntraSamlKeySuppliers(
            IPublicKeySupplier spVerificationKeySupplier,
            IPublicKeySupplier spEncryptionKeySupplier,
            IPrivateKeySupplier idpSigningKeySupplier)
        {
            this.SpVerificationKeySupplier = spVerificationKeySupplier ?? throw new ArgumentNullException(nameof(spVerificationKeySupplier));
            this.SpEncryptionKeySupplier = spEncryptionKeySupplier ?? throw new ArgumentNullException(nameof(spEncryptionKeySupplier));
            this.IdpSigningKeySupplier = idpSigningKeySupplier ?? throw new ArgumentNullException(nameof(idpSigningKeySupplier));
        }
    }
}
