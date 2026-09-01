using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using swz.Clover.Core;

namespace swz.SurveyPlus.InternetApplication
{
    /// <summary>
    /// Object that exposes a stream to the file content and the file properties
    /// </summary>
    public class FileData
    {
        //Do not add setters to this class

        /// <summary>
        /// File stream. Will never return null.
        /// </summary>
        public Stream Content { get; private set; }

        /// <summary>
        /// File properties as a dictionary. This will never be a null reference
        /// </summary>
        public Dictionary<string, string> Properties { get; private set; } //TODO proper type for this

        public FileData(Stream content, Dictionary<string, string> properties)
        {
            if (content == null) throw new ArgumentNullException(nameof(content));
            if (properties == null) throw new ArgumentNullException(nameof(properties));
            this.Content = content;
            this.Properties = properties;
        }
    }

    /// <summary>
    /// Object that holds details of the outcome of a request to add a new response (multiresponse surveys)
    /// </summary>
    public class AddResponseResult
    {
        //This class is intended to be immutable, do not add public setters

        public static AddResponseResult Success(Guid qnnRespId)
        {
            if (Guid.Empty.Equals(qnnRespId)) throw new ArgumentException(nameof(qnnRespId));
            return new AddResponseResult(true, qnnRespId, "Response added");
        }

        public static AddResponseResult Fail(string message)
        {
            return new AddResponseResult(false, Guid.Empty, (message==null)?"Fail":message);
        }

        public bool IsSuccess { get; private set; }
        public Guid QnnRespId { get; private set; }
        public string Message { get; private set; }

        private AddResponseResult(bool success, Guid qnnRespId, string message)
        {
            IsSuccess = success;
            QnnRespId = qnnRespId; //may be empty
            Message = message;
        }
    }

    /// <summary>
    /// Generic exception to wrap unexpected errors in the service
    /// </summary>
    public class RespondentServiceException : Exception
    {
        public RespondentServiceException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// There was a problem changing the password
    /// </summary>
    public class PasswordChangeException : Exception
    {
        public PasswordChangeException(string message) : base(message) { }
    }

    /// <summary>
    /// Something went wrong retrieving the help content
    /// </summary>
    public class HelpRetrievalException : Exception
    {
        public HelpRetrievalException(Exception innerException) : base("Unable to retrieve help", innerException) { }

        public HelpRetrievalException(string message) : base(message) { }

        public HelpRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// Something went wrong retrieving the respondent content
    /// </summary>
    public class RespondentContentRetrievalException : Exception
    {
        public RespondentContentRetrievalException(Exception innerException) : base("Failed to retrieve respondent content", innerException) { }

        public RespondentContentRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// There was an error retreiving saved survey response data
    /// </summary>
    public class SurveyRetrievalException : Exception
    {
        public SurveyRetrievalException(string message) : base(message) { }

        public SurveyRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// An error occured saving a survey response   (TODO: check is this only used on submit, or even for save too?)
    /// </summary>
    public class SurveySubmissionException : Exception
    {
        public SurveySubmissionException(string message) : base(message) { }

        public SurveySubmissionException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// An unexpected error occured adding a response to a survey
    /// </summary>
    public class AddResponseException : Exception
    {
        public AddResponseException(string message) : base(message) { }

        public AddResponseException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// An error occured when retrieving List Sample Info
    /// </summary>
    public class ListSampleInfoRetrievalException : Exception
    {
        public ListSampleInfoRetrievalException(string message) : base(message) { }

        public ListSampleInfoRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// An error occured when upload respondent file.
    /// </summary>
    public class UploadRespondentFileException : Exception
    {
        public UploadRespondentFileException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// For errors that occur trying to check the Anonymous status of a survey
    /// </summary>
    public class AnonymousFlagRetrievalException : Exception
    {
        public AnonymousFlagRetrievalException(string message) : base(message) { }

        public AnonymousFlagRetrievalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// Thrown when a virus (etc) is detected in an uploaded file (eg, by respondent file upload, excel upload)
    /// </summary>
    public class VirusDetectedException : Exception
    {
        public VirusDetectedException(string message) : base(message) { }
    }

    /// <summary>
    /// Thrown if there is an unexpected error when trying to verify the u@app respondent session token
    /// (In this case the status of the session token is unknown)
    /// </summary>
    public class VerifyAccessTokenException : Exception
    {
        public VerifyAccessTokenException(string message, Exception innerException) : base(message, innerException) { }
    }


    /// <summary>
    /// Thrown if there is an unexpected error when trying to export pdf
    /// </summary>
    public class ExportPdfException : Exception
    {
        public ExportPdfException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class PdfExportRateLimitResult
    {
        public bool IsRateLimited { get; set; }
        public int CooldownMinutes { get; set; }
        public Guid LogId { get; set; }

    }

    /// <summary>
    /// Interface to respondent portal features (Business Logic) that need to work with the persistent data.
    /// This interface exists to allow us to adapt to the required architecture for the environment.
    /// Currently there are two such architectures - U@App & U@Db:  (as of 2021-10-23 the U@Db implementation has yet to be created)
    /// 1. Unified@App - coordination between internet portal and database is via an api exposed by the intranet application
    /// 2. Unified@Db - coordination between internet portal and database is via direct access to db with a db connection and clover ORM (older SIMS/SurveyPlus implemented this directly)
    /// The implementation of this interface (ie: RespondentServiceUApp, RespondentServiceUDb) will take care of the details of accessing the features
    /// appropriately. Code in the internet portal (eg: controllers etc) must work with this interface rather than performing the work themselves.
    /// nb: There is also quite a bit of special cases in SurveyPlus core classes, mainly to support the UI forms and data mappings. See the ApiSupport project
    ///     for more details on that. 
    /// </summary>
    public interface IRespondentService
    {
        /// <summary>
        /// Perform a basic connectivity test that returns a simple plain text string with some information. 
        /// (Nature of the info is implementation specific and subject to change between SurveyPlus builds)
        /// </summary>
        /// <returns>a string with some information</returns>
        Task<string> ConnectivityTest();

        /// <summary>
        /// Change the password for a respondent. Caller should have verified the approriate access to do so for the specified uid.
        /// On failure will throw a PasswordChangeException whose message may be reported to the ui.
        /// Other exception messages shoupd not be reported to the ui.
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="oldPassword"></param>
        /// <param name="newPassword"></param>
        /// <returns>nothing, but will throw a PasswordChangeException if the change fails</returns>
        Task ChangePasswordAsync(string uid, string oldPassword, string newPassword);

        /// <summary>
        /// Get the online Help content for respondents.
        /// Throws a HelpRetrievalException if something goes wrong (this is never respondents fault
        /// so always indicates some unexpected internal problem). 
        /// </summary>
        /// <returns>returned list may be empty but never null</returns>
        Task<List<HelpItem>> GetRespHelpAsync();

        /// <summary>
        /// Return the respondent content of specified type
        /// </summary>
        /// <param name="type">RespDashboard or RespLogin</param>
        /// <returns>content item</returns>
        Task<List<RespondentContentItem>> GetRespondentContentAsync(string type);

        /// <summary>
        /// Retrieve the excel survey file for download.
        /// nb: caller is responsible for closing the returned stream (if caller is a controller then File return can handle)
        /// </summary>
        /// <param name="dlsi">Id in QNN_DPLY_SAMPLE_INFO (required)</param>
        /// <param name="token">File token (required)</param>
        /// <param name="respId">Response Id (may be null)</param>
        /// <returns>object containing a stream along with the filename and type information</returns>
        Task<StreamWithName> DownloadExcelAsync(
            Guid dlsi,
            string token,
            Guid? respId = null);

