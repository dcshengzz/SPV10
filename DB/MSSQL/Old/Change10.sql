UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.507', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-23 02:21:00.473', [Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "Name",
        "data-buildertype": "header",
        "content": "Deployment: {Name}",
        "size": "medium"
      }
    ],
    "style-marginBottom": "10px",
    "events": {}
  },
  {
    "key": "modalDiv",
    "data-buildertype": "container",
    "children": [
      {
        "key": "remarksModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "remarks",
                "data-buildertype": "input",
                "label": "Remarks",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-required": true,
                "transparent": false,
                "inverted": false,
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [],
                    "targets": [
                      "remarksModal"
                    ],
                    "parameters": []
                  }
                }
              },
              {
                "key": "button_1",
                "data-buildertype": "button",
                "content": "Submit",
                "primary": false,
                "secondary": true,
                "inverted": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "submitRemarks"
                    ],
                    "targets": [
                      "grid"
                    ],
                    "parameters": []
                  }
                }
              }
            ]
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      },
      {
        "key": "statusModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "dropdownStatus",
            "data-buildertype": "dropdown",
            "label": "Dropdown",
            "fluid": true,
            "selection": true,
            "data-elements": [],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setStatusAsync",
                  "gridRefresh"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            }
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      }
    ],
    "style-hidden": true,
    "events": {}
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/DataEditorDeploymentList"
              }
            ]
          }
        },
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Refresh",
        "secondary": false,
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
        "primary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": 200,
        "placeholder": "Enter case number to search.....",
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
                "value": "UID"
              }
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "events": {},
    "style-width": "100%"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": ""
      },
      {
        "key": "Form",
        "name": "Form",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 220
      },
      {
        "key": "PeerUID",
        "name": "Peer UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 120
      },
      {
        "key": "DateStart",
        "name": "Date Start",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": "datetime"
      },
      {
        "key": "DateComplete",
        "name": "Date Complete",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": "datetime"
      },
      {
        "key": "Remarks",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "name": "Remarks",
        "width": 120
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "type": "custom",
        "width": 120
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 120
      },
      {
        "name": "",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "key": "Actions2",
        "width": 120
      }
    ],
    "rowKey": "Id",
    "pageSize": "20",
    "pagerType": "server",
    "defaultSort": "UID ASC",
    "style-marginBottom": "20px",
    "multiselect": false
  }
]', [StructDivisionId]=NULL WHERE ([Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='4AF67164-5E60-4905-9885-AFD6DA24CB3D', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.407', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-01 23:57:01.840', [Data]=N'{
    init: function (args) {
        var innerArgs = args;
        args.data.remarks = null;
        //console.log(''init args'', args);
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-4].customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Remarks");
                };
                model.columns[model.columns.length-3].customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showStatusModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, p.value);
                };                
                
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    if(p.row.StatusCode==''PE''){
                        return CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, ''9731DE1D-2B6A-484C-BF10-44F842A3140E''), className: "ui button mini secondary" }, "Exempt");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Exempt");
                    }                
                    
                };        
                    
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                        return CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id), className: "ui button mini secondary" }, "Reset");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Reset");
                    }
                        
                };                     
                model.columns[1].customFormatter = function (p) {

                    
                    if(p.row.Type=="P"){
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));
                        
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else if(p.row.Type=="O"){
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }                    
                    

                };
            }
            return model;
        };

        var genFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);            
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var genFormLinkButtons = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
            var element = CloverApp.API.createElement("span", { onClick: () =>  {
                CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)
            }, className: "link-style" }, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };        
        var genOfflineFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = "/dataedit/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var getRemarksAsync = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/dataeditor/getremarks'';
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
                        //console.log("getRemarksAsync args", args);
                        args.component.state.data.remarks = response.item;
                        args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                        args.controlRef.refs.remarksModal.openModal();
                        args.component.refs.remarks.forceUpdate();
                        
                    return {
                        app:{
                            form: {
                                data: {
                                    modified:{
                                        remarks: response.item
                                    }
                                }
                            }
                        }
                    }; 

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });


        };

        var showModal = function (args, id) {


            return getRemarksAsync(args, id);

        };
        


        var showStatusModal = function (args, id) {
            //console.log(''showStatusModal args: '', args);

            args.state.app.extra.spData = id;
            

            var formData = new FormData();

            formData.append(''id'', id);        

            
            var url = ''/dataeditor/GetStatusItems'';
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
                        args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                                                                args.controlRef.refs.statusModal.props.swzData.isOpen = true;
                        args.controlRef.refs.statusModal.openModal();
                        args.controlRef.refs.dropdownStatus.forceUpdate();

                    } else {
                        alertify.error(response.message);
                        args.controlRef.refs.statusModal.close();
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                    args.controlRef.refs.statusModal.close();
                });

                

        };        

        var setStatus = function (args, id, statusId) {
            
            console.log("setStatus args: ", args)
            var formData = new FormData();
            formData.append(''id'', id);        
            formData.append(''selectedStatusId'', statusId);
            var url = ''/dataeditor/setStatus'';
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
                        args.component.refs.grid.refresh();
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            

        };  

        var resetStatus = function (args, id) {
            
            console.log("setStatus args: ", args)
            var formData = new FormData();
            formData.append(''id'', id);        
            var url = ''/dataeditor/resetStatus'';
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
                        args.component.refs.grid.refresh();     
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            
                
        };  
                

        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    },
    
    setStatusAsync: function (args) {
        //console.log(''setStatusAsync args: '', args);
        var id = args.state.app.extra.spData;
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        formData.append(''id'', id);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
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
                    args.component.refs.statusModal.close();
                    //args.controlRef.forceUpdate();
    
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    
    
    },
    submitRemarks: function (args) {
        var changeRemarksAsync = function (remarks, id) {
            var formData = new FormData();

            formData.append(''remarks'', remarks);
            formData.append(''id'', id);
            var url = ''/dataeditor/setremarks'';
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
                        alertify.success(response.message);

                        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
            
                args.component.refs.remarksModal.close();

        };

        let id = args.state.app.extra.spData;
        let remarks = args.data.remarks;
        changeRemarksAsync(remarks, id);

        return {


        };

    }

}
', [StructDivisionId]=NULL WHERE ([Id]='4AF67164-5E60-4905-9885-AFD6DA24CB3D');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='55831859-15D6-47CC-ACCD-FF632CDD1845', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.683', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-14 12:55:45.610', [Data]=N'[
  {
    "key": "headerDataEditorList",
    "data-buildertype": "header",
    "content": "Data Editor",
    "size": "huge",
    "subheader": "View a list of deployments under you",
    "style-marginTop": "10px"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "editorBarChart",
            "data-buildertype": "doughnutchart",
            "chartType": "doughnut",
            "datasetLabel": "",
            "legendPosition": "bottom",
            "responsive": true,
            "style-width": "500px",
            "style-source": "margin: auto;"
          },
          {
            "key": "refreshChart",
            "data-buildertype": "button",
            "content": "Refresh",
            "events": {
              "onClick": {
                "active": false,
                "actions": [
                  "updateBarChart"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "primary": false,
            "style-width": "100%",
            "style-source": "",
            "secondary": true,
            "compact": false,
            "style-hidden": true,
            "style-marginTop": "5px",
            "style-marginBottom": "5px"
          }
        ],
        "style-width": "50%",
        "style-marginTop": "1em"
      },
      {
        "key": "dictionary_1",
        "data-buildertype": "dictionary",
        "label": "Category",
        "fluid": true,
        "selection": true,
        "dataModel": "QNN_CATEGORY",
        "columns": "Name ASC",
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
        "style-width": "50%",
        "search": true,
        "clearable": true,
        "onChangeTimeout": "200",
        "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
      },
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "Filter",
        "fluid": true,
        "onChangeTimeout": "200",
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
        "labelPosition": "",
        "inverted": false,
        "transparent": false,
        "style-width": "50%"
      }
    ],
    "style-source": "",
    "style-marginBottom": "30px"
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
        "type": "custom",
        "width": 200
      },
      {
        "key": "StatusText",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 120
      },
      {
        "key": "Title",
        "name": "Questionnaire",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 200
      },
      {
        "key": "QnnType",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 70
      },
      {
        "key": "Category",
        "name": "Category",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "",
        "width": 120
      },
      {
        "key": "Responses",
        "name": "Responses",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 120
      },
      {
        "key": "DateEnd",
        "name": "Date End",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": 120
      }
    ],
    "editForm": "QNN_DPLY_SAMPLE_INFO",
    "multiselect": false,
    "pagerType": "",
    "defaultSort": "CreatedDate ASC",
    "autoHeight": false,
    "offSet": "",
    "rowKey": "Id",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [
          "gridRefresh"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-customcss": "",
    "style-source": "",
    "pageSize": "20",
    "minHeight": "200px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='55831859-15D6-47CC-ACCD-FF632CDD1845');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='774BF1E8-60A0-44F9-B942-478CB9ECB120', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.560', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-02 00:00:34.107', [Data]=N'{
    viewArgs: function(args){
        //console.log(''View Args'', args);    
    },
    
   /* updateBarChart: function (args){
        
        console.log("Update Bar Chart!");
        var count = args.component.refs.grid.state.rowsCount;
        var counter = 0;
        var gridData = args.component.refs.grid.state.items;
        
         for(var i=0; i<gridData.length;i++){
        if(gridData[i].RespCount == gridData[i].SampleCount){
            counter++;
        }
    }
    
    var editorLabel = [''Total Deployment'',''Completed Deployment''];
    var barData = [count,counter];
    
    console.log("count is", count);
     var value = {
                        labels: editorLabel,
                        datasets: [
                          {
                            data: barData,
                            backgroundColor:["#1362E2","#ff2052"],
                            label: "Count",
                          }
                        ]
                    };
        CloverApp.API.setDataField("editorBarChart", value);
        
        },*/
    
  init: function (args){
      
    //console.log(''Data Editor'', args);  
    var gridModelRewriter = function (model) {
        if(Array.isArray(model.columns) && model.columns.length > 2){
            model.columns[0].customFormatter = function(p){ 
                var url = "/form/DataEditorDeployment/" + p.row.DplyId;
                //return CloverApp.API.createElement("a", { href: url}, p.value);  
                //return "<a href=''www.google.com''>" +p.value+ "</a>";
                return CloverApp.API.createElement("span", { onClick: () =>  {
                                CloverApp.API.redirect(''form'', ''DataEditorDeployment'', p.row.Id)
                            }, className: "link-style" }, p.value);                
            };
        }
        return model; 
    };
    CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    
    var count = args.component.refs.grid.state.rowsCount;
    var counter = 0;
    var gridData = args.component.refs.grid.state.items;
    
    for(var i=0; i<gridData.length;i++){
        if(gridData[i].RespCount == gridData[i].SampleCount){
            counter++;
        }
    }
    
    var editorLabel = [''Total Deployment'',''Completed Deployment''];
    var barData = [count,counter];
    
     var value = {
                        labels: editorLabel,
                        datasets: [
                          {
                            data: barData,
                            backgroundColor:["#1362E2","#ff2052"],
                            label: "Count",
                          }
                        ]
                    };
        CloverApp.API.setDataField("editorBarChart", value);
        CloverApp.API.setDataField("originalCount", value);
     
    
  }
}
', [StructDivisionId]=NULL WHERE ([Id]='774BF1E8-60A0-44F9-B942-478CB9ECB120');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='736DB1D2-47C6-4DAF-B3CC-4D49A5BEA55F', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.617', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-14 12:55:45.680', [Data]=N'{
  "isSurvey": false,
  "name": "DataEditorDeploymentList",
  "lastUpdate": "2019-08-14T12:55:45.667872+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "c4514110-9480-5f81-da9b-554de3d0ee8a",
      "entityId": "6a831ca7-cff1-45bd-9125-ff8aa539e5dc",
      "filter": "FilterAsyncFieldsAndStruct",
      "parameter": "{userId: \"@CurrentUserId\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "26bedfb2-eb2a-ad98-369d-175f1904ae40",
          "attributeId": "07c8cf9b-89d5-4825-bb30-71e087e8b371",
          "control": "Category",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb7e8bb-e202-83e6-eb0e-fd86128d9e25",
          "attributeId": "12882549-c63b-4bb9-8411-34003b2228fc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "56773340-b9ac-8094-3608-7bd20339bb8c",
          "attributeId": "b3f92a74-318b-46f8-964c-e99c6b3ce1a6",
          "control": "DateEnd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b8a26c93-c68a-6039-40ef-a7b4df36e9ee",
          "attributeId": "662161e7-61ac-4caa-b5bf-a94e36f99b05",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f3aef91-5da9-5cf0-b777-00773788fb32",
          "attributeId": "117475f3-1979-4047-922b-751e725aa220",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6099ee9f-5f28-00e6-662c-7a06c3319740",
          "attributeId": "a5175ebf-3842-483d-99cc-23479501c082",
          "control": "Responses",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b97b27d0-a407-d9da-5786-6bc2b718f678",
          "attributeId": "e4488721-c14a-4001-9f86-95547b4fef49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb6e78e-50df-49b5-4fe9-ce95827f2a2e",
          "attributeId": "14b1108f-a4cf-4154-b5af-9e943bc7825a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b8feb4-a967-27cc-7009-dd7262910160",
          "attributeId": "9a6b8e15-a962-4512-84fc-906fa79f0ba6",
          "control": "StatusText",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ea662025-1336-29ff-bcde-32326d1e691a",
          "attributeId": "be433204-7b5e-4d48-acd2-bab9ceba06b6",
          "control": "Title",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "074f3cb1-dbbf-51f3-2071-d9f313936f53",
          "attributeId": "560b916d-7b92-43cc-87a2-25eebe01b04e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8876b77d-a26e-e81f-3e6e-99af1a68b2e3",
          "attributeId": "f75b7c08-2bbf-453e-acff-46dfb6d90ca7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8a856b69-f546-70a2-504d-fef8614ca005",
          "attributeId": "4def3ea4-668b-4dfd-9c7f-871eb1e461ff",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f18e44c-2f48-8875-bd41-f97f3976f5ce",
          "attributeId": "ce8b4c4e-43fc-42af-acdf-d1dc9530092b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "793dffa5-906c-7261-b5f5-11656313e10f",
          "attributeId": "3698003c-ad9d-4014-a4d5-dfe14418e377",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "210caea8-d5ab-366c-bab2-08ec967829ff",
          "attributeId": "7b42a4f1-8da8-4e10-aee0-8db424b6d16c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f257d4b5-4127-42ac-c6f2-4e59832b4ebb",
          "attributeId": "b57fb1aa-5502-418c-94cc-0365fbd5cbb0",
          "control": "",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60f68dfb-d1f3-9c2e-8959-924025772f63",
          "attributeId": "bb884c00-d4b4-4d8b-83c5-a2c424a220db",
          "control": "QnnType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ce5ea0e4-e19c-a816-ab23-e2d3fb821c09",
          "attributeId": "77adabcb-6e75-4100-b589-873557998506",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "DataEditor"
}', [StructDivisionId]=NULL WHERE ([Id]='736DB1D2-47C6-4DAF-B3CC-4D49A5BEA55F');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='65E99B1A-44C8-47CF-94F3-E96A73E3F9FD', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.457', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-23 02:21:00.477', [Data]=N'{
  "isSurvey": false,
  "name": "DataEditorDeployment",
  "lastUpdate": "2019-08-23T02:21:00.4774679+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "dd2b1de1-8906-5440-a0b1-02b52ae0b7bb",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "af0b83d4-7938-1792-7467-8cda8561fe59",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a586de72-847a-a985-3629-7e51539d4a84",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "734db879-1d82-c264-1027-f30a57b9b67a",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "34836eb8-15f1-34ec-ab1c-e0e535f12a9d",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dae432fc-ec82-a8f2-03d7-7b3b4495fdb5",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e51fde7-57db-97cb-44b5-43b57a7b2c7a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "799e556b-61ce-1fc4-4d1a-7dfecd1a571c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ec6ab480-72d9-4e70-8ae5-e9fa27776491",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1e4706d9-3dda-13d2-cbae-ba3192c4c478",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1af8c09f-a1a6-e6d2-68ca-5a2aff87db30",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8b3d96dc-a807-1e6b-281a-e9fd87c0c595",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a681a21-7ea6-fbdc-76c4-57adf19cd9be",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "45cc1a58-9465-85b9-733b-e35726bbe246",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14d66d-44b0-635d-b9cd-0586f86baca2",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "11709f94-f671-f1ef-9d2c-80c5a1411442",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2186040a-20a9-baa7-7aa7-dac44246641e",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29f312d4-dc1a-a3e3-f4b0-5b28f3125567",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039caea8-8b26-54a3-c82b-9d71aa0a285c",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039280c8-f268-964d-101a-4fc229a524d1",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "88d5edc3-9d2d-958d-fcd3-0dc260e95f00",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "348b6b76-a181-c3d8-10c3-64dccfcfb5c8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6b22e96c-497f-5dd8-f4d5-5451e39e1ed7",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c937d26-b286-4818-87c2-64ca646c0b09",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dd5554b7-3553-c9fc-c472-47b7ae764ae9",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1df3b42b-b6a3-bda3-e867-cf6e5ff6c146",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb3c783b-89c2-6c2a-cc11-b1a2bb3eb729",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "aa7f5eac-b5d0-45b2-a883-37af1e8c90b0",
      "entityId": "fe42f73b-dd23-468f-abce-7603be873b15",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{UserId: \"@UserId\", DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "ca856a82-8cf7-94e5-6a63-be0112a9de69",
          "attributeId": "5068b642-c419-4e66-9cb6-4c499f8fbf98",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac9a5899-a4ab-a832-2458-bbbe9297800e",
          "attributeId": "9839c5ec-1da6-4480-b4a4-dfcd0d8c7ee3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ec5edf34-3b0b-5c28-4a65-def784054037",
          "attributeId": "bc9ea8c1-8e42-46c1-a307-20bd1f16425c",
          "control": "DateComplete",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1cc6738a-1af6-a23b-389f-398c8fd7358f",
          "attributeId": "29955168-38dc-4bc4-9d09-51936f0c47a3",
          "control": "DateStart",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db11567c-09c6-2bea-b6d5-5d66ed18ea9a",
          "attributeId": "5092b667-2bd3-4e5c-901d-af0c08ab963f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07b46b6f-2327-8fa4-ad8b-1b372074f71f",
          "attributeId": "eae438a7-c933-4cf4-901f-9afe4676b5d2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29992aa5-ff10-8f3f-3496-af3af7c8c049",
          "attributeId": "3f32683a-0b73-4487-8f9f-bcf67f4cd3de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0af2ce3e-6c33-6c1a-02fb-adacf28ccf1e",
          "attributeId": "12b9130f-5b30-4de6-b1b3-9c87eb24b51b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9e3e3241-0ed5-991c-ceed-8a7e7dfa36e9",
          "attributeId": "8de04fab-6501-4963-9be1-d94e4e17bdad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e7862e2-a88f-65b7-a22f-0bd5d69b4126",
          "attributeId": "cb449047-fd1f-4877-a9e8-31ff27e3522d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc699a02-923f-17fb-c75b-fa4317cad04d",
          "attributeId": "e309b993-a4fc-4646-bed1-901028f4e701",
          "control": "PeerUID",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99668211-09a4-a2ff-025b-712f80a76e84",
          "attributeId": "194b29f5-61d7-4e19-9bff-61b7d63a59bc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df75d4b6-1b24-8491-608f-65eb8e83b7a6",
          "attributeId": "bdd2c1e8-5fcc-425e-961a-902bb6a04b1b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20fb1a1a-4568-05f7-191a-5f7fe80c5e11",
          "attributeId": "6334a04c-beac-457e-a52c-6321f8eee654",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0333e9e4-2539-eea0-3fe5-469f369b162e",
          "attributeId": "5d21fa68-625e-47f7-8b04-7e2407cb6833",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbfc2be2-151c-fa31-134e-29e1565630d0",
          "attributeId": "ea09352e-57ba-4d9b-a1dc-c46e0f9d35a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d27dcbe-d8c3-9339-9c82-22c664862417",
          "attributeId": "a3a11c9c-b29d-409b-8bec-45da88c5d7cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9497d95-641b-128d-fb42-8ab57b7037e3",
          "attributeId": "cb1b05c3-930a-4336-82a3-8fcf1d5d03be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ecb61b0-5e91-a2c7-f3d2-9fafb61d274a",
          "attributeId": "e119a97f-3f94-4359-bf02-550c2523f58e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ba5e855-c142-3291-a47c-3e5f269c0371",
          "attributeId": "2f9a77cf-0afc-413a-abe5-8268e56c8f3b",
          "control": "StatusTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "856b1e54-6028-b354-5bca-6f9f8aafb1f0",
          "attributeId": "37e6a978-a4c0-401b-8541-c3d0185eaefc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bf4af0d-2c41-be37-d27f-6564ff0ed821",
          "attributeId": "2416c808-79fd-45b8-b9ea-09ff66b261dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "13251d44-0af1-64f2-e53d-93e100122acc",
          "attributeId": "a8718f73-4e80-49af-9b33-2437cfbccfd9",
          "control": "UID",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47c01363-0e02-128d-6836-b43901d62d8c",
          "attributeId": "e62abbfa-5e05-45f0-a59d-d25f0a90e47a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa72e2c4-3908-eca1-c269-5ca4628df44b",
          "attributeId": "93d1e6f3-e3da-46c6-8da2-f145da19c67e",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='65E99B1A-44C8-47CF-94F3-E96A73E3F9FD');


UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='4BEF2440-7B11-4D01-B795-09EE58ED0F65', [Folder]=N'metadata/forms', [Filename]=N'AuditTrail.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-08-22 17:06:51.123', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-29 14:29:47.190', [Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Trail",
    "size": "medium",
    "subheader": ""
  },
  {
    "key": "staticcontent_1",
    "data-buildertype": "staticcontent",
    "content": "Filters you can use: Event Date (between Start and End filter), Table Name, Event Type, User Name or Sample Name"
  },
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
            "key": "input_1",
            "data-buildertype": "input",
            "label": "Start",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime",
            "placeholder": "Select Event Start",
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
                    "value": "EventDate"
                  },
                  {
                    "name": "term",
                    "value": ">="
                  }
                ]
              }
            }
          },
          {
            "key": "input_2",
            "data-buildertype": "input",
            "label": "End",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime",
            "placeholder": "Select Event End",
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
                    "value": "EventDate"
                  },
                  {
                    "name": "term",
                    "value": "<="
                  }
                ]
              }
            }
          }
        ]
      },
      {
        "key": "formgroup_1",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "dictionary_1",
            "data-buildertype": "dictionary",
            "label": "Table Name",
            "fluid": true,
            "selection": true,
            "columns": "TableName ASc",
            "dataModel": "vSP_auditlog_TableName",
            "placeholder": "Select Table Name",
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
                    "value": "TableName"
                  },
                  {
                    "name": "term",
                    "value": "="
                  }
                ]
              }
            },
            "clearable": true
          },
          {
            "key": "dictionary_2",
            "data-buildertype": "dictionary",
            "label": "Event Type",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_auditlog_EventType",
            "placeholder": "Select Event Type",
            "multiple": false,
            "columns": "EventType ASc",
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
                    "value": "EventType"
                  }
                ]
              }
            },
            "clearable": true
          }
        ]
      },
      {
        "key": "formgroup_3",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "input_3",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "placeholder": "Search by name...",
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
                    "value": "UserName, SampleName"
                  }
                ]
              }
            }
          }
        ]
      }
    ],
    "style-customcss": "ui message"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UserName",
        "name": "User Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "SampleName",
        "name": "Sample Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "TableName",
        "name": "Table Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 300
      },
      {
        "key": "EventType",
        "name": "Event Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "EventDate",
        "name": "Event Date",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": 200
      }
    ],
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
    "rowKey": "Id",
    "pageSize": "5",
    "defaultSort": "EventDate DESC",
    "pagerType": "server",
    "editForm": "AuditLog"
  }
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='4BEF2440-7B11-4D01-B795-09EE58ED0F65');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='821D5319-793C-4B0E-AA09-6AF302B3A6FD', [Folder]=N'metadata/forms', [Filename]=N'AuditTrail-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-08-22 17:06:51.527', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-29 14:32:02.720', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2019-08-29T14:32:02.691633+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "1897ec65-fe7e-402c-9974-72cb9342dc93",
      "filter": "StructDivisionFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "f526573f-a62b-95bf-346d-a06b92c76e12",
          "attributeId": "2e21e8b9-1e90-40d2-938d-fa726da87038",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a4b657e-689b-3949-6603-0e8f7ca9d932",
          "attributeId": "5869778c-89cd-45e3-a8c9-1747167f61ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dbb0c63c-0add-af05-d51c-6f1954b43e88",
          "attributeId": "6fdec3d4-8a48-43fb-9807-0d64a49aaa5a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c24d08c2-9e1d-c3a3-d382-3b500d7315db",
          "attributeId": "93c7731d-b893-4f18-937d-8673d9a3d9d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99f2df97-0581-8476-9500-196bac947e9f",
          "attributeId": "1b453bce-5bbd-4b45-b8f1-4c9afdb576a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "854e614d-e2d2-f068-0451-ca6d082526f4",
          "attributeId": "b33e2ad5-9c76-431c-b50a-e453b5d8aaa2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "de952a18-0e0f-d80f-79b2-1fbf553e9440",
          "attributeId": "4b11d200-6a61-49e1-858b-2982112da95b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd375f77-d340-3f74-9536-d0aacfe6723c",
          "attributeId": "da3da2f2-bd77-4e9a-8fba-c6d4483a9584",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "902168a9-f82f-101f-693c-404998ef8dc7",
          "attributeId": "af9dde32-9a6b-492c-92f3-60c83fb265a9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8d37cede-a164-5b87-aa5f-da6a6af47662",
          "attributeId": "8dad216f-5cc9-4016-ab61-3fe57901d512",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "806238de-71c0-4559-b966-2c3961a6c40a",
          "attributeId": "a9de8a50-ab77-4dec-91c4-de47a7830a36",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "194b747f-eeb2-5057-9d53-22b18c2d0926",
          "attributeId": "fbd8712c-47f7-4afb-8b12-c797387526fa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "caec513c-67e8-7961-fbbd-cae28b5edfd9",
          "attributeId": "bccbce8c-3484-4adf-a64f-f75d51d2bb4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a6f4e69e-1ace-66d5-d950-0978267890ab",
          "attributeId": "ecc77617-4bb7-4b61-9068-ce1b37f9613f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9f58858c-024e-e39b-38c2-2d5de0b26d34",
          "attributeId": "02ef86df-c080-48bf-b367-52a01206593f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "434e038b-7ae1-2cca-cd28-4e8f8998c155",
          "attributeId": "4ffa7632-4275-4f08-ac6b-8d8d19a8f481",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21d3c8e7-0014-f592-d1c0-7cf6e0718339",
          "attributeId": "056a5a07-7305-4c7b-ad84-6e83a5961e0d",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='821D5319-793C-4B0E-AA09-6AF302B3A6FD');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='55636648-E5A4-4002-9F59-D597FD167C04', [Folder]=N'metadata/forms', [Filename]=N'sidemenu.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.540', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-10 07:00:58.503', [Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "/form/SwzQnnList",
        "title": "Questionaires",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true",
        "children": [
          {
            "title": "Survey Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')==true"
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
          }
        ]
      },
      {
        "target": "/form/SwzListList",
        "title": "List",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/SwzDplyList",
        "title": "Deployment",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "title": "Data Editor",
        "target": "/form/DataEditorDeploymentList",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')==true"
      },
      {
        "title": "Category",
        "target": "/form/SwzCategoryList",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/organizations",
        "title": "Organizations",
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "title": "Respondent Content Management",
        "target": "/form/SwzRespAdminList",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "target": "/useradmin",
        "title": "Security",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/audittrail",
        "title": "Audit Trail",
        "visibleCondition": "\t CloverApp.API.checkRole(''Admins'')==true"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "redirect"
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
    "other-visibleConition": ""
  }
]', [StructDivisionId]=NULL WHERE ([Id]='55636648-E5A4-4002-9F59-D597FD167C04');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='40ADD745-91D0-4122-A158-8CABF9712CD2', [Folder]=N'metadata/forms', [Filename]=N'sidemenu-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.447', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-04-01 14:14:43.287', [Data]=N'{
//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
//    var errors = {};
//    //TODO: Insert your code for validation this form
//    if(data.name == undefined || data.name == ''''){
//      errors.name = ''This field is requered!'';
//    }
//    if(errors.name){
//      throw {
//          level: 1,
//          message: ''Check errors on the form!'',
//          formerrors: {main: errors}
//      };
//    }
//    return {};
//  }
    onItemClick: function(args) {
        // console.log(args);
    },
    init: function(args) {
       // console.log(args);
        return {
            component: {
                refs: {
                    sidemenu: {
                        props: {
                            "data-items": [],
                        }
                    }
                }
            }
        };
    }
}', [StructDivisionId]=NULL WHERE ([Id]='40ADD745-91D0-4122-A158-8CABF9712CD2');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A', [Folder]=N'metadata/forms', [Filename]=N'sidemenu-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.490', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-10 07:00:58.750', [Data]=N'{
  "isSurvey": false,
  "lastUpdate": "2019-09-10T07:00:58.7441272+08:00",
  "isTemplate": false
}', [StructDivisionId]=NULL WHERE ([Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A');


