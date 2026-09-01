using System;
using System.Collections.Generic;
using System.Linq;
using swz.Workflow.Core.Model;

namespace swz.Workflow.Core.Runtime
{
    public class AggregatingRuleProvider : IWorkflowRuleProvider
    {
        private object _lock = new object();

        private int _cnt = 0;
        
        private SortedDictionary<int, IWorkflowRuleProvider> _providers = new SortedDictionary<int, IWorkflowRuleProvider>();
        
        public List<string> GetRules()
        {
            var ruleNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                ruleNames.AddRange(serverActionsProvider.GetRules());
            }
            return ruleNames.Distinct().ToList();
        }

        public bool Check(ProcessInstance processInstance, WorkflowRuntime runtime, string identityId, string ruleName, string parameter)
        {
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetRules().Contains(ruleName))
                    return provider.Check(processInstance, runtime, identityId, ruleName, parameter);
            }
            
            throw new NotImplementedException($"Rule with name {ruleName} is not implemented");
        }

        public IEnumerable<string> GetIdentities(ProcessInstance processInstance, WorkflowRuntime runtime, string ruleName, string parameter)
        {
            foreach (var provider in _providers.Values.Reverse())
            {
                if (provider.GetRules().Contains(ruleName))
                    return provider.GetIdentities(processInstance, runtime, ruleName, parameter);
            }
            
            throw new NotImplementedException($"Rule with name {ruleName} is not implemented");
        }

        public void RegisterProvider(IWorkflowRuleProvider provider)
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