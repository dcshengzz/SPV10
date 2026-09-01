using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class IntranetAccountApplication
    {
        public static async Task<DynamicEntity> GetDwSecurityUserByIdAsync(Guid id, EntityModel dwSecurityUserModel=null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.dwSecurityUser, dwSecurityUserModel);
        }

        public static async Task<List<DynamicEntity>> GetDwSecurityUsersByIdsAsync(List<Guid> userIds, EntityModel dwSecurityUserModel = null)
        {
            if (userIds == null) throw new ArgumentNullException(nameof(userIds));
            List<DynamicEntity> users = await ORMUtils.GetEntitiesByIds(userIds, Constants.ModelName.dwSecurityUser, dwSecurityUserModel);
            return users;
        }

        public static async Task<bool> IsUserInRoleAsync(Guid securityUserId, string roleCode)
        {
            if (string.IsNullOrWhiteSpace(roleCode)) throw new ArgumentException("Must be specified", nameof(roleCode));
            try
            {
                EntityModel vSPUserRoleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_UserRole, Constants.Level.NoJoins);
                Filter byIdAndRole = Filter.And
                    .Equal(securityUserId, Constants.FieldName.SecurityUserId)
                    .Equal(roleCode, Constants.FieldName.RoleCode);
                bool isInRole = (await vSPUserRoleModel.GetCountAsync(byIdAndRole)) > 0;
                return isInRole;
            }
            catch(Exception e)
            {
                throw new InternalException($"Unexpected error checking if user {securityUserId}  is in role {roleCode}", e);
            }
        }

        /// <summary>
        /// Returns a list of dwSecurityUser entities having the specified role.
        /// </summary>
        /// <param name="roleCode"></param>
        /// <param name="inStructDivisionId">if specified, will only return users in this structdivision</param>
        /// <param name="isExcludeLockedUsers">if true then locked users are ignored, if false they are included</param>
        /// <returns></returns>
        public static async Task<List<DynamicEntity>> GetDwSecurityUsersInRoleAsync(
            string roleCode,
            Guid? inStructDivisionId = null,
            bool isExcludeLockedUsers = false)
        {
            return await GetDwSecurityUsersInRolesAsync(new string[] { roleCode }.ToList(), inStructDivisionId, isExcludeLockedUsers);
        }

        public static async Task<List<Guid>> GetDwSecurityUserIdsInRoleAsync(
            string roleCode,
            Guid? inStructDivisionId = null,
            bool isExcludeLockedUsers = false)
        {
            return await GetDwSecurityUserIdsInRolesAsync(new string[] { roleCode }.ToList(), inStructDivisionId, isExcludeLockedUsers);
        }

        public static async Task<List<Guid>> GetDwSecurityUserIdsInRolesAsync(
            List<string> roleCodes,
            Guid? inStructDivisionId = null,
            bool isExcludeLockedUsers = false)
        {
            if (!roleCodes.Any() || roleCodes.Any(rc => string.IsNullOrWhiteSpace(rc)))
                throw new ArgumentException("Must be specified", nameof(roleCodes));
            try
            {
                EntityModel vSpUserRoleModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_UserRole, Constants.Level.NoJoins);
                Filter filter = Filter.And.In(roleCodes, Constants.FieldName.RoleCode);
                if (inStructDivisionId != null)
                {
                    filter = filter.Merge(Filter.And.Equal(inStructDivisionId, Constants.FieldName.SecurityUserStructDivisionId));
                }
                if (isExcludeLockedUsers)
                {
                    //AND isLocked=0   (so don't include locked users in the results)
                    filter = filter.Merge(Filter.And.Equal(false, Constants.FieldName.IsLocked));
                }

                List<Guid> userIds
                    = (await vSpUserRoleModel.GetAsync(filter, Order.StartAsc(Constants.FieldName.SecurityUserName), Paging.Empty))
                    .Select(ur => (Guid)ur[Constants.FieldName.SecurityUserId])
                    .ToList();

                return userIds;
            }
            catch (Exception e)
            {
                throw new InternalException($"Unexpected error getting users in roles", e);
            }
        }

        public static async Task<List<DynamicEntity>> GetDwSecurityUsersInRolesAsync(
            List<string> roleCodes,
            Guid? inStructDivisionId = null,
            bool isExcludeLockedUsers=false)
        {
            if(!roleCodes.Any() || roleCodes.Any(rc => string.IsNullOrWhiteSpace(rc))) 
                throw new ArgumentException("Must be specified", nameof(roleCodes));
            try
            {
                List<Guid> userIds = await GetDwSecurityUserIdsInRolesAsync(roleCodes, inStructDivisionId, isExcludeLockedUsers);
                List<DynamicEntity> users = await GetDwSecurityUsersByIdsAsync(userIds);
                return users;
            }
            catch(Exception e)
            {
                throw new InternalException($"Unexpected error getting users in role {roleCodes}, inStructDivisionId={inStructDivisionId}", e);
            }
        }

    }
}
