-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST.json
-- QNN_LIST-settings.json
-- QNN_LIST-code.js

UPDATE [dwMetadata] SET
[Id]='715ce353-26d4-4c0f-8b65-57db2da22232', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-09-13 20:25:05.723', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "bcList",
        "data-buildertype": "breadcrumb",
        "items": [
          {
            "divider": "right angle",
            "text": "List",
            "url": "/form/SwzListList"
          },
          {
            "text": "Manage List",
            "active": true
          }
        ],
        "events": {
          "onItemClick": {
            "active": true,
            "actions": [
              "redirect"
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "headerPage",
        "data-buildertype": "container",
        "style-float": "left",
        "style-marginTop": "",
        "style-marginBottom": "",
        "style-marginLeft": "",
        "children": [
          {
            "key": "form_5",
            "data-buildertype": "form",
            "children": [
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "headerName",
                    "data-buildertype": "header",
                    "content": "Manage {nameInput}",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  },
                  {
                    "key": "header_1",
                    "data-buildertype": "header",
                    "content": "",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  }
                ]
              }
            ],
            "style-marginLeft": "7px",
            "style-customcss": ""
          }
        ],
        "style-source": "",
        "style-marginRight": "20px"
      }
    ],
    "style-source": "",
    "style-marginTop": "10px",
    "style-marginBottom": "",
    "style-marginLeft": "",
    "style-float": "left",
    "style-width": "",
    "style-customcss": ""
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-source": "",
    "style-height": "",
    "children": []
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
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "style-float": "left",
                "style-width": "100%",
                "children": [
                  {
                    "key": "form_3",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "headerProperties",
                        "data-buildertype": "header",
                        "content": "Properties",
                        "size": "medium"
                      },
                      {
                        "key": "formgroup_5",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "nameInput",
                            "data-buildertype": "input",
                            "label": "List Name",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "text",
                            "readOnly": false,
                            "events": {},
                            "labelPosition": "",
                            "style-width": "",
                            "other-required": true,
                            "reference": "List Name"
                          }
                        ]
                      },
                      {
                        "key": "formgroup_7",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "headerDescription",
                            "data-buildertype": "textarea",
                            "label": "List Description",
                            "fluid": true,
                            "other-required": false,
                            "events": {}
                          }
                        ]
                      },
                      {
                        "key": "staticcontent_3",
                        "data-buildertype": "staticcontent",
                        "content": "Tags",
                        "isHtml": true,
                        "style-marginBottom": "4px",
                        "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                      },
                      {
                        "key": "divActiveTags",
                        "data-buildertype": "container",
                        "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;",
                        "events": {},
                        "children": [
                          {
                            "key": "mdlTag",
                            "data-buildertype": "swzmodal",
                            "content": "Add/Remove Tags",
                            "compact": true,
                            "secondary": true,
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
                            "children": [
                              {
                                "key": "header_4",
                                "data-buildertype": "header",
                                "content": "Add/Remove Tags",
                                "size": "medium"
                              },
                              {
                                "key": "message_1",
                                "data-buildertype": "message",
                                "header": "",
                                "content": "Add a custom tag by typing in the Tags",
                                "info": true
                              },
                              {
                                "key": "staticcontent_5",
                                "data-buildertype": "staticcontent",
                                "content": "Tags",
                                "isHtml": true,
                                "style-marginBottom": "4px",
                                "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                              },
                              {
                                "key": "ddTags",
                                "data-buildertype": "dropdown",
                                "label": "",
                                "fluid": true,
                                "selection": true,
                                "data-elements": [],
                                "placeholder": "Type and add tag here",
                                "search": true,
                                "multiple": true,
                                "allowAddItems": true,
                                "style-marginBottom": "20px",
                                "events": {}
                              },
                              {
                                "key": "divTagsSearchResult",
                                "data-buildertype": "container",
                                "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                                "style-marginBottom": "10px",
                                "events": {},
                                "children": [
                                  {
                                    "key": "formgroup_10",
                                    "data-buildertype": "formgroup",
                                    "widths": "equal",
                                    "orientation": "grouped",
                                    "children": [
                                      {
                                        "key": "staticcontent_6",
                                        "data-buildertype": "staticcontent",
                                        "content": "Search For Tags",
                                        "isHtml": true,
                                        "style-marginBottom": "4px",
                                        "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                                      },
                                      {
                                        "key": "TagsSearch",
                                        "data-buildertype": "input",
                                        "label": "",
                                        "fluid": false,
                                        "onChangeTimeout": 200,
                                        "placeholder": "Search Tags...",
                                        "events": {
                                          "onChange": {
                                            "active": true,
                                            "actions": [
                                              "searchTagsInDB"
                                            ],
                                            "targets": [],
                                            "parameters": []
                                          }
                                        }
                                      }
                                    ]
                                  },
                                  {
                                    "key": "staticcontent_7",
                                    "data-buildertype": "staticcontent",
                                    "content": "<hr>",
                                    "isHtml": true,
                                    "style-marginBottom": "10px",
                                    "style-source": "",
                                    "style-marginTop": "10px"
                                  }
                                ]
                              },
                              {
                                "key": "container_24",
                                "data-buildertype": "container",
                                "style-float": "left",
                                "style-marginTop": "30px",
                                "style-marginBottom": "20px",
                                "children": [
                                  {
                                    "key": "btnTagsSave",
                                    "data-buildertype": "button",
                                    "content": "Save",
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
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeTagsModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "secondary": true
                                  }
                                ]
                              }
                            ],
                            "size": "tiny",
                            "style-display": "none",
                            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                          },
                          {
                            "key": "staticcontent_4",
                            "data-buildertype": "staticcontent",
                            "content": "<hr>",
                            "isHtml": true,
                            "style-marginBottom": "10px",
                            "style-source": "",
                            "style-marginTop": "10px"
                          }
                        ],
                        "style-marginTop": "",
                        "style-marginBottom": "15px"
                      },
                      {
                        "key": "formgroup_4",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "TrkListIds",
                            "data-buildertype": "dictionary",
                            "label": "Track List",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_TRK_LIST",
                            "columns": "Name ASC",
                            "events": {},
                            "multiple": true,
                            "clearable": true,
                            "style-hidden": false
                          }
                        ],
                        "style-marginTop": "15px"
                      },
                      {
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "toggleStatus",
                            "data-buildertype": "checkbox",
                            "label": "Status",
                            "toggle": true,
                            "events": {},
                            "style-width": "300px"
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-customcss": ""
              }
            ],
            "style-width": "100%",
            "style-float": "left"
          },
          {
            "key": "container_13",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_2",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "",
                    "style-width": "100%",
                    "children": [
                      {
                        "key": "form_4",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "headerUser",
                            "data-buildertype": "header",
                            "content": "Records User Control",
                            "size": "medium"
                          },
                          {
                            "key": "formgroup_8",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditName",
                                "data-buildertype": "checkbox",
                                "label": "Edit Name",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_3",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditEmail",
                                "data-buildertype": "checkbox",
                                "label": "Edit Email",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_9",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "togglePassword",
                                "data-buildertype": "checkbox",
                                "label": "Edit Password",
                                "toggle": true
                              }
                            ]
                          }
                        ],
                        "style-source": "float:left"
                      }
                    ],
                    "other-visibleConition": "",
                    "style-hidden": true
                  },
                  {
                    "key": "container_11",
                    "data-buildertype": "container",
                    "children": [],
                    "style-float": "",
                    "style-source": "clear:both",
                    "style-customcss": "",
                    "style-width": ""
                  }
                ],
                "style-source": "",
                "style-width": "100%",
                "style-marginTop": "10px"
              }
            ],
            "style-width": "100%"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "List Sample Properties",
            "size": "medium"
          },
          {
            "key": "collectioneditor_1",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Alias",
                "name": "Alias",
                "width": "",
                "control": "input"
              },
              {
                "key": "ReqdYN",
                "name": "Reqd",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "UsrEditYN",
                "name": "UsrEdit",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "TxtRow",
                "name": "TxtRow",
                "control": "number",
                "width": "10%"
              },
              {
                "key": "TxtRegExp",
                "name": "TxtRegExp",
                "width": "25%",
                "control": "input"
              },
              {
                "key": "TxtRegExpErr",
                "name": "TxtRegExpErr",
                "width": "20%",
                "control": "input"
              }
            ],
            "header": false,
            "headerTitle": "List Sample Properties",
            "hierarchical": false,
            "placeholders": {
              "Type": [
                {
                  "key": "Type",
                  "data-buildertype": "input",
                  "label": "",
                  "fluid": true,
                  "onChangeTimeout": 200,
                  "readOnly": true,
                  "defaultValue": "1",
                  "style-hidden": false
                }
              ]
            },
            "events": {},
            "style-width": "100%",
            "style-customcss": "hmr-block",
            "style-marginBottom": "20px"
          }
        ],
        "style-customcss": "",
        "style-width": "100%",
        "style-source": "padding: 10px;\nborder: 1px solid rgba(34,36,38,.15);",
        "style-hidden": false,
        "other-visibleConition": "",
        "style-float": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnSave",
            "data-buildertype": "button",
            "content": "Save",
            "events": {
              "onClick": {
                "actions": [
                  "processTrkList",
                  "validate",
                  "save",
                  "goRecords"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzListList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          },
          {
            "key": "btnCancel",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "exit",
                  "redirect"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/swzlistlist"
                  }
                ]
              }
            },
            "secondary": true
          }
        ],
        "style-float": "right",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": ""
  },
  {
    "key": "cnt_visuallyDivideMasterAndDetail",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null"
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
                "size": "medium",
                "subheader": "Samples in this list"
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
                          "newListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDisable",
                    "data-buildertype": "button",
                    "content": "Disable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "toggleListSamplesActive"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "disableSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "disableSamplesConfirmText"
                          },
                          {
                            "name": "action",
                            "value": "disable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  },
                  {
                    "key": "btnEnable",
                    "data-buildertype": "button",
                    "content": "Enable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "toggleListSamplesActive"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "action",
                            "value": "enable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_22",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDeleteSample",
                    "data-buildertype": "button",
                    "content": "Delete Samples & Data",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "deleteListSample",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "deleteListSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteListSamplesConfirmText"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "formImportList",
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
                                "content": "Import Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "inputPassword",
                            "data-buildertype": "input",
                            "label": "Password",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "password"
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
                      },
                      {
                        "key": "sampleListImportHeader",
                        "data-buildertype": "header",
                        "content": "Sample List Import Complete",
                        "size": "large",
                        "events": {},
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-hidden": true,
                        "textAlign": "left"
                      },
                      {
                        "key": "importSummaryStatic",
                        "data-buildertype": "staticcontent",
                        "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Updated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleUpdated}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
                        "isHtml": true,
                        "style-font-size": "15px",
                        "style-hidden": true,
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "events": {}
                      },
                      {
                        "key": "containerInvalidDetails",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Invalid Rows Detail",
                            "size": "medium",
                            "other-visibleConition": ""
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
                                        "key": "invalidRowsDetail",
                                        "data-buildertype": "collectioneditor",
                                        "idField": "Id",
                                        "parentIdField": "ParentId",
                                        "columns": [
                                          {
                                            "key": "RowNo",
                                            "name": "Row No",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrField",
                                            "name": "Field",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrMsg",
                                            "name": "Error Message",
                                            "control": "span",
                                            "width": ""
                                          }
                                        ],
                                        "disableAdd": false,
                                        "disableDelete": false,
                                        "other-visibleConition": "",
                                        "header": false,
                                        "headerTitle": "Pre-Populate Fields",
                                        "events": {},
                                        "readOnly": true
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
                                ],
                                "events": {}
                              }
                            ]
                          }
                        ],
                        "style-source": "",
                        "style-customcss": "ui negative message",
                        "style-float": "",
                        "style-width": "",
                        "other-visibleConition": "(data.invalidRowsDetail!= undefined || data.invalidRowsDetail!= null)",
                        "events": {},
                        "style-hidden": true
                      },
                      {
                        "key": "btnImportClose",
                        "data-buildertype": "button",
                        "content": "Close",
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
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-source": "float: right;",
                        "style-hidden": true,
                        "style-marginBottom": "20px",
                        "secondary": true
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
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-marginRight": ""
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "btnExportSamples",
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
                "key": "container_25",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnRefresh",
                    "data-buildertype": "button",
                    "content": "Refresh",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "",
                    "secondary": true
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "inputSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "300px",
                "size": "",
                "labelPosition": "",
                "style-source": "float: left;",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridviewSample"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "Name, UID"
                      }
                    ]
                  }
                },
                "placeholder": "Search by Name or UID"
              }
            ],
            "style-width": "100%",
            "style-float": "",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      }
    ],
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "gridviewSample",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "ListSampleActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "ToEmails",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "CcEmails",
        "name": "CC Emails",
        "sortable": true,
        "filterable": false,
        "resizable": true
      }
    ],
    "autoHeight": false,
    "offSet": "",
    "multiselect": true,
    "rowKey": "Id",
    "defaultSort": "UID ASC",
    "events": {
      "onRowClick": {
        "active": false,
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
    "editForm": "QNN_LIST_SAMPLE",
    "style-hidden": false,
    "rowHeight": "80",
    "pageSize": "384",
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "container_20",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null",
    "style-marginTop": "20px"
  },
  {
    "key": "container_23",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Deployments using this Sample List",
        "size": "small",
        "textAlign": "left"
      },
      {
        "key": "gridDeployments",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "Name",
            "name": "Deployment",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SurveyName",
            "name": "Survey",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CategoryName",
            "name": "Category",
            "sortable": true,
            "filterable": false,
            "resizable": true
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
        "editForm": "QNN_DPLY",
        "rowKey": "Id",
        "pageSize": "50",
        "defaultSort": "Name ASC",
        "rowHeight": "80",
        "events": {
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
    "other-visibleConition": "(data.Id  && CloverApp.API.checkRole(''SurveyAdmin'') ) ? true : false"
  }
]' WHERE [Id]='715ce353-26d4-4c0f-8b65-57db2da22232';

UPDATE [dwMetadata] SET
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-09-13 20:25:05.747', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2023-09-13T20:25:05.7478121+08:00",
  "entityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "6bb9025a-7861-e177-eded-333d69e577d4",
      "attributeId": "17bf4b77-798d-4cba-83d4-16ea2a7696b7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79853784-fc1e-c680-ffe9-cb8aaeff5c39",
      "attributeId": "ebcf3683-c851-499c-a4b9-e2daec3948c2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e158c090-63ad-c843-de20-e2fd018a051e",
      "attributeId": "9eef3bf1-726a-4bcc-81db-eb27a0a16b04",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ea041ec-525a-89ac-0908-fab13baf146b",
      "attributeId": "76f762fb-7aa1-47fd-9ecf-b0c17bca4b43",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1ccd0d11-07a4-5fa0-41d7-b5979cbfdfd1",
      "attributeId": "852fb683-2f47-412a-9e40-11de48808b16",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e8b13f8-da52-e713-1b09-efb0d94a0148",
      "attributeId": "98399b10-9bc8-442e-88ce-2ff314a8c7ba",
      "control": "headerDescription",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ce4fa93-6667-133a-8f7a-7604cf99939b",
      "attributeId": "83bee845-79e5-4929-b4fb-fe5cff7748a8",
      "control": "toggleEditEmail",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab9545bf-afde-3b8a-be20-7fd4fb38ff33",
      "attributeId": "27f10ba1-fbdf-4878-958c-8400ea40490f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f07bb99-136e-4e3c-2401-c27a6d38e5c6",
      "attributeId": "a11f6ad2-bda5-4a4f-bafd-230fa27ccb36",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9cf7eb23-7a27-f882-e683-4d1cd4e17c97",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "control": "nameInput",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bd5ce67-64b2-f488-1327-13b0fa4725bb",
      "attributeId": "483d548e-4239-40a9-82cd-c47981e25945",
      "control": "toggleEditName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed6d936f-04af-04c3-2ff0-a1c23fa25c83",
      "attributeId": "0d50217d-3b94-4aa3-bccb-7dbdbb222749",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "292801af-0143-79be-0402-be3fc30eec41",
      "attributeId": "3f17e524-114a-4c9a-a71f-99154710f20e",
      "control": "togglePassword",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4af24cb-542d-3804-ef56-7cb98f1ba120",
      "attributeId": "6899bb22-b9f9-48da-adef-29209c0b0595",
      "control": "toggleStatus",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "456dd0ff-56dd-614a-89a5-4c6983bdf189",
      "attributeId": "064f6b2f-14dc-48dd-8e6d-b4e175be873f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6daa775d-0f9a-63a3-a83f-3ee20de05d28",
      "attributeId": "82b9d680-7b4e-4d25-8b72-555bbb17fe8a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f06fd16-7354-7c35-0406-313e3dca70d2",
      "attributeId": "bb19edbc-181e-4f9d-9e8b-3f64a38dd911",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ca7559f5-2bb1-9ca3-df65-72516fecebce",
      "attributeId": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5194d452-7552-b246-c734-b81f51c9921e",
      "attributeId": "eba31ce9-8aea-467e-a463-4ed7ba17131b",
      "control": "TrkListIds",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a6cf905-666e-ea96-3dc7-ea414625f144",
      "attributeId": "727c6358-fea5-49ed-9099-2762644973fe",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "6cf82f70-64e4-4494-b02b-82806ea7c26e",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "81789810-9928-2fd3-bad0-fa54dfae9227",
          "attributeId": "8cccf6c3-0226-48a3-a998-da0e36c4daf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19b7bc15-60ca-0552-7ffb-f99ca0f979a2",
          "attributeId": "8483bf15-ff56-49e2-96e1-c9bc94be1938",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc0643f8-c16f-9c44-5a89-1b03699e8d54",
          "attributeId": "04ae0ae7-aa15-4fe4-9a9e-3da6b1011130",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "055e840f-5d2c-de43-f5ee-1aec3231946d",
          "attributeId": "0303ebaa-f136-4957-853e-52fb9dce9865",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1ccc22e-44f4-079b-e05f-33112d8a94c8",
          "attributeId": "f9357a1b-c839-42c1-a624-ee242454fcfc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27629011-2b07-85fb-2ac7-ea8fed5b3de2",
          "attributeId": "361ff056-f5e5-42e3-af19-804c08085e6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9b8b9fe-9ec1-7f75-8458-6d0b876a606f",
          "attributeId": "cf043f7d-e0bf-4cdf-a5f2-22e2cb362f82",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5b6d9ce-d349-4130-006a-ae105bb6e21b",
          "attributeId": "32553188-2535-4522-95b8-957279ba3ed1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6886368-d110-d7d8-bd6d-eb63bc7fd5ce",
          "attributeId": "8325f35d-ec44-4846-b129-0011d8b15cc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41d8d692-cfc7-1490-f59c-8a7d6ad738d4",
          "attributeId": "b5602ad5-e7a9-4659-a2d8-ee1b7b7a2bbf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "595a1068-fbb6-bc68-f3ab-ec868b11793e",
          "attributeId": "75e179e7-7731-46f4-9e62-eb27d6fe95aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1e9b043-7a8f-67e2-e1e3-fa6bbd773f49",
          "attributeId": "f25864f8-5967-4508-8fa8-3fbdbdeeff9b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "623faa61-93d5-e2a0-82ed-a90b0877bcb5",
          "attributeId": "38bfcb12-f658-4ce2-ab33-99e5c236435a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84770df3-3b00-da09-a7ce-6e8b51c01fb6",
          "attributeId": "f9743ce4-bd21-4aec-ae86-0bb6d7440190",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
    },
    {
      "id": "dbf01fb4-db82-d562-bddb-a718f924ef35",
      "entityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "8442fb3b-134a-c355-7d90-f3e49c30af2c",
          "attributeId": "9c84a07d-bde2-414d-8628-9665e6df1c4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9990f3ba-6ea2-01f2-2522-5df2b216d08e",
          "attributeId": "304670fb-e871-443c-9c62-75b544da93a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e980519-bb41-ee3b-b0f9-724fad5fe32e",
          "attributeId": "495a9b97-319e-4139-aade-8103d4bc2e41",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0df8f806-b655-09c3-7a45-f6edf7604746",
          "attributeId": "27a0ea17-2da1-4ebb-ba54-0f783e3d2907",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b49e1ae4-2ad3-3cd2-4a86-66ce0cda30c2",
          "attributeId": "fc40cac5-1da7-46d7-90c3-f8e90cf935cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8657b639-deed-2116-f436-1982cee0669d",
          "attributeId": "cde17e04-b25f-476e-b722-97c11da29326",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5abd8c3-1e7f-166b-91d7-6725f32c6ded",
          "attributeId": "cbe9a1b9-bea3-49e1-9e1e-ac8391624939",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df2b19f4-19fa-9d44-b12e-1590811b0e55",
          "attributeId": "f5682ad5-b493-43a5-864e-3d554ac37ddf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "970989ac-c2e1-737a-1d0c-fd77022f0cfe",
          "attributeId": "70c763b0-6a8e-4a59-959e-fd6859fdfc17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb1ae13-7ce8-8524-217c-23de6712a577",
          "attributeId": "b2761fa3-a119-48a0-84e8-5112873d10d3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1e49ed9-982d-bfdc-cc71-a21fd33e3522",
          "attributeId": "6eaf8118-3a45-4e6d-88bd-f0fd37671cd3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b6adfdac-f4c3-b5bd-5158-25befb267921",
          "attributeId": "b430f4f3-2d95-4d88-a2c7-b8d12d33b144",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e128c585-70ab-a73c-ad73-1fd43d8f738e",
          "attributeId": "641d5acb-3586-4c86-a28b-22c339609610",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_1_totalcount"
    },
    {
      "id": "8161ebf5-8ee8-cfe0-f4e9-935018d59779",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridDeployments",
      "dataMap": [
        {
          "id": "7eb438a5-8378-c552-f483-616b4c93c22e",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "80ff6f67-e35c-616d-d105-fce77104b780",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f691ddf4-f53b-f6fc-c2b0-e71dea6f5a36",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b30ab47f-c182-941e-b0af-eced94413c75",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "874d2516-9167-54f8-0b10-ffb989851c2a",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b3c1aea5-7b04-5545-d228-0be1c415c664",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d171d52-707f-e394-f76e-9289a1ce2c6c",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "686f8437-cefd-20bd-c123-01990b71b0c7",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "df652069-f61c-6a16-4d7c-5117f50276df",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76751db7-b053-cda9-fe7c-caa2f473b806",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b58afbda-846a-45d2-9f41-fd8b781d4d2c",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "539bd40b-09f3-d46e-aee2-e1647d96c47a",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58c09ddf-88d3-41db-4c40-255b51d76bcd",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "324607f9-64a7-a4a2-867e-21a16bd48a30",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a61f3f0-17f8-5560-8aa1-226f00b0bfc0",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6ab9dd5a-70f4-b3d7-33fd-0d74b6fed431",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8ccce086-674d-d299-83aa-b9e0a31dca2c",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "07173d24-9a62-d3da-95a1-151bddcf650d",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "534bf5ba-27bf-ddd8-6bdd-5b3ec0a0c030",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17e8f3bf-d9b3-d76a-8bf9-8f5bccd5edb8",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98ba8faa-f5d7-5f66-fc28-123bfb82f447",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17eb14fc-b708-37ff-4d0c-4fbdb112a8a2",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e86db019-f90c-9e27-3b29-146c8e393b49",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3bb8be8f-61e1-840f-4e0c-6e2b0329c971",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "27a77db0-a3d0-ffb6-9258-c1c2074c9be7",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e80c78df-a127-2d8d-60bc-8fb646b952ac",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "38b7ccea-48b0-7c18-2c49-ff5a17580aa5",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e09c75b1-86fa-b386-86fb-4e14c7386e1c",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e63666a4-d893-e406-1ef0-b42decba3846",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f252bd0f-3337-42c8-0cef-a259957135c8",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d83b1629-fa64-5d96-a049-0ab2549d43aa",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62fdacb4-f875-b857-023c-3a8d48a39723",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "160429b3-b94d-3e59-7e4b-5dbb9468aabc",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2218a6b9-000b-acca-e751-274e2d688d8f",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3ca153e7-01d6-248c-3ba2-d7bec064177e",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b9ee09ac-8c87-2ed5-8c7b-e445fe3813e3",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "bd8ed4c3-1f81-67fc-1f70-9a6a83c517cc",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1c6a67fc-8d25-df17-58d8-4ab23ca9d466",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a1a16e9-7349-24b2-6932-7a3ae3378498",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1075e0b4-8efc-fbff-d5e1-044f438cd1e5",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "98228910-e68e-8b0c-ee11-809f3c8aa8d2",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e0201016-9f47-a707-765a-eae1b5e50471",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b46ac118-589a-de57-460a-e97b892b5d13",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a32c472-41aa-93d8-7209-750dd241db1a",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f2ac5885-3565-8174-86b2-e3b25ce3a03d",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f98e53fd-fbad-e205-9605-e1a1688df15a",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "961307f9-927e-47a6-c493-26e901f3b26a",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "eb6a51e2-c389-247f-61a5-9506bf94b2bd",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "417028e7-9314-bab9-d94a-2eeac101941b",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f0c8e82a-23c5-fa7f-3b46-f4ac728ab9e3",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e558c8e2-3ae0-2ee4-7716-874b83bb14a4",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "95689c4e-507b-d3ac-173f-a39fec264a6f",
          "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b137e4b-b2a1-ee47-2ae7-47b36e4c2dd9",
          "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1969361-f986-69b9-6382-3cb3bb2d4bb4",
          "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e565af0-2681-4106-90be-aa91f09842b9",
          "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "625db4ca-d2cb-e4ac-db61-0bf5e306b00a",
          "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b52aea0-1929-4c1d-57d3-ce5bffef8755",
          "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47a7f132-b61e-7b8d-fd39-0df8dbec78c7",
          "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridDeployments_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-09-13 20:48:33.760', 
[Data]=N'{   
    init: function(args){
        console.log("QNNLIST Args",args);
        
        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_listUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
    }, 
    
    processTrkList: function(args){
        var trkListIds = args.data.TrkListIds;
        if(trkListIds==null || trkListIds==undefined) return {};   
        try {
            var arr = JSON.parse(trkListIds);
            var sourceArray = args.component.refs.TrkListIds.state.options;
        
            let newArray = [];
            arr.map((currentValue, index, array) => {
                // return element to new Array
                if (sourceArray.filter(function(e) { return e.key === currentValue; }).length > 0) {
                      /* contains the element we''re looking for */
                      newArray.push(currentValue);
                }

            });
            CloverApp.API.setDataField("TrkListIds", JSON.stringify(newArray));
            
        } catch (e) {
            return {};
        }
        return {};   

    },
    
    deleteListSample: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const listId = args.data.Id;
        const listSampleIds = [];
        for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            const gridIndex = args.controlRef.state.selectedIndexes[i];
            const listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        const formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);      
        Utils.loadingStart();
        Utils.postFormRequest("/list/deletelistsample",formData).then(
            response => {
                alertify.success(response.message);
                args.controlRef.refresh();
            }, reason => {
                console.log("Error deleting list samples", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },   
    
    toggleListSamplesActive: function(args) {
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].Id);
        if(listSampleIds.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const grid = args.component.refs.gridviewSample;
        const action = args.parameters.action;
        let waitMessage;
        let url;
        if("enable"===action) {
            url = "/list/enablelistsamples";
            waitMessage = "Enabling selected samples...";
        } else if("disable"===action) {
            url = "/list/disablelistsamples";
            waitMessage = "Disabling selected samples...";
        } else {
            throw "INTERNAL ERROR (UI): Invalid action";
        }
        const listId = args.data.Id;
        const formData = new FormData();
        formData.append("listId", listId);
        formData.append("listSampleIds", listSampleIds);    
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify.success(response.message);
                grid.refresh()
            }, reason => {
                console.log("toggleListSamplesActive failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    
    exportSample: function (args){
        let defaultFormName = args.originalData.nameInput + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.QNN_LIST.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.QNN_LIST.provideName);
          }
        }
        var url = ''/list/exportsample?listId='' + args.data.Id + ''&fileName='' + encodeURIComponent(inputName);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please", 15000);
            return {};
        };

        if(password){
            var errors = {};
            var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
            var countChars = function(str, type) {
                var count=0,len=str.length;
                    for(var i=0;i<len;i++) {
                        if(type==0){
                            if(/[A-Z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==1){
                            if(/[a-z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==2){
                            if(/[0-9]/.test(str.charAt(i))) count++;                    
                        }                
                    }
                return count;
            };                
            if(!req.test(password)){
                errors.inputPassword = true;
                errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
            }
    
            if(countChars(password, 0)<3 || countChars(password, 1)<3 || countChars(password, 2)<3){
                errors.inputPassword = true;
                errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }
            
    
            if(errors.passwordComplex){
              throw {
                  level: 1,
                  message: errors.passwordComplex,
                  formerrors: {main: errors}
              };
            }
            if(errors.passwordStrength){
              throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
              };
            }    
        }

        const url = "/list/" + encodeURIComponent(args.data.Id) + "/import";
        const formData = new FormData();
        formData.append("token", token);
        if(password) {
            formData.append("password", password);
        }
        Utils.loadingStart();
        Utils.postFormRequest(url, formData).then(
            response => {
                CloverApp.API.setDataField("inputImportListSample", null);
                CloverApp.API.setDataField("inputPassword", null);
                alertify.success(response.message,10000);
                args.component.refs.modalImportSample.close();
                args.component.refs.gridviewSample.refresh();
                qnn_listUserActions.closeModal(args); 
            }, reason => {
                CloverApp.API.setDataField("inputImportListSample", null);
                alertify.error(reason, 15000);
            }
        ).finally( Utils.loadingStop );
    }, 

    //called by btnSave
    goRecords: function(args){
        var modelArray = args.state.app.form.models.model; 
        var recordsCont= args.state.app.form.models.model[4];
        var isHidden = false;
        
        var newModal= {''key'': recordsCont[''key''], ''data-buildertype'': recordsCont[''data-buildertype''], ''children'': recordsCont[''children''],
        ''style-customcss'': recordsCont[''style-customcss''], ''style-float'':recordsCont[''style-float''], ''style-width'': recordsCont[''style-width''],
        ''style-hidden'': isHidden,};
    
        modelArray.splice(4,1,newModal); //Replace item in whole model series
    
        return {
            app:{
                form:{
                    models:{
                        model: modelArray
                    }
                }
            }
        }
    },
    
    newListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id);
    },
    
    closeModal: function (args){
        CloverApp.API.setDataField("inputImportListSample", null);
        CloverApp.API.setDataField("inputPassword", null);
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: []
                  }
              }
            }
        }       
    },  

    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_listUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_listUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_listUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082';

