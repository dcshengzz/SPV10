


-- =============================================
-- Name: [dbo].[spSP_DeleteAuditLogBeforeCreatedDate]
-- Description:	To purge the data created before a specified date.
-- =============================================
CREATE PROCEDURE [dbo].[spSP_DeleteAuditLogBeforeCreatedDate]
	@UserId uniqueidentifier,
	@EventBatch uniqueidentifier,
	@EventDate datetime,
	@StructDivisionId uniqueidentifier,
	@DataCreatedBefore datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET XACT_ABORT, NOCOUNT ON;

	DELETE FROM sy_AuditLog where CAST(EventDate as date) < CAST(@DataCreatedBefore as date)

	BEGIN
		INSERT INTO sy_AuditLog 
			(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
		SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Audit Purge', 'AuditLog', null, null,'Event Logged Before : ' + CAST(@DataCreatedBefore AS VARCHAR(20)), null, @StructDivisionId;
	END

END