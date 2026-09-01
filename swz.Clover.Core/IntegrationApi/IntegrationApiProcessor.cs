using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;

#pragma warning disable 1591

namespace swz.Clover.Core.IntegrationApi
{
    public enum IntegrationApiOperations
    {
        Get,
        Change,
        Delete
    }

    public enum IntegrationApiMode
    {
        Form, Model
    }
    

    public static class IntegrationApiKeys
    {
        public const string Operation = "operation";
        public const string Mode = "mode";
        public const string Level = "level"; //For models
        public const string Name = "name";
        public const string UrlFilter = "urlfilter";
        public const string Filter = "filter";
        public const string Order = "order";
        public const string Skip = "skip";
        public const string Take = "take";
        public const string Data = "data";
        public const string Ids = "ids";
        public const string ApiKey = "apikey";
        public const string HeaderApiKey = "clover-apikey";
    }

    public static class IntegrationApiProcessor
    {
        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(IntegrationApiProcessor));
        public static async Task<IntegrationApiResponse> ProcessAsync(Dictionary<string, string> parameters)
        {
            try
            {
                return await ProcessInternal(parameters);
            }
            catch (Exception e)
            {
                _logger.LogDebug(e, nameof(ProcessAsync) + " - caught unexpected exception");
                return new IntegrationApiFailResponse(e);
            }
           
        }

        private static async Task<IntegrationApiResponse> ProcessInternal(Dictionary<string, string> parameters)
        {
            if (string.IsNullOrEmpty(CloverRuntime.IntegrationApiKey))
                throw new Exception($"IntegrationApiKey must have value. Set in in Clover settings");
            if (!parameters.ContainsKey(IntegrationApiKeys.ApiKey))
                throw new Exception($"Parameter {IntegrationApiKeys.ApiKey} is required");
            if (!parameters[IntegrationApiKeys.ApiKey].Equals(CloverRuntime.IntegrationApiKey,StringComparison.Ordinal))
                throw new Exception($"Wrong {IntegrationApiKeys.ApiKey}");
            if (!parameters.ContainsKey(IntegrationApiKeys.Operation))
                throw new Exception($"Parameter {IntegrationApiKeys.Operation} is required");
            if (!parameters.ContainsKey(IntegrationApiKeys.Mode))
                throw new Exception($"Parameter {IntegrationApiKeys.Mode} is required");
            if (!parameters.ContainsKey(IntegrationApiKeys.Name))
                throw new Exception($"Parameter {IntegrationApiKeys.Name} is required");

            IntegrationApiOperations operations;
            Enum.TryParse(parameters[IntegrationApiKeys.Operation], true, out operations);
            IntegrationApiMode mode;
            Enum.TryParse(parameters[IntegrationApiKeys.Mode], true, out mode);

            var name = parameters[IntegrationApiKeys.Name];

            switch (operations)
            {
                case IntegrationApiOperations.Get:
                    switch (mode)
                    {
                        case IntegrationApiMode.Form:
                            return await GetFormAsync(name, parameters);
                        case IntegrationApiMode.Model:
                            return await GetModelAsync(name, parameters);
                        default:
                            throw new Exception("Unknown api mode, must be form or model");
                    }
                case IntegrationApiOperations.Change:
                    switch (mode)
                    {
                        case IntegrationApiMode.Form:
                            return await ChangeFormAsync(name, parameters);
                        case IntegrationApiMode.Model:
                            return await ChangeModelAsync(name, parameters);
                        default:
                            throw new Exception("Unknown api mode, must be form or model");
                    }
                case IntegrationApiOperations.Delete:
                    switch (mode)
                    {
                        case IntegrationApiMode.Form:
                            return await DeleteFormAsync(name, parameters);
                        case IntegrationApiMode.Model:
                            return await DeleteModelAsync(name, parameters);
                        default:
                            throw new Exception("Unknown api mode, must be form or model");
                    }
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        private static async Task<IntegrationApiResponse>  DeleteModelAsync(string name, Dictionary<string, string> parameters)
        {
            var model = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 1, true);
            var modelForDelete = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 0, true);
            
            return await DeleteData(parameters, model, modelForDelete);
        }

