	CREATE PROCEDURE [dbo].[spSP_DeleteAllRespAnsByRespId]
		@RespId uniqueidentifier,
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime
	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO AuditLog 
			(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
		SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_RESP_ANS
		where RespId=@RespId FOR JSON AUTO), null, @StructDivisionId;

		delete from QNN_RESP_ANS where RespId=@RespId and NumberId<=@NumberId; 



	END
	



GO