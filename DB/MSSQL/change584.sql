-- Will UPDATE existing row(s) in dwMetadata for the following:
-- swzListList.json
-- swzListList-code.js
-- swzListList-settings.json
-- swzQnnList.json
-- swzQnnList-code.js
-- swzQnnList-settings.json

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:41:56.177', 
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
    "style-marginRight": "20px"
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
        "defaultValue": "AllSampleList"
      }
    ],
    "style-float": "left",
    "style-width": "",
    "events": {},
    "style-marginBottom": "",
    "style-marginLeft": "20px"
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
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:20:18.760', 
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

            if(tags.length > 5){
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
    
    importSampleList(args){
        const token = args.data.listFile;
        const listName = args.data.listName;
        const password = args.data.listPassword;
        
        const passwordError = globalUserActions.samplePasswordError(password);
        if(passwordError) {
            throw {
                level: 1,
                message: passwordError,
                formerrors: {main: {listPassword: true}}
            };
        }
        
        var errors = {};
        if (!listName || ""===listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                message: "List name or file cannot be empty",
                formerrors: {main: errors}
            };
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        if(password && ""!==password) {
            formData.append("password", password);
        }
        Utils.postFormRequest("/list/importcsv", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success( Utils.encodeHTML(response.message),10000);
                args.component.refs.importModal.close();
            }, reason => {
                console.error(reason);
                if("NAME EXISTS"===reason) {
                    alertify.error( "A list with this name already exists in this organisation", 25000);
                } else {
                    CloverApp.API.setDataField("listFile", null);
                    alertify.error( Utils.encodeHTML(reason), 25000);
                }
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeImportModal: function(args) {
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
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
    
            updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != ''AllSampleList'') {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.470', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:41:56.220', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2025-11-26T11:41:56.2191567+08:00",
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
        },
        {
          "id": "6f21b7f4-e600-61a5-c8b0-3f0057ad0a4e",
          "attributeId": "b8f72a51-90d9-4416-8267-3ad35be75b43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2a785c5-0e2d-9039-b398-13964d4bc342",
          "attributeId": "ccbdf688-0179-41e6-9087-aea47869fb08",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3';

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:22:25.317', 
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
            "defaultValue": "AllFormProperties"
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
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:17:11.920', 
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
    
        updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != ''AllFormProperties'') {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridQnn: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

UPDATE [dwMetadata] SET
[Id]='2868495b-b1d3-40a8-943b-0078927caa60', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.650', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-26 11:22:25.437', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzQnnList",
  "lastUpdate": "2025-11-26T11:22:25.4373467+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "f7cb6ad3-78ac-8040-0838-09058d73161a",
      "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
      "filter": "StructAsyncFilter",
      "control": "gridQnn",
      "dataMap": [
        {
          "id": "2745cc89-c54f-d253-bbc5-67765af500a5",
          "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9eefbfb-c05d-277e-61f1-2463208aa58d",
          "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b843f723-2acd-c38a-1381-ae6883cfea39",
          "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36e795f2-b899-f6d0-81b4-4ba60c81359d",
          "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93015bf0-2009-41d5-81cf-4aa6e9fd063c",
          "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "228d3101-b4bc-0eea-a96c-db7cfb4ce9e1",
          "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff5f3abc-abe7-5c06-ad70-3a2c1894e925",
          "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "70de2c9d-6607-0cd5-f8c2-f6aed26cf048",
          "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27c1cfef-6d4c-12de-add1-839bc5dd08e5",
          "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6e08bf3-0b0e-536b-1485-8e662b1aa6c2",
          "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05f9bb5e-a5bc-60ca-5d22-b9a5d35b06e9",
          "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "672d3d2a-a7f7-21ca-9bca-0a7f7044e906",
          "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8787ec91-9b6b-fbd4-e407-aaca9ca20a5f",
          "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "607a923f-7a35-368b-ca05-464f7dc9ff1f",
          "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f340d62-9ff5-60a5-253a-b591891dffc7",
          "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "16cc7389-055e-b28a-47fc-372ab83fb9a0",
          "attributeId": "e2018e3a-6e65-4b0d-aa62-c640c20288b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58e1abd0-8afc-222b-e16e-023362fa415c",
          "attributeId": "37e07f99-e5d6-45b3-8674-cbfb55769be9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__gridQnn_totalcount"
    }
  ],
  "securityGroup": "Questionnaire",
  "isArchived": false
}' WHERE [Id]='2868495b-b1d3-40a8-943b-0078927caa60';

