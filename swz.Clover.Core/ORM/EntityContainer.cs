using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{

    
    public class EntityContainer
    {
        protected readonly bool ReadOnly;
        protected string PropertyName { get; set; }
        public EntityContainer Parent { get; private set; }

        public IEnumerable<EntityContainer> Children => ChildrenList.Values;

        protected SortedList<string,EntityContainer> ChildrenList = new SortedList<string, EntityContainer>();
         
  
        public IEnumerable<dynamic> Entities
        { 
            get => EntitiesList;
            set => EntitiesList = value.ToList();
        }
        
        protected  List<dynamic> EntitiesList; 

        public EntityModel Model { get; }

        //TODO obsolete
        public bool IgnoreNotChanged { get; set; }
        

        public EntityContainer(IEnumerable<dynamic> entities, EntityModel model, bool readOnly = false)
        {
            ReadOnly = readOnly;
            Model = model;
            var entitiesList = entities as IList<dynamic> ?? entities?.ToList() ?? new List<dynamic>();
            EntitiesList = new List<dynamic>();
            
            foreach (DynamicEntity entity in entitiesList)
            {
                // ReSharper disable once VirtualMemberCallInConstructor
                EntitiesList.Add(ProcessSingleEntity(entity));
            }

            if (model.HasCollections)
            {
                foreach (var collection in model.Collections)
                {
                    var allEntitiesInCollection = GetAllEntitiesInCollection(entitiesList, collection);
                    // ReSharper disable once VirtualMemberCallInConstructor
                    var childContainer = CreateChildContainer(allEntitiesInCollection, collection.Model, collection.ReadOnly, collection.Name);
                    childContainer.Parent = this;
                    ChildrenList.Add(collection.Name, childContainer);
                }
            }
        }

        protected virtual EntityContainer CreateChildContainer(IEnumerable<dynamic> entities, EntityModel model, bool readOnly,string propertyName)
        {
            return  new EntityContainer(entities, model, readOnly)
            {
                PropertyName = propertyName
            };
        }

        private IEnumerable<DynamicEntity> GetAllEntitiesInCollection(IList<dynamic> entitiesList, CollectionModel collection)
        {
            var allEntitiesInCollection = new Dictionary<object,DynamicEntity>();
            foreach (DynamicEntity entity in entitiesList)
            {
                if (entity.HasProperty(collection.Name))
                {
                    if (entity[collection.Name] is IEnumerable<DynamicEntity> collectionValue)
                    {
                        foreach (var dynamicEntity in collectionValue)
                        {
                            var key = dynamicEntity.GetId();
                            if (!allEntitiesInCollection.ContainsKey(key))
                            {
                               // var processSingleEntity = ProcessSingleEntity(dynamicEntity);
                                //allEntitiesInCollection.Add(key, processSingleEntity);
                                allEntitiesInCollection.Add(key,dynamicEntity);
                            }
                        }
                    }
                }
            }

            return allEntitiesInCollection.Values;
        }


        protected void AddSingleEntity(DynamicEntity entity, bool dontAddChildren = false)
        {
            var entityToAdd = ProcessSingleEntity(entity);
            EntitiesList.Add(entityToAdd);
            if (dontAddChildren)
                return;
            foreach (var child in Children)
            {
                if (entity[child.PropertyName] is IEnumerable<DynamicEntity> childEntities)
                {
                    foreach (var childEntity in childEntities)
                    {
                        child.AddSingleEntity(childEntity);
                    }
                }
            }
        }



        protected virtual DynamicEntity ProcessSingleEntity(DynamicEntity entity)
        {
            return entity;
        }

        public string Serialize()
        {
            List<IDictionary<string, object>> values;
            if (!Model.HasCollections)
            {
                values = new List<IDictionary<string, object>>(EntitiesList.Count);
                values.AddRange(EntitiesList.Cast<DynamicEntity>().Select(entity => entity.Dictionary));
            }
            else
            {
                values = new List<IDictionary<string, object>>(EntitiesList.Count);
                values.AddRange(EntitiesList.Cast<DynamicEntity>().Select(entity => entity.ToDictionary()));
            }

            return JsonConvert.SerializeObject(values);
        }
    }
}
