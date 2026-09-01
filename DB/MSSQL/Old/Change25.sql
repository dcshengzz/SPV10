

ALTER PROCEDURE [dbo].[spSP_UpdateResp]
		@Id uniqueidentifier,
		@UpdatedDate datetime,
		@DateComplete datetime = null,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @OriginalValue  AS NVARCHAR(MAX)
		set @OriginalValue = (select * from QNN_RESP where Id=@Id FOR JSON AUTO)

		IF @UserId is null
			BEGIN
				Update QNN_RESP 
				set 
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp
				where Id = @Id
			END
		ELSE
			BEGIN
				Update QNN_RESP 
				set 
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp,
				UserId = @UserId
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

