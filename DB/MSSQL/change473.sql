-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AccessReportSchedule-code.js

UPDATE [dwMetadata] SET
[Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 18:37:43.117', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-15 15:52:35.880', 
[Data]=N'{
    cancelSetting: function(args){
        CloverApp.API.setDataField(''structDivision'', null);
        Utils.queueHideControl("form_1");
    },
    
    getSchedule: function(id){
        const url = ''/setting/accessreportschedule/'' + encodeURIComponent(id);
        Utils.loadingStart();
        return Utils.getRequest(url).then(
            response => {
                return response.item;
            }, reason => {
                console.error("getSchedule", reason);
                alertify.error( Utils.encodeHTML("Unable to load schedule details: " + reason) );
                return null;
            }
        ).finally(Utils.loadingStop);
    },
    
    initSchedule: async function(args){
        if(args.data.structDivision !== undefined || args.data.structDivision !== ''''){
            const schedule = await accessreportscheduleUserActions.getSchedule(args.data.structDivision);
            if(schedule !== undefined && schedule !== null){
                CloverApp.API.setDataField("schedule", schedule.ScheduleType);
                CloverApp.API.setDataField("isEnable", schedule.IsEnabled);
                CloverApp.API.setDataField("receiver", schedule.Email);
            }else{
                CloverApp.API.setDataField("schedule", '''');
                CloverApp.API.setDataField("isEnable", false);
                CloverApp.API.setDataField("receiver", '''');
            }    
        }else{
            accessreportscheduleUserActions.cancelSetting(args);
        }
    },
    
    getStruct: function(){
        const url = ''/setting/organization'';
        Utils.loadingStart();
        return Utils.getRequest(url).then(
            response => {
                return response.item;
            }, reason => {
                console.error("getStruct", reason);
                alertify.error( Utils.encodeHTML("Unable to load organisation list: " + reason) );
                return [];
            }
        ).finally(Utils.loadingStop);
    },
    
    init: async function(args){
        console.log(''init'',args.data.structDivision);
        const organizationList = await accessreportscheduleUserActions.getStruct();
        if(organizationList != null) {
            await CloverApp.API.changeModelControl(args, "structDivision",''data-elements'', organizationList);
            CloverApp.API.setDataField("structDivision", '''');
        }
    },
    
    validateInput: function(data){
        let isValid = true;
        if(data.schedule === undefined || data.schedule.trim() === ''''){
            alertify.error(''Please select a schedule.'');
            isValid = false;
        }
        
        const isEnabled = Utils.isSelected(data.isEnable);
        if(isEnabled) {
            if(data.receiver === undefined || data.receiver.trim() === ''''){
                alertify.error(''Please provide receiver email address.'');
                isValid = false;
            }else{
                
                let emailValid
                let emailArr = data.receiver.split('','');
                if(emailArr.length > 1){
                    for( var key in emailArr){
                        var email = emailArr[key];
                        emailValid = email.trim().match(/^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i)
                        if(!emailValid) {break;}
                    }
                }else{
                    emailValid = data.receiver.match(/^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i)  
                }
                 
                if(!emailValid){
                    alertify.error(''Please provide valid email address.'');
                    isValid = false;
                }
            }    
        }
        return isValid;
    },
    
    saveSetting: function(args){
        if(accessreportscheduleUserActions.validateInput(args.data)){
            let formData = new FormData();
            formData.append(''structDivisionId'', args.data.structDivision);
            formData.append(''scheduleType'', args.data.schedule);
            formData.append(''isEnabled'', Utils.isSelected(args.data.isEnable));
            formData.append(''email'', args.data.receiver);
            const url = ''/setting/saveaccessreportschedule/'';
            return Utils.postFormRequest(url, formData).then(
                response => {
                    alertify.success(''Saved successfully.'');
                }, reason => {
                    console.error(reason);
                    alertify.error(Utils.encodeHTML(reason));
                }
            ).finally( Utils.loadingStop );
        }else{
            console.log(''saveSetting is not valid.'');
        }
    }
    
}' WHERE [Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7';

