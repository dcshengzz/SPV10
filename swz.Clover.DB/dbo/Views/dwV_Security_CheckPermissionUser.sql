CREATE VIEW [dbo].[dwV_Security_CheckPermissionUser]
	AS
	SELECT 
	dwV_Security_UserRole.UserId,
	sp.Id as "PermissionId",
	spg.Code as PermissionGroupCode,
	spg.Name as PermissionGroupName,
	sp.Code as PermissionCode,
	sp.Name as PermissionName,
	MAX(srtosp.[AccessType]) as AccessType
	FROM dbo.dwSecurityPermission sp WITH(NOLOCK)
	INNER JOIN dbo.dwSecurityPermissionGroup spg WITH(NOLOCK) on sp.GroupId = spg.Id
	INNER JOIN dbo.dwSecurityRoleToSecurityPermission srtosp WITH(NOLOCK) on srtosp.SecurityPermissionId = sp.Id
	INNER JOIN dwV_Security_UserRole on dwV_Security_UserRole.RoleId = srtosp.SecurityRoleId
	WHERE srtosp.[AccessType] <> 0
	GROUP BY dwV_Security_UserRole.UserId, sp.Id, spg.Code, spg.Name, sp.Code, sp.Name
