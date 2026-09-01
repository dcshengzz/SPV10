-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY.json
-- QNN_DPLY-settings.json
-- QNN_DPLY_PRE_POPULATE.json
-- QNN_DPLY_PRE_POPULATE-settings.json
-- dplyRecurrence.json
-- dplyRecurrence-settings.json

UPDATE [dwMetadata] SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:14:44.087', 
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
        "key": "cnt_buttons",
        "data-buildertype": "container",
        "style-float": "",
        "children": [
          {
            "key": "cntImportModal",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnMaintenance",
                "data-buildertype": "button",
                "content": "Maintenance",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyMaintenance"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-marginLeft": "",
            "other-visibleConition": "",
            "style-source": "text-align: right;",
            "style-width": "100%"
          },
          {
            "key": "container_8",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnManageSnapshot",
                "data-buildertype": "button",
                "content": "Manage Report Snapshot",
                "secondary": true,
                "floated": "",
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
                        "value": "dplySnapshot"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
              {
                "key": "btnManageScheduledExport",
                "data-buildertype": "button",
                "content": "Manage Scheduled Export",
                "secondary": true,
                "floated": "",
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
                        "value": "dplyScheduledExport"
                      }
                    ]
                  }
                },
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
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
                "floated": "",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              },
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
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-marginLeft": "",
            "style-marginRight": "",
            "events": {},
            "style-width": "100%",
            "style-source": "text-align: right;",
            "style-marginTop": ""
          },
          {
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnManageRecurringDeployments",
                "data-buildertype": "button",
                "content": "Manage Recurring Deployments",
                "secondary": true,
                "floated": "",
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
                "other-visibleConition": "data.Id!=null",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
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
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
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
                "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'') ",
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px",
                "other-readOnlyConition": "data.IsMultipleResponse || data.IsAnonymous"
              },
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
                "floated": "",
                "style-width": "250px",
                "style-marginLeft": "10px",
                "style-marginTop": "10px"
              }
            ],
            "style-float": "",
            "style-width": "100%",
            "style-marginTop": "",
            "style-source": "text-align: right;"
          }
        ],
        "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;\nbackground-image: linear-gradient(#f0f0f0, #f8f8f8);",
        "style-marginBottom": "",
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-width": "100%",
    "style-float": "right"
  },
  {
    "key": "cnt_clearBoth",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-width": "100%"
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
                    "key": "staticcontent_7",
                    "data-buildertype": "staticcontent",
                    "content": "Tags",
                    "isHtml": true,
                    "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                    "style-marginBottom": "4px"
                  },
                  {
                    "key": "divActiveTags",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "mdlTag",
                        "data-buildertype": "swzmodal",
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "openTagsModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-display": "none",
                        "size": "tiny",
                        "secondary": true,
                        "children": [
                          {
                            "key": "header_7",
                            "data-buildertype": "header",
                            "content": "Add/Remove Tags",
                            "size": "medium"
                          },
                          {
                            "key": "message_1",
                            "data-buildertype": "message",
                            "header": "",
                            "content": "Add a custom tag by typing in the Tags",
                            "negative": false,
                            "info": true
                          },
                          {
                            "key": "staticcontent_9",
                            "data-buildertype": "staticcontent",
                            "content": "Tags",
                            "isHtml": true,
                            "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                            "style-marginBottom": "4px"
                          },
                          {
                            "key": "ddTags",
                            "data-buildertype": "dropdown",
                            "label": "",
                            "fluid": true,
                            "selection": true,
                            "data-elements": [],
                            "placeholder": "Type and add tag here",
                            "multiple": true,
                            "search": true,
                            "readOnly": false,
                            "allowAddItems": true,
                            "disabled": false,
                            "events": {},
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "divTagsSearchResult",
                            "data-buildertype": "container",
                            "style-marginTop": "",
                            "style-marginBottom": "10px",
                            "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                            "children": [
                              {
                                "key": "formgroup_3",
                                "data-buildertype": "formgroup",
                                "widths": "equal",
                                "children": [
                                  {
                                    "key": "staticcontent_8",
                                    "data-buildertype": "staticcontent",
                                    "content": "Search For Tags",
                                    "isHtml": true,
                                    "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;",
                                    "style-marginBottom": "4px"
                                  },
                                  {
                                    "key": "TagsSearch",
                                    "data-buildertype": "input",
                                    "label": "",
                                    "fluid": false,
                                    "onChangeTimeout": 200,
                                    "events": {
                                      "onChange": {
                                        "active": true,
                                        "actions": [
                                          "searchTagsInDB"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "placeholder": "Search Tags..."
                                  }
                                ],
                                "orientation": "grouped"
                              },
                              {
                                "key": "staticcontent_10",
                                "data-buildertype": "staticcontent",
                                "content": "<hr>",
                                "isHtml": true,
                                "style-marginTop": "10px",
                                "style-marginBottom": "10px",
                                "events": {}
                              }
                            ],
                            "style-height": ""
                          },
                          {
                            "key": "container_3",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "btnTagsSave",
                                "data-buildertype": "button",
                                "content": "Save",
                                "floated": "",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "saveActiveTags"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_2",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "floated": "",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeTagsModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "left",
                            "style-marginTop": "30px",
                            "style-marginBottom": "20px"
                          }
                        ],
                        "content": "Add/Remove Tags",
                        "style-source": "",
                        "compact": true,
                        "style-marginBottom": ""
                      },
                      {
                        "key": "staticcontent_6",
                        "data-buildertype": "staticcontent",
                        "content": "<hr>",
                        "isHtml": true,
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px",
                        "events": {}
                      }
                    ],
                    "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;"
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
                    "label": "Maximum Number of Responses (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "events": {},
                    "defaultValue": "-1",
                    "style-width": "10em",
                    "reference": "Maximum Number of Responses"
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
                "key": "formgroup_IsIncludeUnansweredSection",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "IsIncludeUnansweredSection",
                    "data-buildertype": "checkbox",
                    "label": "Allow Respondents to Export Unanswered Sections",
                    "toggle": true,
                    "defaultValue": "",
                    "events": {}
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

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:14:44.117', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2024-07-24T17:14:44.1157818+08:00",
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
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnDplyTrigger"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
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
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "020f9a28-e54d-750b-cb60-045ce9ed0c05",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "control": "SurveyName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b17a499b-7d84-0cc9-96d2-58795c553378",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfa65cde-ed69-b522-cae6-f91eccaa1dad",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b8cd14dc-2364-8ef6-2230-c18d9d9f2dc2",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "control": "textApiIdentifier",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb4bde3f-4a8a-c6ae-c6ae-b88664a83f9f",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "control": "IsExposeListProperties",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "729f2391-b64a-5198-beb1-947ec62f6f16",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "control": "IsDirectAccessEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5ed2dad-6f5b-d741-a5e9-d94f9b0d242e",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "control": "IsDirectAccessForComplete",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae906195-d1ed-a375-9361-17acb9d583e5",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aea6df5c-cf81-6caa-ad26-375769226477",
      "attributeId": "595da6d0-43c2-4faf-8b64-242a5e2a9c10",
      "control": "IsIncludeUnansweredSection",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

UPDATE [dwMetadata] SET
[Id]='54181d8d-523f-4075-ac8e-575e817af26b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.213', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:47:54.960', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Data Pre-Populate",
    "size": "huge",
    "subheader": " {Name}"
  },
  {
    "key": "message_notsupported",
    "data-buildertype": "message",
    "header": "Not Supported",
    "content": "Pre-Population for multiple-response or anonymous survey types is not supported.",
    "error": true,
    "other-visibleConition": "data.IsMultipleResponse || data.IsAnonymous"
  },
  {
    "key": "container_8",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_12",
        "data-buildertype": "container",
        "children": [
          {
            "key": "PrepopulateInfo",
            "data-buildertype": "message",
            "header": "Pre-populate Answers",
            "content": "Pre-populate will initialise response data in this deployment as specified below. It only pre-sets answers where the sample has yet to start responding. For these cases any existing pre-populated data will be cleared and replaced with the data specified below.\nYou can optionally schedule the pre-population to occur in the future by selecting a date and time to run the job, otherwise it will be run immediately. ",
            "info": true
          },
          {
            "key": "PrePopulateInfo",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true
          }
        ],
        "style-marginTop": "10px",
        "style-marginBottom": "10px"
      },
      {
        "key": "formgroup_2",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "orientation": "grouped",
        "children": [
          {
            "key": "DataSource",
            "data-buildertype": "radiogroup",
            "label": "Pre-Populate Data From",
            "data-elements": [
              {
                "key": 1,
                "value": 1,
                "text": "Online Deployment"
              },
              {
                "key": 2,
                "value": 2,
                "text": "Upload CSV"
              }
            ],
            "reference": "Import Data From",
            "defaultValue": ""
          },
          {
            "key": "ScheduledTime",
            "data-buildertype": "input",
            "label": "Schedule pre-population at",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime",
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              },
              "onChange": {
                "active": true,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            }
          }
        ]
      }
    ],
    "events": {},
    "other-readOnlyConition": "",
    "other-visibleConition": "!(data.IsMultipleResponse || data.IsAnonymous)"
  },
  {
    "key": "container_7",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "style-float": "",
        "children": [
          {
            "key": "Deployment",
            "data-buildertype": "dictionary",
            "label": "Source Deployment",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_DeploymentOnline",
            "columns": "Name ASC",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "removeAllFields",
                  "getDeploymentFields"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-customcss": "",
            "clearable": true,
            "multiple": false,
            "filters": "[{\"column\":\"Id\", \"value\":\"{Id}\", \"term\":\"!=\"}]"
          }
        ],
        "style-width": "",
        "style-marginBottom": "10px",
        "events": {}
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "Pre-Populate Fields",
            "size": "medium"
          },
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "container_3",
                    "data-buildertype": "container",
                    "style-float": "",
                    "children": [
                      {
                        "key": "DeploymentQnnFields",
                        "data-buildertype": "collectioneditor",
                        "idField": "Id",
                        "parentIdField": "ParentId",
                        "columns": [
                          {
                            "key": "Name",
                            "name": "Field Name",
                            "control": "span",
                            "width": ""
                          },
                          {
                            "key": "Type",
                            "name": "Type",
                            "control": "span"
                          },
                          {
                            "key": "PrePopulate",
                            "name": "PrePopulate",
                            "control": "checkbox"
                          }
                        ],
                        "disableAdd": true,
                        "disableDelete": true,
                        "other-visibleConition": "data.Deployment",
                        "header": false,
                        "headerTitle": "Pre-Populate Fields"
                      }
                    ],
                    "style-width": "",
                    "style-marginBottom": "",
                    "events": {},
                    "other-visibleConition": "",
                    "style-customcss": "",
                    "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;",
                    "style-marginTop": ""
                  }
                ]
              }
            ]
          },
          {
            "key": "container_6",
            "data-buildertype": "container",
            "children": [
              {
                "key": "addAllFields",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Add All",
                    "url": "/",
                    "active": false
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "addAllFields"
                    ],
                    "targets": [
                      "DeploymentQnnFields"
                    ],
                    "parameters": []
                  }
                },
                "style-marginRight": "10px"
              },
              {
                "key": "breadcrumb_1",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Remove All",
                    "url": "/",
                    "active": false
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "removeAllFields"
                    ],
                    "targets": [
                      "DeploymentQnnFields"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "style-float": ""
          }
        ],
        "style-source": "",
        "style-customcss": "ui info message",
        "style-float": "",
        "style-width": "",
        "other-visibleConition": "data.Deployment"
      }
    ],
    "other-visibleConition": "data.DataSource == 1",
    "style-width": "80%",
    "style-marginTop": "20px"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "other-visibleConition": "data.DataSource == 2",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "CsvInfo",
                "data-buildertype": "staticcontent",
                "content": "The CSV must have a header row to provide alias/field names and contain a UID column. If using a previously exported response CSV do be aware that pre-population pays no special attention to the Status column. Any rows to to be excluded should be removed from the CSV prior to upload."
              }
            ],
            "style-marginTop": "10px",
            "style-marginBottom": "10px"
          },
          {
            "key": "CsvFileUploaded",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "file",
            "events": {
              "onChange": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "style-hidden": false,
            "style-source": ""
          }
        ],
        "style-width": "50%",
        "style-marginBottom": "20px",
        "style-marginTop": "20px"
      }
    ]
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "btn_OnlinePrePopulate",
        "data-buildertype": "button",
        "content": "Schedule Pre-Populate (From Dply)",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "prePopulate"
            ],
            "targets": [
              "DeploymentQnnFields"
            ],
            "parameters": []
          }
        },
        "other-customValidation": "",
        "other-visibleConition": "data.DataSource == 1"
      },
      {
        "key": "btn_CSVPrePopulate",
        "data-buildertype": "button",
        "content": "Schedule Pre-Populate (From CSV)",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "prePopulateCSV"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "primary": true,
        "style-hidden": false,
        "secondary": false,
        "other-visibleConition": "data.DataSource == 2"
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
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
        "secondary": true,
        "inverted": false
      }
    ],
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": ""
  }
]' WHERE [Id]='54181d8d-523f-4075-ac8e-575e817af26b';

