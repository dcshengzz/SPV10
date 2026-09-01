

CREATE PROCEDURE [dbo].[spSP_InsertAllSamplesToDataEditor]
	@DplyId uniqueidentifier,
	@DataEditorId uniqueidentifier,
	@UserId uniqueidentifier,
	@TableName NVARCHAR(50),
	@SampleId uniqueidentifier,
	@StructDivisionId uniqueidentifier,
	@EventBatch uniqueidentifier,
	@EventDate datetime,
	@AuditOn AS BIT = 0,
	@NewValue NVARCHAR(MAX)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	IF @AuditOn=1
			BEGIN
				INSERT INTO sy_AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Assign All Samples', @TableName, @DplyId, null, null, @NewValue, @StructDivisionId;
			END

	INSERT INTO [QNN_DPLY_SAMPLE_OWNER] (
		[Id],
		[DplyId],
		[ListSampleId],
		[UserId])
		(SELECT 
			NEWID(), 
			@DplyId, 
			ListSampleId, 
			@DataEditorId 
		FROM 
			[vSP_ListSampleOwnerInfo] 
		WHERE 
			DplyId = @DplyId 
			AND ListSampleId NOT IN 
			(SELECT ListSampleId FROM [QNN_DPLY_SAMPLE_OWNER] WHERE DplyId = @DplyId AND UserId = @DataEditorId));
END