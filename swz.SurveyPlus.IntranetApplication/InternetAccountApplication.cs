using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.IdentityModel.JsonWebTokens;
using System.Security.Claims;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.Clover.AuthServices.Jwt.Services;

namespace swz.SurveyPlus.IntranetApplication
{
    //will probably move this to common project if we implement U@Db again
    //and it will require significant refactoring arond session handling if we do as that logic all assumes u@db with jwt
    //TODO consider renaming from InternetAccountApplication to SampleAccountApplication or RespondentAccountApplication
    public static class InternetAccountApplication
    {
        /// <summary>
        /// Wraps unexpected errors that occur when trying to process a Respondent login in one of the login methods
        /// Subclasses exist to provide a convenient place to put additional information such as uid to faciliate 
        /// logging or handling by  the calling code.
        /// </summary>
        public abstract class RespondentLoginException : Exception
        {
            public bool IsEnforceRespondentSingleSession { get; private set; }

            protected RespondentLoginException(bool isEnforceRespondentSingleSession, string message, Exception innerException)
                : base(message, innerException)
            {
                this.IsEnforceRespondentSingleSession = isEnforceRespondentSingleSession;
            }
        }

        public class SPCPRespondentLoginException : RespondentLoginException
        {
            public string UID { get; private set; }

            public SPCPRespondentLoginException(string uid, bool isEnforceRespondentSingleSession, Exception innerException) 
                : base(isEnforceRespondentSingleSession, "Failed to process SPCP login", innerException)
            {
                this.UID = uid;
            }
        }

        public class InvitationRespondentLoginException : RespondentLoginException
        {
            public string DlsiCode { get; private set; }
            public string AccessCodeString { get; private set; }

            public InvitationRespondentLoginException(string dlsiCode, string accessCodeString, bool isEnforceRespondentSingleSession, Exception innerException) 
                : base(isEnforceRespondentSingleSession, "Failed to process invitation login request", innerException)
            {
                this.DlsiCode = dlsiCode;
                this.AccessCodeString = accessCodeString;
            }
        }

        public class PasswordRespondentLoginException : RespondentLoginException
        {
            public string UID { get; private set; }

            public PasswordRespondentLoginException(string uid, bool isEnforceRespondentSingleSession, Exception innerException) 
                : base(isEnforceRespondentSingleSession, "Failed to process a password login", innerException)
            {
                this.UID = uid;
            }
        }

        public class DirectAccessRespondentLoginException : RespondentLoginException
        {
            public string AccessCodeString { get; private set; }
            public string DlsiCode { get; private set; }
            public string FormCode { get; private set; }

            public DirectAccessRespondentLoginException(string accessCodeString, string dlsiCode, string formCode, bool isEnforceRespondentSingleSession, Exception innerException) 
                : base(isEnforceRespondentSingleSession, "Failed to process a direct-access login", innerException)
            {
                this.AccessCodeString = accessCodeString;
                this.DlsiCode = dlsiCode;
                this.FormCode = formCode;

            }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(InternetAccountApplication));

