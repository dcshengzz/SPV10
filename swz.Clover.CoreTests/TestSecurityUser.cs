using Xunit;
using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Security.Cryptography;

namespace swz.Clover.CoreTests
{
    public class TestSecurityUser
    {
        [Theory]
        [InlineData("d8e1ef4b-9e81-4c91-a0b6-62f44a49cbc3", "oTDp6rh4A7UnXXi8qZ5mFw==", "ySpBFZWbkMDRXqNZDFNYgf9+t9XQZX+95n3k5Okq9Wk=", "lenfZzCNIyt6QvkNUVEPbA==")] //128 bit key
        [InlineData("99e24680-e5ab-427c-a5aa-5e5485b657d4", "6Nc4n6utiPBcT/iaLCUW9w==", "v7w7IFRj4RQ21BhQYkR0Sy0ygmGVOr5HQ/3EHYnxPvU=", "alNhgvrT5WLu1KqhftkTfQ==")] //128 bit key
        [InlineData("e488511d-71c6-4705-9bf6-a7ede77c4ed8", "C2fT6gt13yTTPm39zV2H5w==", "Y1YGvGKM3BViMR/TY2Z7lzUq+S7uGOrp+iTaHadMH+E=", "TjLCWlw1y4PCyJ0C9NH+Xw==")] //128 bit key
        [InlineData("66072704-af70-4231-ab58-add371bcd0b0", "Ei3hNKaA12ti3pzPAOw56g==", "ChE/WIFKzStrHKUYeqML8aQEujKyW8wh8VG2Skhp9tM=", "1dourK+RtzNVAKPqAZ18Iw==")] //128 bit key
        [InlineData("ac77dbd9-009d-48b3-a520-b945dd1eaf18", "AUZ7he5FqMU48QnEunNapA==", "5xcAC4ruQPznfPKdiyoCvom2wNrE81Gl5NYmeeqTmrM=", "yYtSpjgWQVEsrEbLaDApMg==")] //128 bit key
        [InlineData("c4e169af-af7d-4cae-813d-a5eff64bd33d", "dYVTc0Q6J6aBgiB3rEl2Mg==", "du8w90/cEMpeIB7RQriTNzYLgY93Ot1a7ye2O2YTK5g=", "N2LZN4yfQHJvEG6rlG8NLg==")] //128 bit key
        [InlineData("f19e448c-3468-42aa-9910-55939ab3cbba", "AbScAwYdWdSk2ikbuHBTUg==", "jEoSiUaXg2DVGeEhbKBWpuQmoRZSej5Kt2KcbLdfuOA=", "aB7ChqrsmIx757eQTCAgiA==")] //128 bit key
        [InlineData("63e8843a-d486-49f8-9f96-c40fa7bc248d", "zONe0dHfWdnuVbA07UX8qg==", "tVGKfQR1m/+EM1vz75WG6XYhnOHZCOArE0/z341Jc90=", "uFlwAc/r+JT7aEweCIvTWw==")] //128 bit key
        [InlineData("c44d7cc5-4173-445a-8072-1b511ed25107", "6zGj3q1Sc8At01StzJmqhzuLoMu8MWT6", "Qrt9L7Yl92KJmOtOA7/dDSm82i20qgi57o0BY3V6Gmo=", "cvwvUMRi2MHSZal01I/zZg==")] //192 bit key
        [InlineData("dc582b16-75ac-4af9-ab49-ea8b49aa2a4a", "UMuz7MWN/SwvmSeHdspmDkYMY+X7tCZV", "0sak+VHlQJtvzmrxvAreLohqDCCcTj7jQjIF1G/9U8M=", "mzCWXFDPphyV8ZqM7j2mjA==")] //192 bit key
        [InlineData("62aa4ced-fe26-446c-be35-7ad1ada26da8", "fFnDljZe3DBUsXUGvmW7rgagiLqlfHge", "dA98edr1czDpi7hzCbqUvLgaiaQrGn26SyiJQDOleIQ=", "YD0WR9k6YWdkDxEj1gDqSA==")] //192 bit key
        [InlineData("63c826c1-cb56-40db-a4eb-2fcc79b40017", "jnZaCon7GeXFrQEkZDo3N+gIzN3d0fUV", "/5kiuGjyp8UypZPPEL2jQaxmgfW2nTghBkTSyJUrdJI=", "W6Chsc8359EMKuS/5gCbWg==")] //192 bit key
        [InlineData("b9f1714f-5f5d-449b-8c2a-0feba408925e", "/SvZN6H1zzQn0/QNiSisvXZejLU0LUjr3tNsAKXb3hk=", "5/QNDjVag1g8AcEr8KeW10j3/TnPkzvF4ZVc1QgWmtg=", "RWcQMJrNwS9pYX5UIrsDIA==")] //256 bit key
        [InlineData("e1bc046c-5884-45fc-af43-eed1dc2e72a5", "hYEwVEztg8vld1t3+YTZkfzjVxgzbQPj+OFBC9kJ+d0=", "yKkAqr6rxqvVmGDfp9cqWzhQxu0TqXckIkaMSDSbbfw=", "VAq74tSJhGOk8RHIpsBDOQ==")] //256 bit key
        [InlineData("b8239340-9794-4c21-9c84-d8e996d7401a", "np1mVJbxmqGHF6sbWqxWLgQUcbNQawtbBoTBhbkaFe0=", "H5nEVg27CSYU31lH38+ozPX3BNstoLP4VQvd/yWYA1Q=", "hmk/8my7rL6PlyOg2tmFDg==")] //256 bit key
        [InlineData("7bf9a67b-6035-44a4-b967-fb6b12d17940", "AL2OLGLKW7cMDNEn5ETqYLd/GCJKggY5hsap/lXwbL4=", "nXSooytMEvnaintFx8WmTTwOUiNJN5/u4lbbGLMXbPs=", "x7ovSv146Aln3m5qc6Tthg==")] //256 bit key
        public static void DecryptTotpSecret_Works(string userIdString, string encryptionKeyBase64, string encryptedSecretBase64, string expectedDecryptedSecretBase64)
        {
            Guid userId = Guid.Parse(userIdString);
            byte[] encryptionKey = Convert.FromBase64String(encryptionKeyBase64);
            byte[] expectedDecryptedSecret = Convert.FromBase64String(expectedDecryptedSecretBase64);

            byte[] actualDecryptedSecret = SecurityUser.DecryptTotpSecret(userId, encryptionKey, encryptedSecretBase64);

            Assert.Equal(expectedDecryptedSecret, actualDecryptedSecret);
        }

