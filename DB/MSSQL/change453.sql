-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY-code.js
-- DataEditorDeployment-code.js

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-15 18:04:48.843', 
[Data]=N'{
    init: function(args) {
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
        }
        
        if(args.data.IsIncludeUnansweredSection == null ){
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
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
        //update (job data) (word ''get'' in url is legacy)
        Utils.postFormRequest("/report/getJobData",formData).then(
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
                        alertify.error("Sample List " + Utils.encodeHTML(selectedList) + " is empty.", 10000);
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
        if(args.data.addedTags != null && originalTags != null){
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
            args.data.ddTags = new Array(tagsName);
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
[Id]='4af67164-5e60-4905-9885-afd6da24cb3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-15 16:38:47.740', 
[Data]=N'{
    init: function (args) {
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi));                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------

        if(args.data.IsAnonymous){
            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
        }
        
        const innerArgs = args; //Used in column formatters
        const iconBtnClass = "ui icon button mini secondary";
        const iconBtnDisabledClass = "ui icon button mini disabled";
        
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};

        const CLEARED = ''129C7781-536D-42F6-ACA4-33A62F2E2C1F''.toLowerCase();

        const genFormLinkButtons = function(p, elements, languages, formName, index){
            const dlsi = p.row.Id;
            const isMultipleResponse = !!innerArgs.data.IsMultipleResponse;
            const isAnonymous = !!innerArgs.data.IsAnonymous;
            //Render new response button for multiple response surveys
            if(isMultipleResponse || isAnonymous) {
                const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                const responseNotCleared = (status!==CLEARED);
                
                const showActionAdd = responseNotCleared;
                if( showActionAdd ) {
                    const onClickNew = () => {
                        createNewResponseAndOpen(dlsi, formName);
                    };
                    elements.push(
                        CloverApp.API.createElement("span", { 
                            onClick: onClickNew  , className: "link-style", style: { color: "green", paddingRight: "0.5em" }
                        },''Add |'')
                    );
                }
            }
            
            //Render Form link
            const onClickForm = () => {
                redirectToSurvey(dlsi, formName, p.row.RespId);
            };
            elements.push(
                CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
            );
            elements.push( CloverApp.API.createElement("br") );
        };

        const createNewResponseAndOpen = function(dlsi, formName) {
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/dataeditor/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks");
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        const showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks for Reject Response modal");
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        const showUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/dataedit/upload/xlsx?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                  Utils.loadingStop();
                  if(!success) {
                      console.log("Upload failed", xhr, msg, err);
                      if(xhr.status=== 400) {
                          alertify.error("Upload Failed - " + xhr.statusText + " - " + xhr.responseText, 15000);
                      } else if(xhr.status===413) {
                          alertify.error("Upload Failed - the selected file is too large to be uploaded here", 15000);
                      } else {
                          alertify.error("Upload Failed - " + msg + " - " + err, 15000);
                      }
                  }
                };
                console.log("rewrote model",model);
            });
            
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            CloverApp.API.setDataField("UploadFormNames", formNames);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: i,
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", 0);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        }; //end of showUploadModal
   
        const showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            //console.log(''showTrkListsModal args: '', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", Utils.encodeHTML(UID));
            CloverApp.API.setDataField("trkListSample_email", Utils.encodeHTML(Email));  
            CloverApp.API.setDataField("trkListSample_name", Utils.encodeHTML(Name));              
            CloverApp.API.setDataField("trkListSample_remarks", Utils.encodeHTML(Remarks));
            CloverApp.API.setDataField("trkListSample_status", Utils.encodeHTML(Status));       
            CloverApp.API.setDataField("trkListSample_statusTitle", Utils.encodeHTML(StatusTitle));

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();

            var formData = new FormData();
            formData.append(''uid'', UID);    
            Utils.loadingStart("Retrieving Track List Information");
            Utils.postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error(reason);
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(Utils.loadingStop);  
        };

        const openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField(''gridDelegate'', null);
            var url = ''/dataeditor/viewdelegatelist?dlsi='' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                CloverApp.API.setDataField(''gridDelegate'', data.item);
                args.controlRef.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error(data.message);
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            });
        };

        //just used by Exempt button right now
        const setStatus = function (args, id, statusId, message) {
            if(!message) {
                message = { parameters: { 
                    confirmTitle: "setStatusConfirmTitle", 
                    confirmText: "setStatusConfirmText"
                } };
            }
            CloverApp.API.confirm(message?message:args).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);        
                formData.append(''selectedStatusId'', statusId);
                Utils.loadingStart("Setting Status");
                Utils.postFormRequest("/dataeditor/setStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();
                        alertify.success(response.message);
                    }, reason => {
                        console.error("Failed to set status", reason);
                        alertify.error(reason);
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{/*Empty catch to avoid error show at the console*/})
        };
        
        //used by Reset
        const resetStatus = function (args, id, respId) {
            const message = { 
                parameters: { 
                    confirmTitle: "resetResponseConfirmTitle", 
                    confirmText: "resetResponseConfirmText", 
                    confirmOk: "resetResponseConfirmOk"
            } };
            CloverApp.API.confirm(message).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);
                if(respId){
                    formData.append(''respId'', respId);                
                }
                Utils.loadingStart("Resetting Status");
                Utils.postFormRequest("/dataeditor/resetStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();     
                        alertify.success(response.message);
                        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                        }
                    }, reason => {
                        console.error("Failed to reset status", reason);
                        alertify(reason);
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{ /*Empty catch to avoid error show at the console*/})
        }; 
         
        const remarksPreview = function(text) {
            const previewLength = 32;
            return ''"'' + (text.length<=previewLength ? text : text.substring(0,previewLength)+"...") + ''"'';
        } ;
        
        const remarksFormatter = function (p) {
            const hasRemarks = (p.row.Remarks!=null);
            const iconClass = hasRemarks 
                ? ''comments outline icon'' 
                : ''comment outline icon'';
            const tooltip = hasRemarks 
                ? ''View/Edit Remarks''+remarksPreview(p.row.Remarks)
                : ''Set Remarks'';
            const icon = CloverApp.API.createElement("i", {className: iconClass, ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup(tooltip, popupProps, btn);
        };

        const exemptFormatter = function (p) {
            const exemptStatusGUID = ''9731DE1D-2B6A-484C-BF10-44F842A3140E'';
            const icon = CloverApp.API.createElement("i", {className: "cut icon",ariaHidden: "true" }, "");
            const btnText = "Set Exempt Status";
            let element;
            if(p.row.StatusCode==''PE''){
                const exemptMessage = { parameters: { 
                    confirmTitle: "exemptConfirmTitle", 
                    confirmText: "exemptConfirmText",
                    confirmOk: "exemptConfirmOk"
                } };
                const btn = CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, exemptStatusGUID, exemptMessage), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }      
            
            return element;
        };

        const resetFormatter  = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "undo icon",ariaHidden: "true" }, "");
            const btnText = "Reset Response";
            let element;
            if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                const btn = CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass },icon);
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass },icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, container);
            }
            return element;
        }; 
        
        const rejectFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "thumbs down outline icon",ariaHidden: "true" }, "");
            const btnText = "Reject Response";
            let element;
            if(p.row.StatusCode==''SB''){
                const btn = CloverApp.API.createElement("button", { onClick: () => showRejectResponseModal(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn);//For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }  
            return element;
        };

        const trackFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "ban icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { 
                onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.ToEmails, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), 
                className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Track List", popupProps, btn);
        };
        
        const delegateHistoryFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "history icon",ariaHidden: "true" }, "");
            if(innerArgs.data.RequireAccessCode) {
                const btn = CloverApp.API.createElement("button"
                    ,{ onClick: () => openDelegateHistoryModal(innerArgs, p.row.Id), className: iconBtnClass }
                    , icon);
                
                return CloverApp.API.createElementWithPopup("Delegation History", popupProps, btn);
            } else { 
                return CloverApp.API.createElement("span", {}, "");
            }
        }; //end of DelegateHistoryFormatter

        //Excel Response upload button
        const excelUploadFormatter = function (p) {
            const isOnlineSurvey = ("O"===p.row.Type) && !!p.row.FormNames;
            const hasFiles = isOnlineSurvey && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
            const alwaysShowForDataEditor = true;
            const showUploadButtonInAppropriateStatus = isOnlineSurvey && (hasFiles || alwaysShowForDataEditor);
            if(showUploadButtonInAppropriateStatus) {
                const uploadIcon = CloverApp.API.createElement("i", {className: "file excel outline icon",ariaHidden: "true" }, "");
                //const uploadIcon = CloverApp.API.createElement("i", {className: "upload icon",ariaHidden: "true" }, "");
                const excelEnabledForDply = true; //was innerArgs.data.IsExcelEnabled;
                const uploadButtonText = "Upload Response from Excel";
                if(!excelEnabledForDply && !alwaysShowForDataEditor) {
                    const blank = CloverApp.API.createElement("div", {}, "");
                    return blank;
                } else if( (p.row.StatusCode=="PE" || p.row.StatusCode=="DE") ) {
                    //Upload option is available for Pending and In-Progress
                    const formNames = p.row.FormNames.split(''||''); //used for form selection after upload
                    const languages = p.row.Languages.split(''||''); 
                    const btn = CloverApp.API.createElement("button", { 
                            onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id),
                            className: iconBtnClass, style:{marginBottom:"2.75px"}}, uploadIcon);
                            
                    const popup = CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, btn);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  popup); //For disabled component, require a div to cover in order to show the popup.
                    
                    return container;
                } else {
                    const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, uploadIcon);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  btn);
                    const popup=CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, container);
                    
                    //Show a disabled button for other status 
                    return popup;
                }
            }     
        }

        const allActionsFormatter = function (p) {
            const elements = [];
            
            elements.push(excelUploadFormatter(p));
            
            if(p.row.UID !== "swzanonymous"){
                elements.push(trackFormatter(p));
            }
            
            elements.push(remarksFormatter(p));
            elements.push(delegateHistoryFormatter(p));
            const allBtn = CloverApp.API.createElement("div", {}, elements);
            return allBtn;
        };
        
        const statusFormatter  = function (p) {
            const isAnonymousRespondent = "swzanonymous"===p.row.UID;
            
            const elements = [];
            elements.push(resetFormatter(p));
            if(!isAnonymousRespondent){elements.push(rejectFormatter(p));}
            if(!isAnonymousRespondent){elements.push(exemptFormatter(p));}
            const updateStatusDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },elements );
            
            if(!isAnonymousRespondent){
                const statusText = p.value;
                const statusBtn = CloverApp.API.createElement("button", { 
                        onClick: () => dataeditordeploymentUserActions.showStatusModal(innerArgs, p.row.Id), 
                        className: "ui button mini secondary invert", 
                        style: { minWidth: "100px" }, 
                    },statusText);
                return [statusBtn, updateStatusDiv];
            }else{
                return [updateStatusDiv];
            }
            
        }; 
        
        const uploadedExcelLinksFormatter = function (p) {
            const elements = [];

            //Response download link
            if(p.row.IsExcelResponse) {
                const responseLinkText = dayjs(p.row.ExcelUploadDate).format("DD MMM YYYY HH:mm");// + (p.row.IsExcelResponseDE ? " (DE)" : "");
                const downloadUrl = "/dataedit/download/response/" + p.row.Id + "/" + p.row.RespId;
                const downloadLinkBtn = [];
                const linkBtn = CloverApp.API.createElement("a", 
                    { href: downloadUrl, target: "_blank", style: {fontStyle: "italic"}},
                    responseLinkText);    
                    downloadLinkBtn.push(linkBtn);
                if(p.row.IsExcelResponseDE){
                    element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                    downloadLinkBtn.push(element);
                    const dataEditorIcon = CloverApp.API.createElement("i",{className: "edit icon",ariaHidden: "true" }, "");
                    element = CloverApp.API.createElementWithPopup("By Data Editor", popupProps, dataEditorIcon);
                    downloadLinkBtn.push(element);
                }
                
                const marginDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },downloadLinkBtn );      
                elements.push(marginDiv);
                
            }
            
            if(elements.length===0) {
                elements.push( CloverApp.API.createElement("div", {}, p.value) );
            }
            return elements;
        }; //end of xlsxActionsFormatter

        const formNamesFormatter = function (p) {
            var elements = [];
            if(p.row.Type=="O"){
                var strFormNames = p.row.FormNames;
                var strLanguages = p.row.Languages;
                var formNames = strFormNames.split(''||'');
                var languages = strLanguages.split(''||'');      
                
                //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));

                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, p.value); 
            }    
        }; //end of formNamesFormatter

        const fileNamesFormatter = function(p) {
            //const isExcelEnabled = innerArgs.data.IsExcelEnabled;
            const isExcelEnabled = true;
            if(p.row.Type=="O" && isExcelEnabled){
                var elements = [];
                var element;
                if(p.row.FileLanguages) {
                    const fileNames = p.row.FileNames.split(''||'');
                    const fileLanguages = p.row.FileLanguages.split(''||'');
                    const fileTokens = p.row.FileTokens.split(''||'');   
                    for(var i=0; i < fileNames.length; i++) {
                        const token = fileTokens[i];
                        const linkUrl = "/dataedit/download/xlsx/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                        elements.push(element);
                        element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                        elements.push(element);
                        elements.push( CloverApp.API.createElement("br") );
                    }
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }  
        }; //end of FileNamesFormatter
        
        //origin indicators
        const initialResponseFormatter  = function (p) {
            
            //todo - define style in .css file as a class
            const attrAs =  { className: "ui label tiny", style: { margin: "2px", background: "#defffc" } };
            const attrBy =  { className: "ui label tiny", style: { margin: "2px", background: "#fffae0" } };
            const attrVia = { className: "ui label tiny", style: { margin: "2px", background: "#f0ffab" } };
            
            const elements = [];
            if(p.row.InitialResponseAs !== "Unknown" && p.row.InitialResponseAs !== "PrePopulated" && p.row.InitialResponseAs !== null){
                const iniResponseAs = CloverApp.API.createElement("div", attrAs, p.row.InitialResponseAs);
                elements.push(iniResponseAs);
            }
            
            if(p.row.InitialResponseBy !== "Unknown" && p.row.InitialResponseBy !== null){
                const iniResponseBy = CloverApp.API.createElement("div", attrBy, p.row.InitialResponseBy);
                elements.push(iniResponseBy);
            }
            
            if(p.row.Tags !== null && p.row.Tags !== ''[]'' && p.row.Tags !== undefined && p.row.Tags !== ''undefined'' && p.row.Tags !== ''null''){
                var tags = JSON.parse(p.row.Tags);
                let tagsLabel = new Array();
                if(tags.length > 3) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label tiny", style: {margin: "2px"}}, tags.length));
                } else {
                    for(x=0;x<tags.length;x++) {
                        tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label tiny", style: {margin: "2px"}}, tags[x]));
                    }
                }
                elements.push(CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel)); 
            }
            
            // via is hidden since we only have online now
            /*if(p.row.InitialResponseVia !== "Unknown" && p.row.InitialResponseVia !== null){
                const iniResponseVia = CloverApp.API.createElement("div", attrVia, p.row.InitialResponseVia);
                elements.push(iniResponseVia);
            }*/
            return elements;
            
        };  

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );

                cols.FormNames.customFormatter = formNamesFormatter;
                cols.FileNames.customFormatter = fileNamesFormatter;
                cols.InitialResponse.customFormatter = initialResponseFormatter;
                cols.StatusTitle.customFormatter = statusFormatter;
                cols.ExcelSupport.customFormatter = uploadedExcelLinksFormatter; 
                cols.AllAction.customFormatter = allActionsFormatter; 
                
            }
            return model;
        }; //end of gridModelRewriter

        args.data.remarks = null;
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
    getAnonymousSampleInfo: function(args){
        var anonymousFormData = new FormData();
        anonymousFormData.append(''dplyid'',args.data.Id);
        Utils.loadingStart();
        Utils.getRequest("/dataeditor/getanonymoussampleinfo", anonymousFormData)
        .then(response => {
            if(response.success){
                CloverApp.API.setDataField("swzAnonymousDplySampleInfoId", response.item.swzAnonymousSampleInfoId);
                CloverApp.API.setDataField("dlsi", response.item.swzAnonymousSampleInfoId); 
                args.component.refs.btnAnonymousStatus.props.additionalParams.model.content = ''Status: '' + response.item.status;
                args.component.refs.btnAnonymousStatus.forceUpdate();
            }
        }, reason => {
            console.error("Failed to get anonymous sample info", reason);
            alertify(reason);
        }).finally(Utils.loadingStop);
    },
    
    showStatusModal: function (args, id) {
        const innerArgs = args; //Used in column formatters
        var formData = new FormData();
        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
            id = args.data.swzAnonymousDplySampleInfoId;
        }
        
        formData.append(''id'', id);   
        CloverApp.API.setDataField("dlsi", id); 
        Utils.loadingStart("Retrieving Status Options");
        Utils.postFormRequest("/dataeditor/GetStatusItems", formData).then(
            response => {
                //args.state.app.extra.spData = id;
                //args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                const options = response.item;
                if(Array.isArray(options) && options.length>0) {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", options);
                    CloverApp.API.setDataField("dropdownStatus", null);
                } else {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", {} );
                    CloverApp.API.setDataField("dropdownStatus", null);
                }
                
                args.component.refs.statusModal.props.swzData.isOpen = true;
                args.component.refs.statusModal.openModal();
                
                args.component.refs.dropdownStatus.forceUpdate();
                
            }, reason => {
                console.error("Failed to get status items", reason);
                alertify.error(reason);
                args.component.refs.statusModal.close();
            }
        ).finally(Utils.loadingStop);
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
        
        Utils.loadingStart("Updating Track List");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success(response.message);
                    CloverApp.API.setDataField("dictionaryTrkList", null);  
                    CloverApp.API.setDataField("trkListSample_uid", null);
                    CloverApp.API.setDataField("trkListSample_email", null);    
                    CloverApp.API.setDataField("trkListSample_name", null);                 
                    CloverApp.API.setDataField("trkListSample_remarks", null);
                    CloverApp.API.setDataField("trkListSample_status", null);       
                    CloverApp.API.setDataField("trkListSample_statusTitle", null);        
                } else {
                    alertify.error(response.message);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(()=>{       
                Utils.loadingStop();
            });
    },    
    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        //console.log(''selectedStatusId'', selectedStatusId);
        if(selectedStatusId === undefined || selectedStatusId === null){
            alertify.error(''Please select a status.'');
            return;
        }
        
        formData.append(''id'', args.data.dlsi);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
        
        Utils.loadingStart("Updating status...");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
                    
                    if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                        dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                    }
                
                } else {
                    alertify.error(response.message);
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
    },
    
    submitRemarks: function (args) {
        const modal = args.component.refs.remarksModal;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);
        formData.append("remarks", args.data.remarks ? args.data.remarks.trim() : "");
        Utils.loadingStart("Updating Remarks");
        Utils.postFormRequest("/dataeditor/setremarks", formData).then(
            response => {
                modal.close();
                alertify.success(response.message);
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue; //ExcelFileUpload
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if(result === "OK") {
            args.component.refs.fileUploadModal.close(); 
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers updated from file");
            if(formName) {
                CloverApp.API.redirect("form", formName, ''dlsi/''+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    }, //end of excelFileUploaded
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
        const remarks = args.data.RejectResponseRemarks ? args.data.RejectResponseRemarks.trim() : ""
        if(""===remarks) {
            alertify.error("Remarks are required here");
            return {};
        }
        
        const modal = args.component.refs.mdl_RejectResponse;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);  
        formData.append("respId", args.data.RejectResponseRespId);
        formData.append("remarks", remarks );
        Utils.loadingStart("Rejecting Response");
        Utils.postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success(response.message, 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error(reason, 15000);
                grid.refresh();
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    onChangeSearch: function(args) {
        const caseSearch = args.data.CaseSearch ? args.data.CaseSearch : null;
        const generalSearch = args.data.GeneralSearch ? args.data.GeneralSearch : null;
        const selectedStatus = args.data.dictStatus && args.data.dictStatus.length>0 ? args.data.dictStatus : null;
        const filterComplete = args.data.dropdownComplete ? args.data.dropdownComplete : null;
        var filterArr = [];
        
        if(caseSearch) {
            filterArr.push({
                column: "UID",
                term: "like",
                value: caseSearch
            });
        }
        
        if(generalSearch) {
            filterArr.push({
                column: "UIDName, UpdatedBy, StatusTitle, ToEmails, InitialResponseAs, InitialResponseBy, InitialResponseVia",
                term: "like",
                value: generalSearch
            });
        }
        
        if(selectedStatus) {
            const tempArr = [];
            for(let i = 0; i < selectedStatus.length; i++){
                tempArr.push(selectedStatus[i]);
            };
            
            filterArr.push({
                column: "Status",
                term: "in",
                value: tempArr
            });
        }

        if(filterComplete) {
            filterArr.push({
               column: "DateComplete",
               nextValue: "",
               term: filterComplete == "true" ? "!=" : "=",
               value: "",
            });
        }
        
        return {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filterArr
                            }
                    }
                }
            }
        };
        
    },

}






' WHERE [Id]='4af67164-5e60-4905-9885-afd6da24cb3d';