        /// <summary>
        /// Upload an excel and import response answers from it.
        /// Throws a SurveySubmissionException on failure. 
        /// </summary>
        /// <param name="qnnId"></param>
        /// <param name="dplyId"></param>
        /// <param name="listSampleId"></param>
        /// <param name="file"></param>
        /// <returns>Nothing on success</returns>
        Task UploadExcelAsync(
            Guid qnnId,
            Guid dplyId,
            Guid listSampleId,
            StreamWithName file);

        /// <summary>
        /// Create a new response for a multiple response survey.
        /// Business logic failure to create the response is indicated by a fail status in the returned results.
        /// Other errors will raise an AddResponseException.
        /// </summary>
        /// <param name="qnnDplySampleInfoId">dlsi</param>
        /// <returns>result containing success/failure indicator and the failure message or new response id</returns>
        Task<AddResponseResult> AddNewResponseAsync(Guid qnnDplySampleInfoId);

        /// <summary>
        /// Check if the deployment for this dlsi is set to require a delegated access code.
        /// This requires a call to check, if you already have a ListSampleInfo instance, it is quicker to check there
        /// (Delegation feature)
        /// </summary>
        /// <param name="qnnDplySampleInfoId">dlsi</param>
        /// <returns>RequireAccessCode</returns>
        Task<bool> IsRequireDelegatedAccessCodeAsync(Guid qnnDplySampleInfoId);

        Task<bool> IsDelegatedAccessRetriesExceedAsync(Guid qnnDplySampleInfoId);

        Task<bool> ValidateDelegatedAccessCodeAsync(Guid qnnDplySampleInfoId, string inputCode);

        Task<DelegateSurveyResult> DelegateSurveyAsync(DelegateSurveyRequest request, string delegationCode);

        Task<DelegateSurveyResult> RevokeDelegationAsync(string delegationCode, Guid qnnDplySampleInfoId, Guid? qnnRespDelegationId = null);

        Task<DelegationHistoryResult> GetDelegationHistoryAsync(Guid qnnDplySampleInfoId, string delegationCode);

        //Task<IPRestriction> GetIPRestrictionAsync(Guid dlsi);

        /// <summary>
        /// UID + Password login
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        Task<LoginResult> PasswordLoginAsync(string uid, string password);

        /// <summary>
        /// Login and set initial password via an invitation link
        /// </summary>
        /// <param name="accessCode">the accesscode in the invites link</param>
        /// <param name="dlsiCode">code that identifies the invited sample</param>
        /// <returns></returns>
        Task<RespInvitationResult> InvitesLoginAsync(string accessCode, string dlsiCode);

        /// <summary>
        /// Singpass/Corppass login
        /// Assumes the entity has been authenticated already (by spcp logic) and logs them in.
        /// They have been authenticated via corppass/singpass, but if the sample doesn't exist or
        /// is not enabled, then the intranet side may still return an error result.
        /// </summary>
        /// <param name="uid">for spcp this will be the suen/nric</param>
        /// <returns></returns>
        Task<LoginResult> SPCPLoginAsync(string uid);

        /// <summary>
        /// Direct Access link login
        /// </summary>
        /// <param name="accessCode"></param>
        /// <param name="dlsiCode"></param>
        /// <param name="formCode"></param>
        /// <returns></returns>
        Task<DirectAccessLoginResult> DirectAccessLoginAsync(string accessCode, string dlsiCode, string formCode);

        Task<ShortLinkResult> ProcessShortLinkAsync(string shortLinkCode, string accessCode);

        /// <summary>
        /// Update any persistent records pertaining to current login. Note that this doesn't
        /// clear http session attributes as that is caller's responsibility.
        /// </summary>
        /// <returns></returns>
        Task LogoffAsync();

        Task<bool> SendResetPasswordLinkAsync(string userId);

        Task<ValidatePasswordResetTokenResult> ValidatePasswordResetTokenAsync(string nkt);

        Task<bool> ResetPasswordAsync(string token, string newPassword);

        Task<bool> IsAnonymousSurveyAsync(Guid dlsi);

