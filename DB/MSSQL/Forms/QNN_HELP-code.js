{
    init: function(args){
    

    },
    
    onHtmlChange: function (args){

        var contentData =  JSON.stringify(args.component.refs.HelpContent.state.jsonData);
     
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            HelpContent: contentData  
                        }
                    }
                }
            }
        }
    },
    
    showArgs: function (args){
        console.log("show Args", args);
    },
    
    goBack: function(args) {
        args.state.router.history.goBack();
    }
}

