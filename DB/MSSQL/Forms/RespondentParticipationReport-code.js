{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);

        //init run
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
    onExport: function(args) {
        const formData = new FormData();
        if(args.data.UID != undefined){
            formData.append('UID', args.data.UID);
        }
        if(args.data.RespName != undefined){
            formData.append('RespName', args.data.RespName);
        }
        
        if(args.data.Status != undefined){
            formData.append('StatusId', args.data.Status);
        }
        
        if(args.data.DeploymentName != undefined){
            formData.append('DplyId', args.data.DeploymentName);
        }

        Utils.loadingStart();
        Utils.postFormRequest("/report/respondentparticipation",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.log(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    //gridview must not in any container
    gridFilter: function() {
        
        //nb: args is not available in this function
        
        const data = CloverStore.getState().app.form.data.modified; //get from store to facilitate use in queued callback task
        const searchUID = data.UID ? data.UID : "";
        const searchRespName = data.RespName ? data.RespName : "";
        const filterDeploymentName = data.DeploymentName ? data.DeploymentName : [];
        const filterStatus = data.Status ? data.Status : [];

        const searchParams = new URLSearchParams({
            UID: searchUID,
            RespName: searchRespName,
            StatusIds: filterStatus,
            DplyIds: filterDeploymentName
        });
        const searchUrl = "/report/respondentparticipationgridfilter?" + searchParams;

        Utils.loadingStart("Fetching data...");
        Utils.getRequest(searchUrl).then(response => {
                if(response.success && response.item !== null) {
                    CloverApp.API.setDataField("gridview_1", response.item);
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    actionAddAllFields: function(args){
        var options = args.component.refs.Status.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("Status", keys);
        
        //update grid
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
    actionRemoveAllFields: function(args){
        CloverApp.API.setDataField("Status", []);
        
        //update grid
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
}