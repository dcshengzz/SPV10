-- Will UPDATE existing row(s) in dwMetadata for the following:
-- Swztrklists.json
-- swztrklists-settings.json
-- QNN_TRK_LIST.json
-- QNN_TRK_LIST-settings.json
-- QNN_TRK_LIST-code.js

UPDATE [dwMetadata] SET
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-15 13:18:12.300', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_2",
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
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
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
                "key": "header_1",
                "data-buildertype": "header",
                "content": "Delete Track List",
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
                    "name": "Track List Name",
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
    "style-marginBottom": "",
    "style-float": "right",
    "style-marginRight": "20px"
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
        "style-width": "300px",
        "style-float": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "left",
        "style-width": "300px",
        "children": [
          {
            "key": "dictionary_1",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter by Organisation",
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
        ],
        "style-marginLeft": "10px"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_6",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
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
[Id]='52c60fe7-52bc-4191-9759-ced45ee3e7ea', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.947', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-15 13:18:12.353', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzTrklists",
  "lastUpdate": "2024-10-15T13:18:12.3517895+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "113be75a-51d8-db7b-9745-aa135fe7079e",
      "entityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "56fec25a-db74-f92d-b854-29ee2bb018e3",
          "attributeId": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0c70b31-7684-fbb1-23e1-ff96a00a9db1",
          "attributeId": "0c358898-d35c-4be3-89bd-368143effb39",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f08543d7-bfbd-6b13-4488-a679535eef1d",
          "attributeId": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3ac46703-2e77-13b5-9190-f907277c5c90",
          "attributeId": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f9bb2f3-70a5-b666-1874-6c4e991e2cfc",
          "attributeId": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb8a2a04-61a4-10e2-c06e-ea8ddb0a3e64",
          "attributeId": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5b82c5e0-3142-5dad-26c2-307f8f59a6c3",
          "attributeId": "f55004c7-067f-4b47-9815-1d91d177b8a2",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8566f52-293f-d6f8-27e2-0e850ef57c24",
          "attributeId": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b0973aa9-d8a7-8224-ad22-7dc8997bc1f3",
          "attributeId": "b3e75714-844d-4e64-b638-e9c60ffebf78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "482464a3-ebba-4393-97d5-2fd4a02af1e5",
          "attributeId": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
          "control": "UpdatedDate",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b789c7f-ab20-cfd7-8643-e702110c24c2",
          "attributeId": "863fb411-5f61-4962-ac06-cdf953abbbf0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72e26579-e5f5-8b27-35b2-5ad4768e9ffb",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionId_Name",
          "parentId": "6b789c7f-ab20-cfd7-8643-e702110c24c2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d0459245-8976-318d-c8ab-4d5b13a9fa42",
          "attributeId": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='52c60fe7-52bc-4191-9759-ced45ee3e7ea';

UPDATE [dwMetadata] SET
[Id]='94df18e6-8c55-43f0-883c-8b905a2d882f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-15 13:46:32.097', 
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
            "onChangeTimeout": 200,
            "other-required": true
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
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
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
                                "key": "rowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": true
                              },
                              {
                                "key": "uid",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": true
                              },
                              {
                                "key": "errField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": true
                              },
                              {
                                "key": "errMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": true
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
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
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
[Id]='27855988-ddc1-4d16-9272-69ebe7e64c13', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-15 13:46:32.127', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST",
  "lastUpdate": "2024-10-15T13:46:32.126765+08:00",
  "entityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
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
      "id": "e3fdbacd-4375-80d2-740c-7640f45540a1",
      "attributeId": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "189b34e9-b436-1620-293f-96b512e74eeb",
      "attributeId": "0c358898-d35c-4be3-89bd-368143effb39",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29536852-22ef-4321-6099-c79c4eed021b",
      "attributeId": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7f578f4f-db0d-f9d4-6def-3c5d9ba046ac",
      "attributeId": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "827f2897-f7bb-10bf-6d86-b59c288e3bd2",
      "attributeId": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1bafca91-1758-7795-8775-c66ceadd577a",
      "attributeId": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f69e648-723a-b662-fdd6-8fdf28016f17",
      "attributeId": "f55004c7-067f-4b47-9815-1d91d177b8a2",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54ed9637-3e8e-8e12-00e8-a24ad1c47f4c",
      "attributeId": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff10f833-945d-1258-ec3b-ce0af61fd36b",
      "attributeId": "b3e75714-844d-4e64-b638-e9c60ffebf78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9f27c2e-a9ec-dc10-868c-e57a039d72ad",
      "attributeId": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d23e0b5d-3658-a1a1-6202-1d30ec00565a",
      "attributeId": "863fb411-5f61-4962-ac06-cdf953abbbf0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b38af738-1a41-0f6e-1fd9-052438e971ce",
      "attributeId": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b2018773-2287-ab4a-5f60-6c614b841b76",
      "entityId": "245660f8-437f-4716-b14b-03a040a0f220",
      "filter": "FilterByModelId",
      "parameter": "{TrkListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "0cc2a40e-652a-3f5e-7502-cce03d7e26b9",
          "attributeId": "93d5e831-d471-4fdf-b562-60d70ed73b64",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d5b185b8-2318-5fc4-284a-4d6c3aca0540",
          "attributeId": "a6337ff6-c08d-4998-b235-f0c4609d44e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "548fe073-4081-ca3b-e8cb-780a584cd2e3",
          "attributeId": "7d603136-3dbb-488f-81ef-482d2592184e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8cd98de-8a9a-b81d-58ba-925e47eb0b47",
          "attributeId": "1c65984e-89ce-4030-8cbb-60d8eb2455d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e66f31-0567-6973-6dbe-8ead55b735a5",
          "attributeId": "665424d0-9759-437b-b620-d5d5243287c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c1692c4-bc68-d880-6ae2-023173363cbb",
          "attributeId": "9ed7f898-6b13-4cd0-be8d-4ce5183f0da8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6a27f53d-c1e7-1242-2949-4ef829c0fee3",
          "attributeId": "8f29d669-5d1d-4e3d-90b4-97153c2bbdfb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c399f5c-2b24-7d4d-e23c-93400d7a1520",
          "attributeId": "ec0e063b-9864-49a5-9469-72c6e2f2546e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35b222dd-c9b1-84ed-5313-04c48f4bb267",
          "attributeId": "b84d9d22-dd5c-4077-a8f7-a45a55496c0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0297648c-0594-5ad0-8f16-0fab66e47816",
          "attributeId": "67bb8933-188d-46ff-a9ce-7152447c3e6a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "26a11c54-3f20-205d-986b-9ec0206a9f87",
          "attributeId": "97f7aa0f-e033-4b9f-80e9-1dd6730c65f9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9afe4bb-1f5a-5f9b-c8ef-32cf8a130d2c",
          "attributeId": "aec40eba-82df-4090-8bda-87bc9ae2bdac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a213b234-6c3e-9107-5700-fb7244c3d7c2",
          "attributeId": "5671f841-1602-4210-90f3-77b8c2a51aaf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa0e2e0-84ea-65b9-8e32-cac5d650b33c",
          "attributeId": "4b041d0e-1bed-4dd0-87ea-1c8812ec54de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "498ba4b5-d60b-db99-acb1-09133f0a889b",
          "attributeId": "f042fa99-cffb-480c-af49-86b679f57c1e",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='27855988-ddc1-4d16-9272-69ebe7e64c13';

UPDATE [dwMetadata] SET
[Id]='ea958da5-0374-40dd-a53a-a00315a50a3a', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 15:06:37.850', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-15 13:56:27.630', 
[Data]=N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
    },
    
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){
        if(args.controlRef.state.rowsCount==0){
            alertify.error("Nothing to export");
            return;
        }
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
    submitFile(args)
    {
        const token = args.data.inputImportListSample;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        const formData = new FormData();
        formData.append("trkListId",args.data.Id);
        formData.append("token", token);

        Utils.loadingStart();
        Utils.postFormRequest("/trklist/importsamples", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                console.log("response", response);
                CloverApp.API.setDataField("inputImportListSample", null);
                args.component.refs.gridviewSample.refresh();
                CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                Utils.queueHideControl("headerListSampleAdded", false);
                Utils.queueHideControl("headerListSampleUpdated", false);
                const hasErrorMessages = response.items!=null && response.items!=undefined && response.items.length>0;
                if(hasErrorMessages){
                    console.log("items", response.items);
                    CloverApp.API.setDataField("gridviewImportSummary", response.items);  
                    Utils.queueHideControl("gridviewImportSummary", false);
                }
                else{
                    Utils.queueHideControl("gridviewImportSummary", true);                     
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally(Utils.loadingStop());
    }, 
  
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
}' WHERE [Id]='ea958da5-0374-40dd-a53a-a00315a50a3a';

