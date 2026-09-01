-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzGlobalMailerMessage.json
-- SwzGlobalMailerMessage-settings.json

UPDATE [dwMetadata] SET
[Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.460', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-04 20:22:13.140', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Global Mail Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5><p>{EmailSubj}</p>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5>{MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>{EmailFrom}<p/>\n\n",
        "isHtml": true
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Scheduled time:</h5>{ScheduledDate}<p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_1",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">For Status:</h5><p name=\"status\"><p/>",
            "isHtml": true
          },
          {
            "key": "StatusCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "ForStatus_Title",
                "name": ""
              }
            ],
            "readOnly": true,
            "hierarchical": false,
            "disableAdd": true,
            "disableDelete": true,
            "header": false,
            "events": {},
            "collapseAll": false,
            "draggable": false,
            "style-hidden": true
          }
        ],
        "other-visibleConition": "data.StatusCollection.length !== 0"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_4",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">This scheduled job is cancel</h5><p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ],
        "other-visibleConition": "data.JobIsCanceled"
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cancelJob",
        "data-buildertype": "button",
        "content": "Cancel Job",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "cancelJob"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "!data.JobIsCanceled && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "value": "/form/SwzGlobalMailer",
                "name": "target"
              }
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "input_1",
    "data-buildertype": "input",
    "label": "",
    "fluid": true,
    "onChangeTimeout": 200,
    "placeholder": "Filter by UID",
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "setFilter",
          "applyFilter"
        ],
        "targets": [
          "gridview_1"
        ],
        "parameters": [
          {
            "name": "column",
            "value": "UID"
          }
        ]
      }
    },
    "style-marginBottom": "20px",
    "style-width": "300px"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "UID ASC",
    "pagerType": "server"
  }
]' WHERE [Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf';

UPDATE [dwMetadata] SET
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-04 20:22:13.230', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2021-08-04T20:22:13.2300118+08:00",
  "entityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "2233d8bb-2753-7adc-140a-f3713ed2bd19",
      "attributeId": "51458d0d-a57e-415d-af77-0506b62b2deb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e737ab32-149c-f374-034e-dbe21901d118",
      "attributeId": "178e7c32-3be5-46ae-8ab1-94a6504f1a2b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78945706-2fd2-e046-bfdb-bc96647a242b",
      "attributeId": "7c6620ef-f482-49bd-86bd-86ec78fa23ee",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "80e9b5b6-e9d0-d6c6-7820-fda90a42cdca",
      "attributeId": "04e1e5d0-d802-4a29-92ab-221ff60efb6c",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "cc3532d7-a661-48ec-434f-ecbf5d6f4c37",
      "attributeId": "868d7019-916a-41a2-ad9c-80e83c3e7146",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37108dd-6858-a497-a9bb-a8a61d9d4a62",
      "attributeId": "cf5185ac-386f-4c17-9b43-d81346e47627",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "00f5b7a6-98e0-e43d-bdfb-7130427ac87b",
      "attributeId": "7f4eb9fe-d50d-4b90-be34-5f81b48a005f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbc3f2c9-8468-1e35-8b28-186bd9130f4c",
      "attributeId": "25163e9e-6d07-4423-bef6-5203af0926cf",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "4c82c383-7898-02c4-46e8-c5048e9d98e1",
      "attributeId": "a59d6ab1-d8f1-4092-a7b2-5302d788b52a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d7efc1d-18a9-1188-aaab-64a342757ed9",
      "attributeId": "e24601f7-a005-4dc1-b76b-2e4ced2c9f47",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9ee0391-52e3-87a4-554f-0b077751cef3",
      "attributeId": "ffc06abf-996d-41b7-8aee-f8ee9b573217",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e3246e2e-23df-9c09-498d-019c4037fbaf",
      "attributeId": "b34d67a4-bfc5-4ee0-9112-d7ddffbfd570",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c40f8b2-4c30-f7bc-e027-d37ee84d4bfd",
      "attributeId": "603cb5e3-af1f-4288-8659-9d041999c4d4",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "19190086-6d45-9e40-be40-9531abc43cd7",
      "attributeId": "98daf50e-4248-4701-8fdd-17dacdd94355",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfe6fd82-2f3c-1d8e-ca6f-761aab03d8ef",
      "attributeId": "bb0f1b64-9144-4b35-916b-3a6292a0e774",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b0292df5-4b89-70ba-7594-fd5ba4e1f8bc",
      "entityId": "65091649-b0af-4091-86f9-7109aeb9fbf7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "attributeId": "8c53aed3-bbc5-420f-84f0-e6b8820052cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10d586e4-f3bf-dd0a-fdc5-8e00c0c5b388",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "e9dd17e6-7fdd-78ea-f15d-73b1202f750b",
          "attributeId": "1287529e-1bc7-465a-a53b-98cb619f253b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ce34148-ea28-4a48-8417-e7f8a16a222c",
          "attributeId": "1ffeb14b-0ab9-4ca5-ade4-2971477fe68b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "4ba1a0b1-27ae-1ffb-2156-315fff887e73",
      "entityId": "1aa13d9f-30a1-482e-9733-ee01420755f7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "fc90a4a8-8cf1-61a1-609c-fd1ec101de5f",
          "attributeId": "e958ec47-15ba-4f2a-9f06-b82631dc6a6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f4699a1-ab9d-1454-a2c7-647b982701af",
          "attributeId": "0e2eac76-0927-4eb7-8fdf-c5955a3d227a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf4d04ce-5cb5-202a-a744-9bee51e82991",
          "attributeId": "8b4aaa31-a559-4912-9397-09de90ac4e16",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a504a99-7cd1-4452-6ffc-7612b2961e92",
          "attributeId": "4853e87b-032f-48ce-b964-790b92b9e918",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d4e96d7-3e92-7958-6d7e-687c26985e75",
          "attributeId": "686137e7-c77f-43bd-9dd2-e6b79b4465aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96a42599-adad-d96f-c7e2-4ac67180323e",
          "attributeId": "907dfbd8-9670-4099-8dae-91b18986837c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}' WHERE [Id]='95150f4a-b078-48ac-a2a5-a12da83bf571';

