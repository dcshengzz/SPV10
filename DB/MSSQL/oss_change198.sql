-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard-settings.json
-- respdashboard-code.js

UPDATE [dwMetadata] SET
[Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-04 19:02:55.193', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2021-10-04T19:02:55.1804587+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "ee290857-7d9d-2279-3c90-6a3c7e43dd0a",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\", DplyDateStart: \"<=@NOW\",  DueDate: \">=@NOW\", VisibleToRespondent:1,DplyWorkflowState:\"Active\"}",
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
          "id": "5c0ce6a5-5bfa-6db5-8d7d-f7497336c3d0",
          "attributeId": "9eb710fb-abce-48df-bcb7-10973ce31e6d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98c8878b-bb97-dc94-5e61-b73b25878d3c",
          "attributeId": "f84924a8-77d0-4b03-8f0a-fc97de0df311",
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
        },
        {
          "id": "478f65dc-b52f-032c-1065-c93960570c85",
          "attributeId": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f00a135c-c8fa-6da6-b081-3e5b200d2e7f",
          "attributeId": "5e31222f-ebf1-4707-a20f-33636fc4064b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0903d948-ea6e-eb0a-c6b0-33083623a6df",
          "attributeId": "45e33b1c-4b46-48ef-a5f2-eaccd6057395",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e6309118-87fe-3ae6-c470-63874361ced6",
          "attributeId": "d90b98b7-4fa0-4b64-8b66-cf30d6d39fc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "15a002fe-9ef9-68ca-bb12-8e9bf9bce58c",
          "attributeId": "c7ae7005-ac4a-4a29-b1cb-c30d844cbdcd",
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
      "parameter": "{UID:\"@UID\",  DueDate:\"<=@NOW\", VisibleToRespondent:1,DplyWorkflowState:\"Active\"}",
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
          "id": "4f4d8f86-0af8-2782-9b8f-1aca12ee39ad",
          "attributeId": "9eb710fb-abce-48df-bcb7-10973ce31e6d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f7d8370a-32ad-c125-5e9a-09fd73b953ef",
          "attributeId": "f84924a8-77d0-4b03-8f0a-fc97de0df311",
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
        },
        {
          "id": "076f23c8-1ee2-8743-8261-addda7bd670b",
          "attributeId": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a88237f-7d35-b1d8-131d-99c1d4b93c0c",
          "attributeId": "5e31222f-ebf1-4707-a20f-33636fc4064b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f7a38db-1457-27ec-be9c-5155239f862e",
          "attributeId": "45e33b1c-4b46-48ef-a5f2-eaccd6057395",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8f4ae206-342b-128e-f2aa-73afcf675673",
          "attributeId": "d90b98b7-4fa0-4b64-8b66-cf30d6d39fc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57cc98e3-4b50-d1e1-b3c2-aec3deee156d",
          "attributeId": "c7ae7005-ac4a-4a29-b1cb-c30d844cbdcd",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}' WHERE [Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b';

