using System;
using System.Collections;
using System.Collections.Generic;
using System.Dynamic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Serialization;
using Microsoft.IdentityModel.Tokens;

//TODO - consider moving this to swz.SurveyPlus.Application 
namespace swz.SurveyPlus.IntranetApplication
{
    public static class Extensions
    {
        public static string GetAnonymousId(this string data)
        {
            if (string.IsNullOrEmpty(data))
            {
                return null;
            }

            try
            {
                var blob = Base64UrlEncoder.DecodeBytes(data);

                if (blob == null || blob.Length < 13)
                {
                    return null;
                }

                var expireDate = DateTime.FromFileTime(BitConverter.ToInt64(blob, 0));

                if (expireDate < DateTime.Now)
                {
                    return null;
                }

                var len = BitConverter.ToInt32(blob, 8);

                if (len < 0 || len > blob.Length - 12)
                {
                    return null;
                }

                return Encoding.UTF8.GetString(blob, 12, len);

            }
            catch
            {
                //any other scenario
            }

            return null;
        }
        public static string Scramble(this string s)
        {
            return new string(s.ToCharArray().OrderBy(x => Guid.NewGuid()).ToArray());
        }

        public static DateTime toDate(this string dateTimeStr, string dateFmt)
        {
            // example: var dt="2011-03-21 13:26".toDate("yyyy-MM-dd HH:mm");
            const DateTimeStyles style = DateTimeStyles.AllowWhiteSpaces;
            var result = DateTime.MinValue;
            DateTime dt;
            if (DateTime.TryParseExact(dateTimeStr, dateFmt,
                CultureInfo.InvariantCulture, style, out dt)) result = dt;
            return result;
        }

        public static string SqlEscape(this string str)
        {
            if (str != null) return str.Replace("_", "[_]").Replace("[", "[[]").Replace("%", "[%]").Replace("'", "''");
            return str;
        }

        public static bool isNumber(this string input)
        {
            var match = Regex.Match(input, @"^[0-9]+$", RegexOptions.IgnoreCase);
            return match.Success;
        }

        public static bool CaseInsensitiveContains(this string text, string value,
            StringComparison stringComparison = StringComparison.CurrentCultureIgnoreCase)
        {
            return text.IndexOf(value, stringComparison) >= 0;
        }

        public static string SerializeObject<T>(this T toSerialize)
        {
            var xmlSerializer = new XmlSerializer(toSerialize.GetType());

            using (var textWriter = new StringWriter())
            {
                xmlSerializer.Serialize(textWriter, toSerialize);
                return textWriter.ToString();
            }
        }

        public static byte[] ToByteArray(this string text)
        {
            return text.Select(x => (byte) x).ToArray();
        }

        public static Stream ToStream(this string str)
        {
            var stream = new MemoryStream();
            StreamWriter writer;
            if (str.IndexOf("utf-16", StringComparison.InvariantCultureIgnoreCase) > 0)
                writer = new StreamWriter(stream, Encoding.Unicode);
            else if (str.IndexOf("utf-8", StringComparison.InvariantCultureIgnoreCase) > 0)
                writer = new StreamWriter(stream, Encoding.UTF8);
            else
                writer = new StreamWriter(stream, Encoding.ASCII);

            writer.Write(str);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }


        public static string ReplaceFirst(this string text, string search, string replace)
        {
            var pos = text.IndexOf(search, StringComparison.InvariantCultureIgnoreCase);
            if (pos < 0) return text;
            return text.Substring(0, pos) + replace + text.Substring(pos + search.Length);
        }

        public static string SubstringUpToLast(this string text, char delimiter)
        {
            if (text == null)
                return null;
            var length = text.LastIndexOf(delimiter);
            if (length >= 0)
                return text.Substring(0, length);
            return text;
        }

        /// <summary>
        ///     Extension method that turns a dictionary of string and object to an ExpandoObject
        /// </summary>
        public static ExpandoObject ToExpando(this IDictionary<string, object> dictionary)
        {
            var expando = new ExpandoObject();
            var expandoDic = (IDictionary<string, object>) expando;

            // go through the items in the dictionary and copy over the key value pairs)
            foreach (var kvp in dictionary)
                // if the value can also be turned into an ExpandoObject, then do it!
                if (kvp.Value is IDictionary<string, object>)
                {
                    var expandoValue = ((IDictionary<string, object>) kvp.Value).ToExpando();
                    expandoDic.Add(kvp.Key, expandoValue);
                }
                else if (kvp.Value is ICollection)
                {
                    // iterate through the collection and convert any strin-object dictionaries
                    // along the way into expando objects
                    var itemList = new List<object>();
                    foreach (var item in (ICollection) kvp.Value)
                        if (item is IDictionary<string, object>)
                        {
                            var expandoItem = ((IDictionary<string, object>) item).ToExpando();
                            itemList.Add(expandoItem);
                        }
                        else
                        {
                            itemList.Add(item);
                        }

                    expandoDic.Add(kvp.Key, itemList);
                }
                else
                {
                    expandoDic.Add(kvp);
                }

            return expando;
        }

        /// <summary>
        /// Extension method providing some syntactic sugar for getting string values from a dictionary.
        /// If the dictionary has the key and its value isn't empty then return it's string representation (as per ToString), 
        /// but if it is absent or the value's string representation is an empty or whitespace string 
        /// then return the specified defaultValue instead.
        /// Mostly I expect to use this with string,string dictionaries but I have made it generic for convenience.
        /// Note: If you are looking for the more general purpose GetValueOrDefault for dictionaries, it is in 
        ///       System.Collections.Generic.CollectionExtensions
        ///       see: https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.collectionextensions.getvalueordefault?view=netcore-3.1
        /// </summary>
        public static string GetNonEmptyStringValueOrDefault<K,V>(
            this Dictionary<K, V> dictionary,
            K key,
            string defaultString = null)
        {
            if (dictionary == null) throw new NullReferenceException("this dictionary is null");
            if (dictionary.TryGetValue(key, out V value))
            {
                string stringValue = value?.ToString() ?? "";
                return string.IsNullOrWhiteSpace(stringValue) ? defaultString : stringValue;
            }
            else
            {
                return defaultString;
            }
                
        }
    }
}