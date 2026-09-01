//using System;
//using System.Collections.Generic;
//using System.Data.Objects.DataClasses;
//using System.Linq;
//using System.Transactions;
//using System.Web.Security;
//using swz.Security.Exceptions;
//using swz.DynamicEntities.Base;

//namespace swz.Security.Providers
//{
//    public class SecurityRoleProvider : RoleProvider
//    {
//        public override string ApplicationName { get; set; }


//        public string ConnectionString { get; set; }

//        public override bool IsUserInRole(string username, string roleName)
//        {
//            throw new NotImplementedException();
//            return false;
//            //using (DBEntities context = Settings.CreateDataContext())
//            //{
//            //    return
//            //        context.SecurityUser.Count(
//            //            su =>
//            //            su.Name == username &&
//            //            (su.SecurityRole.Count(sr => sr.Name == roleName) > 0 ||
//            //                su.SecurityGroup.Count(sg => sg.SecurityRole.Count(sr1 => sr1.Name == roleName) > 0) > 0)) >
//            //        0;
//            //}
//        }

//        public bool IsUserInRole(Guid usernid, string roleName)
//        {
//            throw new NotImplementedException();
//            return false;
//            //using (DBEntities context = Settings.CreateDataContext())
//            //{
//            //    return
//            //        context.SecurityUser.Count(
//            //            su =>
//            //            su.Id == usernid &&
//            //            (su.SecurityRole.Count(sr => sr.Code == roleName) > 0 ||
//            //             su.SecurityGroup.Count(sg => sg.SecurityRole.Count(sr1 => sr1.Code == roleName) > 0) > 0)) >
//            //        0;
//            //}
//        }

//        public override string[] GetRolesForUser(string username)
//        {
//            throw new NotImplementedException();
//            return null; ;
//            //using (DBEntities context = Settings.CreateDataContext())
//            //{
//            //    IQueryable<EntityCollection<SecurityRole>> userRoles =
//            //        context.SecurityUser.Where(su => su.Name == username).Select(su => su.SecurityRole);
//            //    IQueryable<EntityCollection<SecurityRole>> groupRoles =
//            //        context.SecurityGroup.Where(sg => sg.SecurityUser.Count(su => su.Name == username) > 0).Select(
//            //            sg => sg.SecurityRole);

//            //    IEnumerable<EntityCollection<SecurityRole>> allRoles = userRoles.ToList().Union(groupRoles.ToList());

//            //    var roles = new List<string>();

//            //    foreach (var roleset in allRoles)
//            //        foreach (SecurityRole role in roleset)
//            //            if (!roles.Contains(role.Name))
//            //                roles.Add(role.Name);

//            //    return roles.ToArray();
//            //}
//        }


//        public override void CreateRole(string roleName)
//        {
//            throw new NotImplementedException();
            
//            //using (TransactionScope scope = Settings.GetDefaultScope())
//            //{
//            //    using (DBEntities context = Settings.CreateDataContext())
//            //    {
//            //        //TODO
//            //        if (context.SecurityRole.Count(p => p.Name == roleName) > 0)
//            //            throw new RoleProviderException("SecurityRoleProvider:");

//            //        context.AddToSecurityRole(new SecurityRole {IsSystem = false, Name = roleName});

//            //        context.SaveChanges();
//            //    }

//            //    scope.Complete();
//            //}
//        }

//        public override bool DeleteRole(string roleName, bool throwOnPopulatedRole)
//        {
//            throw new NotImplementedException();

//            //using (TransactionScope scope = Settings.GetDefaultScope())
//            //{
//            //    using (DBEntities context = Settings.CreateDataContext())
//            //    {
//            //        var roles =
//            //            context.SecurityRole.Where(p => p.Name == roleName).Select(
//            //                sr =>
//            //                new
//            //                    {
//            //                        Role = sr,
//            //                        UsersInRoleCount = throwOnPopulatedRole ? sr.SecurityUser.Count : 0,
//            //                        GroupsInRoleCount = throwOnPopulatedRole ? sr.SecurityGroup.Count : 0
//            //                    }).ToList();

//            //        if (roles.Count <= 0)
//            //            return false;

//            //        foreach (var role in roles)
//            //        {
//            //            if (role.Role.IsSystem)
//            //                throw new RoleProviderException("SecurityRoleProvider:");
//            //            if (throwOnPopulatedRole && (role.UsersInRoleCount > 0) || role.GroupsInRoleCount > 0)
//            //                throw new RoleProviderException("SecurityRoleProvider:");
//            //            context.DeleteObject(role.Role);
//            //        }
//            //        context.SaveChanges();
//            //    }
//            //    scope.Complete();
//            //}

//            return true;
//        }

//        public override bool RoleExists(string roleName)
//        {
//            throw new NotImplementedException();
//            return true;
//            //using (DBEntities context = Settings.CreateDataContext())
//            //    return context.SecurityRole.Count(p => p.Name == roleName) > 0;
//        }

