CREATE VIEW [dbo].[vHeads]
	AS
	select  e.Id Id, e.Name Name, eh.Id HeadId, eh.Name HeadName FROM dwSecurityUser e
		INNER JOIN [vStructDivisionParentsAndThis] vsp ON e.StructDivisionId = vsp.Id
		INNER JOIN dwSecurityUser eh ON eh.StructDivisionId = vsp.ParentId AND eh.IsHead = 1
