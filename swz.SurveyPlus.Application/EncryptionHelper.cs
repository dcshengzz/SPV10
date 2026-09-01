using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;

namespace swz.SurveyPlus.Application
{

    /// <summary>
    /// Utility methods for working with encryption and passwords
    /// </summary>
    public class EncryptionHelper
    {
#if DEBUG
        //With the changes in commit a18242f you can at least reference this class now but of course if you
        //reference it before DefaultApplicationLogging is initialised then all the logging here wont work
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger<EncryptionHelper>();
#endif

        private static readonly char[] Punctuations = "!@#$%^&*()_-+=[{]};:>|./?".ToCharArray();

        public static string EncryptStr(string qnnId, string listSampleId, string dplyId,
            string userId, string dateStart, string delimiter, string key, string iv)
        {
            var temp = $"{qnnId}{delimiter}{listSampleId}{delimiter}{dplyId}{delimiter}{userId}{delimiter}{dateStart}";
            return EncryptStr(temp, key, iv);
        }

        public static string EncryptStr(string plainText, string key, string iv)
        {
            var keyBytes = Bytes(key);
            var ivBytes = Bytes(iv);

            var encrypted = EncryptStringToBytes(plainText, keyBytes, ivBytes);
            return Convert.ToBase64String(encrypted);
        }

        public static string EncryptStr(string plainText, byte[] keyBytes, byte[] ivBytes)
        {
            byte[] encrypted = EncryptStringToBytes(plainText, keyBytes, ivBytes);
            return Convert.ToBase64String(encrypted);
        }

        /// <summary>
        /// Get a string as byte array in the MSB-stripping legacy way that EncryptStr / DecryptStr do
        /// i.e. Select(x => (byte) x).ToArray();
        /// (WARNING: This is anyhow just casting each char to a byte with no care for encoding.
        /// Since char datatype is actually a 2 byte UTF-16 value, doing this will quietly strip 
        /// the most significant bits from each char in the sequence. For char values < 256 
        /// (i.e. ascii stuff) this won't change the value, but if it is > 255 then information is lost. 
        /// For more details and test cases demonstrating this refer to the TestEncryptionHelper class).
        /// </summary>
        public static byte[] Bytes(string s)
        {
            //WARNING: although the technique is 'wrong' it is retained to avoid breaking old code/data
            return s.Select(x => (byte)x).ToArray();
        }

        public static string DecryptStr(string encryptedData, string key, string iv)
        {
            try
            {
                var encryptedDataAsBytes = Convert.FromBase64String(encryptedData);
                var keyBytes = Bytes(key);
                var ivBytes = Bytes(iv);
                var roundtrip = DecryptStringFromBytes(encryptedDataAsBytes, keyBytes, ivBytes);

                return roundtrip;
            }
#if DEBUG
            catch (Exception e)
            {
                Logger.LogDebug(e.Message);
                return null;
            }
#endif
#if !DEBUG
            catch (Exception)
            {
                return null; //Swallow details for security reasons, return null to indicate failure
            }
#endif
        }

        public static string DecryptStr(string encryptedData, byte[] keyBytes, byte[] ivBytes)
        {
            try
            {
                byte[] encryptedDataAsBytes = Convert.FromBase64String(encryptedData);
                string roundtrip = DecryptStringFromBytes(encryptedDataAsBytes, keyBytes, ivBytes);
                return roundtrip;
            }
#if DEBUG
            catch (Exception e)
            {
                Logger.LogDebug(e.Message);
                return null;
            }
#endif
#if !DEBUG
            catch (Exception)
            {
                return null; //swallow details to avoid exposing information here, return null to indicate failure
            }
#endif
        }

        public class EncryptStringToBytesException : Exception
        {
            public EncryptStringToBytesException(string message, Exception innerException) : base(message, innerException) { }
        }

