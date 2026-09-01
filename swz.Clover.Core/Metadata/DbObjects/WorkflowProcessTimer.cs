using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessTimer : DbObject<WorkflowProcessTimer>
    {
        public WorkflowProcessTimer() : base(true)
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
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public DateTime NextExecutionDateTime
        {
            get => _entity.NextExecutionDateTime;
            set => _entity.NextExecutionDateTime = value;
        }

        [DbObjectModel]
        public bool Ignore
        {
            get => _entity.Ignore;
            set => _entity.Ignore = value;
        }

        public async static Task<List<WorkflowProcessTimer>> SelectByProcessId(Guid id)
        {
            var filter = Filter.And.Equal(id, "ProcessId");
            var items = await Model.GetAsync(filter);
            return items.Select(c => CreateByDynamicEntity(c)).ToList();
        }
    }
}