-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY.json

UPDATE [dwMetadata] SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-31 16:35:29.973', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cntDeploymentTitle",
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
                "key": "cntImportModal",
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
                        "key": "importModalForm",
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
                                "key": "invalidQnnColumnsForm",
                                "data-buildertype": "form",
                                "children": [
                                  {
                                    "key": "innerInvalidQnnColumnsForm",
                                    "data-buildertype": "form",
                                    "children": [
                                      {
                                        "key": "cntInvalidQnnColumns",
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
                            "key": "cntImportDialogButtons",
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
                    "floated": "right",
                    "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)"
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
                    "key": "buttonManagePrePopulate",
                    "data-buildertype": "button",
                    "content": "Pre-Populate Response",
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
                            "value": "QNN_DPLY_PRE_POPULATE"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'')",
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
                    },
                    "other-visibleConition": "data.Id!=null"
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
    "style-width": "100%",
    "style-source": "clear: both;",
    "style-marginTop": "",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntMainContainer",
    "data-buildertype": "container",
    "children": [
      {
        "key": "MainForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "cntBasicProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerBasicProperties",
                "data-buildertype": "header",
                "content": "Basic Properties",
                "size": "medium"
              },
              {
                "key": "formgroup_BasicPropertiesMain",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "textName",
                    "data-buildertype": "input",
                    "label": "Deployment Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Deployment Name",
                    "other-visibleConition": ""
                  },
                  {
                    "key": "SurveyName",
                    "data-buildertype": "input",
                    "label": "Displayed Survey Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Survey Name"
                  },
                  {
                    "key": "Description",
                    "data-buildertype": "textarea",
                    "label": "Description",
                    "fluid": true
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
                    "label": "Form Properties (Questionnaire) ~",
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
                    "placeholder": "Select a form properties...",
                    "other-required": true,
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "reference": "Form Properties"
                  },
                  {
                    "key": "dictList",
                    "data-buildertype": "dictionary",
                    "label": "Sample List ~",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_LIST",
                    "columns": "Name ASC",
                    "search": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "validateSampleList"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "placeholder": "Select a sample list...",
                    "other-required": true,
                    "style-source": "",
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "other-visibleConition": "",
                    "reference": "Sample List"
                  },
                  {
                    "key": "textApiIdentifier",
                    "data-buildertype": "input",
                    "label": "Api Identifier",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": false,
                    "events": {},
                    "reference": "Api Identifier",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "events": {},
                "style-source": "clear:both;"
              }
            ],
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "cntResponseProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerResponseProperties",
                "data-buildertype": "header",
                "content": "Response Properties",
                "size": "medium"
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
                    "toggle": false,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "slider": false,
                    "fitted": false
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
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
                    "label": "Maximum Number of Respondents (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "events": {},
                    "defaultValue": "-1",
                    "style-width": "10em",
                    "reference": "Maximum Number of Respondents"
                  },
                  {
                    "key": "DaysUpdate",
                    "data-buildertype": "input",
                    "label": "Days for Update after Submission (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "defaultValue": "0",
                    "events": {},
                    "style-width": "10em",
                    "reference": "Days for Update",
                    "other-readOnlyConition": "",
                    "other-customValidation": "(/^-?\\d+$/.test(value)) ? value >= -1 ? true: ''must be -1, 0 or positive number'' : ''must be whole number''"
                  }
                ],
                "orientation": "inline"
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
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
            "key": "cntSurveyFeatures",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_6",
                "data-buildertype": "header",
                "content": "Survey Features",
                "size": "medium"
              },
              {
                "key": "formgroup_IsExcelEnabled",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsExcelEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Online Excel Support",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_RequireAccessCode",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "RequireAccessCode",
                    "data-buildertype": "checkbox",
                    "label": "Require Delegation Access Code",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_EnableWorkflow",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "EnableWorkflow",
                    "data-buildertype": "checkbox",
                    "label": "Use Workflow ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setDplyState",
                          "updateFeatureInteraction"
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
                "key": "formgroup_IsDirectAccess",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsDirectAccessEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Direct Access",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": ""
                  },
                  {
                    "key": "IsDirectAccessForComplete",
                    "data-buildertype": "checkbox",
                    "label": "Allow direct access after submission",
                    "other-visibleConition": "(data.IsDirectAccessEnabled==''1'') ? true : false"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)",
                "orientation": "grouped"
              },
              {
                "key": "formgroup_IsMultipleResponse",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsMultipleResponse",
                    "data-buildertype": "checkbox",
                    "label": "Allow Multiple Responses ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id || Utils.isSelected(data.IsAnonymous)"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)"
              },
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Anonymous Survey ~",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleAnonymousSurvey",
                      "updateFeatureInteraction",
                      "validateSampleList"
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
              },
              {
                "key": "fgCompletionUrl",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "formgroup_IsAnonymous",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "events": {},
                    "children": [],
                    "style-width": "",
                    "widthsCustom": "3"
                  },
                  {
                    "key": "anonymousSurveyLink",
                    "data-buildertype": "staticcontent",
                    "content": "",
                    "isHtml": true,
                    "isPre": true,
                    "fetchData": true
                  },
                  {
                    "key": "textCompleteURL",
                    "data-buildertype": "input",
                    "label": "Completion URL (Leave blank if there is no completion URL)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "placeholder": "https://example.com",
                    "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                    "events": {},
                    "style-marginLeft": "",
                    "other-customValidation": "",
                    "style-width": "",
                    "reference": "Completion URL"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "orientation": "grouped"
              },
              {
                "key": "formgroup_IsExposeListProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "IsExposeListProperties",
                    "data-buildertype": "checkbox",
                    "label": "Expose List Sample Properties to Form",
                    "toggle": true,
                    "defaultValue": "0"
                  }
                ]
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "<i>(Above options marked with <strong>~</strong> may only be selected before creating the deployment and cannot be enabled later)</i>",
                "isHtml": true
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
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
            "key": "cntRestrictionProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Restriction Properties",
                "size": "medium",
                "style-marginTop": "",
                "style-marginBottom": ""
              },
              {
                "key": "RestrictIp",
                "data-buildertype": "checkbox",
                "label": "IP Restriction",
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
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "cntInitialNotification",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<i>(Initial notification will be sent to all samples in the selected Sample List when the deployment is created)</i>",
                "isHtml": true
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
                ],
                "style-marginTop": "20px"
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
                    "style-marginBottom": "20px",
                    "other-customValidation": "",
                    "reference": "Email From",
                    "events": {}
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email Subject"
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
                    },
                    "other-customValidation": ""
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "events": {}
          }
        ],
        "style-source": ""
      },
      {
        "key": "cntInfoBeforeCreating",
        "data-buildertype": "container",
        "style-marginBottom": "20p",
        "style-source": "",
        "style-customcss": "ui info message",
        "children": [
          {
            "key": "staticcontent_5",
            "data-buildertype": "staticcontent",
            "content": "<i>(After creating the deployment you can perform additional deployment management functions such as assigning data editors, configuring recurrence settings, setting snapshot report options, performing pre-population, etc)</i>",
            "isHtml": true,
            "fetchData": false
          }
        ],
        "other-visibleConition": "(data.Id?false:true)"
      }
    ],
    "style-float": "",
    "style-width": "100%",
    "style-source": "",
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntReportProperties",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "",
        "style-marginBottom": ""
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
    "style-marginTop": "",
    "style-marginBottom": "20px",
    "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnFirstSave",
        "data-buildertype": "button",
        "content": "Create Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "confirm",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "createDplyConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "createDplyConfirmText"
              }
            ]
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?false:true)",
        "other-customValidation": ""
      },
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Update Deployment",
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
        "other-visibleConition": "(data.Id?true:false)",
        "other-customValidation": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "redirect"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/SwzDplyList"
              }
            ]
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

