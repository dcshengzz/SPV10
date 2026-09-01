-- Will INSERT row(s) into dwMetadata for the following:
-- SwzTrkLists-code.js

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'949d3dcf-7eff-489c-af9b-de8854605956', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SwzTrklists-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-05-27 21:15:00.700', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-05-27 21:15:50.360', 
N'{
    closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
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
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}');

