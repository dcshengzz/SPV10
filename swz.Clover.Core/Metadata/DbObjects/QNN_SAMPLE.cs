using System;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

//TODO - why is this SurveyPlus-specific class here in core?
namespace swz.Clover.Core.Metadata.DbObjects
{
    public class QNN_SAMPLE : DbObject<QNN_SAMPLE>
    {
        public QNN_SAMPLE() : base(true)
        {
        }
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }
        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }
        [DbObjectModel]
        public bool ActiveYN { get => _entity.ActiveYN; set => _entity.ActiveYN = value; }
        [DbObjectModel]
        public string UID { get => _entity.UID; set => _entity.UID = value; }
        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }
        [DbObjectModel]
        public bool PwdResetYN { get => _entity.PwdResetYN; set => _entity.PwdResetYN = value; }
        [DbObjectModel]
        public string Pwd { get => _entity.Pwd; set => _entity.Pwd = value; }
        [DbObjectModel]
        public int NumRetry { get => _entity.NumRetry; set => _entity.NumRetry = value; }
        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }
        [DbObjectModel]
        public DateTime? CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }
        [DbObjectModel]
        public Guid? UpdatedBy { get => _entity.UpdatedBy; set => _entity.UpdatedBy = value; }
        [DbObjectModel]
        public DateTime? UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }
        [DbObjectModel]
        public DateTime? SelfUpdatedDate { get => _entity.SelfUpdatedDate; set => _entity.SelfUpdatedDate = value; }

        [Obsolete]
        [DbObjectModel]
        public bool IsDeleted { get => _entity.IsDeleted; set => _entity.IsDeleted = value; }

        [Obsolete]
        [DbObjectModel]
        public Guid? DeletedBy { get => _entity.DeletedBy; set => _entity.DeletedBy = value; }

        [Obsolete]
        [DbObjectModel]
        public DateTime? DeletedDate { get => _entity.DeletedDate; set => _entity.DeletedDate = value; }

        [DbObjectModel]
        public string PwdResetToken { get => _entity.PwdResetToken; set => _entity.PwdResetToken = value; }
        [DbObjectModel]
        public DateTime? LastLoginDate { get => _entity.LastLoginDate; set => _entity.LastLoginDate = value; }


        public static async Task<QNN_SAMPLE> GetByUId(string uId)
        {
            var filter = Filter.And.Equal(uId, "UID");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }
    }

}