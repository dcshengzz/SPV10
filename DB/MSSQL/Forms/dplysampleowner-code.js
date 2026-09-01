{   
    init:function(args){
        Utils.getRequest("/deployment/getDataEditor?dplyId=" + encodeURIComponent(args.data.Id))
        .then(response => {
                if(response.success && response.item !== null) {
                    var result = response.item;
                    const options = [];
                    for(var i=0; i<result.length; i++) {
                        options.push( {
                        value: result[i].id,
                        text: result[i].name,
                        } );
                    }
                    CloverApp.API.changeModelControl(args, "DataEditor","data-elements", options);
                    CloverApp.API.changeModelControl(args, "dictTsfDataEditor","data-elements", options);
                }
            }, reason => {
                if(reason == 'NO_DATA_EDITORS'){
                    alertify.error('No data editor found this organisation');
                } else {
                    console.error("Error getDataEditor",reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            }
        ).finally(() => {
            args.component.refs.DataEditor.forceUpdate();
            if(args.component.refs.dictTsfDataEditor) {
                args.component.refs.dictTsfDataEditor.forceUpdate();
            }
        });
    },
    
    deleteAllAssignment: function(args){
        const dplyId = args.data.Id;
        const dataEditorGv = args.component.refs.dataEditorGv;
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        Utils.postFormRequest("/deployment/deleteAllDataEditors", formData).then(
            response => {
                dplysampleownerUserActions.onChangeDataEditor(args);
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    AssignAllSamples: function(args){
        if(!args.data.DataEditor) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        const dplyId = args.data.Id;
        Utils.loadingStart("Adding assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        formData.append("userId", args.data.DataEditor);
        Utils.postFormRequest("/deployment/addAllSamplesToDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
            }, reason => {
                console.error("Failed to add all assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    tsfDplySampleOwner: function(args){
        const dataEditorIds = args.data.dictTsfDataEditor;
        const dplyId = args.data.Id;
        const sampleOwnerIds = args.data.tsfSampleOwnerIds;
        
        Utils.loadingStart("Transfering Assignments...");
        const formData = new FormData();
        formData.append('dplyId', dplyId);
        formData.append('dataEditorIds', dataEditorIds);
        formData.append('sampleOwnerIds', sampleOwnerIds);  
        Utils.postFormRequest("/deployment/TsfSamplesToDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
                CloverApp.API.setDataField("dictTsfDataEditor", null);
            }, reason => {
                console.error("Failed to transfer assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        dplysampleownerUserActions.closeTsfDataOwnerModal(args);
    },
    
    openTsfModal: function(args){
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        const sampleOwnerIds = gridSelectedIndexes.map( i => gridItems[i].lsoId );
        if(gridSelectedIndexes.length===0){
            dplysampleownerUserActions.closeTsfDataOwnerModal(args);
            alertify.error("No assignments selected"); 
            return {};
        }
        CloverApp.API.setDataField("tsfSampleOwnerIds", sampleOwnerIds);
    },
    
    closeTsfDataOwnerModal: function(args){
         args.component.refs.modalTsfSampleOwner.close();
    },
    
    deleteDplySampleOwner: function(args){
        const dataEditorGv = args.component.refs.dataEditorGv;
        const dplyId = args.data.Id;
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append('dplyId', dplyId);
        formData.append('sampleOwnerIds', gridSelectedIndexes.map( i => gridItems[i].lsoId ) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    onChangeDataEditor: function(args){
        var data = args.data;
        var selectedDataEditors = data.DataEditor;
        var filterArr = [];
        var dplyId = args.data.Id
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            return CloverApp.API.setDataField("dataEditorGv", []);
            args.component.refs.dataEditorGv.forceUpdate();
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        Utils.loadingStart();
        Utils.getRequest("/deployment/getDplySampleOwner?dplyId=" + encodeURIComponent(dplyId) + "&strUserIds=" + encodeURIComponent(filterArr))
        .then(response => {
                if(response.success && response.item !== null) {
                    var result = response.item;
                    CloverApp.API.setDataField("dataEditorGv", result);
                }
            }, reason => {
                if(reason == 'NO_ASSIGNMENT'){
                    CloverApp.API.setDataField("dataEditorGv", []);
                } else {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            }
        ).finally(() => {
            Utils.loadingStop();
            args.component.refs.dataEditorGv.forceUpdate();
        });
    },
    
    getSampleOwnerCSV: function(args, strUserIds) {
        var userIds = null
        var dplyId = args.data.Id;
        
        if(strUserIds != undefined)
            userIds = strUserIds;
        let defaultFormName = args.data.Name + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.dplysampleowner.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.dplysampleowner.provideName);
          }
        }
        var url = '/deployment/getSampleOwnerCSV?dplyId=' + encodeURIComponent(dplyId) + '&fileName=' +  encodeURIComponent(inputName)  + '&strUserIds=' +  encodeURIComponent(userIds);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    getSelectedSampleOwnerCSV:function(args) {
        dplysampleownerUserActions.getSampleOwnerCSV(args, args.data.DataEditor);
    },
    
    closeAssignmentUploadModal: function(args){
         args.component.refs.mdlBulkUploadAssignments.close();
    },
    
    UploadAssignmentCSV:function(args) {
        var dplyId = args.data.Id;
        var token = args.data.assignmentUploadFile;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please", 15000);
            return {};
        };
        const formData = new FormData();
        formData.append("token", token);
        formData.append("dplyId", dplyId);
        Utils.loadingStart();
        Utils.postFormRequest('/deployment/setSampleOwnerCSV', formData).then(
            response => {
                if(response.success && response.item !== null) {
                    alertify.success( Utils.encodeHTML(response.message), 10000);
                    CloverApp.API.setDataField("assignmentUploadFile", null);
                    dplysampleownerUserActions.onChangeDataEditor(args);
                    args.component.refs.mdlBulkUploadAssignments.close();
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally( Utils.loadingStop );
    },
    
}