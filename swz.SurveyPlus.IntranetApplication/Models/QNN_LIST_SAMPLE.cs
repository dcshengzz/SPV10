using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{ 
    public class QNN_LIST_SAMPLE : DbObject<QNN_LIST_SAMPLE>
    {
        public QNN_LIST_SAMPLE() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid ListId { get => _entity.ListId; set => _entity.ListId = value; }

        [DbObjectModel]
        public bool ActiveYN { get => _entity.ActiveYN; set => _entity.ActiveYN = value; }

        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime? CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public Guid? UpdatedBy { get => _entity.UpdatedBy; set => _entity.UpdatedBy = value; }

        [DbObjectModel]
        public DateTime? UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }

        [DbObjectModel]
        public bool IsDeleted { get => _entity.IsDeleted; set => _entity.IsDeleted = value; }

        [DbObjectModel]
        public Guid? DeletedBy { get => _entity.DeletedBy; set => _entity.DeletedBy = value; }

        [DbObjectModel]
        public DateTime? DeletedDate { get => _entity.DeletedDate; set => _entity.DeletedDate = value; }

        [DbObjectModel]
        public Guid SampleId { get => _entity.SampleId; set => _entity.SampleId = value; }

        [DbObjectModel]
        public Guid? SamplePeerId { get => _entity.SamplePeerId; set => _entity.SamplePeerId = value; }



        public static async Task<QNN_LIST_SAMPLE> GetByListIdAndSampleId(Guid listId, Guid sampleId)
        {
            var filter = Filter.And.Equal(listId, Constants.FieldName.ListId).Equal(sampleId, Constants.FieldName.SampleId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

    }
}
