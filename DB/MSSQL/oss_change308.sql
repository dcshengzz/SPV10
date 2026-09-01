-- Originally created in MPA Pentest Branch
-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyListSample.json
-- QNN_DPLY_PRE_POPULATE.json
-- SwzTrkLists.json
-- QNN_TRK_LIST.json
-- Organizations.json
-- SwzQnnList.json
-- DataEditorDeploymentList.json

UPDATE [dwMetadata] SET
[Id]='4ccdc858-527d-4321-8bee-942751feb26e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:06:35.597', 
[Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
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
                      "gridListSamples"
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
                    "onChangeTimeout": "500",
                    "type": "datetime",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "gridListSamples"
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
                    "onChangeTimeout": "500",
                    "type": "datetime",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "gridListSamples"
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
                "key": "modalDueDate",
                "data-buildertype": "swzmodal",
                "style-display": "none",
                "children": [
                  {
                    "key": "container_8",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "formgroup_1",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "orientation": "grouped",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Manage Due Date",
                            "size": "medium",
                            "subheader": ""
                          },
                          {
                            "key": "staticcontent_1",
                            "data-buildertype": "staticcontent",
                            "content": "Select a new Due Date for the chosen samples.<br/>\n<i>Note: due date may only be pushed later, earlier dates will not be respected</i>",
                            "style-marginTop": "20px",
                            "isHtml": true
                          },
                          {
                            "key": "dueDate",
                            "data-buildertype": "input",
                            "label": "Due Date",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "datetime",
                            "style-marginTop": "20px"
                          }
                        ]
                      },
                      {
                        "key": "container_17",
                        "data-buildertype": "container",
                        "style-width": "100%",
                        "style-marginTop": "20px",
                        "children": [
                          {
                            "key": "btnSubmitManageDueDate",
                            "data-buildertype": "button",
                            "content": "Submit",
                            "secondary": false,
                            "inverted": false,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "changeDueDate"
                                ],
                                "targets": [
                                  "gridListSamples"
                                ],
                                "parameters": []
                              }
                            },
                            "style-marginTop": "20px",
                            "primary": true
                          },
                          {
                            "key": "btnCancelManageDueDate",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeModal"
                                ],
                                "targets": [
                                  "modalDueDate"
                                ],
                                "parameters": []
                              }
                            },
                            "style-marginLeft": "20px"
                          }
                        ]
                      }
                    ],
                    "style-customcss": "",
                    "style-source": "padding: 20px;"
                  }
                ],
                "content": "Extend Due Date",
                "secondary": true,
                "inverted": false,
                "style-customcss": "",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "onOpenManageDueDate"
                    ],
                    "targets": [],
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
                      "gridListSamples"
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
                    "onChangeTimeout": "500",
                    "type": "datetime",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "gridListSamples"
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
                    "onChangeTimeout": "500",
                    "type": "datetime",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "gridListSamples"
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
                      "confirm",
                      "sampleResetPassword"
                    ],
                    "targets": [
                      "gridListSamples"
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
                "key": "modalSendMessage",
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
                                "active": false,
                                "actions": [],
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
                                "active": false,
                                "actions": [],
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
                                "active": false,
                                "actions": [],
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
                        "style-marginTop": "20px",
                        "style-marginBottom": "20px"
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
                            "key": "btnSubmitSendMessage",
                            "data-buildertype": "button",
                            "content": "Submit",
                            "secondary": false,
                            "inverted": false,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "sendMessage"
                                ],
                                "targets": [
                                  "gridListSamples"
                                ],
                                "parameters": []
                              }
                            },
                            "primary": true
                          },
                          {
                            "key": "btnCancelSendMessage",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeModal"
                                ],
                                "targets": [
                                  "modalSendMessage"
                                ],
                                "parameters": []
                              }
                            },
                            "style-marginLeft": "20px"
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
                      "onOpenSendMessage"
                    ],
                    "targets": [
                      "gridListSamples"
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
                "key": "btnResetDelegationCode",
                "data-buildertype": "button",
                "content": "Reset Delegation Code",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "confirm",
                      "sampleResetDelegationCode"
                    ],
                    "targets": [
                      "gridListSamples"
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
      }
    ]
  },
  {
    "key": "gridListSamples",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UIDName",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response End",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      },
      {
        "key": "CreatedDate",
        "name": "Generated On",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true
      }
    ],
    "rowKey": "Id",
    "pagerType": "server",
    "defaultSort": "UIDName ASC",
    "multiselect": true,
    "rowHeight": "80",
    "pageSize": "128"
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
              "gridListSamples"
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
        "content": "Cancel",
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

