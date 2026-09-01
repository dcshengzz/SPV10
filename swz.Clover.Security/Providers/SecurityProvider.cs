using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using swz.Clover.Core;
using swz.Clover.Core.Security;
using swz.Clover.Core.License;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using swz.Clover.Security.Native;
using User = swz.Clover.Core.Security.User;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Collections.Concurrent;
using Microsoft.Extensions.Logging;

namespace swz.Clover.Security.Providers
{
    /// <summary>
    /// Standard (SurveyPlus version) implementation of the ISecurityProvider interface 
    /// A single shared instance will be created and set into the Clover runtime at startup to be exposed as 
    /// globally as ambient context via CloverRuntime.Security property.
    /// </summary>
    public class SecurityProvider : ISecurityProvider
    {
        public static readonly string licensefile = "license.key"; //exposed to faciliate checking its presence at startup

        //shared non-distributed cache of User objects for currently logged in users (and also those who didnt log out properly)
        private static readonly ConcurrentDictionary<string, User> UserCache = new ConcurrentDictionary<string, User>();

#if (DEBUG)
        public static void TROUBLESHOOTING_CLEAR_USER_CACHE() { UserCache.Clear(); } //For troubleshooting purposes only
#endif

        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly ILogger logger;

        public SecurityProvider(IHttpContextAccessor accessor, ILogger logger)
        {
            if (accessor == null) throw new ArgumentNullException(nameof(accessor));
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            httpContextAccessor = accessor;
            this.logger = logger;
            if(this.logger.IsEnabled(LogLevel.Trace))
            {  
                //This is to save us time next time by seeing if we got the trace logging configured right for this class
                //*before* we start trying to do the actual troubleshooting on it...
                this.logger.LogTrace("SecurityProvider constructor invoked");
            }
        }

        public async Task<User> GetUserByIdAsync(Guid id, bool includeLockedUsers)
        {
            SecurityUser user = await SecurityUser.SelectByKey(id);
            return (user == null || (user.IsLocked && !includeLockedUsers))
                ? null 
                : CreateUser(user);
        }

        ////TODO - remove later
        //[Obsolete]
        //public User GetUserByIdIncludeLocked(Guid id)
        //{
        //    //WARNING: below is sync-over-async
        //    SecurityUser user = SecurityUser.SelectByKey(id).Result;
        //    if (user == null)
        //        return null;

        //    return CreateUser(user);
        //}

        public Guid? GetSecurityUserId()
        {
            if (httpContextAccessor?.HttpContext?.User?.Claims == null)
                return null;
            string securityUserId = httpContextAccessor.HttpContext.User.Claims.Where(c => c.Type == ClaimTypes.Sid)
                .Select(c => c.Value).SingleOrDefault();
            return string.IsNullOrEmpty(securityUserId) ? (Guid?)null : new Guid(securityUserId);
        }

        public Guid? GetStructDivisionId()
        {
            if (httpContextAccessor?.HttpContext?.User?.Claims == null)
                return null;
            string structDivisionId = httpContextAccessor.HttpContext.User.Claims.Where(c => c.Type == ClaimTypes.GroupSid)
                .Select(c => c.Value).SingleOrDefault();
            return string.IsNullOrEmpty(structDivisionId) ? (Guid?)null : new Guid(structDivisionId);
        }

        public bool HasAllRole(IEnumerable<string> codes)
        {
            return CurrentUserHas(CheckHas.All, codes);
        }

        public bool HasAnyRole(IEnumerable<string> codes)
        {
            return CurrentUserHas(CheckHas.Any, codes);
        }

        private enum CheckHas { Any, All }
        private bool CurrentUserHas(CheckHas requires, IEnumerable<string> roleCodes)
        {
            bool haveRole = false;
            Dictionary<string, bool> resultDict = new Dictionary<string, bool>();
            if(roleCodes != null && roleCodes.Any())
            {
                foreach(string role in roleCodes) 
                {
                    resultDict[role] = false;
                    if (CheckAccess(role))
                    {
                        if (requires == CheckHas.Any)
                        {
                            haveRole = true;
                            break;
                        }
                        else
                        {
                            resultDict[role] = true;
                            continue;
                        }
                    }
                    else if (requires == CheckHas.All)
                    {
                        break;
                    }
                }
            }

            if (requires==CheckHas.All && resultDict.Any())
            {
                haveRole = resultDict.Values.Where(e => e == false).ToList().Any();
            }
            
            return haveRole;
        }

