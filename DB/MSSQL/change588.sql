-- Will UPDATE existing row(s) in dwMetadata for the following:
-- swzListList.json
-- swzQnnList.json
-- swzDplyList.json

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-01 15:16:56.633', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "modalDiv",
        "data-buildertype": "container",
        "children": [
          {
            "key": "copyModal",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "inverted": true,
            "secondary": true,
            "children": [
              {
                "key": "formImportList",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopySampleList",
                    "data-buildertype": "header",
                    "content": "Copy Sample List",
                    "size": "medium",
                    "subheader": "New Sample List Name*"
                  },
                  {
                    "key": "copySampleListId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "newSampleListName",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200
                  },
                  {
                    "key": "container_4",
                    "data-buildertype": "container",
                    "style-marginBottom": "20px",
                    "style-width": "100%",
                    "children": [
                      {
                        "key": "container_8",
                        "data-buildertype": "container",
                        "style-float": "right",
                        "children": [
                          {
                            "key": "btnCopyList",
                            "data-buildertype": "button",
                            "content": "Copy",
                            "primary": true,
                            "style-marginRight": "20px",
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "copySampleList"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            }
                          },
                          {
                            "key": "btnCancelCopyList",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeCopyModal"
                                ],
                                "targets": [
                                  "copyModal"
                                ],
                                "parameters": []
                              }
                            }
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Sample Lists",
        "size": "large"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Export",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridExport"
            ],
            "targets": [
              "gridviewwithactions_1"
            ],
            "parameters": []
          }
        },
        "style-hidden": true,
        "secondary": true
      },
      {
        "key": "btnCreate",
        "data-buildertype": "button",
        "content": "Create",
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
              "gridCreate"
            ],
            "targets": [
              "grid"
            ],
            "parameters": []
          }
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
        "style-source": "",
        "floated": "left"
      },
      {
        "key": "container_11",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "deleteModal",
            "data-buildertype": "swzmodal",
            "secondary": true,
            "children": [
              {
                "key": "deleteHeader",
                "data-buildertype": "header",
                "content": "Delete Sample List & Associated Records",
                "size": "medium",
                "textAlign": "left",
                "subheader": ""
              },
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Import List",
                "size": "medium",
                "events": {},
                "other-visibleConition": ""
              },
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "",
                "content": "WARNING: Deleting a Sample List will also immediately delete all deployments that use it INCLUDING RESPONSE DATA"
              },
              {
                "key": "deleteGridView",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Sample List Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": true
                  }
                ],
                "events": {}
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "DeleteConfirm",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridDelete",
                          "closeDeleteModal"
                        ],
                        "targets": [
                          "grid"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "CancelDelete",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDeleteModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-float": "right",
                "style-source": "text-align: right;",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "style-display": "none",
            "content": "Delete",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "openDeleteModal"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "isOpen": "",
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ]
      },
      {
        "key": "div_float_modal",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float:left",
            "secondary": true,
            "content": "Import",
            "style-display": "none",
            "children": [
              {
                "key": "formImportList",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "importHeader",
                    "data-buildertype": "header",
                    "content": "Import Sample List",
                    "size": "medium",
                    "events": {},
                    "other-visibleConition": ""
                  },
                  {
                    "key": "listName",
                    "data-buildertype": "input",
                    "label": "New List Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "400px"
                  },
                  {
                    "key": "listPassword",
                    "data-buildertype": "input",
                    "label": "Password for new or password_reset samples (optional)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "200px",
                    "type": "text"
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
                    "key": "container_7",
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
                              "closeImportModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "(data.sampleAdded == null || data.sampleAdded == undefined)",
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
                              "importSampleList"
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
                ]
              }
            ],
            "size": "",
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ],
        "style-float": "left"
      }
    ],
    "style-float": "right",
    "style-marginRight": "20px",
    "style-marginBottom": "50px"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnRefresh",
        "data-buildertype": "button",
        "content": "Refresh",
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
              "gridRefresh"
            ],
            "targets": [
              "grid"
            ],
            "parameters": []
          }
        },
        "other-visibleConition": "",
        "style-source": "",
        "inverted": false,
        "secondary": true,
        "compact": false,
        "floated": "left",
        "style-marginLeft": "",
        "style-marginRight": "20px"
      },
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
              "grid"
            ],
            "parameters": [
              {
                "name": "column",
                "value": "Name,Tags,SampleCount,UpdatedDate"
              }
            ]
          }
        },
        "placeholder": "Search...",
        "style-width": "300px"
      }
    ],
    "style-float": "left",
    "style-width": "",
    "events": {},
    "style-marginBottom": ""
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "Archived",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "AllSampleList",
            "text": "(Archived: no filter)"
          },
          {
            "key": 2,
            "value": "true",
            "text": "Archived"
          },
          {
            "key": 3,
            "value": "false",
            "text": "Not Archived"
          }
        ],
        "style-width": "250px",
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
        "defaultValue": "false",
        "style-marginLeft": "20px"
      }
    ],
    "style-float": "left",
    "style-width": "",
    "events": {},
    "style-marginBottom": "",
    "style-marginLeft": ""
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
        "key": "SampleCount",
        "name": "Samples",
        "type": "number",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "isArchived",
        "name": "Archived",
        "type": "checkbox",
        "width": 100,
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": ""
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 150
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "sortable": false,
        "filterable": false,
        "resizable": true,
        "width": 100
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "NumberId DESC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_LIST",
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
]' WHERE [Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa';

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-28 10:36:30.657', 
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
        "key": "div_main_button",
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
            "key": "container_10",
            "data-buildertype": "container",
            "style-float": "left",
            "children": [
              {
                "key": "deleteModal",
                "data-buildertype": "swzmodal",
                "secondary": true,
                "children": [
                  {
                    "key": "header_22",
                    "data-buildertype": "header",
                    "content": "Delete Form Properties",
                    "size": "medium",
                    "textAlign": "left",
                    "subheader": ""
                  },
                  {
                    "key": "message_1",
                    "data-buildertype": "message",
                    "header": "",
                    "content": "WARNING: Deleting a Form Properties will also immediately delete all deployments that use it INCLUDING RESPONSE DATA",
                    "style-marginTop": "",
                    "style-marginBottom": "50px"
                  },
                  {
                    "key": "deleteGridView",
                    "data-buildertype": "gridview",
                    "columns": [
                      {
                        "key": "Title",
                        "name": "Form Properties Name",
                        "sortable": true,
                        "filterable": false,
                        "resizable": true
                      }
                    ],
                    "events": {}
                  },
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "DeleteConfirm",
                        "data-buildertype": "button",
                        "content": "Ok",
                        "primary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "gridDelete",
                              "closeDeleteModal"
                            ],
                            "targets": [
                              "gridQnn"
                            ],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "CancelDelete",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "secondary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeDeleteModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-float": "right",
                    "style-source": "text-align: right;",
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  }
                ],
                "style-display": "none",
                "content": "Delete",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "openDeleteModal"
                    ],
                    "targets": [
                      "gridQnn"
                    ],
                    "parameters": []
                  }
                },
                "isOpen": "",
                "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
              }
            ]
          }
        ],
        "style-float": "right",
        "style-marginRight": "20px"
      },
      {
        "key": "div_search",
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
                    "value": "Title,CreatedDate,Tags"
                  }
                ]
              }
            },
            "placeholder": "Search..."
          }
        ],
        "style-float": "left",
        "style-width": "300px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "Archived",
            "data-buildertype": "dropdown",
            "label": "",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "AllFormProperties",
                "text": "(Archived: no filter)"
              },
              {
                "key": 2,
                "value": "true",
                "text": "Archived"
              },
              {
                "key": 3,
                "value": "false",
                "text": "Not Archived"
              }
            ],
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
            "style-width": "250px",
            "defaultValue": "false"
          }
        ],
        "style-float": "left",
        "style-width": "300px",
        "style-marginLeft": "20px"
      }
    ],
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "div_clear",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginTop": "",
    "style-marginBottom": "30px"
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
        "key": "Tags",
        "name": "Tags",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
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
        "key": "IsArchived",
        "name": "Archived",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false
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
        "sortable": false,
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
    "minHeight": "500",
    "defaultSort": "Title ASC",
    "style-marginTop": "",
    "style-source": ""
  }
]' WHERE [Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-01 15:12:35.377', 
[Data]=N'[
  {
    "key": "container_4",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_2",
        "data-buildertype": "header",
        "content": "Deployments",
        "size": "huge",
        "style-source": "",
        "events": {}
      }
    ],
    "events": {},
    "style-source": "width: 100%;\nfloat:left;",
    "style-marginRight": "",
    "style-marginTop": "",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "buttonAdd",
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
        },
        "style-marginBottom": "0.25em",
        "floated": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "deleteModal",
            "data-buildertype": "swzmodal",
            "secondary": true,
            "children": [
              {
                "key": "header_1",
                "data-buildertype": "header",
                "content": "Delete Deployment",
                "size": "medium",
                "textAlign": "left",
                "subheader": ""
              },
              {
                "key": "deleteGridView",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Deployment Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": true
                  }
                ],
                "events": {}
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "DeleteConfirm",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridDelete",
                          "closeDeleteModal"
                        ],
                        "targets": [
                          "gridview_1"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "CancelDelete",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDeleteModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-float": "right",
                "style-source": "text-align: right;",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "style-display": "none",
            "content": "Delete",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "openDeleteModal"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "isOpen": "",
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ]
      }
    ],
    "style-float": "right",
    "style-marginBottom": "50px",
    "style-source": "",
    "style-width": "",
    "style-marginRight": "20px"
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
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "FilterSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": false,
                "onChangeTimeout": 200,
                "placeholder": "Search...",
                "style-width": "300px",
                "style-source": "",
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
                "style-marginBottom": "",
                "style-marginRight": ""
              }
            ],
            "style-source": "float: left;",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "FilterRecurrenceType",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllRecurrenceType",
                    "text": "(Recurring Survey: no filter)"
                  },
                  {
                    "value": "IR",
                    "text": "Recurring only"
                  },
                  {
                    "value": "I",
                    "text": "Recurring Initial only"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Recurring Recurrences only"
                  },
                  {
                    "key": 3,
                    "value": "N",
                    "text": "Not-recurring only"
                  }
                ],
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
                "defaultValue": "AllRecurrenceType",
                "style-source": "",
                "style-marginBottom": "",
                "style-marginRight": "",
                "placeholder": "",
                "style-width": "250px"
              },
              {
                "key": "FilterAnonymous",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllAnonymous",
                    "text": "(Anonymous Survey: no filter)"
                  },
                  {
                    "key": 2,
                    "value": "true",
                    "text": "Anonymous only"
                  },
                  {
                    "key": 3,
                    "value": "false",
                    "text": "Not-anonymous only"
                  }
                ],
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
                "defaultValue": "AllAnonymous",
                "style-source": "",
                "style-marginBottom": "",
                "style-marginRight": "",
                "placeholder": "",
                "style-width": "250px"
              },
              {
                "key": "FilterMultiple",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllMultiple",
                    "text": "(Multiple Response: no filter)"
                  },
                  {
                    "key": 2,
                    "value": "true",
                    "text": "Multiple only"
                  },
                  {
                    "key": 3,
                    "value": "false",
                    "text": "Not-multiple only"
                  }
                ],
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
                "defaultValue": "AllMultiple",
                "style-marginBottom": "",
                "style-marginRight": "",
                "style-width": "250px"
              }
            ],
            "style-source": "float: left;",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          }
        ],
        "style-width": "100%"
      }
    ],
    "style-marginBottom": ""
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "QnnTitle",
        "name": "Form Properties",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "ListName",
        "name": "Sample List",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": 250
      },
      {
        "key": "RecurrenceType",
        "name": "Recur",
        "type": "",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "IsAnonymous",
        "name": "Anon",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "IsMultipleResponse",
        "name": "Multi",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "CreatedDate",
        "name": "Created",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 150
      },
      {
        "key": "RespCount",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": "Responses",
        "width": 128
      },
      {
        "key": "Action",
        "name": "Action",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 128
      }
    ],
    "editForm": "QNN_DPLY",
    "rowKey": "Id",
    "multiselect": true,
    "defaultSort": "Name ASC",
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
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [],
        "targets": [],
        "parameters": []
      }
    },
    "pagerType": "server",
    "autoHeight": false,
    "offSet": "100px",
    "style-marginTop": "100px",
    "rowHeight": "80",
    "minHeight": "500",
    "style-source": "clear: both;",
    "disableSort": false
  }
]' WHERE [Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38';