        /// <summary>
        /// Authenticate the sample password and increment the number of failed logins for invalid credentials.
        /// Note that this doesnt store the UID in the internet side session on success. That is responsibility
        /// of the appropriate controller on the internet side.
        /// </summary>
        /// <param name="login"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static async Task<LoginResult> PasswordLogin(
            IJwtService jwtService,
            string login, 
            string password, 
            bool isEnforceRespondentSingleSession)
        {
            if (String.IsNullOrWhiteSpace(login) || String.IsNullOrWhiteSpace(password))
            {
                return LoginResult.Fail(LoginResult.Outcome.InvalidCredentials);
            }
            try
            {
                EntityModel qnnSampleModel    
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                DynamicEntity qnnSample = (await qnnSampleModel.GetAsync(Filter.And.Equal(login,Constants.FieldName.UID))).FirstOrDefault();
                if (qnnSample == null || !(bool)qnnSample[Constants.FieldName.ActiveYN])
                {
                    //Audit Log for sample failed login (sample not found)
                    await Clover.Core.Utils.AuditHelper.AuditLogLoginFailed("Internet username: " + login);
                    return LoginResult.Fail(LoginResult.Outcome.InvalidCredentials); //return bad creds reason here to prevent leaking too much info
                }
                int numRetry = (int)qnnSample[Constants.FieldName.NumRetry];
                
                string uid = qnnSample[Constants.FieldName.UID]?.ToString();
                bool isAnonymous = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uid);
                bool validCredentialsPresented = password.Equals(qnnSample[Constants.FieldName.Pwd].ToString()) || isAnonymous;
                if (validCredentialsPresented)
                {
                    LoginResult.LoginInformation information = await RecordSampleLogin(
                        jwtService,
                        qnnSample, 
                        isEnforceRespondentSingleSession, 
                        qnnSampleModel);
                    return LoginResult.Success(information);
                } 
                else
                {
                    //Audit Log sample failed login (valid sample)
                    await Clover.Core.Utils.AuditHelper.AuditLogLoginFailed(null, (Guid)qnnSample[Constants.FieldName.Id], null);

                    //Increment the failure counter and maybe lock the account for invalid password attempts
                    numRetry++;
                    bool lockAccountNow = (numRetry >= Constants.NumRetry);
                    if(lockAccountNow) qnnSample.TrySetMember(Constants.FieldName.ActiveYN, false);
                    qnnSample.TrySetMember(Constants.FieldName.NumRetry, numRetry);
                    await qnnSampleModel.UpdateSingleAsync(qnnSample);
                    return lockAccountNow
                        ? LoginResult.Fail(LoginResult.Outcome.AccountLocked)
                        : LoginResult.Fail(LoginResult.Outcome.InvalidCredentials);
                }                
            }
            catch (Exception e)
            {
                throw new PasswordRespondentLoginException(login, isEnforceRespondentSingleSession, e);
            }
        }

        /// <summary>
        /// If this sample has an existing JWT linked from RespondentSessionTokenId then it will be deleted 
        /// from JsonWebTokens. Don't call this if not enforcing single respondent session (caller to check).
        /// </summary>
        /// <param name="sampleId"></param>
        /// <returns></returns>
        private static async Task ClearExistingToken(Guid sampleId)
        {
            try
            {
                string tokenId = await spSP_GetRespondentSessionTokenId.ExecuteAsync(sampleId);
                if (tokenId != null)
                {
                    //if there is a token id then another session for this respondent might still be active
                    //so deleting the token will invalidate it on this end
                    await Clover.AuthServices.Jwt.Data.DataService.DeleteToken(tokenId);
                }

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(ClearExistingToken) + " completed for sampleId={0}, with tokenId={1}", sampleId, tokenId);
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogTrace(e, nameof(ClearExistingToken) + " caught unexpected exception for sampleId={0}", sampleId);
                throw; //caller to handle
            }
        }

        /// <summary>
        /// Based on the records in LoginSessionStatus this removes any previous JWT access token assigned to this sample
        /// and records a new entry for their current access token. Don't call this if respondent single session is not
        /// to be enforced! Caller to check. 
        /// </summary>
        /// <param name="sampleId"></param>
        /// <param name="accessToken"></param>
        /// <returns></returns>
        private static async Task RecordSessionTokenId(Guid sampleId, string accessToken)
        {
            try
            {
                //TODO - take the date to record so it matches the user record
                string tokenId = ExtractTokenId(accessToken);
                await spSP_UpdateRespondentSessionTokenId.ExecuteAsync(sampleId, tokenId);
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(e, nameof(RecordSessionTokenId) + " caught an unexpected exception for sampleId={0}", sampleId);
                throw;
            }
        }

        /// <summary>
        /// Given a raw JWT accessToken will return its TokenId which is the value of the sessionid claim (this is used as the
        /// primary key for it in the JsonWebTokens table where it is referred to as 'TokenId').
        /// Note that it is not the job of this method to validate the token. 
        /// </summary>
        public static string ExtractTokenId(string accessToken)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException("required", nameof(accessToken));
            try
            {
                JsonWebToken token = new JsonWebToken(accessToken);
                Claim sessionClaim = token.Claims.FirstOrDefault(claim => "sessionid".Equals(claim.Type));
                return sessionClaim.Value ?? throw new InvalidOperationException("No sessionid claim in token");
            }
            catch (Exception e)
            {
                throw new InternalException("Unable to extract TokenId from raw JWT accessToken", e);
            }
        }

        /// <summary>
        /// Record the sample login and generate the LoginResult to return
        /// </summary>
        /// <param name="qnnSample"></param>
        /// <param name="qnnSampleModel">optional model reference (will get one itself if null)</param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        private static async Task<LoginResult.LoginInformation> RecordSampleLogin(
            IJwtService jwtService,
            DynamicEntity qnnSample, 
            bool isEnforceRespondentSingleSession, 
            EntityModel qnnSampleModel = null)
        {
            if (qnnSample == null) 
                throw new ArgumentNullException(nameof(qnnSample));

            if(qnnSampleModel==null)
            {
                qnnSampleModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
            } 
            else if (Constants.ModelName.QNN_SAMPLE != qnnSampleModel.Name)
            {
                throw new ArgumentException(
                    nameof(qnnSampleModel), 
                    $"Wrong model {qnnSampleModel.Name}, expected {Constants.ModelName.QNN_SAMPLE}");
            }
             
            //TODO - can we use a tx for the below?

            String uid = (string)qnnSample[Constants.FieldName.UID];
            DateTime lastLoginDate = (DateTime?)qnnSample[Constants.FieldName.LastLoginDate] ?? DateTime.Now;

            bool forcePwdChange;
            bool isAnonymous = TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uid);
            if (!isAnonymous)
            {
                //Reset the login failure counter on a successful authentication
                int numRetry = (int)qnnSample[Constants.FieldName.NumRetry];
                if (numRetry > 0)
                {
                    qnnSample.TrySetMember(Constants.FieldName.NumRetry, 0);
                }

                forcePwdChange = (bool)qnnSample[Constants.FieldName.PwdResetYN];
            }
            else
            {
                //Never force password change for swzAnonymous (because they dont use password!)
                forcePwdChange = false;

                //Do not enforce respondent single-session for the anonymous respondent
                isEnforceRespondentSingleSession = false;
            }

            Guid sampleId = (Guid)qnnSample[Constants.FieldName.Id];

            if (isEnforceRespondentSingleSession)
                await ClearExistingToken(sampleId); //wipe the old jwt for this sample

            string sampleName = qnnSample[Constants.FieldName.Name]?.ToString();
            Clover.AuthServices.Jwt.Components.Entity.LoginResultData tokenData 
                = await jwtService.GenerateRespondentTokens(sampleId, sampleName);

            if (isEnforceRespondentSingleSession)
                await RecordSessionTokenId(sampleId, tokenData.AccessToken); //record Id of new token (so can clear next time)


            //Audit
            if (!isAnonymous) //TODO - why we don't log anonymous?
            {
                await Clover.Core.Utils.AuditHelper.AuditLog(null, sampleId, null, "Login");
            }

            qnnSample.TrySetMember(Constants.FieldName.LastLoginDate, DateTime.Now);
            await qnnSampleModel.UpdateSingleAsync(qnnSample);

            return new LoginResult.LoginInformation(
                    userId: uid,
                    sampleId: sampleId.ToString(),
                    encrUserID: EncryptionHelper.EncryptStr(uid, Constants.LoginKey, Constants.LoginIv),
                    accessToken: tokenData.AccessToken,
                    renewalToken: tokenData.RenewalToken,
                    lastLoginDate: lastLoginDate,
                    forcePwdChange: forcePwdChange);
        }

        private class InvalidInvitationOrDirectAccessDetailsException : ArgumentException
        {
            public enum Parameter { accessCode, dlsiCode, formCode }

            public Parameter Argument { get; private set; }

            public InvalidInvitationOrDirectAccessDetailsException(Parameter argument) : base("Invalid value",argument.ToString()) { this.Argument = argument; }
        }

        /// <summary>
        /// Used with DirectAcccessDetails where the form code and form name are not used
        /// </summary>
        private const string FormNotApplicable = "_FormNotApplicable";

        /// <summary>
        /// Will fetch the details for the specified arguments (these come from the URL the respondent accessed) and 
        /// parse out the AccessCode, find the DLSI entity, and form etc. If the values passed are malformed or refer to
        /// non-existent entities then an InvalidDirectAccessDetailsException is raised (it will identify which argument
        /// was bad). Otherwise the method returns the parsed AccessCode object along with the formName and the QNN_DPLY_SAMPLE_INFO
        /// entity detailing the respondents participation in the survey.
        /// Note that this method *does not* check if the AccessCode is the correct access code (only that it is formatted validly)
        /// and it is for the caller to verify the parsed AccessCode against what they are expecting.
        /// The QNN_DPLY_SAMPLE_INFO entity is retrieved at FetchJoins level. 
        /// This method is now used for invitiation links as well as direct access links.
        /// </summary>
        /// <param name="accessCodeString"></param>
        /// <param name="dlsiCode"></param>
        /// <param name="formCode"></param>
        /// <returns>accessCode, dlsi entity, form name</returns>
        /// <exception cref="InvalidInvitationOrDirectAccessDetailsException"></exception>
        /// <exception cref="Exception"></exception>
        private static async Task<(AccessCode accessCode, DynamicEntity qnnDplySampleInfo, string formName)> InvitationOrDirectAccessDetails(
            string accessCodeString,
            string dlsiCode,
            string formCode)
        {
            if (!AccessCode.IsValidFormat(accessCodeString)) 
                throw new InvalidInvitationOrDirectAccessDetailsException(InvalidInvitationOrDirectAccessDetailsException.Parameter.accessCode);
            if (string.IsNullOrEmpty(dlsiCode))
                throw new InvalidInvitationOrDirectAccessDetailsException(InvalidInvitationOrDirectAccessDetailsException.Parameter.dlsiCode);
            if (string.IsNullOrEmpty(formCode))
                throw new InvalidInvitationOrDirectAccessDetailsException(InvalidInvitationOrDirectAccessDetailsException.Parameter.formCode);
            try
            {
                AccessCode accessCode = new AccessCode(accessCodeString);
                
                //This nonsense is just for mildly obfuscating the actual running-number of DLSI (but real security is the AccessCode)
                int obfuscatedDlsiNumberId = (int)AccessCode.DecodeStringAsLong(dlsiCode);
                int waxOff = accessCode.ToString().Select((c) => (int)c).Sum() + Constants.MagicNumber;
                int dlsiNumberId = obfuscatedDlsiNumberId ^ waxOff;

                EntityModel qnnDplySampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);
                Filter byQnnDplyNumberId = Filter.And.Equal(dlsiNumberId, Constants.FieldName.NumberId);
                DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byQnnDplyNumberId)).FirstOrDefault();
                if(qnnDplySampleInfo ==null)
                {
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(InvitationOrDirectAccessDetails) + " - QNN_DPLY_SAMPLE_INFO with NumberId={1} not found", dlsiNumberId);
                    }
                    throw new InvalidInvitationOrDirectAccessDetailsException(InvalidInvitationOrDirectAccessDetailsException.Parameter.dlsiCode);
                }

                string formName;
                if(FormNotApplicable.Equals(formCode))
                {
                    formName = null;
                }
                else
                {
                    //Get the formName based on the form numberId 
                    int qnnQnnFormNumberId = (int)AccessCode.DecodeStringAsLong(formCode);
                    Guid qnnId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.QnnId];
                    EntityModel qnnQnnFormModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM);
                    Filter byQnnFormNumberId = Filter.And.Equal(qnnQnnFormNumberId, Constants.FieldName.NumberId);
                    DynamicEntity qnnQnnForm = (await qnnQnnFormModel.GetAsync(byQnnFormNumberId)).FirstOrDefault();
                    if (qnnQnnForm == null)
                    {
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(InvitationOrDirectAccessDetails) + " - QNN_QNN_FORM with NumberId={1} not found", qnnQnnFormNumberId);
                        }
                        throw new InvalidInvitationOrDirectAccessDetailsException(InvalidInvitationOrDirectAccessDetailsException.Parameter.formCode);
                    }
                    formName = (string)qnnQnnForm[Constants.FieldName.Name];
                }
                
                return (accessCode, qnnDplySampleInfo, formName);
            }
            catch(InvalidInvitationOrDirectAccessDetailsException)
            {
                throw;
            }
            catch(Exception e)
            {
                logger.LogDebug(e, nameof(InvitationOrDirectAccessDetails) + " - caught unexpected exception, dlsiCode={0}, formCode={1}", dlsiCode, formCode);
                throw new Exception("Failed to extract direct access details", e); //Unexpected errors
            }
        }

        public static async Task<LoginResult> SPCPLogin(
            IJwtService jwtService,
            string uid, 
            bool isEnforceRespondentSingleSession)
        {
            if (string.IsNullOrWhiteSpace(uid)) throw new ArgumentException("required", nameof(uid));            
            try
            {
                EntityModel qnnSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                Filter byUid = Filter.And.Equal(uid, Constants.FieldName.UID);
                DynamicEntity qnnSample
                    = (await qnnSampleModel.GetAsync(byUid)).FirstOrDefault();
                if (qnnSample == null)
                {
                    //TODO - can consider dropping this to info or debug level logging
                    logger.LogError(nameof(SPCPLogin) + " - did not find a QNN_SAMPLE with UID={0}", uid);
                    return LoginResult.Fail(LoginResult.Outcome.InvalidCredentials);
                }                    
                else
                {
                    LoginResult.LoginInformation information
                        = await RecordSampleLogin(
                            jwtService,
                            qnnSample, 
                            isEnforceRespondentSingleSession, 
                            qnnSampleModel);
                    return LoginResult.Success(information);
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(SPCPLogin) + " - caught an unexpected error for uid={0}", uid);
                throw new SPCPRespondentLoginException(uid, isEnforceRespondentSingleSession, e);
            }
        }

        /// <summary>
        /// Process a request for Direct Access login (this feature used to be called Trackable Anonymous)
        /// </summary>
        /// <param name="accessCodeString"></param>
        /// <param name="dlsiCode"></param>
        /// <param name="formCode"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public static async Task<DirectAccessLoginResult> DirectAccessLogin(
            IJwtService jwtService,
            string accessCodeString,
            string dlsiCode,
            string formCode,
            bool isEnforceRespondentSingleSession)
        {
            try
            {
                EntityModel qnnSampleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);

                (AccessCode accessCode, DynamicEntity qnnDplySampleInfo, string formName)
                    = await InvitationOrDirectAccessDetails(accessCodeString, dlsiCode, formCode);

                Guid dplySampleInfoId = (Guid)qnnDplySampleInfo[Constants.FieldName.Id];
                bool directAccessEnabled
                    = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsDirectAccessEnabled];
                bool isAnonymousSurvey
                    = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsAnonymous];
                bool isMultipleResponseSurvey
                    = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsMultipleResponse];

                if (!directAccessEnabled || isAnonymousSurvey || isMultipleResponseSurvey)
                {
                    return DirectAccessLoginResult.IncompatibleSurveyFeatures(dplySampleInfoId);
                }

                AccessCode expectedAccessCode = AccessCode.FromEncryptedString( 
                    (string)qnnDplySampleInfo[Constants.FieldName.DirectAccessCode],
                    EncryptionHelper.Bytes(Constants.LoginKey),
                    ((Guid)qnnDplySampleInfo[Constants.FieldName.Id]).ToByteArray());
                if (expectedAccessCode==null || accessCode != expectedAccessCode)
                {
                    return DirectAccessLoginResult.InvalidAccessCode();
                }

                //Process the direct access login
                Guid dplyId = (Guid)qnnDplySampleInfo[Constants.FieldName.DplyId];
                Guid listSampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId];
                Guid sampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.SampleId];
                bool sampleActiveInList = (bool)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.ActiveYN];
                DynamicEntity qnnSample = await GetQnnSampleById(sampleId, qnnSampleModel);
                bool sampleActive = (bool)qnnSample[Constants.FieldName.ActiveYN];

                if (qnnSample == null || !sampleActive || !sampleActiveInList)
                {
                    await Clover.Core.Utils.AuditHelper.AuditLogLoginFailed("Direct access: " + (string)qnnSample[Constants.FieldName.UID]);
                    return DirectAccessLoginResult.InvalidRespondent(dplySampleInfoId);
                }

                bool allowDirectAcccessWhenComplete
                    = (bool)qnnDplySampleInfo[Constants.FieldName.DplyId + "_" + Constants.FieldName.IsDirectAccessForComplete];
                if (!allowDirectAcccessWhenComplete)
                {
                    //Need to get the response (if any) and check it is it completed
                    List<DynamicEntity> responses = await ResponseApplication.GetResponsesForSample(dplyId, listSampleId);
                    if(responses.Any(r => r[Constants.FieldName.DateComplete] != null))
                    {
                        return DirectAccessLoginResult.ResponseCompleted(dplySampleInfoId);
                    }
                }

                //All good, log them in and tell the internet side to log them in there and they may proceed to the survey
                LoginResult.LoginInformation information 
                    = await RecordSampleLogin(
                        jwtService,
                        qnnSample, 
                        isEnforceRespondentSingleSession, 
                        qnnSampleModel);
                return DirectAccessLoginResult.RedirectToSurvey(information, dplySampleInfoId, formName);
            }
            catch(InvalidInvitationOrDirectAccessDetailsException ida)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(ida, nameof(DirectAccessLogin) + " - caught unexpected exception, dlsiCode={0}, formCode={1}", dlsiCode, formCode);
                }
                return (ida.Argument == InvalidInvitationOrDirectAccessDetailsException.Parameter.accessCode)
                    ? DirectAccessLoginResult.InvalidAccessCode()
                    : DirectAccessLoginResult.InvalidSurvey();
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(e, nameof(DirectAccessLogin) + " - caught unexpected exception for accessCodeString={0}, dlsiCode={1}, formCode={2}, isEnforceRespondentSingleSession={3}", accessCodeString, dlsiCode, formCode, isEnforceRespondentSingleSession);
                throw new DirectAccessRespondentLoginException(accessCodeString, dlsiCode, formCode, isEnforceRespondentSingleSession, e);
            }
        }

        public static async Task<RespInvitationResult> InvitationLogin(
            IJwtService jwtService,
            string dlsiCode, 
            string accessCodeString,
            bool isEnforceRespondentSingleSession)
        {
            try
            {
                (AccessCode accessCode, DynamicEntity qnnDplySampleInfo, string formName) details 
                    = await InvitationOrDirectAccessDetails(accessCodeString, dlsiCode, FormNotApplicable);

                DynamicEntity qnnDplySampleInfo = details.qnnDplySampleInfo;
                
                bool sampleActiveInList = (bool)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.ActiveYN];
                QnnStatusId dlsiStatus = QnnStatusId.FromGuid((Guid)qnnDplySampleInfo[Constants.FieldName.Status]);

                Guid sampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId + "_" + Constants.FieldName.SampleId];
                EntityModel qnnSampleModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                DynamicEntity qnnSample = await GetQnnSampleById(sampleId, qnnSampleModel);
                if (qnnSample == null) return RespInvitationResult.InvalidRespondent();

                bool sampleActive = (bool)qnnSample[Constants.FieldName.ActiveYN];
                if (!sampleActive) return RespInvitationResult.InvalidRespondent();

                AccessCode providedAccessCode = details.accessCode;
                AccessCode expectedAccessCode = AccessCode.FromEncryptedString(
                    (string)qnnDplySampleInfo[Constants.FieldName.DirectAccessCode],
                    EncryptionHelper.Bytes(Constants.LoginKey),
                    ((Guid)qnnDplySampleInfo[Constants.FieldName.Id]).ToByteArray());
                if (expectedAccessCode == null || providedAccessCode != expectedAccessCode)
                {
                    return RespInvitationResult.InvalidAccessCode();
                }

                //ONLY update if sample is active in the list (include itself) and the status is at the very beginning stage PENDING
                if (QnnStatusId.Pending.Equals(dlsiStatus))
                {
                    qnnDplySampleInfo[Constants.FieldName.Status] = QnnStatusId.Acknowledged.Value;
                    //These two field seems use to trace intranet user only e.g. Survey Admin or Data Editor
                    //  qnnDplySampleInfo[Constants.FieldName.StatusModifyOn] = DateTime.Now;
                    //  qnnDplySampleInfo[Constants.FieldName.StatusModifyBy] = sampleId;
                    EntityModel qnnDplySampleInfoModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.FetchJoins);
                    await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                }

                DateTime? lastLoginDate = (DateTime?)qnnSample[Constants.FieldName.LastLoginDate];
                bool neverLoginBefore = (lastLoginDate == null) || (lastLoginDate == DateTime.MinValue);
                bool forcePwdChange = (bool)qnnSample[Constants.FieldName.PwdResetYN] || neverLoginBefore;
                if (forcePwdChange)
                {
                    //If require to change password then log them in,
                    //upon internet web should redirect them to change password page and directly into the dashboard page.
                    LoginResult.LoginInformation information 
                        = await RecordSampleLogin(
                            jwtService,
                            qnnSample, 
                            isEnforceRespondentSingleSession, 
                            qnnSampleModel);
                    return RespInvitationResult.InviteCompletedRequireChangePassword(information);
                }
                else
                {
                    //Upon internet web should reach login page for the normal login flow.
                    //(i.e. we won't log them in here, they would need to login manually)
                    return RespInvitationResult.InviteCompleted();
                }
            }
            catch (InvalidInvitationOrDirectAccessDetailsException badDad)
            {
                switch (badDad.Argument)
                {
                    case InvalidInvitationOrDirectAccessDetailsException.Parameter.accessCode:
                        return RespInvitationResult.InvalidAccessCode();

                    case InvalidInvitationOrDirectAccessDetailsException.Parameter.dlsiCode:
                        return RespInvitationResult.InvalidSurvey();

                    default:
                        throw new NotSupportedException($"Unexpected {nameof(InvalidInvitationOrDirectAccessDetailsException.Parameter)} - {badDad.Argument}");
                }
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(InvitationLogin) + " - caught unexpected exception for dlsiCode={0}, accessCodeString={1}, isEnforceRespondentSingleSession={2}", dlsiCode, accessCodeString, isEnforceRespondentSingleSession);
                }
                throw new InvitationRespondentLoginException(dlsiCode, accessCodeString, isEnforceRespondentSingleSession, e);
            }
        }

        public static async Task<DynamicEntity> GetQnnSampleById(Guid sampleId, EntityModel qnnSampleModel = null)
        {
            return await ORMUtils.GetEntityById(sampleId, Constants.ModelName.QNN_SAMPLE, qnnSampleModel);
        }

        /// <summary>
        /// This doesn't change the password, but it does optionally reset the retry counter and its main task is to send the
        /// link with the special token to the respondent so they can change their password. The link will be sent to the distinct
        /// set of ALL their ToEmails (in QNN_SAMPLE_ADDRESS) accross all StructDivision. 
        /// </summary>
        public static async Task<int> SendRespondentPasswordResetLinksAsync(List<Guid> sampleIds, bool isResetRetry)
        {
            //TODO - rewrite this as a JOB now please and enqueue it via BP
            //email the results to the intranet user - with details!

            if (sampleIds == null) throw new ArgumentNullException(nameof(sampleIds));
            if (!sampleIds.Any()) return 0;

            EntityModel qnnSampleAddressModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.FetchJoins);

            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string internetDomainAuthority = await SettingsHelper.Common.GetInternetDomainAuthority();
            if (string.IsNullOrEmpty(internetDomainAuthority))
                throw new InvalidOperationException("InternetDomainAuthority is not configured in dwAppSettings");
            string appName = await SettingsHelper.Common.GetApplicationName();

            string timeStamp = DateTime.Now.ToString("dd MMMM yyyy hh:mm:ss tt");

            int emailsQueued = 0;
            foreach (Guid sampleId in sampleIds)
            {
                //TODO - if we need to do much more maintenance on these reset flows then reifying this token into a class might be helpful
                string token = $"{sampleId}{Constants.QnnDelimiter}{timeStamp}";

                //Send to the ToEmails set of ToEmails (and NOT CcEmails) we have for this sample across ALL StructDivision
                //This is a special case (normally would only send based on the applicable StructDivision, but for the login
                //it need to go to all
                List<DynamicEntity> allAddress 
                    = await GetAllSampleAddressAsync(sampleId, rootStructDivisionId: null, qnnSampleAddressModel);
                if(allAddress.Any())
                {
                    bool activeYN = (bool)allAddress.First()[Constants.FieldName.SampleId + '_' + Constants.FieldName.ActiveYN];
                    string uid = (string)allAddress.First()[Constants.FieldName.SampleId + '_' + Constants.FieldName.UID];

                    List<string> respEmails = Email.SplitAddressesExtractDistinct(
                        allAddress.Select(sampleAddress => (string)sampleAddress[Constants.FieldName.ToEmails]) );

                    if(logger.IsEnabled(LogLevel.Information))
                    {
                        logger.LogInformation(nameof(SendRespondentPasswordResetLinksAsync) + " - sending password reset link for sample {0} to {1}", sampleId, respEmails);
                    }

                    try
                    {
                        string encryptedToken
                            = await InternetAccountApplication.StoreSamplePasswordResetTokenAsync(sampleId, token, isResetRetry);
                        string resetLink
                            = $"{Constants.MailLinksProtocol}{internetDomainAuthority}/Resp/resetPassword/?nkt={HttpUtility.UrlEncode(encryptedToken)}";
                        string body = $"Please reset your {appName} password by clicking this link: <a href='{resetLink}'>{resetLink}</a>";
                        await BusinessProcess.Enqueue.SendEmail(
                            mailSettings: mailSettings,
                            email: string.Join(',',respEmails), //TODO
                            subject: $"{appName} Password Reset: {uid}",
                            body: body,
                            appName: appName);

                        emailsQueued++;
                    }
                    catch (Exception e)
                    {
                        logger.LogError(e, nameof(SendRespondentPasswordResetLinksAsync) +  " - error preparing password reset mail job for sampleId={0}", sampleId);
                    }
                }
            }
            return emailsQueued;
        }

        /// <summary>
        /// Intended for use in the admin or respondent initiated password reset flows.
        /// Updates the password for the specfied QNN_SAMPLE provided that they are active and 
        /// resets the retry counter and clears the PwdResetYN flag.
        /// If not active or not found an exception will be raised.
        /// nb: this method DOES NOT send the email
        /// </summary>
        public static async Task ResetSamplePasswordAsync(Guid sampleId, string newPassword)
        {
            if (string.IsNullOrWhiteSpace(newPassword)) 
                throw new ArgumentException("Not specified", nameof(newPassword));
            EntityModel qnnSampleModel =
                 await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
            DynamicEntity qnnSample 
                = await GetQnnSampleById(sampleId, qnnSampleModel);
            if (qnnSample == null) 
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_SAMPLE, sampleId);
            if (!(bool)qnnSample["ActiveYN"]) 
                throw new InvalidOperationException($"Sample {sampleId} is not active");

            qnnSample[Constants.FieldName.Pwd] = EncryptionHelper.EncryptStr(newPassword, Constants.LoginKey, Constants.LoginIv);
            qnnSample[Constants.FieldName.SelfUpdatedDate] = DateTime.Now;
            qnnSample[Constants.FieldName.PwdResetYN] = false; //password has now been reset so clear flag indicating reset is required
            qnnSample[Constants.FieldName.PwdResetToken] = null; //clear the token so it can't be resused even before expiry
            if ((int)qnnSample[Constants.FieldName.NumRetry] > 0) qnnSample[Constants.FieldName.NumRetry] = 0;
            await qnnSampleModel.UpdateSingleAsync(qnnSample);
        }

        /// <summary>
        /// Store a password reset token in the database and (optionally) clear the counter for failed password attempts.
        /// Will fail if the specified sample is not active (or not found etc)
        /// </summary>
        public static async Task<string> StoreSamplePasswordResetTokenAsync(Guid sampleId, string token, bool isResetRetry)
        {
            if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));

            EntityModel qnnSampleModel =
                await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE,Constants.Level.NoJoins);
            DynamicEntity qnnSample = await GetQnnSampleById(sampleId, qnnSampleModel);
            if (qnnSample == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_SAMPLE, sampleId);

            if (!(bool)qnnSample["ActiveYN"]) 
                throw new InvalidOperationException($"Sample {sampleId} is not active");

            string encryptedToken = EncryptionHelper.EncryptStr(token, Constants.LoginKey, Constants.LoginIv);
            qnnSample[Constants.FieldName.PwdResetToken] = encryptedToken;
            if(isResetRetry)
            {
                //nb: this will be used when the reset link sending is initiated by a system admin,
                //    and must not be used when self-initiated by a user
                qnnSample[Constants.FieldName.NumRetry] = 0; //Clear the failed password attempts counter
            }
            await qnnSampleModel.UpdateSingleAsync(qnnSample);

            return encryptedToken;
        }

        //TODO - sample Id are a Guid, so why does this take a string?
        public static async Task<(string, string, bool)> ValidateRespIdAsync(string id)
        {
            try
            {

                var sampleModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, 0, true);
                var sampleEntity = (await sampleModel.GetAsync(Filter.And.Equal(id, Constants.FieldName.Id)))?.FirstOrDefault();

                if (sampleEntity == null) //Contain no user data
                {
                    return ("User does not exist!", null, false);
                }

                var token = sampleEntity["PwdResetToken"].ToString();//Get resetpwdtoken

                if (((bool)sampleEntity["ActiveYN"]).Equals(false)) return ("Invalid Account. Please contact administrator", null, false);
                return ("User exist!", token, true);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ValidateRespIdAsync) + " - caught unexpected exception, id={0}", id);
                return ("Invalid Account. Please contact administrator", null, false);
            }
        }

        /// <summary>
        /// Verifies that the token is valid, for an active existing user, and not expired.
        /// </summary>
        /// <param name="token">unencrypted reset token</param>
        public static async Task<ValidatePasswordResetTokenResult> ValidatePasswordResetTokenAsync(string token)
        {
            if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));

            string[] strArr = token.Split(Constants.QnnDelimiter);
            if (strArr.Length != 2)
                return ValidatePasswordResetTokenResult.InvalidToken();


            //Check if the supplied token is expired, we'll do this before we retrieve the expected token from the db
            //as this will save us a db lookup in many cases. If it hasnt expired we will still be comparing the entire
            //token against the expected one to check that it is a genuine token we generated earlier.
            DateTime timestamp = Convert.ToDateTime(strArr[1]);

            List<AppSettings> settings = await AppSettings.SelectAsync(Filter.And.In(new List<string>() { "ResetPwdTimeSpan" }, "Name"));
            string timespan = settings.FirstOrDefault(c => c.Name == "ResetPwdTimeSpan")?.Value;
            if (string.IsNullOrEmpty(timespan))
            {
                timespan = "5"; //Fill timespan settings in DB app settings or default is 5minutes
            }

            DateTime timer = timestamp.AddMinutes(Convert.ToDouble(timespan));
            if (timer < DateTime.Now)
                return ValidatePasswordResetTokenResult.LinkExpired();


            //Now we can check if the sample identified in the token is valid and if this token is really theirs
            Guid sampleId = Guid.Parse(strArr[0]);
            DynamicEntity qnnSample = await GetQnnSampleById(sampleId);
            if (qnnSample == null)
            {
                logger.LogDebug(nameof(ValidatePasswordResetTokenAsync) + " - sample not found: {0}", sampleId);
                return ValidatePasswordResetTokenResult.InvalidSample();
            }

            bool isActive = (bool)qnnSample[Constants.FieldName.ActiveYN];
            if(!isActive) 
                return ValidatePasswordResetTokenResult.InvalidSample();

            string tokenInDb = (string)qnnSample[Constants.FieldName.PwdResetToken];
            string expectedToken 
                = EncryptionHelper.DecryptStr(tokenInDb, Constants.LoginKey, Constants.LoginIv);
            return (token.Equals(expectedToken))
                ? ValidatePasswordResetTokenResult.Valid()
                : ValidatePasswordResetTokenResult.InvalidToken();
        }

        /// <summary>
        /// Utility method to get a QNN_SAMPLE_ADDRESS entity given the SampleId and a specific StructDivisionId.
        /// This is for a single organisation.
        /// </summary>
        public static async Task<DynamicEntity> GetSampleAddressAsync(
            Guid sampleId, 
            Guid structDivisionId, 
            EntityModel qnnSampleAddressModel=null)
        {
            if(qnnSampleAddressModel==null)
            {
                qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
            }
            Filter bySampleIdAndStuctDivision = Filter.And
                .Equal(structDivisionId, Constants.FieldName.StructDivisionId)
                .Equal(sampleId, Constants.FieldName.SampleId);
            DynamicEntity qnnSampleAddress
                = (await qnnSampleAddressModel.GetAsync(bySampleIdAndStuctDivision))
                .FirstOrDefault();
            return qnnSampleAddress;
        }

        /// <summary>
        /// Get all the QNN_SAMPLE_ADDRESS for the specified SampleId in the (optional) subtree of the specfied StructDivisionId, or
        /// if not specified, across ALL StructDivisions.
        /// </summary>
        /// <param name="sampleId">required Id in QNN_SAMPLE</param>
        /// <param name="rootStructDivisionId">root organisation node in the organisaion tree, if null/empty will get for ALL</param>
        /// <param name="qnnSampleAddressModel">optional model reference (to avoid unnecessary re-lookup)</param>
        /// <returns></returns>
        public static async Task<List<DynamicEntity>> GetAllSampleAddressAsync(
            Guid sampleId, 
            Guid? rootStructDivisionId, 
            EntityModel qnnSampleAddressModel = null)
        {
            if (qnnSampleAddressModel == null)
            {
                qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
            }

            Filter filter = Filter.And.Equal(sampleId, Constants.FieldName.SampleId);
            if (rootStructDivisionId != null && !Guid.Empty.Equals(rootStructDivisionId))
            {
                List<Guid> structDivisionIds = await StructDivision.SelectChildrenAndThisIdListAsync(rootStructDivisionId.Value);
                filter = filter.Merge(Filter.And.In(structDivisionIds, Constants.FieldName.StructDivisionId));
            }

            List<DynamicEntity> addresses = (await qnnSampleAddressModel.GetAsync(filter));
            return addresses;
        }

        /// <summary>
        /// Reset the delegation code and send an email with the new code to the sample's ToEmails (if they have any).
        /// This method will reset the delegation code for all dlsi specified, but only sends notification to samples that are active
        /// and active in their list. Note that it doesn't check the active state of the deployment, and it does not verify if the
        /// calling user has organisation access to these dlsi (these tasks are the responsibility of calling code).
        /// The reset count will be returned.
        /// </summary>
        public static async Task<int> SendNewDelegationCodes(List<DynamicEntity> vSPListSampleInfos)
        {
            bool isLoggerDebugEnabled = logger.IsEnabled(LogLevel.Debug);

            //nb: we pass in the actual entities rather than just their ids as an 'optimisation' because its the caller's job to
            //    look at them first and validate the struct division is applicable to the user, so they can then pass this is to
            //    save an extra lookup
            if (vSPListSampleInfos == null) throw new ArgumentNullException(nameof(vSPListSampleInfos));
            if (!vSPListSampleInfos.Any())
            {
                if (isLoggerDebugEnabled) 
                    logger.LogDebug(nameof(SendNewDelegationCodes) + " no samples specified");
                return 0;
            }

            int resetCount = 0;
            try
            {
                EntityModel qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
                EntityModel qnnDplySampleInfoModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                string internetDomainAuthority = await SettingsHelper.Common.GetInternetDomainAuthority();
                if (string.IsNullOrEmpty(internetDomainAuthority)) 
                    throw new InvalidOperationException("Internet Domain Authority is not configured in AppSettings table");

                foreach (DynamicEntity vSPListSampleInfo in vSPListSampleInfos)
                {
                    Guid dlsi = (Guid)vSPListSampleInfo[Constants.FieldName.Id];
                    Guid sampleId = (Guid)vSPListSampleInfo[Constants.FieldName.SampleId];
                    Guid structDivisionIdForAddress = (Guid)vSPListSampleInfo[Constants.FieldName.StructDivisionId];                    
                    bool isActiveSample
                        = (bool)vSPListSampleInfo[Constants.FieldName.ListSampleRecordActiveYN]
                        && (bool)vSPListSampleInfo[Constants.FieldName.SampleRecordActiveYN];

                    using (SharedTransaction shared = new SharedTransaction())
                    {
                        try
                        {
                            shared.BeginTransactionAsync().Wait();

                            //Create new master delegation code
                            DynamicEntity qnnDplySampleInfoEntity
                                = await DeploymentApplication.GetQnnDplySampleInfoById(dlsi, qnnDplySampleInfoModel);
                            if (qnnDplySampleInfoEntity == null)
                                throw NotFoundException.ForModelName(qnnDplySampleInfoModel.Name, dlsi); //shouldn't happen if already in vSPListSampleInfo

                            //string delegationCode 
                            //    = (EncryptionHelper.GenerateChars(length: 6, EncryptionHelper.CharType.Numerals)
                            //    + EncryptionHelper.GenerateChars(length: 2, EncryptionHelper.CharType.Lowercase)).Scramble();
                            //string encryptedDelegationCode 
                            //    = EncryptionHelper.EncryptStr(delegationCode, Constants.LoginKey, Constants.LoginIv);
                            AccessCode delegationCode = new AccessCode();
                            string encryptedDelegationCode = delegationCode.ToEncryptedString(
                                EncryptionHelper.Bytes(Constants.LoginKey), 
                                EncryptionHelper.Bytes(Constants.LoginIv) );

                            qnnDplySampleInfoEntity.TrySetMember(Constants.FieldName.DelegationCode, encryptedDelegationCode);
                            qnnDplySampleInfoEntity.TrySetMember(Constants.FieldName.DelegationAccessFailAttempt, 0);
                            if (isLoggerDebugEnabled)
                                logger.LogDebug(nameof(SendNewDelegationCodes) + " - Resetting delegation code for dlsi={0}", dlsi);
                            await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfoEntity);
                            resetCount++;

                            //Send Email
                            DynamicEntity sampleAddress
                                = await GetSampleAddressAsync(sampleId, structDivisionIdForAddress, qnnSampleAddressModel);
                            string commaDelimitedToEmails = (string)sampleAddress[Constants.FieldName.ToEmails];
                            bool hasPrimaryEmail = !string.IsNullOrWhiteSpace(commaDelimitedToEmails);
                            bool sendEmail = hasPrimaryEmail && isActiveSample;

                            if(sendEmail)
                            {
                                if (isLoggerDebugEnabled)
                                    logger.LogDebug(nameof(SendNewDelegationCodes) + " - Sending new delegation code for dlsi={0}, ToEmails={1}",
                                        dlsi, commaDelimitedToEmails);

                                string qnnTitle = (string)vSPListSampleInfo[Constants.FieldName.QnnTitle];
                                //TODO - I want to include the sample name in the email, but not their uid

                                string subject = $"Delegation Code has been reset for {qnnTitle}"; //subject is not html
                                string body
                                    = $"<p>Survey Delegation code for {HttpUtility.HtmlEncode(qnnTitle)}</p>"
                                    + $"<p>Your new delegation code is: <strong>{delegationCode}</strong></p>";

                                await BusinessProcess.Enqueue.SendEmail(
                                    mailSettings: mailSettings,
                                    email: commaDelimitedToEmails,
                                    subject: subject,
                                    body: body,
                                    appName: appName);
                            }

                            await shared.CommitAsync();
                        }
                        catch (Exception)
                        {
                            await shared.RollbackAsync().ConfigureAwait(false);
                            throw;
                        }
                    } //end using shared tx
                } //end foreach vSPListSampleInfos
                return resetCount;
            }
            catch (Exception e)
            {
                string msg = $"{nameof(SendNewDelegationCodes)} caught an unexpected exception. resetCount=${resetCount}";
                logger.LogDebug(e, nameof(SendNewDelegationCodes) + " - caught unexpected exception");
                throw new Exception(msg, e);                
            }
        }

        public static string GenerateRespondentPassword()
        {
            string generatedPassword =
                    (EncryptionHelper.GenerateChars(length: 3, EncryptionHelper.CharType.Numerals)
                    + EncryptionHelper.GenerateChars(length: 6, EncryptionHelper.CharType.Lowercase)
                    + EncryptionHelper.GenerateChars(length: 3, EncryptionHelper.CharType.UpperCase))
                    .Scramble();
            return generatedPassword;
        }

    }
}