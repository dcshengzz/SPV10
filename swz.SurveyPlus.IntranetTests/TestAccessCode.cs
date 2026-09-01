using swz.SurveyPlus.Application;
using System;
using Xunit;

namespace swz.SurveyPlus.IntranetTests
{
    public class TestAccessCode
    {
        //these aren't static on the offchance that a test somehow overwrites the array, so other test won't be affected by that
        private readonly byte[] key128 = Convert.FromBase64String("J9lXlLnY3OnPMrKcpeC2sg==");
        private readonly byte[] anotherKey128 = Convert.FromBase64String("Z5c5LRYeXmeNetnTZUFn6Q==");
        private readonly byte[] key192 = Convert.FromBase64String("hvW6nc1eTBt1ksDB8MQfGyz4sRCgSJGo"); 
        private readonly byte[] key256 = Convert.FromBase64String("nuIbDGfa/5dN4o4CiWTKaigE+hN3yQKQoUPgKRxwhIc=");
        private readonly byte[] iv = Convert.FromBase64String("CVRCNDwxC/o7PB6EAQEirg==");
        private readonly byte[] anotherIv = Convert.FromBase64String("DffXKWuXgoCqznv2ae5i/g==");
        private readonly byte[] oneMoreIv = Convert.FromBase64String("XkKy0SKFbDVvZwmcKVAa8Q==");
        private readonly byte[][] keys, ivs;

        private readonly ITestOutputHelper toh;
       
        
        public TestAccessCode(ITestOutputHelper testOutputHelper)
        {
            this.toh = testOutputHelper;
            this.keys = new byte[][] { key128, anotherKey128, key192, key256 };
            this.ivs = new byte[][] { iv, anotherIv, oneMoreIv };

        }

        [Theory]
        [InlineData("n3v2h6h")]
        [InlineData("xjhn2pv")]
        [InlineData("yvyyb46")]
        public void Constructor_Accepts_Valid_Format(string code)
        {
            AccessCode accessCode = new AccessCode(code);
            Assert.Equal(code, accessCode.ToString());
        }

        [Fact]
        public void Constructor_Rejects_Null_Empty()
        {
            Assert.ThrowsAny<ArgumentException>(() => new AccessCode(null));
            Assert.ThrowsAny<ArgumentException>(() => new AccessCode(""));
        }

        [Theory]
        [InlineData("1dyjgjr")] //invalid chars
        [InlineData("m00cowr")] //invalid chars
        [InlineData("gkcjgtbb")] //too long
        [InlineData("gkcjg")] //too short
        [InlineData(" ")] //too whitespacey
        public void Constructor_Rejects_Invalid_Format(string code)
        {
            Assert.ThrowsAny<FormatException>(() => new AccessCode(code));
        }

        [Theory]
        [InlineData("n3v2h6h")]
        [InlineData("xjhn2pv")]
        [InlineData("yvyyb46")]
        public void FromString_Accepts_Valid_Format(string code)
        {
            AccessCode accessCode = AccessCode.FromString(code);
            Assert.Equal(code, accessCode.ToString());
        }

        [Fact]
        public void FromString_Allows_Null_Or_Empty_And_Returns_Null()
        {
            Assert.Null(AccessCode.FromString(null));
            Assert.Null(AccessCode.FromString(""));
        }

        [Fact]
        public void Equals_Compares_Based_On_Value()
        {
            AccessCode instanceA = new AccessCode("38wqkkf");
            AccessCode instanceB = new AccessCode("38wqkkf");
            AccessCode differentCode = new AccessCode("tpyv2pt");

            //Self compare
            Assert.True(instanceA.Equals(instanceA));
            Assert.True(instanceB.Equals(instanceB));

            //Two instances with same data are equal
            Assert.True(instanceA.Equals(instanceB));
            Assert.True(instanceB.Equals(instanceA));
            Assert.True(instanceA.GetHashCode() == instanceB.GetHashCode()); //If equal the hashcode must be equal (but converse not true)

            //Test agaist different too
            Assert.False(instanceA.Equals(differentCode));
            Assert.False(instanceB.Equals(differentCode));
            Assert.False(differentCode.Equals(instanceA));
            Assert.False(differentCode.Equals(instanceB));
        }

