-- Will UPDATE existing row(s) in dwMetadata for the following:
-- DataEditorDeployment.json
-- DataEditorDeployment-settings.json
-- DataEditorDeployment-code.js

UPDATE [dwMetadata] SET
[Id]='6e6bb37c-97cd-4c89-bfe2-4688e9d89e2f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-30 15:16:30.827', 
[Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "headerName",
        "data-buildertype": "header",
        "content": "Deployment: {Name}",
        "size": "medium",
        "subheader": ""
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
                    },
                    "style-marginRight": "20px"
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
            "key": "header_6",
            "data-buildertype": "header",
            "content": "Update Status",
            "size": "medium"
          },
          {
            "key": "dropdownStatus",
            "data-buildertype": "dropdown",
            "label": "Dropdown",
            "fluid": true,
            "selection": true,
            "data-elements": [],
            "events": {
              "onChange": {
                "active": false,
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
            "placeholder": "Select new status",
            "style-marginBottom": "20px"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-customcss": "",
            "style-source": "",
            "children": [
              {
                "key": "btnSaveStatus",
                "data-buildertype": "button",
                "content": "Save Status",
                "floated": "",
                "primary": true,
                "events": {
                  "onClick": {
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
                "style-marginRight": "20px"
              },
              {
                "key": "btnCancelChangeStatus",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
                "floated": "",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "cancelModal"
                    ],
                    "targets": [
                      "statusModal"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "style-float": "right"
          },
          {
            "key": "container_12",
            "data-buildertype": "container",
            "style-source": "clear: both;"
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
            "content": "Update Track List",
            "size": "medium",
            "subheader": "",
            "events": {}
          },
          {
            "key": "trkListSampleInfo",
            "data-buildertype": "staticcontent",
            "content": "\nYou may add or remove this Sample from multiple Track List.\n<div class=\"ui divider\"></div>\n<table style=\"margin-bottom: 20px;\">\n   <tr>\n      <td>UID (Name)</td>\n      <td> : {trkListSample_uid} ({trkListSample_name})</td>\n   </tr>\n   <tr>\n      <td>Email</td>\n      <td> : {trkListSample_email}</td>\n   </tr>\n   <tr>\n      <td>Status</td>\n      <td> : {trkListSample_statusTitle}</td>\n   </tr>\n   <tr>\n      <td>Remarks</td>\n      <td> : {trkListSample_remarks}</td>\n   </tr>\n</table>",
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
            },
            "style-marginBottom": "20px",
            "placeholder": "Select Track List"
          },
          {
            "key": "container_13",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSaveUpdateTrackList",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "inverted": false,
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
                },
                "style-marginRight": "20px"
              },
              {
                "key": "btnCancelTrackList",
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
                      "trkListModal"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "style-float": "right"
          },
          {
            "key": "container_14",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear: both;"
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
                "filterable": false,
                "type": "custom",
                "width": 100
              },
              {
                "key": "Status",
                "name": "Status",
                "width": 80,
                "sortable": true,
                "filterable": false,
                "resizable": false
              }
            ],
            "rowKey": "CreatedDate",
            "defaultSort": "CreatedDate DESC",
            "autoHeight": false,
            "style-marginTop": "50px",
            "rowHeight": "80",
            "style-source": "",
            "style-customcss": ""
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
        "primary": false,
        "disabled": false,
        "compact": false,
        "toggle": false,
        "basic": false
      },
      {
        "key": "btnAnonymousStatus",
        "data-buildertype": "button",
        "content": "Status",
        "secondary": true,
        "other-visibleConition": "Utils.isSelected(data.IsAnonymous)",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "showStatusModal"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "id",
                "value": "null"
              }
            ]
          }
        }
      },
      {
        "key": "swzAnonymousDplySampleInfoId",
        "data-buildertype": "input",
        "label": "Input",
        "fluid": true,
        "onChangeTimeout": 200,
        "style-hidden": true,
        "disabled": true,
        "readOnly": true
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
        "key": "dictStatus",
        "data-buildertype": "dictionary",
        "label": "",
        "fluid": true,
        "selection": true,
        "dataModel": "QNN_STATUS",
        "columns": "Title ASC",
        "multiple": true,
        "disabled": false,
        "clearable": true,
        "search": true,
        "placeholder": "Filter by Status",
        "style-width": "300px",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "onChangeDictStatus"
            ],
            "targets": [],
            "parameters": []
          }
        }
      }
    ],
    "style-source": "float: left;",
    "events": {},
    "style-marginBottom": "20px",
    "style-marginRight": "20px",
    "other-visibleConition": "!Utils.isSelected(data.IsAnonymous)"
  },
  {
    "key": "formgroup_3",
    "data-buildertype": "formgroup",
    "widths": "equal",
    "children": [
      {
        "key": "dropdownComplete",
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
            "value": "true",
            "text": "Complete"
          },
          {
            "key": 3,
            "value": "false",
            "text": "Incomplete"
          }
        ],
        "placeholder": "Complete | Incomplete",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "200px"
      }
    ],
    "style-source": "float: left;",
    "events": {},
    "style-marginBottom": "20px",
    "style-marginRight": "20px"
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
        "name": "Started",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": "",
        "type": "datetime"
      },
      {
        "key": "DateComplete",
        "name": "Completed",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": "",
        "type": "datetime"
      },
      {
        "key": "UpdatedBy",
        "name": "Updated By",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "InitialResponse",
        "name": "Origin",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "type": "custom",
        "width": 150
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "type": "custom",
        "width": 120,
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "type": "custom",
        "width": "",
        "resizable": true,
        "name": "Excel",
        "key": "ExcelSupport",
        "sortable": true,
        "filterable": false
      },
      {
        "type": "custom",
        "width": 150,
        "resizable": true,
        "name": "Actions",
        "key": "AllAction",
        "sortable": true,
        "filterable": false
      }
    ],
    "rowKey": "Id",
    "pageSize": "80",
    "pagerType": "server",
    "defaultSort": "UID ASC, DateStart DESC",
    "style-marginBottom": "20px",
    "multiselect": false,
    "events": {},
    "rowHeight": "80",
    "minHeight": "500",
    "editFormShowType": ""
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-30 15:16:30.977', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2021-12-30T15:16:30.9770754+08:00",
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
    },
    {
      "id": "bb8cd888-a68c-3962-3232-6cded5eefaee",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e43db90c-df65-3031-5e0d-baf6fcb6c8e2",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "13812a52-422f-7c4b-22af-6002d7366ece",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a8f4143-ebf6-b24b-2ef4-237fddd592b8",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
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
        },
        {
          "id": "568bc539-279c-0035-dc94-2a17964374ea",
          "attributeId": "73e6b5cc-fedb-4d93-8be2-91f9992e4b1e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cfbfa2f6-6a8a-2c0c-ec37-63439a176986",
          "attributeId": "4a348d30-9f13-415e-8c6d-bf6944ce7272",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf076c60-4e13-63f8-f248-fd83fd368787",
          "attributeId": "a5fae11f-6956-4f3e-8a98-b4c87eff7829",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ed1c45fe-dfba-c210-9444-0282aa70ff41",
          "attributeId": "656b207e-e791-4d30-a59d-88741d35f333",
          "control": "InitialResponseAs",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60c3d798-f75a-8bd9-0908-f42d9c5393cd",
          "attributeId": "7fe0e838-99bb-444a-b786-759048ad31ee",
          "control": "InitialResponseBy",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4863936d-2fee-42c7-d4ef-a0595243873d",
          "attributeId": "02cd32e6-06c3-4d56-b507-7837589b64bf",
          "control": "InitialResponseVia",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "DataEditor"
}' WHERE [Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd';

