using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using swz.Clover.AuthServices.Jwt.Components.Entity;

namespace swz.Clover.AuthServices.Jwt.Data
{
    public interface IDataService
    {
        Task<PersistedToken> GetTokenById(string tokenId);
        Task<IList<PersistedToken>> GetUserTokens(Guid userId);
        Task AddToken(PersistedToken token);
        Task UpdateToken(PersistedToken token);
        Task DeleteToken(string tokenId);
        Task DeleteUserTokens(Guid userId);
        Task DeleteExpiredTokens();
    }
}
