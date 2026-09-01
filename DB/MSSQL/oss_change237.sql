-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard.json

UPDATE [dwMetadata] SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-08 13:42:49.500', 
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
            "name": "Downloads",
            "type": "custom",
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
                "sortable": true,
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

