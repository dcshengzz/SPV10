------------------------------------------------------------------
-- for imputation feature
------------------------------------------------------------------
-- to do database sync for table QNN_RESP, change DateStart from not null to null, add column IsImputed
-- need to do data sync and set Primary Key to Id for new views: vSP_DeploymentOnline, vSP_DeploymentQnnFields, vSP_DeploymentSampleAndPeerSample
-- to do database sync and set Primary Key as Id in Data model
CREATE VIEW [dbo].[vSP_DeploymentOnline] AS 
select d.Id, d.Name, d.QnnId, d.StructDivisionId from QNN_DPLY d
inner join QNN_QNN q on d.QnnId = q.Id
where q.Type='O' and d.IsDeleted = 0 and q.IsDeleted = 0 and q.Status = 1 and d.Status = 1
GO


CREATE VIEW [dbo].[vSP_DeploymentQnnFields] AS 
select f.*, d.Id as DplyId, d.StructDivisionId from QNN_QNN_FIELD f
inner join QNN_QNN q on f.QnnId = q.Id
inner join QNN_DPLY d on d.QnnId = q.Id
GO

-- to do database sync 
ALTER TABLE [dbo].[QNN_RESP] ADD [IsImputed] bit NULL 
GO

ALTER TABLE [dbo].[QNN_RESP] ALTER COLUMN [DateStart] datetime NULL 
GO

CREATE INDEX [IDX_Imputed] ON [dbo].[QNN_RESP]
([IsImputed] ASC) 
GO

-- to do database sync and set Primary Key as Id in Data model
CREATE VIEW [dbo].[vSP_DeploymentSampleAndPeerSample] AS 
select dsi.Id, Concat(s.UID, s2.UID) as MergedUID, ls.Id as ListSampleId, dsi.DplyId, r.Id as RespId, r.IsImputed  from QNN_DPLY_SAMPLE_INFO dsi
inner join QNN_LIST_SAMPLE ls on ls.Id = dsi.ListSampleId
inner join QNN_SAMPLE s on ls.SampleId=s.Id
left join QNN_SAMPLE s2 on ls.SamplePeerId =s2.Id
left join QNN_RESP r on r.ListSampleId = dsi.ListSampleId and r.DplyId = dsi.DplyId
where ls.ActiveYN = 1 and ls.IsDeleted = 0

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
				@lastNotEmptyField as NVARCHAR(MAX),
				@isImputed as BIT


		select @lastNotEmptyField = (select top 1 f.Name from QNN_RESP_ANS rs
		inner join QNN_QNN_FIELD f on f.Id = rs.QnnFieldId
		where RespId = @RespId and AnsVal<>'' order by f.NumberId desc)

		select @isImputed = (select top 1 isImputed from QNN_RESP 
		where Id = @RespId)

		if(@isImputed=1) set @lastNotEmptyField = null

		select @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
		                    from qnn_qnn_field where QnnId = @QnnId
												and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
		                    group by Name, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'')


		set @query_singleResp = 'SELECT @lastNotEmptyField as [LastNotEmptyField], RespId, NumberId,' + @cols + ' from
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
				execute sp_executesql @query_singleResp, N'@lastNotEmptyField NVARCHAR(300), @RespId uniqueidentifier, @QnnId uniqueidentifier', @lastNotEmptyField, @RespId, @QnnId;
			END
	END


GO


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
		@IsImputed AS BIT = 0


	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO QNN_RESP 
					(Id, QnnId, ListSampleId, DplyId, UserId, UpdatedDate, DateStart, DateComplete, RespIp, IsImputed)
				SELECT @Id, @QnnId, @ListSampleId, @DplyId, @UserId, @UpdatedDate, @DateStart, @DateComplete, @RespIp, @IsImputed;


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', null, null, null, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END

GO


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
		@IsImputed AS BIT = 0

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
				IsImputed = @IsImputed
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
				IsImputed = @IsImputed
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

