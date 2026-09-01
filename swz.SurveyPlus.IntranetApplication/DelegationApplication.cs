using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class DelegationApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(DelegationApplication));

        //Fallback default value if setting is not found.
        private const int DELEGATION_ACCESS_CODE_RETRIES = 10;
        
        public static bool IsDelegationAccessRetriesExceed(int retriesLimit, int attemptCount)
        {
            return attemptCount >= retriesLimit;
        }

        /// <summary>
        /// -1 or less than 0 consider unlimited, no count required.
        /// </summary>
        /// <param name="retriesLimit"></param>
        /// <returns></returns>
        public static bool IsDelegationAccessRetriesLimited(int retriesLimit)
        {
            //TODO - should use the Unlimited constant
            return retriesLimit >= 0;
        }

        /// <summary>
        /// Convenience method to get the setting for the maximum number of access code retries (or the fallback default value if
        /// it isnt found in dwAppsettings).
        /// nb: this method will not work in the internet side under U@App
        /// </summary>
        /// <returns>maxmum number of retries allowed for a delegation access code</returns>
        public static async Task<int> GetDelegationAccessCodeRetriesSetting()
        {
            ILookup<string, string> settings = (await AppSettings
                        .SelectAsync(Filter.And.Equal(Constants.dwAppSettingName.DelegationAccessCodeRetries, Constants.FieldName.Name)))
                        .ToLookup(s => s.Name, s => s.Value);
            int retriesLimit = DelegationApplication.GetRetriesLimit(settings[Constants.dwAppSettingName.DelegationAccessCodeRetries].FirstOrDefault());
            return retriesLimit;
        }

        //TODO - refactor, r at least rename the below
        /// <summary>
        /// To get fallback default value.
        /// </summary>
        /// <param name="retriesLimit"></param>
        /// <returns></returns>
        public static int GetRetriesLimit(string retriesLimit)
        {
            int intRetriesLimit = DELEGATION_ACCESS_CODE_RETRIES;

            if (!string.IsNullOrEmpty(retriesLimit))
            {
                if (!int.TryParse(retriesLimit, out intRetriesLimit))
                {
                    intRetriesLimit = DELEGATION_ACCESS_CODE_RETRIES;
                }
            }

            return intRetriesLimit;
        }

        /// <summary>
        /// Compare the codes, syntactic sugar for comaping, so long as the expected is not empty/null.
        /// Uses invariant culture. Case-sensitive. 
        /// </summary>
        /// <param name="provided"></param>
        /// <param name="expected"></param>
        /// <returns></returns>
        public static bool CodeMatches(string provided, string expected)
        {
            return !string.IsNullOrEmpty(expected) && expected.Equals(provided, StringComparison.InvariantCulture);
        }

        /// <summary>
        /// Returns the history for the specified dlsi
        /// Note that this method does not verify delegation code. For internet side results caller should
        /// verfify the supplied code with CheckMasterDelegationCodeAndUpdateAttempts first.
        /// This method uses the ORM so will not work on the internet side in U@App environment
        /// </summary>
        /// <param name="qnnDplySampleInfoId"></param>
        /// <returns>history</returns>
        public static async Task<DelegationHistoryResult> GetDelegationHistory(Guid qnnDplySampleInfoId)
        {
            try
            {
                EntityModel vSPRespDelegationGridModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_RespDelegationGrid, Constants.Level.NoJoins);
                Filter filterByDlsi = Filter.And.Equal(qnnDplySampleInfoId, Constants.FieldName.DplyListSampleId);
                Order sortByStatusAndCreatedDate = Order.StartAsc(Constants.FieldName.Status).Desc(Constants.FieldName.CreatedDate);
                List<DynamicEntity> listRespDelegationGrid 
                    = await vSPRespDelegationGridModel.GetAsync(filterByDlsi, sortByStatusAndCreatedDate, Paging.Empty);
                if (listRespDelegationGrid.Count == 0)
                {
                    return DelegationHistoryResult.Fail(DelegationHistoryResult.Outcome.NoDelegationHistory);
                }

                List<Dictionary<string, object>> listGridResult = new List<Dictionary<string, object>>();
                foreach (DynamicEntity respDelegationGrid in listRespDelegationGrid)
                {
                    Dictionary<string, object> gridRow = new Dictionary<string, object>()
                    {
                        { "Id", (Guid)respDelegationGrid[Constants.FieldName.Id] },
                        { "CreatedDate", (DateTime)respDelegationGrid[Constants.FieldName.CreatedDate] },
                        { "FromName", (string)respDelegationGrid[Constants.FieldName.FromName] },
                        { "Name", (string)respDelegationGrid[Constants.FieldName.Name] },
                        { "ValidityStart", (DateTime?)respDelegationGrid[Constants.FieldName.ValidityStart] }, //TODO - nullable or not?
                        { "ValidityEnd", (DateTime?)respDelegationGrid[Constants.FieldName.ValidityEnd] }, //TODO - nullable or not?
                        { "Comments", (string)respDelegationGrid[Constants.FieldName.Comments] },
                        { "RevokedDate", (DateTime?)respDelegationGrid[Constants.FieldName.RevokedDate] },
                        { "Status", (string)respDelegationGrid[Constants.FieldName.Status] },
                    };
                    listGridResult.Add(gridRow);
                }
                return DelegationHistoryResult.Success(listGridResult);
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(GetDelegationHistory) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw;
            }
        } //end of GetDelegationHistory

        /// <summary>
        /// Verify the correctness of the supplied DelegationCode (the master delegation code in the dlsi) and update or clear
        /// the fail attempts counter in the dlsi accordingly.
        /// This method uses the ORM so will not work on internet side in u@app environment
        /// </summary>
        /// <param name="qnnDplySampleInfoId"></param>
        /// <param name="providedDelegationCode"></param>
        /// <returns>true if correct, false otherwise</returns>
        /// <exception cref="ArgumentException"></exception>
        public static async Task<bool> CheckMasterDelegationCodeAndUpdateAttempts(Guid qnnDplySampleInfoId, string providedDelegationCode)
        {
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException("May not be empty", nameof(qnnDplySampleInfoId));
            if (string.IsNullOrEmpty(providedDelegationCode)) throw new ArgumentException(nameof(providedDelegationCode));

            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
            DynamicEntity qnnDplySampleInfo = await DeploymentApplication.GetQnnDplySampleInfoById(qnnDplySampleInfoId, qnnDplySampleInfoModel);
            if (qnnDplySampleInfo == null) throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, qnnDplySampleInfoId);

            string providedEncryptedDelegationCode = EncryptionHelper.EncryptStr(providedDelegationCode, Constants.LoginKey, Constants.LoginIv);
            int retries = await GetDelegationAccessCodeRetriesSetting();
            string expectedEncryptedDelegationCode = (string)qnnDplySampleInfo[Constants.FieldName.DelegationCode];
            int attempts = (int)qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt];
            //TODO - below code needs to also respect the 'limited' feature now?
            if (!DelegationApplication.CodeMatches(providedEncryptedDelegationCode, expectedEncryptedDelegationCode))
            {
                //code is wrong so we need to increment the failed attempts counter in the db
                if (DelegationApplication.IsDelegationAccessRetriesLimited(retries))
                {
                    qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = attempts + 1;
                    await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                }
                return false;
            }
            else if (DelegationApplication.IsDelegationAccessRetriesLimited(retries) && attempts > 0)
            {
                //code is correct and we need to clear the failed attempts counter in the db
                qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = attempts + 1;
                await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                return true;
            }
            else
            {
                //code is correct, and no failed attempts to clear in the db
                return true;
            }
        }

        public static async Task<bool> ValidateAccessCodeAndUpdateAttempts(Guid qnnDplySampleInfoId, string inputCode)
        {
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException(nameof(qnnDplySampleInfoId));
            if (string.IsNullOrEmpty(inputCode)) throw new ArgumentException(nameof(inputCode));

            try
            {
                string encyptedInputCode = EncryptionHelper.EncryptStr(inputCode, Constants.LoginKey, Constants.LoginIv);

                //1. look for currently valid QNN_RESP_DELEGATION record for this dlsi matching supplied access code
                EntityModel vSPRespDelegationActiveModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_RespDelegationActive, Constants.Level.NoJoins);
                //The swagger based code was using RowNumber here. 
                //var filterByDlsi = new List<FilterItem>() {
                //    new FilterItem(new List<string> { Constants.FieldName.DplyListSampleId }, "=", qnnDplySampleInfoId.ToString()),
                //    new FilterItem(new List<string> { Constants.FieldName.RowNumber }, "=", "1"),
                Filter byDlsiAndRowNumber = Filter.And
                    .Equal(qnnDplySampleInfoId, Constants.FieldName.DplyListSampleId)
                    .Equal(1, Constants.FieldName.RowNumber);
                DynamicEntity respDelegationActive
                    = (await vSPRespDelegationActiveModel.GetAsync(byDlsiAndRowNumber)).FirstOrDefault();
                if (respDelegationActive != null)
                {
                    //validated = respDelegationActive.AccessCode.Equals(encyptedInputCode);
                    string activeAccessCode = (string)respDelegationActive[Constants.FieldName.AccessCode];
                    if (CodeMatches(encyptedInputCode, activeAccessCode))
                    {
                        return true;
                    }  
                }

                //2. If no explicit delegation then check against main access code (master delegation code)
                //in QNN_DPLY_SAMPLE_INFO, check agains delegationCode in table QNN_DPLY_SAMPLE_INFO
                EntityModel qnnDplySampleInfoModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
                DynamicEntity qnnDplySampleInfo
                    = await DeploymentApplication.GetQnnDplySampleInfoById(qnnDplySampleInfoId);

                string masterDelegationCode = (string)qnnDplySampleInfo[Constants.FieldName.DelegationCode];
                bool validated = CodeMatches(encyptedInputCode, masterDelegationCode);

                int retries = await GetDelegationAccessCodeRetriesSetting();
                if (IsDelegationAccessRetriesLimited(retries))
                {
                    int attempts = (int)qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt];
                    if (!validated)
                    {
                        //Incorrect code so need to fail and increment the counter of failed attempts
                        qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = attempts + 1;
                        await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                    }
                    else if (validated && attempts > 0)
                    {
                        //Code is valid but the counter has some earlier fails so we want to reset it to zero before returning 
                        qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = 0;
                        await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                    }
                }
                return validated;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ValidateAccessCodeAndUpdateAttempts) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw;
            }
        }

        public static async Task<bool> IsDelegatedAccessRetriesExceed(Guid qnnDplySampleInfoId)
        {
            if (Guid.Empty.Equals(qnnDplySampleInfoId)) throw new ArgumentException(nameof(qnnDplySampleInfoId));

            try
            {
                int retries = await GetDelegationAccessCodeRetriesSetting();
                if (DelegationApplication.IsDelegationAccessRetriesLimited(retries))
                {
                    DynamicEntity qnnDplySampleInfo 
                        = await DeploymentApplication.GetQnnDplySampleInfoById(qnnDplySampleInfoId);
                    if (qnnDplySampleInfo == null) 
                        throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, qnnDplySampleInfoId);
                    int attempts = (int)qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt];
                    bool exceed = DelegationApplication.IsDelegationAccessRetriesExceed(retries, attempts);
                    return exceed;
                }
                else
                {
                    return false; //Unlimited retries
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(IsDelegatedAccessRetriesExceed) + " - caught unexpected exception, qnnDplySampleInfoId={0}", qnnDplySampleInfoId);
                throw;
            }
        }

        /// <summary>
        /// Generate enough delegation codes to satisfy the number of samples in the sample list
        /// that have yet to be added to the sample info for this deployment.
        /// Primary intent of this method is to generate a bunch of encrypted codes for passing to spSP_AddDplySampleInfoByListId
        /// which can't easily generate them itself because of the need for encryption.
        /// </summary>
        /// <param name="dplyId">Id of the QNN_DPLY to which rows of QNN_DPLY_SAMPLE_INFO are going to be added</param>
        /// <returns>collection of encrypted delegation codes (may be empty but not null)</returns>
        public static async Task<List<string>> GenerateDelegationCodes(Guid dplyId)
        {
            int count = await spSP_GetAddDplySampleInfoCount.GetSampleCountAsync(dplyId);
            List<string> delegationCodes = new List<string>(count);
            for (int i = 0; i < count; i++)
            {
                AccessCode generatedDelegationCode = new AccessCode();
                delegationCodes.Add(
                    generatedDelegationCode.ToEncryptedString(
                        EncryptionHelper.Bytes(Constants.LoginKey),
                        EncryptionHelper.Bytes(Constants.LoginIv))
                    );
            }
            //nb: spSP_AddDplySampleInfoByListId would get passed these values as a single string delimited by '|'
            //    and because all these values are base64 encoded, a '|' will not occur in them to cause problems there
            return delegationCodes;
        }

        public static async Task<DelegateSurveyResult> DelegateSurvey(DelegateSurveyRequest request, string encryptedDelegationCode)
        {
            DelegateSurveyResult result;
            EntityModel vSpListSampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);
            EntityModel qnnRespDelegationModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP_DELEGATION, Constants.Level.NoJoins);

            Filter byDlsi = Filter.And.Equal(request.QnnDplySampleInfoId, Constants.FieldName.Id);
            DynamicEntity vSPListSampleInfo = (await vSpListSampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
            if (vSPListSampleInfo == null) throw new NullReferenceException(nameof(vSPListSampleInfo));

            if (!(bool)vSPListSampleInfo[Constants.FieldName.RequireAccessCode])
            {
                throw new InvalidOperationException("invalid dlsi - RequiresAccessCode is not set");
            }
            //if is ListSampleRecord not active, respondent should not be able to access the survey
            if (!(bool)vSPListSampleInfo[Constants.Views.FieldName.ListSampleRecordActiveYN])
            {
                throw new InvalidOperationException("invalid dlsi - Sample is not activated in Sample List");
            }

            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
            DynamicEntity qnnDplySampleInfo = (await qnnDplySampleInfoModel.GetAsync(byDlsi)).FirstOrDefault();
            string qnnDplySampleInfoDelegationCode = (string)qnnDplySampleInfo[Constants.FieldName.DelegationCode];
            int qnnDplySampleInfoDelegationFailAttempt = (int)qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt];

            int retriesLimit = await GetDelegationAccessCodeRetriesSetting();
            bool isRetriesLimited = DelegationApplication.IsDelegationAccessRetriesLimited(retriesLimit);
            bool isRetriesExceed = DelegationApplication.IsDelegationAccessRetriesExceed(retriesLimit, qnnDplySampleInfoDelegationFailAttempt);
            if (isRetriesLimited && isRetriesExceed)
            {
                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.DelegationAccessRetriesExceed);
                return result;
            }

            if (!DelegationApplication.CodeMatches(encryptedDelegationCode, qnnDplySampleInfoDelegationCode))
            {
                if (isRetriesLimited)
                {
                    qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = qnnDplySampleInfoDelegationFailAttempt + 1;
                    await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
                }
                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.InvalidDelegationCode);
                return result;
            }
            else if (isRetriesLimited && qnnDplySampleInfoDelegationFailAttempt > 0)
            {
                qnnDplySampleInfo[Constants.FieldName.DelegationAccessFailAttempt] = 0;
                await qnnDplySampleInfoModel.UpdateSingleAsync(qnnDplySampleInfo);
            }

            if (request.ValidityStart.CompareTo(request.ValidityEnd) > 0)
            {
                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.InvalidValidityPeriod);
                return result;
            }

            //Generate a new access code to send to person delegated to
            string rawAccessCode = (EncryptionHelper.GenerateChars(length: 6, EncryptionHelper.CharType.Numerals)
                + EncryptionHelper.GenerateChars(length: 2, EncryptionHelper.CharType.Lowercase)).Scramble();
            string encryptedAccessCode = EncryptionHelper.EncryptStr(rawAccessCode, Constants.LoginKey, Constants.LoginIv);

            using (var shared = new SharedTransaction())
            {
                try
                {
                    shared.BeginTransactionAsync().Wait();

                    //Record this delegation in the database
                    DynamicEntity qnnRespDelegation = await qnnRespDelegationModel.NewAsync();
                    qnnRespDelegation[Constants.FieldName.DplyListSampleId] = request.QnnDplySampleInfoId;
                    qnnRespDelegation[Constants.FieldName.ValidityStart] = request.ValidityStart;
                    qnnRespDelegation[Constants.FieldName.ValidityEnd] = request.ValidityEnd;
                    qnnRespDelegation[Constants.FieldName.Name] = request.Name;
                    qnnRespDelegation[Constants.FieldName.Email] = request.Email;
                    qnnRespDelegation[Constants.FieldName.Comments] = request.Comments;
                    qnnRespDelegation[Constants.FieldName.FromName] = request.DelegateFromName;
                    qnnRespDelegation[Constants.FieldName.AccessCode] = encryptedAccessCode;
                    qnnRespDelegation[Constants.FieldName.CreatedDate] = DateTime.Now;
                    await qnnRespDelegationModel.UpdateSingleAsync(qnnRespDelegation);

                    //Prepare the email
                    var tokens = new Dictionary<string, string>();
                    tokens[Constants.FieldName.QnnTitle] = (string)vSPListSampleInfo[Constants.FieldName.QnnTitle];
                    tokens[Constants.FieldName.Comments] = request.Comments;
                    tokens[Constants.FieldName.ValidityStart] = request.ValidityStart.ToString("d MMM yyyy HH:mm");
                    tokens[Constants.FieldName.ValidityEnd] = request.ValidityEnd.ToString("d MMM yyyy HH:mm");
                    tokens[Constants.FieldName.AccessCode] = rawAccessCode;
                    tokens[Constants.FieldName.Name] = request.Name;
                    tokens[Constants.FieldName.FromName] = request.DelegateFromName;

                    //Send email in the tx so we fail the tx if this throws an exception
                    //(this is because without the email the access code won't reach them
                    //so we don't want to keep the db record of the delegation either)
                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    string appName = await SettingsHelper.Common.GetApplicationName();
                    await Email.FormSendAsync(
                        mailSettings: mailSettings,
                        mailTo: new string[] { request.Email },
                        mailCc: null,
                        mailBcc: null,
                        formName: "RespDelegationEmailTemplate",
                        parameters: tokens);
                    await shared.CommitAsync();
                    result = DelegateSurveyResult.Success();
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(DelegateSurvey) + " - caught unexpected exception, request={0}", request);
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw;
                }

            } //end using tx

            return result;
        }

        public static async Task<DelegateSurveyResult> RespRevokeDelegationByDlsi(Guid qnnDplySampleInfoId, string encryptedDelegationCode)
        {
            DelegateSurveyResult result;
            QNN_DPLY_SAMPLE_INFO qnnDplySampleInfo = await QNN_DPLY_SAMPLE_INFO.SelectByKey(qnnDplySampleInfoId);

            int retriesLimit = await GetDelegationAccessCodeRetriesSetting();
            bool isRetriesLimited = DelegationApplication.IsDelegationAccessRetriesLimited(retriesLimit);
            bool isRetriesExceed = DelegationApplication.IsDelegationAccessRetriesExceed(retriesLimit, qnnDplySampleInfo.DelegationAccessFailAttempt);
            if (isRetriesLimited && isRetriesExceed)
            {
                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.DelegationAccessRetriesExceed);
                return result;
            }

            if (!DelegationApplication.CodeMatches(encryptedDelegationCode, qnnDplySampleInfo.DelegationCode))
            {
                //Update only if required.
                if (isRetriesLimited)
                {
                    qnnDplySampleInfo.DelegationAccessFailAttempt = qnnDplySampleInfo.DelegationAccessFailAttempt + 1;
                    await QNN_DPLY_SAMPLE_INFO.Model.UpdateAsync(new List<dynamic>() { qnnDplySampleInfo.AsDynamicEntity });
                }

                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.InvalidDelegationCode);
            }
            else
            {
                if (isRetriesLimited && qnnDplySampleInfo.DelegationAccessFailAttempt > 0)
                {
                    qnnDplySampleInfo.DelegationAccessFailAttempt = 0;
                    await QNN_DPLY_SAMPLE_INFO.Model.UpdateAsync(new List<dynamic>() { qnnDplySampleInfo.AsDynamicEntity });
                }
                //TODO: we must also check that this sample is correct for this dlsi, even though they DID have the right delegationCode somewhow

                List<string> activeStatus = new List<string>()
                {
                    Constants.Views.FieldName.Active,
                    Constants.Views.FieldName.Inactive,
                    Constants.Views.FieldName.Scheduled,
                };

                List<vSP_RespDelegationGrid> listRespDelegationGrid = await vSP_RespDelegationGrid.GetByDplyListSampleIdAndStatus(qnnDplySampleInfoId, activeStatus);
                if (listRespDelegationGrid != null && listRespDelegationGrid.Any())
                {
                    List<Guid> respDelegationId = listRespDelegationGrid.Select(x => x.Id).ToList();
                    var listRespDelegation = await QNN_RESP_DELEGATION.getByIds(respDelegationId);
                    listRespDelegation.ForEach(x => x.RevokedDate = DateTime.Now);
                    await QNN_RESP_DELEGATION.Model.UpdateAsync(listRespDelegation.Select(x => x.AsDynamicEntity).ToList());
                    result = DelegateSurveyResult.Success();
                }
                else
                {
                    result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.NoDelegationsFound);
                }
            }

            return result;
        }

        public static async Task<DelegateSurveyResult> RespRevokeDelegationById(Guid qnnDplySampleInfoId, Guid qnnRespDelegationId, string encryptedDelegationCode)
        {
            DelegateSurveyResult result;
            QNN_DPLY_SAMPLE_INFO qnnDplySampleInfo = await QNN_DPLY_SAMPLE_INFO.SelectByKey(qnnDplySampleInfoId);
            if (qnnDplySampleInfo == null)
            {
                logger.LogWarning(nameof(RespRevokeDelegationById) + " - couldn't find dlsi to revoke delegations - {0}", qnnDplySampleInfoId);
                throw new NullReferenceException(nameof(qnnDplySampleInfo));
            }

            int retriesLimit = await GetDelegationAccessCodeRetriesSetting();
            bool isRetriesLimited = DelegationApplication.IsDelegationAccessRetriesLimited(retriesLimit);
            bool isRetriesExceed = DelegationApplication.IsDelegationAccessRetriesExceed(retriesLimit, qnnDplySampleInfo.DelegationAccessFailAttempt);
            if (isRetriesLimited && isRetriesExceed)
            {
                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.DelegationAccessRetriesExceed);
                return result;
            }

            if (!DelegationApplication.CodeMatches(encryptedDelegationCode, qnnDplySampleInfo.DelegationCode))
            {
                //Update only if required.
                if (isRetriesLimited)
                {
                    qnnDplySampleInfo.DelegationAccessFailAttempt = qnnDplySampleInfo.DelegationAccessFailAttempt + 1;
                    await QNN_DPLY_SAMPLE_INFO.Model.UpdateAsync(new List<dynamic>() { qnnDplySampleInfo.AsDynamicEntity });
                    //await qnnDplySampleInfo.;
                }

                result = DelegateSurveyResult.Fail(DelegateSurveyResult.Outcome.InvalidDelegationCode);
            }
            else
            {
                if (isRetriesLimited && qnnDplySampleInfo.DelegationAccessFailAttempt > 0)
                {
                    qnnDplySampleInfo.DelegationAccessFailAttempt = 0;
                    await QNN_DPLY_SAMPLE_INFO.Model.UpdateAsync(new List<dynamic>() { qnnDplySampleInfo.AsDynamicEntity });
                }
                //TODO: we must also check that this sample is correct for this dlsi, even though they DID have the right delegationCode somewhow

                QNN_RESP_DELEGATION respDelegation = await QNN_RESP_DELEGATION.SelectByKey(qnnRespDelegationId);
                if (respDelegation == null)
                {
                    logger.LogWarning("Couldn't find dlsi to revoke delegations - {0}", qnnDplySampleInfoId);
                    throw new NullReferenceException(nameof(respDelegation));
                }

                respDelegation.RevokedDate = DateTime.Now;
                await QNN_RESP_DELEGATION.Model.UpdateSingleAsync((DynamicEntity)respDelegation.AsDynamicEntity);
                result = DelegateSurveyResult.Success();
            }

            return result;
        }

    }
}
