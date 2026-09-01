-- Will UPDATE existing row(s) in dwMetadata for the following:
-- RespondentParticipationReport.json
-- RespondentParticipationReport-settings.json
-- RespondentParticipationReport-code.js

UPDATE [dwMetadata] SET
[Id]='ce0356a5-09ff-4fc3-b838-b09ef6c81b8a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 12:37:25.427', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-04-24 17:14:36.773', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Respondent Participation Report",
    "size": "huge"
  },
  {
    "key": "form_2",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "UID",
                "data-buildertype": "input",
                "label": "UID",
                "fluid": true,
                "onChangeTimeout": 200,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "RespName",
                "data-buildertype": "input",
                "label": "Respondent Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "reference": "Respondent Name",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ]
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "Status",
                "data-buildertype": "dictionary",
                "label": "Status",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_STATUS",
                "columns": "Title, NumberId ASC",
                "placeholder": "Select Status",
                "multiple": true,
                "clearable": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "DeploymentName",
                "data-buildertype": "dictionary",
                "label": "Deployment Name",
                "fluid": true,
                "selection": true,
                "reference": "Deployment Name",
                "dataModel": "QNN_DPLY",
                "filters": "[{ column : \"StructDivisionId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                "placeholder": "Select Deployment Name",
                "columns": "Name ASC, Id",
                "multiple": true,
                "clearable": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-width": "100%"
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "actionAddAllStatus",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Add All Status",
                    "url": "/"
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "actionAddAllFields"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-source": "margin:5px;"
              },
              {
                "key": "actionRemoveAllStatus",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Remove All Status",
                    "url": "/"
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "actionRemoveAllFields"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-source": "margin:5px"
              }
            ],
            "style-marginTop": "-15px",
            "style-marginBottom": "10px"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "ddIncludeTags",
                "data-buildertype": "dropdown",
                "label": "Include Tags",
                "fluid": true,
                "selection": true,
                "data-elements": [],
                "placeholder": "Select Include Tags",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-visibleConition": "",
                "multiple": true
              },
              {
                "key": "ddExcludeTags",
                "data-buildertype": "dropdown",
                "label": "Exclude Tags",
                "fluid": true,
                "selection": true,
                "data-elements": [],
                "placeholder": "Select Exclude Tags",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-visibleConition": "",
                "multiple": true
              }
            ]
          }
        ]
      },
      {
        "key": "btnExport",
        "data-buildertype": "button",
        "content": "Export",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "onExport"
            ],
            "targets": [],
            "parameters": []
          }
        }
      }
    ]
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "uid",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "respondentName",
        "name": "Respondent Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "name",
        "name": "Deployment Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "status",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "statusDate",
        "name": "Status Date",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "tags",
        "name": "Tags",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false
      }
    ],
    "defaultSort": "Name ASC",
    "pagerType": "",
    "pageSize": "10",
    "editFormShowType": ""
  }
]' WHERE [Id]='ce0356a5-09ff-4fc3-b838-b09ef6c81b8a';

UPDATE [dwMetadata] SET
[Id]='6dbdbfc3-9969-4847-b2a5-3394bfa75853', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 12:37:25.483', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-04-24 17:14:36.787', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "RespondentParticipationReport",
  "lastUpdate": "2023-04-24T17:14:36.7873841+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [],
  "securityGroup": "Reports"
}' WHERE [Id]='6dbdbfc3-9969-4847-b2a5-3394bfa75853';