        [Fact]
        public void GenerateEncryptedTotpSecretBase64_Returns_Expected_Format()
        {
            //We will generate lots of random secrets using random keys and IVs and assert that they
            //all turn out the expected size.
            //(We cant verify that they are really encrypted correctly here though)
            using (var rng = RandomNumberGenerator.Create())
            {
                foreach (int keyLength in new int[] { 16, 24, 32 })
                {
                    for (int i = 0; i < 1024; i++)
                    {
                        byte[] encryptionKey = new byte[keyLength];
                        rng.GetBytes(encryptionKey);
                        string encryptionKeyBase64 = Convert.ToBase64String(encryptionKey);
                        Guid userId = Guid.NewGuid();

                        string encryptedSecretBase64 = SecurityUser.GenerateEncryptedTotpSecretBase64(userId, encryptionKey);

                        //We expect it to produce a base 64 string that fits the GaSalt column
                        byte[] encryptedSecret = Convert.FromBase64String(encryptedSecretBase64);
                        Assert.NotNull(encryptedSecretBase64);
                        Assert.NotEmpty(encryptedSecretBase64);
                        Assert.False(encryptedSecretBase64.Length > 256); //dwSecurityUser.GaSalt is varchar(256)

                        //Copilot tells me for AES "the size of the encrypted data will be the size of the padded input data
                        //plus any additional bytes required by the cipher mode such as the IV in CBC mode". The padding
                        //is to bring the input data up to the 128 bit block size used by AES if necessary.
                        //Since the 20221010 format is an AES encryption of a 128 bit secret, our input requires no padding
                        //for the AES 128 bit block size and we expect it to be using CBC cipher mode, requiring a 128 bit IV
                        //for which we use make use of the user's Id since it is conveniently available and the right size,
                        //so the output should always be 128+128=256bits (32 bytes). This is not affected by key size.
                        Assert.Equal(32, encryptedSecret.Length);
                    }
                }
            }
        }

