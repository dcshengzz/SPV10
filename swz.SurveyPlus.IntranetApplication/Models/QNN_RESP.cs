using System;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_RESP : DbObject<QNN_RESP>
    {
        public QNN_RESP() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid? DplyId { get => _entity.DplyId; set => _entity.DplyId = value; }

        [DbObjectModel]
        public Guid? QnnId { get => _entity.QnnId; set => _entity.QnnId = value; }

        [DbObjectModel]
        public Guid? ListSampleId { get => _entity.ListSampleId; set => _entity.ListSampleId = value; }

        [DbObjectModel]
        public int Score { get => _entity.Score; set => _entity.Score = value; }

        [DbObjectModel]
        public int TimeTook { get => _entity.TimeTook; set => _entity.TimeTook = value; }

        [DbObjectModel]
        public DateTime? DateStart { get => _entity.DateStart; set => _entity.DateStart = value; }

        [DbObjectModel]
        public DateTime? DateComplete { get => _entity.DateComplete; set => _entity.DateComplete = value; }

        [DbObjectModel]
        public DateTime? UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }

        [DbObjectModel]
        public bool? IsPrePopulated { get => _entity.IsPrePopulated; set => _entity.IsPrePopulated = value; }

        [DbObjectModel]
        public string LastSavedPage { get => _entity.LastSavedPage; set => _entity.LastSavedPage = value; }

        [DbObjectModel]
        public Guid? AnonymousId { get => _entity.AnonymousId; set => _entity.AnonymousId = value; }

        [DbObjectModel]
        public string IpAddress { get => _entity.IpAddress; set => _entity.IpAddress = value; }

        [DbObjectModel]
        public bool IsExcelResponse { get => _entity.IsExcelResponse; set => _entity.IsExcelResponse = value; }

        [DbObjectModel]
        public string ExcelToken { get => _entity.ExcelToken; set => _entity.ExcelToken = value; }

        [DbObjectModel]
        public DateTime ExcelUploadDate { get => _entity.ExcelUploadDate; set => _entity.ExcelUploadDate = value; }

        [DbObjectModel]
        public bool IsExcelResponseDE { get => _entity.IsExcelResponseDE; set => _entity.IsExcelResponseDE = value; }

        [DbObjectModel]
        public string InitialResponseAs { get => _entity.InitialResponseAs; set => _entity.InitialResponseAs = value; }

        [DbObjectModel]
        public string InitialResponseBy { get => _entity.InitialResponseBy; set => _entity.InitialResponseBy = value; }

        [DbObjectModel]
        public string InitialResponseVia { get => _entity.InitialResponseVia; set => _entity.InitialResponseVia = value; }

        [DbObjectModel]
        public Guid? InitialResponseUserId { get => _entity.InitialResponseUserId; set => _entity.InitialResponseUserId = value; }

        [DbObjectModel]
        public string LastResponseAs { get => _entity.LastResponseAs; set => _entity.LastResponseAs = value; }

        [DbObjectModel]
        public string LastResponseBy { get => _entity.LastResponseBy; set => _entity.LastResponseBy = value; }

        [DbObjectModel]
        public string LastResponseVia { get => _entity.LastResponseVia; set => _entity.LastResponseVia = value; }

        [DbObjectModel]
        public Guid? UserId { get => _entity.UserId; set => _entity.UserId = value; }

        [DbObjectModel]
        public string CompletedResponseAs { get => _entity.CompletedResponseAs; set => _entity.CompletedResponseAs = value; }

        [DbObjectModel]
        public string CompletedResponseBy { get => _entity.CompletedResponseBy; set => _entity.CompletedResponseBy = value; }

        [DbObjectModel]
        public string CompletedResponseVia { get => _entity.CompletedResponseVia; set => _entity.CompletedResponseVia = value; }

        [DbObjectModel]
        public Guid? CompletedResponseUserId { get => _entity.CompletedResponseUserId; set => _entity.CompletedResponseUserId = value; }

        public static async Task<QNN_RESP> GetByDplyIdQnnIdListSampleId(Guid dplyId, Guid qnnId, Guid listSampleId)
        {
            var filter = Filter.And
                .Equal(dplyId, Constants.FieldName.DplyId)
                .Equal(qnnId, Constants.FieldName.QnnId)
                .Equal(listSampleId, Constants.FieldName.ListSampleId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }


    }
}