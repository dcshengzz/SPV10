-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AuditLog.json
-- AuditLog-settings.json
-- AuditLog-code.js

UPDATE [dwMetadata] SET
[Id]='f5168e8b-50fc-442b-ad6d-3e225324bd0e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-28 17:35:29.610', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-22 14:54:24.143', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Log Item Details",
    "size": "medium"
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
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirect"
                ],
                "targets": [],
                "parameters": [
                  {
                    "value": "/form/audittrail",
                    "name": "target"
                  }
                ]
              }
            },
            "secondary": true,
            "toggle": true,
            "floated": "right"
          },
          {
            "key": "Id",
            "data-buildertype": "input",
            "label": "Id",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "Division",
            "data-buildertype": "input",
            "label": "Organisation",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "UserName",
            "data-buildertype": "input",
            "label": "User Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "(data.UserId!=undefined && data.UserId!=null  && data.UserId!=\"00000000-0000-0000-0000-000000000000\")",
            "readOnly": true
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "Sample UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "(data.SampleId!=undefined && data.SampleId!=null  && data.SampleId!=\"00000000-0000-0000-0000-000000000000\")",
            "readOnly": true
          },
          {
            "key": "SampleName",
            "data-buildertype": "input",
            "label": "Sample Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "(data.SampleId!=undefined && data.SampleId!=null  && data.SampleId!=\"00000000-0000-0000-0000-000000000000\")",
            "readOnly": true
          },
          {
            "key": "EventType",
            "data-buildertype": "input",
            "label": "EventType",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "TableName",
            "data-buildertype": "input",
            "label": "TableName",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "RecordId",
            "data-buildertype": "input",
            "label": "RecordId",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "EventBatch",
            "data-buildertype": "input",
            "label": "EventBatch",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "ColumnName",
            "data-buildertype": "input",
            "label": "ColumnName",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "FormattedEventDate",
            "data-buildertype": "input",
            "label": "EventDate",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "text",
            "readOnly": true,
            "style-width": "200px"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "OriginalValue",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "{OriginalValue}",
                    "fetchData": false,
                    "events": {},
                    "style-customcss": "custom-label",
                    "isHtml": false,
                    "isPre": true
                  }
                ]
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_3",
                    "data-buildertype": "staticcontent",
                    "content": "New Value",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "{NewValue}",
                "isHtml": false,
                "isPre": true
              }
            ]
          }
        ],
        "placeholders": {
          "customblock_1": []
        }
      }
    ]
  }
]' WHERE [Id]='f5168e8b-50fc-442b-ad6d-3e225324bd0e';

UPDATE [dwMetadata] SET
[Id]='65d69bcf-b52e-4a1a-bc13-6b7e790652b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-28 17:35:29.720', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-22 14:54:24.173', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditLog",
  "lastUpdate": "2024-11-22T14:54:24.1736604+08:00",
  "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "304e429d-ce5b-b9b4-54eb-d5ec0c538524",
      "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
      "control": "ColumnName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32c35a41-24ce-72cf-4530-efa067b1d390",
      "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
      "control": "Division",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e5532fc-4eb3-20f0-96b5-c1f931ca62dd",
      "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
      "control": "EventBatch",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c066b0ff-78ae-7dd1-23ce-ba47d674d975",
      "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
      "control": "EventDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "94c0c6cf-46f5-c64d-b113-bc114a6c39f8",
      "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
      "control": "EventType",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a3f7b45a-9f71-8b5f-f3c9-231f493a0d4a",
      "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
      "control": "Id",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "34fbdd44-5b99-6787-86a0-2bb5e390e124",
      "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5914be1f-bf75-c808-1d27-0b782e044802",
      "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2a3270a-ba57-4fb5-de37-441995d4af36",
      "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
      "control": "RecordId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26c47cc3-1985-2d33-84ac-875a6532c86c",
      "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "be177a9d-c296-3b89-2a26-913a8429e0b7",
      "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
      "control": "SampleName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f1c774c-fe85-8b1a-353c-cbb9f835a65e",
      "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7264203e-5b32-6b62-2ea0-1e0a512f96ef",
      "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
      "control": "TableName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ef5f4eb2-e819-5ec0-de86-d77b058025ae",
      "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0823f6ef-4437-9c9e-9e66-ef365e80c83f",
      "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a1304e24-bc6b-d522-23f5-97280b8ab991",
      "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
      "control": "UserName",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Audit"
}' WHERE [Id]='65d69bcf-b52e-4a1a-bc13-6b7e790652b0';

UPDATE [dwMetadata] SET
[Id]='1787cccb-bc84-4e3a-9731-c60a9664e377', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-29 05:08:52.053', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-22 15:19:32.967', 
[Data]=N'{
     init: function(args){
        if(args.data.NewValue instanceof Array) {
            CloverApp.API.setDataField("NewValue", JSON.stringify(args.data.NewValue,null,"\t")); 
        }

        if(args.data.OriginalValue instanceof Array) {
            CloverApp.API.setDataField("OriginalValue", JSON.stringify(args.data.OriginalValue,null,"\t"));
        }

        const formattedEventDate = args.data.EventDate
            ?           (args.data.EventDate.getYear()+1900) 
                + "-" + (args.data.EventDate.getMonth()+1).toString().padStart(2,"0") 
                + "-" + args.data.EventDate.getDate().toString().padStart(2,"0")
                + " " + args.data.EventDate.getHours().toString().padStart(2,"0")
                + ":" + args.data.EventDate.getMinutes().toString().padStart(2,"0")
                + ":" + args.data.EventDate.getSeconds().toString().padStart(2,"0")
                + "." + args.data.EventDate.getMilliseconds().toString().padStart(3,"0")
            : null;
        CloverApp.API.setDataField("FormattedEventDate", formattedEventDate);
    }, 
    
}' WHERE [Id]='1787cccb-bc84-4e3a-9731-c60a9664e377';

