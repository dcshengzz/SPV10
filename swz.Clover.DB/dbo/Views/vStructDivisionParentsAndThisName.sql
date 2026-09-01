


CREATE VIEW [dbo].[vStructDivisionParentsAndThisName]
	AS
	SELECT sd.Id, Name, vsd.ParentId FROM StructDivision sd
	INNER JOIN DBO.vStructDivisionParentsAndThis vsd
	on sd.Id = vsd.ID