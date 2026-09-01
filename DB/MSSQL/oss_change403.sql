-- Will UPDATE existing row(s) in dwMetadata for the following:
-- DashboardStatus.json
-- DashboardStatus-settings.json
-- DashboardStatus-code.js

UPDATE [dwMetadata] SET
[Id]='67597a3c-e438-42d1-9a6d-761b70d61684', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:13:17.740', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-24 03:45:11.767', 
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
        "key": "container_addRemoveStatus",
        "data-buildertype": "container",
        "style-marginTop": "-15px",
        "style-marginBottom": "10px",
        "children": [
          {
            "key": "actionAddAllStatus",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Add All Status",
                "url": ""
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "actionAddAllStatus"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-source": "margin: 5px;"
          },
          {
            "key": "actionRemoveAllStatus",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "RemoveAll Status",
                "url": ""
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "actionRemoveAllStatus"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-source": "margin: 5px;"
          }
        ],
        "other-visibleConition": "data.onOverallResponse == 1"
      },
      {
        "key": "excludeExempted",
        "data-buildertype": "checkbox",
        "label": "Exclude ''exempted'' status",
        "defaultValue": "true",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "onChangeFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "data.onOverallResponse == 1 && (  !data.statusType || (Array.isArray(data.statusType) && data.statusType.length==0) )"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-24 03:45:11.803', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2023-05-24T03:45:11.8041842+08:00",
  "isTemplate": false,
  "securityGroup": "Reports"
}' WHERE [Id]='7bdc57fe-b769-4ee2-b259-763e0937836e';

UPDATE [dwMetadata] SET
[Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:14:40.923', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-24 03:52:48.573', 
[Data]=N'{
    init: function(args) {
        
    },
    
    //not an action handler (used by onChangeDeployment and onChangeFilter)
    reportHtml: function(response, statusType, excludeExempted){
        if(response == undefined || response == "")
            return;
        
        const totalStatus = response.totalStatus;
        let html = '''';
        const items = response.items;
        const statusFilterOn = (statusType !== undefined && statusType.length > 0);
        const isExcludeExempted = !statusFilterOn && excludeExempted;
        const exemptedTypes = [ ''EM'', ''EE'', ''EC'', ''EO''];

        if(items !== undefined && items.length > 0){
            for(let i = 0; i < items.length; i++){
                const itemStatus = items[i]["Status"];
                const itemStatusCode = items[i]["StatusCode"];
                
                const excludeItem 
                    = (statusFilterOn && !statusType.includes(itemStatus))
                    || (isExcludeExempted && exemptedTypes.includes(itemStatusCode));
                
                if(!excludeItem){
                    let responseRate = items[i]["ResponseNumber"] / totalStatus * 100;
                    responseRate = responseRate.toFixed(2);
                        
                    let text = items[i]["ResponseNumber"] + ''/'' + totalStatus;
                    text = text.toString() + "&nbsp" + ''('' + responseRate + ''%)'';
                    
                    html = html 
                        + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                        items[i]["Status"] +  ":" + "&nbsp" +
                        `</div><div class="ui input">
                        <input type="text" readOnly value=` + text  + `>
                        </div>` +
                        
                        `</div></div>`;
                }
            }
        }
        const htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''
        return htmlOverall;
    },
    
    onChangeDeployment: function (args){
    
        CloverApp.API.setDataField("statusType", []);
        if(args.data.deployment == undefined || args.data.deployment == "")
            return;

        const statusType = args.data.statusType == undefined ? [] : args.data.statusType ;
        const excludeExempted = args.data.excludeExempted;
        Utils.loadingStart();
        Utils.getRequest("/report/dashboard/statusresponse",{dplyId:args.data.deployment}).then(
            response => {
                const htmlOverall = dashboardstatusUserActions.reportHtml(response.item, statusType, excludeExempted);
                CloverApp.API.setDataField("result", htmlOverall);
                CloverApp.API.setDataField("response", response.item);
                CloverApp.API.setDataField("onOverallResponse", true);
                
                Utils.queueHideControl("statusType", false);
                Utils.queueHideControl("excludeExempted", false);
                Utils.queueHideControl("btnExportDetails", false);
                Utils.queueHideControl("container_addRemoveStatus", false);
                
                const statusOptions = response.item.items.map( (item,index) =>  ({ key: index, value: item["Status"], text: item["Status"] }) );
                Utils.rewriteDropdown("statusType", statusOptions, []);

            }, reason => {
                console.error("failed to fetch statusresponse data, reason=", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
  
    onChangeFilter: function(args){
        console.log("onChangeFilter args=", args);
        const response = args.data.response;
        
        if(response == undefined || response == "")
            return;
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            args.data.statusType, 
            args.data.excludeExempted);

        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
    },
    
    changeHeader: function(args){
        const dicValue = args.sourceControlValue;
        const options = args.sourceControlRef.state.options;
        
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
        const dplyId = args.data.deployment;
        const statusType = args.data.statusType ? args.data.statusType : [];
        const isExcludeExempted = (statusType.length > 0) ? false : Boolean(args.data.excludeExempted);
        
        console.log("Requesting export for dplyId=", dplyId, "statusType=",statusType, "isExcludeExempted=", isExcludeExempted);
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("excludeExempted", isExcludeExempted);
        statusType.forEach(status => formData.append("status",status));
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/dashboard/statusresponse/exportdetails", formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
            }
        ).finally( Utils.loadingStop );
    },
    
    actionAddAllStatus: function(args){
        const response = args.data.response;
        const allStatus = response.items.map( item => item["Status"] );
        CloverApp.API.setDataField("statusType", allStatus);
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            allStatus, 
            args.data.excludeExempted);
        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
        
        Utils.queueHideControl("excludeExempted", true);
    },
    
    actionRemoveAllStatus: function(args){
        const response = args.data.response;
        
        CloverApp.API.setDataField("statusType", []);
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            [], 
            args.data.excludeExempted);
        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
        
        Utils.queueHideControl("excludeExempted", false);
    },
}







' WHERE [Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e';