        [Theory]
        [InlineData("8xpnccc")]
        [InlineData("3y9bk3n")]
        [InlineData("mt8fm5f")]
        [InlineData("7p6w7jc")]
        [InlineData("pym9g38")]
        public void Test_Equality_Operator(string code)
        {
            AccessCode instanceA = new AccessCode(code);
            AccessCode instanceB = new AccessCode(code);
            AccessCode differentCode = new AccessCode("zv7pjzg");
            AccessCode nullCode = null;

            Assert.True(nullCode == null);

            Assert.True(instanceA == instanceB);
            Assert.True(instanceB == instanceA);

            Assert.False(instanceA == differentCode);
            Assert.False(instanceB == differentCode);

            //Nulls
            Assert.False(instanceA == null);
            Assert.False(instanceB == null);
        }

        [Theory]
        [InlineData("8xpnccc")]
        [InlineData("yt28whp")]
        [InlineData("rgfz26k")]
        [InlineData("j8zghpr")]
        [InlineData("pym9g38")]
        public void Test_Inequality_Operator(string code)
        {
            AccessCode instanceA = new AccessCode(code);
            AccessCode instanceB = new AccessCode(code);
            AccessCode differentCode = new AccessCode("zv7pjzg");
            AccessCode nullCode = null;

            Assert.True(instanceA != differentCode);
            Assert.True(instanceB != differentCode);

            Assert.False(instanceB != instanceA);
            Assert.False(instanceA != instanceB);

            //Nulls
            Assert.True(instanceA != null);
            Assert.True(instanceB != null);
            Assert.True(nullCode != instanceA);
            Assert.True(nullCode != instanceB);
        }

        [Fact]
        public void Can_Create_A_Million_Quickly_And_Length_Always_7()
        {
            for(int i=0; i<1000000; i++)
            {
                AccessCode accessCode = new AccessCode();
                Assert.Equal(7, accessCode.ToString().Length);
            }
        }

        [Theory]
        [InlineData("bdyjgjr", 7)]
        [InlineData("fj4hxjy", Constants.Unlimited)]
        [InlineData("87t6hrk", Constants.Unlimited)]
        [InlineData("3zvpqmf", Constants.Unlimited)]
        [InlineData("g", 1)]
        [InlineData("Z", 1)]
        [InlineData("234", 3)]
        [InlineData("BDYjgjrfj4Hxjy", 14)] //case-insensitive for the parsing to facilitate manual entry
        [InlineData("fj4Hxjy", 7)] //case-insensitive for the parsing to facilitate manual entry
        public void Is_Valid_Format(string code, int length)
        {
            Assert.True(AccessCode.IsValidFormat(code, length));
        }

        [Theory]
        [InlineData("1dyjgjr")] //invalid chars
        [InlineData("m00cow")] //invalid chars
        [InlineData("bahb4ahsh33ps")] //invalid chars
        [InlineData("")]
        [InlineData(null)]
        [InlineData("gkcjgtbb")] //too long
        [InlineData("gkcjg")] //too short
        [InlineData(" ")] //too whitespacey
        [InlineData("\tbdyjgjr ")] //too whitespacey
        [InlineData("bdyjgjr\n")] //too whitespacey
        public void Is_Not_Valid_Format(string code)
        {
            Assert.False(AccessCode.IsValidFormat(code));
        }

        [Theory]
        [InlineData("xqzjm4x")]
        [InlineData("zdqdzfb")]
        [InlineData("gkcjgtb")]
        [InlineData("p72WTJz")]
        [InlineData("dzrvzwk")]
        [InlineData("5d52zvg")]
        [InlineData("rqqzm9j")]
        [InlineData("G7KBH3X")]
        public void Roundtrips_To_Lower(string code)
        {
            string expected = code.ToLowerInvariant();
            Assert.Equal(expected, new AccessCode(code).ToString());
        }

