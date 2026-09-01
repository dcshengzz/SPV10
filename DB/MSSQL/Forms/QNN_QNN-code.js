{
    init: function(args){
      //console.log('View Args', args);    
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
                console.error(reason);
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    viewArgs: function(args){
        console.log('View Args', args);    
    },
    
    GenFormFields:function(args){
        console.dir(args);
        var qnnId = args.data.Id;
        var token = args.data.collectioneditor_1[0].Token;
        var url = '/qnn/genfields?qnnId=' + args.data.Id + '&token=' + token;
        $.post(url).done(function (data) {
            if(data.success)
                alertify.success( Utils.encodeHTML(data.message) );
            else
                alertify.error( Utils.encodeHTML(data.message) );
        }).fail(function (jqxhr, textStatus, error) {
           alertify.error( Utils.encodeHTML(textStatus) );
        }); 
        return {};
    },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        
        if(args.data.Title==undefined || args.data.Title==null || args.data.Title.trim() == ''){
            errorMessages.push('Please enter questionnaire title');
            errors.main.Title = true;
            hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
            errorMessages.push('Please select questionnaire type!');
            errors.main.Type = true;
            hasError= true;
        }        
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push('Please insert an online form!');
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
        Utils.queueHideControl("Warning_nolanguage_file",'show');
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
                      case 'TAGS_NOT_FOUND':
                        qnn_qnnUserActions.rewriteSearchedTags('');
                        break;
                      default:
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.error(e);
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
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.error(e);
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
        newTags = newTags.filter((newTags) => newTags != ' ');
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







