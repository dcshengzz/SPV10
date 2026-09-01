-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_STYLE-settings.json
-- QNN_LIST-settings.json
-- QNN_TRK_LIST-settings.json
-- ShortLink-settings.json
-- QNN_RESP_ADMIN-settings.json
-- SwzRespAdminList-settings.json
-- SwzRespAdminList.json
-- QNN_HELP-settings.json
-- QNN_SAMPLE-settings.json
-- QNN_QNN-settings.json

UPDATE [dwMetadata] SET
[Id]='dc7cd7f5-8839-40fd-b16d-eace35fd3c59', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_STYLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 17:51:45.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 01:43:57.087', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_STYLE",
  "lastUpdate": "2026-01-22T01:43:57.0737159+08:00",
  "entityId": "218ec89e-4aa3-4985-bcf5-4e69c8824347",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
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
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnStyleTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "8c0c425f-5482-e9ed-d27c-da6e4d96011a",
      "attributeId": "68d481c2-da6f-4186-b65f-ff583f740930",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a2de45ed-f7ca-20a0-0ed4-648570905eeb",
      "attributeId": "ec886465-a2e5-4cc1-afd8-beb101ce86c6",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e1259b93-f850-b147-bbdf-ccccd70a15d1",
      "attributeId": "00792a31-ed25-4d82-b673-5cfff21eb35e",
      "control": "CssProperties",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "43992589-6b02-da3c-2226-c5c257e9dc3b",
      "attributeId": "fc6da424-9227-47c5-a801-9217d29883f5",
      "control": "CssSelector",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05cc1c14-4b4e-cf9e-80c0-b4fec756ca68",
      "attributeId": "85f06cd3-2033-4704-9a7e-cd1295179e37",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e1a55496-575b-cb87-45c6-4d05e21d99b0",
      "attributeId": "12e325a8-ecca-4288-9e76-81d57ae03d7e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16c7dde5-4b5a-384b-40ad-5230aebd44b9",
      "attributeId": "4ef2eaf5-6d7d-44e6-af6e-f0c230b9e368",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b42b7fa8-3f45-340f-80d4-35ee6bc9076d",
      "attributeId": "ae020fe4-cb13-4994-894b-1152f2d88cf5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8b9969c2-af2e-861d-e4fa-949c9516963c",
      "attributeId": "233251e4-788f-4443-8c71-a58e8b71abb2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "70035e38-990c-67a5-d134-1c727b9fc754",
      "attributeId": "0ed9cb40-1a9b-49e4-a96e-b43978dd1e22",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "439904c4-b2c8-4e90-afc1-3ca8c7f95f0b",
      "attributeId": "d9d785b6-7573-43ef-b534-7e5b7ca2e542",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25ab0fc0-25eb-a0f6-ed9e-323ff61d8e97",
      "attributeId": "9060a28f-eb9f-449d-b1bc-e211cc3ea7cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "484ccd18-70d1-2fd1-2337-2bfeace63c15",
      "attributeId": "40c7cb99-4fda-45dd-97b0-9f9f84957bf5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dd72ca8a-2193-c603-ee24-6ab711491151",
      "attributeId": "72ccc8e6-de8a-4814-b4d4-2772e23bfa8c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Designer",
  "isArchived": false
}' WHERE [Id]='dc7cd7f5-8839-40fd-b16d-eace35fd3c59';

UPDATE [dwMetadata] SET
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 01:53:43.213', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2026-01-22T01:53:43.2122709+08:00",
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
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnListTrigger"
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
      "readOnly": true,
      "totalCountPropertyName": "__gridDeployments_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

