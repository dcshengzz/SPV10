using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowScheme : DbObject<WorkflowScheme>
    {
        public WorkflowScheme() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public string Code
        {
            get => _entity.Code;
            set => _entity.Code = value;
        }

        [DbObjectModel]
        public string Scheme
        {
            get => _entity.Scheme;
            set => _entity.Scheme = value;
        }
    }
}