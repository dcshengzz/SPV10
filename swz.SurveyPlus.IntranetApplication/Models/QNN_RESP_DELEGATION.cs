using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_RESP_DELEGATION : DbObject<QNN_RESP_DELEGATION>
    {
        public QNN_RESP_DELEGATION() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid DplyListSampleId { get => _entity.DplyListSampleId; set => _entity.DplyListSampleId = value; }

        [DbObjectModel]
        public string FromName { get => _entity.FromName; set => _entity.FromName = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public string Email { get => _entity.Email; set => _entity.Email = value; }

        [DbObjectModel]
        public string Comments { get => _entity.Comments; set => _entity.Comments = value; }

        [DbObjectModel]
        public DateTime ValidityStart { get => _entity.ValidityStart; set => _entity.ValidityStart = value; }

        [DbObjectModel]
        public DateTime ValidityEnd { get => _entity.ValidityEnd; set => _entity.ValidityEnd = value; }

        [DbObjectModel]
        public string AccessCode { get => _entity.AccessCode; set => _entity.AccessCode = value; }

        [DbObjectModel]
        public DateTime CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public DateTime? RevokedDate { get => _entity.RevokedDate; set => _entity.RevokedDate = value; }

        public static async Task<List<QNN_RESP_DELEGATION>> getByIds(List<Guid> ids)
        {
            var filter = Filter.And.In(ids, Constants.FieldName.Id);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}
