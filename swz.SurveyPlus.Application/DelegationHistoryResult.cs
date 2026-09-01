using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Object that holds the response to a request to get the delegation history for a survey.
    /// If successful (no error and there is some history to retrieve) then the history can be obtained via the History Property.
    /// </summary>
    public class DelegationHistoryResult
    {
        //This class is intended to be immutable, do not add public setters

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome { Success, InvalidDelegationCode, NoDelegationHistory, DelegationAccessRetriesExceed }

        /// <summary>
        /// Factory method to create an instance representing success.
        /// Pass it the history to return.
        /// </summary>
        /// <param name="history">delegation history</param>
        /// <returns></returns>
        public static DelegationHistoryResult Success(List<Dictionary<string, object>> history)
        {
            if (history == null) throw new ArgumentNullException(nameof(history));
            return new DelegationHistoryResult(isSuccess: true, Outcome.Success, history);
        }

        /// <summary>
        /// Factory method to create an instance representing failure.
        /// Pass it the reason for the failure.
        /// </summary>
        /// <param name="reason">why cannot?</param>
        /// <returns></returns>
        public static DelegationHistoryResult Fail(Outcome reason)
        {
            if (Outcome.Success == reason) throw new ArgumentException("Cannot pass Success outcome to Fail");
            return new DelegationHistoryResult(isSuccess: false, reason, null);
        }

        public bool IsSuccess { get { return Reason == Outcome.Success; } }
        public Outcome Reason { get; private set; }
        public List<Dictionary<string, object>> History { get; private set; }

        [JsonConstructor] //nb: constructor argument names must follow what is expected in the json
        private DelegationHistoryResult(bool? isSuccess, Outcome? reason, List<Dictionary<string, object>> history)
        {
            this.Reason = (Outcome)reason;
            this.History = (history == null) ? new List<Dictionary<string, object>>() : history;
        }
    }
}
