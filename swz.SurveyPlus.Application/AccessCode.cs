using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Security.Cryptography;
using System.Text;

namespace swz.SurveyPlus.Application
{

    /// <summary>
    /// Represents a short 'secure' code that is easy to read and type manually and is suitable for use in URLS etc.
    /// e.g. for the Direct Access urls and in Short Links. The character set used is also useful for encoding other
    /// info (such as NumberId) that might need to form part of such Urls and benefit from the same typeability and
    /// readability as the access code itself.
    /// </summary>
    public class AccessCode
    {
        private const int AccessCodeLength = 7;

        /// <summary>
        /// Chars for use in AccessCode that need to be typed (typically as part of a url or password-like field).
        /// More confusable characters like i1lo0s have been left out (keep 5 in)
        /// and drops some vowels to reduce chance of naughty words. We don't use uppercase here (and when
        /// parsing an accesscode will convert it to lower automatically. We also only use url-safe characters,
        /// and only from the set of numbers and letters (no funny symbols etc that might be harder to get at on a 
        /// mobile keyboard)
        /// </summary>
        private static readonly char[] AccessCodeChars = new char[]
        {
            //WARNING: any changes to this will break all existing AccessCodes and other data encoded using these chars
            //(Changes only to the order won't make stored codes invalid but will change the encoding for longs (and thus break
            // existing direct access and short link URLS, while changes to the set of chars will break both)
            //Changed 20221025 so the order is not quite so obvious when used for encoding numbers. Old TA AccessCodes from old
            //SurveyPlus are thus no longer compatible with this (but we aren't migrating those anyway).
            //Sadly, 'n' and 'r' are visually closer than I would like, but we shall keep them both as we need the variety
            'k','f','3','p','m','9','q','x','d','8',
            '7','t','v','5','w','g','h','2','j','6',
            'b','c','y','z','4','r','n'
        };

        // Previous order prior to 20221026
        //    '2','3','4','5','6','7','8','9','b','c',
        //    'd','f','g','h','j','k','m','n','p','q',
        //    'r','t','v','w','x','y','z'

        private static readonly Dictionary<char, int> AccessCodeCharValues = AccessCodeChars
            .Select((c, i) => new KeyValuePair<char, int>(c, i))
            .ToDictionary(ci => ci.Key, ci => ci.Value);


        /// <summary>
        /// Are all characters in this string valid for use in an access code?
        /// Check is case-insensitive
        /// </summary>
        /// <param name="accessCode"></param>
        /// <param name="expectedLength">defaults to length of an access code, but you can pass other length or unlimited to check against other lengths</param>
        /// <returns></returns>
        public static bool IsValidFormat(string accessCode, int expectedLength = AccessCodeLength)
        {
            if (string.IsNullOrWhiteSpace(accessCode)) return false;            
            if (expectedLength != Constants.Unlimited && accessCode.Length != expectedLength) return false;
            accessCode = accessCode.ToLowerInvariant();
            foreach (char c in accessCode)
            {
                if (!AccessCodeCharValues.ContainsKey(c)) return false;
            }
            return true;
        }

        /// <summary>
        /// Encodes a Long as a string using the same set of characters as used by an AccessCode
        /// (note this is not an AccessCode but will likely be used along with one in a url etc)
        /// </summary>
        /// <param name="number"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public static string EncodeLongAsString(long number)
        {
            //We now support negative numbers by way of casting to a ulong and encoding them as that
            return EncodeULongAsString((ulong)number);
        }

        public static string EncodeULongAsString(ulong number)
        {
            //For algorithm I used the following reference:
            // https://www.mathwarehouse.com/non-decimal-bases/how-to-convert-from-base-10-to-other-bases.php
            ulong theBase = (ulong)AccessCodeChars.Length;
            Stack<char> digits = new Stack<char>();
            ulong quotient = number;
            do
            {
                ulong remainder = (ulong)(quotient % theBase);
                digits.Push(AccessCodeChars[remainder]);
                quotient /= theBase;
            } while (quotient >= theBase);
            if (quotient > 0)
            {
                digits.Push(AccessCodeChars[quotient]);
            }
            string code = digits.Aggregate(new StringBuilder(), (builder, digit) => builder.Append(digit)).ToString();
            return code;
        }