        private static byte[] EncryptStringToBytes(string plainText, byte[] Key, byte[] IV)
        {
            // Check arguments.
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            if (IV == null || IV.Length <= 0)
                throw new ArgumentNullException("IV");
            byte[] encrypted;


            //Fixed for SVP-06 for MPA SCR 2022-04-29
            try
            {
                // Create an Aes object - changed from the obsolete RijndaelManaged 2022-08-21
                //                      - use Aes.Create() instead of Aes.Create("AesManaged") SYSLIB0045 2024-12-30
                //See: https://stackoverflow.com/a/70212529
                //     https://stackoverflow.com/questions/45473884
                using (Aes aes = Aes.Create())
                {
                    aes.Key = Key;
                    aes.IV = IV; //initialisation vector

                    // Create an encryptor to perform the stream transform.
                    var encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                    // Create the streams used for encryption.
                    using (var msEncrypt = new MemoryStream())
                    {
                        using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                        {
                            using (var swEncrypt = new StreamWriter(csEncrypt))
                            {
                                //Write all data to the stream.
                                swEncrypt.Write(plainText);
                            }

                            encrypted = msEncrypt.ToArray();
                        }
                    }
                }

                // Return the encrypted bytes from the memory stream.
                return encrypted;
            }
            catch (IOException ioEx)
            {
                throw new EncryptStringToBytesException("Failed to write stream from a string", ioEx);
            }
            catch (Exception e)
            {
                throw new EncryptStringToBytesException("Unable to encrypt into bytes from string", e);
            }
        }

        private static string DecryptStringFromBytes(byte[] cipherText, byte[] Key, byte[] IV)
        {
            // Check arguments.
            if (cipherText == null || cipherText.Length <= 0)
                throw new ArgumentNullException("cipherText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            if (IV == null || IV.Length <= 0)
                throw new ArgumentNullException("IV");

            // Declare the string used to hold
            // the decrypted text.
            string plaintext = null;

            // Create an Aes object - changed from the obsolete RijndaelManaged 2022-08-21
            //                      - use Aes.Create() instead of Aes.Create("AesManaged") SYSLIB0045 2024-12-30
            //See: https://stackoverflow.com/a/70212529
            //     https://stackoverflow.com/questions/45473884
            using (Aes aes = Aes.Create())
            {
                aes.Key = Key;
                aes.IV = IV;

                // Create a decryptor to perform the stream transform.
                var decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                // Create the streams used for decryption.
                using (var msDecrypt = new MemoryStream(cipherText))
                {
                    using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (var srDecrypt = new StreamReader(csDecrypt))
                        {
                            // Read the decrypted bytes from the decrypting stream
                            // and place them in a string.
                            plaintext = srDecrypt.ReadToEnd();
                        }
                    }
                }
            }

            return plaintext;
        }

        public static string GeneratePassword(int length, int numberOfNonAlphanumericCharacters, bool? alphaCharactersLowercaseOnly = null)
        {
            if (length < 1 || length > 128) throw new ArgumentException(nameof(length));

            if (numberOfNonAlphanumericCharacters > length || numberOfNonAlphanumericCharacters < 0)
                throw new ArgumentException(nameof(numberOfNonAlphanumericCharacters));

            using (var rng = RandomNumberGenerator.Create())
            {
                var byteBuffer = new byte[length];

                rng.GetBytes(byteBuffer);

                var count = 0;
                var characterBuffer = new char[length];

                for (var iter = 0; iter < length; iter++)
                {
                    var i = byteBuffer[iter] % 87;

                    if (i < 10)
                    {
                        characterBuffer[iter] = (char) ('0' + i);
                    }
                    else if (i < 36)
                    {
                        if(alphaCharactersLowercaseOnly==null || !alphaCharactersLowercaseOnly.Value)
                        {
                            characterBuffer[iter] = (char) ('A' + i - 10);
                        }
                        else
                        {
                            characterBuffer[iter] = (char)('a' + i - 10);
                        }

                    }
                    else if (i < 62)
                    {
                        if (alphaCharactersLowercaseOnly == null || alphaCharactersLowercaseOnly.Value)
                        {
                            characterBuffer[iter] = (char)('a' + i - 36);
                        }
                        else
                        {
                            characterBuffer[iter] = (char)('A' + i - 36);
                        }
                    }
                    else
                    {
                        if (alphaCharactersLowercaseOnly != null)
                        {
                            if (alphaCharactersLowercaseOnly.Value)
                            {
                                characterBuffer[iter] = (char)('a' + i - 62);
                            }
                            else
                            {
                                characterBuffer[iter] = (char)('A' + i - 62);
                            }
                        }
                        else
                        {
                            characterBuffer[iter] = Punctuations[i - 62];
                            count++;
                        }

                    }
                }

                if (count >= numberOfNonAlphanumericCharacters) return new string(characterBuffer);

                int j;

                for (j = 0; j < numberOfNonAlphanumericCharacters - count; j++)
                {
                    int k;
                    do
                    {
                        k = RandomInt(0, length);
                    } while (!char.IsLetterOrDigit(characterBuffer[k]));

                    characterBuffer[k] = Punctuations[RandomInt(0, Punctuations.Length)];
                }

                return new string(characterBuffer);
            }
        }