        [Theory]
        [InlineData("4bfxyzc", "fjJM1af3UJjO2Y/Ojc/c6A==", "RPfXvHLaMNR/hoxQSt1pRg==", "ugtOVbN05wv307JPLJykTw==")]
        [InlineData("2ck3vyr", "xD/1gwnErGePmv08oq9fdg==", "Q5Isdr5Eda4wRv0mZNN/BQ==", "vbMIefWtMYIHqGGKdSwZJw==")]
        [InlineData("r55mwqk", "bAQRNyUoeJbrQeOA1Nd6hA==", "A0EpQo8n6/QYaKZWDy2R8Q==", "VLt1ahW+5eyCVUkUo7iqLA==")]
        public void Decrypts_As_Expected(string code, string encrypted128, string encrypted192, string encrypted256 )
        {
            Assert.Equal(code, AccessCode.FromEncryptedString(encrypted128, key128, iv).ToString());
            Assert.Equal(code, AccessCode.FromEncryptedString(encrypted192, key192, iv).ToString());
            Assert.Equal(code, AccessCode.FromEncryptedString(encrypted256, key256, iv).ToString());
        }

        [Theory]
        [InlineData("wgp9t3v", "anZJKqNUBjPs1tSzKP80jg==", "Qe359792bExLjzZ5NQZj3w==", "lAd5XDBWbbWPlJlIFZAiNw==")]
        [InlineData("9963t8b", "73fcN2OfwG5Y+pRRlaAzuA==", "HOpM22SlODakOrzWukKGxA==", "yaW8RCjLUh7c6zEq1EAAUg==")]
        [InlineData("7pt4b5k", "B1ZDo9Dz9u6To/OBvDObqg==", "/YFN0fLB3I0wD/UYGYIu/A==", "R70Ots4mr4rgo1bJAOhG/Q==")]
        public void Encrypts_As_Expected(string code, string expected128, string expected192, string expected256 )
        {
            string encrypted128 = new AccessCode(code).ToEncryptedString(key128, iv);
            Assert.Equal(expected128, encrypted128);

            string encrypted192 = new AccessCode(code).ToEncryptedString(key192, iv);
            Assert.Equal(expected192, encrypted192);

            string encrypted256 = new AccessCode(code).ToEncryptedString(key256, iv);
            Assert.Equal(expected256, encrypted256);
        }

        [Fact]
        public void Can_Roundtrip_Encrypt_And_Encrypted_Data_Always_24_Chars()
        {
            foreach (byte[] key in keys)
            {
                foreach (byte[] iv in ivs)
                {
                    for (int i = 0; i < 1024; i++) //probably 255 more than we need to test, but whatever
                    {
                        AccessCode expected = new AccessCode();
                        string encrypted = expected.ToEncryptedString(key, iv);
                        Assert.Equal(24, encrypted.Length);
                        //toh.WriteLine(encrypted);
                        AccessCode accessCode = AccessCode.FromEncryptedString(encrypted, key, iv);
                        Assert.Equal(expected.ToString(), accessCode.ToString());                        
                    }
                }
            }
        }

        [Fact]
        public void Fails_For_Invalid_Decrypt()
        {
            string encWithKey128AndIv = "NSRrqjRyjn1znYEVQez57A==";
            AccessCode.FromEncryptedString(encWithKey128AndIv, key128, iv); //this line should NOT fail

            //This might not catch all cases of bad decryption? (i.e. where EncryptionHelper catches a failure and returns null
            //because the key or the iv or the data is bad) but we expect a more useful exception when it does
            Assert.ThrowsAny<ArgumentException>(() => AccessCode.FromEncryptedString(encWithKey128AndIv, key192, iv));
            Assert.ThrowsAny<ArgumentException>(() => AccessCode.FromEncryptedString(encWithKey128AndIv, key256, iv));
            Assert.ThrowsAny<ArgumentException>(() => AccessCode.FromEncryptedString(encWithKey128AndIv, anotherKey128, iv));
            Assert.ThrowsAny<ArgumentException>(() => AccessCode.FromEncryptedString(encWithKey128AndIv, key128, anotherIv));
        }



        // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //



        /// <summary>
        /// Tests that cover the utility methods to encode/decode longs and ulongs using the same set of
        /// characters that the AccessCode uses. Essentially an esoteric version of base27, which by virtue
        /// of using that set of characters is easier to type. Typically we'd use this in URLS with access codes
        /// to encode information like NumberId etc... as part of those transcription-friendly URLS. 
        /// </summary>
        public class CharacterEncodingTests
        {
            [Fact]
            public void Can_Encode_Long_Zero_Using_AccessCode_Chars()
            {
                Assert.Equal("k", AccessCode.EncodeLongAsString(0));
            }

            [Fact]
            public void Can_Decode_Long_Zero_Using_AccessCode_Chars()
            {
                Assert.Equal((long)0, AccessCode.DecodeStringAsLong("k"));
            }

            [Fact]
            public void Can_Encode_ULong_Zero_Using_AccessCode_Chars()
            {
                Assert.Equal("k", AccessCode.EncodeULongAsString(0));
            }

            [Fact]
            public void Can_Decode_ULong_Zero_Using_AccessCode_Chars()
            {
                Assert.Equal((ulong)0, AccessCode.DecodeStringAsULong("k"));
            }

            [Theory]
            [InlineData(Int64.MaxValue, "3xvmdc9tpx474r")] //9223372036854775807
            [InlineData(4611686018427387903, "fp6g2436f2v9vv")]
            [InlineData(562949953421311, "36yq5qmbyx7")]
            [InlineData(140737488355327, "jvd7fwj6fy")]
            [InlineData(Int32.MaxValue, "9w2zvb7")] //max int32
            [InlineData(524287, "n29f")]
            [InlineData(262143, "5dhk")]
            [InlineData(131071, "q2c5")]
            [InlineData(32767, "f2rh")]
            [InlineData(8191, "tq7")]
            [InlineData(255, "8v")]
            [InlineData(127, "m6")]
            [InlineData(7, "x")]
            [InlineData(3, "p")]
            [InlineData(1, "f")]
            [InlineData(0, "k")]
            [InlineData(Int64.MinValue, "3xvmdc9tpx474n")]
            [InlineData(-4611686018427387904, "ptm6njdpmr8h7v")]
            [InlineData(-18014398509481984, "mwc3m96p4rptf4")]
            [InlineData(-268435456, "mw4d2g7cwzjz2k")]
            [InlineData(-33554432, "mw4d2g7ymqjfy9")]
            [InlineData(-65536, "mw4d2g7yqgjvrj")]
            [InlineData(-8192, "mw4d2g7yqgc7hw")]
            [InlineData(-4, "mw4d2g7yqgccyc")]
            public void Can_Encode_Long(long value, string expected)
            {
                string actual = AccessCode.EncodeLongAsString(value);
                Assert.Equal(expected, actual);
            }

            [Theory]
            [InlineData(UInt64.MaxValue, "mw4d2g7yqgccy4")]
            [InlineData(4611686018427387903, "fp6g2436f2v9vv")]
            [InlineData(1152921504606846975, "xj72nxt54hwz8")]
            [InlineData(288230376151711743, "f4y4bfzpv47vg")]
            [InlineData(72057594037927935, "vrntb6xh6hpp")]
            [InlineData(18014398509481983, "pq58jjd2j7ck")]
            [InlineData(1125899906842623, "9v2vnv8w2wc")]
            [InlineData(17592186044415, "3dxc5j69bv")]
            [InlineData(16383, "yvc")]
            [InlineData(255, "8v")]
            [InlineData(3, "p")]
            [InlineData(UInt64.MinValue, "k")] //0
            public void Can_Encode_ULong(ulong value, string expected)
            {
                string encoded = AccessCode.EncodeULongAsString(value);
                Assert.Equal(expected, encoded);
            }

