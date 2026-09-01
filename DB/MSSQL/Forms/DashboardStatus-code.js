{
    init: function(args) {
        
    },
    
    //not an action handler (used by onChangeDeployment and onChangeFilter)
    reportHtml: function(response, statusType, excludeExempted){
        if(response == undefined || response == "")
            return;
        
        const totalStatus = response.totalStatus;
        let html = '';
        const items = response.items;
        const statusFilterOn = (statusType !== undefined && statusType.length > 0);
        const isExcludeExempted = !statusFilterOn && excludeExempted;
        const exemptedTypes = [ 'EM', 'EE', 'EC', 'EO'];

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
                        
                    let text = items[i]["ResponseNumber"] + '/' + totalStatus;
                    text = text.toString() + "&nbsp" + '(' + responseRate + '%)';
                    
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
        const htmlOverall = '<div class="field"><label>Result</label></div><div class="swz-block">' + html + '</div>'
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
                alertify.error( Utils.encodeHTML(reason) );
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
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                alertify.error( Utils.encodeHTML(reason) );
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







