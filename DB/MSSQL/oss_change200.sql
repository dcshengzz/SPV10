-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMessages-code.js
-- dplyListSample-code.js

UPDATE [dwMetadata] SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-06 13:17:10.070', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
        text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
        text += ''Purpose of the Survey:\n''
        text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
        text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
        text +=''Submission of the Questionnaire:\n''
        text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
        text +='' \n''
        text +=''The following are your login information:\n''
        text +=''Company name: {Name}\n''
        text +=''Username: {UID}\n''
        text +=''Password: {Password}\n''
        text +='' \n''
        
        text +=''Other tokens:\n''
        text +=''UID: {UID}\n''
        text +=''Password: {Password}\n''
        text +=''Survey Name: {SurveyName}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
    },
    
    init: function(args) {        
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: ''link-style''}, ''Yes'');
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
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };              
            }
            return model;
        };    

        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    emailToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        var dplyId = args.data.Id;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContent = args.component.refs.htmlEditor.state.htmlData;
        var msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        var subject = args.data.subject;
        var status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        let validated = true;
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
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
        
        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        console.log(''msgContentJson : '',msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        
        var url = ''/deployment/emailtostatus'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    console.log("args:",args);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },
    
    msgToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        var dplyId = args.data.Id;
        var mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        var email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        var profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        var emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        var subject = args.data.msgSubject;
        var status = args.data.msgStatus ? args.data.msgStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(!mailMerge && !email && !profile){
            $(''body'').loadingModal(''destroy'');
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        var msgContent = "";
        var msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.msgContent.state.htmlData;
            msgContentJson = args.component.refs.msgContent.state.jsonData;
        }
        
        if(email && (emailFrom==undefined || emailFrom==null || emailFrom.length==0)){
            alertify.error("Email address from is required");
            validated = false;
        } else if(email && !emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
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
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''email'', email);    
        formData.append(''profile'', profile);       
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''status'', status);          
        
        var url = ''/deployment/messagetostatus'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    }

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-06 13:16:45.983', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
        text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
        text += ''Purpose of the Survey:\n''
        text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
        text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
        text +=''Submission of the Questionnaire:\n''
        text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
        text +='' \n''
        text +=''The following are your login information:\n''
        text +=''Company name: {Name}\n''
        text +=''Username: {UID}\n''
        text +=''Password: {Password}\n''
        text +='' \n''
        
        text +=''Other tokens:\n''
        text +=''UID: {UID}\n''
        text +=''Password: {Password}\n''
        text +=''Survey Name: {SurveyName}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
    },
    
    addNewSample: function(args){
		//-----------------------
		const loadingStart = function(loadingMessage) {
		$(''body'').loadingModal({
		    text: loadingMessage ? loadingMessage : ''Please wait...'',
		    animation: ''foldingCube'',
		    backgroundColor: ''#1262E2''});
		};
		
		const loadingStop = function() {
		    $(''body'').loadingModal(''destroy'');
		};
		//---------------------
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------		
        
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        loadingStart("Updating deployment samples from list");
        postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
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
		//-----------------------
		const loadingStart = function(loadingMessage) {
		$(''body'').loadingModal({
		    text: loadingMessage ? loadingMessage : ''Please wait...'',
		    animation: ''foldingCube'',
		    backgroundColor: ''#1262E2''});
		};
		
		const loadingStop = function() {
		    $(''body'').loadingModal(''destroy'');
		};
		//---------------------
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
			
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='''') {
            alertify.error("Please select the due date");
            return {};
        }
        
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        loadingStart("Updating Due Dates");
        postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success(result.message);
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
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
    
    sendMessage: function(args){
        //-----------------------
        const loadingStart = function(loadingMessage) {
        $(''body'').loadingModal({
            text: loadingMessage ? loadingMessage : ''Please wait...'',
            animation: ''foldingCube'',
            backgroundColor: ''#1262E2''});
        };
        
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
        
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        var msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = args.component.refs.htmlEditor.state.jsonData;
        }
        const subject = args.data.subject;
        
        if(email && (emailFrom==undefined || emailFrom==null || emailFrom.length==0)){
            alertify.error("Email address from is required");
            validated = false;
        } else if(email && !emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );
        // for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
        //     var gridIndex = args.controlRef.state.selectedIndexes[i];
        //     var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
        //     listSampleIds.push(listSampleId);
        // }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        loadingStart();
        postFormRequest("/deployment/resend", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success(result.message);
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
		//-----------------------
		const loadingStart = function(loadingMessage) {
		$(''body'').loadingModal({
		    text: loadingMessage ? loadingMessage : ''Please wait...'',
		    animation: ''foldingCube'',
		    backgroundColor: ''#1262E2''});
		};
		
		const loadingStop = function() {
		    $(''body'').loadingModal(''destroy'');
		};
		//---------------------
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------	
        
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
        loadingStart();
        postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error(reason);
            }
        ).then(loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
		//-----------------------
		const loadingStart = function(loadingMessage) {
		$(''body'').loadingModal({
		    text: loadingMessage ? loadingMessage : ''Please wait...'',
		    animation: ''foldingCube'',
		    backgroundColor: ''#1262E2''});
		};
		
		const loadingStop = function() {
		    $(''body'').loadingModal(''destroy'');
		};
		//---------------------
        //----------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------	
        
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

        // let sampleIds = [];
        // for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
        //     const gridIndex = args.controlRef.state.selectedIndexes[i];
        //     const sampleId = args.controlRef.state.items[gridIndex].SampleId;
        //     const sampleInfoId = args.controlRef.state.items[gridIndex].Id;
            
        //     const temp = {};
        //     temp.sampleId = sampleId;
        //     temp.sampleInfoId = sampleInfoId;
        //     sampleIds.push(temp);
        // }
        
        //console.log("sampleIds", sampleIds);
        
        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        var url = ''/deployment/resetrespdelegationcode'';
        
        loadingStart();
        postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

