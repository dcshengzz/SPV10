-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard.json
-- respdashboard-settings.json
-- respdashboard-code.js
-- DataEditorDeployment.json
-- DataEditorDeployment-settings.json
-- DataEditorDeployment-code.js
-- QNN_DPLY.json
-- QNN_DPLY-settings.json
-- QNN_DPLY-code.js
-- dplyListSample.json
-- dplyListSample-settings.json
-- dplyListSample-code.js
-- dplyMessages.json
-- dplyMessages-settings.json
-- dplyMessages-code.js

UPDATE dwMetadata SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-27 23:36:27.823', 
[Data]=N'[
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
          },
          {
            "key": "Delegate",
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
        "key": "delegateModal",
        "data-buildertype": "swzmodal",
        "content": "delegateModal",
        "secondary": true,
        "style-display": "block",
        "children": [
          {
            "key": "header_6",
            "data-buildertype": "header",
            "content": "Delegate Survey",
            "size": "medium",
            "subheader": "Delegate access to answer the survey to another user in your organisation."
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "DelegateEmail",
                "data-buildertype": "input",
                "label": "Delegate''s email address",
                "fluid": true,
                "onChangeTimeout": 200
              },
              {
                "key": "AccessCodeNote",
                "data-buildertype": "input",
                "label": "Survey access code for delegate to use",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px",
                "readOnly": true,
                "placeholder": "(Will be generated automatically by the system)"
              },
              {
                "key": "DelegateValidityStart",
                "data-buildertype": "input",
                "label": "Valid from",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "defaultValue": ""
              },
              {
                "key": "DelegateValidityEnd",
                "data-buildertype": "input",
                "label": "Valid until",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime"
              },
              {
                "key": "DelegateComments",
                "data-buildertype": "textarea",
                "label": "Comments  (optional)",
                "fluid": true,
                "rows": "3",
                "autoHeight": true,
                "style-width": "100%"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<hr/>",
                "isHtml": true
              },
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "Delegation Code Required",
                "content": "Please provide your delegation code to authorise the delegation or view the delegation history. Please note that this is the delegation code you were previously sent and NOT your CorpPass or SingPass password and NOT the access code the delegate will use to answer the survey.",
                "info": false,
                "positive": false,
                "negative": true
              },
              {
                "key": "DelegateName",
                "data-buildertype": "input",
                "label": "Your name  (optional)",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
              {
                "key": "DelegateCode",
                "data-buildertype": "input",
                "label": "Your delegation code",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelegate",
                    "data-buildertype": "button",
                    "content": "Delegate",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "delegate"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnCancelDelegate",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDelegateModal"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnDelegationHistory",
                    "data-buildertype": "button",
                    "content": "Delegation History",
                    "floated": "right",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "openDelegateHistoryModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": false,
                    "secondary": true
                  }
                ],
                "style-marginTop": "20px"
              }
            ]
          }
        ],
        "primary": false
      },
      {
        "key": "accessCodeModal",
        "data-buildertype": "swzmodal",
        "style-display": "block",
        "content": "accessCodeModal",
        "secondary": true,
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Access Code Required",
                "size": "medium",
                "textAlign": "left"
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "This survey is protected. Please enter the survey specific access or delegation code to access this survey. ",
                "style-marginBottom": "20px"
              },
              {
                "key": "AccessCode",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px",
                "style-marginTop": "20px"
              },
              {
                "key": "container_9",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btn_SubmitAccessCode",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "submitAccessCode"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btn_CancelAccessCode",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeAccessCodeModal"
                        ],
                        "targets": [
                          "accessCodeModal"
                        ],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ]
          }
        ]
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "ExcelFileUpload",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "file",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "excelFileUploaded"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ],
        "style-hidden": true
      },
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
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Upload survey response as an Excel file",
                "size": "medium",
                "subheader": "",
                "textAlign": "left"
              },
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
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "Click \"Upload Excel Response\" below to select a file to upload. <br/>\nUpload will commence immediately and if successful the survey will open for you to finalise and submit.\n<br/>\n<br/>",
                    "isHtml": true
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
                    "key": "UploadExcelButton",
                    "data-buildertype": "button",
                    "content": "Upload Excel Response",
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "promptForExcelFile"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
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
      },
      {
        "key": "delegateHistoryModal",
        "data-buildertype": "swzmodal",
        "content": "delegateHistoryModal",
        "style-display": "block",
        "events": {},
        "children": [
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_7",
                "data-buildertype": "header",
                "content": "Delegation History",
                "size": "medium",
                "textAlign": "left",
                "style-source": "float:left;"
              },
              {
                "key": "buttonCloseDelegateListModal",
                "data-buildertype": "button",
                "content": "Close",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "closeDelegateHistoryModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "style-marginLeft": "10px"
              },
              {
                "key": "RevokeDelegation",
                "data-buildertype": "button",
                "content": "Revoke Active Delegation",
                "primary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "revokeDelegation"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "secondary": true
              }
            ]
          },
          {
            "key": "gridDelegation",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "CreatedDate",
                "name": "Delegation Date",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "Email",
                "name": "Delegate To",
                "sortable": true,
                "filterable": false,
                "resizable": true
              },
              {
                "key": "ValidityStart",
                "name": "Validity Start",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "ValidityEnd",
                "name": "Validity End",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "Active",
                "name": "Active",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": 80
              }
            ],
            "autoHeight": true,
            "events": {},
            "pagerType": "",
            "defaultSort": "CreatedDate DESC",
            "rowKey": "CreatedDate",
            "style-marginTop": "80px"
          }
        ],
        "compact": true,
        "secondary": true
      }
    ],
    "events": {}
  }
]' WHERE [Id]='d6e12e1d-3384-4352-bf68-8210aa75d406';

UPDATE dwMetadata SET
[Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-27 23:36:28.233', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2021-06-22T13:45:15.1502518+08:00",
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
        },
        {
          "id": "478f65dc-b52f-032c-1065-c93960570c85",
          "attributeId": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
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
        },
        {
          "id": "076f23c8-1ee2-8743-8261-addda7bd670b",
          "attributeId": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}' WHERE [Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b';

