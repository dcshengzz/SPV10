using swz.Clover.Core;
using swz.Clover.Core.ORM;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_RespDelegationGrid : DbObject<vSP_RespDelegationGrid>
    {
        public vSP_RespDelegationGrid() : base(true)
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
        public string Status { get => _entity.Status; set => _entity.Status = value; }


        /// <summary>
        /// This view return single active delegation
        /// WARNING : this method will always return null rather than en empty list when there are no delegations for specified dlsi
        /// </summary>
        /// <param name="dplyListSampleId">dlsi</param>
        /// <returns>null or list</returns>
        public static async Task<List<vSP_RespDelegationGrid>> GetByDplyListSampleId(Guid dplyListSampleId)
        {
            var filter = Filter.And.Equal(dplyListSampleId, Constants.FieldName.DplyListSampleId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }

        /// <summary>
        /// WARNING : this method will always return null rather than en empty list when there are no delegations for specified dlsi
        /// </summary>
        /// <param name="dplyListSampleId">dlsi</param>
        /// <param name="status"></param>
        /// <returns>null or list</returns>
        public static async Task<List<vSP_RespDelegationGrid>> GetByDplyListSampleIdAndStatus(Guid dplyListSampleId, List<string> status)
        {
            var filter = Filter.And.Equal(dplyListSampleId, Constants.FieldName.DplyListSampleId).In(status, Constants.FieldName.Status);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}
