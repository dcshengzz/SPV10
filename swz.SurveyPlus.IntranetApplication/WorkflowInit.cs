using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Workflow.Core.Runtime;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    public class WorkflowInit
    {
        private static readonly Lazy<WorkflowRuntime> LazyRuntime = new Lazy<WorkflowRuntime>(InitWorkflowRuntime);
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(WorkflowInit));

        public static WorkflowRuntime Runtime => LazyRuntime.Value;

        private static WorkflowRuntime InitWorkflowRuntime()
        {
            var runtime = CloverRuntime.CreateWorkflowRuntime()
                .WithActionProvider(new ActionProvider())
                .WithRuleProvider(new RuleProvider())
                .WithTimerManager(new TimerManager());
            
            //events subscription
            runtime.ProcessActivityChanged +=  (sender, args) => {  ActivityChanged(args, runtime).Wait(); };
            runtime.ProcessStatusChanged += (sender, args) => { };
            runtime.OnWorkflowError += (sender, args) =>
            {
                if (Debugger.IsAttached)
                {
                    var info = ExceptionUtils.GetExceptionInfo(args.Exception);
                    var errorBuilder = new StringBuilder();
                    errorBuilder.AppendLine("Workflow engine. An exception occurred while the process was running.");
                    errorBuilder.AppendLine($"ProcessId: {args.ProcessInstance.ProcessId}");
                    errorBuilder.AppendLine($"ExecutedTransition: {args.ExecutedTransition?.Name}");
                    errorBuilder.AppendLine($"Message: {info.Message}");
                    errorBuilder.AppendLine($"Exceptions: {info.Exeptions}");
                    errorBuilder.Append($"StackTrace: {info.StackTrace}");
                    Debug.WriteLine(errorBuilder);
                }
              
                //TODO Add exceptions logging here
            };
            
            //It is necessery to have this assembly for compile code with dynamic
            runtime.RegisterAssemblyForCodeActions(typeof(Microsoft.CSharp.RuntimeBinder.Binder).Assembly,true); 
           
            
            //TODO If you have planned to use Code Actions functionality that required references to external assemblies you have to register them here
            //runtime.RegisterAssemblyForCodeActions(Assembly.GetAssembly(typeof(SomeTypeFromMyAssembly)));
            //starts the WorkflowRuntime
            //TODO If you have planned use Timers the best way to start WorkflowRuntime is somwhere outside of this function in Global.asax for example
            runtime.Start();

            return runtime;
        }

        private static async Task ActivityChanged(ProcessActivityChangedEventArgs args, WorkflowRuntime runtime)
        {
            if (!args.TransitionalProcessWasCompleted)
                return;

            var historyModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_TRANSITIONHISTORY);
            var emptyHistory = (await historyModel.GetAsync(Filter.And.Equal(Null.Value, "UserId").Equal(args.ProcessId, "DplyId")
                .Equal(Null.Value, "TransitionTime"))).Select(h => h.GetId()).ToList();
            await historyModel.DeleteAsync(emptyHistory);

            await runtime.PreExecuteFromCurrentActivityAsync(args.ProcessId);

            var nextState = WorkflowInit.Runtime.GetLocalizedStateName(args.ProcessId, args.ProcessInstance.CurrentState);
            var dplyModel = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY);
            var dply = (await dplyModel.GetAsync(Filter.And.Equal(args.ProcessId, "Id"))).FirstOrDefault() as dynamic;

            if (dply == null)
                return;

            dply.StateName = nextState;
            dply.State = args.ProcessInstance.CurrentState;
            await dplyModel.UpdateSingleAsync(dply as DynamicEntity);

            var newActors = await Runtime.GetAllActorsForDirectCommandTransitionsAsync(args.ProcessId);
            var previousActors = await Runtime.GetAllActorsForDirectCommandTransitionsAsync(args.ProcessId, false, args.PreviousActivityName);
            List<Guid?> listStructDivisionId =
            (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal((Guid)dply.StructDivisionId,
                Constants.FieldName.Id))).Where(p => p.ParentId != null).Select(p => p.ParentId).Distinct().ToList();

            var newInboxes = new List<dynamic>();
            foreach (var newActor in newActors)
            {
                if (Guid.TryParse(newActor, out Guid userId))
                {
                    SecurityUser user = await SecurityUser.GetUserById(userId);
                    if (user == null || !listStructDivisionId.Contains(user.StructDivisionId))
                        continue;
                }

                var newInboxItem = new DynamicEntity() as dynamic;
                newInboxItem.Id = Guid.NewGuid();
                newInboxItem.IdentityId = newActor;
                newInboxItem.ProcessId = args.ProcessId;
                newInboxes.Add(newInboxItem);

                //send workflow email
                var parameters = new Dictionary<string, string>();
                parameters.Add("State", nextState);
                parameters.Add("SiteUrl", CloverRuntime.SiteUrl);
                parameters.Add("DplyName", dply.Name);
                parameters.Add("Remarks", dply.Remarks);

                try
                {
                    Func<Task> emailTask = async () =>
                    {
                        //Is first activity
                        if (Guid.TryParse(newActor, out Guid userId))
                        {
                            if (args.ProcessInstance.PreviousState == null)
                            {
                                await EmailHelper.SendUserEmailByFormTemplate(userId, parameters, Constants.EmailTemplate.DplyWorkflowEmailTemplateStartWorkflow);
                            }
                            else
                            {
                                await EmailHelper.SendUserEmailByFormTemplate(userId, parameters, Constants.EmailTemplate.DplyWorkflowEmailTemplate);
                            }
                        }                        
                    };
                    emailTask.FireAndForgetWithDefaultExceptionLogger();

                }
                catch (Exception e)
                {
                    Logger.LogError(e, nameof(ActivityChanged) + " - caught unexpected exception");
                }
            }

            var userIdsForNotification = new List<string>();

            userIdsForNotification.AddRange(newInboxes.Select(a => (string) (a as dynamic).IdentityId));

            using (var shared = new SharedTransaction())
            {
                await shared.BeginTransactionAsync();
                
                var inboxModel = await MetadataToModelConverter.GetEntityModelByModelAsync("WorkflowInbox");
                var existingInboxes = (await inboxModel.GetAsync(Filter.And.Equal(args.ProcessId, "ProcessId")));
                userIdsForNotification.AddRange(existingInboxes.Select(a => (string) (a as dynamic).IdentityId));
                var existingInboxesIds = existingInboxes.Select(i => i.GetId()).ToList();
                await inboxModel.DeleteAsync(existingInboxesIds);
                await inboxModel.InsertAsync(newInboxes);
                
                await shared.CommitAsync();
            }

            userIdsForNotification = userIdsForNotification.Distinct().ToList();
            Func<Task> task = async () => { await ClientNotifiers.NotifyClientsAboutInboxStatus(userIdsForNotification); };
            task.FireAndForgetWithDefaultExceptionLogger();

        }

        public static void ForceInit()
        {
            var r = Runtime;
        }
    }
}