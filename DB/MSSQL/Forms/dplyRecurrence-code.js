{
    init: function(args) {
        
        const data = args.data;
        if(data.RecurrenceAdvanceDays===undefined || data.RecurrenceAdvanceDays===null || data.RecurrenceAdvanceDays === 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", false);
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
        } else if (data.RecurrenceAdvanceDays > 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", true);
        }
        
        if(!(data.RecurrenceNextDate===undefined || data.RecurrenceNextDate===null)) {
            CloverApp.API.setDataField("msg_NextDeployment", data.RecurrenceNextDate );
        }
        
        CloverApp.API.setDataField("UpdatedDate", new Date()); //for trigger
        
        const customRecurrenceOnFormatter = function(p) {
            if(p.row.CustomFrequencyType !== undefined){
                const CFType = p.row.CustomFrequencyType;
                const CFDayAndWeek = p.row.RecurDay;
                const CFMonth = p.row.RecurMonth;
                const CFYear = p.row.RecurYear;
                let dateValue = new Date(CFYear,CFMonth - 1,CFDayAndWeek);
                let customMonth = 0;
                
                if(dateValue.getMonth()+1 !== CFMonth){
                    dateValue = new Date(CFYear,CFMonth - 1, 1);
                }
                let value = "";
                switch(CFType) {
                    case "EXACT DATE":
                        value = CloverApp.API.formatDatetime(dateValue, window.CloverLang.common.dateFormat);
                        break;
                    case "N DAY N MONTH":
                        value = "Day " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST DAY N MONTH":
                        value = "Last " + CFDayAndWeek + " Day of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N WEEK N MONTH":
                        value = "Week " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST WEEK N MONTH":
                        value = "Last " + CFDayAndWeek + " Week of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N DAY EACH MONTH":
                        value = "Day " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST DAY EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Day of Every Month";
                        break;
                    case "N WEEK EACH MONTH":
                        value = "Week " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST WEEK EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Week of Every Month";
                        break;
                    default:
                        console.log("Error: unknown custom frequency type ", CFType);
                        return CloverApp.API.createElement("div", {}, ""); 
                }
                
                return CloverApp.API.createElement("div", {}, value); 
            }
                
            return CloverApp.API.createElement("div", {}, ""); 
            
        }; //end of customFrequencyValueFormatter

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {   
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                },{}); 
                
                cols.RecurrenceOn.sortable = false;
                cols.RecurrenceOn.customFormatter = customRecurrenceOnFormatter;      

            }
            return model;
        }; //end of gridModelRewriter
        
        CloverApp.API.rewriteControlModel("gdCustomFrequency", gridModelRewriter);

        return {};
    },
    
    addAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    updateRecurrence: function(args) {
        const data = args.data;
        
        if(data.RecurrenceEnabled) {
            if(data.RecurrenceAdvanceDays > 0 && !Number.isInteger(Number(data.RecurrenceAdvanceDays))) {
                alertify.error("Advance days must be a whole number");
                return {};
            }
        }
        
        if(data.RecurrenceEndDate != null){
            const date = new Date(data.RecurrenceEndDate);
            
            if(isNaN(date)) {
                alertify.error("Value specified for 'Do not recur on or after' is not a valid date");
                return {};
            }
            
            const now = new Date();
            if(date < now) {
                alertify.error("Date specified for 'Do not recur on or after' may not be in the past");
                return {};
            }
            data.RecurrenceEndDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        }
        
        Utils.loadingStart("Updating deployment");
        Utils.postJsonRequest("/deployment/updaterecurrence", data).then(
            response => {
                alertify.success("Recurrency settings updated");
                window.location = window.location;
            }, reason => {
                console.error(reason);
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason) );
                return {};
            }
        ) //(absent finally is intentional);
        return {};
    },
    
    toggleDaysInAdvance: function(args) {
        var delta = {};
        if(!args.data.IsCreateInAdvance) {
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
            const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
            if(!hideControls.includes("RecurrenceAdvanceDays")) {
                hideControls.push("RecurrenceAdvanceDays");
                delta = {
                    app: {
                        form: {
                            models: {
                                hideControls,
                            }
                        }
                    }    
                };
            }
        }
        return delta;
    },
    
    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            Utils.redirectToForm("QNN_DPLY", args.data.RecurrenceOfDplyId);
        }    
    },
    
    closeCustomFrequencyModal: function(args){
        args.component.refs.customFrequencyModal.close();
    },
    
    saveCustomFrequency: async function(args){
        //CF = CustomFrequency
        const validateCFInput = function(CFType, CFDay, CFWeek, CFMonth, CFDate) {
            const errMsg = [];
            
            if(!Boolean(CFType)){
                errMsg.push("Please select custom frequency type.");
            }else if(CFType === "N DAY N MONTH" || CFType === "N LAST DAY N MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
                if(errMsg.length === 0){
                    const checkValidDate = new Date("0004",CFMonth - 1,CFDay);
                    if(checkValidDate.getMonth() + 1 !== parseInt(CFMonth)){ errMsg.push("Please select a valid date.");}
                }
            }else if(CFType === "N WEEK N MONTH" || CFType === "N LAST WEEK N MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
            }else if(CFType === "N DAY EACH MONTH" || CFType === "N LAST DAY EACH MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
            }else if(CFType === "N WEEK EACH MONTH" || CFType === "N LAST WEEK EACH MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
            }else if(CFType === "EXACT DATE"){
                if(!Boolean(CFDate)){   errMsg.push("Please select a date."); }
            }else{
                errMsg.push("Unknown custom frequency type.");
                console.log("Error: unknown custom frequency type ", CFType);
            }
            
            if(errMsg.length > 0){ 
                errMsg.forEach( function(msg){
                    alertify.error( Utils.encodeHTML(msg) );
                }); 
            }
            
            return errMsg.length == 0;
        }; 
        
        const saveCFAPI = function(SelectedId, DplyId, CFType, CFDay, CFMonth, CFYear){
            const formData = new FormData();
            formData.append('SelectedId', SelectedId);
            formData.append('dplyId', DplyId);
            formData.append('frequencyType', CFType);
            formData.append('frequencyDay', CFDay);
            formData.append('frequencyMonth', CFMonth);
            formData.append('frequencyYear', CFYear);
            
            const promise = Utils.postFormRequest("/deployment/savedplycustomfrequencyrecurrence/",formData).then(
                response => {
                    alertify.success('Saved successfully.');
                    return true;
                }, reason => {
                    alertify.error( Utils.encodeHTML(response.message) );
                    return false;
                }
            );
            return promise;
        };
        
        const recurType = args.data.CustomFrequencyType;
        const isCFValid = validateCFInput(recurType, args.data.CustomFrequencyDay, args.data.CustomFrequencyWeek, args.data.CustomFrequencyMonth, args.data.CustomFrequencyDate);
        
        let recurDay = 1;
        let recurMonth = 1;
        let recurYear = "0004";
        
        if(recurType !== "EXACT DATE"){
            recurDay = args.data.CustomFrequencyDay;
            
            if(recurType.indexOf("WEEK") > -1){
                recurDay = args.data.CustomFrequencyWeek;
            }
            
            if(recurType.indexOf("EACH MONTH") === -1){
                recurMonth = args.data.CustomFrequencyMonth;
            }
            
        }else{
            let recurDate = new Date(args.data.CustomFrequencyDate);
            recurDay = recurDate.getDate();
            recurMonth = recurDate.getMonth() + 1;
            recurYear = recurDate.getFullYear();
        }
        
        if(isCFValid){
            const result = await saveCFAPI(args.data.SelectedCustomFrequencyId, args.data.Id, recurType, recurDay, recurMonth, recurYear);
            if(result){
                args.component.refs.gdCustomFrequency.refresh();   
                args.component.refs.customFrequencyModal.close();     
            }
            
        }
    },
    
    setCustomFrequencyControlsVisibility: function(args){
        args.component.refs.customFrequencyModal.openModal();
        
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        const CustomFrequencyType = selectedItem.CustomFrequencyType;
        let hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls = hideControls.filter(function(item){ 
            return item !== "CustomFrequencyDay" 
                && item !== "CustomFrequencyWeek" 
                && item !== "CustomFrequencyMonth" 
                && item !== "CustomFrequencyDate" 
                && item !== "customFrequencyDateSpacing"
        });
        
        if(CustomFrequencyType === "N DAY N MONTH" || CustomFrequencyType === "N LAST DAY N MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK N MONTH" || CustomFrequencyType === "N LAST WEEK N MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N DAY EACH MONTH" || CustomFrequencyType === "N LAST DAY EACH MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK EACH MONTH" || CustomFrequencyType === "N LAST WEEK EACH MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "EXACT DATE"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
        } else{
            alertify.error("Unknown custom frequency type.");
            console.log("Error: unknown custom frequency type ", CustomFrequencyType);
            return {};
        }
        
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
    
    setCustomFrequencyControlsValue:function(args){
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        
        let recurYear = selectedItem.RecurYear;
        if(selectedItem.CustomFrequencyType !== "EXACT DATE"){
            recurYear = new Date().getFullYear();
        }
        const dateValue = new Date(recurYear, (selectedItem.RecurMonth - 1), selectedItem.RecurDay);
        CloverApp.API.setDataField("CustomFrequencyType", selectedItem.CustomFrequencyType); 
        CloverApp.API.setDataField("CustomFrequencyDay", String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyWeek", parseInt(selectedItem.RecurDay) > 6 ? '1' : String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        
        if(selectedItem.CustomFrequencyType === "EXACT DATE"){
            CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        }
        CloverApp.API.setDataField("CustomFrequencyDate", dateValue); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", selectedItem.Id); 
        return {};
    },
    
    resetCustomFrequencyModal: function(args){
        CloverApp.API.setDataField("CustomFrequencyType", ""); 
        CloverApp.API.setDataField("CustomFrequencyDay", ""); 
        CloverApp.API.setDataField("CustomFrequencyWeek", ""); 
        CloverApp.API.setDataField("CustomFrequencyMonth", ""); 
        CloverApp.API.setDataField("CustomFrequencyDate", ""); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", ""); 
        
        const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls.push("CustomFrequencyDay");
        hideControls.push("CustomFrequencyWeek");
        hideControls.push("CustomFrequencyMonth");
        hideControls.push("CustomFrequencyDate");
        hideControls.push("customFrequencyDateSpacing");
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
        
}




