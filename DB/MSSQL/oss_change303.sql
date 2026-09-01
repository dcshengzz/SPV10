-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzTrkLists.json
-- SwzTrkLists-settings.json
-- SwzListList.json
-- SwzListList-settings.json
-- sidemenu.json
-- sidemenu-settings.json
-- SwzDplyList.json
-- SwzDplyList-settings.json
-- QNN_LIST_SAMPLE.json
-- QNN_LIST_SAMPLE-settings.json
-- SwzGlobalMailer.json
-- SwzGlobalMailer-settings.json
-- SwzGlobalMailerMessage.json
-- SwzGlobalMailerMessage-settings.json
-- QNN_CATEGORY.json
-- QNN_CATEGORY-settings.json

UPDATE [dwMetadata] SET
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:05:30.150', 
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
        "inverted": true,
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
[Id]='52c60fe7-52bc-4191-9759-ced45ee3e7ea', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.947', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:05:30.237', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzTrklists",
  "lastUpdate": "2022-04-24T18:05:30.2119243+08:00",
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
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:27:50.840', 
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
            "style-display": "block",
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
                                  "copySampleList"
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
                                  "closeCopyModal"
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
                    "style-marginBottom": "20px",
                    "other-visibleConition": ""
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
        "style-float": "left",
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
            "other-visibleConition": "",
            "style-source": "float:left"
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Delete",
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
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "other-visibleConition": "",
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "children": [
              {
                "key": "importModal",
                "data-buildertype": "swzmodal",
                "style-source": "",
                "secondary": true,
                "content": "Import",
                "style-display": "none",
                "children": [
                  {
                    "key": "formImportList",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "header_1",
                        "data-buildertype": "header",
                        "content": "Import List",
                        "size": "medium",
                        "events": {},
                        "other-visibleConition": ""
                      },
                      {
                        "key": "listName",
                        "data-buildertype": "input",
                        "label": "List Name",
                        "fluid": true,
                        "onChangeTimeout": 200
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
                                  "closeModal"
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
                                  "submitFile"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "other-visibleConition": "(data.sampleAdded == null || data.sampleAdded == undefined)",
                            "style-source": "float: right;"
                          }
                        ],
                        "style-marginRight": "",
                        "style-width": "100%",
                        "style-marginBottom": "10px"
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
                    "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
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
                "size": "",
                "other-visibleConition": "CloverApp.API.checkRole(''SurveyAdmin'')"
              }
            ],
            "style-float": "left"
          },
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
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1",
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
        "style-marginRight": "20px",
        "style-width": "100%"
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": false,
        "filterable": false,
        "resizable": false,
        "type": "custom"
      },
      {
        "key": "Category",
        "name": "Category",
        "sortable": false,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "SampleCount",
        "name": "No. Of Records",
        "type": "number",
        "sortable": false,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "sortable": false,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": false,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
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
[Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.470', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:27:50.853', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2022-04-24T18:27:50.8529781+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "176196ed-079f-6a36-bc0c-331bfdb4c7d3",
      "entityId": "d779dd42-ad03-418f-9a00-7906cfb9e01f",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "06e184c2-9e7c-f14d-2947-e9e02f9a62a5",
          "attributeId": "9ec78af2-2a96-4af8-9416-a61b26920f90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "24b1dfc8-98b5-2b3d-cc48-6e6a874659c6",
          "attributeId": "1f8c8043-fc0a-4bc3-a0d5-3933a136b8cb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9ccc51d-c139-eda6-0d48-9d1a1dc10f48",
          "attributeId": "33924fbd-7f4d-447e-9346-91fb73661914",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d7a2e45-1ca6-5be7-ae45-10db539e2ddb",
          "attributeId": "fe356bc9-fb35-418f-b289-6d3c3ba5bff9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c3d75d44-bc83-484d-66ce-5a80562732b0",
          "attributeId": "4da79cdf-bda1-4862-99b0-7762005b3fa8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e1e96a0-86b5-bf30-c83e-c74ca19142a9",
          "attributeId": "1439e7c0-9381-49ac-bb27-06177daba88e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dbc0e6f-294f-a7a1-7b84-3708819382cf",
          "attributeId": "a7caa665-5fcb-4cd8-b75e-4b6023baf6c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8fd30580-6db4-1048-6736-b3b42f516a3c",
          "attributeId": "e85aa4f7-4e99-4797-8979-783b4239720f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:14:42.323', 
[Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
        "children": [
          {
            "title": "<b>Forms</b>",
            "target": "",
            "distype": "dropdownheader",
            "visibleCondition": ""
          },
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/surveydesigner?apanel=formlogic",
            "title": "Form Logic",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')"
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          }
        ],
        "distype": "dropdown",
        "icon": "list alternate outline"
      },
      {
        "target": "",
        "title": "",
        "children": [
          {
            "title": "Deployments",
            "target": "/form/SwzDplyList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')"
          }
        ],
        "distype": "dropdown"
      },
      {
        "distype": "dropdown",
        "icon": "database",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
          },
          {
            "target": "/form/ChoiceCount",
            "title": "Frequency Count Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Response Status Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/RespondentParticipationReport",
            "title": "Respondent Participation Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "title": "<b>System</b>",
            "distype": "dropdownheader"
          },
          {
            "title": "Categories",
            "target": "/form/SwzCategoryList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/SwzRespAdminList",
            "title": "Respondent Content Management",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organisations",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''AuditAdmin'')"
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') "
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "onItemClick"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": "",
    "icon": false,
    "compact": false,
    "style-width": ""
  }
]' WHERE [Id]='55636648-e5a4-4002-9f59-d597fd167c04';

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:14:42.397', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-04-24T18:14:42.3969463+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:16:06.313', 
[Data]=N'[
  {
    "key": "container_4",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "Deployments",
            "size": "huge",
            "style-source": "",
            "events": {}
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
                "style-marginBottom": "0.25em"
              },
              {
                "key": "buttonDelete",
                "data-buildertype": "button",
                "content": "Delete",
                "secondary": true,
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
                },
                "circular": false,
                "style-marginBottom": "0.25em"
              }
            ],
            "style-float": "left",
            "style-marginBottom": "20px",
            "style-source": "",
            "style-width": "",
            "style-marginRight": "20px"
          },
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
    "events": {},
    "style-source": "width: 100%;\nfloat:left;",
    "style-marginRight": "",
    "style-marginTop": "",
    "style-marginBottom": "1em"
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
        "key": "IsAnonymous",
        "name": "Anonymous",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": ""
      },
      {
        "key": "IsMultipleResponse",
        "name": "Multiple",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": ""
      },
      {
        "key": "QnnTitle",
        "name": "Form",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "ListName",
        "name": "Sample List",
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
        "name": "Date Created",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "RespCount",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": "Responses"
      },
      {
        "key": "Action",
        "name": "Action",
        "type": "custom",
        "resizable": true,
        "sortable": false,
        "filterable": false
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
    "style-marginTop": "10px",
    "rowHeight": "80",
    "minHeight": "500",
    "style-source": "clear: both;",
    "disableSort": false
  }
]' WHERE [Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38';

