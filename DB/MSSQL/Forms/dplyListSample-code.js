{
    addNewSample: function(args){
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        Utils.loadingStart("Updating deployment samples from list");
        Utils.postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of addNewSample
    
    closeModal: function(args) {
        args.controlRef.close(); //expects modal as event target    
    },
    
    onOpenManageDueDate: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalDueDate = args.component.refs.modalDueDate;
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    changeDueDate: function(args){
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='') {
            alertify.error("Please select the due date");
            return {};
        }else if(Date.parse(dueDate) <= Date.parse(args.data.DateStart)){
            alertify.error("Due Date must be after Deployment Start Date (" + CloverApp.API.formatDatetime(args.data.DateStart, window.CloverLang.common.datetimeFormat) + ")");
            return {};
        }
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append('listSampleIds', listSampleIds);     
        Utils.loadingStart("Updating Due Dates");
        Utils.postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of changeDueDate

    onOpenSendMessage: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        if(noSamplesSelectedInGrid){
            modalSendMessage.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    //previously named sendMessage
    profileMailMergeToSamples: function(args){
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
 
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.data.UseRawHtml ? args.data.htmlRaw : args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = args.data.UseRawHtml ? null : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        }
        const subject = args.data.subject;

        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Message content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );

        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append('msgContent', msgContent);
        formData.append('msgContentJson', msgContentJson);
        formData.append('dplyId', dplyId);
        formData.append('mailMerge', mailMerge);
        formData.append('profile', profile);        
        formData.append('subject', subject);
        formData.append('email', email);    
        formData.append('emailFrom', emailFrom);
        formData.append('scheduledDate', scheduledDate);        
        formData.append('listSampleIds', listSampleIds);     
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToSamples", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success( Utils.encodeHTML(result.message) );
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }
        
        const sampleIds = gridListSamples.state.selectedIndexes.map( gridIndex => gridListSamples.state.items[gridIndex].SampleId);
        const formData = new FormData();
        formData.append("sampleIds", sampleIds);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).then(Utils.loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);

        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }        

        const sampleIds = gridListSamples.state.selectedIndexes
            .map( gridIndex => gridListSamples.state.items[gridIndex]) //extract selected grid items
            .map( item => { return { sampleId: item.SampleId, sampleInfoId: item.Id } } ); //extract objects with desired ids

        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}