UPDATE [dwMetadata] SET
[Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.283', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:47:54.990', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_DPLY_PRE_POPULATE",
  "lastUpdate": "2024-07-24T17:47:54.9885207+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c786f28a-7c1d-18a1-4e82-b9f14e49d539",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0967f63c-7b85-ccb8-9303-3e9b7cf2fe33",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5023f9da-3f2e-dda2-0f73-5a6311cce0c7",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83bce928-58fa-df11-8c38-8023ae24ffd3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "deca8cf6-dcd5-16dd-b0c0-394a30bc5bb4",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1b987af7-cddd-db61-fcd8-22c3f4c53430",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "374a9edc-ec27-f0f3-e318-ae95b1d65d56",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6368b51c-2ae4-cb3a-5ef7-1b413c202b5c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26703d56-1156-31f0-171d-e8d87610d564",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3b4f621f-b303-8322-460f-b72a0b58edec",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8579bacc-ad88-1655-66bf-fc4c0bc0e799",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a20baeb1-4027-5887-98ef-be1c2688cb8b",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c032b3d1-5303-f950-b1e0-23b6f059fa21",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8713a7b4-640f-8759-797b-8a6bfed64ca5",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7c124c4a-951e-b2cb-a968-d8c5273788e1",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dfd118fb-c4ae-28e5-0842-3651bbcc6547",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05468910-5730-4606-ca8a-2e51c41a049b",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4805992-33ac-ccb9-86e7-8dc8676e91d8",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0d2eaa09-3b24-f802-60f0-866ee281d2bb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08388972-fcf2-f431-14ee-2760c49ac885",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32f0783b-3ac4-05ef-afcb-513c0cf8a96a",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "22f01e4c-f4f5-b0a8-9ace-fff152c8861f",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2f395ae-8032-fb82-68ff-21491768e624",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8c9d150c-a4f8-bb87-e6d9-a1bc85955e43",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4cba037-57a7-977b-5611-779850d41495",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16fdf4f0-9710-d9c5-dfd9-919d2566a221",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9460cdee-c086-e3af-0ccd-b73915f33012",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5bf9eaaa-01b8-944f-0718-aa190ae0afa8",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42882ed3-0f8e-6d54-2a52-3499a8ed8dc7",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "14a0cd73-68bc-b02e-36eb-c474113482f2",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a3934ed-0ab2-ddfe-94b6-5dcefe8dfc01",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b217f1e9-4d95-46af-6850-93438bbaa77b",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bda4a316-cb9c-9c63-031a-d5f5c962de8c",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40074d33-2215-8f83-a2c6-103e301b60d2",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0f7f7c29-6856-d67d-7a28-52c37db4898a",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a8f1c8a9-ccb9-8119-3302-300fef905b8e",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "53a8bb29-ee35-bbbe-5e21-53706eb76527",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29d92318-26b2-a87c-2a62-36fc4e014814",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb1eb284-f895-ba94-87d0-22c7a6553d6a",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "624201ff-d565-fd15-2cb0-b007910456ac",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fad4c089-b443-251a-f24e-708131b711ea",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2eba97d8-5a12-25d7-e37a-a52fea864488",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a106511-5ee8-8d68-456d-122801b83c44",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e8ca787-2034-33c4-5966-190cfc0d1d78",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8dbefaa4-9886-95c2-ed6b-fcda217425d8",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "56b98d6c-ecf2-cf2c-dba7-29a2ea1a4cf3",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "722646b8-e0fa-5664-a7d1-9e3fa23bd1e9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "739c6a49-f04a-f95b-2e67-863ae59a2db2",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4c505d0d-4bd1-3673-b360-3af13fe1c638",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fb7b109-f7b4-1e28-0944-1371fb8059de",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "85ea249a-e020-aa37-6bf2-b1e891cd656e",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30a8203b-b474-503c-676c-545cf45771e9",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4209fb5b-8423-27f6-b5c1-d303126fcc18",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c3cd8263-34d2-221a-6255-fc2c0ca0367f",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "PrePopulate"
}' WHERE [Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f';

