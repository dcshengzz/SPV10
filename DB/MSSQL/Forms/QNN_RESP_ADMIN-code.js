{
    init: function(args){
    

    },
    
    onHtmlChange: function (args){

        var contentData =  JSON.stringify(args.component.refs.respHtmlEditor.state.jsonData);
     
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            respHtmlEditor: contentData  
                        }
                    }
                }
            }
        }
    },
    
    showArgs: function (args){
      //  console.log("show Args", args);
    },
    
    fetchEditorState: function (args){
    
      //  console.log("test button", args);
        var editorState = args.data.EditorState;
        
        if (editorState != null){
       // console.log("Editor State",editorState);
       // console.log(args.state.app.form.models);
              var modelArray = args.state.app.form.models.model; 
             var editor= args.state.app.form.models.model[1];
           var newModal= {'key': editor['key'], 'data-buildertype': editor['data-buildertype'], 'editorState': editorState };
    
        modelArray.splice(1,1,newModal); //Replace item in whole model series
    
        return {
                app:{
                    form:{
                        models:{
                            model: modelArray
                        }
                    }
                }
            }
        }
    
    },
 
    customValidateInput: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
        var errors = {};
        if(new Date(data.StartDate).getTime() > new Date(data.EndDate).getTime()){
            throw {
              level: 1,
              message: 'End Date must be after Start Date',
              formerrors: {main: errors}
          };
        }
        return {};
    },
    
    submitHtmlData: function(args){
    
        var contentData =  JSON.stringify(args.component.refs.swzhtml_1.state.jsonData);
       
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            EditorState: contentData  
                        }
                    }
                }
            }
        }
    },
    
    goBack: function(args) {
        args.state.router.history.goBack();
    }
}