GO

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='F5168E8B-50FC-442B-AD6D-3E225324BD0E', [Folder]=N'metadata/forms', [Filename]=N'AuditLog.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-08-28 17:35:29.610', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-29 11:50:31.763', [Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Log Item Details",
    "size": "medium"
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
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Back",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirect"
                ],
                "targets": [],
                "parameters": [
                  {
                    "value": "/form/audittrail",
                    "name": "target"
                  }
                ]
              }
            },
            "secondary": true,
            "toggle": true,
            "floated": "right"
          },
          {
            "key": "Id",
            "data-buildertype": "input",
            "label": "Id",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Division",
            "data-buildertype": "input",
            "label": "Division",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "LoginId",
            "data-buildertype": "input",
            "label": "Login Id",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined",
            "events": {}
          },
          {
            "key": "UserName",
            "data-buildertype": "input",
            "label": "User Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined"
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "Sample UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined"
          },
          {
            "key": "SampleName",
            "data-buildertype": "input",
            "label": "Sample Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined"
          },
          {
            "key": "EventType",
            "data-buildertype": "input",
            "label": "EventType",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "TableName",
            "data-buildertype": "input",
            "label": "TableName",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "RecordId",
            "data-buildertype": "input",
            "label": "RecordId",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "ColumnName",
            "data-buildertype": "input",
            "label": "ColumnName",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "EventDate",
            "data-buildertype": "input",
            "label": "EventDate",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "OriginalValue",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "{OriginalValue}",
                    "fetchData": false,
                    "events": {},
                    "style-customcss": "custom-label",
                    "isHtml": false,
                    "isPre": true
                  }
                ]
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_3",
                    "data-buildertype": "staticcontent",
                    "content": "New Value",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "{NewValue}",
                "isHtml": false,
                "isPre": true
              }
            ]
          }
        ],
        "placeholders": {
          "customblock_1": []
        }
      }
    ]
  }
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='F5168E8B-50FC-442B-AD6D-3E225324BD0E');

