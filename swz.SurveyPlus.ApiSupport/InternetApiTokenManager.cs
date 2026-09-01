using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.JsonWebTokens;
using Newtonsoft.Json;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.ApiSupport
{
    public interface IInternetApiTokenManager
    {
        /// <summary>
        /// Get the current access token (for the current respondent) or return null if not logged in. 
        /// Will also check if the stored token is expiring and automatically request a renewal if necessary. 
        /// The implementation will handle traffic control when there are multiple simultaneous requests in 
        /// the same session and ensure that only one of the requests handles the process of requesting a 
        /// renewal while the others wait for it to complete and then share the result.
        /// </summary>
        Task<string> AccessToken();

        /// <summary>
        /// Store tokens 
        /// To be called after logging in and exchanging credentials for tokens and when the token is renewed.
        /// </summary>
        void StoreToken(string uid, string accessToken, string renewalToken);

        /// <summary>
        /// Remove stored tokens
        /// (to be called on logout, but note that many sessions won't have explicit logout and must rely on expiration)
        /// </summary>
        void ClearToken();
    }

    /// <summary>
    /// Singleton service to manage and coordinate renewal of the respondent-specific access tokens
    /// used with the u@app API. Although copies of token are held in the http session, code using
    /// tokens must still go through this manager to retrieve them to ensure proper behaviour around
    /// renewals.
    /// WARNING:
    ///     This implementation REQUIRES STICKY SESSIONS when there are multiple instances of the internet
    ///     application. (This is due to the use of an in-memory cache to manage the shared semaphores
    ///     and ensure all requests get the latest token even if their sessions don't reflect it yet).
    /// </summary>
    public class InternetApiTokenManager : IInternetApiTokenManager
    {
        //Troubleshooting note:
        //The complexity around managing the token is focussed on the renewal problem when there are
        //multiple requests (threads) trying to get the latest token at the same time. If you are seeing
        //problems with this process you could try to get around them by setting a long expiry time so
        //that the renewal logic doesn't need to be invoked.

        /// <summary>
        /// Object to temporarily hold token details in the memory cache
        /// </summary>
        private class TokenHolder
        {
            public string AccessToken { get; private set; }
            public string RenewalToken { get; private set; }
            public DateTime ValidTo { get; private set; }

            public TokenHolder(string accessToken, string renewalToken, DateTime validTo)
            {
                this.AccessToken = accessToken ?? throw new ArgumentNullException(nameof(accessToken));
                this.RenewalToken = renewalToken ?? throw new ArgumentNullException(nameof(renewalToken));
                this.ValidTo = validTo;
            }
        }

        private const string Session_AccessToken = "accessToken"; //attribute name in the session
        private const string Session_AccessTokenRenewBefore = "accessTokenExpiry";
        private const string Session_RenewalToken = "renewalToken";

        private const string semaphoreKeyPrefix = "IATM-88fd9353-9395-422a-bfbe-c888d1de881d::"; //avoid clashing with other MC users
        private const double semaphoreCacheExpiryMinutes = 20;

        private const string tokenKeyPrefix = "IATM-570597d9-11d5-4542-83ac-64ce8e93efc4::";

        private readonly ILogger<InternetApiTokenManager> logger;
        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly IHttpClientFactory httpClientFactory;
        private readonly WebApiAdditionalHeaderOptions apiHeaderOptions;
        private readonly UnifiedAtAppSetting unifiedAtAppSetting;
        private readonly IMemoryCache memoryCache;

        public InternetApiTokenManager(
            ILogger<InternetApiTokenManager> logger,
            IHttpContextAccessor httpContextAccessor,
            IHttpClientFactory httpClientFactory,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            UnifiedAtAppSetting unifiedAtAppSetting,
            IMemoryCache memoryCache)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(httpClientFactory));
            this.apiHeaderOptions = apiHeaderOptions ?? throw new ArgumentNullException(nameof(apiHeaderOptions));
            this.unifiedAtAppSetting = unifiedAtAppSetting ?? throw new ArgumentNullException(nameof(unifiedAtAppSetting));
            this.memoryCache = memoryCache ?? throw new ArgumentNullException(nameof(memoryCache));
        }

        public async Task<string> AccessToken()
        {
            ISession session = (httpContextAccessor.HttpContext?.Session)
                ?? throw new InvalidOperationException("There is no session");
            string uid = UAppUtils.GetUidFromSession(session);
            if (string.IsNullOrEmpty(uid))
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(AccessToken) + " - Respondent is not logged in (no uid in session)");
                return null;
            }

            SemaphoreSlim semaphoreSlim = GetSemaphore(session);
            
            //...
            //This block allows only one thread to execute at a time for a given uid
            //(others must wait on the semaphore)
            //so this means that if the token needs to be renewed, only one thread will call the intranet
            //side to do that and put the new token into the session before we let the other threads get it.
            //(Note: I had considered storing the tokens in memory here in the manager, but decided to keep
            //       them in the session so that they can be cleared when the session expires, however code that
            //       wants to use the token is obligated to get it via this manager and should not directly fetch
            //       it from the session (as it may be expiring and about to be renewed)).
            await semaphoreSlim.WaitAsync();
            try
            {
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    HttpRequest request = httpContextAccessor.HttpContext?.Request;
                    logger.LogTrace(nameof(AccessToken) + " - uid={0}, semaphoreSlim={1}, http session.Id={2}, path={3}", uid, semaphoreSlim.GetHashCode(), session.Id, request?.Path);
                }

                //If it is expiring then we try to renew the access token here before returning to caller
                DateTime renewBefore = RetrieveTokenRenewBeforeFromCacheOrSession(uid, session);
                double minutesBefore = unifiedAtAppSetting.TokenManagerEarlyRenewalMinutes;
                bool tokenNeedsRenewal = DateTime.Now.AddMinutes(minutesBefore) >= renewBefore;
                if (tokenNeedsRenewal)
                {
                    string expiringToken = RetrieveAccessTokenFromCacheOrSession(uid, session);
                    string renewalToken = RetrieveRenewalTokenFromCacheOrSession(uid, session);
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        string tokenHash = HashHelper.GetSHA384HashOfUTF8(expiringToken); //to log for debugging only
                        logger.LogDebug(nameof(AccessToken) + " - requesting renewal of token, renewBefore={0}, tokenHash={2}", renewBefore, tokenHash);
                    }
                    
                    AccessTokenRenewalResult result = await RenewAccessToken(expiringToken, renewalToken);
                    if(logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(AccessToken) + " - renewal result={0}", result);
                    }
                    if(result.IsSuccess)
                    {
                        StoreTokenInternal(uid, result.AccessToken, result.RenewalToken, doNotRenew: false);
                    }
                    else
                    {   
                        //If we can't renew, continue to use the expiring token we have, but
                        //make a note not to keep retrying the renewal on subsequent requests
                        StoreTokenInternal(uid, expiringToken, renewalToken, doNotRenew: true);
                    }
                }
                
                string currentToken = RetrieveAccessTokenFromCacheOrSession(uid, session);
                return currentToken;
            }
            finally
            {
                semaphoreSlim.Release();
            }
        }

        /// <summary>
        /// Returns a shared SemaphoreSlim for a given session that is used when getting the token
        /// to do some traffic control around the token renewal (one session will have multiple requests
        /// sent by the clientside at the same time)
        /// </summary>
        private SemaphoreSlim GetSemaphore(ISession session)
        {
            if (session == null) throw new ArgumentNullException(nameof(session));
            string semaphoreKey = ($"{semaphoreKeyPrefix}{session.Id}").ToLowerInvariant();
            Lazy<SemaphoreSlim> trafficControl = memoryCache.GetOrCreate(semaphoreKey, entry =>
            {
                entry.SlidingExpiration = TimeSpan.FromMinutes(semaphoreCacheExpiryMinutes);
                entry.RegisterPostEvictionCallback((key, value, reason, state) =>
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                        logger.LogTrace(nameof(GetSemaphore) + " - cache evicted {0}", key);

                    //Because it is disposable it needs to be disposed when no longer in use 
                    if (((Lazy<SemaphoreSlim>)value).IsValueCreated)
                        ((Lazy<SemaphoreSlim>)value).Value.Dispose();
                });
                return new Lazy<SemaphoreSlim>(() => new SemaphoreSlim(initialCount: 1, maxCount: 1));
            });
            return trafficControl.Value;
        }

        /// <summary>
        /// Call the intranet side to request a token renewal
        /// </summary>
        private async Task<AccessTokenRenewalResult> RenewAccessToken(string accessToken, string renewalToken)
        {
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrWhiteSpace(renewalToken)) throw new ArgumentException(nameof(renewalToken));

            try
            {
                string partialUrl = Constants.UAppRoutes.Renew;
                Dictionary<string, string> formData = new Dictionary<string, string>();
                formData.Add("renewalToken", renewalToken);
                UAppUtils.TraceLogHttpClient(logger, "RenewAccessToken", partialUrl);
                string responseContent = await UAppUtils.SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    UAppUtils.ApiRequest.PostForm(partialUrl, accessToken, formData));
                AccessTokenRenewalResult result = JsonConvert.DeserializeObject<AccessTokenRenewalResult>(responseContent);
                if(!result.IsSuccess && logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(RenewAccessToken) + " - renewal request failed");
                }
                return result;
            }
            catch (SessionInvalidException sie) //might have been invalidated by the single-respondent-session feature
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(sie, nameof(RenewAccessToken) + " - rethrowing a SessionInvalidException");
                throw;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(e, nameof(RenewAccessToken) + " - caught unexpected exception");
                throw new InternalException("Unexpected error renewing access token", e);
            }
        }

        public void StoreToken(string uid, string accessToken, string renewalToken)
        {
            StoreTokenInternal(uid, accessToken, renewalToken, doNotRenew: false);
        }

        private void StoreTokenInternal(
            string uid, 
            string accessToken,
            string renewalToken,
            bool doNotRenew)
        {
            if (string.IsNullOrWhiteSpace(uid)) throw new ArgumentException(nameof(uid));
            if (string.IsNullOrEmpty(accessToken)) throw new ArgumentException(nameof(accessToken));
            if (string.IsNullOrEmpty(renewalToken)) throw new ArgumentException(nameof(renewalToken));

            ISession session = (httpContextAccessor.HttpContext?.Session)
                ?? throw new InvalidOperationException("There is no session");
            //n.b. when this method is called by the respondent service at login (before returning
            //     login result to the controller) the session does not yet have the uid, so because of
            //     this we require the caller to pass it in for us.

            //Parse token to extract expiry date, we store the expiry in the session to avoid having to 
            //parse the entire token to check it every time we need to check the date
            JsonWebToken jwt = new JsonWebToken(accessToken);
            DateTime renewBefore = doNotRenew
                ? DateTime.MaxValue //if couldn't renew then don't keep retrying
                : jwt.ValidTo.ToLocalTime();

            if (logger.IsEnabled(LogLevel.Debug))
            {
                string tokenHash = HashHelper.GetSHA384HashOfUTF8(jwt.EncodedToken.Trim());
                logger.LogDebug(nameof(StoreTokenInternal) + " - storing tokens for sessionId={0}, uid={1}, renewBefore={2}, tokenHash={3}", session.Id, uid, renewBefore, tokenHash);
            }

            //We need to put a copy of the token into shared memory so that it is available *immediately* to any
            //other requests that might be waiting on our token renewal semaphore. Those requests might not see a
            //value that we put into the http session now until after this request has completed (which is long after
            //the renewal semaphore has been released). Therefore we make the memory cache the first place to check
            //for a token. But we only stash in there in the short term, and then fall back to the session later
            //because we prefer that storage of the tokens follows the session's lifecycle.
            //TODO - review this once its working (my original idea was just to use the session and
            //       avoid memory cache altogether but that doesn't work due to the other requests
            //       not seeing the new token in session yet)
            MemoryCacheEntryOptions tokenCacheOptions = new MemoryCacheEntryOptions();
            tokenCacheOptions.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(unifiedAtAppSetting.TokenManagerTokenCacheMinutes);
            tokenCacheOptions.RegisterPostEvictionCallback((key, value, reason, state) =>
            {
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(StoreTokenInternal) + " - cache evicted {0}", key);
            });
            memoryCache.Set<TokenHolder>(
                key: TokenCacheKey(uid, session.Id),
                value: new TokenHolder(accessToken, renewalToken, renewBefore),
                options: tokenCacheOptions);

            session.SetString(Session_AccessToken, accessToken);
            session.SetString(Session_RenewalToken, renewalToken);
            session.SetString(Session_AccessTokenRenewBefore, renewBefore.Ticks.ToString());
        }

        public void ClearToken()
        {
            //n.b. we can't rely on this method actually being called when a session ends
            //     so don't put any logic here that we can't live without

            ISession session = (httpContextAccessor.HttpContext?.Session);
            if(session != null)
            {
                session.Remove(Session_AccessToken);
                session.Remove(Session_RenewalToken);

                string uid = UAppUtils.GetUidFromSession(session); //may be null if expired already
                if (!string.IsNullOrEmpty(uid)) 
                {
                    memoryCache.Remove(TokenCacheKey(uid, session.Id));
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        HttpRequest request = httpContextAccessor.HttpContext?.Request;
                        logger.LogTrace(nameof(ClearToken) + " - cleared for sessionId={0}, uid={1}, path={2}", session?.Id, uid, request?.Path);
                    }
                }
            }  
        }

        private string RetrieveAccessTokenFromCacheOrSession(string uid, ISession session)
        {
            return RetrieveTokenHolderFromCache(uid, session.Id)?.AccessToken
                ?? session.GetString(Session_AccessToken)
                ?? throw new InvalidOperationException("Can't find access token");
        }

        private string RetrieveRenewalTokenFromCacheOrSession(string uid, ISession session)
        {
            return RetrieveTokenHolderFromCache(uid, session.Id)?.RenewalToken
                ?? session.GetString(Session_RenewalToken)
                ?? throw new InvalidOperationException("Can't find renewal token");
        }

        private DateTime RetrieveTokenRenewBeforeFromCacheOrSession(string uid, ISession session)
        {
            return RetrieveTokenHolderFromCache(uid, session.Id)?.ValidTo
                ?? (session.GetString(Session_AccessTokenRenewBefore)!=null 
                    ? new DateTime(ticks: long.Parse(session.GetString(Session_AccessTokenRenewBefore)), DateTimeKind.Local)
                    : throw new InvalidOperationException("Can't find token expiry"));
        }

        private TokenHolder RetrieveTokenHolderFromCache(string uid, string sessionId)
        {
            return memoryCache.Get<TokenHolder>(TokenCacheKey(uid, sessionId));
        }

        private string TokenCacheKey(string uid, string sessionId)
        {
            if (string.IsNullOrEmpty(uid)) throw new ArgumentException(nameof(uid));
            if (string.IsNullOrEmpty(sessionId)) throw new ArgumentException(nameof(sessionId));
            //note that this includes sessionId as same uid could be logged in for multiple sessions
            //and I include uid to feel safer about the prospect of the same session id being re-used for
            //a different respondent
            return ($"{tokenKeyPrefix}{sessionId}::{uid}").ToLowerInvariant();
        }
    }
}
