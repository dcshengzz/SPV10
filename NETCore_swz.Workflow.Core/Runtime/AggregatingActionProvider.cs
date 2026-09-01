using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using swz.Workflow.Core.Model;

namespace swz.Workflow.Core.Runtime
{
    public class AggregatingActionProvider : IWorkflowActionProvider
    {
        private object _lock = new object();

        private int _cnt = 0;
        
        private SortedDictionary<int, IWorkflowActionProvider> _providers = new SortedDictionary<int, IWorkflowActionProvider>();
        
        public void ExecuteAction(string name, ProcessInstance processInstance, WorkflowRuntime runtime, string actionParameter)
        {
            if (IsActionAsync(name))
                throw new NotImplementedException($"Sync action with name {name} is not implemented");
            
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetActions().Contains(name) && !provider.IsActionAsync(name))
                {
                    provider.ExecuteAction(name, processInstance, runtime, actionParameter);
                    return;
                }
            }
            
            throw new NotImplementedException($"Sync action with name {name} is not implemented");
        }

        public async Task ExecuteActionAsync(string name, ProcessInstance processInstance, WorkflowRuntime runtime, string actionParameter, CancellationToken token)
        {
            if (!IsActionAsync(name))
                throw new NotImplementedException($"Async action with name {name} is not implemented");
            
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetActions().Contains(name) && provider.IsActionAsync(name))
                {
                    await provider.ExecuteActionAsync(name, processInstance, runtime, actionParameter, token).ConfigureAwait(false);
                    return;
                }
            }
            
            throw new NotImplementedException($"Async action with name {name} is not implemented");
        }

        public bool ExecuteCondition(string name, ProcessInstance processInstance, WorkflowRuntime runtime, string actionParameter)
        {
            if (IsConditionAsync(name))
                throw new NotImplementedException($"Sync condition with name {name} is not implemented");
            
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetConditions().Contains(name) && !provider.IsConditionAsync(name))
                    return provider.ExecuteCondition(name, processInstance, runtime, actionParameter);
            }
            
            throw new NotImplementedException($"Sync condition with name {name} is not implemented");
        }

        public async Task<bool> ExecuteConditionAsync(string name, ProcessInstance processInstance, WorkflowRuntime runtime, string actionParameter, CancellationToken token)
        {
            if (!IsConditionAsync(name))
                throw new NotImplementedException($"Async condition with name {name} is not implemented");
            
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetConditions().Contains(name) && provider.IsConditionAsync(name))
                    return await provider.ExecuteConditionAsync(name, processInstance, runtime, actionParameter, token).ConfigureAwait(false);
            }
            
            throw new NotImplementedException($"Async condition with name {name} is not implemented");
        }

        public bool IsActionAsync(string name)
        {
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetActions().Contains(name))
                    return provider.IsActionAsync(name);
            }
            
            throw new NotImplementedException($"Action with name {name} is not implemented");
        }

        public bool IsConditionAsync(string name)
        {
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetConditions().Contains(name))
                    return provider.IsConditionAsync(name);
            }
            
            throw new NotImplementedException($"Condition with name {name} is not implemented");
        }

        public List<string> GetActions()
        {
            var actionNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                actionNames.AddRange(serverActionsProvider.GetActions());
            }
            return actionNames.Distinct().ToList();
        }

        public List<string> GetConditions()
        {
            var conditionNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                conditionNames.AddRange(serverActionsProvider.GetConditions());
            }
            return conditionNames.Distinct().ToList();
        }
        
        public void RegisterProvider(IWorkflowActionProvider provider)
        {
            int newIdx;
            lock (_lock)
            {
                _cnt++;
                newIdx = _cnt;
            }
            
            _providers.Add(newIdx,provider);
        }

        public void Clear()
        {
            lock (_lock)
            {
                _cnt = 0;
                _providers.Clear();
            }
        }
    }
}