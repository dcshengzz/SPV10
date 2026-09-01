{
    init: function(args){
         ;
    },
    
    
    getDeploymentFields: function(args){
        const sourceDplyId = args.controlRef.props.value;
        if(!sourceDplyId || sourceDplyId.length==0){
            alertify.error("Please select at least one deployment");
            return;
        }
        
        const targetDplyId = args.data.Id;
        
        const url = "/deployment/" + encodeURIComponent(targetDplyId) + "/prepopulationfieldlist?" + new URLSearchParams({sourceDplyId});
        Utils.loadingStart();
        Utils.getRequest(url).then(
            response => {
                CloverApp.API.setDataField("DeploymentQnnFields", response.item);
            }, reason => {
                console.log("failed to get deployment fields", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    addAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    }, 
    
    _validateScheduledTime: function(args) {
        const scheduledTime = new Date(args.data.ScheduledTime);
        const hasScheduledTime = !isNaN(scheduledTime) && (scheduledTime.getTime()!==new Date(0).getTime());
        if(hasScheduledTime) {
            const now = new Date();
            if(scheduledTime < now) {
                alertify.error("Pre-population may not be scheduled in the past");
                return false;
            }
            const nowPlus24 = new Date(new Date().getTime() + (24 * 60 * 60 * 1000));
            if(scheduledTime > nowPlus24) {
                alertify.error("Pre-population may not be scheduled more than 24 hours from now");
                return false;
            }
        }
        return true;
    },
    
    //pre-pop from online deployment
    prePopulate: function(args){
        if(!qnn_dply_pre_populateUserActions._validateScheduledTime(args))
            return {};
        
        const targetDplyId = args.data.Id;
        const sourceDplyId = args.data.Deployment;
        const scheduledTime = new Date(args.data.ScheduledTime);
        const hasScheduledTime = !isNaN(scheduledTime) && (scheduledTime.getTime()!==new Date(0).getTime());
        
        if(sourceDplyId==null || ""===sourceDplyId) {
            alertify.error("Please select a source deployment");
            return {};
        }
        
        const allFields = args.data.DeploymentQnnFields;
        if(!allFields || allFields.length==0){
            alertify.error("Invalid source deployment, there are no common Alias");
            return {};
        }
        
        const fieldIds = [];
        for(let x = 0 ; x < allFields.length ; x++){
            if(allFields[x].PrePopulate == true){
                fieldIds.push(allFields[x].Id);
            }
        }
        
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sourceDplyId", sourceDplyId); 
        if(hasScheduledTime) {
            formData.append("scheduledTime", scheduledTime.toISOString() );
        }
        formData.append("fieldIds", fieldIds);
        
        const url = "/deployment/" + encodeURIComponent(targetDplyId) + "/prepopulate";
        Utils.loadingStart(); 
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message), 20000 );
                setTimeout(() => CloverApp.API.redirect("form", "QNN_DPLY", targetDplyId), 250);
            }, reason => {
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason), 30000 );
            }
        );
    },
    
    prePopulateCSV: function(args){
        if(!qnn_dply_pre_populateUserActions._validateScheduledTime(args))
            return {};
           
        const targetDplyId = args.data.Id;
        const scheduledTime = new Date(args.data.ScheduledTime);
        const hasScheduledTime = !isNaN(scheduledTime) && (scheduledTime.getTime()!==new Date(0).getTime());
        const token = args.data.CsvFileUploaded;
        
        if(token==null || "FAIL"===token){
            alertify.error("Please upload a CSV file");
            return {};
        }
        
        const formData = new FormData();
        formData.append("token", token); 
        if(hasScheduledTime) {
            formData.append('scheduledTime', scheduledTime.toISOString() );
        }
        const url = "/deployment/" + encodeURIComponent(targetDplyId) + "/prepopulatecsv";
        Utils.loadingStart("Checking CSV and scheduling job..."); 
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message), 20000 );
                setTimeout(() => CloverApp.API.redirect("form", "QNN_DPLY", targetDplyId), 250);
            }, reason => {
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason), 30000 );
                CloverApp.API.setDataField("CsvFileUploaded", null);
            }
        );
    },
    
    
 
}