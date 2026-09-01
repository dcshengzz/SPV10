using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core
{

    public static class DynamicRepository
    {

        public static Task<List<DynamicEntity>> GetAsync(this EntityModel model, Filter filter)
        {
            return GetAsync(model, filter, Order.Empty);
        }

        public static Task<List<DynamicEntity>> GetAsync(this EntityModel model, Filter filter, Order order)
        {
            return model.GetAsync(filter, order, Paging.Empty);
        }

        public static Task<List<DynamicEntity>> GetAsync(this EntityModel model, Filter filter, Order order, Paging paging)
        {
            return GetEntities(model, filter, order, paging);
        }
        
        public static Task<List<DynamicEntity>> GetAsync(this EntityModel model,  Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests)
        {
            return GetEntities(model, Filter.Empty, Order.Empty, Paging.Empty, collectionsRequests);
        }
        
        public static async Task<DynamicEntity> NewAsync(this EntityModel model)
        {
            var newObj =  model.GetIntializedObject(false, true);
            var result = await model.ExecuteTriggersAsync(TriggerCallType.AfterNew, new List<dynamic> { newObj });
            
            if (result.IsCancelled)
                throw new NewEntityCreationCancelledException(result.Message);
            
            result = await model.ExecuteTriggersAsync(TriggerCallType.AfterSelect, new List<dynamic> {newObj});
            
            if (result.IsCancelled)
                throw new NewEntityCreationCancelledException(result.Message);
            
            return newObj;
        }

        public static async Task<ObservableEntityContainer> GetContainerByForm(string name, Filter filter)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions()).ConfigureAwait(false);
            return await GetObservableEntitiesAsync(metadata, filter).ConfigureAwait(false);
        }

      
        public static async Task<ObservableEntityContainer> GetContainerByEntity(string name, Filter filter)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByModelAsync(name).ConfigureAwait(false);
            return await GetObservableEntitiesAsync(metadata, filter).ConfigureAwait(false);
        }

        //public static async Task InsertByForm(string name, List<dynamic> entities)
        //{
        //    var metadata = await MetadataToModelConverter.GetEntityModelByFormAsync(name).ConfigureAwait(false);
        //    await metadata.InsertAsync(entities).ConfigureAwait(false);
        //}

        public static Task InsertSingleAsync(this EntityModel model, dynamic entity)
        {
            return model.InsertAsync(new List<dynamic> {entity});
        }
        
     
        public static async Task InsertAsync(this EntityModel model, List<dynamic> entities)
        {
            await InsertAsync(entities, model).ConfigureAwait(false);
        }


        public static async Task UpdateByFormAsync(string name, List<dynamic> entities)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions()).ConfigureAwait(false);
            await metadata.UpdateAsync(entities).ConfigureAwait(false);
        }

        public static Task UpdateSingleAsync(this EntityModel model, dynamic entity)
        {
            return model.UpdateAsync(new List<dynamic> {entity});
        }

        public static async Task<(long inserted, long updated)> UpdateAsync(this EntityModel model, List<dynamic> entities)
        {
            return await UpdateAsync(entities, model).ConfigureAwait(false);
        }


        private static async Task<(long inserted, long updated)> UpdateAsync(List<dynamic> entities, EntityModel model)
        {
            var filter = Filter.Empty;
			var needLoadData = false;
            if (!model.IsVirtual)
            {
                var idProperty = model.PrimaryKeyAttribute.PropertyName;
                filter = Filter.Or;

                foreach (DynamicEntity en in entities)
                {
                    en.SetIdName(idProperty);
                    if (en.HasPrimaryKey)
                    {
                        filter.Equal(en.GetPrimaryKey(), idProperty);
                        needLoadData = true;
                    }
                }
            }
            else
            {
                needLoadData = true;
            }
            var container = needLoadData 
                        ? await GetObservableEntitiesAsync(model, filter).ConfigureAwait(false)
                        : new ObservableEntityContainer(new List<DynamicEntity>(),model);

            container.Merge(entities);

            var res = await container.ApplyAsync().ConfigureAwait(false);

            return (res.inserted, res.updated);
        }

        private static async Task<ObservableEntityContainer> InsertAsync(IEnumerable<dynamic> entities, EntityModel model)
        {
            var container = GetEmptyObservableEntities(model);
            container.Merge(entities);
            await container.ApplyAsync().ConfigureAwait(false);

            return container;
        }

        public static async Task InsertByEntityAsync(string name, List<dynamic> entities)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByModelAsync(name).ConfigureAwait(false);
            await InsertAsync(entities, metadata).ConfigureAwait(false);
        }

        public static async Task UpdateByEntityAsync(string name, List<dynamic> entities)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByModelAsync(name).ConfigureAwait(false);
            await UpdateAsync(entities, metadata).ConfigureAwait(false);
        }

        public static async Task<long> DeleteAsync(this EntityModel model, IEnumerable<object> ids, bool cascadeDelete = false)
        {
            return await DeleteAsync(ids, model, cascadeDelete).ConfigureAwait(false);
        }
        
        private static async Task<long> DeleteAsync(IEnumerable<object> ids, EntityModel model,  bool cascadeDelete)
        {
            var enumerable = ids as IList<object> ?? ids.ToList();

            if (!enumerable.Any())
                return 0;

            var filter = Filter.Or;

            foreach (var id in enumerable)
            {
                filter.Equal(id, model.PrimaryKeyAttribute);
            }

            var container = await GetObservableEntitiesAsync(model, filter).ConfigureAwait(false);

            container.RemoveAll(cascadeDelete);
            var res = await container.ApplyAsync().ConfigureAwait(false);
            return res.deleted;
        }


        public static async Task<Dictionary<object, object>> FormToDictionary(string name, string valueColumnName)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions()).ConfigureAwait(false);


            var attribute = metadata.GetAttributeByName(valueColumnName);

            var data = await GetEntityContainer(Filter.Empty, Order.StartAsc(attribute), metadata).ConfigureAwait(false);
         
            var result = new Dictionary<object, object>();
            foreach (DynamicEntity entity in data.Entities)
            {
                if (!result.ContainsKey(entity.GetId()))
                {
                    result.Add(entity.GetId(), entity.GetProperty(valueColumnName));
                }
            }

            return result;
        }

        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void SetNewPrimaryKey(this EntityModel model, DynamicEntity dymamicEntity)
        {
            if (model.PrimaryKeyAttribute.Type.CLRType == typeof(Guid))
                dymamicEntity.TrySetMember(model.PrimaryKeyAttributeName, CloverRuntime.DbProvider.GenerateGuid(), true);
            else
            {
                var pk = CloverRuntime.GeneratePrimaryKey(model.PrimaryKeyAttribute);
                if (pk != null)
                {
                    dymamicEntity.TrySetMember(model.PrimaryKeyAttributeName, pk, true);
                }
            }
        }


        public static async Task<long> GetCountByEntity(string name, Filter filter, byte level = 1)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByModelAsync(name, level).ConfigureAwait(false);

            return await metadata.GetCountAsync(filter).ConfigureAwait(false);
        }

        public static async Task<long> GetCountByForm(string name, Filter filter)
        {
            var metadata = await MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions()).ConfigureAwait(false);
            return await metadata.GetCountAsync(filter).ConfigureAwait(false);
        }

        public static Task<long> GetCountAsync(this EntityModel model, Filter filter)
        {
            return GetCount(filter, model);
        }

        public static Task<EntityModel> GetMetadataByForm(string name)
        {
            return MetadataToModelConverter.GetEntityModelByFormAsync(name, new BuildModelOptions());
        }

        public static void ExecuteStoredProcedure(string storedProcedure, Dictionary<string, object> paramsIn, Dictionary<string, object> paramsOut)
        {
            CloverRuntime.DbProvider.ExecuteStoredProcedureAsync(storedProcedure, paramsIn, paramsOut).Wait();
        }

        public static List<Dictionary<string, object>> ExecuteStoredProcedureExAsync(string storedProcedure, Dictionary<string, object> paramsIn, Dictionary<string, object> paramsOut)
        {
            return CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(storedProcedure, paramsIn, paramsOut).Result;
        }

       


        #region DynamicQueries

        public static Task<EntityContainer> GetEntities(EntityModel model, Filter filter,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests = null, string connectionString = null)
        {
            return GetEntityContainer(filter, model, collectionsRequests, connectionString);
        }


        public static async Task<ObservableEntityContainer> GetObservableEntitiesAsync(EntityModel model, Filter filter,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests = null, string connectionString = null)
        {
            return new ObservableEntityContainer((await GetEntities(model, filter, collectionsRequests, connectionString).ConfigureAwait(false)),false, connectionString);
        }

        public static ObservableEntityContainer GetEmptyObservableEntities(EntityModel model, string connectionString = null)
        {
            return new ObservableEntityContainer(new EntityContainer(new List<dynamic>(), model), false, connectionString);
        }

        public static Task<long> GetCount(Filter filter, EntityModel model, string connectionString = null)
        {
            return CloverRuntime.DbProvider.CountAsyc(model, filter, connectionString);
        }

        private static Task<EntityContainer> GetEntityContainer(Filter filter, EntityModel model,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests = null, string connectionString = null)
        {
            return GetEntityContainer(filter, Order.Empty, Paging.Empty, model,collectionsRequests, connectionString);
        }

        private static async Task<EntityContainer> GetEntityContainer(Filter filter,
            Order order,
            Paging paging,
            EntityModel model,
            Dictionary<string, (Filter Filter, Order order, Paging paging)> collectionsRequests = null,
            string connectionString = null)
        {
            var parentEntities = await GetEntities(model, filter, order, paging, collectionsRequests, connectionString);

            return new EntityContainer(parentEntities, model);
        }

        private static async Task<List<DynamicEntity>> GetEntities(EntityModel model, Filter filter, Order order, Paging paging,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests = null,
            string connectionString = null)
        {
            if (paging == null)
                paging = Paging.Empty;
            if (order == null)
                order = Order.Empty;
            
            //if (CloverRuntime.LicenseSemaphore != null) await CloverRuntime.LicenseSemaphore.WaitAsync();
            try
            {
                if (!model.IsVirtual)
                {
                    var orderForPaging = order.IsEmpty && paging != Paging.Empty ? Order.StartAsc(model.PrimaryKeyAttribute) : order;
                    var parentEntities = (await CloverRuntime.DbProvider.ReadAsync(model, filter, orderForPaging, paging, connectionString)).ToList();
                    if (parentEntities.Any())
                    {
                        foreach (var childCollection in model.Collections)
                        {
                            await FillCollectionsAsync(parentEntities, childCollection, collectionsRequests, connectionString);
                        }
                    }

                    
                    var triggerExecutionResult = await model.ExecuteTriggersAsync(TriggerCallType.AfterSelect, parentEntities.Cast<dynamic>().ToList());
                    if (triggerExecutionResult.IsCancelled)
                        throw new SelectCancelledException(triggerExecutionResult.Message);
                    
                    return parentEntities;
                }

                var result = new List<DynamicEntity>() {new DynamicEntity()};
                foreach (var childCollection in model.Collections)
                {
                    await FillCollectionsAsync(result, childCollection, collectionsRequests, connectionString);
                }
                
                var res = await model.ExecuteTriggersAsync(TriggerCallType.AfterSelect, result.Cast<dynamic>().ToList());
                if (res.IsCancelled)
                    throw new SelectCancelledException(res.Message);
                
                return result;
            }
            finally
            {
                CloverRuntime.LicenseSemaphore?.Release();
            }
        }

        private static async Task FillCollectionsAsync(List<DynamicEntity> entities, CollectionModel collection,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests,
            string connectionString)
        {
            var hasSpecialRequest = collectionsRequests != null && collectionsRequests.ContainsKey(collection.Name);
            var filter = hasSpecialRequest ? collectionsRequests[collection.Name].Filter : Filter.Empty;
            var order = hasSpecialRequest ? collectionsRequests[collection.Name].Order : Order.Empty;
            var paging = hasSpecialRequest ? collectionsRequests[collection.Name].Paging : Paging.Empty;

            if (paging != Paging.Empty && entities.Count != 1)
                throw new DynamicEntitiesException($"Can not use a paging request if there are more than one root entities.");

            var orderForPaging = order.IsEmpty && paging != Paging.Empty ? Order.StartAsc(collection.Model.PrimaryKeyAttribute) : order;
            var resultFilter = collection.GetCollectionFilter(entities).Merge(filter);
            var collectionData = await CloverRuntime.DbProvider.ReadAsync(collection.Model, resultFilter, orderForPaging, paging, connectionString);


            if (entities.Count == 1)
            {
                var entity = entities.First();
                entity[collection.Name] = collectionData;
                if (paging == Paging.Empty)
                {
                    entity[collection.TotalCountPropertyName] = collectionData.Count;
                }
                else
                {
                    entity[collection.TotalCountPropertyName] = await CloverRuntime.DbProvider.CountAsyc(collection.Model, resultFilter, connectionString);
                }
            }
            else
            {
                foreach (var entity in entities)
                {
                    var entityCollectionData = collection.GetCollection(entity, collectionData);
                    entity[collection.Name] = entityCollectionData;
                    entity[collection.TotalCountPropertyName] = entityCollectionData.Count;

                }
            }

            if (collectionData.Any())
            {
                foreach (var childCollection in collection.Model.Collections)
                {
                    await FillCollectionsAsync(collectionData, childCollection, null,
                        connectionString); //Only first level is supported now
                }
            }
        }

        private static Task<EntityContainer> GetEntityContainer(Filter filter, Order order, EntityModel model,
            Dictionary<string, (Filter Filter, Order Order, Paging Paging)> collectionsRequests = null, string connectionString = null)
        {
            return GetEntityContainer(filter, order, Paging.Empty, model, collectionsRequests, connectionString);
        }


        #endregion
    }
}

