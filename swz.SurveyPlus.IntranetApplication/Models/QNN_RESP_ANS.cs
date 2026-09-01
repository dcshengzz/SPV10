using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_RESP_ANS : DbObject<QNN_RESP_ANS>
    {
        public QNN_RESP_ANS() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid RespId { get => _entity.RespId; set => _entity.RespId = value; }

        [DbObjectModel]
        public Guid QnnFieldId { get => _entity.QnnFieldId; set => _entity.QnnFieldId = value; }

        [DbObjectModel]
        public string AnsVal { get => _entity.AnsVal; set => _entity.AnsVal = value; }

        public static async Task<List<QNN_RESP_ANS>> GetByRespId(Guid respId)
        {
            var filter = Filter.And.Equal(respId, Constants.FieldName.RespId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}