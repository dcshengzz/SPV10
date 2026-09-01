using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata
{
    public class User : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string Login;
        public string LinkedDomainLogin; //Currently only used to build for switch account menu feature, nothing related to security credential validation process
        public string Password;
        public string DomainLogin;
        public string Email;
        public bool IsLocked;
        public string ExternalId;
        public string Timezone;
        public string Localization;
        public string DecimalSeparator;
        public string PageSize;
        public string StartPage;
        public bool IsRTL;
        public List<Guid> Roles;
        public List<Guid> Groups;

        public string RolesStr;
        public string GroupsStr;

        public Guid? StructDivisionId;
        public bool RequireTotp;
        public bool EmailTotp; //for new user

		public DateTime? LastLoginDate;
		public int NumRetry;
		public string IpAddress;
		public string BrowserType;

        public Guid? CreatedBy;
        public DateTime? CreatedDate;
        public Guid? UpdatedBy;
        public DateTime? UpdatedDate;

        [DbObjectModel]
		public static User Create(SecurityUser c, List<SecurityCredential> credentials, List<SecurityGroupToSecurityUser> usergroup, List<SecurityUserToSecurityRole> userroles)
        {
            return new User()
            {
                Id = c.Id,
                Name = c.Name,
                Login = credentials
                     .Where(credential => credential.SecurityUserId == c.Id && credential.AuthenticationType == 0)
                    .Select(credential => credential.Login).FirstOrDefault(),
                //Currently we store the 2fa flag on the password credentials row. Its not used for the domain row
                RequireTotp = credentials
                    .Where(credential => credential.SecurityUserId == c.Id && credential.AuthenticationType == 0)
                    .Select(credential => credential.RequireTotp).FirstOrDefault(),
                DomainLogin = credentials
                    .Where(credential => credential.SecurityUserId == c.Id && credential.AuthenticationType == 1)
                    .Select(credential => credential.Login).FirstOrDefault(),                
                LinkedDomainLogin = c.LinkedDomainLogin ?? string.Empty,
				Email = c.Email ?? string.Empty,
				IsLocked = c.IsLocked,
				ExternalId = c.ExternalId,
				Timezone = c.Timezone,
				Localization = c.Localization,
				Roles = userroles.Where(p => p.SecurityUserId == c.Id).Select(p => p.SecurityRoleId).ToList(),
				Groups = usergroup.Where(p => p.SecurityUserId == c.Id).Select(p => p.SecurityGroupId).ToList(),
				RolesStr = string.Join(", ", userroles.Where(p => p.SecurityUserId == c.Id).Select(p => p.SecurityRoleCode)),
				GroupsStr = string.Join(", ", usergroup.Where(p => p.SecurityUserId == c.Id).Select(p => p.SecurityGroupCode)),
				StructDivisionId = c.StructDivisionId,
				NumRetry = c.NumRetry,
				LastLoginDate = c.LastLoginDate,
				IpAddress = c.IpAddress,
				BrowserType = c.BrowserType,
                CreatedBy = c.CreatedBy,
                CreatedDate = c.CreatedDate,
                UpdatedBy = c.UpdatedBy,
                UpdatedDate = c.UpdatedDate
			};
        }

        public static List<User> Create(List<SecurityUser> users, List<SecurityCredential> credentials,
            List<SecurityGroupToSecurityUser> usergroup, List<SecurityUserToSecurityRole> userroles)
        {
            var res = users.Select(c => Create(c, credentials, usergroup, userroles)).ToList();
            
            return res;
        }
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as User)?.Id == Id);
        
        public SecurityUser ToDbObject()
        {
            return new SecurityUser()
            {
                Id = Id,
                Name = Name,
                Email = Email,
                IsLocked = IsLocked,
                ExternalId = ExternalId,
                Timezone = Timezone,
                Localization = Localization,
                StructDivisionId = StructDivisionId,
                GaSalt = null, //this is no longer exposed in the User but is part of the SecurityUser
				LastLoginDate = LastLoginDate,
				NumRetry = NumRetry,
				IpAddress = IpAddress,
				BrowserType = BrowserType,
                CreatedBy = CreatedBy,
                CreatedDate = CreatedDate,
                UpdatedBy = UpdatedBy,
                UpdatedDate = UpdatedDate,
                LinkedDomainLogin = LinkedDomainLogin
	        };
        }

        public SecurityCredential GetDomainCredential()
        {
            if (string.IsNullOrWhiteSpace(DomainLogin))
                return null;
            
            return new SecurityCredential()
            {
                Id = Guid.NewGuid(),
                SecurityUserId = Id,
                AuthenticationType = 1,
                Login = DomainLogin
            };
        }
        
        public SecurityCredential GetCustomCredential()
        {
            if (string.IsNullOrWhiteSpace(Login))
                return null;
            
            string passwordsalt = null;
            string passwordhash = null;

            if (Password != null)
            {
                passwordsalt = HashHelper.GenerateSalt();
                passwordhash = HashHelper.GenerateStringHash(Password, passwordsalt);
            }

            return new SecurityCredential()
            {
                Id = Guid.NewGuid(),
                SecurityUserId = Id,
                AuthenticationType = 0,
                Login = Login,
                RequireTotp = RequireTotp,
                PasswordSalt = passwordsalt,
                PasswordHash = passwordhash
            };
        }
        
        public List<DbObject<SecurityCredential>> GetCredentials()
        {
            var custom = GetCustomCredential();
            var domain = GetDomainCredential();
            var res = new List<DbObject<SecurityCredential>>();
            if(custom != null)
                res.Add(custom);
            
            if(domain != null)
                res.Add(domain);

            return res;
        }

        /// <summary>
        /// Kludge to expose the LoadList method for use by implementation such as InternetApiMetadataProvider in the internet side, which has been moved out of Core to internet's
        /// Application as it is a specialised implementation for use in internet.
        /// </summary>
        /// <param name="skip"></param>
        /// <param name="take"></param>
        /// <param name="filterStr"></param>
        /// <param name="sort"></param>
        /// <param name="structDivisionId"></param>
        /// <returns></returns>
        public async static Task<object> LoadListExposedForMetadataProviderImplementations(int skip, int take, string filterStr, string sort, string structDivisionId = null)
        {
            return await LoadList(skip, take, filterStr, sort, structDivisionId);
        }

        internal async static Task<object> LoadList(int skip, int take, string filterStr, string sort, string structDivisionId = null)
        {
            Order order = Order.Empty;
            if (!string.IsNullOrEmpty(sort))
            {
                var sortEl = sort.Split(' ');
                if (sortEl.Length == 2)
                {
                    var sortType = sortEl[1].Trim().ToUpper();
                    if (sortType == "DESC")
                        order = Order.StartDesc(sortEl[0].Trim());
                    else if (sortType == "ASC")
                        order = Order.StartAsc(sortEl[0].Trim());
                    else
                        throw new Exception("Incorrect 'sort' parameter!");
                }
            }

            Filter filter = Filter.Empty;
            if (!string.IsNullOrEmpty(filterStr))
            {
                filter = Filter.And.LikeRightLeft(filterStr, "Name");
            }

            if (!filter.IsEmpty)
                filter = filter.NestOr();
            else
            {
                filter = Filter.Or;
            }

            //Filter Out other division users
            if (!string.IsNullOrEmpty(structDivisionId))
            {
                var childrenStructDivisionIds =
                (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId,
                    "ParentId"))).Select(p => p.Id).Distinct().ToList();

                if (childrenStructDivisionIds.Any())
                {
                    foreach (var childId in childrenStructDivisionIds)
                    {
                        filter = filter.Equal(childId, "StructDivisionId");
                    }
                }
            }

			var items = await SecurityUser.SelectAsync(filter, order, new Paging(skip, take));
			var totalItems = await SecurityUser.SelectAsync(filter);

			var userIds = items.Select(c => c.Id).ToList();

			var users = User.Create(items,
                await SecurityCredential.SelectAsync(Filter.And.In(userIds, "SecurityUserId")),
                await SecurityGroupToSecurityUser.SelectAsync(Filter.And.In(userIds, "SecurityUserId")),
                await SecurityUserToSecurityRole.SelectAsync(Filter.And.In(userIds, "SecurityUserId")));

			long count = totalItems.Count;
			//long count = await SecurityUser.GetCountAsync(filter);
            return new
            {
                users = users,
                count
            };
        }
    }
}