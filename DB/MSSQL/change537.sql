-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST_SAMPLE.json
-- QNN_LIST_SAMPLE-settings.json

UPDATE [dwMetadata] SET
[Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.530', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-12-03 16:53:07.357', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Manage Sample",
            "size": "large",
            "events": {}
          },
          {
            "key": "DictionaryListName",
            "data-buildertype": "dictionary",
            "label": "List Title",
            "fluid": true,
            "selection": true,
            "columns": "Name ASC",
            "dataModel": "QNN_LIST",
            "events": {},
            "other-required": true,
            "other-readOnlyConition": "true",
            "paging": true,
            "pageSize": "20",
            "filters": ""
          },
          {
            "key": "dictionarySample",
            "data-buildertype": "dictionary",
            "label": "Sample",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "other-customValidation": "value!=''00000000-0000-0000-0000-000000000000'' ?true:''Sample is requried''",
            "filters": ""
          },
          {
            "key": "dictionarySamplePeer",
            "data-buildertype": "dictionary",
            "label": "Sample Peer",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "clearable": true
          },
          {
            "key": "ActiveYN",
            "data-buildertype": "checkbox",
            "label": "Active Status",
            "toggle": true
          },
          {
            "key": "customBlockSampleProps",
            "data-buildertype": "customblock",
            "sourceType": "source",
            "source": "[]",
            "style-marginBottom": "1em"
          }
        ]
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
                  "saveProp"
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
          }
        ],
        "style-float": "left",
        "events": {},
        "style-source": "",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": "700px",
    "style-source": "clear: both;\nmaxWidth: 1050;\n",
    "style-marginTop": "10px",
    "style-customcss": ""
  }
]' WHERE [Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96';

UPDATE [dwMetadata] SET
[Id]='93a53d80-5afe-4eba-9b6c-b635ea424879', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.480', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-12-03 16:53:08.083', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_LIST_SAMPLE",
  "lastUpdate": "2024-12-03T16:53:08.0738556+08:00",
  "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "d3fcd0a7-f271-1814-0bdb-4d49b32326eb",
      "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "be26f972-5122-f200-8d78-e74fb5cd55fa",
      "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a565d76f-79a8-3bed-ce96-e787ad4164d3",
      "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a70f3313-0c44-6e58-37a3-9425445e7281",
      "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "622e9be6-151f-9edc-9937-e0607e2af60b",
      "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2bc23b6-3714-e347-819c-edda82506012",
      "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d27d197c-c3dc-6813-4789-68a10910e391",
      "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
      "control": "DictionaryListName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9df4d633-6819-b137-7dfa-f5284b394b99",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "parentId": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "isEditable": false,
      "isLoadable": true
    },
    {
      "id": "a0d749d9-08c8-bdd7-449a-f584627b6cfd",
      "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9f967df-5b61-c0b0-fb87-a8011db68bb8",
      "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a762c4ec-c806-6933-d52c-a63e364d6fff",
      "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0a1060c-64f1-1dc2-3e95-24b262c1f211",
      "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
      "control": "dictionarySample",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f6b56a50-4df1-08d6-47de-f2c839f12ac5",
      "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
      "control": "dictionarySamplePeer",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "List"
}' WHERE [Id]='93a53d80-5afe-4eba-9b6c-b635ea424879';

