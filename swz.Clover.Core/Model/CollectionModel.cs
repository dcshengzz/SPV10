using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Model
{
    public sealed class CollectionModel
    {
        public CollectionModel(string name, EntityModel model, Func<IEnumerable<DynamicEntity>, Filter> filter,
            Func<DynamicEntity, IEnumerable<DynamicEntity>, List<DynamicEntity>> getter, bool readOnly)
        {
            Name = name;
            Model = model;
            ReadOnly = readOnly;
            _filter = filter;
            _getter = getter;
        }

        public string Name { get; }
        public EntityModel Model { get; }
        private readonly Func<IEnumerable<DynamicEntity>,Filter> _filter;
        private readonly Func<DynamicEntity, IEnumerable<DynamicEntity>, List<DynamicEntity>> _getter;

        public Filter GetCollectionFilter(IEnumerable<DynamicEntity> parentEntities)
        {
            return _filter(parentEntities);
        }

        public List<DynamicEntity> GetCollection(DynamicEntity parentEntity, IEnumerable<DynamicEntity> children)
        {
            return _getter(parentEntity, children);
        }

        public string TotalCountPropertyName => $"__{Name}_totalcount";
        
        public bool ReadOnly { get; private set; }
    }

}