-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyListSample.json
-- dplyListSample-settings.json
-- dplyListSample-code.js
-- dplyMessage.json
-- dplyMessage-settings.json
-- dplyMessage-code.js
-- dplyMessages.json
-- dplyMessages-settings.json
-- dplyMessages-code.js

UPDATE [dwMetadata] SET
[Id]='4ccdc858-527d-4321-8bee-942751feb26e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-17 17:35:48.603', 
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
                "content": "Set Due Date",
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
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "orientation": "grouped",
                        "children": [
                          {
                            "key": "UseRawHtml",
                            "data-buildertype": "checkbox",
                            "label": "Use Raw HTML Template",
                            "toggle": true,
                            "style-marginTop": "10px",
                            "style-marginBottom": "10px",
                            "events": {},
                            "other-visibleConition": "data.cbMailMerge||data.cbEmail"
                          },
                          {
                            "key": "htmlRaw",
                            "data-buildertype": "textarea",
                            "label": "",
                            "fluid": true,
                            "rows": "12",
                            "style-width": "100%",
                            "other-visibleConition": "(data.UseRawHtml && (data.cbMailMerge||data.cbEmail))"
                          }
                        ]
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
                        "other-visibleConition": "(!data.UseRawHtml && (data.cbMailMerge||data.cbEmail))"
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
                                  "profileMailMergeToSamples"
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
[Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-17 17:35:48.647', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyListSample",
  "lastUpdate": "2022-10-17T17:35:48.6462728+08:00",
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
    },
    {
      "id": "d8950925-6f18-4e76-b947-7bb4689cf97f",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ffedbea9-9cd6-a2d9-5e55-cb1d1bfdb2d6",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
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
      "control": "gridListSamples",
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
          "id": "933af709-b148-4b2e-06a8-a27477be0116",
          "attributeId": "9eb710fb-abce-48df-bcb7-10973ce31e6d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8097400-8a5b-c75d-127c-2b24f70df23a",
          "attributeId": "f84924a8-77d0-4b03-8f0a-fc97de0df311",
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
        },
        {
          "id": "fdbd27fc-a9aa-63a2-b280-e40d8156644c",
          "attributeId": "5e31222f-ebf1-4707-a20f-33636fc4064b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridListSamples_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8';

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-17 17:18:31.307', 
[Data]=N'{
    addNewSample: function(args){
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        Utils.loadingStart("Updating deployment samples from list");
        Utils.postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of addNewSample
    
    closeModal: function(args) {
        args.controlRef.close(); //expects modal as event target    
    },
    
    onOpenManageDueDate: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalDueDate = args.component.refs.modalDueDate;
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    changeDueDate: function(args){
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='''') {
            alertify.error("Please select the due date");
            return {};
        }else if(Date.parse(dueDate) <= Date.parse(args.data.DateStart)){
            alertify.error("Due Date must be after Deployment Start Date (" + CloverApp.API.formatDatetime(args.data.DateStart, window.CloverLang.common.datetimeFormat) + ")");
            return {};
        }
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        Utils.loadingStart("Updating Due Dates");
        Utils.postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success(result.message);
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of changeDueDate

    onOpenSendMessage: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        if(noSamplesSelectedInGrid){
            modalSendMessage.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    //previously named sendMessage
    profileMailMergeToSamples: function(args){
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
 
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.data.UseRawHtml ? args.data.htmlRaw : args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = args.data.UseRawHtml ? null : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        }
        const subject = args.data.subject;

        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Message content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );

        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToSamples", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success(result.message);
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }
        
        const sampleIds = gridListSamples.state.selectedIndexes.map( gridIndex => gridListSamples.state.items[gridIndex].SampleId);
        const formData = new FormData();
        formData.append("sampleIds", sampleIds);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error(reason);
            }
        ).then(Utils.loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);

        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }        

        const sampleIds = gridListSamples.state.selectedIndexes
            .map( gridIndex => gridListSamples.state.items[gridIndex]) //extract selected grid items
            .map( item => { return { sampleId: item.SampleId, sampleInfoId: item.Id } } ); //extract objects with desired ids

        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

UPDATE [dwMetadata] SET
[Id]='057eacaf-f332-4646-aa05-4e3d5656246a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:47.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-17 18:47:17.580', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Deployment Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5> {EmailSubj}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5> {MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>\n\n",
        "isHtml": true
      },
      {
        "key": "staticcontent_EmailFrom",
        "data-buildertype": "staticcontent",
        "content": "{EmailFrom}",
        "isHtml": false,
        "other-visibleConition": "(data.EmailFrom != null && data.EmailFrom != \"\")"
      },
      {
        "key": "staticcontent_EmailFromDefault",
        "data-buildertype": "staticcontent",
        "content": "<i>(Default Sender)</i>",
        "isHtml": true,
        "other-visibleConition": "(data.EmailFrom == null || data.EmailFrom == \"\")"
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Scheduled time:</h5>{ScheduledDate}<p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_1",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">For Status:</h5><p name=\"status\"><p/>",
            "isHtml": true
          },
          {
            "key": "StatusCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "ForStatus_Title",
                "name": ""
              }
            ],
            "readOnly": true,
            "hierarchical": false,
            "disableAdd": true,
            "disableDelete": true,
            "header": false,
            "events": {},
            "collapseAll": false,
            "draggable": false,
            "style-hidden": true
          },
          {
            "key": "SampleCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Id",
                "name": ""
              }
            ],
            "readOnly": true,
            "hierarchical": false,
            "disableAdd": true,
            "disableDelete": true,
            "header": false,
            "events": {},
            "collapseAll": false,
            "draggable": false,
            "style-hidden": true
          }
        ],
        "other-visibleConition": "data.StatusCollection.length !== 0"
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%",
    "events": {},
    "other-required": false
  },
  {
    "key": "container_5",
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
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ],
                "style-marginBottom": "20px",
                "style-float": "left"
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_4",
                    "data-buildertype": "staticcontent",
                    "content": "<i>(Changes to the email message text and schedule will also be applied to Mail Merge generation)</i>",
                    "isHtml": true
                  }
                ],
                "other-visibleConition": "(data.NotifyMerge!=null&&data.NotifyMerge==1)",
                "style-source": "clear: both;\nborder: 1px solid red;\npadding: 25px;",
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
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "20px",
                    "clearable": true,
                    "placeholder": "Select Status",
                    "multiple": true,
                    "other-visibleConition": "data.StatusCollection.length > 0",
                    "other-required": false
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
                    "style-marginBottom": "20px",
                    "events": {},
                    "other-required": false
                  },
                  {
                    "key": "emailSubj",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-visibleConition": "",
                    "style-marginBottom": "20px",
                    "other-required": false
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
                    "style-marginBottom": "20px",
                    "other-required": true
                  },
                  {
                    "key": "formgroup_1",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "children": [
                      {
                        "key": "UseRawHtml",
                        "data-buildertype": "checkbox",
                        "label": "Use Raw HTML Template",
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px",
                        "events": {},
                        "toggle": true
                      },
                      {
                        "key": "htmlRaw",
                        "data-buildertype": "textarea",
                        "label": "",
                        "fluid": true,
                        "rows": "12",
                        "events": {},
                        "style-width": "100%",
                        "other-visibleConition": "data.UseRawHtml"
                      }
                    ],
                    "orientation": "grouped"
                  },
                  {
                    "key": "msgContentEditor",
                    "data-buildertype": "swzhtml",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "!data.UseRawHtml",
                    "other-customValidation": "",
                    "defaultValue": "",
                    "hideOutput": "block",
                    "other-required": true
                  }
                ],
                "style-source": "",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_15",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "button_SubmitMessage",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "updateProfileMailMerge"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btnCancel_1",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeModal"
                        ],
                        "targets": [
                          "swzmodal_2"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": false
                  }
                ],
                "style-marginTop": "20px"
              }
            ],
            "style-customcss": "ui message"
          }
        ],
        "content": "Edit",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "onEditClick"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "style-source": "",
        "size": "",
        "primary": true,
        "other-visibleConition": "!data.JobIsCanceled && data.MsgContentJson != null && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      }
    ],
    "style-float": "left"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cancelJob",
        "data-buildertype": "button",
        "content": "Cancel This Job",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "cancelJob"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "!data.JobIsCanceled && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Exit",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "goBack"
            ],
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px",
    "style-float": ""
  },
  {
    "key": "input_1",
    "data-buildertype": "input",
    "label": "",
    "fluid": true,
    "onChangeTimeout": 200,
    "placeholder": "Filter by UID",
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
            "value": "UID"
          }
        ]
      }
    },
    "style-marginBottom": "20px",
    "style-width": "300px"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "UID ASC",
    "pagerType": "server"
  }
]' WHERE [Id]='057eacaf-f332-4646-aa05-4e3d5656246a';

UPDATE [dwMetadata] SET
[Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:48.240', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-17 18:47:17.630', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMessage",
  "lastUpdate": "2022-10-17T18:47:17.629405+08:00",
  "entityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c9370afc-65af-ce1d-128b-ff72c191483e",
      "attributeId": "98ea38c9-6a0b-43c9-81e7-33c0fdf81664",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "745eb442-a214-4015-763d-c755eec82f9d",
      "attributeId": "53013ae2-ac53-49d9-8256-29517c8ce92d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2e313eff-505e-20bd-1d77-b769e682a84b",
      "attributeId": "05249853-6194-4045-b78a-b300b1261dbd",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "22c2ff97-d372-1635-b14c-5b85336111aa",
      "attributeId": "3827faa7-8f56-4657-b62f-3f0e2b741601",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "58d6ca3f-5562-1a2f-c667-264b808bc8e8",
      "attributeId": "59c5738d-c75c-48f3-a13d-89551dc8f265",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe10991b-03f6-819b-ea3d-d7c0d22e5a43",
      "attributeId": "617e73c0-cbc5-427c-8b5c-9b3eb9724eef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "93b2e866-3493-3a03-f1fc-3acd60609772",
      "attributeId": "b048ef0b-e83c-441b-8a37-bb9c186da00e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a486fa98-68dc-c3fc-3e8d-663cc132d38f",
      "attributeId": "e2f43f33-e402-4bf0-8240-406f330128ef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d4e4f928-bbf0-3903-7f5b-e31155052692",
      "attributeId": "980ba3ed-445e-4048-84e4-aa8a5a894d03",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "742c9f5f-2e42-54f7-4d33-04341f347da7",
      "attributeId": "723a024e-c6b7-4a6d-8840-700288df74fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6931df1a-f300-025f-3f2d-1bacd4666f5f",
      "attributeId": "5aa6f5c9-ff71-45dc-aac4-069c32bd2e46",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d705f381-e567-d49c-7c16-5c6f4ffdd799",
      "attributeId": "91b7860e-858d-4fb2-8c34-e08911284e78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e29ebf-55bc-6cfe-af47-e9318c8cce94",
      "attributeId": "d8a72553-1d8e-4c67-8429-9055cb5c6679",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8d5ceaa9-dbf6-ce90-c5c6-364eee828eeb",
      "attributeId": "c43a9452-c591-440c-a1d4-e35201bfdd51",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d845079c-af30-193c-ffc1-a242f62aaa5b",
      "attributeId": "2081e372-56bf-4d2f-bf8f-0e41e9989215",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29783cdc-9668-53ac-4146-e3eadead99c0",
      "attributeId": "e5b3a81b-2dd8-4237-9792-99dde3d846fb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "58ef1b63-8f95-4994-1e53-83b7eb89b4fe",
      "attributeId": "59aa8497-8343-4a3e-9e58-08d0474ea25d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7484baa3-a364-76d7-63e3-8a9daa3f5e23",
      "attributeId": "0d5d3634-db52-47d2-b648-06aff68ef376",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe701f01-ff07-824a-9ab2-b21a4667e146",
      "attributeId": "bc72319c-27cd-4331-8aa4-d4d7440d4558",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b1ea41a7-4d9e-42af-8798-5df1a1742e55",
      "attributeId": "248da247-714b-4c8e-aabe-ae51b1a298d7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9b3fc79-8855-cfd1-ef83-b5d7665c6baf",
      "attributeId": "3e45f699-36e4-4ec2-b6d4-d79f08aa90d1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f92263b7-3937-a7f0-09cf-742e1f32328a",
      "attributeId": "bb235505-d84c-41c6-ae87-06603fabb6b0",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d66da26d-3666-017f-8186-c6b6d814ca15",
      "attributeId": "29bfaf0b-7047-4e34-b148-fa040deaf052",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2085efba-b81b-b6e2-6ff6-e691b7832e3f",
      "attributeId": "0a6ac3a9-3884-4171-a423-0b7f032ebbef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b7078366-a6b7-4618-bc98-8ce0387c03af",
      "attributeId": "cd7763ec-414c-4abd-a1d2-0046377e916e",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "14f54703-0bbb-b496-3fc3-fa6cdfa6b86f",
      "attributeId": "be830ce8-ca8b-41a5-993c-bcedbbe889a9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a13627f0-a868-26de-de41-23191869a002",
      "attributeId": "687ad667-bbbf-4584-9a38-0b48d0b4b92a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff060bce-473f-cb62-a009-4bc9b8112cbe",
      "attributeId": "b8365e45-58cf-4618-91a0-4bc1f9c97870",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0da158e6-e2dc-f265-de4c-06c107ec644d",
      "attributeId": "98282783-cd5c-4945-af3b-262377a1caeb",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "fbeaf2c0-69a1-6298-cb5e-abb7430a963b",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "ca44aea3-ad0c-52f8-7fe4-37e8588c2c77",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f536ba98-4c6f-8504-54dc-02fe35365124",
          "attributeId": "4cdbf6f2-c84a-4a11-82ce-7173d40eecd1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f7cc16b-bc81-3825-9a23-9a2a714d8d02",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62e684e4-e47c-0c38-f461-c687f995c9e4",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f984f169-9167-bd8d-5476-0a0021cb01a6",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6f28fa9-1c85-a87a-7a71-5dfab0fcbc71",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5203a0ea-f30f-4ad7-7d9e-15d441e63e6a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    },
    {
      "id": "e22fb78e-4e0a-2bf8-2c31-9f742d39ab47",
      "entityId": "953e74a5-a493-4d79-a4d9-0ad32b7e1896",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "c9faad19-728c-f67d-708c-352975f48c51",
          "attributeId": "f31f1bc0-3a16-4699-84d4-b12a3ce6c66f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e6e385c-b484-5fc5-5668-add48805a469",
          "attributeId": "41ecf684-71cd-4d13-9535-1941227f974d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3be75909-d67f-c307-7bcd-e077038b6bd6",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "8e6e385c-b484-5fc5-5668-add48805a469",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "ceafde69-7498-063a-812b-c12bb8b77486",
          "attributeId": "293a7a59-6c38-4db2-b230-2c206e777614",
          "isEditable": true,
          "isLoadable": false
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__StatusCollection_totalcount"
    },
    {
      "id": "c5794574-42a8-e0a7-7367-0b179084d7f9",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "SampleCollection",
      "dataMap": [
        {
          "id": "ddf9c8a0-b505-92ec-0c2d-efd55ce3e561",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "83753949-9ad2-caa5-8e25-273013642da6",
          "attributeId": "4cdbf6f2-c84a-4a11-82ce-7173d40eecd1",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b657c9f3-8076-bcb4-a501-0cac9db7cb14",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a0df557-fb7f-a905-e0d5-65f9c7e62ae6",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4bfd4143-4ef1-1b4a-b877-8056a8e90ab7",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0936701e-4d83-bd91-ecf6-3212a4ddc11d",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "388a4722-ab91-3be5-5b24-3b9df981ae2a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__SampleCollection_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0';

UPDATE [dwMetadata] SET
[Id]='87ead053-54cb-4735-8cbc-e812f3344ab3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 12:29:26.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-18 11:51:29.917', 
[Data]=N'{
    init: function(args){
        console.log(args);
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'');
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    $("p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
    },
    
    cancelJob: function(args){
        Utils.loadingStart();
        const formData = new FormData();
        formData.append(''dplyMsgId'', args.data.Id);
        Utils.postFormRequest("/deployment/canceljob",formData).then(
            response => {
                alertify.success(response.message);
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                console.log("Cancel jib failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
       return{};
    },
    
    //renamed from editEmailToStatus
    updateProfileMailMerge: function(args){
        const dplyMsgId = args.data.Id;
        const dplyId = args.data.DplyId;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        
        //lowercase msg would be used after onHtmlChange was invoked
        const msgContentJson = args.data.UseRawHtml 
            ? "" 
            : (args.data.msgContentJson) ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const listSampleIds = args.data.targetSamples ? args.data.targetSamples : "";
        
        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!args.data.UseRawHtml) {
            if(msgContentJson==undefined || msgContentJson==null){
                alertify.error("Email content is required");
                validated = false;
            }
        }

        if(status.length==0 && listSampleIds.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        
        let url = "";
        if(status.length !== 0 && listSampleIds.length ==0){
            url = "/deployment/profileMailMergeToStatus";
            formData.append(''status'', status);
        } 
        if(listSampleIds.length !== 0 && status.length ==0){
            url = "/deployment/profileMailMergeToSamples";
            formData.append(''listSampleIds'',listSampleIds);
            formData.append(''mailMerge'', args.data.NotifyMerge);
            formData.append(''email'', args.data.NotifyEmail);
            formData.append(''profile'', args.data.NotifyGenerate);
        }

        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''dplyMsgId'', dplyMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);  
        
        if(validated){
            Utils.loadingStart();
            Utils.postFormRequest(url,formData).then(
                response => {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/dplyMessage/" + encodeURIComponent(dplyMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
                    alertify.success(response.message);
                }, reason => {
                    console.error(reason);
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        }

        return {};
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        var samplelist = [];
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
            CloverApp.API.setDataField("dictionaryStatus",statuslist);
        }
        if(args.data.SampleCollection.length > 0){
            args.data.SampleCollection.forEach(
                (entry) => {
                    samplelist.push(entry.ListSampleId);
                });
            CloverApp.API.setDataField("targetSamples",samplelist);
        }

        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        if(args.data.MsgContentJson && args.data.MsgContentJson && args.data.MsgContentJson != '''') {
            CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
            CloverApp.API.setDataField("UseRawHtml",false);
            Utils.queueHideControl("msgContentEditor","show");
            Utils.queueHideControl("htmlRaw","hide");
        } else {
            CloverApp.API.setDataField("msgContentEditor","");
            CloverApp.API.setDataField("UseRawHtml",true);
            CloverApp.API.setDataField("htmlRaw",args.data.MsgContent);
            Utils.queueHideControl("msgContentEditor","hide");
            Utils.queueHideControl("htmlRaw","show");
        }
        return { app:{} }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
}' WHERE [Id]='87ead053-54cb-4735-8cbc-e812f3344ab3';

UPDATE [dwMetadata] SET
[Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.593', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-18 12:31:21.750', 
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
                        },
                        "style-width": "100%",
                        "style-source": "padding-top: 20px;"
                      }
                    ],
                    "style-marginBottom": "20px",
                    "style-float": "left"
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
                        "placeholder": "Select Status",
                        "multiple": true,
                        "other-visibleConition": ""
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
                        "style-marginBottom": "20px",
                        "events": {}
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
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "formgroup_2",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "children": [
                      {
                        "key": "UseRawHtml",
                        "data-buildertype": "checkbox",
                        "label": "Use Raw HTML Template",
                        "toggle": true,
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px"
                      },
                      {
                        "key": "htmlRaw",
                        "data-buildertype": "textarea",
                        "label": "",
                        "fluid": true,
                        "rows": "12",
                        "style-width": "100%",
                        "other-visibleConition": "data.UseRawHtml"
                      }
                    ],
                    "orientation": "grouped"
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
                    "other-visibleConition": "!data.UseRawHtml"
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_ProfileMailMergeToStatus_Scheduled",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "profileMailMergeToStatus"
                            ],
                            "targets": [
                              "grid"
                            ],
                            "parameters": []
                          }
                        },
                        "primary": true
                      },
                      {
                        "key": "btnCancel_1",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "secondary": true,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeModal"
                            ],
                            "targets": [
                              "swzmodal_2"
                            ],
                            "parameters": []
                          }
                        },
                        "primary": false
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
        "style-marginTop": "20px",
        "style-marginRight": ""
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "swzmodal_1",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "msgMailMerge",
                        "data-buildertype": "checkbox",
                        "label": "Mail Merge",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "msgEmail",
                        "data-buildertype": "checkbox",
                        "label": "Email",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "msgProfile",
                        "data-buildertype": "checkbox",
                        "label": "Generate Profile",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "breadcrumb_2",
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
                        },
                        "style-width": "100%",
                        "style-source": "padding-top: 20px;"
                      }
                    ],
                    "style-marginBottom": "20px",
                    "style-float": "left"
                  },
                  {
                    "key": "container_8",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "msgStatus",
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
                        "placeholder": "Select Status",
                        "multiple": true,
                        "other-visibleConition": "data.msgMailMerge||data.msgEmail||data.msgProfile"
                      }
                    ]
                  },
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "style-customcss": "",
                    "children": [
                      {
                        "key": "msgEmailFrom",
                        "data-buildertype": "input",
                        "label": "From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "style-marginBottom": "20px",
                        "events": {},
                        "other-visibleConition": "data.msgEmail"
                      },
                      {
                        "key": "msgSubject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "style-marginBottom": "20px",
                        "other-visibleConition": "data.msgEmail"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "formgroup_1",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "orientation": "grouped",
                    "children": [
                      {
                        "key": "msgUseRawHtml",
                        "data-buildertype": "checkbox",
                        "label": "Use Raw HTML Template",
                        "toggle": true,
                        "other-visibleConition": "data.msgMailMerge||data.msgEmail",
                        "style-marginTop": "10px",
                        "style-marginBottom": "10px"
                      },
                      {
                        "key": "msgHtmlRaw",
                        "data-buildertype": "textarea",
                        "label": "",
                        "fluid": true,
                        "rows": "12",
                        "style-width": "100%",
                        "other-visibleConition": "(data.msgUseRawHtml && (data.msgMailMerge||data.msgEmail))"
                      }
                    ]
                  },
                  {
                    "key": "msgContent",
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
                    "other-visibleConition": "(!data.msgUseRawHtml && (data.msgMailMerge||data.msgEmail))"
                  },
                  {
                    "key": "container_16",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_ProfileMailMergeToStatus_Immediate",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "profileMailMergeToStatusImmediate"
                            ],
                            "targets": [
                              "grid"
                            ],
                            "parameters": []
                          }
                        },
                        "primary": true
                      },
                      {
                        "key": "btnCancel_2",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "secondary": true,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeModal"
                            ],
                            "targets": [
                              "swzmodal_1"
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
            "content": "Create Message For Status",
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
      },
      {
        "key": "container_17",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnRefresh",
            "data-buildertype": "button",
            "content": "Refresh",
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
            "secondary": true
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
            "resizable": true
          },
          {
            "name": "Mail Merge?",
            "key": "NotifyMerge",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "NotifyEmail",
            "name": "Email?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "NotifyGenerate",
            "name": "Generate Profile?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SampleCount",
            "name": "Samples",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime"
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "ScheduledDate",
            "name": "Scheduled For",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
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
        "key": "btn_ManageListSamples",
        "data-buildertype": "button",
        "content": "Manage List Samples",
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
                "value": "dplyListSample"
              }
            ]
          }
        }
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
    ],
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a';

