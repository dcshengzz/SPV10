






CREATE   PROCEDURE [dbo].[spSP_UpdateResp]
	--Params related to audit
	@AuditOn BIT, --for audit only (i.e. is audit in use)
	@SampleId uniqueidentifier, --for audit only
	@StructDivisionId uniqueidentifier, -- for audit only
	@EventBatch uniqueidentifier, --for audit only
	@EventDate datetime, --for audit and also UpdatedDate
	@AuditUserId uniqueidentifier, --for audit only
		
	--Values for the qnn_resp update
	@Id uniqueidentifier,
	@UpdatedDate datetime,
	@DateStart datetime,		
	@DateComplete datetime,	
	@IsPrePopulated AS BIT,
	@LastSavedPage NVARCHAR(255),
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
	
	IF @AuditOn=1
		BEGIN
			DECLARE @OriginalValue  AS NVARCHAR(MAX);
			set @OriginalValue = (select * from QNN_RESP where Id=@Id FOR JSON AUTO);
		END

	--Preservation of existing values is now responsibility of the caller
	UPDATE QNN_RESP SET
		DateStart = @DateStart,				
		UpdatedDate = @UpdatedDate,
		DateComplete = @DateComplete,
		IsPrePopulated = @IsPrePopulated,
		LastSavedPage = @LastSavedPage,
		IpAddress = @IpAddress,
		InitialResponseAs = @InitialResponseAs,
		InitialResponseBy = @InitialResponseBy,
		InitialResponseVia = @InitialResponseVia,
		InitialResponseUserId = @InitialResponseUserId,
		LastResponseAs = @LastResponseAs,
		LastResponseBy = @LastResponseBy,
		LastResponseVia = @LastResponseVia,
		UserId = @UserId, --functions as LastResponseUserId (caller should preserve old value for a respondent update)
		CompletedResponseAs = @CompletedResponseAs,
		CompletedResponseBy = @CompletedResponseBy,
		CompletedResponseVia = @CompletedResponseVia,
		CompletedResponseUserId = @CompletedResponseUserId,
		Strata = @Strata
	WHERE 
		Id = @Id;

	IF(@@ROWCOUNT=0) 
		BEGIN
			RAISERROR ('Row not found',
				16, -- Severity.
				1 -- State.
				);	
		END

	IF @AuditOn=1
		BEGIN
			INSERT INTO sy_AuditLog 
						(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
					SELECT NEWID(), @AuditUserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_RESP', @Id, null, @OriginalValue, 
					(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

		END
END