UPDATE [dwMetadata] SET
[Id]='27855988-ddc1-4d16-9272-69ebe7e64c13', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:08:58.467', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST",
  "lastUpdate": "2026-01-22T02:08:58.4535978+08:00",
  "entityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
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
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnTrkListTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "e3fdbacd-4375-80d2-740c-7640f45540a1",
      "attributeId": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "189b34e9-b436-1620-293f-96b512e74eeb",
      "attributeId": "0c358898-d35c-4be3-89bd-368143effb39",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29536852-22ef-4321-6099-c79c4eed021b",
      "attributeId": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7f578f4f-db0d-f9d4-6def-3c5d9ba046ac",
      "attributeId": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "827f2897-f7bb-10bf-6d86-b59c288e3bd2",
      "attributeId": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1bafca91-1758-7795-8775-c66ceadd577a",
      "attributeId": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f69e648-723a-b662-fdd6-8fdf28016f17",
      "attributeId": "f55004c7-067f-4b47-9815-1d91d177b8a2",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54ed9637-3e8e-8e12-00e8-a24ad1c47f4c",
      "attributeId": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff10f833-945d-1258-ec3b-ce0af61fd36b",
      "attributeId": "b3e75714-844d-4e64-b638-e9c60ffebf78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9f27c2e-a9ec-dc10-868c-e57a039d72ad",
      "attributeId": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d23e0b5d-3658-a1a1-6202-1d30ec00565a",
      "attributeId": "863fb411-5f61-4962-ac06-cdf953abbbf0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b38af738-1a41-0f6e-1fd9-052438e971ce",
      "attributeId": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b2018773-2287-ab4a-5f60-6c614b841b76",
      "entityId": "245660f8-437f-4716-b14b-03a040a0f220",
      "filter": "FilterByModelId",
      "parameter": "{TrkListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "0cc2a40e-652a-3f5e-7502-cce03d7e26b9",
          "attributeId": "93d5e831-d471-4fdf-b562-60d70ed73b64",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d5b185b8-2318-5fc4-284a-4d6c3aca0540",
          "attributeId": "a6337ff6-c08d-4998-b235-f0c4609d44e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "548fe073-4081-ca3b-e8cb-780a584cd2e3",
          "attributeId": "7d603136-3dbb-488f-81ef-482d2592184e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8cd98de-8a9a-b81d-58ba-925e47eb0b47",
          "attributeId": "1c65984e-89ce-4030-8cbb-60d8eb2455d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e66f31-0567-6973-6dbe-8ead55b735a5",
          "attributeId": "665424d0-9759-437b-b620-d5d5243287c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c1692c4-bc68-d880-6ae2-023173363cbb",
          "attributeId": "9ed7f898-6b13-4cd0-be8d-4ce5183f0da8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6a27f53d-c1e7-1242-2949-4ef829c0fee3",
          "attributeId": "8f29d669-5d1d-4e3d-90b4-97153c2bbdfb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c399f5c-2b24-7d4d-e23c-93400d7a1520",
          "attributeId": "ec0e063b-9864-49a5-9469-72c6e2f2546e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35b222dd-c9b1-84ed-5313-04c48f4bb267",
          "attributeId": "b84d9d22-dd5c-4077-a8f7-a45a55496c0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0297648c-0594-5ad0-8f16-0fab66e47816",
          "attributeId": "67bb8933-188d-46ff-a9ce-7152447c3e6a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "26a11c54-3f20-205d-986b-9ec0206a9f87",
          "attributeId": "97f7aa0f-e033-4b9f-80e9-1dd6730c65f9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9afe4bb-1f5a-5f9b-c8ef-32cf8a130d2c",
          "attributeId": "aec40eba-82df-4090-8bda-87bc9ae2bdac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a213b234-6c3e-9107-5700-fb7244c3d7c2",
          "attributeId": "5671f841-1602-4210-90f3-77b8c2a51aaf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa0e2e0-84ea-65b9-8e32-cac5d650b33c",
          "attributeId": "4b041d0e-1bed-4dd0-87ea-1c8812ec54de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "498ba4b5-d60b-db99-acb1-09133f0a889b",
          "attributeId": "f042fa99-cffb-480c-af49-86b679f57c1e",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='27855988-ddc1-4d16-9272-69ebe7e64c13';

