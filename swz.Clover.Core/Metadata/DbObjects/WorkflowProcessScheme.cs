using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class WorkflowProcessScheme : DbObject<WorkflowProcessScheme>
    {
        public WorkflowProcessScheme() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string Scheme
        {
            get => _entity.Scheme;
            set => _entity.Scheme = value;
        }

        [DbObjectModel]
        public string DefiningParameters
        {
            get => _entity.DefiningParameters;
            set => _entity.DefiningParameters = value;
        }

        [DbObjectModel]
        public string DefiningParametersHash
        {
            get => _entity.DefiningParametersHash;
            set => _entity.DefiningParametersHash = value;
        }

        [DbObjectModel]
        public string SchemeCode
        {
            get => _entity.SchemeCode;
            set => _entity.SchemeCode = value;
        }

        [DbObjectModel]
        public bool IsObsolete
        {
            get => _entity.IsObsolete;
            set => _entity.IsObsolete = value;
        }

        [DbObjectModel]
        public string RootSchemeCode
        {
            get => _entity.RootSchemeCode;
            set => _entity.RootSchemeCode = value;
        }

        [DbObjectModel]
        public Guid RootSchemeId
        {
            get => _entity.RootSchemeId;
            set => _entity.RootSchemeId = value;
        }

        [DbObjectModel]
        public string AllowedActivities
        {
            get => _entity.AllowedActivities;
            set => _entity.AllowedActivities = value;
        }

        [DbObjectModel]
        public string StartingTransition
        {
            get => _entity.StartingTransition;
            set => _entity.StartingTransition = value;
        }
    }
}