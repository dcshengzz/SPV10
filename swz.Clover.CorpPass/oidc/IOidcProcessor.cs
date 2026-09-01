using System.Threading.Tasks;

namespace swz.Clover.SPCP.OIDC
{
    /// <summary>
    /// Implementations of IOidcProcessor assist in the processing of OIDC artifacts etc.
    /// They are now required to be threadsafe. 
    /// (Later changes may see a shared instance injected into RespController rather than new instances created each request)
    /// </summary>
    public interface IOidcProcessor
    {
        Task<string> GetAccessToken(string code);
        Task<string> ProcessAccessToken(string accessToken, string nonce);
    }
}