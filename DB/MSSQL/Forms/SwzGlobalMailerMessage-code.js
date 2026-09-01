{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format('DD MMM YYYY HH:mm')
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    //var element = CloverApp.API.createElement("a", {className: "ui label"}, entry.ForStatus_Title);
                    $("p[name='status']").append("<a class='ui label'>" + entry.ForStatus_Title + "</a>");
                });
        }
        
        console.log(args);
    },
    
    cancelJob: function(args){
        const formData = new FormData();
        formData.append('globalMsgId', args.data.Id);
        Utils.loadingStart("Cancelling mail job");
        Utils.postFormRequest("/globalmailer/canceljob", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                alertify.error( Utils.encodeHTML(reason) );
                console.log("cancelJob error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    editEmail: function(args){
        
        const globalMsgId = args.data.Id;
        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? target=="intranetUsers" ? "" :  args.data.dictionaryStatus : "";
        
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
        
        if(msgContent==undefined || msgContent==null || msgContentJson==undefined || msgContentJson==null){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            $('body').loadingModal('destroy');
            return {};
        }

        const formData = new FormData();
        formData.append('organization', organization);
        formData.append('target', target);
        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('globalMsgId', globalMsgId);
        formData.append('subject', subject);
        formData.append('emailFrom', emailFrom);
        formData.append('scheduledDate', scheduledDate);  
        formData.append('status', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success("Message updated");
                const reloadUrl = "/form/SwzGlobalMailerMessage/" + encodeURIComponent(globalMsgId);
                window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    }, //end of editEmail
    

    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        if(args.data.StatusCollection.length > 0){
            CloverApp.API.setDataField("target","activeSamples");
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("dictionaryStatus",statuslist);
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("organization",args.data.StructDivisionId);
        CloverApp.API.setDataField("target",args.data.IsTargetUsers ? "intranetUsers" : "activeSamples" );
        return { 
            app:{}
        }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
}