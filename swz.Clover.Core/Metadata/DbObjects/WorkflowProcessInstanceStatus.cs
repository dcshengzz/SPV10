using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessInstanceStatus : DbObject<WorkflowProcessInstanceStatus>
    {
        public WorkflowProcessInstanceStatus() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public byte Status
        {
            get => _entity.Status;
            set => _entity.Status = value;
        }

        [DbObjectModel]
        public Guid Lock
        {
            get => _entity.Lock;
            set => _entity.Lock = value;
        }
    }
}