UPDATE [dwMetadata] SET
[Id]='54181d8d-523f-4075-ac8e-575e817af26b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.213', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:09:31.883', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Data Pre-Populate",
    "size": "huge",
    "subheader": " {Name}"
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
            "content": "Pre-populate will initialise response data in this deployment as specified below. It only pre-sets answers where the sample has yet to start responding. For these cases any existing pre-populated data will be cleared and replaced with the data specified below.",
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
      }
    ]
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
    "style-width": "50%"
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
            "key": "uploadFile",
            "data-buildertype": "button",
            "content": "Upload CSV File",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "clickFileUpload"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "primary": false,
            "style-hidden": false,
            "secondary": true
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "children": [
              {
                "key": "CsvFileUploaded",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "file",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "csvFileUploaded"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-hidden": false,
                "style-source": ""
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "CsvInfo",
                "data-buildertype": "staticcontent",
                "content": "The CSV must have a header row to provide alias/field names and contain a UID column."
              }
            ],
            "style-marginTop": "10px",
            "style-marginBottom": "10px"
          }
        ],
        "style-width": "50%",
        "style-marginBottom": "20px"
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
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Pre-Populate",
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
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:12:52.280', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track Lists",
        "size": "large"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Create",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridCreate"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "gridDelete"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": []
          }
        }
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "input_1",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              },
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
                    "value": "Name, StructDivisionId_Name"
                  }
                ]
              }
            },
            "placeholder": "Filter by Name",
            "style-marginBottom": ""
          }
        ],
        "style-width": "48%",
        "style-float": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "right",
        "style-width": "48%",
        "children": [
          {
            "key": "dictionary_1",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter by Division",
            "dataModel": "vSP_StructDivision",
            "columns": "Name ASC",
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
                    "value": "StructDivisionId_Name"
                  }
                ]
              }
            },
            "style-marginBottom": "",
            "paging": true,
            "pageSize": "20",
            "clearable": true
          }
        ]
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "form_2",
    "data-buildertype": "form",
    "children": []
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "sortable": false,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "rowHeight": "50",
    "minHeight": "250",
    "pageSize": "10",
    "defaultSort": "Name ASC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": true,
    "editForm": "QNN_TRK_LIST",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    }
  }
]' WHERE [Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64';