        //TODO - why not have it return a Uri instead of a string? Then we can log exception when its malformed
        /// <summary>
        /// Get the redirect url for survey completion (used with certain types of survey)
        /// </summary>
        /// <param name="dlsi">Id in QNN_DPLY_SAMPLE_INFO or vSP_ListSampleInfoResp etc</param>
        /// <returns>url as a string</returns>
        Task<string> GetCompletionUrl(Guid dlsi);

        Task<ListSampleInfo> GetListSampleInfoAsync(Guid dlsi);

        /// <summary>
        /// The GetDataRequest object is used together with an IDataSource implementation when 
        /// passing back and forth the survey response data.
        /// This method will perform additional setup for the GetDataRequest object, such as setting an appropriate BaseUrl. 
        /// This method may alter the object passed in, or it may return a new object. Caller should therefore
        /// be prepared to have the object it passed be modified, and be prepared to replace its reference with the
        /// one returned from here.
        /// </summary>
        /// <param name="gdRequest">GetDataRequest</param>
        /// <returns></returns>
        public GetDataRequest PrepareGetRequest(GetDataRequest gdRequest);

        /// <summary>
        /// Fetchs the file data and metainfo for *any* file in dwUploadedFiles
        /// Caller is responsible for determining which security to apply
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        Task<FileData> GetFileDataByTokenAsync(string token);

        /// <summary>
        /// Fetch the file data and metainfo for a file in the file storage (IsLocalStorage)
        /// by its filename. The id of the sample wanting it is required so that the structDivisionId
        /// mappings can be checked.
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="sampleId"></param>
        /// <returns></returns>
        Task<FileData> GetLocalStorageFileDataByNameAsync(string fileName, Guid sampleId);

        /// <summary>
        /// Save a respondent uploaded file in dwUploadedFiles.
        /// These files will have IsLocalStorage=false, IsDownloadable=true
        /// </summary>
        /// <param name="uid">uid of the sample</param>
        /// <param name="file">the file uploaded from browser</param>
        /// <returns>token</returns>
        Task<string> UploadRespondentFileAsync(string uid, StreamWithName file);

        Task InvitesChangePasswordAsync(string uid, string newPassword);


        /// <summary>
        /// Log and check PDF export rate limit via intranet API.
        /// </summary>
        Task<PdfExportRateLimitResult> CheckPdfExportRateLimitAsync(Guid dlsi, Guid? respId, string formName, string surveyName, string emails);


        /// <summary>
        /// Get survey data from intranet side for survey printing.
        /// </summary>
        /// <param name="dlsi"></param>
        /// <param name="respId"></param>
        /// <param name="formName"></param>
        /// <param name="IsPDFExportForSubmittedOnly"></param>
        /// <returns></returns>
        Task<DynamicEntity> GetSurveyDataForPrintAsync(Guid dlsi, Guid? respId, string formName, bool IsPDFExportForSubmittedOnly = false);

        /// <summary>
        /// Generate print access code that is bind to form.
        /// </summary>
        /// <param name="dlsi"></param>
        /// <returns></returns>
        Task EnqueuePrintJobAsync(Guid logId, string formName, string emails, string surveyName, string responseData);

        /// <summary>
        /// Update the status of a PDF export log entry after the outcome is known.
        /// </summary>
        Task UpdatePdfExportStatusAsync(Guid logId, string status, string errorMessage = null);

        /// <summary>
        /// Verifies that the business-logic session is still active. For U@App what this means is that it checks that
        /// the access token has not been revoked (with single-session handling this can happen when another session logs in).
        /// If the session is no longer to be considered valid then a Sess
        /// </summary>
        Task VerifySessionActive();

        /// <summary>
        /// Get autosave is enabled settings from appsettings in db
        /// </summary>
        /// <returns>autosave is enabled as boolean</returns>
        Task<bool> GetAutoSaveEnabled();

        /// <summary>
        /// Get autosave duration from appsettings in db
        /// </summary>
        /// <returns>autosave delay duration as int</returns>
        Task<int> GetAutoSaveDelay();
    }
}
