UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='948AB167-D5B8-43DF-B3D7-41F3FE871887', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.950', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-21 11:33:19.203', [Data]=N'{
  "isSurvey": false,
  "name": "QNN_LIST",
  "lastUpdate": "2019-09-21T11:33:19.1716619+08:00",
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
      "id": "2a71279b-5c43-59ed-96e7-0f4e35e9a962",
      "attributeId": "f1a29960-54a0-4f4a-bd1e-521146d28625",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ca7559f5-2bb1-9ca3-df65-72516fecebce",
      "attributeId": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
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
