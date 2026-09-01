-- Will UPDATE existing row(s) in dwMetadata for the following:
-- metadata.json
-- swzListList.json
-- swzListList-code.js
-- swzListList-settings.json
-- swzQnnList.json
-- swzQnnList-code.js
-- swzQnnList-settings.json
-- QNN_QNN.json
-- QNN_QNN-settings.json
-- QNN_DPLY.json
-- QNN_DPLY-settings.json
-- QNN_LIST.json
-- QNN_LIST-settings.json

UPDATE [dwMetadata] SET
[Id]='5a1a28d7-df6a-4391-9965-05f17d7660e3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata', [FileName]=N'metadata.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:54:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:23:20.443', 
[Data]=N'{
  "dataModel": [
    {
      "id": "1b535314-d142-4421-900a-93917ffd5515",
      "name": "dwSecurityUser",
      "dbObjectName": "dwSecurityUser",
      "schemaName": "",
      "attributes": [
        {
          "id": "709b447a-a303-40c6-8728-78577495a60e",
          "name": "DecimalSeparator",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6f3b3111-8dbd-4b41-a441-ef7e18271b68",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b25a4d34-6adb-4f98-b9e4-9ccde76bae86",
          "name": "ExternalId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "09fd1ca6-bb53-4d29-8548-dd1146e1343e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "78299986-246a-4bec-a5a4-dfa4b8dacf1d",
          "name": "IsHead",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9243de5d-cbdc-436b-8f40-16bbefaf0b81",
          "name": "IsRTL",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6b19c771-889d-42c8-9ca9-0364a42140ed",
          "name": "Localization",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "29d3c632-82d1-4f51-96d2-82dfba411f3b",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4f8276c8-eced-45de-9753-df5555f86b79",
          "name": "PageSize",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "46d7ba68-f43c-40a9-9e6f-19567ab77834",
          "name": "StartPage",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "74ef7760-4db5-4ef5-98d0-ab283efeec8d",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "91752447-aa10-4ff7-aa30-4b443fab78b0",
          "name": "Timezone",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fed90b3e-0dbc-4d8c-b2ce-8eece86f8507",
          "name": "IsLocked",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4670e1b1-c6c1-467c-b9a1-19221dcbdeca",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ee31d5b8-72f7-4c4b-a574-bc7bc66304f6",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fb54f210-e37b-4a56-9e40-fbc07d9a7a10",
          "name": "DormancyDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "72a425c0-874a-48e6-af6f-4baea687598d",
          "name": "LastLoginDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6c1bfc55-0d24-4edf-a356-f88b53df46c9",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6bf31ff3-1b4d-4766-b41a-18421ca5c530",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
      "name": "StructDivision",
      "dbObjectName": "StructDivision",
      "schemaName": "",
      "attributes": [
        {
          "id": "07e9391f-c1b3-4ae8-a228-6ea9228ac5be",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2f0469b-086d-4084-be71-2068e006a906",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "6fcb47cc-9167-4871-82f8-d67f3816b121",
      "name": "WorkflowInbox",
      "dbObjectName": "WorkflowInbox",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "014fe586-1d86-4784-96f5-0b87942438b6",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bdb077c7-518f-42ab-8662-b692336b49f7",
          "name": "IdentityId",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a164b309-fdaf-4e5b-9364-903b33bf00e1",
          "name": "ProcessId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f9b358b7-a601-4f1d-8d92-2230f08a704d",
      "name": "dwSecurityRole",
      "dbObjectName": "dwSecurityRole",
      "schemaName": "",
      "attributes": [
        {
          "id": "7b676974-66f0-4cd8-9185-1744b0fe2514",
          "name": "Code",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e938b500-90f1-46f5-8b12-5b5d6ab4d552",
          "name": "Comment",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0892938f-3b6d-4e9d-8b20-1c9a843e60b8",
          "name": "DomainGroup",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "814fdbfa-723e-43e9-bc10-2ebbc46a005a",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fe8419e4-1144-4ccc-9027-5019be1e903e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "521ee4f0-f9c1-4122-a06e-5b1eecea11f6",
      "name": "dwV_Security_UserRole",
      "dbObjectName": "dwV_Security_UserRole",
      "schemaName": "",
      "attributes": [
        {
          "id": "e06581a6-8b25-4de2-996a-c90254cfdf05",
          "name": "RoleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d0881999-a245-4676-afd3-5752904a4f23",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "1f177b32-fb14-4857-9dbe-36c0dfa33f42",
      "name": "vHeads",
      "dbObjectName": "vHeads",
      "schemaName": "",
      "attributes": [
        {
          "id": "2f79e8c5-7b9c-4bfb-96ac-b3b6e86089a4",
          "name": "HeadId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1e44a74d-1461-4ac2-9fa1-25958b31f95b",
          "name": "HeadName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c5e3f530-4415-45fe-834d-fa1382938ccb",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "58c4c673-85f4-4f50-8292-4f16ee2024b9",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "37b16af9-0144-410d-81e5-b6429a1300cc",
      "name": "vStructDivisionParents",
      "dbObjectName": "vStructDivisionParents",
      "schemaName": "",
      "attributes": [
        {
          "id": "2ee88bac-86e3-42f1-8878-0e4ae4a75b0c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fcd8b527-bf14-4ca2-bd0c-970ee4ee446b",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "bb1f410d-e6e6-438f-bd05-b5097870a89b",
      "name": "vStructDivisionParentsAndThis",
      "dbObjectName": "vStructDivisionParentsAndThis",
      "schemaName": "",
      "attributes": [
        {
          "id": "cedbda8c-782d-42be-ae09-bcec7accaf78",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1f5a52a3-3d7b-47ba-929e-deb811656347",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "622907d5-66f2-4dda-ab1b-5797e3f99b4c",
      "name": "WorkflowProcessTransitionHistory",
      "dbObjectName": "WorkflowProcessTransitionHistory",
      "schemaName": "",
      "attributes": [
        {
          "id": "6d11ad51-2462-4f9c-82d8-41fe8239db2f",
          "name": "ActorIdentityId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8f2ce4df-f95b-499a-8f5f-911c5b6b0b8f",
          "name": "ExecutorIdentityId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2e5680df-fe2a-48c5-b36e-a2f4c030175d",
          "name": "FromActivityName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6ad9c036-563c-4fd8-a013-bcecb3f86c91",
          "name": "FromStateName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b9720dd4-6908-4692-aa6d-baccb87a93ab",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b0928a2e-ace6-4d84-85d9-13df4bd76114",
          "name": "IsFinalised",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0d10f631-cc5e-4ac2-ab84-f518cd47f0f2",
          "name": "ProcessId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "72648bb2-8ce2-4981-b96c-b73ad83297c6",
          "name": "ToActivityName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9538f24d-f0f5-4c04-b673-5474ffc5aa26",
          "name": "ToStateName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "abb251ec-8d1f-40cf-ac15-2eacb955187b",
          "name": "TransitionClassifier",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bebbba3d-1b83-4d4f-8a1e-a9158d609b58",
          "name": "TransitionTime",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2a4939cc-056d-4851-8d24-4a07cd3c0460",
          "name": "TriggerName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "e92fb32a-cab6-433c-8d32-8b1a94045c6d",
      "name": "vStructDivisionUsers",
      "dbObjectName": "vStructDivisionUsers",
      "schemaName": "",
      "attributes": [
        {
          "id": "917dbd0a-80ea-4383-abf5-53f5c692620f",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d65e227-0994-4819-90a4-24cec8312f55",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ee9388be-5b54-4ec3-a24f-5bbbb25cf49f",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "86152541-8973-4f51-94e6-f671006716cd",
          "name": "Roles",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "76909c18-3bbf-4a10-bedc-e7b373570dfb",
      "name": "vUsers",
      "dbObjectName": "vUsers",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "d829fb7d-299f-47b2-975b-de88efceb3ba",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1d3c4354-d051-42c9-8e53-2ab374c1b670",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "db3f576a-ff69-4d52-9cfd-e1024524d444",
          "name": "Roles",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "de8122ea-e1c3-4c71-845b-a9077228d5f8",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f98583ad-b822-455b-a922-db8755a8cac1",
          "name": "Title",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "name": "QNN_DPLY",
      "dbObjectName": "QNN_DPLY",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "name": "CompleteAction",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "name": "CompleteURL",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2bd6090e-c303-478d-b362-89c9191d052a",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "name": "DateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "name": "DateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "429a264c-e4bc-4db0-bec0-03467deed005",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "44907ef9-0d57-4a97-9be2-d58120934253",
          "name": "QnnDuration",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "name": "Target",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "455e5598-3db3-484c-84a6-148758489688",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "name": "DaysUpdate",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "referenceEntityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
          "name": "ListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "639da28f-dca1-4941-863f-131a30734e71",
          "name": "MaxResponse",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "name": "QnnDurationUnit",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "name": "NavigateBackYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "name": "NavigateCancelURL",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "name": "NavigateCancelYN",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "name": "VisibleToRespondent",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "name": "IpCountry",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "name": "IpRange",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "name": "RestrictIp",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "name": "RestrictIpInclusive",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "name": "IsMultipleResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "name": "IsAnonymous",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "name": "State",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "389ae941-1466-42de-af26-9f3936a456ad",
          "name": "StateName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "name": "EnableWorkflow",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "44d55954-c577-4260-8272-2c97e213c22a",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "ValidationDplyId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "name": "IsDataToData",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a340221f-730d-46dd-a258-3bd194e584c7",
          "name": "RecurrenceAdvanceDays",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "name": "RecurrenceEndDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "name": "RecurrenceFrequency",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "RecurrenceOfDplyId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "name": "RecurrenceEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "name": "RecurrenceJobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "name": "RecurrenceNextDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "992b4f36-55a1-45ac-b937-026d657af01c",
          "name": "RecurrenceNotify",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "name": "RequireAccessCode",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "name": "IsExcelEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "name": "SurveyName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cd126359-fee9-4f36-9161-aefe0344e821",
          "name": "IsRecurrencePrePopulateEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
          "name": "ApiIdentifier",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "50dc8926-bba9-4c03-9a59-267aab2f1999",
          "name": "IsExposeListProperties",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
          "name": "IsDirectAccessEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d71d57fd-f787-4130-ac9e-28276b1988ed",
          "name": "IsDirectAccessForComplete",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7cdb2342-264a-4c24-91ac-1dfac739a199",
          "name": "ScheduledExportEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
          "name": "ScheduledExportEndDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
          "name": "ScheduledExportFrequency",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
          "name": "ScheduledExportNextDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "73d3d704-8028-41ec-92ef-43fdbadc124f",
          "name": "ScheduledExportStartDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
          "name": "ScheduledExportJobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0a7f52c0-02ed-4729-8617-5c26d4fb989b",
          "name": "StrataSource",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f69ae006-6ffe-4389-a7b5-777afd6a8776",
          "name": "IsIncludeUnansweredSection",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
      "name": "QNN_LIST",
      "dbObjectName": "QNN_LIST",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "17bf4b77-798d-4cba-83d4-16ea2a7696b7",
          "name": "ActiveUsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ebcf3683-c851-499c-a4b9-e2daec3948c2",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9eef3bf1-726a-4bcc-81db-eb27a0a16b04",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "76f762fb-7aa1-47fd-9ecf-b0c17bca4b43",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "852fb683-2f47-412a-9e40-11de48808b16",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98399b10-9bc8-442e-88ce-2ff314a8c7ba",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "83bee845-79e5-4929-b4fb-fe5cff7748a8",
          "name": "EmailUsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "27f10ba1-fbdf-4878-958c-8400ea40490f",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a11f6ad2-bda5-4a4f-bafd-230fa27ccb36",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "483d548e-4239-40a9-82cd-c47981e25945",
          "name": "NameUsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0d50217d-3b94-4aa3-bccb-7dbdbb222749",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "3f17e524-114a-4c9a-a71f-99154710f20e",
          "name": "PasswordUsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6899bb22-b9f9-48da-adef-29209c0b0595",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "064f6b2f-14dc-48dd-8e6d-b4e175be873f",
          "name": "UIDUsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "82b9d680-7b4e-4d25-8b72-555bbb17fe8a",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bb19edbc-181e-4f9d-9e8b-3f64a38dd911",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eba31ce9-8aea-467e-a463-4ed7ba17131b",
          "name": "TrkListIds",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "727c6358-fea5-49ed-9099-2762644973fe",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bf05e1dc-1d8d-4dd2-969c-c199798a1c93",
          "name": "isArchived",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
      "name": "QNN_LIST_PROP",
      "dbObjectName": "QNN_LIST_PROP",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "9c84a07d-bde2-414d-8628-9665e6df1c4a",
          "name": "Alias",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "304670fb-e871-443c-9c62-75b544da93a7",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "495a9b97-319e-4139-aade-8103d4bc2e41",
          "referenceEntityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
          "name": "ListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "27a0ea17-2da1-4ebb-ba54-0f783e3d2907",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "fc40cac5-1da7-46d7-90c3-f8e90cf935cd",
          "name": "OptType",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cde17e04-b25f-476e-b722-97c11da29326",
          "name": "ReqdYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cbe9a1b9-bea3-49e1-9e1e-ac8391624939",
          "name": "TxtRegExp",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f5682ad5-b493-43a5-864e-3d554ac37ddf",
          "name": "TxtRegExpErr",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "70c763b0-6a8e-4a59-959e-fd6859fdfc17",
          "name": "TxtRow",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b2761fa3-a119-48a0-84e8-5112873d10d3",
          "name": "Type",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6eaf8118-3a45-4e6d-88bd-f0fd37671cd3",
          "name": "UsrEditYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b430f4f3-2d95-4d88-a2c7-b8d12d33b144",
          "name": "RespVisibleYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "641d5acb-3586-4c86-a28b-22c339609610",
          "name": "UsrVisibleYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "b840e861-c9c6-4b7d-acbd-81ff16bfade1",
      "name": "QNN_LIST_PROP_OPT",
      "dbObjectName": "QNN_LIST_PROP_OPT",
      "schemaName": "",
      "attributes": [
        {
          "id": "74decd2a-0b82-441a-b38f-17351f3937d4",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "48bf99a7-71fc-48e4-b63c-45f68baa6b78",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d96bb2cd-faca-401d-8940-f609dded80eb",
          "name": "OptTxt",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "607ad7bd-4c1c-4646-a78c-0364846e9b0d",
          "name": "OptVal",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "055777c4-4266-4016-9f60-f0fde45a81f8",
          "referenceEntityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
          "name": "PropId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "28410272-a4f2-4721-8cad-b446c07befcb",
      "name": "QNN_LIST_REVIEW",
      "dbObjectName": "QNN_LIST_REVIEW",
      "schemaName": "",
      "attributes": [
        {
          "id": "8ff2acf8-36f7-440a-afe0-5d14a972b361",
          "name": "Consent",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d6f59c11-ecb7-4216-8a5e-506d548a9bef",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12969f57-571c-4547-ad7a-57c2dca2c190",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ceac8936-46da-4b99-9937-fd35fa0e1336",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "284dbfe7-36e7-48ed-bbf2-cb7ef3548a14",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6ad8012a-8151-41ab-9245-f579f054b484",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "56d6d5fc-9ae1-402f-95fb-07453f19e25e",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dd607f1c-0bde-48b1-bf36-4a22319016c9",
          "referenceEntityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
          "name": "ListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2bc8dc6-31eb-4857-91e3-13c023f6f500",
          "name": "Notes",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0397e9df-a246-4751-956a-1561c6487512",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fafe1381-3bb1-493a-95d6-b7db6ca2e340",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "608237cd-0ec9-4477-a556-28ae1f7364dc",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "528ea941-04eb-47cf-a5cb-e44148d6c493",
      "name": "QNN_LIST_REVIEW_FILES",
      "dbObjectName": "QNN_LIST_REVIEW_FILES",
      "schemaName": "",
      "attributes": [
        {
          "id": "c69a8b78-539e-4755-8b70-57465e9124d9",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c56fbcd3-75e5-4fd0-9ee3-21cad6695583",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6614c302-cf55-4f53-a203-4b111045db70",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "97069aec-c69a-4fce-85ff-d2c3e7323418",
          "referenceEntityId": "28410272-a4f2-4721-8cad-b446c07befcb",
          "name": "ReviewId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4ca380d8-a7d8-4726-aa29-ac5eac3ebded",
          "name": "Size",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cef7b489-b448-481f-82d2-389bf5446911",
          "name": "token",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
      "name": "QNN_LIST_SAMPLE",
      "dbObjectName": "QNN_LIST_SAMPLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
          "name": "ActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "de101582-7962-4a76-a707-a849e4e12d24",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98039f88-493b-42e6-9130-c060f8514b69",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5723662d-4af8-4861-a079-98880f6ca7b0",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "af09e234-5b40-4d0e-9200-5963747f01a8",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
          "referenceEntityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
          "name": "ListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0804faae-6203-4764-9752-93b86a82c513",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "dcfaa7a1-164c-4c4d-a135-de834309c262",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e7666721-b415-43a5-a524-4922fa12ce97",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SamplePeerId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "67bb3e37-4530-4812-945e-f462dd1abd05",
      "name": "QNN_LIST_SAMPLE_UPD_NOTIF",
      "dbObjectName": "QNN_LIST_SAMPLE_UPD_NOTIF",
      "schemaName": "",
      "attributes": [
        {
          "id": "78cd0644-b2bd-4100-943a-c71963b03e47",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9292e6ae-ec97-4a2c-ba45-23f0c798ec2d",
          "name": "ListUsrId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e34da812-26f5-4791-b5a7-ca1d59644658",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b4f076ff-ab87-4345-af35-3e24e00fbb46",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "589862c4-0937-4c74-a1cc-e7605c16b43f",
      "name": "QNN_QNN",
      "dbObjectName": "QNN_QNN",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3f57cdc6-e819-47fd-9d12-387211c01028",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
          "name": "FieldCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8677a7da-33d6-48b4-8b2c-19988301076e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8621d809-3ede-44eb-8695-1a26adb17420",
          "name": "Title",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2018e3a-6e65-4b0d-aa62-c640c20288b0",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "37e07f99-e5d6-45b3-8674-cbfb55769be9",
          "name": "IsArchived",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "1c8be8b0-f9a7-4f09-a7b1-c4bfd124ff0b",
      "name": "QNN_QNN_FIELD",
      "dbObjectName": "QNN_QNN_FIELD",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "78b7cc31-70ab-47f7-87e4-cfe750a97135",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c0c09b0b-5d90-41d1-a573-c6bad7b4a99a",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fc07763a-3371-428e-9042-78a552faa124",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "0dc3b126-6fcd-43b5-a7f2-c226a3bf978b",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8f48fffb-86c5-4de4-8503-c2589b9e10bd",
          "name": "ReadOnly",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f9f67be8-380d-404a-81ef-fc1e726bf9cf",
          "name": "Required",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5a23d541-33ab-44a4-b94e-bc46ce876950",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7fe6c0ef-4b08-4160-86b1-2cf594634ac4",
          "name": "ValidationErr",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "49205da0-3bce-460a-8c6d-b29056016f61",
          "name": "ValidationExp",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "fc5212f9-9b8d-4b10-8637-4b5e6ae99e66",
      "name": "QNN_RESP",
      "dbObjectName": "QNN_RESP",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "91fdd9bf-fba9-487c-866d-5762158a46d4",
          "name": "DateComplete",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "65d339bf-f867-4989-b11d-df93fcc7fcba",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0dc836b8-6653-43ba-adb5-0f0741bf47ce",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "55b98c46-fbbe-454a-a429-99033e4ff8a3",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8c9c10c6-92de-4c1a-a355-928f5acead01",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "51f9523e-9f56-4e05-b68b-e5e290eed023",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ed6f502f-0f26-494c-9576-a1bc1ca20d89",
          "name": "Score",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d7e024fd-0b91-41f7-9a44-33ebe7d5d016",
          "name": "TimeTook",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a65c6381-c415-432f-bf4b-07ce642113bc",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25b3b260-dd8c-45d2-8e87-aff51b44bcc6",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "67037ce4-b760-4746-862b-71002faa81cc",
          "name": "IsPrePopulated",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a0de67b0-bf1a-4147-93c0-c9987f9a089b",
          "name": "DateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c19bd11e-10b8-4d1b-ad4c-1b44edb999f8",
          "name": "LastSavedPage",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "08b86588-3cf2-4856-985a-cd81dd76a0f5",
          "name": "AnonymousId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4b110557-ae87-4122-a4a4-1802bf81231f",
          "name": "ExcelToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3c6f904d-e7bf-4bce-b445-085a8894dbab",
          "name": "IsExcelResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9b0a1bd8-4f09-4acc-b656-02ff5e7dfb0f",
          "name": "ExcelUploadDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5dfb9e1d-e470-4ab7-bd20-7576c8b6f0dd",
          "name": "IsExcelResponseDE",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ee2195e9-fdb7-4b88-903b-893b5c053579",
          "name": "InitialResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98ec6af3-e360-45aa-8a5e-29ea988b64bc",
          "name": "InitialResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f12c1739-b6c1-4cbc-bc6d-f97c9c340d88",
          "name": "InitialResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a8394f36-e7bc-4388-a364-fa710b11aff7",
          "name": "CompletedResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dfffb676-fe49-4372-a1e8-30b1bfc475a4",
          "name": "CompletedResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "842e33de-1007-40ce-95b3-f46c7b0ac5f1",
          "name": "CompletedResponseUserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a80d77d7-6a01-4d3d-a1d7-e7fa15fa1de2",
          "name": "CompletedResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4b1ddb95-fddb-4f96-9012-d2480e903aa9",
          "name": "InitialResponseUserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "92b5b46e-013d-424c-9197-2bcccb8f237d",
          "name": "IpAddress",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c05b82cf-1ccc-451d-a630-e1e2490c8826",
          "name": "LastResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7360ccfb-7835-4bed-be7e-66ffbcc10b13",
          "name": "LastResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1e4c3ee5-1afb-4ecb-8381-4816c6eb5b9e",
          "name": "LastResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c39f5d20-9a1c-40fb-8daf-b7a3f11733c9",
          "name": "Strata",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "941ed21d-a697-4ac0-9d51-49fa79a0c22c",
      "name": "QNN_RESP_ANS",
      "dbObjectName": "QNN_RESP_ANS",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "910c8ab5-2d27-41c7-b377-4b0dbd11bb2a",
          "name": "AnsVal",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "da8818be-675b-4e70-bed7-834e562a0c4e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c1ee7e8-f7f7-466f-8f0d-055a8fae075e",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "8904e12d-ad11-4911-b21d-353bb193cf9f",
          "referenceEntityId": "1c8be8b0-f9a7-4f09-a7b1-c4bfd124ff0b",
          "name": "QnnFieldId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ccb705ac-830b-432f-858f-c4c192a19052",
          "referenceEntityId": "fc5212f9-9b8d-4b10-8637-4b5e6ae99e66",
          "name": "RespId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "779f80c6-3852-4313-9d1a-e6f123945117",
          "name": "IsPrePopulated",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "5a613570-2b28-45f0-8be6-7be3393671b8",
      "name": "QNN_STATUS",
      "dbObjectName": "QNN_STATUS",
      "schemaName": "",
      "attributes": [
        {
          "id": "d928001b-5ce9-424f-9dea-de5961744026",
          "name": "Active",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18ed2f33-6512-4348-8e52-a3726d60925d",
          "name": "Code",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0830ad53-ba94-4f80-8da8-e41caa37098d",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25fc5a67-9e5e-4d93-a938-16ee3cfe655f",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e851ee7c-9e2c-45c2-83df-577ea8cbbf1d",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e7d0fb60-615a-4fec-9eae-4a7291d5f4d2",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "382b9ef4-ff2c-4b23-8fd0-c9a5dc613e34",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "994afeeb-b37d-4ab4-a9cb-a5171926978e",
          "name": "HasRespYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "80d16b41-84ca-44e0-ac1c-b6c2b9df37ed",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a06ca618-2f56-4c3e-9d7c-72acaeab23d5",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dbe8ffb8-57a3-493c-b105-8ef5411f8ba5",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "name": "Title",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8f84505e-aa13-4ad1-ac2b-921f9bd49966",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4678ae1f-8859-43a6-8d75-8ae3d50470de",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fcc25aa4-71c8-4660-935f-685583040224",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "3987392b-8965-4b2b-9142-9aeb72613ded",
      "name": "QNN_TRK_LIST",
      "dbObjectName": "QNN_TRK_LIST",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c358898-d35c-4be3-89bd-368143effb39",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f55004c7-067f-4b47-9815-1d91d177b8a2",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "b3e75714-844d-4e64-b638-e9c60ffebf78",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "863fb411-5f61-4962-ac06-cdf953abbbf0",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "245660f8-437f-4716-b14b-03a040a0f220",
      "name": "QNN_TRK_LIST_SAMPLE",
      "dbObjectName": "QNN_TRK_LIST_SAMPLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "93d5e831-d471-4fdf-b562-60d70ed73b64",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a6337ff6-c08d-4998-b235-f0c4609d44e4",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7d603136-3dbb-488f-81ef-482d2592184e",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c65984e-89ce-4030-8cbb-60d8eb2455d7",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "665424d0-9759-437b-b620-d5d5243287c8",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9ed7f898-6b13-4cd0-be8d-4ce5183f0da8",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8f29d669-5d1d-4e3d-90b4-97153c2bbdfb",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ec0e063b-9864-49a5-9469-72c6e2f2546e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b84d9d22-dd5c-4077-a8f7-a45a55496c0a",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "67bb8933-188d-46ff-a9ce-7152447c3e6a",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "97f7aa0f-e033-4b9f-80e9-1dd6730c65f9",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "Status",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aec40eba-82df-4090-8bda-87bc9ae2bdac",
          "referenceEntityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
          "name": "TrkListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5671f841-1602-4210-90f3-77b8c2a51aaf",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4b041d0e-1bed-4dd0-87ea-1c8812ec54de",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f042fa99-cffb-480c-af49-86b679f57c1e",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "6ec43df0-6b46-4203-aa2d-2d920141faea",
      "name": "QNN_AUDIT_TRAIL",
      "dbObjectName": "QNN_AUDIT_TRAIL",
      "schemaName": "",
      "attributes": [
        {
          "id": "08508012-bb93-4cf3-a57a-bbec2377b9af",
          "name": "AuditAction",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "40e2bfd4-f710-448e-b67e-ad0e6d01fe0b",
          "name": "ChangeDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf8e3f9c-588a-4413-9f29-26746f096f06",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "20ddb052-4412-4a3d-ab9b-cacff7bdc2c9",
          "name": "ModuleCode",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "60c787b6-a84d-4cb0-8dab-2cfb8ca66d64",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f157c595-64f8-4eb4-8004-f86ff88bdbdf",
          "name": "Ref_Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dde3e315-1e55-4016-8254-bd2f0f35c60c",
          "name": "Ref_Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "176d5f7e-a425-47ef-a733-b259010aa857",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8158905a-a5d5-4ea9-b18d-f4048a87cc4a",
          "name": "UserName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
      "name": "QNN_DPLY_MSG",
      "dbObjectName": "QNN_DPLY_MSG",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "98ea38c9-6a0b-43c9-81e7-33c0fdf81664",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "53013ae2-ac53-49d9-8256-29517c8ce92d",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "05249853-6194-4045-b78a-b300b1261dbd",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3827faa7-8f56-4657-b62f-3f0e2b741601",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "59c5738d-c75c-48f3-a13d-89551dc8f265",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "617e73c0-cbc5-427c-8b5c-9b3eb9724eef",
          "name": "DplyStep",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "980ba3ed-445e-4048-84e4-aa8a5a894d03",
          "name": "EmailFrom",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "723a024e-c6b7-4a6d-8840-700288df74fe",
          "name": "EmailSubj",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5aa6f5c9-ff71-45dc-aac4-069c32bd2e46",
          "name": "GenerateDateTime",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "91b7860e-858d-4fb2-8c34-e08911284e78",
          "name": "GenerateQnnYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8a72553-1d8e-4c67-8429-9055cb5c6679",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c43a9452-c591-440c-a1d4-e35201bfdd51",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2081e372-56bf-4d2f-bf8f-0e41e9989215",
          "name": "NotifyEmail",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e5b3a81b-2dd8-4237-9792-99dde3d846fb",
          "name": "NotifyGenerate",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "59aa8497-8343-4a3e-9e58-08d0474ea25d",
          "name": "NotifyMerge",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0d5d3634-db52-47d2-b648-06aff68ef376",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "bc72319c-27cd-4331-8aa4-d4d7440d4558",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "248da247-714b-4c8e-aabe-ae51b1a298d7",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3e45f699-36e4-4ec2-b6d4-d79f08aa90d1",
          "name": "MsgContent",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bb235505-d84c-41c6-ae87-06603fabb6b0",
          "name": "MergeDone",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "29bfaf0b-7047-4e34-b148-fa040deaf052",
          "name": "MergeOutputToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0a6ac3a9-3884-4171-a423-0b7f032ebbef",
          "name": "GenerateProfileDone",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cd7763ec-414c-4abd-a1d2-0046377e916e",
          "name": "GenerateProfileOutputToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be830ce8-ca8b-41a5-993c-bcedbbe889a9",
          "name": "JobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "687ad667-bbbf-4584-9a38-0b48d0b4b92a",
          "name": "JobIsCanceled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b8365e45-58cf-4618-91a0-4bc1f9c97870",
          "name": "ScheduledDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98282783-cd5c-4945-af3b-262377a1caeb",
          "name": "MsgContentJson",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "b605b7f1-2181-445a-9c74-cdbc4390232f",
      "name": "QNN_DPLY_MSG_SAMPLE",
      "dbObjectName": "QNN_DPLY_MSG_SAMPLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "4b1c74a9-f913-4d8f-a4f5-08aeefed6af2",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "534c50cb-bcf5-44e4-af01-1fd8233fad4f",
          "referenceEntityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
          "name": "DplyMsgId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c18c44ca-a0f8-4918-b47f-a6416f5a7ad1",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f914a09e-771c-433e-8116-b51dc906141c",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8e458ffe-97d8-4bc4-b79a-1df4d1d1c360",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "56383ede-9cdf-4bab-98e1-69cfbc44ca8f",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "21c27010-bd8c-4537-89fb-cc6029bfb4ad",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a511d6c1-57f0-4faa-b4f4-f45af52d5a2a",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "14cdb24f-77da-4673-ae5c-afc02124836b",
      "name": "QNN_DPLY_SAMPLE_DUEDATE",
      "dbObjectName": "QNN_DPLY_SAMPLE_DUEDATE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "2ccb018c-5886-4ce1-b1d3-687a21afa7ec",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "688df515-fcda-47be-825e-8c6f2c81aad5",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4ee4c588-757a-49e7-ace0-418d232d9192",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3243f60d-c650-4f35-9390-80f7c4d684b8",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18cdb87a-b7da-492e-87a5-24bc3194cd4a",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "0922eac6-ef78-4d36-a771-700118d3712e",
      "name": "QNN_DPLY_SAMPLE_INFO",
      "dbObjectName": "QNN_DPLY_SAMPLE_INFO",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "a32c9077-a79a-448c-8da5-b8998c8b0596",
          "name": "DispatchInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ca44607b-fd21-4b04-a6b1-ddfaa761d4ec",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b4d5897d-9478-472f-add8-26df591caac9",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fbb5e113-1276-42a2-9fdc-13058e7ec6f0",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5e844fd1-13cf-4994-be2f-eabdb02e3910",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "7fcc7528-cf2f-4683-bc60-096540b8c014",
          "name": "ProcessEditInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b583597-c80d-405a-9395-b14623d28fa5",
          "name": "ProcessValidInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b5b097dc-7c90-4c0f-84c4-7984bce3bef0",
          "name": "ReturnInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9d9c0270-90c0-4ec8-ab70-b810e59a0924",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7a2224ec-3fd9-4d02-9d6c-a9a8fc805272",
          "name": "RemarksModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e19a7810-06a2-473a-8a55-f8eae4fbfbfe",
          "name": "RemarksModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a2690b76-a292-40c2-a676-b5d370a6910c",
          "name": "StatusModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "791fd824-7b6a-4a23-b7d6-ae1c2980cb23",
          "name": "StatusModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "495086da-79e0-4d32-8bf7-6dfedd53e155",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aa01ba4f-6357-46c9-8fc2-97cf08c0324f",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d022c864-0edc-4572-bdaf-cbad3783db92",
          "name": "DelegationCode",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6dac4127-4880-4c86-bdb9-60d87b12fbd1",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "Status",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4caa97a7-74af-4c76-b5e8-3584dbf1b9bb",
          "name": "DelegationAccessFailAttempt",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d91e2b17-8a78-4eac-a842-07c7114b23ac",
          "name": "DirectAccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d4407a57-89cc-4ca5-94fd-f27fd23b0849",
          "name": "PrintAccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "619e3147-af6e-4d41-bb9a-2b7aa8a01639",
      "name": "QNN_DPLY_SAMPLE_OWNER",
      "dbObjectName": "QNN_DPLY_SAMPLE_OWNER",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "9b7a23e6-1f1f-417c-a966-a16ce47dae96",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bcd040b6-77c1-4520-82d8-303eaddae15e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a645e634-e912-4253-8ffe-11d0df297388",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d9a9c45a-e4c7-467d-98c3-3345c9e797d8",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "0866ae19-d15e-479f-8e21-a587e56e9e2e",
          "referenceEntityId": "1b535314-d142-4421-900a-93917ffd5515",
          "name": "UserId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f3eaf01b-d3d3-4056-869d-ea45c1b82ea8",
      "name": "QNN_QNN_REVIEW",
      "dbObjectName": "QNN_QNN_REVIEW",
      "schemaName": "",
      "attributes": [
        {
          "id": "f344f48e-d988-4ea3-9049-f9aeb31617f5",
          "name": "Consent",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6d291e41-55d2-4a5a-99c7-2919c7bc5404",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bdf78b1c-9f0d-4e13-8b36-6f1c652ac68b",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "986ed319-5daf-40fc-9c55-c55a840f0f5b",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9a6bb722-ccfb-4cab-a2f1-bdc010f1c462",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dee50441-19d6-4d36-acef-93fa0472dce5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "04f3b1a0-c765-4d75-8d43-23565a63bf5f",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "29402f19-fa49-4f50-946b-295e613c172f",
          "name": "Notes",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5f2fc699-7b01-4236-a09e-c00a802c0941",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "99b69b8a-d59d-4cea-8f96-8193689f7fb2",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8ec80ee6-3cbd-441a-bb0e-f8c0bd813511",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a390f01d-8b04-4860-927b-e1d04c57603a",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "c492973c-656d-4f9c-9906-e2cc9045c648",
      "name": "QNN_QNN_REVIEW_FILES",
      "dbObjectName": "QNN_QNN_REVIEW_FILES",
      "schemaName": "",
      "attributes": [
        {
          "id": "3372f03d-0fbd-40c5-b9ab-a61307694b54",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7349838a-bd17-4c61-bc98-b0e43f3af26e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4bed821f-0947-4eb5-933c-5ae19c18d7d6",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dfc10075-22fe-4e24-b061-d3fa7e07e1c6",
          "referenceEntityId": "f3eaf01b-d3d3-4056-869d-ea45c1b82ea8",
          "name": "ReviewId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c8067f48-6c95-45c5-a78d-b28f9e47f4a4",
          "name": "Size",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "70f2b482-5cb2-488e-af25-8c327f7eae66",
          "name": "token",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "283c3132-e3b3-4b5b-8afd-fd5e380f6124",
      "name": "dwUploadedFiles",
      "dbObjectName": "dwUploadedFiles",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "715e537f-4f6f-4ba3-7709-c0dd25cf0715",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f54eaab2-75d3-4cc4-85b5-4781f8c009dc",
          "name": "AttachmentLength",
          "type": "Int64",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "547f0f3b-fe5c-4f76-95fa-0923e6cebfe0",
          "name": "ContentType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8a71b1d0-f295-4c4e-a0e0-cbcabf0a2ec8",
          "name": "CreatedBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e8eefcc0-7899-43f8-ab3f-bbd75cb74b0b",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b84c4975-ae50-4202-a7c6-90b833c01b7b",
          "name": "Data",
          "type": "Byte%5B%5D",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8c69de15-f086-45aa-9692-7270b3dbcd9d",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ac6c7838-354f-499b-a267-8b5700c4c023",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d9d5cc14-a18c-4810-8ac6-4a4bbc75005e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "93738fc4-4c7f-4987-ba1f-a98d0909a4cc",
          "name": "Properties",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2abf3678-8b22-4e68-a579-206c4612ec78",
          "name": "UpdatedBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "89c91ca2-820e-4d29-88c7-47745b806922",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b72274d9-1ba0-4836-8c17-50c38bd0eaaf",
          "name": "Used",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "518b28ec-de0d-4a94-86aa-05998263e4bb",
          "name": "IsLocalStorage",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "cd522364-03bb-44c1-af31-575eab8ac087",
      "name": "QNN_RESP_ADMIN",
      "dbObjectName": "QNN_RESP_ADMIN",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8512084-4732-4938-869d-0165bc220192",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
          "name": "EditorState",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
          "name": "EndDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "46699848-4700-4d77-a193-ef4ecbd921ad",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "59530aed-1d91-40d2-8808-d1a286390b4f",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
          "name": "StartDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "617be8a6-bcdc-46db-86c9-2841eac54b68",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5c84da90-3ecb-4c14-846f-8d1568091a77",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f73ddd12-d5ad-40e4-bf49-e7918dd065e9",
      "name": "QNN_STATUS_FLOW",
      "dbObjectName": "QNN_STATUS_FLOW",
      "schemaName": "",
      "attributes": [
        {
          "id": "9b9dcaca-706d-4e94-89f7-6861b865e5fb",
          "name": "CreateBy",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b9c90e09-a4a1-492c-84ba-610e61252651",
          "name": "CreateOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e4cb9bc5-5323-4dd6-90e0-25bbdb929bc2",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "FromStatus",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2b96e6c5-5c82-4d72-af9b-968df494efaa",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5fe7c967-cb48-4047-b2d1-92be17700fb9",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "85a1e724-0539-4ff9-a878-2a78bf76e3b4",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "ToStatus",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "6a831ca7-cff1-45bd-9125-ff8aa539e5dc",
      "name": "vSP_DataEditorDeployment",
      "dbObjectName": "vSP_DataEditorDeployment",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "12882549-c63b-4bb9-8411-34003b2228fc",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b3f92a74-318b-46f8-964c-e99c6b3ce1a6",
          "name": "DateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "662161e7-61ac-4caa-b5bf-a94e36f99b05",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "117475f3-1979-4047-922b-751e725aa220",
          "name": "RespCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a5175ebf-3842-483d-99cc-23479501c082",
          "name": "Responses",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e4488721-c14a-4001-9f86-95547b4fef49",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "14b1108f-a4cf-4154-b5af-9e943bc7825a",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9a6b8e15-a962-4512-84fc-906fa79f0ba6",
          "name": "StatusText",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be433204-7b5e-4d48-acd2-bab9ceba06b6",
          "name": "Title",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "560b916d-7b92-43cc-87a2-25eebe01b04e",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f75b7c08-2bbf-453e-acff-46dfb6d90ca7",
          "name": "UpdatedByUsername",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4def3ea4-668b-4dfd-9c7f-871eb1e461ff",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ce8b4c4e-43fc-42af-acdf-d1dc9530092b",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3698003c-ad9d-4014-a4d5-dfe14418e377",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7b42a4f1-8da8-4e10-aee0-8db424b6d16c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bb884c00-d4b4-4d8b-83c5-a2c424a220db",
          "name": "QnnType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "77adabcb-6e75-4100-b589-873557998506",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b1c33053-0af4-4d89-8716-7ec3c7bfd686",
          "name": "IsAnonymous",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b2014985-4e95-45cf-854f-6fdf6c046e84",
          "name": "IsMultipleResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "65950772-fdfe-4218-8377-a2c760dbd47d",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "cabd32c7-1f49-446e-8126-b0d860c77116",
      "name": "vSP_dataEditors",
      "dbObjectName": "vSP_dataEditors",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "6b28c937-4080-4300-9bff-96cde67086b6",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fabc400d-d02a-4ea3-b4dc-1feea41e1d85",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7029d83d-6bc8-40db-9e5c-9271a8cb614b",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "ce5f736e-1dbb-4409-ac6f-e02b5ea98283",
      "name": "vSP_DeploymentOwner",
      "dbObjectName": "vSP_DeploymentOwner",
      "schemaName": "",
      "attributes": [
        {
          "id": "a030014e-8231-4ce7-a1d6-30282059ec16",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "58b5e585-413c-4a3a-a360-78f19002fc6e",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "d3643098-a766-406e-88f4-181d291d18ad",
      "name": "vSP_DeploymentRespCount",
      "dbObjectName": "vSP_DeploymentRespCount",
      "schemaName": "",
      "attributes": [
        {
          "id": "5ddc52ac-e513-45a1-a654-ac5788051746",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c9e0bff8-847c-45f4-8515-f9b2d0a87555",
          "name": "RespCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "9d0f4c5d-03da-4357-8a80-38e89ca3f52c",
      "name": "vSP_DeploymentSampleCount",
      "dbObjectName": "vSP_DeploymentSampleCount",
      "schemaName": "",
      "attributes": [
        {
          "id": "3f7b9964-17b3-49e6-8c94-3fdacbbe6ffd",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8d6fc34-25c2-4d7d-8384-067c6afedfb0",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "550e2a57-7c25-4e0c-9402-e70c16b71425",
      "name": "vSP_DplySample",
      "dbObjectName": "vSP_DplySample",
      "schemaName": "",
      "attributes": [
        {
          "id": "82cb6052-6688-48af-bcd1-4164e4072545",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c19c7fc4-5f25-4f2d-8497-ce792dd853d3",
          "name": "Sampler",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a3d0a09c-deda-4f63-9a50-bcb2e6535781",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "c0c622e2-fae9-4616-829f-78e3c65cb1df",
      "name": "vSP_DplySampleDueDate",
      "dbObjectName": "vSP_DplySampleDueDate",
      "schemaName": "",
      "attributes": [
        {
          "id": "030fb646-5b7c-41a9-97c1-1c8eea3427db",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25eba601-1acc-48d9-b178-4e82230cb6fb",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d81030e1-b5e7-4fa8-97e9-cf412742aedc",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "59aff502-0923-4c44-a333-fe09727419f2",
      "name": "vSP_DplyMsgWithSampleCount",
      "dbObjectName": "vSP_DplyMsgWithSampleCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "75fe9558-ad13-4155-adfd-278726de0afe",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "46d6816a-9736-4f40-808a-6bb0529b12c5",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e7df3305-b885-4b9f-bfd9-bc5800d2b3af",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d6e51f9b-36b7-4c4a-8713-94bafddffc4b",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2c37782f-dcf0-4386-9c48-b1885c9ec96f",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "188f0942-ea3d-4400-8ad2-8efe1fc68d8a",
          "name": "DplyStep",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1b50815e-6bdb-4c8c-bbe1-b40e336409c5",
          "name": "EmailFrom",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f17fa3f1-c23d-4a90-8685-be98234f9293",
          "name": "EmailSubj",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "93f82dd7-2705-42b3-bf1a-f9d62cc57663",
          "name": "GenerateDateTime",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4c89a233-907b-4a71-accc-995d9b9c8a76",
          "name": "GenerateQnnYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "491795d5-46e8-4247-975c-4c6419243b8f",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1900ec19-9dac-4596-aa2a-ce82e9cfc493",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a21d3068-cb0f-41ef-881c-25b6aca9b598",
          "name": "MergeDone",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "534741ae-056b-4e92-97cf-5c97cf0e51c1",
          "name": "MergeOutputToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18b42ed0-2227-4819-9b4f-38b1eca723be",
          "name": "MsgContent",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2cbedcd3-922c-4071-9f7a-c6baab5a6007",
          "name": "NotifyEmail",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "df0b7d03-a12e-4c21-8148-cb0d6bfc163c",
          "name": "NotifyGenerate",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "475d3632-b629-4d78-8935-e19451cc5cd0",
          "name": "NotifyMerge",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b49c8574-e461-4400-8df5-68b08cf6cb3f",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "568d1b2d-ba87-4cb1-b7f1-ad30dd23982e",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "019de426-2ba0-4e03-88af-6d32a6b16a40",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8014719b-0387-4367-9581-b3fbe54acb76",
          "name": "UserName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12da9e1a-c2f6-4e0e-bbba-dd98e38d72c2",
          "name": "GenerateProfileDone",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ad82bb50-5d29-4c85-b93d-4ce2c219ddf5",
          "name": "GenerateProfileOutputToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ef45d376-b59e-464c-b997-c482a6edb593",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bdd83ae4-2227-4f66-a1ed-4468407223ce",
          "name": "JobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "11c9a997-e065-49b0-8b0b-3db8a55e36a5",
          "name": "JobIsCanceled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0a863bd9-dd72-4a35-94aa-0aa81d0a3f32",
          "name": "ScheduledDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "37ccd6ff-60ee-4757-9386-75ed69c2ebcc",
      "name": "QNN_LIST_SAMPLE_PROP",
      "dbObjectName": "QNN_LIST_SAMPLE_PROP",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "234f4eec-4acb-45cd-afce-39c0df0c6c0e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8744209d-7ad9-4c27-b902-c41345b61e0a",
          "referenceEntityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
          "name": "ListId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "706d7e73-338b-4e6c-a974-7173bf8a91b2",
          "referenceEntityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
          "name": "ListPropId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cd02c3e4-80ab-4795-a6ae-36905afff414",
          "referenceEntityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
          "name": "ListSampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "df3b4dd9-710f-4c29-878c-3dfd6b5d67a4",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "4eb55e6a-a40b-41be-8fc4-70a59e8caa0b",
          "name": "PropValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
      "name": "QNN_SAMPLE",
      "dbObjectName": "QNN_SAMPLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "e9ee47ca-3a33-42de-54e8-f98a5323d26d",
          "name": "LastLoginDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "011a70db-a5ae-4019-a9ac-4c167d60bbb0",
          "name": "ActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "63a7a61b-6248-4197-8d08-3fc85ff686ba",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be7d893d-9d5d-4c1e-a3e7-b04e13a5c303",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3cb554ec-8497-4513-93c5-58769fe5231c",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8778e5f8-94eb-438f-bfd5-36ede705a05b",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "96143a54-6881-4bfe-947e-39e6ab7fd935",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b22a30c4-696c-4ced-aa4a-22620b16a884",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1b3705b9-e1de-401c-996e-c7c9ac10366a",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "ac3c5076-a671-43d0-bab9-d50d339598a9",
          "name": "NumRetry",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a02ab42a-6f9c-4a9d-8112-3cc7eae2a5fc",
          "name": "Pwd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "700091f4-476a-440a-bc17-ab5351fa461b",
          "name": "PwdResetYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a7440614-efc1-454a-8ff7-cc29764ad271",
          "name": "SelfUpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "96609d0c-c7fc-4fcb-816b-cde87a1e5de3",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "791dc4a1-5ee5-4550-88d4-56ff82d0d867",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c50309ed-78cf-4601-b861-a0e8c43f8ba3",
          "name": "PwdResetToken",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "2d1fab47-26c2-4aba-97bc-7b8f46597748",
      "name": "sysdiagrams",
      "dbObjectName": "sysdiagrams",
      "schemaName": "",
      "attributes": [
        {
          "id": "0ff7adc0-6099-4df1-9b14-c26178b05f50",
          "name": "definition",
          "type": "Byte%5B%5D",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f7fac792-59e0-4341-bb34-16244671dca7",
          "name": "diagram_id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "897e9cd0-2a2d-4186-b1f8-2e6e27faaea4",
          "name": "name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18a6e757-ca8f-4a31-965d-5b66717c0aaf",
          "name": "principal_id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ad597cd2-50c8-48e2-a5c0-03bc81fb6b00",
          "name": "version",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "diagram_id"
    },
    {
      "id": "c0492fdc-cfa9-4d06-ba3c-c7c498318e6e",
      "name": "vSP_ListSampleCount",
      "dbObjectName": "vSP_ListSampleCount",
      "schemaName": "",
      "attributes": [
        {
          "id": "05ca81bb-2645-4464-8d5f-f61752a27c91",
          "name": "ListId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ce47c3fa-37c8-4022-b0d1-a3739957ba34",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "7595bf88-b396-45de-bbd0-88bbe59241e3",
      "name": "AggregatedCounter",
      "dbObjectName": "AggregatedCounter",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "09c6020e-ede4-46c7-b484-cf0eee791d63",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cdb5d888-a9c7-4621-b589-a474eb9df61d",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "80ca95a2-2971-45e2-a8ec-aadd39d5374d",
          "name": "Key",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "34a44dbd-ec0c-4eaa-a4cf-ba4cff5c7265",
          "name": "Value",
          "type": "Int64",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "0fe4a0e4-58ae-40da-946f-fd91f3856d49",
      "name": "Counter",
      "dbObjectName": "Counter",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "ae93addf-4f53-4235-8c82-36b7fd4eba3b",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7aefbef0-96e3-43dc-a6f6-c3bd90361578",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "48cefaed-99fd-4adb-8634-dc105c133320",
          "name": "Key",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2f71aa5e-62fe-4fb1-a34b-c099a7a4892c",
          "name": "Value",
          "type": "Int16",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "48fd592d-3144-4c97-83bc-87a9dd6155e8",
      "name": "Hash",
      "dbObjectName": "Hash",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "e7a445f8-f930-41b0-961c-c15bf462c364",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1f5c10d0-6187-45f7-822b-d1c01cbef735",
          "name": "Field",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d257e3b7-711c-4be5-ace1-df2364f5d1ed",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4ef29f7b-1027-4e0e-aeaf-47a766f14218",
          "name": "Key",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "288fdde9-1b39-4e80-9a10-b4d766a6e709",
          "name": "Value",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "cec606cd-53f6-4b9c-93f5-93206888ebe1",
      "name": "Job",
      "dbObjectName": "Job",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "12d2b6d1-c152-4c23-a0f9-3117a619fa0b",
          "name": "Arguments",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "89457d28-71a6-4607-a6e6-88a56bf68979",
          "name": "CreatedAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f32c907f-27f1-4978-b30d-e969b2a2f116",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a5dc2e63-354b-4312-bf48-ffef026e7084",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b96863b9-c22e-4758-a13b-b031c536f335",
          "name": "InvocationData",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5e269820-806e-4b15-b0e1-792939f53020",
          "name": "StateId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f53e5ef4-9f77-4c10-9a53-c43e18cb6e7c",
          "name": "StateName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "90cf7c11-3a6a-47db-8976-684717bbf56f",
      "name": "JobParameter",
      "dbObjectName": "JobParameter",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "167bf1bd-aba8-4e91-af67-f0867880d546",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12498a8d-3f85-42b6-b248-16f946d3a1bc",
          "referenceEntityId": "cec606cd-53f6-4b9c-93f5-93206888ebe1",
          "name": "JobId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3715aea6-186a-4704-816c-aba1a73717bd",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "07a225e3-3f82-4271-ae8d-2b161c6b58c1",
          "name": "Value",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f1d8999a-aaf1-4f60-9965-d9f99d2224f6",
      "name": "JobQueue",
      "dbObjectName": "JobQueue",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "04130086-7b80-4e13-90ad-8314bfd798b6",
          "name": "FetchedAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6078cf41-91f4-4c58-a6a1-c8c18f227236",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c8c525f-a2b0-4bc9-9b09-2a2106a9046c",
          "name": "JobId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ca71d590-e09f-4d45-8848-0537456ff0dc",
          "name": "Queue",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "73d850e7-3339-4820-93a8-6a59161564f5",
      "name": "List",
      "dbObjectName": "List",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "39a7e732-ee5b-45e0-bdf5-d718b7e82650",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "64eb8f5b-34fb-490b-b011-5fa3a9a8bbb7",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "05f89c94-be2d-40a0-9355-f2cb34aa1abc",
          "name": "Key",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ac0b22d4-8267-4d8b-a854-cee71b618589",
          "name": "Value",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "78ceca6d-0414-4635-ae04-f74f96482023",
      "name": "Schema",
      "dbObjectName": "Schema",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "0c7b8039-6877-409c-9104-3cbf971ddb54",
          "name": "Version",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Version"
    },
    {
      "id": "0e05ffcf-7cf6-4b5e-ad2d-28a136df23ca",
      "name": "Server",
      "dbObjectName": "Server",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "e2c247e0-bcc6-4693-84ff-5ad6715645a0",
          "name": "Data",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d090f580-6aa4-48e5-bff8-ce0875e45f89",
          "name": "Id",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1407a755-c833-440c-8a10-b9c44ec91cd2",
          "name": "LastHeartbeat",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "ecfe23ca-7896-48e3-97f6-8f98b4319d4c",
      "name": "Set",
      "dbObjectName": "Set",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "88ec22a8-3ef9-4831-9b28-d1429c225c67",
          "name": "ExpireAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d317abd-bb92-461a-a2f8-643199919086",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf4390bb-f088-4f0c-a4f7-a6f2a3266e36",
          "name": "Key",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6fe27690-f78b-43ac-b443-04a75e91c900",
          "name": "Score",
          "type": "Double",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "174ee920-b76a-464f-8f44-309c921ce1a8",
          "name": "Value",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "8fac5eb7-3514-49e8-ad47-f2b61347478d",
      "name": "State",
      "dbObjectName": "State",
      "schemaName": "HangFire",
      "attributes": [
        {
          "id": "80add1c2-f1a7-4518-8acb-33b670f5379e",
          "name": "CreatedAt",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "77146324-3c58-492a-b413-68883fc3753b",
          "name": "Data",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ae57a62f-2a90-4a93-aec4-1bca0ca902d5",
          "name": "Id",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5c8e49cb-5846-430c-8d39-c41d05ce6308",
          "referenceEntityId": "cec606cd-53f6-4b9c-93f5-93206888ebe1",
          "name": "JobId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "136d4fa7-d70f-45fe-bd13-4464b3cabada",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f07850d3-047f-4b19-8f3a-fc2751692254",
          "name": "Reason",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "820070e1-0cbf-4d0e-813d-1725715195e7",
      "name": "dwMetadata",
      "dbObjectName": "dwMetadata",
      "schemaName": "",
      "attributes": [
        {
          "id": "cf570884-963c-44dd-be22-017c258e9662",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5aaee5b8-2b10-41a9-9d1d-f4263a0ef46d",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b1131e6-4e6a-4b70-a9fe-a96e4fbd2721",
          "name": "Data",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4c721fe3-de2e-4d6c-a81a-563dc1edea94",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3eb5a052-77da-4791-b38b-0561103fb896",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "661cf69c-deee-41ac-a22b-615a8c03000b",
          "name": "Filename",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "08503496-a327-48c4-9b70-1c27837877a1",
          "name": "Folder",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "13335520-e555-4d18-ba2d-bed551ce1fe5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "16383ec6-2501-49f8-85a3-ac3e809a966b",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "30b08b84-0736-448d-8c73-d6ed1a1b72b9",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "00caa425-726a-4d3b-a58f-b3c8f7359820",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9d9b9f2a-6404-4537-b0eb-a93ce3ac63e3",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "727fe2b1-f979-49c5-b92d-c5e70c1a4110",
      "name": "QNN_QNN_FORM",
      "dbObjectName": "QNN_QNN_FORM",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "674343a1-e1a6-4d98-9e2d-a814ebf1742b",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d7c53c38-8d62-431d-8ab7-73a25f6b58bb",
          "name": "Language",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6a636ac4-263e-41a7-b6cd-23640c3f286e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aafe438d-5468-4c99-a125-f23f8a0ea082",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "35a15d67-9f99-4d1a-9a73-7ab396344071",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8e81d88b-b5fe-4f3d-863f-8308bd3d9448",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "c361ccc4-48f2-4e4f-ba0b-3b6f25221fd3",
      "name": "vSP_QnnSampleActive",
      "dbObjectName": "vSP_QnnSampleActive",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "8a0a6c07-e834-4d78-908b-57e741bf83a0",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7e36ee51-604a-4fcb-a7b4-709ad3597863",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0f6c214a-0a7a-4a00-b3ea-fa5a7f8250a2",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cc6c95ac-b4b2-4d53-bdc6-b987423c4de7",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "25779d01-36e7-424a-b671-58f4a860bbc1",
      "name": "vSP_ListPropCount",
      "dbObjectName": "vSP_ListPropCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "d6554bae-2100-45ce-b5b3-edaf6118a8f4",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c1b62d03-dc4e-4340-9e50-d390924c24dc",
          "name": "PropCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2feec18d-b5da-447a-a08e-4841b034d65c",
          "name": "Fields",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d704f5f7-c5bb-4d99-b78a-c61f82fdf815",
          "name": "FieldsId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f80dfd0d-8d02-4fa0-b96d-a8d0a4b158c3",
      "name": "vSP_DeploymentWithRespCount",
      "dbObjectName": "vSP_DeploymentWithRespCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "f0a7d187-b968-4ad8-abec-e46b32bab0cf",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "619d0245-2d3b-46bc-ad67-4d0d69b779a0",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a2a0d06f-d6d9-4452-9910-df0e88be6104",
          "name": "ListId_Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "abc42150-cc13-446b-9a8a-8277022e11d0",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bef244ee-2ee4-496d-82aa-b3c212ed1d0b",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b1a5e363-bc28-40d6-864d-791bc353e150",
          "name": "QnnId_Title",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d4044d06-1bd3-4e33-93ee-e0e7ef5384dc",
          "name": "QnnId_Type",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "932f78f2-eed2-43ad-a8ee-435d0fc7b3b8",
          "name": "RespCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5a4cf42f-8ec4-446c-81cf-ae35f7318a4a",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f29c04ff-05dc-4c47-9ba3-47c0b54a3a74",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "04522c05-b4ee-4c68-ba7d-a94236d7f0b4",
          "name": "IsAnonymous",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "623bdb8d-e43f-4157-8944-6c3cdb497a89",
          "name": "IsMultipleResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "27066598-1089-4846-b0fd-2019d299c43f",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "205cadbe-08ab-43a8-9194-4ece2b83b0fb",
          "name": "RecurrenceType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "fe42f73b-dd23-468f-abce-7603be873b15",
      "name": "vSP_DeploymentSample",
      "dbObjectName": "vSP_DeploymentSample",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "5068b642-c419-4e66-9cb6-4c499f8fbf98",
          "name": "Active",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9839c5ec-1da6-4480-b4a4-dfcd0d8c7ee3",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bc9ea8c1-8e42-46c1-a307-20bd1f16425c",
          "name": "DateComplete",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "29955168-38dc-4bc4-9d09-51936f0c47a3",
          "name": "DateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5092b667-2bd3-4e5c-901d-af0c08ab963f",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eae438a7-c933-4cf4-901f-9afe4676b5d2",
          "name": "FormNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3f32683a-0b73-4487-8f9f-bcf67f4cd3de",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12b9130f-5b30-4de6-b1b3-9c87eb24b51b",
          "name": "Languages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8de04fab-6501-4963-9be1-d94e4e17bdad",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "194b29f5-61d7-4e19-9bff-61b7d63a59bc",
          "name": "ProcessEditInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bdd2c1e8-5fcc-425e-961a-902bb6a04b1b",
          "name": "ProcessValidInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6334a04c-beac-457e-a52c-6321f8eee654",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5d21fa68-625e-47f7-8b04-7e2407cb6833",
          "name": "RespId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ea09352e-57ba-4d9b-a1dc-c46e0f9d35a3",
          "name": "RespListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a3a11c9c-b29d-409b-8bec-45da88c5d7cd",
          "name": "ReturnInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cb1b05c3-930a-4336-82a3-8fcf1d5d03be",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e119a97f-3f94-4359-bf02-550c2523f58e",
          "name": "StatusCode",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2f9a77cf-0afc-413a-abe5-8268e56c8f3b",
          "name": "StatusTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2416c808-79fd-45b8-b9ea-09ff66b261dc",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e62abbfa-5e05-45f0-a59d-d25f0a90e47a",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "93d1e6f3-e3da-46c6-8da2-f145da19c67e",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c77c6136-5ac5-49e8-bf25-7e6bda01302c",
          "name": "UpdatedBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "16421e73-0595-4b09-bee5-15d70ea719d5",
          "name": "HasTrkListIds",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "60a898b6-786f-45e3-a57e-8f7739ac70b2",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8bd473e5-f566-4b1e-acb6-334ebd1c42f1",
          "name": "PeerUIDName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b4fd6baf-2091-46f5-9479-1cb9755293e4",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12e75b20-1246-448e-a824-b8e7320a0bdd",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "235e46d5-89f1-42db-a225-0e788022075c",
          "name": "UIDName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "81d40b12-963d-40a8-bc18-c310f0f82a5b",
          "name": "FileLanguages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ead782a3-2bf2-4ffd-aa71-970315d9a3ac",
          "name": "FileNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0380c4cb-0e1b-4232-ba8b-8e4cb26cf0eb",
          "name": "FileTokens",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d76d0092-3f3a-4006-a7ec-326621b58e70",
          "name": "IsExcelResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a1cb339f-8561-41a3-9f05-62a327f7e30b",
          "name": "ExcelUploadDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dec06220-d310-43c9-ace8-cdf8bcfa233b",
          "name": "IsExcelResponseDE",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "73e6b5cc-fedb-4d93-8be2-91f9992e4b1e",
          "name": "CompleteCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4a348d30-9f13-415e-8c6d-bf6944ce7272",
          "name": "IncompleteCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a5fae11f-6956-4f3e-8a98-b4c87eff7829",
          "name": "IsLatestResponse",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "656b207e-e791-4d30-a59d-88741d35f333",
          "name": "InitialResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7fe0e838-99bb-444a-b786-759048ad31ee",
          "name": "InitialResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "02cd32e6-06c3-4d56-b507-7837589b64bf",
          "name": "InitialResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ae8fd3cf-0a6d-47eb-a223-68f4873d13f1",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c05ecdb-16d5-477f-9a26-fa55ae97d93b",
          "name": "CompletedResponder",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3d364882-6d1e-4153-bbf7-ff1447c1a9fc",
          "name": "CompletedResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5aa147a4-d368-4d70-9c61-1dfa2c71a349",
          "name": "CompletedResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5868b37b-a833-4f6f-b8ee-d30fc37fefed",
          "name": "CompletedResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4cf65151-f4a7-479a-84f7-ea81a32166eb",
          "name": "InitialResponder",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9ca8d62a-6393-4679-94fb-7f45d413a975",
          "name": "LastResponder",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "db40c2ca-832b-4417-a00a-10f4eba418a8",
          "name": "LastResponseAs",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "781b6d55-afee-4764-aade-12cfb9704265",
          "name": "LastResponseBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a305ebdd-e2b4-4a0a-9a5e-138061ae982c",
          "name": "LastResponseVia",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e16ab465-9e59-4801-b498-3bf4ee1c44ea",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "name": "vSP_ListSampleInfo",
      "dbObjectName": "vSP_ListSampleInfo",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "name": "CompleteAction",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "name": "CompleteURL",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "name": "DaysUpdate",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fed57935-d235-4978-8e32-740704d0a4e6",
          "name": "DispatchInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "name": "DplyCreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "name": "DplyDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "name": "DplyDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "name": "DplyIsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "name": "DplyName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "name": "DplyStatus",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "name": "FormNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "name": "Languages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "name": "ListId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "name": "MaxResponse",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "name": "PeerName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dda35caf-327b-47f8-91ee-106063c882d4",
          "name": "ProcessEditInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "name": "ProcessValidInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "name": "QnnIsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "74097b74-c031-4848-af9c-c3e58c34e232",
          "name": "QnnStatus",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "name": "QnnTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "name": "QnnType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "762c021b-e51e-41d9-b041-050e239514a6",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "name": "RemarksModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "name": "RemarksModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "224bbbad-f587-4987-99d5-213d1433a56f",
          "name": "ReturnInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6de55289-ed7b-41bc-b92b-699842f92021",
          "name": "SampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "name": "StatusModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "name": "StatusModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "name": "StatusTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "name": "UIDName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "name": "UIDPeer",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "name": "VisibleToRespondent",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2fbd5e35-2964-40a0-82bc-76b93f3a73af",
          "name": "IpCountry",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be3bef4a-72f7-4804-84e7-8e42c40eab86",
          "name": "IpRange",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "40d72036-21c4-4b3f-8b2b-c352a37b3812",
          "name": "RestrictIp",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5ab3bc7d-e4d8-49fe-a087-7093f99286dc",
          "name": "RestrictIpInclusive",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f84924a8-77d0-4b03-8f0a-fc97de0df311",
          "name": "IsExcelEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fcb4627a-fb63-419f-9bbe-c125514a3f79",
          "name": "IsMultipleResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c457209-3ee6-41b3-95a8-870a2466cd02",
          "name": "IsAnonymous",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9f239689-fdd6-4c51-adce-9959579d2823",
          "name": "FileLanguages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fd8d1d9c-b64b-4e07-8fec-1c2d59577634",
          "name": "FileNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f66354e6-46ee-4d8c-a205-27ffec902cfa",
          "name": "FileTokens",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
          "name": "RequireAccessCode",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "45e33b1c-4b46-48ef-a5f2-eaccd6057395",
          "name": "CompleteCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d90b98b7-4fa0-4b64-8b66-cf30d6d39fc1",
          "name": "IncompleteCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "458395f4-aab2-4991-9f03-e41e4eda3812",
          "name": "DplyWorkflowState",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d57fff1d-991f-4afb-bcf5-7f8693a514fb",
          "name": "ListSampleRecordActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4cad2c1f-1a16-47f5-865e-8de0bc2902bf",
          "name": "SampleRecordActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "d779dd42-ad03-418f-9a00-7906cfb9e01f",
      "name": "vSP_ListWithCount",
      "dbObjectName": "vSP_ListWithCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "1f8c8043-fc0a-4bc3-a0d5-3933a136b8cb",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "33924fbd-7f4d-447e-9346-91fb73661914",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fe356bc9-fb35-418f-b289-6d3c3ba5bff9",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "4da79cdf-bda1-4862-99b0-7762005b3fa8",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1439e7c0-9381-49ac-bb27-06177daba88e",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a7caa665-5fcb-4cd8-b75e-4b6023baf6c7",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e85aa4f7-4e99-4797-8979-783b4239720f",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b8f72a51-90d9-4416-8267-3ad35be75b43",
          "name": "Tags",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ccbdf688-0179-41e6-9087-aea47869fb08",
          "name": "isArchived",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "266312e6-0cdd-4de4-970e-d1f6c4cc2328",
      "name": "vSP_StructDivision",
      "dbObjectName": "vSP_StructDivision",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "fc8e88d4-9c0b-4c80-9428-0856fbc7b975",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "21c9d747-931f-4faa-b2a3-b39181718f63",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b537c330-b42b-45aa-862d-7a25fd4d6797",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "252c3509-f434-4274-8005-4a9821fb52d0",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "5334b62e-8f0b-440b-8811-24a68a270c92",
      "name": "vSP_SurveyForm",
      "dbObjectName": "vSP_SurveyForm",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "ef7fb542-8a6c-4d80-855d-e751bfeefceb",
          "name": "Id",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3d9bf3ea-626e-4305-a291-dfcda906d949",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "200039c9-56d4-44fa-80ed-7530e142fcd2",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "031bb350-00e1-405e-83b4-e8163cbf3194",
          "name": "IsArchived",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "08c52333-7dcf-456b-af56-c30cf818f6c1",
      "name": "QNN_SAMPLE_STRUCTDIVISION",
      "dbObjectName": "QNN_SAMPLE_STRUCTDIVISION",
      "schemaName": "",
      "attributes": [
        {
          "id": "b6869873-d1dd-474f-a804-16faba21fc72",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "400fafbc-52f6-4ab3-8760-f0f699516ca8",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "83da3ded-2adb-4d43-a25f-5e64f7608605",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "01136d4e-2dd9-4fe6-b8a3-c5bf3024133b",
      "name": "AuditLog",
      "dbObjectName": "sy_AuditLog",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "fa59d179-5f66-4839-9a32-c99e27a55f46",
          "name": "ColumnName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7fca1733-7c9f-47fc-9283-32f78201b8db",
          "name": "EventBatch",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "10308116-629e-402c-b1ac-bdcc41113d34",
          "name": "EventDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3dce844f-2bc9-4aaf-a08c-6d7ac41b0de7",
          "name": "EventType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "43b8cfda-758d-4a15-91a9-66436043b9bf",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8bb6613-f8c5-44ca-8119-ef070c579a92",
          "name": "NewValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "22c6bd17-a545-429f-863b-701d7b21947b",
          "name": "OriginalValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d759a15b-6293-4cde-8e44-7bfc0b310053",
          "name": "RecordId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dc92b3df-776c-4b31-8cf8-67fbb728286b",
          "name": "SampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "df28248d-8cfb-495a-9cf9-240f51b95a28",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "87eec989-3d88-4212-a35f-05c06e00ac5c",
          "name": "TableName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d516c97d-9d0a-4972-8e05-dd69e61c2efd",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "name": "vSP_auditlog",
      "dbObjectName": "sySP_vSP_auditlog",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "name": "ColumnName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "name": "Division",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "name": "EventBatch",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "name": "EventDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "name": "EventType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e20428cd-d8c7-4510-a758-d5247006116e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "name": "NewValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "name": "OriginalValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "name": "RecordId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "712f40f5-5b68-496d-895f-32cc4971504a",
          "name": "SampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "name": "SampleName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "name": "TableName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "name": "UserName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "4ffa9a83-6f04-4bbd-a7ea-16101e6de1f4",
      "name": "vSP_auditlog_EventType",
      "dbObjectName": "vSP_auditlog_EventType",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "dcb3d353-78c4-4f17-8716-8f28ba7c08c6",
          "name": "EventType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c3c6c492-e711-4f9d-b786-86793097d7b1",
          "name": "Id",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "e31c0998-f9e9-4da6-9f90-e7d60300e20c",
      "name": "vSP_auditlog_TableName",
      "dbObjectName": "vSP_auditlog_TableName",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "a19b937e-1f45-4bac-8860-23c553f63f07",
          "name": "Id",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1a254095-54bf-46e5-a991-771299e09bbe",
          "name": "TableName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "734a6d9a-ecc2-40eb-8d92-d77de8258f9d",
      "name": "vSP_DeploymentOnline",
      "dbObjectName": "vSP_DeploymentOnline",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "c4ca74d0-afdd-46c0-bc5b-472ce2862247",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eacfb5aa-df9f-41f5-b28b-e759f04dc3bd",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6f420243-26aa-4b9e-9110-a383945d225e",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "89d13cd6-1301-4b24-96ac-0762841fd8ba",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "1cc4ab9d-b461-41d2-8adf-e0cf47ce26cc",
      "name": "vSP_DeploymentSampleAndPeerSample",
      "dbObjectName": "vSP_DeploymentSampleAndPeerSample",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "9505347a-2817-49a2-b570-a9637fdc0128",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2e869e4b-e26e-46f6-b8e7-56e13a66b7d5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "94671cae-7dcb-4719-b1dd-449ae98d9f12",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4507f64b-cea8-45ce-9004-81735eb1acc8",
          "name": "MergedUID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "444e7a41-d377-4ea1-b633-3da297b699e9",
          "name": "RespId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "72e1f2fd-c41e-4247-89b9-b1101b497ddc",
          "name": "IsPrePopulated",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "92ecfb3f-0c0e-4fc3-9a32-bacd84e99b66",
      "name": "vSP_DeploymentRespCompleteCount",
      "dbObjectName": "vSP_DeploymentRespCompleteCount",
      "schemaName": "",
      "attributes": [
        {
          "id": "344c2939-c310-419a-9b14-f494e26cefe8",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b2f71568-bbfe-469d-bcb8-259b29bc5e62",
          "name": "RespCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "3275785a-1cc0-46ce-9029-49294f9ba32c",
      "name": "QNN_DPLY_SCHEDULER",
      "dbObjectName": "QNN_DPLY_SCHEDULER",
      "schemaName": "",
      "attributes": [
        {
          "id": "fd23a6e1-46b5-4644-93ba-9b2ca1e34ba6",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5ee94360-a1c6-4100-ad39-ab1cd9bc0d92",
          "name": "LastJobRun",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "70999c5f-d75a-4266-ab20-2ed95b386989",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4459de82-2451-4a3b-9216-a5ff79ecfb99",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c11efa3e-092e-4d50-a53d-8e466ea46259",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4c4b9d84-b59d-450b-a06c-7d0c8e4d7b7f",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ded3e49c-6af3-4f13-a67d-4378664e1150",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "88da8924-9178-40e0-a718-118193ce6fb4",
          "name": "EmailFailure",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d530f22f-5d25-4569-b03f-db9b19c5d316",
          "name": "EmailRecipients",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b9131c6b-2229-4950-a20a-37c6eed353bf",
          "name": "EmailSuccess",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1936eec5-15c9-4b17-9c53-7a6c00fadc6a",
          "name": "JobDescription",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "50043ffa-94cf-43b2-8c65-7ba239e62046",
      "name": "QNN_REPORT_SNAPSHOT",
      "dbObjectName": "QNN_REPORT_SNAPSHOT",
      "schemaName": "",
      "attributes": [
        {
          "id": "22c68eae-447a-47b2-b5f8-9f6814334706",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5b107635-a175-4977-a1a8-541b2e7c2e7e",
          "name": "BatchNo",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8980a677-cf4c-4647-a8d1-b9af3022d44d",
          "name": "Count",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b0e6b49-1b86-41c4-84f9-e7a58593e9cb",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9dde2ae0-99fd-4b65-b3a3-81bbccb3f7e2",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b9be75ce-242a-4458-a82e-9ae6a82e8774",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0a9aaf19-72e2-41c3-8558-fed28a92fd8b",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f52ade35-d8be-4417-910b-8f6260d3a882",
          "name": "Weightgroup",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "96aba12c-a596-46b1-b1dd-74a5ba60f3d6",
      "name": "vSP_QnnSampleActiveForGrid",
      "dbObjectName": "vSP_QnnSampleActiveForGrid",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "e6eacd17-2f27-ac18-7687-28d1a200b555",
          "name": "LastLoginDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7a48d23c-8d3f-476f-b443-0f2c15c32f51",
          "name": "ActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ed15f27b-d27a-4f96-a87e-35487ef74f6f",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cd0aed58-ed57-47c3-a6a8-e1348aff5e37",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7465d37b-32c2-4447-b563-71121c49aecb",
          "name": "NumRetry",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18273149-6b04-49c7-9b0d-ba476ca9c2d4",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ec38a02c-e930-41b3-bb5d-993aa510d212",
          "name": "StructDivisionName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "37f0c1bc-9266-41e7-89f3-9db71c52d805",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bd7d0d39-4d14-4ab8-8da4-630351b0b2b7",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "67f5a605-d9d5-480d-9eaf-a6bb0244cfb9",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "013d4e11-3ae3-4da3-9120-c7a73048771a",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "name": "vSP_DplyMsgSample",
      "dbObjectName": "vSP_DplyMsgSample",
      "schemaName": "",
      "attributes": [
        {
          "id": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "name": "DplyMsgId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6705a993-8496-4f31-a85d-29254a3bab4c",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "82cae075-c642-4479-9621-a999a4785614",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "8492334d-4c98-4af4-aa79-cb30837d52c4",
      "name": "dwAppSettings",
      "dbObjectName": "dwAppSettings",
      "schemaName": "",
      "attributes": [
        {
          "id": "aa3090bd-a937-4a27-b785-7656c1151b48",
          "name": "EditorType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5172105d-11cf-477d-8d4f-15f42cddc178",
          "name": "GroupName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d76b712c-dbbc-406d-b0f9-ea8f99af36bf",
          "name": "IsHidden",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "775c5512-f25b-4262-83ab-351bb45fb6c9",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aaff6a4a-356a-415d-b3d6-2e828d59e80d",
          "name": "Order",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3201c5f7-6f54-4e19-a862-266a0ce531b5",
          "name": "ParamName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5cedbb22-9925-4fdc-b9b2-a2161707770e",
          "name": "Value",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Name"
    },
    {
      "id": "ea08b91d-a603-41a2-8396-8430ccb3f1bb",
      "name": "QNN_RULE",
      "dbObjectName": "QNN_RULE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "c18b92cc-d3c6-56f9-419d-acb41056f78c",
          "name": "Comments",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "250acf7c-d9fb-4738-88f9-8069b98a1ff5",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2e95decc-de0f-47f7-9e2e-46ea22985ac0",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3da67c4c-93fe-4ecc-b9a7-046dddad5de5",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9a055a7f-4eb9-4441-8df5-b74c489e6e1a",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "430e1edc-de90-4af3-9f02-effe8089800a",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9fff33de-bcb2-4348-a7bf-559894ac6aec",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4760359f-8a71-44ec-baf0-bef43ff238bf",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b12c7eb3-c550-4c9c-8999-4a663ee9f29d",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "92044df4-e4bc-45f2-b023-9d50e722297e",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "640e1fee-733e-41cb-9687-2bd9bd6bcb57",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "89594fdd-5dde-42af-b69d-5d3722883bef",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9192b784-b6ef-4d5e-b9bb-ebccadeed2dc",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "765eaf26-34e9-4154-a57b-ad54564a506f",
          "name": "Validation",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "bb075204-7deb-44cc-9251-b1d158e816d3",
      "name": "QNN_HELP",
      "dbObjectName": "QNN_HELP",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
          "name": "Content",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "90a76b37-0d22-4e40-8524-f4f990a161d5",
          "name": "Heading",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
          "name": "Topic",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "94da5047-34a7-42a0-97ca-09e704f33af0",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "95a49c95-bd21-41ee-8a53-c1f96ca5d927",
      "name": "QNN_QNN_FILE",
      "dbObjectName": "QNN_QNN_FILE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "2e8d9106-1308-4399-a561-a34cd12de0c5",
          "name": "ContentType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b7275b5e-c4b4-4296-966d-91216131561f",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e34c36c7-e5e7-4212-8feb-380d7feb5d48",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6d833d65-ad3f-4d20-a64d-60e913572f0e",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "54a852ab-6ef1-4b5e-9780-c4cf2a8339af",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a895859f-8c06-4515-9803-ce31821119a7",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f65f5cda-7d7e-403f-b7c9-84837c48cd0a",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "debe95cb-f26f-44f5-b9f0-268dd244468b",
          "name": "Language",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fb81a1fb-fa8a-4264-ab16-3c30cd9c3927",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3085136b-f4ce-4790-8dea-bb2fee94de7c",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "7565471d-898d-4f6b-83b8-70fa86343d4f",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b68d3ba2-f9c8-4697-8c0f-a71d8868f86a",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9d07044c-e991-4f1a-816b-a5a2f879bf62",
          "name": "Size",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "48441dc8-4895-4df4-8f48-7358ad18cd97",
          "name": "Token",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fa07f472-dc63-4b47-b611-7bad7624387a",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "51684962-8fa3-4964-bc2a-bc8fd2128baf",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "26784c86-abb0-4561-829c-5c0d2e43bd2b",
      "name": "QNN_DPLY_TRANSITIONHISTORY",
      "dbObjectName": "QNN_DPLY_TRANSITIONHISTORY",
      "schemaName": "",
      "attributes": [
        {
          "id": "330403fb-a523-414e-88bd-7c56a23a0bd4",
          "name": "AllowedToEmployeeNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8c88e685-a9a1-4d69-944b-d29321e71e4a",
          "name": "Command",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1e4d737c-0e95-4ae0-a1fd-92b7019e85d7",
          "name": "DestinationState",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0e7fa009-ea9c-4cbd-b2b2-8b101fbf30f3",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3e5f7a3b-89cb-49fd-8145-409a6623b4c5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "40c8c14b-391b-46e1-8e62-15660dd26e1b",
          "name": "InitialState",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6d378e92-bb9b-455a-ab1b-fcca70e515d0",
          "name": "Order",
          "type": "Int64",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "88aa9c4a-9205-41cc-9814-e13472420002",
          "name": "TransitionTime",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "75d45a92-686d-4429-a833-4009fb223cdb",
          "referenceEntityId": "1b535314-d142-4421-900a-93917ffd5515",
          "name": "UserId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "b0c74e5f-ee68-4c55-9139-6cd123a50e89",
      "name": "QNN_DPLY_DATASET",
      "dbObjectName": "QNN_DPLY_DATASET",
      "schemaName": "",
      "attributes": [
        {
          "id": "4be80f7d-38b7-48cc-a245-c5d859824d6c",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b01b0858-6948-4ef8-8b7c-b151beaced16",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "540da639-899f-4030-9a32-e4a527594a28",
          "name": "Data",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5686c29e-9ba8-4755-937c-b2e320ea4221",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "32445ec9-fe0e-420e-a081-73ec8f037b0e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b1dbfad1-b3fb-49fb-b247-97e634e64a10",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5e6e6007-8860-4d1e-aa11-cf7d66bf73b3",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "70ffb977-fb0c-4158-9bf5-7ab1f761bcf1",
      "name": "QNN_RESP_DELEGATION",
      "dbObjectName": "QNN_RESP_DELEGATION",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "44861bb9-aed7-089d-4167-0d56833dda08",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4ef9466b-de79-4d6c-91bc-2adffde17a34",
          "referenceEntityId": "0922eac6-ef78-4d36-a771-700118d3712e",
          "name": "DplyListSampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "891e1ed9-5c94-4afd-ae6e-bd134ccf6866",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b6edea87-7f1c-45be-8829-179013a9788e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "edacafe3-c210-4d9e-9eac-e1d954377ec2",
          "name": "AccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e813a492-f101-4bd7-b10e-6f83dbe418e2",
          "name": "ValidityEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1b446122-dff9-4a83-968f-24a863ec0f9c",
          "name": "ValidityStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "60d73ddf-7306-43ee-95d2-412064dc4e67",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "cd4f97f9-7f25-4a40-9433-8c132a9963e5",
          "name": "Comments",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "faacf55d-bb38-4bdb-8232-72c498679c29",
          "name": "FromName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6a4da997-20de-4fe5-8c57-73bb82bec696",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "953e74a5-a493-4d79-a4d9-0ad32b7e1896",
      "name": "QNN_DPLY_MSG_FORSTATUS",
      "dbObjectName": "QNN_DPLY_MSG_FORSTATUS",
      "schemaName": "",
      "attributes": [
        {
          "id": "f31f1bc0-3a16-4699-84d4-b12a3ce6c66f",
          "referenceEntityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
          "name": "DplyMsgId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "41ecf684-71cd-4d13-9535-1941227f974d",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "ForStatus",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "293a7a59-6c38-4db2-b230-2c206e777614",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
      "name": "QNN_GLOBAL_MSG",
      "dbObjectName": "QNN_GLOBAL_MSG",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "51458d0d-a57e-415d-af77-0506b62b2deb",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "178e7c32-3be5-46ae-8ab1-94a6504f1a2b",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "868d7019-916a-41a2-ad9c-80e83c3e7146",
          "name": "EmailFrom",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf5185ac-386f-4c17-9b43-d81346e47627",
          "name": "EmailSubj",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7f4eb9fe-d50d-4b90-be34-5f81b48a005f",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25163e9e-6d07-4423-bef6-5203af0926cf",
          "name": "JobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a59d6ab1-d8f1-4092-a7b2-5302d788b52a",
          "name": "JobIsCanceled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e24601f7-a005-4dc1-b76b-2e4ced2c9f47",
          "name": "MsgContent",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ffc06abf-996d-41b7-8aee-f8ee9b573217",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "b34d67a4-bfc5-4ee0-9112-d7ddffbfd570",
          "name": "ScheduledDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "603cb5e3-af1f-4288-8659-9d041999c4d4",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98daf50e-4248-4701-8fdd-17dacdd94355",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bb0f1b64-9144-4b35-916b-3a6292a0e774",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f1658572-a0e2-4084-8cf9-17b3a4f2998a",
          "name": "IsTargetUsers",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1a057eec-3f17-49fa-b876-261f21e6695a",
          "name": "MsgContentJson",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "65091649-b0af-4091-86f9-7109aeb9fbf7",
      "name": "QNN_GLOBAL_MSG_FORSTATUS",
      "dbObjectName": "QNN_GLOBAL_MSG_FORSTATUS",
      "schemaName": "",
      "attributes": [
        {
          "id": "8c53aed3-bbc5-420f-84f0-e6b8820052cd",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "ForStatus",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1287529e-1bc7-465a-a53b-98cb619f253b",
          "referenceEntityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
          "name": "GlobalMsgId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1ffeb14b-0ab9-4ca5-ade4-2971477fe68b",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "0d69cf76-ca91-4b87-b818-eb6721e68ff8",
      "name": "QNN_GLOBAL_MSG_SAMPLE",
      "dbObjectName": "QNN_GLOBAL_MSG_SAMPLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "35f7b4de-501a-4be5-94a8-df8ce32346a2",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b28196dd-a763-4490-9c33-65262618591b",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9e9ed25f-da73-4976-bacd-e070c4724320",
          "referenceEntityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
          "name": "GlobalMsgId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "060b1fb8-93f2-418c-9d89-61492d4c3f58",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "649a59a7-cb88-441b-87d8-49f402b88a10",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "c1cd7f30-1e92-4036-8c06-cf46611db775",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cdde27ca-7f85-401e-9691-f1aefab21f61",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "50d704dc-bfec-4e46-be5f-58ecb9aa220b",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "26f92131-609c-40bc-8b38-9ec4fd66fca5",
      "name": "vSP_GlobalMsgWithSampleCount",
      "dbObjectName": "vSP_GlobalMsgWithSampleCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "be5cfc9e-69b1-4ccd-a92a-bdd062727c00",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c94a477-4399-4659-9d1d-5c24087d023c",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be72b7e3-bcc7-4d62-bb6d-3467d422512f",
          "name": "EmailFrom",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "705fe916-6b58-4b51-ac1d-cbbd565ab921",
          "name": "EmailSubj",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fb438787-70d2-4a34-97dc-1b214d1bdd92",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "577ae8a2-3d0a-4b19-8a28-09c177fd19a0",
          "name": "JobId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "469e027c-f7dc-4227-a4c8-82152ba1dd91",
          "name": "JobIsCanceled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5d1fff92-b20c-4fb6-855d-f840171fa9bf",
          "name": "MsgContent",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e5a4d062-2eb7-4009-920c-b00ec6f661da",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9001b9b9-0f4c-4cfe-b185-8fb97fe61a29",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b66ea0c8-5d41-4d09-9bc4-037a171d6913",
          "name": "ScheduledDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "465f2fc6-434a-457f-bd45-a1835abd7bcd",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ba1df5e9-1f0b-4f9e-8c32-7c02fd04fff4",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0f66dd50-0752-4c59-b219-8fed4d27ace0",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aee289bb-555f-4890-b890-7b3b1a6dc719",
          "name": "UserName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1e447ccd-dd43-4cef-abb7-f3d7a688cc8c",
          "name": "IsTargetUsers",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "acce5637-059f-41f0-814b-a3269259045c",
          "name": "EmailsSent",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "1aa13d9f-30a1-482e-9733-ee01420755f7",
      "name": "vSP_GlobalMsgSample",
      "dbObjectName": "vSP_GlobalMsgSample",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "0e2eac76-0927-4eb7-8fdf-c5955a3d227a",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8b4aaa31-a559-4912-9397-09de90ac4e16",
          "name": "GlobalMsgId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4853e87b-032f-48ce-b964-790b92b9e918",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "686137e7-c77f-43bd-9dd2-e6b79b4465aa",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "907dfbd8-9670-4099-8dae-91b18986837c",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf0d8261-44c1-4bc6-aac4-8be090818dea",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "583dec9c-0409-45e7-9632-50ef1fa4255e",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "d3ac775b-8060-42da-bff9-3375238c92ae",
      "name": "AccessReportSchedule",
      "dbObjectName": "AccessReportSchedule",
      "schemaName": "",
      "attributes": [
        {
          "id": "509010fc-62b3-4fd7-b635-4d8174363f92",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3e15663a-e2a8-4eff-bc74-4f49809a278d",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0c0a3874-5f11-4948-8ac6-0adfe37aa962",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8428c7d-62cb-4cfc-99df-b66fc2cc5e91",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fbfab597-f82e-4d9d-bfd5-61d4f802c20b",
          "name": "IsEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25ca90f0-e8e3-4523-9754-9df7851b2009",
          "name": "ScheduleType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "390846cb-8ed9-478d-919e-89c51ca2f114",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3e95b496-eda7-463c-b279-667a579451bb",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b36f0c25-3194-4333-9380-894b388d8526",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "f25e0160-1a94-4bd9-8217-eba25b098f12",
      "name": "vStructDivisionParentsAndThisName",
      "dbObjectName": "vStructDivisionParentsAndThisName",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "c7b08a56-bc72-4175-9554-26f5886ac5b5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3e0106f7-bcf1-4c30-9acc-964844cddc5f",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5d9cd0f7-2ae3-43b7-969d-2d943e6eb2f7",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "afe5309c-a9b3-4c7f-9691-b638d8eae006",
      "name": "QNN_GLOBAL_MSG_USER",
      "dbObjectName": "QNN_GLOBAL_MSG_USER",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "b8c454cd-764c-4509-b084-739b0cfd70ed",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fbfa7083-9f81-4f03-b48c-70881febdd2d",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0e13a01f-3eac-4fae-9f9b-48492e1565a0",
          "referenceEntityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
          "name": "GlobalMsgId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2f6f6f82-d0b8-454d-b8d9-6cdf146fde17",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d504eff3-5bc6-44b9-b3e2-42ccea76dedc",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "01a28f85-740b-4b8e-8b02-6f70cdfe87b0",
          "referenceEntityId": "1b535314-d142-4421-900a-93917ffd5515",
          "name": "UserId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "a7267c48-2060-46d2-8923-cd1dcbd01006",
      "name": "vSP_GlobalMsgUser",
      "dbObjectName": "vSP_GlobalMsgUser",
      "schemaName": "",
      "attributes": [
        {
          "id": "b3bc9f47-0598-4079-9114-f21bf45fc83e",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4077a2c7-b11c-42e3-9fdc-e9382299c204",
          "name": "EmailSentDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "08edc3df-13f7-480f-9fbe-9a8d1f638a70",
          "name": "GlobalMsgId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0a99aad0-9fcf-412f-8f29-f51ec14de57e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cef5e01e-8dcb-4767-bcb9-6b1dc397ea25",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "c87f2169-d643-4f6e-b3e2-f78161f6b524",
      "name": "vSP_ListSampleRespInfo",
      "dbObjectName": "vSP_ListSampleRespInfo",
      "schemaName": "",
      "attributes": [
        {
          "id": "6fb2bd3a-8e4d-4d9e-be37-981ac7e01b39",
          "name": "DplyDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d71416f5-6203-4cbb-b6bb-82016dce1ac6",
          "name": "DplyDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2950cd56-0353-4684-818e-87e637f534ef",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6c9b6ff0-837b-492d-8ead-7ae8f580e603",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b2a042de-ca11-4db3-bab5-787935fd227c",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be8725e3-d9e8-4903-a536-ab3db65b4a47",
          "name": "lsoId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12628804-e355-41ac-bf17-f250d0c24c5d",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9641e443-8ea5-4530-a8cc-152dea2c2f9d",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d844c2aa-50d5-410c-97d4-4f4d3921f87a",
          "name": "PeerName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6f6c4c1c-ecad-459a-8d90-e6e1106eee07",
          "name": "PK",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "135e83e8-f029-483e-8abd-03d84938595b",
          "name": "RespDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b094760f-ce22-4dfc-bd5d-e1a7de893b69",
          "name": "RespDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "451a89eb-980d-4524-811c-ab10bf56af3c",
          "name": "Segment",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fc29b4df-54fe-427f-8158-fede2f29c3d5",
          "name": "StatusTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ecb87cef-ee39-4339-9372-0504ef38d63c",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "31adbd84-3b88-47f9-b9a2-d7f2ec621697",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d2a4d876-ff9c-4e91-9679-35d20b585580",
          "name": "UIDPeer",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0ec2deb7-88ed-4fab-8233-9a8f8547cd51",
          "name": "UserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d5db008-b458-41d3-b0bf-013783623181",
          "name": "Username",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "38c282f1-ed5f-4147-b1ec-15672887b2a6",
      "name": "vSP_ListSampleOwnerInfo",
      "dbObjectName": "vSP_ListSampleOwnerInfo",
      "schemaName": "",
      "attributes": [
        {
          "id": "81ed3e34-35d5-4293-83c1-7cbfe68e3bfc",
          "name": "DplyDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0cad3427-e00d-4091-a837-4fbe369037d2",
          "name": "DplyDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "31ff9d95-c8fe-4436-bd9f-3148f7964eef",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "21df80a6-9380-4992-8b9c-1bc040ffdc09",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c0daca23-832d-4543-ab20-85d7b2a2dd11",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "46efd4ac-7393-4398-9de4-b37f5676d776",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fa66bc60-0745-40c3-8497-7219b9e4ac9d",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7c4704bb-1c10-48de-a8cc-ba14213ced08",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "093acf4e-c585-4857-9ce1-2e2a3bd40bd1",
          "name": "PeerName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "334c1eb4-621a-4fd4-b42c-a0c09b1d485e",
          "name": "RespDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8519f434-3b1f-4630-8e85-73f9e9df1e3a",
          "name": "RespDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "36f65289-3b9c-4acf-94d8-a24d202347f8",
          "name": "Segment",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ae54d6ea-63a0-46b1-a710-7f4face4d54c",
          "name": "StatusTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "98a16621-02c1-40e2-99ed-2caa2dc87896",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "37449e09-0d4f-460b-b5f1-a9136d721637",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "09fa3e73-1950-4266-b5d3-201ee2746355",
          "name": "UIDPeer",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "89210f1f-3c03-4ea1-b372-8b02b35b2de5",
      "name": "vSP_RespDelegationActive",
      "dbObjectName": "vSP_RespDelegationActive",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "2e9dc482-edcb-493a-b885-f72aa321b484",
          "name": "AccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9da49035-97b7-49cf-9d1b-82fb10d67928",
          "name": "Comments",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3b039863-3fdd-432f-a931-cc89d6a62dfe",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d0123a87-20e3-4812-bcd6-beb7f645032c",
          "name": "DplyListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "673e3e54-ca7b-4c84-8bb4-7bf49d774a7b",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "25cb64e7-dcd5-4dfb-a136-6a6b453c7035",
          "name": "FromName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fddbceda-1f68-4850-b766-4b6eafb780a3",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "14e52b98-f57a-4707-89cf-98b8c51f56fe",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ff33bb45-adfa-4e03-887e-9915fbd89fb3",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0afe8de2-0418-4ea4-83eb-ca49849ce1a5",
          "name": "ValidityEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bc257393-048b-4cbb-bcc8-e569c70031bd",
          "name": "ValidityStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "36fc4752-6c87-4108-b65c-af24d739b5e2",
          "name": "RowNumber",
          "type": "Int64",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "847b2487-0d91-4f05-a720-f34ac1e31314",
          "name": "RevokedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "36802030-8323-4a30-8056-186feb9dea66",
      "name": "vSP_RespDelegationGrid",
      "dbObjectName": "vSP_RespDelegationGrid",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "d6a13135-3cdf-4d30-86bf-f288bd3badb3",
          "name": "AccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5470da65-d64c-4136-ac51-64510e1b8719",
          "name": "Comments",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f29a636d-9ccb-4d13-bfb3-c018c190acb5",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "78ff02fc-5f20-4e12-8900-2f8195c7f254",
          "name": "DplyListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ec76d211-020d-42b0-88a6-92bb960a6640",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "23490c83-c8e7-41ec-900b-21f8e1c1dd8c",
          "name": "FromName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "44c1da14-b66c-476f-b0cc-6a7384352b9c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b7e97588-c69f-44aa-96e2-4f0eca30f6fd",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "913f969b-18fc-4286-b190-f927b0dbeee0",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0e846c4b-7ebd-4705-bda1-11cd0a1e1439",
          "name": "Status",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "14a831d9-c323-4ecd-9f12-423b3f0fa461",
          "name": "ValidityEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12e2d745-cd38-4dd1-ac16-0bc21cb2a0f4",
          "name": "ValidityStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ef308bee-edf7-4468-b31f-cb0b1a1b623d",
          "name": "RevokedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "1a997b7e-cd30-4121-a97f-9e00401d21a4",
      "name": "QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD",
      "dbObjectName": "QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD",
      "schemaName": "",
      "attributes": [
        {
          "id": "ca74e2db-4cb9-41bf-be49-dd9777a188fe",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d059a5b2-e62f-4992-84f0-065ba74f311c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ae51edb0-f7d6-49a8-9c17-0c2a1e9f852d",
          "referenceEntityId": "1c8be8b0-f9a7-4f09-a7b1-c4bfd124ff0b",
          "name": "QnnFieldId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "a201ebb9-a7ef-4753-b162-47841336d562",
      "name": "vSP_DeploymentRecurrencePrePopulateFields",
      "dbObjectName": "vSP_DeploymentRecurrencePrePopulateFields",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "c8b903d9-6dde-450b-adb2-0a7948047f5d",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8fad157c-5c95-4014-abca-895070e078a8",
          "name": "PrePopulate",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "436fed2d-8ec3-4677-ab00-40611ca10734",
          "name": "QnnFieldName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e76aa78e-99ff-491b-92dc-cee0b3158dfd",
          "name": "QnnFieldType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8e394b8b-9ab2-4b98-ade3-b63b538a030a",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ea03357d-fad0-4bb2-928b-1c5756c63016",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "3c39bb2d-0db5-453b-868f-1094da479292",
      "name": "QNN_DPLY_CUSTOM_RECURRENCE",
      "dbObjectName": "QNN_DPLY_CUSTOM_RECURRENCE",
      "schemaName": "",
      "attributes": [
        {
          "id": "03936e9a-293c-4c2f-bd0e-16d2b81c84e9",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6ab6c2e3-2f40-4e1d-b866-b8ab17092a0f",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "de3905ff-a670-43af-bf11-d038ff133e0b",
          "name": "CustomFrequencyType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3fc3bce6-3fae-451b-bd09-7e5016eb4a37",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "20b5906b-ee07-4ee7-8927-632440b5537c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a61ce22f-4bf0-4e86-be45-3a3d17adfb49",
          "name": "RecurDay",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7d244f96-18a9-4f22-83fb-6c0c92682b5c",
          "name": "RecurMonth",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "acdbfe29-3a2c-48c7-8220-e973d49530ce",
          "name": "RecurYear",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fc5b24d4-f694-43b7-873d-2c3c6ba2a087",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b26c218a-c003-4414-b385-cce4d55f95c4",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "name": "vSP_ListSampleInfoResp",
      "dbObjectName": "vSP_ListSampleInfoResp",
      "schemaName": "",
      "attributes": [
        {
          "id": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "name": "CompleteAction",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "name": "CompleteURL",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "name": "DaysUpdate",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "name": "DispatchInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "name": "DplyCreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "name": "DplyDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "name": "DplyDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "16185f31-6818-41e0-8d67-d2ad33108559",
          "name": "DplyIsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "name": "DplyName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "name": "DplyStatus",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "979c3398-38e0-4d66-b349-85d17d150b27",
          "name": "DplyWorkflowState",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "name": "DueDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "name": "FileLanguages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "name": "FileNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "name": "FileTokens",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "name": "FormNames",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "name": "IpCountry",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "532327eb-fce5-46d4-ad4c-772823325636",
          "name": "IpRange",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18734c70-0971-491b-b0ed-8480b5869727",
          "name": "IsAnonymous",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "name": "IsExcelEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "name": "IsExcelResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "name": "IsMultipleResponse",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "name": "IsPrePopulated",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "name": "Languages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "name": "ListId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "name": "ListSampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "name": "MaxResponse",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "name": "PeerName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "name": "ProcessEditInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "name": "ProcessValidInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fabd0251-b03f-4485-af61-7e5419b99995",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "name": "QnnIsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "name": "QnnStatus",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a077938a-1661-465d-a937-8b0d080e95c7",
          "name": "QnnTitle",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "name": "QnnType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "name": "RemarksModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "name": "RemarksModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "name": "RequireAccessCode",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "name": "RespDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "name": "RespDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "name": "RespId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "name": "RestrictIp",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "name": "RestrictIpInclusive",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "name": "ReturnInd",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "name": "SampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5f01ec1a-9752-4062-b954-4b251862e473",
          "name": "StatusModifyBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "name": "StatusModifyOn",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "88faf742-166e-4acb-bf00-9870fb94f619",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "name": "UIDName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "name": "UIDPeer",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "name": "VisibleToRespondent",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "name": "ListSampleRecordActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f384f444-143d-43e7-8727-09b545ed8819",
          "name": "IsIncludeUnansweredSection",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "704cea13-77e0-4087-9136-561b7c7743b2",
          "name": "RespDateUpdate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "96f391bb-a0b5-4c38-a382-d8b963a88524",
          "name": "sampleEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e40d9199-bbba-4267-b632-7c1fd80f2021",
          "name": "TotalComplete",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b1faa54-a4d7-4f86-9010-c00bc1d6592a",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "e7274207-b60b-40d6-9722-f6ab0b25264e",
      "name": "vSP_auditlog_EventBatch",
      "dbObjectName": "vSP_auditlog_EventBatch",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "ffdfc2dd-d473-46e7-b20b-368eb0e453ee",
          "name": "EventBatch",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "652dce1c-7cff-4295-b7e1-904f85f0a74c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "edae2d91-a5b4-4bcb-a268-7e3c4966c532",
      "name": "vSP_RespParticipation",
      "dbObjectName": "vSP_RespParticipation",
      "schemaName": "",
      "attributes": [
        {
          "id": "a0df13b1-bd63-4dfe-8200-08e11196f831",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b362071e-92a7-4f80-8680-32d36700b061",
          "name": "RespondentName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b6e5918b-6c76-41bd-9587-dfe2485d8b1d",
          "name": "Status",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c9e2504d-934a-4589-bdae-c5ae75e386c6",
          "name": "StatusDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0bca6c1b-46fa-4554-b48e-fcb4bfa1a424",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8f15ec99-ab32-4ada-97e5-096df1df7096",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8e115ea7-402b-4d44-b47f-b441d98c875e",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "41f1f4b7-c4cb-42a3-abcc-e18369d55bd9",
          "name": "StatusId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d900a4d6-92ff-48f7-bbb4-65b35b192eaf",
          "name": "RespId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "bb232797-c37c-4e39-8261-5cde3636eb04",
      "name": "QNN_SHORT_LINK",
      "dbObjectName": "QNN_SHORT_LINK",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "acd0d9a1-ace1-4bfd-8f80-2c2c493ed548",
          "name": "AccessCode",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b7052bb3-8310-47ed-b645-f079b5f73e05",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1bae5af1-eb43-4d4a-b4cf-87304bddba00",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "728217c3-dfb3-45cd-bdca-8951417281e2",
          "name": "LinkType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fe48fb6e-51ec-43d8-8205-d3d099441e9d",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "da7a87db-a45a-4a02-a73a-43c4ec9f5ac2",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "116cbed7-4d0f-44d2-9ff0-875a648175ac",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "878d0beb-de01-440b-a81b-5a284e8ebdc9",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f224c78c-3bdc-47ca-84d1-51795d978d48",
          "name": "Url",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "09beb932-46b3-4485-b133-f0ec735935d6",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d5041cf8-91b4-47b2-bf5e-0cd64ff11a22",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8a0c403a-2f71-4dbf-b0ee-4b760a149ecb",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dcd04769-b679-449b-bde1-6170a9b7d14e",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "94fda3ab-15e5-4fda-bec1-339a2d72f128",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "acff1425-443d-45dc-a491-cf18e6b646b8",
          "name": "IsEnhancedSecurity",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "281b9c4f-cde3-422d-9cb3-b2364fef8b51",
          "name": "FormName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "9f2384b3-c50c-4a14-aada-cd75ff27c780",
      "name": "vSP_ShortLink",
      "dbObjectName": "vSP_ShortLink",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "a386cf67-dc72-454c-acc3-4a53da9a63b1",
          "name": "DisplayDescription",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d279a7ce-1748-4a52-8f44-cd5ea6d9ca1c",
          "name": "DisplayTarget",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ef36465f-85c4-4e7d-a24d-b161b1a076c8",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eb6f0fdf-f014-4615-ab5a-aa2ba9b3e0e2",
          "name": "IsEnhancedSecurity",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5cff4fe9-0f43-41a6-a22e-994c44bf933e",
          "name": "LinkType",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cd5fc2da-fcf2-4e67-9b85-7294633c788f",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "904478aa-2ab1-4480-afd3-742ba9840c06",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "259e06f8-652b-4ef7-aace-cd5fd115e6de",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "218ec89e-4aa3-4985-bcf5-4e69c8824347",
      "name": "QNN_STYLE",
      "dbObjectName": "QNN_STYLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "68d481c2-da6f-4186-b65f-ff583f740930",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ec886465-a2e5-4cc1-afd8-beb101ce86c6",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "00792a31-ed25-4d82-b673-5cfff21eb35e",
          "name": "CssProperties",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fc6da424-9227-47c5-a801-9217d29883f5",
          "name": "CssSelector",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "85f06cd3-2033-4704-9a7e-cd1295179e37",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "12e325a8-ecca-4288-9e76-81d57ae03d7e",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4ef2eaf5-6d7d-44e6-af6e-f0c230b9e368",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ae020fe4-cb13-4994-894b-1152f2d88cf5",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "233251e4-788f-4443-8c71-a58e8b71abb2",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0ed9cb40-1a9b-49e4-a96e-b43978dd1e22",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d9d785b6-7573-43ef-b534-7e5b7ca2e542",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "9060a28f-eb9f-449d-b1bc-e211cc3ea7cd",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "40c7cb99-4fda-45dd-97b0-9f9f84957bf5",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "72ccc8e6-de8a-4814-b4d4-2772e23bfa8c",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "f6daa3a5-a8d0-4985-a2c7-a4154f51ec7a",
      "name": "vPlaceholder",
      "dbObjectName": "vPlaceholder",
      "schemaName": "",
      "attributes": [
        {
          "id": "80c7b92e-a05f-4a88-b698-5f91cef20047",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "48188aea-bf3d-45fe-8173-51f409497771",
      "name": "QNN_SAMPLE_ADDRESS",
      "dbObjectName": "QNN_SAMPLE_ADDRESS",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "dcc822c9-1fa5-4d21-8eec-aebf01b6189d",
          "name": "AddressLine1",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c2ed800c-0cd5-4a76-adce-e315b65bf765",
          "name": "AddressLine2",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f619adde-1faa-4560-94ef-0e83714e067c",
          "name": "AddressLine3",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "68dd7da4-94ed-4401-9895-e22c3d8a8e71",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c6a061e3-229c-462d-90e2-35acfc735fd8",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8e081f3f-77f3-49ec-9388-77edd594c8dc",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eacf1752-f109-4c4d-8219-1932c08c467c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "01ec6849-8f6d-4d77-98a1-3c9cad29afb6",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "91cf943b-610e-40a0-aa88-2910fb679c27",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "df70459b-50df-48ae-9f54-53a35cc60414",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5958b446-a320-41b6-8a09-bfb1bddf8429",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "439de409-d7af-45df-b742-fb94059a4208",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0b83a30f-b46c-4d5f-bf85-8472c188b02d",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "6cf82f70-64e4-4494-b02b-82806ea7c26e",
      "name": "vSP_ListSampleAddress",
      "dbObjectName": "vSP_ListSampleAddress",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "8cccf6c3-0226-48a3-a998-da0e36c4daf3",
          "name": "AddressLine1",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8483bf15-ff56-49e2-96e1-c9bc94be1938",
          "name": "AddressLine2",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "04ae0ae7-aa15-4fe4-9a9e-3da6b1011130",
          "name": "AddressLine3",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0303ebaa-f136-4957-853e-52fb9dce9865",
          "name": "CcEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f9357a1b-c839-42c1-a624-ee242454fcfc",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "361ff056-f5e5-42e3-af19-804c08085e6c",
          "name": "ListId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf043f7d-e0bf-4cdf-a5f2-22e2cb362f82",
          "name": "ListSampleActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "32553188-2535-4522-95b8-957279ba3ed1",
          "name": "ListStatus",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8325f35d-ec44-4846-b129-0011d8b15cc1",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "b5602ad5-e7a9-4659-a2d8-ee1b7b7a2bbf",
          "name": "SampleActiveYN",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "75e179e7-7731-46f4-9e62-eb27d6fe95aa",
          "name": "SampleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f25864f8-5967-4508-8fa8-3fbdbdeeff9b",
          "name": "SamplePeerId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "38bfcb12-f658-4ce2-ab33-99e5c236435a",
          "name": "ToEmails",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f9743ce4-bd21-4aec-ae86-0bb6d7440190",
          "name": "UID",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "2440d7d1-2e6f-48b7-b9e1-6c01c3ef7ca1",
      "name": "QNN_SCHEDULED_EXPORT_RECIPIENT",
      "dbObjectName": "QNN_SCHEDULED_EXPORT_RECIPIENT",
      "schemaName": "",
      "attributes": [
        {
          "id": "1491743c-ef8d-468f-9c10-7d133adbf413",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "755e59b8-aff2-404e-a15b-e408909ce99c",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7bd06848-1fe0-434b-b865-402ed82c60cd",
          "referenceEntityId": "1b535314-d142-4421-900a-93917ffd5515",
          "name": "SecurityUserId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "5c69df80-7410-40d0-bea8-3dc8d6479f6f",
      "name": "vSP_UserRole",
      "dbObjectName": "vSP_UserRole",
      "schemaName": "",
      "attributes": [
        {
          "id": "08165950-4631-4855-8437-f78a512aeb7a",
          "name": "IsLocked",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "45097630-e153-4dfd-bf5b-81a1d3eecb60",
          "name": "RoleCode",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "68f60577-9329-4934-8a79-f375be04b631",
          "name": "RoleName",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "57ff6b9f-2a6a-4f9d-97f1-95e5c4542af8",
          "name": "SecurityRoleId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7484d111-cfc7-4751-9079-ea0d1cc2abe9",
          "name": "SecurityUserId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "124448b8-9768-4a12-a406-dca0ddbb7195",
          "name": "SecurityUserName",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "485ab321-5b58-425e-addf-e1b14f2cda74",
          "name": "SecurityUserStructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ]
    },
    {
      "id": "11c8a1e4-825e-4166-bd56-c2c10b0a74f1",
      "name": "QNN_FILE_TICKET",
      "dbObjectName": "QNN_FILE_TICKET",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "c1839ac4-420e-4656-8934-8391c7ebac39",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "84977ffb-630b-4906-a1c3-c14f4e793c84",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e1b9b130-0b6d-458b-8ebe-9e85a5dd59bc",
          "name": "ExpiryDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5589c84a-a626-4dae-8953-24785bd6a680",
          "referenceEntityId": "283c3132-e3b3-4b5b-8afd-fd5e380f6124",
          "name": "FileId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "faf97893-8fdb-4a01-94af-39b646e9f9a4",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a5a1a127-9643-439f-a815-bb3ca78af0cd",
          "name": "IsEnabled",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "9b8f6d61-99f7-4289-a7a5-a12755083cc8",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "da6fa4b7-9956-496a-ab05-69cb269e4c0e",
          "name": "Purpose",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "eb83657f-05b4-4de8-a02e-501445a701a7",
          "name": "RestrictedToRoles",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "22cd748e-bfc9-43aa-b685-19031fde8332",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a8fa70a6-00a3-4700-a522-b7cd2e5bb33c",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ba190749-3170-4304-94fd-2c5c47d4e879",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ee2bc8d4-c2e8-4789-9b23-1f365d37fb43",
          "name": "IsDeleteFileOnExpiry",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "084fdf90-fc2f-4b17-97eb-b67cd95c1e58",
          "referenceEntityId": "1b535314-d142-4421-900a-93917ffd5515",
          "name": "RestrictedToUserId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "d86b1601-1835-4940-8656-935919fbfa42",
      "name": "QNN_DPLY_STRATA_QUOTA",
      "dbObjectName": "QNN_DPLY_STRATA_QUOTA",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "e002b0ed-62ab-4c24-b5ed-8dbbd3a94905",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5131622f-7910-472e-96a3-20579c094ce9",
          "referenceEntityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
          "name": "DplyId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "18c36ed8-5910-4b2b-922c-fa91043b7ee2",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "66bd2fe0-f34a-4378-986d-211cc77371c1",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "f326f979-04ea-455e-85b4-b94d629030e3",
          "name": "MaxResponse",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "543fa0b2-cad2-4507-830e-fed30afe0c19",
          "name": "StrataValue",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    },
    {
      "id": "11362fb2-6363-4042-bd07-b786ef81f86b",
      "name": "QNN_SAMPLE_REMARKS",
      "dbObjectName": "QNN_SAMPLE_REMARKS",
      "schemaName": "",
      "attributes": [
        {
          "id": "a0d35614-4ea6-4b38-9d0b-449208977482",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "593a53f2-e483-43fa-812a-733cd546f844",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fbc37fc4-7b06-4e88-9cae-2caae9a3fcd8",
          "referenceEntityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
          "name": "SampleId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "31f9bdbf-51bb-49b7-adcc-3608113a5d8b",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        }
      ],
      "primaryKeyAttribute": "Id"
    }
  ],
  "codeActions": [
    {
      "id": "9914f1b6-de45-4692-be97-d835f9e70d94",
      "name": "StructDivisionFilter",
      "comment": "The filter for struct division",
      "definedOnServer": false,
      "type": 0,
      "source": "return Filter.Empty;",
      "usings": "",
      "isAsync": true
    },
    {
      "id": "6a5f16cc-75be-3e9d-d669-476394ff0668",
      "name": "inboxfromadmin",
      "definedOnServer": false,
      "type": 0,
      "source": "var user = CloverRuntime.Security.CurrentUser;\r\n/*break*/\r\nvar inboxModel = await MetadataToModelConverter.GetEntityModelByModelAsync(\"WorkflowInbox\");\r\nvar currentUserInbox = (await inboxModel.GetAsync(Filter.And.Equal(user.Id, \"IdentityId\"))).Select(e => (Guid) e[\"ProcessId\"]).ToList();\r\nthrow (new Exception());\r\nreturn Filter.And.In(currentUserInbox, \"Id\");",
      "usings": "",
      "isAsync": true
    }
  ],
  "businessFlow": [],
  "modules": []
}' WHERE [Id]='5a1a28d7-df6a-4391-9965-05f17d7660e3';

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:28:59.107', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "modalDiv",
        "data-buildertype": "container",
        "children": [
          {
            "key": "copyModal",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "inverted": true,
            "secondary": true,
            "children": [
              {
                "key": "formImportList",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopySampleList",
                    "data-buildertype": "header",
                    "content": "Copy Sample List",
                    "size": "medium",
                    "subheader": "New Sample List Name*"
                  },
                  {
                    "key": "copySampleListId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "newSampleListName",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200
                  },
                  {
                    "key": "container_4",
                    "data-buildertype": "container",
                    "style-marginBottom": "20px",
                    "style-width": "100%",
                    "children": [
                      {
                        "key": "container_8",
                        "data-buildertype": "container",
                        "style-float": "right",
                        "children": [
                          {
                            "key": "btnCopyList",
                            "data-buildertype": "button",
                            "content": "Copy",
                            "primary": true,
                            "style-marginRight": "20px",
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "copySampleList"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            }
                          },
                          {
                            "key": "btnCancelCopyList",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeCopyModal"
                                ],
                                "targets": [
                                  "copyModal"
                                ],
                                "parameters": []
                              }
                            }
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Sample Lists",
        "size": "large"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Export",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridExport"
            ],
            "targets": [
              "gridviewwithactions_1"
            ],
            "parameters": []
          }
        },
        "style-hidden": true,
        "secondary": true
      },
      {
        "key": "btnCreate",
        "data-buildertype": "button",
        "content": "Create",
        "style-customcss": "",
        "primary": true,
        "events-onClick": true,
        "events-onClick-actions": [
          "gridAdd"
        ],
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridCreate"
            ],
            "targets": [
              "grid"
            ],
            "parameters": []
          }
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
        "style-source": "",
        "floated": "left"
      },
      {
        "key": "container_11",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "deleteModal",
            "data-buildertype": "swzmodal",
            "secondary": true,
            "children": [
              {
                "key": "deleteHeader",
                "data-buildertype": "header",
                "content": "Delete Sample List & Associated Records",
                "size": "medium",
                "textAlign": "left",
                "subheader": ""
              },
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Import List",
                "size": "medium",
                "events": {},
                "other-visibleConition": ""
              },
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "",
                "content": "WARNING: Deleting a Sample List will also immediately delete all deployments that use it INCLUDING RESPONSE DATA"
              },
              {
                "key": "deleteGridView",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Sample List Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": true
                  }
                ],
                "events": {}
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "DeleteConfirm",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridDelete",
                          "closeDeleteModal"
                        ],
                        "targets": [
                          "grid"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "CancelDelete",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDeleteModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-float": "right",
                "style-source": "text-align: right;",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "style-display": "none",
            "content": "Delete",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "openDeleteModal"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "isOpen": "",
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ]
      },
      {
        "key": "div_float_modal",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float:left",
            "secondary": true,
            "content": "Import",
            "style-display": "none",
            "children": [
              {
                "key": "formImportList",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "importHeader",
                    "data-buildertype": "header",
                    "content": "Import Sample List",
                    "size": "medium",
                    "events": {},
                    "other-visibleConition": ""
                  },
                  {
                    "key": "listName",
                    "data-buildertype": "input",
                    "label": "New List Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "400px"
                  },
                  {
                    "key": "listPassword",
                    "data-buildertype": "input",
                    "label": "Password for new or password_reset samples (optional)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "200px",
                    "type": "text"
                  },
                  {
                    "key": "listFile",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "file",
                    "style-marginTop": "10px"
                  },
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "right",
                    "children": [
                      {
                        "key": "btnImportCancel",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "style-customcss": "",
                        "primary": false,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeImportModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "(data.sampleAdded == null || data.sampleAdded == undefined)",
                        "style-source": "float: right;",
                        "inverted": false,
                        "secondary": true
                      },
                      {
                        "key": "btnImportSave",
                        "data-buildertype": "button",
                        "content": "Save",
                        "style-customcss": "",
                        "primary": true,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "importSampleList"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;"
                      }
                    ],
                    "style-marginRight": "",
                    "style-width": "100%",
                    "style-marginBottom": "10px"
                  }
                ]
              }
            ],
            "size": "",
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ],
        "style-float": "left"
      }
    ],
    "style-float": "right",
    "style-marginRight": "20px"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnRefresh",
        "data-buildertype": "button",
        "content": "Refresh",
        "style-customcss": "",
        "primary": false,
        "events-onClick": true,
        "events-onClick-actions": [
          "gridAdd"
        ],
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
        "other-visibleConition": "",
        "style-source": "",
        "inverted": false,
        "secondary": true,
        "compact": false,
        "floated": "left",
        "style-marginLeft": "",
        "style-marginRight": "20px"
      },
      {
        "key": "inputSearch",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": "",
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
                "value": "Name,Tags,SampleCount,UpdatedDate"
              }
            ]
          }
        },
        "placeholder": "Search...",
        "style-width": "300px"
      }
    ],
    "style-float": "left",
    "style-width": "",
    "events": {},
    "style-marginBottom": ""
  },
  {
    "key": "Archived",
    "data-buildertype": "checkbox",
    "label": "Archived",
    "toggle": true,
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "updateFilter"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "10px",
    "style-marginLeft": "20px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-source": "clear:both",
    "style-marginBottom": "50px",
    "children": [],
    "style-marginTop": ""
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": ""
      },
      {
        "key": "SampleCount",
        "name": "Samples",
        "type": "number",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "isArchived",
        "name": "Archived",
        "type": "checkbox",
        "width": 100,
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": ""
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 150
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "sortable": false,
        "filterable": false,
        "resizable": true,
        "width": 100
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "NumberId DESC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_LIST",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500"
  }
]' WHERE [Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa';

UPDATE [dwMetadata] SET
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:18:38.953', 
[Data]=N'{
    init: function(args) {
        console.log("args to init", args);
        const innerArgs = args;
        const hasEditPermission = CloverApp.API.checkPermission("Edit");
        console.log("hasEditPermission", hasEditPermission);
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            if(hasEditPermission) {
                return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
            } else {
                return null;
            }
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 5){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Name.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    }, //end of int
    
    //called by Copy button in modal
    copySampleList: function(args) {
        const data = args.data;
        const id = data.copySampleListId;
        const title = (data.newSampleListName===undefined) ? "" : data.newSampleListName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sampleListId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating SampleList");
        Utils.postFormRequest("/list/duplicate", formData).then(
            result => {
                args.component.refs.grid.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of copySampleList
    
    viewArgs: function (args){
        console.log("View", args);
    },
    
    importSampleList(args){
        const token = args.data.listFile;
        const listName = args.data.listName;
        const password = args.data.listPassword;
        
        const passwordError = globalUserActions.samplePasswordError(password);
        if(passwordError) {
            throw {
                level: 1,
                message: passwordError,
                formerrors: {main: {listPassword: true}}
            };
        }
        
        var errors = {};
        if (!listName || ""===listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                message: "List name or file cannot be empty",
                formerrors: {main: errors}
            };
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        if(password && ""!==password) {
            formData.append("password", password);
        }
        Utils.postFormRequest("/list/importcsv", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success( Utils.encodeHTML(response.message),10000);
                args.component.refs.importModal.close();
            }, reason => {
                console.error(reason);
                if("NAME EXISTS"===reason) {
                    alertify.error( "A list with this name already exists in this organisation", 25000);
                } else {
                    CloverApp.API.setDataField("listFile", null);
                    alertify.error( Utils.encodeHTML(reason), 25000);
                }
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeImportModal: function(args) {
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
    },
    
    closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
    
            updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != null) {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.470', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:28:59.237', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2025-11-24T17:28:59.2367332+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "176196ed-079f-6a36-bc0c-331bfdb4c7d3",
      "entityId": "d779dd42-ad03-418f-9a00-7906cfb9e01f",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "24b1dfc8-98b5-2b3d-cc48-6e6a874659c6",
          "attributeId": "1f8c8043-fc0a-4bc3-a0d5-3933a136b8cb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9ccc51d-c139-eda6-0d48-9d1a1dc10f48",
          "attributeId": "33924fbd-7f4d-447e-9346-91fb73661914",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d7a2e45-1ca6-5be7-ae45-10db539e2ddb",
          "attributeId": "fe356bc9-fb35-418f-b289-6d3c3ba5bff9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c3d75d44-bc83-484d-66ce-5a80562732b0",
          "attributeId": "4da79cdf-bda1-4862-99b0-7762005b3fa8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e1e96a0-86b5-bf30-c83e-c74ca19142a9",
          "attributeId": "1439e7c0-9381-49ac-bb27-06177daba88e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dbc0e6f-294f-a7a1-7b84-3708819382cf",
          "attributeId": "a7caa665-5fcb-4cd8-b75e-4b6023baf6c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8fd30580-6db4-1048-6736-b3b42f516a3c",
          "attributeId": "e85aa4f7-4e99-4797-8979-783b4239720f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f21b7f4-e600-61a5-c8b0-3f0057ad0a4e",
          "attributeId": "b8f72a51-90d9-4416-8267-3ad35be75b43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2a785c5-0e2d-9039-b398-13964d4bc342",
          "attributeId": "ccbdf688-0179-41e6-9087-aea47869fb08",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3';

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:17:46.530', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Form Properties",
        "size": "huge",
        "textAlign": "left",
        "style-width": "",
        "style-marginLeft": "",
        "events": {},
        "style-source": ""
      },
      {
        "key": "modalDiv",
        "data-buildertype": "container",
        "children": [
          {
            "key": "copyModal",
            "data-buildertype": "swzmodal",
            "style-display": "block",
            "inverted": true,
            "secondary": true,
            "children": [
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopyQnn",
                    "data-buildertype": "header",
                    "content": "Copy Form Properties",
                    "size": "medium",
                    "subheader": "New Form Properties Name*"
                  },
                  {
                    "key": "CopyQnnId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "NewQnnName",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200
                  },
                  {
                    "key": "container_3",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "container_4",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "btnCopy",
                            "data-buildertype": "button",
                            "content": "Copy",
                            "primary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "copyQnn"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginRight": "20px",
                            "floated": ""
                          },
                          {
                            "key": "btnCancelCopy",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeModal"
                                ],
                                "targets": [
                                  "copyModal"
                                ],
                                "parameters": []
                              }
                            },
                            "floated": ""
                          }
                        ],
                        "style-float": "right"
                      }
                    ],
                    "style-float": "",
                    "style-width": "100%",
                    "events": {},
                    "style-marginBottom": "20px"
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      },
      {
        "key": "div_main_button",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnCreate2",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "style-source": "float:left",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "container_10",
            "data-buildertype": "container",
            "style-float": "left",
            "children": [
              {
                "key": "deleteModal",
                "data-buildertype": "swzmodal",
                "secondary": true,
                "children": [
                  {
                    "key": "header_22",
                    "data-buildertype": "header",
                    "content": "Delete Form Properties",
                    "size": "medium",
                    "textAlign": "left",
                    "subheader": ""
                  },
                  {
                    "key": "message_1",
                    "data-buildertype": "message",
                    "header": "",
                    "content": "WARNING: Deleting a Form Properties will also immediately delete all deployments that use it INCLUDING RESPONSE DATA",
                    "style-marginTop": "",
                    "style-marginBottom": "50px"
                  },
                  {
                    "key": "deleteGridView",
                    "data-buildertype": "gridview",
                    "columns": [
                      {
                        "key": "Title",
                        "name": "Form Properties Name",
                        "sortable": true,
                        "filterable": false,
                        "resizable": true
                      }
                    ],
                    "events": {}
                  },
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "DeleteConfirm",
                        "data-buildertype": "button",
                        "content": "Ok",
                        "primary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "gridDelete",
                              "closeDeleteModal"
                            ],
                            "targets": [
                              "gridQnn"
                            ],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "CancelDelete",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "secondary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeDeleteModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-float": "right",
                    "style-source": "text-align: right;",
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  }
                ],
                "style-display": "none",
                "content": "Delete",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "openDeleteModal"
                    ],
                    "targets": [
                      "gridQnn"
                    ],
                    "parameters": []
                  }
                },
                "isOpen": "",
                "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
              }
            ]
          }
        ],
        "style-float": "right",
        "style-marginRight": "20px"
      },
      {
        "key": "div_search",
        "data-buildertype": "container",
        "children": [
          {
            "key": "inputSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Title,CreatedDate,Tags"
                  }
                ]
              }
            },
            "placeholder": "Search..."
          }
        ],
        "style-float": "left",
        "style-width": "300px"
      },
      {
        "key": "Archived",
        "data-buildertype": "checkbox",
        "label": "Archived",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "defaultValue": "0",
        "style-marginLeft": "20px",
        "style-marginTop": "10px",
        "other-customValidation": ""
      }
    ],
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "div_clear",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginTop": "",
    "style-marginBottom": "30px"
  },
  {
    "key": "gridQnn",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Title",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom"
      },
      {
        "key": "Tags",
        "name": "Tags",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Status",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "checkbox"
      },
      {
        "key": "IsArchived",
        "name": "Archived",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": false,
        "filterable": false
      }
    ],
    "editForm": "QNN_QNN",
    "multiselect": true,
    "pagerType": "server",
    "pageSize": "50",
    "rowKey": "Id",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500",
    "defaultSort": "Title ASC",
    "style-marginTop": "",
    "style-source": ""
  }
]' WHERE [Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef';

UPDATE [dwMetadata] SET
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 16:56:35.253', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_QNN'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Title.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        
      return CloverApp.API.rewriteControlModel("gridQnn", gridModelRewriter);

    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating Questionnaire");
        Utils.postFormRequest("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridQnn.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
    },
    
        closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
    
        updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != null) {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridQnn: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

UPDATE [dwMetadata] SET
[Id]='2868495b-b1d3-40a8-943b-0078927caa60', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.650', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:17:46.797', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzQnnList",
  "lastUpdate": "2025-11-24T17:17:46.7978502+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "f7cb6ad3-78ac-8040-0838-09058d73161a",
      "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
      "filter": "StructAsyncFilter",
      "control": "gridQnn",
      "dataMap": [
        {
          "id": "2745cc89-c54f-d253-bbc5-67765af500a5",
          "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9eefbfb-c05d-277e-61f1-2463208aa58d",
          "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b843f723-2acd-c38a-1381-ae6883cfea39",
          "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36e795f2-b899-f6d0-81b4-4ba60c81359d",
          "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93015bf0-2009-41d5-81cf-4aa6e9fd063c",
          "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "228d3101-b4bc-0eea-a96c-db7cfb4ce9e1",
          "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff5f3abc-abe7-5c06-ad70-3a2c1894e925",
          "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "70de2c9d-6607-0cd5-f8c2-f6aed26cf048",
          "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27c1cfef-6d4c-12de-add1-839bc5dd08e5",
          "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6e08bf3-0b0e-536b-1485-8e662b1aa6c2",
          "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05f9bb5e-a5bc-60ca-5d22-b9a5d35b06e9",
          "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "672d3d2a-a7f7-21ca-9bca-0a7f7044e906",
          "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8787ec91-9b6b-fbd4-e407-aaca9ca20a5f",
          "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "607a923f-7a35-368b-ca05-464f7dc9ff1f",
          "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f340d62-9ff5-60a5-253a-b591891dffc7",
          "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "16cc7389-055e-b28a-47fc-372ab83fb9a0",
          "attributeId": "e2018e3a-6e65-4b0d-aa62-c640c20288b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58e1abd0-8afc-222b-e16e-023362fa415c",
          "attributeId": "37e07f99-e5d6-45b3-8674-cbfb55769be9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__gridQnn_totalcount"
    }
  ],
  "securityGroup": "Questionnaire",
  "isArchived": false
}' WHERE [Id]='2868495b-b1d3-40a8-943b-0078927caa60';

UPDATE [dwMetadata] SET
[Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.690', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-23 23:51:19.527', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Form Properties",
    "size": "huge",
    "subheader": "(Questionnaire)"
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
            "key": "Warning_Type_P",
            "data-buildertype": "message",
            "header": "WARNING: Unsupported Form Properties Type",
            "content": "This Form Properties uses the deprecated ''P'' type for Offline PDF Surveys. \nSupport for this feature has been removed. ",
            "warning": false,
            "error": false,
            "other-visibleConition": "(data.Type===''P'')",
            "size": ""
          },
          {
            "key": "Title",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "other-customValidation": ""
          },
          {
            "key": "Description",
            "data-buildertype": "textarea",
            "label": "Description",
            "fluid": true
          },
          {
            "key": "staticcontent_4",
            "data-buildertype": "staticcontent",
            "content": "Tags",
            "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
            "isHtml": true
          },
          {
            "key": "divActiveTags",
            "data-buildertype": "container",
            "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;",
            "children": [
              {
                "key": "mdlTag",
                "data-buildertype": "swzmodal",
                "content": "Add/Remove Tags",
                "compact": true,
                "secondary": true,
                "size": "tiny",
                "style-display": "none",
                "children": [
                  {
                    "key": "header_6",
                    "data-buildertype": "header",
                    "content": "Add/Remove Tags",
                    "size": "medium"
                  },
                  {
                    "key": "message_1",
                    "data-buildertype": "message",
                    "header": "",
                    "content": "Add a custom tag by typing in the Tags",
                    "info": true,
                    "compact": false
                  },
                  {
                    "key": "staticcontent_6",
                    "data-buildertype": "staticcontent",
                    "content": "Tags",
                    "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                    "isHtml": true
                  },
                  {
                    "key": "ddTags",
                    "data-buildertype": "dropdown",
                    "label": "",
                    "fluid": true,
                    "selection": true,
                    "data-elements": [],
                    "placeholder": "Type and add tag here",
                    "search": true,
                    "multiple": true,
                    "allowAddItems": true,
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "divTagsSearchResult",
                    "data-buildertype": "container",
                    "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                    "style-marginBottom": "10px",
                    "events": {},
                    "children": [
                      {
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "staticcontent_8",
                            "data-buildertype": "staticcontent",
                            "content": "Search For Tags",
                            "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                            "isHtml": true
                          },
                          {
                            "key": "TagsSearch",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": false,
                            "onChangeTimeout": 200,
                            "placeholder": "Search Tags...",
                            "events": {
                              "onChange": {
                                "active": true,
                                "actions": [
                                  "searchTagsInDB"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            }
                          }
                        ],
                        "orientation": "grouped"
                      },
                      {
                        "key": "staticcontent_7",
                        "data-buildertype": "staticcontent",
                        "content": "<hr>",
                        "isHtml": true,
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px"
                      }
                    ]
                  },
                  {
                    "key": "container_4",
                    "data-buildertype": "container",
                    "style-float": "left",
                    "style-marginTop": "30px",
                    "style-marginBottom": "20px",
                    "children": [
                      {
                        "key": "btnTagsSave",
                        "data-buildertype": "button",
                        "content": "Save",
                        "primary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "saveActiveTags"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeTagsModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "secondary": true
                      }
                    ]
                  }
                ],
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "openTagsModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "<hr>",
                "isHtml": true,
                "style-marginTop": "10px",
                "style-marginBottom": "10px"
              }
            ],
            "style-marginTop": "4px",
            "style-marginBottom": "20px"
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "IsArchived",
            "data-buildertype": "checkbox",
            "label": "Archived"
          },
          {
            "key": "congtainer_qnn_qnn_form",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Online Forms:",
                "size": "tiny"
              },
              {
                "key": "collectioneditor_2",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Form Name",
                    "control": "custom"
                  },
                  {
                    "key": "Language",
                    "name": "Language",
                    "control": ""
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "header": true,
                "other-visibleConition": "",
                "placeholders": {
                  "Name": [
                    {
                      "key": "Name",
                      "data-buildertype": "dictionary",
                      "label": "",
                      "fluid": true,
                      "selection": true,
                      "columns": "Name",
                      "dataModel": "vSP_SurveyForm",
                      "paging": true,
                      "search": true,
                      "style-customcss": "dictionary-no-label",
                      "filters": "[{\"column\":\"IsArchived\", \"value\":\"false\", \"term\":\"=\"}]",
                      "events": {}
                    }
                  ],
                  "NoLanguageMsg": [
                    {
                      "key": "NoLanguageMsg",
                      "data-buildertype": "message",
                      "header": "",
                      "content": "No link will be generated as there is no language specified",
                      "negative": false,
                      "warning": false,
                      "error": false,
                      "size": "mini",
                      "events": {},
                      "other-visibleConition": "data.Language ==null"
                    }
                  ]
                },
                "events": {}
              },
              {
                "key": "Warning_nolanguage_form",
                "data-buildertype": "message",
                "header": "WARNING: Language is not specified",
                "content": "No link will be generated for those not language specified in online form.",
                "other-visibleConition": "!data.collectioneditor_2.every(function(e) { return e.Language != \"\" }) || !data.collectioneditor_2.every(function(e) { return e.Language != null })",
                "events": {},
                "negative": true,
                "compact": true,
                "floating": false
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "other-visibleConition": "(data.Type==''O'')"
          },
          {
            "key": "Excel_Files_After_Save_Message",
            "data-buildertype": "container",
            "style-marginBottom": "",
            "style-marginTop": "20px",
            "other-visibleConition": "(data.Type==''O'' && (data.Id===undefined || data.Id===null || data.Id=='''')   )",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "(Excel survey files may be added after saving)"
              }
            ]
          },
          {
            "key": "container_qnn_qnn_file",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Downloadable Excel Files:",
                "size": "tiny",
                "subheader": "(Used in Excel-enabled Online Surveys)"
              },
              {
                "key": "collectioneditor_3",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Excel File Name"
                  },
                  {
                    "key": "Token",
                    "name": "File",
                    "control": "file2"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "disableAdd": true,
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  },
                  "onAdd": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-visibleConition": ""
              },
              {
                "key": "Warning_nolanguage_file",
                "data-buildertype": "message",
                "header": "WARNING: Language is not specified",
                "content": "No link will be generated for those not language specified in excel file.",
                "other-visibleConition": "!data.collectioneditor_3.every(function(e) { return e.Language != \"\" }) || !data.collectioneditor_3.every(function(e) { return e.Language != null })",
                "info": false,
                "warning": false,
                "positive": false,
                "floating": false,
                "error": false,
                "compact": true,
                "negative": true,
                "success": false,
                "events": {},
                "other-customValidation-soft": false,
                "other-required": true
              },
              {
                "key": "dropzonecontrol_2",
                "data-buildertype": "dropzonecontrol",
                "showFiletypeIcon": true,
                "autoProcessQueue": true,
                "addRemoveLinks": true,
                "multile": true,
                "events": {
                  "success": {
                    "active": true,
                    "actions": [
                      "createElement",
                      "showLangWarning"
                    ],
                    "targets": [
                      "collectioneditor_3"
                    ],
                    "parameters": []
                  }
                },
                "iconFiletypes": "*.xslx",
                "customPostUrl": ""
              }
            ],
            "other-visibleConition": "(data.Type==''O'' && data.Id)",
            "style-marginTop": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-float": "left",
            "events": {},
            "style-marginRight": "20px",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "customSave"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "value": "/form/SwzQnnList",
                        "name": "target"
                      }
                    ]
                  }
                },
                "inverted": false,
                "secondary": false,
                "primary": true,
                "other-visibleConition": "(data.Type !== ''P'')",
                "style-marginRight": "20px"
              },
              {
                "key": "btnConvertToOnlineForm",
                "data-buildertype": "button",
                "content": "Convert to Online Form",
                "events": {
                  "onClick": {
                    "actions": [
                      "convertToOnlineForm"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "inverted": false,
                "secondary": true,
                "primary": false,
                "other-visibleConition": "(data.Type === ''P'')",
                "style-marginRight": "20px"
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
                        "value": "/form/SwzQnnList"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          }
        ],
        "style-marginBottom": ""
      },
      {
        "key": "cntVisuallyDivideFormAndList",
        "data-buildertype": "container",
        "style-source": "clear: both;\ntext-align: center;",
        "style-marginBottom": "20px",
        "children": [
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<hr />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_5",
            "data-buildertype": "header",
            "content": "Deployments using this Form Properties",
            "size": "small"
          },
          {
            "key": "gridDeployments",
            "data-buildertype": "gridview",
            "columns": [
              {
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "key": "Name",
                "name": "Deployment"
              },
              {
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "key": "SurveyName",
                "name": "Survey"
              },
              {
                "key": "CategoryName",
                "name": "Category",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "CreatedDate",
                "name": "Created",
                "resizable": true,
                "type": "datetime",
                "sortable": true,
                "filterable": false
              },
              {
                "key": "DateStart",
                "name": "Start",
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "DateEnd",
                "name": "End",
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              }
            ],
            "rowKey": "Id",
            "pageSize": "50",
            "defaultSort": "Name ASC",
            "rowHeight": "80",
            "editFormShowType": "",
            "editForm": "QNN_DPLY",
            "events": {
              "onRowClick": {
                "active": false,
                "actions": [],
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
            }
          }
        ],
        "style-source": "padding: 10px;\nclear: both;",
        "style-marginTop": "20px",
        "other-visibleConition": "(data.Id  && CloverApp.API.checkRole(''SurveyAdmin'') ) ? true : false",
        "style-customcss": "",
        "events": {}
      }
    ],
    "style-marginBottom": "",
    "events": {}
  },
  {
    "key": "divModal",
    "data-buildertype": "container",
    "children": [
      {
        "key": "errorModal",
        "data-buildertype": "swzmodal",
        "content": "errorModal",
        "size": "",
        "style-display": "block",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "System Message",
                "size": "medium",
                "style-source": "font-family: Lato,''Helvetica Neue'',Arial,Helvetica,sans-serif;\npadding-bottom: 1.5rem;\ncolor: rgba(0,0,0,.85);\nborder-bottom: 1px solid rgba(34,36,38,.15);"
              },
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "{ErrorText}",
                "isHtml": false,
                "style-source": "word-wrap: normal;\nleft-margin: auto; right-margin: auto;",
                "style-width": "80%",
                "style-customcss": "content"
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "style-source": "clear: both;\npadding: 20px;",
                "style-width": "100%",
                "children": [
                  {
                    "key": "btn_cancelErrorModal",
                    "data-buildertype": "button",
                    "content": "OK",
                    "secondary": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "cancelModal"
                        ],
                        "targets": [
                          "errorModal"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": true,
                    "floated": "right"
                  }
                ]
              }
            ],
            "style-source": "padding: 20px;"
          }
        ]
      }
    ],
    "style-hidden": true
  }
]' WHERE [Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374';

UPDATE [dwMetadata] SET
[Id]='27dbfadb-0e83-4acd-af28-35a760e3239b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 13:29:58.803', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2025-11-24T13:29:58.7823865+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
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
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\", \"Type\": \"O\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnFilesTrigger"
    }
  ],
  "dataMap": [
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
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a618b97-0e2c-8433-f49c-5ba34a9f6132",
      "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2fd052d-a481-fb33-2d48-d40d25783715",
      "attributeId": "e2018e3a-6e65-4b0d-aa62-c640c20288b0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "555fd0cb-283c-789e-ffa2-810d600a7ada",
      "attributeId": "37e07f99-e5d6-45b3-8674-cbfb55769be9",
      "control": "IsArchived",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
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
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_2_totalcount"
    },
    {
      "id": "b7ce1da8-ae40-e1fc-55d2-df280efd08a2",
      "entityId": "95a49c95-bd21-41ee-8a53-c1f96ca5d927",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_3",
      "dataMap": [
        {
          "id": "852590b9-843e-dab0-910e-ab0c75f435a7",
          "attributeId": "2e8d9106-1308-4399-a561-a34cd12de0c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3287ffd8-7f38-a3da-c04d-232ca9c5da01",
          "attributeId": "b7275b5e-c4b4-4296-966d-91216131561f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d8d404cf-819c-e856-3cee-58a956982862",
          "attributeId": "e34c36c7-e5e7-4212-8feb-380d7feb5d48",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "592af51c-57f8-d328-4a0b-40eae472aff9",
          "attributeId": "6d833d65-ad3f-4d20-a64d-60e913572f0e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6182e72e-b921-ee6d-f4a4-b80bc7dfb5fa",
          "attributeId": "54a852ab-6ef1-4b5e-9780-c4cf2a8339af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae5d7a7d-b38f-d9c8-6e81-88aa759f07d4",
          "attributeId": "a895859f-8c06-4515-9803-ce31821119a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1ae290f-bd5c-5387-cf44-70eec5ea51a0",
          "attributeId": "f65f5cda-7d7e-403f-b7c9-84837c48cd0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b139332-1d81-cc9f-a0bd-23d7d65277c8",
          "attributeId": "debe95cb-f26f-44f5-b9f0-268dd244468b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfa16bb3-4e81-ff85-c4f6-fe864926638b",
          "attributeId": "fb81a1fb-fa8a-4264-ab16-3c30cd9c3927",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a3d05474-440a-188e-8d39-3142e5a4fba0",
          "attributeId": "3085136b-f4ce-4790-8dea-bb2fee94de7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eeb8673f-cff7-6087-38ba-35a47bd7c740",
          "attributeId": "7565471d-898d-4f6b-83b8-70fa86343d4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "389ba6ae-a81e-155d-f797-bb8a5fb898eb",
          "attributeId": "b68d3ba2-f9c8-4697-8c0f-a71d8868f86a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2df7de33-37a9-6065-3592-00e830c7f31b",
          "attributeId": "9d07044c-e991-4f1a-816b-a5a2f879bf62",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "771d41fa-33b0-4745-8fc7-e9a9d60207b4",
          "attributeId": "48441dc8-4895-4df4-8f48-7358ad18cd97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a28f9da0-e40c-3531-e96d-8883e5ec8cd5",
          "attributeId": "fa07f472-dc63-4b47-b611-7bad7624387a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e46c4f1e-95d2-533e-8550-a77543efdef8",
          "attributeId": "51684962-8fa3-4964-bc2a-bc8fd2128baf",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_3_totalcount"
    },
    {
      "id": "70a597e0-2a98-67c3-58e7-c93905178502",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "gridDeployments",
      "dataMap": [
        {
          "id": "f94e1f28-9edd-3723-5420-3fad8d0757ff",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fa5bc6a4-d3ba-e4c5-cfeb-8eb498c6c89a",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "59c80845-b598-c4f1-e872-3217a14a4694",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1bddbab9-501c-cf15-f06d-ff2388220c85",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d8e3393-f577-1216-0663-8107dd32e933",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76938a99-3554-6185-83de-e0f3c2e9c456",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a07cefc8-e148-f2f6-ecc0-8a4e70633ef2",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a417dfbb-525c-e217-b478-897761e735af",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2537ffd2-371c-0ec3-090f-6936c1c1b720",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c6201e1e-f836-76f5-7197-50c911d301de",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ccc85c1b-e319-1af1-c225-992ee107a8e8",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "31c3fb47-3fb4-5994-e58a-6693b21b6d1d",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b77751e-0e66-8432-e1a4-2b99d3024bfe",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5d07b717-67ee-8a9a-bf2a-f90728fba4b7",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "9cae761d-d751-e2b0-6e86-2abf4eac8802",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "94de1ac0-ca93-95b0-52e9-42809d3bc279",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8f1727b5-ed2b-db71-31b2-8669d957c354",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3bae1a86-f38b-fff5-0c61-43183c25420e",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4aadcdf5-aeba-1a77-ecee-71aa28f0c895",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "31e61707-017b-e415-7011-68ac9376a5a4",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "872d8a3a-3719-2d0d-bcae-7fd3123e3a27",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d529500f-091f-7423-89b8-fa023dba022f",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4b85193f-0da8-0aee-dada-e77b4839f2ff",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e899d008-4184-a452-27f7-505f80d33e2b",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "715df851-974a-19af-6e97-65377fee7a0e",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a7070ce1-d4a7-2ca9-494e-f3df528f574e",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3200d237-795f-cc78-8a0b-1b1141a49a8f",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52a7e1bf-a22c-8988-359f-40cf5d7edc51",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8292c82d-bbec-8231-6075-6929a09aec4f",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "613b8244-8d92-c31a-1d55-c8a1c893f2ec",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d1e93282-d39b-f79d-b664-72ee4d6c333a",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fb4dd01f-6c7a-1cf8-b0a7-40091bd30db8",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "07d24d12-fe84-fbdb-828a-1c8a667b95b1",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "222a905f-60ab-d52d-b210-8bf2d8098611",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4f3383b1-c35b-e208-7b1c-4d853f808372",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "53791dff-cdb3-2a45-b02b-429e4d90cc43",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "53275c6e-f870-2daf-c1d3-ed123a03b6d4",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e645755b-29f5-d117-263d-087f8699a20f",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "887e611a-456e-ab03-76ee-74bf4b6828c4",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "bc4977c9-a175-a3fb-6431-f065b54b4f5b",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c8a31e73-7d79-5a8a-1d37-50fbddd8770b",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "61f79adc-c491-37c3-9eb8-6d2b1088c999",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "09524c23-4759-c60c-585f-41d2b032c618",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b6733898-921b-d8bc-c8fd-9afa42238f89",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4907d9c9-6aaa-f793-0f23-3ffbe9d71e86",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5d11bf80-11dc-5e82-8134-d4dd3e987fd5",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0fe79b84-1ed0-22e2-b4f3-2864821697db",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "479f4c36-752d-eede-de4e-ed8737e2d253",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c88fad57-ece2-e97c-4031-43a446ca7d05",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "202d264c-d444-7bbf-4f44-4da50653ef99",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d24e4f2c-3341-4761-1d56-0be5bcfaa0c1",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b911abf3-34fd-d05d-6979-9c4a6ba04ba3",
          "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72553aec-e618-9829-73ca-4a5ca9b19a01",
          "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52c78cb1-8286-d5ca-9677-51a5b451f844",
          "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2724e8be-35d5-2f84-6b99-abf9d5429e63",
          "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4efadf93-8313-a040-47b7-9b322cb7e263",
          "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62e4012d-6ab0-ba55-55a7-d980341e6214",
          "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d74b0e00-8107-8b79-62a1-c2ac9620e30d",
          "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07148985-e477-f8af-ed5b-f26b1513f359",
          "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "85efc261-34ce-4639-e6da-6766ba16b3d8",
          "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d50e2785-be51-aafd-1d57-0042c798d336",
          "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "55359f47-289e-46b1-0d8b-6e091c38da1a",
          "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e79d9129-8057-5f01-f134-f42cb9fdea00",
          "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c309f5e3-bf5f-29ac-d16e-81d7a7601653",
          "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0289ce75-1f44-5c6e-2880-ed8cb953548e",
          "attributeId": "0a7f52c0-02ed-4729-8617-5c26d4fb989b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01875e39-4e14-ac51-1fb1-73b16a01d5db",
          "attributeId": "f69ae006-6ffe-4389-a7b5-777afd6a8776",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__gridDeployments_totalcount"
    }
  ],
  "securityGroup": "Questionnaire",
  "isArchived": false
}' WHERE [Id]='27dbfadb-0e83-4acd-af28-35a760e3239b';

UPDATE [dwMetadata] SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:12:28.483', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cntDeploymentTitle",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left",
            "subheader": ""
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_23",
        "data-buildertype": "container",
        "children": [
          {
            "key": "workflowbar_1",
            "data-buildertype": "workflowbar",
            "events": {
              "onCommandClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowExecuteCommand",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              },
              "onSetStateClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowSetState",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "blockSetState": true,
            "other-visibleConition": ""
          },
          {
            "key": "container_21",
            "data-buildertype": "container",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<strong>State:</strong> {StateName}",
                "isHtml": true
              }
            ]
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "Remarks",
                "data-buildertype": "textarea",
                "label": "",
                "fluid": true,
                "style-width": "",
                "reference": "Remarks",
                "events": {},
                "placeholder": "Please append your remarks",
                "style-customcss": "ui fluid input",
                "other-required": false
              }
            ]
          },
          {
            "key": "formgroup_9",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": []
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "other-visibleConition": "data.Id && data.EnableWorkflow"
      },
      {
        "key": "cnt_buttons",
        "data-buildertype": "container",
        "style-float": "",
        "children": [
          {
            "key": "cntImportModal",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnDataEditor",
                "data-buildertype": "button",
                "content": "Editor",
                "secondary": true,
                "floated": "",
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
                        "value": "DataEditorDeployment"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id && CloverApp.API.checkRole(\"DataEditor\")",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "btnMaintenance",
                "data-buildertype": "button",
                "content": "Maintenance",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyMaintenance"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-marginLeft": "",
            "other-visibleConition": "",
            "style-source": "text-align: right;",
            "style-width": "100%"
          },
          {
            "key": "container_8",
            "data-buildertype": "container",
            "children": [
              {
                "key": "buttonResponseQuotas",
                "data-buildertype": "button",
                "content": "Manage Response Quotas",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyResponseQuota"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "btnManageSnapshot",
                "data-buildertype": "button",
                "content": "Manage Report Snapshot",
                "secondary": true,
                "floated": "",
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
                        "value": "dplySnapshot"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "btnManageScheduledExport",
                "data-buildertype": "button",
                "content": "Manage Scheduled Export",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyScheduledExport"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
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
                },
                "floated": "",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
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
                },
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-marginLeft": "",
            "style-marginRight": "",
            "events": {},
            "style-width": "100%",
            "style-source": "text-align: right;",
            "style-marginTop": ""
          },
          {
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnManageRecurringDeployments",
                "data-buildertype": "button",
                "content": "Manage Recurring Deployments",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyRecurrence"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "button_5",
                "data-buildertype": "button",
                "content": "Manage Validation Data",
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
                        "value": "dplyValidation"
                      }
                    ]
                  }
                },
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "buttonManagePrePopulate",
                "data-buildertype": "button",
                "content": "Pre-Populate Response",
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
                        "value": "QNN_DPLY_PRE_POPULATE"
                      }
                    ]
                  }
                },
                "secondary": true,
                "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'') ",
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px",
                "other-readOnlyConition": "data.IsMultipleResponse || data.IsAnonymous"
              },
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
                "other-visibleConition": "data.Id!=null",
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-width": "100%",
            "style-marginTop": "",
            "style-source": "text-align: right;"
          }
        ],
        "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;\nbackground-image: linear-gradient(#f0f0f0, #f8f8f8);",
        "style-marginBottom": "",
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-width": "100%",
    "style-float": "right"
  },
  {
    "key": "cnt_clearBoth",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-width": "100%"
  },
  {
    "key": "cntMainContainer",
    "data-buildertype": "container",
    "children": [
      {
        "key": "MainForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "cntBasicProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerBasicProperties",
                "data-buildertype": "header",
                "content": "Basic Properties",
                "size": "medium"
              },
              {
                "key": "formgroup_BasicPropertiesMain",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "textName",
                    "data-buildertype": "input",
                    "label": "Deployment Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Deployment Name",
                    "other-visibleConition": ""
                  },
                  {
                    "key": "SurveyName",
                    "data-buildertype": "input",
                    "label": "Displayed Survey Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Survey Name"
                  },
                  {
                    "key": "Description",
                    "data-buildertype": "textarea",
                    "label": "Description",
                    "fluid": true
                  },
                  {
                    "key": "staticcontent_7",
                    "data-buildertype": "staticcontent",
                    "content": "Tags",
                    "isHtml": true,
                    "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                    "style-marginBottom": "4px"
                  },
                  {
                    "key": "divActiveTags",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "mdlTag",
                        "data-buildertype": "swzmodal",
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "openTagsModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-display": "none",
                        "size": "tiny",
                        "secondary": true,
                        "children": [
                          {
                            "key": "header_7",
                            "data-buildertype": "header",
                            "content": "Add/Remove Tags",
                            "size": "medium"
                          },
                          {
                            "key": "message_1",
                            "data-buildertype": "message",
                            "header": "",
                            "content": "Add a custom tag by typing in the Tags",
                            "negative": false,
                            "info": true
                          },
                          {
                            "key": "staticcontent_9",
                            "data-buildertype": "staticcontent",
                            "content": "Tags",
                            "isHtml": true,
                            "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                            "style-marginBottom": "4px"
                          },
                          {
                            "key": "ddTags",
                            "data-buildertype": "dropdown",
                            "label": "",
                            "fluid": true,
                            "selection": true,
                            "data-elements": [],
                            "placeholder": "Type and add tag here",
                            "multiple": true,
                            "search": true,
                            "readOnly": false,
                            "allowAddItems": true,
                            "disabled": false,
                            "events": {},
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "divTagsSearchResult",
                            "data-buildertype": "container",
                            "style-marginTop": "",
                            "style-marginBottom": "10px",
                            "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                            "children": [
                              {
                                "key": "formgroup_3",
                                "data-buildertype": "formgroup",
                                "widths": "equal",
                                "children": [
                                  {
                                    "key": "staticcontent_8",
                                    "data-buildertype": "staticcontent",
                                    "content": "Search For Tags",
                                    "isHtml": true,
                                    "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                                    "style-marginBottom": "4px"
                                  },
                                  {
                                    "key": "TagsSearch",
                                    "data-buildertype": "input",
                                    "label": "",
                                    "fluid": false,
                                    "onChangeTimeout": 200,
                                    "events": {
                                      "onChange": {
                                        "active": true,
                                        "actions": [
                                          "searchTagsInDB"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "placeholder": "Search Tags..."
                                  }
                                ],
                                "orientation": "grouped"
                              },
                              {
                                "key": "staticcontent_10",
                                "data-buildertype": "staticcontent",
                                "content": "<hr>",
                                "isHtml": true,
                                "style-marginTop": "10px",
                                "style-marginBottom": "10px",
                                "events": {}
                              }
                            ],
                            "style-height": ""
                          },
                          {
                            "key": "container_3",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "btnTagsSave",
                                "data-buildertype": "button",
                                "content": "Save",
                                "floated": "",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "saveActiveTags"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_2",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "floated": "",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeTagsModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "left",
                            "style-marginTop": "30px",
                            "style-marginBottom": "20px"
                          }
                        ],
                        "content": "Add/Remove Tags",
                        "style-source": "",
                        "compact": true,
                        "style-marginBottom": ""
                      },
                      {
                        "key": "staticcontent_6",
                        "data-buildertype": "staticcontent",
                        "content": "<hr>",
                        "isHtml": true,
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px",
                        "events": {}
                      }
                    ],
                    "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;"
                  },
                  {
                    "key": "dictQuestionnaire",
                    "data-buildertype": "dictionary",
                    "label": "Form Properties (Questionnaire) ~",
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
                    "placeholder": "Select a form properties...",
                    "other-required": true,
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "reference": "Form Properties",
                    "filters": "[{ column : \"IsArchived\" , value : \"0\" , term : \"=\" }]"
                  },
                  {
                    "key": "dictList",
                    "data-buildertype": "dictionary",
                    "label": "Sample List ~",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_LIST",
                    "columns": "Name ASC",
                    "search": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "validateSampleList"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "placeholder": "Select a sample list...",
                    "other-required": true,
                    "style-source": "",
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "other-visibleConition": "",
                    "reference": "Sample List",
                    "filters": "[{ column : \"IsArchived\" , value : \"0\" , term : \"=\" }]"
                  },
                  {
                    "key": "textApiIdentifier",
                    "data-buildertype": "input",
                    "label": "Api Identifier",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": false,
                    "events": {},
                    "reference": "Api Identifier",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "events": {},
                "style-source": "clear:both;"
              }
            ],
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "cntResponseProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerResponseProperties",
                "data-buildertype": "header",
                "content": "Response Properties",
                "size": "medium"
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
                    "style-source": "z-index: 1000;",
                    "style-marginLeft": "32px",
                    "other-readOnlyConition": "",
                    "other-required": true
                  },
                  {
                    "key": "DateEnd",
                    "data-buildertype": "input",
                    "label": "End On",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime",
                    "other-readOnlyConition": "",
                    "other-required": true,
                    "style-source": "z-index: 1000;"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_5",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "VisibleToRespondent",
                    "data-buildertype": "checkbox",
                    "label": "Visible to Respondent",
                    "defaultValue": "True",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "slider": false,
                    "fitted": false
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "style-source": "",
                "orientation": "grouped"
              },
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "MaxResponse",
                    "data-buildertype": "input",
                    "label": "Overall Maximum Number of Responses (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "defaultValue": "-1",
                    "events": {},
                    "style-width": "10em",
                    "reference": "Overall Maximum Number of Responses",
                    "other-readOnlyConition": "",
                    "other-customValidation": "(/^-?\\d+$/.test(value)) ? value >= -1 ? true: ''must be -1, 0 or positive number'' : ''must be whole number''"
                  },
                  {
                    "key": "DaysUpdate",
                    "data-buildertype": "input",
                    "label": "Days for Update after Submission (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "defaultValue": "0",
                    "events": {},
                    "style-width": "10em",
                    "reference": "Days for Update",
                    "other-readOnlyConition": "",
                    "other-customValidation": "(/^-?\\d+$/.test(value)) ? value >= -1 ? true: ''must be -1, 0 or positive number'' : ''must be whole number''"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "style-source": "",
                "orientation": "inline"
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "fg_RecurrenceInfo",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "This is a recurring deployment."
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Next Deployment Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": false,
                "readOnly": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3",
            "orientation": "grouped",
            "other-visibleConition": "data.RecurrenceEnabled"
          },
          {
            "key": "cntSurveyFeatures",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_6",
                "data-buildertype": "header",
                "content": "Survey Features",
                "size": "medium"
              },
              {
                "key": "formgroup_IsExcelEnabled",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsExcelEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Online Excel Support",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_RequireAccessCode",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "RequireAccessCode",
                    "data-buildertype": "checkbox",
                    "label": "Require Delegation Access Code",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_EnableWorkflow",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "EnableWorkflow",
                    "data-buildertype": "checkbox",
                    "label": "Use Workflow ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setDplyState",
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id",
                    "reference": "Enable Workflow"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_IsDirectAccess",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsDirectAccessEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Direct Access",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": ""
                  },
                  {
                    "key": "IsDirectAccessForComplete",
                    "data-buildertype": "checkbox",
                    "label": "Allow direct access after submission",
                    "other-visibleConition": "(data.IsDirectAccessEnabled==''1'') ? true : false"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)",
                "orientation": "grouped"
              },
              {
                "key": "formgroup_IsMultipleResponse",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsMultipleResponse",
                    "data-buildertype": "checkbox",
                    "label": "Allow Multiple Responses ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id || Utils.isSelected(data.IsAnonymous)"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)"
              },
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Anonymous Survey ~",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleAnonymousSurvey",
                      "updateFeatureInteraction",
                      "validateSampleList"
                    ],
                    "targets": [
                      "textCompleteURL"
                    ],
                    "parameters": []
                  }
                },
                "other-required": false,
                "style-width": "50%",
                "other-readOnlyConition": "data.Id"
              },
              {
                "key": "fgCompletionUrl",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "formgroup_IsAnonymous",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "events": {},
                    "children": [],
                    "style-width": "",
                    "widthsCustom": "3"
                  },
                  {
                    "key": "anonymousSurveyLink",
                    "data-buildertype": "staticcontent",
                    "content": "",
                    "isHtml": true,
                    "isPre": true,
                    "fetchData": true
                  },
                  {
                    "key": "textCompleteURL",
                    "data-buildertype": "input",
                    "label": "Completion URL (Leave blank if there is no completion URL)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "placeholder": "https://example.com",
                    "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                    "events": {},
                    "style-marginLeft": "",
                    "other-customValidation": "",
                    "style-width": "",
                    "reference": "Completion URL"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "orientation": "grouped"
              },
              {
                "key": "formgroup_IsExposeListProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "IsExposeListProperties",
                    "data-buildertype": "checkbox",
                    "label": "Expose List Sample Properties to Form",
                    "toggle": true,
                    "defaultValue": "0"
                  }
                ]
              },
              {
                "key": "formgroup_IsIncludeUnansweredSection",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "IsIncludeUnansweredSection",
                    "data-buildertype": "checkbox",
                    "label": "Allow Respondents to Export Unanswered Sections",
                    "toggle": true,
                    "defaultValue": "",
                    "events": {}
                  }
                ]
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "<i>(Above options marked with <strong>~</strong> may only be selected before creating the deployment and cannot be enabled later)</i>",
                "isHtml": true
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
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
                "key": "textCompleteURL-3",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
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
            "key": "cntRestrictionProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Restriction Properties",
                "size": "medium",
                "style-marginTop": "",
                "style-marginBottom": ""
              },
              {
                "key": "RestrictIp",
                "data-buildertype": "checkbox",
                "label": "IP Restriction",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setIpRestriction"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "reference": "Ip Restriction",
                "style-marginBottom": "20px",
                "defaultValue": "0"
              },
              {
                "key": "RestrictIpInclusive",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Inclusive",
                    "value": "1"
                  },
                  {
                    "value": "0",
                    "text": "Exclusive"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
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
                "key": "countryOrIpRange",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Countries",
                    "value": "1"
                  },
                  {
                    "text": "IP Ranges",
                    "value": "0"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "clearContent"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "IpCountry",
                "data-buildertype": "dropdown",
                "label": "IpCountry",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "SG",
                    "text": "Singapore"
                  },
                  {
                    "value": "MY",
                    "text": "Malaysia"
                  }
                ],
                "multiple": true,
                "reference": "Respondent Country",
                "placeholder": "Select countries",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
                "events": {}
              },
              {
                "key": "IpRange",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": true,
                "selection": true,
                "data-elements": [],
                "multiple": true,
                "search": true,
                "allowAddItems": true,
                "reference": "Ip Ranges",
                "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "cntInitialNotification",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<i>(Initial notification will be sent to all samples in the selected Sample List when the deployment is created)</i>",
                "isHtml": true
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
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
                      }
                    ],
                    "events": {
                      "onItemClick": {
                        "active": true,
                        "actions": [
                          "downloadEmailTemplate"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ],
                "style-marginTop": "20px"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "",
                    "reference": "Email From",
                    "events": {}
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email Subject"
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
                    },
                    "other-customValidation": ""
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "events": {}
          }
        ],
        "style-source": ""
      },
      {
        "key": "cntInfoBeforeCreating",
        "data-buildertype": "container",
        "style-marginBottom": "20p",
        "style-source": "",
        "style-customcss": "ui info message",
        "children": [
          {
            "key": "staticcontent_5",
            "data-buildertype": "staticcontent",
            "content": "<i>(After creating the deployment you can perform additional deployment management functions such as assigning data editors, configuring recurrence settings, setting snapshot report options, performing pre-population, etc)</i>",
            "isHtml": true,
            "fetchData": false
          }
        ],
        "other-visibleConition": "(data.Id?false:true)"
      }
    ],
    "style-float": "",
    "style-width": "100%",
    "style-source": "",
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnFirstSave",
        "data-buildertype": "button",
        "content": "Create Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "confirm",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "createDplyConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "createDplyConfirmText"
              }
            ]
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?false:true)",
        "other-customValidation": ""
      },
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Update Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?true:false)",
        "other-customValidation": ""
      },
      {
        "key": "button_3",
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
                "value": "/form/SwzDplyList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]' WHERE [Id]='655275cf-8202-4438-b66b-874eab315889';

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:12:28.630', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2025-11-24T17:12:28.6309653+08:00",
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
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnDplyTrigger"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InitDplyAsync"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
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
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "020f9a28-e54d-750b-cb60-045ce9ed0c05",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "control": "SurveyName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b17a499b-7d84-0cc9-96d2-58795c553378",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfa65cde-ed69-b522-cae6-f91eccaa1dad",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b8cd14dc-2364-8ef6-2230-c18d9d9f2dc2",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "control": "textApiIdentifier",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb4bde3f-4a8a-c6ae-c6ae-b88664a83f9f",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "control": "IsExposeListProperties",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "729f2391-b64a-5198-beb1-947ec62f6f16",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "control": "IsDirectAccessEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5ed2dad-6f5b-d741-a5e9-d94f9b0d242e",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "control": "IsDirectAccessForComplete",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae906195-d1ed-a375-9361-17acb9d583e5",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b5055ae0-b053-d0fb-9b26-f25cbfa2f260",
      "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d34bf8b4-67e6-fbf7-866c-e78c6837446d",
      "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "34a10252-2496-fd24-9542-65b267e04006",
      "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "3733f215-f60f-d464-dd7f-0f36b0177fef",
      "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "243b71ba-e853-c2df-c929-dd492ef949ae",
      "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "639c75d6-ac90-3e71-2815-896547eb0f47",
      "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "8cf795ce-2e5f-8ab5-a3c8-ad4d6fcb469a",
      "attributeId": "0a7f52c0-02ed-4729-8617-5c26d4fb989b",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2cdd57aa-d513-a262-9fc8-736cbdb0214e",
      "attributeId": "f69ae006-6ffe-4389-a7b5-777afd6a8776",
      "control": "IsIncludeUnansweredSection",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment",
  "isArchived": false
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

UPDATE [dwMetadata] SET
[Id]='715ce353-26d4-4c0f-8b65-57db2da22232', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:10:15.257', 
[Data]=N'[
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "headerName",
        "data-buildertype": "header",
        "content": "Sample List",
        "size": "large",
        "subheader": "",
        "style-marginTop": "",
        "style-marginLeft": "",
        "style-source": "",
        "style-width": "300px",
        "events": {},
        "style-customcss": ""
      }
    ],
    "style-source": "",
    "style-marginTop": "",
    "style-marginBottom": "20px",
    "style-marginLeft": "",
    "style-float": "",
    "style-width": "",
    "style-customcss": ""
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
            "key": "container_26",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "headerProperties",
                "data-buildertype": "header",
                "content": "Basic Properties",
                "size": "medium"
              },
              {
                "key": "container_28",
                "data-buildertype": "container",
                "style-source": "clear:both;",
                "style-height": "",
                "children": []
              },
              {
                "key": "formgroup_5",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "nameInput",
                    "data-buildertype": "input",
                    "label": "Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "text",
                    "readOnly": false,
                    "events": {},
                    "labelPosition": "",
                    "style-width": "",
                    "other-required": true,
                    "reference": "Name"
                  },
                  {
                    "key": "headerDescription",
                    "data-buildertype": "textarea",
                    "label": "Description",
                    "fluid": true,
                    "other-required": false,
                    "events": {}
                  }
                ],
                "orientation": "grouped"
              },
              {
                "key": "formgroup_7",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": []
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "Tags",
                "isHtml": true,
                "style-marginBottom": "4px",
                "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
              },
              {
                "key": "divActiveTags",
                "data-buildertype": "container",
                "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;",
                "events": {},
                "children": [
                  {
                    "key": "mdlTag",
                    "data-buildertype": "swzmodal",
                    "content": "Add/Remove Tags",
                    "compact": true,
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "openTagsModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "children": [
                      {
                        "key": "header_4",
                        "data-buildertype": "header",
                        "content": "Add/Remove Tags",
                        "size": "medium"
                      },
                      {
                        "key": "message_1",
                        "data-buildertype": "message",
                        "header": "",
                        "content": "Add a custom tag by typing in the Tags",
                        "info": true
                      },
                      {
                        "key": "staticcontent_5",
                        "data-buildertype": "staticcontent",
                        "content": "Tags",
                        "isHtml": true,
                        "style-marginBottom": "4px",
                        "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                      },
                      {
                        "key": "ddTags",
                        "data-buildertype": "dropdown",
                        "label": "",
                        "fluid": true,
                        "selection": true,
                        "data-elements": [],
                        "placeholder": "Type and add tag here",
                        "search": true,
                        "multiple": true,
                        "allowAddItems": true,
                        "style-marginBottom": "20px",
                        "events": {}
                      },
                      {
                        "key": "divTagsSearchResult",
                        "data-buildertype": "container",
                        "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                        "style-marginBottom": "10px",
                        "events": {},
                        "children": [
                          {
                            "key": "formgroup_10",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "orientation": "grouped",
                            "children": [
                              {
                                "key": "staticcontent_6",
                                "data-buildertype": "staticcontent",
                                "content": "Search For Tags",
                                "isHtml": true,
                                "style-marginBottom": "4px",
                                "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                              },
                              {
                                "key": "TagsSearch",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": false,
                                "onChangeTimeout": 200,
                                "placeholder": "Search Tags...",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "searchTagsInDB"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "staticcontent_7",
                            "data-buildertype": "staticcontent",
                            "content": "<hr>",
                            "isHtml": true,
                            "style-marginBottom": "10px",
                            "style-source": "",
                            "style-marginTop": "10px"
                          }
                        ]
                      },
                      {
                        "key": "container_24",
                        "data-buildertype": "container",
                        "style-float": "left",
                        "style-marginTop": "30px",
                        "style-marginBottom": "20px",
                        "children": [
                          {
                            "key": "btnTagsSave",
                            "data-buildertype": "button",
                            "content": "Save",
                            "primary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "saveActiveTags"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            }
                          },
                          {
                            "key": "button_2",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeTagsModal"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "secondary": true
                          }
                        ]
                      }
                    ],
                    "size": "tiny",
                    "style-display": "none",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  },
                  {
                    "key": "staticcontent_4",
                    "data-buildertype": "staticcontent",
                    "content": "<hr>",
                    "isHtml": true,
                    "style-marginBottom": "10px",
                    "style-source": "",
                    "style-marginTop": "10px"
                  }
                ],
                "style-marginTop": "",
                "style-marginBottom": "15px"
              },
              {
                "key": "formgroup_4",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
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
                ],
                "style-marginTop": "15px"
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
              },
              {
                "key": "formgroup_11",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "Archived",
                    "data-buildertype": "checkbox",
                    "label": "Archived",
                    "toggle": true,
                    "events": {},
                    "style-width": "300px"
                  }
                ]
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
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
                    "style-width": "100%",
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
                    "other-visibleConition": "",
                    "style-hidden": true
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
                "style-source": "",
                "style-width": "100%",
                "style-marginTop": "10px"
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
            "key": "header_2",
            "data-buildertype": "header",
            "content": "List Sample Properties",
            "size": "medium"
          },
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
            "header": false,
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
        "style-customcss": "",
        "style-width": "100%",
        "style-source": "padding: 10px;\nborder: 1px solid rgba(34,36,38,.15);",
        "style-hidden": false,
        "other-visibleConition": "",
        "style-float": "left",
        "style-marginBottom": "20px"
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
                  "save"
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
        "style-float": "left",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": "",
    "style-marginBottom": ""
  },
  {
    "key": "cnt_visuallyDivideMasterAndDetail",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<br/>\n<br/>\n<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null",
    "style-marginTop": ""
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
                "size": "medium",
                "subheader": "Samples in this list"
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
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDisable",
                    "data-buildertype": "button",
                    "content": "Disable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "toggleListSamplesActive"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "disableSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "disableSamplesConfirmText"
                          },
                          {
                            "name": "action",
                            "value": "disable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  },
                  {
                    "key": "btnEnable",
                    "data-buildertype": "button",
                    "content": "Enable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "toggleListSamplesActive"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "action",
                            "value": "enable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_22",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDeleteSample",
                    "data-buildertype": "button",
                    "content": "Delete Samples & Data",
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
                            "value": "deleteListSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteListSamplesConfirmText"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "formImportList",
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
                                "content": "Import Samples from CSV",
                                "size": "small",
                                "subheader": ""
                              }
                            ]
                          },
                          {
                            "key": "inputPassword",
                            "data-buildertype": "input",
                            "label": "Password for new or password_reset samples (optional)",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "text",
                            "style-width": "200px"
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
                                    "active": false,
                                    "actions": [],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
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
                                      "importSamples"
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
                                      "closeImportModal"
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
                      },
                      {
                        "key": "sampleListImportHeader",
                        "data-buildertype": "header",
                        "content": "Sample List Import Complete",
                        "size": "large",
                        "events": {},
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-hidden": true,
                        "textAlign": "left"
                      },
                      {
                        "key": "importSummaryStatic",
                        "data-buildertype": "staticcontent",
                        "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Updated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleUpdated}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
                        "isHtml": true,
                        "style-font-size": "15px",
                        "style-hidden": true,
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "events": {}
                      },
                      {
                        "key": "containerInvalidDetails",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Invalid Rows Detail",
                            "size": "medium",
                            "other-visibleConition": ""
                          },
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "formgroup_1",
                                "data-buildertype": "formgroup",
                                "widths": "equal",
                                "orientation": "grouped",
                                "children": [
                                  {
                                    "key": "container_3",
                                    "data-buildertype": "container",
                                    "style-float": "",
                                    "children": [
                                      {
                                        "key": "invalidRowsDetail",
                                        "data-buildertype": "collectioneditor",
                                        "idField": "Id",
                                        "parentIdField": "ParentId",
                                        "columns": [
                                          {
                                            "key": "RowNo",
                                            "name": "Row No",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrField",
                                            "name": "Field",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrMsg",
                                            "name": "Error Message",
                                            "control": "span",
                                            "width": ""
                                          }
                                        ],
                                        "disableAdd": false,
                                        "disableDelete": false,
                                        "other-visibleConition": "",
                                        "header": false,
                                        "headerTitle": "Pre-Populate Fields",
                                        "events": {},
                                        "readOnly": true
                                      }
                                    ],
                                    "style-width": "",
                                    "style-marginBottom": "",
                                    "events": {},
                                    "other-visibleConition": "",
                                    "style-customcss": "",
                                    "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;",
                                    "style-marginTop": ""
                                  }
                                ],
                                "events": {}
                              }
                            ]
                          }
                        ],
                        "style-source": "",
                        "style-customcss": "ui negative message",
                        "style-float": "",
                        "style-width": "",
                        "other-visibleConition": "(data.invalidRowsDetail!= undefined || data.invalidRowsDetail!= null)",
                        "events": {},
                        "style-hidden": true
                      },
                      {
                        "key": "btnImportClose",
                        "data-buildertype": "button",
                        "content": "Close",
                        "style-customcss": "",
                        "primary": false,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-source": "float: right;",
                        "style-hidden": true,
                        "style-marginBottom": "20px",
                        "secondary": true
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
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-marginRight": ""
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "btnExportSamples",
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
                "key": "container_25",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnRefresh",
                    "data-buildertype": "button",
                    "content": "Refresh",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "",
                    "secondary": true
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "inputSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "300px",
                "size": "",
                "labelPosition": "",
                "style-source": "float: left;",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridviewSample"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "Name, UID"
                      }
                    ]
                  }
                },
                "placeholder": "Search by Name or UID"
              }
            ],
            "style-width": "100%",
            "style-float": "",
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
        "resizable": true,
        "width": ""
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "ListSampleActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "ToEmails",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "CcEmails",
        "name": "CC Emails",
        "sortable": true,
        "filterable": false,
        "resizable": true
      }
    ],
    "autoHeight": false,
    "offSet": "",
    "multiselect": true,
    "rowKey": "Id",
    "defaultSort": "UID ASC",
    "events": {
      "onRowClick": {
        "active": false,
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
    "style-hidden": false,
    "rowHeight": "80",
    "pageSize": "384",
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "container_20",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null",
    "style-marginTop": "20px"
  },
  {
    "key": "container_23",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Deployments using this Sample List",
        "size": "small",
        "textAlign": "left"
      },
      {
        "key": "gridDeployments",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "Name",
            "name": "Deployment",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SurveyName",
            "name": "Survey",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CategoryName",
            "name": "Category",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CreatedDate",
            "name": "Created",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DateStart",
            "name": "Start",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DateEnd",
            "name": "End",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          }
        ],
        "editForm": "QNN_DPLY",
        "rowKey": "Id",
        "pageSize": "50",
        "defaultSort": "Name ASC",
        "rowHeight": "80",
        "events": {
          "onRowDblClick": {
            "active": true,
            "actions": [
              "gridEdit"
            ],
            "targets": [],
            "parameters": []
          }
        }
      }
    ],
    "other-visibleConition": "(data.Id  && CloverApp.API.checkRole(''SurveyAdmin'') ) ? true : false"
  }
]' WHERE [Id]='715ce353-26d4-4c0f-8b65-57db2da22232';