UPDATE [dwMetadata] SET
[Id]='4a9265ad-e634-425d-964c-6ba7325313c8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.550', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-18 12:31:21.803', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyMessages",
  "lastUpdate": "2022-10-18T12:31:21.8040571+08:00",
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
    },
    {
      "id": "fe53995a-9a5d-c653-91ae-88cecd0891a3",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bf9371ee-0b24-8dbd-16f1-882d609037a9",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f0e74be8-84f5-03d6-9c40-55aaa728a8ae",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5cc0405-146e-4045-9677-2c7e80413018",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d94c4bd0-1bda-b112-a603-b715002d7fb0",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c087eea7-56b5-d6b4-c47b-3b55bd050008",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48f9defe-6f27-6ec1-f5f4-cb4b70313d9d",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b5e4a23d-61d1-e8cf-19c9-76e79376d7cd",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb4ebf5d-26bc-66e5-b7f6-ceae6874a9a2",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf904ce9-4510-112f-41fc-f6b25a0ac5c1",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9e5d2752-b33f-4738-56a1-fd0c753bacf9",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05d30da8-b070-962b-02d8-9e12b8626203",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7994af87-3fbe-cdd2-f61f-f9b960b6b08d",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a6c4fba3-a180-4a34-9f51-804c4481ff40",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "129f6d05-4d05-168c-ef1b-25bf47166088",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5436e34f-2a03-0cbf-4150-4dd479f142c6",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d192629-7319-8c4c-c28d-e24010aff510",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ddd4a7bd-1f01-8dbc-d6f0-194e2fee3a96",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e87f1b8-350a-e164-4be7-a5b5929e3aae",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77bf0020-8d39-b02d-7081-57b0f0c0efd9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "431f4999-2e39-1693-9125-dd212f2d610f",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "87b9d548-6502-1194-0102-eb5e70d0e7de",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e852ef59-2edb-6fb3-e90f-2a60e6bd64f7",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
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
        },
        {
          "id": "48d58510-dc34-3508-71b5-b703536a13fe",
          "attributeId": "ef45d376-b59e-464c-b997-c482a6edb593",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8077076c-19a6-be9b-bf57-e85cc79769a0",
          "attributeId": "bdd83ae4-2227-4f66-a1ed-4468407223ce",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b898fcfe-616f-ed9c-caeb-d17918c3c2cf",
          "attributeId": "11c9a997-e065-49b0-8b0b-3db8a55e36a5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8b33c0d-aaa7-bcb9-95c8-076ef6eca977",
          "attributeId": "0a863bd9-dd72-4a35-94aa-0aa81d0a3f32",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='4a9265ad-e634-425d-964c-6ba7325313c8';

UPDATE [dwMetadata] SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-18 12:32:45.200', 
[Data]=N'{
    init: function(args) {        
        const innerArgs = args;
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
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
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                };              
            }
            return model;
        }; //end of gridModelRewriter
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    //renamed from emailToStatus
    profileMailMergeToStatus: function(args){

        const dplyId = args.data.Id;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent =  args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = args.data.UseRawHtml
            ? ""
            : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatus",formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success(response.message);
                args.controlRef.refresh();
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    //renamed from msgToStatus
    profileMailMergeToStatusImmediate: function(args){

        const dplyId = args.data.Id;
        const mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        const email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        const profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        const emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        const subject = args.data.msgSubject;
        const status = args.data.msgStatus ? args.data.msgStatus : "";
        
        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            if(args.data.msgUseRawHtml) {
                msgContent = args.data.msgHtmlRaw;
                msgContentJson = "";
            } else {
                msgContent = args.component.refs.msgContent.state.htmlData;
                msgContentJson = args.component.refs.msgContent.state.jsonData;
            }
            
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if((email || mailMerge || profile) && (status==undefined || status==null || status.length==0)){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }
        
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''email'', email);    
        formData.append(''profile'', profile);       
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''status'', status);          
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatusImmediate", formData).then(
            response => {
                args.component.refs.swzmodal_1.close();
                alertify.success(response.message);
                args.controlRef.refresh();
                CloverApp.API.setDataField("msgHtmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    }

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