UPDATE dwMetadata SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-27 23:37:44.710', 
[Data]=N'{

    init: function(args){
console.log("Args", args);

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
        
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + respId + ''/dlsi/''+ dlsi)                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ dlsi)                        
                }
        };
        //--------------------------------------------

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
                    const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    if(hasOnlineFiles){
                        const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed==undefined);
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            let element;
                            if(ipAllowed) {
                                const linkUrl = "/respondent/download/file/" + p.row.Id + "/"  + fileTokens[i] + "/" + p.row.RespId;
                                element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);
                            } else {
                                element = CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, fileLanguages[i]);
                            }         
                            elements.push(element);
                            elements.push( CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ") );
                        }
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }  
                };
                
                //Upload button
                cols.Actions.customFormatter = function (p) {
                    const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed==undefined);
                    const status = p.row.Status ? p.row.Status.toUpperCase() : "";
                    if(hasOnlineFiles && ipAllowed && (status==PENDING || status==IN_PROGRESS) ){
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
                
                //Delegate button
                cols.Delegate.customFormatter = function (p) {
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
                checkAccessCode(innerArgs, p, value);
            }, className: "link-style" }, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        
        var checkAccessCode = function(innerArgs, p, formName) {
            const respId = p.row.RespId;
            const dlsi = p.row.Id;
            
            if(p.row.RequireAccessCode) {
                loadingStart("Loading");
                getJsonRequest("/respondent/accesscode", { dlsi }).then(
                    result => {
                        if(result.item.validated) {
                            redirectToSurvey(dlsi, formName, respId);
                        } else {
                            CloverApp.API.setDataField("AccessCodeRespId", respId);
                            CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
                            CloverApp.API.setDataField("AccessCodeFormName", formName);
                            CloverApp.API.setDataField("AccessCode", "");
                            innerArgs.component.refs.accessCodeModal.openModal();
                        }
                    }, reason => {
                        alertify.error(response.message);
                        console.log(response);
                    }
                ).finally(loadingStop); 
            } else {
                redirectToSurvey(dlsi, formName, respId);
            }
        };
        
        var openDelegateModal = function(innerArgs, p) {
            CloverApp.API.setDataField("DelegateCode", "");
            CloverApp.API.setDataField("DelegateName", "");
            CloverApp.API.setDataField("DelegateComments", "");
            CloverApp.API.setDataField("DelegateEmail", "");
            CloverApp.API.setDataField("DelegateValidityStart", JSON.parse(JSON.stringify(new Date())) );
            CloverApp.API.setDataField("DelegateValidityEnd", p.row.DueDate);
            CloverApp.API.setDataField("DelegateDlsi", p.row.Id);
            innerArgs.component.refs.delegateModal.openModal();
        }
        
        var openUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            //console.log("innerArgs, qnnId, dplyId, listSampleId", innerArgs, qnnId, dplyId, listSampleId);

            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/respondent/uploadexcelresponse?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => loadingStart("Uploading response...");
                model.onUploadEnd = loadingStop;
            });
            
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

        //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        //args.component.refs.grid.refresh();
        //args.component.refs.gridview.refresh();
        
    }, //end of init
    
    closeAccessCodeModal: function(args) {
        args.component.refs.accessCodeModal.close();
        CloverApp.API.setDataField("AccessCode", "");
        return {};
    },
    
    closeDelegateModal: function(args) {
        args.component.refs.delegateModal.close();
        CloverApp.API.setDataField("DelegateCode", "");
        return {};
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

    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
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
                console.error("data", args.data);
                throw new Error("Missing required value");
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers uploaded");
            if(uploadFormChoice) {
                CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
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
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + respId + ''/dlsi/''+ dlsi)                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ dlsi)                        
                }
        };
        //--------------------------------------------
        
        const accessCode = args.data.AccessCode;
        if(accessCode === undefined || accessCode === null || accessCode == "") {
            alertify.error("Please enter an Access Code");
            return {};
        }
        
        const respId = args.data.AccessCodeRespId;
        const dlsi = args.data.AccessCodeDlsi;
        const formName = args.data.AccessCodeFormName;
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("accessCode", accessCode);
        loadingStart("Validating Access Code");
        postFormRequest("/respondent/accesscode", form).then(
            result => {
                if(result.item.validated) {
                    redirectToSurvey(dlsi, formName, respId);
                } else {
                    alertify.error("Access Code is incorrect or has expired");
                }
            }, reason => {
                alertify.error(reason);
                console.log(reason);
            }
        ).finally(loadingStop);
        return {};
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
        const email = data.DelegateEmail;
        const delegateCode = data.DelegateCode;
        const DelegateName = data.DelegateName;
        const delegateComments = data.DelegateComments;
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
            alertify.error("Please provide your password to authorise the delegation", displayTime);
            validated = false;
        }
        if(!validated) {
            return {};
        }
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("validityStart", validityStart);
        form.append("validityEnd", validityEnd);
        form.append("email", email);
        form.append("delegateCode", delegateCode);
        form.append("name",DelegateName)
        form.append("comments",delegateComments)
        loadingStart("Delegating");
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
        CloverApp.API.setDataField(''gridDelegation'', null);
        
        const delegateCode = args.data.DelegateCode;
        
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
    
    revokeDelegation: function(args){
        $.post("/respondent/revokedelegation",
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
    }

    
}








' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

UPDATE dwMetadata SET
[Id]='6e6bb37c-97cd-4c89-bfe2-4688e9d89e2f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 14:59:32.023', 
[Data]=N'[
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
        "key": "mdl_RejectResponse",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "rejectResponseModal",
        "style-display": "block",
        "children": [
          {
            "key": "header_3",
            "data-buildertype": "header",
            "content": "Reject Response",
            "size": "medium"
          },
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "This will reset the status of the selected response to pending and send an email to the sample.<br/>\nRemarks made below will be included in the email and a copy will be CC to you as well for reference.",
            "isHtml": true
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "RejectResponseRemarks",
                "data-buildertype": "textarea",
                "label": "Remarks",
                "fluid": true,
                "placeholder": "Remarks",
                "reference": "remarks",
                "rows": "4"
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          },
          {
            "key": "container_8",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btn_RejectResponse",
                "data-buildertype": "button",
                "content": "Reject Response",
                "primary": true,
                "secondary": false,
                "inverted": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "rejectResponse"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-marginRight": "20px"
              },
              {
                "key": "btn_CancelRejectResponse",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "cancelModal"
                    ],
                    "targets": [
                      "mdl_RejectResponse"
                    ],
                    "parameters": []
                  }
                },
                "style-marginRight": ""
              }
            ],
            "style-source": "text-align: right;",
            "style-width": "100%"
          }
        ],
        "style-source": "padding: 20px;"
      },
      {
        "key": "container_7",
        "data-buildertype": "container",
        "style-hidden": true,
        "children": [
          {
            "key": "ExcelFileUpload",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "file",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "excelFileUploaded"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ]
      },
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
            "content": "Upload survey response as an Excel file",
            "size": "medium"
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
                    "content": "Click \"Upload Excel Response\" below to select a file to upload. <br/>\nUpload will commence immediately and if successful the survey will open for you to finalise and submit.\n<br/>\n<br/>",
                    "isHtml": true
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "UploadExcelButton",
                    "data-buildertype": "button",
                    "content": "Upload Excel Response",
                    "buttonType": "",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "promptForExcelFile"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
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
            "key": "header_4",
            "data-buildertype": "header",
            "content": "Update Remarks",
            "size": "medium"
          },
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
                "key": "container_9",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Save Remarks",
                    "primary": true,
                    "secondary": false,
                    "inverted": false,
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
                  },
                  {
                    "key": "btn_CancelRemarksModal",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "cancelModal"
                        ],
                        "targets": [
                          "remarksModal"
                        ],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "100%",
                "style-marginTop": "20px",
                "style-marginBottom": "20px",
                "style-source": "text-align: right;"
              }
            ]
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "padding: 20px;",
        "style-hidden": false,
        "isOpen": "",
        "content": "remarksModal"
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
            },
            "placeholder": "Select new status"
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": "",
        "content": "statusModal"
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
        "isOpen": "",
        "content": "trkListModal"
      },
      {
        "key": "delegateHistoryModal",
        "data-buildertype": "swzmodal",
        "content": "delegateHistoryModal",
        "style-display": "block",
        "compact": true,
        "secondary": true,
        "children": [
          {
            "key": "container_10",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Delegation History",
                "size": "medium",
                "style-source": "float:left;"
              },
              {
                "key": "buttonCloseDelegateListModel",
                "data-buildertype": "button",
                "content": "Close",
                "primary": true,
                "floated": "right",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "closeDelegateHistoryModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ]
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "style-marginTop": "",
            "style-marginBottom": "50px",
            "style-source": "clear:both;"
          },
          {
            "key": "gridDelegate",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "CreatedDate",
                "name": "Delegation Date",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "Email",
                "name": "Delegate To",
                "sortable": true,
                "filterable": false,
                "resizable": true
              },
              {
                "key": "ValidityStart",
                "name": "Validity Start",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "ValidityEnd",
                "name": "Validity End",
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "Active",
                "name": "Active",
                "width": 80,
                "sortable": true,
                "filterable": false,
                "resizable": false
              }
            ],
            "rowKey": "CreatedDate",
            "defaultSort": "CreatedDate DESC",
            "autoHeight": true,
            "style-marginTop": "50px"
          }
        ]
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
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "key": "ActionsReject",
        "type": "custom"
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
        "resizable": true,
        "key": "Actions5",
        "type": "custom"
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
]' WHERE [Id]='6e6bb37c-97cd-4c89-bfe2-4688e9d89e2f';

UPDATE dwMetadata SET
[Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 14:59:32.173', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2021-06-22T14:53:30.3309273+08:00",
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
    },
    {
      "id": "14ee1d12-282d-7e2a-227d-a04682b9f06e",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "563d44e5-b373-7ce4-9396-393b8048548c",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2c10aa9-a84e-8652-e0d1-09f8b58346f8",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "898de757-596a-b36e-14db-facf115e67fa",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "02164652-3fae-a756-6ad7-3c5ff10f6860",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "99f9f3db-5e93-3bbd-8170-f3d6def5b716",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4879333f-cddb-05fb-d28a-001589f23de5",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8a15e500-d6c6-cee3-f2a1-031d74a8650b",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "43f40941-ce5e-2326-827b-69b2ee2ae6b6",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9ea64c57-9ec8-4755-cb19-de2c63a9547b",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfbd4e1a-23b1-e22b-26c6-42f4459f72e3",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9832d71-bdd9-fa77-3cd2-eb70e6d815a9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9bd2dd1-4892-b55e-62f1-565755bbfab6",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7e0286d2-b996-269d-ea4a-70a88b7a8251",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e8bdcd70-6784-8c12-4a12-da128039ddeb",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
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
}' WHERE [Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd';