        /// <summary>
        /// Decodes a string that uses the same set of access code characters into a Long (i.e was encoded with EncodeLongAsString)
        /// (note this string is not itself an AccessCode but will likely be used along with one in a url etc)
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentException"></exception>
        public static long DecodeStringAsLong(string code)
        {
            return (long)DecodeStringAsULong(code);
        }

        public static ulong DecodeStringAsULong(string code)
        {
            try
            {
                code = code.ToLowerInvariant();
                ulong theBase = (ulong)AccessCodeChars.Length; //i.e. 27
                ulong number = 0;
                for (int position = code.Length - 1; position >= 0; position--)
                {
                    char digit = code[position];
                    ulong digitBaseValue = (ulong)AccessCodeCharValues[digit]; // i.e 0..27
                    //Math.Pow will sabo us up near max long due to floating point innacuracy, use BigInteger.Pow instead
                    //see: https://stackoverflow.com/a/4297478/8243046
                    //btw we might get better performance using a lookup table here, but its not urgent
                    ulong weight = (ulong)BigInteger.Pow(theBase, (code.Length - position - 1));
                    ulong value = digitBaseValue * weight;
                    number += value;
                }
                return number;
            }
            catch (Exception)
            {
                throw new ArgumentException(nameof(code), "Unable to decode this string using access code characters");
            }
        }

        /// <summary>
        /// If passed null or empty string will return null, otherwise will use the string constructor for accesscode.
        /// FormatException is thrown for an invalid code.
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static AccessCode FromString(string code)
        {
            return string.IsNullOrEmpty(code) ? null : new AccessCode(code);
        }

        public static AccessCode FromEncryptedString(string encryptedAccessCodeBase64, byte[] key, byte[] iv)
        {
            if (string.IsNullOrEmpty(encryptedAccessCodeBase64)) return null;
            string decryptedDirectAccessCodeString = EncryptionHelper.DecryptStr(encryptedAccessCodeBase64, key, iv);
            if (decryptedDirectAccessCodeString==null) throw new ArgumentException(nameof(encryptedAccessCodeBase64), "Invalid data");
            return new AccessCode(decryptedDirectAccessCodeString);
        }

        public static bool operator ==(AccessCode lhs, AccessCode rhs)
        {
            if (Object.ReferenceEquals(lhs, null)) return Object.ReferenceEquals(rhs, null);
            return lhs.Equals(rhs);
        }

        public static bool operator !=(AccessCode lhs, AccessCode rhs) => !(lhs == rhs);

        private readonly string value;

        public AccessCode()
        {
            RandomNumberGenerator rnd = RandomNumberGenerator.Create();
            byte[] rndBytes = new byte[AccessCodeLength];
            rnd.GetBytes(rndBytes);
            char[] accessCode = new char[AccessCodeLength];
            for (int i = 0; i < AccessCodeLength; i++)
            {
                int c = rndBytes[i] % AccessCodeChars.Length;
                accessCode[i] = AccessCodeChars[c];
            }
            value = new string(accessCode);
        }

        /// <summary>
        /// Create an instance from a string representtion.
        /// Will automatcally convert to lowercase.
        /// </summary>
        /// <param name="code"></param>
        /// <exception cref="ArgumentException"></exception>
        /// <exception cref="FormatException">thrown if the string does not represent a valid AccessCode</exception>
        [JsonConstructor]
        public AccessCode(string code)
        {
            if (string.IsNullOrEmpty(code)) throw new ArgumentException("Required", nameof(code));
            if (!IsValidFormat(code)) throw new FormatException($"Invalid {nameof(AccessCode)} format");
            value = code.ToLowerInvariant();
        }

        public override bool Equals(object obj)
        {
            return obj is AccessCode utils && value == utils.value;
        }

        public override int GetHashCode()
        {
            return value.GetHashCode();
        }

        public override string ToString()
        {
            return value;
        }

        public string ToEncryptedString(byte[] key, byte[] iv)
        {
            //We could encode the access code as a long and encrypt the bytes of that (smaller than the string!),
            //but EncryptionHelper only works with string data. Or we could do our own encryption, but lazy
            string encryptedAccessCodeBase64 = EncryptionHelper.EncryptStr(value, key, iv);
            return encryptedAccessCodeBase64;
        }

    }
}
