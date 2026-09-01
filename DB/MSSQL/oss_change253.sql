-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY_PRE_POPULATE-code.js

UPDATE [dwMetadata] SET
[Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:51:04.643', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-06 18:12:30.830', 
[Data]=N'{
    init: function(args){
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("CsvFileUploaded", model => {
            model.customPostUrl = "/deployment/prepopulatecsv?" + new URLSearchParams( { dplyId } );
            model.onUploadBegin = () => Utils.loadingStart("Pre-populating...");
            model.onUploadEnd = Utils.loadingStop;
        });
    },
    
    getDeploymentFields: function(args){
        const dplyId = args.controlRef.props.value;
        if(!dplyId || dplyId.length==0){
            alertify.error("Please select at least one deployment");
            return;
        }
        
        
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/getDeploymentFields", formData).then(
            response => {
                CloverApp.API.setDataField("DeploymentQnnFields", response.item);
            }, reason => {
                console.log("failed ot get deployment fields", reason);
                alterify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    addAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    }, 
    
    prePopulate: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(!allFields || allFields.length==0){
            alertify.error("Please select source deployment");
            return;
        }
        
        const fieldIds = [];
        for(let x = 0 ; x < allFields.length ; x++){
            if(allFields[x].PrePopulate == true){
                fieldIds.push(allFields[x].Id);
            }
        }
        
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
              
        const formData = new FormData();
        formData.append(''dplyId'', args.data.Id);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', args.data.Deployment);   
        Utils.loadingStart(); 
        Utils.postFormRequest("/deployment/prepopulate", formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    csvFileUploaded: function(args) {
        const result = args.sourceControlValue;
        console.log(result);
        CloverApp.API.setDataField("CsvFileUploaded", null); 
        if("OK"===result) {
            alertify.success("Pre-populate has been scheduled. An email will be sent to you once it is completed.");
        } else {
            let errorMessage = result;
            if("FAIL" == result){
                errorMessage = "Pre-populate failed."
            } else if ("DUPLICATE HEADER DETECTED" == result){
                errorMessage = "Uploaded file contains duplicate header. Please remove duplicate and try again."
            } else if ("NO ALIAS COLUMN" == result){
                errorMessage = "Uploaded file does not have valid alias for this deployment. Did you select the correct CSV file?"
            }  else if ("NO UID COLUMN" == result){
                errorMessage = "Invalid file. A UID column is required to identify samples."
            } else if("INCORRECT FILE TYPE"==result) {
                errorMessage = "Incorrect file type. Please upload a CSV file.";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    },
    
    clickFileUpload: function(args){
        const file = $("input[name=''CsvFileUploaded'']");
        file.trigger(''click'');
        return {};
    },
 
}' WHERE [Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09';

