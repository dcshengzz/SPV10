



CREATE PROCEDURE [dbo].[spSP_PurgeResp]
		--Params for audit
		@AuditOn BIT, --for audit only (i.e. is audit in use)
		@StructDivisionId UNIQUEIDENTIFIER, -- for audit only
		@EventBatch UNIQUEIDENTIFIER, --for audit only
		@EventDate DATETIME, --for audit
		@UserId UNIQUEIDENTIFIER, --for audit only

		@DplyId UNIQUEIDENTIFIER
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		DECLARE @Pending UNIQUEIDENTIFIER = 'A3D01086-40FC-4A7A-BF0C-DE17BDD205FA';

		DELETE FROM QNN_RESP WHERE DplyId=@DplyId;

		--Reset the status for any respondents that aren't pending anymore
		UPDATE QNN_DPLY_SAMPLE_INFO 
			SET 
				[Status]=@Pending, 
				[StatusModifyBy]=@UserId,
				[StatusModifyOn]=@EventDate
			WHERE 
				@DplyId=@DplyId
				AND [Status] <> @Pending;

		--Clear any remarks
		UPDATE QNN_DPLY_SAMPLE_INFO 
			SET 
				[Remarks]=NULL,
				[RemarksModifyBy]=@UserId,
				[RemarksModifyOn]=@EventDate
			WHERE 
				@DplyId=@DplyId
				AND [Remarks] IS NOT NULL;

		IF @AuditOn=1
		BEGIN
			--We only record the DplyId that was purged. The data itself is not fetched, so if really need it you must
			--try to refer to the earlier audit records that changed it
			INSERT INTO sy_AuditLog (Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Purge Responses', 'QNN_DPLY', @DplyId, null, null, null, @StructDivisionId;
		END

	END