UPDATE [dwMetadata] SET
[Id]='5e580c8a-8a4e-425c-8649-d13f9a83d932', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:31:17.030', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:23:46.350', 
[Data]=N'[
  {
    "key": "frm_Recurrence",
    "data-buildertype": "form",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Recurring Deployment Settings",
        "size": "medium"
      },
      {
        "key": "Name",
        "data-buildertype": "input",
        "label": "Deployment",
        "fluid": true,
        "onChangeTimeout": 200,
        "readOnly": true
      },
      {
        "key": "DateStart",
        "data-buildertype": "input",
        "label": "Original Deployment Start",
        "fluid": true,
        "onChangeTimeout": 200,
        "type": "datetime",
        "readOnly": true
      },
      {
        "key": "formgroup_2",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "orientation": "grouped",
        "children": [
          {
            "key": "message_1",
            "data-buildertype": "message",
            "header": "Recurrent Child Deployment",
            "content": "This deployment was created as a recurrence of a parent deployment and may not have its own recurrent settings. Please edit settings on the parent.",
            "other-visibleConition": "",
            "warning": false,
            "info": true
          },
          {
            "key": "container_1",
            "data-buildertype": "container",
            "children": [
              {
                "key": "buttonCancel2",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
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
                "style-marginRight": "20px"
              },
              {
                "key": "buttonOpenParent",
                "data-buildertype": "button",
                "content": "Open Parent Deployment",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "navigateParentDeployment"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "secondary": true
              }
            ],
            "style-width": "100%",
            "style-marginTop": "20px"
          }
        ],
        "other-visibleConition": "!(data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
      },
      {
        "key": "cnt_Content",
        "data-buildertype": "container",
        "children": [
          {
            "key": "RecurrenceEnabled",
            "data-buildertype": "checkbox",
            "label": "Enable Recurring Deployments",
            "toggle": true,
            "other-readOnlyConition": "!(data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
          },
          {
            "key": "fg_RecurrenceSettings",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "RecurrenceFrequency",
                "data-buildertype": "dropdown",
                "label": "Frequency",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "value": "DAILY",
                    "text": "Daily"
                  },
                  {
                    "value": "WEEKLY",
                    "text": "Weekly"
                  },
                  {
                    "value": "MONTHLY",
                    "text": "Monthly"
                  },
                  {
                    "value": "QUARTERLY",
                    "text": "Quarterly"
                  },
                  {
                    "value": "HALF_YEARLY",
                    "text": "Half Yearly"
                  },
                  {
                    "value": "ANNUALLY",
                    "text": "Annually"
                  },
                  {
                    "value": "BIENNIALLY",
                    "text": "Biennially"
                  },
                  {
                    "value": "CUSTOM",
                    "text": "Custom"
                  }
                ],
                "placeholder": "Select frequency of recurrence",
                "style-width": "300px",
                "other-customValidation": "!data.RecurrenceEnabled || (value!==undefined&&value!==null&&value!==\"\") ? true : \" is required\"",
                "style-source": ""
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "header_5",
                    "data-buildertype": "header",
                    "content": "Custom Frequency",
                    "size": "small",
                    "textAlign": "left"
                  },
                  {
                    "key": "container_5",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "SelectedCustomFrequencyId",
                        "data-buildertype": "input",
                        "label": "Input",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "style-hidden": true
                      },
                      {
                        "key": "customFrequencyModal",
                        "data-buildertype": "swzmodal",
                        "other-visibleConition": "data.RecurrenceFrequency === ''CUSTOM''",
                        "content": "Add",
                        "style-display": "none",
                        "children": [
                          {
                            "key": "form_1",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "header_4",
                                "data-buildertype": "header",
                                "content": "Custom Frequency",
                                "size": "medium"
                              },
                              {
                                "key": "CustomFrequencyType",
                                "data-buildertype": "dropdown",
                                "label": "",
                                "fluid": false,
                                "selection": true,
                                "data-elements": [
                                  {
                                    "value": "EXACT DATE",
                                    "text": "Specific date"
                                  },
                                  {
                                    "key": 1,
                                    "value": "N DAY N MONTH",
                                    "text": "N Day of N Month"
                                  },
                                  {
                                    "value": "N WEEK N MONTH",
                                    "text": "N Week of N Month"
                                  },
                                  {
                                    "key": 2,
                                    "value": "N DAY EACH MONTH",
                                    "text": "N Day of Every Month"
                                  },
                                  {
                                    "value": "N WEEK EACH MONTH",
                                    "text": "N Week of Every Month"
                                  },
                                  {
                                    "key": 3,
                                    "value": "N LAST DAY N MONTH",
                                    "text": "Last N Day of N Month"
                                  },
                                  {
                                    "value": "N LAST WEEK N MONTH",
                                    "text": "Last N Week of N Month"
                                  },
                                  {
                                    "value": "N LAST DAY EACH MONTH",
                                    "text": "Last N Day of Every Month"
                                  },
                                  {
                                    "value": "N LAST WEEK EACH MONTH",
                                    "text": "Last N Week of Every Month"
                                  }
                                ],
                                "events": {},
                                "style-width": "300px",
                                "style-source": "",
                                "placeholder": "Select custom frequency type",
                                "other-visibleConition": ""
                              },
                              {
                                "key": "CustomFrequencyDate",
                                "data-buildertype": "input",
                                "label": "Exact Date",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "date",
                                "other-visibleConition": "data.CustomFrequencyType === ''EXACT DATE''",
                                "style-width": "",
                                "size": "",
                                "style-source": "",
                                "events": {},
                                "style-marginBottom": ""
                              },
                              {
                                "key": "customFrequencyDateSpacing",
                                "data-buildertype": "container",
                                "other-visibleConition": "data.CustomFrequencyType === ''EXACT DATE''",
                                "style-marginBottom": "250px"
                              },
                              {
                                "key": "formgroup_4",
                                "data-buildertype": "formgroup",
                                "widths": "custom",
                                "children": [
                                  {
                                    "key": "CustomFrequencyDay",
                                    "data-buildertype": "dropdown",
                                    "label": "Day",
                                    "fluid": true,
                                    "selection": true,
                                    "data-elements": [
                                      {
                                        "value": "1",
                                        "text": "1"
                                      },
                                      {
                                        "value": "2",
                                        "text": "2"
                                      },
                                      {
                                        "value": "3",
                                        "text": "3"
                                      },
                                      {
                                        "value": "4",
                                        "text": "4"
                                      },
                                      {
                                        "value": "5",
                                        "text": "5"
                                      },
                                      {
                                        "value": "6",
                                        "text": "6"
                                      },
                                      {
                                        "value": "7",
                                        "text": "7"
                                      },
                                      {
                                        "value": "8",
                                        "text": "8"
                                      },
                                      {
                                        "value": "9",
                                        "text": "9"
                                      },
                                      {
                                        "value": "10",
                                        "text": "10"
                                      },
                                      {
                                        "value": "11",
                                        "text": "11"
                                      },
                                      {
                                        "value": "12",
                                        "text": "12"
                                      },
                                      {
                                        "value": "13",
                                        "text": "13"
                                      },
                                      {
                                        "value": "14",
                                        "text": "14"
                                      },
                                      {
                                        "value": "15",
                                        "text": "15"
                                      },
                                      {
                                        "value": "16",
                                        "text": "16"
                                      },
                                      {
                                        "value": "17",
                                        "text": "17"
                                      },
                                      {
                                        "value": "18",
                                        "text": "18"
                                      },
                                      {
                                        "value": "19",
                                        "text": "19"
                                      },
                                      {
                                        "value": "20",
                                        "text": "20"
                                      },
                                      {
                                        "value": "21",
                                        "text": "21"
                                      },
                                      {
                                        "value": "22",
                                        "text": "22"
                                      },
                                      {
                                        "value": "23",
                                        "text": "23"
                                      },
                                      {
                                        "value": "24",
                                        "text": "24"
                                      },
                                      {
                                        "value": "25",
                                        "text": "25"
                                      },
                                      {
                                        "value": "26",
                                        "text": "26"
                                      },
                                      {
                                        "value": "27",
                                        "text": "27"
                                      },
                                      {
                                        "value": "28",
                                        "text": "28"
                                      },
                                      {
                                        "value": "29",
                                        "text": "29"
                                      },
                                      {
                                        "value": "30",
                                        "text": "30"
                                      },
                                      {
                                        "value": "31",
                                        "text": "31"
                                      }
                                    ],
                                    "placeholder": "Select Day",
                                    "style-width": "300px",
                                    "other-visibleConition": "data.CustomFrequencyType === ''N DAY N MONTH'' || data.CustomFrequencyType === ''N DAY EACH MONTH'' || data.CustomFrequencyType === ''N LAST DAY N MONTH'' || data.CustomFrequencyType === ''N LAST DAY EACH MONTH''"
                                  },
                                  {
                                    "key": "CustomFrequencyWeek",
                                    "data-buildertype": "dropdown",
                                    "label": "Week",
                                    "fluid": true,
                                    "selection": true,
                                    "data-elements": [
                                      {
                                        "value": "1",
                                        "text": "1"
                                      },
                                      {
                                        "value": "2",
                                        "text": "2"
                                      },
                                      {
                                        "value": "3",
                                        "text": "3"
                                      },
                                      {
                                        "value": "4",
                                        "text": "4"
                                      },
                                      {
                                        "value": "5",
                                        "text": "5"
                                      },
                                      {
                                        "value": "6",
                                        "text": "6"
                                      }
                                    ],
                                    "style-width": "300px",
                                    "style-customcss": "",
                                    "events": {},
                                    "other-visibleConition": "data.CustomFrequencyType === ''N WEEK N MONTH'' || data.CustomFrequencyType === ''N WEEK EACH MONTH'' || data.CustomFrequencyType === ''N LAST WEEK N MONTH'' || data.CustomFrequencyType === ''N LAST WEEK EACH MONTH''",
                                    "placeholder": "Select Week"
                                  },
                                  {
                                    "key": "CustomFrequencyMonth",
                                    "data-buildertype": "dropdown",
                                    "label": "Month",
                                    "fluid": true,
                                    "selection": true,
                                    "data-elements": [
                                      {
                                        "value": "1",
                                        "text": "January"
                                      },
                                      {
                                        "value": "2",
                                        "text": "February"
                                      },
                                      {
                                        "value": "3",
                                        "text": "March"
                                      },
                                      {
                                        "value": "4",
                                        "text": "April"
                                      },
                                      {
                                        "value": "5",
                                        "text": "May"
                                      },
                                      {
                                        "value": "6",
                                        "text": "June"
                                      },
                                      {
                                        "value": "7",
                                        "text": "July"
                                      },
                                      {
                                        "value": "8",
                                        "text": "August"
                                      },
                                      {
                                        "value": "9",
                                        "text": "September"
                                      },
                                      {
                                        "value": "10",
                                        "text": "October"
                                      },
                                      {
                                        "value": "11",
                                        "text": "November"
                                      },
                                      {
                                        "value": "12",
                                        "text": "December"
                                      }
                                    ],
                                    "placeholder": "Select Month",
                                    "events": {},
                                    "other-visibleConition": "data.CustomFrequencyType === ''N DAY N MONTH'' || data.CustomFrequencyType === ''N LAST DAY N MONTH'' || data.CustomFrequencyType === ''N WEEK N MONTH'' || data.CustomFrequencyType  === ''N LAST WEEK N MONTH''",
                                    "style-width": "300px"
                                  }
                                ],
                                "orientation": "inline",
                                "widthsCustom": "2",
                                "style-marginTop": "0px",
                                "style-marginBottom": "0px",
                                "style-marginLeft": "0px",
                                "style-marginRight": "0px",
                                "style-width": "100%"
                              },
                              {
                                "key": "container_4",
                                "data-buildertype": "container",
                                "children": [
                                  {
                                    "key": "btnCancelCustomRecurrence",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
                                    "secondary": true,
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeCustomFrequencyModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "floated": "",
                                    "size": "",
                                    "style-source": "float: right"
                                  },
                                  {
                                    "key": "btnSaveCustomRecurrence",
                                    "data-buildertype": "button",
                                    "content": "Save",
                                    "primary": true,
                                    "floated": "",
                                    "style-source": "float:right",
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "saveCustomFrequency"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    }
                                  }
                                ],
                                "style-float": "right",
                                "style-marginTop": "10px",
                                "style-marginBottom": "10px",
                                "style-width": "100%"
                              }
                            ]
                          }
                        ],
                        "secondary": true,
                        "style-source": "",
                        "style-marginRight": "",
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "resetCustomFrequencyModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-height": "500px",
                        "isOpen": ""
                      }
                    ],
                    "style-marginBottom": "10px",
                    "style-float": "left"
                  },
                  {
                    "key": "btnDeleteCustomFrequency",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "secondary": true,
                    "floated": "left",
                    "style-source": "float: left;",
                    "style-marginTop": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "gridDelete"
                        ],
                        "targets": [
                          "gdCustomFrequency"
                        ],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "QNN_DPLY_CUSTOM_RECURRENCE"
                          }
                        ]
                      }
                    }
                  },
                  {
                    "key": "gdCustomFrequency",
                    "data-buildertype": "gridview",
                    "columns": [
                      {
                        "key": "CustomFrequencyType",
                        "name": "Custom Frequency Type",
                        "resizable": true,
                        "sortable": false,
                        "filterable": false,
                        "width": 250
                      },
                      {
                        "key": "RecurrenceOn",
                        "name": "Recurrence On ",
                        "sortable": false,
                        "filterable": false,
                        "resizable": true,
                        "width": "",
                        "type": "custom"
                      }
                    ],
                    "events": {
                      "onRowClick": {
                        "active": false,
                        "actions": [
                          "setCustomFrequencyControlsVisibility",
                          "setCustomFrequencyControlsValue"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onRowDblClick": {
                        "active": true,
                        "actions": [
                          "setCustomFrequencyControlsVisibility",
                          "setCustomFrequencyControlsValue"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.RecurrenceFrequency === ''CUSTOM''",
                    "style-width": "",
                    "multiselect": true,
                    "editForm": "",
                    "editFormShowType": "",
                    "pagerType": "server",
                    "autoHeight": false,
                    "rowKey": "Id",
                    "defaultSort": "CustomFrequencyType ASC",
                    "pageSize": "",
                    "disableSort": false
                  }
                ],
                "other-visibleConition": "data.RecurrenceFrequency === ''CUSTOM''",
                "style-marginBottom": "10px",
                "style-customcss": "ui info message"
              },
              {
                "key": "RecurrenceEndDate",
                "data-buildertype": "input",
                "label": "Do not recur on or after",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "date",
                "placeholder": "Select end date",
                "other-customValidation": "!data.RecurrenceEnabled || (data.RecurrenceEnabled && value !== undefined && value !== null && value !== \"\") ? true : \" is required\"",
                "events": {}
              },
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "You may specify the survey administrator email addresses to be notified when the recurrences are created. Use a comma to separate multiple addresses.",
                "style-customcss": "ui info message"
              },
              {
                "key": "RecurrenceNotify",
                "data-buildertype": "input",
                "label": "Notify email(s)",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": ""
              },
              {
                "key": "IsCreateInAdvance",
                "data-buildertype": "checkbox",
                "label": "Create deployment in advance of start date",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleDaysInAdvance"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "fg_CreateInAdvance",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "RecurrenceAdvanceDays",
                    "data-buildertype": "input",
                    "label": "Days in advance of deployment start",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "style-width": "200px",
                    "other-visibleConition": "",
                    "defaultValue": "",
                    "other-customValidation": "(!data.RecurrenceEnabled || (data.RecurrenceEnabled && ( !data.IsCreateInAdvance || (  (value > 0) )   )    ) ) ? true : \"Must be at least one day in advance\""
                  },
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "Note: When the recurrence is created in advance it is necessary to manually open the new deployment before its start date and make it visible to respondents (and to make any other adjustments as desired).",
                    "style-customcss": "ui info message"
                  }
                ],
                "orientation": "grouped",
                "other-visibleConition": "data.IsCreateInAdvance || (data.RecurrenceAdvanceDays > 0)"
              },
              {
                "key": "container_399",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "IsRecurrencePrePopulateEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Pre-Populate Previous Recurring Data",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-readOnlyConition": ""
                  },
                  {
                    "key": "container_499",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "header_499",
                        "data-buildertype": "header",
                        "content": "Pre-Populate Fields",
                        "size": "small",
                        "other-visibleConition": "",
                        "textAlign": "left"
                      },
                      {
                        "key": "container_599",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "PrePopulateFields",
                            "data-buildertype": "collectioneditor",
                            "idField": "Id",
                            "parentIdField": "ParentId",
                            "columns": [
                              {
                                "key": "QnnFieldName",
                                "name": "Field Name",
                                "control": "span"
                              },
                              {
                                "key": "QnnFieldType",
                                "name": "Type",
                                "control": "span"
                              },
                              {
                                "control": "checkbox",
                                "name": "PrePopulate",
                                "key": "PrePopulate"
                              }
                            ],
                            "disableAdd": true,
                            "disableDelete": true,
                            "header": false,
                            "readOnly": false,
                            "headerTitle": "Pre-Populate Field",
                            "other-visibleConition": ""
                          }
                        ],
                        "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;"
                      },
                      {
                        "key": "addAllFields",
                        "data-buildertype": "breadcrumb",
                        "items": [
                          {
                            "text": "Add All",
                            "url": "/"
                          }
                        ],
                        "events": {
                          "onItemClick": {
                            "active": true,
                            "actions": [
                              "addAllFields"
                            ],
                            "targets": [
                              "PrePopulateFields"
                            ],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "RemoveAllFields",
                        "data-buildertype": "breadcrumb",
                        "items": [
                          {
                            "text": "Remove All",
                            "url": "/"
                          }
                        ],
                        "events": {
                          "onItemClick": {
                            "active": true,
                            "actions": [
                              "removeAllFields"
                            ],
                            "targets": [
                              "PrePopulateFields"
                            ],
                            "parameters": []
                          }
                        },
                        "style-marginLeft": "10px"
                      }
                    ],
                    "style-customcss": "ui info message",
                    "other-visibleConition": "data.IsRecurrencePrePopulateEnabled",
                    "events": {},
                    "style-source": "",
                    "style-width": "",
                    "style-height": ""
                  }
                ],
                "style-marginTop": "10px",
                "style-marginBottom": "10px",
                "other-customValidation": "",
                "other-visibleConition": "!(data.IsMultipleResponse || data.IsAnonymous)"
              }
            ],
            "other-visibleConition": "data.RecurrenceEnabled && (data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "btn_Save",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "style-marginRight": "20px",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "updateRecurrence"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btn_Cancel",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
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
                }
              }
            ],
            "style-width": "100%",
            "style-marginTop": "20px",
            "style-marginBottom": ""
          },
          {
            "key": "fg_NextDeployment",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "other-visibleConition": "data.RecurrenceEnabled && !(data.RecurrenceNextDate===undefined || data.RecurrenceNextDate===null)",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Next Deployment Recurrence",
                "size": "small",
                "textAlign": "left"
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Start Date",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "readOnly": true
              },
              {
                "key": "RecurrenceJobId",
                "data-buildertype": "input",
                "label": "Job Id",
                "fluid": true,
                "onChangeTimeout": 200,
                "readOnly": true,
                "style-width": "200px",
                "other-visibleConition": "CloverApp.API.checkRole(''Admins'')"
              }
            ],
            "orientation": "grouped",
            "style-customcss": "ui info message",
            "style-marginTop": "20px"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "other-visibleConition": "",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Previous Recurrences",
                "size": "small",
                "textAlign": "left"
              },
              {
                "key": "gv_Recurrences",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Deployment",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
                  },
                  {
                    "key": "CreatedDate",
                    "name": "Created",
                    "type": "datetime",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
                  },
                  {
                    "key": "DateStart",
                    "name": "Start",
                    "type": "datetime",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
                  },
                  {
                    "key": "DateEnd",
                    "name": "End",
                    "type": "datetime",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
                  }
                ],
                "rowKey": "Id",
                "defaultSort": "DateStart DESC",
                "editForm": "QNN_DPLY",
                "events": {
                  "onRowClick": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  },
                  "onRowDblClick": {
                    "active": true,
                    "actions": [
                      "gridEdit"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "orientation": "grouped",
            "style-customcss": "ui info message",
            "style-marginTop": "20px"
          }
        ],
        "other-visibleConition": "data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null"
      }
    ],
    "style-width": "800px"
  }
]' WHERE [Id]='5e580c8a-8a4e-425c-8649-d13f9a83d932';