UPDATE [dwMetadata] SET
[Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.327', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:16:06.373', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzDplyList",
  "lastUpdate": "2022-04-24T18:16:06.3732189+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "058228ef-f056-b36f-c7ec-702668c9294a",
      "entityId": "f80dfd0d-8d02-4fa0-b96d-a8d0a4b158c3",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "20724308-7569-e228-19f7-8363d510a2f9",
          "attributeId": "7cf8625b-4118-4801-bfa3-e97948989e72",
          "control": "CategoryName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19511b88-44e8-86e1-6d14-82bbe1011505",
          "attributeId": "f0a7d187-b968-4ad8-abec-e46b32bab0cf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c6b9cbf-4767-22e2-ca9e-9ff48eb9966d",
          "attributeId": "619d0245-2d3b-46bc-ad67-4d0d69b779a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7aff8724-8cd0-625d-d36b-ace2a505e040",
          "attributeId": "a2a0d06f-d6d9-4452-9910-df0e88be6104",
          "control": "ListName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9da9dd72-7068-08ac-d0a7-4923caf23aca",
          "attributeId": "abc42150-cc13-446b-9a8a-8277022e11d0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99fe6b46-ff27-ee98-7bc3-8132656515e2",
          "attributeId": "bef244ee-2ee4-496d-82aa-b3c212ed1d0b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a7a3938-317b-fb4b-0f19-49c9531e7035",
          "attributeId": "b1a5e363-bc28-40d6-864d-791bc353e150",
          "control": "QnnTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7b50251-f8e2-c9df-fe21-dfb83887e9d0",
          "attributeId": "d4044d06-1bd3-4e33-93ee-e0e7ef5384dc",
          "control": "QnnType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76e6c076-85d3-8ed9-07d2-1b267ceb476c",
          "attributeId": "932f78f2-eed2-43ad-a8ee-435d0fc7b3b8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b37898-b089-fbbb-6db6-d83280200104",
          "attributeId": "5a4cf42f-8ec4-446c-81cf-ae35f7318a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d083abec-c35f-6363-3a7d-862b0526ef58",
          "attributeId": "f29c04ff-05dc-4c47-9ba3-47c0b54a3a74",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a72c10e3-ad37-5968-ecc4-3d3a0a3fd32f",
          "attributeId": "04522c05-b4ee-4c68-ba7d-a94236d7f0b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0c7530a-11ac-6e69-4b3b-714e51056ab3",
          "attributeId": "623bdb8d-e43f-4157-8944-6c3cdb497a89",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec';

UPDATE [dwMetadata] SET
[Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.530', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:23:09.457', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Manage Sample",
            "size": "large",
            "events": {}
          },
          {
            "key": "DictionaryListName",
            "data-buildertype": "dictionary",
            "label": "List Title",
            "fluid": true,
            "selection": true,
            "columns": "Name ASC",
            "dataModel": "QNN_LIST",
            "events": {},
            "other-required": true,
            "other-readOnlyConition": "true",
            "paging": true,
            "pageSize": "20",
            "filters": ""
          },
          {
            "key": "dictionarySample",
            "data-buildertype": "dictionary",
            "label": "Sample",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "other-customValidation": "value!=''00000000-0000-0000-0000-000000000000'' ?true:''Sample is requried''",
            "filters": ""
          },
          {
            "key": "dictionarySamplePeer",
            "data-buildertype": "dictionary",
            "label": "Sample Peer",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "clearable": true
          },
          {
            "key": "ActiveYN",
            "data-buildertype": "checkbox",
            "label": "Active Status",
            "toggle": true
          },
          {
            "key": "customBlockSampleProps",
            "data-buildertype": "customblock",
            "sourceType": "source",
            "source": "[]",
            "style-marginBottom": "1em"
          }
        ]
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
                  "saveProp"
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
                  "goBack"
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
          }
        ],
        "style-float": "left",
        "events": {},
        "style-source": "",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": "700px",
    "style-source": "clear: both;\nmaxWidth: 1050;\n",
    "style-marginTop": "10px",
    "style-customcss": ""
  }
]' WHERE [Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96';