UPDATE [dwMetadata] SET
[Id]='4b3767e2-2251-46fd-b68c-6f6a5f4408c9', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ShortLink-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-20 14:04:44.173', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:19:51.713', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "ShortLink",
  "lastUpdate": "2026-01-22T02:19:51.697026+08:00",
  "entityId": "bb232797-c37c-4e39-8261-5cde3636eb04",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\",\"AccessCode\":\"@AccessCode\"}"
    },
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"LinkType\":\"Anonymous\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateShortlinkTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "d0b3bcd2-ff12-1b2b-ea2e-ea7d99bdcc6d",
      "attributeId": "acd0d9a1-ace1-4bfd-8f80-2c2c493ed548",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "8e84e88f-1a20-137d-87c2-b5a409d505c3",
      "attributeId": "b7052bb3-8310-47ed-b645-f079b5f73e05",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2994ef14-1de2-6877-ddc5-fa3ed979c6e8",
      "attributeId": "1bae5af1-eb43-4d4a-b4cf-87304bddba00",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dda2e306-9e99-f6a9-1104-bf2d93ea3dea",
      "attributeId": "728217c3-dfb3-45cd-bdca-8951417281e2",
      "control": "LinkType",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29c50add-085c-f84a-3b27-43cba88550c1",
      "attributeId": "fe48fb6e-51ec-43d8-8205-d3d099441e9d",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42c08c7f-f2a5-2f69-2961-84a9e2e32a62",
      "attributeId": "da7a87db-a45a-4a02-a73a-43c4ec9f5ac2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3c69c82d-efb4-1df7-40aa-a4f00bf1cacd",
      "attributeId": "116cbed7-4d0f-44d2-9ff0-875a648175ac",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d1381457-f41f-2242-917f-ce16c09cd9e4",
      "attributeId": "878d0beb-de01-440b-a81b-5a284e8ebdc9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2c29ccea-9c8a-b19b-fd4e-8cb0786b0a3a",
      "attributeId": "f224c78c-3bdc-47ca-84d1-51795d978d48",
      "control": "Url",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "362379f0-495e-ce57-9e15-e3220ba126b0",
      "attributeId": "09beb932-46b3-4485-b133-f0ec735935d6",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "23cb473f-136a-233c-cac2-f7980b035df0",
      "attributeId": "d5041cf8-91b4-47b2-bf5e-0cd64ff11a22",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42f58073-ec63-7337-d689-7cd6d800e49f",
      "attributeId": "8a0c403a-2f71-4dbf-b0ee-4b760a149ecb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f402f01d-69b5-b5e3-1e69-b77df6aa3db4",
      "attributeId": "dcd04769-b679-449b-bde1-6170a9b7d14e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "95894704-0e7e-6559-334f-325e24b74d06",
      "attributeId": "94fda3ab-15e5-4fda-bec1-339a2d72f128",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "012693e0-df8b-2707-7fec-436a4fca04b6",
      "attributeId": "acff1425-443d-45dc-a491-cf18e6b646b8",
      "control": "IsEnhancedSecurity",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "43446e03-136b-4883-1c2d-209879fdc2b1",
      "attributeId": "281b9c4f-cde3-422d-9cb3-b2364fef8b51",
      "control": "FormName",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "ShortLink",
  "isArchived": false
}' WHERE [Id]='4b3767e2-2251-46fd-b68c-6f6a5f4408c9';

UPDATE [dwMetadata] SET
[Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.397', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:34:28.533', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_RESP_ADMIN",
  "lastUpdate": "2026-01-22T02:34:28.4283905+08:00",
  "entityId": "cd522364-03bb-44c1-af31-575eab8ac087",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnRespAdminTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "7eca1a45-c409-c32e-acb9-251afa096832",
      "attributeId": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98277ccb-156d-afac-2a25-810f13e8ecb4",
      "attributeId": "d8512084-4732-4938-869d-0165bc220192",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5b887698-a623-eae4-a59f-a470b18bb314",
      "attributeId": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5e36525f-6583-2890-4e1a-b5b43f70b0d0",
      "attributeId": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
      "control": "respHtmlEditor",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0904f275-ff19-ad51-3862-c95d8ce0e28d",
      "attributeId": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
      "control": "EndDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14a5e4-f3c4-1a77-b66f-ab5ead0f9a9c",
      "attributeId": "46699848-4700-4d77-a193-ef4ecbd921ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16abd9a3-7f1f-7567-52f7-7eeca4e7ea42",
      "attributeId": "59530aed-1d91-40d2-8808-d1a286390b4f",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d8ab4c5-a6bc-45c0-769a-381960714fd3",
      "attributeId": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a5f37cdf-b2e2-0df8-f5db-b3ea2415a852",
      "attributeId": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
      "control": "StartDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b0088559-9d4a-b852-6699-6a6aa5878664",
      "attributeId": "617be8a6-bcdc-46db-86c9-2841eac54b68",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f27ec61-4e13-2d9e-7a39-60413c212ca9",
      "attributeId": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "44070596-2231-fd60-7e48-8a373db5ce80",
      "attributeId": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79d44998-f62a-a4c0-790a-f9920d1848a9",
      "attributeId": "5c84da90-3ecb-4c14-846f-8d1568091a77",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content",
  "isArchived": false
}' WHERE [Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f';

