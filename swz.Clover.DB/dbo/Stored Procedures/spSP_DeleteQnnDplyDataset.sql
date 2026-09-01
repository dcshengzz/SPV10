




	CREATE PROCEDURE [dbo].[spSP_DeleteQnnDplyDataset]
		@DplyId uniqueidentifier,
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		if(Exists( select top 1 1 from QNN_DPLY_DATASET where DplyId = @DplyId ))

			BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY_DATASET', null, null,
						(select * from QNN_DPLY_DATASET where DplyId = @DplyId FOR JSON AUTO), null, @StructDivisionId;
					END			
				delete from QNN_DPLY_DATASET where DplyId = @DplyId; 
			END

	END