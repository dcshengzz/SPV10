{
    init: function(args) {
        const copySortedByName = function(items, nameProperty){
            const systemDefault = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045';
            const sortedOrganisations = [...items].sort((a, b) => {
                if (a.StructDivisionId.toUpperCase() === systemDefault) {
                    return 1;
                } else if (b.StructDivisionId.toUpperCase() === systemDefault) {
                    return -1;
                } else {
                    return a[nameProperty].localeCompare(b[nameProperty]);
                }
            });
            return sortedOrganisations;
        };
        
        CloverApp.API.setDataField("MappedOrganisations", copySortedByName(args.data.MappedOrganisations,"StructDivisionName2") );
        CloverApp.API.setDataField("AddressBook", copySortedByName(args.data.AddressBook,"StructDivisionName") );
        
        //Ensure editor provides a remarks row for all mapped organisations even if no remarks yet
        const orgsWithRemarks = new Set(args.data.OrganisationRemarks.map(remark => remark.StructDivisionId));
        const tempRemarks = args.data.OrganisationRemarks.map(remark => ({ ...remark }));
        args.data.MappedOrganisations.forEach(org => {
          if (!orgsWithRemarks.has(org.StructDivisionId)) {
            tempRemarks.push({
              StructDivisionId: org.StructDivisionId,
              StructDivisionName3: org.StructDivisionName2,
              Remarks: ""
            });
          }
        });
        CloverApp.API.setDataField("OrganisationRemarks", copySortedByName(tempRemarks,"StructDivisionName3"));
    },
    
    resetNumRetry: function(args) {
        if(args.data.ActiveYN){
            CloverApp.API.setDataField("NumRetry",0);
        }
    },
    
    customSave: function(args) {
        args.data.UpdatedDate = new Date(); //trigger triggers
        const innerArgs = args;
        Utils.loadingStart("Saving...");
        Utils.changeData(args.data,"QNN_SAMPLE").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_SAMPLE/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    resetPassword: function(args){
        if(!args.data.Id){
            alertify.error("The sample must exist");
            return;
        } 
        
        const formData = new FormData();
        formData.append('sampleIds', args.data.Id);
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message), 15000 );
            }, reason => {
                console.error("resetPassword failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
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
    },
    
    //called by the customValidation on AddressBook collection editor
    validateAddressBook: function(value) {
        const errors = [];
        for(const sampleAddress of value) {
            
            const organisation = sampleAddress.StructDivisionName;
            
            if(sampleAddress.ToEmails 
                && sampleAddress.ToEmails.trim()!==""
                && !(sampleAddress.ToEmails.split(',').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                errors.push("Invalid 'To Emails' for " + organisation);  
            }
            
            if(sampleAddress.CcEmails 
                && sampleAddress.CcEmails.trim()!==""
                && !(sampleAddress.CcEmails.split(',').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                errors.push("Invalid 'CC Emails' for " + organisation);  
            }
        }
        return errors.length >0 ? errors.join(", ") : true;
    },
    
    //called by the customValidation on OrganisationRemarks collection editor
    validateOrganisationRemarks: function(value) {
        const errors = [];
        for(const remark of value) {
            
            const organisation = remark.StructDivisionName3;
            
            if(remark.Remarks && remark.Remarks.length > 1024) {
                errors.push("'Remarks' for " + organisation + " must be 1024 characters or fewer");  
            }
        }
        return errors.length >0 ? errors.join(", ") : true;
    },
    
    cancelModal: function(args) {
        console.log("cancelModal", args, args.controlRef);
        args.controlRef.close();
        return {};
    },
    
}