UPDATE [dwMetadata] SET
[Id]='93a53d80-5afe-4eba-9b6c-b635ea424879', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.480', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:23:09.570', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_LIST_SAMPLE",
  "lastUpdate": "2022-04-24T18:23:09.5680802+08:00",
  "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "d3fcd0a7-f271-1814-0bdb-4d49b32326eb",
      "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "be26f972-5122-f200-8d78-e74fb5cd55fa",
      "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a565d76f-79a8-3bed-ce96-e787ad4164d3",
      "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a70f3313-0c44-6e58-37a3-9425445e7281",
      "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "622e9be6-151f-9edc-9937-e0607e2af60b",
      "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2bc23b6-3714-e347-819c-edda82506012",
      "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d27d197c-c3dc-6813-4789-68a10910e391",
      "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
      "control": "DictionaryListName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9df4d633-6819-b137-7dfa-f5284b394b99",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "parentId": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "isEditable": false,
      "isLoadable": true
    },
    {
      "id": "a0d749d9-08c8-bdd7-449a-f584627b6cfd",
      "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9f967df-5b61-c0b0-fb87-a8011db68bb8",
      "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a762c4ec-c806-6933-d52c-a63e364d6fff",
      "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0a1060c-64f1-1dc2-3e95-24b262c1f211",
      "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
      "control": "dictionarySample",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f6b56a50-4df1-08d6-47de-f2c839f12ac5",
      "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
      "control": "dictionarySamplePeer",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "List"
}' WHERE [Id]='93a53d80-5afe-4eba-9b6c-b635ea424879';

