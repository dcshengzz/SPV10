{
    init: function(args) { 
        const innerArgs = args;
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: 'link-style'}, 'Yes');
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                
                model.columns[3].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyGenerate){
                        var url = "/deployment/downloadProfile/" + p.row.GenerateProfileOutputToken;
                        if(p.row.GenerateProfileDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                };              
            }
            return model;
        }; //end of gridModelRewriter
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    //renamed from emailToStatus
    profileMailMergeToStatus: function(args){

        const dplyId = args.data.Id;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent =  args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = args.data.UseRawHtml
            ? ""
            : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('dplyId', dplyId);
        formData.append('subject', subject);
        formData.append('emailFrom', emailFrom ?? "");
        formData.append('scheduledDate', scheduledDate);  
        formData.append('status', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatus",formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success( Utils.encodeHTML(response.message) );
                args.controlRef.refresh();
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    //renamed from msgToStatus
    profileMailMergeToStatusImmediate: function(args){
        const dplyId = args.data.Id;
        const mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        const email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        const profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        const emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        const subject = args.data.msgSubject;
        const status = args.data.msgStatus ? args.data.msgStatus : "";

        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            if(args.data.msgUseRawHtml) {
                msgContent = args.data.msgHtmlRaw;
                msgContentJson = "";
            } else {
                msgContent = args.component.refs.msgContent.state.htmlData;
                msgContentJson = args.component.refs.msgContent.state.jsonData;
            }
            
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if((email || mailMerge || profile) && (status==undefined || status==null || status.length==0)){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }
        
        const formData = new FormData();
        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('dplyId', dplyId);
        formData.append('mailMerge', mailMerge);
        formData.append('email', email);    
        formData.append('profile', profile);       
        formData.append('subject', subject);
        formData.append('emailFrom', emailFrom ?? ""); 
        formData.append('status', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatusImmediate", formData).then(
            response => {
                args.component.refs.swzmodal_1.close();
                alertify.success( Utils.encodeHTML(response.message) );
                args.controlRef.refresh();
                CloverApp.API.setDataField("msgHtmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },

    actionAddAllFields: function(args){
        var options = args.component.refs.msgStatus.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("msgStatus", keys);
        
    },
    
    actionRemoveAllFields: function(args){
        CloverApp.API.setDataField("msgStatus", []);
    },
    
    actionAddAllFieldsSchedule: function(args){
        var options = args.component.refs.dictionaryStatus.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("dictionaryStatus", keys);
        
    },
    
    actionRemoveAllFieldsSchedule: function(args){
        CloverApp.API.setDataField("dictionaryStatus", []);
    },

}