-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST-code.js
-- QNN_DPLY-code.js
-- QNN_QNN-code.js
-- SwzTags-code.js

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-08-01 15:09:30.707', 
[Data]=N'{   
    init: function(args){
        console.log("QNNLIST Args",args);
        
        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_listUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
    }, 
    
    processTrkList: function(args){
        var trkListIds = args.data.TrkListIds;
        if(trkListIds==null || trkListIds==undefined) return {};   
        try {
            var arr = JSON.parse(trkListIds);
            var sourceArray = args.component.refs.TrkListIds.state.options;
        
            let newArray = [];
            arr.map((currentValue, index, array) => {
                // return element to new Array
                if (sourceArray.filter(function(e) { return e.key === currentValue; }).length > 0) {
                      /* contains the element we''re looking for */
                      newArray.push(currentValue);
                }

            });
            CloverApp.API.setDataField("TrkListIds", JSON.stringify(newArray));
            
        } catch (e) {
            return {};
        }
        return {};   

    },
    
    deleteListSample: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const listId = args.data.Id;
        const listSampleIds = [];
        for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            const gridIndex = args.controlRef.state.selectedIndexes[i];
            const listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        const formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);      
        Utils.loadingStart();
        Utils.postFormRequest("/list/deletelistsample",formData).then(
            response => {
                alertify.success(response.message);
                args.controlRef.refresh();
            }, reason => {
                console.log("Error deleting list samples", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },   
    
    toggleListSamplesActive: function(args) {
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].Id);
        if(listSampleIds.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const action = args.parameters.action;
        let waitMessage;
        let url;
        if("enable"===action) {
            url = "/list/enablelistsamples";
            waitMessage = "Enabling selected samples...";
        } else if("disable"===action) {
            url = "/list/disablelistsamples";
            waitMessage = "Disabling selected samples...";
        } else {
            throw "INTERNAL ERROR (UI): Invalid action";
        }
        const listId = args.data.Id;
        const formData = new FormData();
        formData.append("listId", listId);
        formData.append("listSampleIds", listSampleIds);    
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                console.log("disableListSample failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    
    exportSample: function (args){
        let defaultFormName = args.originalData.nameInput + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.QNN_LIST.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.QNN_LIST.provideName);
          }
        }
        var url = ''/list/exportsample?listId='' + args.data.Id + ''&fileName='' + encodeURIComponent(inputName);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please", 15000);
            return {};
        };

        if(password){
            var errors = {};
            var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
            var countChars = function(str, type) {
                var count=0,len=str.length;
                    for(var i=0;i<len;i++) {
                        if(type==0){
                            if(/[A-Z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==1){
                            if(/[a-z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==2){
                            if(/[0-9]/.test(str.charAt(i))) count++;                    
                        }                
                    }
                return count;
            };                
            if(!req.test(password)){
                errors.inputPassword = true;
                errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
            }
    
            if(countChars(password, 0)<3 || countChars(password, 1)<3 || countChars(password, 2)<3){
                errors.inputPassword = true;
                errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }
            
    
            if(errors.passwordComplex){
              throw {
                  level: 1,
                  message: errors.passwordComplex,
                  formerrors: {main: errors}
              };
            }
            if(errors.passwordStrength){
              throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
              };
            }    
        }

        const url = "/list/" + encodeURIComponent(args.data.Id) + "/import";
        const formData = new FormData();
        formData.append("token", token);
        if(password) {
            formData.append("password", password);
        }
        Utils.loadingStart();
        Utils.postFormRequest(url, formData).then(
            response => {
                CloverApp.API.setDataField("inputImportListSample", null);
                CloverApp.API.setDataField("inputPassword", null);
                alertify.success(response.message,10000);
                args.component.refs.modalImportSample.close();
                args.component.refs.gridviewSample.refresh();
                qnn_listUserActions.closeModal(args); 
            }, reason => {
                CloverApp.API.setDataField("inputImportListSample", null);
                alertify.error(reason, 15000);
            }
        ).finally( Utils.loadingStop );
    }, 

    //called by btnSave
    goRecords: function(args){
        var modelArray = args.state.app.form.models.model; 
        var recordsCont= args.state.app.form.models.model[4];
        var isHidden = false;
        
        var newModal= {''key'': recordsCont[''key''], ''data-buildertype'': recordsCont[''data-buildertype''], ''children'': recordsCont[''children''],
        ''style-customcss'': recordsCont[''style-customcss''], ''style-float'':recordsCont[''style-float''], ''style-width'': recordsCont[''style-width''],
        ''style-hidden'': isHidden,};
    
        modelArray.splice(4,1,newModal); //Replace item in whole model series
    
        return {
            app:{
                form:{
                    models:{
                        model: modelArray
                    }
                }
            }
        }
    },
    
    newListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id);
    },
    
    closeModal: function (args){
        CloverApp.API.setDataField("inputImportListSample", null);
        CloverApp.API.setDataField("inputPassword", null);
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: []
                  }
              }
            }
        }       
    },  

    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_listUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_listUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_listUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082';

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-08-01 15:10:38.773', 
[Data]=N'{
    init: function(args) {
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
        }
        
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch(error) {
                //ignore
            }
        }          

        var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
        if(args.data.IsAnonymous){
            qnn_dplyUserActions.getAnonymousSurveyLink(args);
        }

        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_dplyUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
        
        
        // Only get category details
        // iff args.data.Id is not null
    
        var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
        var d1 = new Date();
        return ()=>{
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    method: ''get''
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    qnn_dplyUserActions.showHideControls(args);  
                    console.log("Response is", response);
                    if (response.success) {
                        
                        var _hideControls = args.state.app.form.models.hideControls;
                        var items = response.items;
                        if (items != null)
                        {
                    
                        var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                        var valChkScheduler = obj[0].Id;
                        var EmailRecipients = obj[0].EmailRecipients;
                        var valEmailSuccess ;
                        var valEmailFailure ;
                        
                        if(obj[0].EmailSuccess == true)
                        {
                            valEmailSuccess = ''1'';
                        }
                        else
                        valEmailSuccess = ''0'';
                            
                        if(obj[0].EmailFailure == true)
                        {
                            valEmailFailure = ''1'';
                        }
                        else
                        {
                            valEmailFailure = ''0'';
                        }
                        
                        // var recipients = [];
                        
                        var recipients = [];
                        if(EmailRecipients == "No Recipient")
                        {
                            recipients = [];
                        }
                        else
                        {
                            var breakRecepient = EmailRecipients.split('','');
                            for (let r = 0 ; r < breakRecepient.length ; r++ )
                            {
                            recipients.push(breakRecepient[r]);
                        }
                        
                        }
                
                        /*// alert(items.length);
                        if(items !== undefined && items.length > 0){
                            _removeElement(_hideControls, dailySsForm);
                        }
                        // recipients.push(EmailRecipients);*/
                    
                        CloverApp.API.setDataField("chkScheduler", 1);
                        CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                        CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                        CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                        
                        _removeElement(_hideControls, ''dailySsForm'');  
                        _hideControls.concat(hideControls);
                        return Promise.resolve(
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models: {
                                                hideControls: _hideControls
                                            }
                                        }
                                    },
                                }
                            });  
                            
                        }
                        else
                        {
                            CloverApp.API.setDataField("chkScheduler", 0);
                            CloverApp.API.setDataField("ddlEmailReceipients", []);
                            CloverApp.API.setDataField("chkEmailSuccess", false);
                            CloverApp.API.setDataField("chkEmailFail", false);
                            return {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: args.state.app.form.models.hideControls
                                        }
                                    }
                                }
                            };                    
                        }
                    
                        //  _loadingStop();
                    
                    } // end if response.success        
                }) // end then => response
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
        }; //end return  
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append(''qnnId'', qnnId);
        loadingStart("Verifying survey field alias");
        postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.log(reason);
                alertify.alert(reason);
            }
        ).finally(loadingStop);
    }, //end of checkQnnFields
    
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    
    toggleCompletionUrl: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    
    toggleAnonymousSurvey: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);
        }else{
            CloverApp.API.setDataField("IsMultipleResponse", 0);
        }
    },
    
    downloadInvalidColumns(args) {
        //CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');
    }, // end of downloadInvalidColumns
    
    downloadInvalidDates(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');        
    }, //end of downloadInvalidDates
    
    downloadInvalidUIDs(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');        
    }, //end of downloadInvalidUIDS
    
    viewArgs(args){
      console.log("View Args", args);  
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var dplyId = args.data.Id;
        var qnnId = args.data.dictQuestionnaire;
        var listId = args.data.dictList;

        var errors = {};
        if (qnnId == null || qnnId == undefined)
         alertify.error("Questionnaire not selected");
        if (listId == null || listId == undefined)    
         alertify.error("List not selected''");
        if (dplyId == null || dplyId == undefined)    
         alertify.error("There is no existing deployment");
         
         if (token == null || token == undefined){
             errors.token = ''Please select csv file'';
                
            if(errors.token){
              throw {
                  level: 1,
                  message: ''Check errors on the form!'',
                  formerrors: {main: errors}
              };
            }
            return {};
        }
        
        var url = ''/deployment/importresponse?token='' + token + ''&qnnId='' + qnnId + ''&listId='' + listId + ''&dplyId='' + dplyId;

        var d1 = new Date();
        Utils.loadingStart();
        return ()=>{
            return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Utils.loadingStop();
              
                if (response.success) {
                    var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
                    
                    alertify.success(''The changes have been applied!'');
                    console.log("Response is", response);
                    
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("totalSampleResponseAdded", response.statistics.totalSampleResponseAdded);
                    CloverApp.API.setDataField("totalSampleNoResponse", response.statistics.totalSampleNoResponse);
                    CloverApp.API.setDataField("totalSampleResponseAnsAdded", response.statistics.totalSampleResponseAnsAdded);                    
                    CloverApp.API.setDataField("totalInvalidQnnColumns", response.totalInvalidQnnColumns);
                    CloverApp.API.setDataField("totalInvalidUIDs", response.totalInvalidUIDs);
                    CloverApp.API.setDataField("totalInvalidDates_Updated", response.totalInvalidDates_Updated);
                    CloverApp.API.setDataField("totalInvalidScore_Updated", response.totalInvalidScore_Updated);
                   
                    if(response.statistics.totalSampleResponseAdded !== null && response.statistics.totalSampleResponseAdded != undefined){
                        CloverApp.API.setDataField("invalidQnnColumns", response.invalidQnnColumns);
                        CloverApp.API.setDataField("invalidUIDs", response.invalidUIDs);
                        CloverApp.API.setDataField("invalidDates_Updated", response.invalidDates_Updated);
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
                            }
                        });  
                    }
                } else {
                    alertify.error("Invalid");
                    console.log(response.message);
                }
            })
            .catch(error => {
                Utils.loadingStop();
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, // end of submitFile
    
    closeModal: function (args){
        console.log("Close modal", args);
        args.component.refs.importModal.close();
        if(args.component.refs.moreModal !== undefined)
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []
                }
              }
            }
        }       
    }, //end of closeModal
    
    closeMoreModal: function (args){
        console.log("Close open modal", args);
        args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []//[totalSampleResponseAdded, totalSampleResponseAnsAdded, totalInvalidQnnColumns, totalInvalidUIDs, totalInvalidDates_Updated, totalInvalidScore_Updated, invalidQnnColumns, invalidUIDs, invalidDates_Updated]
                  }
              }
            }
        }       
    }, //end of closeMoreModal
    
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            } 
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        

        return {hideControls: hideControls, showControls: showControls};
    },
    
    //TODO - refactoe
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    
    //TODO - refactor
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    }, //end of setIpRestriction
    
    onClickSave: function (args){
        const data = args.data.chkScheduler;
        const dplyId = args.data.Id;
        
        const emailSuccess = args.data.chkEmailSuccess;
        const emailFail = args.data.chkEmailFail;
        const userId = args.data.ddlEmailReceipients;
   
        const formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);       
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/updateSnapshotJob",formData).then(
            response => {
                console.log(data);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of onClickSave
    
    parseHtml: function(args) {
        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData,
                             msgContentJson: args.component.refs.htmlEditor.state.jsonData
                            }
                        }
                    }
                }
        };  
    },
    
    dropdownQuestionnaireOnChange: function(args) {
        var qnnId = args.sourceControlValue;
        var options = args.sourceControlRef.state.options;
        console.log("Args is", args);
        if(args.data.SurveyName=="" || args.data.SurveyName ==null){
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == qnnId){
                        CloverApp.API.setDataField("SurveyName", options[i]["text"]);
                        break;
                    }
                }
            }
        }   
    },
    
    radioCompletionActionOnChange: function(args) {
    },

    radioCompletionNavBackOnChange: function(args) {
    },

    radioCompletionNavCancelOnChange: function(args) {
    },

    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },

    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }
    }, //end of clearContent

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
    updateFeatureInteraction: function(args) {
        const isExcelEnabled = Utils.isSelected(args.data.IsExcelEnabled);
        const isDelegationEnabled = Utils.isSelected(args.data.RequireAccessCode);
        const isAnonymous = Utils.isSelected(args.data.IsAnonymous);
        const isMultipleResponse = Utils.isSelected(args.data.IsMultipleResponse);
        const isDirectAccessEnabled = Utils.isSelected(args.data.IsDirectAccessEnabled);
        
        if(isAnonymous) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for anonymous surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDelegationEnabled) {
                alertify.error("Delegation Access Code is not supported for anonymous surveys");
                CloverApp.API.setDataField("RequireAccessCode", 0);
            }
            
            if(isDirectAccessEnabled) {
                alertify.error("Direct Access feature is not applicable for anonymous surveys (use anonymous survey links)");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
        if(isMultipleResponse) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for multiple response surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDirectAccessEnabled) {  
                alertify.error("Direct Access is not supported for multiple response surveys");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
    },
    
    validateSampleList: function (args){
        const listId =  args.data.dictList;
        
        if(listId !== ''00000000-0000-0000-0000-000000000000''){
            Utils.loadingStart("Verifying list has samples...");
            Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
                response => {
                    if(!response.result) {
                        CloverApp.API.setDataField("dictList", "");
                        const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(listId)].text;
                        alertify.error("Sample List " + selectedList + " is empty.");
                    }else if(Utils.isSelected(args.data.IsAnonymous) && !response.isAnonymousSampleOnly){
                        CloverApp.API.setDataField("dictList", "");
                        alertify.error("Anonymous Survey is ONLY allow for Anonymous Sample.")
                    }
                }, reason => {
                    console.log(''validateSampleList'', reason);
                }
            ).finally(Utils.loadingStop);
        }
    },
    
    getAnonymousSurveyLink: function (args){
        const dplyId =  args.data.Id;
        const qnnId =  args.data.dictQuestionnaire;
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        const surveyLinkKey = ''anonymous-survey-'';
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/deployment/GenerateAnonymousSurveyURL/" + encodeURIComponent(dplyId) +"/"+ encodeURIComponent(qnnId))
        .then(response => {
                if(response.success && response.result) {
                    htmlLink += ''<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Anonymous Survey URL:</i>'';
                    response.result.forEach(function(item, index){
                        //Does not show as hyperlink due to access anonymous survey will attempt to logout.
                        //let urlLink = ''<li><a href="'' + item.link +''" target="_blank">'' + item.link + ''&nbsp<i>(''+ item.lang +'')</i></a></li>'';
                        let iconBtn = ''<button id="btn-''+surveyLinkKey+index+''" name="btnCopy-anonymous-survey-link" title="Copy" data-link-id="''+surveyLinkKey+index+''" class="''+iconBtnClass+''"><i data-link-id="''+surveyLinkKey+index+''" class="''+iconClass+''" ariahidden="true"></i></button>'';
                        //this urlText is required for the copy action.
                        let urlText = ''<span id="link-''+surveyLinkKey+index+''" style="display:none;">''+item.url +''</span>'';
                        let headerDiv = ''<div style="margin:18px 18px 0px 18px; word-break: break-word;">''+iconBtn +'' '' +item.language + '' '' +urlText+''</div>'';
                        let qrCodeImg = ''<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,'' + item.qrCode +''"  alt="''+item.url+''"/>'';
                        let listItem = ''<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">''+ headerDiv + qrCodeImg + ''</div>'';
                        htmlLink += listItem;
                    });
                    
                    htmlLink += "</div>"
                    
                    CloverApp.API.setDataField("anonymousSurveyLink", htmlLink);
                    
                    //Due to security issue does not allow "unsafe inline", bind separately
                    document.getElementsByName("btnCopy-anonymous-survey-link").forEach(function(btn){
                       btn.addEventListener("click",function(e){
                           e.preventDefault();
                           const copyText = document.getElementById("link-" + e.target.getAttribute(''data-link-id'')).innerText
                           navigator.clipboard.writeText(copyText);
                           alertify.success(''Copied to clipboard!'');
                       })
                    });
                }else{
                    CloverApp.API.setDataField("anonymousSurveyLink", "");
                }
            }, reason => {
                console.log(''getAnonymousSurveyLink'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_dplyUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_dplyUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_dplyUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

UPDATE [dwMetadata] SET
[Id]='927fc400-e371-4fbb-b866-cb020fff46db', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-08-01 15:11:35.643', 
[Data]=N'{
    init: function(args){
      //console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]
        if(args.data.Id){
            CloverApp.API.setDataField("UpdatedDate", new Date());
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.Id);                  
            }
            catch(err) {
                ;
        	}
        } else {
            CloverApp.API.setDataField("Type","O");
        }
        CloverApp.API.setDataField("ErrorText", "");
        
        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_qnnUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
    },  

    customSave: function(args) {
        args.data.UpdatedDate = new Date(); //trigger triggers
        const innerArgs = args;
        Utils.loadingStart("Saving...");
        Utils.changeData(args.data,"QNN_QNN").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_QNN/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    viewArgs: function(args){
        console.log(''View Args'', args);    
    },
    
    GenFormFields:function(args){
        console.dir(args);
        var qnnId = args.data.Id;
        var token = args.data.collectioneditor_1[0].Token;
        var url = ''/qnn/genfields?qnnId='' + args.data.Id + ''&token='' + token;
        $.post(url).done(function (data) {
            if(data.success)
                alertify.success(data.message);
            else
                alertify.error(data.message);
        }).fail(function (jqxhr, textStatus, error) {
           alertify.error(textStatus);
        }); 
        return {};
    },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        
        if(args.data.Title==undefined || args.data.Title==null || args.data.Title.trim() == ''''){
            errorMessages.push(''Please enter questionnaire title'');
            errors.main.Title = true;
            hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
            errorMessages.push(''<br />Please select questionnaire type!'');
            errors.main.Type = true;
            hasError= true;
        }        
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push(''<br />Please insert an online form!'');
                errors.main.collectioneditor_2 = true;
                hasError = true;
            }            
        }
        
        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    convertToOnlineForm: function(args) {
        //nb: it is assumed this is only called for an already saved entity
        CloverApp.API.setDataField("Type","O");
        alertify.success("Type changed to Online. Add an Online form and click Save to apply this change");
        const hideControls = [ "Warning_Type_P", "Type", "Excel_Files_After_Save_Message", "btnConvertToOnlineForm" ];
        return {
            app: {
                form: {
                    models: {
                        hideControls: hideControls,
                    },
                },
            },
        }; //end of state delta
    }, // end of convertToOnlineForm
    
    showLangWarning: function(args) {
        Utils.queueHideControl("Warning_nolanguage_file",''show'');
    },
    
    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_qnnUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_qnnUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_qnnUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_qnnUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_qnnUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_qnnUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}







' WHERE [Id]='927fc400-e371-4fbb-b866-cb020fff46db';

UPDATE [dwMetadata] SET
[Id]='d6d4a9c0-8e4b-4142-91a3-aede215ba6d3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTags-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-17 10:12:22.957', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-08-01 15:13:22.783', 
[Data]=N'{
    init: function(args){
        //Grid init
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                cols.name.customFormatter = nameColumnFormatter;
                cols.tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        }; 
        
        const tagsColumnFormatter = function (p){
            if(p.row.tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.tags);
            let tagsLabel = new Array();
            for(x=0;x<tags.length;x++) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
            }
            return CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const nameColumnFormatter = function (p) {
            let source = p.row.sourceTable;
            let name = p.row.name;
            let url;
            switch (source) {
                case "Deployment" :
                    url = "/form/QNN_DPLY/";
                    break;
                case "List" :
                    url = "/form/QNN_LIST/";
                    break;
                case "Form" :
                    url = "/form/QNN_QNN/";
                    break;
            }
            url = url + p.row.id;
            
            const onClickGoTo = () => { window.location = url };
            return CloverApp.API.createElement("span", { onClick: onClickGoTo, className: "link-style" }, name);
        };
        CloverApp.API.rewriteControlModel("gvTags", gridModelRewriter);
        //Grid init End
        
        //Get tags from session storage
        let tagsName = sessionStorage.getItem("tagsName");
        tagsName = tagsName == null ? "" : tagsName;
        sessionStorage.clear();
        
        if(tagsName !== "") {
            CloverApp.API.setDataField("TagsInSearch", tagsName);
        }
        tagsName = JSON.stringify(new Array(tagsName));
        swztagsUserActions.getTagsData(args,tagsName);
        swztagsUserActions.getPopularTags();
    },
    
    getPopularTags: function(){
        try{
            let NumberOfUniqueTagsShows = 10;
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        swztagsUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        swztagsUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTags: function(args){
        let tagsSelected = args.data.TagsInSearch;
        let tagsSelectedName = new Array();
        if(tagsSelected!== null){
            tagsSelectedName = JSON.stringify(tagsSelected);
            swztagsUserActions.getTagsData(args,tagsSelectedName);
        }
    },
    
    getTagsData: function(args, tagsSelectedName) {
        try{
            Utils.loadingStart();
            Utils.getRequest("/tags/tagsPanelSearch?tagsSelectedName=" + encodeURIComponent(tagsSelectedName))
            .then(response => {
                    if(response.success && response.item !== null) {
                        //Write to GRID
                        CloverApp.API.setDataField("gvTags", response.item);
                        args.component.refs.gvTags.refresh();
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        alertify.error("Tags not found");
                        CloverApp.API.setDataField("gvTags", null);
                        args.component.refs.gvTags.refresh();
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsToSearch);
            let tagsInSearch = args.data.TagsInSearch;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        let tagsPopular = result;
                        if(Array.isArray(tagsInSearch)){
                            tagsPopular = tagsPopular.filter(x => !tagsInSearch.includes(x));
                        }
                        swztagsUserActions.rewriteSearchedTags(tagsPopular);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        swztagsUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error(reason);
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(tags){
        const divTagsSearch = function (model) {
            model.children.splice(2);
            if(tags.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<tags.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(tags[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearch", divTagsSearch);
        CloverApp.API.setDataField("divTagsSearch", null);
    },
    
    addTagToDropdown: function (args){
        var tagName = args.sourceControlRef.props.additionalParams.model.content;
        let tagsInSearch = args.data.TagsInSearch;
        
        if(tagsInSearch!=null){
            if(!tagsInSearch.includes(tagName)) {
                tagsInSearch.push(tagName);
                CloverApp.API.setDataField("TagsInSearch", tagsInSearch);
            }
        } else {
            CloverApp.API.setDataField("TagsInSearch", new Array(tagName));
            args.data.TagsInSearch = new Array(tagName);
        }
        args.component.refs.TagsInSearch.forceUpdate();
        swztagsUserActions.searchTags(args);
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearch = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearch", divTagsSearch);
        CloverApp.API.setDataField("divTagsSearch", null);
    },
    
}' WHERE [Id]='d6d4a9c0-8e4b-4142-91a3-aede215ba6d3';

