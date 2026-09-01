

CREATE PROCEDURE [dbo].[spSP_UpdateQnnRespAns]
	@RespId UNIQUEIDENTIFIER,
    @UpdatedAnswers RespAnsUpdate READONLY,

	@UserId uniqueidentifier, --used for audit
	@SampleId uniqueidentifier, --used for audit
	@StructDivisionId uniqueidentifier, --used for audit
	@EventBatch uniqueidentifier, --used for audit
	@EventDate datetime, --used for audit
	@AuditOn BIT --used for audit
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON
    
	-- RespId is passed explicitly and included in the join condition with the intent of
	-- improving the generated query plan gven that qnn_resp_ans is now clustered on RespId

	IF @AuditOn=1
	BEGIN
		DECLARE @OriginalValue  AS NVARCHAR(MAX);
		SET @OriginalValue = (
			SELECT a.* FROM 
			@UpdatedAnswers u INNER JOIN QNN_RESP_ANS a ON (a.RespId=@RespId AND a.Id=u.Id)
			FOR JSON AUTO );
	END;

	UPDATE a SET
		AnsVal = u.NewAnsVal,
		IsPrePopulated = u.NewIsPrePopulated
	FROM
		@UpdatedAnswers u
		INNER JOIN QNN_RESP_ANS a ON (a.RespId=@RespId AND a.Id=u.Id)
	;

	IF @AuditOn=1
	BEGIN
		DECLARE @NewValue  AS NVARCHAR(MAX);
		SET @NewValue = (
			SELECT a.* FROM 
			@UpdatedAnswers u INNER JOIN QNN_RESP_ANS a ON (a.RespId=@RespId AND a.Id=u.Id)
			FOR JSON AUTO );
		INSERT INTO sy_AuditLog
			(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
			SELECT 
			NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_RESP_ANS', null, null, @OriginalValue, @NewValue, @StructDivisionId;
	END
	
END