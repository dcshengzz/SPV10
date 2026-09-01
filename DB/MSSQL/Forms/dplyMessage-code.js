{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format('DD MMM YYYY HH:mm');
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    $("span[name='StatusStatic'] > p[name='status']").append("<a class='ui label'>" + entry.ForStatus_Title + "</a>");
                });
        }
    },
    
    cancelJob: function(args){
        Utils.loadingStart();
        const formData = new FormData();
        formData.append('dplyMsgId', args.data.Id);
        Utils.postFormRequest("/deployment/canceljob",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                console.log("Cancel job failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
       return{};
    },
    
    //renamed from editEmailToStatus
    updateProfileMailMerge: function(args){
        const dplyMsgId = args.data.Id;
        const dplyId = args.data.DplyId;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        
        //lowercase msg would be used after onHtmlChange was invoked
        const msgContentJson = args.data.UseRawHtml 
            ? "" 
            : (args.data.msgContentJson) ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const listSampleIds = args.data.targetSamples ? args.data.targetSamples : "";

        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!args.data.UseRawHtml) {
            if(msgContentJson==undefined || msgContentJson==null){
                alertify.error("Email content is required");
                validated = false;
            }
        }

        if(status.length==0 && listSampleIds.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        
        let url = "";
        if(status.length !== 0 && listSampleIds.length ==0){
            url = "/deployment/profileMailMergeToStatus";
            formData.append('status', status);
        } 
        if(listSampleIds.length !== 0 && status.length ==0){
            url = "/deployment/profileMailMergeToSamples";
            formData.append('listSampleIds',listSampleIds);
            formData.append('mailMerge', args.data.NotifyMerge);
            formData.append('email', args.data.NotifyEmail);
            formData.append('profile', args.data.NotifyGenerate);
        }

        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('dplyId', dplyId);
        formData.append('dplyMsgId', dplyMsgId);
        formData.append('subject', subject);
        formData.append('emailFrom', emailFrom ?? "");
        formData.append('scheduledDate', scheduledDate);
        
        if(validated){
            Utils.loadingStart();
            Utils.postFormRequest(url,formData).then(
                response => {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/dplyMessage/" + encodeURIComponent(dplyMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
                    alertify.success( Utils.encodeHTML(response.message) );
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        }

        return {};
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        var samplelist = [];
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
            CloverApp.API.setDataField("dictionaryStatus",statuslist);
        }
        if(args.data.SampleCollection.length > 0){
            args.data.SampleCollection.forEach(
                (entry) => {
                    samplelist.push(entry.ListSampleId);
                });
            CloverApp.API.setDataField("targetSamples",samplelist);
        }

        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        if(args.data.MsgContentJson && args.data.MsgContentJson && args.data.MsgContentJson != '') {
            CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
            CloverApp.API.setDataField("UseRawHtml",false);
            Utils.queueHideControl("msgContentEditor","show");
            Utils.queueHideControl("htmlRaw","hide");
        } else {
            CloverApp.API.setDataField("msgContentEditor","");
            CloverApp.API.setDataField("UseRawHtml",true);
            CloverApp.API.setDataField("htmlRaw",args.data.MsgContent);
            Utils.queueHideControl("msgContentEditor","hide");
            Utils.queueHideControl("htmlRaw","show");
        }
        return { app:{} }
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