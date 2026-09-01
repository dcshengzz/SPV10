using Microsoft.AspNetCore.Http;
using System;
using System.Threading.Tasks;

namespace swz.Clover.SPCP
{
    public enum SPCPFlow { Corppass, Singpass }

    /// <summary>
    /// Interface for Singpass/Corppass handling logic. 
    /// An instance will be injected into RespController. The service setup is
    /// im SPCPConfigurator.
    /// </summary>
    public interface ISPCPHandler
    {
        /// <summary>
        /// Invoke the configured SPCP processing logic to try and determine the uId to login
        /// from the data in the http request. Will be called by the SPCP login method(s) 
        /// in RespController (at the time of writing).
        /// Implementations of this method may be async.
        /// </summary>
        /// <param name="request">the http request, could be get or post depending on impl</param>
        /// <returns>result with the respondent uId or error information</returns>
        Task<SPCPHandlerResult> Handle(HttpRequest request, SPCPFlow flow);
    }

    /// <summary>
    /// Encapsulate the result of calling the ISPCPHandler.
    /// If successful will have the respondent's uId. If not then will have an error code to indicate the reason.
    /// </summary>
    public class SPCPHandlerResult
    {
        //If adding more codes here please pin down the value so it doesn't change later.
        //This is to help us save time with support when diagnosing reports from older versions.

        /// <summary>
        /// Summarises the outcome of the handling of the SPCP request
        /// Typically the handlers should log more details when an error occurs, so check the logs when troubleshooting
        /// </summary>
        public enum Outcome
        {
            /// <summary>
            /// The SPCP login was successful, respondent UId will be populated and IsSuccess will return true
            /// </summary>
            Success = 0,

            /// <summary>
            /// For use during development or in placeholder implementations
            /// Indicates the implementation is not implemented / incomplete
            /// Should not see this in production
            /// </summary>
            NotImplemented = 1,

            /// <summary>
            /// The feature is disabled
            /// </summary>
            NotEnabled = 2,

            /// <summary>
            /// Failure condition when invalid configuration is detected
            /// </summary>
            InvalidConfiguration = 3,

            /// <summary>
            /// The information in the request was not valid in some way
            /// </summary>
            InvalidRequest = 4,

            /// <summary>
            /// Outcome to indicate the presented SPCP credentials (eg password etc) were invalid.
            /// (This is NOT used where the identified respondent UId isn't in SurveyPlus as that's not the handler's concern)
            /// nb: with the current (as of April 2022) implementations of SPCP this outcome is not applicable as Singpass
            /// will report such errors to user, they aren't directed back to us in this case, so this outcome is more of a
            /// placeholder for now.
            /// </summary>
            InvalidCredentials = 5,

            /// <summary>
            /// The external gateway (or other external server) that was contacted to assist with the
            /// login process returned us an invalid response
            /// </summary>
            InvalidGatewayResponse = 6,

            /// <summary>
            /// I'm not saying it is, but...
            /// </summary>
            Aliens = 7,

            /// <summary>
            /// An unexpected error occured (e.g. an exception was caught).
            /// This would also apply for Network errors as to the user the SPCP integration is a black box,
            /// so from the user's perspective its something internal to the overall system. 
            /// Check the logs for details
            /// </summary>
            InternalError = 8,

            /// <summary>
            /// The Access Token return by gateway do not have cPEntID (UEN) or user browser nonce not match.
            /// This may cause by Access Token format changed.
            /// </summary>
            InvalidAccessToken = 9,
        }

        public static SPCPHandlerResult Success(string uId)
        {
            if (uId == null) throw new ArgumentNullException(nameof(uId));
            if (string.IsNullOrWhiteSpace(uId)) throw new ArgumentException("Not specified", nameof(uId));
            return new SPCPHandlerResult(Outcome.Success, uId);
        }

        public static SPCPHandlerResult Fail(Outcome reason)
        {
            if (reason == Outcome.Success) throw new ArgumentException(nameof(reason));
            return new SPCPHandlerResult(reason, null);
        }

        //we may wish to add a third option here : Redirect
        //and a url to redirect to

        // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// The identity of the authenticated user. 
        /// This will be a respondent uId/UEN for Corppass.
        /// </summary>
        public string UserIdentity { get; private set; }

        /// <summary>
        /// Indicates the reason for failure (for any value other than Success)
        /// </summary>
        public Outcome Reason { get; private set; }

        public bool IsSuccess { get => Outcome.Success.Equals(Reason); }

        private SPCPHandlerResult(Outcome reason, string uId)
        {
            this.Reason = reason;
            this.UserIdentity = uId;
        }
    } //end of SPCPHandlerResult
}
