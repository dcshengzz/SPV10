-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzListList.json
-- SwzListList-settings.json

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-28 16:50:57.480', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "pageHeader",
            "data-buildertype": "header",
            "content": "Lists",
            "size": "huge",
            "textAlign": "left",
            "style-marginTop": "",
            "style-source": "padding-top:20px;",
            "style-marginLeft": "",
            "style-width": "250px",
            "events": {}
          }
        ],
        "style-marginBottom": "10px"
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
                    "key": "form_1",
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
                        "key": "sampleAdded",
                        "data-buildertype": "header",
                        "content": "Samples added: {sampleAdded}",
                        "size": "small",
                        "events": {},
                        "other-visibleConition": "(data.sampleAdded!= null && data.sampleAdded!= undefined)"
                      },
                      {
                        "key": "sampleUpdated",
                        "data-buildertype": "header",
                        "content": "Samples updated: {sampleUpdated}",
                        "size": "small",
                        "events": {},
                        "other-visibleConition": "(data.sampleUpdated!= null && data.sampleUpdated!= undefined)"
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
                    ]
                  }
                ],
                "size": "",
                "other-visibleConition": "CloverApp.API.checkRole(''SurveyAdmin'')"
              }
            ],
            "style-float": "left"
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
        "resizable": false
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
        "active": true,
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-28 16:50:57.643', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2021-11-28T16:50:57.6204395+08:00",
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
      "readOnly": false
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3';

