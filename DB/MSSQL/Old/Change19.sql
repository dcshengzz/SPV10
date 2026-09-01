
   
	ALTER PROCEDURE [dbo].[spSP_AddDplySampleInfoByListId]
		@DplyId uniqueidentifier,
		@ListId uniqueidentifier,
		@userpass varchar(256),
		@Status uniqueidentifier = 'A3D01086-40FC-4A7A-BF0C-DE17BDD205FA',
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		Create TABLE #Temp (Id uniqueidentifier)
		if(Exists(select top 1 1 from QNN_LIST_SAMPLE ls
		 WHERE ListId = @ListId 
		and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)
	))
			BEGIN		

				INSERT INTO QNN_DPLY_SAMPLE_INFO 
					(Id, DplyId, ListSampleId, Status, PdfPassword, CreatedDate)
				OUTPUT INSERTED.ID INTO #Temp(Id)
				SELECT NEWID(), @DplyId, Id, @Status, Upper(right(@DplyId, 12))+Lower(left(Id, 8)), GETDATE()
					FROM QNN_LIST_SAMPLE ls
				 WHERE ListId = @ListId 
				and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)

				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Insert', 'QNN_DPLY_SAMPLE_INFO', null, null, null, 
								(select * from QNN_DPLY_SAMPLE_INFO where Id IN( SELECT Id FROM #Temp) FOR JSON AUTO), @StructDivisionId;

					END


			END


	END
GO



	ALTER PROCEDURE [dbo].[spSP_DeleteAllRespAnsByRespId]
		@RespId uniqueidentifier,
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

		--DECLARE @AuditOn AS NVARCHAR(50);
		--set @AuditOn = (select [Value] from dwAppSettings where [Name] = 'AuditOn');
		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_RESP_ANS
				where RespId=@RespId FOR JSON AUTO), null, @StructDivisionId;
			END

		delete from QNN_RESP_ANS where RespId=@RespId; 



	END
	
GO
	
ALTER PROCEDURE [dbo].[spSP_DeleteByTableNameAndIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		DECLARE @query_all  AS NVARCHAR(MAX),
		 @dplyIds  AS NVARCHAR(MAX);
		--DECLARE @AuditOn AS NVARCHAR(50);
		--set @AuditOn = (select [Value] from dwAppSettings where [Name] = 'AuditOn');

		SET NOCOUNT ON;

		if(UPPER(@TableName)='QNN_DPLY')
			BEGIN

				if(Exists(select top 1 1 from QNN_RESP where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))

					BEGIN
						IF @AuditOn=1
							BEGIN
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
								
								delete from qnn_resp where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
							END
					END

				IF @AuditOn=1
					BEGIN 
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_DPLY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 
			END
		ELSE IF(UPPER(@TableName)='QNN_LIST')
		 BEGIN

				if(Exists(select top 1 1 from QNN_RESP r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
										(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
									SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r 
									inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id left join QNN_RESP_ANS ra on ra.RespId = r.Id 
									where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END

						delete r from qnn_resp r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId
							END									
							delete from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END
				IF @AuditOn=1
					BEGIN 
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST', null, null,(select * from QNN_LIST 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

					END

				delete from QNN_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

		 END
		ELSE IF(UPPER(@TableName)='QNN_QNN')
		 BEGIN
				if(Exists(select top 1 1 from QNN_RESP  where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
						delete from qnn_resp where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
	
					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
						delete from QNN_DPLY where QnnId IN (select Item FROM dbo.splitIds(@Ids, ',')); 
					END
					IF @AuditOn=1
						BEGIN 
							INSERT INTO AuditLog 
								(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
							SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_QNN', null, null,(select * from QNN_QNN 
							where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
						END

				delete from QNN_QNN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_CATEGORY')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_CATEGORY', null, null,(select * from QNN_CATEGORY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_CATEGORY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_RESP_ADMIN')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP_ADMIN', null, null,(select * from QNN_RESP_ADMIN 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_RESP_ADMIN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

	END
	
GO

	ALTER PROCEDURE [dbo].[spSP_DeleteSampleOwnerByIds]
		@Ids NVARCHAR(MAX),
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
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
			END
		delete from QNN_DPLY_SAMPLE_OWNER where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

	END
	
	
GO

	ALTER PROCEDURE [dbo].[spSP_DeleteSampleProp]
		@ListId uniqueidentifier,
		@ListSampleIds NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET NOCOUNT ON;

		if(Exists(select top 1 1 from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ','))))

			BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST_SAMPLE_PROP', null, null,(select * from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END			
				delete from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')); 
			END

	END

GO

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
		@AuditOn AS BIT = 0


	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO QNN_RESP 
					(Id, QnnId, ListSampleId, DplyId, UserId, UpdatedDate, DateStart, DateComplete, RespIp)
				SELECT @Id, @QnnId, @ListSampleId, @DplyId, @UserId, @UpdatedDate, @DateStart, @DateComplete, @RespIp;


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', null, null, null, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END

GO



ALTER PROCEDURE [dbo].[spSP_UpdateDplySampleInfo]
		@Id uniqueidentifier,
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@OldStatus uniqueidentifier,
		@NewStatus uniqueidentifier = '7C23B23E-23A3-4F04-96EF-89521BABE78D',
		@AuditOn AS BIT = 0


	AS
	BEGIN
		SET NOCOUNT ON;
		update QNN_DPLY_SAMPLE_INFO set Status = @NewStatus where Id = @Id;
		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_DPLY_SAMPLE_INFO', @Id, 'Status', @OldStatus, 
						@NewStatus, @StructDivisionId;
			END
	END

GO


ALTER PROCEDURE [dbo].[spSP_UpdateResp]
		@Id uniqueidentifier,
		@UpdatedDate datetime,
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
				RespIp = @RespIp
				where Id = @Id
			END
		ELSE
			BEGIN
				Update QNN_RESP 
				set 
				UpdatedDate = @UpdatedDate,
				RespIp = @RespIp,
				UserId = @UserId
				where Id = @Id
			END


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', @Id, null, @OriginalValue, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END

GO



