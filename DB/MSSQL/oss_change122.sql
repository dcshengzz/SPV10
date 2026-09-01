-- Will UPDATE existing row(s) in dwMetadata for the following:
-- DataEditorDeployment.json

UPDATE [dwMetadata] SET
[Id]='6e6bb37c-97cd-4c89-bfe2-4688e9d89e2f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-17 14:29:12.683', 
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
        "key": "ExemptActions",
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
        "key": "ResetActions",
        "width": ""
      },
      {
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "key": "RejectActions",
        "type": "custom"
      },
      {
        "key": "TrackActions",
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
        "key": "DelegationActions",
        "type": "custom",
        "name": "Delegation"
      },
      {
        "key": "XlsxActions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": "Uploads"
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

