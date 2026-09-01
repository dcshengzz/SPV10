-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzQnnList.json

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-10-02 17:45:14.450', 
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

