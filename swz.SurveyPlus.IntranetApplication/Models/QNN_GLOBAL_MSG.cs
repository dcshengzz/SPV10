using swz.Clover.Core.ORM;
using System;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_GLOBAL_MSG : DbObject<QNN_GLOBAL_MSG>
    {
        public QNN_GLOBAL_MSG() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public string MsgContent { get => _entity.MsgContent; set => _entity.MsgContent = value; }

        [DbObjectModel]
        public string EmailSubj { get => _entity.EmailSubj; set => _entity.EmailSubj = value; }

        [DbObjectModel]
        public string EmailFrom { get => _entity.EmailFrom; set => _entity.EmailFrom = value; }

        [DbObjectModel]
        public string EmailCC { get => _entity.EmailCC; set => _entity.EmailCC = value; }

        [DbObjectModel]
        public string EmailBCC { get => _entity.EmailBCC; set => _entity.EmailBCC = value; }

        [DbObjectModel]
        public Guid CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public Guid UpdatedBy { get => _entity.UpdatedBy; set => _entity.UpdatedBy = value; }

        [DbObjectModel]
        public DateTime UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }

        [DbObjectModel]
        public Guid? StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public DateTime? ScheduledDate { get => _entity.ScheduledDate; set => _entity.ScheduledDate = value; }

        [DbObjectModel]
        public string JobId { get => _entity.JobId; set => _entity.JobId = value; }

        [DbObjectModel]
        public bool? JobIsCanceled { get => _entity.JobIsCanceled; set => _entity.JobIsCanceled = value; }

        [DbObjectModel]
        public bool? IsTargetUsers { get => _entity.IsTargetUsers; set => _entity.IsTargetUsers = value; }

    }
}