UPDATE [dwMetadata] SET
[Id]='94df18e6-8c55-43f0-883c-8b905a2d882f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:13:25.197', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginBottom": "20px",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List",
        "size": "large"
      }
    ]
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
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Description",
            "data-buildertype": "textarea",
            "label": "Description",
            "fluid": true
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "btnExit",
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
                        "value": "/form/swztrklists"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ],
            "style-marginBottom": "20px",
            "style-float": "right"
          }
        ]
      }
    ]
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newTrkListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelete",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "gridDelete",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_7",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Track List Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "breadcrumb_1",
                            "data-buildertype": "breadcrumb",
                            "items": [
                              {
                                "text": "Download Template",
                                "url": "#"
                              }
                            ],
                            "events": {
                              "onItemClick": {
                                "active": true,
                                "actions": [
                                  "onDownloadTemplate"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "hideMessages"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "headerListSampleAdded",
                            "data-buildertype": "header",
                            "content": "Track List Sample Added: {listSampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleAddedCount!=null"
                          },
                          {
                            "key": "headerListSampleUpdated",
                            "data-buildertype": "header",
                            "content": "Track List Sample Updated: {listSampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleUpdatedCount!= null"
                          },
                          {
                            "key": "gridviewImportSummary",
                            "data-buildertype": "gridview",
                            "columns": [
                              {
                                "key": "RowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "UID",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              }
                            ],
                            "style-hidden": false,
                            "events": {},
                            "other-visibleConition": "data.gridviewImportSummary!= null && data.gridviewImportSummary!=undefined",
                            "rowKey": "RowNo",
                            "minHeight": "150"
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_20",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "children": [],
                "style-float": "left"
              }
            ],
            "style-width": "",
            "style-float": "left",
            "style-marginRight": "",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "gridviewSample",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "UID",
                "name": "UID",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Name",
                "name": "Name",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Email",
                "name": "Email",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "offSet": "",
            "multiselect": true,
            "rowKey": "Id",
            "defaultSort": "UID ASC",
            "events": {
              "onRowClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
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
            },
            "pagerType": "server",
            "editFormShowType": "",
            "minHeight": "",
            "style-marginTop": "",
            "editForm": "QNN_TRK_LIST_SAMPLE",
            "style-hidden": false,
            "pageSize": "80",
            "rowHeight": "80"
          }
        ],
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-customcss": "hrm-block",
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  }
]' WHERE [Id]='94df18e6-8c55-43f0-883c-8b905a2d882f';

UPDATE [dwMetadata] SET
[Id]='a211ced0-595c-465a-bb8b-93b991246ec4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.013', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:19:19.043', 
[Data]=N'[
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "Save",
    "primary": true,
    "inverted": false,
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "validate",
          "save"
        ],
        "targets": [
          "collectioneditor_1"
        ],
        "parameters": []
      }
    },
    "compact": false
  },
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Organisation Structure",
    "size": "large",
    "textAlign": "left"
  },
  {
    "key": "collectioneditor_1",
    "data-buildertype": "collectioneditor",
    "idField": "Id",
    "parentIdField": "ParentId",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "width": "30%"
      }
    ],
    "hierarchical": true,
    "disableAdd": false,
    "disableDelete": false,
    "header": true,
    "draggable": false,
    "collapseAll": false,
    "other-visibleConition": ""
  }
]' WHERE [Id]='a211ced0-595c-465a-bb8b-93b991246ec4';

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-18 17:44:28.707', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Form Properties",
        "size": "huge",
        "textAlign": "left",
        "style-width": "",
        "style-marginLeft": "",
        "events": {},
        "style-source": ""
      },
      {
        "key": "modalDiv",
        "data-buildertype": "container",
        "children": [
          {
            "key": "copyModal",
            "data-buildertype": "swzmodal",
            "style-display": "block",
            "inverted": true,
            "secondary": true,
            "children": [
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopyQnn",
                    "data-buildertype": "header",
                    "content": "Copy Form Properties",
                    "size": "medium",
                    "subheader": "New Form Properties Name*"
                  },
                  {
                    "key": "CopyQnnId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "NewQnnName",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200
                  },
                  {
                    "key": "container_3",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "container_4",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "btnCopy",
                            "data-buildertype": "button",
                            "content": "Copy",
                            "primary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "copyQnn"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginRight": "20px",
                            "floated": ""
                          },
                          {
                            "key": "btnCancelCopy",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeModal"
                                ],
                                "targets": [
                                  "copyModal"
                                ],
                                "parameters": []
                              }
                            },
                            "floated": ""
                          }
                        ],
                        "style-float": "right"
                      }
                    ],
                    "style-float": "",
                    "style-width": "100%",
                    "events": {},
                    "style-marginBottom": "20px"
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnCreate2",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "style-source": "float:left",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Delete",
            "primary": false,
            "style-source": "float:left",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": []
              }
            },
            "secondary": true,
            "inverted": false
          },
          {
            "key": "123",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1123",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "inputSearch",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": "",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "gridQnn"
                        ],
                        "parameters": [
                          {
                            "name": "column",
                            "value": "Title,CreatedDate"
                          }
                        ]
                      }
                    },
                    "placeholder": "Search..."
                  }
                ],
                "style-float": "left",
                "style-width": "300px"
              }
            ],
            "style-float": "left"
          }
        ],
        "style-float": "left",
        "style-marginRight": "20px"
      }
    ],
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "gridQnn",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Title",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom"
      },
      {
        "key": "Status",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "checkbox"
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false
      }
    ],
    "editForm": "QNN_QNN",
    "multiselect": true,
    "pagerType": "server",
    "pageSize": "50",
    "rowKey": "Id",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500"
  }
]' WHERE [Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef';