            [Theory]
            [InlineData("3xvmdc9tpx474r", Int64.MaxValue)] //max long (int64)
            [InlineData("vxyvgf3qfgj77", 1844674407370955161)]
            [InlineData("3v84pk9yc46zj", 368934881474191032)]
            [InlineData("w8fd2dy9hpz", 2951479051793528)]
            [InlineData("3ztf62nfpqm", 590295810358705)]
            [InlineData("p3hxx98b2w", 23611832414348)]
            [InlineData("9w2zvb7", Int32.MaxValue)] //2147483647
            [InlineData("p4d5bfr", 1511157274)]
            [InlineData("cfjrhg", 302231454)]
            [InlineData("yb98d", 12089258)]
            [InlineData("mwyjf", 2417851)]
            [InlineData("4g8k", 483570)]
            [InlineData("m4jk", 96714)]
            [InlineData("nw7", 19342)]
            [InlineData("96", 154)]
            [InlineData("fp", 30)]
            [InlineData("q", 6)]
            [InlineData("k", 0)]
            [InlineData("3xvmdc9tpx474n", Int64.MinValue)]
            [InlineData("pnwwdhyn9bg6p9", -2305843009213693952)]
            [InlineData("m5r7jjz7j88hh2", -144115188075855872)]
            [InlineData("mw4d2g7tmxfz8p", -4294967296)]
            [InlineData("mw4d2g7yqggmft", -131072)]
            [InlineData("mw4d2g7yqgc6f3", -2048)]
            [InlineData("mw4d2g7yqgccy8", -16)]
            [InlineData("mw4d2g7yqgccy4", -1)]
            public void Can_Decode_As_Long(string encoded, long expected)
            {
                long actual = AccessCode.DecodeStringAsLong(encoded);
                Assert.Equal(expected, actual);
            }


            [Theory]
            [InlineData("mw4d2g7yqgccy4", UInt64.MaxValue)]
            [InlineData("fp6g2436f2v9vv", 4611686018427387903)]
            [InlineData("xj72nxt54hwz8", 1152921504606846975)]
            [InlineData("f4y4bfzpv47vg", 288230376151711743)]
            [InlineData("vrntb6xh6hpp", 72057594037927935)]
            [InlineData("pq58jjd2j7ck", 18014398509481983)]
            [InlineData("9v2vnv8w2wc", 1125899906842623)]
            [InlineData("f84hbp37tpj", 281474976710655)]
            [InlineData("ggvpttwr8", 4398046511103)]
            [InlineData("p4pkz3zng", 1099511627775)]
            [InlineData("nx56xvbp", 274877906943)]
            [InlineData("qg7myp9k", 68719476735)]
            [InlineData("mjx5fv", 67108863)]
            [InlineData("fmg7k8", 16777215)]
            [InlineData("f74", 1023)]
            [InlineData("k", UInt64.MinValue)] //0
            public void Can_Decode__As_ULong(string encoded, ulong expected)
            {
                ulong actual = AccessCode.DecodeStringAsULong(encoded);
                Assert.Equal(expected, actual);
            }

            private string EncodeGuidWithULong(Guid guid)
            {
                byte[] bytes = guid.ToByteArray();
                ulong foo = BitConverter.ToUInt64(bytes, 0);
                ulong bar = BitConverter.ToUInt64(bytes, 8);
                string result = AccessCode.EncodeULongAsString(foo) + "." + AccessCode.EncodeULongAsString(bar);
                return result;
            }

            private string EncodeGuidWithLong(Guid guid)
            {
                byte[] bytes = guid.ToByteArray();
                long foo = BitConverter.ToInt64(bytes, 0);
                long bar = BitConverter.ToInt64(bytes, 8);
                string result = AccessCode.EncodeLongAsString(foo) + "." + AccessCode.EncodeLongAsString(bar);
                return result;
            }

