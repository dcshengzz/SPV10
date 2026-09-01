



	CREATE PROCEDURE [dbo].[spSP_DeleteSampleOwnerByIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		IF @AuditOn=1
			BEGIN
				INSERT INTO sy_AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_DPLY_SAMPLE_OWNER 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
			END
		delete from QNN_DPLY_SAMPLE_OWNER where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

	END