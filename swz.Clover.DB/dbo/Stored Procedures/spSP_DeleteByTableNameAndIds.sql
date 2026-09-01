




--------------
--Added delete qnnsample records
CREATE PROCEDURE [dbo].[spSP_DeleteByTableNameAndIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 1
	AS
	BEGIN
		DECLARE @query_all  AS NVARCHAR(MAX),
		 @dplyIds  AS NVARCHAR(MAX),
		 @HangFireJobID AS NVARCHAR(MAX),
		 @UploadedFilesToken AS NVARCHAR(MAX),
		 @FormPropertiesExcelFiles AS NVARCHAR(MAX);

		--DECLARE @AuditOn AS NVARCHAR(50);
		--set @AuditOn = (select [Value] from dwAppSettings where [Name] = 'AuditOn');

		SET XACT_ABORT, NOCOUNT ON;

		if(UPPER(@TableName)='QNN_DPLY')
			BEGIN
				if(Exists(select top 1 1 from QNN_RESP where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN
								INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END

							--Prepare tokens in comma delimited format to delete survey uploaded files 
							--at c# code after this store procedure is done.
							EXEC [dbo].[spSP_GetUploadedFiles]
								 @DplyId = @Ids,
								 @UploadedFilesToken = @UploadedFilesToken OUTPUT;
					END

				--Include tokens for this deployment's mail merge / profile files
				EXEC [dbo].[spSP_GetMailMergeFiles]
						@DplyId = @Ids,
						@UploadedFilesToken = @UploadedFilesToken OUTPUT
							
				DELETE FROM qnn_resp WHERE DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
					
				--Prepare this to delete hangfire job at c# code after this store procedure is done.
				SELECT @HangFireJobID = COALESCE(@HangFireJobID +','+ RecurrenceJobId, RecurrenceJobId) FROM QNN_DPLY WHERE RecurrenceJobId IS NOT NULL AND ID IN (SELECT Item FROM dbo.splitIds(@Ids, ','));

				--Unlink child recurrences before deleting parent deployments
				UPDATE QNN_DPLY SET RecurrenceOfDplyId=NULL WHERE RecurrenceOfDplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));

				IF @AuditOn=1
					BEGIN 
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_DPLY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

				--Return this to delete job and files via application c# code after this store procedure is done.
				SELECT @HangFireJobID as 'HangFireJobID', @UploadedFilesToken as 'UploadedFilesToken';

				RETURN;
			END
		ELSE IF(UPPER(@TableName)='QNN_LIST')
		 BEGIN

				if(Exists(select top 1 1 from QNN_RESP r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO sy_AuditLog 
										(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
									SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r 
									inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id left join QNN_RESP_ANS ra on ra.RespId = r.Id 
									where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
							
							--Prepare tokens in comma delimited format to delete survey uploaded files at c# code after this store procedure is done.
							EXEC [dbo].[spSP_GetUploadedFiles]
								 @ListId = @Ids,
								 @UploadedFilesToken = @UploadedFilesToken OUTPUT

						delete r from qnn_resp r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId
							END									
							delete from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END
				IF @AuditOn=1
					BEGIN 
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST', null, null,(select * from QNN_LIST 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

					END

				delete from QNN_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));

				--Return this to proceed at c# code after this store procedure is done.
				SELECT @UploadedFilesToken as 'UploadedFilesToken';
				RETURN;
		 END
		ELSE IF(UPPER(@TableName)='QNN_QNN')
		 BEGIN
				if(Exists(select top 1 1 from QNN_RESP  where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
						
						--Prepare tokens in comma delimited format to delete survey uploaded files at c# code after this store procedure is done.
						EXEC [dbo].[spSP_GetUploadedFiles]
							 @QnnId = @Ids,
							 @UploadedFilesToken = @UploadedFilesToken OUTPUT
					 
						delete from qnn_resp where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
	
					END

				if(Exists(select top 1 1 from QNN_DPLY where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END

						

						--Prepare this to delete hangfire job at c# code after this store procedure is done.
						SELECT @HangFireJobID = COALESCE(@HangFireJobID +','+ RecurrenceJobId, RecurrenceJobId) FROM QNN_DPLY WHERE RecurrenceJobId IS NOT NULL AND ID IN (SELECT ID FROM QNN_DPLY WHERE QnnId IN (SELECT Item FROM dbo.splitIds(@Ids, ',')));
						
						--Unlink child recurrences before deleting parent deployments
						UPDATE QNN_DPLY SET RecurrenceOfDplyId = NULL WHERE RecurrenceOfDplyId IN(SELECT ID FROM QNN_DPLY WHERE QnnId IN (SELECT Item FROM dbo.splitIds(@Ids, ',')));

						DELETE from QNN_DPLY WHERE QnnId IN (SELECT Item FROM dbo.splitIds(@Ids, ',')); 
					END
					
				if(Exists(select top 1 1 from QNN_QNN_FILE where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_QNN_FILE', null, null,(select * from QNN_QNN_FILE 
								where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
							
						--Prepare tokens in comma delimited format to delete uploaded files (excel files in form properties page) at c# code after this store procedure is done.
						SELECT @FormPropertiesExcelFiles = COALESCE(@FormPropertiesExcelFiles + ',' + Token, Token) FROM QNN_QNN_FILE WHERE QnnId IN (SELECT Item FROM dbo.splitIds(@Ids, ',')); 		
						
						DELETE FROM QNN_QNN_FILE WHERE QnnId IN (SELECT Item FROM dbo.splitIds(@Ids, ',')); 
					END

				IF @AuditOn=1
					BEGIN 
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_QNN', null, null,(select * from QNN_QNN 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END

				delete from QNN_QNN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 
				SET @UploadedFilesToken = COALESCE(NULLIF(@UploadedFilesToken,'') + ',', '') + COALESCE(NULLIF(@FormPropertiesExcelFiles,'') + ',', '')
				SELECT @HangFireJobID as 'HangFireJobID', @UploadedFilesToken as 'UploadedFilesToken';
				RETURN;
		 END

		ELSE IF(UPPER(@TableName)='QNN_RULE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RULE', null, null,(select * from QNN_RULE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_RULE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_STYLE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_STYLE', null, null,(select * from QNN_STYLE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_STYLE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_HELP')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_HELP', null, null,(select * from QNN_HELP 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_HELP where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_RESP_ADMIN')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP_ADMIN', null, null,(select * from QNN_RESP_ADMIN 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_RESP_ADMIN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_TRK_LIST_SAMPLE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_TRK_LIST_SAMPLE', null, null,(select * from QNN_TRK_LIST_SAMPLE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_TRK_LIST_SAMPLE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_TRK_LIST')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_TRK_LIST', null, null,(select * from QNN_TRK_LIST 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_TRK_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_SAMPLE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_SAMPLE', null, null,(select * from QNN_SAMPLE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END

				--Prepare tokens in comma delimited format to delete survey uploaded files at c# code after this store procedure is done.
				EXEC [dbo].[spSP_GetUploadedFiles]
					 @SampleId = @Ids,
					 @UploadedFilesToken = @UploadedFilesToken OUTPUT
				

			    delete p from QNN_LIST_SAMPLE_PROP p inner join QNN_LIST_SAMPLE ls on p.ListSampleId = ls.Id inner join QNN_SAMPLE s on s.Id = ls.SampleId where s.Id in( SELECT Item FROM dbo.splitIds(@Ids, ','))
				delete from QNN_SAMPLE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  


				SELECT @UploadedFilesToken as 'UploadedFilesToken';
				RETURN; 

		 END
		ELSE IF(UPPER(@TableName)='QNN_DPLY_CUSTOM_RECURRENCE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY_CUSTOM_RECURRENCE', null, null,(select * from QNN_DPLY_CUSTOM_RECURRENCE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_DPLY_CUSTOM_RECURRENCE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_SHORT_LINK' OR UPPER(@TableName)='vSP_ShortLink')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_SHORT_LINK', null, null,(select * from QNN_SHORT_LINK 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_SHORT_LINK where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
	END