-------------------
--Forms
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.340', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2020-01-07 13:08:23.927', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2020-01-07T13:08:23.9259589+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}', [StructDivisionId]=NULL WHERE ([Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='655275CF-8202-4438-B66B-874EAB315889', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.393', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2020-01-07 13:08:23.797', [Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left"
          }
        ],
        "style-float": "left"
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageMessageHistory",
            "data-buildertype": "button",
            "content": "Manage Message History",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyMessages"
                  }
                ]
              }
            }
          },
          {
            "key": "buttonManageListSamples",
            "data-buildertype": "button",
            "content": "Manage List Samples",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyListSample"
                  }
                ]
              }
            }
          }
        ],
        "style-float": "right"
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "style-source": "clear: both;",
        "style-marginBottom": "10px"
      },
      {
        "key": "container_12",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageDataEditors",
            "data-buildertype": "button",
            "content": "Manage Data Editors",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplySampleOwner"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null"
          },
          {
            "key": "buttonManageImputation",
            "data-buildertype": "button",
            "content": "Manage Imputation",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyImputation"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null"
          }
        ],
        "style-float": "right"
      }
    ]
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-height": "24px"
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
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {}
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "",
                "style-marginLeft": "32px",
                "other-readOnlyConition": ""
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": ""
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ]
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ]
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
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
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
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
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='655275CF-8202-4438-B66B-874EAB315889');
GO
------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('FDA09D74-02B3-4085-9BC7-D4B7457E1AAD', N'metadata/forms', N'dplyImputation-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-07 13:10:31.320', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-14 14:27:14.430', N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyImputation",
  "lastUpdate": "2020-01-14T14:27:14.4130094+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "0c5fe000-d5d0-5a64-104c-e7f1f12280ac",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29d8b956-8e2e-26ec-36a4-61cf663e6905",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "51778179-1119-e0ae-7f5c-a664c6e1611f",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f51f2d4b-9cf6-1258-8914-23dbee9b2fe0",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e6b13686-56ba-823f-7d4a-d2db4bb3cd9e",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19224cd3-7c22-ac6c-8bb8-fd61536d1233",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2dc05288-8957-2788-553e-c4b49022928c",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e2c99b3-aeca-7bbe-50e6-07f90af39af7",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b02a2117-747a-d512-ad06-b5cc9c5c8ef1",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1d68227d-1d05-079b-c826-7171bb015bcb",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e112652f-f104-44c6-0fdd-6193e2dd639b",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "81a69e67-7b1b-82fd-cd25-9e564cf1f2b0",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7b817447-7265-eaaa-cdff-c0fadb5dff56",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2b0a215-1328-6a3d-ad9d-cadd7524114b",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "81de3d2d-5855-ba97-f4a4-c7a69c5ce657",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb743015-363b-7187-9ee6-8abcd0cec3bf",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6c973712-a08a-123b-f74a-1c9611edc6d8",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a0b8586a-116b-666e-e0cf-c7ad2d7ba76c",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1b8d3fd5-4c90-8340-e430-594d4702f8cf",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fda33ab0-f60d-7a93-a573-b9df64ede83e",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e750482a-3322-907d-4e89-c286115dff43",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "861b3463-eff7-094d-5f84-89f810cf9bc2",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "def506ba-10f8-11aa-915a-2b865ad1148f",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b1eed774-a54a-cd8f-43d9-dc8bf6826ce2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bde9910-011f-02ef-13a8-0e521dce39c4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b7017236-9b84-049e-9d29-5ce3f73a2386",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d05c71f-fa09-d74b-d82f-5ca5341d7a7c",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4c13ac86-a8cf-9626-3dbc-0725de999539",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "87bf8367-7f33-120c-51bc-13a65b9666a8",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "FilterByModelId",
      "parameter": "{\"DplyId\": \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "e8fc1b85-7271-80f6-f5db-7abbf9102cd5",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "654cb2e0-d60d-11a6-81b9-89d5a6391d09",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df20a346-6578-da77-0f34-cda4ca6ef2eb",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "25a665c5-adc8-5136-efd5-b4ebe6577ef8",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "54cdb87c-2d0d-30a2-e960-0186b27ab305",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "68843a10-dabf-a488-e4e4-864c84e71bc6",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c39c7b02-3e76-25b4-6d34-48f0bcbed280",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d7b9aef5-e77a-647f-9271-0e56391bb7ed",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c5d3aa98-0af0-6acb-6960-cd4d0e2d8198",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "afae599b-324b-a97d-d857-cae544ce28a3",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ffe9a2d-a85e-d1de-21fa-0b80b42dd96f",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a6893b4d-353f-450f-b58f-73011a06cc83",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "13298baa-4ed4-abdb-550b-269e30a84b7b",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62660488-f17c-2709-b158-d6ee08293625",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b7703e1-a85c-e4d0-7c8b-d123530971c5",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86b6a73b-10f9-fccf-5bd7-26b037d2a5a5",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7f319432-7052-57d2-4658-d0cf51259a4e",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bcf891da-6313-ee9a-fb2c-8068e33b6751",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "397c39de-0906-7bb7-478d-8466e3d3791b",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b378ce9-79e7-bd2d-c17b-23aa53cd4c47",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8bd7b464-c732-03b2-ffc1-11feb1b89d48",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "42bf26c3-0875-0424-9e3e-95bc5ceccbba",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c3450994-3209-d395-7e2f-dd71c26ea396",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb61ab6-a8a2-1afe-3392-c28f4671f946",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d90d129-ee56-d675-3c3c-0a487be4a8a0",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "68212b0b-bbce-0238-0e05-5a061ff0d4b3",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c025da77-a5d2-7d48-45b0-1a824eeb306e",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86f7928b-6e30-92fd-bb83-349fd6e2ffcf",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc410d36-239e-0dda-20f8-2a67dc042442",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41acf343-3126-1d15-ebb0-da139584e196",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbea808f-0912-ec7d-cfbd-854a2e0c1d18",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b87c370d-4866-65d1-fd31-f8b4868cd036",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "235eef19-b6d3-9304-c2db-eebe841048e8",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c72a6f0-ac36-18df-408f-20ebdb72d8f3",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "be47cd17-d82c-abb8-befc-10435d88a995",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e1181da-9e11-a43b-d745-a3e4babd1614",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cf574690-8b00-e86b-b1ba-b47434368e41",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "30b48962-4755-df7d-338a-49d517eb78aa",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff3f2ee6-23d3-ebe9-7e59-afc431d0e3a0",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "90a4d756-9034-9f5d-d76f-00ef788fcf68",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07200185-4ff9-0699-2151-c110e5796dc6",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1462d956-c17d-1b13-158f-8c60a4b60275",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3d55fdf9-86fc-93fa-10ee-c3d0430c184e",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cc3dd912-c72b-65d9-07f2-f1bca3275e53",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "79f8839c-b22b-1824-9004-e4573f4d6dd1",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "66c50b8a-96be-9e13-8de4-2ba35154d520",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a11bd79-4b4a-4ac7-f19d-718b300ac6be",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ade35746-517c-7498-d99b-b349025e329c",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a4aa1b4-f051-8a7f-a3ae-d731396d3da2",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "069cfe51-46b2-fde0-e096-b45963acfc08",
      "entityId": "68339f93-8d97-48a4-bbce-7d9a70578e94",
      "filter": "FilterAsyncFieldsAndStruct",
      "control": "gridview_2",
      "dataMap": [
        {
          "id": "1c6e254c-244e-24d1-4c77-c7e1820bd9b6",
          "attributeId": "b8433cb2-0fe2-43c0-85dd-60fc7331f78b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0a1b0e90-f300-aae5-3972-2980a4b08c2f",
          "attributeId": "2f1ddc0c-f5e3-496a-af6a-4b8cdb7403ba",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "864439e0-6881-d1c6-f97b-adf23b96c545",
          "attributeId": "b33f4eb8-b433-4911-aad7-cc6a1860c216",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "87b523ea-77e0-5b8f-4777-8a92159c29e5",
          "attributeId": "04fcfab9-f3bd-4f76-8961-86100e9e7c1b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "769cf973-abba-0473-b4c0-56ddba3e998c",
          "attributeId": "828522aa-db19-4736-b6e0-c43b4d478eb7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b412b6e-965b-9fbb-ad25-e11ffdd6d6de",
          "attributeId": "15426d62-f31b-4f71-a373-1f304997649a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00c688cd-a8d3-a613-a704-350147fc7427",
          "attributeId": "0cb1823b-f508-49e0-9e24-42377977ac24",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "543d5d70-a0fc-4e14-b813-437fbda7f4f6",
          "attributeId": "0ffd8c7b-edb5-449e-a762-50bf6c835722",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "051fd71a-71b3-f7f9-b7e2-f0ac13732758",
          "attributeId": "a59e7d05-b0a7-44af-8490-f4fdfe64e6e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b4eaefb3-6970-e14b-26d3-a4d1d551560a",
          "attributeId": "a682e6b6-69f3-4bb9-9f5a-9e974307f920",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df9100a7-bcec-c3f5-cad7-27ecb38e9e38",
          "attributeId": "0ba47d07-0d73-4847-9e1b-8a6907fa568e",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('057F23A2-F709-4620-8A27-E95B43463BB3', N'metadata/forms', N'dplyImputation.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-07 13:10:30.993', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-14 14:27:14.157', N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Data imputation",
    "size": "huge",
    "subheader": " {Name}"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "Deployment",
        "data-buildertype": "dictionary",
        "label": "Source Deployment",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentOnline",
        "columns": "Name ASC",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "removeAllFields"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": false,
        "filters": "[{\"column\":\"Id\", \"value\":\"{Id}\", \"term\":\"!=\"}]"
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {}
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "DeploymentQnnFields",
        "data-buildertype": "dictionary",
        "label": "Source Fields",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentQnnFields",
        "columns": "Name, NumberId asc",
        "events": {
          "onChange": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": true,
        "filters": "[{\"column\":\"DplyId\", \"value\":\"{Deployment}\", \"term\":\"=\"}]",
        "search": true
      },
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "addAllFields",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Add All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "addAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            },
            "style-marginRight": "10px"
          },
          {
            "key": "breadcrumb_1",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Remove All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "removeAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            }
          }
        ]
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Impute",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "impute"
            ],
            "targets": [
              "DeploymentQnnFields"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true,
        "inverted": true
      }
    ],
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  }
]', '72D461B2-234B-40D6-B410-B261964BA291');
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('B1F0C760-698D-4018-85FF-4DEBEBF9EDF8', N'metadata/forms', N'dplyImputation-code.js', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-07 13:14:00.780', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2020-01-09 15:13:05.387', N'{
    addAllFields: function(args){
        var allFields = args.controlRef.state.options.map(function(option){
            return option.key;
        });
        CloverApp.API.setDataField("DeploymentQnnFields", allFields);
    },
    removeAllFields: function(args){
        CloverApp.API.setDataField("DeploymentQnnFields", []);
    },    
    
    impute: function(args){
        var fieldIds = args.controlRef.props.value;
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
        var dplyId = args.data.Id;
        var sourceDplyId = args.data.Deployment;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', sourceDplyId);         
        var url = ''/deployment/impute'';
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
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    }
 
}', '72D461B2-234B-40D6-B410-B261964BA291');
GO
-------------------