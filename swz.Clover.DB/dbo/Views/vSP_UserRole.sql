
CREATE VIEW [dbo].[vSP_UserRole] AS 
SELECT 	 
	u.Id As SecurityUserId, 
	r.Id AS SecurityRoleId, 
	u.Name AS SecurityUserName, 	
	r.Code As RoleCode, 
	r.Name As RoleName,
	u.StructDivisionId AS SecurityUserStructDivisionId,
	u.IsLocked AS IsLocked
FROM
	dwSecurityUser u
	LEFT JOIN dwSecurityUserToSecurityRole utr ON u.Id=utr.SecurityUserId
	LEFT JOIN dwSecurityRole r ON r.Id=utr.SecurityRoleId
WHERE
	u.Id <> '00000000-0000-0000-0000-000000000000';