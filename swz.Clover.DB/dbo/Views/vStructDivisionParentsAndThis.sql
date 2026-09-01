CREATE VIEW [dbo].[vStructDivisionParentsAndThis]
	AS
	select  Id Id, Id ParentId FROM [dbo].[StructDivision]
	UNION 
	select  Id Id, ParentId ParentId FROM [dbo].[vStructDivisionParents]