UPDATE [dwMetadata] SET
[Id]='4af67164-5e60-4905-9885-afd6da24cb3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-30 17:00:29.643', 
[Data]=N'{
    init: function (args) {
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi));                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------

        if(args.data.IsAnonymous){
            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
        }
        
        const innerArgs = args; //Used in column formatters
        const iconBtnClass = "ui icon button mini secondary";
        const iconBtnDisabledClass = "ui icon button mini disabled";
        
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};

        const CLEARED = ''129C7781-536D-42F6-ACA4-33A62F2E2C1F''.toLowerCase();

        const genFormLinkButtons = function(p, elements, languages, formName, index){
            const dlsi = p.row.Id;
            const isMultipleResponse = !!innerArgs.data.IsMultipleResponse;
            const isAnonymous = !!innerArgs.data.IsAnonymous;
            //Render new response button for multiple response surveys
            if(isMultipleResponse || isAnonymous) {
                const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                const responseNotCleared = (status!==CLEARED);
                
                const showActionAdd = responseNotCleared;
                if( showActionAdd ) {
                    const onClickNew = () => {
                        createNewResponseAndOpen(dlsi, formName);
                    };
                    elements.push(
                        CloverApp.API.createElement("span", { 
                            onClick: onClickNew  , className: "link-style", style: { color: "green", paddingRight: "0.5em" }
                        },''Add |'')
                    );
                }
            }
            
            //Render Form link
            const onClickForm = () => {
                redirectToSurvey(dlsi, formName, p.row.RespId);
            };
            elements.push(
                CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
            );
            elements.push( CloverApp.API.createElement("br") );
        };

        const createNewResponseAndOpen = function(dlsi, formName) {
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/dataeditor/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks");
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        const showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks for Reject Response modal");
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        const showUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/dataedit/upload/xlsx?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                  Utils.loadingStop();
                  if(!success) {
                      console.log("Upload failed", xhr, msg, err);
                      if(xhr.status=== 400) {
                          alertify.error("Upload Failed - " + xhr.statusText + " - " + xhr.responseText, 15000);
                      } else if(xhr.status===413) {
                          alertify.error("Upload Failed - the selected file is too large to be uploaded here", 15000);
                      } else {
                          alertify.error("Upload Failed - " + msg + " - " + err, 15000);
                      }
                  }
                };
                console.log("rewrote model",model);
            });
            
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            CloverApp.API.setDataField("UploadFormNames", formNames);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: i,
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", 0);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        }; //end of showUploadModal
   
        const showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
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
            Utils.loadingStart("Retrieving Track List Information");
            Utils.postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error(reason);
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(Utils.loadingStop);  
        };

        const openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField(''gridDelegate'', null);
            var url = ''/dataeditor/viewdelegatelist?dlsi='' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                CloverApp.API.setDataField(''gridDelegate'', data.item);
                args.controlRef.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error(data.message);
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            });
        };  
        
        //used by Exempt
        const setStatus = function (args, id, statusId) {
            CloverApp.API.confirm(args).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);        
                formData.append(''selectedStatusId'', statusId);
                Utils.loadingStart("Setting Status");
                Utils.postFormRequest("/dataeditor/setStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();
                        alertify.success(response.message);
                    }, reason => {
                        console.error("Failed to set status", reason);
                        alertify.error(reason);
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{/*Empty catch to avoid error show at the console*/})
        };
        
        //used by Reset
        const resetStatus = function (args, id, respId) {
            CloverApp.API.confirm(args).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);
                if(respId){
                    formData.append(''respId'', respId);                
                }
                Utils.loadingStart("Resetting Status");
                Utils.postFormRequest("/dataeditor/resetStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();     
                        alertify.success(response.message);
                        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                        }
                    }, reason => {
                        console.error("Failed to reset status", reason);
                        alertify(reason);
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{/*Empty catch to avoid error show at the console*/})
        }; 
         
        const remarksPreview = function(text) {
            const previewLength = 32;
            return ''"'' + (text.length<=previewLength ? text : text.substring(0,previewLength)+"...") + ''"'';
        } ;
        const remarksFormatter = function (p) {
            const hasRemarks = (p.row.Remarks!=null);
            const iconClass = hasRemarks 
                ? ''comments outline icon'' 
                : ''comment outline icon'';
            const tooltip = hasRemarks 
                ? ''View/Edit Remarks''+remarksPreview(p.row.Remarks)
                : ''Set Remarks'';
            const icon = CloverApp.API.createElement("i", {className: iconClass, ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup(tooltip, popupProps, btn);
        };
        
        const exemptFormatter = function (p) {
            const exemptStatusGUID = ''9731DE1D-2B6A-484C-BF10-44F842A3140E'';
            const icon = CloverApp.API.createElement("i", {className: "cut icon",ariaHidden: "true" }, "");
            const btnText = "Set Exempt Status";
            let element;
            if(p.row.StatusCode==''PE''){
                const btn = CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, exemptStatusGUID), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }      
            
            return element;
        };

        const resetFormatter  = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "undo icon",ariaHidden: "true" }, "");
            const btnText = "Reset Response";
            let element;
            if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                const btn = CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass },icon);
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass },icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, container);
            }
            return element;
        }; 
        
        const rejectFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "thumbs down outline icon",ariaHidden: "true" }, "");
            const btnText = "Reject Response";
            let element;
            if(p.row.StatusCode==''SB''){
                const btn = CloverApp.API.createElement("button", { onClick: () => showRejectResponseModal(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn);//For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }  
            return element;
        };

        const trackFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "ban icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { 
                onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), 
                className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Track List", popupProps, btn);
        };
        
        const delegateHistoryFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "history icon",ariaHidden: "true" }, "");
            if(innerArgs.data.RequireAccessCode) {
                const btn = CloverApp.API.createElement("button"
                    ,{ onClick: () => openDelegateHistoryModal(innerArgs, p.row.Id), className: iconBtnClass }
                    , icon);
                
                return CloverApp.API.createElementWithPopup("Delegation History", popupProps, btn);
            } else { 
                return CloverApp.API.createElement("span", {}, "");
            }
        }; //end of DelegateHistoryFormatter

        //Excel Response upload button
        const excelUploadFormatter = function (p) {
            const isOnlineSurvey = ("O"===p.row.Type) && !!p.row.FormNames;
            const hasFiles = isOnlineSurvey && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
            const alwaysShowForDataEditor = true;
            const showUploadButtonInAppropriateStatus = isOnlineSurvey && (hasFiles || alwaysShowForDataEditor);
            if(showUploadButtonInAppropriateStatus) {
                const uploadIcon = CloverApp.API.createElement("i", {className: "file excel outline icon",ariaHidden: "true" }, "");
                //const uploadIcon = CloverApp.API.createElement("i", {className: "upload icon",ariaHidden: "true" }, "");
                const excelEnabledForDply = true; //was innerArgs.data.IsExcelEnabled;
                const uploadButtonText = "Upload Response from Excel";
                if(!excelEnabledForDply && !alwaysShowForDataEditor) {
                    const blank = CloverApp.API.createElement("div", {}, "");
                    return blank;
                } else if( (p.row.StatusCode=="PE" || p.row.StatusCode=="DE") ) {
                    //Upload option is available for Pending and In-Progress
                    const formNames = p.row.FormNames.split(''||''); //used for form selection after upload
                    const languages = p.row.Languages.split(''||''); 
                    const btn = CloverApp.API.createElement("button", { 
                            onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id),
                            className: iconBtnClass }, uploadIcon);
                            
                    const popup = CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, btn);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  popup); //For disabled component, require a div to cover in order to show the popup.
                    
                    return container;
                } else {
                    const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, uploadIcon);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  btn);
                    const popup=CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, container);
                    
                    //Show a disabled button for other status 
                    return popup;
                }
            }     
        }

        const allActionsFormatter = function (p) {
            const elements = [];
            
            elements.push(excelUploadFormatter(p));
            
            if(p.row.UID !== "swzanonymous"){
                elements.push(trackFormatter(p));
            }
            
            elements.push(remarksFormatter(p));
            elements.push(delegateHistoryFormatter(p));
            const allBtn = CloverApp.API.createElement("div", {}, elements);
            return allBtn;
        };
        
        const statusFormatter  = function (p) {
            const isAnonymousRespondent = "swzanonymous"===p.row.UID;
            
            const elements = [];
            elements.push(resetFormatter(p));
            if(!isAnonymousRespondent){elements.push(rejectFormatter(p));}
            if(!isAnonymousRespondent){elements.push(exemptFormatter(p));}
            const updateStatusDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },elements );
            
            if(!isAnonymousRespondent){
                const statusText = p.value;
                const statusBtn = CloverApp.API.createElement("button", { 
                        onClick: () => dataeditordeploymentUserActions.showStatusModal(innerArgs, p.row.Id), 
                        className: "ui button mini secondary invert", 
                        style: { minWidth: "100px" }, 
                    },statusText);
                return [statusBtn, updateStatusDiv];
            }else{
                return [updateStatusDiv];
            }
            
        }; 
        
        const uploadedExcelLinksFormatter = function (p) {
            const elements = [];

            //Response download link
            if(p.row.IsExcelResponse) {
                const responseLinkText = dayjs(p.row.ExcelUploadDate).format("DD MMM YYYY HH:mm");// + (p.row.IsExcelResponseDE ? " (DE)" : "");
                const downloadUrl = "/dataedit/download/response/" + p.row.Id + "/" + p.row.RespId;
                const downloadLinkBtn = [];
                const linkBtn = CloverApp.API.createElement("a", 
                    { href: downloadUrl, target: "_blank", style: {fontStyle: "italic"}},
                    responseLinkText);    
                    downloadLinkBtn.push(linkBtn);
                if(p.row.IsExcelResponseDE){
                    element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                    downloadLinkBtn.push(element);
                    const dataEditorIcon = CloverApp.API.createElement("i",{className: "edit icon",ariaHidden: "true" }, "");
                    element = CloverApp.API.createElementWithPopup("By Data Editor", popupProps, dataEditorIcon);
                    downloadLinkBtn.push(element);
                }
                
                const marginDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },downloadLinkBtn );      
                elements.push(marginDiv);
                
            }
            
            if(elements.length===0) {
                elements.push( CloverApp.API.createElement("div", {}, p.value) );
            }
            return elements;
        }; //end of xlsxActionsFormatter

        const formNamesFormatter = function (p) {
            var elements = [];
            if(p.row.Type=="O"){
                var strFormNames = p.row.FormNames;
                var strLanguages = p.row.Languages;
                var formNames = strFormNames.split(''||'');
                var languages = strLanguages.split(''||'');      
                
                //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));

                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, p.value); 
            }    
        }; //end of formNamesFormatter

        const fileNamesFormatter = function(p) {
            //const isExcelEnabled = innerArgs.data.IsExcelEnabled;
            const isExcelEnabled = true;
            if(p.row.Type=="O" && isExcelEnabled){
                var elements = [];
                var element;
                if(p.row.FileLanguages) {
                    const fileNames = p.row.FileNames.split(''||'');
                    const fileLanguages = p.row.FileLanguages.split(''||'');
                    const fileTokens = p.row.FileTokens.split(''||'');   
                    for(var i=0; i < fileNames.length; i++) {
                        const token = fileTokens[i];
                        const linkUrl = "/dataedit/download/xlsx/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                        elements.push(element);
                        element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                        elements.push(element);
                        elements.push( CloverApp.API.createElement("br") );
                    }
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }  
        }; //end of FileNamesFormatter
        
        //origin indicators
        const initialResponseFormatter  = function (p) {
            
            //todo - define style in .css file as a class
            const attrAs =  { className: "ui label tiny", style: { marginRight: "5px", marginBottom: "5px", minWidth: "48px", background: "#defffc" } };
            const attrBy =  { className: "ui label tiny", style: { marginRight: "5px", marginBottom: "5px", minWidth: "48px", background: "#fffae0" } };
            const attrVia = { className: "ui label tiny", style: { marginRight: "5px", marginBottom: "5px", minWidth: "48px", background: "#f0ffab" } };
            
            const elements = [];
            if(p.row.InitialResponseAs !== "Unknown" && p.row.InitialResponseAs !== "PrePopulated" && p.row.InitialResponseAs !== null){
                const iniResponseAs = CloverApp.API.createElement("div", attrAs, p.row.InitialResponseAs);
                elements.push(iniResponseAs);
            }
            
            if(p.row.InitialResponseBy !== "Unknown" && p.row.InitialResponseBy !== null){
                const iniResponseBy = CloverApp.API.createElement("div", attrBy, p.row.InitialResponseBy);
                elements.push(iniResponseBy);
            }
            
            // via is hidden since we only have online now
            /*if(p.row.InitialResponseVia !== "Unknown" && p.row.InitialResponseVia !== null){
                const iniResponseVia = CloverApp.API.createElement("div", attrVia, p.row.InitialResponseVia);
                elements.push(iniResponseVia);
            }*/
            return elements;
            
        };  

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.FormNames.sortable = false; 
                cols.FileNames.sortable = false; 
                cols.InitialResponse.sortable = false;
                cols.ExcelSupport.sortable = false;
                cols.AllAction.sortable = false;
                
                cols.FormNames.customFormatter = formNamesFormatter;
                cols.FileNames.customFormatter = fileNamesFormatter;
                cols.InitialResponse.customFormatter = initialResponseFormatter;
                cols.StatusTitle.customFormatter = statusFormatter;
                cols.ExcelSupport.customFormatter = uploadedExcelLinksFormatter; 
                cols.AllAction.customFormatter = allActionsFormatter; 
                
            }
            return model;
        }; //end of gridModelRewriter

        args.data.remarks = null;
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
    getAnonymousSampleInfo: function(args){
        var anonymousFormData = new FormData();
        anonymousFormData.append(''dplyid'',args.data.Id);
        Utils.loadingStart();
        Utils.getRequest("/dataeditor/getanonymoussampleinfo", anonymousFormData)
        .then(response => {
            if(response.success){
                CloverApp.API.setDataField("swzAnonymousDplySampleInfoId", response.item.swzAnonymousSampleInfoId);
                CloverApp.API.setDataField("dlsi", response.item.swzAnonymousSampleInfoId); 
                args.component.refs.btnAnonymousStatus.props.additionalParams.model.content = ''Status: '' + response.item.status;
                args.component.refs.btnAnonymousStatus.forceUpdate();
            }
        }, reason => {
            console.error("Failed to get anonymous sample info", reason);
            alertify(reason);
        }).finally(Utils.loadingStop);
    },
    
    showStatusModal: function (args, id) {
        const innerArgs = args; //Used in column formatters
        var formData = new FormData();
        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
            id = args.data.swzAnonymousDplySampleInfoId;
        }
        
        formData.append(''id'', id);   
        CloverApp.API.setDataField("dlsi", id); 
        Utils.loadingStart("Retrieving Status Options");
        Utils.postFormRequest("/dataeditor/GetStatusItems", formData).then(
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
                
                args.component.refs.statusModal.props.swzData.isOpen = true;
                args.component.refs.statusModal.openModal();
                
                args.component.refs.dropdownStatus.forceUpdate();
                
            }, reason => {
                console.error("Failed to get status items", reason);
                alertify.error(reason);
                args.component.refs.statusModal.close();
            }
        ).finally(Utils.loadingStop);
    },
        
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append(''uid'', args.data.trkListSample_uid);
        formData.append(''email'', args.data.trkListSample_email);
        formData.append(''name'', args.data.trkListSample_name);
        formData.append(''remarks'', args.data.trkListSample_remarks);
        formData.append(''status'', args.data.trkListSample_status);
        formData.append(''trkListIds'', args.data.dictionaryTrkList);
        
        var url = ''/dataeditor/settrklists'';
        
        Utils.loadingStart("Updating Track List");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success(response.message);
                    CloverApp.API.setDataField("dictionaryTrkList", null);  
                    CloverApp.API.setDataField("trkListSample_uid", null);
                    CloverApp.API.setDataField("trkListSample_email", null);    
                    CloverApp.API.setDataField("trkListSample_name", null);                 
                    CloverApp.API.setDataField("trkListSample_remarks", null);
                    CloverApp.API.setDataField("trkListSample_status", null);       
                    CloverApp.API.setDataField("trkListSample_statusTitle", null);        
                } else {
                    alertify.error(response.message);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(()=>{       
                Utils.loadingStop();
            });
        
        // fetch(url,
        //     {
        //         credentials: ''same-origin'',
        //         contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
        //         method: ''post'',
        //         body: formData
        //     })
        //     .then(response => response.json())
        //     .then(response => {
        //         if (response.success) {
        //             args.component.refs.grid.refresh();  
        //             args.component.refs.trkListModal.close();
        //             alertify.success(response.message);
        
        //         } else {
        //             alertify.error(response.message);
        //         }
        //     })
        //     .catch(error => {
        //         alertify.error(error.message);;
        //     })
        //     .finally(()=>{
        //         CloverApp.API.setDataField("dictionaryTrkList", null);  
        //         CloverApp.API.setDataField("trkListSample_uid", null);
        //         CloverApp.API.setDataField("trkListSample_email", null);    
        //         CloverApp.API.setDataField("trkListSample_name", null);                 
        //         CloverApp.API.setDataField("trkListSample_remarks", null);
        //         CloverApp.API.setDataField("trkListSample_status", null);       
        //         CloverApp.API.setDataField("trkListSample_statusTitle", null);               
        //     });
            
    
    
    },    
    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        //console.log(''selectedStatusId'', selectedStatusId);
        if(selectedStatusId === undefined || selectedStatusId === null){
            alertify.error(''Please select a status.'');
            return;
        }
        
        formData.append(''id'', args.data.dlsi);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
        
        Utils.loadingStart("Updating status...");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
                    
                    if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                        dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                    }
                
                } else {
                    alertify.error(response.message);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
    },
    
    submitRemarks: function (args) {
        const modal = args.component.refs.remarksModal;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);
        formData.append("remarks", args.data.remarks ? args.data.remarks.trim() : "");
        Utils.loadingStart("Updating Remarks");
        Utils.postFormRequest("/dataeditor/setremarks", formData).then(
            response => {
                modal.close();
                alertify.success(response.message);
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
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
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers updated from file");
            if(formName) {
                CloverApp.API.redirect("form", formName, ''dlsi/''+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    }, //end of excelFileUploaded
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
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
        Utils.loadingStart("Rejecting Response");
        Utils.postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success(response.message, 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error(reason, 15000);
                grid.refresh();
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    onChangeDictStatus: function(args){
        var data = args.data;
        var selectedDataEditors = data.dictStatus;
        var filterArr = [];
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            
            return {
                app: {
                    form: {
                        filters: {
                            main: {
                                grid: []
                                }
                        }
                    }
                }
            };
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        var filterObj = {
            column: "Status",
            term: "in",
            value: filterArr
        };

        return {
                app: {
                    form: {
                        filters: {
                            main: {
                                grid: [filterObj]
                                }
                        }
                    }
                }
        };
    },
    
    updateFilter: function(args) {
        const data = args.data;
        const filterComplete = data.dropdownComplete ? data.dropdownComplete : "";
        
        const filter = [];

        if("" != filterComplete) {
            filter.push({
               column: "DateComplete",
               nextValue: "",
               term: filterComplete == "true" ? "!=" : "=",
               value: "",
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    },
    
}






' WHERE [Id]='4af67164-5e60-4905-9885-afd6da24cb3d';

