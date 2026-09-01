-- Warning: This script will update forms. 
--          Please compare forms in swz-appbuilder-clover\DB\MSSQL\Forms folder with yours 
--          and merge if there are conflicts.

-- update the following files:

-- respdashboard-code.js

UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'respdashboard-code.js', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:23.760', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-09-01 13:33:10.440', 120), Data = N'{

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
                        const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed==undefined);
                        const fileNames = p.row.FileNames.split(''||'');
                        const fileLanguages = p.row.FileLanguages.split(''||'');
                        const fileTokens = p.row.FileTokens.split(''||'');      
                        var elements = [];
                        for(var i=0; i < fileNames.length; i++) {
                            let element;
                            if(ipAllowed) {
                                const linkUrl = "/respondent/download/file/" + p.row.Id + "/"  + fileTokens[i] + "/" + p.row.RespId;
                                element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);
                            } else {
                                element = CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, fileLanguages[i]);
                            }         
                            elements.push(element);
                            elements.push( CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ") );
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
                    const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed==undefined);
                    const status = p.row.Status ? p.row.Status.toUpperCase() : "";
                    if(hasOnlineFiles && ipAllowed && (status==PENDING || status==IN_PROGRESS) ){
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
