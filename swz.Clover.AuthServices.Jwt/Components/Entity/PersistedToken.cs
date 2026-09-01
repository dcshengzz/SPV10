using System;

namespace swz.Clover.AuthServices.Jwt.Components.Entity
{
    [Serializable]
    public class PersistedToken
    {
        public string TokenId { get; set; }
        public Guid UserId { get; set; }
        public int? RenewCount { get; set; }
        public DateTime TokenExpiry { get; set; }
        public DateTime RenewalExpiry { get; set; }
        public string TokenHash { get; set; }
        public string RenewalHash { get; set; }

        public override string ToString()
        {
            return $"[{nameof(PersistedToken)} - {nameof(TokenId)}={TokenId}, {nameof(UserId)}={UserId}, {nameof(RenewCount)}={RenewCount}, {nameof(TokenExpiry)}={TokenExpiry}, {nameof(RenewalExpiry)}={RenewalExpiry}, {nameof(TokenHash)}={TokenHash}, {nameof(RenewalHash)}={RenewalHash}]";
        }
    }

}