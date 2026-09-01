using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;

namespace swz.SurveyPlus.InternetApplication
{
	public class CustomActionProvider : IServerActionsProvider
    {
        private readonly IHttpContextAccessor _accessor;

        private readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<CustomActionProvider>();

        private readonly Dictionary<string, Func<dynamic, dynamic>> _actions
            = new Dictionary<string, Func<dynamic, dynamic>>();

        private readonly Dictionary<string, Func<dynamic, Task<dynamic>>> _actionsAsync
            = new Dictionary<string, Func<dynamic, Task<dynamic>>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>> _filters
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>> _filtersAsync
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>>();

        private readonly Dictionary<string,
                Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>>
            _triggers
                = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, (string Message, bool IsCancelled)>
                >();

        private readonly Dictionary<string,
                Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>
            _triggersAsync
                = new Dictionary<string,
                    Func<EntityModel, List<dynamic>, dynamic, Task<(string Message, bool IsCancelled)>>>();

        public CustomActionProvider(IHttpContextAccessor accessor) : this()
        {
            _accessor = accessor;
        }

        public CustomActionProvider()
        {
            _filtersAsync.Add("DplySampleAsyncFilter", DplySampleAsyncFilter);
        }

        #region IServerActionsProvider implementation

        public List<string> GetFilterNames()
        {
            return _filters.Keys.Concat(_filtersAsync.Keys).ToList();
        }

        public bool IsFilterAsync(string name)
        {
            return _filtersAsync.ContainsKey(name);
        }

        public bool ContainsFilter(string name)
        {
            return _filtersAsync.ContainsKey(name) || _filters.ContainsKey(name);
        }

        public Filter GetFilter(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            if (_filters.ContainsKey(name))
                return _filters[name](model, entities, options);
            throw new NotImplementedException();
        }

        public Task<Filter> GetFilterAsync(string name, EntityModel model, List<dynamic> entities, dynamic options)
        {
            if (_filtersAsync.ContainsKey(name))
                return _filtersAsync[name](model, entities, options);
            throw new NotImplementedException();
        }

        public List<string> GetTriggerNames()
        {
            return _triggers.Keys.Concat(_triggersAsync.Keys).ToList();
        }

        public bool IsTriggerAsync(string name)
        {
            return _triggersAsync.ContainsKey(name);
        }

        public bool ContainsTrigger(string name)
        {
            return _triggersAsync.ContainsKey(name) || _triggers.ContainsKey(name);
        }

        public (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            if (_triggers.ContainsKey(name))
                return _triggers[name](model, entities, options);
            throw new NotImplementedException();
        }

        public Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            if (_triggersAsync.ContainsKey(name))
                return _triggersAsync[name](model, entities, options);
            throw new NotImplementedException();
        }

        public List<string> GetActionNames()
        {
            return _actions.Keys.Concat(_actionsAsync.Keys).ToList();
        }

        public bool IsActionAsync(string name)
        {
            return _actionsAsync.ContainsKey(name);
        }

        public bool ContainsAction(string name)
        {
            return _actions.ContainsKey(name) || _actionsAsync.ContainsKey(name);
        }

        public dynamic ExecuteAction(string name, dynamic request)
        {
            if (_actions.ContainsKey(name))
                return _actions[name](request);
            throw new NotImplementedException();
        }

        public async Task<dynamic> ExecuteActionAsync(string name, dynamic request)
        {
            if (_actionsAsync.ContainsKey(name))
                return _actionsAsync[name](request);
            throw new NotImplementedException();
        }

        #endregion

        #region Filters

        private async Task<Filter> DplySampleAsyncFilter(EntityModel model, List<object> entities, dynamic options)
        {
            //The filtering is performed elsewhere now as we are using the u@app mechanism to retrieve the
            //data from the intranet side (see InternetApiDataSource). As such this code is not being maintained
            //so will be removed. This filter is left as a placeholder for now
            return Filter.Empty;

            /*
             
            The following commented out code is left here as a reference 
            and may be of interest if we implement U@Db again:

            The mapping used the following Parameters for the respdashboard mappings:
            grid (current surveys): 
                {UID:"@UID", DplyDateStart: "<=@NOW",  DueDate: ">=@NOW", VisibleToRespondent:1,DplyWorkflowState:"Active",ListSampleRecordActiveYN:1}

            gridview (previous surveys):
                {UID:"@UID",  DueDate:"<=@NOW", VisibleToRespondent:1,DplyWorkflowState:"Active", ListSampleRecordActiveYN:1,}


                    if (_accessor.HttpContext != null && _accessor.HttpContext.Session != null &&
                        _accessor.HttpContext.Session.Keys.Any(k => k == "uId"))
                    {
                        var uId = _accessor.HttpContext.Session.GetString("uId");
                        var fields = options as DynamicEntity;
                        var filter = Filter.Empty;
                        if (fields != null)
                            foreach (var field in fields.Dictionary)
                            {
                                if (field.Value == null || field.Key == null) continue;
                                if (field.Key.ToUpper() == "UID" && ((string)field.Value).ToUpper() == "@UID")
                                    filter = filter.Merge(Filter.And.Equal(uId, field.Key));

                                //current
                                else if (field.Key.ToUpper() == "DplyDateStart".ToUpper() &&
                                    ((string)field.Value).ToUpper() == "<=@NOW")
                                    filter = filter.Merge(Filter.And.LessOrEqual(DateTime.Now, field.Key));
                                else if (field.Key.ToUpper() == "DueDate".ToUpper() && ((string)field.Value).ToUpper() == ">=@NOW")
                                    filter = filter.Merge(Filter.And.Greater(DateTime.Now, field.Key));

                                //previous
                                else if (field.Key.ToUpper() == "DueDate".ToUpper() && ((string)field.Value).ToUpper() == "<=@NOW")
                                    filter = filter.Merge(Filter.And.LessOrEqual(DateTime.Now, field.Key));
                                else
                                {
                                    filter = filter.Merge(Filter.And.Equal(field.Value, field.Key));
                                }
                            }

                        return filter;
                    }
                    return Filter.Empty;
            */
        } //end of DplySampleAsyncFilter

        #endregion
    } //end of CustomActionProvider
}