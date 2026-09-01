using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.IdentityAccessManagement.Domain;
using swz.SurveyPlus.IdentityAccessManagement.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Email = swz.SurveyPlus.IdentityAccessManagement.Domain.Common.Email;

namespace swz.SurveyPlus.IdentityAccessManagement
{
    public class IamApplication
    {
        public async static Task<User> GetUser(string iamLogin, Guid userId)
        {
            SecurityCredential iamCredential = await SecurityUser.GetCredentialByLogin(iamLogin);
            Clover.Core.Security.User iamUser = await CloverRuntime.Security.GetUserByIdAsync(iamCredential.SecurityUserId, includeLockedUsers: true);

            User u = await GetUser(userId);
            if (u.id != null)
            {
                string o = JsonConvertEx.SerializeObject(u);
                await InsertAuditLog.InsertAuditLogAsync(iamUser.Id, null, Guid.NewGuid(), DateTime.Now, "Read", "dwSecurityUser", userId, null, null, o, iamUser.StructDivisionId);
            }

            return u;
        }

        public async static Task<User> GetUser(Guid userId)
        {
            if(Guid.Empty == userId)
                throw new ArgumentException("Invalid User ID");
            SecurityUser securityUser = await SecurityUser.SelectByKey(userId);
            if (securityUser == null)
                throw new ArgumentException("Invalid User ID");
            SecurityCredential[] credentials = await SecurityUser.GetCredentialByUserId(userId);
            Clover.Core.Metadata.User metadataUser = Clover.Core.Metadata.User.Create(securityUser, credentials.ToList(),
                                    await SecurityGroupToSecurityUser.SelectByUser(userId),
                                    await SecurityUserToSecurityRole.SelectByUser(userId));


            List<Roles> listRoles = new List<Roles>();

            foreach (Guid role in metadataUser.Roles)
            {
                Roles roles = new Roles { value = role.ToString(), display = (await SecurityRole.SelectByKey(role)).Name };
                listRoles.Add(roles);
            }

            User user = new User
            {
                id = userId.ToString(),
                meta = new Meta { resourceType = "User", created = metadataUser.CreatedDate, lastModified = metadataUser.UpdatedDate },
                userName = metadataUser.Login,
                displayName = metadataUser.Name,
                active = !metadataUser.IsLocked,
                emails = new List<Email> { new Email { primary = true, value = metadataUser.Email, type = "work" } },
                roles = listRoles,

                extensionCamUser = new ExtensionCamUser
                {
                    lastLogin = metadataUser.LastLoginDate,
                    isPrivileged = true
                }
            };

            return user;
        }

        public async static Task<UserList> GetUserList(string iamLogin, ListInput input)
        {
            string logs = "Request:\n";
            logs += "input.ascOrderBy = " + input.ascOrderBy + "\n";
            logs += "input.descOrderBy = " + input.descOrderBy + "\n";
            logs += "input.itemsPerPage = " + input.itemsPerPage + "\n";
            logs += "input.startIndex = " + input.startIndex + "\n";
            logs += "input.filter = " + input.filter + "\n";
            logs += "Response:\n";

            SecurityCredential iamCredential = await SecurityUser.GetCredentialByLogin(iamLogin);
            Clover.Core.Security.User iamUser = await CloverRuntime.Security.GetUserByIdAsync(iamCredential.SecurityUserId, includeLockedUsers: true);

            UserList ul = await GetUserList(input);
            string o = JsonConvertEx.SerializeObject(ul);

            await InsertAuditLog.InsertAuditLogAsync(iamUser.Id, null, Guid.NewGuid(), DateTime.Now, "Read", "dwSecurityUser", null, null, null, (logs + o), iamUser.StructDivisionId);

            return ul;
        }

