CREATE VIEW [dbo].[vStructDivisionUsers]
AS
select Id, Name, ParentId, null as Roles from StructDivision
union all
select dwSecurityUser.Id, dwSecurityUser.Name, dwSecurityUser.StructDivisionId, 
stuff(
    (
    select cast(', ' as varchar(max)) + dwSecurityRole.Name
    from dwV_Security_UserRole
	LEFT JOIN dwSecurityRole on dwSecurityRole.Id = dwV_Security_UserRole.RoleId
	WHERE dwV_Security_UserRole.UserId = dwSecurityUser.Id
    order by dwSecurityRole.Name
    for xml path('')
    ), 1, 1, '') as Roles 
from dwSecurityUser
