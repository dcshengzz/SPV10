CREATE VIEW [dbo].[vUsers]
AS
select dwSecurityUser.Id, dwSecurityUser.Name, dwSecurityUser.StructDivisionId, 
stuff(
    (
    select cast(', ' as varchar(max)) + dwSecurityRole.Name
    from dwV_Security_UserRole
	LEFT JOIN dwSecurityRole on dwSecurityRole.Id = dwV_Security_UserRole.RoleId
	WHERE dwV_Security_UserRole.UserId = dwSecurityUser.Id
    order by dwSecurityRole.Name
    for xml path('')
    ), 1, 2, '') as Roles,
dwSecurityUser.Name + ' (' + stuff(
    (
    select cast(', ' as varchar(max)) + dwSecurityRole.Name
    from dwV_Security_UserRole
	LEFT JOIN dwSecurityRole on dwSecurityRole.Id = dwV_Security_UserRole.RoleId
	WHERE dwV_Security_UserRole.UserId = dwSecurityUser.Id
    order by dwSecurityRole.Name
    for xml path('')
    ), 1, 2, '') + ')' as Title 
from dwSecurityUser
