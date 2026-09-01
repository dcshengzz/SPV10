-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard.json
-- respdashboard-settings.json
-- respdashboard-code.js
-- RespDelegationEmailTemplate.json

UPDATE dwMetadata SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 15:11:16.347', 
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
                "key": "SurveyPasswordNote",
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
        "key": "surveyPasswordModal",
        "data-buildertype": "swzmodal",
        "style-display": "block",
        "content": "surveyPasswordModal",
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
                "key": "SurveyPassword",
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
                    "key": "btn_SubmitSurveyPassword",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "submitSurveyPassword"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btn_CancelSurveyPassword",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeSurveyPasswordModal"
                        ],
                        "targets": [
                          "surveyPasswordModal"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 15:11:16.497', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2021-06-25T15:11:16.4944667+08:00",
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-25 15:05:27.603', 
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
                checkSurveyPassword(innerArgs, p, value);
            }, className: "link-style" }, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        
        var checkSurveyPassword = function(innerArgs, p, formName) {
            const respId = p.row.RespId;
            const dlsi = p.row.Id;
            
            if(p.row.RequireAccessCode) {
                loadingStart("Loading");
                getJsonRequest("/respondent/surveypassword", { dlsi }).then(
                    result => {
                        if(result.item.validated) {
                            redirectToSurvey(dlsi, formName, respId);
                        } else {
                            CloverApp.API.setDataField("SurveyPasswordRespId", respId);
                            CloverApp.API.setDataField("SurveyPasswordDlsi", dlsi);
                            CloverApp.API.setDataField("SurveyPasswordFormName", formName);
                            CloverApp.API.setDataField("SurveyPassword", "");
                            innerArgs.component.refs.surveyPasswordModal.openModal();
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
    
    closeSurveyPasswordModal: function(args) {
        args.component.refs.surveyPasswordModal.close();
        CloverApp.API.setDataField("SurveyPassword", "");
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
    
    submitSurveyPassword: function(args) {
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
        
        const surveyPassword = args.data.SurveyPassword;
        if(surveyPassword === undefined || surveyPassword === null || surveyPassword == "") {
            alertify.error("Please enter a password");
            return {};
        }
        
        const respId = args.data.SurveyPasswordRespId;
        const dlsi = args.data.SurveyPasswordDlsi;
        const formName = args.data.SurveyPasswordFormName;
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("password", surveyPassword);
        loadingStart("Validating Password");
        postFormRequest("/respondent/surveypassword", form).then(
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
[Id]='951b16cf-9aa1-4e4b-aca7-2d0f4d422891', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespDelegationEmailTemplate.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-12-19 16:36:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-06-24 17:24:43.210', 
[Data]=N'[
  {
    "key": "subject",
    "data-buildertype": "staticcontent",
    "content": "Survey Access Code",
    "isHtml": true
  },
  {
    "key": "container_1",
    "data-buildertype": "container"
  },
  {
    "key": "body",
    "data-buildertype": "staticcontent",
    "content": "<p><b>{QnnTitle}</b></p>\n\n<p>\n{Comments}\n</p>\n<p>\nThe survey access code is: {AccessCode}<br/>\nThis survey access code is valid from {ValidityStart} until {ValidityEnd}<br/>\n</p>\n<p>{Name}</p>",
    "isHtml": true
  }
]' WHERE [Id]='951b16cf-9aa1-4e4b-aca7-2d0f4d422891';

