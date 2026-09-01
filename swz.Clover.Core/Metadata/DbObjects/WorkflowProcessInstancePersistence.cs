using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessInstancePersistence : DbObject<WorkflowProcessInstancePersistence>
    {
        public WorkflowProcessInstancePersistence() : base(true)
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
        public string ParameterName
        {
            get => _entity.ParameterName;
            set => _entity.ParameterName = value;
        }

        [DbObjectModel]
        public string Value
        {
            get => _entity.Value;
            set => _entity.Value = value;
        }

        public async static Task<List<WorkflowProcessInstancePersistence>> SelectByProcessId(Guid id)
        {
            var filter = Filter.And.Equal(id, "ProcessId");
            var items = await Model.GetAsync(filter);
            return items.Select(c => CreateByDynamicEntity(c)).ToList();
        }
    }
}