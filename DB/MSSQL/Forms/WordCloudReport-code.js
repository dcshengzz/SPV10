{
    getFields: function(args){
        
        CloverApp.API.setDataField("dplyId", null);
        CloverApp.API.setDataField("qnnField", null);
        CloverApp.API.setDataField("dropDown_wordCloudFields", null);
        Utils.loadingStart();
        Utils.getRequest("/report/wordcloudfields/" + encodeURIComponent(args.data.dictDeploymentId)).then(
            response => {
                if(response.success){
                    Utils.rewriteDropdown("dropDown_wordCloudFields", response.item, undefined);
                }
            }, reason => {
                Utils.rewriteDropdown("dropDown_wordCloudFields", null, undefined);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    genWordCloud: function(args){
        if(!args.data.dictDeploymentId || !args.data.dropDown_wordCloudFields){ 
            CloverApp.API.setDataField("dplyId", null);
            CloverApp.API.setDataField("qnnField", null);
            return;
        }
        CloverApp.API.setDataField("dplyId", args.data.dictDeploymentId);
        CloverApp.API.setDataField("qnnField", args.data.dropDown_wordCloudFields);

    }
}