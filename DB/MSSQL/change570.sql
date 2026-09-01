-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMessage.json
-- dplyMessage-settings.json

UPDATE [dwMetadata] SET
[Id]='057eacaf-f332-4646-aa05-4e3d5656246a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:47.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-07-27 20:55:57.360', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Deployment Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5> {EmailSubj}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5> {MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>\n\n",
        "isHtml": true
      },
      {
        "key": "staticcontent_EmailFrom",
        "data-buildertype": "staticcontent",
        "content": "{EmailFrom}",
        "isHtml": false,
        "other-visibleConition": "(data.EmailFrom != null && data.EmailFrom != \"\")"
      },
      {
        "key": "staticcontent_EmailFromDefault",
        "data-buildertype": "staticcontent",
        "content": "<i>(Default Sender)</i>",
        "isHtml": true,
        "other-visibleConition": "(data.EmailFrom == null || data.EmailFrom == \"\")"
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
        "key": "statusContainer",
        "data-buildertype": "container",
        "children": [
          {
            "key": "StatusStatic",
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
          },
          {
            "key": "SampleCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Id",
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
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%",
    "events": {},
    "other-required": false
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "swzmodal_2",
        "data-buildertype": "swzmodal",
        "style-display": "none",
        "children": [
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-source": "clear: both;",
                "children": [
                  {
                    "key": "breadcrumb_1",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "url": ""
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
                "style-marginBottom": "20px",
                "style-float": "left"
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_4",
                    "data-buildertype": "staticcontent",
                    "content": "<i>(Changes to the email message text and schedule will also be applied to Mail Merge generation)</i>",
                    "isHtml": true
                  }
                ],
                "other-visibleConition": "(data.NotifyMerge!=null&&data.NotifyMerge==1)",
                "style-source": "clear: both;\nborder: 1px solid red;\npadding: 25px;",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_14",
                "data-buildertype": "container",
                "style-source": "clear: both;",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "<h5 class=\"ui header\">Status Filter</h5>",
                    "isHtml": true
                  },
                  {
                    "key": "dictionaryStatus",
                    "data-buildertype": "dictionary",
                    "label": "",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_STATUS",
                    "columns": "Title, NumberId ASC",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "20px",
                    "clearable": true,
                    "placeholder": "Select Status",
                    "multiple": true,
                    "other-visibleConition": "data.StatusCollection.length > 0",
                    "other-required": false
                  }
                ]
              },
              {
                "key": "container_13",
                "data-buildertype": "container",
                "style-customcss": "",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-visibleConition": "",
                    "style-marginBottom": "20px",
                    "events": {},
                    "other-required": false
                  },
                  {
                    "key": "emailSubj",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-visibleConition": "",
                    "style-marginBottom": "20px",
                    "other-required": false
                  },
                  {
                    "key": "scheduledDate",
                    "data-buildertype": "input",
                    "label": "Start From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "reference": "Start From",
                    "other-visibleConition": "",
                    "type": "datetime",
                    "style-marginBottom": "20px",
                    "other-required": true
                  },
                  {
                    "key": "formgroup_1",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "children": [
                      {
                        "key": "UseRawHtml",
                        "data-buildertype": "checkbox",
                        "label": "Use Raw HTML Template",
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px",
                        "events": {},
                        "toggle": true
                      },
                      {
                        "key": "htmlRaw",
                        "data-buildertype": "textarea",
                        "label": "",
                        "fluid": true,
                        "rows": "12",
                        "events": {},
                        "style-width": "100%",
                        "other-visibleConition": "data.UseRawHtml"
                      }
                    ],
                    "orientation": "grouped"
                  },
                  {
                    "key": "msgContentEditor",
                    "data-buildertype": "swzhtml",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "!data.UseRawHtml",
                    "other-customValidation": "",
                    "defaultValue": "",
                    "hideOutput": "block",
                    "other-required": true
                  }
                ],
                "style-source": "",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_15",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "button_SubmitMessage",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "updateProfileMailMerge"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btnCancel_1",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeModal"
                        ],
                        "targets": [
                          "swzmodal_2"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": false
                  }
                ],
                "style-marginTop": "20px"
              }
            ],
            "style-customcss": "ui message"
          }
        ],
        "content": "Edit",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "onEditClick"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "style-source": "",
        "size": "",
        "primary": true,
        "other-visibleConition": "!data.JobIsCanceled && data.MsgContentJson != null && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      }
    ],
    "style-float": "left"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cancelJob",
        "data-buildertype": "button",
        "content": "Cancel This Job",
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
        "content": "Exit",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "goBack"
            ],
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px",
    "style-float": ""
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
        "resizable": true
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "ToEmails",
        "name": "Sent To",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "CcEmails",
        "name": "CC",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "UID ASC",
    "pagerType": "server"
  }
]' WHERE [Id]='057eacaf-f332-4646-aa05-4e3d5656246a';

