--------------------------
--Fix: output last saved page instead of last not empty field
--Implementation guide:
--1. run this script
--2. do database sync for QNN_RESP model to add LastSavedPage field
ALTER TABLE [dbo].[QNN_RESP] ADD [LastSavedPage] nvarchar(255) NULL 
GO

-----------------
ALTER PROCEDURE [dbo].[spSP_GetRespAns] 
		@DplyId uniqueidentifier,
		@QnnId uniqueidentifier,
		@RespId uniqueidentifier
	AS
	BEGIN

		DECLARE @cols AS NVARCHAR(MAX),
		    @query_singleResp  AS NVARCHAR(MAX),
		    @query_allResp  AS NVARCHAR(MAX),
				@lastSavedPage as NVARCHAR(MAX)


		select @lastSavedPage = (select top 1 LastSavedPage from QNN_RESP
		where Id = @RespId and IsImputed<>1)


		select @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
		                    from qnn_qnn_field where QnnId = @QnnId
												and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
		                    group by Name, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'')


		set @query_singleResp = 'SELECT @lastSavedPage as [LastSavedPage], RespId, NumberId,' + @cols + ' from
		(
		select a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
		inner join qnn_qnn_field f on f.Id = a.QnnFieldId 
		inner join qnn_resp r on r.Id = a.RespId and f.QnnId=r.QnnId
		where r.Id = @RespId and f.QnnId= @QnnId' + '
		) d 
		pivot
		(
		max(AnsVal) 
		for SurveyFieldName in (' + @cols + ')
		            ) p order by NumberId'

		set @query_allResp = 'SELECT RespId, NumberId, ' + @cols + ' from
		(
		select a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
		inner join qnn_qnn_field f on f.Id = a.QnnFieldId 
		inner join qnn_resp r on r.Id = a.RespId and f.QnnId=r.QnnId
		where r.DplyId = @DplyId and f.QnnId=@QnnId
		) d 
		pivot
		(
		max(AnsVal) 
		for SurveyFieldName in (' + @cols + ')
		            ) p order by NumberId'


		if @RespId is null
			begin
				execute sp_executesql @query_allResp, N'@DplyId uniqueidentifier, @QnnId uniqueidentifier', @DplyId, @QnnId;
			END
		ELSE
			begin
				execute sp_executesql @query_singleResp, N'@lastSavedPage NVARCHAR(300), @RespId uniqueidentifier, @QnnId uniqueidentifier', @lastSavedPage, @RespId, @QnnId;
			END
	END


GO
--------------------------
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
		@LastSavedPage NVARCHAR(255)


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
------------------------


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
		@LastSavedPage NVARCHAR(255)

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

GO
----------------