UPDATE [dwMetadata] SET
[Id]='7920415b-36c7-4270-99de-fcd7abca91a7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:45:49.327', 
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
            "content": "\nGlobal Mailer",
            "size": "huge",
            "subheader": "Send email to all all sample of active deployment with selected status"
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
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "organization",
                        "data-buildertype": "dictionary",
                        "label": "",
                        "fluid": true,
                        "selection": true,
                        "placeholder": "Organisation",
                        "dataModel": "vStructDivisionParentsAndThisName",
                        "columns": "Name, Id ASC",
                        "filters": "[{ column : \"ParentId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                        "paging": true,
                        "search": true,
                        "style-marginBottom": "10px"
                      },
                      {
                        "key": "target",
                        "data-buildertype": "radiogroup",
                        "label": "To",
                        "data-elements": [
                          {
                            "key": 1,
                            "value": "intranetUsers",
                            "text": "Backoffice Users (Intranet)"
                          },
                          {
                            "key": 2,
                            "value": "activeSamples",
                            "text": "Active Samples (Internet Respondents)"
                          }
                        ],
                        "style-marginTop": ""
                      },
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
                        "other-visibleConition": "data.target == \"activeSamples\" ? true : false"
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
                    "other-visibleConition": ""
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "emailToStatus"
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
                        "key": "btnCancel",
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
                              "swzmodal_2"
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
            "content": "Create Scheduled Email",
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
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": false,
            "type": "datetime"
          },
          {
            "key": "ScheduledDate",
            "name": "Scheduled",
            "type": "datetime",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "EmailSubj",
            "name": "Subject",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "SampleCount",
            "name": "Sent",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "JobIsCanceled",
            "name": "Cancelled",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "IsTargetUsers",
            "name": "Intranet",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": false
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "defaultSort": "NumberId DESC",
        "multiselect": false,
        "rowHeight": "",
        "pageSize": "80",
        "minHeight": "",
        "editForm": "SwzGlobalMailerMessage",
        "events": {
          "onRowClick": {
            "active": true,
            "actions": [
              "gridEdit"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "autoHeight": false
      }
    ]
  }
]' WHERE [Id]='7920415b-36c7-4270-99de-fcd7abca91a7';