        [Fact]
        public void GenerateEncryptedTotpSecretBase64_Roundtrip_DecryptTotpSecret_Expected_Size()
        {
            //We will generate lots of random secrets using random keys and IVs and assert that
            //when decrypted they are 128 bits (beyond this we can't test if they decrypted correctly
            //because the random secret is generated inside the method and we don't know what it was.
            //
            //This is an example of how adding tests can highlight where code isn't so well designed.
            //We already had to break out the generation logic into a static method so we could test
            //it without all the baggage of a SecurityUser object, and I've left the generation code
            //in that and now my tests are showing me I should have broken that out too, as those 
            //concerns ought not to have been conflated into a single method! (Something to refactor
            //another day perhaps...)
            using (var rng = RandomNumberGenerator.Create())
            {
                for (int i = 0; i < 1024; i++)
                {
                    foreach(int keyLength in new int[] { 16, 24, 32 })
                    {
                        byte[] encryptionKey = new byte[keyLength];
                        rng.GetBytes(encryptionKey);
                        Guid userId = Guid.NewGuid();

                        string encryptedSecretBase64 = SecurityUser.GenerateEncryptedTotpSecretBase64(userId, encryptionKey);
                        byte[] decryptedSecret = SecurityUser.DecryptTotpSecret(userId, encryptionKey, encryptedSecretBase64);

                        Assert.Equal(16, decryptedSecret.Length); //Our TOTP secrets are 128 bit
                    }
                }
            }
        }

        //All the following when decrypted are not 128 bits so DecryptTotpSecret should fail-fast instead of returning anything
        [Theory]
        [InlineData("wHqPFnQKgA1lLGazMyP/4Q==")]
        [InlineData("XyGU/CsizGbJm98AU7qIx4EBUUaBYSykHYRVAYKmd+OPIDiRKOte59yi1S46CcuYmkogb8mie/Myf4KEq4OqmQ==")]
        [InlineData("nOqXrz82kZlTFoSQ9Sxa5zFEQDaseD9fDYE8Jnc9BBplAcy7U2irgbdWFPEXenSQiN/4oTEsmIhyNQubetsSEw==")]
        [InlineData("qk+r7767jNNAwilxnJugm7VLh9agEovm+qr6oXUUr1dvfUhsbtbH3cIlOfMWcHqwOMgzIE8PfTPYAOUByf+INQ==")]
        [InlineData("KvTWYJCCLtYXbNutobh7kZvCvyYW9jJAGEra9/MILHC/3k4WJwiYRVdvlX3RFdLIkmXmXbEF9HwBBoDwxfMxCg==")]
        [InlineData("sxvgDk1AmlthLf75JKupBH4psScdb0sQoYaLNguwi4buCovc06h37O2yEvYP+w2l")]
        [InlineData("JvzMgEJhXMDkl/0Z9sQ28Opwy6HBAgfLwHMCQnCCx+zxMDplqYP5dGaEGX8LBRUQ")]
        [InlineData("udARANawckWEbmnYeDt7/+j9yYhyQCrxzHj3qXnIIp83Shh2DJ5Mex4fE7H5D59r")]
        [InlineData("yimwJMdheSR9SuTjXCY6Nw==")]
        public static void DecryptTotpSecret_FailsFast_For_Invalid_Secret_Size(string encryptedSecretBase64)
        {
            Guid userId = new Guid(Convert.FromBase64String("wuaSMErok16jzKw7R1DQgA==")); //gets used as 128 bit IV
            byte[] encryptionKey = Convert.FromBase64String("+B/FIigmPYOJN/gWresa4w=="); //128 bit key

            Assert.Throws<InvalidOperationException>(() => SecurityUser.DecryptTotpSecret(userId, encryptionKey, encryptedSecretBase64));
        }
    }
}
