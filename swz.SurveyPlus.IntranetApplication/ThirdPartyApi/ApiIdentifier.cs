using Newtonsoft.Json;
using System;

namespace swz.SurveyPlus.IntranetApplication.ThirdPartyApi
{
    public class ApiIdentifier
    {
        /// <summary>
        /// Convert between simple json string attributes and the ApiIdentifier type
        /// </summary>
        public class JsonConverterImpl : JsonConverter
        {
            public override bool CanWrite
            {
                get { return false; } //TODO
            }

            public override bool CanConvert(Type objectType)
            {
                return false; // TODO - can put string here?
            }

            public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
            {
                throw new NotImplementedException("Not implemented yet");
            }

            public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
            {
                switch(reader.TokenType)
                {
                    case JsonToken.Null: return null;
                    case JsonToken.String: return ApiIdentifier.FromString(serializer.Deserialize<string>(reader));
                    default: throw new InvalidOperationException("Unexpected TokenType " + reader.TokenType);
                }
            }
        } //end of JsonConverterImpl

        /// <summary>
        /// Factory method to create an instance of ApiIdentifier from a string.
        /// An ArgumentException is thrown if the string is not valid
        /// </summary>
        /// <param name="apiIdentifier">The ApiIdentifier in string form. If taking from a url etc it is assumed any necessary decoding would have already been done.</param>
        /// <returns></returns>
        public static ApiIdentifier FromString(string apiIdentifier)
        {
            return new ApiIdentifier(apiIdentifier);
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly string value;

        /// <summary>
        /// Constructor is private and intended only for use by the factory method
        /// Your code should create instances using the factory methods.
        /// </summary>
        /// <param name="value"></param>
        private ApiIdentifier(string value)
        {
            if (value == null) throw new ArgumentNullException(nameof(value));
            if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException(nameof(value));
            if (value.Length > 255) throw new ArgumentException(nameof(value));
            //TODO - regex to check its a valid pattern (as we may be receiving these as part of a url path so must limit available chars)
            this.value = value;
        }

        public override string ToString()
        {
            return value.ToString();
        }

        public override bool Equals(object obj)
        {
            return obj is ApiIdentifier identifier &&
                   value == identifier.value;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(value);
        }
    } //end of ApiIdentifier
}