UPDATE [dwMetadata] SET
[Id]='bd23d168-027b-4827-b17a-7617b4a12378', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:45:49.387', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailer",
  "lastUpdate": "2022-04-24T18:45:49.3851016+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "a6062e72-4830-7d94-dbc3-731a6adfffaf",
      "entityId": "26f92131-609c-40bc-8b38-9ec4fd66fca5",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "c467c287-9a90-9323-3cbd-bf8ae2727287",
          "attributeId": "be5cfc9e-69b1-4ccd-a92a-bdd062727c00",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff86383-5e00-a969-8310-030675d955a7",
          "attributeId": "0c94a477-4399-4659-9d1d-5c24087d023c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a869f780-c1b7-67dc-de1c-75dac944c1aa",
          "attributeId": "dcee1721-2a49-4bbc-82b7-b8ea08f97c9a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a2fc8d9-8440-3ab1-12f9-7d2868616aae",
          "attributeId": "6e55e3d1-0f7b-4eb0-a20e-ca42f09ec4eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ede8577-6d92-a0cf-b9da-fdead3a0f7c5",
          "attributeId": "be72b7e3-bcc7-4d62-bb6d-3467d422512f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06100a2d-174b-4d39-ca2c-e2c14c76ce88",
          "attributeId": "705fe916-6b58-4b51-ac1d-cbbd565ab921",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62b8f9b9-83cf-9589-258f-e825421e57ee",
          "attributeId": "fb438787-70d2-4a34-97dc-1b214d1bdd92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da7f21e0-cf2a-2b81-d3d9-a2683ddf5a5d",
          "attributeId": "577ae8a2-3d0a-4b19-8a28-09c177fd19a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "afd269b5-bf93-5658-f107-87f896b8aa2f",
          "attributeId": "469e027c-f7dc-4227-a4c8-82152ba1dd91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0fcf4a9c-1172-8cad-41e7-367d045b51ec",
          "attributeId": "5d1fff92-b20c-4fb6-855d-f840171fa9bf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "880dbd97-5dc1-859e-f537-c0e8657306ac",
          "attributeId": "e5a4d062-2eb7-4009-920c-b00ec6f661da",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "de9764c9-5916-f36d-ddb4-e89d145f3408",
          "attributeId": "9001b9b9-0f4c-4cfe-b185-8fb97fe61a29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9cb669f7-74f6-7f5c-69c4-122532c93449",
          "attributeId": "b66ea0c8-5d41-4d09-9bc4-037a171d6913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "66722324-156e-9ef1-b94c-23935deb1ab6",
          "attributeId": "465f2fc6-434a-457f-bd45-a1835abd7bcd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8cc2868-ce74-f236-2b54-da8a60dc4984",
          "attributeId": "ba1df5e9-1f0b-4f9e-8c32-7c02fd04fff4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a46b6591-b811-ca0e-e144-34303c20803f",
          "attributeId": "0f66dd50-0752-4c59-b219-8fed4d27ace0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "185090ea-8777-1d36-4752-68dd25ffdd6e",
          "attributeId": "aee289bb-555f-4890-b890-7b3b1a6dc719",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa4a564-7283-29a1-33f2-0225b86bb993",
          "attributeId": "1e447ccd-dd43-4cef-abb7-f3d7a688cc8c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='bd23d168-027b-4827-b17a-7617b4a12378';

