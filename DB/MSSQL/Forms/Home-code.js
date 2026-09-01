{
    init: function(args) {
        //Redirect to alternative landing page based on role
        let form = null;
        let text = null;
        if(CloverApp.API.checkRole("DataEditor")) {
            form = "DataEditorDeploymentList";
            text = "Data Editor Module";
        }
        else if(CloverApp.API.checkRole("SurveyAdmin")) {
            form = "SwzDplyList";
            text = "Deployment Module";
        }
        else if(CloverApp.API.checkRole("Maintenance")) {
            form = "MaintenanceTests";
            text = "Maintenance Module";
        }
        
        if(form) { 
            Utils.loadingStart("Redirecting to " + text);
            Utils.queueTask( () => {
                const delta = CloverApp.API.redirectToForm(form);
                Utils.dispatchUpdate(delta);
            } );
        }
        return {};  
        
        //Other roles would remain on Home
    },

    
}




