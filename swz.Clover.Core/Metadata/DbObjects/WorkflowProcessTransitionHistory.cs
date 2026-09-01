using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessTransitionHistory : DbObject<WorkflowProcessTransitionHistory>
    {
        public WorkflowProcessTransitionHistory() : base(true)
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
        public string ExecutorIdentityId
        {
            get => _entity.ExecutorIdentityId;
            set => _entity.ExecutorIdentityId = value;
        }

        [DbObjectModel]
        public string ActorIdentityId
        {
            get => _entity.ActorIdentityId;
            set => _entity.ActorIdentityId = value;
        }

        [DbObjectModel]
        public string FromActivityName
        {
            get => _entity.FromActivityName;
            set => _entity.FromActivityName = value;
        }

        [DbObjectModel]
        public string ToActivityName
        {
            get => _entity.ToActivityName;
            set => _entity.ToActivityName = value;
        }

        [DbObjectModel]
        public string ToStateName
        {
            get => _entity.ToStateName;
            set => _entity.ToStateName = value;
        }

        [DbObjectModel]
        public DateTime TransitionTime
        {
            get => _entity.TransitionTime;
            set => _entity.TransitionTime = value;
        }

        [DbObjectModel]
        public string TransitionClassifier
        {
            get => _entity.TransitionClassifier;
            set => _entity.TransitionClassifier = value;
        }

        [DbObjectModel]
        public bool IsFinalised
        {
            get => _entity.IsFinalised;
            set => _entity.IsFinalised = value;
        }

        [DbObjectModel]
        public string FromStateName
        {
            get => _entity.FromStateName;
            set => _entity.FromStateName = value;
        }

        [DbObjectModel]
        public string TriggerName
        {
            get => _entity.TriggerName;
            set => _entity.TriggerName = value;
        }

        public async static Task<List<WorkflowProcessTransitionHistory>> SelectByProcessId(Guid id)
        {
            var filter = Filter.And.Equal(id, "ProcessId");
            var items = await Model.GetAsync(filter);
            return items.Select(c => CreateByDynamicEntity(c)).ToList();
        }
    }
}