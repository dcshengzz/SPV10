using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;

namespace swz.SurveyPlus.Application
{
    public class ValidatePasswordResetTokenResult
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome { ValidToken, InvalidToken, LinkExpired, InvalidSample }

        public static ValidatePasswordResetTokenResult Valid() { return new ValidatePasswordResetTokenResult(true, Outcome.ValidToken); }

        public static ValidatePasswordResetTokenResult InvalidToken() { return new ValidatePasswordResetTokenResult(false, Outcome.InvalidToken); }

        public static ValidatePasswordResetTokenResult LinkExpired() { return new ValidatePasswordResetTokenResult(false, Outcome.LinkExpired); }

        public static ValidatePasswordResetTokenResult InvalidSample() { return new ValidatePasswordResetTokenResult(false, Outcome.InvalidSample); }

        public bool IsValid { get { return Reason == Outcome.ValidToken; } }
        public Outcome Reason { get; private set; }

        [JsonConstructor] //nb: constructor argument names must follow what is expected in the json
        private ValidatePasswordResetTokenResult(bool? isValid, Outcome? reason)
        {
            if (isValid == null || reason == null
                || ((Outcome.ValidToken == reason) && (isValid==false))
                || ((isValid==true) && (Outcome.ValidToken != reason)))
            {
                //You will see this if you try to deserialise garbage - check what the api is returning
                throw new ArgumentException($"Invalid values passed to constructor {nameof(ValidatePasswordResetTokenResult)} . If deserialising json please check what is in the json. Passed isValid={isValid}, reason={reason}");
            }
            this.Reason = (Outcome)reason;
        }
    }
}
