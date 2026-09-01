using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Data;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_DPLY_SAMPLE_OWNER : DbObject<QNN_DPLY_SAMPLE_OWNER>
    {
        public QNN_DPLY_SAMPLE_OWNER() : base(true)
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
        public Guid UserId { get => _entity.UserId; set => _entity.UserId = value; }

        public static string GetTableName()
        {
            return Constants.ModelName.QNN_DPLY_SAMPLE_OWNER;
        }

        /// <summary>
        /// To get the data column for insert with
        /// Id, DplyId, ListSampleId, UserId
        /// skip auto increament NumberId column
        /// </summary>
        /// <returns></returns>
        public static DataColumn[] GetDataColumn()
        {
            List<DataColumn> dataColumn = new List<DataColumn>()
            {
                new DataColumn(Constants.FieldName.Id, typeof(Guid)),
                new DataColumn(Constants.FieldName.DplyId, typeof(Guid)),
                new DataColumn(Constants.FieldName.ListSampleId, typeof(Guid)),
                new DataColumn(Constants.FieldName.UserId, typeof(Guid)),
            };

            return dataColumn.ToArray();
        }

        public static async Task<List<QNN_DPLY_SAMPLE_OWNER>> GetByDplyIdAndUserId(Guid dplyId, Guid userId)
        {
            var filter = Filter.And.Equal(dplyId, Constants.FieldName.DplyId)
                .Equal(userId, Constants.FieldName.UserId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
        
        public static async Task<List<QNN_DPLY_SAMPLE_OWNER>> GetById(List<Guid> id)
        {
            var filter = Filter.And.In(id, Constants.FieldName.Id);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
        }
    }
}
