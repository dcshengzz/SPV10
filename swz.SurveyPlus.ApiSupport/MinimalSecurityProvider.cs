using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using swz.Clover.Core.Security;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using User = swz.Clover.Core.Security.User;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using static swz.Clover.Core.Security.ISecurityProvider;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// Minimal placeholder implementation of the ISecurityProvider interface for use on the Internet side.
    /// Supports GetSampleId and GetSession, but most other methods return null or throw a NotImplementedException.
    /// GetSample was a tangential kludge tacked on for the internet. (The business of the ISecurityProvider is dealing with Clover
    /// SecurityUser and the associated features and the internet side does not use these.)
    /// </summary>
    public class MinimalSecurityProvider : ISecurityProvider
    {
        private const string ApiNotSupported = "The complete ISecurityProvider API is not supported here";

        private readonly IHttpContextAccessor _accessor;
        private readonly ISession _session;

        public MinimalSecurityProvider(IHttpContextAccessor accessor)
        {
            _accessor = accessor;
            _session = _accessor?.HttpContext?.Session;
        }

        public ISession GetSession()
        {
            return _session;
        }

        public async Task<User> GetUserByIdAsync(Guid id, bool includeLockedUsers)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        //TODO - remove later
        [Obsolete]
        public User GetUserByIdIncludeLocked(Guid id)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Guid? GetSecurityUserId()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Guid? GetStructDivisionId()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public bool IsInRole(string claimValue = "Admins")
        {
            //Throw exception rather than just return false as we want to see if anything is trying to use this
            throw new NotImplementedException(ApiNotSupported);
        }

        /// <summary>
        /// Samples are not represented by Clover users and Clover users can't login here
        /// </summary>
        public User CurrentUser => null;

        public async Task<User> GetCurrentUserAsync()
        {
            return null;
        }

        public bool CheckPermission(string group, string permission)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public virtual bool CheckPermission(Guid userId, string groupPermissionCode, string permissionCode)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public async Task<ISecurityProvider_PasswordValidity> ValidateUserByLoginAsync(string login, string password)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        private bool ValidateCredential(SecurityCredential credential, string password)
        {
            throw new NotImplementedException(ApiNotSupported);
        }
        
        public SecurityCredential GetCredential(Guid userId)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public async Task SignInAsync(string login, bool remember, string ipAddress, string browserType)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public async Task<bool> WindowsAuthenticationValidateAndSignInAsync()
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public async Task SignOutAsync()
        {
            throw new NotImplementedException(ApiNotSupported);  //Internet login doesn't use Clover/Asp auth mechanism
        }

        public async Task<bool> CheckFormPermissionAsync(string formName, string permissionName)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public async Task<bool> CheckFormPermissionAsync(Form form, string permissionCode)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public void ResetUserCache(string login = null)
        {
            ; //20230206 - Changed to a no-op instead of throwing an exception as called by resetappcache
        }

        //this method wasn't in internet side's version of the interface before unification
        public Task<string> FailedLoginByUser(string login, List<AppSettings> appSettings)
        {
            throw new NotImplementedException();
        }

        Task<SecurityProcessingStatus> ISecurityProvider.SwitchAccount(Guid userId)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        bool ISecurityProvider.HasAllRole(IEnumerable<string> ignored)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        bool ISecurityProvider.HasAnyRole(IEnumerable<string> ignored)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        bool ISecurityProvider.CheckAccess(string ignored)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task RefreshUserAsync(ClaimsPrincipal principal)
        {
            throw new NotImplementedException(ApiNotSupported);
        }
    }
}
