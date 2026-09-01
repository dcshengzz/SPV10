-- Warning: this script will update metadata.json and forms. Please compare metadata.json and forms in swz-appbuilder-clover\DB\MSSQL\Forms folder with yours and merge if there are conflicts.

-- update the following metadata.json and forms:

-- metadata.json

-- DataEditorDeployment.json
-- DataEditorDeployment-code.js
-- DataEditorDeployment-settings.json

-- QNN_QNN.json
-- QNN_QNN-code.js
-- QNN_QNN-sttings.json

-- respdashboard.json
-- respdashboard-code.js
-- respdashboard-settings.json

UPDATE dbo.dwMetadata SET Folder = N'metadata', Filename = N'metadata.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:54:52.990', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 16:37:27.057', 120), Data = N'{
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
          "id": "0e896b55-a269-435e-88af-0d73eb6f337c",
          "name": "IsLocked",
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
      "id": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
      "name": "QNN_CATEGORY",
      "dbObjectName": "QNN_CATEGORY",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "6536ef8f-b9a1-4a7a-819b-35691537fefd",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a6250e06-4a48-43dc-81f7-4bbc9a80a0ea",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f0370aec-4608-46ef-998b-b115c3fe4ca4",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fa137602-163a-4f3e-9b78-980f5820a3a0",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "83f78020-12c8-430e-a030-a659dce0df30",
          "name": "Description",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "38bae30d-1d9f-4003-8850-b6c19fa2b565",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "2115d9aa-2765-4e15-bf55-9f67465f0270",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "69d19937-002d-45b7-b86f-73f63e918fd8",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0ba90a37-bdfa-447c-b463-70fabd946961",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "7f67d0c6-4bab-49e9-8270-12cfcc0b2f8b",
          "name": "ParentId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "ee2a1214-2e10-46c1-82da-c63bbf0c2718",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "94217f4c-c998-4900-9ee1-a6f6826113c3",
          "name": "UpdatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d78ebe9c-b194-490a-859a-18ecaa37f967",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "53fc33f5-3fab-487e-9569-170e34f28f09",
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
      "id": "bc6a6500-d844-4c69-a6b3-0ddecbca20a0",
      "name": "QNN_CATEGORY_ROLE",
      "dbObjectName": "QNN_CATEGORY_ROLE",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "3d2adef7-30df-4798-b0e5-862ed6143bb8",
          "referenceEntityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
          "name": "CategoryId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1ef735fb-050d-470d-bf84-4d315fd2029e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5a9f1560-ac75-4269-823c-b92b0a95510b",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "36ed163b-4f10-4e07-ac71-210e89c1f535",
          "referenceEntityId": "f9b358b7-a601-4f1d-8d92-2230f08a704d",
          "name": "RoleId",
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
      "id": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "name": "QNN_DPLY",
      "dbObjectName": "QNN_DPLY",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
          "referenceEntityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
          "name": "CategoryId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
          "id": "c25bbd26-a246-4904-9400-a34ee23930a3",
          "referenceEntityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
          "name": "CategoryId",
          "typeId": 1,
          "isNullable": true,
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
          "id": "c808a448-06a0-4c5f-869a-3eb2c0a6c903",
          "name": "Alias",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0d19ac69-83df-4a34-9dff-53382d296641",
          "referenceEntityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
          "name": "CategoryId",
          "typeId": 1,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
        }
      ],
      "primaryKeyAttribute": "Id",
      "logicalDeleteAttribute": "IsDeleted"
    },
    {
      "id": "c20a37ac-e637-4eae-9ca5-274455d6b83d",
      "name": "QNN_QNN_ENTITY",
      "dbObjectName": "QNN_QNN_ENTITY",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "d41c0520-6ec8-4b9d-b5da-7d9f280353d9",
          "name": "ContentType",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "632f1468-a0e6-4fcb-84a9-fa2c68b2b21f",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "6b26300b-3db8-436f-a603-32f6f37c3cbc",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "42f766b8-e59a-430d-aef0-e4d3f4e98d58",
          "name": "DeletedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c548f205-edc0-4259-b840-c2035fad11cf",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c21bc428-4ab6-4155-9864-1523bdddb6b8",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "11b29a33-078c-45a5-b0d4-73300202cde6",
          "name": "IsDeleted",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d74d725-aa3f-4485-ba71-12bc00593f8e",
          "name": "Language",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "705bedd0-90b0-4159-b2dc-2e5b167c85a1",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c0b2633-2d27-4a7a-800a-ddfd8d6530b9",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": true,
          "isExtension": false
        },
        {
          "id": "bbba0639-2151-47d2-beb3-4af1bfc14681",
          "referenceEntityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
          "name": "QnnId",
          "typeId": 1,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "193f1d40-696d-489c-a981-38e1d235d5b2",
          "name": "Remarks",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "be25d4ad-96b4-4da2-b52f-9182b24cd0ca",
          "name": "Size",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4d673305-fe74-4b52-8886-5dead4f6f0a4",
          "name": "Token",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "16445fab-034f-4f31-9571-e8d61363ae12",
          "name": "UpdatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "fcc4b9e5-b553-4d34-a673-3d174f6e7de9",
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
          "id": "0f8dc60e-7f8c-4cf8-9f45-4763e35f41d5",
          "name": "RespIp",
          "type": "String",
          "typeId": 0,
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
          "name": "IsImputed",
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
          "id": "b048ef0b-e83c-441b-8a37-bb9c186da00e",
          "name": "EmailBCC",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2f43f33-e402-4bf0-8240-406f330128ef",
          "name": "EmailCC",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "779bd4fc-f5be-48cb-8c5d-a9addab29e9c",
          "referenceEntityId": "5a613570-2b28-45f0-8be6-7be3393671b8",
          "name": "ForStatus",
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
          "id": "053fb919-cfaf-4f19-b47c-b0585d6253ea",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "5ffa2b46-39db-4bd3-be44-943c0df44779",
          "name": "PdfPassword",
          "type": "String",
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
          "id": "7ca7e192-f9c4-498e-98bc-eadb3c4fa697",
          "name": "UserId",
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
      "attributes": [
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
          "id": "f884abc5-1b1a-4079-9c5e-84d27d6d57f8",
          "name": "DeletedBy",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0dab5aa7-aca8-4214-a491-7afff520ad3c",
          "name": "DeletedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
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
      "attributes": [
        {
          "id": "07c8cf9b-89d5-4825-bb30-71e087e8b371",
          "name": "Category",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
          "id": "b57fb1aa-5502-418c-94cc-0365fbd5cbb0",
          "name": "CategoryId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
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
          "id": "3b27eb5c-9959-4243-b9da-9155a90d8a85",
          "name": "EmailBCC",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "82a1ea3e-7db2-4673-92cf-eca1c47db3c4",
          "name": "EmailCC",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
          "name": "Email",
          "type": "String",
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
          "id": "7cf8625b-4118-4801-bfa3-e97948989e72",
          "name": "CategoryId_Name",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
          "id": "cb449047-fd1f-4877-a9e8-31ff27e3522d",
          "name": "OfflineLanguages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "37e6a978-a4c0-401b-8541-c3d0185eaefc",
          "name": "Tokens",
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
          "id": "0eef5a8c-cfa7-4c9e-ab34-d3d7b45593bc",
          "name": "Email",
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
          "id": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "name": "OfflineLanguages",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "name": "PdfPassword",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "name": "RespDateEnd",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "name": "RespDateStart",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "name": "RespId",
          "type": "Guid",
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
          "id": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "name": "Tokens",
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
          "id": "9ec78af2-2a96-4af8-9416-a61b26920f90",
          "name": "Category",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
      "dbObjectName": "AuditLog",
      "schemaName": "",
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
      "dbObjectName": "vSP_auditlog",
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
          "id": "daea24d9-f131-4870-a3bc-750a0b033c03",
          "name": "LoginId",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
      "id": "d1249976-27b3-4abd-b138-e03cf063ad48",
      "name": "vSP_DeploymentQnnFields",
      "dbObjectName": "vSP_DeploymentQnnFields",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "81b7d605-665a-4c13-bef2-15435414629e",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "c1b8a417-b552-4ace-951d-3b0cd525bd3e",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "314622bd-f89e-4892-a194-4ed837b85a14",
          "name": "Name",
          "type": "String",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1ac802c7-0098-4de9-9740-57b4d96d86a6",
          "name": "NumberId",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "0cc5dfca-4fb6-4529-baf7-e5fedfdf9bcd",
          "name": "QnnId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f67d084e-482e-406a-b88e-2f0691498694",
          "name": "ReadOnly",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1c2d0a1c-0004-4368-9215-fa18273df409",
          "name": "Required",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "1edd43dd-458d-4c88-9a83-3092e73f5064",
          "name": "StructDivisionId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "f4cf97fa-ee21-4abc-99e3-ecd9db176110",
          "name": "Type",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "4be7c5bb-0ed9-4855-a8c9-4c352459cb14",
          "name": "ValidationErr",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "120d60ff-c8b1-46f8-9938-b39685dba2b3",
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
          "name": "IsImputed",
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
      "id": "34047cb7-ac66-4ae0-b682-ae4d01df08ba",
      "name": "vSP_DeploymentWithRespCompleteCount",
      "dbObjectName": "vSP_DeploymentWithRespCompleteCount",
      "schemaName": "",
      "triggers": [],
      "attributes": [
        {
          "id": "8bcb0d0c-f5af-440f-9266-82bce12e8cf2",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "8500fff2-73ae-4831-b43e-1c53453101b4",
          "name": "RespCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "3c167482-785c-46f8-b31c-e9fa1aba8ca4",
          "name": "SampleCount",
          "type": "Int32",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "69811903-fef0-4dc5-8b11-fa6ed67b8a54",
          "name": "Status",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": false,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "bcc8b597-2ef6-4bdb-9a65-5a912fb44984",
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
      "id": "3275785a-1cc0-46ce-9029-49294f9ba32c",
      "name": "QNN_DPLY_SCHEDULER",
      "dbObjectName": "QNN_DPLY_SCHEDULER",
      "schemaName": "",
      "attributes": [
        {
          "id": "ae2fff9b-1723-490b-8e43-3f17047a8889",
          "name": "CreatedBy",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "aa86ecf8-e1bc-4e98-88d6-29ebdb1f6dea",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "42edc141-faed-4544-91b1-a27dbad3dacc",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "dcbae434-5239-48e0-94e9-200104ec4327",
          "name": "EmailFailure",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "64836262-c6c6-47a5-a054-0d4cf19ef2ed",
          "name": "EmailRecipients",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "a18bc7e5-e755-4782-a612-631a75f8d877",
          "name": "EmailSuccess",
          "type": "Boolean",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
          "id": "b8c69817-6a32-4130-8ee9-c6f1782345ad",
          "name": "JobDescription",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "76868474-bbb5-4235-8295-35696c7e66bb",
          "name": "BatchNo",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "cf56afc2-42f2-4627-a795-763d17072314",
          "name": "Count",
          "type": "Int32",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e2eb8524-f6d6-4be4-a94e-d8a49726d4c9",
          "name": "CreatedDate",
          "type": "DateTime",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "17e16c1d-7f9f-43c4-9ec5-1da9989fd03a",
          "name": "DplyId",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "179e13c7-b70c-4f9f-991c-f41decd6802d",
          "name": "Id",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
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
          "id": "0873a155-1c3c-4abb-8f7d-2ab7247e7885",
          "name": "Status",
          "type": "Guid",
          "typeId": 0,
          "isNullable": true,
          "isVirtual": false,
          "isCalculated": false,
          "isExtension": false
        },
        {
          "id": "e84318b2-1e05-4d11-abeb-41de4e8fc220",
          "name": "Weightgroup",
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
      "id": "96aba12c-a596-46b1-b1dd-74a5ba60f3d6",
      "name": "vSP_QnnSampleActiveForGrid",
      "dbObjectName": "vSP_QnnSampleActiveForGrid",
      "schemaName": "",
      "triggers": [],
      "attributes": [
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
          "id": "b9571038-92eb-4bcc-b558-c8f93a942931",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "4cdbf6f2-c84a-4a11-82ce-7173d40eecd1",
          "name": "Email",
          "type": "String",
          "typeId": 0,
          "isNullable": true,
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
          "id": "459a9286-34fe-4a23-9992-362731d39f49",
          "referenceEntityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
          "name": "StructDivisionId",
          "typeId": 1,
          "isNullable": true,
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
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '5A1A28D7-DF6A-4391-9965-05F17D7660E3';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'DataEditorDeployment.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:18.507', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-17 15:29:49.970', 120), Data = N'[
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
        "key": "fileUploadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileUploadModal",
        "style-display": "block",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "Upload Survey Answers",
            "size": "large"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-marginTop": "20px",
            "style-marginBottom": "20px",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "After upload the survey will open for validation and editing. <br/>\n<br/>\nPlease select the form in which to open the survey:",
                    "isHtml": true
                  },
                  {
                    "key": "UploadFormChoice",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ],
                "style-marginBottom": "20px"
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "Click below to select the file to upload or drag and drop a file onto the box.<br/>\nUpload will commence immediately.\n<br/>\n<br/>",
                    "isHtml": true
                  },
                  {
                    "key": "FileUploader",
                    "data-buildertype": "dropzonecontrol",
                    "showFiletypeIcon": true,
                    "autoProcessQueue": true,
                    "addRemoveLinks": false,
                    "multile": true,
                    "iconFiletypes": "*.xlsx",
                    "events": {
                      "success": {
                        "active": true,
                        "actions": [
                          "answerFileUploaded"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btn_CancelUpload",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileUploadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-source": "text-align: right;",
                "style-marginTop": "20px"
              }
            ],
            "style-source": "padding: 20px;"
          }
        ]
      },
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
        "key": "FileNames",
        "name": "File",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false
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
        "key": "UpdatedBy",
        "name": "Last Updated By",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
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
        "filterable": false,
        "name": ""
      },
      {
        "key": "Actions4",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": ""
      },
      {
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pageSize": "80",
    "pagerType": "server",
    "defaultSort": "UID ASC",
    "style-marginBottom": "20px",
    "multiselect": false,
    "events": {},
    "rowHeight": "80",
    "minHeight": "500"
  },
  {
    "key": "dlsi",
    "data-buildertype": "input",
    "label": "Input",
    "fluid": true,
    "onChangeTimeout": 200,
    "style-hidden": true,
    "events": {}
  }
]', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'DataEditorDeployment-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:18.407', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 16:49:30.933', 120), Data = N'{
    init: function (args) {
        const innerArgs = args;
        args.data.remarks = null;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Remarks.customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Remarks" + (p.row.Remarks!=null? '' ...'':''''));
                };
                
                cols.StatusTitle.customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showStatusModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, p.value);
                };                
                
                cols.Actions.customFormatter = function (p) {
                    if(p.row.StatusCode==''PE''){
                        return CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, ''9731DE1D-2B6A-484C-BF10-44F842A3140E''), className: "ui button mini secondary" }, "Exempt");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Exempt");
                    }  
                };        
                    
                cols.Actions2.customFormatter = function (p) {
                    if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                        return CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: "ui button mini secondary" }, "Reset");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Reset");
                    }   
                };    
                
                cols.Actions3.customFormatter = function (p) {
                    return CloverApp.API.createElement("button", { onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), className: "ui button mini secondary" }, "Track" + (p.row.HasTrkListIds!=null? '' ...'':''''));
                };     
                
                cols.Actions4.customFormatter = function (p) {
                    if("O"===p.row.Type) {
                        if(p.row.StatusCode=="PE" || p.row.StatusCode=="DE") {
                            //Upload option is available for Pending and In-Progress
                            const formNames = p.row.FormNames.split(''||'');
                            const languages = p.row.Languages.split(''||''); 
                            return CloverApp.API.createElement("button", { onClick: () => openUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id), className: "ui button mini secondary" }, "Upload");
                        } else {
                            //Disabled button for other status
                            return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Upload");
                        }
                    } else {
                        //No upload button for offline surveys
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                }; 

                cols.FormNames.customFormatter = function (p) {
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
                
                cols.FileNames.customFormatter = function(p) {
                    if(p.row.Type=="O" && p.row.FileLanguages){
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            const token = fileTokens[i];
                            const linkUrl = "/dataedit/download/file/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                            elements.push(element);
                            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                            elements.push(element);
                        }
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
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
                
                if(p.row.RespId){
                    CloverApp.API.redirect(''form'', value, ''respid/'' + p.row.RespId + ''/dlsi/''+ p.row.Id)                        
                }
                else{
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)                        
                }

                
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
            CloverApp.API.setDataField("dlsi", id); 
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
        
        var openUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            console.log("innerArgs, qnnId, dplyId, listSampleId", innerArgs, qnnId, dplyId, listSampleId);
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: formNames[i],
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", formNames[0]);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        var showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            //console.log(''showTrkListsModal args: '', args);
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
            var formData = new FormData();
            formData.append(''id'', id);   
            CloverApp.API.setDataField("dlsi", id); 
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
                        //args.state.app.extra.spData = id;

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

        var resetStatus = function (args, id, respId) {

            var formData = new FormData();
            formData.append(''id'', id);
            if(respId){
                formData.append(''respId'', respId);                
            }
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
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        formData.append(''id'', args.data.dlsi);        
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

        //let id = args.state.app.extra.spData;
        let id = args.data.dlsi;
        let remarks = args.data.remarks;
        changeRemarksAsync(remarks, id);

        return {


        };

    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    answerFileUploaded: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        const postFormData = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: ''same-origin'',
                method: ''post'',
                body: formData,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    /*return responseData.success ? responseData.data : Promise.reject(responseData.message);*/
                    return responseData.success ? responseData.message : Promise.reject(responseData.message);
                }, reason => {
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        
        args.component.refs.fileUploadModal.close();
        
        const token = args.sourceControlValue;
        const qnnId = args.data.UploadQnnId;
        const dplyId = args.data.UploadDplyId;
        const listSampleId = args.data.UploadListSampleId;
        if( (!qnnId) || (!dplyId) || (!listSampleId) || (!token)) {
            console.error("data", args.data);
            throw new Error("Missing required value");
        }
        
        const uploadFormChoice = args.data.UploadFormChoice;
        const uploadIndex = args.data.UploadIndex;
        
        const formData = new FormData();
        formData.append("qnnId", qnnId);
        formData.append("dplyId", dplyId);
        formData.append("listSampleId", listSampleId);
        formData.append("token", token);
        loadingStart("Processing Uploaded File");
        postFormData("/dataedit/handleuploaded", formData).then(
            result => {
                args.component.refs.grid.refresh();
                alertify.success("Survey answers updated from file");
                if(uploadFormChoice) {
                    CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        return {};
    },

}
', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '4AF67164-5E60-4905-9885-AFD6DA24CB3D';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'DataEditorDeployment-settings.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:18.457', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 16:53:11.333', 120), Data = N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2020-08-23T16:53:11.3274775+08:00",
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
    },
    {
      "id": "1d40544a-b501-7c0d-5f87-3daabb92ba95",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "840aaca3-e459-2b81-39fc-4658c3f3c263",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bf099076-5ad5-ede5-f80e-25042482b18b",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f172169e-666e-4df9-964b-c8f43babf927",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "573af6e6-6b28-9f43-25b6-5deaeb8eeb2f",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c6b1203-7c06-14d6-632d-bd9f75cf392f",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "af1fb791-053c-d155-7038-d5d2f43a5ad4",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
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
          "id": "606e2796-04bc-7cec-16ab-d329785946b8",
          "attributeId": "c77c6136-5ac5-49e8-bf25-7e6bda01302c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dbf63b7-2082-676b-627d-422e1ec8c924",
          "attributeId": "0eef5a8c-cfa7-4c9e-ab34-d3d7b45593bc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6711b4a5-90ee-9960-7ada-d28884061dbc",
          "attributeId": "16421e73-0595-4b09-bee5-15d70ea719d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2429f66b-3e7f-b3df-a83f-eb1f76d6d6ec",
          "attributeId": "60a898b6-786f-45e3-a57e-8f7739ac70b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "492a6432-5665-e28f-bfd8-31a6f8cd0b1d",
          "attributeId": "8bd473e5-f566-4b1e-acb6-334ebd1c42f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db2fc40a-7bc0-1820-c5d7-304f368e2411",
          "attributeId": "b4fd6baf-2091-46f5-9479-1cb9755293e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6eb9df3d-925b-61cb-a4d5-bbb642712db8",
          "attributeId": "12e75b20-1246-448e-a824-b8e7320a0bdd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "317feb1c-51ba-f67e-c9ac-02ec111c2f91",
          "attributeId": "235e46d5-89f1-42db-a225-0e788022075c",
          "control": "UIDName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5077e7e6-8186-ee94-45ae-e6586b381adb",
          "attributeId": "81d40b12-963d-40a8-bc18-c310f0f82a5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5de0cae3-364e-20c5-4196-0120370d24c8",
          "attributeId": "ead782a3-2bf2-4ffd-aa71-970315d9a3ac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4c741369-1e2b-16c4-7d81-56803e6be9db",
          "attributeId": "0380c4cb-0e1b-4232-ba8b-8e4cb26cf0eb",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '65E99B1A-44C8-47CF-94F3-E96A73E3F9FD';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'QNN_QNN.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:22.690', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-17 14:36:32.433', 120), Data = N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Questionnaire",
    "size": "huge"
  },
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "View Args",
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "viewArgs"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "size": "",
    "primary": true,
    "style-hidden": true
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
            "key": "Title",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Alias",
            "data-buildertype": "input",
            "label": "Alias",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "CategoryId",
            "data-buildertype": "dictionary",
            "label": "Category",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_CATEGORY",
            "columns": "Name Asc",
            "filters": "[{\"column\":\"Type\", \"value\":\"Q\", \"term\":\"=\"}]"
          },
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "P",
                "text": "Offline"
              },
              {
                "key": 2,
                "value": "O",
                "text": "Online"
              }
            ]
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "children": [
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
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "header": true,
                "other-visibleConition": "data.Type==''O''",
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
                      "style-customcss": "dictionary-no-label"
                    }
                  ]
                }
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "collectioneditor_1",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Name"
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
                    "active": true,
                    "actions": [
                      "validate"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": true,
                "other-visibleConition": ""
              },
              {
                "key": "dropzonecontrol_1",
                "data-buildertype": "dropzonecontrol",
                "showFiletypeIcon": false,
                "autoProcessQueue": true,
                "addRemoveLinks": true,
                "multile": true,
                "events": {
                  "success": {
                    "active": true,
                    "actions": [
                      "createElement"
                    ],
                    "targets": [
                      "collectioneditor_1"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "other-visibleConition": "data.Type==''P''"
          },
          {
            "key": "container_qnn_qnn_file",
            "data-buildertype": "container",
            "children": [
              {
                "key": "collectioneditor_3",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Name"
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
                    "active": true,
                    "actions": [
                      "validate"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": true,
                "other-visibleConition": ""
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
                      "createElement"
                    ],
                    "targets": [
                      "collectioneditor_3"
                    ],
                    "parameters": []
                  }
                },
                "iconFiletypes": "*.xslx"
              }
            ],
            "other-visibleConition": "(data.Type==''O'')",
            "style-marginTop": "20px"
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
                      "save"
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
      }
    ],
    "style-marginBottom": "",
    "events": {}
  }
]', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '61598194-D4D0-43CB-8FB8-A75EA0B2B374';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'QNN_QNN-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:22.580', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', UpdatedDate = convert(datetime, '2019-08-02 23:02:30.070', 120), Data = N'{
    init: function(args){
      console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]


    },  

    viewArgs(args){
        //console.log(''View Args'', args);    
    },
    
  GenFormFields:function(args){
      console.dir(args);
      var qnnId = args.data.Id;
      var token = args.data.collectioneditor_1[0].Token;
          var url = ''/qnn/genfields?qnnId='' + args.data.Id + ''&token='' + token;
    $.post(url).done(function (data) {
        if(data.success)
            alertify.success(data.message);
        else
            alertify.error(data.message);
    }).fail(function (jqxhr, textStatus, error) {
       alertify.error(textStatus);
    }); 
    return {};
      
  },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        //TODO: Insert your code for validation this form
        if(args.data.Title==undefined || args.data.Title==null){
                errorMessages.push(''Please enter questionnaire title'');
                errors.main.Title = true;
                hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
                errorMessages.push(''<br />Please select questionnaire type!'');
                errors.main.Type = true;
                hasError= true;
        }        
        else if(args.data.Type==''P''){
            if(args.data.collectioneditor_1 == undefined || args.data.collectioneditor_1.length == 0){
                errorMessages.push(''<br />Please insert PDF form!'');
                errors.main.collectioneditor_1 = true;
                hasError = true;
            }
        }
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push(''<br />Please insert an online form!'');
                errors.main.collectioneditor_2 = true;
                hasError = true;
            }            
        }
        

        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
    },
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '927FC400-E371-4FBB-B866-CB020FFF46DB';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'QNN_QNN-settings.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:22.637', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 16:38:06.310', 120), Data = N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2020-08-23T16:38:06.2917791+08:00",
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
      "readOnly": false
    }
  ],
  "securityGroup": "Questionnaire"
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '27DBFADB-0E83-4ACD-AF28-35A760E3239B';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'respdashboard.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:23.863', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 17:33:23.420', 120), Data = N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Respondent Home",
    "size": "huge",
    "style-customcss": "",
    "style-source": "color: rgb(19, 98, 226);"
  },
  {
    "key": "respDashboardHtmlView",
    "data-buildertype": "swzhtmlview",
    "hideOutput": "block",
    "events": {}
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_2",
        "data-buildertype": "header",
        "content": "Current Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);",
        "style-customcss": "",
        "events": {}
      },
      {
        "key": "grid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "type": "",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "Form",
            "name": "Form",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "File",
            "name": "File",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "Type",
            "name": "Type",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "PeerName",
            "name": "Peer",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "RespDateStart",
            "name": "Responded On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "Actions",
            "name": "Actions",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "pageSize": "80",
        "defaultSort": "DplyCreatedDate Desc, RespDateEnd Desc",
        "autoHeight": false,
        "offSet": "295px",
        "minHeight": "200px",
        "style-width": "",
        "style-customcss": "",
        "rowHeight": "80"
      }
    ],
    "style-width": "100%",
    "style-source": "margin: auto;\npadding: 10px;\nmargin-bottom: 1em;",
    "style-customcss": "hrm-block",
    "style-marginBottom": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-customcss": "hrm-block",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Previous Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);",
        "style-customcss": "",
        "events": {}
      },
      {
        "key": "gridview",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "type": "",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "Form",
            "name": "Form",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "Type",
            "name": "Type",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "PeerName",
            "name": "Peer",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "RespDateStart",
            "name": "Responded On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime",
            "width": ""
          },
          {
            "sortable": true,
            "filterable": false,
            "resizable": false
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "pageSize": "80",
        "defaultSort": "DplyCreatedDate Desc, RespDateEnd Desc",
        "autoHeight": false,
        "offSet": "295px",
        "minHeight": "200px",
        "style-width": "",
        "events": {},
        "style-customcss": "",
        "rowHeight": "80"
      }
    ],
    "style-width": "100%",
    "style-source": "padding: 10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "",
    "style-hidden": true,
    "children": [
      {
        "key": "fileUploadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileUploadModal",
        "children": [
          {
            "key": "container_4",
            "data-buildertype": "container",
            "style-marginTop": "20px",
            "style-marginBottom": "20px",
            "style-source": "padding: 20px",
            "children": [
              {
                "key": "container_5",
                "data-buildertype": "container",
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "After upload the survey will open for validation and editing. <br/>\n<br/>\nPlease select the form in which to open the survey:",
                    "isHtml": true
                  },
                  {
                    "key": "UploadFormChoice",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ]
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "Click below to select the file to upload or drag and drop a file onto the box.<br/>\nUpload will commence immediately.\n<br/>\n<br/>",
                    "isHtml": true
                  },
                  {
                    "key": "FileUploaded",
                    "data-buildertype": "dropzonecontrol",
                    "showFiletypeIcon": true,
                    "autoProcessQueue": true,
                    "addRemoveLinks": false,
                    "multile": true,
                    "iconFiletypes": "*.xlsx",
                    "events": {
                      "success": {
                        "active": true,
                        "actions": [
                          "answerFileUploaded"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ]
              },
              {
                "key": "container_7",
                "data-buildertype": "container",
                "style-marginTop": "20px",
                "style-source": "text-align: right;",
                "children": [
                  {
                    "key": "btn_CancelUpload",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileUploadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "key": "passwordModal",
        "data-buildertype": "swzmodal",
        "style-display": "block",
        "children": [
          {
            "key": "password",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true,
            "disabled": false,
            "error": true,
            "style-marginBottom": "20px"
          },
          {
            "key": "btnClose",
            "data-buildertype": "button",
            "content": "OK",
            "secondary": true,
            "inverted": true,
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
            "size": "mini"
          }
        ],
        "size": "medium",
        "style-width": ""
      }
    ]
  }
]', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = 'D6E12E1D-3384-4352-BF68-8210AA75D406';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'respdashboard-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:23.760', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 17:59:40.943', 120), Data = N'{

    init: function(args){
console.log("Args", args);
        const innerArgs = args;            
        var url = ''/swzdata/getmultiple?type=RespDashboard'';
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA";
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93";
           
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.customFormatter = function (p) {
                    if(p.row.Type=="Offline"){
                        
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                        return CloverApp.API.createElement("div", {}, elements);
                        
                        //return CloverApp.API.createElement("a", { href: url}, p.value); 
                    }
                    else if(p.row.Type=="Online"){
                        
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        return CloverApp.API.createElement("div", {}, elements);                            
                        
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                };
                
                cols.File.customFormatter = function(p) {
                    console.log("File customFormatter p", p);
                    if(p.row.QnnType=="O" && p.row.FileLanguages){
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            const token = fileTokens[i];
                            const linkUrl = "/respondent/download/file/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                            elements.push(element);
                            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                            elements.push(element);
                        }
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }  
                };
                
                cols.Actions.customFormatter = function (p) {
                    const status = p.row.Status ? p.row.Status.toUpperCase() : "";
                    if(p.row.Type=="Online" && (status==PENDING || status==IN_PROGRESS) ){
                        const formNames = p.row.FormNames.split(''||'');
                        const languages = p.row.Languages.split(''||''); 
                        return CloverApp.API.createElement(
                            "button", {
                                onClick: () => openUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id), 
                                className: "ui button secondary invert",
                            }, "Upload");
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }
                };
                
                //model.columns[model.columns.length-1].customFormatter = function (p) {
                //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                //};   
                
            }
            return model;
        };
        
        var gridviewModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    if(p.row.Type=="Offline"){
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                        return CloverApp.API.createElement("div", {}, elements);
                        
                        //return CloverApp.API.createElement("a", { href: url}, p.value); 
                    }
                    else if(p.row.Type=="Online"){
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        return CloverApp.API.createElement("div", {}, elements);  
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                };
                
                //model.columns[model.columns.length-1].customFormatter = function (p) {
                //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                //};                  
                
            }
            return model;
        };      
        

        
       /* var genFormLinks = function(p, elements, languages, value, index){
            var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };*/
        var genOfflineFormLinks = function(p, elements, languages, value, index){
            var linkUrl = "/respondent/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
            CloverApp.API.createElement("a", { href: linkUrl}, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };    
        
        var genFormLinkButtons = function(p, elements, languages, value, index){
            var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
            var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
            CloverApp.API.createElement("span", { onClick: () =>  {

                if(p.row.RespId){
                    CloverApp.API.redirect(''form'', value, ''respid/'' + p.row.RespId + ''/dlsi/''+ p.row.Id)                         
                }
                else{
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)                        
                }

                
            }, className: "link-style" }, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };     
        
        var openUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            //console.log("innerArgs, qnnId, dplyId, listSampleId", innerArgs, qnnId, dplyId, listSampleId);
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: formNames[i],
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", formNames[0]);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        var showModal = function (args, id) {
            return getPasswordAsync(args, id);
        }; 
        
        var getPasswordAsync = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/respondent/getpassword'';
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
                        //console.log("getPasswordAsync args", args);
                        args.controlRef.refs.passwordModal.openModal();
                        args.component.state.data.password = response.item;
                        args.component.refs.password.forceUpdate();
                        //console.log(''response.item'', response.item);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });


        };        
        
        
        $.get(url).done(function (data) {
        if(data.success){
            
            var htmlData = [];
            for (var i=0; i<data.data.length; i++){
                        htmlData.push(data.data[i].editorState);
            }
            CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
        }
        else
          console.log(data.message);
        }).fail(function (jqxhr, textStatus, error) {
         console.log(textStatus);
        }); 
        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
        CloverApp.API.rewriteControlModel("gridview", gridviewModelRewriter);

        $(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        //args.component.refs.grid.refresh();
        //args.component.refs.gridview.refresh();
        
    },
    
    closeModal: function (args) {

        args.component.refs.passwordModal.close();
        return {
        };

    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    answerFileUploaded: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        const postFormData = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: ''same-origin'',
                method: ''post'',
                body: formData,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    /*return responseData.success ? responseData.data : Promise.reject(responseData.message);*/
                    return responseData.success ? responseData.message : Promise.reject(responseData.message);
                }, reason => {
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        
        args.component.refs.fileUploadModal.close();
        
        const token = args.sourceControlValue;
        const qnnId = args.data.UploadQnnId;
        const dplyId = args.data.UploadDplyId;
        const listSampleId = args.data.UploadListSampleId;
        if( (!qnnId) || (!dplyId) || (!listSampleId) || (!token)) {
            console.error("data", args.data);
            throw new Error("Missing required value");
        }
        
        const uploadFormChoice = args.data.UploadFormChoice;
        const uploadIndex = args.data.UploadIndex;
        
        const formData = new FormData();
        formData.append("qnnId", qnnId);
        formData.append("dplyId", dplyId);
        formData.append("listSampleId", listSampleId);
        formData.append("token", token);
        loadingStart("Processing Uploaded File");
        postFormData("/respondent/handleuploaded", formData).then(
            result => {
                args.component.refs.grid.refresh();
                alertify.success("Survey answers uploaded");
                if(uploadFormChoice) {
                    CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        return {};
    }
    
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '7479ADC7-5164-48A5-B4C6-2EB01ECA68DF';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'respdashboard-settings.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:23.807', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-23 18:00:14.237', 120), Data = N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2020-08-23T18:00:14.2251062+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "ee290857-7d9d-2279-3c90-6a3c7e43dd0a",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\", DplyDateStart: \"<=@NOW\",  DueDate: \">=@NOW\", VisibleToRespondent:1}",
      "control": "grid",
      "dataMap": [
        {
          "id": "2c47907c-aa19-c201-7f1a-77167860f312",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11f589c2-05e7-2a32-4f4d-83d960dd0cb0",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7edf9385-6e02-d115-762c-6d9038638568",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4f0f5962-1b59-4f87-3e5e-8f19ff902409",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62a46b8a-ed2e-102c-0d63-fdd8df24eb2d",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8201ffea-ece8-038b-2683-d46c77a1e46a",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d07c7bd-e02e-f4a9-f60e-b70e78a365bc",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f79ce41-b73e-07dd-aeeb-1d1ed251ae16",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cab04562-b8cf-e61d-ef4d-2f544cb78c8c",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "469d27b4-e0a8-801a-68f2-c0ec0e6e14af",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d965334-15f2-516a-58cb-48b7266dc7db",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "33eb2bce-b538-0b44-bc3b-89d2a40b1626",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "400c511d-a24d-9e60-3289-661ec1eb146d",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "85c7647c-34e0-9d3d-f170-8ca1c21c2ea4",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd39aaea-5157-30c7-10f1-50422bcf6c5a",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "830f8133-1268-1ef3-1d63-48893663ee7f",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1b5eee2-7dec-78a8-84a1-3d1e8463c037",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b451aea9-e6dc-6878-055e-f3c676195b00",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6526b948-f332-8273-f664-f6165eda3ad9",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36f01f84-926d-0f56-311f-3451f1e72c26",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc0bc8bb-66aa-37a8-9e6a-91aad3236606",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81fbcb41-92f7-41c1-bf35-d531fff38728",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "896558f3-b726-1e96-e083-240b213b330a",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98b48d4c-dd53-eea5-e575-d226c7d5d25b",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eef8657b-fa91-32db-74f6-068e49a403e1",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "209f2db1-f603-2676-ef4d-5c70cc1618b1",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "affee0d0-4f89-dd9c-9b00-1c5153082017",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3348cfe2-b3dc-5331-8190-525139fd2044",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad46c62d-32cb-4905-1b11-5293ef6b14e8",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6313f004-9086-c0a1-99b6-eeb4469db504",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9934ce50-5b90-f388-905c-8ce429967485",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7663a9cc-e912-b849-1e35-e3199a22e89f",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20033a00-e7b0-095e-2339-a38e54fca73c",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "91ea6eb6-f90c-76d3-6708-c139b659960a",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9707b198-3172-3e85-04e9-1afc89366b9e",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4c078237-080a-ceb8-5ffb-9bb0f7b36143",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b8b84c38-eadc-47b3-df63-181d60180d35",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2df64e6f-678c-ddbc-d0e3-ec0f53000a99",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10f14e69-604d-0ec6-fada-bf8582881d22",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c4adbd26-9c00-45ad-f447-ffa3f90f0e91",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b68abba1-547f-4aac-21bd-fd15b192ea14",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db3afac5-e792-1271-f5d6-d038827907df",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7fbba967-0ec3-ddc9-fd57-0d85e303cf22",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b61c0453-2747-a283-14b7-02b768b6ee60",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b90ae358-c136-d958-b7dd-2ddcbc68668e",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86fc073f-f004-b6bc-de5b-6903197bbe19",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2eec3fab-3af8-23b0-cb71-47376426f0dc",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96e09b14-03ee-ff2e-1992-596a83a6da5c",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "64aec786-6856-56b9-c67e-ff5d6cfd21d7",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ee45e436-4b34-06f0-b133-afeb339aa0ee",
          "attributeId": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "352c2c00-9290-0cf9-005f-850c49843cd8",
          "attributeId": "2fbd5e35-2964-40a0-82bc-76b93f3a73af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a87c286d-8213-93ed-737c-ccdba25a36d6",
          "attributeId": "be3bef4a-72f7-4804-84e7-8e42c40eab86",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "705af60e-2406-b4e3-e213-19fd46a70cce",
          "attributeId": "40d72036-21c4-4b3f-8b2b-c352a37b3812",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37465afb-a121-cb45-25f8-eab58e6f20f6",
          "attributeId": "5ab3bc7d-e4d8-49fe-a087-7093f99286dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1df3aaa4-49ef-5a13-2906-80e6c2361c63",
          "attributeId": "fcb4627a-fb63-419f-9bbe-c125514a3f79",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b50fcb2e-1722-c793-367d-6e14554fdead",
          "attributeId": "1c457209-3ee6-41b3-95a8-870a2466cd02",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d1955db7-7af8-929c-37fc-fe4cb676d0fb",
          "attributeId": "9f239689-fdd6-4c51-adce-9959579d2823",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "77aeae35-3e64-25d8-45f2-560729893f92",
          "attributeId": "fd8d1d9c-b64b-4e07-8fec-1c2d59577634",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bae423a2-bfa8-cd41-6be3-6c2846a9156a",
          "attributeId": "f66354e6-46ee-4d8c-a205-27ffec902cfa",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "fc1769be-53f6-2708-3c8b-9ce8fe01560b",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\",  DueDate:\"<=@NOW\", VisibleToRespondent:1}",
      "control": "gridview",
      "dataMap": [
        {
          "id": "37b3d171-4289-902e-37e1-0269e02f630d",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "254c1313-aefa-a548-e7c5-979c0058575c",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7ad4ab55-275b-7968-fc66-5291f6de6720",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3c2a4fb2-96d0-7bfa-301e-d46dab52a0f4",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35def3d8-e33e-3ce6-060a-43e77dce53ed",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e6064b5e-2817-a7ba-68b3-8a5736158722",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e8ae1ab-f1ea-365c-99e0-2004fc185efd",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f25c06b0-74cd-6a5c-814a-bfa259682bd5",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2305c962-2497-d015-4507-201247932839",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "33d9f7ef-f80e-4407-2aa9-b373ec98b753",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e36f79f-39f7-b5ea-6e45-b8af274f9d22",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1ffbae71-fa5c-fb47-6b17-e1e740102066",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "476ec478-a554-ce99-8a3e-83101096b023",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6db04129-2b60-5418-1674-d9f0a04b2e33",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f2453f4-cb18-514f-5279-50c07678e91a",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c646ae36-9a34-c827-e6f2-361396f7f547",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "362a62db-25f4-cf72-17bd-3f5cae1dbc31",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6de5ff64-e223-1dfe-1ff2-ba678b13871c",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "67518526-7a96-53dc-c1dc-faeab93a61ef",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8bbfb419-eb74-665a-9aa2-6f8aec037c49",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98cb492f-ebb7-6338-d011-03707bb09bf4",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aad9a577-ebbe-7e60-c296-c60f537c7139",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1dc591b5-ea15-374a-eb3c-19a6833a2301",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "affa5a82-9586-68c4-93f0-bd56cbab9f4c",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1150e8fe-b6f3-bf7d-75b7-0c9928f50bb3",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1989f42a-fb33-8407-1a72-4647e31140d3",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "16fb7e95-be61-3385-1120-6c1361d9dd64",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad39f718-b0a1-84a4-b403-cd09b8087cd4",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2039d889-95e9-6360-9ff4-87a7d72b7abb",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7489d5b6-6874-8408-17a9-5eb636b480e2",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bdec1b8e-a3a3-72c1-e1db-7f1e40576143",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ddecb24-8dcc-d45b-e579-24c957403576",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01fb9843-6d3f-768e-67d9-7c704abbf912",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6ebce0fa-b0e1-d2ff-13c7-1cbe70a59bf8",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "850c96b1-0b9a-4392-0a5c-c3420b308b96",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9898766-c9bc-5915-8472-0710b899806c",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84179341-403c-ca9d-a86c-5432cb72e01b",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e9456374-1b25-243b-4b7a-95c251e42f3a",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7b02fe81-8087-7111-1772-417c12e9d46e",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "92832494-78f1-84b2-332e-d329206a9522",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b178125-dbe8-b52a-2e48-43cc74e1720e",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4acb99f-279f-f68b-5b6b-3323e656f78d",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32aa7dbc-473e-fab0-80d0-e8498e183ddd",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d4f03b3-45ff-11a9-230c-45313117fc02",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d3de4fb4-6473-14be-c5d9-9f5f6e13f42c",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89192b80-4e20-0c04-d193-54f225e727cb",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eaac75be-1f00-5567-b507-4c996a1f48cd",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0bb3beeb-ff41-a2cd-8229-0f5dcec51272",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69ffd8f9-ed6d-cb73-bce5-c334bc74df5b",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39b1dcaf-ddf7-48ae-39e9-e72697d94a77",
          "attributeId": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7315524e-bf57-c964-8afb-4cdefec60917",
          "attributeId": "2fbd5e35-2964-40a0-82bc-76b93f3a73af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05766f76-b73f-0127-b49c-5861dccea2f4",
          "attributeId": "be3bef4a-72f7-4804-84e7-8e42c40eab86",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e781e6b0-103c-47e0-e3ab-9ecf8ef01e2f",
          "attributeId": "40d72036-21c4-4b3f-8b2b-c352a37b3812",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "302ec320-35c7-6c82-4d44-f55e2a0f59fb",
          "attributeId": "5ab3bc7d-e4d8-49fe-a087-7093f99286dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d3a3936c-cf3e-247c-ae6c-1d3f6fe728f0",
          "attributeId": "fcb4627a-fb63-419f-9bbe-c125514a3f79",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1691d19-ee85-8047-18a7-f2b2a5b935fd",
          "attributeId": "1c457209-3ee6-41b3-95a8-870a2466cd02",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0052208b-e149-1d54-d707-c58bbb2cec23",
          "attributeId": "9f239689-fdd6-4c51-adce-9959579d2823",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c17e443f-688d-f1ed-2e6b-f4cf6c45ce12",
          "attributeId": "fd8d1d9c-b64b-4e07-8fec-1c2d59577634",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4db2b53d-7de0-a825-31f0-4c8bd1843668",
          "attributeId": "f66354e6-46ee-4d8c-a205-27ffec902cfa",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '50A76E5A-98F3-44BF-A161-003ED4FB2F3B';
