using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;

namespace swz.SurveyPlus.Application
{
    public class DelegateSurveyResult
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Thrown if the constructor deems the information it is passed as invalid.
        /// This would generally occur because we tried to deserialise invalid json
        /// as the constructor is private and the factory methods won't pass rubbish.
        /// </summary>
        public class InvalidResultException : Exception { }

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome { 
            /// <summary>The action was successfull</summary>
            Success, 
            /// <summary>The specified delegationCode was not valid</summary>
            InvalidDelegationCode,
            /// <summary>The email provided was not formatted correctly</summary>
            IncorrectEmail,  
            /// <summary>The action could not be taken because no delegation(s) found matching the criteria</summary>
            NoDelegationsFound,
            /// <summary>The action could not be taken because too many fail attempts</summary>
            DelegationAccessRetriesExceed,
            /// <summary>Start date greater than end date</summary>
            InvalidValidityPeriod,
        }

        public static DelegateSurveyResult Success()
        {
            return new DelegateSurveyResult(isSuccess: true, Outcome.Success);
        }

        public static DelegateSurveyResult Fail(Outcome reason)
        {
            if (Outcome.Success == reason) throw new ArgumentException(nameof(reason));
            return new DelegateSurveyResult(isSuccess:false, reason);
        }

        // // // // // // // // // // //

        public bool IsSuccess { get { return Outcome.Success == Reason; } }
        public Outcome Reason { get; private set; }

        /// <summary>
        /// Constructor used by Success and Fail factory methods as well as newtonsoft.
        /// Will throw exception if the providing information is missing or inconsistent.
        /// </summary>
        /// <param name="reason"></param>
        /// <param name="reason"></param>
        [JsonConstructor] //nb: constructor argument names must follow what is expected in the json
        private DelegateSurveyResult(bool? isSuccess, Outcome? reason)
        {            
            if ( (isSuccess == null) || (reason == null) 
                || ((isSuccess==false)&&(reason==Outcome.Success)) 
                || ((isSuccess==true)&&(reason != Outcome.Success)))
            {
                throw new InvalidResultException(); //bad json probably
            }                
            this.Reason = (Outcome)reason;
        }
    }
}