UPDATE [dwMetadata] SET
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-24 17:11:22.733', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2025-11-24T17:11:22.7164845+08:00",
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
      "id": "5194d452-7552-b246-c734-b81f51c9921e",
      "attributeId": "eba31ce9-8aea-467e-a463-4ed7ba17131b",
      "control": "TrkListIds",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a6cf905-666e-ea96-3dc7-ea414625f144",
      "attributeId": "727c6358-fea5-49ed-9099-2762644973fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78ab618d-da6e-8fd3-8584-bb898d8acf8e",
      "attributeId": "bf05e1dc-1d8d-4dd2-969c-c199798a1c93",
      "control": "Archived",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "6cf82f70-64e4-4494-b02b-82806ea7c26e",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "81789810-9928-2fd3-bad0-fa54dfae9227",
          "attributeId": "8cccf6c3-0226-48a3-a998-da0e36c4daf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19b7bc15-60ca-0552-7ffb-f99ca0f979a2",
          "attributeId": "8483bf15-ff56-49e2-96e1-c9bc94be1938",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc0643f8-c16f-9c44-5a89-1b03699e8d54",
          "attributeId": "04ae0ae7-aa15-4fe4-9a9e-3da6b1011130",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "055e840f-5d2c-de43-f5ee-1aec3231946d",
          "attributeId": "0303ebaa-f136-4957-853e-52fb9dce9865",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1ccc22e-44f4-079b-e05f-33112d8a94c8",
          "attributeId": "f9357a1b-c839-42c1-a624-ee242454fcfc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27629011-2b07-85fb-2ac7-ea8fed5b3de2",
          "attributeId": "361ff056-f5e5-42e3-af19-804c08085e6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9b8b9fe-9ec1-7f75-8458-6d0b876a606f",
          "attributeId": "cf043f7d-e0bf-4cdf-a5f2-22e2cb362f82",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5b6d9ce-d349-4130-006a-ae105bb6e21b",
          "attributeId": "32553188-2535-4522-95b8-957279ba3ed1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6886368-d110-d7d8-bd6d-eb63bc7fd5ce",
          "attributeId": "8325f35d-ec44-4846-b129-0011d8b15cc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41d8d692-cfc7-1490-f59c-8a7d6ad738d4",
          "attributeId": "b5602ad5-e7a9-4659-a2d8-ee1b7b7a2bbf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "595a1068-fbb6-bc68-f3ab-ec868b11793e",
          "attributeId": "75e179e7-7731-46f4-9e62-eb27d6fe95aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1e9b043-7a8f-67e2-e1e3-fa6bbd773f49",
          "attributeId": "f25864f8-5967-4508-8fa8-3fbdbdeeff9b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "623faa61-93d5-e2a0-82ed-a90b0877bcb5",
          "attributeId": "38bfcb12-f658-4ce2-ab33-99e5c236435a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84770df3-3b00-da09-a7ce-6e8b51c01fb6",
          "attributeId": "f9743ce4-bd21-4aec-ae86-0bb6d7440190",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
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
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_1_totalcount"
    },
    {
      "id": "8161ebf5-8ee8-cfe0-f4e9-935018d59779",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridDeployments",
      "dataMap": [
        {
          "id": "7eb438a5-8378-c552-f483-616b4c93c22e",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "80ff6f67-e35c-616d-d105-fce77104b780",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f691ddf4-f53b-f6fc-c2b0-e71dea6f5a36",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b30ab47f-c182-941e-b0af-eced94413c75",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "874d2516-9167-54f8-0b10-ffb989851c2a",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b3c1aea5-7b04-5545-d228-0be1c415c664",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d171d52-707f-e394-f76e-9289a1ce2c6c",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "686f8437-cefd-20bd-c123-01990b71b0c7",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "df652069-f61c-6a16-4d7c-5117f50276df",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76751db7-b053-cda9-fe7c-caa2f473b806",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b58afbda-846a-45d2-9f41-fd8b781d4d2c",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "539bd40b-09f3-d46e-aee2-e1647d96c47a",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58c09ddf-88d3-41db-4c40-255b51d76bcd",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "324607f9-64a7-a4a2-867e-21a16bd48a30",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a61f3f0-17f8-5560-8aa1-226f00b0bfc0",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6ab9dd5a-70f4-b3d7-33fd-0d74b6fed431",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8ccce086-674d-d299-83aa-b9e0a31dca2c",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "07173d24-9a62-d3da-95a1-151bddcf650d",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "534bf5ba-27bf-ddd8-6bdd-5b3ec0a0c030",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17e8f3bf-d9b3-d76a-8bf9-8f5bccd5edb8",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98ba8faa-f5d7-5f66-fc28-123bfb82f447",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17eb14fc-b708-37ff-4d0c-4fbdb112a8a2",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e86db019-f90c-9e27-3b29-146c8e393b49",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3bb8be8f-61e1-840f-4e0c-6e2b0329c971",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "27a77db0-a3d0-ffb6-9258-c1c2074c9be7",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e80c78df-a127-2d8d-60bc-8fb646b952ac",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "38b7ccea-48b0-7c18-2c49-ff5a17580aa5",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e09c75b1-86fa-b386-86fb-4e14c7386e1c",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e63666a4-d893-e406-1ef0-b42decba3846",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f252bd0f-3337-42c8-0cef-a259957135c8",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d83b1629-fa64-5d96-a049-0ab2549d43aa",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62fdacb4-f875-b857-023c-3a8d48a39723",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "160429b3-b94d-3e59-7e4b-5dbb9468aabc",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2218a6b9-000b-acca-e751-274e2d688d8f",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3ca153e7-01d6-248c-3ba2-d7bec064177e",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b9ee09ac-8c87-2ed5-8c7b-e445fe3813e3",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "bd8ed4c3-1f81-67fc-1f70-9a6a83c517cc",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1c6a67fc-8d25-df17-58d8-4ab23ca9d466",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a1a16e9-7349-24b2-6932-7a3ae3378498",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1075e0b4-8efc-fbff-d5e1-044f438cd1e5",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "98228910-e68e-8b0c-ee11-809f3c8aa8d2",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e0201016-9f47-a707-765a-eae1b5e50471",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b46ac118-589a-de57-460a-e97b892b5d13",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a32c472-41aa-93d8-7209-750dd241db1a",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f2ac5885-3565-8174-86b2-e3b25ce3a03d",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f98e53fd-fbad-e205-9605-e1a1688df15a",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "961307f9-927e-47a6-c493-26e901f3b26a",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "eb6a51e2-c389-247f-61a5-9506bf94b2bd",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "417028e7-9314-bab9-d94a-2eeac101941b",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f0c8e82a-23c5-fa7f-3b46-f4ac728ab9e3",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e558c8e2-3ae0-2ee4-7716-874b83bb14a4",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "95689c4e-507b-d3ac-173f-a39fec264a6f",
          "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b137e4b-b2a1-ee47-2ae7-47b36e4c2dd9",
          "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1969361-f986-69b9-6382-3cb3bb2d4bb4",
          "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e565af0-2681-4106-90be-aa91f09842b9",
          "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "625db4ca-d2cb-e4ac-db61-0bf5e306b00a",
          "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b52aea0-1929-4c1d-57d3-ce5bffef8755",
          "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47a7f132-b61e-7b8d-fd39-0df8dbec78c7",
          "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7fc75bea-7cb5-f0bf-1cf8-b952ab36841a",
          "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5af97e36-994b-892e-ecbd-534bce6260c2",
          "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09e9f49f-6e80-7e02-7326-e603ce46e03f",
          "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e4710cc-795d-80c0-8d50-b4aec625ebbb",
          "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35579287-f8fd-d7b5-9f3c-92eb0e4c1de3",
          "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb313555-0420-ae7c-79e8-a8361edf96ee",
          "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c7e73c2-3349-b88d-cfab-5bcd186a821a",
          "attributeId": "0a7f52c0-02ed-4729-8617-5c26d4fb989b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "23cb8e6d-0553-af7f-a26e-e6b03738adab",
          "attributeId": "f69ae006-6ffe-4389-a7b5-777afd6a8776",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridDeployments_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

