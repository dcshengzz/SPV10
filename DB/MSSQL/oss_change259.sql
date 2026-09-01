-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AuditLog-code.js

UPDATE [dwMetadata] SET
[Id]='1787cccb-bc84-4e3a-9731-c60a9664e377', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-29 05:08:52.053', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-09 12:04:03.493', 
[Data]=N'{
     init: function(args){
        if(args.data.NewValue instanceof Array) {
            CloverApp.API.setDataField("NewValue", JSON.stringify(args.data.NewValue,null,"\t")); 
        }

        if(args.data.OriginalValue instanceof Array) {
            CloverApp.API.setDataField("OriginalValue", JSON.stringify(args.data.OriginalValue,null,"\t"));
        }

        /* return {
            app:{
                form: {
                    models: {
                        readOnly: true
                    }
                }
            }
        }; */
    }, 
    
}' WHERE [Id]='1787cccb-bc84-4e3a-9731-c60a9664e377';