UPDATE dwMetadata SET
[Id]='4af67164-5e60-4905-9885-afd6da24cb3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 14:34:12.637', 
[Data]=N'{
    init: function (args) {
        
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
                    return CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Remarks" + (p.row.Remarks!=null? '' ...'':''''));
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
                
                cols.ActionsReject.customFormatter = function (p) {
                    if(p.row.StatusCode==''SB''){
                        return CloverApp.API.createElement("button", { onClick: () => showRejectResponseModal(innerArgs, p.row.Id, p.row.RespId), className: "ui button mini secondary" }, "Reject");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Reject");
                    }   
                }; 
                
                cols.Actions3.customFormatter = function (p) {
                    return CloverApp.API.createElement("button", { onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), className: "ui button mini secondary" }, "Track" + (p.row.HasTrkListIds!=null? '' ...'':''''));
                };     
                
                cols.Actions4.customFormatter = function (p) {
                    const hasOnlineFiles = ("O"===p.row.Type) && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
                    if(hasOnlineFiles) {
                        if( p.row.StatusCode=="PE" || p.row.StatusCode=="DE") {
                            //Upload option is available for Pending and In-Progress
                            const formNames = p.row.FormNames.split(''||'');
                            const languages = p.row.Languages.split(''||''); 
                            return CloverApp.API.createElement("button", { onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id), className: "ui button mini secondary" }, "Upload");
                        } else {
                            //Show a disabled button for other status
                            return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Upload");
                        }
                    } else {
                        //No upload button for offline surveys or online surveys with no files
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                };
                
                cols.Actions5.customFormatter = function (p) {
                    if(innerArgs.data.RequireAccessCode)
                        return CloverApp.API.createElement("button"
                        ,{ onClick: () => openDelegateHistoryModal(innerArgs, p.row.Id), className: "ui button mini secondary" }
                        , "Delegate History");
                    else 
                        return CloverApp.API.createElement("div", {}, "");
                      
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

        var showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            loadingStart("Retrieving remarks");
            postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks");
                    alertify.error(reason);
                }
            ).finally(loadingStop);
        };
        
        var showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            loadingStart("Retrieving remarks");
            postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks for Reject Response modal");
                    alertify.error(reason);
                }
            ).finally(loadingStop);
        };
        
        var showUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/dataedit/uploadexcelresponse?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => loadingStart("Uploading response...");
                model.onUploadEnd = loadingStop;
            });
            
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
            loadingStart("Retrieving Track List Information");
            postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error(reason);
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(loadingStop);  
        };

        var showStatusModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);   
            CloverApp.API.setDataField("dlsi", id); 
            loadingStart("Retrieving Status Options");
            postFormRequest("/dataeditor/GetStatusItems", formData).then(
                response => {
                    //args.state.app.extra.spData = id;
                    //args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                    const options = response.item;
                    if(Array.isArray(options) && options.length>0) {
                        CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", options);
                        CloverApp.API.setDataField("dropdownStatus", null);
                    } else {
                        CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", {} );
                        CloverApp.API.setDataField("dropdownStatus", null);
                    }
                    
                    args.controlRef.refs.statusModal.props.swzData.isOpen = true;
                    args.controlRef.refs.statusModal.openModal();
                    
                    args.controlRef.refs.dropdownStatus.forceUpdate();
                }, reason => {
                    console.error("Failed to get status items", reason);
                    alertify.error(reason);
                    args.controlRef.refs.statusModal.close();
                }
            ).finally(loadingStop);
        }; 
        
        var openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField(''gridDelegate'', null);
            var url = ''/dataeditor/viewdelegatelist?dlsi='' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                if(data.message)
                    alertify.success(data.message); 
                CloverApp.API.setDataField(''gridDelegate'', data.item);
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error(data.message);
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            }); 
            args.controlRef.refs.delegateHistoryModal.props.swzData.isOpen = true;
            args.controlRef.refs.delegateHistoryModal.openModal();
        };  
        
        //used by Exempt
        var setStatus = function (args, id, statusId) {
            var formData = new FormData();
            formData.append(''id'', id);        
            formData.append(''selectedStatusId'', statusId);
            loadingStart("Setting Status");
            postFormRequest("/dataeditor/setStatus", formData).then(
                response => {
                    args.component.refs.grid.refresh();
                    alertify.success(response.message);
                }, reason => {
                    console.error("Failed to set status", reason);
                    alertify.error(reason);
                }
            ).finally(loadingStop);
        };
        
        //used by Reset
        var resetStatus = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            if(respId){
                formData.append(''respId'', respId);                
            }
            loadingStart("Resetting Status");
            postFormRequest("/dataeditor/resetStatus", formData).then(
                response => {
                    args.component.refs.grid.refresh();     
                    alertify.success(response.message);
                }, reason => {
                    console.error("Failed to reset status", reason);
                    alertify(reason);
                }
            ).finally(loadingStop);
        }; 
                

        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
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
        
        const modal = args.component.refs.remarksModal;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);
        formData.append("remarks", args.data.remarks ? args.data.remarks.trim() : "");
        loadingStart("Updating Remarks");
        postFormRequest("/dataeditor/setremarks", formData).then(
            response => {
                modal.close();
                alertify.success(response.message);
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue; //ExcelFileUpload
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if(result === "OK") {
            args.component.refs.fileUploadModal.close(); 
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId) || (!result)) {
                console.error("data", args.data);
                throw new Error("Missing required value");
            }
            const uploadFormChoice = args.data.UploadFormChoice;
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers updated from file");
            if(uploadFormChoice) {
                CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
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
        
        const remarks = args.data.RejectResponseRemarks ? args.data.RejectResponseRemarks.trim() : ""
        if(""===remarks) {
            alertify.error("Remarks are required here");
            return {};
        }
        
        const modal = args.component.refs.mdl_RejectResponse;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);  
        formData.append("respId", args.data.RejectResponseRespId);
        formData.append("remarks", remarks );
        loadingStart("Rejecting Response");
        postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success(response.message, 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error(reason, 15000);
                grid.refresh();
            }
        ).finally(loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
}






' WHERE [Id]='4af67164-5e60-4905-9885-afd6da24cb3d';

UPDATE dwMetadata SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 14:27:07.923', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left",
            "subheader": ""
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_23",
        "data-buildertype": "container",
        "children": [
          {
            "key": "workflowbar_1",
            "data-buildertype": "workflowbar",
            "events": {
              "onCommandClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowExecuteCommand",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              },
              "onSetStateClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowSetState",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "blockSetState": true,
            "other-visibleConition": ""
          },
          {
            "key": "container_21",
            "data-buildertype": "container",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<strong>State:</strong> {StateName}",
                "isHtml": true
              }
            ]
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "Remarks",
                "data-buildertype": "textarea",
                "label": "",
                "fluid": true,
                "style-width": "",
                "reference": "Remarks",
                "events": {},
                "placeholder": "Please append your remarks",
                "style-customcss": "ui fluid input",
                "other-required": false
              }
            ]
          },
          {
            "key": "formgroup_9",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": []
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "other-visibleConition": "data.Id && data.EnableWorkflow"
      },
      {
        "key": "formgroup_10",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "container_22",
            "data-buildertype": "container",
            "style-float": "right",
            "children": [
              {
                "key": "container_13",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "importModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "float: right;",
                    "secondary": true,
                    "content": "Import Response",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_1",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "header_3",
                            "data-buildertype": "header",
                            "content": "Import Response",
                            "size": "medium",
                            "events": {},
                            "other-visibleConition": ""
                          },
                          {
                            "key": "listFile",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "file",
                            "style-marginTop": "10px"
                          },
                          {
                            "key": "totalRows",
                            "data-buildertype": "header",
                            "content": "Total rows: {totalRows}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                          },
                          {
                            "key": "totalSampleResponseAdded",
                            "data-buildertype": "header",
                            "content": "Rows added: {totalSampleResponseAdded}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                          },
                          {
                            "key": "totalSampleNoResponse",
                            "data-buildertype": "header",
                            "content": "Rows not added (No response): {totalSampleNoResponse}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidUIDs",
                            "data-buildertype": "header",
                            "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidQnnColumns",
                            "data-buildertype": "header",
                            "content": "Total invalid columns: {totalInvalidQnnColumns}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                          },
                          {
                            "key": "moreModal",
                            "data-buildertype": "swzmodal",
                            "style-source": "",
                            "secondary": true,
                            "content": "More information",
                            "style-display": "none",
                            "children": [
                              {
                                "key": "form_2",
                                "data-buildertype": "form",
                                "children": [
                                  {
                                    "key": "form_2",
                                    "data-buildertype": "form",
                                    "children": [
                                      {
                                        "key": "container_13",
                                        "data-buildertype": "container",
                                        "style-float": "right",
                                        "children": [
                                          {
                                            "key": "invalidQnnColumns",
                                            "data-buildertype": "header",
                                            "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_1",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidColumns"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "invalidUIDs",
                                            "data-buildertype": "header",
                                            "content": "Invalid rows (UID): {totalInvalidRows}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_2",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidUIDs"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "totalInvalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                            "style-hidden": true
                                          },
                                          {
                                            "key": "invalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_3",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidDates"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "button_1",
                                            "data-buildertype": "button",
                                            "content": "Cancel",
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
                                                  "closeMoreModal"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "",
                                            "style-source": "float: right;",
                                            "inverted": false,
                                            "secondary": true
                                          }
                                        ],
                                        "style-marginRight": "",
                                        "style-width": "100%",
                                        "style-marginBottom": "",
                                        "style-source": ""
                                      }
                                    ],
                                    "style-source": "overflow-y: auto;\noverflow-x: auto;"
                                  }
                                ],
                                "style-source": "overflow-y: auto;\noverflow-x: auto;"
                              }
                            ],
                            "size": "",
                            "events": {
                              "onClick": {
                                "active": false,
                                "actions": [],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "other-customValidation": "",
                            "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                          },
                          {
                            "key": "container_17",
                            "data-buildertype": "container"
                          },
                          {
                            "key": "formgroup_7",
                            "data-buildertype": "formgroup",
                            "widths": "equal"
                          },
                          {
                            "key": "container_7",
                            "data-buildertype": "container",
                            "style-float": "right",
                            "children": [
                              {
                                "key": "btnImportCancel",
                                "data-buildertype": "button",
                                "content": "Cancel",
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
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;",
                                "inverted": false,
                                "secondary": true
                              },
                              {
                                "key": "btnImportSave",
                                "data-buildertype": "button",
                                "content": "Save",
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
                                      "submitFile"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;"
                              }
                            ],
                            "style-marginRight": "",
                            "style-width": "100%",
                            "style-marginBottom": "10px"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                    "style-marginLeft": ""
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "other-visibleConition": ""
              },
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageMessageHistory",
                    "data-buildertype": "button",
                    "content": "Manage Message History",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyMessages"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "buttonManageListSamples",
                    "data-buildertype": "button",
                    "content": "Manage List Samples",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyListSample"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "style-marginRight": "3.5px"
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageDataEditors",
                    "data-buildertype": "button",
                    "content": "Manage Data Editors",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplySampleOwner"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "floated": "right"
                  },
                  {
                    "key": "buttonManageImputation",
                    "data-buildertype": "button",
                    "content": "Manage Imputation",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyImputation"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''Imputation'')",
                    "floated": "right"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Manage Validation Data",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyValidation"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "btnManageRecurringDeployments",
                    "data-buildertype": "button",
                    "content": "Manage Recurring Deployments",
                    "secondary": true,
                    "floated": "right",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyRecurrence"
                          }
                        ]
                      }
                    }
                  }
                ],
                "style-float": "right",
                "style-width": "100%",
                "style-marginTop": "15px"
              }
            ]
          }
        ]
      }
    ],
    "style-width": "100%",
    "style-float": "right"
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
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {}
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required''",
                "other-readOnlyConition": "",
                "reference": "Questionnaire"
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required''",
                "other-readOnlyConition": "",
                "other-visibleConition": "",
                "reference": "List"
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": true
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": "",
                "other-required": true,
                "style-source": "z-index: 1000;"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "fg_RecurrenceInfo",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "This is a recurring deployment."
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Next Deployment Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": false,
                "readOnly": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3",
            "orientation": "grouped",
            "other-visibleConition": "data.RecurrenceEnabled"
          },
          {
            "key": "formgroup_5",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "VisibleToRespondent",
                "data-buildertype": "checkbox",
                "label": "Visible to Respondent",
                "defaultValue": "True",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_12",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "RequireAccessCode",
                "data-buildertype": "checkbox",
                "label": "Require Access Code",
                "defaultValue": "",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_11",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "EnableWorkflow",
                "data-buildertype": "checkbox",
                "label": "Enable Workflow",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setDplyState"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-readOnlyConition": "data.Id",
                "reference": "Enable Workflow"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_8",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "IsMultipleResponse",
                "data-buildertype": "checkbox",
                "label": "Allow Multiple Responses",
                "defaultValue": "0",
                "toggle": true,
                "events": {},
                "other-required": false,
                "other-readOnlyConition": "data.Id"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_6",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Is Anonymous",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleCompletionUrl"
                    ],
                    "targets": [
                      "textCompleteURL"
                    ],
                    "parameters": []
                  }
                },
                "other-required": false,
                "style-width": "50%",
                "other-readOnlyConition": "data.Id"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "Completion URL",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "",
                "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                "events": {},
                "style-marginLeft": "",
                "other-customValidation": "!(data.IsAnonymous== ''1''  && !value)? true : '' - Please provide completion URL for anonymous survey''",
                "style-width": "",
                "reference": "Completion URL"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL-3",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
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
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_18",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_5",
        "data-buildertype": "header",
        "content": "Restriction Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "RestrictIp",
        "data-buildertype": "checkbox",
        "label": "Ip Restriction",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setIpRestriction"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "reference": "Ip Restriction",
        "style-marginBottom": "20px",
        "defaultValue": "0"
      },
      {
        "key": "RestrictIpInclusive",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Inclusive",
            "value": "1"
          },
          {
            "value": "0",
            "text": "Exclusive"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
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
        "key": "countryOrIpRange",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Countries",
            "value": "1"
          },
          {
            "text": "IP Ranges",
            "value": "0"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "clearContent"
            ],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "IpCountry",
        "data-buildertype": "dropdown",
        "label": "IpCountry",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "SG",
            "text": "Singapore"
          },
          {
            "value": "MY",
            "text": "Malaysia"
          }
        ],
        "multiple": true,
        "reference": "Respondent Country",
        "placeholder": "Select countries",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
        "events": {}
      },
      {
        "key": "IpRange",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": true,
        "selection": true,
        "data-elements": [],
        "multiple": true,
        "search": true,
        "allowAddItems": true,
        "reference": "Ip Ranges",
        "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      }
    ]
  },
  {
    "key": "container_14",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_16",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "children": []
      },
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true,
            "search": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "30px",
    "style-marginBottom": "30px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "goBack"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]' WHERE [Id]='655275cf-8202-4438-b66b-874eab315889';

UPDATE dwMetadata SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 14:27:08.893', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2020-12-15T15:33:10.6506912+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

UPDATE dwMetadata SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-28 09:37:17.607', 
[Data]=N'{
     checkQnnFields: function(qnnId){
    
        var formData = new FormData();
        formData.append(''qnnId'', qnnId);
        var url = ''/qnn/checkfields'';
    
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (!response.success) {
                    alertify.alert(response.message);
    
                } 
            })
            .catch(error => {
                alertify.alert(error.message);;
            });
            

    },      
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    toggleCompletionUrl: function(args){
        
        if(args.data.IsAnonymous==1){
 
        }  
        else{
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    downloadEmailTemplate: function(args){
             var text = '''';
            text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
            text += ''Purpose of the Survey:\n''
            text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
            text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
            text +=''Submission of the Questionnaire:\n''
            text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
            text +='' \n''
            text +=''The following are your login information:\n''
            text +=''Company name: {Name}\n''
            text +=''Username: {UID}\n''
            text +=''Password: {Password}\n''
            text +='' \n''
            
            text +=''Other tokens:\n''
            text +=''Survey Url:{SurveyUrl}\n''            
            text +=''Deployment List Sample Id:{DplySampleInfoId}\n''                
            text +=''UID: {UID}\n''
            text +=''Password: {Password}\n''
            text +=''Questionnaire Name: {DplyQnn}\n''
            text +=''List Name: {DplyList}\n''
            text +=''Deployment Name: {DplyName}\n''
            text +=''Category Name: {DplyCategory}\n''
            text +=''UIDPeer: {UIDPeer}\n''
            text +=''Account Active Status: {ActiveYN}\n''
            text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
            
             var hiddenElement = document.createElement(''a'');
                hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                hiddenElement.target = ''_blank'';
                hiddenElement.download = ''EmailTemplate.txt'';
                hiddenElement.click();
    },
    downloadInvalidColumns(args){
//        CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');

    },
    downloadInvalidDates(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');
        
    },
    downloadInvalidUIDs(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');
        
    },
    viewArgs(args){
      console.log("View Args", args);  
    },
    submitFile(args){
        var token = args.data.listFile;
        var dplyId = args.data.Id;
        var qnnId = args.data.dictQuestionnaire;
        var listId = args.data.dictList;

        var errors = {};
        if (qnnId == null || qnnId == undefined)
         alertify.error("Questionnaire not selected");
        if (listId == null || listId == undefined)    
         alertify.error("List not selected''");
        if (dplyId == null || dplyId == undefined)    
         alertify.error("There is no existing deployment");
         
         if (token == null || token == undefined){
             errors.token = ''Please select csv file'';
                
            if(errors.token){
              throw {
                  level: 1,
                  message: ''Check errors on the form!'',
                  formerrors: {main: errors}
              };
            }
            return {};
        }
        
        var url = ''/deployment/importresponse?token='' + token + ''&qnnId='' + qnnId + ''&listId='' + listId + ''&dplyId='' + dplyId;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                     var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
                    
                    alertify.success(''The changes have been applied!'');
                    console.log("Response is", response);
                    
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("totalSampleResponseAdded", response.statistics.totalSampleResponseAdded);
                    CloverApp.API.setDataField("totalSampleNoResponse", response.statistics.totalSampleNoResponse);
                    CloverApp.API.setDataField("totalSampleResponseAnsAdded", response.statistics.totalSampleResponseAnsAdded);                    
                    CloverApp.API.setDataField("totalInvalidQnnColumns", response.totalInvalidQnnColumns);
                    CloverApp.API.setDataField("totalInvalidUIDs", response.totalInvalidUIDs);
                    CloverApp.API.setDataField("totalInvalidDates_Updated", response.totalInvalidDates_Updated);
                    CloverApp.API.setDataField("totalInvalidScore_Updated", response.totalInvalidScore_Updated);
                   
                    if(response.statistics.totalSampleResponseAdded !== null && response.statistics.totalSampleResponseAdded != undefined){
                            CloverApp.API.setDataField("invalidQnnColumns", response.invalidQnnColumns);
                            CloverApp.API.setDataField("invalidUIDs", response.invalidUIDs);
                            CloverApp.API.setDataField("invalidDates_Updated", response.invalidDates_Updated);
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                } else {
                    alertify.error("Invalid");
                    console.log(response.message);
                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, 
    closeModal: function (args){
        console.log("Close modal", args);
        args.component.refs.importModal.close();
        if(args.component.refs.moreModal !== undefined)
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []
                }
              }
            }
        }       
    },
    
     closeMoreModal: function (args){
        console.log("Close open modal", args);
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []//[totalSampleResponseAdded, totalSampleResponseAnsAdded, totalInvalidQnnColumns, totalInvalidUIDs, totalInvalidDates_Updated, totalInvalidScore_Updated, invalidQnnColumns, invalidUIDs, invalidDates_Updated]
                  }
              }
            }
        }       
    },
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            }            
             
            
        }  
        else{
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        


        return {hideControls: hideControls, showControls: showControls};
    },
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    },
    init: function(args) {
        
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
        }
        
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch{}
        }          

  var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
          var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
 
 
      var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
    
    // Only get category details
    // iff args.data.Id is not null
    
    var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
        var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
              qnn_dplyUserActions.showHideControls(args);  
              console.log("Response is", response);
                if (response.success) {
                    
                     var _hideControls = args.state.app.form.models.hideControls;
                     var items = response.items;
                    if (items != null)
                    {
                   
                    var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                    var valChkScheduler = obj[0].Id;
                    var EmailRecipients = obj[0].EmailRecipients;
                    var valEmailSuccess ;
                    var valEmailFailure ;
                     
                  if(obj[0].EmailSuccess == true)
                    {
                        valEmailSuccess = ''1'';
                    }
                  else
                       valEmailSuccess = ''0'';
                        
                  if(obj[0].EmailFailure == true)
                  {
                        valEmailFailure = ''1'';
                  }
                   else
                   {
                      valEmailFailure = ''0'';
                    }
                    
                   // var recipients = [];
                    
                     var recipients = [];
                    if(EmailRecipients == "No Recipient")
                    {
                        recipients = [];
                    }
                    else
                    {
                         var breakRecepient = EmailRecipients.split('','');
                         for (let r = 0 ; r < breakRecepient.length ; r++ )
                         {
                        recipients.push(breakRecepient[r]);
                    }
                    
                    }
               
                   /*// alert(items.length);
                    if(items !== undefined && items.length > 0){
                        _removeElement(_hideControls, dailySsForm);
                    }
                   // recipients.push(EmailRecipients);*/
                   
                   
                   
                   
                    CloverApp.API.setDataField("chkScheduler", 1);
                    CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                    CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                    CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                    
                    _removeElement(_hideControls, ''dailySsForm'');  
                    _hideControls.concat(hideControls);
                    return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: _hideControls
                                        }
                                    }
                                },
                            }
                        });  
                        
                    }
                    else
                    {
                        CloverApp.API.setDataField("chkScheduler", 0);
                        CloverApp.API.setDataField("ddlEmailReceipients", []);
                        CloverApp.API.setDataField("chkEmailSuccess", false);
                        CloverApp.API.setDataField("chkEmailFail", false);
                        return {
                            app: {
                                form: {
                                    models: {
                                        hideControls: args.state.app.form.models.hideControls
                                    }
                                }
                            }
                        };                    
                    }
                   
                    //  _loadingStop();
                   
                }
        
            })
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
  };
       
    },
    
     onClickSave: function (args){
  
    var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
          var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
   
  
  
      var data = args.data.chkScheduler;
      var dplyId = args.data.Id;
      
      var emailSuccess = args.data.chkEmailSuccess;
      var emailFail = args.data.chkEmailFail;
      var userId = args.data.ddlEmailReceipients;
      console.log(args.data);
      console.log(userId);         
   
            
        var formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);
        
      
        var url = ''/report/getJobData'';
          _loadingStart();
            fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                
                _loadingStop();
                if (response.success) {
              
                  //  alertify.success("");
              console.log(data);
              
               } else {
                   // alertify.success(" ");
                }

            })
           .catch(error => {
               alertify.error(error.message);;
            });

 
},
    
    parseHtml: function(args) {

        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData                            
                            }
                        }
                    }
                }
        };  
    },
    dropdownQuestionnaireOnChange: function(args) {
    },
    radioCompletionActionOnChange: function(args) {
    },
    radioCompletionNavBackOnChange: function(args) {
    },
    radioCompletionNavCancelOnChange: function(args) {
    },
    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },
    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }

    },

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
}












' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

UPDATE dwMetadata SET
[Id]='4ccdc858-527d-4321-8bee-942751feb26e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-28 11:09:57.753', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage list of samples specific to this deployment"
          }
        ],
        "style-float": "left"
      },
      {
        "key": "container_10",
        "data-buildertype": "container",
        "children": [],
        "style-float": "right"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "input_4",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
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
                    "value": "UIDName"
                  },
                  {
                    "name": "fieldName",
                    "value": "txtResend"
                  }
                ]
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-readOnlyConition": "",
            "placeholder": "Filter UID",
            "labelPosition": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "container_6",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_1",
                "data-buildertype": "input",
                "label": "Filter Due Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": ""
              },
              {
                "key": "input_5",
                "data-buildertype": "input",
                "label": "Filter Due Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "swzmodal_1",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "dueDate",
                    "data-buildertype": "input",
                    "label": "Due Date",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": true,
                    "inverted": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "changeDueDate"
                        ],
                        "targets": [
                          "gridview_1"
                        ],
                        "parameters": []
                      }
                    },
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Manage Due Date",
            "secondary": true,
            "inverted": true,
            "style-customcss": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageDueDate"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            }
          }
        ],
        "events": {},
        "style-marginTop": "20px",
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-customcss": "ui message"
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "dictionaryStatus",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter Status",
            "dataModel": "QNN_STATUS",
            "columns": "Title, NumberId ASC",
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
                    "value": "Status"
                  }
                ]
              }
            },
            "style-marginBottom": "20px"
          },
          {
            "key": "container_7",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_2",
                "data-buildertype": "input",
                "label": "Filter Generated Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              },
              {
                "key": "input_3",
                "data-buildertype": "input",
                "label": "Filter Generated Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "",
            "style-marginBottom": "20px"
          },
          {
            "key": "btnResetPassword",
            "data-buildertype": "button",
            "content": "Reset Password",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "sampleResetPassword"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "primary": true,
            "style-marginTop": "",
            "style-source": "float:left;\n",
            "style-marginBottom": "",
            "style-marginLeft": "",
            "style-marginRight": "10px",
            "floated": "left"
          },
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
                    "key": "container_12",
                    "data-buildertype": "container",
                    "style-float": "left",
                    "children": [
                      {
                        "key": "cbMailMerge",
                        "data-buildertype": "checkbox",
                        "label": "Mail Merge",
                        "toggle": true,
                        "slider": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbEmail",
                        "data-buildertype": "checkbox",
                        "label": "Email",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbProfile",
                        "data-buildertype": "checkbox",
                        "label": "Generate Profile",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "breadcrumb_1",
                        "data-buildertype": "breadcrumb",
                        "items": [
                          {
                            "text": "Download Template",
                            "active": false
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
                        "style-source": "padding-top: 20px;",
                        "style-width": "100%"
                      }
                    ],
                    "style-customcss": "",
                    "style-source": ""
                  },
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;"
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
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "subject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "scheduledDate",
                        "data-buildertype": "input",
                        "label": "Start From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "reference": "Start From",
                        "other-visibleConition": "data.cbEmail",
                        "type": "datetime",
                        "style-marginBottom": "20px"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": false,
                        "actions": [
                          "showModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail"
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": true,
                        "inverted": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "reSend"
                            ],
                            "targets": [
                              "gridview_1"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Send Message",
            "secondary": true,
            "inverted": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageResend"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "style-customcss": "",
            "style-source": ""
          },
          {
            "key": "container_16",
            "data-buildertype": "container",
            "children": [],
            "style-source": "clear:both;"
          },
          {
            "key": "button_6",
            "data-buildertype": "button",
            "content": "Reset Delegation Code",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "sampleResetDelegationCode"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "primary": true,
            "style-marginTop": "10px",
            "style-source": "float:left;\n",
            "style-marginBottom": "",
            "style-marginLeft": "",
            "style-marginRight": "",
            "floated": "left",
            "other-visibleConition": "data.RequireAccessCode == 1 ? true : false"
          }
        ],
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-marginTop": "20px",
        "style-marginLeft": "20px",
        "style-customcss": "ui message",
        "style-source": ""
      }
    ],
    "style-source": "clear: both;\n"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UIDName",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "PeerName",
        "name": "Peer UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response End",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "CreatedDate",
        "name": "Generated On",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pagerType": "server",
    "defaultSort": "UIDName ASC",
    "multiselect": true,
    "rowHeight": "80",
    "pageSize": "800"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Add New List Sample",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "addNewSample",
              "gridRefresh"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "addSampleConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "addSampleConfirmText"
              }
            ]
          }
        },
        "primary": true
      },
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Manage Message History",
        "secondary": true,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "dplyMessages"
              }
            ]
          }
        },
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Back",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true
      }
    ]
  }
]' WHERE [Id]='4ccdc858-527d-4321-8bee-942751feb26e';

