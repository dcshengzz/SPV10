{
    init: function(args) {
        const isNewDply = !args.data.Id;
        if(isNewDply){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
            CloverApp.API.setDataField("MaxResponse","-1");
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
        
        if(!isNewDply){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch(error) {
                console.error(error);
            }
        }          

        if (isNewDply) {
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
        } else {
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
        }
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append('qnnId', qnnId);
        Utils.loadingStart("Verifying survey field alias");
        Utils.postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.error("check fields failed", reason);
                alertify.alert( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
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
        //CloverApp.API.setDataField("invalidQnnColumns",['A11', 'B22', 'C33']);
        
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
                alert('No information found')
            }                 
        } 
        downloadFile('invalidQnnColumns');
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
                alert('No information found')
            }                 
        } 
        downloadFile('invalidDates_Updated');        
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
                alert('No information found')
            }                 
        } 
        downloadFile('invalidUIDs');        
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
                args.data.RestrictIpInclusive='1';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive='0';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, 'RestrictIpInclusive');
            qnn_dplyUserActions.addUniqueElement(showControls, 'countryOrIpRange');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange='1';
            }
            else{
                args.data.countryOrIpRange='0';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", '1');
                qnn_dplyUserActions.addUniqueElement(hideControls, 'IpRange');  
                qnn_dplyUserActions.addUniqueElement(showControls, 'IpCountry');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", '0');
                qnn_dplyUserActions.addUniqueElement(hideControls, 'IpCountry');  
                qnn_dplyUserActions.addUniqueElement(showControls, 'IpRange');                         
            } 
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, 'RestrictIpInclusive');  
            qnn_dplyUserActions.addUniqueElement(hideControls, 'countryOrIpRange');    
            qnn_dplyUserActions.addUniqueElement(hideControls, 'IpRange');  
            qnn_dplyUserActions.addUniqueElement(hideControls, 'IpCountry');                
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
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, 'IpCountry');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, 'IpRange');             
            
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
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, 'IpRange');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, 'IpCountry');      
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
        
        if(listId !== '00000000-0000-0000-0000-000000000000'){
            Utils.loadingStart("Verifying list has samples...");
            Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
                response => {
                    if(!response.result) {
                        CloverApp.API.setDataField("dictList", "");
                        const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(listId)].text;
                        alertify.error( Utils.encodeHTML("Sample List " + selectedList + " is empty."), 10000);
                    }else if(Utils.isSelected(args.data.IsAnonymous) && !response.isAnonymousSampleOnly){
                        CloverApp.API.setDataField("dictList", "");
                        alertify.error("Anonymous Survey requires list with only the anonymous sample.")
                    }
                }, reason => {
                    console.log('validateSampleList', reason);
                }
            ).finally(Utils.loadingStop);
        }
    },
    
    getAnonymousSurveyLink: function (args){
        const dplyId =  args.data.Id;
        const qnnId =  args.data.dictQuestionnaire;
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        const surveyLinkKey = 'anonymous-survey-';
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/deployment/GenerateAnonymousSurveyURL/" + encodeURIComponent(dplyId) +"/"+ encodeURIComponent(qnnId))
        .then(response => {
                if(response.success && response.result) {
                    htmlLink += '<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Anonymous Survey URL:</i>';
                    response.result.forEach(function(item, index){
                        //Does not show as hyperlink due to access anonymous survey will attempt to logout.
                        //let urlLink = '<li><a href="' + item.link +'" target="_blank">' + item.link + '&nbsp<i>('+ item.lang +')</i></a></li>';
                        let iconBtn = '<button id="btn-'+surveyLinkKey+index+'" name="btnCopy-anonymous-survey-link" title="Copy" data-link-id="'+surveyLinkKey+index+'" class="'+iconBtnClass+'"><i data-link-id="'+surveyLinkKey+index+'" class="'+iconClass+'" ariahidden="true"></i></button>';
                        //this urlText is required for the copy action.
                        let urlText = '<span id="link-'+surveyLinkKey+index+'" style="display:none;">'+item.url +'</span>';
                        let headerDiv = '<div style="margin:18px 18px 0px 18px; word-break: break-word;">'+iconBtn +' ' +item.language + ' ' +urlText+'</div>';
                        let qrCodeImg = '<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,' + item.qrCode +'"  alt="'+item.url+'"/>';
                        let listItem = '<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">'+ headerDiv + qrCodeImg + '</div>';
                        htmlLink += listItem;
                    });
                    
                    htmlLink += "</div>"
                    
                    CloverApp.API.setDataField("anonymousSurveyLink", htmlLink);
                    
                    //Due to security issue does not allow "unsafe inline", bind separately
                    document.getElementsByName("btnCopy-anonymous-survey-link").forEach(function(btn){
                       btn.addEventListener("click",function(e){
                           e.preventDefault();
                           const copyText = document.getElementById("link-" + e.target.getAttribute('data-link-id')).innerText
                           navigator.clipboard.writeText(copyText);
                           alertify.success('Copied to clipboard!');
                       })
                    });
                }else{
                    CloverApp.API.setDataField("anonymousSurveyLink", "");
                }
            }, reason => {
                console.log('getAnonymousSurveyLink', reason);
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
                      case 'TAGS_NOT_FOUND':
                        qnn_dplyUserActions.rewriteSearchedTags('');
                        break;
                      default:
                        console.error("failed to get active tags", reason);
                        alertify.error( Utils.encodeHTML(reason) );
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
                        alertify.error( Utils.encodeHTML(reason) );
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
                label['content'] = "Tag Not Found...";
                label['data-buildertype'] = "staticcontent";
                label['key'] = "lblNotFound";
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
        newTags = newTags.filter((newTags) => newTags != ' ');
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
            model['data-elements'] = new Array();
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
}