            [Theory]
            [InlineData("f428a306-9427-49b9-8bbc-92c6d3fd4f9b", "fd72mz5n7d4kpr.3bg9p9f4wn6qmx")]
            [InlineData("e833ef1e-9525-4763-baa1-47e826621a4e", "fxx8265bd6v55n.f757tz3ft73c72")]
            [InlineData("92077dc8-cee2-4a4d-bef8-644fc9cc70bc", "fdjpyxr8nytgmz.p8vhxgrxfy7fdn")]
            [InlineData("952d67fa-0b5a-4a51-9f79-c2dede9e97e4", "fdjdqb9hjnkyhw.mfbf5nfg73n8gq")]
            [InlineData("045bcf87-fe6a-48e0-a0af-0fb8774db313", "fxnj3dh8dm689r.8v86jm65925mh")]
            [InlineData("1474c2d4-7847-4136-b053-a13667e65cd0", "fmdd34hdd2frt8.p6ky2bhxbkb44k")]
            [InlineData("b07e367e-651f-4a74-bec1-6754a28a40d6", "fdb3gh7h244w2q.pczmbhg2jvftxd")]
            [InlineData("3c1afd45-99a3-421f-bca2-cfe81aaca115", "fmb3ymnt2hpqmt.777gbndpfhjg3")]
            public void Can_Encode_Guid_As_Two_ULongs(string value, string expected)
            {
                string actual = EncodeGuidWithULong(Guid.Parse(value));
                Assert.Equal(expected, actual);
            }

            /*
                Observations on using AccessCode chars to encode Guids:
                    - A Guid is 16 bytes, a long or ulong is 8
                    - Because it treats the values as numbers the length will be variable, so we need a divider to delineate the two encoded strings
                    - The length of the encoded value is barely smaller than a raw guid in string format
                    - So the usefullness of using accesscode chars to encode a guid is limited
            */

            [Theory]
            [InlineData("988c2753-1ed8-4e42-a4e5-f8fed88bef90", "f7g7bhzm632w4q.3ggjvzphkdtkrh")]
            [InlineData("162bde02-7ff6-4774-b453-aa127c3dab3a", "fxd9cmgtvv56fp.ffmv4f4h89tdp5")]
            [InlineData("c6495fcd-e12f-44f7-973c-65d302e0efe8", "fq3nv8kv9gm5tp.mpy738dfq8hx7b")]
            [InlineData("bfc97949-559e-499c-be74-1a1fa425b57a", "fd8m9t33fpw7xw.3m4g3275bj849p")]
            [InlineData("9206cc46-e8be-4275-a776-232e9a3ca97b", "fm4vykxhfkmfgz.3984cv3c9x93md")]
            [InlineData("95268ce4-3539-459a-8897-5cafa5c9f268", "fqt97m2hpwyx98.fz78bf4m9xqwnj")]
            [InlineData("e793593b-41f1-454e-b192-3db8cb6544df", "fqx8w6fkqky326.pn9kyzw486mr5n")]
            [InlineData("8b9bc81a-612a-4334-91c3-9fa378b30b4c", "f9xp9h4rgrtwtm.f856tky3c7jjy6")]
            public void Can_Encode_Guid_As_Two_Longs(string value, string expected)
            {
                string actual = EncodeGuidWithLong(Guid.Parse(value));
                Assert.Equal(expected, actual);
            }

            [Fact]
            public void Assert_Long_ULong_Equivelance_Using_AccessCode_Chars()
            {
                for (long l = Int64.MinValue; l <= -1; l /= 2)
                {
                    ulong expected = (ulong)l;
                    string encodedLong = AccessCode.EncodeLongAsString(l);
                    ulong decodedAsUlong = AccessCode.DecodeStringAsULong(encodedLong);
                    Assert.Equal(expected, decodedAsUlong);
                }

                for (long l = Int64.MaxValue; l >= 1; l /= 2)
                {
                    ulong expected = (ulong)l;
                    string encodedLong = AccessCode.EncodeLongAsString(l);
                    ulong decodedAsUlong = AccessCode.DecodeStringAsULong(encodedLong);
                    Assert.Equal(expected, decodedAsUlong);

                    //For the positive numbers we expect that an encoded long and encoded ulong give the same string
                    string encodedULong = AccessCode.EncodeULongAsString((ulong)l);
                    Assert.Equal(encodedULong, encodedLong);
                }
            }
        }

    }
}
