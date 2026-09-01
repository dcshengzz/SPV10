using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;

namespace swz.SurveyPlus.Application
{
    public class RespInvitationResult
    {

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome
        {
            /// <summary>
            /// All good, this code indicates the internet application may proceed to the login page
            /// </summary>
            InviteCompleted,

            /// <summary>
            /// All good, this code indicates the internet application may proceed to the change password page
            /// </summary>
            InviteCompletedRequireChangePassword,

            /// <summary>
            /// Couldn't find the survey. Unable to update the status to Acknowledged at all.
            /// </summary>
            InvalidSurvey,

            /// <summary>
            /// The AccessCode in the url that is used to secure the url was not correct
            /// </summary>
            InvalidAccessCode,

            /// <summary>
            /// This respondent isn't allowed to login, e.g. because they are locked or not found at all
            /// </summary>
            InvalidRespondent
        }
        public LoginResult LoginResult { get; private set; }

        public Outcome Response { get; private set; }

        public static RespInvitationResult InvalidSurvey() { return new RespInvitationResult(null, Outcome.InvalidSurvey); }
        public static RespInvitationResult InvalidRespondent() { return new RespInvitationResult(null, Outcome.InvalidRespondent); }
        public static RespInvitationResult InvalidAccessCode() { return new RespInvitationResult(null, Outcome.InvalidAccessCode); }
        public static RespInvitationResult InviteCompleted() { return new RespInvitationResult(null, Outcome.InviteCompleted); }
        public static RespInvitationResult InviteCompletedRequireChangePassword(LoginResult.LoginInformation loginInformation) {
            LoginResult loginResult = LoginResult.Success(loginInformation);
            return new RespInvitationResult(loginResult, Outcome.InviteCompletedRequireChangePassword); }

        [JsonConstructor]
        private RespInvitationResult(
            //nb: argument names MUST match the properties in json for newtonsoft or deserialisation will be wrong
            LoginResult loginResult,
            Outcome response)
        {
            this.LoginResult = loginResult;
            this.Response = response;
        }

        public override string ToString()
        {
            return $"[{nameof(RespInvitationResult)} : LoginResult={LoginResult}, Response={Response}]";
        }
    }

    /// <summary>
    /// Wraps a LoginResult to add some additional information needed for the Direct Access login flow
    /// </summary>
    public class DirectAccessLoginResult
    {
        public static DirectAccessLoginResult RedirectToSurvey(LoginResult.LoginInformation loginInformation, Guid dlsi, string formName)
        {
            if (loginInformation == null) throw new ArgumentNullException(nameof(loginInformation));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            LoginResult loginResult = LoginResult.Success(loginInformation);
            return new DirectAccessLoginResult(
                loginResult,
                Outcome.RedirectToSurvey,
                dlsi,
                formName);
        }

        public static DirectAccessLoginResult InvalidSurvey()
        {
            return new DirectAccessLoginResult(null, Outcome.InvalidSurvey, null, null);
        }

        public static DirectAccessLoginResult ResponseCompleted(Guid dlsi)
        {
            return new DirectAccessLoginResult(null, Outcome.ResponseCompleted, dlsi, null);
        }

        public static DirectAccessLoginResult InvalidRespondent(Guid dlsi)
        {
            return new DirectAccessLoginResult(
                LoginResult.Fail(LoginResult.Outcome.InvalidCredentials),
                Outcome.InvalidRespondent,
                dlsi,
                null);
        }

        public static DirectAccessLoginResult InvalidAccessCode()
        {
            return new DirectAccessLoginResult(
                LoginResult.Fail(LoginResult.Outcome.InvalidCredentials),
                Outcome.InvalidAccessCode,
                null,
                null);
        }

        public static DirectAccessLoginResult IncompatibleSurveyFeatures(Guid dlsi)
        {
            return new DirectAccessLoginResult(null, Outcome.IncompatibleSurveyFeatures, dlsi, null);
        }

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome 
        { 
            /// <summary>
            /// All good, this code indicates the internet application may treat them as logged in and send them to the survey
            /// </summary>
            RedirectToSurvey,

            /// <summary>
            /// Access code was invalid. Internet side should ask user to check their link
            /// </summary>
            InvalidAccessCode,

            /// <summary>
            /// Couldn't find the survey. Internet side should ask user to check their link
            /// </summary>
            InvalidSurvey,

            /// <summary>
            /// This respondent isn't allowed to login, e.g. because they are locked
            /// </summary>
            InvalidRespondent,

            /// <summary>
            /// The link is ok, but this respondent has already completed a response and this survey doesn't allow
            /// access after completion
            /// </summary>
            ResponseCompleted,

            /// <summary>
            /// The specified survey has a combination of features enabled or disabled that a direct access link cannot support
            /// This included where the survey doesn't have Direct Access Enabled
            /// (e.g. Multiple Response, Anonymous, etc...)
            /// </summary>
            IncompatibleSurveyFeatures,
        }

