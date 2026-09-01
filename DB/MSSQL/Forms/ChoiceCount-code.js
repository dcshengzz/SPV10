{
    
    getCounts: function(args) {
        
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    },
    
    onExport: function(args) {
        const formData = new FormData();
        formData.append('dplyId', args.data.dplyId);
        Utils.loadingStart();
        Utils.postFormRequest("/report/exportanswerchoicecount", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Export error:", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

}