        public enum CharType
        {
            Special = -1,
            LowercaseAndNumerals = 0,
            Numerals = 1,
            Lowercase = 2,
            UpperCase = 3
        }

        /// <summary>
        /// Generate random chars by given type
        /// </summary>
        /// <param name="length">Number of chars to be returned</param>
        /// <param name="type">(See CharType enum) 0: lowercase and numerals; 1: numerals; 2: lowercase; 3: uppercase; others: special character</param>
        /// <returns>string</returns>
        public static string GenerateChars(int length, CharType type)
        {
            if (type == CharType.LowercaseAndNumerals) return GeneratePassword(length, 0, true); //lower case and numerals

            using (var rng = RandomNumberGenerator.Create())
            {
                var byteBuffer = new byte[length];

                rng.GetBytes(byteBuffer);

                var characterBuffer = new char[length];

                switch (type)
                {
                    case CharType.Numerals:
                        for (var iter = 0; iter < length; iter++)
                        {

                            int i = byteBuffer[iter] % 10;
                            characterBuffer[iter] = (char)('0' + i);
                        }

                        break;
                    case CharType.Lowercase:
                        for (var iter = 0; iter < length; iter++)
                        {

                            int i = byteBuffer[iter] % 26;
                            characterBuffer[iter] = (char)('a' + i);
                        }

                        break;
                    case CharType.UpperCase:
                        for (var iter = 0; iter < length; iter++)
                        {

                            int i = byteBuffer[iter] % 26;
                            characterBuffer[iter] = (char)('A' + i);
                        }

                        break;
                    default: //Special Characters
                        for (var iter = 0; iter < length; iter++)
                        {

                            int i = byteBuffer[iter] % 25;
                            characterBuffer[iter] = Punctuations[i];
                        }

                        break;
                }


                return new string(characterBuffer);
            }

        }

        /// <exception cref="ArgumentOutOfRangeException"><paramref name="min" /> is greater than <paramref name="max" />.</exception>
        public static int RandomInt(int min, int max)
        {
            if (min > max) throw new ArgumentOutOfRangeException(nameof(min));
            if (min == max) return min;

            //... old code
            // SFWKZ - 04   Insecure Randomess
            // Use RNGCryptoServiceProvider for generating safe random numbers
            /*using (var rng = new RNGCryptoServiceProvider())*/
            //...

            // 20231214 - RNGCryptoServiceProvider is obsolete from Net6 onwards so use RandomNumberGenerator.Create instead
            //See:
            //  https://learn.microsoft.com/en-us/dotnet/fundamentals/syslib-diagnostics/syslib0023
            //  https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.randomnumbergenerator?view=net-6.0
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                var data = new byte[4];
                rng.GetBytes(data);

                int generatedValue = Math.Abs(BitConverter.ToInt32(data, 0));

                int diff = max - min;
                int mod = generatedValue % diff;
                int normalizedNumber = min + mod;

                return normalizedNumber;
            }
        }

        //This can be replaced by RandomNumberGenerator.GetBytes() now
        /// <summary>
        /// Some syntactic sugar to generate n bytes using a crypto rng
        /// </summary>
        /// <param name="n">number of bytes</param>
        /// <returns></returns>
        public static byte[] GenerateBytes(int n)
        {
            if (n < 0) throw new ArgumentOutOfRangeException(nameof(n));
            using (var rng = RandomNumberGenerator.Create())
            {
                var byteBuffer = new byte[n];
                rng.GetBytes(byteBuffer);
                return byteBuffer;
            }
        }

        /// <summary>
        /// Generates a random string of the specified number of characters using only alphanumeric characters.
        /// Not recommended for nonce generation except where there is a specific requirement to restrict the generated
        /// nonce to alphanumeric values. 
        /// </summary>
        public static string RandomAlphanumericString(int length)
        {
            if (length <= 0) throw new ArgumentOutOfRangeException(nameof(length), length, "May not be zero or negative");
            Random random = new Random(); //TODO - This is not crytographically secure and should not be used in a security context
            string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var randomString = new StringBuilder();
            for (int i = 0; i < length; i++)
            {
                randomString.Append(validChars[random.Next(0, validChars.Length - 1)]);
            }

            return randomString.ToString();
        }

    } //end of EncryptionHelper
}