UPDATE dwMetadata SET
[Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-28 11:09:58.493', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyListSample",
  "lastUpdate": "2021-06-28T11:09:58.4440251+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "bc832ee5-3bd0-ebf6-3bf8-25ff0947ac8e",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a54be7e1-6121-4fe3-fabf-c0fd241bd88c",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8eece4fd-92b9-89cb-9ce5-b033fdb22e6e",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bd8efd2f-4fe7-e6ba-c68e-e09f951af003",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4efb6b7b-e2e7-cc3e-f3cf-24818308da18",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c5261b6c-0d65-53ec-13dd-e702ae734de2",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d31d80a-df37-5b85-bc80-70ce9188cb3a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "848759d7-3c89-24e3-0376-87e075558973",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ae2fc8-d42b-68e0-e6fa-b5e75987ce3d",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a362a32-828a-0533-ec29-7c6ed2a15bc2",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c96969eb-0e90-27cf-ad4b-d81280319f35",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a292613-dd96-6200-8334-203d03b8dffd",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7e8e478-f1c2-f4f4-28ca-2aa868227e0e",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0afffdd2-98bc-b873-8fa7-1ac09711910e",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe20c92c-2272-cc47-b5c1-51bd07abe8cd",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b36376b8-bcd1-c703-feb9-93a2d1908859",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9ccf729f-2efd-8a11-9778-4042a4595b35",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e22b6e0f-7d71-53d5-7f38-3a338cd21939",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30122a30-2be2-34cc-62cf-edca9bc1f279",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7100e5fd-43b6-6f9b-08a4-9ec7a1c6fb1f",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a6b55cd-7b7f-1cef-f45b-7a65c6438e18",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7e882006-8c36-251c-c1f4-779501f5e200",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a7b7fed-328e-f039-94dd-3e55531421fe",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90a595c6-b385-22f0-e282-5335681d05a4",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3d9cd8bc-8f6b-6ae1-0011-938ef017356e",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "db0ad778-8c4e-102a-ee96-fd07b7962bec",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f2c73be5-9335-fdac-6c2d-3aefd3f5c330",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "378c33a0-8b8e-f6f8-24ae-d373e0b20ddc",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2d2e54a3-f54d-4b09-c0a7-16bf1295455f",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6ffdae77-294e-f26d-278e-c5d7ad98e466",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7fbcd7c8-5c5e-cc0a-f34c-43f5e57153e6",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0605f1f5-f7e6-76b3-fdd9-117b94272e70",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ec3acd3-ebd6-b5b2-8306-4f27a411c3fd",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "28ae03d5-840d-8a9b-7fd9-ed770e423c65",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ad302084-6af2-f876-8be9-7bc391c6206c",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c0392aa-22d8-7068-f11b-a8a767cf139d",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3f2998b-05d7-5101-16ae-ff40f914be02",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "acc6d514-6d18-60e4-9412-e089c00cbfa9",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6e16046c-270b-c90d-4acc-5d3da1114120",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0637b23-96fc-aa19-1849-03d637f7834f",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "006527c2-33f9-a184-664b-7d0aec2a53dd",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "396cc3dc-1aed-3bd7-f6cb-7affaf1a8035",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2e0a28d0-a4f6-369b-febd-8f9a18c84fde",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cd3d4fb1-4f4a-1b34-5a26-c67bff1c0a95",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "be4534fa-79ff-e548-9ee4-c76fef55aada",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f1108bd9-b354-605f-f6c5-8dbc0cfc0adf",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5bc115f-ced0-780c-656b-498286cc81d2",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b77d01d4-77d8-328e-c847-b03cc80dcbdb",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a332d64c-3ced-1ad2-8f9b-dc7028f55d18",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f54a6937-17c3-6a83-c0d0-2c16198062a0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "9c4efb38-5907-162e-3fea-df643d5420cc",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "9978fddc-eec3-9093-b0c8-5e3aca535b6e",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cc4f8d6e-aa8f-5022-be5e-fd884eb06a60",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "373aecb8-8d7d-3c8e-456b-2a66209b141a",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5a5722a5-a1b5-158a-1ae1-5ae945291aa7",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "029fbf4c-87a1-7a87-08a5-91ddbe384c50",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "49497f8f-99f7-77b5-4b77-ace3a1ce3846",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "75a570bd-0915-5eb2-5b22-8ece6cf5f7bf",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd5640b8-4db0-3f65-cc38-5ad3b40539e3",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b91a407d-7e52-c2f1-e639-444cf18166c5",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d83e259f-c5f6-511a-22b5-f941b7170fd3",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d917943a-118c-c411-5c32-cde2e20ea902",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f0a041e9-c9b9-7264-d4b9-951950f6befa",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "886f408a-a7bd-e0f1-0404-2f7e94503365",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b771d4be-9aab-5b84-2c43-e4a95a3877c9",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f1e4821a-06a4-188f-05b5-6ecb9cdb7310",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41fe8bba-6b0e-882d-946b-6055a92a0ef6",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da8cde09-24c4-a61f-b4ba-f9eb40b7461a",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6db86a5-399d-f074-aa08-df497d17c6cf",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0d11670f-0e66-6a63-786f-97d9601c86db",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "720a8aab-26dc-4fb1-a690-3008617b7107",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac20f89c-b63e-32bc-2d3f-1a7deb58e78f",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fcd415ed-1da7-1e97-3094-ed1a5e28f9b3",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb0bf43-fd73-a672-14ce-fdfccaaaadf4",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "808b68c5-48c0-2e06-3e46-a2423bf3c6d5",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e34d7a9-61b5-418a-14f2-8e4c2ab6175b",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e05861e-51e7-54ef-6d95-0193fc383391",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb4fec13-5a4c-9687-5b3c-a58dfc28cc05",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72f8e5d7-8712-69eb-c424-a1b656464b15",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "264b48ef-2b6c-562f-a6e6-e3e5391d5975",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9ada3a1-679e-d102-dff3-ec944c9102d5",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e520499-6e1c-2fdd-666a-47ade51dedc5",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06f1fdb9-5c93-bb44-cb12-448ddc83975a",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b284dc1-a531-4c00-9a35-562eddc83e53",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76ff75aa-45e9-9584-7c32-da9189fdca51",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "768325b2-72f3-f307-e9a8-7045a7467674",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "50c4cfdb-6219-7209-572d-0a9194e49f34",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f11e3ca-4ae3-c4ff-83c1-13f249b82a1c",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "adb774b7-ea70-9bd6-9af2-204f70b8a73c",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d54b68b-2f0f-c53d-4986-dada95bdb84c",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d11621a0-a83c-7df6-5d13-c564361ed8ef",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f619c28-e828-a07e-93cf-d14e6a6868d6",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6ca07f9-a6c6-cc1b-bc18-b59fd267f1c9",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c34f9b3-3e27-6368-900e-3bef8753ae5c",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45d25e9d-3ccf-c473-1437-2b1fada7bbd4",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff134cf-9917-97bf-e7ad-f5a3b823576a",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8637245-6ed0-edd5-233d-c08df9e21e17",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f9e2961e-38d5-8db5-9b42-0625827b6f1c",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3414e56a-dab8-327f-3d91-db490d28b820",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d387ad1-9415-6968-ad98-5b9c0dc9da8f",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07748147-b3ef-db3a-e2de-25d1a1219180",
          "attributeId": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "278d9720-6138-aa17-80bb-fd478f14700d",
          "attributeId": "2fbd5e35-2964-40a0-82bc-76b93f3a73af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12743ba9-39cb-f8ef-73ae-692d4feefb77",
          "attributeId": "be3bef4a-72f7-4804-84e7-8e42c40eab86",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "966342c9-d9ea-df51-22b0-30d69ef469e1",
          "attributeId": "40d72036-21c4-4b3f-8b2b-c352a37b3812",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45605942-8545-24c5-230e-83e9b497ca29",
          "attributeId": "5ab3bc7d-e4d8-49fe-a087-7093f99286dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3a4e6ecb-0e8d-f407-28ba-6796ba797a95",
          "attributeId": "fcb4627a-fb63-419f-9bbe-c125514a3f79",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37530020-6bd6-366b-bbbf-c0d9e64e761a",
          "attributeId": "1c457209-3ee6-41b3-95a8-870a2466cd02",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9ca3cfa0-a62d-1fed-f51a-e4d396253670",
          "attributeId": "9f239689-fdd6-4c51-adce-9959579d2823",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "098f8705-9012-f915-6851-a7d72956e19c",
          "attributeId": "fd8d1d9c-b64b-4e07-8fec-1c2d59577634",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e06034b0-de50-c59a-fb28-388c08fe159e",
          "attributeId": "f66354e6-46ee-4d8c-a205-27ffec902cfa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b59ea382-6a4b-c085-7706-f1ebfb599dab",
          "attributeId": "35cd64a7-b5ba-4a11-8631-b4f1b0a6fb66",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8';

UPDATE dwMetadata SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-28 11:10:42.543', 
[Data]=N'{
    downloadEmailTemplate: function(args){

                 var text = '''';
                text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
                text += ''Purpose of the Survey:\n''
                text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
                text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
                text +=''Submission of the Questionnaire:\n''
                text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
                text +='' \n''
                text +=''The following are your login information:\n''
                text +=''Company name: {Name}\n''
                text +=''Username: {UID}\n''
                text +=''Password: {Password}\n''
                text +='' \n''
                
                text +=''Other tokens:\n''
                text +=''UID: {UID}\n''
                text +=''Password: {Password}\n''
                text +=''Questionnaire Name: {DplyQnn}\n''
                text +=''List Name: {DplyList}\n''
                text +=''Deployment Name: {DplyName}\n''
                text +=''Category Name: {DplyCategory}\n''
                text +=''UIDPeer: {UIDPeer}\n''
                text +=''Account Active Status: {ActiveYN}\n''
                text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
                
                 var hiddenElement = document.createElement(''a'');
                    hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                    hiddenElement.target = ''_blank'';
                    hiddenElement.download = ''EmailTemplate.txt'';
                    hiddenElement.click();
    },
    
    addNewSample: function(args){
        
        var dplyId = args.data.Id;
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''listId'', listId);        
        var url = ''/deployment/addnewsample'';

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
                    //console.log(''addNewSample args:'', args);
                    alertify.success(response.message);
                    args.controlRef.refresh();
                    

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
            

    },
    manageDueDate: function(args){
        
        //console.log("manageDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
            
        }
        
    },
    changeDueDate: function(args){
        
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
        }
        var dplyId = args.data.Id;
        var dueDate = args.data.dueDate;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''dueDate'', dueDate);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/changeDueDate'';

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
                    args.component.refs.swzmodal_1.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });        
        
        
    },    
    goBack: function(args) {
        args.state.router.history.goBack();
    },
    manageResend: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_2.close();
            alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_2.props.swzData.isOpen = true;
        }
        
    },
    reSend: function(args){
             Pace.start();
        var dplyId = args.data.Id;
        var mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        var email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        var emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        var scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";        
        var profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;        
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        var msgContent = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
        }
        var subject = args.data.subject;
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            return alertify.error("Please input email subject");
                        
        }
        
        if((email || mailMerge) && msgContent.length==0){
            return alertify.error("Please input messange content.");
        }
                
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
   
        //var formName = args.data.formName;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        //formData.append(''formName'', formName);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/resend'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });   
        
    },
    
    sampleResetPassword: function(args){
        
        if (args.controlRef.state.selectedIndexes.length < 1){
            alertify.error("Please select at least one list sample");
            return
        }
        console.log("Sample reset password!", args);
        var sampleIds = [];
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var sampleId = args.controlRef.state.items[gridIndex].SampleId;
            sampleIds.push(sampleId);
        }
        CloverApp.API.setDataField("loading", "");
        //CloverApp.API.setDataField("loading", "Loading...");
        var formData = new FormData();
        formData.append(''sampleIds'', sampleIds);        
        var url = ''/deployment/resetresppassword'';
        alertify.success("Loading...");
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
                    //CloverApp.API.setDataField("loading", response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
                //CloverApp.API.setDataField("loading", error.message);
            });   
        
    },
    
    showModal: function(args){
        args.component.refs.swzmodal_2.props.swzData.isOpen = true;
    },
        
    sampleResetDelegationCode: function(args){
        
        if (args.controlRef.state.selectedIndexes.length < 1){
            alertify.error("Please select at least one list sample");
            return
        }
        console.log("Sample reset Delegation Code!", args);
        var sampleIds = [];
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var sampleId = args.controlRef.state.items[gridIndex].SampleId;
            var sampleInfoId = args.controlRef.state.items[gridIndex].Id;
            
            var temp = {};
            temp.sampleId = sampleId;
            temp.sampleInfoId = sampleInfoId;
            sampleIds.push(temp);
        }
        console.log("sampleIds : ", JSON.stringify(sampleIds));
        
        CloverApp.API.setDataField("loading", "");
        //CloverApp.API.setDataField("loading", "Loading...");
        var formData = new FormData();
        formData.append(''sampleIds'', JSON.stringify(sampleIds));
        var url = ''/deployment/resetrespdelegationcode'';
        
        $(''body'').loadingModal({
                text: ''Processing...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        
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
                    $(''body'').loadingModal(''destroy'');
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);
            });
        
    },

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

UPDATE dwMetadata SET
[Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.593', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-04-15 01:06:05.093', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage message history of this deployment"
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_10",
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
                        }
                      }
                    ],
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
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
                            "active": true,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginBottom": "20px",
                        "clearable": true,
                        "placeholder": "Select Status"
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
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "subject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "",
                        "style-marginBottom": "20px"
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
                        "style-marginBottom": "20px"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": false,
                        "actions": [
                          "showModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": ""
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": true,
                        "inverted": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "emailToStatus"
                            ],
                            "targets": [
                              "grid"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Create Scheduled Email For Status",
            "secondary": true,
            "inverted": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "style-customcss": "",
            "style-source": "",
            "size": ""
          }
        ],
        "style-float": "left",
        "style-marginBottom": "20px",
        "events": {},
        "style-marginTop": "20px"
      }
    ],
    "style-source": "clear: both;",
    "style-marginBottom": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "grid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "DplyStep",
            "name": "Step",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "name": "Mail Merge?",
            "key": "NotifyMerge",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "NotifyEmail",
            "name": "Email?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "NotifyGenerate",
            "name": "Generate Profile?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "SampleCount",
            "name": "Number of Samples",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": false,
            "type": "datetime"
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": false
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "defaultSort": "NumberId DESC",
        "multiselect": false,
        "rowHeight": "80",
        "pageSize": "80",
        "minHeight": "",
        "editForm": "",
        "events": {
          "onRowClick": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      }
    ]
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Back",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a';

UPDATE dwMetadata SET
[Id]='4a9265ad-e634-425d-964c-6ba7325313c8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.550', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-04-15 01:06:05.097', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyMessages",
  "lastUpdate": "2020-04-15T01:06:05.0981702+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "4eea8bf2-bc7c-f6e8-7876-94e848626146",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "94a1a8a7-ec79-e083-6d12-8c5b487b2fa2",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "23483e91-d133-f59b-07d4-56e3736ad830",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e692525-ebf2-26ca-f9fa-24fd75594796",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f8529e8-4447-b3eb-8fc4-27ad6d752b35",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c990e95a-2f07-44be-ddd7-a75596c2874f",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80b90421-f882-97cc-79f2-2e513de597d3",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eb69ab88-e705-d472-45a6-144b317956ab",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25ff2f3a-0739-ec93-88be-21ba02a18d14",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "566dfb86-bc25-1d4c-736d-ba72a8b25c6a",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a5f413d-54a3-e1af-7dfb-7b60f07a5246",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "86bc9c77-d96c-a3db-d3b6-16b61abdc3a9",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "38d3f594-c1c5-45b5-7da0-c40251c8f047",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b20a602-3395-05d7-a690-c28be7d7671f",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d065225-77c1-6eb9-a037-32e4a4b24428",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c9f3b5f0-daa2-97b4-7a91-e72f7cffcff2",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0944778b-0ec1-c561-6872-f88e0dbb62f4",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ba4b3b6b-b282-738b-80d8-f63524e4b294",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "998cac2f-ddd2-61b1-4d6a-0cce55f790fb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e339ef-8d58-44f3-e36f-2b4658079115",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fd691de8-ad3c-c601-c4f2-3ea528679f36",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c382b47-6727-0456-4b40-0572c7dc5ba8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab5d23f2-b4d7-e289-61f1-211a31b285ef",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f5ebf44-8b4f-73a4-3347-36396f10003e",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "64a8aadd-4f40-fd3d-c155-4923df865059",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d7b147af-017c-77ff-30da-c0024133097e",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6d244d89-0282-8d31-302b-b47cedc095aa",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "7aa61911-5cad-4e47-1584-77a399729529",
      "entityId": "59aff502-0923-4c44-a333-fe09727419f2",
      "filter": "FilterByModelId",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "285a25a7-457d-9012-e148-812872f7f345",
          "attributeId": "75fe9558-ad13-4155-adfd-278726de0afe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d31f92a-155e-3263-c253-6b9deefae68e",
          "attributeId": "46d6816a-9736-4f40-808a-6bb0529b12c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b958e738-8730-746d-5670-dbd8f3a43c73",
          "attributeId": "e7df3305-b885-4b9f-bfd9-bc5800d2b3af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00831898-d09a-51f0-68ef-539d2db6d01e",
          "attributeId": "d6e51f9b-36b7-4c4a-8713-94bafddffc4b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e7e4be7-e73c-5838-4732-86444c38469b",
          "attributeId": "2c37782f-dcf0-4386-9c48-b1885c9ec96f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bbd53d9a-8b4a-ce4c-2c9e-f1401f9d8aaf",
          "attributeId": "188f0942-ea3d-4400-8ad2-8efe1fc68d8a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "88dac03c-75dc-f65c-f412-e2fca82378bf",
          "attributeId": "3b27eb5c-9959-4243-b9da-9155a90d8a85",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d653ede4-3206-d935-3940-74ca9b35d8d3",
          "attributeId": "82a1ea3e-7db2-4673-92cf-eca1c47db3c4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa7affcf-8be7-be1a-2dea-b566f7ed2b13",
          "attributeId": "1b50815e-6bdb-4c8c-bbe1-b40e336409c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "becb0731-4e23-e255-4a4c-d40b3bec3769",
          "attributeId": "f17fa3f1-c23d-4a90-8685-be98234f9293",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a196eb5a-94df-5f9c-fac5-56c9c4cc7065",
          "attributeId": "93f82dd7-2705-42b3-bf1a-f9d62cc57663",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "18a2abe1-7b04-d3df-82e5-6aae2d98ff37",
          "attributeId": "4c89a233-907b-4a71-accc-995d9b9c8a76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "955b4502-cf1b-300b-06ef-57fa546c30ca",
          "attributeId": "491795d5-46e8-4247-975c-4c6419243b8f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "555a34a3-0ead-0a7c-1b70-a083fb003ab0",
          "attributeId": "1900ec19-9dac-4596-aa2a-ce82e9cfc493",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a191533f-269c-1b89-c2b2-3b7b90b6deeb",
          "attributeId": "a21d3068-cb0f-41ef-881c-25b6aca9b598",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36c74caf-0cf3-5392-d56b-0edd3d0ad91f",
          "attributeId": "534741ae-056b-4e92-97cf-5c97cf0e51c1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e5a14a-bd95-a442-bf99-a8a118b8c69e",
          "attributeId": "18b42ed0-2227-4819-9b4f-38b1eca723be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "48b97909-8a82-599c-35f5-6f19db39820f",
          "attributeId": "2cbedcd3-922c-4071-9f7a-c6baab5a6007",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6ac14fc5-7526-ccec-d21b-63b1c23a63b3",
          "attributeId": "df0b7d03-a12e-4c21-8148-cb0d6bfc163c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d75a6f43-73e1-7c3e-adab-3511fc06bf19",
          "attributeId": "475d3632-b629-4d78-8935-e19451cc5cd0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41ac7538-f4ec-9965-9973-9e6f2750bed8",
          "attributeId": "b49c8574-e461-4400-8df5-68b08cf6cb3f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b5e475da-2dff-3583-3dba-cec738de299a",
          "attributeId": "4026dc0f-3e46-4c2f-a65c-249366dd0993",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd58cb00-a6ef-8621-0806-65c27c32379d",
          "attributeId": "568d1b2d-ba87-4cb1-b7f1-ad30dd23982e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f128f3a4-343e-9fb5-a0d0-c12d4a66440f",
          "attributeId": "019de426-2ba0-4e03-88af-6d32a6b16a40",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1f93ae-5190-83af-f71e-3a0e8c1deab2",
          "attributeId": "8014719b-0387-4367-9581-b3fbe54acb76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dccfa04-2541-88e9-f46e-0d4b81c5a9d0",
          "attributeId": "12da9e1a-c2f6-4e0e-bbba-dd98e38d72c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "303c8966-b0b0-25fd-4166-04d4d4343c86",
          "attributeId": "ad82bb50-5d29-4c85-b93d-4ce2c219ddf5",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='4a9265ad-e634-425d-964c-6ba7325313c8';

UPDATE dwMetadata SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-28 09:34:14.033', 
[Data]=N'{
        downloadEmailTemplate: function(args){
                 var text = '''';
                text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
                text += ''Purpose of the Survey:\n''
                text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
                text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
                text +=''Submission of the Questionnaire:\n''
                text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
                text +='' \n''
                text +=''The following are your login information:\n''
                text +=''Company name: {Name}\n''
                text +=''Username: {UID}\n''
                text +=''Password: {Password}\n''
                text +='' \n''
                
                text +=''Other tokens:\n''
                text +=''UID: {UID}\n''
                text +=''Password: {Password}\n''
                text +=''Questionnaire Name: {DplyQnn}\n''
                text +=''List Name: {DplyList}\n''
                text +=''Deployment Name: {DplyName}\n''
                text +=''Category Name: {DplyCategory}\n''
                text +=''UIDPeer: {UIDPeer}\n''
                text +=''Account Active Status: {ActiveYN}\n''
                text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
                
                
                 var hiddenElement = document.createElement(''a'');
                    hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                    hiddenElement.target = ''_blank'';
                    hiddenElement.download = ''EmailTemplate.txt'';
                    hiddenElement.click();
    },
    init: function(args) {        
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: ''link-style''}, ''Yes'');
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                
                  model.columns[3].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyGenerate){
                        var url = "/deployment/downloadProfile/" + p.row.GenerateProfileOutputToken;
                        if(p.row.GenerateProfileDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };              
            }
            return model;
        };    

        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },    
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    emailToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        var dplyId = args.data.Id;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;        
        var msgContent = args.component.refs.htmlEditor.state.htmlData;        
        var subject = args.data.subject;
        var status = args.data.dictionaryStatus;
        
        if(!emailFrom || !scheduledDate || !msgContent ||!subject ||!status){
            $(''body'').loadingModal(''destroy'');
            alertify.error("Please input all the fields");
            return {};            
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
           
        var url = ''/deployment/emailtostatus'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },   

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

