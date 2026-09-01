CREATE PROCEDURE [dbo].[spSP_DeleteSampleOwnerByDplyIdAndUserIds]
		@DplyId uniqueidentifier,
		@UserIds NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0
	AS
	BEGIN
		SET NOCOUNT ON;
		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_DPLY_SAMPLE_OWNER 
				where DplyId=@DplyId and UserId IN( SELECT Item FROM dbo.splitIds(@UserIds, ',')) FOR JSON AUTO), null, @StructDivisionId;
			END
		delete from QNN_DPLY_SAMPLE_OWNER where DplyId=@DplyId and UserId IN( SELECT Item FROM dbo.splitIds(@UserIds, ',')); 

	END
	
	


GO