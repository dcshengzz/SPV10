using QRCoder;
using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;

namespace swz.Clover.Security.Providers
{
    public class GoogleAuthenticator
    {
        public const int IntervalLength = 30;
        const int PinLength = 6;
        static readonly int PinModulo = (int)Math.Pow(10, PinLength);
        static readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        /// <summary>
        /// Encodes the secret as Base32 suitable for inclusion in email etc... for user to type it
        /// </summary>
        /// <param name="secret"></param>
        /// <returns></returns>
        public static string GenerateEncodedKey(byte[] secret)
        {
            return Encoder.Base32Encode(secret);
        }

        /// <summary>
        /// Add some spaces to an encoded secret totp key to make it easier to read for humans who are typing it
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static string PrettyPrintEncodedKey(string key)
        {
            if (key == null) throw new ArgumentNullException(nameof(key));
            key = key.ToUpperInvariant();
            StringBuilder prettyKey = new StringBuilder();
            for(int i=0; i<key.Length; i++)
            {
                if (i % 4 == 0) prettyKey.Append(' ');
                prettyKey.Append(key[i]);
            }
            return prettyKey.ToString();
        }

        /// <summary>
        ///   Number of intervals that have elapsed.
        /// </summary>
        static long CurrentInterval
        {
            get
            {
                var ElapsedSeconds = (long)Math.Floor((DateTime.UtcNow - UnixEpoch).TotalSeconds);

                return ElapsedSeconds / IntervalLength;
            }
        }

        //TODO - remove the png generation from Core so we can remove the nuget dependency. 
        //       THe thing sending the email can generate it instead, its just a QR, we only care about secret here in core thanks
        public static byte[] GenerateQrCodePng(string code)
        {
            //See: https://github.com/codebude/QRCoder/issues/354
            using QRCodeGenerator qrGenerator = new QRCodeGenerator();
            using QRCodeData qrCodeData = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
            using PngByteQRCode qrCode = new PngByteQRCode(qrCodeData);
            return qrCode.GetGraphic(pixelsPerModule: 5);
        }

        /// <summary>
        ///   Generates a pin for the given key.
        /// </summary>
        public static string GeneratePin(byte[] key)
        {
            return GeneratePin(key, CurrentInterval);
        }

        /// <summary>
        ///   Generates a pin by hashing a key and counter.
        /// </summary>
        static string GeneratePin(byte[] key, long counter)
        {
            const int SizeOfInt32 = 4;

            var CounterBytes = BitConverter.GetBytes(counter);

            if (BitConverter.IsLittleEndian)
            {
                //spec requires bytes in big-endian order
                Array.Reverse(CounterBytes);
            }

            var Hash = new HMACSHA1(key).ComputeHash(CounterBytes);
            var Offset = Hash[Hash.Length - 1] & 0xF;

            var SelectedBytes = new byte[SizeOfInt32];
            Buffer.BlockCopy(Hash, Offset, SelectedBytes, 0, SizeOfInt32);

            if (BitConverter.IsLittleEndian)
            {
                //spec interprets bytes in big-endian order
                Array.Reverse(SelectedBytes);
            }

            var SelectedInteger = BitConverter.ToInt32(SelectedBytes, 0);

            //remove the most significant bit for interoperability per spec
            var TruncatedHash = SelectedInteger & 0x7FFFFFFF;

            //generate number of digits for given pin length
            var Pin = TruncatedHash % PinModulo;

            return Pin.ToString(CultureInfo.InvariantCulture).PadLeft(PinLength, '0');
        }

        #region Nested type: Encoder

        public static class Encoder
        {
            /// <summary>
            ///   Url Encoding (with upper-case hexadecimal per OATH specification)
            /// </summary>
            public static string UrlEncode(string value)
            {
                const string UrlEncodeAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~";

                var Builder = new StringBuilder();

                for (var i = 0; i < value.Length; i++)
                {
                    var Symbol = value[i];

                    if (UrlEncodeAlphabet.IndexOf(Symbol) != -1)
                    {
                        Builder.Append(Symbol);
                    }
                    else
                    {
                        Builder.Append('%');
                        Builder.Append(((int)Symbol).ToString("X2"));
                    }
                }

                return Builder.ToString();
            }

