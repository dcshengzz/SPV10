using System;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace swz.Clover.Core.Utils
{

    public static class HashHelper
    {
        public static string GenerateSalt()
        {
            var data = new byte[0x10];
            RandomNumberGenerator.Create().GetBytes(data);
            return Convert.ToBase64String(data);
        }

        public static string GenerateStringHash(string stringForHashing, string salt)
        {
            //SFWKZ - 16   Weak Cryptographic Hash
            //Changed from SHA1 to SHA512
            return GenerateStringHash(stringForHashing, salt, SHA512.Create());
        }

        public static string GenerateStringHash(string stringForHashing, HashAlgorithm hashAlgorithm)
        {
            if (hashAlgorithm is KeyedHashAlgorithm)
                throw new NotSupportedException("It is impossible to create Hash with KeyedHashAlgorithm and empty Salt");

            return GenerateStringHash(stringForHashing, string.Empty, hashAlgorithm);
        }

        public static string GenerateStringHash(string stringForHashing, string salt, HashAlgorithm hashAlgorithm)
        {
            return Convert.ToBase64String(GenerateBinaryHash(stringForHashing, salt, hashAlgorithm));
        }

        public static byte[] GenerateBinaryHash(string stringForHashing)
        {
            return GenerateBinaryHash(stringForHashing, string.Empty, MD5.Create());
        }

        public static byte[] GenerateBinaryHash(string stringForHashing, string salt, HashAlgorithm hashAlgorithm)
        {
            byte[] bytes = Encoding.Unicode.GetBytes(stringForHashing);
            byte[] src = Convert.FromBase64String(salt);
            byte[] inArray;
            var algorithm = hashAlgorithm as KeyedHashAlgorithm;
            if (algorithm != null)
            {
                var keyedHashAlgorithm = algorithm;
                if (keyedHashAlgorithm.Key.Length == src.Length)
                {
                    keyedHashAlgorithm.Key = src;
                }
                else if (keyedHashAlgorithm.Key.Length < src.Length)
                {
                    var dst = new byte[keyedHashAlgorithm.Key.Length];
                    Buffer.BlockCopy(src, 0, dst, 0, dst.Length);
                    keyedHashAlgorithm.Key = dst;
                }
                else
                {
                    int count;
                    var buffer = new byte[keyedHashAlgorithm.Key.Length];
                    for (int i = 0; i < buffer.Length; i += count)
                    {
                        count = Math.Min(src.Length, buffer.Length - i);
                        Buffer.BlockCopy(src, 0, buffer, i, count);
                    }
                    keyedHashAlgorithm.Key = buffer;
                }

                inArray = keyedHashAlgorithm.ComputeHash(bytes);
            }
            else
            {
                var buffer = new byte[src.Length + bytes.Length];
                Buffer.BlockCopy(src, 0, buffer, 0, src.Length);
                Buffer.BlockCopy(bytes, 0, buffer, src.Length, bytes.Length);
                inArray = hashAlgorithm.ComputeHash(buffer);
            }

            return inArray;
        }

        public static Guid FromMethodInfo(MethodInfo methodInfo, Type type)
        {
            string assemblyAndClassAndMethod = type.GetTypeInfo().Assembly.FullName.Split(',')[0] + type.GetTypeInfo().FullName + methodInfo.Name;
            string result = assemblyAndClassAndMethod + "(";
            foreach (ParameterInfo paramInfo in methodInfo.GetParameters())
                result += paramInfo.ParameterType + ",";
            if (methodInfo.GetParameters().Length > 0)
                string.Format("{0})", result.Remove(result.Length - 1, 1));
            else
                result += ")";
            return new Guid(GenerateBinaryHash(result));
        }

        public static Guid FromParameterInfo(ParameterInfo parameterInfo, Type type)
        {
            MethodInfo methodInfo = (MethodInfo)parameterInfo.Member;
            string assemblyAndClassAndMethod = type.GetTypeInfo().Assembly.FullName.Split(',')[0] + type.GetTypeInfo().FullName + methodInfo.Name;
            string result = assemblyAndClassAndMethod + "(";
            foreach (ParameterInfo paramInfo in methodInfo.GetParameters())
                result += paramInfo.ParameterType + ",";
            if (methodInfo.GetParameters().Length > 0)
                string.Format("{0})", result.Remove(result.Length - 1, 1));
            else
                result += ")";
            return new Guid(GenerateBinaryHash(result + parameterInfo.ParameterType.FullName));
        }

        public static Guid FromPropertyInfo(PropertyInfo propertyInfo, Type type)
        {
            string assemblyAndClassAndMethod = type.GetTypeInfo().Assembly.FullName.Split(',')[0] + type.GetTypeInfo().FullName + propertyInfo.Name;
            return new Guid(GenerateBinaryHash(assemblyAndClassAndMethod));
        }

        public static Guid FromType(Type type)
        {
            return type.GetTypeInfo().GUID;
        }

        public static Guid FromString(string s)
        {
            return new Guid(GenerateBinaryHash(s));
        }

        /// <summary>
        /// Hash the data with SHA384 encoded as a base64 string
        /// note: A SHA-384 hash (48 bytes) represented as a Base64 string will always be exactly 64 characters long.
        /// </summary>
        /// <param name="data">data to hash</param>
        /// <returns>base64 hash value</returns>
        public static string GetSHA384Hash(byte[] data)
        {
            if (data == null) throw new ArgumentNullException(nameof(data));
            using (HashAlgorithm hasher = SHA384.Create())
            {
                byte[] hashBytes = hasher.ComputeHash(data);
                string hashedStr = Convert.ToBase64String(hashBytes).TrimEnd('='); //TODO - the trim is superflous here
                return hashedStr;
            }
        }

        /// <summary>
        /// Convenience method to get the SHA384 hash of the UTF-8 bytes of the string
        /// </summary>
        /// <param name="text">string to be hashed, will be treated as UTF-8</param>
        /// <returns>base64 hash value</returns>
        public static string GetSHA384HashOfUTF8(string text)
        {
            if (text == null) throw new ArgumentNullException(nameof(text));
            byte[] dataBytes = Encoding.UTF8.GetBytes(text);
            return HashHelper.GetSHA384Hash(dataBytes);
        }
    }
}
