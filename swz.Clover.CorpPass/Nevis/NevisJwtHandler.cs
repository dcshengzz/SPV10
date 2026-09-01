using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
using swz.KeyUtils;
using Microsoft.IdentityModel.JsonWebTokens;

namespace swz.Clover.SPCP.Nevis
{
    public class NevisJwtHandler : ISPCPHandler
    {
        /// <summary>
        /// Interface for objects that know how to extract a UId from an entityInfo / sub claim
        /// </summary>
        public interface IUidExtractor
        {
            string Extract(string entityInfo);
        }

        //was going to call this CPEntExtractor, but that has unfortunate implications for NricExtractor's name :p
        public class UenExtractor : IUidExtractor
        {
            public string Extract(string entityInfo)
            {
                /**
                             *  Example format:
                             *  { "CPEntID": "82532759L", "CPEnt_TYPE": "UEN",
                             *    "CPEnt_Status": "Registered", "CPNonUEN_Country": "",
                             *    "CPNonUEN_RegNo": "", "CPNonUEN_Name": "" }
                             * 
                             */
                Dictionary<string, object> data = JsonConvert.DeserializeObject<Dictionary<string, object>>(entityInfo);
                if (data.ContainsKey("CPEntID"))
                {
                    return (string)data["CPEntID"];
                }
                else
                {
                    throw new InvalidIdentityClaimException("Missing CPEntID", entityInfo);
                }
            }
        }

        public class NricExtractor : IUidExtractor
        {
            public string Extract(string entityInfo)
            {
                /**
                * Example format:
                * s=S8829314B,u=1c0cee38-3a8f-4f8a-83bc-7a0e4c59d6a9
                */

                //Find the s element and return its value
                string[] elements = entityInfo.Split(',');
                foreach (string element in elements)
                {
                    int i = element.IndexOf('=');
                    if (i != -1)
                    {
                        string key = element.Substring(0, i);
                        if ("s".Equals(key)) return element.Substring(i + 1);
                    }
                }
                throw new InvalidIdentityClaimException("Missing s element", entityInfo);
            }
        }

        /// <summary>
        /// Convenience object to wrap the public key suppliers for injection
        /// </summary>
        public class IssuerPublicKeySuppliers
        {
            public IPublicKeySupplier Corppass { get; private set; }

            public IPublicKeySupplier Singpass { get; private set; }
            
            public IssuerPublicKeySuppliers(IPublicKeySupplier corppass, IPublicKeySupplier singpass)
            {
                this.Corppass = corppass ?? throw new ArgumentNullException(nameof(corppass));
                this.Singpass = singpass ?? throw new ArgumentNullException(nameof(singpass));
            }
        }

        /// <summary>
        /// Convenience object to wrap the private key suppliers for injection
        /// </summary>
        public class DecryptionPrivateKeySuppliers
        {
            public IPrivateKeySupplier Corppass { get; private set; }

            public IPrivateKeySupplier Singpass { get; private set; }

            public DecryptionPrivateKeySuppliers(IPrivateKeySupplier corppass, IPrivateKeySupplier singpass)
            {
                this.Corppass = corppass ?? throw new ArgumentNullException(nameof(corppass));
                this.Singpass = singpass ?? throw new ArgumentNullException(nameof(singpass));
            }
        }

        /// <summary>
        /// Internal exception used in the handler.
        /// The request from Nevis, usually the token, is in some way invalid.
        /// Tells our local catch block to return an InvalidRequest outcome to handler's caller.
        /// </summary>
        private class InvalidRequestException : Exception
        {
            public InvalidRequestException(string message) : base(message) { }

            public InvalidRequestException(string message, Exception innerException) : base(message, innerException) { }
        }

        /// <summary>
        /// Internal exception used in the handler.
        /// Where the token's "entityInfo" or "sub" claim is empty, doesn't make sense or can't be parsed
        /// (not applicable for things like where the uid doesnt exist in db)
        /// </summary>
        private class InvalidIdentityClaimException : InvalidRequestException
        {
            public string ClaimValue { get; private set; }

            public InvalidIdentityClaimException(string message, string claimValue) : base(message) 
            {
                this.ClaimValue = claimValue;
            }

            public InvalidIdentityClaimException(string message, string claimValue, Exception innerException) : base(message, innerException)
            {
                this.ClaimValue = claimValue;
            }
        }

        private class InvalidTokenException : InvalidRequestException
        {
            public InvalidTokenException(string message) : base(message) { }

            public InvalidTokenException(string message, Exception innerException) : base(message, innerException) { }
        }

        //

