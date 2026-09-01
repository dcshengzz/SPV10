using System;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class SecurityUserState : DbObject<SecurityUserState>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid SecurityUserId { get => _entity.SecurityUserId; set => _entity.SecurityUserId = value; }

        [DbObjectModel]
        public string Key { get => _entity.Key; set => _entity.Key = value; }

        [DbObjectModel]
        public string Value { get => _entity.Value; set => _entity.Value = value; }

        public static async Task<SecurityUserState> SelectByUser(Guid userId, string urlkey)
        {
            var filter = Filter.And.Equal(userId, "SecurityUserId").Equal(urlkey, "Key");
            return (await SelectAsync(filter).ConfigureAwait(false)).FirstOrDefault();
        }
    }
}