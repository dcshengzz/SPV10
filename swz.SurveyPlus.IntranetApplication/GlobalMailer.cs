using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Utilities;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class GlobalMailer
    {
        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(GlobalMailer));

        /// <summary>
        /// Global mailer, send to all active distinct sample with active deployment with selected status.
        /// Insert to DB and then schedule the check of this job to scheduledDate.
        /// 1. Insert to DB QNN_GLOBAL_MSG
        /// 2. Insert the selected status to DB QNN_GLOBAL_MSG_SAMPLE
        /// 3. Schedule the job to SendGlobalEmailsToStatus
        /// </summary>
        /// <param name="scheduledDate">schedule date of the job</param>
        /// <param name="emailFrom">email address from (now optional)</param>
        /// <param name="subject">email subject</param>
        /// <param name="body">email body</param>
        /// <param name="qnnStatusIdsArray">status id to send</param>
        /// <param name="selectedStructId">selected struct division Id</param>
        /// <returns>true for successful add to schedule</returns>
        public static async Task<bool> CreateGlobalMsgAndGlobalMsgStatus(
            DateTime? scheduledDate, 
            string emailFrom, 
            string subject, 
            string body, 
            string bodyJson, 
            string[] qnnStatusIdsArray, 
            Guid selectedStructId, 
            bool isTargetUsers)
        {
            using (var shared = new SharedTransaction())
            {
                try
                {
                    var listStructDivisionId = await vStructDivisionParentsAndThis.GetByParentStructId((Guid)selectedStructId);

                    Guid userId = CloverRuntime.Security.CurrentUser.Id;
                    Guid qnnGlobalMsgId = Guid.NewGuid();

                    shared.BeginTransactionAsync().Wait();

                    //global_msg
                    EntityModel qnnGlobalMsgModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG, 0);
                    List<dynamic> qnnGlobalMsgDynamic = new List<dynamic>();
                    DynamicEntity qnnGlobalMsg = await qnnGlobalMsgModel.NewAsync();
                    qnnGlobalMsg[Constants.FieldName.Id] = qnnGlobalMsgId;
                    qnnGlobalMsg[Constants.FieldName.MsgContent] = body;
                    qnnGlobalMsg[Constants.FieldName.MsgContentJson] = bodyJson;
                    qnnGlobalMsg[Constants.FieldName.EmailSubj] = subject;
                    qnnGlobalMsg[Constants.FieldName.EmailFrom] = emailFrom ?? "";
                    qnnGlobalMsg[Constants.FieldName.ScheduledDate] = scheduledDate;
                    qnnGlobalMsg[Constants.FieldName.CreatedDate] = DateTime.Now;
                    qnnGlobalMsg[Constants.FieldName.CreatedBy] = userId;
                    qnnGlobalMsg[Constants.FieldName.StructDivisionId] = selectedStructId;
                    qnnGlobalMsg[Constants.FieldName.JobId] = null;
                    qnnGlobalMsg[Constants.FieldName.IsTargetUsers] = isTargetUsers;
                    qnnGlobalMsgDynamic.Add(qnnGlobalMsg as dynamic);
                    var (i, _) = await qnnGlobalMsgModel.UpdateAsync(qnnGlobalMsgDynamic);

                    //dply_msg_forstatus
                    var qnnGlobalMsgStatusModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG_FORSTATUS, 0);
                    var qnnGlobalMsgStatusDynamic = new List<dynamic>();
                    List<Guid> listStatusIds = new List<Guid>();
                    if (i > 0)
                    {
                        if (qnnStatusIdsArray != null && qnnStatusIdsArray.Any())
                        {
                            foreach (var qnnStatusId in qnnStatusIdsArray)
                            {
                                if (!Guid.TryParse(qnnStatusId, out Guid _)) return false;
                                var qnnGlobalMsgStatus = await qnnGlobalMsgStatusModel.NewAsync();
                                qnnGlobalMsgStatus[Constants.FieldName.Id] = Guid.NewGuid();
                                qnnGlobalMsgStatus[Constants.FieldName.GlobalMsgId] = qnnGlobalMsgId;
                                qnnGlobalMsgStatus[Constants.FieldName.ForStatus] = qnnStatusId;
                                qnnGlobalMsgStatusDynamic.Add(qnnGlobalMsgStatus);

                                listStatusIds.Add(Guid.Parse(qnnStatusId));
                            }
                            // will not have too many status. so update on one shot
                            await qnnGlobalMsgStatusModel.UpdateAsync(qnnGlobalMsgStatusDynamic);
                        }
                    }

                    string jobId = null;

                    if (scheduledDate != null)
                    {
                        if (isTargetUsers == true)
                        {
                            jobId = BackgroundJob.Schedule(() =>
                            BusinessProcess.SendGlobalEmailsToUsers(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body), new DateTimeOffset((scheduledDate.Value)));
                        }
                        else
                        {
                            jobId = BackgroundJob.Schedule(() =>
                            BusinessProcess.SendGlobalEmailsToStatus(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body, listStatusIds), new DateTimeOffset((scheduledDate.Value)));
                        }
                    }
                    else
                    {
                        if (isTargetUsers == true)
                        {
                            jobId = BackgroundJob.Enqueue(() =>
                            BusinessProcess.SendGlobalEmailsToUsers(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body));
                        }
                        else
                        {
                            jobId = BackgroundJob.Enqueue(() =>
                            BusinessProcess.SendGlobalEmailsToStatus(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body, listStatusIds));
                        }
                    }

                    var entity = (await qnnGlobalMsgModel.GetAsync(Filter.And.Equal(qnnGlobalMsgId, Constants.FieldName.Id))).FirstOrDefault();
                    if (entity != null)
                    {
                        entity[Constants.FieldName.JobId] = jobId;
                        await qnnGlobalMsgModel.UpdateSingleAsync(entity);
                    }

                    shared.Commit();
                    return true;
                }
                catch (Exception e)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    _logger.LogError(e, nameof(CreateGlobalMsgAndGlobalMsgStatus) + " - caught unexpected exception");
                    return false;
                }
            }
        }

        public static async Task<bool> EditGlobalMsgAndGlobalMsgStatus(
            Guid qnnGlobalMsgId, 
            DateTime? scheduledDate, 
            string emailFrom, //may be null/empty now to indicate default
            string subject, 
            string body, 
            string bodyJson, 
            string[] qnnStatusIdsArray, //TODO this should be Guid[]
            Guid selectedStructId, 
            bool isTargetUsers)
        {
            using (var shared = new SharedTransaction())
            {
                try
                {
                    var listStructDivisionId = await vStructDivisionParentsAndThis.GetByParentStructId((Guid)selectedStructId);

                    Guid userId = CloverRuntime.Security.CurrentUser.Id;

                    shared.BeginTransactionAsync().Wait();

                    //global_msg
                    EntityModel qnnGlobalMsgModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG, 0);

                    List<dynamic> qnnGlobalMsgDynamic = new List<dynamic>();
                    DynamicEntity qnnGlobalMsg = (await qnnGlobalMsgModel.GetAsync(Filter.And.Equal(qnnGlobalMsgId, Constants.FieldName.Id))).FirstOrDefault() as dynamic;
                    qnnGlobalMsg[Constants.FieldName.MsgContent] = body;
                    qnnGlobalMsg[Constants.FieldName.MsgContentJson] = bodyJson;
                    qnnGlobalMsg[Constants.FieldName.EmailSubj] = subject;
                    qnnGlobalMsg[Constants.FieldName.EmailFrom] = emailFrom ?? "";
                    qnnGlobalMsg[Constants.FieldName.ScheduledDate] = scheduledDate;
                    qnnGlobalMsg[Constants.FieldName.CreatedDate] = DateTime.Now;
                    qnnGlobalMsg[Constants.FieldName.CreatedBy] = userId;
                    qnnGlobalMsg[Constants.FieldName.StructDivisionId] = selectedStructId;
                    qnnGlobalMsg[Constants.FieldName.IsTargetUsers] = isTargetUsers;
                    qnnGlobalMsgDynamic.Add(qnnGlobalMsg as dynamic);
                    var (_, updated) = await qnnGlobalMsgModel.UpdateAsync(qnnGlobalMsgDynamic);

                    
                    var qnnGlobalMsgStatusModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG_FORSTATUS, 0);

                    //remove previous dply_msg_forstatus
                    var qnnDplyMsgForStatusIds = (await qnnGlobalMsgStatusModel.GetAsync(Filter.And.Equal(qnnGlobalMsgId, Constants.FieldName.GlobalMsgId)))
                        .Select(m => m.GetId());
                    await qnnGlobalMsgStatusModel.DeleteAsync(qnnDplyMsgForStatusIds);

                    //add dply_msg_forstatus
                    var qnnGlobalMsgStatusDynamic = new List<dynamic>();
                    List<Guid> listStatusIds = new List<Guid>();
                    if (updated > 0)
                    {
                        if (qnnStatusIdsArray != null && qnnStatusIdsArray.Any())
                        {
                            foreach (var qnnStatusId in qnnStatusIdsArray)
                            {
                                if (!Guid.TryParse(qnnStatusId, out Guid _)) return false;
                                var qnnGlobalMsgStatus = await qnnGlobalMsgStatusModel.NewAsync();
                                qnnGlobalMsgStatus[Constants.FieldName.Id] = Guid.NewGuid();
                                qnnGlobalMsgStatus[Constants.FieldName.GlobalMsgId] = qnnGlobalMsgId;
                                qnnGlobalMsgStatus[Constants.FieldName.ForStatus] = qnnStatusId;
                                qnnGlobalMsgStatusDynamic.Add(qnnGlobalMsgStatus);

                                listStatusIds.Add(Guid.Parse(qnnStatusId));
                            }
                            // will not have too many status. so update on one shot
                            await qnnGlobalMsgStatusModel.UpdateAsync(qnnGlobalMsgStatusDynamic);
                        }
                    }

                    //delete job
                    BackgroundJob.Delete(qnnGlobalMsg[Constants.FieldName.JobId]?.ToString());
                    string jobId = null;
                    if (scheduledDate != null)
                    {
                        if (isTargetUsers == true)
                        {
                            jobId = BackgroundJob.Schedule(() =>
                            BusinessProcess.SendGlobalEmailsToUsers(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body), new DateTimeOffset((scheduledDate.Value)));
                        }
                        else
                        {
                            jobId = BackgroundJob.Schedule(() =>
                            BusinessProcess.SendGlobalEmailsToStatus(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body, listStatusIds), new DateTimeOffset((scheduledDate.Value)));
                        }
                    }
                    else
                    {
                        if (isTargetUsers == true)
                        {
                            jobId = BackgroundJob.Enqueue(() =>
                            BusinessProcess.SendGlobalEmailsToUsers(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body));
                        }
                        else
                        {
                            jobId = BackgroundJob.Enqueue(() =>
                            BusinessProcess.SendGlobalEmailsToStatus(listStructDivisionId, qnnGlobalMsgId, emailFrom, subject, body, listStatusIds));
                        }
                    }

                    var entity = (await qnnGlobalMsgModel.GetAsync(Filter.And.Equal(qnnGlobalMsgId, Constants.FieldName.Id))).FirstOrDefault();
                    if (entity != null)
                    {
                        entity[Constants.FieldName.JobId] = jobId;
                        await qnnGlobalMsgModel.UpdateSingleAsync(entity);
                    }

                    shared.Commit();
                    return true;
                }
                catch (Exception e)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    _logger.LogError(e, nameof(EditGlobalMsgAndGlobalMsgStatus) + " - caught unexpected exception, qnnGlobalMsgId={0}", qnnGlobalMsgId);
                    return false;
                }
            }
        }

        /// <summary>
        /// (nb: would normally be called via the hangfire entrypoint in BusinessProcess as a background task)
        /// Check for distinct SampleId with active deployment and selected status.
        /// Send email sample and update EmailSent
        /// 1. Get active deployment with status and get active distinct sample using vSP_ListSampleInfo
        /// 2. Insert to DB QNN_GLOBAL_MSG_SAMPLE
        /// 3. Get the email of active sample, send the email and update QNN_GLOBAL_MSG_SAMPLE
        /// Note : May need to add StuctDivision for child deployment
        /// </summary>
        /// <param name="structDivisionIds">list of structDivisionId to include</param>
        /// <param name="globalMsgId">globalMsgId to insert to QNN_GLOBAL_MSG_SAMPLE DB</param>
        /// <param name="emailFrom">email from</param>
        /// <param name="subject">email subject</param>
        /// <param name="body">email body</param>
        /// <param name="listStatusIds">selected status to include</param>
        /// <returns></returns>
        public static async Task<bool> SendToStatusAsync(
            List<Guid> structDivisionIds, 
            Guid globalMsgId, 
            string emailFrom, 
            string subject, 
            string body, 
            List<Guid> listStatusIds)
        {
            bool isDebugLogEnabled = _logger.IsEnabled(LogLevel.Debug);

            if (isDebugLogEnabled)
            {
                _logger.LogDebug(nameof(SendToStatusAsync) + " - starting job for globalMsgId={0}, structDivisionIds={1}, statusIds={2}",
                    globalMsgId, structDivisionIds, listStatusIds);
            }

            try
            {
                EntityModel vSPListSampleInfoModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.NoJoins);
                //EntityModel qnnSampleModel
                //        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE, Constants.Level.NoJoins);
                EntityModel qnnSampleAddressModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.FetchJoins);

                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();

                DateTime now = DateTime.Now;

                //Get Active Deployment and their SampleId
                
                Filter byStuctAndActiveWithStatus = Filter.And
                    .LessOrEqual(now, Constants.FieldName.DplyDateStart)
                    .Greater(now, Constants.FieldName.DueDate)
                    .In(listStatusIds, Constants.FieldName.Status)
                    .In(structDivisionIds, Constants.FieldName.StructDivisionId)
                    .Equal(true, Constants.Views.FieldName.ListSampleRecordActiveYN);

                List<Guid> sampleIds 
                    = (await vSPListSampleInfoModel.GetAsync(byStuctAndActiveWithStatus))
                    .Select(e => (Guid)e[Constants.FieldName.SampleId])
                    .Distinct()
                    .ToList();
                if(isDebugLogEnabled)
                {
                    _logger.LogDebug(nameof(SendToStatusAsync) + " - found {0} samples for globalMsgId={1}",
                        sampleIds.Count, globalMsgId);
                }
                int sendCount = 0;
                if (sampleIds.Any())
                {
                    //After getting the sampleId Insert to QNN_GLOBAL_MSG_SAMPLE
                    //We do this first to record the intent, so if it fails part we through we can see which ones were actually
                    //sent (when sending we will update the EmailSentDate)
                    EntityModel qnnGlobalMsgSampleModel 
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG_SAMPLE, Constants.Level.NoJoins);
                    List<DynamicEntity> qnnGlobalMsgSamples = new List<DynamicEntity>();
                    List<DynamicEntity> qnnGlobalMsgSamplesToEmail = new List<DynamicEntity>();
                    foreach (Guid sampleId in sampleIds)
                    {
                        Guid gmsId = Guid.NewGuid();
                        if(_logger.IsEnabled(LogLevel.Trace))
                        {
                            _logger.LogTrace(nameof(SendToStatusAsync) + " - preparing QNN_GLOBAL_MSG_SAMPLE {0} for sampleId={1} under globalMsgId={2}",
                                gmsId, sampleId, globalMsgId);
                        }
                        //TODO - currently doing a query per sample, would be better if we could fetch all (or a batch) of address at one go
                        //       to reduce the number of trips to the db

                        //Get a distinct set of toEmails and ccEmails for this sample in all the requested StructDivision
                        Filter bySampleIdAndStructDivisions = Filter.And
                            .Equal(sampleId, Constants.FieldName.SampleId)
                            .In(structDivisionIds, Constants.FieldName.StructDivisionId);
                        List<DynamicEntity> qnnSampleAddresses
                            = await qnnSampleAddressModel.GetAsync(bySampleIdAndStructDivisions);
                        string toEmails = String.Join(',',Email.SplitAddressesExtractDistinct(
                                qnnSampleAddresses.Select(a => (string)a[Constants.FieldName.ToEmails]).ToList()));
                        bool hasPrimaryEmail = toEmails.Any();
                        string ccEmails
                            = !hasPrimaryEmail
                            ? "" //We don't sent to the ccEmails if there is no primary email
                            : String.Join(',', Email.SplitAddressesExtractDistinct(
                                qnnSampleAddresses.Select(a => (string)a[Constants.FieldName.CcEmails]).ToList()));

                        DynamicEntity qnnGlobalMsgSample = await qnnGlobalMsgSampleModel.NewAsync();
                        qnnGlobalMsgSample[Constants.FieldName.Id] = gmsId;
                        qnnGlobalMsgSample[Constants.FieldName.GlobalMsgId] = globalMsgId;
                        qnnGlobalMsgSample[Constants.FieldName.CreatedDate] = DateTime.Now;
                        qnnGlobalMsgSample[Constants.FieldName.SampleId] = sampleId;
                        qnnGlobalMsgSample[Constants.FieldName.ToEmails] = toEmails; //will be empty (not null) if none
                        qnnGlobalMsgSample[Constants.FieldName.CcEmails] = ccEmails; //will be empty (not null) if none or no primary email

                        qnnGlobalMsgSamples.Add(qnnGlobalMsgSample);
                        if (hasPrimaryEmail)
                            qnnGlobalMsgSamplesToEmail.Add(qnnGlobalMsgSample);
                    }

                    //Insert To DB in 500 each
                    const int takeSampleQty = 500; //number to process in one go
                    if (qnnGlobalMsgSamples.Count > int.MaxValue - takeSampleQty) throw new Exception("");
                    for (int i = 0; i < qnnGlobalMsgSamples.Count; i = i + takeSampleQty)
                    {
                        List<dynamic> entities = qnnGlobalMsgSamples.Skip(i).Take(takeSampleQty).Cast<dynamic>().ToList();
                        await qnnGlobalMsgSampleModel.UpdateAsync(entities);
                    }
                    qnnGlobalMsgSamples = null;

                    //Now re-iterate the list of those we want to email one at at time, sendthe email, and record the date sent
                    using (Email.IMailer mailer = await Email.CreateMailer(
                        mailSettings: mailSettings,
                        senderDisplayName: appName,
                        emailFrom: emailFrom))
                    {
                        foreach (DynamicEntity qnnGlobalMsgSample in qnnGlobalMsgSamplesToEmail)
                        {
                            string toEmails = (string)qnnGlobalMsgSample[Constants.FieldName.ToEmails];
                            bool hasPrimaryEmail = !string.IsNullOrWhiteSpace(toEmails);

                            if (hasPrimaryEmail)
                            {
                                Guid sampleId = (Guid)qnnGlobalMsgSample[Constants.FieldName.SampleId];
                                string ccEmails = (string)qnnGlobalMsgSample[Constants.FieldName.CcEmails];

                                if (_logger.IsEnabled(LogLevel.Trace))
                                {
                                    _logger.LogTrace(nameof(SendToStatusAsync) + " - sending email for globalMsgId={0}, sampleId={1}, sendCount={2}",
                                        globalMsgId, sampleId, sendCount);
                                }

                                await mailer.SendAsync(
                                    mailTo: Email.SplitAddresses(toEmails),
                                    mailCc: Email.SplitAddresses(ccEmails),
                                    mailBcc: null,
                                    subject: subject,
                                    body: body);

                                qnnGlobalMsgSample[Constants.FieldName.EmailSentDate] = DateTime.Now;
                                await qnnGlobalMsgSampleModel.UpdateSingleAsync(qnnGlobalMsgSample);
                                sendCount++;
                            }
                        } //end foreach sampleId
                    } //end using mailer
                } //end if any samples

                if(isDebugLogEnabled)
                {
                    _logger.LogDebug(nameof(SendToStatusAsync) + " - completed job for globalMsgId={0}, sample count={1}, sendCount={2}",
                        globalMsgId, sampleIds.Count, sendCount) ;
                }

                return true;
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(SendToStatusAsync) + " - caught unexpected exception, globalMsgId={0}", globalMsgId);
                return false;
            }
        }

        /// <summary>
        /// (nb: would normally be called via the hangfire entrypoint in BusinessProcess as a background task)
        /// Send email to intranet users, search all user by struct id
        /// </summary>
        /// <param name="structDivisionIds">struct id to send</param>
        /// <param name="globalMsgId">Global Msg Id</param>
        /// <param name="emailFrom">email from</param>
        /// <param name="subject">email subject</param>
        /// <param name="body">email body</param>
        /// <returns></returns>
        public static async Task<bool> SendToUsersAsync(
            List<Guid> structDivisionIds, 
            Guid globalMsgId, 
            string emailFrom, 
            string subject, 
            string body)
        {
            try
            {
                EntityModel qnnGlobalMsgUserModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_GLOBAL_MSG_USER, Constants.Level.NoJoins);

                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();

                DateTime now = DateTime.Now;

                List<SecurityUser> users = await SecurityUser.GetByStructId(structDivisionIds);

                //Insert to QNN_GLOBAL_MSG_USER
                List<DynamicEntity> listEntity = new List<DynamicEntity>();
                foreach (SecurityUser user in users)
                {
                    DynamicEntity entity = new DynamicEntity();
                    entity[Constants.FieldName.Id] = Guid.NewGuid();
                    entity[Constants.FieldName.GlobalMsgId] = globalMsgId;
                    entity[Constants.FieldName.CreatedDate] = DateTime.Now;
                    entity[Constants.FieldName.UserId] = user.Id;
                    listEntity.Add(entity as dynamic);
                }

                (long updated, long inserted) = await DbHelper.BulkDataUpdate(listEntity, qnnGlobalMsgUserModel);

                if (_logger.IsEnabled(LogLevel.Debug))
                    _logger.LogDebug(nameof(SendToUsersAsync) + " - updated {0}, inserted {1} to {2}", updated, inserted, qnnGlobalMsgUserModel.Name);

                using (Email.IMailer mailer = await Email.CreateMailer(
                    mailSettings: mailSettings,
                    senderDisplayName: appName,
                    emailFrom: emailFrom))
                {
                    foreach (SecurityUser user in users)
                    {
                        await mailer.SendAsync(
                            mailTo: new string[] { user.Email },
                            mailCc: null,
                            mailBcc: null,
                            subject: subject,
                            body: body);

                        var qnnGlobalMsgUser = await QNN_GLOBAL_MSG_USER.GetByGlobalMsgIdAndUserId(globalMsgId, user.Id);
                        if (qnnGlobalMsgUser != null)
                        {
                            qnnGlobalMsgUser.EmailSentDate = DateTime.Now;
                            await QNN_GLOBAL_MSG_USER.Model.UpdateSingleAsync((DynamicEntity)qnnGlobalMsgUser.AsDynamicEntity);

                        }
                    } //end foreach user
                } //end using mailer                    
                return true;
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(SendToUsersAsync) + " - caught unexpected exception, globalMsgId={0}", globalMsgId);
                return false;
            }
        }
    }
}
