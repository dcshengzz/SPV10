-- Will UPDATE existing row(s) in dwMetadata for the following:
-- swzsamplelist.json
-- swzsamplelist-settings.json

UPDATE [dwMetadata] SET
[Id]='29d6757b-a248-477d-a1d5-e5a4f7550f07', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzsamplelist.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 09:33:31.797', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-09-03 13:55:47.733', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "pageHeader",
        "data-buildertype": "header",
        "content": "Samples",
        "size": "huge",
        "textAlign": "left",
        "style-marginTop": "",
        "style-source": "padding-top:20px;",
        "style-marginLeft": "",
        "style-width": "250px",
        "events": {}
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "right",
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
        "style-source": "float:left"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Delete",
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
              "confirm",
              "gridDelete"
            ],
            "targets": [
              "grid"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "deleteSampleConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "deleteSampleConfirmText"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
        "style-source": "float:left",
        "inverted": false,
        "secondary": true,
        "compact": false
      }
    ],
    "style-marginRight": "20px",
    "style-width": ""
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "inputSearch",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": "350",
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
                "value": "Name, UID"
              }
            ]
          }
        },
        "placeholder": "Search by Name or UID"
      }
    ],
    "style-float": "left",
    "style-width": "300px"
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "children": [
      {
        "key": "inputSearchEmail",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": "350",
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
                "value": "ToEmails,CcEmails"
              }
            ]
          }
        },
        "placeholder": "Search by Email"
      }
    ],
    "style-float": "left",
    "style-width": "300px",
    "style-marginLeft": "20px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
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
        "width": ""
      },
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 150
      },
      {
        "key": "ToEmails",
        "name": "To Emails",
        "type": "",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 250
      },
      {
        "key": "CcEmails",
        "name": "CC Emails",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 250
      },
      {
        "key": "StructDivisionName",
        "name": "Organisation",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 150
      },
      {
        "key": "ActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 64
      },
      {
        "key": "LastLoginDate",
        "name": "Last Login Date",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "Name",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_SAMPLE",
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
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500",
    "style-width": "100%"
  }
]' WHERE [Id]='29d6757b-a248-477d-a1d5-e5a4f7550f07';

UPDATE [dwMetadata] SET
[Id]='e3aa01f6-089e-477b-bc56-7bb0a62ca971', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzsamplelist-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 09:33:32.437', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-09-03 13:55:47.760', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzsamplelist",
  "lastUpdate": "2025-09-03T13:55:47.7601469+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "71b48e2c-7b9b-17d7-d790-99f8533733ac",
      "entityId": "96aba12c-a596-46b1-b1dd-74a5ba60f3d6",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "7802862b-264f-9665-0e2a-fc1c19c09c8b",
          "attributeId": "e6eacd17-2f27-ac18-7687-28d1a200b555",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d51ef056-f852-bb20-19da-129d6fbb6944",
          "attributeId": "7a48d23c-8d3f-476f-b443-0f2c15c32f51",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c987c0f5-3b5c-8cb3-2b52-9081c25257a9",
          "attributeId": "ed15f27b-d27a-4f96-a87e-35487ef74f6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "301e61f9-24d5-135a-117d-9b8c7ad8e400",
          "attributeId": "cd0aed58-ed57-47c3-a6a8-e1348aff5e37",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b3ac5c6-2c17-3d2f-404f-a4cfbcaac451",
          "attributeId": "7465d37b-32c2-4447-b563-71121c49aecb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aed556ab-ed20-c7df-c08a-3394712a8193",
          "attributeId": "18273149-6b04-49c7-9b0d-ba476ca9c2d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6876cd45-29c9-2300-1e82-ca0fa140438e",
          "attributeId": "ec38a02c-e930-41b3-bb5d-993aa510d212",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d67afb34-df34-55d6-c80f-7f6f19f7fed2",
          "attributeId": "37f0c1bc-9266-41e7-89f3-9db71c52d805",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99c53890-e2f7-2d6b-6dd8-f511ec32ccae",
          "attributeId": "bd7d0d39-4d14-4ab8-8da4-630351b0b2b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9034192-c642-b31b-97a4-0910c2013734",
          "attributeId": "67f5a605-d9d5-480d-9eaf-a6bb0244cfb9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='e3aa01f6-089e-477b-bc56-7bb0a62ca971';