UPDATE [dwMetadata] SET
[Id]='d95c76fc-a10b-4b34-aba6-6020b42217e0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:31:17.383', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-24 17:23:46.380', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyRecurrence",
  "lastUpdate": "2024-07-24T17:23:46.3783874+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "251086a6-9399-d8b4-63e7-ba1660361ce5",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19376db4-1b08-4983-e2ac-f2ea9d640f9a",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9813d5e6-7c04-e009-e4bb-c9b8f3b5d55b",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b4bb55f0-f82f-a93d-1109-219383c4f2d0",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7bcd2347-39ef-0f03-8c32-056da5b73032",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ced0b87-251b-7bc3-3f8a-51918c46cc6f",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b78e117b-2f62-87a1-5b0f-33801efd99df",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7d11d08-5bb9-dff9-3966-83af84286faf",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf119136-969d-1ca7-4650-b8d4917de1f5",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "396d1e83-5c27-6613-b419-5254bba6fdc4",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1bb0899f-2109-768d-ca5c-ce8afcb2060f",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fd4565b-3642-6b97-618e-6d716c89c1f8",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08542a1d-242c-35a8-dda8-740a08ad2092",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5df21c8c-d3de-eae6-051b-5c1db67e1da2",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a38dfee-a00a-7d63-7b9c-bbcb8c5b65bc",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f7880bc4-1c46-937d-7175-5e2efe3d997e",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78b08312-ac0b-8128-f8eb-aeff8cb77a48",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c6ce037-b742-ceb9-3ee5-9a4b3525b2ef",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c71bdf11-1624-1231-5366-3aa0f04dfd0f",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1eba387a-86ab-b769-93c2-19be0af741f2",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d813e036-b7d0-4382-d0ef-4bc92134fc6d",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "578fff01-828f-85a9-873c-6d69de559bec",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f02556a8-6e23-c4f8-ebee-96ffb82edbc3",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0d6c610e-2f7f-2ade-8143-0e9fb356909b",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80c71fa7-f762-a7af-9152-a73ecb9a62da",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "07f82828-f0b9-a585-cad6-16b5b82f6777",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "76f33d11-24ca-0d34-6470-9699d3c96d3f",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "92121ab3-8fb2-dae3-d494-34e196e18c95",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83f70cd0-970e-2165-2a39-6122b4bea908",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5139398a-ef15-65f8-f085-dd0f54f3df2c",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f2632b8-7449-ac57-12b3-06ea9a1e9abf",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a54494d6-7a6c-998b-f242-d6b9b7fb705f",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6b6dc71e-d173-6dc6-d8dc-71403d7baab2",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0bd3e4b8-542a-319f-1614-259e3e8df05c",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89e4b751-39ab-2d39-54bc-96e7091a236f",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4de30b35-9677-359f-b046-bdc28cf3d315",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "99cbb340-27e5-6d7a-b46c-5d04932c8435",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37d9dee-8f1d-6230-a206-35db9adbdc44",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce4a034-4933-414d-c9ac-da209056f06b",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7fc6413c-ed37-ea4a-61f5-336f53656ceb",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9fd860f7-c45f-9737-36a3-9761cba216dd",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f188cf30-c69a-ff10-1bb5-36d18d877607",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "control": "RecurrenceAdvanceDays",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40cabcc7-19e0-b86b-24d4-5dafeb5d15c9",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "control": "RecurrenceEndDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f2de1058-725a-21f3-35ed-4da89bd5cb0a",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "control": "RecurrenceFrequency",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78cc56ee-39fe-9c54-be43-f34b3d3f6aaf",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf1c5389-f718-9d16-3f8a-f07e73892cae",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "control": "RecurrenceEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08dda8b8-790d-48d0-4208-e67f63529dc4",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26f0788a-26d5-8188-10ed-96f51a3effba",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "abb95675-e12e-f2d3-d525-840696c59eee",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "96503d76-9542-3d5f-cc3d-41add7d817eb",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5c5b2ef-33d4-37b8-b35b-464dec08eef3",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b319589-c62f-57b3-5349-e49141d81ccc",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9efde21-2d98-58bf-092c-ab4d66a1c84f",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "93e017cc-f0a7-33ff-d3d9-d9cfe2310bce",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "5ea05b61-68da-691f-85de-92d435d5dc64",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterByModelId",
      "parameter": "{RecurrenceOfDplyId: \"@Id\"}",
      "control": "gv_Recurrences",
      "dataMap": [
        {
          "id": "dbd2ca31-e8c2-80f2-c7a2-f6730f524b52",
          "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e91d7ff4-ceb8-0208-49dd-79b2df16f66f",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5aca1c6-6fb7-41db-ac7e-ea2fc2aea4e2",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cbcabb25-3cfa-26f9-3db3-06d7cb632edd",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f14bdb5-5a89-06eb-e653-6c5e4dc75174",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11383080-2bff-f6f0-324a-4b12e8837ae2",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c766d920-5208-43b5-aac3-332f9893b213",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a8ef1c50-8e6c-3978-ee1f-5877c0ddd37c",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6351e09e-1fd6-d846-c41b-7f1ea965ae5b",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e79adbe7-4448-ccfc-18d5-86b4778ce111",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb8163d6-7c68-5419-9b21-ee2b340fb74b",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae812efb-32d6-a497-df76-5db272213a91",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "46fbbb0c-a6b6-5592-0b7a-4e9fa7192ffc",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14935a6a-b667-8145-58ce-cb2470d95e41",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dbfefdc3-c033-4d72-ae74-3cd0f141134c",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69c5491e-fd30-14cf-1055-4beb1aaa46cf",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ff15a20-ea53-707e-2def-b81681bd6bdb",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf7c684d-c238-6c19-d5a4-1a34ddc6a275",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d2143ebf-9642-60e4-e856-420f20261e2c",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "776e0c0d-0262-5407-f045-1924e5107852",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff4e4aba-6994-ac95-c55e-5055fe42d18b",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d7adab5-714b-ef27-8768-1292cc7e6c92",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60f24e99-75da-56ce-ed74-9dd4e862d1d2",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "016c131e-ec57-a7f4-22f5-90f50e065a34",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9ec6c2d5-aefc-0abd-5657-40f99730a23f",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4a0fb874-914e-4631-aba1-81006e5d216e",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab81cba1-59fb-30f5-323c-ab61f9bfd383",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6c3b3401-3606-c89d-c154-567ad76a46d6",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b6d44a9-7c08-3bd0-fe80-02f5249b8870",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b0805e99-8971-14b5-4f07-21a861e8bf46",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fb4e3217-411e-61c9-984c-43dfcc374e32",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4477254a-8846-4fce-8112-db21b87d47fd",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fb92a2af-fcba-baaf-ce09-797007fe4f3c",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c100932d-c98e-6a39-1de3-94e922e24b1c",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8f2e49dd-3806-103a-bf3e-17afea2f9d3f",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b07b6d5-b0ea-b769-11e1-75ef32595aad",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "994fecdc-2a81-1790-3da3-24b50cf08b8b",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfcb88c1-3cdc-b2f3-9fd3-22bf1464e58f",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "18fe52dc-9c0a-797f-0688-cfec218dbd7e",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09f65613-284b-4bc8-45a4-910b2538f682",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d0e8347-ecc6-9ede-3b7b-16e1ae0960a9",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e2fa299c-229e-c3c9-e58c-33a8292f5374",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ae7ad15-0775-61d4-c42d-09d76e5b7f7c",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5874f7a1-4f95-8230-249c-691fd944dd55",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "667cb25b-81a3-55c9-6b70-d353743f6cc2",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a4a6499-c5dd-749f-e700-338ea1555b43",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "caef425b-9d21-0365-8e1f-95ad118e9f4c",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb460600-33cc-ab13-0e44-d46a46ce6fbe",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ef69fb9f-86a7-0b17-a8b8-2c9b2304da5c",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3b024270-125c-3740-c210-1465431381c9",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1dde943f-9c78-ee12-8ca4-44d7f2d8d758",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6461281-4326-84ab-693a-10eb8b3568ec",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "816c4fae-ffff-b72c-970b-cf2b1b4143c1",
          "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39c4943d-011f-8767-044b-d35cf679e97e",
          "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gv_Recurrences_totalcount"
    },
    {
      "id": "74050ff6-ed30-c6c9-8d6e-e0a365c7ae59",
      "entityId": "a201ebb9-a7ef-4753-b162-47841336d562",
      "filter": "FilterByModelId",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "PrePopulateFields",
      "dataMap": [
        {
          "id": "eed063e0-662e-7ecf-7fbb-38b819fc4ae8",
          "attributeId": "c8b903d9-6dde-450b-adb2-0a7948047f5d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9522ab8a-1894-2113-4f8a-6403e2d03add",
          "attributeId": "8fad157c-5c95-4014-abca-895070e078a8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4e1c399-4578-17a1-a23d-a6e295965cb0",
          "attributeId": "436fed2d-8ec3-4677-ab00-40611ca10734",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4527fa66-e99d-2369-4d64-a181c4d444d3",
          "attributeId": "e76aa78e-99ff-491b-92dc-cee0b3158dfd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff0e33a3-d0aa-b851-59f9-9c9cbfbdc87f",
          "attributeId": "8e394b8b-9ab2-4b98-ade3-b63b538a030a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3400fe5c-af42-ab1e-7107-5778d416b71e",
          "attributeId": "ea03357d-fad0-4bb2-928b-1c5756c63016",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__PrePopulateFields_totalcount"
    },
    {
      "id": "0d9b543c-0c01-d30d-d0fa-75dfe67fd1af",
      "entityId": "3c39bb2d-0db5-453b-868f-1094da479292",
      "filter": "FilterByModelId",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "gdCustomFrequency",
      "dataMap": [
        {
          "id": "1adc121e-57b8-4bf0-d275-69534293c7c2",
          "attributeId": "03936e9a-293c-4c2f-bd0e-16d2b81c84e9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1973d758-4123-0e1e-bb11-41ba1bf4ae67",
          "attributeId": "6ab6c2e3-2f40-4e1d-b866-b8ab17092a0f",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8ea481e2-d2d4-9c06-2f1d-f8d89e790bc6",
          "attributeId": "de3905ff-a670-43af-bf11-d038ff133e0b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32622804-38e0-a104-7d31-a34e90a585e3",
          "attributeId": "3fc3bce6-3fae-451b-bd09-7e5016eb4a37",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5500a696-c27e-7a60-5583-2a5b65625e2b",
          "attributeId": "20b5906b-ee07-4ee7-8927-632440b5537c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99cc025d-6843-d0b4-dbdb-bdc71adcc609",
          "attributeId": "a61ce22f-4bf0-4e86-be45-3a3d17adfb49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e3caf96f-0d28-149e-57e7-ba747b486931",
          "attributeId": "7d244f96-18a9-4f22-83fb-6c0c92682b5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "beeecfef-21e3-f429-abaf-8b700e8af99f",
          "attributeId": "acdbfe29-3a2c-48c7-8220-e973d49530ce",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "79561ac1-c558-6795-ef8d-31dd37204aab",
          "attributeId": "fc5b24d4-f694-43b7-873d-2c3c6ba2a087",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5251d549-63ca-1c97-47d4-dba6963a14ec",
          "attributeId": "b26c218a-c003-4414-b385-cce4d55f95c4",
          "isEditable": true,
          "isLoadable": false
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gdCustomFrequency_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='d95c76fc-a10b-4b34-aba6-6020b42217e0';

