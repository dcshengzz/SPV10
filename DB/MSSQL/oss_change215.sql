-- Will UPDATE existing row(s) in dwMetadata for the following:
-- RespAccountChangePassword-code.js

UPDATE [dwMetadata] SET
[Id]='dd9ae999-1e15-4f09-8114-10e64df4003e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespAccountChangePassword-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-05-08 20:14:18.343', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-18 00:57:00.153', 
[Data]=N'{
    
    changePassword: function (args){
     
     var data = args.data;
     
      if(data.oldPassword === "" || data.newPassword === "" || data.confirmPassword === ""){
        CloverApp.API.setDataField("oldPassword", "");
        CloverApp.API.setDataField("newPassword", "");
        CloverApp.API.setDataField("confirmPassword", "");
        return;
      }
        var oldPassword = args.data.oldPassword;
        var newPassword = args.data.newPassword;
      
        var formData = new FormData();
        formData.append(''oldPassword'', oldPassword);
        formData.append(''newPassword'', newPassword);        
        var url = ''/RespChangePassword/RespChangePassword'';
    
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
                    //CloverApp.API.redirect("/form/respdashboard/");
                CloverApp.API.redirectToForm("respdashboard")
                    
                    
                } 
                else {
                    CloverApp.API.setDataField("oldPassword", "");
                    CloverApp.API.setDataField("newPassword", "");
                    CloverApp.API.setDataField("confirmPassword", "");
                alertify.error(response.message);
                    
                }
    
            })
            .catch(error => {
                CloverApp.API.setDataField("oldPassword", "");
                CloverApp.API.setDataField("newPassword", "");
                CloverApp.API.setDataField("confirmPassword", "");
                alertify.error(error.message);
            });
    },
    
    init: function(args){
        CloverApp.API.setDataField("oldPassword", "");
        CloverApp.API.setDataField("newPassword", "");
        CloverApp.API.setDataField("confirmPassword", "");
    },
    
    validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
    
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
        };    
      
        var errors = {};
        
        if(data.oldPassword === "" || data.newPassword === "" || data.confirmPassword === ""){
            errors.newPassword = true;
            errors.passwordRequirement = "Password cannot be empty";
        }
          
        var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
        //TODO: Insert your code for validation this form
        if(!req.test(data.newPassword)){
            errors.newPassword = true;
            errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
        }

        if(countChars(data.newPassword, 0)<3 || countChars(data.newPassword, 1)<3 || countChars(data.newPassword, 2)<3){
            errors.newPassword = true;
            errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
        }
        
        if(data.newPassword != data.confirmPassword){
            errors.match = ''Confirm Password did not match the new password!'';
            errors.confirmPassword = true;
        }
        
        if(data.oldPassword == data.newPassword){
            errors.samePassword = ''New password must not match old password!'';
            errors.newPassword = true;            
        }

        if(errors.passwordRequirement){
          throw {
              level: 1,
              message: errors.passwordRequirement,
              formerrors: {main: errors}
          };
        }
 
         if(errors.passwordComplex){
          throw {
              level: 1,
              message: errors.passwordComplex,
              formerrors: {main: errors}
          };
        }
 
        if(errors.passwordStrength){
          throw {
              level: 1,
              message: errors.passwordStrength,
              formerrors: {main: errors}
          };
        }        
        
        if(errors.match){
          throw {
              level: 1,
              message: errors.match,
              formerrors: {main: errors}
          };
        }
        if(errors.samePassword){
          throw {
              level: 1,
              message: errors.samePassword,
              formerrors: {main: errors}
          };
        
        }
        return {};
    },
    
    
    cancel: function (args){
    //TODO: Insert your code
    },
    
}' WHERE [Id]='dd9ae999-1e15-4f09-8114-10e64df4003e';