UPDATE [dwMetadata] SET
[Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:48.240', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-07-27 20:55:57.413', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMessage",
  "lastUpdate": "2025-07-27T20:55:57.404372+08:00",
  "entityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c9370afc-65af-ce1d-128b-ff72c191483e",
      "attributeId": "98ea38c9-6a0b-43c9-81e7-33c0fdf81664",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "745eb442-a214-4015-763d-c755eec82f9d",
      "attributeId": "53013ae2-ac53-49d9-8256-29517c8ce92d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2e313eff-505e-20bd-1d77-b769e682a84b",
      "attributeId": "05249853-6194-4045-b78a-b300b1261dbd",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "22c2ff97-d372-1635-b14c-5b85336111aa",
      "attributeId": "3827faa7-8f56-4657-b62f-3f0e2b741601",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "58d6ca3f-5562-1a2f-c667-264b808bc8e8",
      "attributeId": "59c5738d-c75c-48f3-a13d-89551dc8f265",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe10991b-03f6-819b-ea3d-d7c0d22e5a43",
      "attributeId": "617e73c0-cbc5-427c-8b5c-9b3eb9724eef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4e4f928-bbf0-3903-7f5b-e31155052692",
      "attributeId": "980ba3ed-445e-4048-84e4-aa8a5a894d03",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "742c9f5f-2e42-54f7-4d33-04341f347da7",
      "attributeId": "723a024e-c6b7-4a6d-8840-700288df74fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6931df1a-f300-025f-3f2d-1bacd4666f5f",
      "attributeId": "5aa6f5c9-ff71-45dc-aac4-069c32bd2e46",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d705f381-e567-d49c-7c16-5c6f4ffdd799",
      "attributeId": "91b7860e-858d-4fb2-8c34-e08911284e78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e29ebf-55bc-6cfe-af47-e9318c8cce94",
      "attributeId": "d8a72553-1d8e-4c67-8429-9055cb5c6679",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8d5ceaa9-dbf6-ce90-c5c6-364eee828eeb",
      "attributeId": "c43a9452-c591-440c-a1d4-e35201bfdd51",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d845079c-af30-193c-ffc1-a242f62aaa5b",
      "attributeId": "2081e372-56bf-4d2f-bf8f-0e41e9989215",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29783cdc-9668-53ac-4146-e3eadead99c0",
      "attributeId": "e5b3a81b-2dd8-4237-9792-99dde3d846fb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "58ef1b63-8f95-4994-1e53-83b7eb89b4fe",
      "attributeId": "59aa8497-8343-4a3e-9e58-08d0474ea25d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7484baa3-a364-76d7-63e3-8a9daa3f5e23",
      "attributeId": "0d5d3634-db52-47d2-b648-06aff68ef376",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe701f01-ff07-824a-9ab2-b21a4667e146",
      "attributeId": "bc72319c-27cd-4331-8aa4-d4d7440d4558",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b1ea41a7-4d9e-42af-8798-5df1a1742e55",
      "attributeId": "248da247-714b-4c8e-aabe-ae51b1a298d7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9b3fc79-8855-cfd1-ef83-b5d7665c6baf",
      "attributeId": "3e45f699-36e4-4ec2-b6d4-d79f08aa90d1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f92263b7-3937-a7f0-09cf-742e1f32328a",
      "attributeId": "bb235505-d84c-41c6-ae87-06603fabb6b0",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d66da26d-3666-017f-8186-c6b6d814ca15",
      "attributeId": "29bfaf0b-7047-4e34-b148-fa040deaf052",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2085efba-b81b-b6e2-6ff6-e691b7832e3f",
      "attributeId": "0a6ac3a9-3884-4171-a423-0b7f032ebbef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b7078366-a6b7-4618-bc98-8ce0387c03af",
      "attributeId": "cd7763ec-414c-4abd-a1d2-0046377e916e",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "14f54703-0bbb-b496-3fc3-fa6cdfa6b86f",
      "attributeId": "be830ce8-ca8b-41a5-993c-bcedbbe889a9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a13627f0-a868-26de-de41-23191869a002",
      "attributeId": "687ad667-bbbf-4584-9a38-0b48d0b4b92a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff060bce-473f-cb62-a009-4bc9b8112cbe",
      "attributeId": "b8365e45-58cf-4618-91a0-4bc1f9c97870",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0da158e6-e2dc-f265-de4c-06c107ec644d",
      "attributeId": "98282783-cd5c-4945-af3b-262377a1caeb",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "fbeaf2c0-69a1-6298-cb5e-abb7430a963b",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "ca44aea3-ad0c-52f8-7fe4-37e8588c2c77",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f7cc16b-bc81-3825-9a23-9a2a714d8d02",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62e684e4-e47c-0c38-f461-c687f995c9e4",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f984f169-9167-bd8d-5476-0a0021cb01a6",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6f28fa9-1c85-a87a-7a71-5dfab0fcbc71",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5203a0ea-f30f-4ad7-7d9e-15d441e63e6a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2fecf330-d1d7-8430-a7db-bd8ef94f486c",
          "attributeId": "6705a993-8496-4f31-a85d-29254a3bab4c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "974380df-5b6f-1854-5a4d-7d83738e5a9e",
          "attributeId": "82cae075-c642-4479-9621-a999a4785614",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    },
    {
      "id": "e22fb78e-4e0a-2bf8-2c31-9f742d39ab47",
      "entityId": "953e74a5-a493-4d79-a4d9-0ad32b7e1896",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "c9faad19-728c-f67d-708c-352975f48c51",
          "attributeId": "f31f1bc0-3a16-4699-84d4-b12a3ce6c66f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e6e385c-b484-5fc5-5668-add48805a469",
          "attributeId": "41ecf684-71cd-4d13-9535-1941227f974d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3be75909-d67f-c307-7bcd-e077038b6bd6",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "8e6e385c-b484-5fc5-5668-add48805a469",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "ceafde69-7498-063a-812b-c12bb8b77486",
          "attributeId": "293a7a59-6c38-4db2-b230-2c206e777614",
          "isEditable": true,
          "isLoadable": false
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__StatusCollection_totalcount"
    },
    {
      "id": "c5794574-42a8-e0a7-7367-0b179084d7f9",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "SampleCollection",
      "dataMap": [
        {
          "id": "ddf9c8a0-b505-92ec-0c2d-efd55ce3e561",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b657c9f3-8076-bcb4-a501-0cac9db7cb14",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a0df557-fb7f-a905-e0d5-65f9c7e62ae6",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4bfd4143-4ef1-1b4a-b877-8056a8e90ab7",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0936701e-4d83-bd91-ecf6-3212a4ddc11d",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "388a4722-ab91-3be5-5b24-3b9df981ae2a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81f54c84-78df-ff25-32a1-18b47d5b07eb",
          "attributeId": "6705a993-8496-4f31-a85d-29254a3bab4c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "00e336bd-8bd6-c784-d95e-7f9c52dea741",
          "attributeId": "82cae075-c642-4479-9621-a999a4785614",
          "isEditable": true,
          "isLoadable": false
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__SampleCollection_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0';

