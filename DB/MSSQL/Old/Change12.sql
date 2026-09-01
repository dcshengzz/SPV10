CREATE PROCEDURE [dbo].[spSP_InsertResp]
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
		@EventDate datetime


	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO QNN_RESP 
					(Id, QnnId, ListSampleId, DplyId, UserId, UpdatedDate, DateStart, DateComplete, RespIp)
				SELECT @Id, @QnnId, @ListSampleId, @DplyId, @UserId, @UpdatedDate, @DateStart, @DateComplete, @RespIp;



		INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', null, null, null, 
				(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;



	END

GO


CREATE PROCEDURE [dbo].[spSP_UpdateDplySampleInfo]
		@Id uniqueidentifier,
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@OldStatus uniqueidentifier,
		@NewStatus uniqueidentifier = '7C23B23E-23A3-4F04-96EF-89521BABE78D'


	AS
	BEGIN
		SET NOCOUNT ON;
		update QNN_DPLY_SAMPLE_INFO set Status = @NewStatus where Id = @Id;

		INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_DPLY_SAMPLE_INFO', @Id, 'Status', @OldStatus, 
				@NewStatus, @StructDivisionId;

	END


GO

CREATE PROCEDURE [dbo].[spSP_UpdateResp]
		@Id uniqueidentifier,
		@UpdatedDate datetime,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime

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



		INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', @Id, null, @OriginalValue, 
				(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;



	END




GO

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='27DBFADB-0E83-4ACD-AF28-35A760E3239B', [Folder]=N'metadata/forms', [Filename]=N'QNN_QNN-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:22.637', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-17 14:42:57.543', [Data]=N'{
  "isSurvey": false,
  "name": "QNN_QNN",
  "lastUpdate": "2019-09-17T14:42:57.2244008+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnFieldsTrigger"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "InsertQnnPdfFieldsTrigger",
      "parameter": ""
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateOnlineFormTrigger"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy:\"@CurrentUserId\", UpdatedDate:\"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "InsertQnnOnlineFormFieldsTrigger"
    },
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    }
  ],
  "dataMap": [
    {
      "id": "f5c72328-b907-7ee0-8b55-f4239c8da6e8",
      "attributeId": "c808a448-06a0-4c5f-869a-3eb2c0a6c903",
      "control": "Alias",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "721e7992-c058-fdec-99de-e4b2134e0071",
      "attributeId": "0d19ac69-83df-4a34-9dff-53382d296641",
      "control": "CategoryId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89b15150-fab8-f905-e931-1395a6cae270",
      "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfb7bec7-b589-607d-5129-a59dde6190ea",
      "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "581270f1-2e71-5a5c-a88d-f8da9064a71a",
      "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74a0dac6-9a11-ed4e-b5c6-96fae81edb84",
      "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b137d32-d9f7-7c6d-dc7a-aa8d413b53df",
      "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa94aeed-0ff2-42b7-de9a-a6c8509a2c66",
      "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cd2ee951-429c-9622-3e69-141f0741a5e6",
      "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d260ba0c-a6d5-b700-2354-c322a00c1814",
      "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e194959a-a340-9add-f232-c1617b48df7d",
      "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24dae954-e67e-a607-a3e4-f2bbbe492700",
      "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
      "control": "Title",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ac8dd062-9404-30ae-2a60-f64a0d2b5851",
      "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2497b2ba-fde1-921b-eb23-7bb1c90c9cbd",
      "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0f31090-e7d8-6df6-df4b-17911aafcbd6",
      "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c8c1d3f-e294-9402-162b-ae1fc8eaf98e",
      "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a618b97-0e2c-8433-f49c-5ba34a9f6132",
      "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "a8f082fb-3708-b830-f8fc-c2d05863d63f",
      "entityId": "c20a37ac-e637-4eae-9ca5-274455d6b83d",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "be17b8b1-39ea-601c-0ae2-cd7a444c450b",
          "attributeId": "d41c0520-6ec8-4b9d-b5da-7d9f280353d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a23b7dbe-c559-b9de-9bdd-3fd2bab20a80",
          "attributeId": "632f1468-a0e6-4fcb-84a9-fa2c68b2b21f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19312a46-c3e9-34da-e26f-8b97d24f242b",
          "attributeId": "6b26300b-3db8-436f-a603-32f6f37c3cbc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf0498b1-893d-8a33-5103-4b51f8771ea2",
          "attributeId": "42f766b8-e59a-430d-aef0-e4d3f4e98d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "320d9b6b-4811-0e7a-11ab-2ec13580248d",
          "attributeId": "c548f205-edc0-4259-b840-c2035fad11cf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5344120d-e405-c4bb-48f0-e142c1b9eb2f",
          "attributeId": "c21bc428-4ab6-4155-9864-1523bdddb6b8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e8dc2fa-0fa2-2aed-ceca-92e58f8b583c",
          "attributeId": "11b29a33-078c-45a5-b0d4-73300202cde6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf6268bf-f749-89f2-4d12-f5eacac66643",
          "attributeId": "4d74d725-aa3f-4485-ba71-12bc00593f8e",
          "control": "Language",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8da170d-e0c7-15fc-ffda-4321e4405020",
          "attributeId": "705bedd0-90b0-4159-b2dc-2e5b167c85a1",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4a3d26a7-37b7-8355-6236-acb68ad46522",
          "attributeId": "1c0b2633-2d27-4a7a-800a-ddfd8d6530b9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "91408784-eb59-c367-eb88-2d3c63169edb",
          "attributeId": "bbba0639-2151-47d2-beb3-4af1bfc14681",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb39ebd7-e29d-0761-4e56-678a290bb752",
          "attributeId": "193f1d40-696d-489c-a981-38e1d235d5b2",
          "control": "Remarks",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14cab041-bda5-662e-630d-198f729b087b",
          "attributeId": "be25d4ad-96b4-4da2-b52f-9182b24cd0ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e3d18078-ae2f-4750-342a-773f10938b29",
          "attributeId": "4d673305-fe74-4b52-8886-5dead4f6f0a4",
          "control": "Token",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "61ba136c-2b89-0826-3af4-6bb8e204f8d4",
          "attributeId": "16445fab-034f-4f31-9571-e8d61363ae12",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "706d7b43-218b-f0a5-de19-4aa527bf13cc",
          "attributeId": "fcc4b9e5-b553-4d34-a673-3d174f6e7de9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "ce55df4c-3912-415b-d8f9-6858832481f8",
      "entityId": "727fe2b1-f979-49c5-b92d-c5e70c1a4110",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_2",
      "dataMap": [
        {
          "id": "b4f98c07-3eb7-4254-dc33-546a56ca63ac",
          "attributeId": "674343a1-e1a6-4d98-9e2d-a814ebf1742b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3048e0ad-79e1-3424-6c5b-31c8e7844626",
          "attributeId": "d7c53c38-8d62-431d-8ab7-73a25f6b58bb",
          "control": "Language",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86062545-a96f-5ff7-28d8-d342b8af08ce",
          "attributeId": "6a636ac4-263e-41a7-b6cd-23640c3f286e",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5774b7e-dfc2-5063-fafb-602fab6d71bb",
          "attributeId": "aafe438d-5468-4c99-a125-f23f8a0ea082",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1991fe4a-50db-50f1-3bcd-b2df702e17ae",
          "attributeId": "35a15d67-9f99-4d1a-9a73-7ab396344071",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9dfb9655-3bc3-f6e9-f0cd-640b5ccc3107",
          "attributeId": "8e81d88b-b5fe-4f3d-863f-8308bd3d9448",
          "control": "Remarks",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='27DBFADB-0E83-4ACD-AF28-35A760E3239B');

GO

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.340', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-17 15:19:42.157', [Data]=N'{
  "isSurvey": false,
  "name": "QNN_DPLY",
  "lastUpdate": "2019-09-17T15:19:41.9304346+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
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

GO
