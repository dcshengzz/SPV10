{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("UploadDataset", model => {
            model.customPostUrl = "/deployment/dataset/" + dplyId;
            model.onUploadBegin = () => Utils.loadingStart("Uploading data to server");
            model.onUploadEnd = (cmp, ok, data) => { 
                Utils.loadingStop();
                if(ok) {
                    if(data.item) {
                        const importReport = data.item;
                        CloverApp.API.setDataField("ImportReportImportCount", importReport.importCount);
                        CloverApp.API.setDataField("ImportReportInvalidCount", importReport.invalidCount);
                        CloverApp.API.setDataField("ImportReportIgnoredCount", importReport.ignoredCount);
                        CloverApp.API.setDataField("ImportReportDuplicateCount", importReport.duplicateCount);
                    }
                } else {
                    CloverApp.API.setDataField("UploadDataset",null);
                    alertify.error("File upload failed");
                }
            };
        });
    },
    
    onClickUpload: function(args) {
        const file = $("input[name='UploadDataset']");
        file.trigger('click');
    },
    
    onImport: function(args) {
        const gridview = args.component.refs.gv_Datasets;
        const result = args.sourceControlValue;
        
        //Need to clear the file field so it can be used again
        CloverApp.API.setDataField("UploadDataset",null);
        
        if("FAIL"==result) {
            alertify.error("Data import failed.");
        } else if("NO UID COLUMN"==result) {
            alertify.error("Invalid file. A UID column is required to identify samples.");
        } else if("INCORRECT FILE TYPE"==result) {
            alertify.error("Incorrect file type. Please upload a CSV file.");
        } else if("OK"==result) {
            gridview.refresh();
            args.component.refs.ImportReportModal.openModal();
        } else {
            console.error("CSV import error", result);
            alertify.error("An error occured.");
        }
        
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
    },
    
    clearDatasets: function(args) {
        args.controlRef.close();
        const gridview = args.component.refs.gv_Datasets;
        Utils.loadingStart("Removing uploaded datasets");
        Utils.deleteRequest("/deployment/dataset/"+encodeURIComponent(args.data.Id)).then(
            () => {
                alertify.success("Datasets removed");
                gridview.refresh();
            },
            reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
    },

}








