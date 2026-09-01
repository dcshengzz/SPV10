-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzQnnList.json
-- SwzQnnList-code.js
-- SwzDplyList.json
-- SwzDplyList-code.js
-- SwzListList.json
-- SwzListList-code.js
-- SwzTrkLists.json

--Edited 20240605 to remove the UPDATE for SwzTrkLists-code.js as this should have been an INSERT.
--Instead change482.sql will insert SwzTrklists-code.js

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 22:52:19.647', 
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

UPDATE [dwMetadata] SET
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 21:16:23.370', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_QNN'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Title.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        
      return CloverApp.API.rewriteControlModel("gridQnn", gridModelRewriter);

    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating Questionnaire");
        Utils.postFormRequest("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridQnn.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
    },
    
        closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 19:24:15.287', 
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
    "style-marginBottom": "20px",
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
    ]
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
    "style-marginTop": "10px",
    "rowHeight": "80",
    "minHeight": "500",
    "style-source": "clear: both;",
    "disableSort": false
  }
]' WHERE [Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38';

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 19:15:26.930', 
[Data]=N'{
    init: function (args) {
        const isDataOwner = CloverApp.API.checkRole("DataOwner");
        
        //used by button rendere by respCOuntFormatter and actionsFormatter
        const prepareExport = function (baseUrl, dplyId) {
            Utils.loadingStart();
            Utils.postFormRequest(baseUrl + encodeURIComponent(dplyId)).then(
                response => {
                    alertify.success( Utils.encodeHTML(response.message), 20000);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason), 20000);
                }
            ).finally(Utils.loadingStop);
        };
        
        const respCountFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            return CloverApp.API.createElement(
                "button", 
                {
                    style: {
                        width: "100%",
                        color: (hasAnyResponses ? "black" : "red"),
                    },
                    onClick: hasAnyResponses
                        ? isDataOwner 
                            ? ((e)=>{e.stopPropagation(); prepareExport("/deployment/exportresponse/prepare/",dplyId);}) 
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the responses",10000);})
                        : ((e)=>{e.stopPropagation(); alertify.error("This deployment has no responses yet",10000);}),
                    className: "small ui button secondary invert",
                }, 
                p.row.RespCount + " / " + p.row.SampleCount);
        }; //end of respCountFormatter
                
        const actionsFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            if(!hasAnyResponses || !isDataOwner) {
                return CloverApp.API.createElement("div", {}, "");
            } else {
                return CloverApp.API.createElement(
                    "button", 
                    {
                        style: {
                            width: "100%",
                            color: "black",
                        },
                        onClick: isDataOwner
                            ? ((e)=> {e.stopPropagation(); prepareExport("/deployment/exportuploadedfiles/prepare/", dplyId)})
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the respondent uploaded files",10000)}),
                        className: "small ui button secondary invert",
                    }, 
                    "Export Files"); 
            }
        }; //end of actionsFormatter     
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();
            if(tags.length > 3) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel); 
        }; //end of tagsColumnFormatter
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }); 
                cols.RespCount.customFormatter = respCountFormatter;
                cols.Action.customFormatter = actionsFormatter;          
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        }; //end of gridModelRewriter

        var activateDeploymentAsync = function (args, id) {
            
            if(!$(''#''+id).is('':checked'')){
                $(''#''+id).prop(''checked'', true);
                args.controlRef.refs.swzmodalNotAllowed.props.swzData.isOpen = true;
                args.controlRef.refs.swzmodalNotAllowed.openModal();
            }
            else{
                $(''#''+id).prop(''checked'', false);
                args.state.app.extra.dplyId = id;
                args.controlRef.refs.confirmModal.props.swzData.isOpen = true;
                args.controlRef.refs.confirmModal.openModal();
            }
  
            return {};
        };

        var showModal = function (args, id) {

            return activateDeploymentAsync(args, id);

        };

        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);

        return {};
    }, //end of init
    
    closeModal: function (args){
        //console.log("closeModal args:", args);
        args.component.refs.swzmodalNotAllowed.close();
    },


    activateDeployment: function (args) {
        
        var changeStatusAsync = function (id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/deployment/activate'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success( Utils.encodeHTML(response.message) );
                         $(''#''+id).prop(''checked'', true);

                    } else {
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
                })
                .catch(error => {
                    alertify.error( Utils.encodeHTML(error.message) );
                });
                 args.component.refs.confirmModal.close();


        };
        console.log("activateDeployment args:", args);
        let id =  args.state.app.extra.dplyId;
        $(''#''+id).prop(''checked'', false);   
        changeStatusAsync(id);
        return {


        };

    },
    
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const filterAnonymousType = data.FilterAnonymous ? data.FilterAnonymous : "AllAnonymous";
        const filterMultipleType = data.FilterMultiple ? data.FilterMultiple : "AllMultiple";
        const filterRecurrenceType = data.FilterRecurrenceType ? data.FilterRecurrenceType : "AllRecurrenceType";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, QnnTitle, QnnType, ListName, Tags, CreatedDate",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        if("AllAnonymous" != filterAnonymousType) {
            filter.push({
               column: "IsAnonymous",
               nextValue: filterAnonymousType,
               term: "=",
               value: filterAnonymousType,
            });
        }
        if("AllMultiple" != filterMultipleType) {
            filter.push({
               column: "IsMultipleResponse",
               nextValue: filterMultipleType,
               term: "=",
               value: filterMultipleType,
            });
        }
        if("AllRecurrenceType" != filterRecurrenceType) {
            if(filterRecurrenceType=="IR") {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: ["I","R"],
                    term: "IN",
                    value: ["I","R"],
                });
            } else {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: filterRecurrenceType,
                    term: "=",
                    value: filterRecurrenceType,
                });
            }
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridview_1: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta, "filter", filter);
        return delta;
    },
    
    test: function(args,foo,bar) {
        console.log(args,foo,bar);
    },
    
    closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}