UPDATE [dwMetadata] SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-05 10:58:19.113', 
[Data]=N'{

    init: function(args){
console.log("Args", args);

        //-----------------------
        const loadingStart = function(loadingMessage) {
            console.log("loadingStart");
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            console.log("loadingStop");
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        //--------------------------------------------
        const getJsonRequest = function(url, searchParams) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if (!(searchParams === undefined || searchParams === null)) {
                if(!(searchParams instanceof URLSearchParams)) {
                    searchParams = new URLSearchParams(searchParams);
                }
                url = url + "?" + searchParams.toString();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                method: "get"
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to get data from server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    return responseData.success ? responseData : Promise.reject(responseData.message);
                }, reason => {
                    if(reason.message && reason.message.includes("Unexpected token") && !url.startsWith("/") && !url.startsWith("http")) {
                        console.warn(url + " appears to have returned a non JSON response. Is url correct? Should it start with a ''/'' ?");
                    }
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
        
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------

        const innerArgs = args;            
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA".toLowerCase();
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93".toLowerCase();

        const genFormLink = function(p, elements, languages, formName, index){
            const isMultipleResponse = !!p.row.IsMultipleResponse;
            const ipIsAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            if(ipIsAllowed) {
                //Render new response button for multiple response surveys
                if(isMultipleResponse && p.row.IsLatestResponse) {
                    const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                    const thisResponseIsComplete = !!p.row.RespDateEnd;
                    const noIncompleteResponses = (p.row.IncompleteCount===0);
                    const isCurrentSurvey = new Date(p.row.DueDate) >= Date.now();
                    const sampleResponseInProgress = (status===IN_PROGRESS);
                    
                    // console.log("for " + p.row.DplyName, p.row);
                    // console.log("thisResponseIsComplete", thisResponseIsComplete);
                    // console.log("noIncompleteResponses", noIncompleteResponses, p.row.CompleteResponses, p.row.IncompleteResponses);
                    // console.log("sampleResponseInProgress", sampleResponseInProgress, p.row.Status, IN_PROGRESS);
                    
                    const showActionAdd = isCurrentSurvey && sampleResponseInProgress && thisResponseIsComplete && noIncompleteResponses; 
                    
                    //console.log("showActionAdd", showActionAdd);
                    
                    if( showActionAdd ) {
                        const onClickNew = () => {
                            checkAccessCode(innerArgs, p, formName, ''new'');
                        };
                        elements.push(
                            CloverApp.API.createElement("span", { 
                                onClick: onClickNew  , className: "link-style", style: { color: "green", paddingRight: "0.5em" }
                            },''Add |'')
                        );
                    }
                }
                
                //Render Form link
                const onClickForm = () => {
                    checkAccessCode(innerArgs, p, formName, ''form'');
                };
                elements.push(
                    CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
                );
            } else {
                elements.push(
                    CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index])    
                );
            }
            elements.push( CloverApp.API.createElement("br") );
        };
        
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            loadingStart();
            postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( loadingStop );
        }; //end of createNewResponseAndOpen

        const promptForAccessCode = function(respId, dlsi, formName) {
            CloverApp.API.setDataField("AccessCodeRespId", respId);
            CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
            CloverApp.API.setDataField("AccessCodeFormName", formName);
            CloverApp.API.setDataField("AccessCode", "");
            innerArgs.component.refs.accessCodeModal.openModal();
        };
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };

        //checks access code with server and proceeds to form, upload, or code prompt accordingly
        const checkAccessCode = function(innerArgs, p, formName, control) {
            console.log("checkAccessCode", p, formName, control);
            const respId = p.row.RespId;
            const dlsi = p.row.Id;
            CloverApp.API.setDataField("AccessCodeControl", control); //submitAccessCode will use this too
            
            if(control == ''upload''){
                //this is for upload modal to work
                const qnnId = p.row.QnnId;
                const dplyId = p.row.DplyId;
                const listSampleId = p.row.ListSampleId;
                //rewrite the FileUploadUrl
                CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                    model.customPostUrl = "/respondent/uploadexcelresponse?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                    model.onUploadBegin = () => loadingStart("Uploading response...");
                    model.onUploadEnd = loadingStop;
                });
                
                //create the language option
                CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
                CloverApp.API.setDataField("UploadQnnId", p.row.QnnId);
                CloverApp.API.setDataField("UploadDplyId", p.row.DplyId);
                CloverApp.API.setDataField("UploadListSampleId", p.row.ListSampleId);

                const formNames = p.row.FormNames.split(''||'');
                const languages = p.row.Languages.split(''||'');
                CloverApp.API.setDataField("UploadFormNames", formNames);
                
                if(Array.isArray(formNames) && formNames.length>0) {
                    const options = [];
                    for(var i=0; i<formNames.length; i++) {
                        options.push( {
                            key: i,
                            value: i,
                            text: languages[i],
                        } );
                    }
                    CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                    CloverApp.API.setDataField("UploadFormChoice", 0);
                } else {
                    CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                    CloverApp.API.setDataField("UploadFormChoice", null);
                }
            } //end of if control is upload
            
            if(p.row.RequireAccessCode) {
                loadingStart("Loading");
                getJsonRequest("/respondent/accesscode", { dlsi }).then(
                    result => {
                        const codeVerifiedSuccessfully = result.item.validated;
                        if(codeVerifiedSuccessfully) {
                            switch(control) {
                                case ''form'':
                                    redirectToSurvey(dlsi, formName, respId);
                                    break;
                                case ''upload'':
                                    innerArgs.component.refs.fileUploadModal.openModal();
                                    break;
                                case ''new'':
                                    createNewResponseAndOpen(dlsi, formName);
                                    break;
                            }
                        } else {
                            promptForAccessCode(respId, dlsi, formName);
                        }
                    }, reason => {
                        alertify.error(response.message);
                        console.log(response);
                    }
                ).finally(loadingStop); 
            } else { //if dont require access code
                if(control == ''form''){
                    redirectToSurvey(dlsi, formName, respId);
                }else if(control == ''upload''){
                    promptForUpload();
                }
            }
            
        }; //end of checkAccessCode
        
        const openDelegateModal = function(innerArgs, p) {
            CloverApp.API.setDataField("DelegateFromName", "");
            CloverApp.API.setDataField("DelegateCode", "");
            CloverApp.API.setDataField("DelegateName", "");
            CloverApp.API.setDataField("DelegateComments", "");
            CloverApp.API.setDataField("DelegateEmail", "");
            CloverApp.API.setDataField("DelegateValidityStart", JSON.parse(JSON.stringify(new Date())) );
            CloverApp.API.setDataField("DelegateValidityEnd", p.row.DueDate);
            CloverApp.API.setDataField("DelegateDlsi", p.row.Id);
            innerArgs.component.refs.delegateModal.openModal();
        };

        const getPasswordAsync = function (args, id) {
            const formData = new FormData();
            formData.append(''id'', id);
            fetch("/respondent/getpassword", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }).then( response => response.json()
            ).then( response => {
                if (response.success) {
                    //console.log("getPasswordAsync args", args);
                    args.controlRef.refs.passwordModal.openModal();
                    args.component.state.data.password = response.item;
                    args.component.refs.password.forceUpdate();
                    //console.log(''response.item'', response.item);
                } else {
                    alertify.error(response.message);
                }
            }).catch(error => {
                alertify.error(error.message);
            });
        }; //end of getPasswordAsync 
        
        const formColumnFormatter = function (p) {
            if(p.row.Type=="Online"){
                const formNames = p.row.FormNames.split(''||'');
                const languages = p.row.Languages.split(''||'');      
                let elements = [];
                formNames.forEach( genFormLink.bind(null, p, elements, languages) );
                return CloverApp.API.createElement("div", {}, elements);  
            }
            else{
                return CloverApp.API.createElement("div", {}, p.value); 
            }
        }; //end of formColumnFormatter

        const fileColumnFormatter = function(p) {
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            //console.log("In fileColumnFormatter for "+p.row.QnnTitle+" for deployment "+p.row.DplyName+". hasOnlineFiles="+hasOnlineFiles+", isExcelEnabled="+isExcelEnabled+", row:", p.row);
            if(hasOnlineFiles && isExcelEnabled){
                const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
                const fileNames = p.row.FileNames.split(''||'');
                const fileLanguages = p.row.FileLanguages.split(''||'');
                const fileTokens = p.row.FileTokens.split(''||'');      
                let elements = [];
                for(let i=0; i < fileNames.length; i++) {
                    let element;
                    if(ipAllowed) {
                        const linkUrl = "/respondent/download/file/" + p.row.Id + "/"  + fileTokens[i] + "/" + p.row.RespId;
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);
                    } else {
                        element = CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, fileLanguages[i]);
                    }         
                    elements.push(element);
                    elements.push( CloverApp.API.createElement("br") );
                    //elements.push( CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ") );
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }  
        }; //end of fileColumnFormatter
        
        const excelButtonFormatter = function(p) {
            const isExcelEnabled = p.row.IsExcelEnabled;
            const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const status = p.row.Status ? p.row.Status.toLowerCase() : "";
            if(isExcelEnabled && hasOnlineFiles && ipAllowed && (status===PENDING || status===IN_PROGRESS) ) {
                const formNames = p.row.FormNames.split(''||'');
                const languages = p.row.Languages.split(''||''); 
                return CloverApp.API.createElement(
                    "button", {
                        onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''),
                        className: "ui button secondary invert",
                    }, "Upload Excel"); 
            }
            else if(isExcelEnabled && hasOnlineFiles && ipAllowed && !(status===PENDING || status===IN_PROGRESS) ){
                return CloverApp.API.createElement("button", {className: "ui button disabled" }, "Upload Excel");
            }
            else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of excelButtonFormatter

        const actionsColumnFormatter  = function (p) {
            const excelButton = excelButtonFormatter(p);
            return CloverApp.API.createElement("div", {}, [excelButton]);
        }; //end of actionsColumnFormatter

        const delegateColumnFormatter = function (p) {
            const requireAccessCode = p.row.RequireAccessCode;
            if(requireAccessCode){
                return CloverApp.API.createElement(
                    "button", {
                        onClick: () => openDelegateModal(innerArgs, p), 
                        className: "ui button secondary invert",
                    }, "Delegate");
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of delegateFormatter

        //Current surveys grid
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.sortable = false; 
                cols.File.sortable = false; 
                cols.Actions.sortable = false;
                cols.Form.customFormatter = formColumnFormatter;
                cols.File.customFormatter = fileColumnFormatter;
                cols.Actions.customFormatter = actionsColumnFormatter; //upload
                cols.Delegate.customFormatter = delegateColumnFormatter;                
            }
            return model;
        }; //end of gridModelRewriter
            
        //Previous surveys grid    
        const gridviewModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.sortable = false;
                
                cols.Form.customFormatter = formColumnFormatter;
            }
            return model;
        }; //end of gridviewModelRewriter
            
        //fetch and display respondent portal messages
        $.get("/swzdata/getmultiple?type=RespDashboard").done(
            function (data) {
                if(data.success) {
                    var htmlData = [];
                    for (var i=0; i<data.data.length; i++){
                        htmlData.push(data.data[i].editorState);
                    }
                    CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
                } else {
                    console.log(data.message);
                }
            }
        ).fail(
            function (jqxhr, textStatus, error) {
                console.log(textStatus);
            }
        ); 
        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
        CloverApp.API.rewriteControlModel("gridview", gridviewModelRewriter);
        
        //when uncommented it causes scrollbar reset issue
        //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        //args.component.refs.grid.refresh();
        //args.component.refs.gridview.refresh();
        
    }, //end of init
    
    closeAccessCodeModal: function(args) {
        args.component.refs.accessCodeModal.close();
        args.data.AccessCode = null;
        return {};
    },
    
    closeDelegateModal: function(args) {
        args.component.refs.delegateModal.close();
        CloverApp.API.setDataField("DelegateCode", "");
        return {};
    },

    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        args.data.AccessCode = null;
        return {};
    },

    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue;
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if("OK"===result) {
            args.component.refs.fileUploadModal.close();
            
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadDlsi = args.data.AccessCodeDlsi;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers uploaded");
            
            if(formName) {
                CloverApp.API.redirect(''form'', formName, ''dlsi/''+ uploadDlsi);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            } else if("RESTRICTED IP" === result) {
                errorMessage = "Your IP Address or Country is restricted from accessing this survey.";
            } else if ("INCORRECT ACCESS CODE" === result) {
                errorMessage = "Access Code is incorrect or has expired";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    },
    
    submitAccessCode: function(args) {
        //-----------------------
        const loadingStart = function(loadingMessage) {
        $(''body'').loadingModal({
            text: loadingMessage ? loadingMessage : ''Please wait...'',
            animation: ''foldingCube'',
            backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
        
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------
        
        //--------------------------------------------
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            loadingStart();
            postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( loadingStop );
        }; //end of createNewResponseAndOpen
        //--------------------------------------------
        
        const innerArgs = args;
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        const accessCode = args.data.AccessCode.trim();
        if(accessCode === undefined || accessCode === null || accessCode == "") {
            alertify.error("Please enter an Access Code");
            return {};
        }
        
        const respId = args.data.AccessCodeRespId;
        const dlsi = args.data.AccessCodeDlsi;
        const formName = args.data.AccessCodeFormName;
        const control = args.data.AccessCodeControl;

        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("accessCode", accessCode);
        loadingStart("Validating Access Code");
        postFormRequest("/respondent/accesscode", form).then(
            result => {
                if(result.item.validated) {
                    respdashboardUserActions.closeAccessCodeModal(innerArgs);
                    switch(control) {
                        case ''form'':
                            redirectToSurvey(dlsi, formName, respId);
                            break;
                        case ''upload'':
                            promptForUpload();
                            break;
                        case ''new'':
                            createNewResponseAndOpen(dlsi, formName);
                            break;
                    }
                } else {
                    alertify.error("Access Code is incorrect or has expired");
                }
            }, reason => {
                alertify.error(reason);
                console.log(reason);
            }
        ).finally(loadingStop);

    },
    
    delegate: function(args) {
        //-----------------------
        const loadingStart = function(loadingMessage) {
        $(''body'').loadingModal({
            text: loadingMessage ? loadingMessage : ''Please wait...'',
            animation: ''foldingCube'',
            backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
        
        const data = args.data;
        
        const dlsi = data.DelegateDlsi;
        const validityStart = data.DelegateValidityStart;
        const validityEnd = data.DelegateValidityEnd;
        const name = data.DelegateName;
        const email = data.DelegateEmail;
        const comments = data.DelegateComments;
        const delegateFromName = data.DelegateFromName;
        const delegateCode = data.DelegateCode.trim();
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        const displayTime = 15000;
        let validated = true;
        if(validityStart===undefined || validityStart===null || validityStart==='''') {
            alertify.error("Validity start date is required", displayTime);
            validated = false;
        }
        if(validityEnd===undefined || validityEnd===null || validityEnd==='''') {
            alertify.error("Validity end date is required", displayTime);
            validated = false;
        }
        if(validityStart >= validityEnd || validityEnd <= new Date()) {
            alertify.error("Invalid validity period", displayTime);
            validated = false;
        }
        if(email===undefined || email===null || email==='''') {
            alertify.error("Email address is required", displayTime);
            validated = false;
        }
        if(!emailRegExr.test(email)){
            alertify.error("Invalid email address", displayTime);
            validated = false;
        }
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to authorise the delegation", displayTime);
            validated = false;
        }
        if(name===undefined || name===null || name==='''') {
            alertify.error("Delegate''s name is required", displayTime);
            validated = false;
        }
        if(delegateFromName===undefined || delegateFromName===null || delegateFromName==='''') {
            alertify.error("Your name is required", displayTime);
            validated = false;
        }
        if(!validated) {
            return {};
        }
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("validityStart", validityStart);
        form.append("validityEnd", validityEnd);
        form.append("name",name);
        form.append("email", email);
        form.append("delegateFromName", delegateFromName);
        form.append("delegateCode", delegateCode);
        form.append("comments",comments);
        loadingStart("Delegating...");
        postFormRequest("/respondent/delegate", form).then(
            result => {
                alertify.success("Delegation recorded. An access code has been generated and sent to " + email, displayTime);
                args.component.refs.delegateModal.close();
            }, reason => {
                console.log(reason);
                alertify.error(reason, displayTime);
            }
        ).finally(loadingStop);
        
        return {};
    },
    
    openDelegateHistoryModal: function(args){
        //--------------------------------------------
        
        const gridDelegationModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Revoke.sortable = false;
                cols.Revoke.customFormatter = RevokeColumnFormatter;                
            }
            return model;
        }; //end of gridDelegationModelRewriter
        
        const RevokeColumnFormatter = function (p) {
            const status = p.row.Status;
            if(status == ''Active'' || status == ''Scheduled'' || status == ''Inactive''){
                return CloverApp.API.createElement(
                    "button", {
                        onClick: () => revokeDelegationById(args, p.row.Id), 
                        className: "ui button secondary invert",
                    }, "Revoke");
            } else {
                return CloverApp.API.createElement("div", {}, ""); 
            }
        };
        
        const revokeDelegationById = function(args, p) {
            console.log(p);
            $.post("/respondent/revokedelegationbyid",
            { delegateId : p,
              dlsi : args.data.DelegateDlsi,
              delegateCode : args.data.DelegateCode })
            .done(function (data) {
                if(data.success){
                    alertify.success(data.message);
                    // Refresh the grid with new data
                    $.post("/respondent/viewdelegatelist",
                    { dlsi : args.data.DelegateDlsi,
                     delegateCode : args.data.DelegateCode })
                    .done(function (data) {
                        if(data.success){
                            CloverApp.API.setDataField(''gridDelegation'', data.item);
                            args.component.refs.gridDelegation.refresh();
                        } else
                            alertify.error(data.message);
                    }).fail(function (jqxhr, textStatus, error) {
                     console.log(textStatus);
                    });
                } else
                    alertify.error(data.message);
            }).fail(function (jqxhr, textStatus, error) {
             console.log(textStatus);
            });
        };
        
        //--------------------------------------------
        
        CloverApp.API.setDataField(''gridDelegation'', null);
        
        const delegateCode = args.data.DelegateCode.trim();
        
        const displayTime = 15000;
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to view delegation history", displayTime);
            return {};
        }
        
        $.post("/respondent/viewdelegatelist",
        { dlsi : args.data.DelegateDlsi,
         delegateCode : delegateCode })
        .done(function (data) {
            if(data.success){
                CloverApp.API.setDataField(''gridDelegation'', data.item);
                CloverApp.API.rewriteControlModel("gridDelegation", gridDelegationModelRewriter);
                args.component.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegation.refresh();
            } else
                alertify.error(data.message);
        }).fail(function (jqxhr, textStatus, error) {
         console.log(textStatus);
        });
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        CloverApp.API.setDataField(''gridDelegation'', null);
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    revokeAllDelegation: function(args){
        $.post("/respondent/revokedelegationbydlsi",
        { dlsi : args.data.DelegateDlsi,
         delegateCode : args.data.DelegateCode })
        .done(function (data) {
            if(data.success){
                alertify.success(data.message);
                // Refresh the grid with new data
                $.post("/respondent/viewdelegatelist",
                { dlsi : args.data.DelegateDlsi,
                 delegateCode : args.data.DelegateCode })
                .done(function (data) {
                    if(data.success){
                        CloverApp.API.setDataField(''gridDelegation'', data.item);
                        args.component.refs.gridDelegation.refresh();
                    } else
                        alertify.error(data.message);
                }).fail(function (jqxhr, textStatus, error) {
                 console.log(textStatus);
                });
            } else
                alertify.error(data.message);
        }).fail(function (jqxhr, textStatus, error) {
         console.log(textStatus);
        });
    },

}








' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

