-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyListSample.json
-- dplyListSample-settings.json
-- dplyListSample-code.js

UPDATE [dwMetadata] SET
[Id]='4ccdc858-527d-4321-8bee-942751feb26e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-26 20:04:58.970', 
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
                "inverted": true,
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
[Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-26 20:04:59.037', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyListSample",
  "lastUpdate": "2021-08-26T20:04:59.0369394+08:00",
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
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='c1c3d084-f194-4719-b7ae-0b62f14f67e8';

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-26 20:24:05.763', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
        text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
        text += ''Purpose of the Survey:\n''
        text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
        text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
        text +=''Submission of the Questionnaire:\n''
        text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
        text +='' \n''
        text +=''The following are your login information:\n''
        text +=''Company name: {Name}\n''
        text +=''Username: {UID}\n''
        text +=''Password: {Password}\n''
        text +='' \n''
        
        text +=''Other tokens:\n''
        text +=''UID: {UID}\n''
        text +=''Password: {Password}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
    },
    
    addNewSample: function(args){
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
        
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        loadingStart("Updating deployment samples from list");
        postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
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
        }
        
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        loadingStart("Updating Due Dates");
        postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success(result.message);
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
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
    
    sendMessage: function(args){
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
        
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
        }
        const subject = args.data.subject;
        
        if(email && (emailFrom==undefined || emailFrom==null || emailFrom.length==0)){
            alertify.error("Email address from is required");
            validated = false;
        } else if(email && !emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );
        // for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
        //     var gridIndex = args.controlRef.state.selectedIndexes[i];
        //     var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
        //     listSampleIds.push(listSampleId);
        // }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        loadingStart();
        postFormRequest("/deployment/resend", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success(result.message);
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
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
        loadingStart();
        postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error(reason);
            }
        ).then(loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
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

        // let sampleIds = [];
        // for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
        //     const gridIndex = args.controlRef.state.selectedIndexes[i];
        //     const sampleId = args.controlRef.state.items[gridIndex].SampleId;
        //     const sampleInfoId = args.controlRef.state.items[gridIndex].Id;
            
        //     const temp = {};
        //     temp.sampleId = sampleId;
        //     temp.sampleInfoId = sampleInfoId;
        //     sampleIds.push(temp);
        // }
        
        //console.log("sampleIds", sampleIds);
        
        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        var url = ''/deployment/resetrespdelegationcode'';
        
        loadingStart();
        postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

