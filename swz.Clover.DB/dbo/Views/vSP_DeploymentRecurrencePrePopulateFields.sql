CREATE VIEW [dbo].[vSP_DeploymentRecurrencePrePopulateFields] AS
SELECT f.Id AS Id
	,f.Name AS QnnFieldName 
	,f.type AS QnnFieldType 
	,d.Id as DplyId 
	,d.StructDivisionId 
	,IIF(g.id is not null, cast(1 as bit), cast(0 as bit)) as [PrePopulate]
FROM QNN_QNN_FIELD f
inner join QNN_QNN q ON f.QnnId = q.Id
inner join QNN_DPLY d ON d.QnnId = q.Id
left join QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD g ON g.DplyId = d.Id AND g.QnnFieldId = f.Id