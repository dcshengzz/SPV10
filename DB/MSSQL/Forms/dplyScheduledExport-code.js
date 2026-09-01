{
    init: function(args) {
        //console.log("args to init", args);
        const data = args.data;
        if(!data.Id) {
            alertify.error("No deployment. Returning to deployment form");
            window.setTimeout(()=>{ window.location = "/form/QNN_DPLY"; }, 500);
        } else {
            //Populate the recipients dropdown options
            const selectedRecipients = data.__selectedRecipients.map(r => r.SecurityUserId);
            Utils.loadingStart();
            Utils.getRequest("/deployment/dataowners/" + encodeURIComponent(data.Id)).then(
                response => {
                    const options = response.item.map( (owner) => ({ key: owner.Id, text: owner.Name, value: owner.Id }) );
                    const currentlyValidSelectedRecipients = options.filter(o => selectedRecipients.indexOf(o.value) !=-1).map(o => o.value);
                    //console.log("options", options, "selectedRecipients",selectedRecipients, "currentlyValidSelectedRecipients", currentlyValidSelectedRecipients);
                    Utils.rewriteDropdown("Recipients",options, currentlyValidSelectedRecipients);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop); 
        }
    },
    
    updateScheduledExport: function(args) {
        //console.log("args to updateScheduledExport", args);
        const data = args.data;
        
        const dplyId = data.Id;
        const scheduledExportEnabled = (data.ScheduledExportEnabled==1);
        const scheduledExportFrequency = data.ScheduledExportFrequency;
        const scheduledExportStartDate = data.ScheduledExportStartDate ? new Date(data.ScheduledExportStartDate) : null;
        const scheduledExportEndDate = data.ScheduledExportEndDate ? new Date(data.ScheduledExportEndDate) : null;
        const recipients = data.Recipients ? data.Recipients : [];
        
        //console.log("dplyId", dplyId, "scheduledExportEnabled", scheduledExportEnabled, "scheduledExportFrequency", scheduledExportFrequency,"scheduledExportStartDate", scheduledExportStartDate, "scheduledExportEndDate", scheduledExportEndDate, "recipients", recipients );

        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("scheduledExportEnabled", scheduledExportEnabled);
        formData.append("scheduledExportFrequency", scheduledExportFrequency);
        formData.append("scheduledExportStartDate", scheduledExportStartDate ? scheduledExportStartDate.toISOString() : "");
        formData.append("scheduledExportEndDate", scheduledExportEndDate ? scheduledExportEndDate.toISOString() : "");
        recipients.forEach(r => formData.append("recipients", r));
        
        Utils.loadingStart("Updating deployment");
        Utils.postFormRequest("/deployment/updatescheduledexport", formData).then(
            response => {
                alertify.success("Export settings updated");
                window.setTimeout(()=>{window.location = window.location;}, 500);
            }, reason => {
                console.error(reason);
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason) );
                return {};
            }
        ) //(no loadingStop in finally - this is to keep the animation going while we navigate on success);
        return {};
    },
}