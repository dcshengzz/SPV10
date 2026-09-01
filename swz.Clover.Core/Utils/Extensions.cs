using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace swz.Clover.Core.Utils
{
    public static class Extensions
    {
        public static object GetDefaultValue(this Type type)
        {
            if (type.GetTypeInfo().IsValueType)
            {
                return Activator.CreateInstance(type);
            }
            return null;
        }

        public static bool IsNullable(this Type type)
        {
            return Nullable.GetUnderlyingType(type) != null;
        }

        public static bool IsEnumerable(this Type type)
        {
            return type.GetInterfaces().Any(intType => intType == typeof(IEnumerable));
        }

        public static Type GetUnderlyingType(this Type type)
        {
            return Nullable.GetUnderlyingType(type) ?? type;
        }

        public static Type ToNullableType(this Type type)
        {
            var newType = Nullable.GetUnderlyingType(type) ?? type;
            return newType.GetTypeInfo().IsValueType ? typeof(Nullable<>).MakeGenericType(newType) : newType;
        }

        public static bool ExtendedEquals(this object value, object valueToCompare)
        {
            if (valueToCompare == null)
            {
                return value == null;
            }

            if (value.GetType() == valueToCompare.GetType() && value is IEnumerable)
            {
                var valueArray = (value as IEnumerable).Cast<object>().ToArray();
                var valueToCompareArray = (valueToCompare as IEnumerable).Cast<object>().ToArray();

                if (valueArray.Length != valueToCompareArray.Length)
                    return false;

                for (int i = 0; i < valueArray.Length; i++)
                {
                    if (valueArray[i] == null && valueToCompareArray[i] != null)
                        return false;
                    if (valueArray[i] != null && valueToCompareArray[i] == null)
                        return false;
                    if (valueArray[i] != null && valueToCompareArray[i] != null)
                        if (!valueArray[i].Equals(valueToCompareArray[i]))
                            return false;
                }

                return true;
            }

            return value.Equals(valueToCompare);
        }

        public static string ToLowerCaseString(this bool value)
        {
            return value.ToString().ToLower();
        }

        public static string ToValidCSharpIdentifierName(this string originalString)
        {
            var pattern = @"[^\p{Ll}\p{Lu}\p{Lt}\p{Lo}\p{Nd}\p{Nl}\p{Mn}\p{Mc}\p{Cf}\p{Pc}\p{Lm}]";

            var result = Regex.Replace(originalString, pattern, "_");

            if (!char.IsLetter(result, 0))
            {
                result = result.Insert(0, "_");
            }

            return result.Replace(" ", "_");
        }
    }

    public static class AsyncExtensions
    {
        public static async Task<bool> AnyAsync<T>(
            this IEnumerable<T> source, Func<T, Task<bool>> func)
        {
            foreach (var element in source)
            {
                if (await func(element).ConfigureAwait(false))
                    return true;
            }
            return false;
        }

        public static async Task<List<T>> WhereAsync<T>(this IEnumerable<T> source, Func<T, Task<bool>> func)
        {
            var result = new List<T>();
            foreach (var element in source)
            {
                if (await func(element).ConfigureAwait(false))
                    result.Add(element);
            }
            return result;
        }

        public static async Task<List<TNew>> SelectAsync<T, TNew>(this IEnumerable<T> source, Func<T, Task<TNew>> func)
        {
            var result = new List<TNew>();
            foreach (var element in source)
            {
                result.Add(await func(element).ConfigureAwait(false));
            }
            return result;
        }

        public static Dictionary<TKey, TValue> ToDictionary<TKey, TValue>(this NameValueCollection col)
        {
            var dict = new Dictionary<TKey, TValue>();
            var keyConverter = TypeDescriptor.GetConverter(typeof(TKey));
            var valueConverter = TypeDescriptor.GetConverter(typeof(TValue));

            foreach (string name in col)
            {
                var key = (TKey) keyConverter.ConvertFromString(name);
                var value = (TValue) valueConverter.ConvertFromString(col[name]);
                if (typeof(TKey).GetTypeInfo().IsValueType || key != null)
                    dict.Add(key, value);
            }

            return dict;
        }
    }

    public static class ListExtensions
    {
        /// <summary>
        /// Util to seperate List&lt;T&gt; to List&lt;List&lt;T&gt;&gt;
        /// </summary>
        public static List<List<T>> ChunkBy<T>(this List<T> source, int chunkSize)
        {
            return source
                .Select((x, i) => new { Index = i, Value = x })
                .GroupBy(x => x.Index / chunkSize)
                .Select(x => x.Select(v => v.Value).ToList())
                .ToList();
        }
    }
}