' WHERE [Id]='4d440057-891c-4fe7-aa60-47b67638b311';

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 22:42:15.763', 
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
                "key": "header_1",
                "data-buildertype": "header",
                "content": "Delete Sample List & Associated Records",
                "size": "medium",
                "textAlign": "left",
                "subheader": ""
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
                        "children": [],
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
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
          }
        ],
        "style-float": "left"
      }
    ],
    "style-float": "right",
    "style-marginRight": "20px"
  },
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
                "value": "Name,Tags,SampleCount,UpdatedDate"
              }
            ]
          }
        },
        "placeholder": "Search..."
      }
    ],
    "style-float": "",
    "style-width": "300px",
    "events": {},
    "style-marginBottom": "10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-source": "clear:both",
    "style-marginBottom": "50px",
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
        "floated": "left"
      }
    ],
    "style-marginTop": ""
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
        "resizable": false,
        "type": "custom"
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "custom"
      },
      {
        "key": "SampleCount",
        "name": "No. Of Records",
        "type": "number",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "sortable": false,
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
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 21:14:17.057', 
[Data]=N'{
    init: function(args) {
        console.log("args to init", args);
        const innerArgs = args;
        const hasEditPermission = CloverApp.API.checkPermission("Edit");
        console.log("hasEditPermission", hasEditPermission);
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            if(hasEditPermission) {
                return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
            } else {
                return null;
            }
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Name.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    }, //end of int
    
    //called by Copy button in modal
    copySampleList: function(args) {
        const data = args.data;
        const id = data.copySampleListId;
        const title = (data.newSampleListName===undefined) ? "" : data.newSampleListName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sampleListId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating SampleList");
        Utils.postFormRequest("/list/duplicate", formData).then(
            result => {
                args.component.refs.grid.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of copySampleList
    
    viewArgs: function (args){
        console.log("View", args);
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var listName = args.data.listName;
        
        var errors = {};
        if (!listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                //message: ''List name or file cannot be empty'',
                formerrors: {main: errors}
            };
          
          return {};
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        Utils.postFormRequest("/list/importnew", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success( Utils.response.message,10000);
            }, reason => {
                CloverApp.API.setDataField("listFile", null);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeModal: function (args){
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''importSummaryStatic'',''sampleListImportHeader'',''btnImportClose'',''containerInvalidDetails'']
                  }
              }
            }
        }       
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
    },
    
        closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-27 22:45:54.963', 
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
