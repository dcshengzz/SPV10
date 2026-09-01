using swz.Clover.Core;
using swz.Clover.Core.ORM;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_ListSampleRespInfo : DbObject<vSP_ListSampleRespInfo>
    {
        public vSP_ListSampleRespInfo() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid PK { get => _entity.PK; set => _entity.PK = value; }

        [DbObjectModel]
        public Guid UserId { get => _entity.UserId; set => _entity.UserId = value; }

        [DbObjectModel]
        public Guid lsoId { get => _entity.lsoId; set => _entity.lsoId = value; }

        [DbObjectModel]
        public string Username { get => _entity.Username; set => _entity.Username = value; }

        [DbObjectModel]
        public string Segment { get => _entity.Segment; set => _entity.Segment = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid DplyId { get => _entity.DplyId; set => _entity.DplyId = value; }

        [DbObjectModel]
        public Guid ListSampleId { get => _entity.ListSampleId; set => _entity.ListSampleId = value; }

        [DbObjectModel]
        public string UID { get => _entity.UID; set => _entity.UID = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public string PeerName { get => _entity.PeerName; set => _entity.PeerName = value; }

        [DbObjectModel]
        public string StatusTitle { get => _entity.StatusTitle; set => _entity.StatusTitle = value; }

        [DbObjectModel]
        public string UIDPeer { get => _entity.UIDPeer; set => _entity.UIDPeer = value; }

        [DbObjectModel]
        public DateTime? DplyDateStart { get => _entity.DplyDateStart; set => _entity.DplyDateStart = value; }

        [DbObjectModel]
        public DateTime? DplyDateEnd { get => _entity.DplyDateEnd; set => _entity.DplyDateEnd = value; }

        [DbObjectModel]
        public DateTime? DueDate { get => _entity.DueDate; set => _entity.DueDate = value; }

        [DbObjectModel]
        public DateTime? RespDateStart { get => _entity.RespDateStart; set => _entity.RespDateStart = value; }

        [DbObjectModel]
        public Guid? StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public DateTime? RespDateEnd { get => _entity.RespDateEnd; set => _entity.RespDateEnd = value; }

        public static async Task<List<vSP_ListSampleRespInfo>> GetByDplyIdAndDplyListSampleInfoId(Guid dplyId, Guid dplyListSampleInfoId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .NestAnd().Equal(dplyListSampleInfoId, "PK");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

        public static async Task<List<vSP_ListSampleRespInfo>> GetByDplyIdAndUserId(Guid dplyId, List<Guid> userId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .NestAnd().In(userId, Constants.FieldName.UserId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

        public static async Task<List<vSP_ListSampleRespInfo>> GetByDplyIdOrderByUid(Guid dplyId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId);
            var order = Order.StartAsc(Constants.FieldName.UID);
            var result = await SelectAsync(filter, order).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

        public static async Task<List<vSP_ListSampleRespInfo>> GetByDplyIdAndUserIdOrderByUid(Guid dplyId, List<Guid> userId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .In(userId, Constants.FieldName.UserId);
            var order = Order.StartAsc(Constants.FieldName.UID);
            var result = await SelectAsync(filter, order).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}
