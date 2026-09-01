using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using swz.Clover.Core;
using swz.Clover.Core.Security;
using System;
using System.Threading.Tasks;

namespace swz.Clover.AuthServices.Jwt.Services
{
    public static class TokenLoginHelper
    {
        /// <summary>
        /// Structure used for the Login to obtain a Json Web Token (JWT).
        /// </summary>
        [JsonObject]
        public struct LoginData
        {
            [JsonProperty("u")]
            public string Username;
            [JsonProperty("p")]
            public string Password;
        }

        /// <summary>
        /// Validates user login credentials and returns result when successful
        /// This method is used by 3PA, but not for respondent login
        /// </summary>
        public static async Task<LoginResultData> LoginUser(
            IJwtService jwtService, 
            HttpRequest request, 
            LoginData loginData, 
            bool remember = false)
        {

            ISecurityProvider_PasswordValidity validity
                = await CloverRuntime.Security.ValidateUserByLoginAsync(loginData.Username, loginData.Password);

            switch (validity)
            {
                case ISecurityProvider_PasswordValidity.Invalid:
                    return LoginResultData.EmptyWithError(IJwtServiceConstants.BadCredentials);

                case ISecurityProvider_PasswordValidity.Valid:
                    await CloverRuntime.Security.SignInAsync(loginData.Username, remember);
                    return await jwtService.GenerateUserTokens(loginData.Username);

                default:
                    throw new NotImplementedException($"Unsupported {nameof(ISecurityProvider_PasswordValidity)} = {validity}");
            }
        }
    }
}
