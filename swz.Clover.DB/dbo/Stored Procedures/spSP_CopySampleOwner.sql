



	CREATE PROCEDURE [dbo].[spSP_CopySampleOwner]
		@ParentDplyId uniqueidentifier,
		@RecurrenceDplyId uniqueidentifier,		
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@AuditOn AS BIT = 0

	AS
	BEGIN

		SET XACT_ABORT, NOCOUNT ON;

		Create TABLE #Temp (Id uniqueidentifier);
		
		--warning: intended for single use, does not check if this relationship already exists in the new deployment
		INSERT INTO QNN_DPLY_SAMPLE_OWNER (Id, DplyId, ListSampleId, UserId) 
			OUTPUT INSERTED.Id INTO #Temp(Id)
			SELECT NEWID() AS Id, @RecurrenceDplyId AS DplyId, ListSampleId, UserId FROM QNN_DPLY_SAMPLE_OWNER 
			WHERE DplyId=@ParentDplyId;

		IF @@RowCount>0 AND @AuditOn=1
		BEGIN
			INSERT INTO sy_AuditLog 
						(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
					SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Insert', 'QNN_DPLY_SAMPLE_OWNER', null, null, null, 
					(select * from QNN_DPLY_SAMPLE_OWNER where Id IN( SELECT Id FROM #Temp) FOR JSON AUTO), @StructDivisionId;
		END
	END