{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    createEmail: function(args){
        console.log("resend args", args);

        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent = args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
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

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append('organization', organization);
        formData.append('target', target);
        formData.append('status', status);
        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('subject', subject);
        formData.append('emailFrom', emailFrom ? emailFrom : "");
        formData.append('scheduledDate', scheduledDate);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                    alertify.success( Utils.encodeHTML(response.message) );
                    args.controlRef.refresh();
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally( Utils.loadingStop );
  
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
}