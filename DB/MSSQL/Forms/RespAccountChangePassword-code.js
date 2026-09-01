{
    
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
        formData.append('oldPassword', oldPassword);
        formData.append('newPassword', newPassword);        
        var url = '/RespChangePassword/RespChangePassword';
    
        fetch(url, {
                credentials: 'same-origin',
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                method: 'post',
                body: formData
            } )
        .then(response => response.json())
        .then(response => {
            if (response.success) {
                alertify.success( Utils.encodeHTML(response.message) );
                CloverApp.API.redirectToForm("respdashboard");
            } 
            else {
                CloverApp.API.setDataField("oldPassword", "");
                CloverApp.API.setDataField("newPassword", "");
                CloverApp.API.setDataField("confirmPassword", "");
                alertify.error( Utils.encodeHTML(response.message) );
            }
        })
        .catch(error => {
            CloverApp.API.setDataField("oldPassword", "");
            CloverApp.API.setDataField("newPassword", "");
            CloverApp.API.setDataField("confirmPassword", "");
            alertify.error( Utils.encodeHTML(error.message) );
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
            errors.match = 'Confirm Password did not match the new password!';
            errors.confirmPassword = true;
        }
        
        if(data.oldPassword == data.newPassword){
            errors.samePassword = 'New password must not match old password!';
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
    
}