        public bool CheckAccess(string roleCode)
        {
            //below uses the sync-over-async CurrentUser property
            if (CurrentUser?.Id != null && IsInRole(roleCode)) return true;
            return false;
        }

        public bool IsInRole(string claimValue)
        {
            if (httpContextAccessor?.HttpContext?.User?.Claims == null)
                return false;
            return httpContextAccessor.HttpContext.User.HasClaim(c => c.Type == ClaimTypes.Role && c.Value == claimValue);
        }

        //TODO - is using Result here ok? safe wrt to deadlock? (in Netcore its deadlock safe but still a code-smell)
        //See for example: https://softwareengineering.stackexchange.com/questions/398998/how-to-justify-using-await-instead-of-result-or-wait-in-net-core
        //Netcore doesn't use the Synchronisation Context that would make this deadly in old .NET but this still blocks a thread
        //so there may be a chance of threadpool starvation?
        //For info on lack of SC in netcore: https://blog.stephencleary.com/2017/03/aspnetcore-synchronization-context.html
        //And I'd note that CurrentUser property is called in many places. It sees a lot of traffic (there's ~ 200 places referencing it).
        //See also: https://docs.microsoft.com/en-us/aspnet/core/performance/performance-best-practices?view=aspnetcore-3.1
        //And: https://github.com/davidfowl/AspNetCoreDiagnosticScenarios/blob/master/AsyncGuidance.md#warning-sync-over-async
        //Also: https://stackoverflow.com/a/13735418/8243046  <---  '"asynchronous properties" is an oxymoron.'
        //For more detail: https://blog.stephencleary.com/2013/01/async-oop-3-properties.html
        //For info on the (lack of a) SynchronizationContext in ASP.NET Core see https://blog.stephencleary.com/2017/03/aspnetcore-synchronization-context.html
        //So why is GetCurrentUserAsync async? Well, on the first hit it will read in the Clover license and check it (and
        //then remember if its valid for subsequent calls), and the other thing it will do is try to lookup the SecurityUser
        //based on the HttpContext (which it gets via an accessor of course) Identity.Name and stick that in the UserCache
        //and Items. So both these things involve async code , but only happen occasionally. On the happy path the asynchrony
        //isn't needed and so we aren't actully blocking the thread while waiting on IO, most hits are just going to be pulling
        //a SecurityUser from the UserCache. The very few times we do need to wait for license or lookup don't risk a deadlock since
        //this is netcore, so they just hold up the thread a while. As such it should not be a matter of great concern, though would be
        //nice to tidy it up at some point. 
        //2022-03-21 - am updating the behaviour to avoid the auto-login via property
        //2022-03-24 - updated the behaviour to avoid the auto-login via property
        public User CurrentUser => GetCurrentUserAsync().Result;

        #region license
        private static object LicenseRegoLock = new object(); //used in LicenseRegistrationCheck

