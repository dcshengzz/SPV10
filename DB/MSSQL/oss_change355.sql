-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_SAMPLE-code.js

UPDATE [dwMetadata] SET
[Id]='ef95ed35-6b68-4a52-8433-f85554dbd1fe', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 20:33:31.493', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-07 14:00:46.527', 
[Data]=N'{
    resetPassword: function(args){
            var formData = new FormData();
            if(!args.data.Id){
                alertify.error("The sample must exist");
                return;
            } 
            formData.append(''sampleIds'', args.data.Id);
            var url = ''/deployment/resetresppassword'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success(response.message);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
        
    },
    
    validate: function(args){
        var countChars = function(str, type) {
            var count=0,len=str.length;
                for(var i=0;i<len;i++) {
                    if(type==0){
                        if(/[A-Z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==1){
                        if(/[a-z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==2){
                        if(/[0-9]/.test(str.charAt(i))) count++;                    
                    }                
                }
            return count;
        }    
        CloverApp.API.formValidate(args);
        
        var errors = {};
        
        if(args.data.Pwd){
            if(countChars(args.data.Pwd, 0)<3 || countChars(args.data.Pwd, 1)<3 || countChars(args.data.Pwd, 2)<3){
                errors.Pwd = true;
                errors.passwordStrength = "must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }    
            if(errors.passwordStrength){
                throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
                };
            }             
        }
        
        if(args.originalData.ActiveYN === false && args.data.ActiveYN == 1){
            CloverApp.API.setDataField("NumRetry", " 0");
        }
       
    }
}' WHERE [Id]='ef95ed35-6b68-4a52-8433-f85554dbd1fe';

