using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.CodeActions
{
    /// <summary>
    /// Provides invoke of code actions by name
    /// </summary>
    public sealed class CodeActionsInvoker
    {
        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>> _filters =
            new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>> _asyncFilters =
            new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>>();
        
        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>> _triggers =
            new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>>();
        
        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>> _asyncTriggers =
            new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>();

        private readonly Dictionary<string, Func<dynamic, dynamic>> _actions =
            new Dictionary<string, Func<dynamic, dynamic>>();
        
        private readonly Dictionary<string, Func<dynamic, Task<dynamic>>> _asyncActions =
            new Dictionary<string, Func<dynamic,  Task<dynamic>>>();

    
        public void AddCompiledType(Type compiledType)
        {
            var methodInfos = compiledType.GetMethods(BindingFlags.Static | BindingFlags.Public);

            foreach (var method in methodInfos)
            {
                var methodInfo = method;
                var isAsync = false;
                var strings = methodInfo.Name.Split('_');
                var value = strings.Last();
                var name = strings.First();
                if (value.EndsWith("Async",StringComparison.Ordinal))
                {
                    isAsync = true;
                    value = value.Remove(value.Length - 5, 5);
                }

                var type = (CodeActionType) Enum.Parse(typeof (CodeActionType), value, true);

                switch (type)
                {
                    case CodeActionType.Filter:
                        if (isAsync)
                        {
                            _asyncFilters.Add(name, (m, e, o) => GetFilterTask(m, e, o, methodInfo));
                        }
                        else
                        {
                            _filters.Add(name, (m, e, o) => InvokeFilter(m, e, o, methodInfo));
                        }
                        break;
                    case CodeActionType.Trigger:
                        if (isAsync)
                        {
                            _asyncTriggers.Add(name, (m, e, o) => GetTriggerTask(m, e, o, methodInfo));
                        }
                        else
                        {
                            _triggers.Add(name, (m, e, o) => InvokeTrigger(m, e, o, methodInfo));
                        }
                        break;
                    case CodeActionType.Action:
                        if (isAsync)
                        {
                            _asyncActions.Add(name, (r) => GetActionTask(r, methodInfo));
                        }
                        else
                        {
                            _actions.Add(name, (r) => InvokeAction(r, methodInfo));
                        }
                        break;
                 
                }
            }
        }

        public Filter InvokeFilter(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            //return _filters[CodeActionUtils.GetMethodName(name, CodeActionType.Filter, false)].Invoke(model, entities, options);
            return _filters[name].Invoke(model, entities, options);
        }
        
        public Task<Filter> InvokeFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
           // return _asyncFilters[CodeActionUtils.GetMethodName(name, CodeActionType.Filter, true)].Invoke(model, entities, options);
            return _asyncFilters[name].Invoke(model, entities, options);
        }

       
        public (string Message, bool IsCancelled) InvokeTrigger(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
           // return _triggers[CodeActionUtils.GetMethodName(name, CodeActionType.Trigger, false)].Invoke(model, entities, options);
            return _triggers[name].Invoke(model, entities, options);
        }

        public Task<(string Message, bool IsCancelled)> InvokeTriggerAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            //return _asyncTriggers[CodeActionUtils.GetMethodName(name, CodeActionType.Trigger, true)].Invoke(model, entities, options);
            return _asyncTriggers[name].Invoke(model, entities, options);
        }

        public dynamic InvokeAction(string name, dynamic request)
        {
//            return _actions[CodeActionUtils.GetMethodName(name, CodeActionType.Action, false)].Invoke(request);
            return _actions[name].Invoke(request);
        }
        
        public Task<dynamic> InvokeActionAsync(string name, dynamic request)
        {
           // return _asyncActions[CodeActionUtils.GetMethodName(name, CodeActionType.Action, true)].Invoke(request);
            return  _asyncActions[name].Invoke(request);
        }

        public bool ContainsFilter(string name)
        {
//            return _filters.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Filter, false))
//                   || _asyncFilters.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Filter, true));
            return _filters.ContainsKey(name) || _asyncFilters.ContainsKey(name);
        }

        public bool ContainsTrigger(string name)
        {
//            return _triggers.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Trigger, false))
//                   || _asyncTriggers.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Trigger, true));
            return _triggers.ContainsKey(name) || _asyncTriggers.ContainsKey(name);
        }
        
        public bool ContainsAction(string name)
        {
//            return _actions.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Action, false))
//                   || _asyncActions.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Action, true));
            return _actions.ContainsKey(name) || _asyncActions.ContainsKey(name);
        }

        public List<string> GetFilterNames()
        {
            return _filters.Keys.Concat(_asyncFilters.Keys).Distinct().ToList();
        }
        
        public List<string> GetTriggerNames()
        {
            return _triggers.Keys.Concat(_asyncTriggers.Keys).Distinct().ToList();
        }
        
        public List<string> GetActionNames()
        {
            return _actions.Keys.Concat(_asyncActions.Keys).Distinct().ToList();
        }

        public bool IsFilterAsync(string name)
        {
           // return _asyncFilters.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Filter, true));
            return _asyncFilters.ContainsKey(name);
        }

        public bool IsTriggerAsync(string name)
        {
           // return _asyncTriggers.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Trigger, true));
            return _asyncTriggers.ContainsKey(name);
        }
        
        public bool IsActionAsync(string name)
        {
          //  return _asyncActions.ContainsKey(CodeActionUtils.GetMethodName(name, CodeActionType.Action, true));
            return _asyncActions.ContainsKey(name);
        }

        private Filter InvokeFilter(EntityModel model, List<dynamic> entities, dynamic options, MethodInfo methodInfo)
        {
            return (Filter) methodInfo.Invoke(null, new object[] {model, entities, options});
        }

        private Task<Filter> GetFilterTask(EntityModel model, List<dynamic> entities, dynamic options, MethodInfo methodInfo)
        {
            return (Task<Filter>)methodInfo.Invoke(null, new object[] { model, entities, options });
        }
        
        private (string Message, bool IsCancelled) InvokeTrigger(EntityModel model, List<dynamic> entities, dynamic options, MethodInfo methodInfo)
        {
            return ((string Message, bool IsCancelled)) methodInfo.Invoke(null, new object[] {model, entities, options});
        }

        private Task<(string Message, bool IsCancelled)> GetTriggerTask(EntityModel model, List<dynamic> entities, dynamic options, MethodInfo methodInfo)
        {
            return (Task<(string Message, bool IsCancelled)>)methodInfo.Invoke(null, new object[] { model, entities, options });
        }

        private dynamic InvokeAction(dynamic request, MethodInfo methodInfo)
        {
            return (dynamic) methodInfo.Invoke(null, new object[] {request});
        }

        private Task<dynamic> GetActionTask(dynamic request, MethodInfo methodInfo)
        {
            return (Task<dynamic>) methodInfo.Invoke(null, new object[] {request});
        }
    }
}

