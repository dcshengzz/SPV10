using swz.Clover.Core;
using swz.Clover.Core.ORM;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_ListSampleInfoResp : DbObject<vSP_ListSampleInfoResp>
    {
        public vSP_ListSampleInfoResp() : base(true)
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
        public string Segment { get => _entity.Segment; set => _entity.Segment = value; }

        [DbObjectModel]
        public string Remarks { get => _entity.Remarks; set => _entity.Remarks = value; }

        [DbObjectModel]
        public Guid? StatusModifyBy { get => _entity.StatusModifyBy; set => _entity.StatusModifyBy = value; }

        [DbObjectModel]
        public DateTime? StatusModifyOn { get => _entity.StatusModifyOn; set => _entity.StatusModifyOn = value; }

        [DbObjectModel]
        public Guid? RemarksModifyBy { get => _entity.StatusModifyBy; set => _entity.StatusModifyBy = value; }

        [DbObjectModel]
        public DateTime? RemarksModifyOn { get => _entity.StatusModifyOn; set => _entity.StatusModifyOn = value; }

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
        public string StatusTitle { get => _entity.StatusTitle; set => _entity.StatusTitle = value; }

        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime? CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public string UID { get => _entity.UID; set => _entity.UID = value; }

        [DbObjectModel]
        public Guid SampleId { get => _entity.SampleId; set => _entity.SampleId = value; }

        [DbObjectModel]
        public string UIDName { get => _entity.UIDName; set => _entity.UIDName = value; }

        [DbObjectModel]
        public string PeerName { get => _entity.PeerName; set => _entity.PeerName = value; }

        [DbObjectModel]
        public string FormNames { get => _entity.FormNames; set => _entity.FormNames = value; }

        [DbObjectModel]
        public string Languages { get => _entity.Languages; set => _entity.Languages = value; }

        [DbObjectModel]
        public string FileNames { get => _entity.FileNames; set => _entity.FileNames = value; }

        [DbObjectModel]
        public string FileLanguages { get => _entity.FileLanguages; set => _entity.FileLanguages = value; }

        [DbObjectModel]
        public string FileTokens { get => _entity.FileTokens; set => _entity.FileTokens = value; }

        [DbObjectModel]
        public string UIDPeer { get => _entity.UIDPeer; set => _entity.UIDPeer = value; }

        [DbObjectModel]
        public DateTime? DplyCreatedDate { get => _entity.DplyCreatedDate; set => _entity.DplyCreatedDate = value; }

        [DbObjectModel]
        public string DplyName { get => _entity.DplyName; set => _entity.DplyName = value; }

        [DbObjectModel]
        public string IpCountry { get => _entity.IpCountry; set => _entity.IpCountry = value; }

        [DbObjectModel]
        public bool RestrictIp { get => _entity.RestrictIp; set => _entity.RestrictIp = value; }

        [DbObjectModel]
        public bool RestrictIpInclusive { get => _entity.RestrictIpInclusive; set => _entity.RestrictIpInclusive = value; }

        [DbObjectModel]
        public string IpRange { get => _entity.IpRange; set => _entity.IpRange = value; }

        [DbObjectModel]
        public DateTime? DplyDateStart { get => _entity.DplyDateStart; set => _entity.DplyDateStart = value; }

        [DbObjectModel]
        public DateTime? DplyDateEnd { get => _entity.DplyDateEnd; set => _entity.DplyDateEnd = value; }

        [DbObjectModel]
        public Guid QnnId { get => _entity.QnnId; set => _entity.QnnId = value; }

        [DbObjectModel]
        public bool DplyIsDeleted { get => _entity.DplyIsDeleted; set => _entity.DplyIsDeleted = value; }

        [DbObjectModel]
        public bool DplyStatus { get => _entity.DplyStatus; set => _entity.DplyStatus = value; }

        [DbObjectModel]
        public string DplyWorkflowState { get => _entity.DplyWorkflowState; set => _entity.DplyWorkflowState = value; }

        [DbObjectModel]
        public char CompleteAction { get => _entity.CompleteAction; set => _entity.CompleteAction = value; }

        [DbObjectModel]
        public string CompleteURL { get => _entity.CompleteURL; set => _entity.CompleteURL = value; }

        [DbObjectModel]
        public int DaysUpdate { get => _entity.DaysUpdate; set => _entity.DaysUpdate = value; }

        [DbObjectModel]
        public int MaxResponse { get => _entity.MaxResponse; set => _entity.MaxResponse = value; }

        [DbObjectModel]
        public bool VisibleToRespondent { get => _entity.VisibleToRespondent; set => _entity.VisibleToRespondent = value; }

        [DbObjectModel]
        public bool IsAnonymous { get => _entity.IsAnonymous; set => _entity.IsAnonymous = value; }

        [DbObjectModel]
        public bool IsMultipleResponse { get => _entity.IsMultipleResponse; set => _entity.IsMultipleResponse = value; }

        [DbObjectModel]
        public DateTime? DueDate { get => _entity.DueDate; set => _entity.DueDate = value; }

        [DbObjectModel]
        public string QnnTitle { get => _entity.QnnTitle; set => _entity.QnnTitle = value; }

        [DbObjectModel]
        public bool QnnIsDeleted { get => _entity.QnnIsDeleted; set => _entity.QnnIsDeleted = value; }

        [DbObjectModel]
        public bool QnnStatus { get => _entity.QnnStatus; set => _entity.QnnStatus = value; }

        [DbObjectModel]
        public char QnnType { get => _entity.QnnType; set => _entity.QnnType = value; }

        [DbObjectModel]
        public string Type { get => _entity.Type; set => _entity.Type = value; }

        [DbObjectModel]
        public Guid ListId { get => _entity.ListId; set => _entity.ListId = value; }

        [DbObjectModel]
        public Guid? RespId { get => _entity.RespId; set => _entity.RespId = value; }

        [DbObjectModel]
        public DateTime? RespDateStart { get => _entity.RespDateStart; set => _entity.RespDateStart = value; }

        [DbObjectModel]
        public Guid? StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public DateTime? RespDateEnd { get => _entity.RespDateEnd; set => _entity.RespDateEnd = value; }

        [DbObjectModel]
        public DateTime? RespDateUpdate { get => _entity.RespDateUpdate; set => _entity.RespDateUpdate = value; }

        [DbObjectModel]
        public bool IsExcelEnabled { get => _entity.IsExcelEnabled; set => _entity.IsExcelEnabled = value; }

        [DbObjectModel]
        public bool? IsExcelResponse { get => _entity.IsExcelResponse; set => _entity.IsExcelResponse = value; }

        [DbObjectModel]
        public bool? IsPrePopulated { get => _entity.IsPrePopulated; set => _entity.IsPrePopulated = value; }

        [DbObjectModel]
        public bool RequireAccessCode { get => _entity.RequireAccessCode; set => _entity.RequireAccessCode = value; }

        [DbObjectModel]
        public bool? ListSampleRecordActiveYN { get => _entity.ListSampleRecordActiveYN; set => _entity.ListSampleRecordActiveYN = value; }

        [DbObjectModel]
        public int TotalComplete { get => _entity.TotalComplete; set => _entity.TotalComplete = value; }

        [DbObjectModel]
        public string sampleEmails { get => _entity.sampleEmails; set => _entity.sampleEmails = value; }

        public static async Task<vSP_ListSampleInfoResp> GetByDplyIdAndId(Guid dplyId, Guid id)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .NestAnd().Equal(id, Constants.FieldName.Id);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

        public static async Task<List<vSP_ListSampleInfoResp>> GetByDplyIdAndUid(Guid dplyId, List<string> uid)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .In(uid, Constants.FieldName.UID);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}
