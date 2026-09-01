using swz.SurveyPlus.Application;
using System;
using System.Text.RegularExpressions;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestEncryptionHelper
    {
        /*
        From copilot:
            When encrypting data using AES with a specific key and IV, you will get the same encrypted bytes regardless of the implementation of the AES algorithm you use. This consistency is due to the standardized nature of the AES algorithm, which ensures that any compliant implementation will produce identical results given the same inputs
                https://nvlpubs.nist.gov/nistpubs/ir/2021/NIST.IR.8319.pdf
                https://codedinsights.com/modern-cryptography/implementation-of-advanced-encryption-standard-aes/.

            Key Points to Remember:
            1. Standardization: AES is a standardized algorithm defined by NIST, ensuring that all compliant implementations follow the same steps and produce the same output for given inputs
            2. Same Key and IV: Using the same key and IV is crucial for achieving consistent encryption results.
            3. Implementation Independence: Whether you use AesManaged, AesCryptoServiceProvider, or Aes.Create(), the output will be the same as long as the key and IV are identical
        */

        private const string multilinePlainTextData = "Iram indeed is gone with all its Rose,\nAnd Jamshyd's Sev'n-ring'd Cup where no one knows;\nBut still the Vine her ancient Ruby yields,\nAnd still a Garden by the Water blows.";

        private const string singlelinePlainTextData = "Myself when young did eagerly frequent|Doctor and Saint, and heard great Argument|About it and about: but evermore|Came out by the same Door as in I went.";

        //Some keys for testing (AES supports 128, 192, 256)
        //n.b. if you want to quickly make more keys, use the 'nonce' command in dwdb and it also has
        //     commands for encrypt and decrypt which are useful when generating test data
        private const string key128bits_base64 = "eA7B0yItjRHW+Z/xcxIr0w==";
        private const string key192bits_base64 = "j7Wd8AH6A/K1GCPPZhiRveVkPw4xkOGA";
        private const string key256bits_base64 = "vPbBXljLJ8SgGN1ghI1yW34/yKQUIqNLSme+cxWnLAY=";
        
        private const string iv128_base64 = "NsD4ATM3w5xSuvX0uJ9jCg=="; //always 128 bits for an AES IV

        private readonly byte[] key256 = Convert.FromBase64String(key256bits_base64);
        private readonly byte[] iv128 = Convert.FromBase64String(iv128_base64);

        [Fact]
        public void RandomAlphanumericString_Generates_Alphanumerics()
        {
            Regex regexAlphanumeric = new Regex("^[a-zA-Z0-9]*$"); //regex from https://stackoverflow.com/a/1046743
            Random rnd = new Random();
            //We'll test a lot to see if any non-alphanumeric ones pop up. In theory, since its random, its possible
            //that we are just very very lucky in our testing and its still buggy. In practice, yeah nah ... 
            for (int i = 0; i < 2048; i++)
            {
                int length = rnd.Next(64)+1;
                string result = EncryptionHelper.RandomAlphanumericString(length);
                bool isIndeedAlphanumeric = regexAlphanumeric.IsMatch(result);
                Assert.True(isIndeedAlphanumeric);
            }
        }

        [Fact]
        public void RandomAlphanumericString_Generates_Expected_Length()
        {
            for(int expectedLength=1; expectedLength<1024; expectedLength++)
            {
                Assert.Equal(expectedLength, EncryptionHelper.RandomAlphanumericString(expectedLength).Length);
            }
        }

        [Fact]
        public void RandomAlphanumericString_Doesnt_Give_Same_Answer_Each_Time()
        {
            //In theory it *could* give us a dupe occasionally but is so unlikely that occams razor applies as far as testing goes ...
            //really we're just trying to rule out this --> https://xkcd.com/221/
            Assert.NotEqual(EncryptionHelper.RandomAlphanumericString(128), EncryptionHelper.RandomAlphanumericString(128));
            Assert.NotEqual(EncryptionHelper.RandomAlphanumericString(256), EncryptionHelper.RandomAlphanumericString(256));
            Assert.NotEqual(EncryptionHelper.RandomAlphanumericString(512), EncryptionHelper.RandomAlphanumericString(512));
            //I'm not about to go check the distributions of the stuff it returns :p
        }

        [Theory]
        [InlineData(0)]
        [InlineData(-1)]
        [InlineData(-123)]
        [InlineData(int.MinValue)]
        public void RandomAlphanumericString_Rejects_Zero_Or_Negative_Length(int length)
        {
            Assert.Throws<ArgumentOutOfRangeException>(() => EncryptionHelper.RandomAlphanumericString(length));
        }

        [Theory]
        [InlineData("thirtytwocharsofplainascii123456", "dGhpcnR5dHdvY2hhcnNvZnBsYWluYXNjaWkxMjM0NTY=")]
        [InlineData("You know, my Friends, how long since in my House", "WW91IGtub3csIG15IEZyaWVuZHMsIGhvdyBsb25nIHNpbmNlIGluIG15IEhvdXNl")]
        [InlineData("For a new Marriage I did make Carouse:", "Rm9yIGEgbmV3IE1hcnJpYWdlIEkgZGlkIG1ha2UgQ2Fyb3VzZTo=")]
        [InlineData("Divorced old barren Reason from my Bed,", "RGl2b3JjZWQgb2xkIGJhcnJlbiBSZWFzb24gZnJvbSBteSBCZWQs")]
        [InlineData("And took the Daughter of the Vine to Spouse.", "QW5kIHRvb2sgdGhlIERhdWdodGVyIG9mIHRoZSBWaW5lIHRvIFNwb3VzZS4=")]
        public void Bytes_Simple_ASCII(string input, string expectedBytesBase64)
        {
            byte[] expectedBytes = Convert.FromBase64String(expectedBytesBase64);

            byte[] actualBytes = EncryptionHelper.Bytes(input);

            Assert.Equal(expectedBytes, actualBytes);
        }

        [Theory]
        [InlineData(
            "dGhpcnR5dHdvY2hhcnNvZnBsYWluYXNjaWkxMjM0NTY=", 
            "dGhpcnR5dHdvY2hhcnNvZnBsYWluYXNjaWkxMjM0NTY=")] //thirtytwocharsofplainascii123456
        [InlineData(
            "YXNjaWkgc3R1ZmYgaXMganVzdCBmaW5l",
            "YXNjaWkgc3R1ZmYgaXMganVzdCBmaW5l")]  //ascii is just fine
        [InlineData(
            "U8RzEWR2ttfGucHCvXj+riqtZSnBic/kBljVVTMKyissh+RwKjuh6EWC+Op3CubvRhghH+elECD22XDBITH76g==",
            "U/1zEWR2/f25/b14/f0q/WUp/f39/QZY/VUzCv0rLP39cCo7/f1F/f39dwr9/UYYIR/9ECD9/XD9ITH9/Q==")]
        [InlineData(
            "Jz1urEJawREWDjwhQNTDqNWD31Cg/zoIQn50j/MMpnPIrQteGi6Xw94hwHhb4tK6MlSyZWLrs+D/icC7RXvVlA==",
            "Jz1u/UJa/REWDjwhQP3oQ/1Q/f06CEJ+dP39DP1zLQteGi79/f0h/Xhb/boyVP1lYv39/f39/UV7VA==")]
        [InlineData(
            "19MxlFVM8uSajBPfgbenzQ==",
            "/f0x/VVM/YwTwf39/Q==")]
        [InlineData(
            "EZtnnlt5bahnhnIvtNq9pg==",
            "Ef1n/Vt5bf1n/XIv/b39")]
        [InlineData(
            "H5vhK+mi01eabyVWf2LL7Q==",
            "H/39K/39V/1vJVZ/Yv39")]
        public void Bytes_MSB_Stripping_Of_Multibyte_Chars(string inputBase64, string expectedBytesBase64)
        {
            //If you want to convert a bunch of bytes into a string then you need to specify the encoding so that
            //it knows how to handle multibyte characters (or indeed, if there even are mutibyte characters). The
            //code in EncryptionHelper (as of 20241229) uses StreamReader to read and write text to a crypto stream
            //and doesn't bother to specify which encoding, implying stream-reader's default of UTF-8,
            //however the the code in Bytes() (used for key and iv decoding) will take each char in a string and
            //cast it to a byte with no care as though its ASCII or some such single byte encoding.
            //Char is UTF-16 however - so values >255 will be truncated, retaining only the least significant 8 bits...
            //...so for simple ascii we'd expect the input as base64 utf-8 and the output as base 64 ascii to look the same,
            //but for anything beyond we would get stripping and a shorter byte array from Bytes[]
            //--------------------------------------------------------------------------------------------------
            //Although clearly 'wrong' this is the legacy behaviour we need Bytes() to preserve for existing code
            //--------------------------------------------------------------------------------------------------
            string input = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(inputBase64));

            byte[] expectedBytes = Convert.FromBase64String(expectedBytesBase64);
            byte[] actualBytes = EncryptionHelper.Bytes(input);
            Assert.Equal(expectedBytes, actualBytes);
        }

        [Fact]
        public void EncryptStr_DecryptStr_ByteKeyIv_Can_RoundTrip()
        {
            string encrypted = EncryptionHelper.EncryptStr(plainText: multilinePlainTextData, keyBytes:key256, ivBytes:iv128);
            Assert.NotEqual(multilinePlainTextData, encrypted); //ensure it really did ...something... with the string lol
            string decrypted = EncryptionHelper.DecryptStr(encryptedData: encrypted, keyBytes: key256, ivBytes: iv128);
            Assert.Equal(multilinePlainTextData, decrypted);
        }

        [Theory]
        [InlineData("/kDEMc4+DlQVHV1XtwiUG6QLCJSlGjDsRb2w3zmr5iFGTzZDFIWZZVuTJuZtlfUS", "The Worldly Hope men set their Hearts upon", key256bits_base64)]
        [InlineData("/beXkBaIOtd6POMaoCofXokesQ4M26a+/exAqYrQFtHokLs45gXtkTs39KisMxWC", "Turns Ashes-or it prospers; and anon,", key256bits_base64)]
        [InlineData("BaN8EEp8gA+tYiZdmOu7Qnlgm94aXEzlsEdUWn2cWIig+xxvpALdgGMn2GO8m9CV", "Like Snow upon the Desert's dusty Face", key256bits_base64)]
        [InlineData("IuZvd8G5Vs19G0b5K+6lT455vEa0YGq8HOXj/WO2AZVHf3ptDZbI5m6sZI4XF/o2", "Lighting a little Hour or two-is gone", key256bits_base64)]
        [InlineData("YT2Nj2LrrPsoPLPh+cfhD6HavGyj5iYagMLgPdEhomDAesvK+ob5GD6M4PQxFmI58wJWvno90RFUtSCotiyNC/ZGtNMif7YlNNXlKt79u005CZoZ+M9aGNNQm4alqSz8fj+qs8Jgsz5R3D056y8rorj4Xq7ykw9WnaHWQrtZoVJ9Vn57o+3aoFZYBtYSnzqCS7XAD26A4YuzSOfftWhSZU/eCaQ16WArciXwY4QzYvc=", multilinePlainTextData, key256bits_base64)]
        [InlineData("yqrLf2CDDb/MxJVetj40lyORYv0jgt86DIDFJ79e2Qn16YIS9eMj8Onjnj3uu7Mq81Yx+rsLhiIor4y4MQomjiM6sk0z0T9OqEY4FvsjrRxcVocTD7W/tuijlRCLXehVtiB5cQmm8hMfz7CorPxClhAcvxbqz7FvKxNTBb8SpNktOt2jSJ9tnvxklxgcKg3u+ckdGErHkF8fizIrxQOOKg==", singlelinePlainTextData, key128bits_base64)]
        [InlineData("wb7+nS33a0WAoTiu+GJqprb0LfMBPYyGM37JJRLbcN2j7vsAuImdDMk1dLpCGVSOPkKy+M7XKMQQ4lMnbtNVlYkHYzfUBt63aS8Hfh92c9s=", "At Over they fling oaths at one, And worse than oaths at Trumpington,", key192bits_base64)]
        public void DecryptStr_KeyBytes_IvBytes( string encryptedBase64, string expected, string keyBase64 )
        {
            byte[] keyBytes = Convert.FromBase64String(keyBase64);

            string decrypted = EncryptionHelper.DecryptStr(encryptedData: encryptedBase64, keyBytes: keyBytes, ivBytes: iv128);

            Assert.Equal(expected, decrypted);
        }

        [Theory]
        [InlineData("How long, how long, in infinite Pursuit", "rBeoS69L9v5GUOOXra8R6qZ2Jq43DfGV7yQXSmGZaTRgLU+btCl2sUVzyBI14G4z", key128bits_base64)]
        [InlineData("Of This and That endeavour and dispute?", "fRzEIl6lEFK9r3J0OdnJNMa7px5Igsy6Mj77YIRxm1KtNN2N7ulKBJeHFjS5F97a", key192bits_base64)]
        [InlineData("Better be merry with the fruitful Grape", "3DYlyla76VbM/H/GCEAPAtVPBYxBuAJRg67upsX4K2FmPAjQ9qKPXfO9xlgL87+R", key256bits_base64)]
        [InlineData("Than sadden after none, or bitter, Fruit.", "EDrosJ11K6bC3vIoqwya5iGfZBbtw02RILKrW8juV5ja/I5+Ye/GXCGljbE5prIr", "K/g5ZNK8+EjpVMu4YOqo/TlYj/E2YYAERYnfoDd2wlg=")]
        public void EncryptStr_KeyBytes_IvBytes( string plaintext, string expectedBase64, string keyBase64)
        {
            byte[] expectedBytes = Convert.FromBase64String(expectedBase64);
            byte[] keyBytes = Convert.FromBase64String(keyBase64);

            string encryptedBase64 = EncryptionHelper.EncryptStr(plainText: plaintext, keyBytes: keyBytes, ivBytes: iv128);
            
            byte[] actualBytes = Convert.FromBase64String(encryptedBase64);
            Assert.Equal(expectedBytes, actualBytes);
        }
    }
}
