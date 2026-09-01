using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.JsonWebTokens;
using System.Linq;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.AuthServices.Jwt.Data;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Metadata.DbObjects;
using Microsoft.IdentityModel.Tokens;
using swz.Clover.Core.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Security.Cryptography;

namespace swz.Clover.AuthServices.Jwt.Services
{
    //This class was previously named JwtController -20250503
    public class JwtService : IJwtService
    {
        //NOTE: this service will be registered as a singleton, do not keep any mutable state that is not thread-safe

        private const string SigningAlgorithm = SecurityAlgorithms.HmacSha256;
        private const string JwtSchemeType = "JWT"; //required 'typ' claim, oddly seems there's no standard constant for this!
        private const int ClockSkewMinutes = 5;
        private const string SessionClaimType = "sessionid";
        private const string RespondentRole = "Respondent";

        private readonly ILogger<JwtService> logger;
        private readonly ISigningKeySupplier keys;

        public JwtService(
            ILogger<JwtService> logger,
            ISigningKeySupplier keySupplier)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.keys = keySupplier ?? throw new ArgumentNullException(nameof(keySupplier));
        }

        /// <summary>
        /// Validates the received JWT's signature and against details in database and returns 
        /// the related QNN_SAMPLE on success or null if the token is bad.
        /// </summary>
        public async Task<QNN_SAMPLE> GetRespondent(AuthenticationHeaderValue header)
        {
            string rawToken = (header == null) ? null : GetRawTokenFromHeader(header);
            if (rawToken == null)
            {   //n.b. an invalid header would be logged in call above, for missing header is too verbose, not logged
                return null;
            }
            else
            {
                SecurityKey signingKey = keys.GetRespondentKey();
                string expectedIssuer = (await TokenIssueSettings.GetFromAppSettings()).RespTokenIssuer;
                JsonWebToken jwt = await ParseAndValidateJwt(
                    signingKey: signingKey,
                    rawToken: rawToken,
                    checkExpiry: true,
                    requiredIssuer: expectedIssuer);
                QNN_SAMPLE sample = (jwt != null)
                    ? await LookupSample(jwt, checkRecordedExpiry: true)
                    : null;
                return sample;
            }
        }

        /// <summary>
        /// Generate tokens for an intranet user (i.e. for use with 3PA)
        /// </summary>
        public async Task<LoginResultData> GenerateUserTokens(string login)
        {
            if (string.IsNullOrWhiteSpace(login))
                throw new ArgumentException(nameof(login));

            SecurityUser user = await SecurityUser.SelectByPrincipal(login);
            if (user == null)
                throw new ArgumentException("User is not valid", nameof(login));

            TokenIssueSettings tokenSettings = await TokenIssueSettings.GetFromAppSettings();

            return await GenerateTokensInternal(
                signingKey: keys.GetUserKey(),
                userId: user.Id,
                name: user.Name,
                issuer: tokenSettings.ThirdPartyApiTokenIssuer,
                roles: user.Roles.Value,
                tokenExpiryMinutes: tokenSettings.ThirdPartyApiTokenExpiryMinutes,
                renewalExpiryMinutes: tokenSettings.ThirdPartyApiTokenRenewalMinutes);
        }

        /// <summary>
        /// Generate tokens for a respondent
        /// </summary>
        public async Task<LoginResultData> GenerateRespondentTokens(Guid sampleId, string name)
        {
            if (Guid.Empty.Equals(sampleId))
                throw new ArgumentException("May not be empty", nameof(sampleId));
            if (string.IsNullOrWhiteSpace(name))
                throw new ArgumentException(nameof(name));

            TokenIssueSettings tokenSettings = await TokenIssueSettings.GetFromAppSettings();

            return await GenerateTokensInternal(
                signingKey: keys.GetRespondentKey(),
                userId: sampleId,
                name: name,
                issuer: tokenSettings.RespTokenIssuer,
                roles: new List<string> { RespondentRole },
                tokenExpiryMinutes: tokenSettings.RespTokenExpiryMinutes,
                renewalExpiryMinutes: tokenSettings.RespTokenRenewalMinutes);
        }

