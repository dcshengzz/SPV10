-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplysampleowner-code.js

UPDATE [dwMetadata] SET
[Id]='a6712791-65c1-463b-bd07-3a2bdac69c68', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.640', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-06-02 16:16:25.277', 
[Data]=N'{   
    logToConsole: function(args){
        $(".react-grid-Canvas").trigger(''click'');
        console.log(''logToConsole args'', args.component.refs.allSamplesGv);
        console.log("Assigned samples ", args);
    },
    
    deleteAllAssignment: function(args){
        const dplyId = args.data.Id;
        const dataEditorGv = args.component.refs.dataEditorGv;
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        Utils.postFormRequest("/deployment/deleteAllDataEditors", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    deleteDplySampleOwner: function(args){
        //expects the assignment grid as control ref
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
        formData.append(''dplyId'', dplyId);
        formData.append(''sampleOwnerIds'', gridSelectedIndexes.map( i => gridItems[i].lsoId ) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    saveDplySampleOwner: function(args){
        if(!args.data.DataEditor) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        const dataEditorGv = args.component.refs.dataEditorGv;
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        const listSampleIds = gridSelectedIndexes.map(i => gridItems[i].ListSampleId);
        const formData = new FormData();
        formData.append("userId", args.data.DataEditor); //array
        formData.append("dplyId", args.data.Id);
        formData.append("listSampleIds", listSampleIds);
        Utils.loadingStart("Assigning Data Editors...");
        Utils.postFormRequest("/deployment/setDataEditor", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to save assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    onChangeDataEditor: function(args){
        
        var data = args.data;
        var selectedDataEditors = data.DataEditor;
        var filterArr = [];
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            
            return {
                app: {
                    form: {
                        filters: {
                            main: {
                                    dataEditorGv: []
                                }
                        }
                    }
                }
            };
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        var filterObj = {
            column: "UserId",
            term: "in",
            value: filterArr
        };
        
       return {
                app: {
                    form: {
                        filters: {
                            main: {
                                    dataEditorGv: [filterObj]
                                }
                        }
                    }
                }
            };
    },
    
    closeModal: function(args){
         args.component.refs.filterModal.close();
    },
    
    clearGridCheckboxes: function(args){
         args.controlRef.state.selectedIndexes = [];
    }
    
}' WHERE [Id]='a6712791-65c1-463b-bd07-3a2bdac69c68';

