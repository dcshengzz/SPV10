-- Will UPDATE existing row(s) in dwMetadata for the following:
-- DataEditorDeployment.json
-- DataEditorDeployment-settings.json

UPDATE [dwMetadata] SET
[Id]='6e6bb37c-97cd-4c89-bfe2-4688e9d89e2f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-07 19:15:27.890', 
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
                "key": "FromName",
                "name": "From",
                "width": 100,
                "sortable": true,
                "filterable": false,
                "resizable": true
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
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "Comments",
                "name": "Comments",
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
            "style-marginTop": "50px",
            "rowHeight": "100"
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
    "style-marginBottom": "20px",
    "style-marginRight": "20px"
  },
  {
    "key": "formgroup_1",
    "data-buildertype": "formgroup",
    "widths": "equal",
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
        },
        "style-width": "300px"
      }
    ],
    "style-source": "float: left;",
    "events": {},
    "style-marginBottom": "20px",
    "style-marginRight": "20px"
  },
  {
    "key": "formgroup_2",
    "data-buildertype": "formgroup",
    "widths": "equal",
    "children": [
      {
        "key": "FilterStatus1",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "",
            "text": ""
          },
          {
            "key": 2,
            "value": "pending",
            "text": "Pending"
          },
          {
            "key": 3,
            "value": "inprogress",
            "text": "In-Progress"
          },
          {
            "value": "submitted",
            "text": "Submitted"
          },
          {
            "text": "Exempted",
            "value": "Exempted"
          },
          {
            "text": "Cleared",
            "value": "Cleared"
          },
          {
            "text": "Received",
            "value": "Received"
          },
          {
            "text": "Ceased Ops",
            "value": "Ceased Ops"
          },
          {
            "text": "Dormant",
            "value": "Dormant"
          },
          {
            "text": "Out-of-Scope",
            "value": "Out-of-Scope"
          },
          {
            "text": "Struck-off",
            "value": "Struck-off"
          },
          {
            "text": "Holding Company",
            "value": "Holding Company"
          },
          {
            "text": "Not-In-Ops Yet",
            "value": "Not-In-Ops Yet"
          },
          {
            "text": "Bounced",
            "value": "Bounced"
          },
          {
            "text": "Conso-Return",
            "value": "Conso-Return"
          },
          {
            "text": "Partial Return",
            "value": "Partial Return"
          },
          {
            "text": "Incomplete Data Entry",
            "value": "Incomplete Data Entry"
          }
        ],
        "style-width": "250px",
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
                "value": "StatusTitle"
              }
            ]
          }
        },
        "placeholder": "Filter by status"
      }
    ],
    "style-marginBottom": "20px",
    "style-marginRight": "20px",
    "style-source": "float: left;",
    "events": {}
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
        "name": "Downloads",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": ""
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
        "key": "StatusTitle",
        "name": "Status",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "type": "custom",
        "width": 120
      },
      {
        "key": "ExcelSupport",
        "name": "Excel Support",
        "type": "custom",
        "width": 170,
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "AllAction",
        "name": "Action",
        "type": "custom",
        "width": 130,
        "resizable": true,
        "sortable": true,
        "filterable": false
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

UPDATE [dwMetadata] SET
[Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-07 19:15:28.000', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2021-09-07T19:15:28.0003+08:00",
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
    },
    {
      "id": "1a56b8b4-4501-60a4-0e36-1e42c4fb491b",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
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
        },
        {
          "id": "30962f6d-1fce-bd3e-9fb3-f92ac87aed3d",
          "attributeId": "d76d0092-3f3a-4006-a7ec-326621b58e70",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c989e4b2-ff2e-3958-9698-de4453caaa4d",
          "attributeId": "a1cb339f-8561-41a3-9f05-62a327f7e30b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f679353-160f-141d-120e-8db0d48a859c",
          "attributeId": "dec06220-d310-43c9-ace8-cdf8bcfa233b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}' WHERE [Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd';

