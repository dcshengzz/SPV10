








	CREATE PROCEDURE [dbo].[spSP_DeleteAllRespAnsByRespId]
		@RespId uniqueidentifier,
		@UserId uniqueidentifier, --used for audit
		@SampleId uniqueidentifier, --used for audit
		@StructDivisionId uniqueidentifier, --used for audit
		@EventBatch uniqueidentifier, --used for audit
		@EventDate datetime, --used for audit
		@AuditOn BIT --used for audit
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		IF @AuditOn=1
			BEGIN
				INSERT INTO sy_AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', 'QNN_RESP_ANS', null, null,(select * from QNN_RESP_ANS with (NOLOCK)
				where RespId=@RespId FOR JSON AUTO), null, @StructDivisionId;
			END

		delete from QNN_RESP_ANS where RespId=@RespId; 

	END