        private static async Task<IntegrationApiResponse>  DeleteFormAsync(string name, Dictionary<string, string> parameters)
        {
            
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null, true, BuildModelStartegy.ForGet));
            var modelForDelete = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null, true, BuildModelStartegy.ForChange));
            
            return await DeleteData(parameters, model, modelForDelete);
        }

        private static async Task<IntegrationApiResponse> DeleteData(Dictionary<string, string> parameters, EntityModel model, EntityModel modelForDelete)
        {
            long deleted = 0;
            var filter = Filter.And;
            filter.Merge(await GetFilterFromUrlAsync(parameters, model));
            filter.Merge(GetFilter(parameters, model));

            if (filter.IsEmpty)
            {
                if (!parameters.ContainsKey(IntegrationApiKeys.Ids))
                    throw new Exception($"Parameter {IntegrationApiKeys.Ids} is required");

                var ids = JsonConvert.DeserializeObject<List<object>>(parameters[IntegrationApiKeys.Ids]);
                deleted = await modelForDelete.DeleteAsync(ids);
            }
            else
            {
                using (var shared = new SharedTransaction())
                {
                    await shared.BeginTransactionAsync();
                    
                    var data = await model.GetAsync(filter);
                    var ids = data.Select(d => d.GetId()).ToList();
                    deleted = await modelForDelete.DeleteAsync(ids);
                    
                    await shared.CommitAsync();
                }
            }

            return new IntegrationApiSuccessResponse<object>(new
            {
                Deleted = deleted
            });
        }

        private static async Task<IntegrationApiResponse>  ChangeModelAsync(string name, Dictionary<string, string> parameters)
        {
            if (!parameters.ContainsKey(IntegrationApiKeys.Data))
                    throw new Exception($"Parameter {IntegrationApiKeys.Data} is required");
            var model = await MetadataToModelConverter.GetEntityModelByModelAsync(name, 0, ignoreCase: true);
            return await ChangeData(parameters, model);
        }

        private static async Task<IntegrationApiResponse>  ChangeFormAsync(string name, Dictionary<string, string> parameters)
        {
            if (!parameters.ContainsKey(IntegrationApiKeys.Data))
                throw new Exception($"Parameter {IntegrationApiKeys.Data} is required");
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null, true, BuildModelStartegy.ForChange));
            return await ChangeData(parameters, model);
        }

        private static async Task<IntegrationApiResponse> ChangeData(Dictionary<string, string> parameters, EntityModel model)
        {
            var deserializer = new DynamicEntityDeserializer(model);
            var data = deserializer.DeserializeList(parameters[IntegrationApiKeys.Data], model, fillClientId: true);

            long updated = 0;
            long inserted = 0;

            var idsMap = new SortedDictionary<object, object>();

            if (data.Any())
            {
                var res = await model.UpdateAsync(data.Cast<dynamic>().ToList());

                foreach (var entity in data)
                {
                    if (entity.HasPrimaryKey)
                    {
                        var map = entity.GetClientIdAndPrimaryKey();
                        
                        if (map.originalClientId != null)
                            idsMap.Add(map.primaryKey,map.originalClientId);
                    }
                }
                
                updated += res.updated;
                inserted += res.inserted;
            }
            
            return new IntegrationApiSuccessResponse<object>(new
            {
                Updated = updated,
                Inserted = inserted,
                OriginalIds = idsMap.Values,
                InsertedIds = idsMap.Keys
            });
        }

        #region GET


        private static async Task<IntegrationApiResponse>  GetModelAsync(string name, Dictionary<string, string> parameters)
        {
            byte level = 1;

            if (parameters.ContainsKey(IntegrationApiKeys.Level))
            {
                byte.TryParse(parameters[IntegrationApiKeys.Level], out level);
            }

            var model = await MetadataToModelConverter.GetEntityModelByModelAsync(name, level, true);

            return await GetByEntityModel(parameters, model);
        }



        private static async Task<IntegrationApiResponse> GetFormAsync(string name, Dictionary<string, string> parameters)
        {
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions(null,true));

            return await GetByEntityModel(parameters, model);
        }

        private static async Task<IntegrationApiResponse> GetByEntityModel(Dictionary<string, string> parameters, EntityModel model)
        {
            var filter = Filter.And;
            filter.Merge(await GetFilterFromUrlAsync(parameters, model));
            filter.Merge(GetFilter(parameters, model));
            var order = GetOrder(parameters);
            var paging = await GetPagingAsync(parameters, filter, model);

            var data = await model.GetAsync(filter, order, paging);

            return new IntegrationApiSuccessResponse<List<Dictionary<string, object>>>(data.Select(d => d.ToDictionary(true)).ToList());
        }

        private static async Task<Paging> GetPagingAsync(Dictionary<string, string> parameters, Filter filter, EntityModel model)
        {
            long? skip = null;
            long? take = null;

            if (parameters.ContainsKey(IntegrationApiKeys.Skip))
            {
                if (long.TryParse(parameters[IntegrationApiKeys.Skip],out var parsed))
                {
                    skip = parsed;
                }
            }
            
            if (parameters.ContainsKey(IntegrationApiKeys.Take))
            {
                if (long.TryParse(parameters[IntegrationApiKeys.Take],out var parsed))
                {
                    take = parsed;
                }
            }

            if (skip.HasValue && take.HasValue)
            {
                return Paging.Create(skip.Value, take.Value);
            }

            if (skip.HasValue)
            {
                var total = await model.GetCountAsync(filter);
                return Paging.Create(skip.Value, total - skip.Value);
            }

            if (take.HasValue)
            {
                return Paging.Create(0, take.Value);
            }

            return Paging.Empty;
        }

        private static Order GetOrder(Dictionary<string, string> parameters)
        {
            if (parameters.ContainsKey(IntegrationApiKeys.Order))
            {
                var items = JsonConvert.DeserializeObject<List<ClienSortItem>>(parameters[IntegrationApiKeys.Order]);

                return items.ToORMOrder();
            }

            return Order.Empty;
        }

        private static Filter GetFilter(Dictionary<string, string> parameters, EntityModel model)
        {
            if (parameters.ContainsKey(IntegrationApiKeys.Filter))
            {
                var items = JsonConvert.DeserializeObject<List<ClientFilterItem>>(parameters[IntegrationApiKeys.Filter]);

                return items.ToORMFilter(model);
            }

            return Filter.Empty;
        }

        private static async Task<Filter> GetFilterFromUrlAsync(Dictionary<string, string> parameters, EntityModel model)
        {
            
            if (parameters.ContainsKey(IntegrationApiKeys.UrlFilter))
            {
                var combinedFilter = Filter.And;
                
                var rawUrlFilter = parameters[IntegrationApiKeys.UrlFilter];

                if (CloverRuntime.ServerActions.ContainsFilter(rawUrlFilter))
                {
                    if (CloverRuntime.ServerActions.IsFilterAsync(rawUrlFilter))
                    {
                        combinedFilter.Merge(await CloverRuntime.ServerActions.GetFilterAsync(rawUrlFilter, model, new List<dynamic>(), null));
                    }
                    else
                    {
                        combinedFilter.Merge(CloverRuntime.ServerActions.GetFilter(rawUrlFilter, model, new List<dynamic>(), null));
                    }
                }
                else if (model.HasPrimaryKey)
                {
                    combinedFilter.Equal(model.PrimaryKeyAttribute.Type.ParseToCLRType(rawUrlFilter), model.PrimaryKeyAttribute);
                }

                return combinedFilter;
            }

            return Filter.Empty;
        }

       #endregion 
    }
}