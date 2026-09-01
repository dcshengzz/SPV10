using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// U@App support for account/login related activities.
    /// Methods in this class MUST NOT be called directly from outside the UnifiedAtApp implementation of the IRespondentService.
    /// Code outside UnifiedAtApp MUST go through the IRespondentService interface. 
    /// </summary>
    public class AccountGateway
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(AccountGateway));

        public static async Task ChangePassword(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken,
            string password,
            string oldPassword=null)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            
            if (oldPassword == "") throw new PasswordChangeException("Old password not specified");
            if (password == null) throw new PasswordChangeException("New password not specified");
            try
            {
                var form = new Dictionary<string, string>();
                if(oldPassword != null)
                {   //Required for normal self-service password change,
                    //but not Invites flow where ResetPwdYN is true.
                    form.Add("oldPassword", oldPassword);
                }
                form.Add("password", password);

                const string partialUrl = Constants.UAppRoutes.PasswordChange;
                TraceLogHttpClient(logger, "ChangePassword", partialUrl);
                string json = await SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostForm(partialUrl, accessToken, form));
                dynamic response = JsonConvert.DeserializeObject(json);
                if ((bool)response.success)
                    return;
                else
                    throw new PasswordChangeException(((string)response.message) ?? "Unable to change password");
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (PasswordChangeException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ChangePassword) + " - caught an unexpected exception");
                throw new PasswordChangeException("Internal Error. Please retry and contact support if this error persists.");
            }
        }

        public static async Task<LoginResult> PasswordLogin(
            IHttpClientFactory httpClientFactory, 
            string login, 
            string password, 
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(login)) throw new ArgumentException(nameof(login));
            if (string.IsNullOrWhiteSpace(password)) throw new ArgumentException(nameof(password));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string encryptedPassword = EncryptionHelper.EncryptStr(password.Trim(), Constants.LoginKey, Constants.LoginIv);
                var formData = new Dictionary<string, string>();
                formData.Add("login", login);
                formData.Add("password", encryptedPassword);
                string partialUrl = Constants.UAppRoutes.PasswordLogin;
                UAppUtils.TraceLogHttpClient(logger, "Login", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                LoginResult result = JsonConvert.DeserializeObject<LoginResult>(responseContent);
                return result;
            }
            catch (Exception e)
            {
                if(logger.IsEnabled(LogLevel.Warning))
                    logger.LogWarning(e, nameof(PasswordLogin) + " - exception caught, login={0}", login);
                throw new RespondentServiceException("Not able to login", e);
            }
        }

        public static async Task Logoff(
            string accessToken, 
            IHttpClientFactory httpClientFactory, 
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (string.IsNullOrWhiteSpace(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.Logoff;
                UAppUtils.TraceLogHttpClient(logger, "Logoff", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions, 
                    ApiRequest.PostJson(partialUrl, accessToken, null));
                dynamic result = JsonConvert.DeserializeObject<dynamic>(responseContent);
                if (!Convert.ToBoolean(result.success))
                {
                    throw new Exception($"Api server response messageCont: {result.message}"); //Will be wrapped in RSE
                }
            }
            catch (ApiRequestException rex)
            {
                if(rex.StatusCode != null && StatusCodes.Status401Unauthorized == (int)rex.StatusCode)
                {
                    logger.LogWarning("Logoff: api returned 401 Unauthorized. (This might be due to an expired token)");
                }
                else
                {
                    logger.LogDebug(rex, nameof(Logoff) + " - caught ApiRequestException");
                    throw new RespondentServiceException("Logoff was not successful", rex);
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(Logoff) + " - caught Exception");
                throw new RespondentServiceException("Logoff was not successful", e);
            }
        } //end of Logoff

        public static async Task<bool> SendResetPasswordLink(
            IHttpClientFactory httpClientFactory, 
            string uid, 
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if(httpClientFactory==null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(uid)) throw new ArgumentException(nameof(uid));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.SendPasswordResetLink;
                UAppUtils.TraceLogHttpClient(logger, "SendResetPasswordLink", partialUrl);
                var formData = new Dictionary<string, string>();
                formData.Add("uid", uid); //Don't want uid in the url, post in form
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                dynamic result = JsonConvert.DeserializeObject<dynamic>(responseContent);
                bool success = Convert.ToBoolean(result.success);
                return success;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(SendResetPasswordLink) + " - caught unexpected exception, uid={0}", uid);
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        public static async Task<ValidatePasswordResetTokenResult> ValidatePasswordResetToken(
            IHttpClientFactory httpClientFactory, 
            string nkt, 
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(nkt)) throw new ArgumentException(nameof(nkt));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.ValidatePasswordResetToken;// + "?nkt=" + HttpUtility.UrlEncode(nkt);
                Dictionary<string, string> formData = new Dictionary<string, string>();
                formData.Add("nkt", nkt);
                UAppUtils.TraceLogHttpClient(logger, "ValidatePasswordResetToken", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                ValidatePasswordResetTokenResult result = JsonConvert.DeserializeObject<ValidatePasswordResetTokenResult>(responseContent);
                return result;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ValidatePasswordResetToken) + " - caught unexpected exception");
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        public static async Task<bool> ResetPassword(
            IHttpClientFactory httpClientFactory, 
            string token, 
            string newPassword,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(token)) throw new ArgumentException(nameof(token));
            if (string.IsNullOrWhiteSpace(newPassword)) throw new ArgumentException(nameof(newPassword));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.PasswordReset;
                UAppUtils.TraceLogHttpClient(logger, "RespResetPassword", partialUrl);
                var formData = new Dictionary<string, string>();
                formData.Add("token", token);
                formData.Add("newPassword", newPassword);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                dynamic result = JsonConvert.DeserializeObject<dynamic>(responseContent);
                if (!Convert.ToBoolean(result.success))
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(ResetPassword) + " - failed to reset password. Reason: {0}", (string)result.message);
                    }
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ResetPassword) + " - caught unexpected exception");
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        public static async Task<LoginResult> SPCPLogin(
            IHttpClientFactory httpClientFactory, 
            string uid,
            WebApiAdditionalHeaderOptions apiHeaderOptions)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (string.IsNullOrWhiteSpace(uid)) throw new ArgumentException(nameof(uid));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            try
            {
                string partialUrl = Constants.UAppRoutes.SpcpLogin;
                var formData = new Dictionary<string, string>();
                formData.Add("uid", uid);
                UAppUtils.TraceLogHttpClient(logger, "SPCPLogin", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                dynamic response = JsonConvert.DeserializeObject<dynamic>(responseContent);
                if (Convert.ToBoolean(response.success))
                {
                    string userSampleId = response.item.sampleId;
                    string userAccessToken = response.item.accessToken;
                    string renewalToken = response.item.renewalToken;
                    DateTime lastLoginDate = response.item.lastLoginDate;
                    string encrUserId = EncryptionHelper.EncryptStr(uid, Constants.LoginKey, Constants.LoginIv);

                    return LoginResult.Success(
                        new LoginResult.LoginInformation(
                            userId: uid,
                            sampleId: userSampleId,
                            encrUserID: encrUserId,
                            accessToken: userAccessToken,
                            renewalToken: renewalToken,
                            lastLoginDate: lastLoginDate,
                            forcePwdChange: false));
                }
                else
                {
                    //This can be the case if the sample doesn't exist or is not currently enabled
                    logger.LogDebug(nameof(SPCPLogin) + " - Unsuccesful spcplogin result for {0}", uid);
                    return LoginResult.Fail(LoginResult.Outcome.InvalidCredentials);
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(SPCPLogin) + " - caught unexpected exception");
                throw new RespondentServiceException("Unexpected error", e);
            }
        } //end of SPCPLogin

        public static async Task<DirectAccessLoginResult> DirectAccessLogin(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessCode,
            string dlsiCode,
            string formCode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            if (string.IsNullOrEmpty(accessCode)) throw new ArgumentException(nameof(accessCode));
            if (string.IsNullOrEmpty(dlsiCode)) throw new ArgumentException(nameof(dlsiCode));
            if (string.IsNullOrEmpty(formCode)) throw new ArgumentException(nameof(formCode));
            try
            {
                string partialUrl = Constants.UAppRoutes.DirectAccessLogin;
                var formData = new Dictionary<string, string>();
                formData.Add("accessCode", accessCode);
                formData.Add("dlsiCode", dlsiCode);
                formData.Add("formCode", formCode);
                UAppUtils.TraceLogHttpClient(logger, "DirectAccessLogin", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                DirectAccessLoginResult result = JsonConvert.DeserializeObject<DirectAccessLoginResult>(responseContent);
                return result;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(DirectAccessLogin) + " - caught unexpected exception, accessCode={0}, dlisCode={1}, formCode={2}", accessCode, dlsiCode, formCode);
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        public static async Task<RespInvitationResult> InvitesLogin(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessCode,
            string dlsiCode)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));

            if (string.IsNullOrEmpty(accessCode)) throw new ArgumentException(nameof(accessCode));
            if (string.IsNullOrEmpty(dlsiCode)) throw new ArgumentException(nameof(dlsiCode));
            try
            {
                string partialUrl = Constants.UAppRoutes.InvitesLogin;
                var formData = new Dictionary<string, string>();
                formData.Add("accessCode", accessCode);
                formData.Add("dlsiCode", dlsiCode);
                UAppUtils.TraceLogHttpClient(logger, "InvitationLogin", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.PostFormWithoutAccessToken(partialUrl, formData));
                RespInvitationResult result = JsonConvert.DeserializeObject<RespInvitationResult>(responseContent);
                return result;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(InvitesLogin) + " - caught unexpected exception, accessCode={0}, dlsiCode={1}", accessCode, dlsiCode);
                throw new RespondentServiceException("Unexpected error", e);
            }
        }

        /// <summary>
        /// Just checks the access token with no other effects. Will throw InvalidRespondentTokenException if it is not
        /// valid. This provides us a mechanism for ad-hoc reverification of the session. This is more important with
        /// single-session handling active as the token could be invalidated any time by another login.
        /// </summary>
        public static async Task VerifySessionActive(
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            string accessToken)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            if (apiHeaderOptions == null) throw new ArgumentNullException(nameof(apiHeaderOptions));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));

            try
            {
                string partialUrl = Constants.UAppRoutes.Verify;
                UAppUtils.TraceLogHttpClient(logger, "VerifyAccessToken", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                dynamic result = JsonConvert.DeserializeObject(responseContent);
                if (result.success != true) 
                    throw new InternalException("response does not have expected success=true"); //shouldn't happen for this one
            }
            catch (SessionInvalidException sie)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(sie, nameof(VerifySessionActive) + " - caught SessionInvalidException");
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(e, nameof(VerifySessionActive) + " - caught unexpected exception");
                throw new VerifyAccessTokenException("Unexpected error re-verifying access token", e);
            }
        }
    }
}