        /// <summary>
        /// Register the license if this has yet to be done and then verify that the number of users provisioned in the
        /// system does not exceed the number permitted by the license.
        /// Will raise a LicenseException if necessary.
        /// </summary>
        private async Task LicenseRegistrationCheckAsync()
        {
            if (httpContextAccessor.HttpContext == null)
                throw new InvalidOperationException("There is no HttpContext so the check cannot be performed");

            //TODO - prefer to find some other place to handle the license (a license filter maybe, but needs to be in core or easy to bypass)
            //Note that the license check must be done while handling a request so we can check the current host vs what is in the license            
            lock (LicenseRegoLock)
            {
                if (!CloverRuntime.LicenseControl.Validated)
                {
                    string host = httpContextAccessor.HttpContext.Request.Host.Value;
                    //see also: https://stackoverflow.com/questions/18303334/request-url-host-vs-request-url-authority
                    logger.LogInformation("Host for licensing is {0}", host);
                    CloverRuntime.LicenseControl.Host = host;
                    CloverRuntime.LicenseControl.Validated = true;

                    if (File.Exists(licensefile))
                    {
                        logger.LogInformation("Registering license from {0}", licensefile);
                        string licenseText = File.ReadAllText(licensefile);
                        if (string.IsNullOrEmpty(licenseText))
                        {
                            logger.LogError("{0} is empty", licensefile);
                            CloverRuntime.LicenseControl.Message = $"{licensefile} is empty! Use {HardwareInfo.Value()} to request for a license key";
                        }
                        else
                        {
                            CloverRuntime.RegisterLicense(licenseText);
                        }
                    }
                    else
                    {
                        //nb: For SurveyPlus we have added an additional check for this file in IntranetConfigurator (to save time with new installations)
                        CloverRuntime.LicenseControl.Message = $"License key is not installed. Use {HardwareInfo.Value()} to request for a license key";
                        logger.LogError("{0} not found", licensefile);
                    }
                } //end if not validated yet                
            } //end lock
            bool licenseIsInvalid = !string.IsNullOrEmpty(CloverRuntime.LicenseControl.Message);
            if (licenseIsInvalid)
            {
                //At the time the license was validated (in RegisterLicense) the string we checked was set if that failed
                //or if the code to read the license didnt find the file
                if (!string.IsNullOrEmpty(CloverRuntime.LicenseControl.Message))
                    throw new LicenseException(CloverRuntime.LicenseControl.Message);
            }
            else
            {
                //var maxNumberOfUsers = Licensing.GetLicenseRestrictions<CloverRestrictions>().MaxNumberOfUsers;
                int maxNumberOfUsers = Licensing.GetMaxNumberOfCloverUsers();
                if (maxNumberOfUsers > 0) //nb: we use -1 to indicate unlimited
                {
                    long cnt = await SecurityUser.GetCountAsync();
                    if (cnt > maxNumberOfUsers)
                    {
                        try
                        {
                            LicenseKey<CloverRestrictions> key = Licensing.GetLicense<CloverRestrictions>();
                            logger.LogError("Failed license check for licensed number of users: ref={0}, license type={1}, licensed number of users={2}, provisioned users={3}", key?.Ref, key?.LicenseType, maxNumberOfUsers, cnt);
                        }
                        catch(Exception e)
                        {
                            logger.LogError(e, nameof(LicenseRegistrationCheckAsync) + " - caught unexpected exception");
                        }
                        throw new LicenseException("users", maxNumberOfUsers, cnt, HardwareInfo.Value());
                    }
                }
            }
        }
        #endregion license

        public async Task<User> GetCurrentUserAsync()
        {
            bool isNotHandlingRequest = (httpContextAccessor.HttpContext == null);
            if (isNotHandlingRequest)
            {
                //Current user is dependent on AspNetCore user from the request. If there's no request there's no current user
                return null;
            }
            else
            {
                bool isNoIdentityInRequest = (httpContextAccessor.HttpContext?.User?.Identity?.Name == null);
                if (isNoIdentityInRequest)
                {
                    return null;
                }
                else
                {
                    //First see if the User was set as item for request already (special case - e.g. during initial login request)
                    User currentUser = GetRequestItemsCurrentUser(); //typically returns null

                    //Normal flow to get the current user from UserCache based on Identity in the request
                    if (currentUser == null) currentUser = await GetCurrentUserByRequestIdentity();
                    bool loggedIn = (currentUser != null);

                    //Licence check here as it needs a request to know the host & only want to check after logged in
                    if (loggedIn) await LicenseRegistrationCheckAsync();

                    return currentUser;
                }
            }
        } 

