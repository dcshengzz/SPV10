-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplySnapshot-code.js

UPDATE [dwMetadata] SET
[Id]='f9e0b630-92ee-4722-b2f9-a426eda90b69', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplySnapshot-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2024-06-16 18:46:08.650', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-06-18 01:56:44.967', 
[Data]=N'{
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
}' WHERE [Id]='f9e0b630-92ee-4722-b2f9-a426eda90b69';

