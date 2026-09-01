using System;
using swz.Clover.Core.ORM;

namespace swz.Clover.AuthServices.Jwt.Components.Models
{

    public class JsonWebTokens : DbObject<JsonWebTokens>
    {
        public JsonWebTokens() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public string TokenId { get => _entity.TokenId; set => _entity.TokenId = value; }
        [DbObjectModel]
        public Guid UserId { get => _entity.UserId; set => _entity.UserId = value; }
        [DbObjectModel]
        public DateTime? CreatedOn { get => _entity.CreatedOn; set => _entity.CreatedOn = value; }
        [DbObjectModel]
        public int? RenewCount { get => _entity.RenewCount; set => _entity.RenewCount = value; }
        [DbObjectModel]
        public DateTime TokenExpiry { get => _entity.TokenExpiry; set => _entity.TokenExpiry = value; }
        [DbObjectModel]
        public DateTime RenewalExpiry { get => _entity.RenewalExpiry; set => _entity.RenewalExpiry = value; }
        [DbObjectModel]
        public string TokenHash { get => _entity.TokenHash; set => _entity.TokenHash = value; }
        [DbObjectModel]
        public string RenewalHash { get => _entity.RenewalHash; set => _entity.RenewalHash = value; }

    }
}