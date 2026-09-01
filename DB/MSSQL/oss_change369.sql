/** 
-- Part 1
-- Create Tags column and copy over Category data
**/

PRINT 'Tags column create and migrate';
/*QNN_DPLY*/
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_DPLY' AND COLUMN_NAME = 'Tags'
AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1)
	BEGIN
		PRINT '- Start add Tags column to QNN_DPLY';
		EXEC ('ALTER TABLE [dbo].[QNN_DPLY] ADD Tags nvarchar(MAX)');

		PRINT '- Start migrate QNN_DPLY category to tags'
		EXEC ('UPDATE [QNN_DPLY] 
			SET [QNN_DPLY].Tags = ''["'' + CAT.Name + ''"]'' 
			FROM [QNN_DPLY] DPLY 
			INNER JOIN [QNN_CATEGORY] CAT 
			ON DPLY.CategoryId = CAT.Id');
		PRINT '- Completed migrate QNN_DPLY Category to Tags'
	END
ELSE
	PRINT '- QNN_DPLY Tags is already added';

/*QNN_QNN*/
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_QNN' AND COLUMN_NAME = 'Tags'
AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1)
	BEGIN
		PRINT '- Start add Tags column to QNN_QNN';
		EXEC ('ALTER TABLE [dbo].[QNN_QNN] ADD Tags nvarchar(MAX)');

		PRINT '- Start migrate QNN_QNN category to tags'
		EXEC ('UPDATE [QNN_QNN] 
			SET [QNN_QNN].Tags = ''["'' + CAT.Name + ''"]'' 
			FROM [QNN_QNN] QNN 
			INNER JOIN [QNN_CATEGORY] CAT 
			ON QNN.CategoryId = CAT.Id');
		PRINT '- Completed migrate QNN_QNN Category to Tags'
	END
ELSE
	PRINT '- QNN_QNN Tags is already added';

/*QNN_LIST*/
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_LIST' AND COLUMN_NAME = 'Tags'
AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1)
	BEGIN
		PRINT '- Start add Tags column to QNN_LIST';
		EXEC ('ALTER TABLE [dbo].[QNN_LIST] ADD Tags nvarchar(MAX)');

		PRINT '- Start migrate QNN_LIST category to tags'
		EXEC ('UPDATE [QNN_LIST] 
			SET [QNN_LIST].Tags = ''["'' + CAT.Name + ''"]'' 
			FROM [QNN_LIST] LIST 
			INNER JOIN [QNN_CATEGORY] CAT 
			ON LIST.CategoryId = CAT.Id');
		PRINT '- Completed migrate QNN_LIST Category to Tags'
	END
ELSE
	PRINT '- QNN_LIST Tags is already added';
	
/**
-- Part 2
-- Update View and Store Procedure to works with Tags
-- [vSP_DataEditorDeployment]
-- [vSP_DeploymentWithRespCount]
-- [vSP_ListWithCount]
-- [spSP_CopyRecurrentDply]
-- [spSP_DeleteByTableNameAndIds]
**/
/****** Object:  View [dbo].[vSP_DataEditorDeployment]    Script Date: 24/11/2022 12:32:26 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vSP_DataEditorDeployment] AS 
select o.DplyId AS Id, o.DplyId, o.UserId, d.Name, d.IsAnonymous, d.IsMultipleResponse,
CASE
	WHEN d.Status=1 THEN 'Active'   
	WHEN d.Status=0 THEN 'Design'   
END 
as StatusText, d.Status,

q.Title, q.Type as QnnType,  d.DateEnd, d.UpdatedBy, d.CreatedDate, d.UpdatedDate,  sc.SampleCount, rc.RespCount, d.Tags,

ISNULL(CAST(rc.RespCount as varchar(10)),0)  + '/' + CAST(sc.SampleCount as varchar(10)) as Responses, d.StructDivisionId, 

u.Name as UpdatedByUsername

from vSP_DeploymentOwner o
left join QNN_DPLY d on o.DplyId=d.Id
left join QNN_QNN q on d.QnnId = q.Id
left join dwSecurityUser u on u.Id = d.UpdatedBy
left join vSP_DeploymentSampleCount sc on sc.DplyId = o.DplyId
left join vSP_DeploymentRespCount rc on rc.DplyId = o.DplyId


where d.IsDeleted=0 and q.IsDeleted=0
GO

/****** Object:  View [dbo].[vSP_DeploymentWithRespCount]    Script Date: 24/11/2022 12:34:06 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vSP_DeploymentWithRespCount] AS 
select d.Name, d.Id, d.IsAnonymous, d.IsMultipleResponse, d.QnnId, qnn.Title as QnnId_Title, qnn.Type as QnnId_Type, list.Name as ListId_Name, d.Tags as Tags, 
d.CreatedDate, ISNULL(drc.RespCount, 0 ) as RespCount, ISNULL(sc.SampleCount,0) as SampleCount, d.StructDivisionId from QNN_DPLY d
left join vSP_DeploymentRespCount drc on d.Id = drc.DplyId
inner join QNN_QNN qnn on d.QnnId = qnn.Id
inner join QNN_LIST list on d.ListId = list.Id
left join vSP_DeploymentSampleCount sc on d.Id = sc.DplyId 
GO

/****** Object:  View [dbo].[vSP_ListWithCount]    Script Date: 24/11/2022 12:34:38 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vSP_ListWithCount] AS 
select l.Id, l.NumberId, l.Name, l.Tags as Tags, ISNULL(lsc.SampleCount, 0) as SampleCount, l.UpdatedDate, l.Status, l.StructDivisionId from QNN_LIST l
left join vSP_ListSampleCount lsc on lsc.ListId = l.Id
GO

/****** Object:  StoredProcedure [dbo].[spSP_CopyRecurrentDply]    Script Date: 24/11/2022 12:35:24 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[spSP_CopyRecurrentDply]
		@Id uniqueidentifier,
		@UserId uniqueidentifier,
		@DateStart datetime,
		@DateEnd datetime,
		@StartDeploymentImmediately bit,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@RecurrenceDplyId uniqueidentifier output

	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @RecurrenceId uniqueidentifier;
		SET @RecurrenceDplyId = NEWID();
	
		INSERT INTO QNN_DPLY ( 
			[Id], [DateStart], [DateEnd], 
			[VisibleToRespondent], [CreatedBy], [CreatedDate],
			[RecurrenceOfDplyId],
			[QnnId], [Type], [StructDivisionId],
			[Target], [Status], [Name], [ListId],
			[CompleteAction], [NavigateBackYN],	[NavigateCancelYN],
			[NavigateCancelURL], [MaxResponse], [DaysUpdate],
			[Tags], [IpCountry], [RestrictIp],
			[IpRange], [RestrictIpInclusive], [IsAnonymous], 
			[IsMultipleResponse], [SurveyName], [ApiIdentifier],
			[Description],[State], [RequireAccessCode], [IsExcelEnabled]
		) SELECT 
			@RecurrenceDplyId, @DateStart AS [DateStart], @DateEnd AS [DateEnd],
			@StartDeploymentImmediately AS VisibleToRespondent, @UserId AS CreatedBy, @EventDate AS CreatedDate,
			@Id AS [RecurrenceOfDplyId],
			[QnnId], [Type], @StructDivisionId,
			[Target], [Status], CONCAT([Name], ' ', convert(varchar(10),@DateStart,23)), [ListId],
			[CompleteAction], [NavigateBackYN],	[NavigateCancelYN],
			[NavigateCancelURL], [MaxResponse], [DaysUpdate],
			[Tags], [IpCountry], [RestrictIp],
			[IpRange], [RestrictIpInclusive], [IsAnonymous], 
			[IsMultipleResponse], CONCAT([SurveyName], ' ', convert(varchar(10),@DateStart,23)), [ApiIdentifier],
			[Description], [State], [RequireAccessCode], [IsExcelEnabled]
		FROM QNN_DPLY WHERE Id=@Id AND IsDeleted=0;

		IF @AuditOn=1
		BEGIN
			INSERT INTO AuditLog 
				(Id, UserId, SampleId, 
				 EventBatch, EventDate, EventType,
				 TableName, RecordId, ColumnName,
				 OriginalValue, NewValue, StructDivisionId)
			SELECT 
				NEWID(), @UserId, NULL,
				@EventBatch, @EventDate, 'Insert',
				'QNN_DPLY', @Id, null,
				NULL, (select * from QNN_DPLY where Id=@RecurrenceId FOR JSON AUTO), @StructDivisionId;

		END

	END
GO

/****** Object:  StoredProcedure [dbo].[spSP_DeleteByTableNameAndIds]    Script Date: 24/11/2022 12:35:57 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------
--Added delete qnnsample records
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
		 @dplyIds  AS NVARCHAR(MAX),
		 @HangFireJobID AS NVARCHAR(MAX),
		 @UploadedFilesToken AS NVARCHAR(MAX),
		 @FormPropertiesExcelFiles AS NVARCHAR(MAX);

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

							--Prepare tokens in comma delimited format to delete survey uploaded files at c# code after this store procedure is done.
							EXEC [dbo].[spSP_GetUploadedFiles]
								 @DplyId = @Ids,
								 @UploadedFilesToken = @UploadedFilesToken OUTPUT
							
							delete from qnn_resp where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));

					END
					
					--Prepare this to delete hangfire job at c# code after this store procedure is done.
					SELECT @HangFireJobID = COALESCE(@HangFireJobID +','+ RecurrenceJobId, RecurrenceJobId) FROM QNN_DPLY WHERE RecurrenceJobId IS NOT NULL AND ID IN (SELECT Item FROM dbo.splitIds(@Ids, ','));

					--Unlink child recurrences before deleting parent deployments
					UPDATE QNN_DPLY SET RecurrenceOfDplyId=NULL WHERE RecurrenceOfDplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));

				IF @AuditOn=1
					BEGIN 
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_DPLY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

				--Return this to proceed at c# code after this store procedure is done.
				SELECT @HangFireJobID as 'HangFireJobID', @UploadedFilesToken as 'UploadedFilesToken';

				RETURN;
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
								INSERT INTO AuditLog 
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
								INSERT INTO AuditLog 
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
								INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
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
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_SHORT_LINK', null, null,(select * from QNN_SHORT_LINK 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_SHORT_LINK where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
	END
GO

/**
-- Part 3
-- DROP Category Tables
**/

-- DROP QNN_CATEGORY_ROLE
PRINT 'Start Dropping Category';
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_CATEGORY_ROLE')
	BEGIN
		PRINT '- Dropping QNN_CATEGORY_ROLE';
		EXEC ('DROP TABLE [dbo].[QNN_CATEGORY_ROLE];')
	END
ELSE
	PRINT '- QNN_CATEGORY_ROLE is already removed';

-- DROP QNN_DPLY CategoryId
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_DPLY' AND COLUMN_NAME = 'CategoryId')
	BEGIN
		PRINT '- Dropping CategoryId column on QNN_DPLY';
		EXEC ('ALTER TABLE [dbo].[QNN_DPLY] DROP CONSTRAINT FK_QNN_DPLY_CategoryId;')
		EXEC ('ALTER TABLE [dbo].[QNN_DPLY] DROP COLUMN CategoryId;')
	END
ELSE
	PRINT '- QNN_DPLY CategoryId is already removed';

-- DROP QNN_LIST CategoryId
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_LIST' AND COLUMN_NAME = 'CategoryId')
	BEGIN
		PRINT '- Dropping CategoryId column on QNN_LIST';
		EXEC ('ALTER TABLE [dbo].[QNN_LIST] DROP CONSTRAINT FK_QNN_LIST_QNN_CATEGORY;')
		EXEC ('ALTER TABLE [dbo].[QNN_LIST] DROP COLUMN CategoryId;')
	END
ELSE
	PRINT '- QNN_LIST CategoryId is already removed';

-- DROP QNN_QNN CategoryId
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_QNN' AND COLUMN_NAME = 'CategoryId')
	BEGIN
		PRINT '- Dropping CategoryId column on QNN_QNN';
		EXEC ('ALTER TABLE [dbo].[QNN_QNN] DROP CONSTRAINT FK_QNN_QNN_CategoryId;')
		EXEC ('ALTER TABLE [dbo].[QNN_QNN] DROP COLUMN CategoryId;')
	END
ELSE
	PRINT '- QNN_QNN CategoryId is already removed';

-- DROP QNN_CATEGORY
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'QNN_CATEGORY')
	BEGIN
		PRINT '- Dropping QNN_CATEGORY';
		EXEC ('DROP TABLE [dbo].[QNN_CATEGORY];')
	END
ELSE
	PRINT '- QNN_CATEGORY is already removed';
