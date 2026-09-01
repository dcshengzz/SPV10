-- Warning: this script will update forms. Please compare forms in swz-appbuilder-clover\DB\MSSQL\Forms folder with yours and merge if there are conflicts.

-- update the following files:

-- DataEditorDeployment-code.js
-- respdashboard-code.js

UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'DataEditorDeployment-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:18.407', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-28 11:43:50.043', 120), Data = N'{
    init: function (args) {
        const innerArgs = args;
        args.data.remarks = null;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Remarks.customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Remarks" + (p.row.Remarks!=null? '' ...'':''''));
                };
                
                cols.StatusTitle.customFormatter = function (p) {
                    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    return CloverApp.API.createElement("button", { onClick: () => showStatusModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, p.value);
                };                
                
                cols.Actions.customFormatter = function (p) {
                    if(p.row.StatusCode==''PE''){
                        return CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, ''9731DE1D-2B6A-484C-BF10-44F842A3140E''), className: "ui button mini secondary" }, "Exempt");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Exempt");
                    }  
                };        
                    
                cols.Actions2.customFormatter = function (p) {
                    if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                        return CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: "ui button mini secondary" }, "Reset");
                    }
                    else{
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Reset");
                    }   
                };    
                
                cols.Actions3.customFormatter = function (p) {
                    return CloverApp.API.createElement("button", { onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), className: "ui button mini secondary" }, "Track" + (p.row.HasTrkListIds!=null? '' ...'':''''));
                };     
                
                cols.Actions4.customFormatter = function (p) {
                    const hasOnlineFiles = ("O"===p.row.Type) && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
                    if(hasOnlineFiles) {
                        if( p.row.StatusCode=="PE" || p.row.StatusCode=="DE") {
                            //Upload option is available for Pending and In-Progress
                            const formNames = p.row.FormNames.split(''||'');
                            const languages = p.row.Languages.split(''||''); 
                            return CloverApp.API.createElement("button", { onClick: () => openUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id), className: "ui button mini secondary" }, "Upload");
                        } else {
                            //Show a disabled button for other status
                            return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Upload");
                        }
                    } else {
                        //No upload button for offline surveys or online surveys with no files
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                }; 

                cols.FormNames.customFormatter = function (p) {
                    if(p.row.Type=="P"){
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));
                        
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else if(p.row.Type=="O"){
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];
                        
                        //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }    
                };
                
                cols.FileNames.customFormatter = function(p) {
                    if(p.row.Type=="O" && p.row.FileLanguages){
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            const token = fileTokens[i];
                            const linkUrl = "/dataedit/download/file/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                            elements.push(element);
                            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                            elements.push(element);
                        }
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }  
                };
            }
            return model;
        };

        var genFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);            
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var genFormLinkButtons = function(p, elements, languages, value, index){
            
            var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
            var element = CloverApp.API.createElement("span", { onClick: () =>  {
                
                if(p.row.RespId){
                    CloverApp.API.redirect(''form'', value, ''respid/'' + p.row.RespId + ''/dlsi/''+ p.row.Id)                        
                }
                else{
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)                        
                }

                
            }, className: "link-style" }, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };        
        var genOfflineFormLinks = function(p, elements, languages, value, index){
            
            var linkUrl = "/dataedit/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };
        var getRemarksAsync = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            var url = ''/dataeditor/getremarks'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        //console.log("getRemarksAsync args", args);
                        args.component.state.data.remarks = response.item;
                        args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                        args.controlRef.refs.remarksModal.openModal();

                        args.component.refs.remarks.forceUpdate();
                        
                    return {
                        app:{
                            form: {
                                data: {
                                    modified:{
                                        remarks: response.item
                                    }
                                }
                            }
                        }
                    }; 

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });


        };

        var showModal = function (args, id) {


            return getRemarksAsync(args, id);

        };
        
        var openUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: formNames[i],
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", formNames[0]);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        var showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            //console.log(''showTrkListsModal args: '', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", UID);
            CloverApp.API.setDataField("trkListSample_email", Email);  
            CloverApp.API.setDataField("trkListSample_name", Name);              
            CloverApp.API.setDataField("trkListSample_remarks", Remarks);
            CloverApp.API.setDataField("trkListSample_status", Status);       
            CloverApp.API.setDataField("trkListSample_statusTitle", StatusTitle);

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();


            var formData = new FormData();
            
            formData.append(''uid'', UID);        
            
            
            var url = ''/dataeditor/gettrklistsbyuid'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        if(response.item)
                            CloverApp.API.setDataField("dictionaryTrkList", response.item);                        
            
                    } else {
                        alertify.error(response.message);
                        args.controlRef.refs.trkListModal.close();
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                    args.controlRef.refs.rrkListModal.close();
                });            
            


        };     


        var showStatusModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);   
            CloverApp.API.setDataField("dlsi", id); 
            var url = ''/dataeditor/GetStatusItems'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        //args.state.app.extra.spData = id;

                        args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                        args.controlRef.refs.statusModal.props.swzData.isOpen = true;
                        args.controlRef.refs.statusModal.openModal();

                        args.controlRef.refs.dropdownStatus.forceUpdate();

                    } else {
                        alertify.error(response.message);
                        args.controlRef.refs.statusModal.close();
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                    args.controlRef.refs.statusModal.close();
                });

                

        };        

        var setStatus = function (args, id, statusId) {
            var formData = new FormData();
            formData.append(''id'', id);        
            formData.append(''selectedStatusId'', statusId);
            var url = ''/dataeditor/setStatus'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        args.component.refs.grid.refresh();
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            

        };  

        var resetStatus = function (args, id, respId) {

            var formData = new FormData();
            formData.append(''id'', id);
            if(respId){
                formData.append(''respId'', respId);                
            }
            var url = ''/dataeditor/resetStatus'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        args.component.refs.grid.refresh();     
                        alertify.success(response.message);
        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });            
                
        };  
                

        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    },
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append(''uid'', args.data.trkListSample_uid);
        formData.append(''email'', args.data.trkListSample_email);
        formData.append(''name'', args.data.trkListSample_name);
        formData.append(''remarks'', args.data.trkListSample_remarks);
        formData.append(''status'', args.data.trkListSample_status);
        formData.append(''trkListIds'', args.data.dictionaryTrkList);

        
        
        var url = ''/dataeditor/settrklists'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success(response.message);
        
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                CloverApp.API.setDataField("dictionaryTrkList", null);  
                CloverApp.API.setDataField("trkListSample_uid", null);
                CloverApp.API.setDataField("trkListSample_email", null);    
                CloverApp.API.setDataField("trkListSample_name", null);                 
                CloverApp.API.setDataField("trkListSample_remarks", null);
                CloverApp.API.setDataField("trkListSample_status", null);       
                CloverApp.API.setDataField("trkListSample_statusTitle", null);               
            });
            
    
    
    },    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        formData.append(''id'', args.data.dlsi);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
    
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    
    
    },
    submitRemarks: function (args) {
        var changeRemarksAsync = function (remarks, id) {
            var formData = new FormData();

            formData.append(''remarks'', remarks);
            formData.append(''id'', id);
            var url = ''/dataeditor/setremarks'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success(response.message);
                        args.component.refs.grid.refresh();
                        
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
            
                args.component.refs.remarksModal.close();

        };

        //let id = args.state.app.extra.spData;
        let id = args.data.dlsi;
        let remarks = args.data.remarks;
        changeRemarksAsync(remarks, id);

        return {


        };

    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    answerFileUploaded: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        const postFormData = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: ''same-origin'',
                method: ''post'',
                body: formData,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    /*return responseData.success ? responseData.data : Promise.reject(responseData.message);*/
                    return responseData.success ? responseData.message : Promise.reject(responseData.message);
                }, reason => {
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        
        args.component.refs.fileUploadModal.close();
        
        const token = args.sourceControlValue;
        const qnnId = args.data.UploadQnnId;
        const dplyId = args.data.UploadDplyId;
        const listSampleId = args.data.UploadListSampleId;
        if( (!qnnId) || (!dplyId) || (!listSampleId) || (!token)) {
            console.error("data", args.data);
            throw new Error("Missing required value");
        }
        
        const uploadFormChoice = args.data.UploadFormChoice;
        const uploadIndex = args.data.UploadIndex;
        
        const formData = new FormData();
        formData.append("qnnId", qnnId);
        formData.append("dplyId", dplyId);
        formData.append("listSampleId", listSampleId);
        formData.append("token", token);
        loadingStart("Processing Uploaded File");
        postFormData("/dataedit/handleuploaded", formData).then(
            result => {
                args.component.refs.grid.refresh();
                alertify.success("Survey answers updated from file");
                if(uploadFormChoice) {
                    CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        return {};
    },

}
', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '4AF67164-5E60-4905-9885-AFD6DA24CB3D';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'respdashboard-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:23.760', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-08-28 12:13:01.330', 120), Data = N'{

    init: function(args){
console.log("Args", args);
        const innerArgs = args;            
        var url = ''/swzdata/getmultiple?type=RespDashboard'';
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA";
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93";
           
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.customFormatter = function (p) {
                    if(p.row.Type=="Offline"){
                        
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                        return CloverApp.API.createElement("div", {}, elements);
                        
                        //return CloverApp.API.createElement("a", { href: url}, p.value); 
                    }
                    else if(p.row.Type=="Online"){
                        
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        return CloverApp.API.createElement("div", {}, elements);                            
                        
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                };
                
                cols.File.customFormatter = function(p) {
                    const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    if(hasOnlineFiles){
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            const token = fileTokens[i];
                            const linkUrl = "/respondent/download/file/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                            elements.push(element);
                            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                            elements.push(element);
                        }
                        return CloverApp.API.createElement("div", {}, elements);
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }  
                };
                
                //Upload button
                cols.Actions.customFormatter = function (p) {
                    const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    const status = p.row.Status ? p.row.Status.toUpperCase() : "";
                    if(hasOnlineFiles && (status==PENDING || status==IN_PROGRESS) ){
                        const formNames = p.row.FormNames.split(''||'');
                        const languages = p.row.Languages.split(''||''); 
                        return CloverApp.API.createElement(
                            "button", {
                                onClick: () => openUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id), 
                                className: "ui button secondary invert",
                            }, "Upload");
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, ""); 
                    }
                };
                
                //model.columns[model.columns.length-1].customFormatter = function (p) {
                //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                //};   
                
            }
            return model;
        };
        
        var gridviewModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    if(p.row.Type=="Offline"){
                        var strTokens = p.row.Tokens;
                        var strOfflineLanguages = p.row.OfflineLanguages;
                        var tokens = strTokens.split(''||'');
                        var offlineLanguages = strOfflineLanguages.split(''||'');      
                        var elements = [];

                        tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                        return CloverApp.API.createElement("div", {}, elements);
                        
                        //return CloverApp.API.createElement("a", { href: url}, p.value); 
                    }
                    else if(p.row.Type=="Online"){
                        var strFormNames = p.row.FormNames;
                        var strLanguages = p.row.Languages;
                        var formNames = strFormNames.split(''||'');
                        var languages = strLanguages.split(''||'');      
                        var elements = [];

                        formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                        return CloverApp.API.createElement("div", {}, elements);  
                    }
                    else{
                        return CloverApp.API.createElement("div", {}, p.value); 
                    }
                };
                
                //model.columns[model.columns.length-1].customFormatter = function (p) {
                //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                //};                  
                
            }
            return model;
        };      
        

        
       /* var genFormLinks = function(p, elements, languages, value, index){
            var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };*/
        var genOfflineFormLinks = function(p, elements, languages, value, index){
            var linkUrl = "/respondent/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
            CloverApp.API.createElement("a", { href: linkUrl}, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };    
        
        var genFormLinkButtons = function(p, elements, languages, value, index){
            var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
            var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
            CloverApp.API.createElement("span", { onClick: () =>  {

                if(p.row.RespId){
                    CloverApp.API.redirect(''form'', value, ''respid/'' + p.row.RespId + ''/dlsi/''+ p.row.Id)                         
                }
                else{
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)                        
                }

                
            }, className: "link-style" }, languages[index]):
            CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
        };     
        
        var openUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            //console.log("innerArgs, qnnId, dplyId, listSampleId", innerArgs, qnnId, dplyId, listSampleId);
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: formNames[i],
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", formNames[0]);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        var showModal = function (args, id) {
            return getPasswordAsync(args, id);
        }; 
        
        var getPasswordAsync = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/respondent/getpassword'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        //console.log("getPasswordAsync args", args);
                        args.controlRef.refs.passwordModal.openModal();
                        args.component.state.data.password = response.item;
                        args.component.refs.password.forceUpdate();
                        //console.log(''response.item'', response.item);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });


        };        
        
        
        $.get(url).done(function (data) {
        if(data.success){
            
            var htmlData = [];
            for (var i=0; i<data.data.length; i++){
                        htmlData.push(data.data[i].editorState);
            }
            CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
        }
        else
          console.log(data.message);
        }).fail(function (jqxhr, textStatus, error) {
         console.log(textStatus);
        }); 
        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
        CloverApp.API.rewriteControlModel("gridview", gridviewModelRewriter);

        $(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        //args.component.refs.grid.refresh();
        //args.component.refs.gridview.refresh();
        
    },
    
    closeModal: function (args) {

        args.component.refs.passwordModal.close();
        return {
        };

    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    answerFileUploaded: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        const postFormData = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: ''same-origin'',
                method: ''post'',
                body: formData,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    /*return responseData.success ? responseData.data : Promise.reject(responseData.message);*/
                    return responseData.success ? responseData.message : Promise.reject(responseData.message);
                }, reason => {
                    return Promise.reject(reason);
                } 
            );
            return promise;
        };
        //--------------------------------------------
        
        args.component.refs.fileUploadModal.close();
        
        const token = args.sourceControlValue;
        const qnnId = args.data.UploadQnnId;
        const dplyId = args.data.UploadDplyId;
        const listSampleId = args.data.UploadListSampleId;
        if( (!qnnId) || (!dplyId) || (!listSampleId) || (!token)) {
            console.error("data", args.data);
            throw new Error("Missing required value");
        }
        
        const uploadFormChoice = args.data.UploadFormChoice;
        const uploadIndex = args.data.UploadIndex;
        
        const formData = new FormData();
        formData.append("qnnId", qnnId);
        formData.append("dplyId", dplyId);
        formData.append("listSampleId", listSampleId);
        formData.append("token", token);
        loadingStart("Processing Uploaded File");
        postFormData("/respondent/handleuploaded", formData).then(
            result => {
                args.component.refs.grid.refresh();
                alertify.success("Survey answers uploaded");
                if(uploadFormChoice) {
                    CloverApp.API.redirect(''form'', uploadFormChoice, ''dlsi/''+ uploadIndex);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        return {};
    }
    
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '7479ADC7-5164-48A5-B4C6-2EB01ECA68DF';
