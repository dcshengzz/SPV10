using swz.Clover.Core;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using System;
using System.Data.SqlTypes;
using System.Globalization;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Token used to represent the version of a survey response for use when checking to see if a request
    /// to update the response is based on the current version of the response or an older one.
    /// Code using this shouldn't make any assumptions about how it is represented (first cut is based on updated
    /// date, since thats conveniently stored in qnn_resp already but this may change in future).
    /// At the core its just a string based on the date, but there's a fair bunch of trivial but messy fiddling about to
    /// get that string and compare it, so creating a class to reify it as a first class object can hide that mess 
    /// from code that uses it.
    /// Equals, == and !=, GetHashCode are overridden to work as expected.
    /// </summary>
    public class SurveyResponseVersionToken
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        // Instances of this class are intended to be immutable,             //
        // please do not add public setters / mutators!                      //
        // // // // // // // // // // // // // // // // // // // // // // // //

        private static readonly string NEW = "SRV00000000-000000-000";

        //In order to avoid getting tangled in json deserialisation issues around dates
        //we don't use an exact ISO format here. Beware of this if tweaking the format later. See:
        //https://github.com/JamesNK/Newtonsoft.Json/issues/862
        //https://github.com/JamesNK/Newtonsoft.Json/issues/904
        //Beyond needing to use the appropriate static factory methods, code outside this class should not
        //make assumptions about the actual format of the token, and it may change at any time.
        private static readonly string FORMAT = "'SRV'yyyyMMdd-HHmmss-fff"; 

        public static bool IsValidValue(string value)
        {
            if (NEW.Equals(value)) return true;
            return DateTime.TryParseExact(value, FORMAT, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime _);
        }

        public static SurveyResponseVersionToken NewVersion()
        {
            return new SurveyResponseVersionToken(NEW);
        }

        /// <summary>
        /// Factory method to rehydrate an instance from a string
        /// </summary>
        /// <param name="responseVersionTokenString">version token</param>
        /// <returns>token</returns>
        public static SurveyResponseVersionToken FromString(string responseVersionTokenString)
        {
            return new SurveyResponseVersionToken(responseVersionTokenString);
        }

        /// <summary>
        /// Factory method to create instance representing version of the response 
        /// (the entity reference may be null if no response yet)
        /// </summary>
        /// <param name="qnnResp">the response, this may be null if there is no response yet</param>
        /// <returns>token</returns>
        public static SurveyResponseVersionToken FromQnnResp(DynamicEntity qnnResp)
        {
            if(qnnResp == null)
            {
                return new SurveyResponseVersionToken(NEW);
            }
            else
            {
                DateTime? updatedDate = (DateTime?)qnnResp[Constants.FieldName.UpdatedDate];
                return FromUpdatedDate(updatedDate);
            }
        }

        public static SurveyResponseVersionToken FromQnnResp(QNN_RESP qnnResp)
        {
            if (qnnResp == null)
            {
                return new SurveyResponseVersionToken(NEW);
            }
            else
            {
                DateTime? updatedDate = (DateTime?)qnnResp.UpdatedDate;
                return FromUpdatedDate(updatedDate);
            }
        }

        /// <summary>
        /// Factory method to create an instance based on the UpdatedDate from a QNN_RESP 
        /// (pass null if no response yet)
        /// </summary>
        /// <param name="updatedDate">UpdatedDate or null if no response yet</param>
        /// <returns>token</returns>
        public static SurveyResponseVersionToken FromUpdatedDate(DateTime? updatedDate)
        {
            if(updatedDate==null)
            {
                return new SurveyResponseVersionToken(NEW);
            }
            else
            {
                //When storing a DateTime in the database there is a loss of precision, and this
                //means the value that comes back is not quite the same as what we put in (it is
                //typically one millisecond higher). We use SqlDateTime here to adjust the value
                //we use for the token so that it will still match a token generated from the date
                //retrieved from the column later.
                //See:
                //https://stackoverflow.com/questions/7823966/milliseconds-in-my-datetime-changes-when-stored-in-sql-server
                //https://stackoverflow.com/questions/14519912/datetime-now-differs-a-millisecond
                DateTime sqlPrecisionDateTime = new SqlDateTime(updatedDate.Value).Value;
                string value = sqlPrecisionDateTime.ToString(FORMAT);
                return new SurveyResponseVersionToken(value);
            }
        }

        public string Value { get; private set; }

        private bool IsNew { get => NEW.Equals(Value); }

        /// <summary>
        /// Constructor is private and only for internal use, outside code please use the appropriate factory method
        /// </summary>
        private SurveyResponseVersionToken(string responseVersionTokenString)
        {
            if (responseVersionTokenString == null) throw new ArgumentNullException(nameof(responseVersionTokenString));
            if (!IsValidValue(responseVersionTokenString)) throw new FormatException($"Invalid value for {nameof(responseVersionTokenString)}");
            this.Value = responseVersionTokenString;
        }

        /// <summary>
        /// String representation of the token, suitable for use in JSON
        /// </summary>
        public override string ToString()
        {
            return Value;
        }

        public override bool Equals(object obj)
        {
            //nb the current implementation uses UpdatedDate for convenience (so we dont have to add another column)
            //but this is only accurate down to milliseconds, so in theory two versions at the same millisecond can
            //collide. Given the use case this probably won't be an issue in practice however.
            return obj is SurveyResponseVersionToken token && (Value == token.Value);
        }

        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }

        public static bool operator ==(SurveyResponseVersionToken lhs, SurveyResponseVersionToken rhs)
        {
            return (ReferenceEquals(lhs, null))
                ? ReferenceEquals(rhs, null)
                : lhs.Equals(rhs);
        }

        public static bool operator !=(SurveyResponseVersionToken lhs, SurveyResponseVersionToken rhs)
        {
            return !(lhs == rhs);
        }
    }
}