UPDATE [dwMetadata] SET
[Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.460', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:52:44.443', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Global Mail Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5><p>{EmailSubj}</p>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5>{MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>{EmailFrom}<p/>\n\n",
        "isHtml": true
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
          }
        ],
        "other-visibleConition": "data.StatusCollection.length !== 0"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_4",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">This scheduled job was cancelled</h5><p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ],
        "other-visibleConition": "data.JobIsCanceled"
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%"
  },
  {
    "key": "container_6",
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
                "key": "container_14",
                "data-buildertype": "container",
                "style-source": "clear: both;",
                "children": [
                  {
                    "key": "organization",
                    "data-buildertype": "dictionary",
                    "label": "",
                    "fluid": true,
                    "selection": true,
                    "placeholder": "Organization",
                    "dataModel": "vStructDivisionParentsAndThisName",
                    "columns": "Name, Id ASC",
                    "filters": "[{ column : \"ParentId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                    "paging": true,
                    "search": true,
                    "style-marginBottom": "10px"
                  },
                  {
                    "key": "target",
                    "data-buildertype": "radiogroup",
                    "label": "To",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "intranetUsers",
                        "text": "Intranet Users"
                      },
                      {
                        "key": 2,
                        "value": "activeSamples",
                        "text": "Active Samples"
                      }
                    ],
                    "style-marginTop": ""
                  },
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
                    "other-visibleConition": "data.target == null ? data.IsTargetUsers == true ? false : true : data.target == \"activeSamples\" ? true : false",
                    "other-customValidation-soft": false
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
                    "other-visibleConition": "",
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
                    "key": "button_2",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "editEmailToStatus"
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
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "value": "/form/SwzGlobalMailer",
                "name": "target"
              }
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "searchSample",
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
          "sampleGrid"
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
    "style-width": "300px",
    "other-visibleConition": "data.IsTargetUsers == 0 ? true : false"
  },
  {
    "key": "searchUser",
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
          "userGrid"
        ],
        "parameters": [
          {
            "name": "column",
            "value": "Name"
          }
        ]
      }
    },
    "style-marginBottom": "20px",
    "style-width": "300px",
    "other-visibleConition": "data.IsTargetUsers == 1 ? true : false"
  },
  {
    "key": "sampleGrid",
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
    "pagerType": "server",
    "other-visibleConition": "data.IsTargetUsers == 0 ? true : false"
  },
  {
    "key": "userGrid",
    "data-buildertype": "gridview",
    "columns": [
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
    "defaultSort": "Name ASC",
    "pagerType": "server",
    "other-visibleConition": "data.IsTargetUsers == 1 ? true : false"
  }
]' WHERE [Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf';

