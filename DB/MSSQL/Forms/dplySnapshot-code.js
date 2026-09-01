{
    init: function(args) {
        Utils.loadingStart("Fetching snapshot settings...");
        Utils.getRequest("/report/snapshot/settings?dplyId=" + encodeURIComponent(args.data.Id)).then(
            response => {
                //console.log("response", response);
                const settings = response.item;
                CloverApp.API.setDataField("rs_SaveSnapshot", settings.isSaveSnapshot);
                CloverApp.API.setDataField("rs_EmailOnSuccess", settings.isEmailOnSuccess);
                CloverApp.API.setDataField("rs_EmailOnFailure", settings.isEmailOnFailure);
                CloverApp.API.setDataField("rs_EmailRecipients",settings.emailRecipients);
                Utils.queueHideControl("rs_SettingsForm", settings.isSaveSnapshot ? "show" : "hide");
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    onClickSave: function (args){
        const settings = {
            dplyId: args.data.Id,
            isSaveSnapshot: Utils.isSelected(args.data.rs_SaveSnapshot),
            isEmailOnSuccess: Utils.isSelected(args.data.rs_EmailOnSuccess),
            isEmailOnFailure: Utils.isSelected(args.data.rs_EmailOnFailure),
            emailRecipients: args.data.rs_EmailRecipients
        };
        //console.log("settings", settings);
        Utils.loadingStart("Updating snapshot settings...");
        Utils.postJsonRequest("/report/snapshot/settings", settings).then(
            response => {
                alertify.success(Utils.encodeHTML(response.message));
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    }, 
}