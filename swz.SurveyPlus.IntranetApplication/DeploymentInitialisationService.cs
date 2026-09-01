using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public interface IDeploymentInitialisationService
    {
        /// <summary>
        /// Background job to complete the intialisation of the deployment by creating various child records (a time
        /// consuming process when the sample list is large). This includes provisioning rows in QNN_DPLY_SAMPLE_INFO
        /// and preparing the initial notification by creating the QNN_DPLY_MSG and QNN_DPLY_MSG_SAMPLE rows and creating
        /// the job to send the initial notification.
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task InitialiseDeployment(
            Guid userId,
            Guid dplyId,
            bool isMailMerge,
            bool isEmail,
            bool isProfile,
            string emailFrom,
            string body,
            string bodyJson,
            string subject);
    }

    public class DeploymentInitialisationService : IDeploymentInitialisationService
    {
        private readonly ILogger<DeploymentInitialisationService> logger;
        private readonly IProfileMailMergeService profileMailMergeService;

        public DeploymentInitialisationService(
            ILogger<DeploymentInitialisationService> logger,
            IProfileMailMergeService profileMailMergeService)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.profileMailMergeService = profileMailMergeService ?? throw new ArgumentNullException(nameof(profileMailMergeService));
        }

        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task InitialiseDeployment(
            Guid userId,
            Guid dplyId,
            bool isMailMerge,
            bool isEmail,
            bool isProfile,
            string emailFrom,
            string body,
            string bodyJson,
            string subject)
        {
            ProfileMailMergeOptions options = new ProfileMailMergeOptions(isMailMerge, isEmail, isProfile, emailFrom, body, bodyJson, subject, ProfileMailMergeOptions.DplyStep.Initial);

            //The work here was previously done directly in the CustomActionProvider actions
            //InsertDplyListSampleAsync and InsertDplyMessageAsync. They were replaced with InitDplyAsync
            //which will enqueue this hangfire job so that work gets done in the background instead.
            //(See issue #129)

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                logger.LogInformation(nameof(InitialiseDeployment) + " - starting job, userId={0}, dplyId={1}, isMailMerge={2}, isEmail={3}, isProfile={4}", userId, dplyId, isMailMerge, isEmail, isProfile);

                using (SharedTransaction shared = new SharedTransaction())
                {
                    DbHelper.AssertTransactionNotStartedYet(shared, $"{nameof(InitialiseDeployment)} expects control of the transaction");
                    
                    shared.BeginTransactionAsync().Wait();

                    try
                    {
                        User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                        if (user == null)
                            throw new NotFoundException($"user {userId} was not found");
                        if (!user.IsInRole(Constants.Role.SurveyAdmin))
                            throw new PermissionException($"Requires {Constants.Role.SurveyAdmin}");

                        QNN_DPLY dply = await QNN_DPLY.SelectByKey(dplyId);
                        if (dply == null)
                            throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                        AuditBatch auditBatch = await AuditSettings.NewBatchAsync(userId);
                        Guid auditStructDivisionId = user.StructDivisionId.Value;


                        // #1 Provision all the rows in QNN_DPLY_SAMPLE_INFO
                        List<string> delegationCodes = await DelegationApplication.GenerateDelegationCodes(dplyId);
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(InitialiseDeployment) + " - provisioning DLSI, dplyId={0}, listId={1}, dc count={2}, auditBatch={3}", dplyId, dply.ListId, delegationCodes.Count, auditBatch);
                        }
                        await spSP_AddDplySampleInfoByListId.ExecuteAsync(
                            dplyId,
                            dply.ListId,
                            delegationCodes,
                            auditBatch,
                            auditStructDivisionId);


                        // #2 Prepare the initial notification
                        //EntityModel qnnListSampleModel =
                        //        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.NoJoins);
                        //List<DynamicEntity> qnnListSamples
                        //    = await qnnListSampleModel.GetAsync(Filter.And.Equal(dply.ListId, Constants.FieldName.ListId));
                        //List<Guid> listSampleIds = qnnListSamples.Select(qnnListSample => (Guid)qnnListSample.GetId()).ToList();
                        EntityModel qnnDplySampleInfoModel
                            = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
                        ImmutableList<Guid> listSampleIds
                            = (await qnnDplySampleInfoModel.GetAsync(Filter.And.Equal(dplyId, Constants.FieldName.DplyId)))
                            .Select(qnnDplySampleInfo => (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId])
                            .ToImmutableList();
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(InitialiseDeployment) + " - preparing ProfileMailMerge job, dplyId={0}, listId={1}, ls count={2}, auditBatch={3}", dplyId, dply.ListId, listSampleIds.Count, auditBatch);
                        }

                        //Create message rows and schedule another job that will do the mail
                        try
                        {
                            await profileMailMergeService.CreateJob(
                                auditBatch: auditBatch,
                                auditStructDivisionId: auditStructDivisionId,
                                sendTo: IProfileMailMergeService.TargetType.Samples,
                                targetIds: listSampleIds,
                                dplyId: dplyId,
                                scheduledDate: null,
                                options);
                        }
                        catch(Exception e)
                        {
                            throw new InternalException($"Failed to create initial notification job", e);
                        }

                        shared.Commit();

                        long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                        logger.LogInformation(nameof(InitialiseDeployment) + " - completed job, userId={0}, dplyId={1}, duration={2} (approx {3} minutes)", userId, dplyId, duration, ConversionUtils.ToMinutesRoundedUp(duration));
                        await SendNotification(NotificationResult.Success, userId, dplyId, duration, listSampleIds.Count, null);
                    }
                    catch (Exception)
                    {
                        await shared.RollbackAsync();
                        throw;
                    }
                } //end using shared
            }
            catch (Exception e)
            {
                long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                logger.LogError(e, nameof(InitialiseDeployment) + " - caught unexpected exception, userId={0}, dplyId={1}, duration={2}", userId, dplyId, duration);
                await SendNotification(NotificationResult.Failure, userId, dplyId, duration, 0,  e);
            }
        }

        private enum NotificationResult { Success, Failure }

        private async Task SendNotification(
            NotificationResult result, 
            Guid userId, 
            Guid dplyId,
            long duration, 
            int sampleCount,
            Exception error)
        {
            try
            {
                //n.b. Although it adds a little extra db overhead I've chosen to lookup the user and deployment again
                //     in here as it makes all the plumbing for the error handling and notifications a little simpler to
                //     write. (Finding the user and deployment are also potential sources of an error)
                User user = await CloverRuntime.Security.GetUserByIdAsync(userId);
                if (user == null)
                    throw new NotFoundException($"user {userId} was not found");

                QNN_DPLY dply = await QNN_DPLY.SelectByKey(dplyId);
                if (dply == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, dplyId);

                bool sendReportToUser = !string.IsNullOrEmpty(user?.Email);
                if (sendReportToUser)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(SendNotification) + " - Sending {0} result email to {1} user={2} ({3})", result, user.Email, user?.Id, user?.Name);
                    }

                    int durationMinutes = ConversionUtils.ToMinutesRoundedUp(duration);
                    string dplyName = dply?.Name??"[Unknown Deployment]";

                    string subject, body;
                    switch (result)
                    {
                        case NotificationResult.Success:
                            subject = $"Completed initialising deployment {dplyName}";
                            body = $"Initialisation of deployment \"{WebUtility.HtmlEncode(dplyName)}\" completed in approximately {durationMinutes} minutes for {sampleCount} samples.";
                            break;
                        case NotificationResult.Failure:
                            subject = $"FAILED to initialise deployment {dplyName}";
                            body = $"An error was encountered while initialising \"{WebUtility.HtmlEncode(dplyName)}\". The deployment may have inconsistent records and need to be re-created. (Job duration was approximately {durationMinutes} minutes). {TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.ClientReportableMessage(error?.Message, "Refer to technical logs for error details.")}";
                            break;
                        default: throw new NotImplementedException(result.ToString());
                    }

                    MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                    await Email.SendAsync(
                        mailSettings: mailSettings,
                        mailTo: user.Email,
                        subject: subject,
                        body: body);
                }
                else
                {
                    logger.LogWarning(nameof(SendNotification) + " - no email to send {0} notification to user={2} ({3})", result, user?.Id, user?.Name);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SendNotification) + " - caught unexpected exception sending {result} notification", result);
            }
        }

    }
}