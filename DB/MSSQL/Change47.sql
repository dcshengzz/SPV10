

-----------------
--Add IsImputed

ALTER PROCEDURE [dbo].[spSP_InsertResp]
		@Id uniqueidentifier,
		@QnnId uniqueidentifier,
		@ListSampleId uniqueidentifier,
		@DplyId uniqueidentifier,
		@UpdatedDate datetime,
		@DateStart datetime,
		@DateComplete datetime,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@IsImputed AS BIT = 0,
		@LastSavedPage NVARCHAR(255)=null


	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO QNN_RESP 
					(Id, QnnId, ListSampleId, DplyId, UserId, UpdatedDate, DateStart, DateComplete, RespIp, IsImputed, LastSavedPage)
				SELECT @Id, @QnnId, @ListSampleId, @DplyId, @UserId, @UpdatedDate, @DateStart, @DateComplete, @RespIp, @IsImputed, @LastSavedPage;


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', null, null, null, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END

GO
----------


----
ALTER PROCEDURE [dbo].[spSP_UpdateResp]
		@Id uniqueidentifier,
		@UpdatedDate datetime,
		@DateStart datetime,		
		@DateComplete datetime = null,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@IsImputed AS BIT = 0,
		@LastSavedPage NVARCHAR(255) = null

	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @OriginalValue  AS NVARCHAR(MAX)
		set @OriginalValue = (select * from QNN_RESP where Id=@Id FOR JSON AUTO)

		IF @UserId is null
			BEGIN
				Update QNN_RESP 
				set 
				DateStart = @DateStart,				
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp,
				IsImputed = @IsImputed,
				LastSavedPage = @LastSavedPage
				where Id = @Id
			END
		ELSE
			BEGIN
				Update QNN_RESP 
				set 
				DateStart = @DateStart,				
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp,
				UserId = @UserId,
				IsImputed = @IsImputed,
				LastSavedPage = @LastSavedPage
				where Id = @Id
			END


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_RESP', @Id, null, @OriginalValue, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END
---------