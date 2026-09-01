namespace swz.Clover.SPCP.OIDC
{
    /// <summary>
    /// SPCP Token return by the Netrust
    /// </summary>
    public class IMDAToken
    {
        public IdTokenValue id_token_value { get; set; }

        public class EntityInfo
        {
            public string CPEntID { get; set; }
        }

        public class IdTokenValue
        {
            public EntityInfo entityInfo { get; set; }
            public string nonce { get; set; }
        }
    }

    /// <summary>
    /// SPCP Token return by Crimson Logic
    /// </summary>
    public class EMAToken
    {
        public bool? status { get; set; }
        public Attributes attributes { get; set; }

        public class Attributes
        {
            public UserInfo UserInfo { get; set; }
        }

        public class UserInfo
        {
            public string CPEntID { get; set; }
        }

    }
}
