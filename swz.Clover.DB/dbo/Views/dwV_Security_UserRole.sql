CREATE VIEW [dbo].[dwV_Security_UserRole]
	AS
	SELECT 
		dwSecurityUserToSecurityRole.SecurityUserId as UserId, 
		dwSecurityUserToSecurityRole.SecurityRoleId as RoleId 
	FROM dwSecurityUserToSecurityRole WITH(NOLOCK) 
	
	UNION

	SELECT DISTINCT
		dwSecurityGroupToSecurityUser.SecurityUserId as UserId, 
		dwSecurityGroupToSecurityRole.SecurityRoleId as RoleId 
	FROM dwSecurityGroupToSecurityRole WITH(NOLOCK)
	INNER JOIN dwSecurityGroupToSecurityUser WITH(NOLOCK) ON dwSecurityGroupToSecurityUser.SecurityGroupId = dwSecurityGroupToSecurityRole.SecurityGroupId