GO

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='ADF598E9-17A9-4B69-BFA2-CD7B938D2472', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST_SAMPLE-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:22.433', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-12 15:46:48.530', [Data]=N'{
   init: function (args){
        var getParameterByName = function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '''';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        };
        var getListId = function() {
            var url = window.location.href;
            var parts = url.split(''/'');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };        
       return () => {
           var listId = args.data.DictionaryListName
           var url = ''/list/genListprop/'' + listId+ ''/'' + args.data.Id;
           if(args.data.Id==undefined || args.data.Id==null){
               //listId = getParameterByName(''listId'');
               listId = getListId();
               url = ''/list/genListprop/'' + listId+ ''/''
           }
           if(listId==null || listId==undefined) return Promise.resolve();
           
           return fetch(url)
            .then(function(response) {
                return response.json();
               })
            .then(response => {
                if (!response.success) {
                    return {};
                }
                var item = JSON.parse(response.item);
                if(args.data.Id==undefined || args.data.Id==null) item.data[''DictionaryListName''] = listId;
                if(item.model.length==0) return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: {
                                            DictionaryListName: listId
                                        }
                                    }
                                },                                
                                
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                ); 
                args.state.app.form.models.model[0].children[0].children[5].source =JSON.stringify(item.model);  

                var readOnlyArray = args.state.app.form.models.readOnlyControls;
                var rule = item.rule;
                for (var key in rule) {
                
                    if(rule[key]["readOnly"] =="true"){
                        readOnlyArray.push(key);
                    } 
                }                  
                
                return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: item.data
                                    },
                                    models:{
                                        readOnlyControls: readOnlyArray
                                    }
                                },
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                );             
                
            }
            )
            .catch(function(ex) {
                //alertify.error("");
            });
        };
       
       
       
   },
   
    saveProp: function(args){

        var data = args.state.app.extra.spData.data;
        var model = args.state.app.extra.spData.model;
        var rule = args.state.app.extra.spData.rule;
        
        if(model.length>0){
            var hasError = false;
            var errors = {main: {}};    
            var messages = [];
            if(args.data["dictionarySample"]==null || args.data["dictionarySample"]=="00000000-0000-0000-0000-000000000000") {
                hasError = true;
                messages.push("Sample is required");
                errors.main["dictionarySample"] = true;
            }
            
            for (var key in data) {
                //if (data.hasOwnProperty(key)) {
                //    data[key] =  $("input[name=''"+key+"''], textarea[name=''"+key+"'']").val();
                //    args.data[key] = data[key];
                //}
                if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                    hasError = true;
                    messages.push("<br />" + key + " is required");
                    errors.main[key] = true;
                    //errors.ADDRESS1 = key + " " + "required";
                    //args.state.app.form.errors.main = {ADDRESS1: true};
                    //$("input[name=''"+key+"''], textarea[name=''"+key+"'']").parent().addClass(''error'');
                }
                
                if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                    
                    let funcArgs = ''value, data'';
                    let body = ''return '' + rule[key]["txtRegExp"];
                    let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                    if (typeof isValid === ''boolean''){
                        if (isValid === false) {
                            hasError = true;
                            messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                            errors.main[key] = true;
                        }
                    }
                    else{
                        error = isValid;
                    }
                    
    
                }            
                
            }
            //args.component.forceUpdate();
            //console.log("saveProp args: ", args);
            if(hasError){
                throw {
                    level: 1,
                    message: messages,
                    formerrors: errors
                };
            }
            
        }

        return ()=> {
        var listSampleId = args.data.Id;
        var listId = args.data.DictionaryListName;
        var formData = new FormData();
        formData.append(''listSampleId'', listSampleId);
        formData.append(''listId'', listId);        
        formData.append(''listSampleProp'', JSON.stringify(args.data));
        var url = ''/list/savelistprop'';
        return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success("List sample changed");
                    CloverApp.API.redirectToForm(''QNN_LIST'',response.item);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
           
        };
     },
   
      goBack: function(args) {
        args.state.router.history.goBack();
    },
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}', [StructDivisionId]=NULL WHERE ([Id]='ADF598E9-17A9-4B69-BFA2-CD7B938D2472');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='C7D7BD7E-1766-4AB2-81F4-2A69A3B3D082', [Folder]=N'metadata/forms', [Filename]=N'QNN_LIST-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.910', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-12 16:19:54.603', [Data]=N'{   
    init: function(args){
        //console.log("inint" , args);
    }, 
    
    deleteListSample: function(args){
    
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
            
        }

        var listId = args.data.Id;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        var formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/list/deletelistsample'';
    
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
                    alertify.success(response.message);
    
                } else {
                    alertify.error(response.message);
                }
    
            })
            .catch(error => {
                alertify.error(error.message);;
            });        
    
    
    },   
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    exportSample: function (args){
        var url = ''/list/exportsample?listId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,                                  
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'']
                  }
              }
            }
        }        
        
    },
    
   submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                    CloverApp.API.setDataField("inputImportListSample", null);
                    CloverApp.API.setDataField("inputPassword", null);
                    args.component.refs.gridviewSample.refresh();
                    //CloverApp.API.setDataField("sampleAddedCount", response.statistics.sampleAdded);
                    //CloverApp.API.setDataField("sampleUpdatedCount", response.statistics.sampleUpdated);
                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.listSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.listSampleUpdated);    
                    return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    models: {
                                        hideControls: []
                                    }
                                }
                            },

                            
                        }
                    });   
  
               
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);;
            });
 
        };
            
         

    }, 
    
    dbExport: function(args){
        
    var downloadLink = document.createElement("a");
    var csv2 = "Email,ActiveYN,Name,NumRetry,Pwd,Mat@yahoo.com,TRUE,Mat Tan,34,5566,anthony@yahoo.com,TRUE,Anthony Chew,35,5566,John ,TRUE,John ,36,5566,Cathy,TRUE,Cathy,37,5566,zBenedict,TRUE,zBenedict,38,5566,zJane,TRUE,zJane,39,5566";
   
    var json = csv2;
    var fields = Object.keys(json[0])
    var replacer = function(key, value) { return value === null ? '''' : value } 
    var csv = json.map(function(row){
      return fields.map(function(fieldName){
        return JSON.stringify(row[fieldName], replacer)
      }).join('','')
    })
    csv.unshift(fields.join('','')) // add header column
    
    console.log(csv.join(''\r\n''))
    
    console.log(csv)

      var blob = new Blob(["\ufeff", csv]);
      var url = URL.createObjectURL(blob);
      downloadLink.href = url;
      downloadLink.download = "data.csv";

      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    },
    
    dbImport: function(args){
      
       var csvdata = args.component.refs.swzimport_1.state.csvdata;
       var datamodel = "QNN_LIST"
        if (csvdata == null) return alertify.error("Please choose a file!")
        var csvDataCount = csvdata.length;
        var oldData = args.state.app.form.data.modified;
        var newData = {};
        newData[''collectioneditor_sample''] = JSON.stringify(csvdata);
        var formData = $.extend(true,oldData,newData);
    
        var url = ''/SwzData/change?name='' + datamodel;
        var formDataString = JSON.stringify(formData);
        var msg = alertify.success("Loading...");

      $.post(url,{data: formDataString}).done(function (data) {
            
        if(data.success){
            var msg = csvDataCount + " respondents have been created"
              
            alertify.success(msg) ;
            console.log("response Json", data);
            console.log(args.state.app.form.data.modified.__collectioneditor_sample_totalcount);
               
               return {
                          app: {
                              form: {
                                  data: {
                                      modified: {
                                         __collectioneditor_sample_totalcount:csvDataCount
                                      }
                                  }
                              }
                          }
                      }
        }
        else {
            alertify.error(data.message);
            console.log(data.message);
            console.log(data);
        }
}).fail(function (jqxhr, textStatus, error) {
       alertify.error(textStatus);
    }); 
    return {};
      
    },
    
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
        //window.location.href = ''/form/QNN_LIST_SAMPLE?listId='' +args.data.Id;
        //return {
        //    router :{
        //        push: ''/form/QNN_LIST_SAMPLE/listId/'' +args.data.Id
        //    
        //    }
        //}
         CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id)

    },

    
    
    goReview: function(args){

        var userId = args.data.Id;
        console.log("userid is" , userId);
        var form = ''/form/swzreviewlist/'';
        var userReview = form + userId;
        
    if (userId !== undefined ){    
       return {
                router :{
                    push: userReview
                
                }
            }
        
        }
    },
    
    listExport: function(args){
        console.log("list export")
        var modelArray = args.state.app.form.models.model; //The whole model series
        var oldModal = args.state.app.form.models.model[3].children[0].children[1].children[1].children[0].children[0].children[2].children[0];
        
        var jsonData = args.component.refs.collectioneditor_sample.state.data;
        console.log(jsonData);
          
        var newModal = {''content'': "Export", ''data-buildertype'': oldModal[''data-buildertype''], ''key'':  oldModal[''key''], ''secondary'': true, ''size'': "" ,''jsonData'': jsonData}

        console.log(''new model'', modelArray);
        console.log(''old model'', oldModal);
        
        modelArray.splice(1,1,newModal); //Replace item in whole model series
    
          return {
              app: {
                  form: {
                      models: {
                         model: modelArray
                        }
                      }
                  }
            }
        
    },
    
    
    listImport: function (args){
      console.log("View CSV DATA")
        console.log(args);
//      console.log(args.component.refs.swzimport_1.state.csvdata);
        var csvdata = args.component.refs.swzimport_1.state.csvdata;
        console.log(csvdata);
        if (csvdata === undefined || csvdata === null ){
            console.log("include file");
          alertify.error("Please, include CSV file for import!");
        }
        else if (csvdata !== undefined || csvdata !== null ){
            console.log("all undefined")
             return {
                  app: {
                      form: {
                          data: {
                              modified: {
                                  collectioneditor_sample:csvdata
                              }
                          }
                      }
                  }
              }
        }
        
    },
        
    closeModal: function (args){
        //CloverApp.API.setDataField("inputImportListSample", null);
        //CloverApp.API.setDataField("inputPassword", null);
        //CloverApp.API.setDataField("sampleAddedCount", null);
        //CloverApp.API.setDataField("sampleUpdatedCount", null);
        //CloverApp.API.setDataField("listSampleAddedCount", null);
        //CloverApp.API.setDataField("listSampleUpdatedCount", null);   
        //args.state.aop.forms.models.hideControls = [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headListSampleUpdated'']
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
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,                                  
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'']
                  }
              }
            }
        }       
    }
}', [StructDivisionId]=NULL WHERE ([Id]='C7D7BD7E-1766-4AB2-81F4-2A69A3B3D082');

GO

----------------------------------------------------

	CREATE PROCEDURE [dbo].[spSP_DeleteRespAnsByIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime
	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO AuditLog 
			(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
		SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_RESP_ANS 
		where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

		delete from QNN_RESP_ANS where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 



	END
	
GO

----------------------------------------------------

	CREATE PROCEDURE [dbo].[spSP_DeleteSampleOwnerByIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime
	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO AuditLog 
			(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
		SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Delete', @TableName, null, null,(select * from QNN_DPLY_SAMPLE_OWNER 
		where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

		delete from QNN_DPLY_SAMPLE_OWNER where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 


	END
	
GO