        /// <summary>
        /// Get the user from the UserCache based on identity in the request and authenticate it. Will return the User or null
        /// if no authenticated. This method is intended only to be called by GetCurrentUserAsync. It will fail if there is no identity
        /// presented in the request.
        /// </summary>
        /// <returns></returns>
        /// <exception cref="InvalidOperationException"></exception>
        private async Task<User> GetCurrentUserByRequestIdentity()
        {
            //See if there is a User object for the user identified in request cached in local memory (non-distributed)
            string login = httpContextAccessor.HttpContext?.User?.Identity?.Name;
            if (string.IsNullOrEmpty(login))
                throw new InvalidOperationException("No identity in request");

            User user = GetUserCache(login);

            //Just because there is an object cached doesnt mean that user is actually logged in. Need to check against cookie (ASP.NET Core Identity)
            //Users only get removed from cache on an explicit logout action or apppool recycle (not if they lose cookie, close browser)
            AuthenticateResult authResult
                = await httpContextAccessor.HttpContext.AuthenticateAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            bool haveCacheLoginButEmptyCookie = user != null && !authResult.Succeeded;
            if (haveCacheLoginButEmptyCookie)
            {
                //only reach here with windows authentication mode on
                //because without browser presenting creds its the cookie that will let them be preserved
                //special handle if no cookie (cleared?) but the server has their account login info in the cache.
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(GetCurrentUserByRequestIdentity) + " - found User {0} in UserCache under key {1} but AuthenticateAsync did not succeed so will return null.", user.Name, login);
                }
                user = null; //The cookie has spoken
            }
            return user;
        }

        /// <summary>
        /// For use by SignInAsync / GetCurrentUserAsync
        /// Part of a workaround for AuthenticateAsync not succeeding during the initial request
        /// </summary>
        /// <param name="user">the user, or null to clear it</param>
        private void SetRequestItemsCurrentUser(User user)
        {
            if (httpContextAccessor.HttpContext == null) throw new InvalidOperationException("There is no HttpContext");
            //not intended to be a well known key! Use the method to access please!
            httpContextAccessor.HttpContext.Items["private_internal_b2a2717fa154_CurrentUser"] = user;
        }

        /// <summary>
        /// For use by GetCurrentUserAsync
        /// Part of a workaround for AuthenticateAsync not succeeding during the initial request
        /// In the current impl this value would only be here after the user sign-in on their sign-in request
        /// and null the rest of the time
        /// </summary>
        /// <returns>A User object stashed in the request by SetRequestItemsCurrentUser</returns>
        private User GetRequestItemsCurrentUser()
        {
            if (httpContextAccessor.HttpContext == null) return null;  //Could be the case if not coming via a controller (eg, hangfire jobs)
            //not intended to be a well known key! Use the method to access please!
            return (User)httpContextAccessor.HttpContext.Items["private_internal_b2a2717fa154_CurrentUser"];
        }

        /// <summary>
        /// Sign-in based on the windows authentication Identity presented in the HttpContext.
        /// Part of the magic that enable windows authentication (auto login without manual password required)
        /// Will verify the windows account is mapped and if so sign them in, delegating to SignInAsync to add to the HttpContext
        /// and audit the login. Will then update latest login date.
        /// </summary>
        /// <returns>true on success, false if no windows user or the windows user isn't mapped or is locked</returns>
        public async Task<bool> WindowsAuthenticationValidateAndSignInAsync()
        {
            string login = httpContextAccessor.HttpContext?.User?.Identity?.Name;
            if (string.IsNullOrWhiteSpace(login)) throw new InvalidOperationException("No Identity in HttpContext");
            SecurityUser su = await SecurityUser.SelectByPrincipal(login);

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("WindowsAuthenticationValidateAndSignInAsync: mapped {0} to {1}, locked={2}", login, su?.Name, su?.IsLocked);
            }

            if (su != null && !su.IsLocked)
            {
                //Create the security claim and sign them into the httpcontext (creates cookie). Will also audit log the sign in
                await SignInAsync(su, login, false);

                //Update LastLoginDate for AD linked user
                //TODO - change behaviour: this one shouldn't happen now, it should update for the alt accounts only when they log
                //into them (however this introduces the question of whether the al-accounts should be independent with regards to
                //being locked out after being inactive too long). Have logged this as git issue #152
                Dictionary<Guid, SecurityUser> alternativeAccounts = await SecurityUser.GetAlternativeAccount(su.Id, httpContextAccessor.HttpContext.User.Identity.Name, true);
                foreach (KeyValuePair<Guid, SecurityUser> userAccount in alternativeAccounts)
                {
                    await UpdateSignedInSecurityUserInfo(userAccount.Value);
                }
                return true;
            }
            else
            {
                //Audit Log for unknown user login (via Windows Authentication (Active Directory use case))
                await AuditHelper.AuditLogLoginFailed(login);
                return false;
            }
        }

        /// <summary>
        /// Create a User object from the details in the SecurityUser object passed
        /// </summary>
        /// <param name="securityUser"></param>
        /// <returns>User</returns>
        private static User CreateUser(SecurityUser securityUser)
        {
            if (securityUser == null) throw new ArgumentNullException(nameof(securityUser));
            User user = new User(securityUser.Id, securityUser.Name);
            user.IsLocked = securityUser.IsLocked;
            user.Email = securityUser.Email;
            user.Localization = securityUser.Localization;
            user.Timezone = securityUser.Timezone;
            user.StructDivisionId = securityUser.StructDivisionId;
            user.GaSalt = securityUser.GaSalt;
            user.LastLoginDate = securityUser.LastLoginDate;
            user.LinkedDomainLogin = securityUser.LinkedDomainLogin;
            user.IpAddress = securityUser.IpAddress;
            user.BrowserType = securityUser.BrowserType;
            if (securityUser.Roles.Value != null)
                user.Roles = securityUser.Roles.Value.Select(c => c.ToString()).ToList();
            else
                user.Roles = new List<string>();

            if (securityUser.Groups.Value != null)
                user.Groups = securityUser.Groups.Value.Select(c => c.ToString()).ToList();
            else
                user.Groups = new List<string>();

            return user;
        }

        public bool CheckPermission(string group, string permission)
        {
            if (CurrentUser == null)
                return false;

            return CheckPermission(CurrentUser.Id, group, permission);
        }

        public virtual bool CheckPermission(Guid userId, string groupPermissionCode, string permissionCode)
        {
            return SecurityUser.CheckPermission(userId, groupPermissionCode, permissionCode).Result;
        }

        /// <summary>
        /// Record a failed login attempt for the specified login. Will update the retry counter and
        /// log the failure in the audit trail. If necessary will lock the user.
        /// </summary>
        /// <param name="login"></param>
        /// <param name="appSettings"></param>
        /// <returns>a string indicating the outcome, one of: Incorrect, Locked, JustLocked </returns>
		public virtual async Task<string> FailedLoginByUser(string login, List<AppSettings> appSettings)
		{
            //TODO - appSettings is too vague. Should either look them up itself, or should require some
            //       object that encapsulates the desired settings

            //TODO: instead by hardcode string, enum status could be better
			//Incorrect
			//Locked
			//JustLocked
			String result;
			SecurityCredential credential = await SecurityUser.GetCredentialByLogin(login);
            bool knownUser = (credential != null);
            if (!knownUser)
            {
                //If the user doesn't exist then we don't log this in the audit trail
                result = "Incorrect";
            }
            else
            {
                SecurityUser su = await SecurityUser.SelectByKey(credential.SecurityUserId);

                //Audit Log for login failed with valid username (via username/password)
                await AuditHelper.AuditLogLoginFailed(su.Id, null, su.StructDivisionId);

                //This user is already locked
                if (su == null || su.IsLocked)
                {
                    result = "Locked";
                }
                else
                {
                    //Increment the retry counter and lock the user if necessary
                    short maxNumRetry = Int16.Parse(appSettings.FirstOrDefault(c => c.Name == "FailedPwdMaxAttempt")?.Value);
                    bool limitedRetries = (maxNumRetry > -1);

                    su.StartTracking();
                    //int numRetryCount = su.NumRetry;
                    //su.NumRetry = numRetryCount + 1;
                    su.NumRetry++;                    
                    if (limitedRetries && (su.NumRetry > maxNumRetry))
                    {
                        su.IsLocked = true;
                        result = "JustLocked";
                        logger.LogInformation("FailedLoginByUser is locking user after {0} retries, login={1}", su.NumRetry, login);
                    } 
                    else
                    {
                        result = "Incorrect";
                    }
                    await su.ApplyAsync(); //update user in db
                }
            }
            logger.LogError("FailedLoginByUser login={0}, knownUser={1}, result={2}", login, knownUser, result);
            return result;
		}

		public virtual async Task<ISecurityProvider_PasswordValidity> ValidateUserByLoginAsync(string login, string password)
        {
            SecurityCredential credential = await SecurityUser.GetCredentialByLogin(login);
            if (credential == null)
            {
                //Audit Log for unknown user login (via username/password)
                await AuditHelper.AuditLogLoginFailed("Intranet username: " + login);
                return ISecurityProvider_PasswordValidity.Invalid;
            }

            if (ValidateCredential(credential, password))
            {
                SecurityUser su = await SecurityUser.SelectByKey(credential.SecurityUserId);
                if (su != null && su.IsLocked == false)
                {
                    return  credential.RequireTotp 
                        ? ISecurityProvider_PasswordValidity.TotpRequired 
                        : ISecurityProvider_PasswordValidity.Valid;
                }
            }

            return ISecurityProvider_PasswordValidity.Invalid;
        }

        private bool ValidateCredential(SecurityCredential credential, string password)
        {
            bool valid = false;
            if (credential.AuthenticationType == (byte)AuthenticationType.Generic)
            {
                if (credential.PasswordSalt == null || credential.PasswordHash == null)
                {
                    //If the user has no password set then they can't login via password login mechanism
                    valid = false;
                }                    
                else
                {
                    valid = (HashHelper.GenerateStringHash(password, credential.PasswordSalt) == credential.PasswordHash);
                }
            }
            else if (credential.AuthenticationType == (byte)AuthenticationType.Domain)
            {
                //TODO - Consider removing this logic as I believe this code is no longer in use, and can not be considered as maintained
                IntPtr token = IntPtr.Zero;
                try
                {
                    string[] name = credential.Login.Split('\\');
                    if (name.Count() != 2)
                        return false;

                    string loginName = name[1];
                    string domain = name[0];

                    token = NativeMethods.LogonUser(loginName, password, domain);

                    valid = token != IntPtr.Zero;
                }
                finally
                {
                    NativeMethods.CloseHandle(token);
                }
            }
            return valid;
        }

        public SecurityCredential GetCredential(Guid userId)
        {
            SecurityUser user = SecurityUser.SelectByKey(userId).Result;
            if (user != null && !user.IsLocked)
            {
                Filter filter = Filter.And.Equal(userId, Constants.FieldName.dwSecurityCredential.SecurityUserId);
                List<SecurityCredential> credentials = SecurityCredential.SelectAsync(filter).Result;
                if (credentials.Count > 0)
                    return credentials[0];
            }
            return null;
        }

        public async Task SignInAsync(string login, bool remember, string ipAddress=null, string browserType=null)
        {
            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("SignInAsync for login={0}, remember={1}", login, remember);
            }
            SecurityCredential credential = await SecurityUser.GetCredentialByLogin(login);
            if (credential == null)
                throw new Exception($"Can't find credentials for login {login}");
            SecurityUser su = await SecurityUser.SelectByKey(credential.SecurityUserId);
            await SignInAsync(su, login, remember, ipAddress, browserType);
        }

        /// <summary>
        /// If the AppPool gets recycled then the UserCache would be cleared, but the user will still have a valid
        /// cookie and ASP.NET Core will use that to populate a valid authenticated principal in HttpContext.User.
        /// So ASP knows about the user but Clover has forgotten them. This method will fetch the SecurityUser details
        /// from db again and restore the entry in UserCache.
        /// Intended to be called from the AuthorizationFilter. 
        /// </summary>
        /// <param name="principal">HttpContext.User</param>
        /// <returns>the SecurityUser (for reference)</returns>
        public async Task RefreshUserAsync(ClaimsPrincipal principal)
        {
            if (principal == null) 
                throw new ArgumentNullException(nameof(principal));
            if(principal.Identity==null || !(principal.Identity is ClaimsIdentity)) 
                throw new ArgumentException(nameof(principal), "principal is not using a ClaimsIdentity");
            if(!principal.Identity.IsAuthenticated)
                throw new ArgumentException(nameof(principal), "principal is not authenticated");
            string login = principal?.Identity?.Name;
            if (string.IsNullOrWhiteSpace(login)) 
                throw new ArgumentException(nameof(principal), "principal lacks a name"); 

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("RefreshUserAsync called for authenticated principal.Identity.Name={0}", login);
            }

            SecurityUser su = await SecurityUser.SelectByPrincipal(login);
            if (su == null)
                throw new InvalidOperationException(login + " does not map to a Clover SecurityUser");

            AddUserCache(login, su);
        }

        /// <summary>
        /// Register ClaimsIdentity with the HttpContext and log it in the audit trail as a sign in
        /// </summary>
        /// <param name="su"></param>
        /// <param name="login"></param>
        /// <param name="remember"></param>
        /// <param name="ipAddress"></param>
        /// <param name="browserType"></param>
        /// <returns></returns>
        public async Task SignInAsync(SecurityUser su, string login, bool remember, string ipAddress=null, string browserType=null)
        {
            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation("SignInAsync for su.Name={0}, login={1}, remember={2}, su.Id={3}", 
                    su?.Name, login, remember, su?.Id);
            }
            List<string> roles = su.Roles == null ? new List<string>() : su.Roles.Value;
            ClaimsIdentity id = CreateSecurityClaim(su.Id, login, su.StructDivisionId, roles);
            ClaimsPrincipal principal = new ClaimsPrincipal(id);
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("HttpContextSignIn with ClaimsIdentity for login={0}, Identity.Name={1}", login, id.Name);
            }
            await httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                principal,
                new Microsoft.AspNetCore.Authentication.AuthenticationProperties() { IsPersistent = remember }
            );

            //add user to cache after login successful and update the LastLoginDate
            AddUserCache(login, su);

            //Nb: At this point although we've supposedly signed them into the context a call to HttpContext.AuthenticateAsync
            //    would still return false (I think, but am not certain it needs the cookie presented in the request to succeed)
            //    and GetCurrentUserAsync uses that, so as a workaround we will add the User to the HttpContext Items.
            SetRequestItemsCurrentUser(CreateUser(su));
            await UpdateSignedInSecurityUserInfo(su, ipAddress, browserType); //nb: this can trigger a license exception if unlicense (orm using CurrentUser to audit?)

            //audit
            await AuditHelper.AuditLog(su.Id, null, su.StructDivisionId, "Login");
        }

        public async Task SignOutAsync()
        {
            User user = CurrentUser;
            //audit
            if (CurrentUser != null)
            {
                await AuditHelper.AuditLog(user.Id, null,CurrentUser?.StructDivisionId, "LogOff");
            }
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("SignOutAsync user={0}", user?.Name);
            }
            await httpContextAccessor.HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            if (httpContextAccessor.HttpContext.User?.Identity?.Name != null)
            {
                ResetUserCache(httpContextAccessor.HttpContext.User.Identity.Name);
            }

            SetRequestItemsCurrentUser(null);
        }

        public async Task<bool> CheckFormPermissionAsync(string formName, string permissionName)
        {
            Form form = CloverRuntime.Metadata.GetForm(formName); //20260701 - was CR.M
            if (form == null)
                throw new Exception("This form is not found!");

            return await CheckFormPermissionAsync(form, permissionName);
        }

        public async Task<bool> CheckFormPermissionAsync(Form form, string permissionCode)
        {
            return string.IsNullOrEmpty(form?.SecurityGroup) ||
                   await SecurityUser.CheckPermission(CurrentUser?.GetOperationUserId() ?? Guid.Empty, form.SecurityGroup, permissionCode);
        }

        #region UserCache access encapsulate
        /// <summary>
        /// This clears the UserCache either entirely (if no argument passed) or removes the
        /// cached User for the specified login only
        /// </summary>
        /// <param name="login">(optional) just remove user identified by this login</param>
        public void ResetUserCache(string login = null)
        {
            if (string.IsNullOrEmpty(login))
                UserCache.Clear();
            else
                UserCache.TryRemove(login, out _);
        }

        /// <summary>
        /// Add a User to the cache under the specified login id, creating a
        /// User object based on the details in the SecurityUser object that is passed
        /// </summary>
        /// <param name="login"></param>
        /// <param name="user"></param>
        protected void AddUserCache(string login, SecurityUser user)
        {
            AddUserCache(login, CreateUser(user) );
        }

        /// <summary>
        /// Add specified User to the cache under the specified login id
        /// </summary>
        /// <param name="login"></param>
        /// <param name="user"></param>
        private void AddUserCache(string login, User user)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("AddUserCache: {0}, {1}", login, user?.Name);
            }
            UserCache.TryAdd(login, user);
        }

        /// <summary>
        /// This doesn't get the cache it gets a User from the cache (indexed by login)
        /// </summary>
        /// <param name="login"></param>
        /// <returns>User record if in the UserCache, null otherwise</returns>
        private User GetUserCache(string login)
        {
            User result = null;
            UserCache.TryGetValue(login, out result);
            return result;
        }
        #endregion

        #region Switch account feature (Windows Authenticate)
        /// <summary>
        /// Switch to account without password required.
        /// Will perform SignOut and SignIn.
        /// </summary>
        /// <param name="userId">Security User Id of the selected account</param>
        /// <returns>
        /// SecurityProcessingStatus.AccountLocked if the account is locked.
        /// SecurityProcessingStatus.AccountSwitched if the process is completed.
        /// </returns>
        public async Task<SecurityProcessingStatus> SwitchAccount(Guid userId)
        {
            if (userId == Guid.Empty) throw new ArgumentNullException(nameof(userId));
            Dictionary<Guid, SecurityUser> altAccDict = await SecurityUser.GetAlternativeAccount(CurrentUser);
            if (!altAccDict.ContainsKey(userId)) throw new UnauthorizedAccessException($"{CurrentUser.Name} ({CurrentUser.Id}) attempt to access {userId} account by switch account but without valid Linked Domain Login.");
            
            SecurityProcessingStatus result;
            SecurityUser selectedDBUser = await SecurityUser.GetUserById(userId);
            if (selectedDBUser == null) throw new NullReferenceException($"Missing record from SecurityUser. Id: {userId}");

            if (selectedDBUser.IsLocked)
            {
                result = SecurityProcessingStatus.AccountLocked;
            }
            else
            {
                SecurityCredential[] domainCredentialArr = await SecurityUser.GetCredentialByUserId(selectedDBUser.Id);
                SecurityCredential selectedCredential = null;
                if (domainCredentialArr == null || !domainCredentialArr.Any()) throw new NullReferenceException($"Missing record from SecurityCredential. SecurityUserId: {selectedDBUser.Id}");

                if (domainCredentialArr.Length == 1)
                    selectedCredential = domainCredentialArr[0];
                else//If there are more than one, definitely have Domain Login. Currently switch account feature is build for Domain Login, so use that one instead.
                    selectedCredential = domainCredentialArr.Where(e => e.AuthenticationType == (byte)AuthenticationType.Domain).First();

                string ipAddress = CurrentUser.IpAddress;
                string browserType = CurrentUser.BrowserType;

                await SignOutAsync();

                bool remember = false;
                await SignInAsync(selectedCredential.Login, remember, ipAddress, browserType);
                //SetRequestItemsCurrentUser(user);

                //TODO: Refer to ValidateUserByLoginAsync for the same logic
                AddUserCache(selectedCredential.Login, selectedDBUser);

                await UpdateSignedInSecurityUserInfo(selectedDBUser, ipAddress, browserType);

                result = SecurityProcessingStatus.AccountSwitched;
            }
            return result;
        }

        #endregion

        /// <summary>
        /// Update user details for user login via username and password.
        /// Reset NumRetry, update LastLoginDate, IpAddress, BrowserType.
        /// </summary>
        /// <param name="user">Signed in user</param>
        /// <param name="ipAddress">Ip Address of user</param>
        /// <param name="browserType">Browser Type of user</param>
        /// <returns></returns>
        protected static async Task UpdateSignedInSecurityUserInfo(SecurityUser user, string ipAddress, string browserType)
        {
            user.StartTracking();
            user.LastLoginDate = DateTime.Now;
            user.DormancyDate = null;
            user.NumRetry = 0;
            user.IpAddress = ipAddress;
            user.BrowserType = browserType;

            await user.ApplyAsync();
        }

        private ClaimsIdentity CreateSecurityClaim(Guid userId, string login, Guid? structDivisionId, List<string> roles)
        {
            //JwtRegisteredClaimNames.AuthTime & Jti are defined in System.IdentityModel.Tokens.Jwt
            //package which swz.Clover.Security doesn't have a dependency on (update the below if we add one later)
            const string JwtRegisteredClaimNames_AuthTime = "auth_time";
            const string JwtRegisteredClaimNames_Jti = "jti";

            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames_AuthTime, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64),
                new Claim(JwtRegisteredClaimNames_Jti, Guid.NewGuid().ToString()),
                new Claim(ClaimsIdentity.DefaultNameClaimType, login),
                new Claim(ClaimTypes.Sid, userId.ToString()),
                new Claim(ClaimTypes.GroupSid, structDivisionId?.ToString())
            };

            if (roles != null && roles.Any())
            {
                foreach (var role in roles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role));
                }
            }

            ClaimsIdentity result = new ClaimsIdentity(claims, "ApplicationCookie", ClaimsIdentity.DefaultNameClaimType, ClaimsIdentity.DefaultRoleClaimType);

            return result;
        }
        
        /// <summary>
        /// Update user details for user login via Active Directory.
        /// Update LastLoginDate
        /// </summary>
        /// <param name="user">Signed in user</param>
        /// <returns></returns>
        private static async Task UpdateSignedInSecurityUserInfo(SecurityUser user)
        {
            user.StartTracking();
            user.LastLoginDate = DateTime.Now;
            await user.ApplyAsync();
        }

    }
}
