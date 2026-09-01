
CREATE PROCEDURE [dbo].[spSP_GetAuditLogsCreatedBeforeDate]
		@DataCreatedBefore datetime
AS
BEGIN
	SELECT EventDate AS [Date], UserName AS [User Name], UID AS [Sample UID] , SampleName AS [Sample Name] , EventBatch as [BatchJob ID],  
    EventType AS [Event Type], TableName AS [Table Name] , ColumnName AS [Field Modified], OriginalValue AS [Original Value], NewValue AS [New Value]
	FROM sySP_vSP_auditLog
	Where CAST(EventDate as date) < CAST(@DataCreatedBefore as date)
	ORDER BY EventDate ASC
END