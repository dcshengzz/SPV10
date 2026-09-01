



CREATE PROCEDURE [dbo].[spSP_DeleteSampleOwnerByDplyId]
		@DplyId uniqueidentifier,
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
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
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'SampleOwner Clear', @TableName, @DplyId, null, null, @NewValue, @StructDivisionId;
			END

		DELETE FROM QNN_DPLY_SAMPLE_OWNER 
			WHERE DplyId=@DplyId AND UserId IN (
				SELECT [Id] FROM [dwSecurityUser] 
				WHERE [StructDivisionId] IN (
					SELECT [Id] FROM [vStructDivisionParentsAndThis] 
					WHERE [ParentId] = @StructDivisionId GROUP BY Id));
	END