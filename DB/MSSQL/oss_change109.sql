-- Will INSERT row(s) into dwMetadata for the following:
-- AuditTrail-code.js

INSERT INTO dwMetadata (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'17feec00-b037-4302-b630-328e430e7d1f', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'AuditTrail-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-06-30 17:35:20.063', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-01 14:17:00.343', 
N'{
    
    purgeData: function (args){
        $.post("/audit/purgeauditlog")
        .done(function (data) {
            if(data.success)
                alertify.success(data.message);
            else
                alertify.error(data.message);
        }).fail(function (jqxhr, textStatus, error) {
            console.log(textStatus);
        });
    },
  
}');

