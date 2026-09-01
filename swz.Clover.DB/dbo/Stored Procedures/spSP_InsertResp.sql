



CREATE PROCEDURE [dbo].[spSP_InsertResp]
		--Params for audit
		@AuditOn BIT, --for audit only (i.e. is audit in use)
		@SampleId uniqueidentifier, --for audit only
		@StructDivisionId uniqueidentifier, -- for audit only
		@EventBatch uniqueidentifier, --for audit only
		@EventDate datetime, --for audit
		@AuditUserId uniqueidentifier, --for audit only

		--Values to insert
		@Id uniqueidentifier,
		@UpdatedDate datetime,
		@QnnId uniqueidentifier,
		@ListSampleId uniqueidentifier,
		@DplyId uniqueidentifier,
		@DateStart datetime,
		@DateComplete datetime,
		@IsPrePopulated BIT,
		@LastSavedPage NVARCHAR(255),
		@AnonymousId uniqueidentifier,
		@IpAddress NVARCHAR(2056),
		@InitialResponseAs NVARCHAR(50),
		@InitialResponseBy NVARCHAR(50),
		@InitialResponseVia NVARCHAR(50),
		@InitialResponseUserId uniqueidentifier,
		@LastResponseAs NVARCHAR(50),
		@LastResponseBy NVARCHAR(50),
		@LastResponseVia NVARCHAR(50),
		@UserId uniqueidentifier, --not for audit any more
		@CompletedResponseAs NVARCHAR(50),
		@CompletedResponseBy NVARCHAR(50),
		@CompletedResponseVia NVARCHAR(50),
		@CompletedResponseUserId uniqueidentifier,
		@Strata NVARCHAR(255)
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		INSERT INTO QNN_RESP (
			Id, 
			UpdatedDate,
			QnnId, 
			ListSampleId, 
			DplyId, 
			UserId, 
			DateStart, 
			DateComplete, 
			IsPrePopulated, 
			LastSavedPage, 
			AnonymousId, 
			IpAddress,
			InitialResponseAs,
			InitialResponseBy,
			InitialResponseVia,
			InitialResponseUserId,
			LastResponseAs, 
			LastResponseBy, 
			LastResponseVia,
			CompletedResponseAs,
			CompletedResponseBy,
			CompletedResponseVia,
			CompletedResponseUserId,
			Strata)
			SELECT 
				@Id, 
				@UpdatedDate,
				@QnnId, 
				@ListSampleId, 
				@DplyId,
				@UserId, 
				@DateStart, 
				@DateComplete,
				@IsPrePopulated, 
				@LastSavedPage, 
				@AnonymousId, 
				@IpAddress,
				@InitialResponseAs,
				@InitialResponseBy,
				@InitialResponseVia,
				@InitialResponseUserId,
				@LastResponseAs,
				@LastResponseBy,
				@LastResponseVia,
				@CompletedResponseAs,
				@CompletedResponseBy,
				@CompletedResponseVia,
				@CompletedResponseUserId,
				@Strata;
				
		IF @AuditOn=1
			BEGIN
				INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @AuditUserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', @Id, null, null, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;
			END

	END