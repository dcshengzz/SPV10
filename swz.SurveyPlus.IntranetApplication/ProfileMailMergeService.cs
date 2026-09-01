using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Hangfire;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Object to hold the usual options for a profile/mail/merge job.
    /// Instances of this object are immutable.
    /// </summary>
    public class ProfileMailMergeOptions
    {
        public enum DplyStep
        {
            /// <summary>
            /// Indicates the initial notification for a deployment (recorded as "I")
            /// (i.e. notification generated at the time of the Deployment creation from QNN_DPLY)
            /// </summary>
            Initial,

            /// <summary>
            /// Indicates subsequent notifications for a deployment (recorded as "R")
            /// "Resend" is somethng of a legacy term as such notifications will in practice mostly constitute new messages
            /// and reminders to recipients
            /// </summary>
            Resend,
        }

        public static string DplyStepValue(DplyStep dplyStep)
        {
            switch (dplyStep)
            {
                case DplyStep.Initial: return "I";
                case DplyStep.Resend: return "R"; //something of a 'legacy' name as the message may be different 
                default: throw new NotSupportedException(nameof(DplyStep) + "-" + dplyStep);
            }
        }

        public static DplyStep DplyStepValue(string dplyStep)
        {
            switch(dplyStep)
            {
                case "I": return DplyStep.Initial;
                case "R": return DplyStep.Resend;
                default: throw new NotSupportedException(nameof(DplyStepValue) + "-" + dplyStep);
            }
        }

        public static ProfileMailMergeOptions FromQnnDplyMsg(DynamicEntity qnnDplyMsg)
        {
            if (qnnDplyMsg == null) throw new ArgumentNullException(nameof(qnnDplyMsg));
            return new ProfileMailMergeOptions(
                isMailMerge: (bool)qnnDplyMsg[Constants.FieldName.NotifyMerge],
                isEmail: (bool)qnnDplyMsg[Constants.FieldName.NotifyEmail],
                isProfile: (bool)qnnDplyMsg[Constants.FieldName.NotifyGenerate],
                emailFrom: (string)qnnDplyMsg[Constants.FieldName.EmailFrom],
                body: (string)qnnDplyMsg[Constants.FieldName.MsgContent],
                bodyJson: (string)qnnDplyMsg[Constants.FieldName.MsgContentJson],
                subject: (string)qnnDplyMsg[Constants.FieldName.EmailSubj],
                step: DplyStepValue((string)qnnDplyMsg[Constants.FieldName.DplyStep]) );
        }

        public bool IsMailMerge { get; }
        public bool IsEmail { get; }
        public bool IsProfile { get; }
        public string EmailFrom { get; }
        public string Body { get; }
        public string BodyJson { get; }
        public string Subject { get; }
        public DplyStep Step { get; }

        public bool IsAnyOptionSpecified { get =>  IsMailMerge || IsEmail || IsProfile; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="isMailMerge">If true then will generate a PDF mail merge</param>
        /// <param name="isEmail">If true then will do an email blast to respondents</param>
        /// <param name="isProfile">True if job should generate a CSV profile file for the relevent samples</param>
        /// <param name="emailFrom">(Optional) When doing an email blast this specifies the sender address. This now supports display name format too</param>      
        /// <param name="body">Email body text</param>
        /// <param name="bodyJson">Email body in rich text JSON format (stored to allow editing)</param>
        /// <param name="subject">Email subject line</param>
        /// <param name="dplyStep">Deployment stage (initial notification vs resend/follow-up messaging)</param>
        //TODO - json attribute and a warning about changing it when there are jobs
        public ProfileMailMergeOptions(
            bool isMailMerge,
            bool isEmail,
            bool isProfile,
            string emailFrom,
            //DateTime? scheduledDate,
            string body,
            string bodyJson,
            string subject,
            DplyStep step)
        {
            this.IsMailMerge = isMailMerge;
            this.IsEmail = isEmail;
            this.IsProfile = isProfile;
            this.EmailFrom = emailFrom;
            this.Body = body; //MsgContent
            this.BodyJson = bodyJson; //MsgContentJson
            this.Subject = subject;
            this.Step = step;
        }

        /// <summary>
        /// Initialise related columns in an entity representing QNN_DPLY_MSG
        /// </summary>
        public void CopyToQnnDplyMsg(DynamicEntity qnnDplyMsg)
        {
            if (qnnDplyMsg == null) throw new ArgumentNullException(nameof(qnnDplyMsg));
            qnnDplyMsg[Constants.FieldName.NotifyMerge] = IsMailMerge;
            qnnDplyMsg[Constants.FieldName.NotifyEmail] = IsEmail;
            qnnDplyMsg[Constants.FieldName.NotifyGenerate] = IsProfile;
            qnnDplyMsg[Constants.FieldName.DplyStep] = DplyStepValue(Step); //e.g. "I" for initial, "R" for resend
            qnnDplyMsg[Constants.FieldName.MsgContent] = IsEmail || IsMailMerge ? Body : null;
            qnnDplyMsg[Constants.FieldName.MsgContentJson] = IsEmail || IsMailMerge ? BodyJson : null;
            qnnDplyMsg[Constants.FieldName.EmailSubj] = IsEmail ? Subject : null;
            //nb: emailFrom can be null now to specify default sender
            qnnDplyMsg[Constants.FieldName.EmailFrom] = IsEmail ? (string.IsNullOrWhiteSpace(EmailFrom) ? null : EmailFrom.Trim()) : null;
        }

        public override string ToString()
        {
            return base.ToString();  //TODO
        }
    }

    public interface IProfileMailMergeService
    {
        /// <summary>
        /// Used with CreateProfileMailMergeJob and  UpdatePrfileMailMerge to specify the taregt for the mail blast
        /// (i.e. is it to specific samples or to respondents with a specific status)
        /// </summary>
        public enum TargetType
        {
            /// <summary>
            /// Will send to a list of specifically identified Samples (respondents)
            /// </summary>
            Samples,

            /// <summary>
            /// Will send to samples (respondents) whose response is in a specified status
            /// </summary>
            Status
        }

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public Task<bool> ProcessQnnDplyMsg(Guid userId, Guid dplyMsgId);

        public Task CreateJob(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            TargetType sendTo,
            IEnumerable<Guid> targetIds,
            Guid dplyId,
            DateTime? scheduledDate,
            ProfileMailMergeOptions options);

        public Task UpdateJob(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            IProfileMailMergeService.TargetType sendTo,
            Guid dplyMsgId,
            IEnumerable<Guid> newTargetStatusIds,
            DateTime newScheduledDate,
            string newBody,
            string newBodyJson,
            string newSubject,
            string newEmailFrom);
    }

    public class ProfileMailMergeService : IProfileMailMergeService
    {
        private readonly ILogger<ProfileMailMergeService> logger;

        public ProfileMailMergeService(
            ILogger<ProfileMailMergeService> logger,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        private readonly SurveyPlusOptions surveyPlusOptions;

        ///*** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public async Task<bool> ProcessQnnDplyMsg(Guid userId, Guid dplyMsgId)
        {
            try
            {
                DynamicEntity dplyMsg = await GetQnnDplyMsgById(dplyMsgId);
                if (dplyMsg == null)
                    throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY_MSG, dplyMsgId);
                Guid dplyId = (Guid)dplyMsg[Constants.FieldName.DplyId];
                ProfileMailMergeOptions options = ProfileMailMergeOptions.FromQnnDplyMsg(dplyMsg);

                if (options.IsAnyOptionSpecified)
                {
                    List<Guid> targetStatusIds = await GetMsgStatusIds(dplyMsgId);
                    List<Guid> targetListSampleIds = await GetMsgListSampleIds(dplyMsgId);
                    bool targetingByStatus = targetStatusIds.Any();

                    if (targetingByStatus && targetListSampleIds.Any())
                    {
                        throw new InvalidOperationException($"Targeting {targetStatusIds.Count} status but also found {targetListSampleIds.Count} sample ids for msg {dplyMsgId}");
                    }

                    ProfileMailMerger profileMailMerger
                        = await ProfileMailMerger.NewInstanceAsync(userId, dplyId, options.Body);
                    profileMailMerger.GenerateMailMerge = options.IsMailMerge;
                    profileMailMerger.GenerateProfile = options.IsProfile;

                    if (options.IsMailMerge)
                    {
                        profileMailMerger.MailMergeFolderPath = surveyPlusOptions.MailMergeFolderPath;
                        profileMailMerger.MailMergeArchivedFolderCommand = surveyPlusOptions.MailMergeArchivedFolderCommand;
                        profileMailMerger.MailMergeArchivedFolderCommandArguments = surveyPlusOptions.MailMergeArchivedFolderCommandArguments;
                        profileMailMerger.MailMergeArchivedFolderExtension = surveyPlusOptions.MailMergeArchivedFolderExtension;
                    }

                    //Apply mail merge defaults from dwAppSettings (don't waste the query if just doing profile)
                    if (options.IsMailMerge || options.IsEmail)
                    {
                        (await MailMergeSettings.GetFromAppSettingsAsync())
                            .ApplyTo(profileMailMerger);
                    }

                    if (options.IsEmail)
                    {
                        profileMailMerger.GenerateEmail = true;
                        profileMailMerger.EmailFrom = options.EmailFrom;
                        profileMailMerger.EmailSubject = options.Subject;
                    }

                    profileMailMerger.ApplyOptionsFromTemplate();

                    return targetingByStatus
                        ? profileMailMerger.ExecuteByStatus(dplyMsgId, targetStatusIds)
                        : profileMailMerger.ExecuteBySamples(dplyMsgId, targetListSampleIds);
                }
                else
                {
                    logger.LogWarning(nameof(ProcessQnnDplyMsg) + " - empty job, no options selected: {0}", options);
                    return true;
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ProcessQnnDplyMsg) + " - caught unexpected exception, dplyMsgId={0}", dplyMsgId);
                return false;
            }
        }

        /// <summary>
        /// Creates a new QNN_DPLY_MSG and associated records and schedules a hangfire job to do profile/mailmerge/email generation.
        /// Related hangfire job is: SendEmailsAndMailMergeAndGenerateProfile
        /// nb: does not check role, caller is responsible for this.
        /// Caller is expected to handle/log exceptions.
        /// </summary>
        /// <param name="auditBatch">Audit batch containing Id of the user requesting the job</param>
        /// <param name="auditStructDivisionId">struct division to use for audit</param>
        /// <param name="sendTo">Specifies whether sending to samples or to status</param>
        /// <param name="targetIds">Id of either QNN_LIST_SAMPLE (if sending to samples) or QNN_STATUS (if sending to status)</param>
        /// <param name="dplyId">Id in QNN_DPLY, identifying the deployment with which this ProfileMailMerge job is associated</param>
        /// <param name="scheduledDate">When to execute the job. If null then the job will be enqueued for immediate execution</param>
        public async Task CreateJob(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            IProfileMailMergeService.TargetType sendTo,
            IEnumerable<Guid> targetIds,
            Guid dplyId,
            DateTime? scheduledDate,
            ProfileMailMergeOptions options)
        {
            if (auditBatch == null)
                throw new ArgumentNullException(nameof(auditBatch));
            if (!auditBatch.HasUser)
                throw new ArgumentException("must have user", nameof(auditBatch));
            if (targetIds == null)
                throw new ArgumentNullException(nameof(targetIds));
            if (!targetIds.Any())
                throw new ArgumentException("no targets specified", nameof(targetIds));
            if (options == null)
                throw new ArgumentNullException(nameof(options));
            try
            {
                bool isScheduledForFutureExecution = (scheduledDate != null);
                
                using (SharedTransaction shared = new SharedTransaction())
                {
                    // nb: caller (such as InitialiseDeployment) may have already started a transaction
                    //     in which case we would be using that here
                    shared.BeginTransactionAsync().Wait();

                    //QNN_DPLY_MSG
                    EntityModel qnnDplyMsgModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG, Constants.Level.NoJoins);
                    DynamicEntity qnnDplyMsg = await InsertQnnDplyMsg(
                        qnnDplyMsgModel,
                        auditBatch,
                        auditStructDivisionId,
                        dplyId,
                        scheduledDate,
                        options);
                    Guid dplyMsgId = (Guid)qnnDplyMsg[Constants.FieldName.Id];

                    //Create children of the dplyMsg to record the targeted status or samples
                    //The job will be using these to find its targets
                    switch (sendTo)
                    {   
                        case IProfileMailMergeService.TargetType.Status:
                            if (!isScheduledForFutureExecution && !await IsAnySamplesInStatus(dplyId, targetIds))
                                throw new NotFoundException($"{Constants.Message.Prefix.ClientReportable}No responses have the specified status");
                            await InsertQnnDplyMsgForStatus(auditBatch, auditStructDivisionId, dplyMsgId, targetIds);
                            break;

                        case IProfileMailMergeService.TargetType.Samples: 
                            await InsertQnnDplyMsgSample(auditBatch, auditStructDivisionId, dplyMsgId, targetIds);
                            break;

                        default:
                            throw new NotSupportedException(sendTo.ToString());
                    }

                    //then schedule the job to be run at the appropriate time
                    string jobId = (scheduledDate != null)
                        ? BackgroundJob.Schedule<IProfileMailMergeService>(
                            service => service.ProcessQnnDplyMsg(auditBatch.UserId, dplyMsgId),
                            new DateTimeOffset(scheduledDate.Value))
                        : BackgroundJob.Enqueue<IProfileMailMergeService>(
                            service => service.ProcessQnnDplyMsg(auditBatch.UserId, dplyMsgId));

                    qnnDplyMsg[Constants.FieldName.JobId] = jobId;
                    await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);

                    shared.Commit();
                }
            }
            catch (Exception e)
            {
                //Caller is expected to handle it now (e.g. by logging and reporting an error)
                logger.LogDebug(e, nameof(CreateJob) + " - caught unexpected exception, dplyId={0}", dplyId);
                throw;
            }
        }

        /// <summary>
        /// Update an already scheduled QNN_DPLY_MSG
        /// Caller is responsible for handling/logging exceptions thrown
        /// </summary>
        public async Task UpdateJob(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            IProfileMailMergeService.TargetType sendTo,
            Guid dplyMsgId,
            IEnumerable<Guid> newTargetStatusIds,
            DateTime newScheduledDate,
            string newBody,
            string newBodyJson,
            string newSubject,
            string newEmailFrom)
        {
            if (auditBatch == null)
                throw new ArgumentNullException(nameof(auditBatch));
            if (!auditBatch.HasUser)
                throw new ArgumentException("must have user", nameof(auditBatch));            
            if(sendTo== IProfileMailMergeService.TargetType.Status)
            {
                if (newTargetStatusIds == null)
                    throw new ArgumentNullException(nameof(newTargetStatusIds));
                if (!newTargetStatusIds.Any())
                    throw new ArgumentException("no target status specified", nameof(newTargetStatusIds));
            }
            else
            {
                if (newTargetStatusIds != null)
                    throw new ArgumentException($"target status not supported for sendTo {sendTo.ToString()}, must pass as null", nameof(newTargetStatusIds));
            }
            
            try
            {
                using (SharedTransaction shared = new SharedTransaction())
                {
                    shared.BeginTransactionAsync().Wait();

                    //QNN_DPLY_MSG
                    EntityModel qnnDplyMsgModel =
                        await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG, Constants.Level.NoJoins);
                    DynamicEntity qnnDplyMsg = await GetQnnDplyMsgById(dplyMsgId, qnnDplyMsgModel);
                    if(qnnDplyMsg==null)
                        throw NotFoundException.ForModelName(qnnDplyMsgModel.Name, dplyMsgId);

                    if(sendTo== IProfileMailMergeService.TargetType.Status)
                    {
                        //Replace the status with the new ones
                        //TODO - we don't bother to chek if they actually changed, ideally we should
                        //       but for status the number of rows is tiny so this optimisation has been left
                        //       for another time
                        await DeleteQnnDplyMsgForStatus(dplyMsgId);
                        await InsertQnnDplyMsgForStatus(auditBatch, auditStructDivisionId, dplyMsgId, newTargetStatusIds);
                    }

                    //n.b. currently we don't support editing selected samples if sending to samples
                    
                    //Update the message details 
                    qnnDplyMsg[Constants.FieldName.MsgContent] = newBody;
                    qnnDplyMsg[Constants.FieldName.MsgContentJson] = newBodyJson;
                    qnnDplyMsg[Constants.FieldName.EmailSubj] = newSubject;
                    qnnDplyMsg[Constants.FieldName.EmailFrom] = string.IsNullOrWhiteSpace(newEmailFrom)
                        ? null //nb: emailFrom can be null now to specify default sender
                        : newEmailFrom.Trim();
                    qnnDplyMsg[Constants.FieldName.ScheduledDate] = newScheduledDate;
                    qnnDplyMsg[Constants.FieldName.UpdatedDate] = DateTime.Now;
                    qnnDplyMsg[Constants.FieldName.UpdatedBy] = auditBatch.UserId;

                    string oldJobId = (string)qnnDplyMsg[Constants.FieldName.JobId];
                    qnnDplyMsg[Constants.FieldName.JobId] = null;

                    //Cancel the old job
                    if(!string.IsNullOrEmpty(oldJobId))
                        BackgroundJob.Delete(oldJobId);

                    //Save now in case the scheduled date is effectively immediate (unlikely but possible)
                    //ensuring details up to date before it runs
                    await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);

                    //Now schedule the new job
                    string jobId =  BackgroundJob.Schedule<IProfileMailMergeService>(
                        service => service.ProcessQnnDplyMsg(auditBatch.UserId, dplyMsgId),
                        new DateTimeOffset(newScheduledDate));

                    //And save again to record the new JobId
                    qnnDplyMsg[Constants.FieldName.JobId] = jobId;
                    await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);

                    shared.Commit();
                }
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(UpdateJob) + " - caught unexpected exception, dplyMsgId={0}", dplyMsgId);
                throw;
            }
        }

        public async Task<DynamicEntity> GetQnnDplyMsgById(Guid id, EntityModel qnnDplyMsgModel=null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_DPLY_MSG, qnnDplyMsgModel);
        }

        /// <summary>
        /// Get all the ForStatus from the QNN_DPLY_MSG_FORSTATUS for the specified QNN_DPLY_MSG.
        /// </summary>
        public async Task<List<Guid>> GetMsgStatusIds(Guid dplyMsgId, EntityModel qnnDplyMsgForStatusModel=null)
        {
            if(qnnDplyMsgForStatusModel==null)
                qnnDplyMsgForStatusModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG_FORSTATUS, Constants.Level.NoJoins);
            if (!qnnDplyMsgForStatusModel.Name.Equals(Constants.ModelName.QNN_DPLY_MSG_FORSTATUS))
                throw new ArgumentException($"Incorrect model {qnnDplyMsgForStatusModel.Name}", nameof(qnnDplyMsgForStatusModel));

            Filter byDplyMsgId = Filter.And.Equal(dplyMsgId, Constants.FieldName.DplyMsgId);
            return (await qnnDplyMsgForStatusModel.GetAsync(byDplyMsgId))
                .Select(dm => (Guid)dm[Constants.FieldName.ForStatus])
                .ToList();
        }

        /// <summary>
        /// Get all the ListSampleId from the QNN_DPLY_MSG_SAMPLE for the specified QNN_DPLY_MSG.
        /// </summary>
        public async Task<List<Guid>> GetMsgListSampleIds(Guid dplyMsgId)
        {
            //TODO - the list here can be large, might be better to use a stored procedure to bypass ORM overhead
            Filter byDplyMsgId = Filter.And.Equal(dplyMsgId, Constants.FieldName.DplyMsgId);
            EntityModel qnnDplyMsgForStatusModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG_SAMPLE, Constants.Level.NoJoins);
            return (await qnnDplyMsgForStatusModel.GetAsync(byDplyMsgId))
                .Select(dm => (Guid)dm[Constants.FieldName.ListSampleId])
                .ToList();
        }

        private DataTable DataTableForQnnDplyMsgSample()
        {
            DataTable table = new DataTable();
            table.TableName = "dbo." + Constants.ModelName.QNN_DPLY_MSG_SAMPLE;
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.DplyMsgId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ListSampleId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.CreatedDate, typeof(DateTime));
            table.Columns.Add(Constants.FieldName.EmailSentDate, typeof(DateTime));
            table.Columns.Add(Constants.FieldName.ToEmails, typeof(string));
            table.Columns.Add(Constants.FieldName.CcEmails, typeof(string));
            return table;
        }

        private async Task InsertQnnDplyMsgSample(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            Guid dplyMsgId,
            IEnumerable<Guid> targetListSampleIds)
        {
            DataTable qnnDplyMsgSampleToInsert = DataTableForQnnDplyMsgSample();
            DateTime createdDate = DateTime.Now;
            foreach (Guid listSampleId in targetListSampleIds)
            {
                qnnDplyMsgSampleToInsert.Rows.Add(
                    Guid.NewGuid(),     //Id
                    dplyMsgId,          //DplyMsgId
                    listSampleId,       //ListSampleId
                    createdDate,        //CreatedDate
                    DBNull.Value,       //EmailSentDate,
                    DBNull.Value,       //ToEmails,
                    DBNull.Value);      //CcEmails
            }
            using (SharedTransaction shared = new SharedTransaction())
            {
                DbHelper.BulkCopyDataTable(qnnDplyMsgSampleToInsert, shared, timeoutSeconds: 600);
                string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(qnnDplyMsgSampleToInsert);
                await SurveyPlusAuditHelper.BatchImport(
                    Constants.ModelName.QNN_DPLY_MSG_SAMPLE,
                    auditBatch,
                    auditStructDivisionId,
                    newValue);
            }                
        }

        private DataTable DataTableForQnnDplyMsgForStatus()
        {
            DataTable table = new DataTable();
            table.TableName = "dbo." + Constants.ModelName.QNN_DPLY_MSG_FORSTATUS;
            table.Columns.Add(Constants.FieldName.Id, typeof(Guid));
            table.Columns.Add(Constants.FieldName.DplyMsgId, typeof(Guid));
            table.Columns.Add(Constants.FieldName.ForStatus, typeof(Guid));
            return table;
        }

        private async Task InsertQnnDplyMsgForStatus(
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            Guid dplyMsgId,
            IEnumerable<Guid> targetStatusIds)
        {
            DataTable qnnDplyMsgForStatusToInsert = DataTableForQnnDplyMsgForStatus();
            foreach (Guid statusId in targetStatusIds)
            {
                qnnDplyMsgForStatusToInsert.Rows.Add(
                    Guid.NewGuid(),     //Id
                    dplyMsgId,          //DplyMsgId
                    statusId);          //ForStatus
            }
            using(SharedTransaction shared = new SharedTransaction())
            {
                DbHelper.BulkCopyDataTable(qnnDplyMsgForStatusToInsert, shared, timeoutSeconds: 30);
                string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(qnnDplyMsgForStatusToInsert);
                await SurveyPlusAuditHelper.BatchImport(
                    Constants.ModelName.QNN_DPLY_MSG_FORSTATUS,
                    auditBatch,
                    auditStructDivisionId,
                    newValue);
            }
        }

        public async Task DeleteQnnDplyMsgForStatus(Guid dplyMsgId, EntityModel qnnDplyMsgForStatusModel=null)
        {
            //TODO - this could be improved by using a stored procedure instead of the ORM
            //       so that the change gets a single audit row and is included in the auditbatch

            if (qnnDplyMsgForStatusModel == null)
                qnnDplyMsgForStatusModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG_FORSTATUS, Constants.Level.NoJoins);
            if (!qnnDplyMsgForStatusModel.Name.Equals(Constants.ModelName.QNN_DPLY_MSG_FORSTATUS))
                throw new ArgumentException($"Incorrect model {qnnDplyMsgForStatusModel.Name}", nameof(qnnDplyMsgForStatusModel));

            Filter byDplyMsgId = Filter.And.Equal(dplyMsgId, Constants.FieldName.DplyMsgId);
            IEnumerable<object> idsToDelete = (await qnnDplyMsgForStatusModel.GetAsync(byDplyMsgId))
                .Select(dplyMsgForStatus => (Guid)dplyMsgForStatus[Constants.FieldName.Id])
                .Cast<object>();
            await qnnDplyMsgForStatusModel.DeleteAsync(idsToDelete);
        }

        private async Task<bool> IsAnySamplesInStatus(Guid dplyId, IEnumerable<Guid> statusIds)
        {
            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

            List<Guid> listOfStatusIds = statusIds is List<Guid>
                ? (List<Guid>)statusIds
                : statusIds.ToList();
            Filter byStatusAndDplyId
                = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .In(statusIds.ToList(), Constants.FieldName.Status);
            
            return (await qnnDplySampleInfoModel.GetCountAsync(byStatusAndDplyId)) > 0;
        }

        private async Task<DynamicEntity> InsertQnnDplyMsg(
            EntityModel qnnDplyMsgModel,
            AuditBatch auditBatch,
            Guid auditStructDivisionId,
            Guid dplyId,
            DateTime? scheduledDate,
            ProfileMailMergeOptions options)
        {
            DynamicEntity qnnDplyMsg = await qnnDplyMsgModel.NewAsync();
            qnnDplyMsg[Constants.FieldName.Id] = Guid.NewGuid();
            qnnDplyMsg[Constants.FieldName.DplyId] = dplyId;
            qnnDplyMsg[Constants.FieldName.ScheduledDate] = scheduledDate;
            qnnDplyMsg[Constants.FieldName.CreatedDate] = DateTime.Now;
            qnnDplyMsg[Constants.FieldName.CreatedBy] = auditBatch.UserId;
            qnnDplyMsg[Constants.FieldName.JobId] = null;
            options.CopyToQnnDplyMsg(qnnDplyMsg);
            await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);
            return qnnDplyMsg;
        }
    }
}