        public async static Task<UserList> GetUserList(ListInput input)
        {
            //users ignore list (do not show to cam list)
            string iamIgnoreUsersValue = (await AppSettings.SelectByKey(SurveyPlus.Application.Constants.dwAppSettingName.IamIgnoreLogins)).Value;
            List<string> iamIgnoreUsers = iamIgnoreUsersValue != null ? Array.ConvertAll(iamIgnoreUsersValue.Split(','), p => p.Trim()).ToList() : null;
            List<Guid> listUserId = (await SecurityUser.GetListSecurityUserAndExcludeName(iamIgnoreUsers)).Select(c => c.Id).ToList();
            IList<User> listUser = new List<User>();

            foreach (Guid id in listUserId)
            {
                listUser.Add(await GetUser(id));
            }

            switch (input.descOrderBy)
            {
                case "userId":
                    listUser = listUser.OrderBy(c => c.id).Reverse().ToList();
                    break;
                case "userName":
                    listUser = listUser.OrderBy(c => c.userName).Reverse().ToList();
                    break;
                default:
                    break;
            }

            switch (input.ascOrderBy)
            {
                case "userId":
                    listUser = listUser.OrderBy(c => c.id).ToList();
                    break;
                case "userName":
                    listUser = listUser.OrderBy(c => c.userName).ToList();
                    break;
                default:
                    break;
            }


            int startIndex = input.startIndex;
            if (startIndex < 1)
            {
                startIndex = 1;
            }

            int itemsPerPage = input.itemsPerPage;
            if (itemsPerPage == 0)
            {
                itemsPerPage = listUser.Count;
            }

            int totalResults = listUser.Count;

            IList<User> list = new List<User>();

            for (int i = startIndex - 1; i < startIndex - 1 + itemsPerPage; i++)
            {
                if (i < listUser.Count)
                {
                    list.Add(listUser[i]);
                }
                else
                {
                    break;
                }
            }

            return new UserList
            {
                totalResults = totalResults,
                itemsPerPage = itemsPerPage,
                startIndex = startIndex,
                Resources = list
            };

        }

        public async static Task<User> SetUserActivityStatus(string iamLogin, Guid userId, bool activityStatus)
        {
            SecurityCredential iamCredential = await SecurityUser.GetCredentialByLogin(iamLogin);
            Clover.Core.Security.User iamUser = await CloverRuntime.Security.GetUserByIdAsync(iamCredential.SecurityUserId, includeLockedUsers: true);

            SecurityUser securityUser = await SecurityUser.SelectByKey(userId);
            if (securityUser != null)
            {
                bool oriIsLocked = securityUser.IsLocked;

                securityUser.StartTracking();
                if (securityUser.IsLocked && activityStatus)
                {
                    securityUser.IsLocked = !activityStatus;
                    securityUser.NumRetry = 0;
                }
                else
                {
                    securityUser.IsLocked = !activityStatus;
                }
                await securityUser.ApplyAsync();

                await InsertAuditLog.InsertAuditLogAsync(iamUser.Id, null, Guid.NewGuid(), DateTime.Now, "Update", "dwSecurityUser", securityUser.Id, "isLocked", oriIsLocked.ToString(), securityUser.IsLocked.ToString(), iamUser.StructDivisionId);
            }

            return await GetUser(userId);
        }

        /// <summary>
        /// Implements the CAM delete action by locking the user and removing all roles.
        /// The user record remains to support audit purposes.
        /// </summary>
        public async static Task<string> DeleteUser(string iamLogin, Guid userId)
        {
            SecurityCredential iamCredential = await SecurityUser.GetCredentialByLogin(iamLogin);
            Clover.Core.Security.User iamUser = await CloverRuntime.Security.GetUserByIdAsync(iamCredential.SecurityUserId, includeLockedUsers: true);

            SecurityUser securityUser = await SecurityUser.SelectByKey(userId);
            if (securityUser != null)
            {
                Guid eventBatch = Guid.NewGuid();

                bool oriIsLocked = securityUser.IsLocked;

                securityUser.StartTracking();
                securityUser.IsLocked = true;
                await securityUser.ApplyAsync();

                await InsertAuditLog.InsertAuditLogAsync(iamUser.Id, null, eventBatch, DateTime.Now, "Update", "dwSecurityUser", securityUser.Id, "isLocked", oriIsLocked.ToString(), securityUser.IsLocked.ToString(), iamUser.StructDivisionId);

                List<SecurityUserToSecurityRole> securityUserToSecurityRoles = await SecurityUserToSecurityRole.SelectByUser(securityUser.Id);
                foreach (SecurityUserToSecurityRole securityUserToSecurityRole in securityUserToSecurityRoles)
                {
                    await InsertAuditLog.InsertAuditLogAsync(iamUser.Id, null, eventBatch, DateTime.Now, "Delete", "SecurityUserToSecurityRole", securityUserToSecurityRole.Id, "Id", JsonConvert.SerializeObject(securityUserToSecurityRole), "", iamUser.StructDivisionId);

                    await securityUserToSecurityRole.DeleteAsync();
                }

                return securityUser.Id.ToString();
            }
            else
            {
                return "";
            }
        }
    }
}
