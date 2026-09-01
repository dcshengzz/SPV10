using System;
using System.Threading.Tasks;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using System.Collections.Generic;
using System.Security.Claims;

namespace swz.Clover.Core.Security
{
    //TODO - I'd prefer this to be scoped to ISecurityProvider but I think we need to switch to language version 8?
    /// <summary>
    /// For logic processing to tell precise status
    /// 
    /// NOTE:
    /// Instead simply return true/false (unless providing summarized result to the front end user, either success/failed without any reason) 
    /// With precise status returned, will be easier to understand for other people
    /// Refer to method FailedLoginByUser, it return HARD CODED string as the status
    /// </summary>
    public enum SecurityProcessingStatus
    {
        AccountSwitched,
        AccountLocked
    }

    //TODO - I'd prefer this to be scoped to ISecurityProvider but I think we need to switch to language version 8?
    /// <summary>
    /// Value indiciating the result of a call to ValidateUserByLoginAsync
    /// </summary>
    public enum ISecurityProvider_PasswordValidity { Valid, TotpRequired, Invalid }

    public interface ISecurityProvider
    {
        //[Obsolete] - commented out the [Obsolete] when not working on updating affected code because the hundreds of warnings add to much clutter, but you can consider it obsolete...
        /// <summary>
        /// 
        /// Try not to use this property in new code, use the GetCurrentUserAsync() method instead.
        /// The implementation of this in SecurityProvider just does a sync-over-async call to GetCurrentUserAsync()
        /// anyway. For more information see comments in the SecurityUser class.
        /// 
        /// Returns the current Security.User (if any) based on the logged in user in ASP.Net core.
        /// </summary>
        User CurrentUser { get; }

        /// <summary>
        /// Returns the current Security.User (if any) based on the logged in user in ASP.Net core.
        /// Use this in preference to the CurrentUser property wherever practical. 
        /// </summary>
        /// <returns>user or null</returns>
        Task<User> GetCurrentUserAsync();

        /// <summary>
        /// Get the clover Security.User with the specified id. If includeLockedUsers is false
        /// (the default) then this will return null for a locked user. It will also return
        /// null and not raise an exception if the user is not found.
        /// n.b. This replaces the old GetUserById(Guid id) method (implementations of which would
        /// hide their internal sync-over-async nature) in favour of an explicitly async interface
        /// which puts the onus on caller to deal with the async.
        /// </summary>
        /// <param name="id">Id of the user</param>
        /// <param name="includeLockedUsers">false by default, to allow finding a locked user set this to true</param>
        /// <returns>user or null if not found/locked</returns>
        Task<User> GetUserByIdAsync(Guid id, bool includeLockedUsers=false);

        bool CheckPermission(string group, string permission);
        bool CheckPermission(Guid userId, string groupPermissionCode, string permissionCode);

        /// <summary>
        /// Verify login details for a username:password login. Note that this DOES NOT log the
        /// user in if valid (need to call SignInAsync seperately for that). Value returned will
        /// indicate if valid password credential was supplied, and whether this user needs to 
        /// provide additional 2FA before they should be signed-in.
        /// This method does not audit log a login attempt, and for invalid login it does not give
        /// the details of why (eg password or locked etc. For those you need to call FailedLoginByUser.
        /// </summary>
        /// <param name="login"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        Task<ISecurityProvider_PasswordValidity> ValidateUserByLoginAsync(string login, string password);

        //TODO - this should return an enum, document that it also records a failed login. Maybe rename it?
        //TODO - update how we handle the appSettings arg (it only needs FailedPwdMaxAttempt)
        Task<string> FailedLoginByUser(string login, List<AppSettings> appSettings);

        SecurityCredential GetCredential(Guid id);

        Task<bool> WindowsAuthenticationValidateAndSignInAsync();
        Task SignInAsync(string login, bool remember, string ipAddress = null, string browserType = null);
        Task SignOutAsync();
        Task RefreshUserAsync(ClaimsPrincipal principal);

        Task<bool> CheckFormPermissionAsync(string formName, string permissionCode);
        Task<bool> CheckFormPermissionAsync(Form form, string permissionCode);

        Guid? GetSecurityUserId();
        Guid? GetStructDivisionId();
        bool IsInRole(string role);

        void ResetUserCache(string userId);

        Task<SecurityProcessingStatus> SwitchAccount(Guid userId);

        //TODO - why is this not a method on the User object instead?
        /// <summary>
        /// Does the current user have all the specified roles.
        /// </summary>
        /// <param name="codes">roles identified by their code</param>
        /// <returns></returns>
        bool HasAllRole(IEnumerable<string> codes);

        //TODO - why is this not a method on the User object instead?
        /// <summary>
        /// Does the current user have any of the specified roles
        /// </summary>
        /// <param name="codes">roles identified by their code</param>
        /// <returns></returns>
        bool HasAnyRole(IEnumerable<string> codes);

        //TODO - consider deprecating and removing the below method
        bool CheckAccess(string roleCode);
    }
}