        private class InvalidRequestMethodException : InvalidRequestException
        {
            public InvalidRequestMethodException(string method) : base($"Expected request method to be POST but it was {method}") { }
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        private readonly ILogger logger;
        private readonly SPCPOptions spcpOptions;
        private readonly NevisSettings corppassNevisSettings;
        private readonly NevisSettings singpassNevisSettings;
        private readonly IUidExtractor corppassExtractor;
        private readonly IUidExtractor singpassExtractor;
        private readonly IssuerPublicKeySuppliers issuerPublicKeySuppliers;
        private readonly DecryptionPrivateKeySuppliers decryptionPrivateKeySuppliers;

        public NevisJwtHandler(
            ILogger<NevisJwtHandler> logger, 
            SPCPOptions spcpOptions, 
            CorppassNevisSettingsWrapper corppassNevisWrapper,
            SingpassNevisSettingsWrapper singpassNevisWrapper,
            IssuerPublicKeySuppliers issuerPublicKeyupliers,
            DecryptionPrivateKeySuppliers decryptionPrivateKeySuppliers)
        {
            if (corppassNevisWrapper == null) throw new ArgumentNullException(nameof(corppassNevisWrapper));
            if (singpassNevisWrapper == null) throw new ArgumentNullException(nameof(corppassNevisWrapper));
            this.logger = logger  ?? throw new ArgumentNullException(nameof(logger));
            this.spcpOptions = spcpOptions ?? throw new ArgumentNullException(nameof(spcpOptions));
            this.corppassNevisSettings = corppassNevisWrapper.GetNevisSettings(spcpOptions.Environment);
            if (this.corppassNevisSettings.IsInvalid()) throw new ArgumentException("settings not valid", nameof(corppassNevisWrapper));
            this.singpassNevisSettings = singpassNevisWrapper.GetNevisSettings(spcpOptions.Environment);
            if (this.singpassNevisSettings.IsInvalid()) throw new ArgumentException("settings not valid", nameof(singpassNevisSettings));
            this.issuerPublicKeySuppliers = issuerPublicKeyupliers ?? throw new ArgumentNullException(nameof(issuerPublicKeyupliers));
            this.decryptionPrivateKeySuppliers = decryptionPrivateKeySuppliers ?? throw new ArgumentNullException(nameof(decryptionPrivateKeySuppliers));
            this.corppassExtractor = new UenExtractor();
            this.singpassExtractor = new NricExtractor();
        }

        public async Task<SPCPHandlerResult> Handle(HttpRequest request, SPCPFlow flow)
        {
            if (request == null) throw new ArgumentNullException(nameof(request));
            try
            {
                if (HttpMethods.IsPost(request.Method) == false)
                    throw new InvalidRequestMethodException(request.Method);

                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug("Handle: processing {0} request from {1}", 
                        flow, request.HttpContext.Connection.RemoteIpAddress);
                }

                NevisSettings nevisSettings;
                //IPublicCertificateSupplier certificateSupplier;
                IPublicKeySupplier issuerPublicKeySupplier;
                IPrivateKeySupplier decryptionPrivateKeySupplier;
                switch (flow)
                {
                    case SPCPFlow.Corppass:
                        nevisSettings = corppassNevisSettings;
                        issuerPublicKeySupplier = issuerPublicKeySuppliers.Corppass;
                        decryptionPrivateKeySupplier = decryptionPrivateKeySuppliers.Corppass; 
                        break;

                    case SPCPFlow.Singpass:
                        nevisSettings = singpassNevisSettings;
                        issuerPublicKeySupplier = issuerPublicKeySuppliers.Singpass;
                        decryptionPrivateKeySupplier = decryptionPrivateKeySuppliers.Singpass;
                        break;

                    default:
                        throw new NotImplementedException($"Unknown {nameof(SPCPFlow)} - {flow}");
                }

                JsonWebTokenHandler tokenHandler = new JsonWebTokenHandler();
                string tokenData = RawTokenData(request, nevisSettings, tokenHandler); //raises InvalidRequestException if its missing, unreadable
                if(spcpOptions.Debug && logger.IsEnabled(LogLevel.Trace))
                {
                    //nb: for singpass this is sensitive hence we require the Debug flag before logging it
                    logger.LogTrace("Handle: tokenData={0}", tokenData); 
                }
                JsonWebToken jwt = await ParseToken(
                        nevisSettings,
                        tokenHandler,
                        tokenData,
                        issuerPublicKeySupplier,
                        decryptionPrivateKeySupplier); //raises InvalidTokenException if invalid
                string claimValue = Claim(jwt, nevisSettings.IdentityClaimName);
                if (claimValue == null) throw new InvalidRequestException($"Missing {nevisSettings.IdentityClaimName} claim in token");
                String uId = UId(flow, claimValue); //raises InvalidIdentityClaimException if missing / invalid format
                if (spcpOptions.Debug && logger.IsEnabled(LogLevel.Debug))
                {
                    //nb: this may be sensitive (i.e. nric) hence we require the SPCP Debug flag set in appsettings to log it
                    logger.LogDebug("Handle: Extracted uId={0}", uId);
                }
                return SPCPHandlerResult.Success(uId);
            }
            catch (InvalidRequestException ire)
            {
                if(spcpOptions.Debug && ire is InvalidIdentityClaimException)
                {
                    //Only log the claim value if in debug mode
                    logger.LogError(ire, "Handle: Invalid request. Unable to perform SPCP {0} login. EntityInfo={1}", 
                        flow, ((InvalidIdentityClaimException)ire).ClaimValue);
                }
                else
                {
                    logger.LogError(ire, "Handle: Invalid {0} request. Unable to perform SPCP login.",
                        flow);
                }

                if (spcpOptions.Debug && ire is InvalidRequestMethodException && logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation("Handle: Unexpected {0} request RemoteIpAddress={1}, Method={2},\n Headers={3}",
                        flow,
                        request.HttpContext.Connection.RemoteIpAddress,
                        request.Method,
                        HeaderDump(request));
                }

                return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Handle: Unexpected exception caught by SPCP handler. Unable to perform {0} login.", flow);
                return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InternalError);
            }
        }

