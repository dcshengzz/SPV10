using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using swz.Clover.Core.CodeActions;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;

namespace swz.Clover.Core
{
    public static class ServerActionExtensions
    {
        public  static async Task<(string Message, bool IsCancelled)> ExecuteTriggersAsync(this EntityModel model, TriggerCallType callType, List<dynamic> entities)
        {
            var triggersToCall = model.GetTriggers(callType);

            foreach (var call in triggersToCall)
            {
                if (CloverRuntime.ServerActions.ContainsTrigger(call.Name))
                {
                    var res = CloverRuntime.ServerActions.IsTriggerAsync(call.Name)
                        ? await CloverRuntime.ServerActions.ExecuteTriggerAsync(call.Name, model, entities, call.Options as DynamicEntity).ConfigureAwait(false)
                        : CloverRuntime.ServerActions.ExecuteTrigger(call.Name, model, entities, call.Options as DynamicEntity);

                    if (res.IsCancelled)
                        return res;

                }
            }
            
            return (null, false);
        }
    }
    public sealed class ServerActionsProvider : IServerActionsProvider  //TODO ? Create internal cache ?
    {
        private readonly ConcurrentDictionary<string, IServerActionsProvider> _providers = new ConcurrentDictionary<string, IServerActionsProvider>();
        
        private readonly ConcurrentDictionary<string, CodeActionsInvoker> _invokers = new ConcurrentDictionary<string, CodeActionsInvoker>();

        public void RegisterUsersProvider(string name, IServerActionsProvider provider)
        {
            _providers.AddOrUpdate(name, provider, (s, ap) => provider);
        }

        public void RemoveUsersProvider(string name)
        {
            _providers.TryRemove(name,out var _);
        }
        
        public void RegisterCodeActions(string name, List<CodeAction> actions, out Dictionary<string, string> compilationErrors)
        {
            var invoker = CodeActionsCompiler.GetCodeActionsInvoker(actions,out compilationErrors, true, name);
            _invokers.AddOrUpdate(name, invoker, (s, i) => invoker);
        }
        
        void RemoveCodeActions(string name)
        {
            _invokers.TryRemove(name,out var _);
        }


        public List<string> GetFilterNames()
        {
            var filterNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                filterNames.AddRange(serverActionsProvider.GetFilterNames());
            }
            foreach (var invoker in _invokers.Values)
            {
                filterNames.AddRange(invoker.GetFilterNames());
            }

            return filterNames.Distinct().ToList();
        }

        public List<string> GetFilterNamesFromProviders()
        {
            var filterNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                filterNames.AddRange(serverActionsProvider.GetFilterNames());
            }
            return filterNames.Distinct().ToList();
        }

        public bool IsFilterAsync(string name)
        {
            return true;
        }

        public bool ContainsFilter(string name)
        {
            return GetFilterNames().Contains(name);
        }

        public Filter GetFilter(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            return GetFilterAsync(name, model, entities, options).Result;
        }

        public async Task<Filter> GetFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            foreach (var serverActionsProvider in _providers.Values)
            {
                if (serverActionsProvider.ContainsFilter(name))
                {
                    if (serverActionsProvider.IsFilterAsync(name))
                        return await serverActionsProvider.GetFilterAsync(name, model, entities, options);
                    return serverActionsProvider.GetFilter(name, model, entities, options);
                }
            }
            foreach (var invoker in _invokers.Values)
            {
                if (invoker.ContainsFilter(name))
                {
                    if (invoker.IsFilterAsync(name))
                        return await invoker.InvokeFilterAsync(name, model, entities, options);
                    return invoker.InvokeFilter(name, model, entities, options);
                }
            }
            throw new NotImplementedException($"Filter {name} is not implemented");
        }
    

        public List<string> GetTriggerNames()
        {
            var triggerNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                triggerNames.AddRange(serverActionsProvider.GetTriggerNames());
            }
            foreach (var invoker in _invokers.Values)
            {
                triggerNames.AddRange(invoker.GetTriggerNames());
            }

            return triggerNames.Distinct().ToList();
        }

        public List<string> GetTriggerNamesFromProviders()
        {
            var triggerNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                triggerNames.AddRange(serverActionsProvider.GetTriggerNames());
            }
            return triggerNames.Distinct().ToList();
        }

        public bool IsTriggerAsync(string name)
        {
            return true;
        }

        public bool ContainsTrigger(string name)
        {
            return GetTriggerNames().Contains(name);
        }

        public (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            return ExecuteTriggerAsync(name, model, entities, options).Result;
        }

        public async Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            foreach (var serverActionsProvider in _providers.Values)
            {
                if (serverActionsProvider.ContainsTrigger(name))
                {
                    var res = serverActionsProvider.IsTriggerAsync(name)
                        ? await serverActionsProvider.ExecuteTriggerAsync(name, model, entities, options as DynamicEntity).ConfigureAwait(false)
                        : serverActionsProvider.ExecuteTrigger(name, model, entities, options as DynamicEntity);
                    return res;
                }
            }
            foreach (var invoker in _invokers.Values)
            {
                if (invoker.ContainsTrigger(name))
                {
                    if (invoker.IsTriggerAsync(name))
                        return await invoker.InvokeTriggerAsync(name, model, entities, options);
                    return invoker.InvokeTrigger(name, model, entities, options);
                }
            }
            throw new NotImplementedException($"Trigger {name} is not implemented");
        }

       



        public List<string> GetActionNames()
        {
            var actionNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                actionNames.AddRange(serverActionsProvider.GetActionNames());
            }
            foreach (var invoker in _invokers.Values)
            {
                actionNames.AddRange(invoker.GetActionNames());
            }

            return actionNames.Distinct().ToList();
        }
        
        public List<string> GetActionNamesFromProviders()
        {
            var actionNames = new List<string>();
            foreach (var serverActionsProvider in _providers.Values)
            {
                actionNames.AddRange(serverActionsProvider.GetActionNames());
            }
            return actionNames.Distinct().ToList();
        }

        public bool IsActionAsync(string name)
        {
            return true;
        }

        public bool ContainsAction(string name)
        {
            return GetActionNames().Contains(name);
        }

        public dynamic ExecuteAction(string name, dynamic request)
        {
            return ExecuteActionAsync(name, request).Result;
        }

        public async Task<dynamic> ExecuteActionAsync(string name, dynamic request)
        {
            foreach (var serverActionsProvider in _providers.Values)
            {
                if (serverActionsProvider.ContainsAction(name))
                {
                    if (serverActionsProvider.IsActionAsync(name))
                        return await serverActionsProvider.ExecuteActionAsync(name, request);
                    return serverActionsProvider.ExecuteAction(name, request);
                }
            }
            foreach (var invoker in _invokers.Values)
            {
                if (invoker.ContainsAction(name))
                {
                    if (invoker.IsActionAsync(name))
                        return await invoker.InvokeActionAsync(name, request);
                    return invoker.InvokeAction(name, request);
                }
            }
            throw new NotImplementedException($"Action {name} is not implemented");
        }
    }
}