UPDATE [dwMetadata] SET
[Id]='55831859-15d6-47cc-accd-ff632cdd1845', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeploymentList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:18.683', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-18 09:35:16.037', 
[Data]=N'[
  {
    "key": "headerDataEditorList",
    "data-buildertype": "header",
    "content": "Data Editor",
    "size": "huge",
    "subheader": "View a list of deployments under you",
    "style-marginTop": "10px"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "editorBarChart",
            "data-buildertype": "doughnutchart",
            "chartType": "doughnut",
            "datasetLabel": "",
            "legendPosition": "bottom",
            "responsive": true,
            "style-width": "300px",
            "style-source": "margin: auto;",
            "datasetCustom": false,
            "events": {}
          },
          {
            "key": "refreshChart",
            "data-buildertype": "button",
            "content": "Refresh",
            "events": {
              "onClick": {
                "active": false,
                "actions": [
                  "updateBarChart"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "primary": false,
            "style-width": "100%",
            "style-source": "",
            "secondary": true,
            "compact": false,
            "style-hidden": true,
            "style-marginTop": "5px",
            "style-marginBottom": "5px"
          }
        ],
        "style-width": "50%",
        "style-marginTop": "1em"
      },
      {
        "key": "dictionary_1",
        "data-buildertype": "dictionary",
        "label": "Category",
        "fluid": true,
        "selection": true,
        "dataModel": "QNN_CATEGORY",
        "columns": "Name ASC",
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
                "value": "Category"
              }
            ]
          }
        },
        "style-width": "50%",
        "search": false,
        "clearable": true,
        "onChangeTimeout": "",
        "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
      },
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": "200",
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
                "value": "*"
              }
            ]
          }
        },
        "labelPosition": "",
        "inverted": false,
        "transparent": false,
        "style-width": "50%",
        "placeholder": "Search.."
      }
    ],
    "style-source": "",
    "style-marginBottom": "30px"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": ""
      },
      {
        "key": "IsAnonymous",
        "resizable": true,
        "name": "Anonymous",
        "type": "checkbox",
        "sortable": true,
        "filterable": false
      },
      {
        "key": "IsMultipleResponse",
        "name": "Multiple",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "StatusText",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Title",
        "name": "Form",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Category",
        "name": "Category",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "",
        "width": ""
      },
      {
        "key": "Responses",
        "name": "Responses",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "DateEnd",
        "name": "Date End",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": ""
      }
    ],
    "editForm": "QNN_DPLY_SAMPLE_INFO",
    "multiselect": false,
    "pagerType": "",
    "defaultSort": "CreatedDate ASC",
    "autoHeight": false,
    "offSet": "",
    "rowKey": "Id",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [
          "gridRefresh"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-customcss": "",
    "style-source": "",
    "pageSize": "50",
    "minHeight": "",
    "rowHeight": "80"
  }
]' WHERE [Id]='55831859-15d6-47cc-accd-ff632cdd1845';

