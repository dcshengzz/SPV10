CREATE VIEW [dbo].[vStructDivisionParents]
	AS
	with cteRecursive as (
	 select sd.Id FirstId, sd.ParentId ParentId, sd.Id Id
	  from  [dbo].[StructDivision] sd WHERE sd.ParentId IS NOT NULL
	 union all 
	 select r.FirstId FirstId, sdr.ParentId ParentId, sdr.Id Id
	 from [dbo].[StructDivision] sdr
	 inner join cteRecursive r ON r.ParentId = sdr.Id)

	select DISTINCT FirstId Id, ParentId ParentId FROM cteRecursive 
