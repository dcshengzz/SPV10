using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using swz.Clover.AuthServices.Jwt.Components.Models;
using swz.Clover.Core;

namespace swz.Clover.AuthServices.Jwt.Data
{
    /// -----------------------------------------------------------------------------
    /// <summary>
    ///  This class provides the Data Access Layer for the JWT Authentication library
    /// </summary>
    public static class DataService
    {

        #region implementation

        public static async Task<PersistedToken> GetTokenById(string tokenId)
        {
            try
            {
                var resp = (await JsonWebTokens.SelectAsync(Filter.And
                        .Equal(tokenId, "TokenId")
                )).FirstOrDefault();

                if(resp==null) return null;

                return new PersistedToken()
                {
                    RenewCount = resp.RenewCount,
                    RenewalExpiry = resp.RenewalExpiry,
                    RenewalHash = resp.RenewalHash,
                    TokenId = resp.TokenId,
                    UserId = resp.UserId,
                    TokenExpiry = resp.TokenExpiry,
                    TokenHash = resp.TokenHash


                };

            }
            catch (InvalidCastException)
            {
                // occurs when no record found in th DB
                return null;
            }
        }
        
        public static async Task<IList<PersistedToken>> GetUserTokens(Guid userId)
        {
            var resp = await JsonWebTokens.SelectAsync(Filter.And
                .Equal(userId, "UserId")
            );

            if (resp == null || !resp.Any()) return null;

            return resp.Select(r=> new PersistedToken()
            {
                RenewCount = r.RenewCount,
                RenewalExpiry = r.RenewalExpiry,
                RenewalHash = r.RenewalHash,
                TokenId = r.TokenId,
                UserId = r.UserId,
                TokenExpiry = r.TokenExpiry,
                TokenHash = r.TokenHash

            }).ToList();
        }

        public static async Task AddToken(PersistedToken token)
        {
            //var jsonWebToken = new JsonWebTokens()
            //{
            //    RenewalExpiry = token.RenewalExpiry,
            //    RenewalHash = token.RenewalHash,
            //    TokenId = token.TokenId,
            //    UserId = token.UserId,
            //    TokenExpiry = token.TokenExpiry,
            //    TokenHash = token.TokenHash,
            //    CreatedOn = DateTime.Now,
            //    RenewCount = 0
            //};

            //await JsonWebTokens.ApplyAsync(jsonWebToken);

            var spParams = new Dictionary<string, object>
            {
                {"RenewalExpiry", token.RenewalExpiry},
                {"RenewalHash", token.RenewalHash},
                {"TokenId", token.TokenId},
                {"UserId", token.UserId},
                {"TokenExpiry", token.TokenExpiry},
                {"TokenHash", token.TokenHash}
            };
            await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("JsonWebTokens_Add", spParams,
                new Dictionary<string, object>());

        }

        public static async Task UpdateToken(PersistedToken token)
        {
            var spParams = new Dictionary<string, object>
            {
                {"TokenId", token.TokenId},
                {"TokenExpiry", token.TokenExpiry},
                {"TokenHash", token.TokenHash}
            };
            await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("JsonWebTokens_Update", spParams,
                new Dictionary<string, object>());

            //var resp = (await JsonWebTokens.SelectAsync(Filter.And
            //    .Equal(token.TokenId, "TokenId")
            //)).FirstOrDefault();

            //if (resp != null)
            //{
            //    resp.StartTracking();
            //    resp.TokenExpiry = token.TokenExpiry;
            //    resp.TokenHash = token.TokenHash;
            //    await resp.ApplyAsync();
            //}
        }

        public static async Task DeleteToken(string tokenId)
        {
            var spParams = new Dictionary<string, object>
            {
                {"TokenId", tokenId}
            };
            await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("JsonWebTokens_DeleteById", spParams,
                new Dictionary<string, object>());

            //var resp = (await JsonWebTokens.SelectAsync(Filter.And
            //    .Equal(tokenId, "TokenId")
            //)).FirstOrDefault();

            //if (resp != null)
            //{
            //    await resp.DeleteAsync();
            //}

        }

        public static async Task DeleteUserTokens(Guid userId)
        {
            var spParams = new Dictionary<string, object>
            {
                {"UserId", userId}
            };
            await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync("JsonWebTokens_DeleteByUser", spParams,
                new Dictionary<string, object>());
        }

        public static async Task DeleteExpiredTokens()
        {
            await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                "JsonWebTokens_DeleteExpired",
                new Dictionary<string, object>(),
                new Dictionary<string, object>());
        }

        #endregion

    }
}