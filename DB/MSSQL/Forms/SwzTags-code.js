{
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
                      case 'TAGS_NOT_FOUND':
                        swztagsUserActions.rewriteSearchedTags('');
                        break;
                      default:
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
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
                        alertify.error( Utils.encodeHTML(reason) );
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
                label['content'] = "Tag Not Found...";
                label['data-buildertype'] = "staticcontent";
                label['key'] = "lblNotFound";
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
    
}