        private async Task<LoginResultData> GenerateTokensInternal(
            SecurityKey signingKey,
            Guid userId,
            string name,
            string issuer,
            List<string> roles,
            double tokenExpiryMinutes, 
            double renewalExpiryMinutes)
        {
            string sessionId = NewSessionId();
            DateTime now = DateTime.Now;
            string renewalToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(48));
            PersistedToken ptoken = new PersistedToken
            {
                TokenId = sessionId,
                UserId = userId,
                TokenExpiry = now.AddMinutes(tokenExpiryMinutes),
                RenewalExpiry = (renewalExpiryMinutes > 0)
                    ? now.AddMinutes(renewalExpiryMinutes)
                    : DateTime.MinValue,
                RenewalHash = HashHelper.GetSHA384HashOfUTF8(renewalToken), //save only hash so no-one with access to db can recreate token
            };
            JsonWebToken jwt = CreateJwtToken(signingKey, issuer, ptoken, roles, name);
            string accessToken = jwt.EncodedToken;
            ptoken.TokenHash = HashHelper.GetSHA384HashOfUTF8(accessToken);
            await DataService.AddToken(ptoken);
            return new LoginResultData
            {
                UserId = userId,
                DisplayName = name,
                AccessToken = accessToken,
                RenewalToken = renewalToken,
                Success = true
            };
        }

        public async Task<bool> InvalidateUserToken(AuthenticationHeaderValue header)
        {
            string rawToken = (header == null) ? null : GetRawTokenFromHeader(header);
            return await InvalidateToken(rawToken);
        }

        public async Task<bool> InvalidateToken(string rawToken)
        {
            if (string.IsNullOrEmpty(rawToken))
            {
                return false;
            }

            JsonWebToken jwt = new JsonWebToken(rawToken);

            //delete only one session
            string sessionId = GetSessionClaim(jwt);
            await DataService.DeleteToken(sessionId);
            return true;
        }

        /// <summary>
        /// Validates the received 3PA intranet JWT signature and against the recorded deatils 
        /// in the database and returns the related SecurityUser on success or null if the token is bad.
        /// </summary>
        public async Task<SecurityUser> GetUser(AuthenticationHeaderValue header)
        {
            string rawToken = (header == null) ? null : GetRawTokenFromHeader(header);
            if (rawToken == null)
            {   //n.b. an invalid header would be logged in call above, for missing header is too verbose, not logged
                return null;
            }
            else
            {
                SecurityKey signingKey = keys.GetUserKey();
                string expectedIssuer = (await TokenIssueSettings.GetFromAppSettings()).ThirdPartyApiTokenIssuer;
                JsonWebToken jwt = await ParseAndValidateJwt(
                    signingKey: signingKey,
                    rawToken: rawToken, 
                    checkExpiry: true, 
                    requiredIssuer: expectedIssuer);
                return jwt != null
                    ? await LookupUser(jwt, checkRecordedExpiry: true)
                    : null;
            }       
        }

        public async Task<LoginResultData> RenewUserToken(AuthenticationHeaderValue header, string renewalToken)
        {
            string rawToken = GetRawTokenFromHeader(header);
            if (string.IsNullOrEmpty(rawToken))
            {
                logger.LogError(nameof(RenewUserToken) + " - rawToken is empty");
                return LoginResultData.EmptyWithError("bad-credentials");
            }
            JsonWebToken unvalidatedJwt;
            try
            {
                unvalidatedJwt = new JsonWebToken(rawToken);
            }
            catch (Exception jwtParseEx)
            {
                logger.LogError(jwtParseEx, nameof(RenewUserToken) + " - invalid jwt");
                return LoginResultData.EmptyWithError("bad-jwt");
            }

            SecurityUser userInfo = await LookupUser(unvalidatedJwt, checkRecordedExpiry: false);
            if (userInfo == null)
            {
                logger.LogError(nameof(RenewUserToken) + " - user not found in DB");
                return LoginResultData.EmptyWithError("not-found");
            }

            TokenIssueSettings tokenSettings = await TokenIssueSettings.GetFromAppSettings();

            return await RenewTokenInternal(
                rawToken: rawToken,
                renewalToken: renewalToken,
                signingKey: keys.GetUserKey(),
                issuer: tokenSettings.ThirdPartyApiTokenIssuer,
                userOrSampleId: userInfo.Id,
                name: userInfo.Name,
                roles: userInfo.Roles.Value,
                expiryMinutes: tokenSettings.ThirdPartyApiTokenExpiryMinutes);
        }

        public async Task<LoginResultData> RenewRespondentToken(AuthenticationHeaderValue header, string renewalToken)
        {
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(RenewRespondentToken) + " - called");

            if (string.IsNullOrWhiteSpace(renewalToken)) 
                throw new ArgumentException(nameof(renewalToken));

            string rawToken = GetRawTokenFromHeader(header);
            if (string.IsNullOrEmpty(rawToken))
            {
                logger.LogError(nameof(RenewRespondentToken) + " - rawToken is empty");
                return LoginResultData.EmptyWithError("bad-credentials");
            }
            JsonWebToken unvalidatedJwt;
            try
            {
                unvalidatedJwt = new JsonWebToken(rawToken);
            }
            catch (Exception jwtParseEx)
            {
                logger.LogError(jwtParseEx, nameof(RenewRespondentToken) + " - invalid jwt");
                return LoginResultData.EmptyWithError("bad-jwt");
            }

            QNN_SAMPLE sample = await LookupSample(unvalidatedJwt, checkRecordedExpiry: false);
            if (sample == null)
            {
                logger.LogError(nameof(RenewRespondentToken) + " - sample not found in DB, session claim={0}", GetSessionClaim(unvalidatedJwt));
                return LoginResultData.EmptyWithError("not-found");
            }

            TokenIssueSettings tokenSettings = await TokenIssueSettings.GetFromAppSettings();

            return await RenewTokenInternal(
                rawToken: rawToken,
                renewalToken: renewalToken,
                signingKey: keys.GetRespondentKey(),
                issuer: tokenSettings.RespTokenIssuer,
                userOrSampleId: sample.Id,
                name: sample.Name,
                roles: new List<string> { RespondentRole },
                expiryMinutes: tokenSettings.RespTokenExpiryMinutes);
        }

        private async Task<LoginResultData> RenewTokenInternal(
            string rawToken, 
            string renewalToken,
            SecurityKey signingKey,
            string issuer,
            Guid userOrSampleId,
            string name,
            IEnumerable<string> roles,
            double expiryMinutes)
        {
            JsonWebToken currentToken = await ParseAndValidateJwt(
                signingKey: signingKey,
                rawToken: rawToken,
                checkExpiry: false, //it may have already expired, we'll check renewal period below
                requiredIssuer: issuer);
            if (currentToken == null)
            {
                logger.LogError(nameof(RenewTokenInternal) + " - invalid jwt");
                return LoginResultData.EmptyWithError("bad-jwt");
            }

            string sessionId = GetSessionClaim(currentToken);
            if (string.IsNullOrEmpty(sessionId))
            {
                logger.LogError(nameof(RenewTokenInternal) + " - session ID not found in the claim");
                return LoginResultData.EmptyWithError("bad-claims");
            }

            PersistedToken ptoken = await DataService.GetTokenById(sessionId); //WARNING: ptoken will be mutated below
            if (ptoken == null)
            {
                logger.LogError(nameof(RenewTokenInternal) + " - token not found in DB");
                return LoginResultData.EmptyWithError("not-found");
            }

            if (ptoken.RenewalExpiry <= DateTime.Now)
            {
                logger.LogError(nameof(RenewTokenInternal) + " - token can't be renewed anymore");
                return LoginResultData.EmptyWithError("not-more-renewal");
            }

            if (ptoken.RenewalHash != HashHelper.GetSHA384HashOfUTF8(renewalToken))
            {
                logger.LogError(nameof(RenewTokenInternal) + " - invalid renewal token");
                return LoginResultData.EmptyWithError("bad-token");
            }

            if (ptoken.TokenHash != HashHelper.GetSHA384HashOfUTF8(rawToken))
            {
                logger.LogError(nameof(RenewTokenInternal) + " - invalid access token");
                return LoginResultData.EmptyWithError("bad-token");
            }

            if (ptoken.UserId != userOrSampleId)
            {
                logger.LogError(nameof(RenewUserToken) + " - mismatch token and user");
                return LoginResultData.EmptyWithError("bad-token");
            }

            //20250519 - previously we would limit the expiry of the renewed token to the end of the renewal
            //expiry period, but now we will renew for the normal period when renewing (so long as still in
            //the renewal period). This avoids some issues with continual pre-emptive renewals for a token that
            //will expire soon.
            ptoken.TokenExpiry = DateTime.Now.AddMinutes(expiryMinutes); //used for token's NotAfter

            JsonWebToken newToken = CreateJwtToken(signingKey, issuer, ptoken, roles, name);

            ptoken.TokenHash = HashHelper.GetSHA384HashOfUTF8(newToken.EncodedToken);
            await DataService.UpdateToken(ptoken);

            logger.LogTrace(nameof(RenewTokenInternal) + " - renewed for sessionId={0}, ptoken={1}", sessionId, ptoken);

            return new LoginResultData
            {
                UserId = userOrSampleId,
                DisplayName = name,
                AccessToken = newToken.EncodedToken,
                RenewalToken = renewalToken, //kept the same
                Success = true
            };
        }

        private string NewSessionId()
        {
            //return DateTime.Now.Ticks.ToString("x16") + Guid.NewGuid().ToString("N").Substring(16);

            //20250520 - now that we check signature we don't rely on session id being obscure
            //           so we will use a normal guid to generate it
            //   previous method was: DateTime.Now.Ticks.ToString("x16") + Guid.NewGuid().ToString("N").Substring(16)
            return Guid.NewGuid().ToString("N"); 
        }

        private JsonWebToken CreateJwtToken(
            SecurityKey signingKey, 
            string issuer, 
            PersistedToken ptoken, 
            IEnumerable<string> roles, 
            string name=null)
        {
            ClaimsIdentity claimsIdentity = new ClaimsIdentity();
            claimsIdentity.AddClaim(new Claim(SessionClaimType, ptoken.TokenId));
            claimsIdentity.AddClaim(new Claim(ClaimTypes.Sid, ptoken.UserId.ToString()));
            claimsIdentity.AddClaims(roles.Select(r => new Claim(ClaimTypes.Role, r)));
            if(name!=null) claimsIdentity.AddClaim(new Claim(ClaimTypes.Name, name));

            DateTime notBefore = DateTime.Now;
            DateTime notAfter = ptoken.TokenExpiry;
            JsonWebToken token = new JsonWebToken(
                new JsonWebTokenHandler().CreateToken(
                    new SecurityTokenDescriptor()
                    {
                        Issuer = issuer,
                        Audience = null,
                        Subject = claimsIdentity,
                        NotBefore = notBefore,
                        Expires = notAfter,
                        IssuedAt = notBefore,
                        SigningCredentials = new SigningCredentials(signingKey, SigningAlgorithm)
                    }));
            return token;
        }

        /// <summary>
        /// Checks for Authorization header and validates it is JWT scheme. 
        /// If successful, it returns the raw unparsed token string.
        /// </summary>
        /// <param name="authenticationHeaderValue">The request authorization header.</param>
        /// <returns>The JWT passed in the request; otherwise, it returns null.</returns>
        private string GetRawTokenFromHeader(AuthenticationHeaderValue authenticationHeaderValue)
        {
            if (authenticationHeaderValue == null) 
                throw new ArgumentNullException(nameof(authenticationHeaderValue));

            //According to RFC 7617, the authorization scheme should not be case sensitive;
            if (!string.Equals(authenticationHeaderValue.Scheme, JwtBearerDefaults.AuthenticationScheme, StringComparison.OrdinalIgnoreCase))
            {
                logger.LogError(nameof(GetRawTokenFromHeader) + " - authorization header using {0} scheme, expected {1}", authenticationHeaderValue.Scheme, JwtBearerDefaults.AuthenticationScheme);
                return null;
            }

            string authorization = authenticationHeaderValue.Parameter;
            if (string.IsNullOrEmpty(authorization))
            {
                logger.LogError(nameof(GetRawTokenFromHeader) + " - missing token value in the header");
                return null;
            }

            return string.IsNullOrEmpty(authorization) ? null : authorization;
        }

        /// <summary>
        /// Constructs a token object from the raw encoded token string and check signature.
        /// Will also verify it has a sessionid claim and do expiry date check if requested.
        /// If the token cannot be decoded this method does not raise an exception. It will return null.
        /// Exception messages will be logged at error level.
        /// </summary>
        private async Task<JsonWebToken> ParseAndValidateJwt(
            SecurityKey signingKey,
            string rawToken, 
            bool checkExpiry, //would be false in the renewal case
            string requiredIssuer)
        {
            JsonWebToken jwt;
            try
            {
                JsonWebTokenHandler handler = new JsonWebTokenHandler();
                TokenValidationParameters validationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = signingKey,

                    ValidateIssuer = true, // Validate the 'iss' claim
                    ValidIssuer = requiredIssuer,

                    ValidateAudience = false, // Validate the 'aud' claim
                                              //ValidAudience = requiredAudience,

                    ValidateLifetime = checkExpiry,
                    RequireExpirationTime = checkExpiry,

                    ClockSkew = TimeSpan.FromMinutes(ClockSkewMinutes),
                    ValidAlgorithms = new string[] { SigningAlgorithm },
                    ValidTypes = new string[] { JwtSchemeType },
                };

                TokenValidationResult result = await handler.ValidateTokenAsync(rawToken, validationParameters);
                if (result.IsValid)
                {
                    jwt = result.SecurityToken as JsonWebToken;
                    //ClaimsPrincipal claimsPrincipal = result.ClaimsPrincipal;
                }
                else
                {
                    throw result.Exception;
                }
            }
            catch (Exception ex)
            {
                logger.LogError(nameof(ParseAndValidateJwt) + " - unable to construct a validated JWT object from the raw token value. Message={0}", ex.Message);
                return null;
            }

            //if (!JwtSchemeType.Equals(jwt.Typ, StringComparison.OrdinalIgnoreCase))
            //{
            //    logger.LogError(nameof(ParseAndValidateJwt) + " - unsupported authentication scheme {0} in jwt, expected {1}", jwt.Typ, JwtSchemeType);
            //    return null;
            //}

            //if (checkExpiry)
            //{
            //    //TODO - allow for clock skew
            //    //jwt.ValidForm & jwt.ValidTo are in UTC time zone
            //    DateTime now = DateTime.UtcNow;
            //    if (now < jwt.ValidFrom || now > jwt.ValidTo)
            //    {
            //        logger.LogError(nameof(ParseAndValidateJwt) + " - token is expired");
            //        return null;
            //    }
            //}

            ////"According to the JWT standard (RFC 7519), the iss claim value is a case-sensitive string.
            //// When your application or resource server validates an incoming JWT,
            //// it must perform an exact, case-sensitive match against the expected issuer URI(s) it trusts." - Gemini
            //if (requiredIssuer != null && !requiredIssuer.Equals(jwt.Issuer, StringComparison.Ordinal))
            //{
            //    logger.LogError(nameof(ParseAndValidateJwt) + " - {0} is not the expected token issuer", jwt.Issuer);
            //    return null;
            //}

            string sessionId = GetSessionClaim(jwt);
            if (string.IsNullOrEmpty(sessionId))
            {
                logger.LogError(nameof(ParseAndValidateJwt) + " - Invalid session ID claim");
                return null;
            }

            return jwt;
        }

        private async Task<SecurityUser> LookupUser(JsonWebToken jwt, bool checkRecordedExpiry)
        {
            // validate against DB saved data
            string sessionId = GetSessionClaim(jwt);
            PersistedToken ptoken = await DataService.GetTokenById(sessionId);
            if (ptoken == null)
            {
                logger.LogError(nameof(LookupUser) + " - token not found in DB");
                return null;
            }

            if (checkRecordedExpiry)
            {
                DateTime now = DateTime.Now;
                if (now > ptoken.TokenExpiry || now > ptoken.RenewalExpiry)
                {
                    logger.LogError(nameof(LookupUser) + " - DB Token is expired");
                    return null;
                }
            }

            if (ptoken.TokenHash != HashHelper.GetSHA384HashOfUTF8(jwt.EncodedToken))
            {
                logger.LogError(nameof(LookupUser) + " - mismatch data in received token");
                return null;
            }

            SecurityUser userInfo = await SecurityUser.SelectByKey(ptoken.UserId);

            return userInfo;
        }

        private async Task<QNN_SAMPLE> LookupSample(JsonWebToken jwt, bool checkRecordedExpiry)
        {
            try
            {
                // validate against DB saved data
                string sessionId = GetSessionClaim(jwt);
                PersistedToken ptoken = await DataService.GetTokenById(sessionId);
                if (ptoken == null)
                {
                    logger.LogWarning(nameof(LookupUser) + " - token not found in DB, tokenId/sessionId={0}",sessionId);
                    return null;
                }

                if (checkRecordedExpiry)
                {   //This check is against the recorded expiry time in the database (not in the jwt)
                    DateTime now = DateTime.Now;
                    if (now > ptoken.TokenExpiry) //only check token expiry, not renewal expiry here
                    {
                        logger.LogWarning(nameof(LookupUser) + " - DB Token is expired, tokenId/sessionId={0}, TokenExpiry={1}, RenewalExpiry={1}",sessionId, ptoken.TokenExpiry, ptoken.RenewalExpiry);
                        return null;
                    }
                }
                
                string hashedToken = HashHelper.GetSHA384HashOfUTF8(jwt.EncodedToken);
                bool tokenMatchesRecordedHash = string.Equals(ptoken.TokenHash, hashedToken, StringComparison.Ordinal);
                if (!tokenMatchesRecordedHash)
                {
                    logger.LogError(nameof(LookupSample) + " - mismatch data in received token, tokenId/sessionId={0}, expected hash={1}, actual={2}", sessionId, ptoken.TokenHash, hashedToken);
                    return null;
                }

                QNN_SAMPLE sample = await QNN_SAMPLE.SelectByKey(ptoken.UserId);

                return sample;
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(LookupSample) + " - caught an unexpected exception and will return null");
                return null; //TODO - consider if it would be better to raise an error in this case
            }

        }

        private static string GetSessionClaim(JsonWebToken jwt)
        {
            Claim sessionClaim = jwt?.Claims?.FirstOrDefault(claim => SessionClaimType.Equals(claim.Type, StringComparison.Ordinal)); //claim type is case-sensitive
            return sessionClaim?.Value;
        }

        /// <summary>
        /// Decode a base64 into a UTF-8 string, applying the necessary padding = if it is missing 
        /// </summary>
        /// <param name="b64Str"></param>
        /// <returns></returns>
        private static string DecodeBase64(string b64Str) //TODO - rename DecodeBase64AsUTF8
        {
            // fix Base64 string padding
            int mod = b64Str.Length % 4;
            if (mod != 0) b64Str += new string('=', 4 - mod);
            return Encoding.UTF8.GetString(Convert.FromBase64String(b64Str));
        }

    }
}