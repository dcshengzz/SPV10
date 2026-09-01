using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class QNN_GLOBAL_MSG_USER : DbObject<QNN_GLOBAL_MSG_USER>
    {
        public QNN_GLOBAL_MSG_USER() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public Guid GlobalMsgId { get => _entity.GlobalMsgId; set => _entity.GlobalMsgId = value; }

        [DbObjectModel]
        public Guid UserId { get => _entity.UserId; set => _entity.UserId = value; }

        [DbObjectModel]
        public DateTime CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public DateTime? EmailSentDate { get => _entity.EmailSentDate; set => _entity.EmailSentDate = value; }


        public static async Task<QNN_GLOBAL_MSG_USER> GetByGlobalMsgIdAndUserId(Guid globalMsgId, Guid userId)
        {
            var filter = Filter.And.Equal(globalMsgId, Constants.FieldName.GlobalMsgId).Equal(userId, Constants.FieldName.UserId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

    }
}
