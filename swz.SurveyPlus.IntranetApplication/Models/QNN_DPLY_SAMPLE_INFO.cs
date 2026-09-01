using swz.Clover.Core.ORM;
using System;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_DPLY_SAMPLE_INFO : DbObject<QNN_DPLY_SAMPLE_INFO>
    {
        public QNN_DPLY_SAMPLE_INFO() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid DplyId { get => _entity.DplyId; set => _entity.DplyId = value; }

        [DbObjectModel]
        public Guid ListSampleId { get => _entity.ListSampleId; set => _entity.ListSampleId = value; }

        [DbObjectModel]
        public string Remarks { get => _entity.Remarks; set => _entity.Remarks = value; }

        [DbObjectModel]
        public Guid? StatusModifyBy { get => _entity.StatusModifyBy; set => _entity.StatusModifyBy = value; }

        [DbObjectModel]
        public DateTime? StatusModifyOn { get => _entity.StatusModifyOn; set => _entity.StatusModifyOn = value; }

        [DbObjectModel]
        public Guid? RemarksModifyBy { get => _entity.RemarksModifyBy; set => _entity.RemarksModifyBy = value; }

        [DbObjectModel]
        public DateTime? RemarksModifyOn { get => _entity.RemarksModifyOn; set => _entity.RemarksModifyOn = value; }

        [DbObjectModel]
        public string DispatchInd { get => _entity.DispatchInd; set => _entity.DispatchInd = value; }

        [DbObjectModel]
        public string ReturnInd { get => _entity.ReturnInd; set => _entity.ReturnInd = value; }

        [DbObjectModel]
        public string ProcessValidInd { get => _entity.ProcessValidInd; set => _entity.ProcessValidInd = value; }

        [DbObjectModel]
        public string ProcessEditInd { get => _entity.ProcessEditInd; set => _entity.ProcessEditInd = value; }

        [DbObjectModel]
        public Guid Status { get => _entity.Status; set => _entity.Status = value; }

        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public string DelegationCode { get => _entity.DelegationCode; set => _entity.DelegationCode = value; }

        [DbObjectModel]
        public int DelegationAccessFailAttempt { get => _entity.DelegationAccessFailAttempt; set => _entity.DelegationAccessFailAttempt = value; }
    }
}
