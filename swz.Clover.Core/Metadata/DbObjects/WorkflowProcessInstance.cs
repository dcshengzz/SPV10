using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessInstance : DbObject<WorkflowProcessInstance>
    {
        public WorkflowProcessInstance() : base(true)
        {
        }
        
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string StateName
        {
            get => _entity.StateName;
            set => _entity.StateName = value;
        }

        [DbObjectModel]
        public string ActivityName
        {
            get => _entity.ActivityName;
            set => _entity.ActivityName = value;
        }

        [DbObjectModel]
        public Guid SchemeId
        {
            get => _entity.SchemeId;
            set => _entity.SchemeId = value;
        }

        [DbObjectModel(TableType = typeof(WorkflowProcessScheme), ParentPropertyName = "SchemeId", ColumnName = "SchemeCode")]
        public string SchemeCode
        {
            get => _entity.SchemeCode;
            set => _entity.SchemeCode = value;
        }

        [DbObjectModel]
        public string PreviousState
        {
            get => _entity.PreviousState;
            set => _entity.PreviousState = value;
        }

        [DbObjectModel]
        public string PreviousStateForDirect
        {
            get => _entity.PreviousStateForDirect;
            set => _entity.PreviousStateForDirect = value;
        }

        [DbObjectModel]
        public string PreviousStateForReverse
        {
            get => _entity.PreviousStateForReverse;
            set => _entity.PreviousStateForReverse = value;
        }

        [DbObjectModel]
        public string PreviousActivity
        {
            get => _entity.PreviousActivity;
            set => _entity.PreviousActivity = value;
        }

        [DbObjectModel]
        public string PreviousActivityForDirect
        {
            get => _entity.PreviousActivityForDirect;
            set => _entity.PreviousActivityForDirect = value;
        }

        [DbObjectModel]
        public string PreviousActivityForReverse
        {
            get => _entity.PreviousActivityForReverse;
            set => _entity.PreviousActivityForReverse = value;
        }

        [DbObjectModel]
        public Guid? ParentProcessId
        {
            get => _entity.ParentProcessId;
            set => _entity.ParentProcessId = value;
        }

        [DbObjectModel]
        public Guid? RootProcessId
        {
            get => _entity.RootProcessId;
            set => _entity.RootProcessId = value;
        }

        [DbObjectModel]
        public bool IsDeterminingParametersChanged
        {
            get => _entity.IsDeterminingParametersChanged;
            set => _entity.IsDeterminingParametersChanged = value;
        }

        [DbObjectModel(TableType = typeof(WorkflowProcessInstanceStatus), ParentPropertyName = "Id", ColumnName = "Status")]
        public byte InstanceStatus
        {
            get => _entity.InstanceStatus;
            set => _entity.InstanceStatus = value;
        }

        public async static Task<List<WorkflowProcessInstance>> SelectByParentProcessId(Guid id)
        {
            var filter = Filter.And.Equal(id, "ParentProcessId");
            var items = await Model.GetAsync(filter);
            return items.Select(c => CreateByDynamicEntity(c)).ToList();
        }
    }
}