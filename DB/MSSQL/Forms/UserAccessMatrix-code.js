{
    init: function(args){
        useraccessmatrixUserActions.generateReport(args);
    },
    
    generateReport: function(args){
        const params = new URLSearchParams({aspect:"Role"});
        Utils.loadingStart("Generating report...");
        Utils.getRequest("/report/useraccessmatrix", params).then(
            response => {
                const htmlOverall = '<div>' + response.item + '</div>'
                CloverApp.API.setDataField("result", htmlOverall);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    onClickManageUsers: function(args) {
        window.open("/useradmin", "_blank");
    },
}