-- Will INSERT row(s) into dwMetadata for the following:
-- Organizations-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- Organizations.json
-- Organizations-settings.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'2cc2c415-7586-4bad-a1db-81d6da8a2c3d', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'Organizations-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-09-06 19:50:39.517', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-09-06 19:54:26.663', 
N'{
    init: function(args) {
        console.log(args);
        if(!CloverApp.API.checkRole(''Admins'')){
            const rewriter = function(model) {
                console.log("model", model);
                model.disableAdd = true;
            }
            CloverApp.API.rewriteControlModel("collectioneditor_1", rewriter);
        }
    },
}');

UPDATE [dwMetadata] SET
[Id]='a211ced0-595c-465a-bb8b-93b991246ec4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.013', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-06 21:12:21.453', 
[Data]=N'[
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "Save",
    "primary": true,
    "inverted": true,
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "validate",
          "save"
        ],
        "targets": [
          "collectioneditor_1"
        ],
        "parameters": []
      }
    },
    "compact": false
  },
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Organization Structure",
    "size": "large",
    "textAlign": "left"
  },
  {
    "key": "collectioneditor_1",
    "data-buildertype": "collectioneditor",
    "idField": "Id",
    "parentIdField": "ParentId",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "width": "30%"
      }
    ],
    "hierarchical": true,
    "disableAdd": false,
    "disableDelete": false,
    "header": true,
    "draggable": false,
    "collapseAll": false,
    "other-visibleConition": ""
  }
]' WHERE [Id]='a211ced0-595c-465a-bb8b-93b991246ec4';

UPDATE [dwMetadata] SET
[Id]='264a20b1-0b26-44c4-aa48-573103b8fc87', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.263', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-06 21:12:21.483', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "Organizations",
  "lastUpdate": "2021-09-06T21:12:21.484156+08:00",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "NullifyOrganizationParentAsyncTrigger",
      "parameter": "{ParentId: \"@null\"}"
    }
  ],
  "dataMap": [],
  "dataColl": [
    {
      "id": "795fa882-2c29-4a4f-1b1f-fdbc9b3e77fe",
      "entityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
      "filter": "ParentAsyncFilter",
      "parameter": "",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "00f387a3-77b7-72ce-ddfa-5799a92c5c16",
          "attributeId": "07e9391f-c1b3-4ae8-a228-6ea9228ac5be",
          "control": "",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4720db20-15a8-8cdf-d399-423b6dcac52b",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20aa074f-54eb-70c8-0bad-3899c0482a48",
          "attributeId": "e2f0469b-086d-4084-be71-2068e006a906",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Organization"
}' WHERE [Id]='264a20b1-0b26-44c4-aa48-573103b8fc87';

