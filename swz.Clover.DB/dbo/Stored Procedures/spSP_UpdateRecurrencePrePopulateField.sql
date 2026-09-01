


CREATE PROCEDURE [dbo].[spSP_UpdateRecurrencePrePopulateField]
		@DplyId uniqueidentifier,
		@QnnFieldIdsToAdd as nvarchar(max) = '',
		@QnnFieldIdsToRemove as nvarchar(max) = '',
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		DECLARE @OriginalValue AS NVARCHAR(MAX)
		SELECT @OriginalValue = (select * from QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD where DplyId=@DplyId FOR JSON AUTO)
		
		BEGIN
			INSERT INTO QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD (Id, DplyId, QnnFieldId)
			SELECT NEWID(), @DplyId, c.value AS QnnFieldId FROM STRING_SPLIT(@QnnFieldIdsToAdd, N',') as c
		END

		BEGIN
			DELETE FROM QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD
			WHERE DplyId = @DplyId AND QnnFieldId IN (SELECT value from STRING_SPLIT(@QnnFieldIdsToRemove, N','))
		END

		IF @AuditOn=1
			BEGIN
				INSERT INTO sy_AuditLog  
				(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Update', 'QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD', null, null, @OriginalValue, 
				(SELECT * FROM QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD where DplyId=@DplyId FOR JSON AUTO), @StructDivisionId;
			END
	END