using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.Model;

namespace swz.SurveyPlus.InternetApplication
{
    public class Filters : IServerActionsProvider
    {
        public Filters()
        {
            _filtersAsync.Add("FilterFields", FilterFields);
        }

        public async Task<Filter> FilterFields(EntityModel model, List<dynamic> entities, dynamic options)
        {
            var fields = options as DynamicEntity;
            var filter = Filter.Empty;
            if (fields != null)
                foreach (var field in fields.Dictionary)
                    filter = filter.Merge(Filter.And.Equal(await Triggers.ReplaceVariable(field.Value, model),
                        field.Key));

            return filter;
        }

        #region IServerActionsProvider implementation

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>> _filters
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Filter>>();

        private readonly Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>> _filtersAsync
            = new Dictionary<string, Func<EntityModel, List<dynamic>, dynamic, Task<Filter>>>();

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
            return new List<string>();
        }

        public bool IsTriggerAsync(string name)
        {
            return false;
        }

        public bool ContainsTrigger(string name)
        {
            return false;
        }

        public (string Message, bool IsCancelled) ExecuteTrigger(string name, EntityModel model, List<dynamic> entities,
            dynamic options)
        {
            throw new NotImplementedException();
        }

        public async Task<(string Message, bool IsCancelled)> ExecuteTriggerAsync(string name, EntityModel model,
            List<dynamic> entities, dynamic options)
        {
            throw new NotImplementedException();
        }

        public List<string> GetActionNames()
        {
            return new List<string>();
        }

        public bool IsActionAsync(string name)
        {
            return false;
        }

        public bool ContainsAction(string name)
        {
            return false;
        }

        public dynamic ExecuteAction(string name, dynamic request)
        {
            throw new NotImplementedException();
        }

        public async Task<dynamic> ExecuteActionAsync(string name, dynamic request)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}