        /// <summary>
        /// Extract a single claim of specified type from the jwt
        /// </summary>
        /// <param name="jwt">the token (may not be null)</param>
        /// <param name="type">which claim to extract</param>
        /// <returns>claim or null</returns>
        /// <exception cref="ArgumentNullException"></exception>
        private string Claim(JsonWebToken jwt, String type)
        {
            if (type == null) throw new ArgumentNullException(nameof(type));
            //The Claim Names within a JWT Claims Set MUST be unique
            //see: https://datatracker.ietf.org/doc/html/rfc7519#page-8	
            string value = jwt.Claims
                .Where(claim => type.Equals(claim.Type))
                .Select(claim => claim.Value)
                .LastOrDefault(); 
            return value;
        }

        /// <summary>
        /// Dump request header information to a string (for use in logging)
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        private string HeaderDump(HttpRequest request)
        {
            StringBuilder b = new StringBuilder();
            foreach (KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues> header in request.Headers)
            {
                string key = header.Key;
                foreach (string value in header.Value)
                {
                    b.AppendLine($"key={key} value={value}");
                }
            }
            return b.ToString();
        }

        /// <summary>
        /// Returns a ValidatedToken from parsing and validating the raw JWT token data.
        /// An InvalidTokenException is raised if the tokenData can't be parsed or the token validated.
        /// </summary>
        /// <param name="tokenData"></param>
        /// <param name="cert"></param>
        /// <returns></returns>
        private async Task<JsonWebToken> ParseToken(
            NevisSettings nevisSettings,
            JsonWebTokenHandler tokenHandler, 
            string tokenData, 
            IPublicKeySupplier issuerPublicKeySupplier,
            IPrivateKeySupplier decryptionPrivateKeySupplier)
        {
            if (string.IsNullOrWhiteSpace(tokenData)) throw new ArgumentException(nameof(tokenData));
            if(issuerPublicKeySupplier==null) throw new ArgumentNullException(nameof(issuerPublicKeySupplier));
            if (decryptionPrivateKeySupplier == null) throw new ArgumentNullException(nameof(decryptionPrivateKeySupplier)); 
            try
            {
                IEnumerable<SecurityKey> issuerSigningKeys = await issuerPublicKeySupplier.PublicKeys();
                if(!issuerSigningKeys.Any()) 
                    throw new ArgumentException("At least one issuer public key is required for signature verification",nameof(issuerPublicKeySupplier));

                IEnumerable<SecurityKey> surveyPlusPrivateKeys = await decryptionPrivateKeySupplier.PrivateKeys();
                surveyPlusPrivateKeys = surveyPlusPrivateKeys.Any() ? surveyPlusPrivateKeys : null;

                TokenValidationParameters validationParameters = new TokenValidationParameters()
                {
                    RequireAudience = true,
                    ValidateAudience = true,
                    IgnoreTrailingSlashWhenValidatingAudience = true,
                    ValidAudience = nevisSettings.ExpectedAudience,

                    ValidateIssuer = true,
                    ValidIssuer = nevisSettings.ExpectedIssuer,  //nb: no option to ignore trailing slash

                    RequireExpirationTime = true,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(nevisSettings.ClockSkewSeconds),

                    RequireSignedTokens = true,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKeys = issuerSigningKeys,
                    TryAllIssuerSigningKeys = true,

                    TokenDecryptionKeys = surveyPlusPrivateKeys,

                    ValidAlgorithms = nevisSettings.IsRestrictAlgorithms ? nevisSettings.GetValidAlgorithms() : null,

                    //TODO - Should we set a no-cache CryptoProviderFactory here? think don't need now that we aren't managing the RSA here again
                };

                TokenValidationResult result = await tokenHandler.ValidateTokenAsync(tokenData, validationParameters);
                if (result == null) 
                    throw new NullReferenceException("tokenHandler.ValidateToken returned null"); //Can't happen right?
                if(!result.IsValid) //unlike System.Identity's handler this one doesn't automatically throw the exception
                    throw result.Exception;

                JsonWebToken jwt = (JsonWebToken)result.SecurityToken;
                if(spcpOptions.Debug && logger.IsEnabled(LogLevel.Debug))
                {
                    //nb: this may be sensitive (i.e. nric) hence we require the Debug flag before logging it
                    //the :l is to keep the logged json literal. See: https://github.com/serilog/serilog-sinks-file/issues/102
                    logger.LogDebug("ParseToken: jwt={0:l}", jwt.ToString() );
                }
                return jwt;
            }
            catch (SecurityTokenException ste)
            {
                //Note: "Token does not have a kid" is a rather confusing error message. It actually covers a number
                //      of failures, such as none of the provided certificates working to validate the signature. You
                //      would also see it if the valid algorithms don't match, and so forth...
                //      e.g.  https://stackoverflow.com/a/71612385/8243046


                //For IDX10205 Issuer Validation Failed
                //see: https://aka.ms/IdentityModel/issuer-validation
                //Double-check the expected issuer in the appsettings vs what is actually in the token
                //To see the PII set the Debug flag for SPCP in appsettings, this will set IdentityModelEventSource.ShowPII = true;
                //at startup in SPCPConfigurator (as well as enable other things)

                //fwiw, here is a list of IdentityModel exception messages
                //https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/blob/63f25857adfaba66327681cb47c4b5589d06c887/src/Microsoft.IdentityModel.Tokens/LogMessages.cs
                //When ShowPII is off I think any parameters to these messages are redacted. 
                //See: https://stackoverflow.com/a/62916535/8243046

                logger.LogDebug("ParseToken: SecurityTokenException when validating: {0}", ste.Message);
                throw new InvalidTokenException("Validation failed with a SecurityTokenException", ste);
            }
            catch(Exception e)
            {
                throw new InvalidTokenException("Validation failed with an unexpected exception", e);
            }
        }

