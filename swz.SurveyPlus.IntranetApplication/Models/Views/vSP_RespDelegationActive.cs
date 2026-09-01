using swz.Clover.Core;
using swz.Clover.Core.ORM;
using System;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_RespDelegationActive : DbObject<vSP_RespDelegationActive>
    {
        public vSP_RespDelegationActive() : base(true)
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

        [DbObjectModel]
        public int RowNumber { get => _entity.RowNumber; set => _entity.RowNumber = value; }


        /// <summary>
        /// This view return first row only, This is active delegation
        /// </summary>
        /// <param name="dplyListSampleId"></param>
        /// <returns></returns>
        public static async Task<vSP_RespDelegationActive> GetByDplyListSampleId(Guid dplyListSampleId)
        {
            var filter = Filter.And.Equal(dplyListSampleId, Constants.FieldName.DplyListSampleId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }
    }
}