            /// <summary>
            ///   Base-32 Encoding
            /// </summary>
            public static string Base32Encode(byte[] data)
            {
                const int InByteSize = 8;
                const int OutByteSize = 5;
                const string Base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

                int i = 0, index = 0;
                var Builder = new StringBuilder((data.Length + 7) * InByteSize / OutByteSize);

                while (i < data.Length)
                {
                    int CurrentByte = data[i];
                    int Digit;

                    //Is the current digit going to span a byte boundary?
                    if (index > (InByteSize - OutByteSize))
                    {
                        int NextByte;

                        if ((i + 1) < data.Length)
                        {
                            NextByte = data[i + 1];
                        }
                        else
                        {
                            NextByte = 0;
                        }

                        Digit = CurrentByte & (0xFF >> index);
                        index = (index + OutByteSize) % InByteSize;
                        Digit <<= index;
                        Digit |= NextByte >> (InByteSize - index);
                        i++;
                    }
                    else
                    {
                        Digit = (CurrentByte >> (InByteSize - (index + OutByteSize))) & 0x1F;
                        index = (index + OutByteSize) % InByteSize;

                        if (index == 0)
                        {
                            i++;
                        }
                    }

                    Builder.Append(Base32Alphabet[Digit]);
                }

                return Builder.ToString();
            }
        }

        public const int DefaultAllowedAdjacentIntervals = 2;

        public enum Validity { 
            /// <summary>
            /// Code is valid
            /// </summary>
            Correct, 
            
            /// <summary>
            /// Code is not valid
            /// </summary>
            Incorrect,

            /// <summary>
            /// A code was accepted too recently to check again.
            /// This is to prevent potential replay attacks, so user should try again after a delay
            /// see: https://www.rfc-editor.org/rfc/rfc6238#section-5.2
            /// </summary>
            BlockedToPreventReplay
        }

        public static Validity IsValid(SecurityUser su, string code)
        {
            if (su == null) throw new ArgumentNullException(nameof(su));
            if (string.IsNullOrWhiteSpace(code)) return Validity.Incorrect;
            byte[] secret = su.ReadTotpSecret();
            if (secret == null) return Validity.Incorrect;
            DateTime? lastAcceptedTime = su.LastLoginDate; //Too much work to track explicitly, we'll just assume last login used a valid code
            return GoogleAuthenticator.IsValid(secret, code, DefaultAllowedAdjacentIntervals, lastAcceptedTime );
        }

        //TODO - we should allow the time to be checked for to be passed in so we can unit test this easily
        /// <summary>
        /// Is the TOTP code valid for the secret at the current point in time
        /// </summary>
        /// <param name="secret"></param>
        /// <param name="code"></param>
        /// <param name="checkAdjacentIntervals"></param>
        /// <param name="lastAccepted">time when a valid code was last accepted for this secret (optional)</param>
        /// <returns>validity indicator</returns>
        public static Validity IsValid(
            byte[] secret, 
            string code, 
            int checkAdjacentIntervals = DefaultAllowedAdjacentIntervals,
            DateTime? lastAccepted = null)
        {
            if (secret==null || secret.Length==0) throw new ArgumentException(nameof(secret), "Required");
            if (string.IsNullOrWhiteSpace(code)) throw new ArgumentException(nameof(code), "Required");
            if (checkAdjacentIntervals < 0) throw new ArgumentOutOfRangeException(nameof(checkAdjacentIntervals));

            if (lastAccepted != null)
            {
                //Page 7 of RFC 6238 states:
                //"Note that a prover may send the same OTP inside a given time-step
                //window multiple times to a verifier.  The verifier MUST NOT accept
                //the second attempt of the OTP after the successful validation has
                //been issued for the first OTP, which ensures one - time only use of an
                //OTP." - See https://www.rfc-editor.org/rfc/rfc6238#section-5.2
                //So, to avoid repeat use of a code, if it was already accepted while this code was considered valid
                //then we don't allow it again. (also implies legitimate user would need to wait a minute before trying)
                DateTime cutoff = DateTime.Now.AddSeconds(0 - ( (checkAdjacentIntervals+1) * IntervalLength));
                if(lastAccepted > cutoff )
                {
                    //TODO - we should refactor to return an enum so we can differentiate this from a bad code
                    //and UI can tell user to wait a minute and try again
                    return Validity.BlockedToPreventReplay;
                }
            }

            string serverPassword = GeneratePin(secret);
            if (code == serverPassword)
            {
                return Validity.Correct;
            }
                
            
            for (int i = 1; i <= checkAdjacentIntervals; i++)
            {
                string nextPass = GeneratePin(secret, CurrentInterval + i);
                if (code == nextPass)
                {
                    return Validity.Correct;
                }
                    
                string previousPass = GeneratePin(secret, CurrentInterval - i);
                if (code == previousPass)
                {
                    return Validity.Correct;
                }
            }

            return Validity.Incorrect;
        }
        #endregion
    }
}