UPDATE [dwMetadata] SET
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 18:52:44.480', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2022-04-24T18:52:44.4784286+08:00",
  "entityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "2233d8bb-2753-7adc-140a-f3713ed2bd19",
      "attributeId": "51458d0d-a57e-415d-af77-0506b62b2deb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e737ab32-149c-f374-034e-dbe21901d118",
      "attributeId": "178e7c32-3be5-46ae-8ab1-94a6504f1a2b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78945706-2fd2-e046-bfdb-bc96647a242b",
      "attributeId": "7c6620ef-f482-49bd-86bd-86ec78fa23ee",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "80e9b5b6-e9d0-d6c6-7820-fda90a42cdca",
      "attributeId": "04e1e5d0-d802-4a29-92ab-221ff60efb6c",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "cc3532d7-a661-48ec-434f-ecbf5d6f4c37",
      "attributeId": "868d7019-916a-41a2-ad9c-80e83c3e7146",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37108dd-6858-a497-a9bb-a8a61d9d4a62",
      "attributeId": "cf5185ac-386f-4c17-9b43-d81346e47627",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "00f5b7a6-98e0-e43d-bdfb-7130427ac87b",
      "attributeId": "7f4eb9fe-d50d-4b90-be34-5f81b48a005f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbc3f2c9-8468-1e35-8b28-186bd9130f4c",
      "attributeId": "25163e9e-6d07-4423-bef6-5203af0926cf",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "4c82c383-7898-02c4-46e8-c5048e9d98e1",
      "attributeId": "a59d6ab1-d8f1-4092-a7b2-5302d788b52a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d7efc1d-18a9-1188-aaab-64a342757ed9",
      "attributeId": "e24601f7-a005-4dc1-b76b-2e4ced2c9f47",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9ee0391-52e3-87a4-554f-0b077751cef3",
      "attributeId": "ffc06abf-996d-41b7-8aee-f8ee9b573217",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e3246e2e-23df-9c09-498d-019c4037fbaf",
      "attributeId": "b34d67a4-bfc5-4ee0-9112-d7ddffbfd570",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c40f8b2-4c30-f7bc-e027-d37ee84d4bfd",
      "attributeId": "603cb5e3-af1f-4288-8659-9d041999c4d4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19190086-6d45-9e40-be40-9531abc43cd7",
      "attributeId": "98daf50e-4248-4701-8fdd-17dacdd94355",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfe6fd82-2f3c-1d8e-ca6f-761aab03d8ef",
      "attributeId": "bb0f1b64-9144-4b35-916b-3a6292a0e774",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "61abc650-e453-e08e-8278-b4f1239170d1",
      "attributeId": "f1658572-a0e2-4084-8cf9-17b3a4f2998a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d475ab76-4cf6-9e57-4d3b-bc47bac2dedf",
      "attributeId": "1a057eec-3f17-49fa-b876-261f21e6695a",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b0292df5-4b89-70ba-7594-fd5ba4e1f8bc",
      "entityId": "65091649-b0af-4091-86f9-7109aeb9fbf7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "attributeId": "8c53aed3-bbc5-420f-84f0-e6b8820052cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10d586e4-f3bf-dd0a-fdc5-8e00c0c5b388",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "e9dd17e6-7fdd-78ea-f15d-73b1202f750b",
          "attributeId": "1287529e-1bc7-465a-a53b-98cb619f253b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ce34148-ea28-4a48-8417-e7f8a16a222c",
          "attributeId": "1ffeb14b-0ab9-4ca5-ade4-2971477fe68b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__StatusCollection_totalcount"
    },
    {
      "id": "4ba1a0b1-27ae-1ffb-2156-315fff887e73",
      "entityId": "1aa13d9f-30a1-482e-9733-ee01420755f7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "sampleGrid",
      "dataMap": [
        {
          "id": "fc90a4a8-8cf1-61a1-609c-fd1ec101de5f",
          "attributeId": "e958ec47-15ba-4f2a-9f06-b82631dc6a6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f4699a1-ab9d-1454-a2c7-647b982701af",
          "attributeId": "0e2eac76-0927-4eb7-8fdf-c5955a3d227a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf4d04ce-5cb5-202a-a744-9bee51e82991",
          "attributeId": "8b4aaa31-a559-4912-9397-09de90ac4e16",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a504a99-7cd1-4452-6ffc-7612b2961e92",
          "attributeId": "4853e87b-032f-48ce-b964-790b92b9e918",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d4e96d7-3e92-7958-6d7e-687c26985e75",
          "attributeId": "686137e7-c77f-43bd-9dd2-e6b79b4465aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96a42599-adad-d96f-c7e2-4ac67180323e",
          "attributeId": "907dfbd8-9670-4099-8dae-91b18986837c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__sampleGrid_totalcount"
    },
    {
      "id": "10a9584a-1aff-bc30-6e96-512acd7ac710",
      "entityId": "a7267c48-2060-46d2-8923-cd1dcbd01006",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "userGrid",
      "dataMap": [
        {
          "id": "4f17a43d-7519-f6d4-b4ca-c396cb3bc46e",
          "attributeId": "b3bc9f47-0598-4079-9114-f21bf45fc83e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5272c995-ab67-e316-a4de-fc2bbe043cd8",
          "attributeId": "4077a2c7-b11c-42e3-9fdc-e9382299c204",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63d33da7-0f3c-5557-34a2-b50f4da8ebb1",
          "attributeId": "08edc3df-13f7-480f-9fbe-9a8d1f638a70",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9427ff3-b519-ab75-0167-db1c85bb1450",
          "attributeId": "0a99aad0-9fcf-412f-8f29-f51ec14de57e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "619b3f3f-8600-98d5-ebe3-865d75e7ecbc",
          "attributeId": "cef5e01e-8dcb-4767-bcb9-6b1dc397ea25",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__userGrid_totalcount"
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='95150f4a-b078-48ac-a2a5-a12da83bf571';

UPDATE [dwMetadata] SET
[Id]='11c92291-9d59-45b1-9322-a28318bb61c2', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'QNN_CATEGORY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.060', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 19:02:31.743', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Category",
        "size": "large"
      },
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
            "data-buildertype": "input",
            "label": "Description",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "dropdownType",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "L",
                "text": "List"
              },
              {
                "key": 2,
                "value": "Q",
                "text": "Questionnaire"
              },
              {
                "key": 3,
                "value": "D",
                "text": "Deployment"
              }
            ],
            "search": true,
            "placeholder": "Select type..."
          },
          {
            "key": "dictRoles",
            "data-buildertype": "dictionary",
            "label": "Roles",
            "fluid": true,
            "selection": true,
            "dataModel": "dwSecurityRole",
            "columns": "Name ASC",
            "placeholder": "Select one or more roles...",
            "multiple": true,
            "events": {},
            "filters": "[{\"column\": \"Code\", \"value\":\"Admins\", \"term\":\"!=\"}, {\"column\": \"Code\", \"value\":\"User\", \"term\":\"!=\"}]",
            "paging": false,
            "search": false
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-float": "left",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "btnSaveOnClick"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
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
                        "value": "/form/SwzCategoryList"
                      }
                    ]
                  }
                },
                "primary": false,
                "secondary": true
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          }
        ]
      }
    ]
  }
]' WHERE [Id]='11c92291-9d59-45b1-9322-a28318bb61c2';

