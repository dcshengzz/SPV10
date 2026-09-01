







CREATE PROCEDURE [dbo].[spSP_UpdateDplySampleInfo]
		--for audit
		@AuditOn AS BIT,
		@SampleId UNIQUEIDENTIFIER,
		@StructDivisionId UNIQUEIDENTIFIER,
		@EventBatch UNIQUEIDENTIFIER,
		@EventDate DATETIME,
		@UserId UNIQUEIDENTIFIER,
		--for update
		@Id UNIQUEIDENTIFIER,
		@OldStatus UNIQUEIDENTIFIER,
		@NewStatus UNIQUEIDENTIFIER
	
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		UPDATE 
			QNN_DPLY_SAMPLE_INFO 
		SET
			[Status] = @NewStatus
		WHERE
			Id = @Id
		;

		IF @AuditOn=1
		BEGIN
			INSERT INTO sy_AuditLog 
				(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
			SELECT 
				NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_DPLY_SAMPLE_INFO', @Id, 'Status', @OldStatus, @NewStatus, @StructDivisionId;
		END
	END