        public LoginResult LoginResult { get; private set; }        

        public Outcome Response { get; private set; } 

        public Guid? DplySampleInfoId { get; private set; }

        public string FormName { get; private set; }

        [JsonConstructor]
        private DirectAccessLoginResult(
            //nb: argument names MUST match the properties in json for newtonsoft or deserialisation will be wrong
            LoginResult loginResult,
            Outcome response,
            Guid? dplySampleInfoId,
            string formName)
        {
            if(Outcome.RedirectToSurvey==response)
            {
                if (loginResult == null) //might get this is newtonsoft didnt deserialise the enum correctly
                    throw new ArgumentNullException(nameof(loginResult), $"Required for {Outcome.RedirectToSurvey}");
                if (dplySampleInfoId == null) 
                    throw new ArgumentNullException(nameof(dplySampleInfoId), $"Required for {Outcome.RedirectToSurvey}");
                if (string.IsNullOrEmpty(formName)) 
                    throw new ArgumentException(nameof(loginResult), $"Required for {Outcome.RedirectToSurvey}");
            }

            this.LoginResult = loginResult;
            this.Response = response;
            this.DplySampleInfoId = dplySampleInfoId;
            this.FormName = formName;
        }

        public override string ToString()
        {
            return $"[{nameof(DirectAccessLoginResult)} : Response={Response}, LoginResult={LoginResult}, DplySampleInfoId={DplySampleInfoId}, FormName={FormName}]";
        }
    }

    /// <summary>
    /// Login result
    /// </summary>
    public class LoginResult
    {
        public class LoginInformation
        {
            /// <summary>
            /// uid
            /// </summary>
            public string UserId { get; private set; } 

            public string SampleId { get; private set; } //should this be guid? or s it the uid?

            public string EncrUserID { get; private set; }   //TODO - should take this out? (its login encrypted, login is Uid)

            public string AccessToken { get; private set; } //for u@app api

            public string RenewalToken { get; private set; } //for u@app api

            public DateTime LastLoginDate { get; private set; }

            public bool ForcePwdChange { get; private set; }

            [JsonConstructor]
            public LoginInformation(
                string userId,
                string sampleId,
                string encrUserID,
                string accessToken,
                string renewalToken,
                DateTime lastLoginDate,
                bool forcePwdChange)
            {
                //nb: argument names must match parameters for newtonsoft

                //TODO - validate
                this.UserId = userId;
                this.SampleId = sampleId;
                this.EncrUserID = encrUserID;
                this.AccessToken = accessToken;
                this.RenewalToken = renewalToken;
                this.LastLoginDate = lastLoginDate;
                this.ForcePwdChange = forcePwdChange;
            }
        }

        [JsonConverter(typeof(StringEnumConverter))]
        public enum Outcome {  Success, InvalidCredentials, AccountLocked }

        // // // // // // // // // // // // // // // // // // // //

        public static LoginResult Success(LoginInformation information)
        {
            if (information == null) throw new ArgumentNullException(nameof(information));
            return new LoginResult(true, Outcome.Success, information);
        }

        public static LoginResult Fail(Outcome reason)
        {
            if (Outcome.Success==reason) throw new ArgumentException("May not pass Success here", nameof(reason));
            return new LoginResult(false, reason, null);
        }

        public bool IsSuccess { get; private set; }
        public Outcome Reason { get; private set; }
        public LoginInformation Information { get; private set; }

        [JsonConstructor]
        private LoginResult(bool? isSuccess, Outcome? reason, LoginInformation information)
        {
            //TODO consistency check on info so we can detect bad json deserialisation, see DelegateSurveyResult as example
            this.IsSuccess = (bool)isSuccess;
            this.Reason = (Outcome)reason;
            this.Information = information;
        }

        public override string ToString()
        {
            return $"[{nameof(LoginResult)} : IsSuccess={IsSuccess}, Reason={Reason}]";
        }
    }

    public class AccessTokenRenewalResult
    {
        public static AccessTokenRenewalResult Fail()
        {
            return new AccessTokenRenewalResult(false, null, null);
        }

        public static AccessTokenRenewalResult Success(string accessToken, string renewalToken)
        {
            return new AccessTokenRenewalResult(
                true, 
                accessToken ?? throw new ArgumentException(nameof(accessToken)), 
                renewalToken ?? throw new ArgumentException(nameof(renewalToken)));
        }

        public bool IsSuccess { get; private set; }
        public string AccessToken { get; private set; }
        public string RenewalToken { get; private set; }

        [JsonConstructor]
        public AccessTokenRenewalResult(
            bool isSuccess,
            string accessToken,
            string renewalToken)
        {
            this.IsSuccess = isSuccess;
            this.AccessToken = accessToken;
            this.RenewalToken = renewalToken;
        }

        public override string ToString()
        {
            return $"[{nameof(AccessTokenRenewalResult)} - {nameof(IsSuccess)}={IsSuccess}]";
        }
    }
}
