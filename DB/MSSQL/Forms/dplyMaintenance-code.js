{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("ResponseUpload", model => {
            model.customPostUrl = "/deployment/import/responseupload/" + encodeURIComponent(dplyId);
            model.onUploadBegin = () => Utils.loadingStart("Transferring file...");
            model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                //console.log("ctrl", ctrl, "success", success, "xhr", xhr, "msg", msg, "err", err);
                Utils.loadingStop();
                if(!success) {
                    console.log("Upload failed", xhr, msg, err);
                    if(xhr.status=== 400) {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + xhr.statusText + " - " + xhr.responseText), 25000);
                    } else if(xhr.status===413) {
                        alertify.error("Upload Failed - the selected file is too large to be uploaded here", 25000);
                    } else {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + msg + " - " + err), 25000);
                    }
                } else {
                    console.error(xhr.message);
                    if("OK" == xhr.message) {
                        alertify.success("File transferred to server, you will be notified by email when processing is complete", 20000);
                    } else if("FAIL" == xhr.message) {
                        alertify.error("Failed to transfer the file to the server.", 25000);
                    } else {
                        alertify.error("This file is not valid. Please check that you have the correct file.", 25000);
                    }
                }
            }
        });  
    },
    
    applyDates: function(args) {
        const dplyId = args.data.Id;
        const dateStart = new Date(args.data.DateStart).toISOString();
        const dateEnd = new Date(args.data.DateEnd).toISOString();
        console.log("dateStart", dateStart, "dateEnd", dateEnd);
        const form = new FormData();
        form.append("dplyId", dplyId);
        form.append("dateStart", dateStart);
        form.append("dateEnd", dateEnd);
        Utils.loadingStart("Saving the date...");
        Utils.postFormRequest("/deployment/maintenance/applyDates", form).then(
            response => { 
                alertify.success("Dates updated",20000);
                window.setTimeout(()=>{window.location=window.location},1000);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 25000);
                Utils.loadingStop();
            }
        )
    },
    
    purgeResponses: function(args) {
        const isEnabled = args.data.EnablePurgeResponsesButton;
        if(!isEnabled) {
            alertify.error("Purge responses button is not enabled");
            return {};
        }
        const dplyId = args.data.Id;
        const message = { 
            parameters: { 
                confirmTitle: "purgeRespConfirmTitle", 
                confirmText: "purgeRespConfirmText", 
                confirmOk: "purgeRespConfirmOk"
        } };
        CloverApp.API.confirm(message).then(()=> {
            const form = new FormData();
            form.append("dplyId", dplyId);
            Utils.loadingStart("Purging responses...");
            Utils.postFormRequest("/deployment/maintenance/purgeresponses", form).then(
            response => { 
                    alertify.success(Utils.encodeHTML(response.message),20000);
                    CloverApp.API.setDataField("EnablePurgeResponsesButton", false);
                    //TODO - update readOnly for the button
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason), 25000);
                }
            ).finally(Utils.loadingStop);
        });
    },
    
}