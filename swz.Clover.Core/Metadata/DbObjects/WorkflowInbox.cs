using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowInbox : DbObject<WorkflowInbox>
    {
        public WorkflowInbox() : base(true)
        {
        }
        
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public Guid ProcessId
        {
            get => _entity.ProcessId;
            set => _entity.ProcessId = value;
        }

        [DbObjectModel]
        public Guid IdentityId
        {
            get => _entity.IdentityId;
            set => _entity.IdentityId = value;
        }
    }
}