UPDATE [dwMetadata] SET
[Id]='e9cc3d0b-9488-4546-9d17-08addc93e437', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_CATEGORY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.017', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-24 19:02:31.850', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_CATEGORY",
  "lastUpdate": "2022-04-24T19:02:31.8489813+08:00",
  "entityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
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
      "id": "dc71893e-978b-fafa-3765-a7b9f4d0aa56",
      "attributeId": "6536ef8f-b9a1-4a7a-819b-35691537fefd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f9215a7e-83fd-400e-55f7-51ad964c9742",
      "attributeId": "a6250e06-4a48-43dc-81f7-4bbc9a80a0ea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "711c45e0-68a2-695f-d9af-1c6cc6f3b93d",
      "attributeId": "f0370aec-4608-46ef-998b-b115c3fe4ca4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "85fc042c-b792-19ab-9a64-ba2c30f765d5",
      "attributeId": "fa137602-163a-4f3e-9b78-980f5820a3a0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b55387ee-00e2-951c-49a8-3b8d96f965ab",
      "attributeId": "83f78020-12c8-430e-a030-a659dce0df30",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e09224-5a9d-5bbb-8f0e-d8b367d7b351",
      "attributeId": "38bae30d-1d9f-4003-8850-b6c19fa2b565",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "52d68045-3cf6-2e56-a73b-f7088f7d1060",
      "attributeId": "2115d9aa-2765-4e15-bf55-9f67465f0270",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "84b17b71-c3b6-710b-eaa3-ace3cf41244c",
      "attributeId": "69d19937-002d-45b7-b86f-73f63e918fd8",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ceca8436-a67d-865c-2e6e-1a648e50f022",
      "attributeId": "0ba90a37-bdfa-447c-b463-70fabd946961",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae17eca4-b13e-0c66-53ea-63f29f8ec620",
      "attributeId": "7f67d0c6-4bab-49e9-8270-12cfcc0b2f8b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "21da636a-0291-c4ed-6461-658bfa0afa6c",
      "attributeId": "ee2a1214-2e10-46c1-82da-c63bbf0c2718",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0acf3b45-1dd8-1279-28cf-a5dda6cec2a2",
      "attributeId": "94217f4c-c998-4900-9ee1-a6f6826113c3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15384e53-8e33-cdf5-08a8-633fbd91dfb6",
      "attributeId": "d78ebe9c-b194-490a-859a-18ecaa37f967",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed65e1c6-dd49-7fe3-baf0-db65ed0964fe",
      "attributeId": "53fc33f5-3fab-487e-9569-170e34f28f09",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Category"
}' WHERE [Id]='e9cc3d0b-9488-4546-9d17-08addc93e437';

