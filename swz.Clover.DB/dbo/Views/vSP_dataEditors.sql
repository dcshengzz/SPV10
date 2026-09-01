CREATE VIEW [dbo].[vSP_dataEditors] AS 
select u.Id, u.Name, s.Id as StructDivisionId from dwSecurityRole r
inner join dwV_Security_UserRole vU on r.Id = vU.RoleId
inner join dwSecurityUser u on vU.UserId = u.Id
left join StructDivision s on u.StructDivisionId = s.Id
where r.Code='DataEditor' and u.IsLocked = 0