UPDATE [dwMetadata] SET
[Id]='4d879db0-1a88-4b78-80f7-03229fb983b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 13:38:21.357', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-04-25 16:31:10.673', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
        
        //Grid Custom Column
        const tagsColumnFormatter = function (p){
            if(p.row.tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.tags);
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
                cols.tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        }; //end of gridModelRewriter
        
        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);
        //end of Grid Custom Column
        
        try{
            Utils.loadingStart("Retrieving Tags");
            Utils.getRequest("/tags/showRespTags")
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        respondentparticipationreportUserActions.rewriteDdTags(args, result);
                    }
                }, reason => {
                    if(reason === "TAGS_NOT_FOUND"){
                        console.log("There is no active response tags");
                    } else {
                        console.error(reason);
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
        
        //init run
        respondentparticipationreportUserActions.gridFilter(args);
    },
    
    onExport: function(args) {
        const formData = new FormData();
        if(args.data.UID != undefined){
            formData.append(''UID'', args.data.UID);
        }
        if(args.data.RespName != undefined){
            formData.append(''RespName'', args.data.RespName);
        }
        
        if(args.data.Status != undefined){
            formData.append(''StatusId'', args.data.Status);
        }
        
        if(args.data.DeploymentName != undefined){
            formData.append(''DplyId'', args.data.DeploymentName);
        }
        
        if(args.data.ddIncludeTags != undefined){
            formData.append(''includeTags'', JSON.stringify(args.data.ddIncludeTags));
        }
        
        if(args.data.ddExcludeTags != undefined){
            formData.append(''excludeTags'', JSON.stringify(args.data.ddExcludeTags));
        }
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/respondentparticipation",formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
                console.log("purgeData error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    rewriteDdTags: function(args, tags){
        let ddTags = tags;
        const options = [];
        for(var i=0; i<ddTags.length; i++) {
            options.push( {
                key: i,
                value: ddTags[i],
                text: ddTags[i],
            } );
        }
        CloverApp.API.changeModelControl(args, "ddIncludeTags","data-elements", options);
        CloverApp.API.changeModelControl(args, "ddExcludeTags","data-elements", options);
    },
    
    //gridview must not in any container
    gridFilter: function(args) {
        try{
            const data = args.data;
            const searchUID = data.UID ? data.UID : "";
            const searchRespName = data.RespName ? data.RespName : "";
            const filterDeploymentName = data.DeploymentName ? data.DeploymentName : [];
            const filterStatus = data.Status ? data.Status : [];
            const IncludeTags = data.ddIncludeTags ? data.ddIncludeTags : [];
            const ExcludeTags = data.ddExcludeTags ? data.ddExcludeTags : [];
            let validated = true;
            
            if(IncludeTags.length > 0 && ExcludeTags.length > 0) {
                const found = IncludeTags.some(r=> ExcludeTags.includes(r))
                if(found) {
                    alertify.error("Tags cannot be in both include and exclude");
                    validated = false;
                }
            }
            
            if(!validated){
                return {};
            }
            
            Utils.loadingStart();
            Utils.getRequest("/report/respondentparticipationgridfilter?"
            + "UID=" + encodeURIComponent(searchUID) + "&"
            + "RespName=" + encodeURIComponent(searchRespName) + "&"
            + "StatusIds=" + encodeURIComponent(filterStatus) + "&"
            + "DplyIds=" + encodeURIComponent(filterDeploymentName) + "&"
            + "IncludeTags=" + encodeURIComponent(JSON.stringify(IncludeTags)) + "&"
            + "ExcludeTags=" + encodeURIComponent(JSON.stringify(ExcludeTags)) + "&")
            .then(response => {
                    if(response.success && response.item !== null) {
                        CloverApp.API.setDataField("gridview_1", response.item);
                        args.component.refs.gridview_1.refresh();
                        //console.log(response.item);
                    }
                }, reason => {
                    if(reason === "TAGS_NOT_FOUND"){
                        console.log("There is no active response tags");
                    } else {
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    actionAddAllFields: function(args){
        var options = args.component.refs.Status.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("Status", keys);
        
    },
    
    actionRemoveAllFields: function(args){
        CloverApp.API.setDataField("Status", []);
    },
    
}' WHERE [Id]='4d879db0-1a88-4b78-80f7-03229fb983b0';

