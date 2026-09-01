
	
ALTER PROCEDURE [dbo].[spSP_DeleteByTableNameAndIds]
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
							END
								
							delete from qnn_resp where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
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
	
