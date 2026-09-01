UPDATE TOP(1) [surveyplus.net].[dbo].[dwAppSettings] SET [Name]=N'TrkListActiveYN', [Value]=N'True', [GroupName]=N'TrackList', [ParamName]=N'Is Track List Active', [Order]='0', [EditorType]=N'0', [IsHidden]='0' WHERE ([Name]=N'TrkListActiveYN');
GO

ALTER TABLE [dbo].[QNN_LIST] DROP CONSTRAINT [FK_QNN_LIST_QNN_TRK_LIST]
GO

ALTER TABLE [dbo].[QNN_LIST] DROP COLUMN [TrkListId]
GO

ALTER TABLE [dbo].[QNN_LIST] ADD [TrkListIds] nvarchar(MAX) NULL 
GO



ALTER TABLE [dbo].[QNN_TRK_LIST] ADD [StructDivisionId] uniqueidentifier NULL 
GO
ALTER TABLE [dbo].[QNN_TRK_LIST] ADD DEFAULT newsequentialid() FOR [Id]
GO
ALTER TABLE [dbo].[QNN_TRK_LIST] ADD CONSTRAINT [FK_QNN_TRK_LIST_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[QNN_TRK_LIST_SAMPLE] ADD CONSTRAINT [Unique_TrkListId_UID] UNIQUE ([TrkListId], [UID])
GO


ALTER TABLE [dbo].[QNN_TRK_LIST_SAMPLE] ADD DEFAULT (newsequentialid()) FOR [Id]
GO

CREATE INDEX [IDX_UID] ON [dbo].[QNN_TRK_LIST_SAMPLE]
([UID] ASC) 
GO


CREATE INDEX [IDX_TrkListId] ON [dbo].[QNN_TRK_LIST_SAMPLE]
([TrkListId] ASC) 
GO

CREATE INDEX [IDX_Status] ON [dbo].[QNN_TRK_LIST_SAMPLE]
([Status] ASC) 
GO

-------------------

ALTER VIEW [dbo].[vSP_DeploymentSample] AS 
select 

Concat(sample.UID, ' (', sample.Name, ')') as [UIDName],
IIF (sample2.UID is null, null, Concat(sample2.UID, ' (', sample2.Name, ')')) as [PeerUIDName],
ls.ActiveYN as [Active],
sample.UID,
sample.Email,
sample.Name,
si.Remarks,
r.DateStart,
r.DateComplete,
(select top 1 1 from QNN_TRK_LIST_SAMPLE where UID=sample.UID) as HasTrkListIds,
si.ListSampleId as RespListSampleId,
r.Id as RespId,
si.Id as Id,
si.ListSampleId,
si.[Status],
s.Code as StatusCode,
s.Title as StatusTitle,
si.ReturnInd,
si.ProcessValidInd,
si.ProcessEditInd,
si.DplyId,
SUBSTRING(
        (
            SELECT '||'+qqf.Name  AS [text()]
            FROM QNN_QNN_FORM qqf
            WHERE qqf.QnnId = q.Id
            ORDER BY qqf.Name
            FOR XML PATH ('')
        ), 3, 1000) [FormNames], 

SUBSTRING(
		(
				SELECT '||'+qqf.[Language]  AS [text()]
				FROM QNN_QNN_FORM qqf
				WHERE qqf.QnnId = q.Id
				ORDER BY qqf.Name
				FOR XML PATH ('')
		), 3, 1000) [Languages],

SUBSTRING(
        (
            SELECT '||'+qqe.Token  AS [text()]
            FROM QNN_QNN_ENTITY qqe
            WHERE qqe.QnnId = q.Id
            ORDER BY qqe.[Language]
            FOR XML PATH ('')
        ), 3, 1000) [Tokens], 

SUBSTRING(
		(
				SELECT '||'+qqe.[Language]  AS [text()]
				FROM QNN_QNN_ENTITY qqe
				WHERE qqe.QnnId = q.Id
				ORDER BY qqe.[Language]
				FOR XML PATH ('')
		), 3, 1000) [OfflineLanguages],

d.QnnId,
d.CreatedDate,

q.Type,
--f.Name as FormName,

so.UserId,
d.StructDivisionId,
u.Name as UpdatedBy



from QNN_DPLY_SAMPLE_INFO si
left join QNN_DPLY d on d.Id = si.DplyId
left join QNN_QNN q on d.QnnId = q.Id
--left join QNN_QNN_FORM f on f.QnnId = q.Id
left join QNN_LIST_SAMPLE ls on si.ListSampleId = ls.Id
left join QNN_SAMPLE sample on sample.Id = ls.SampleId
left join QNN_SAMPLE sample2 on sample2.Id = ls.SamplePeerId
left join QNN_STATUS s on si.Status = s.Id
left join QNN_DPLY_SAMPLE_OWNER so on so.DplyId = si.DplyId and so.ListSampleId = si.ListSampleId
left join QNN_RESP r on r.DplyId = si.DplyId and r.ListSampleId = si.ListSampleId and r.QnnId = d.QnnId
left join dwSecurityUser u on u.Id = r.UserId
where ls.ActiveYN = 1
--where so.UserId = 'E41B48E3-C03D-484F-8764-1711248C4F8A' and si.DplyId = '24A7DA6E-E12D-47B8-8A7D-00A193FD2757'


GO



---------------------------------
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

	END
GO	
-------------------------------------------------
CREATE PROCEDURE [dbo].[spSP_GetTrkListSample]
		@TrkListId uniqueidentifier
	AS
	BEGIN

		select UID, NAME, EMAIL, REMARKS, s.Code as STATUSCODE, s.Title as STATUS from QNN_TRK_LIST_SAMPLE tls
		inner join QNN_STATUS s on s.Id = tls.Status where TrkListId = @TrkListId ORDER BY UID ASC

	END

GO
-----------------------------------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='948AB167-D5B8-43DF-B3D7-41F3FE871887', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.950', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-08 09:41:06.560', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2019-10-08T09:41:06.5470124+08:00",
  "entityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "6bb9025a-7861-e177-eded-333d69e577d4",
      "attributeId": "17bf4b77-798d-4cba-83d4-16ea2a7696b7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b63f953d-7550-606b-742b-a593cba856a2",
      "attributeId": "c25bbd26-a246-4904-9400-a34ee23930a3",
      "control": "dictionaryCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79853784-fc1e-c680-ffe9-cb8aaeff5c39",
      "attributeId": "ebcf3683-c851-499c-a4b9-e2daec3948c2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e158c090-63ad-c843-de20-e2fd018a051e",
      "attributeId": "9eef3bf1-726a-4bcc-81db-eb27a0a16b04",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ea041ec-525a-89ac-0908-fab13baf146b",
      "attributeId": "76f762fb-7aa1-47fd-9ecf-b0c17bca4b43",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1ccd0d11-07a4-5fa0-41d7-b5979cbfdfd1",
      "attributeId": "852fb683-2f47-412a-9e40-11de48808b16",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e8b13f8-da52-e713-1b09-efb0d94a0148",
      "attributeId": "98399b10-9bc8-442e-88ce-2ff314a8c7ba",
      "control": "headerDescription",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ce4fa93-6667-133a-8f7a-7604cf99939b",
      "attributeId": "83bee845-79e5-4929-b4fb-fe5cff7748a8",
      "control": "toggleEditEmail",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab9545bf-afde-3b8a-be20-7fd4fb38ff33",
      "attributeId": "27f10ba1-fbdf-4878-958c-8400ea40490f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f07bb99-136e-4e3c-2401-c27a6d38e5c6",
      "attributeId": "a11f6ad2-bda5-4a4f-bafd-230fa27ccb36",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9cf7eb23-7a27-f882-e683-4d1cd4e17c97",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "control": "nameInput",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bd5ce67-64b2-f488-1327-13b0fa4725bb",
      "attributeId": "483d548e-4239-40a9-82cd-c47981e25945",
      "control": "toggleEditName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed6d936f-04af-04c3-2ff0-a1c23fa25c83",
      "attributeId": "0d50217d-3b94-4aa3-bccb-7dbdbb222749",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "292801af-0143-79be-0402-be3fc30eec41",
      "attributeId": "3f17e524-114a-4c9a-a71f-99154710f20e",
      "control": "togglePassword",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4af24cb-542d-3804-ef56-7cb98f1ba120",
      "attributeId": "6899bb22-b9f9-48da-adef-29209c0b0595",
      "control": "toggleStatus",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "456dd0ff-56dd-614a-89a5-4c6983bdf189",
      "attributeId": "064f6b2f-14dc-48dd-8e6d-b4e175be873f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6daa775d-0f9a-63a3-a83f-3ee20de05d28",
      "attributeId": "82b9d680-7b4e-4d25-8b72-555bbb17fe8a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f06fd16-7354-7c35-0406-313e3dca70d2",
      "attributeId": "bb19edbc-181e-4f9d-9e8b-3f64a38dd911",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ca7559f5-2bb1-9ca3-df65-72516fecebce",
      "attributeId": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9a831ac8-6665-fa45-ad14-e0103cc972df",
      "attributeId": "a4ea549b-6fad-42b1-b5c5-c25af0d4828a",
      "control": "TrkListIds",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "49f4229e-2ed5-6cbf-bc35-84f3bdffa14f",
          "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
          "control": "ActiveYN",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ca89d71-5128-9a6a-c46f-83c9b59d14f0",
          "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62f8faa6-b7d9-e5ae-2b1d-88968f5ad0d9",
          "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "dbf9842b-37d4-0fb0-ada0-d035f5821578",
          "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b98176e2-3a0a-1342-d8b6-ecc361035af1",
          "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "955eebb3-28e6-5927-75b7-f7cdebf0bb25",
          "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d339890-30b0-5099-e5fa-c29f931d88f7",
          "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a6ab3152-ef5c-3e46-47b5-87c6ea7b39a6",
          "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1a17e60-f698-b26d-8cf7-53dd3eed081f",
          "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e53a0cd0-bbb9-568d-434b-81ba82c172ef",
          "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ce869cca-457e-8e84-7f2d-aedebaaa4f83",
          "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e949966f-95ee-78bd-208b-afb9f7465364",
          "attributeId": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
          "control": "Email",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d0cdf7e6-3aea-1d21-65f6-b93e864be0e2",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "Name",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6e0819a-a46c-6f4d-4ee2-2dddee8062a1",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "UID",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93a8b5de-28af-a8b7-313a-c6429a2ce66e",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "PeerName",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d28cd4d5-202d-3a60-99d3-55ab0fd8a62e",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "PeerUID",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "dbf01fb4-db82-d562-bddb-a718f924ef35",
      "entityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "8442fb3b-134a-c355-7d90-f3e49c30af2c",
          "attributeId": "9c84a07d-bde2-414d-8628-9665e6df1c4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9990f3ba-6ea2-01f2-2522-5df2b216d08e",
          "attributeId": "304670fb-e871-443c-9c62-75b544da93a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e980519-bb41-ee3b-b0f9-724fad5fe32e",
          "attributeId": "495a9b97-319e-4139-aade-8103d4bc2e41",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0df8f806-b655-09c3-7a45-f6edf7604746",
          "attributeId": "27a0ea17-2da1-4ebb-ba54-0f783e3d2907",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b49e1ae4-2ad3-3cd2-4a86-66ce0cda30c2",
          "attributeId": "fc40cac5-1da7-46d7-90c3-f8e90cf935cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8657b639-deed-2116-f436-1982cee0669d",
          "attributeId": "cde17e04-b25f-476e-b722-97c11da29326",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5abd8c3-1e7f-166b-91d7-6725f32c6ded",
          "attributeId": "cbe9a1b9-bea3-49e1-9e1e-ac8391624939",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df2b19f4-19fa-9d44-b12e-1590811b0e55",
          "attributeId": "f5682ad5-b493-43a5-864e-3d554ac37ddf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "970989ac-c2e1-737a-1d0c-fd77022f0cfe",
          "attributeId": "70c763b0-6a8e-4a59-959e-fd6859fdfc17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb1ae13-7ce8-8524-217c-23de6712a577",
          "attributeId": "b2761fa3-a119-48a0-84e8-5112873d10d3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1e49ed9-982d-bfdc-cc71-a21fd33e3522",
          "attributeId": "6eaf8118-3a45-4e6d-88bd-f0fd37671cd3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b6adfdac-f4c3-b5bd-5158-25befb267921",
          "attributeId": "b430f4f3-2d95-4d88-a2c7-b8d12d33b144",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e128c585-70ab-a73c-ad73-1fd43d8f738e",
          "attributeId": "641d5acb-3586-4c86-a28b-22c339609610",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": ""
}', [StructDivisionId]=NULL WHERE ([Id]='948AB167-D5B8-43DF-B3D7-41F3FE871887');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='C7D7BD7E-1766-4AB2-81F4-2A69A3B3D082', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.910', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 12:23:19.580', [Data]=N'{   
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
    }, 
    
    processTrkList: function(args){
        var trkListIds = args.data.TrkListIds;
        if(trkListIds==null || trkListIds==undefined) return {};   
        try {
            var arr = JSON.parse(trkListIds);
            var sourceArray = args.component.refs.TrkListIds.state.options;
        
            let newArray = [];
            arr.map((currentValue, index, array) => {
                // return element to new Array
                if (sourceArray.filter(function(e) { return e.key === currentValue; }).length > 0) {
                      /* contains the element we''re looking for */
                      newArray.push(currentValue);
                }

            });
            CloverApp.API.setDataField("TrkListIds", JSON.stringify(newArray));
            
        } catch (e) {
            return {};
        }
        return {};   

    },
    
    deleteListSample: function(args){
    
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
            
        }

        var listId = args.data.Id;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        var formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/list/deletelistsample'';
    
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success(response.message);
                    args.controlRef.refresh();
    
                } else {
                    alertify.error(response.message);
                }
    
            })
            .catch(error => {
                alertify.error(error.message);;
            });        
    
    
    },   
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    exportSample: function (args){
        var url = ''/list/exportsample?listId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
   submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                    CloverApp.API.setDataField("inputImportListSample", null);
                    CloverApp.API.setDataField("inputPassword", null);
                    args.component.refs.gridviewSample.refresh();
                    //CloverApp.API.setDataField("sampleAddedCount", response.statistics.sampleAdded);
                    //CloverApp.API.setDataField("sampleUpdatedCount", response.statistics.sampleUpdated);
                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.listSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.listSampleUpdated); 
                    if(response.items!=null && response.items!=undefined){
                        CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                    else{
                         return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [''gridviewImportSummary'']
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
 
  
               
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);;
            });
 
        };
            
         

    }, 
    
    dbExport: function(args){
        
    var downloadLink = document.createElement("a");
    var csv2 = "Email,ActiveYN,Name,NumRetry,Pwd,Mat@yahoo.com,TRUE,Mat Tan,34,5566,anthony@yahoo.com,TRUE,Anthony Chew,35,5566,John ,TRUE,John ,36,5566,Cathy,TRUE,Cathy,37,5566,zBenedict,TRUE,zBenedict,38,5566,zJane,TRUE,zJane,39,5566";
   
    var json = csv2;
    var fields = Object.keys(json[0])
    var replacer = function(key, value) { return value === null ? '''' : value } 
    var csv = json.map(function(row){
      return fields.map(function(fieldName){
        return JSON.stringify(row[fieldName], replacer)
      }).join('','')
    })
    csv.unshift(fields.join('','')) // add header column
    
    console.log(csv.join(''\r\n''))
    
    console.log(csv)

      var blob = new Blob(["\ufeff", csv]);
      var url = URL.createObjectURL(blob);
      downloadLink.href = url;
      downloadLink.download = "data.csv";

      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    },
    
    dbImport: function(args){
      
       var csvdata = args.component.refs.swzimport_1.state.csvdata;
       var datamodel = "QNN_LIST"
        if (csvdata == null) return alertify.error("Please choose a file!")
        var csvDataCount = csvdata.length;
        var oldData = args.state.app.form.data.modified;
        var newData = {};
        newData[''collectioneditor_sample''] = JSON.stringify(csvdata);
        var formData = $.extend(true,oldData,newData);
    
        var url = ''/SwzData/change?name='' + datamodel;
        var formDataString = JSON.stringify(formData);
        var msg = alertify.success("Loading...");

      $.post(url,{data: formDataString}).done(function (data) {
            
        if(data.success){
            var msg = csvDataCount + " respondents have been created"
              
            alertify.success(msg) ;
            console.log("response Json", data);
            console.log(args.state.app.form.data.modified.__collectioneditor_sample_totalcount);
               
               return {
                          app: {
                              form: {
                                  data: {
                                      modified: {
                                         __collectioneditor_sample_totalcount:csvDataCount
                                      }
                                  }
                              }
                          }
                      }
        }
        else {
            alertify.error(data.message);
            console.log(data.message);
            console.log(data);
        }
}).fail(function (jqxhr, textStatus, error) {
       alertify.error(textStatus);
    }); 
    return {};
      
    },
    
    goRecords: function(args){
        var modelArray = args.state.app.form.models.model; 
        var recordsCont= args.state.app.form.models.model[4];
        var isHidden = false;
        
        var newModal= {''key'': recordsCont[''key''], ''data-buildertype'': recordsCont[''data-buildertype''], ''children'': recordsCont[''children''],
        ''style-customcss'': recordsCont[''style-customcss''], ''style-float'':recordsCont[''style-float''], ''style-width'': recordsCont[''style-width''],
        ''style-hidden'': isHidden,};
    
        modelArray.splice(4,1,newModal); //Replace item in whole model series
    
        return {
            app:{
                form:{
                    models:{
                        model: modelArray
                    }
                }
            }
        }
    },
    
    newListSample: function(args){
        //window.location.href = ''/form/QNN_LIST_SAMPLE?listId='' +args.data.Id;
        //return {
        //    router :{
        //        push: ''/form/QNN_LIST_SAMPLE/listId/'' +args.data.Id
        //    
        //    }
        //}
         CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id)

    },

    
    
    goReview: function(args){

        var userId = args.data.Id;
        console.log("userid is" , userId);
        var form = ''/form/swzreviewlist/'';
        var userReview = form + userId;
        
    if (userId !== undefined ){    
       return {
                router :{
                    push: userReview
                
                }
            }
        
        }
    },
    
    listExport: function(args){
        console.log("list export")
        var modelArray = args.state.app.form.models.model; //The whole model series
        var oldModal = args.state.app.form.models.model[3].children[0].children[1].children[1].children[0].children[0].children[2].children[0];
        
        var jsonData = args.component.refs.collectioneditor_sample.state.data;
        console.log(jsonData);
          
        var newModal = {''content'': "Export", ''data-buildertype'': oldModal[''data-buildertype''], ''key'':  oldModal[''key''], ''secondary'': true, ''size'': "" ,''jsonData'': jsonData}

        console.log(''new model'', modelArray);
        console.log(''old model'', oldModal);
        
        modelArray.splice(1,1,newModal); //Replace item in whole model series
    
          return {
              app: {
                  form: {
                      models: {
                         model: modelArray
                        }
                      }
                  }
            }
        
    },
    
    
    listImport: function (args){
      console.log("View CSV DATA")
        console.log(args);
//      console.log(args.component.refs.swzimport_1.state.csvdata);
        var csvdata = args.component.refs.swzimport_1.state.csvdata;
        console.log(csvdata);
        if (csvdata === undefined || csvdata === null ){
            console.log("include file");
          alertify.error("Please, include CSV file for import!");
        }
        else if (csvdata !== undefined || csvdata !== null ){
            console.log("all undefined")
             return {
                  app: {
                      form: {
                          data: {
                              modified: {
                                  collectioneditor_sample:csvdata
                              }
                          }
                      }
                  }
              }
        }
        
    },
        
    closeModal: function (args){
        //CloverApp.API.setDataField("inputImportListSample", null);
        //CloverApp.API.setDataField("inputPassword", null);
        //CloverApp.API.setDataField("sampleAddedCount", null);
        //CloverApp.API.setDataField("sampleUpdatedCount", null);
        //CloverApp.API.setDataField("listSampleAddedCount", null);
        //CloverApp.API.setDataField("listSampleUpdatedCount", null);   
        //args.state.aop.forms.models.hideControls = [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headListSampleUpdated'']
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
}', [StructDivisionId]=NULL WHERE ([Id]='C7D7BD7E-1766-4AB2-81F4-2A69A3B3D082');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='715CE353-26D4-4C0F-8B65-57DB2DA22232', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:22.007', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-08 09:41:06.433', [Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "bcList",
        "data-buildertype": "breadcrumb",
        "items": [
          {
            "divider": "right angle",
            "text": "List",
            "url": "/form/SwzListList"
          },
          {
            "text": "Manage List",
            "active": true
          }
        ],
        "events": {
          "onItemClick": {
            "active": true,
            "actions": [
              "redirect"
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "style-width": "700px"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "headerPage",
        "data-buildertype": "container",
        "style-float": "left",
        "style-marginTop": "",
        "style-marginBottom": "10px",
        "style-marginLeft": "",
        "children": [
          {
            "key": "form_5",
            "data-buildertype": "form",
            "children": [
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "headerName",
                    "data-buildertype": "header",
                    "content": "Manage {nameInput}",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  }
                ]
              }
            ],
            "style-marginLeft": "7px",
            "style-customcss": ""
          }
        ],
        "style-source": "",
        "style-marginRight": "20px"
      }
    ],
    "style-source": "clear: both;\nmaxWidth: 1050;\n",
    "style-marginTop": "10px",
    "style-marginBottom": "",
    "style-marginLeft": "",
    "style-float": "left",
    "style-width": "700px",
    "style-customcss": ""
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-height": "10px",
    "children": []
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "style-float": "left",
                "style-width": "700px",
                "children": [
                  {
                    "key": "form_3",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "headerProperties",
                        "data-buildertype": "header",
                        "content": "Properties",
                        "size": "medium"
                      },
                      {
                        "key": "formgroup_5",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "nameInput",
                            "data-buildertype": "input",
                            "label": "List Title",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "text",
                            "readOnly": false,
                            "events": {},
                            "labelPosition": "",
                            "style-width": "",
                            "other-required": true
                          }
                        ]
                      },
                      {
                        "key": "formgroup_7",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "headerDescription",
                            "data-buildertype": "textarea",
                            "label": "List Description",
                            "fluid": true,
                            "other-required": false,
                            "events": {}
                          }
                        ]
                      },
                      {
                        "key": "formgroup_4",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "dictionaryCategory",
                            "data-buildertype": "dictionary",
                            "label": "Category Name",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_CATEGORY",
                            "columns": "Name ASC",
                            "events": {},
                            "filters": "[{\"column\":\"Type\", \"value\":\"L\", \"term\":\"=\"}]"
                          },
                          {
                            "key": "TrkListIds",
                            "data-buildertype": "dictionary",
                            "label": "Track List",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_TRK_LIST",
                            "columns": "Name ASC",
                            "events": {},
                            "multiple": true,
                            "clearable": true,
                            "style-hidden": false
                          }
                        ]
                      },
                      {
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "toggleStatus",
                            "data-buildertype": "checkbox",
                            "label": "Status",
                            "toggle": true,
                            "events": {},
                            "style-width": "300px"
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-customcss": ""
              }
            ],
            "style-width": "100%",
            "style-float": "left"
          },
          {
            "key": "container_13",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_2",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "",
                    "style-width": "700px",
                    "children": [
                      {
                        "key": "form_4",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "headerUser",
                            "data-buildertype": "header",
                            "content": "Records User Control",
                            "size": "medium"
                          },
                          {
                            "key": "formgroup_8",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditName",
                                "data-buildertype": "checkbox",
                                "label": "Edit Name",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_3",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditEmail",
                                "data-buildertype": "checkbox",
                                "label": "Edit Email",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_9",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "togglePassword",
                                "data-buildertype": "checkbox",
                                "label": "Edit Password",
                                "toggle": true
                              }
                            ]
                          }
                        ],
                        "style-source": "float:left"
                      }
                    ],
                    "style-customcss": "hrm-block",
                    "other-visibleConition": ""
                  },
                  {
                    "key": "container_11",
                    "data-buildertype": "container",
                    "children": [],
                    "style-float": "",
                    "style-source": "clear:both",
                    "style-customcss": "",
                    "style-width": ""
                  }
                ],
                "style-source": "hrm-block",
                "style-width": "700px"
              }
            ],
            "style-width": "100%"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "collectioneditor_1",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Alias",
                "name": "Alias",
                "width": "",
                "control": "input"
              },
              {
                "key": "ReqdYN",
                "name": "Reqd",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "UsrEditYN",
                "name": "UsrEdit",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "TxtRow",
                "name": "TxtRow",
                "control": "number",
                "width": "10%"
              },
              {
                "key": "TxtRegExp",
                "name": "TxtRegExp",
                "width": "25%",
                "control": "input"
              },
              {
                "key": "TxtRegExpErr",
                "name": "TxtRegExpErr",
                "width": "20%",
                "control": "input"
              }
            ],
            "header": true,
            "headerTitle": "List Sample Properties",
            "hierarchical": false,
            "placeholders": {
              "Type": [
                {
                  "key": "Type",
                  "data-buildertype": "input",
                  "label": "",
                  "fluid": true,
                  "onChangeTimeout": 200,
                  "readOnly": true,
                  "defaultValue": "1",
                  "style-hidden": false
                }
              ]
            },
            "events": {},
            "style-width": "100%",
            "style-customcss": "hmr-block",
            "style-marginBottom": "20px"
          }
        ],
        "style-customcss": "hrm-block",
        "style-width": "100%",
        "style-source": "padding: 10px;",
        "style-hidden": false
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnSave",
            "data-buildertype": "button",
            "content": "Save",
            "events": {
              "onClick": {
                "actions": [
                  "processTrkList",
                  "validate",
                  "save",
                  "goRecords"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzListList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          },
          {
            "key": "btnCancel",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "exit",
                  "redirect"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/swzlistlist"
                  }
                ]
              }
            },
            "secondary": true
          }
        ],
        "style-float": "right",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": ""
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelete",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "deleteListSample",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "deleteListSampleConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteListSampleConfirmText"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_7",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "inputPassword",
                            "data-buildertype": "input",
                            "label": "Password",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "password"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "hideMessages"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "headerSampleAdded",
                            "data-buildertype": "header",
                            "content": "Sample Added: {sampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": true,
                            "other-visibleConition": "data.sampleAddedCount!=null"
                          },
                          {
                            "key": "headerSampleUpdated",
                            "data-buildertype": "header",
                            "content": "Sample Updated: {sampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": true,
                            "other-visibleConition": "data.sampleUpdatedCount!= null"
                          },
                          {
                            "key": "headerListSampleAdded",
                            "data-buildertype": "header",
                            "content": "List Sample Added: {listSampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleAddedCount!=null"
                          },
                          {
                            "key": "headerListSampleUpdated",
                            "data-buildertype": "header",
                            "content": "List Sample Updated: {listSampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleUpdatedCount!= null"
                          },
                          {
                            "key": "gridviewImportSummary",
                            "data-buildertype": "gridview",
                            "columns": [
                              {
                                "key": "RowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "UID",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              }
                            ],
                            "style-hidden": false,
                            "events": {},
                            "other-visibleConition": "data.gridviewImportSummary!= null && data.gridviewImportSummary!=undefined",
                            "rowKey": "RowNo",
                            "minHeight": "150"
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_20",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "children": [],
                "style-float": "left"
              }
            ],
            "style-width": "",
            "style-float": "left",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      }
    ],
    "style-customcss": "hrm-block",
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "gridviewSample",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "PeerUID",
        "name": "Peer UID",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "PeerName",
        "name": "Peer Name",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      }
    ],
    "autoHeight": false,
    "offSet": "",
    "multiselect": true,
    "rowKey": "Id",
    "defaultSort": "UID ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowDblClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "pagerType": "server",
    "editFormShowType": "",
    "minHeight": "",
    "style-marginTop": "",
    "editForm": "QNN_LIST_SAMPLE",
    "style-hidden": false
  }
]', [StructDivisionId]=NULL WHERE ([Id]='715CE353-26D4-4C0F-8B65-57DB2DA22232');

GO

------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.370', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-08 09:29:38.730', [Data]=N'{

    addNewSample: function(args){
        
        var dplyId = args.data.Id;
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''listId'', listId);        
        var url = ''/deployment/addnewsample'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    //console.log(''addNewSample args:'', args);
                    alertify.success(response.message);
                    args.controlRef.refresh();
                    

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
            

    },
    manageDueDate: function(args){
        
        //console.log("manageDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
            
        }
        
    },
    changeDueDate: function(args){
        
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
        }
        var dplyId = args.data.Id;
        var dueDate = args.data.dueDate;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''dueDate'', dueDate);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/changeDueDate'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_1.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });        
        
        
    },    
    goBack: function(args) {
        args.state.router.history.goBack();
    },
    manageResend: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_2.close();
            alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_2.props.swzData.isOpen = true;
        }
        
    },
    reSend: function(args){
        //console.log("resend args", args);
        var dplyId = args.data.Id;
        var mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        var email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        var profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;        
        if(!mailMerge && !email && !profile){
            alertify.error("Check at least one");
            return {};
        }
        
        var msgContent = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
        }
        var subject = args.data.subject;
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Please input email subject");
            return {};            
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Please input messange content.");
            return {};            
        }
                
        
        
        //var formName = args.data.formName;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        //formData.append(''formName'', formName);
        formData.append(''email'', email);        
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/resend'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });   
        
    },
    
    sampleResetPassword: function(args){
        
        if (args.controlRef.state.selectedIndexes.length < 1){
            alertify.error("Please select at least one list sample");
            return
        }
        console.log("Sample reset password!", args);
        var sampleIds = [];
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var sampleId = args.controlRef.state.items[gridIndex].SampleId;
            sampleIds.push(sampleId);
        }
        CloverApp.API.setDataField("loading", "");
        //CloverApp.API.setDataField("loading", "Loading...");
        var formData = new FormData();
        formData.append(''sampleIds'', sampleIds);        
        var url = ''/deployment/resetresppassword'';
        alertify.success("Loading...");
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success(response.message);
                    //CloverApp.API.setDataField("loading", response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
                //CloverApp.API.setDataField("loading", error.message);
            });   
        
    },
    showModal: function(args){
        args.component.refs.swzmodal_2.props.swzData.isOpen = true;
    }
        
    

}', [StructDivisionId]=NULL WHERE ([Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8');

GO
-----------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='27855988-DDC1-4D16-9272-69EBE7E64C13', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-01 10:18:05.687', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 12:01:54.083', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST",
  "lastUpdate": "2019-10-09T12:01:54.0844405+08:00",
  "entityId": "8925f81a-4425-463d-b72f-c8838d5fe7e1",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "e8b988d7-5c0d-4bd1-b160-0f2548f9f5eb",
      "attributeId": "0ef98792-caf7-4846-bfe5-0b83a0c1d5e5",
      "control": "CreatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "10146111-8012-433a-b7fc-01cf7b582064",
      "attributeId": "afa62aec-4406-4599-bf24-2d53189c8ed7",
      "control": "CreatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3afd5212-4f07-4b09-a8be-7377e436001f",
      "attributeId": "285502d1-906d-4cc2-8480-8ddf5ff45d9c",
      "control": "DeletedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cc546992-4f9c-4348-83dd-ab56aed3424c",
      "attributeId": "965d6a57-869a-48d5-b0ac-0c92ae435a64",
      "control": "DeletedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f01c149-0123-4270-ad7c-9b4af6f5698e",
      "attributeId": "372129e5-3134-4111-8872-cb77256f5f33",
      "control": "",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c6bc36a5-9764-4860-b6b9-363de4993d30",
      "attributeId": "4d667fd1-dad1-4ed1-9436-6bfb18fee504",
      "control": "IsDeleted",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fdd9b4d-d781-4c91-a605-c09ca984f837",
      "attributeId": "719c13ad-9ca6-4266-be20-3758530d9753",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "784ca270-b718-48c1-b7e8-f80c84bd267e",
      "attributeId": "bb46e381-ca0f-438c-b7ab-efd8ae950321",
      "control": "NumberId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "47a176d2-27d7-4865-bc67-ed2858e2e44e",
      "attributeId": "b6faf64b-3748-49f1-b85a-f9d25d4dd857",
      "control": "UpdatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3b3a3b67-f5d0-4ecf-a522-cdc5b1b9f321",
      "attributeId": "7c8cfa76-0302-433f-b790-88c68d8e6755",
      "control": "UpdatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7eb682ad-33ed-f734-c9c6-831afccc85f9",
      "attributeId": "d5872be0-3f92-4a57-90ae-7d92aaebdd24",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b2018773-2287-ab4a-5f60-6c614b841b76",
      "entityId": "5ff36869-00f7-4cf7-9e38-2cf6fee8e5e9",
      "filter": "FilterByModelId",
      "parameter": "{TrkListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "0b495e66-5fe3-ba13-447a-757f07951de8",
          "attributeId": "18f7e35f-ab4f-4417-ad9d-9e1f5a992f6a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "31b9dde3-9ed3-acbb-c5bc-0affaa339495",
          "attributeId": "3e5b73da-af95-4c59-bec2-df5d2af0184f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00169120-a58c-6191-1128-3efcb8138ed2",
          "attributeId": "57a08f64-21a7-4cfc-abe1-89059e3cdbf1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a45dfd7-af98-74da-fe9e-53852c45ada2",
          "attributeId": "d6693675-df3f-4aeb-89b3-338630a4b84f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dce6bcc4-7a17-00ee-dfae-7afd173318b7",
          "attributeId": "92227ba4-c7e8-4559-a36b-2a869708e399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "354c0b78-05e9-6ff3-3045-11ef6ebab68b",
          "attributeId": "ec188c75-c0b8-45db-a435-da4c9e9218c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "43094dd3-9f9a-62be-e0ba-02e5cf3502ce",
          "attributeId": "b352bda9-7b97-44e7-8434-fc96cb99f393",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7eb5fe6b-a793-69df-fd3b-253edec15c99",
          "attributeId": "255321a4-a259-4f37-a818-67ab1d35e301",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "30f17cd4-0ed0-9fe8-32ee-a8714763562e",
          "attributeId": "193f311b-e307-493a-9636-f891973cba11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c314b582-f0e0-ff14-e785-213a1c9981e3",
          "attributeId": "7d6ac6cf-792b-4cfd-9aa8-54f6e35f4de8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e2c3df1b-49ef-9fe9-4862-5dc871151e70",
          "attributeId": "5a3d78f9-3b60-408e-a0bb-5686b35a32ba",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c8290d4-b2e1-caf1-20db-fdc95c3b3385",
          "attributeId": "75e49c5d-5f66-4720-9d47-f42bf3823605",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07612be1-d9b3-d63f-26f6-7181d3bcafd3",
          "attributeId": "22add706-8375-468e-a2bc-8f6027dd2dd0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df7d8798-f0bd-7d6c-3ef4-25e6087f12b0",
          "attributeId": "6186950f-7fc9-4c9b-92ed-cce3149adb9a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc57ec9d-cf48-1227-e7c5-b4d59dec0740",
          "attributeId": "9b4396e7-8ff7-436e-b334-a3abce78170c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='27855988-DDC1-4D16-9272-69EBE7E64C13');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='EA958DA5-0374-40DD-A53A-A00315A50A3A', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-04 15:06:37.850', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 11:59:47.800', [Data]=N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
        
    },
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
},

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
   submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/trklist/importsamples?token='' + token + ''&trkListId='' + args.data.Id;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                    CloverApp.API.setDataField("inputImportListSample", null);
                    args.component.refs.gridviewSample.refresh();
                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                    if(response.items!=null && response.items!=undefined){
                        CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                    else{
                         return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [''gridviewImportSummary'']
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
 
  
               
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);;
            });
 
        };
            
         

    }, 
 
   
        
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
    
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='EA958DA5-0374-40DD-A53A-A00315A50A3A');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='E6933014-C1D8-42A4-BDB1-5199B4D53677', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST_SAMPLE-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-01 10:18:05.903', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 10:13:54.463', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST_SAMPLE",
  "lastUpdate": "2019-10-09T10:13:54.4622261+08:00",
  "entityId": "5ff36869-00f7-4cf7-9e38-2cf6fee8e5e9",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "5d6dacd6-14b0-443d-9d1f-7b5219e20961",
      "attributeId": "18f7e35f-ab4f-4417-ad9d-9e1f5a992f6a",
      "control": "CreatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "95600632-b79b-40c1-93b0-fd583aaafaea",
      "attributeId": "3e5b73da-af95-4c59-bec2-df5d2af0184f",
      "control": "CreatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f30b780-a364-44f8-8b07-13e5d1af3658",
      "attributeId": "57a08f64-21a7-4cfc-abe1-89059e3cdbf1",
      "control": "DeletedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cea5351e-80c2-4cc1-99bb-c654116b9d33",
      "attributeId": "d6693675-df3f-4aeb-89b3-338630a4b84f",
      "control": "DeletedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2de6bfe9-1603-41ed-b4e6-0f568a8827b7",
      "attributeId": "92227ba4-c7e8-4559-a36b-2a869708e399",
      "control": "Email",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6e014a0b-6280-4170-912e-da799a6dc73b",
      "attributeId": "ec188c75-c0b8-45db-a435-da4c9e9218c7",
      "control": "",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74037b02-8809-4394-bca8-f7e174fc5e45",
      "attributeId": "b352bda9-7b97-44e7-8434-fc96cb99f393",
      "control": "IsDeleted",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2957beec-bcf6-4364-9672-cb66807b705e",
      "attributeId": "255321a4-a259-4f37-a818-67ab1d35e301",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08724a34-41ff-4d46-9cb2-ed3e376b670f",
      "attributeId": "193f311b-e307-493a-9636-f891973cba11",
      "control": "NumberId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3176d6e8-962e-4535-96dc-5a2ec3ce26c7",
      "attributeId": "7d6ac6cf-792b-4cfd-9aa8-54f6e35f4de8",
      "control": "Remarks",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f7e6b79-cf60-42ca-906b-6517c9803817",
      "attributeId": "5a3d78f9-3b60-408e-a0bb-5686b35a32ba",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9abc5b60-b16f-4fa4-9153-367b2811a7b5",
      "attributeId": "75e49c5d-5f66-4720-9d47-f42bf3823605",
      "control": "TrkListId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24f8db47-ed37-4d6c-8185-fb11e259fba8",
      "attributeId": "22add706-8375-468e-a2bc-8f6027dd2dd0",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "184054c8-9a25-4f05-ae86-426787d69f9e",
      "attributeId": "6186950f-7fc9-4c9b-92ed-cce3149adb9a",
      "control": "UpdatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a0797cc6-c895-446e-9708-0cf3593c3d09",
      "attributeId": "9b4396e7-8ff7-436e-b334-a3abce78170c",
      "control": "UpdatedDate",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='E6933014-C1D8-42A4-BDB1-5199B4D53677');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='76815DA0-9FBA-41FC-BE19-F1F7BFDC2212', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST_SAMPLE-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-04 15:21:43.720', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-04 16:12:33.083', [Data]=N'{
   init: function (args){
        var getTrkListId = function() {
            var url = window.location.href;
            var parts = url.split(''/'');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };        

        if(args.data.Id==undefined || args.data.Id==null){
           trkListId = getTrkListId();
            return {
                app: {
                    form: {
                        data: {
                            modified: {
                                TrkListId: trkListId
                            }
                        }
                    }
                }
            };               
        }

   },
   
    saveProp: function(args){

        var data = args.state.app.extra.spData.data;
        var model = args.state.app.extra.spData.model;
        var rule = args.state.app.extra.spData.rule;
        
        if(model.length>0){
            var hasError = false;
            var errors = {main: {}};    
            var messages = [];
            if(args.data["dictionarySample"]==null || args.data["dictionarySample"]=="00000000-0000-0000-0000-000000000000") {
                hasError = true;
                messages.push("Sample is required");
                errors.main["dictionarySample"] = true;
            }
            
            for (var key in data) {
                //if (data.hasOwnProperty(key)) {
                //    data[key] =  $("input[name=''"+key+"''], textarea[name=''"+key+"'']").val();
                //    args.data[key] = data[key];
                //}
                if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                    hasError = true;
                    messages.push("<br />" + key + " is required");
                    errors.main[key] = true;
                    //errors.ADDRESS1 = key + " " + "required";
                    //args.state.app.form.errors.main = {ADDRESS1: true};
                    //$("input[name=''"+key+"''], textarea[name=''"+key+"'']").parent().addClass(''error'');
                }
                
                if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                    
                    let funcArgs = ''value, data'';
                    let body = ''return '' + rule[key]["txtRegExp"];
                    let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                    if (typeof isValid === ''boolean''){
                        if (isValid === false) {
                            hasError = true;
                            messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                            errors.main[key] = true;
                        }
                    }
                    else{
                        error = isValid;
                    }
                    
    
                }            
                
            }
            //args.component.forceUpdate();
            //console.log("saveProp args: ", args);
            if(hasError){
                throw {
                    level: 1,
                    message: messages,
                    formerrors: errors
                };
            }
            
        }

        return ()=> {
        var listSampleId = args.data.Id;
        var listId = args.data.DictionaryListName;
        var formData = new FormData();
        formData.append(''listSampleId'', listSampleId);
        formData.append(''listId'', listId);        
        formData.append(''listSampleProp'', JSON.stringify(args.data));
        var url = ''/list/savelistprop'';
        return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success("List sample changed");
                    CloverApp.API.redirectToForm(''QNN_LIST'',response.item);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
           
        };
     },
   
      goBack: function(args) {
        args.state.router.history.goBack();
    },
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='76815DA0-9FBA-41FC-BE19-F1F7BFDC2212');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='343228F8-B8D1-4775-97F3-DD3278089BD7', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST_SAMPLE.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-01 10:18:05.803', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 10:13:54.350', [Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List Sample",
        "size": "large"
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "TrkListId",
            "data-buildertype": "dictionary",
            "label": "Track List",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_TRK_LIST",
            "columns": "Name ASC",
            "paging": true,
            "pageSize": "20",
            "other-readOnlyConition": "true",
            "events": {}
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Email",
            "data-buildertype": "input",
            "label": "Email",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Remarks",
            "data-buildertype": "textarea",
            "label": "Remarks",
            "fluid": true,
            "reference": "Remarks"
          },
          {
            "key": "Status",
            "data-buildertype": "dictionary",
            "label": "Status",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_STATUS",
            "columns": "Title ASC"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "goBack"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "secondary": true,
                "inverted": true
              }
            ]
          }
        ]
      }
    ]
  }
]', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='343228F8-B8D1-4775-97F3-DD3278089BD7');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='94DF18E6-8C55-43F0-883C-8B905A2D882F', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-01 10:18:05.203', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 12:01:53.963', [Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginBottom": "20px",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List",
        "size": "large"
      }
    ]
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "redirect"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "name": "target",
                        "value": "/form/swztrklists"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": true
              }
            ],
            "style-marginBottom": "20px",
            "style-float": "right"
          }
        ]
      }
    ]
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newTrkListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelete",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "gridDelete",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_7",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Track List Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "breadcrumb_1",
                            "data-buildertype": "breadcrumb",
                            "items": [
                              {
                                "text": "Download Template",
                                "url": "#"
                              }
                            ],
                            "events": {
                              "onItemClick": {
                                "active": true,
                                "actions": [
                                  "onDownloadTemplate"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "hideMessages"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "headerListSampleAdded",
                            "data-buildertype": "header",
                            "content": "Track List Sample Added: {listSampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleAddedCount!=null"
                          },
                          {
                            "key": "headerListSampleUpdated",
                            "data-buildertype": "header",
                            "content": "Track List Sample Updated: {listSampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleUpdatedCount!= null"
                          },
                          {
                            "key": "gridviewImportSummary",
                            "data-buildertype": "gridview",
                            "columns": [
                              {
                                "key": "RowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "UID",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              }
                            ],
                            "style-hidden": false,
                            "events": {},
                            "other-visibleConition": "data.gridviewImportSummary!= null && data.gridviewImportSummary!=undefined",
                            "rowKey": "RowNo",
                            "minHeight": "150"
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_20",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "children": [],
                "style-float": "left"
              }
            ],
            "style-width": "",
            "style-float": "left",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "gridviewSample",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "UID",
                "name": "UID",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Name",
                "name": "Name",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Email",
                "name": "Email",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "offSet": "",
            "multiselect": true,
            "rowKey": "Id",
            "defaultSort": "UID ASC",
            "events": {
              "onRowClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
                "targets": [],
                "parameters": []
              },
              "onRowDblClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "pagerType": "server",
            "editFormShowType": "",
            "minHeight": "",
            "style-marginTop": "",
            "editForm": "QNN_TRK_LIST_SAMPLE",
            "style-hidden": false
          }
        ],
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-customcss": "hrm-block",
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  }
]', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='94DF18E6-8C55-43F0-883C-8B905A2D882F');
GO
----------------------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='65E99B1A-44C8-47CF-94F3-E96A73E3F9FD', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.457', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 12:20:09.900', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2019-10-09T12:20:09.8983307+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "dd2b1de1-8906-5440-a0b1-02b52ae0b7bb",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "af0b83d4-7938-1792-7467-8cda8561fe59",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a586de72-847a-a985-3629-7e51539d4a84",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "734db879-1d82-c264-1027-f30a57b9b67a",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "34836eb8-15f1-34ec-ab1c-e0e535f12a9d",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dae432fc-ec82-a8f2-03d7-7b3b4495fdb5",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e51fde7-57db-97cb-44b5-43b57a7b2c7a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "799e556b-61ce-1fc4-4d1a-7dfecd1a571c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ec6ab480-72d9-4e70-8ae5-e9fa27776491",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1e4706d9-3dda-13d2-cbae-ba3192c4c478",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1af8c09f-a1a6-e6d2-68ca-5a2aff87db30",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8b3d96dc-a807-1e6b-281a-e9fd87c0c595",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a681a21-7ea6-fbdc-76c4-57adf19cd9be",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "45cc1a58-9465-85b9-733b-e35726bbe246",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14d66d-44b0-635d-b9cd-0586f86baca2",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "11709f94-f671-f1ef-9d2c-80c5a1411442",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2186040a-20a9-baa7-7aa7-dac44246641e",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29f312d4-dc1a-a3e3-f4b0-5b28f3125567",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039caea8-8b26-54a3-c82b-9d71aa0a285c",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039280c8-f268-964d-101a-4fc229a524d1",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "88d5edc3-9d2d-958d-fcd3-0dc260e95f00",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "348b6b76-a181-c3d8-10c3-64dccfcfb5c8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6b22e96c-497f-5dd8-f4d5-5451e39e1ed7",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c937d26-b286-4818-87c2-64ca646c0b09",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dd5554b7-3553-c9fc-c472-47b7ae764ae9",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1df3b42b-b6a3-bda3-e867-cf6e5ff6c146",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb3c783b-89c2-6c2a-cc11-b1a2bb3eb729",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "35ccbaae-388e-7f28-ea7c-7304541afae9",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "aa7f5eac-b5d0-45b2-a883-37af1e8c90b0",
      "entityId": "fe42f73b-dd23-468f-abce-7603be873b15",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{UserId: \"@UserId\", DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "ca856a82-8cf7-94e5-6a63-be0112a9de69",
          "attributeId": "5068b642-c419-4e66-9cb6-4c499f8fbf98",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac9a5899-a4ab-a832-2458-bbbe9297800e",
          "attributeId": "9839c5ec-1da6-4480-b4a4-dfcd0d8c7ee3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ec5edf34-3b0b-5c28-4a65-def784054037",
          "attributeId": "bc9ea8c1-8e42-46c1-a307-20bd1f16425c",
          "control": "DateComplete",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1cc6738a-1af6-a23b-389f-398c8fd7358f",
          "attributeId": "29955168-38dc-4bc4-9d09-51936f0c47a3",
          "control": "DateStart",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db11567c-09c6-2bea-b6d5-5d66ed18ea9a",
          "attributeId": "5092b667-2bd3-4e5c-901d-af0c08ab963f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07b46b6f-2327-8fa4-ad8b-1b372074f71f",
          "attributeId": "eae438a7-c933-4cf4-901f-9afe4676b5d2",
          "control": "FormNames",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29992aa5-ff10-8f3f-3496-af3af7c8c049",
          "attributeId": "3f32683a-0b73-4487-8f9f-bcf67f4cd3de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0af2ce3e-6c33-6c1a-02fb-adacf28ccf1e",
          "attributeId": "12b9130f-5b30-4de6-b1b3-9c87eb24b51b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9e3e3241-0ed5-991c-ceed-8a7e7dfa36e9",
          "attributeId": "8de04fab-6501-4963-9be1-d94e4e17bdad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e7862e2-a88f-65b7-a22f-0bd5d69b4126",
          "attributeId": "cb449047-fd1f-4877-a9e8-31ff27e3522d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99668211-09a4-a2ff-025b-712f80a76e84",
          "attributeId": "194b29f5-61d7-4e19-9bff-61b7d63a59bc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df75d4b6-1b24-8491-608f-65eb8e83b7a6",
          "attributeId": "bdd2c1e8-5fcc-425e-961a-902bb6a04b1b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20fb1a1a-4568-05f7-191a-5f7fe80c5e11",
          "attributeId": "6334a04c-beac-457e-a52c-6321f8eee654",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0333e9e4-2539-eea0-3fe5-469f369b162e",
          "attributeId": "5d21fa68-625e-47f7-8b04-7e2407cb6833",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbfc2be2-151c-fa31-134e-29e1565630d0",
          "attributeId": "ea09352e-57ba-4d9b-a1dc-c46e0f9d35a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d27dcbe-d8c3-9339-9c82-22c664862417",
          "attributeId": "a3a11c9c-b29d-409b-8bec-45da88c5d7cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9497d95-641b-128d-fb42-8ab57b7037e3",
          "attributeId": "cb1b05c3-930a-4336-82a3-8fcf1d5d03be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ecb61b0-5e91-a2c7-f3d2-9fafb61d274a",
          "attributeId": "e119a97f-3f94-4359-bf02-550c2523f58e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ba5e855-c142-3291-a47c-3e5f269c0371",
          "attributeId": "2f9a77cf-0afc-413a-abe5-8268e56c8f3b",
          "control": "StatusTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "856b1e54-6028-b354-5bca-6f9f8aafb1f0",
          "attributeId": "37e6a978-a4c0-401b-8541-c3d0185eaefc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bf4af0d-2c41-be37-d27f-6564ff0ed821",
          "attributeId": "2416c808-79fd-45b8-b9ea-09ff66b261dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47c01363-0e02-128d-6836-b43901d62d8c",
          "attributeId": "e62abbfa-5e05-45f0-a59d-d25f0a90e47a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa72e2c4-3908-eca1-c269-5ca4628df44b",
          "attributeId": "93d1e6f3-e3da-46c6-8da2-f145da19c67e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6fa66465-573e-4632-9c4e-750ad0ac62c8",
          "attributeId": "3471959f-a8e6-4f9d-a2da-31576050133b",
          "control": "UpdatedBy",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11d26d80-376f-8973-6288-de27abf1c25d",
          "attributeId": "a753de02-fd13-4bc3-ae01-6eae7328ef29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f43fdc1c-f627-7426-9850-996427464656",
          "attributeId": "f28450af-f6b1-4542-a45f-6cc55ee5fde9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "427de579-6284-9eb1-9750-783b5774e19e",
          "attributeId": "d39086c2-4287-47f5-849a-6bfc31068199",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6488bf01-dce3-3949-5bb1-ff6af4cc6d79",
          "attributeId": "e595ee74-c3d3-4a9b-bf08-f80bd060f0a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "43cd2953-ff4b-2b69-c5ca-22d93994e19f",
          "attributeId": "ad4c4bcf-4bc4-4d76-b5dc-19e231d8add5",
          "control": "UIDName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a02035f-211c-1876-254b-a560d3ee25d6",
          "attributeId": "9f5fe2e0-567d-4e48-9663-14bea8bf37bb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58447494-f997-591f-65a8-96a3895d481b",
          "attributeId": "3de1a952-89f2-458b-9c4b-3705651365ca",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='65E99B1A-44C8-47CF-94F3-E96A73E3F9FD');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='4AF67164-5E60-4905-9885-AFD6DA24CB3D', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.407', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-04 09:02:38.503', [Data]=N'{
    init: function (args) {
        var innerArgs = args;
        args.data.remarks = null;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-5].customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Remarks" + (p.row.Remarks!=null? '' ...'':''''));
                };
                model.columns[model.columns.length-4].customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showStatusModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, p.value);
                };                
                
                model.columns[model.columns.length-3].customFormatter = function (p) {
                    if(p.row.StatusCode==''PE''){
                        return CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, ''9731DE1D-2B6A-484C-BF10-44F842A3140E''), className: "ui button mini secondary" }, "Exempt");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Exempt");
                    }                
                    
                };        
                    
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                        return CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id), className: "ui button mini secondary" }, "Reset");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Reset");
                    }
                        
                };    
                
                model.columns[model.columns.length-1].customFormatter = function (p) {
                        return CloverApp.API.createElement("button", { onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), className: "ui button mini secondary" }, "Track" + (p.row.HasTrkListIds!=null? '' ...'':''''));
                };        

                model.columns[1].customFormatter = function (p) {

                    
                    if(p.row.Type=="P"){
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));
                        
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else if(p.row.Type=="O"){
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }                    
                    

                };
            }
            return model;
        };

        var genFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);            
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var genFormLinkButtons = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
            var element = CloverApp.API.createElement("span", { onClick: () =>  {
                CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)
            }, className: "link-style" }, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };        
        var genOfflineFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = "/dataedit/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var getRemarksAsync = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/dataeditor/getremarks'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        //console.log("getRemarksAsync args", args);
                        args.component.state.data.remarks = response.item;
                        args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                        args.controlRef.refs.remarksModal.openModal();
                        args.component.refs.remarks.forceUpdate();
                        
                    return {
                        app:{
                            form: {
                                data: {
                                    modified:{
                                        remarks: response.item
                                    }
                                }
                            }
                        }
                    }; 

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });


        };

        var showModal = function (args, id) {


            return getRemarksAsync(args, id);

        };
        

        var showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            console.log(''showTrkListsModal args: '', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", UID);
            CloverApp.API.setDataField("trkListSample_email", Email);  
            CloverApp.API.setDataField("trkListSample_name", Name);              
            CloverApp.API.setDataField("trkListSample_remarks", Remarks);
            CloverApp.API.setDataField("trkListSample_status", Status);       
            CloverApp.API.setDataField("trkListSample_statusTitle", StatusTitle);

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();


            var formData = new FormData();
            
            formData.append(''uid'', UID);        
            
            
            var url = ''/dataeditor/gettrklistsbyuid'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        if(response.item)
                            CloverApp.API.setDataField("dictionaryTrkList", response.item);                        
            
                    } else {
                        alertify.error(response.message);
                        args.controlRef.refs.trkListModal.close();
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                    args.controlRef.refs.rrkListModal.close();
                });            
            


        };     


        var showStatusModal = function (args, id) {
            //console.log(''showStatusModal args: '', args);

            args.state.app.extra.spData = id;
            

            var formData = new FormData();

            formData.append(''id'', id);        

            
            var url = ''/dataeditor/GetStatusItems'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                                                                args.controlRef.refs.statusModal.props.swzData.isOpen = true;
                        args.controlRef.refs.statusModal.openModal();
                        args.controlRef.refs.dropdownStatus.forceUpdate();

                    } else {
                        alertify.error(response.message);
                        args.controlRef.refs.statusModal.close();
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                    args.controlRef.refs.statusModal.close();
                });

                

        };        

        var setStatus = function (args, id, statusId) {
            
            console.log("setStatus args: ", args)
            var formData = new FormData();
            formData.append(''id'', id);        
            formData.append(''selectedStatusId'', statusId);
            var url = ''/dataeditor/setStatus'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        args.component.refs.grid.refresh();
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            

        };  

        var resetStatus = function (args, id) {
            
            console.log("setStatus args: ", args)
            var formData = new FormData();
            formData.append(''id'', id);        
            var url = ''/dataeditor/resetStatus'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        args.component.refs.grid.refresh();     
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            
                
        };  
                

        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    },
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append(''uid'', args.data.trkListSample_uid);
        formData.append(''email'', args.data.trkListSample_email);
        formData.append(''name'', args.data.trkListSample_name);
        formData.append(''remarks'', args.data.trkListSample_remarks);
        formData.append(''status'', args.data.trkListSample_status);
        formData.append(''trkListIds'', args.data.dictionaryTrkList);

        console.log(''addToTrkList args: '', args);
        
        
        var url = ''/dataeditor/settrklists'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success(response.message);
        
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                CloverApp.API.setDataField("dictionaryTrkList", null);  
                CloverApp.API.setDataField("trkListSample_uid", null);
                CloverApp.API.setDataField("trkListSample_email", null);    
                CloverApp.API.setDataField("trkListSample_name", null);                 
                CloverApp.API.setDataField("trkListSample_remarks", null);
                CloverApp.API.setDataField("trkListSample_status", null);       
                CloverApp.API.setDataField("trkListSample_statusTitle", null);               
            });
            
    
    
    },    
    setStatusAsync: function (args) {
        //console.log(''setStatusAsync args: '', args);
        var id = args.state.app.extra.spData;
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        formData.append(''id'', id);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
    
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    
    
    },
    submitRemarks: function (args) {
        var changeRemarksAsync = function (remarks, id) {
            var formData = new FormData();

            formData.append(''remarks'', remarks);
            formData.append(''id'', id);
            var url = ''/dataeditor/setremarks'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success(response.message);
                        args.component.refs.grid.refresh();
                        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
            
                args.component.refs.remarksModal.close();

        };

        let id = args.state.app.extra.spData;
        let remarks = args.data.remarks;
        changeRemarksAsync(remarks, id);

        return {


        };

    }

}
', [StructDivisionId]=NULL WHERE ([Id]='4AF67164-5E60-4905-9885-AFD6DA24CB3D');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.507', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-09 12:20:09.767', [Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "Name",
        "data-buildertype": "header",
        "content": "Deployment: {Name}",
        "size": "medium"
      }
    ],
    "style-marginBottom": "10px",
    "events": {}
  },
  {
    "key": "modalDiv",
    "data-buildertype": "container",
    "children": [
      {
        "key": "remarksModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "remarks",
                "data-buildertype": "textarea",
                "label": "Remarks",
                "fluid": true,
                "placeholder": "Remarks",
                "reference": "remarks"
              },
              {
                "key": "button_1",
                "data-buildertype": "button",
                "content": "Submit",
                "primary": false,
                "secondary": true,
                "inverted": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "submitRemarks"
                    ],
                    "targets": [
                      "grid"
                    ],
                    "parameters": []
                  }
                }
              }
            ]
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      },
      {
        "key": "statusModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "dropdownStatus",
            "data-buildertype": "dropdown",
            "label": "Dropdown",
            "fluid": true,
            "selection": true,
            "data-elements": [],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setStatusAsync",
                  "gridRefresh"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            }
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      },
      {
        "key": "trkListModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Add sample to track list",
            "size": "medium",
            "subheader": "You may select multiple track lists from the dropdown list. Click Submit to add or update sample to selected track lists"
          },
          {
            "key": "trkListSampleInfo",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\nUID: {trkListSample_uid}\n<p >&nbsp; </p> \nEmail: {trkListSample_email}\n<p >&nbsp; </p> \nStatus: {trkListSample_statusTitle}\n<p >&nbsp; </p> \nRemarks: {trkListSample_remarks}\n<p >&nbsp; </p> \n<div class=\"ui divider\"></div>",
            "isHtml": true
          },
          {
            "key": "dictionaryTrkList",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "multiple": true,
            "search": true,
            "clearable": true,
            "dataModel": "QNN_TRK_LIST",
            "columns": "Name ASC",
            "events": {
              "onChange": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            }
          },
          {
            "key": "button_4",
            "data-buildertype": "button",
            "content": "Submit",
            "primary": true,
            "inverted": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "addToTrkList"
                ],
                "targets": [
                  "trkListModal"
                ],
                "parameters": []
              }
            }
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      }
    ],
    "style-hidden": true,
    "events": {}
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/DataEditorDeploymentList"
              }
            ]
          }
        },
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Refresh",
        "secondary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridRefresh"
            ],
            "targets": [
              "grid"
            ],
            "parameters": []
          }
        },
        "primary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": 200,
        "placeholder": "Enter case number to search.....",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setFilter",
              "applyFilter"
            ],
            "targets": [
              "grid"
            ],
            "parameters": [
              {
                "name": "column",
                "value": "UID"
              }
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "events": {},
    "style-width": "100%"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UIDName",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": "",
        "type": ""
      },
      {
        "key": "FormNames",
        "name": "Form",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": ""
      },
      {
        "key": "UpdatedBy",
        "name": "UpdatedBy",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "DateStart",
        "name": "Date Start",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": "",
        "type": "datetime"
      },
      {
        "key": "DateComplete",
        "name": "Date Complete",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": "",
        "type": "datetime"
      },
      {
        "key": "Remarks",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "name": "Remarks",
        "width": ""
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "type": "custom",
        "width": ""
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": ""
      },
      {
        "name": "",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "key": "Actions2",
        "width": ""
      },
      {
        "key": "Actions3",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false
      }
    ],
    "rowKey": "Id",
    "pageSize": "20",
    "pagerType": "server",
    "defaultSort": "UID ASC",
    "style-marginBottom": "20px",
    "multiselect": false,
    "events": {},
    "rowHeight": "65",
    "minHeight": "250"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F');
-----------------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('52C60FE7-52BC-4191-9759-CED45EE3E7EA', N'metadata/forms', N'SwzTrklists-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 09:24:36.947', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 19:53:44.483', N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzTrklists",
  "lastUpdate": "2019-10-04T19:53:44.4817296+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "113be75a-51d8-db7b-9745-aa135fe7079e",
      "entityId": "8925f81a-4425-463d-b72f-c8838d5fe7e1",
      "filter": "StructDivisionFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "a48b0e41-42e3-b5bf-236c-cb7d58097919",
          "attributeId": "0ef98792-caf7-4846-bfe5-0b83a0c1d5e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c4718dba-a37a-e2a4-d649-453badbea717",
          "attributeId": "afa62aec-4406-4599-bf24-2d53189c8ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "02d4dd71-d721-1729-b506-31129fcfbf64",
          "attributeId": "285502d1-906d-4cc2-8480-8ddf5ff45d9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "259cb779-e7c2-0a70-ebb2-0be4c1d14904",
          "attributeId": "965d6a57-869a-48d5-b0ac-0c92ae435a64",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4356e2e-0efb-3d21-73b7-9bd832ed6538",
          "attributeId": "372129e5-3134-4111-8872-cb77256f5f33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "91ec88cb-f47f-e6a4-b6c7-3ad86472a77b",
          "attributeId": "4d667fd1-dad1-4ed1-9436-6bfb18fee504",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cbc14e0a-8d65-e061-6b29-9a76fc1dcd6c",
          "attributeId": "719c13ad-9ca6-4266-be20-3758530d9753",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0064dd14-81d0-47df-0fe3-53b71df1876f",
          "attributeId": "bb46e381-ca0f-438c-b7ab-efd8ae950321",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ab9e889-1c45-ff9f-3a47-fa62883c23a3",
          "attributeId": "b6faf64b-3748-49f1-b85a-f9d25d4dd857",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b4eecdfd-bddc-2570-4916-c12cba725473",
          "attributeId": "7c8cfa76-0302-433f-b790-88c68d8e6755",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2cd34842-a2a2-0d7f-7932-7ed390243f0c",
          "attributeId": "d5872be0-3f92-4a57-90ae-7d92aaebdd24",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b3fbb16d-b131-132e-503a-47c5b237b68f",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionId_Name",
          "parentId": "2cd34842-a2a2-0d7f-7932-7ed390243f0c",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('B6DFAB92-C666-4494-B09E-8E9E5DB00B64', N'metadata/forms', N'SwzTrklists.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 09:24:36.687', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 19:53:44.323', N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List",
        "size": "large"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Create",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridCreate"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
        "inverted": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "gridDelete"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": []
          }
        }
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "input_1",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              },
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Name, StructDivisionId_Name"
                  }
                ]
              }
            },
            "placeholder": "Filter by Name",
            "style-marginBottom": ""
          }
        ],
        "style-width": "48%",
        "style-float": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "right",
        "style-width": "48%",
        "children": [
          {
            "key": "dictionary_1",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter by Division",
            "dataModel": "vSP_StructDivision",
            "columns": "Name ASC",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "StructDivisionId_Name"
                  }
                ]
              }
            },
            "style-marginBottom": "",
            "paging": true,
            "pageSize": "20"
          }
        ]
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "form_2",
    "data-buildertype": "form",
    "children": []
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "StructDivisionId_Name",
        "name": "Division",
        "sortable": false,
        "filterable": false,
        "resizable": true
      }
    ],
    "rowKey": "Id",
    "rowHeight": "50",
    "minHeight": "250",
    "pageSize": "10",
    "defaultSort": "Name ASC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": true,
    "editForm": "QNN_TRK_LIST",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    }
  }
]', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('27855988-DDC1-4D16-9272-69EBE7E64C13', N'metadata/forms', N'QNN_TRK_LIST-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-01 10:18:05.687', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-09 12:01:54.083', N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST",
  "lastUpdate": "2019-10-09T12:01:54.0844405+08:00",
  "entityId": "8925f81a-4425-463d-b72f-c8838d5fe7e1",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "e8b988d7-5c0d-4bd1-b160-0f2548f9f5eb",
      "attributeId": "0ef98792-caf7-4846-bfe5-0b83a0c1d5e5",
      "control": "CreatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "10146111-8012-433a-b7fc-01cf7b582064",
      "attributeId": "afa62aec-4406-4599-bf24-2d53189c8ed7",
      "control": "CreatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3afd5212-4f07-4b09-a8be-7377e436001f",
      "attributeId": "285502d1-906d-4cc2-8480-8ddf5ff45d9c",
      "control": "DeletedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cc546992-4f9c-4348-83dd-ab56aed3424c",
      "attributeId": "965d6a57-869a-48d5-b0ac-0c92ae435a64",
      "control": "DeletedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f01c149-0123-4270-ad7c-9b4af6f5698e",
      "attributeId": "372129e5-3134-4111-8872-cb77256f5f33",
      "control": "",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c6bc36a5-9764-4860-b6b9-363de4993d30",
      "attributeId": "4d667fd1-dad1-4ed1-9436-6bfb18fee504",
      "control": "IsDeleted",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fdd9b4d-d781-4c91-a605-c09ca984f837",
      "attributeId": "719c13ad-9ca6-4266-be20-3758530d9753",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "784ca270-b718-48c1-b7e8-f80c84bd267e",
      "attributeId": "bb46e381-ca0f-438c-b7ab-efd8ae950321",
      "control": "NumberId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "47a176d2-27d7-4865-bc67-ed2858e2e44e",
      "attributeId": "b6faf64b-3748-49f1-b85a-f9d25d4dd857",
      "control": "UpdatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3b3a3b67-f5d0-4ecf-a522-cdc5b1b9f321",
      "attributeId": "7c8cfa76-0302-433f-b790-88c68d8e6755",
      "control": "UpdatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7eb682ad-33ed-f734-c9c6-831afccc85f9",
      "attributeId": "d5872be0-3f92-4a57-90ae-7d92aaebdd24",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b2018773-2287-ab4a-5f60-6c614b841b76",
      "entityId": "5ff36869-00f7-4cf7-9e38-2cf6fee8e5e9",
      "filter": "FilterByModelId",
      "parameter": "{TrkListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "0b495e66-5fe3-ba13-447a-757f07951de8",
          "attributeId": "18f7e35f-ab4f-4417-ad9d-9e1f5a992f6a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "31b9dde3-9ed3-acbb-c5bc-0affaa339495",
          "attributeId": "3e5b73da-af95-4c59-bec2-df5d2af0184f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00169120-a58c-6191-1128-3efcb8138ed2",
          "attributeId": "57a08f64-21a7-4cfc-abe1-89059e3cdbf1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a45dfd7-af98-74da-fe9e-53852c45ada2",
          "attributeId": "d6693675-df3f-4aeb-89b3-338630a4b84f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dce6bcc4-7a17-00ee-dfae-7afd173318b7",
          "attributeId": "92227ba4-c7e8-4559-a36b-2a869708e399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "354c0b78-05e9-6ff3-3045-11ef6ebab68b",
          "attributeId": "ec188c75-c0b8-45db-a435-da4c9e9218c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "43094dd3-9f9a-62be-e0ba-02e5cf3502ce",
          "attributeId": "b352bda9-7b97-44e7-8434-fc96cb99f393",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7eb5fe6b-a793-69df-fd3b-253edec15c99",
          "attributeId": "255321a4-a259-4f37-a818-67ab1d35e301",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "30f17cd4-0ed0-9fe8-32ee-a8714763562e",
          "attributeId": "193f311b-e307-493a-9636-f891973cba11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c314b582-f0e0-ff14-e785-213a1c9981e3",
          "attributeId": "7d6ac6cf-792b-4cfd-9aa8-54f6e35f4de8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e2c3df1b-49ef-9fe9-4862-5dc871151e70",
          "attributeId": "5a3d78f9-3b60-408e-a0bb-5686b35a32ba",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c8290d4-b2e1-caf1-20db-fdc95c3b3385",
          "attributeId": "75e49c5d-5f66-4720-9d47-f42bf3823605",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07612be1-d9b3-d63f-26f6-7181d3bcafd3",
          "attributeId": "22add706-8375-468e-a2bc-8f6027dd2dd0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df7d8798-f0bd-7d6c-3ef4-25e6087f12b0",
          "attributeId": "6186950f-7fc9-4c9b-92ed-cce3149adb9a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc57ec9d-cf48-1227-e7c5-b4d59dec0740",
          "attributeId": "9b4396e7-8ff7-436e-b334-a3abce78170c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('EA958DA5-0374-40DD-A53A-A00315A50A3A', N'metadata/forms', N'QNN_TRK_LIST-code.js', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 15:06:37.850', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-09 11:59:47.800', N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
        
    },
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
},

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
   submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/trklist/importsamples?token='' + token + ''&trkListId='' + args.data.Id;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                    CloverApp.API.setDataField("inputImportListSample", null);
                    args.component.refs.gridviewSample.refresh();
                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                    if(response.items!=null && response.items!=undefined){
                        CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                    else{
                         return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [''gridviewImportSummary'']
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
 
  
               
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);;
            });
 
        };
            
         

    }, 
 
   
        
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
    
}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('E6933014-C1D8-42A4-BDB1-5199B4D53677', N'metadata/forms', N'QNN_TRK_LIST_SAMPLE-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-01 10:18:05.903', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-09 10:13:54.463', N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST_SAMPLE",
  "lastUpdate": "2019-10-09T10:13:54.4622261+08:00",
  "entityId": "5ff36869-00f7-4cf7-9e38-2cf6fee8e5e9",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "5d6dacd6-14b0-443d-9d1f-7b5219e20961",
      "attributeId": "18f7e35f-ab4f-4417-ad9d-9e1f5a992f6a",
      "control": "CreatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "95600632-b79b-40c1-93b0-fd583aaafaea",
      "attributeId": "3e5b73da-af95-4c59-bec2-df5d2af0184f",
      "control": "CreatedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f30b780-a364-44f8-8b07-13e5d1af3658",
      "attributeId": "57a08f64-21a7-4cfc-abe1-89059e3cdbf1",
      "control": "DeletedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cea5351e-80c2-4cc1-99bb-c654116b9d33",
      "attributeId": "d6693675-df3f-4aeb-89b3-338630a4b84f",
      "control": "DeletedDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2de6bfe9-1603-41ed-b4e6-0f568a8827b7",
      "attributeId": "92227ba4-c7e8-4559-a36b-2a869708e399",
      "control": "Email",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6e014a0b-6280-4170-912e-da799a6dc73b",
      "attributeId": "ec188c75-c0b8-45db-a435-da4c9e9218c7",
      "control": "",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74037b02-8809-4394-bca8-f7e174fc5e45",
      "attributeId": "b352bda9-7b97-44e7-8434-fc96cb99f393",
      "control": "IsDeleted",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2957beec-bcf6-4364-9672-cb66807b705e",
      "attributeId": "255321a4-a259-4f37-a818-67ab1d35e301",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08724a34-41ff-4d46-9cb2-ed3e376b670f",
      "attributeId": "193f311b-e307-493a-9636-f891973cba11",
      "control": "NumberId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3176d6e8-962e-4535-96dc-5a2ec3ce26c7",
      "attributeId": "7d6ac6cf-792b-4cfd-9aa8-54f6e35f4de8",
      "control": "Remarks",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f7e6b79-cf60-42ca-906b-6517c9803817",
      "attributeId": "5a3d78f9-3b60-408e-a0bb-5686b35a32ba",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9abc5b60-b16f-4fa4-9153-367b2811a7b5",
      "attributeId": "75e49c5d-5f66-4720-9d47-f42bf3823605",
      "control": "TrkListId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24f8db47-ed37-4d6c-8185-fb11e259fba8",
      "attributeId": "22add706-8375-468e-a2bc-8f6027dd2dd0",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "184054c8-9a25-4f05-ae86-426787d69f9e",
      "attributeId": "6186950f-7fc9-4c9b-92ed-cce3149adb9a",
      "control": "UpdatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a0797cc6-c895-446e-9708-0cf3593c3d09",
      "attributeId": "9b4396e7-8ff7-436e-b334-a3abce78170c",
      "control": "UpdatedDate",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('76815DA0-9FBA-41FC-BE19-F1F7BFDC2212', N'metadata/forms', N'QNN_TRK_LIST_SAMPLE-code.js', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 15:21:43.720', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-04 16:12:33.083', N'{
   init: function (args){
        var getTrkListId = function() {
            var url = window.location.href;
            var parts = url.split(''/'');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };        

        if(args.data.Id==undefined || args.data.Id==null){
           trkListId = getTrkListId();
            return {
                app: {
                    form: {
                        data: {
                            modified: {
                                TrkListId: trkListId
                            }
                        }
                    }
                }
            };               
        }

   },
   
    saveProp: function(args){

        var data = args.state.app.extra.spData.data;
        var model = args.state.app.extra.spData.model;
        var rule = args.state.app.extra.spData.rule;
        
        if(model.length>0){
            var hasError = false;
            var errors = {main: {}};    
            var messages = [];
            if(args.data["dictionarySample"]==null || args.data["dictionarySample"]=="00000000-0000-0000-0000-000000000000") {
                hasError = true;
                messages.push("Sample is required");
                errors.main["dictionarySample"] = true;
            }
            
            for (var key in data) {
                //if (data.hasOwnProperty(key)) {
                //    data[key] =  $("input[name=''"+key+"''], textarea[name=''"+key+"'']").val();
                //    args.data[key] = data[key];
                //}
                if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                    hasError = true;
                    messages.push("<br />" + key + " is required");
                    errors.main[key] = true;
                    //errors.ADDRESS1 = key + " " + "required";
                    //args.state.app.form.errors.main = {ADDRESS1: true};
                    //$("input[name=''"+key+"''], textarea[name=''"+key+"'']").parent().addClass(''error'');
                }
                
                if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                    
                    let funcArgs = ''value, data'';
                    let body = ''return '' + rule[key]["txtRegExp"];
                    let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                    if (typeof isValid === ''boolean''){
                        if (isValid === false) {
                            hasError = true;
                            messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                            errors.main[key] = true;
                        }
                    }
                    else{
                        error = isValid;
                    }
                    
    
                }            
                
            }
            //args.component.forceUpdate();
            //console.log("saveProp args: ", args);
            if(hasError){
                throw {
                    level: 1,
                    message: messages,
                    formerrors: errors
                };
            }
            
        }

        return ()=> {
        var listSampleId = args.data.Id;
        var listId = args.data.DictionaryListName;
        var formData = new FormData();
        formData.append(''listSampleId'', listSampleId);
        formData.append(''listId'', listId);        
        formData.append(''listSampleProp'', JSON.stringify(args.data));
        var url = ''/list/savelistprop'';
        return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success("List sample changed");
                    CloverApp.API.redirectToForm(''QNN_LIST'',response.item);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
           
        };
     },
   
      goBack: function(args) {
        args.state.router.history.goBack();
    },
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('343228F8-B8D1-4775-97F3-DD3278089BD7', N'metadata/forms', N'QNN_TRK_LIST_SAMPLE.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-01 10:18:05.803', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-09 10:13:54.350', N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List Sample",
        "size": "large"
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "TrkListId",
            "data-buildertype": "dictionary",
            "label": "Track List",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_TRK_LIST",
            "columns": "Name ASC",
            "paging": true,
            "pageSize": "20",
            "other-readOnlyConition": "true",
            "events": {}
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Email",
            "data-buildertype": "input",
            "label": "Email",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Remarks",
            "data-buildertype": "textarea",
            "label": "Remarks",
            "fluid": true,
            "reference": "Remarks"
          },
          {
            "key": "Status",
            "data-buildertype": "dictionary",
            "label": "Status",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_STATUS",
            "columns": "Title ASC"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "goBack"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "secondary": true,
                "inverted": true
              }
            ]
          }
        ]
      }
    ]
  }
]', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('94DF18E6-8C55-43F0-883C-8B905A2D882F', N'metadata/forms', N'QNN_TRK_LIST.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-01 10:18:05.203', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-10-09 12:01:53.963', N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginBottom": "20px",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List",
        "size": "large"
      }
    ]
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "redirect"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "name": "target",
                        "value": "/form/swztrklists"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": true
              }
            ],
            "style-marginBottom": "20px",
            "style-float": "right"
          }
        ]
      }
    ]
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newTrkListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelete",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "gridDelete",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_7",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Track List Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "breadcrumb_1",
                            "data-buildertype": "breadcrumb",
                            "items": [
                              {
                                "text": "Download Template",
                                "url": "#"
                              }
                            ],
                            "events": {
                              "onItemClick": {
                                "active": true,
                                "actions": [
                                  "onDownloadTemplate"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "hideMessages"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "headerListSampleAdded",
                            "data-buildertype": "header",
                            "content": "Track List Sample Added: {listSampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleAddedCount!=null"
                          },
                          {
                            "key": "headerListSampleUpdated",
                            "data-buildertype": "header",
                            "content": "Track List Sample Updated: {listSampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleUpdatedCount!= null"
                          },
                          {
                            "key": "gridviewImportSummary",
                            "data-buildertype": "gridview",
                            "columns": [
                              {
                                "key": "RowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "UID",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              }
                            ],
                            "style-hidden": false,
                            "events": {},
                            "other-visibleConition": "data.gridviewImportSummary!= null && data.gridviewImportSummary!=undefined",
                            "rowKey": "RowNo",
                            "minHeight": "150"
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_20",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "children": [],
                "style-float": "left"
              }
            ],
            "style-width": "",
            "style-float": "left",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "gridviewSample",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "UID",
                "name": "UID",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Name",
                "name": "Name",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Email",
                "name": "Email",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "offSet": "",
            "multiselect": true,
            "rowKey": "Id",
            "defaultSort": "UID ASC",
            "events": {
              "onRowClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
                "targets": [],
                "parameters": []
              },
              "onRowDblClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "pagerType": "server",
            "editFormShowType": "",
            "minHeight": "",
            "style-marginTop": "",
            "editForm": "QNN_TRK_LIST_SAMPLE",
            "style-hidden": false
          }
        ],
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-customcss": "hrm-block",
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  }
]', '72D461B2-234B-40D6-B410-B261964BA291');

GO
----------------

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A', [Folder]=N'metadata/forms', [Filename]=N'sidemenu-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.490', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-04 11:38:14.037', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2019-10-04T11:38:14.0353979+08:00",
  "isTemplate": false
}', [StructDivisionId]=NULL WHERE ([Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='55636648-E5A4-4002-9F59-D597FD167C04', [Folder]=N'metadata/forms', [Filename]=N'sidemenu.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.540', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-10-04 11:38:13.917', [Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "/form/SwzQnnList",
        "title": "Questionaires",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true",
        "children": [
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')==true"
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
          }
        ]
      },
      {
        "target": "/form/SwzListList",
        "title": "List",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true",
        "children": [
          {
            "target": "/form/SwzListList",
            "title": "Sample List",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track List",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
          }
        ]
      },
      {
        "target": "/form/SwzDplyList",
        "title": "Deployment",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "title": "Data Editor",
        "target": "/form/DataEditorDeploymentList",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')==true"
      },
      {
        "title": "Category",
        "target": "/form/SwzCategoryList",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/organizations",
        "title": "Organizations",
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "title": "Respondent Content Management",
        "target": "/form/SwzRespAdminList",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "target": "/useradmin",
        "title": "Security",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/audittrail",
        "title": "Audit Trail",
        "visibleCondition": "\t CloverApp.API.checkRole(''Admins'')==true"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "redirect"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": ""
  }
]', [StructDivisionId]=NULL WHERE ([Id]='55636648-E5A4-4002-9F59-D597FD167C04');
-----------------------