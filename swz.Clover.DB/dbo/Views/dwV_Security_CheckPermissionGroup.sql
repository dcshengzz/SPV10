CREATE VIEW [dbo].[dwV_Security_CheckPermissionGroup]
	AS
	SELECT 
	sgtosr.SecurityGroupId as SecurityGroupId,
	sp.Id as PermissionId,
	spg.Code as PermissionGroupCode,
	spg.Name as PermissionGroupName,
	sp.Code as PermissionCode,
	sp.Name as PermissionName,
	MAX(srtosp.[AccessType]) as AccessType
	FROM dbo.dwSecurityPermission sp WITH(NOLOCK)
	INNER JOIN dbo.dwSecurityPermissionGroup spg WITH(NOLOCK) on sp.GroupId = spg.Id
	INNER JOIN dbo.dwSecurityRoleToSecurityPermission srtosp WITH(NOLOCK) on srtosp.SecurityPermissionId = sp.Id
	INNER JOIN dbo.dwSecurityGroupToSecurityRole sgtosr WITH(NOLOCK) on sgtosr.SecurityRoleId = srtosp.SecurityRoleId
	WHERE srtosp.[AccessType] <> 0
	GROUP BY sgtosr.SecurityGroupId, sp.Id, spg.Code, spg.Name, sp.Code, sp.Name
