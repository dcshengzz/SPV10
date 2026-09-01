using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD : DbObject<QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD>
    {
        public QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid DplyId { get => _entity.DplyId; set => _entity.DplyId = value; }

        [DbObjectModel]
        public Guid QnnFieldId { get => _entity.QnnFieldId; set => _entity.QnnFieldId = value; }

        public static async Task<List<QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD>> GetByDplyId(Guid dplyId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

        public static async Task<QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD> GetByDplyIdAndQnnFieldId(Guid dplyId, Guid qnnFieldId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId).Equal(qnnFieldId, Constants.FieldName.QnnFieldId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

        public static async Task<List<QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD>> GetByDplyIdAndQnnFieldId(Guid dplyId, List<Guid> qnnFieldId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId).In(qnnFieldId, Constants.FieldName.QnnFieldId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

    }
}