        /// <summary>
        /// Get the raw token data from the request based on the configured parameter name and validate that it can be read as
        /// a JWT. Raise an InvalidRequestException if a token cannot be read from the request.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="nevisSettings"></param>
        /// <param name="jwtTokenHandler"></param>
        /// <returns></returns>
        /// <exception cref="InvalidRequestException"></exception>
        private string RawTokenData(HttpRequest request, NevisSettings nevisSettings, JsonWebTokenHandler jwtTokenHandler)
        {
            string parameterName = nevisSettings.TokenParameter;
            if (string.IsNullOrEmpty(parameterName)) throw new InvalidOperationException("Token parameter name is not configured");
            if (!request.Form.TryGetValue(parameterName, out var strings))
            {
                throw new InvalidRequestException($"Token parameter {parameterName} not provided in request. Unable to perform SPCP login");
            }
            string tokenData = strings.ToString();
            if (string.IsNullOrWhiteSpace(tokenData))
            {
                throw new InvalidRequestException("Token parameter {parameterName} is empty in request. Unable to perform SPCP login");
            }
            bool cannotReadToken = (false == jwtTokenHandler.CanReadToken(tokenData));
            if (cannotReadToken)
            {
                if (spcpOptions.Debug) logger.LogDebug("RawTokenData: Unreadable token={0}", tokenData);
                throw new InvalidRequestException("Token cannot be read");
            }
            return tokenData;
        }

        /// <summary>
        /// Parses the entityInfo (entityInfo or sub) claim to determine the SurveyPlus sample uId 
        /// (which will be the UEN from CPEntID or s (NRIC) in a sub claim)
        /// Raises an InvalidEntityInfoException if this cannot be done.
        /// nb: doesn't verify the CPEnt_TYPE
        /// </summary>
        /// <param name="claimValue"></param>
        /// <returns></returns>
        private string UId(SPCPFlow flow, string claimValue)
        {
            if (claimValue == null) throw new ArgumentNullException(nameof(claimValue));
            if (string.IsNullOrWhiteSpace(claimValue)) throw new InvalidIdentityClaimException("Empty claim", claimValue);
            try
            {
                switch (flow)
                {
                    case SPCPFlow.Corppass: 
                        return corppassExtractor.Extract(claimValue);

                    case SPCPFlow.Singpass: 
                        return singpassExtractor.Extract(claimValue);

                    default:
                        throw new NotImplementedException($"Unknown {nameof(SPCPFlow)} - {flow}");
                }
            }
            catch (InvalidIdentityClaimException)
            {
                throw;
            }
            catch(Exception e)
            {
                throw new InvalidIdentityClaimException("Unable to parse identity claim", claimValue, e);
            }
        }
    }
}
