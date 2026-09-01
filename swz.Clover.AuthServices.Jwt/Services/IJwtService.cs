using System;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.Clover.AuthServices.Jwt.Services
{
    /// <summary>
    /// Some constants which should be in the IJwtService interface but aren't because c#
    /// </summary>
    public static class IJwtServiceConstants
    {
        /// <summary>
        /// Error message returned by ValidateToken for bad credentials
        /// </summary>
        public static readonly string BadCredentials = "bad-credentials";
    }

    /// <summary>
    /// Interface to an object that provides some support for user login via JWT and management
    /// of those JWTs.
    /// Note: this interface (previously name IJwtCntroller) and the implementing 
    /// JwtService have SurveyPlus specific modifications
    /// </summary>
    //This interface was previously named IJwtController -20250503
    public interface IJwtService
    {
        //Methods for intranet (i.e. 3PA) use (user-specific tokens)
        //...

        /// <summary>
        /// Generate access token and renewal token for a user (3pa) and record their details in the db
        /// </summary>
        Task<LoginResultData> GenerateUserTokens(string login);

        /// <summary>
        /// Extracts token from the header and calls InvalidateToken 
        /// to clear the user token from the database 
        /// so it will no longer be considered valid.
        /// </summary>
        Task<bool> InvalidateUserToken(AuthenticationHeaderValue header);

        /// <summary>
        /// Validate the authorisation token in the header 
        /// and return the associated intranet SecurityUser 
        /// or null
        /// </summary>
        Task<SecurityUser> GetUser(AuthenticationHeaderValue header);

        /// <summary>
        /// Issue a new token for a 3pa user with a fresh expiry period
        /// </summary>
        Task<LoginResultData> RenewUserToken(AuthenticationHeaderValue request, string renewalToken);

        //...





        //Methods for surveyplus internet (respondent-specific tokens)
        //...

        /// <summary>
        /// Generate access and renewal tokens for a sample, store details in db
        /// </summary>
        Task<LoginResultData> GenerateRespondentTokens(Guid sampleId, string sampleName);

        /// <summary>
        /// Validate the authorisation token in the header
        /// and return the associated internet respondent
        /// or null
        /// </summary>
        Task<QNN_SAMPLE> GetRespondent(AuthenticationHeaderValue header);
        
        /// <summary>
        /// Issue a new token for a respondent with a fresh expiry period
        /// </summary>
        Task<LoginResultData> RenewRespondentToken(AuthenticationHeaderValue header, string renewalToken);


        //...

        //General methods
        //...


        /// <summary>
        /// Clears the token from the database so it will no longer be considered valid.
        /// n.b. A true return value doesn't indicate whether anything was actually removed from the db,
        /// but the value will be false if the rawToken couldn't be obtained, was null/empty etc
        /// </summary>
        Task<bool> InvalidateToken(string rawToken);  //TODO - hide, there's InvalidateUserToken so make one for resp

        //...
    }
}