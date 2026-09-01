--SQL to update the swzQnnList form with changes made in earlier commits 2ca6c17 and 1921f59
--Updates swzQnnList-code.js, swzQnnList.json in dwMetadata

UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'SwzQnnList.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:25.697', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-06-22 12:08:31.660', 120), Data = N'[
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
        "key": "container_2",
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
                  "gridview_1"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Delete",
            "primary": false,
            "style-source": "float:left",
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
            "secondary": true,
            "inverted": true
          },
          {
            "key": "123",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1123",
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
                          "gridview_1"
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
        "style-float": "left",
        "style-marginRight": "20px"
      }
    ],
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "gridview_1",
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
        "key": "Type",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": true
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
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
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
    "minHeight": "500"
  }
]', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '5811DF16-ED1A-4CF9-AF2F-BE001A7668EF';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'SwzQnnList-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:25.607', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-06-24 13:03:22.903', 120), Data = N'{
    init: function(args) {
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const innerArgs = args;
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[0].customFormatter = function(p){ 
                    return CloverApp.API.createElement("span", { 
                        onClick: () =>  CloverApp.API.redirectToForm(''QNN_QNN'', p.row.Id), 
                        className: "link-style" },
                        p.value); 
                };
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    return CloverApp.API.createElement("button", { 
                        onClick: () => showCopyModal(innerArgs, p.row.Id), 
                        className: "ui button secondary invert" }, 
                        "Copy");
                };
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);
    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------------------
        
        
        //----------------------------------
        const postFormData = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: ''same-origin'',
                method: ''post'',
                body: formData,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    /*return responseData.success ? responseData.data : Promise.reject(responseData.message);*/
                    return responseData.success ? responseData.message : Promise.reject(responseData.message);
                }, reason => {
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        var reg = /[!\s@#$%^&*()_+\-=\[\]{};'':"\\|,.<>\/?]/;
        if(reg.test(title)){
            alertify.error("Special symbols not allowed");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        loadingStart("Duplicating Questionnaire");
        postFormData("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridview_1.refresh();
                args.component.refs.copyModal.close();
                alertify.success("Created " + title);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
    },
}





', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '40CC065E-63CE-482A-B1EA-4766B3B5BE3D';