UPDATE [dwMetadata] SET
[Id]='815eaaa7-0ce0-487b-bdd3-8282471fcff2', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRespAdminList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-09 09:14:33.273', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:46:10.200', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzRespAdminList",
  "lastUpdate": "2026-01-22T02:46:10.1892246+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8545a415-8f5e-24cb-3cb0-835d4723add1",
      "entityId": "cd522364-03bb-44c1-af31-575eab8ac087",
      "control": "grid_respadmin",
      "dataMap": [
        {
          "id": "953748b6-a60d-80ba-4e3e-55359aa05c21",
          "attributeId": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4625a56-4633-155c-1b05-fc8187f3bbaa",
          "attributeId": "d8512084-4732-4938-869d-0165bc220192",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc40b2fa-3238-424c-31d7-d51eea9a01d2",
          "attributeId": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e482d2a-814b-2378-26f7-e6924a4abed1",
          "attributeId": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9cd2aa18-95ae-39d3-f518-2874d836c125",
          "attributeId": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d16f4476-8ce6-626b-3748-648a9762d8b3",
          "attributeId": "46699848-4700-4d77-a193-ef4ecbd921ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06400da2-63e9-7480-cdc2-f9086cdddaa6",
          "attributeId": "59530aed-1d91-40d2-8808-d1a286390b4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f4d776c0-5f48-4852-a110-3ee3b91ca770",
          "attributeId": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93bf876e-d25f-0248-96a7-3cd9a45670f4",
          "attributeId": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12da3aef-a0ed-07cb-de97-a2c22ba2f05a",
          "attributeId": "617be8a6-bcdc-46db-86c9-2841eac54b68",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c8847db-0a76-9214-90f0-195b099934be",
          "attributeId": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "076b8f57-6bb9-20eb-3ff2-2d47da719b1f",
          "attributeId": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4e7ca3a-06d2-a081-2f21-d8fdd1d3a390",
          "attributeId": "5c84da90-3ecb-4c14-846f-8d1568091a77",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_respadmin_totalcount"
    }
  ],
  "securityGroup": "Content",
  "isArchived": false
}' WHERE [Id]='815eaaa7-0ce0-487b-bdd3-8282471fcff2';

UPDATE [dwMetadata] SET
[Id]='02e8136c-05cd-4541-8df3-ad727992c6f6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRespAdminList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-09 09:14:33.160', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:46:10.157', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Respondent Content Management",
        "size": "huge",
        "textAlign": "left",
        "events": {}
      }
    ],
    "style-source": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "right",
    "style-marginRight": "20px",
    "children": [
      {
        "key": "btnCreate",
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
              "grid_respadmin"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "btnDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridDelete"
            ],
            "targets": [
              "grid_respadmin"
            ],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": ""
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginTop": "",
    "style-marginBottom": "50px",
    "style-source": "clear:both;"
  },
  {
    "key": "grid_respadmin",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
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
        "key": "StartDate",
        "name": "Start Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "EndDate",
        "name": "End Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "defaultSort": "NumberId ASC",
    "pagerType": "server",
    "editForm": "QNN_RESP_ADMIN",
    "autoHeight": false,
    "offSet": "285px",
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
        "parameters": [],
        "active": false,
        "actions": [],
        "targets": []
      }
    },
    "editFormShowType": "",
    "multiselect": true,
    "style-marginTop": "10px",
    "minHeight": "500",
    "rowHeight": "80"
  }
]' WHERE [Id]='02e8136c-05cd-4541-8df3-ad727992c6f6';

UPDATE [dwMetadata] SET
[Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_HELP-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 11:03:46.440', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 02:56:36.450', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_HELP",
  "lastUpdate": "2026-01-22T02:56:36.355169+08:00",
  "entityId": "bb075204-7deb-44cc-9251-b1d158e816d3",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnHelpTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "db188500-410c-b948-85ba-95072a3176f6",
      "attributeId": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
      "control": "HelpContent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a50392f-e54d-0e2f-73b1-6bdc4ad8f608",
      "attributeId": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8551abf1-fa37-ca9a-1180-18dd8498b685",
      "attributeId": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc1f01c5-751f-9cae-34f6-4cd6827badc6",
      "attributeId": "90a76b37-0d22-4e40-8524-f4f990a161d5",
      "control": "Heading",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9e78c85f-8330-54f6-141d-1dafdfff716f",
      "attributeId": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98b6ba10-12d1-0a43-ca6e-9a8575519ede",
      "attributeId": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90935ca2-0db8-1f6d-444c-310b7b83380d",
      "attributeId": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee59f60a-0487-dadc-5d95-123bcaf8eb79",
      "attributeId": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
      "control": "Topic",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "246dcd52-bdc7-3150-4bd3-bbd2c436dd0a",
      "attributeId": "94da5047-34a7-42a0-97ca-09e704f33af0",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b47d650-15e8-4233-a9fc-3191f50e2df2",
      "attributeId": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c8205e0c-7502-98f8-3555-38fe4a5ce0a6",
      "attributeId": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content",
  "isArchived": false
}' WHERE [Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a';

