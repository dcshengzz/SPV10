using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace swz.SurveyPlus.InternetApplication.UnifiedAtApp
{
    /// <summary>
    /// Unified @ App implementation of IRespondentService. 
    /// Calls from outside UnifiedAtApp to the methods in the various 'gateway' classes must go through this class.
    /// Instances of this class are not threadsafe due to use of Restsharp in DefaultApi so scope this service accordingly.
    /// (The older version of RestSharp that the generated Swagger code uses currently is not threadsafe)
    /// </summary>
    public class RespondentServiceUApp : IRespondentService
    {
        //This class is basically the switchboard that links up the interface methods the controllers et al call
        //with the various gateway & impl methods in classes here in the UnifiedAtApp namespace. Tehcnically there's no
        //real reason all those gateway methods couldnt be right here, but from a support and maintainance perspective
        //that would suck, so don't put any work here. Keep this class focussed on assisting to expose the interface only.
        //Another approach would have been to give the gateways their own interfaces, and this would also make it easy to just inject
        //the ones you need and the gatwayimpls could get what they need via DI, but for this case I prefer to have a single place
        //where we can see everything in one interface (which also makes swapping the impl less effort when configuring services
        //at startup). Also makes it easy to greb for anyplace using this one interface.

        private readonly ILogger logger; //TODO - look to eliminating this and pushing down any code that might use it (looking at you ChangePassword!)
        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly IHttpClientFactory httpClientFactory;
        private readonly InternetAppSetting internetAppSetting;
        private readonly IAntiVirusScanner antiVirus;
        private readonly LambdaIntegrationSettings lambdaIntegrationSettings;
        private readonly IInternetApiTokenManager internetApiTokenManager;

        public RespondentServiceUApp(
            IHttpContextAccessor httpContextAccessor,
            IHttpClientFactory httpClientFactory,
            ILogger<RespondentServiceUApp> logger, 
            InternetAppSetting internetAppSetting,
            IAntiVirusScanner antiVirus,
            LambdaIntegrationSettings lambdaIntegrationSettings,
            IInternetApiTokenManager internetApiTokenManager)
        {
            this.httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(httpClientFactory));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.internetAppSetting = internetAppSetting ?? throw new ArgumentNullException(nameof(internetAppSetting));
            this.antiVirus = antiVirus ?? throw new ArgumentNullException(nameof(antiVirus));
            this.lambdaIntegrationSettings = lambdaIntegrationSettings ?? throw new ArgumentNullException(nameof(lambdaIntegrationSettings));
            this.internetApiTokenManager = internetApiTokenManager ?? throw new ArgumentNullException(nameof(internetApiTokenManager));
        }

        public async Task<string> ConnectivityTest()
        {
            return await SettingsGateway.ConnectivityTest(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task ChangePasswordAsync(string uid, string oldPassword, string newPassword)
        {
            string accessToken = await AccessToken(TokenIs.Required);            
            await AccountGateway.ChangePassword(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken,
                newPassword, 
                oldPassword);
        }

        public async Task InvitesChangePasswordAsync(string uid, string newPassword)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            await AccountGateway.ChangePassword(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken,
                newPassword);
        }

        public async Task<List<HelpItem>> GetRespHelpAsync()
        {
            return await RespHelpAndContentGateway.GetRespHelp(
                httpClientFactory, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<List<RespondentContentItem>> GetRespondentContentAsync(string type)
        {
            return await RespHelpAndContentGateway.GetRespondentContent(
                httpClientFactory, 
                internetAppSetting.WebApiAdditionalHeader, 
                type);
        }

        public async Task<StreamWithName> DownloadExcelAsync(
            Guid dlsi, 
            string token, 
            Guid? respId)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await ExcelGateway.DownloadExcel(
                accessToken, 
                httpClientFactory, 
                dlsi, 
                token, 
                internetAppSetting.WebApiAdditionalHeader,
                lambdaIntegrationSettings.IsEnabled,
                respId);
        }

        public async Task UploadExcelAsync(
            Guid qnnId,
            Guid dplyId,
            Guid listSampleId,
            StreamWithName file)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            await ExcelGateway.UploadExcel(
                accessToken,
                httpClientFactory,
                antiVirus,
                qnnId,
                dplyId,
                listSampleId,
                file,
                internetAppSetting.WebApiAdditionalHeader,
                lambdaIntegrationSettings.IsEnabled);
        }

        public async Task<AddResponseResult> AddNewResponseAsync(Guid qnnDplySampleInfoId)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await ResponseGateway.AddNewResponse(
                accessToken, 
                httpClientFactory, 
                qnnDplySampleInfoId, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<bool> IsRequireDelegatedAccessCodeAsync(Guid dlsi)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.IsRequireAccessCode(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken,
                dlsi);
        }

        public async Task<bool> IsDelegatedAccessRetriesExceedAsync(Guid qnnDplySampleInfoId)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.IsDelegatedAccessRetriesExceed(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken, 
                qnnDplySampleInfoId);
        }

        public async Task<bool> ValidateDelegatedAccessCodeAsync(Guid qnnDplySampleInfoId, string inputCode)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.ValidateAccessCode(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken, 
                qnnDplySampleInfoId, 
                inputCode);
        }

        public async Task<DelegateSurveyResult> DelegateSurveyAsync(DelegateSurveyRequest request, string delegationCode)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.DelegateSurvey(
                accessToken, 
                httpClientFactory, 
                request, 
                delegationCode, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<DelegateSurveyResult> RevokeDelegationAsync(string delegationCode, Guid qnnDplySampleInfoId, Guid? delegateId = null)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.RevokeDelegation(
                accessToken, 
                httpClientFactory, 
                delegationCode, 
                qnnDplySampleInfoId, 
                internetAppSetting.WebApiAdditionalHeader, 
                delegateId);
        }

        public async Task<DelegationHistoryResult> GetDelegationHistoryAsync(Guid qnnDplySampleInfoId,string delegationCode)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DelegationGateway.GetDelegationHistory(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken,
                qnnDplySampleInfoId, 
                delegationCode);
        }

        //public async Task<IPRestriction> GetIPRestrictionAsync(Guid dlsi)
        //{
        //    string accessToken = AccessToken(TokenIs.Required);
        //    return await DeploymentGateway.GetIPRestriction(accessToken, apiInstance, dlsi);
        //}

        public async Task<LoginResult> PasswordLoginAsync(string login, string password)
        {
            LoginResult result = await AccountGateway.PasswordLogin(
                httpClientFactory, 
                login, 
                password, 
                internetAppSetting.WebApiAdditionalHeader);
            if (result.IsSuccess)
            {
                internetApiTokenManager.StoreToken(
                    uid: result.Information.UserId,
                    accessToken: result.Information.AccessToken, 
                    renewalToken: result.Information.RenewalToken);
            }
            return result;
        }

        public async Task<LoginResult> SPCPLoginAsync(string uid)
        {
            LoginResult result = await AccountGateway.SPCPLogin(
                httpClientFactory, 
                uid, 
                internetAppSetting.WebApiAdditionalHeader);
            if(result.IsSuccess)
            {
                internetApiTokenManager.StoreToken(
                    uid: result.Information.UserId,
                    accessToken: result.Information.AccessToken, 
                    renewalToken: result.Information.RenewalToken);
            }
            return result;
        }

        public async Task<DirectAccessLoginResult> DirectAccessLoginAsync(
            string accessCode, 
            string dlsiCode, 
            string formCode)
        {
            DirectAccessLoginResult result = await AccountGateway.DirectAccessLogin(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessCode,
                dlsiCode,
                formCode);
            if (result.LoginResult?.IsSuccess ??false)
            {
                internetApiTokenManager.StoreToken(
                    uid: result.LoginResult.Information.UserId,
                    accessToken: result.LoginResult.Information.AccessToken, 
                    renewalToken: result.LoginResult.Information.RenewalToken);
            }
            return result;
        }

        public async Task<RespInvitationResult> InvitesLoginAsync(
            string accessCode,
            string dlsiCode)
        {
            RespInvitationResult result = await AccountGateway.InvitesLogin(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessCode,
                dlsiCode);
            if (result.LoginResult?.IsSuccess ??false)
            {
                internetApiTokenManager.StoreToken(
                    uid: result.LoginResult.Information.UserId,
                    accessToken: result.LoginResult.Information.AccessToken,
                    renewalToken: result.LoginResult.Information.RenewalToken);
            }
            return result;
        }

        public async Task<ShortLinkResult> ProcessShortLinkAsync(
            string shortLinkCode, 
            string accessCode)
        {
            return await ShortLinkGateway.ProcessShortLink(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                shortLinkCode,
                accessCode);
        }

        public async Task LogoffAsync()
        {
            string accessToken = await AccessToken(TokenIs.Optional); //optional because session may be gone already
            if(accessToken != null)
            {
                await AccountGateway.Logoff(
                    accessToken,
                    httpClientFactory,
                    internetAppSetting.WebApiAdditionalHeader);
                    internetApiTokenManager.ClearToken();
            }
        }

        public async Task<bool> SendResetPasswordLinkAsync(string userId)
        {
            return await AccountGateway.SendResetPasswordLink(
                httpClientFactory, 
                userId, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<ValidatePasswordResetTokenResult> ValidatePasswordResetTokenAsync(string nkt)
        {
            return await AccountGateway.ValidatePasswordResetToken(
                httpClientFactory, 
                nkt, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<bool> ResetPasswordAsync(string token, string newPassword)
        {
            return await AccountGateway.ResetPassword(
                httpClientFactory,
                token,
                newPassword,
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<bool> IsAnonymousSurveyAsync(Guid dlsi)
        {
            return await DeploymentGateway.IsAnonymousSurvey(
                httpClientFactory, 
                dlsi, 
                internetAppSetting.WebApiAdditionalHeader);
        }

        public async Task<string> GetCompletionUrl(Guid dlsi)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DeploymentGateway.GetCompletionUrl(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken,
                dlsi);
        }

        public async Task<ListSampleInfo> GetListSampleInfoAsync(Guid dlsi)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await DeploymentGateway.GetListSampleInfo(
                httpClientFactory, 
                internetAppSetting.WebApiAdditionalHeader, 
                accessToken, 
                dlsi);
        }

        public async Task<FileData> GetFileDataByTokenAsync(string fileToken)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await FileGateway.GetFileDataByToken(
                httpClientFactory, 
                internetAppSetting.WebApiAdditionalHeader,
                accessToken, 
                fileToken,
                lambdaIntegrationSettings.IsEnabled);
        }

        public async Task<FileData> GetLocalStorageFileDataByNameAsync(string fileName, Guid sampleId)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await FileGateway.GetLocalStorageFileDataByName(
                httpClientFactory, 
                internetAppSetting.WebApiAdditionalHeader, 
                accessToken, 
                fileName, 
                sampleId,
                lambdaIntegrationSettings.IsEnabled);
        }

        public async Task<string> UploadRespondentFileAsync(string uid, StreamWithName file)
        {
            if (internetAppSetting.Restrictions.DisableUploadsFromSurvey)
                throw new Exception(FileStorageApplication.FILE_UPLOAD_DISABLED_MSG);

            string accessToken = await AccessToken(TokenIs.Required);
            return await FileGateway.UploadRespondentFile(
                    httpClientFactory,
                    antiVirus,
                    internetAppSetting.WebApiAdditionalHeader,
                    accessToken,
                    file,
                    lambdaIntegrationSettings.IsEnabled);
        }


        /// <summary>
        /// Used by DataController
        /// Prepare the request by setting BaseUrl (will mutate the passed object and return it) 
        /// </summary>
        /// <param name="gdRequest">the request, this will be mutated by this call</param>
        /// <returns>same request that was passed in </returns>
        public GetDataRequest PrepareGetRequest(GetDataRequest gdRequest)
        {
            if (gdRequest == null) throw new ArgumentNullException(nameof(gdRequest));

            //Set the base path, this plus a path will be used to read/write data by the InternetApiDataSource
            //For u@ap this must be the api base path
            //Old code where it set this in DataController used the following:
            //BaseUrl = _configuration["Clover:WebApiBase"]
            //So the request will be from internet application to intranet application via an endpoint that is part of u@app api

            //For reference, in the old u@db code (eg SIMS) it used:
            //BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value)
            //to make a 'local' request back to the local application

            gdRequest.BaseUrl = UAppUtils.GetApiBasePath().OriginalString; //this is mutating the gdRequest that was passed in

            //Note, the authorization token, and the WebApiAdditionalHeader will be set inside InternetApiDataSource
            //rather than here. In hindsight here might have been a better place? (could wrap the GetHeadersForLocalRequest
            //to add them). We can consider this again later when time permits. 

            return gdRequest; //same instance as was passed in
        }

        public async Task<PdfExportRateLimitResult> CheckPdfExportRateLimitAsync(Guid dlsi, Guid? respId, string formName, string surveyName, string emails)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await PdfExportGateway.CheckPdfExportRateLimit(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                dlsi,
                respId,
                formName,
                surveyName,
                emails,
                accessToken);
        }

        public async Task<DynamicEntity> GetSurveyDataForPrintAsync(
                Guid dlsi,
                Guid? respId,
                string formName,
                bool IsPDFExportForSubmittedOnly)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            return await PdfExportGateway.GetSurveyDataForPrint(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                dlsi,
                respId,
                formName,
                IsPDFExportForSubmittedOnly,
                accessToken);
        }

        public async Task EnqueuePrintJobAsync(Guid logId, string formName, string emails, string surveyName, string responseData)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            await PdfExportGateway.EnqueuePrintJob(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                logId,
                formName,
                emails,
                surveyName,
                responseData,
                accessToken);
        }

        public async Task UpdatePdfExportStatusAsync(Guid logId, string status, string errorMessage = null)
        {
            string accessToken = await AccessToken(TokenIs.Required);
            await PdfExportGateway.UpdatePdfExportStatus(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                logId,
                status,
                errorMessage,
                accessToken);
        }

        public async Task VerifySessionActive()
        {
            string accessToken = await AccessToken(TokenIs.Required);
            await AccountGateway.VerifySessionActive(
                httpClientFactory,
                internetAppSetting.WebApiAdditionalHeader,
                accessToken);
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        private enum TokenIs { Optional, Required } //used by AccessToken method

        /// <summary>
        /// Get U@App API token (respondent specific JWT).
        /// Verify the presence of the accessToken in the clover runtime metadata session and return it.
        /// Throws a PermissionException if the token is absent but required.
        /// Try to call the internet side to renew the token if it is expired or about to expire.
        /// </summary>
        /// <returns>accessToken</returns>
        private async Task<string> AccessToken(TokenIs tokenIs)
        {
            string accessToken = await internetApiTokenManager.AccessToken();
            if(string.IsNullOrWhiteSpace(accessToken))
            {
                if(TokenIs.Required == tokenIs) 
                    throw new PermissionException("Access token is required but it is not available");
            }            
            return accessToken;
        }

        public async Task<int> GetAutoSaveDelay()
        {
            string delayString = await SettingsGateway.GetSettingAsync(httpClientFactory,
                                internetAppSetting.WebApiAdditionalHeader,
                                Constants.dwAppSettingName.AutosaveDelay);
            return int.TryParse(delayString, out int delay) ? delay : 5000;
        }

        public async Task<bool> GetAutoSaveEnabled()
        {
            string IsAutosaveEnabledString = await SettingsGateway.GetSettingAsync(httpClientFactory,
                                internetAppSetting.WebApiAdditionalHeader,
                                Constants.dwAppSettingName.AutosaveEnabled);
            return bool.TryParse(IsAutosaveEnabledString, out bool isEnabled) && isEnabled;
        }

    } //end of RespondentServiceUApp
}
