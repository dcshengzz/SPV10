-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard.json
-- respdashboard-settings.json

UPDATE [dwMetadata] SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-02-07 10:34:53.200', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
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
      }
    ],
    "style-source": "padding: 10px;"
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
            "sortable": false,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "File",
            "name": "Downloads",
            "type": "custom",
            "sortable": false,
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
            "sortable": false,
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
        "pagerType": "",
        "pageSize": "",
        "defaultSort": "Hardcoded",
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
            "sortable": false,
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
        "pagerType": "",
        "pageSize": "",
        "defaultSort": "Hardcoded",
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
    "key": "modalsContainer",
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
                "key": "DelegateName",
                "data-buildertype": "input",
                "label": "Delegate''s name",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
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
                "key": "DelegateFromName",
                "data-buildertype": "input",
                "label": "Your name",
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
                "style-marginTop": "",
                "style-marginBottom": "20px"
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
                "style-marginTop": "",
                "style-marginBottom": ""
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
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "customPostUrl": ""
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
            "style-marginTop": "",
            "style-marginBottom": "",
            "style-source": "",
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
                "style-marginBottom": "",
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
                ],
                "style-marginBottom": ""
              }
            ]
          }
        ]
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
                "key": "RevokeAllDelegation",
                "data-buildertype": "button",
                "content": "Revoke All Delegation",
                "primary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "confirm",
                      "revokeAllDelegation"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "secondary": true,
                "style-hidden": false
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
                "key": "FromName",
                "name": "From",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "width": 100
              },
              {
                "key": "Name",
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
                "key": "Comments",
                "name": "Comments",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "type": "custom",
                "width": 100
              },
              {
                "key": "Status",
                "name": "Status",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": "",
                "type": ""
              },
              {
                "key": "Revoke",
                "name": "Revoke",
                "type": "custom",
                "sortable": false,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "events": {},
            "pagerType": "",
            "defaultSort": "CreatedDate DESC",
            "rowKey": "CreatedDate",
            "style-marginTop": "80px",
            "rowHeight": "80"
          }
        ],
        "compact": true,
        "secondary": true
      }
    ],
    "events": {}
  }
]' WHERE [Id]='d6e12e1d-3384-4352-bf68-8210aa75d406';

