-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzListList-settings.json
-- SwzListList.json
-- SwzListList-code.js

UPDATE [dwMetadata] SET
[Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.470', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-08 12:30:34.137', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2022-02-08T12:30:34.1381505+08:00",
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
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-08 12:30:34.113', 
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
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-08 12:29:26.023', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
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
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                cols.Actions.sortable = false;
                cols.Actions.customFormatter = copyFormatter;
                
                
                cols.Name.sortable = false;
                cols.Name.customFormatter = nameFormatter;
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
        const reg = /[!\s@#$%^&*()_+\-=\[\]{};'':"\\|,.<>\/?]/;
        if(reg.test(title)){
            alertify.error("Special symbols not allowed");
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
                alertify.success("Created " + title);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
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
        
        var url = ''/list/importlistsamples?token='' + token + ''&listName='' + listName;
        Utils.loadingStart("Importing...");
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                Utils.loadingStop();
              
                if (response.success) {
                    var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
             
                    CloverApp.API.setDataField("listFile", null);
                    CloverApp.API.setDataField("listName", null);
                    /* CloverApp.API.setDataField("sampleAdded", response.statistics.sampleAdded);
                    CloverApp.API.setDataField("invalidRows", response.statistics.exceptionCount);
                    CloverApp.API.setDataField("sampleDuplicated", response.statistics.sampleDuplicated);
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows); */
                    args.component.refs.importModal.close();
                    args.component.refs.grid.refresh();
                    alertify.success(response.message,8000);
                    if(response.items!=null && response.items!=undefined){
                        //CloverApp.API.setDataField("invalidRowsDetail", response.items);

                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [],
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                    else{
                         return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [],
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
   
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Pace.stop();
                Utils.loadingStop();
                alertify.error(error.message);;
            });
        };
    }, 
    closeModal: function (args){
        /* CloverApp.API.setDataField("sampleAdded", null);
        CloverApp.API.setDataField("invalidRows", null);
        CloverApp.API.setDataField("invalidRowsDetail", null);
        CloverApp.API.setDataField("sampleDuplicated", null);
        CloverApp.API.setDataField("totalRows", null); */
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
                      hideControls: [''importSummaryStatic'',''sampleListImportHeader'',''btnImportClose'',''containerInvalidDetails'']
                  }
              }
            }
        }       
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

