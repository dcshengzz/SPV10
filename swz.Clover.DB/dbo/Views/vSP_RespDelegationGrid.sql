




CREATE VIEW [dbo].[vSP_RespDelegationGrid]
AS
SELECT [Id]
	,[NumberId]
    ,[DplyListSampleId]
    ,[FromName]
    ,[Name]
    ,[Email]
    ,[Comments]
    ,[ValidityStart]
    ,[ValidityEnd]
    ,[AccessCode]
    ,[CreatedDate]
	,[RevokedDate]
	,[Status]
FROM 
	(SELECT [Id]
	,[NumberId]
    ,[DplyListSampleId]
    ,[FromName]
    ,[Name]
    ,[Email]
    ,[Comments]
    ,[ValidityStart]
    ,[ValidityEnd]
    ,[AccessCode]
    ,[CreatedDate]
	,[RevokedDate]
	,IIF (RowNumber = 1, 'Active', 'Inactive') AS [Status]
	FROM vSP_RespDelegationActive) as a
UNION ALL
	(SELECT [Id]
	,[NumberId]
    ,[DplyListSampleId]
    ,[FromName]
    ,[Name]
    ,[Email]
    ,[Comments]
    ,[ValidityStart]
    ,[ValidityEnd]
    ,[AccessCode]
    ,[CreatedDate]
	,[RevokedDate]
	,IIF(RevokedDate is not null, 'Revoked', 
	IIF(GETDATE() < ValidityStart, 'Scheduled', 
	IIF(ValidityEnd < GETDATE(), 'Expired', 'Unknown'))) AS [Status]
	FROM QNN_RESP_DELEGATION t2
	WHERE NOT EXISTS(SELECT 1 FROM vSP_RespDelegationActive WHERE id = t2.id))