UPDATE [dwMetadata] SET
[Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-02-07 10:34:53.267', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2023-02-07T10:34:53.2645692+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "c1b2ca73-2ded-e096-39ef-7cfc0f62ac2c",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "grid",
      "dataMap": [
        {
          "id": "de499ef5-d48e-8751-1435-5fdf4bad03d6",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0cedcc5a-0faf-7ddf-8f8b-6cc422bb03d9",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6c5ca042-8eab-4e96-82fa-93b821df7ebe",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1820827-1a12-e7bb-da37-e83381fd2bbe",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df8d2528-af6c-439c-3afb-851fb89168f2",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5c7b4a6b-ec0f-c1f5-16ad-ba49d6f95a32",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e4eb684-13e8-e3e1-13a6-bbc8dde3daef",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a5b2d8f3-10ca-4ba0-cbb1-c93f70293eb7",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bbe4900-f1f7-240c-f411-116be94924e6",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b949bd3c-3c62-94e9-71bf-ba52c35c800b",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8fc229a2-eccc-9699-b1d9-f6bf52e8ab12",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "505ff2d8-3d3c-a6a7-42ce-c841f072eca5",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d65f67c-5158-6691-2c88-21114a5662bc",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "64e9f997-7ec5-4d4e-a2da-20b07d8cdd00",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d21cc6f-fcf7-64d5-2a8a-e149f21a03d3",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fff17f24-df36-838a-7216-c34095660f4c",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6bbaf148-a75d-bb84-55bf-0fd066ac771f",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b62eb0f-24c8-0a31-b6c6-c1fc0090468c",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd4955a9-8ec9-27fe-98da-a3b7a80a7ccc",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f2a5d70-7bf8-3dfc-5e9f-618eeaa0ec84",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "240d3b14-0943-b274-86f9-a3ae29cd2adb",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0556426a-9928-5c29-a6c0-3e73efba988f",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7153a0c3-c498-b3c6-3dce-9d4be61cd837",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0d163571-97b7-7300-3089-0e8246b35249",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69dfe58b-8234-6112-f6d3-03a624172dd4",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f863de45-42fa-2732-6225-a5d19f76ec46",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e28e4f2-083d-09be-e749-6f5d16092b27",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37355549-1fa6-9cec-d655-ff60666395a0",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c83c444-09a8-e64e-4c70-e6ce04cfd9db",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1deb5d25-cd89-74bf-94e6-c3af55575a04",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a69c8ec2-9962-adf7-3799-cf986ca59d82",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "199f9105-91c1-a668-4dc6-bd3414d85a76",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4fe3545e-aa1c-dec1-8600-7e5e61b1c076",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5d931ba6-69a5-4231-1071-bd376d0aeef5",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39ac1fb6-a16f-1b0a-eff7-595d651f7103",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d1d7e6ef-3a56-3885-b471-a4e70e768e2d",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a2a59d0b-c7e3-76da-24bb-b5a535ac7507",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b45dcee-818e-4a69-7f7a-8f1e6a321b8a",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c5ac3829-e130-f7fd-feb0-a011ba53cb1c",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fa236c82-2137-17b5-f39f-5aa3e75a1280",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4bebef43-c7f1-6f17-eea7-2fba6adb6193",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a25f1f9b-8175-150e-0701-5b74081cb3db",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "92d5901a-8386-be34-2ae6-ddbc2e288423",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbc39bd1-d4ff-5428-9d57-cc642899c43e",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3a4df715-d398-a3ab-983a-ed544b679395",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6e0e0f5-7a87-f697-577d-d8ef7e49c25a",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f91ceb7-5c8f-0d53-7884-22d4c8959a52",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27c8e4b3-354f-5d79-ab84-42f578421ffe",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89c9fbc6-c1d4-d7a0-7a20-50cc1546f87e",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3b37c584-1910-c912-5bfc-96d60c0fce30",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c81de3ce-8085-80d2-d05f-8e0515b65b4c",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8556a3f4-b6a1-aa3e-89a2-697606bdd0e5",
          "attributeId": "e6e42485-80f6-4209-9270-3ddda6656ea3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cd212774-3a08-8716-04d8-0d9e26c5b342",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "871de62a-fe83-5c97-0879-0d3f333461dc",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4fe212f3-5915-a186-54cc-4cd8dc68ea19",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "53bdacee-661f-2572-4fc2-29ec111efb9f",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8dfe18d-1366-752c-b12f-9d01f08488f0",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fe94fc07-14fb-d694-a712-844c39041294",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "817eca63-b79b-15e5-deed-cd9138322642",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96f7048b-f0cf-7b46-aa7e-78b1a7dc5ebb",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e3123f6d-949e-95c2-3f7d-7a80d4844347",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    },
    {
      "id": "9c373d2d-38e1-5859-ce23-ffda481c0f3b",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "gridview",
      "dataMap": [
        {
          "id": "de26eda1-3ceb-2de8-2e5b-23ce507c2315",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d2855ae8-90dc-94d3-88e5-29fd37821c47",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5874602-d9ab-db1f-e455-cf3c945c2c3f",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4864319-48d1-e1ee-45fc-d7c4fd40fca1",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5d88d814-c63b-a26c-7867-a814b1801637",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a49cf79-b561-b2fc-f8d6-8b809239b173",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bce2bd0e-fbd3-9941-ecd7-56c6288a6618",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4383584b-09e8-0c6f-238c-6f8b3816b499",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eaba1792-784d-764a-c000-2c50204514ff",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b2aea760-4bb0-0b99-3951-5219df91545d",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "42862819-c6c3-bbee-34b1-10cade51c774",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a85fef4-5483-8c90-d50a-620df48cdc79",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f62cba3f-4b7e-147f-cd02-ee8f0952eac4",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05eb28a1-07ae-04ab-3478-651b1ecb1690",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "934ce7f1-2858-1201-b327-002e3f4fe7c1",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "280fbffc-6788-4c6f-fcb0-a4cfe15ef93d",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8d1a2a01-45b9-2bbf-ee8b-c287f62b4fd9",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b964e2-3ff8-0f16-c8f3-3bc6cabb9745",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27084ce4-8c72-5389-e4b5-5e7d91cc2875",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9e7cdb36-5777-c77c-8f48-bf733ae63a3f",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "710e1c47-9c56-4762-5fd9-ab5dc85394d2",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b838c250-3f9c-3d4b-1a00-c0d318be223e",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96bd86de-36b0-cbd5-125b-89777b670a55",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2649f238-490c-9950-1952-713ba8e9ca35",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1b0856-9227-975b-2661-737e7c422aa7",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd431db6-ba4a-1a7f-155d-5700816d823b",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "239863c7-a98a-a4e6-a0db-9d74aaa2fd5a",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2209cc6d-05d2-4071-6842-8546ccc51ee5",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60c8149a-e637-aff7-7b7d-edf2cc3b54ae",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84d8107e-d824-18ba-162a-441c8b88cf4c",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "345af599-3f75-b6c0-4836-c9dfaa853245",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e7396913-5419-df30-492a-e17f04fd59d8",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1ee9b6c-99ea-78b8-9d91-e533881403bb",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab3f1823-2d38-546e-426e-75fd8df02527",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3ccbe982-2efa-b66b-bfe0-0a9725166234",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2258546f-1c27-19a4-7c01-bac01e49ae9b",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a0e36b3-5a95-286f-3fcf-3a6f75e3aa11",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1daa6e-231d-9108-5056-4adebf6abb6f",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4a1707a-0f21-7d9b-2771-49072f0d4739",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ca2b07fe-c472-6cb5-d8b5-b4f5bcbef72e",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "345fab4b-e472-eec0-b034-ba6edb1547d3",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6bbfff9f-47d8-868a-5ea8-4494d88fc106",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "94ee384b-53e3-85aa-92d1-b9782513ab10",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e00eb46-9516-c514-0831-8c5217e5c97e",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ce6f9b27-40a4-12f8-6e2b-54ec688ea639",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05139731-3d7c-5378-788c-487d3487821d",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "70345d2b-1a3d-6f1e-ce3c-3e84621c1d3d",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "acfa30de-d4d4-8e52-5fc1-dce2b10b1658",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "be786b98-e78f-576c-97ed-72ada5a97ec5",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "683d482a-4bc3-7f1c-8839-cf11eb362d86",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f867911a-c9ed-2773-e170-8edd83e6f5a8",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7fd35474-3093-9dd5-3905-843ca9a54644",
          "attributeId": "e6e42485-80f6-4209-9270-3ddda6656ea3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "461218ed-83a9-a5a6-a76c-6f8b9b304827",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e835892-a26f-6aff-fd39-64605e0fd901",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d157d03-31c9-102f-c5b1-5520b100fa34",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f43d7de-7c58-c0c2-7e92-713e5de9bb06",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4870960-a194-ded0-87ee-14dcd353fed5",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05e18520-d5b9-09b7-eb93-b002037e4188",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e34f8321-c469-9537-7a12-75d7df1f5a97",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "681ff069-e261-361e-83b8-41c6eb06e2f9",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf2a4466-0d0b-e713-2feb-a03b109e110f",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_totalcount"
    }
  ]
}' WHERE [Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b';