//        public override void AddUsersToRoles(string[] usernames, string[] roleNames)
//        {
//            ProcessUsersToRoles(usernames, roleNames, AddUsersToRole);
//        }

//        public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames)
//        {
//            ProcessUsersToRoles(usernames, roleNames, RemoveUsersFromRole);
//        }

//        private void ProcessUsersToRoles(string[] usernames, string[] roleNames,
//                                         Action<SecurityRole, List<SecurityUser>> action)
//        {
//            throw new NotImplementedException();
//            //using (TransactionScope scope = Settings.GetDefaultScope())
//            //{
//            //    using (DBEntities context = Settings.CreateDataContext())
//            //    {
//            //        IQueryable<SecurityRole> roles =
//            //            context.SecurityRole.Include("SecurityUser").Where(
//            //                sr => roleNames.Contains(sr.Name));
//            //        List<SecurityUser> users = context.SecurityUser.Where(su => usernames.Contains(su.Name)).ToList();
//            //        foreach (SecurityRole securityRole in roles)
//            //        {
//            //            action(securityRole, users);
//            //        }

//            //        context.SaveChanges();
//            //    }

//            //    scope.Complete();
//            //}
//        }

//        private static void AddUsersToRole(SecurityRole securityRole, List<SecurityUser> users)
//        {
//            throw new NotImplementedException();
            


//            //List<SecurityUser> usersAlwaysInRole = securityRole.SecurityUser.Intersect(users).ToList();
//            //foreach (SecurityUser user in users)
//            //{
//            //    if (!usersAlwaysInRole.Contains(user))
//            //        securityRole.SecurityUser.Add(user);
//            //}
//        }

//        private static void RemoveUsersFromRole(SecurityRole securityRole, List<SecurityUser> users)
//        {
//            throw new NotImplementedException();
            
//            //List<SecurityUser> usersAlwaysInRole = securityRole.SecurityUser.Intersect(users).ToList();
//            //foreach (SecurityUser user in usersAlwaysInRole)
//            //{
//            //    securityRole.SecurityUser.Remove(user);
//            //}
//        }

//        public override string[] GetUsersInRole(string roleName)
//        {
//            return FindUsersInRole(roleName, null);
//        }

//        public override string[] GetAllRoles()
//        {
//            return SecurityRole.Select().Select(c => Name).ToArray();
//        }

//        public override string[] FindUsersInRole(string roleName, string usernameToMatch)
//        {
//            throw new NotImplementedException();
//            return null;

//            //using (DBEntities context = Settings.CreateDataContext())
//            //{
//            //    var userInRoles =
//            //        context.SecurityRole.Where(sr => sr.Name == roleName).Select(
//            //            sr =>
//            //            new
//            //                {
//            //                    Users =
//            //                sr.SecurityUser.Where(
//            //                    su => string.IsNullOrEmpty(usernameToMatch) || su.Name.Contains(usernameToMatch)),
//            //                    UsersInGroups =
//            //                sr.SecurityGroup.Select(
//            //                    sg =>
//            //                    sg.SecurityUser.Where(
//            //                        su => string.IsNullOrEmpty(usernameToMatch) || su.Name.Contains(usernameToMatch)))
//            //                });

//            //    var users = new List<string>();

//            //    foreach (var userset in userInRoles)
//            //    {
//            //        foreach (var userset1 in userset.UsersInGroups)
//            //            foreach (SecurityUser user in userset1)
//            //            {
//            //                if (!users.Contains(user.Name))
//            //                    users.Add(user.Name);
//            //            }
//            //        foreach (SecurityUser user in userset.Users)
//            //        {
//            //            if (!users.Contains(user.Name))
//            //                users.Add(user.Name);
//            //        }
//            //    }


//            //    return users.ToArray();
//            //}
//        }

//        public List<Guid> FindUsersIdsInRole(string roleCode)
//        {
//            throw new NotImplementedException();
//            return null;

//            //using (DBEntities context = Settings.CreateDataContext())
//            //{
//            //    var userInRoles =
//            //        context.SecurityRole.Where(sr => sr.Code == roleCode).Select(
//            //            sr =>
//            //            new
//            //                {
//            //                    Users = sr.SecurityUser,
//            //                    UsersInGroups = sr.SecurityGroup.Select(sg => sg.SecurityUser)
//            //                });

//            //    var users = new List<Guid>();

//            //    foreach (var userset in userInRoles)
//            //    {
//            //        foreach (var userset1 in userset.UsersInGroups)
//            //            foreach (SecurityUser user in userset1)
//            //            {
//            //                if (!users.Contains(user.Id))
//            //                    users.Add(user.Id);
//            //            }
//            //        foreach (SecurityUser user in userset.Users)
//            //        {
//            //            if (!users.Contains(user.Id))
//            //                users.Add(user.Id);
//            //        }
//            //    }


//            //    return users;
//            //}
//        }
//    }
//}