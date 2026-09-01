-- Will UPDATE existing row(s) in dwMetadata for the following:
-- DashboardStatus.json
-- DashboardStatus-settings.json
-- DashboardStatus-code.js

UPDATE [dwMetadata] SET
[Id]='67597a3c-e438-42d1-9a6d-761b70d61684', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:13:17.740', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-12-29 16:20:32.230', 
[Data]=N'[
  {
    "key": "headerSurveyStatus",
    "data-buildertype": "header",
    "content": "Survey Response Status Dashboard - {dplyHeader}",
    "size": "huge",
    "subheader": "",
    "style-marginTop": "10px"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "deployment",
        "data-buildertype": "dictionary",
        "label": "Deployment",
        "fluid": true,
        "selection": true,
        "dataModel": "QNN_DPLY",
        "columns": "Name ASC",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "changeHeader",
              "onChangeDeployment"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "50%",
        "search": true,
        "clearable": false,
        "onChangeTimeout": "200",
        "filters": "",
        "style-height": "",
        "paging": true
      },
      {
        "key": "statusType",
        "data-buildertype": "dropdown",
        "label": "Status",
        "fluid": true,
        "selection": true,
        "data-elements": [],
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
              "onChangeFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "50%",
        "style-height": "",
        "multiple": true,
        "other-visibleConition": "data.onOverallResponse == 1"
      },
      {
        "key": "result",
        "data-buildertype": "staticcontent",
        "content": "Text...",
        "isHtml": true,
        "fetchData": true,
        "isPre": true
      },
      {
        "key": "btnExportDetails",
        "data-buildertype": "button",
        "content": "Export Cases",
        "other-visibleConition": "data.onOverallResponse == 1",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "exportDetails"
            ],
            "targets": [],
            "parameters": []
          }
        }
      }
    ],
    "style-source": "",
    "style-marginBottom": "30px"
  }
]' WHERE [Id]='67597a3c-e438-42d1-9a6d-761b70d61684';

UPDATE [dwMetadata] SET
[Id]='7bdc57fe-b769-4ee2-b259-763e0937836e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:13:17.860', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-12-29 16:20:32.310', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-12-29T16:20:32.2952001+08:00",
  "isTemplate": false,
  "securityGroup": "Reports"
}' WHERE [Id]='7bdc57fe-b769-4ee2-b259-763e0937836e';

UPDATE [dwMetadata] SET
[Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:14:40.923', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-12-29 14:04:21.057', 
[Data]=N'{
    init: function(args) {
        
    },
    
    onChangeDeployment: function (args){
    
    CloverApp.API.setDataField("statusType", []);
                        
                      
       if(args.data.deployment == undefined || args.data.deployment == "")
            return;
        
        var _getStatusTypes = function(array){
            var options = [];
            if(array !== undefined && array.length > 0){
                for(var j = 0; j < array.length; j++){
                    var obj = {
                        key: j,
                        value: array[j],
                        text: array[j]
                    }
                    options.push(obj);
                }
            }
            return options;
        }
        
        // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };
        
        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        var deployment = args.data.deployment;
        var dplyId = args.data.Id;
        var statusType = args.data.statusType == undefined ? [] : args.data.statusType ;
    
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append(''dplyId'', deployment);     
            var url = ''/report/dashboard/statusresponse'';
            
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    _loadingStop();
                    if (response.success) {
                        var items = response.items;
                        var totalStatus = response.totalStatus;
            
                        var html = '''';
                        var onStatusFilter = (statusType !== undefined && statusType.length > 0);
                        var statusOptions = [];
                        
                        if(items !== undefined && items.length > 0){
                            for(var i = 0; i < items.length; i++){
                                
                                statusOptions.push(items[i]["Status"]); 
                                    
                                    var responseRate = items[i]["ResponseNumber"] / totalStatus * 100;
                                        responseRate = responseRate.toFixed(2);
                                        
                                    var text = items[i]["ResponseNumber"] + ''/'' + totalStatus;
                                        text = text.toString() + "&nbsp" + ''('' + responseRate + ''%)'';
                                        
                                    html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                    items[i]["Status"] +  ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + text  + `>
                                    </div>` +
                                        
                                        `</div></div>`;
                                        
                                }
                            
                        }
                               
                        var htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''
               
                        CloverApp.API.setDataField("result", htmlOverall);
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "statusType");
                        _removeElement(_hideControls, "btnExportDetails");
                        
                        CloverApp.API.setDataField("onOverallResponse", true);
                        
                        var statusTypeRewrite = function (model) {
                            model[''data-elements''] = _getStatusTypes(statusOptions);
                        };
                        CloverApp.API.rewriteControlModel("statusType", statusTypeRewrite);
                        
                        return Promise.resolve(
                           
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models:{
                                                hideControls: _hideControls
                                            }
                                        }
                                    }
                                }
                        });
                    } else {
                        alertify.error(response.message);
                    }
    
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
        }
        
    },
  
    onChangeFilter: function(args){
       
        var response = args.data.response;
        var deployment = args.data.deployment;
        var statusType = args.data.statusType;
        
        if(response == undefined || response == "")
            return;
        
        var totalStatus = response.totalStatus;
        var html = '''';
        var items = response.items;
        var onStatusFilter = (statusType !== undefined && statusType.length > 0);

        if(items !== undefined && items.length > 0){
            for(var i = 0; i < items.length; i++){
                
                if(!((onStatusFilter && statusType.includes(items[i]["Status"])) || onStatusFilter == false))
                    continue;
                    
                    var responseRate = items[i]["ResponseNumber"] / totalStatus * 100;
                        responseRate = responseRate.toFixed(2);
                        
                          var text = items[i]["ResponseNumber"] + ''/'' + totalStatus;
                                        text = text.toString() + "&nbsp" + ''('' + responseRate + ''%)'';
                                        
                                    html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                    items[i]["Status"] +  ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + text  + `>
                                    </div>` +
                                        
                                        `</div></div>`;
                }
            
        }
          
        var htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''

        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
                     
        
    },
    
    changeHeader: function(args){
              
            var dicValue = args.sourceControlValue;
            var options = args.sourceControlRef.state.options;
            
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == dicValue){
                        CloverApp.API.setDataField("dplyHeader", options[i]["text"]);
                        break;
                    }
                }
            }
    },
    
    exportDetails: function(args) {
        const formData = new FormData();
        formData.append("dplyId", args.data.deployment);
        // if(Array.isArray(args.data.statusType)) {
        //     args.data.statusType.forEach(status => formData.append("status",status));
        // }
        args.data.statusType.forEach(status => formData.append("status",status));
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/dashboard/statusresponse/exportdetails", formData).then(
            response => {
                    alertify.success(response.message);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
    },
}







' WHERE [Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e';

