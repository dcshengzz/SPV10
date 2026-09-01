{
    init: function (args){
        var getParameterByName = function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        };
        
        var getListId = function() {
            var url = window.location.href;
            var parts = url.split('/');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };   
        
        return () => {
            var listId = args.data.DictionaryListName
            var url = '/list/genListprop/' + listId+ '/' + args.data.Id;
            if(args.data.Id==undefined || args.data.Id==null){
                //listId = getParameterByName('listId');
                listId = getListId();
                url = '/list/genListprop/' + listId+ '/'
            }
            if(listId==null || listId==undefined) return Promise.resolve();
            Utils.loadingStart();
            return Utils.getRequest(url).then(
                response => {
                if (!response.success) {
                    CloverApp.API.redirect('form', "SwzListList");
                }
                var item = JSON.parse(response.item);
                if(args.data.Id==undefined || args.data.Id==null) item.data['DictionaryListName'] = listId;
                if(item.model.length==0) return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: {
                                            DictionaryListName: listId
                                        }
                                    }
                                },                                
                                
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                );
                
                const customBlockModelRewriter = function (model) {
                    model.source = JSON.stringify(item.model);
                    return model;
                }; 
                CloverApp.API.rewriteControlModel("customBlockSampleProps", customBlockModelRewriter);

                var readOnlyArray = args.state.app.form.models.readOnlyControls;
                var rule = item.rule;
                for (var key in rule) {
                    if(rule[key]["readOnly"] =="true"){
                        readOnlyArray.push(key);
                    } 
                }                  
                
                return Promise.resolve({
                    stateDelta: {
                        app: {
                            form: {
                                data: {
                                    modified: item.data
                                },
                                models:{
                                    readOnlyControls: readOnlyArray
                                }
                            },
                            extra: {
                                spData: item
                            }
                        },
                    }
                });             
                
            	}, reason => {
            		alertify.error( Utils.encodeHTML(reason) );
            	}
            ).finally( Utils.loadingStop );
        };
    },
    
    saveProp: function(args){
        var hasError = false;
        var errors = {main: {}};    
        var messages = [];
        
        if(args.data.DictionaryListName == null || args.data.DictionaryListName == Utils.EMPTY_GUID){
            hasError = true;
            messages.push("List Title is required");
            errors.main["DictionaryListName"] = true;
        }
        
        if(args.data["dictionarySample"] == null || args.data["dictionarySample"] == Utils.EMPTY_GUID) {
            hasError = true;
            messages.push("Sample is required");
            errors.main["dictionarySample"] = true;
        }
            
        if(!hasError){
            var data = args.state.app.extra.spData.data;
            var model = args.state.app.extra.spData.model;
            var rule = args.state.app.extra.spData.rule;
            
            //List Sample Properties validation
            if(model.length>0){
                for (var key in data) {
                    if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                        hasError = true;
                        messages.push("<br />" + key + " is required");
                        errors.main[key] = true;
                    }
                    
                    if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                        
                        let funcArgs = 'value, data';
                        let body = 'return ' + rule[key]["txtRegExp"];
                        let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                        if (typeof isValid === 'boolean'){
                            if (isValid === false) {
                                hasError = true;
                                messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                                errors.main[key] = true;
                            }
                        }
                        else{
                            error = isValid;
                        }
                    }
                }
            }
        }

        if(hasError){
            throw {
                level: 1,
                message: messages,
                formerrors: errors
            };
        }
        

        return ()=> {
            var listSampleId = args.data.Id;
            var listId = args.data.DictionaryListName;
            var formData = new FormData();
            formData.append('listSampleId', listSampleId);
            formData.append('listId', listId);        
            formData.append('listSampleProp', JSON.stringify(args.data));
            var url = '/list/savelistprop';
            Utils.loadingStart();
            return Utils.postFormRequest(url, formData).then(
            	response => {
        	        alertify.success("List sample changed");
            	}, reason => {
            		alertify.error( Utils.encodeHTML(reason) );
            	}
            ).finally( Utils.loadingStop );
        };
    },
   
    goBack: function(args) {
        if(args.data.DictionaryListName !== Utils.EMPTY_GUID){
            CloverApp.API.redirectToForm('QNN_LIST', args.data.DictionaryListName);
        }else{
            CloverApp.API.redirectToForm('SwzListList');
        }
    },
    
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}