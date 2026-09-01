using swz.SurveyPlus.Application;
using System.Collections.Generic;

namespace swz.MockNetrust
{
    public interface IMockNetrustService
    {
        string createNewToken(string nonce, string UEN);
        SPCPToken getToken(string code);
    }

    public class MockNetrustService : IMockNetrustService
    {
        private static List<NetrustToken> tokenCache = new List<NetrustToken>();

        /// <summary>
        /// Create a new Netrust token that looks like one we would expect from Netrust
        /// Nonce is from user query
        /// MockCPEntId is from app settings
        /// 1. Create the Token 
        /// 2. Store the Token
        /// 3. Return a code which is used to backend exchange of UserInfo
        /// </summary>
        /// <returns>code of the token</returns>
        public string createNewToken(string nonce, string MockCPEntID)
        {
            NetrustToken token = new NetrustToken();

            token.token.id_token_value.nonce = nonce ?? "";
            token.token.id_token_value.entityInfo.CPEntID = MockCPEntID ?? "";

            token.code = EncryptionHelper.RandomAlphanumericString(16);
            storeToken(token);

            return token.code;
        }

        private void storeToken(NetrustToken token)
        {
            tokenCache.Add(token);
        }

        /// <summary>
        /// Get Token by code
        /// </summary>
        /// <param name="code">code for exchange token</param>
        /// <returns>SPCP Token</returns>
        public SPCPToken getToken(string code)
        {
            NetrustToken token = tokenCache.Find(e => e.code == code);
            if(token != null)
            {
                tokenCache.Remove(token);
                return token.token;
            }
            return null;
        }

    }
}
