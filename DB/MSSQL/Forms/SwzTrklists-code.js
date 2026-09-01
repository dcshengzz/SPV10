{
    closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField('deleteGridView', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField('deleteGridView', null);
            CloverApp.API.setDataField('deleteGridView', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}