UPDATE [dwMetadata] SET
[Id]='22cdf459-84e7-4174-a19b-79618f6f383b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.853', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 03:10:12.980', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2026-01-22T03:10:12.8883108+08:00",
  "entityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{NumRetry: 0, CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"0\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"1\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "DecryptPasswordAsyncTrigger"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertSampleStructDivisionAsync"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "SyncAuditSampleNameAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertSampleAddressAsync"
    },
    {
      "triggers": [
        "BeforeUpdate",
        "BeforeInsert"
      ],
      "codeAction": "ValidateQnnSampleTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "68025520-09f5-8e87-de8a-d02b755a2e17",
      "attributeId": "e9ee47ca-3a33-42de-54e8-f98a5323d26d",
      "control": "LastLoginDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "edc7e5b8-3583-18b9-c627-cf5e7cb86f24",
      "attributeId": "011a70db-a5ae-4019-a9ac-4c167d60bbb0",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a49787b-ba63-68a2-17b3-36da7da2cf2a",
      "attributeId": "63a7a61b-6248-4197-8d08-3fc85ff686ba",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbdffc8e-e317-f0d7-53b4-04aa30f76d98",
      "attributeId": "be7d893d-9d5d-4c1e-a3e7-b04e13a5c303",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ff7b685-f4d8-fb31-e481-f56b2789e4c3",
      "attributeId": "3cb554ec-8497-4513-93c5-58769fe5231c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3f1f58c5-4e1c-2f43-7ff3-5f26b5cc9a98",
      "attributeId": "8778e5f8-94eb-438f-bfd5-36ede705a05b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3c3d5589-a4b2-5a16-3334-24c619fbcdcc",
      "attributeId": "96143a54-6881-4bfe-947e-39e6ab7fd935",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a6cb92af-19df-2766-c04e-b94f1f078fe0",
      "attributeId": "b22a30c4-696c-4ced-aa4a-22620b16a884",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e8cc4b-66f9-f92f-4eb3-55a05b13914b",
      "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5cf2cb99-c2d4-d091-a37f-d857b1273fa6",
      "attributeId": "1b3705b9-e1de-401c-996e-c7c9ac10366a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7435cf97-3c62-30f1-4a23-4d823c702644",
      "attributeId": "ac3c5076-a671-43d0-bab9-d50d339598a9",
      "control": "NumRetry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ab14d4-d93e-6287-ffff-59e47491846d",
      "attributeId": "a02ab42a-6f9c-4a9d-8112-3cc7eae2a5fc",
      "control": "Pwd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eae93866-4ae7-aec2-c89b-b10233e2beb9",
      "attributeId": "700091f4-476a-440a-bc17-ab5351fa461b",
      "control": "PwdResetYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f467544-177f-9368-48bd-501792ae1096",
      "attributeId": "a7440614-efc1-454a-8ff7-cc29764ad271",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4ad5c54-eea6-5a18-b8d2-878a742ef438",
      "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37738de-03a7-9b0e-cce8-db6ac0994dd1",
      "attributeId": "96609d0c-c7fc-4fcb-816b-cde87a1e5de3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "acf1b3ba-ad4d-ed4a-62a8-145645ae5a31",
      "attributeId": "791dc4a1-5ee5-4550-88d4-56ff82d0d867",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8376408e-eb50-67e7-5260-eb9d677237eb",
      "attributeId": "c50309ed-78cf-4601-b861-a0e8c43f8ba3",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1318a691-79c2-4d23-9e4b-29748cfe2ff1",
      "entityId": "48188aea-bf3d-45fe-8173-51f409497771",
      "filter": "SampleMappingsFilter",
      "control": "AddressBook",
      "dataMap": [
        {
          "id": "1575a53e-84b0-3e34-8ea6-c192ea46933e",
          "attributeId": "dcc822c9-1fa5-4d21-8eec-aebf01b6189d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2df8051-7024-380e-a942-bd8927f94542",
          "attributeId": "c2ed800c-0cd5-4a76-adce-e315b65bf765",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8a524894-339d-42eb-d3a3-713f72652afd",
          "attributeId": "f619adde-1faa-4560-94ef-0e83714e067c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f44ea9c9-be98-6084-d54e-f764fb3826b7",
          "attributeId": "68dd7da4-94ed-4401-9895-e22c3d8a8e71",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c99f6ad7-92ea-be32-feb7-0271416cb489",
          "attributeId": "c6a061e3-229c-462d-90e2-35acfc735fd8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8530355-fb19-cc2b-bd1f-9775a18f2f5f",
          "attributeId": "8e081f3f-77f3-49ec-9388-77edd594c8dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "101039a7-efdf-c1ab-b831-4556b4d2a7bd",
          "attributeId": "eacf1752-f109-4c4d-8219-1932c08c467c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8e9692e-ca00-25ef-432e-c1f11bd2d7ca",
          "attributeId": "01ec6849-8f6d-4d77-98a1-3c9cad29afb6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab4ce3bd-56f3-f6c9-a4de-3248949e0b71",
          "attributeId": "91cf943b-610e-40a0-aa88-2910fb679c27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5751a653-a7be-f416-a99e-f434986ad28d",
          "attributeId": "df70459b-50df-48ae-9f54-53a35cc60414",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "126319e1-ddfd-da00-c7d1-f920b3f0c14e",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName",
          "parentId": "5751a653-a7be-f416-a99e-f434986ad28d",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "90ee21ac-e8c2-9870-5755-9ff255e468af",
          "attributeId": "5958b446-a320-41b6-8a09-bfb1bddf8429",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "79185a8f-10a4-545e-f740-89a83cef7529",
          "attributeId": "439de409-d7af-45df-b742-fb94059a4208",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "166392ec-db4d-b874-16d9-41c531b5cf5d",
          "attributeId": "0b83a30f-b46c-4d5f-bf85-8472c188b02d",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__AddressBook_totalcount"
    },
    {
      "id": "0399dcde-a3f6-5dfe-7cdb-a466f2533ab0",
      "entityId": "08c52333-7dcf-456b-af56-c30cf818f6c1",
      "filter": "SampleMappingsFilter",
      "control": "MappedOrganisations",
      "dataMap": [
        {
          "id": "8a095466-40c2-9aa3-6e17-036ddf23937a",
          "attributeId": "b6869873-d1dd-474f-a804-16faba21fc72",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b34b1b1-7aa1-fd6b-65d8-d2ddf0875263",
          "attributeId": "400fafbc-52f6-4ab3-8760-f0f699516ca8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9209cf24-3976-f6b3-aabb-9664a1b18fac",
          "attributeId": "83da3ded-2adb-4d43-a25f-5e64f7608605",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57a240cf-a0e2-e729-4167-1b10a25f615c",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName2",
          "parentId": "9209cf24-3976-f6b3-aabb-9664a1b18fac",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__MappedOrganisations_totalcount"
    },
    {
      "id": "e7af6502-1ece-9ba4-5fc9-47b1e95c1b94",
      "entityId": "11362fb2-6363-4042-bd07-b786ef81f86b",
      "filter": "SampleMappingsFilter",
      "control": "OrganisationRemarks",
      "dataMap": [
        {
          "id": "220a60f1-9f84-ef18-1d91-5fa819e9a261",
          "attributeId": "a0d35614-4ea6-4b38-9d0b-449208977482",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "59424cb5-5007-c207-0996-ba28514ff702",
          "attributeId": "593a53f2-e483-43fa-812a-733cd546f844",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3cc3db57-6c83-3440-b455-8ba4b572dd84",
          "attributeId": "fbc37fc4-7b06-4e88-9cae-2caae9a3fcd8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63c2aa2a-b9fd-56b0-ddaa-5fe52fa8ce74",
          "attributeId": "31f9bdbf-51bb-49b7-adcc-3608113a5d8b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b15466e1-e3b8-3511-8862-7f3fdef63699",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName3",
          "parentId": "63c2aa2a-b9fd-56b0-ddaa-5fe52fa8ce74",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__OrganisationRemarks_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='22cdf459-84e7-4174-a19b-79618f6f383b';

UPDATE [dwMetadata] SET
[Id]='27dbfadb-0e83-4acd-af28-35a760e3239b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-22 03:22:02.267', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2026-01-22T03:22:02.1693497+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
	{
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnQnnTrigger"
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

