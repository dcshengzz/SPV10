using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowGlobalParameter : DbObject<WorkflowGlobalParameter>
    {
        public WorkflowGlobalParameter() : base(true)
        {
        }
        
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string Type
        {
            get => _entity.Type;
            set => _entity.Type = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public string Value
        {
            get => _entity.Value;
            set => _entity.Value = value;
        }
    }
}