-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AccessReportSchedule-code.js
-- AccessReportSchedule-settings.json
-- AccessReportSchedule.json

UPDATE [dwMetadata] SET
[Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 18:37:43.117', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-01 13:11:31.763', 
[Data]=N'{
    cancelSetting: function(args){
        CloverApp.API.setDataField(''structDivision'', null);
        
        let _hideControls = args.state.app.form.models.hideControls;
        _hideControls.push(''form_1'');
        return {
            app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
        }
        
    },
    
    getSchedule: function(id){
        const url = ''/setting/accessreportschedule/'' + encodeURIComponent(id);
        Utils.loadingStart();
        return Utils.getRequest(url).then(
            response => {
                if(response.success){
                    return response.item;
                }else{
                    alertify.error(response.message);
                }
            }, reason => {
                console.log(''getSchedule'', reason);
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
                if(response.success){
                    return response.item;
                }else{
                    alertify.error(response.message);
                }
            }, reason => {
                console.log(''getStruct'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    init: async function(args){
        console.log(''init'',args.data.structDivision);
        const organizationList = await accessreportscheduleUserActions.getStruct();
        await CloverApp.API.changeModelControl(args, "structDivision",''data-elements'', organizationList);
        CloverApp.API.setDataField("structDivision", '''');
    },
    
    validateInput: function(data){
        let isValid = true;
        if(data.schedule === undefined || data.schedule.trim() === ''''){
            alertify.error(''Please select a schedule.'');
            isValid = false;
        }
        
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
                    if (response.success) {
                        alertify.success(''Saved successfully.'');
                    } else {
                        alertify.error(response.message);
                    }
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }else{
            console.log(''saveSetting is not valid.'');
        }
    }
    
}' WHERE [Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7';

UPDATE [dwMetadata] SET
[Id]='c326137e-9316-4c18-bf91-d4c4ebe245b1', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 15:47:52.077', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-01 13:07:51.757', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-12-01T13:07:51.7553902+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin"
}' WHERE [Id]='c326137e-9316-4c18-bf91-d4c4ebe245b1';

UPDATE [dwMetadata] SET
[Id]='fe90af42-f588-41c2-a2e4-39aea75965dd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 15:47:52.047', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-01 13:07:51.710', 
[Data]=N'[
  {
    "key": "breadcrumb_1",
    "data-buildertype": "breadcrumb",
    "items": [
      {
        "text": "User Access Matrix",
        "url": "/form/UserAccessMatrix",
        "divider": "right angle"
      },
      {
        "divider": "",
        "text": "Access Report Schedule",
        "url": "/form/AccessReportSchedule",
        "active": true
      }
    ],
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "redirect"
        ]
      }
    }
  },
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Access Report Schedule Setting",
    "size": "huge",
    "textAlign": "left",
    "style-marginBottom": "20px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "structDivision",
            "data-buildertype": "dropdown",
            "label": "Organization",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "value": "Dummy",
                "text": "Dummy"
              }
            ],
            "style-width": "200px",
            "style-marginBottom": "20px",
            "placeholder": "Organization",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "initSchedule"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ]
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "schedule",
            "data-buildertype": "dropdown",
            "label": "Schedule",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "Daily",
                "text": "Daily"
              },
              {
                "key": 2,
                "value": "Weekly",
                "text": "Weekly"
              },
              {
                "key": 3,
                "value": "Monthly",
                "text": "Monthly"
              },
              {
                "value": "Yearly",
                "text": "Yearly"
              }
            ],
            "style-width": "200px",
            "style-marginBottom": "",
            "other-customValidation": "value !== null && value !== '''' ? true : ''Please select a schedule.''",
            "events": {},
            "other-required": true
          },
          {
            "key": "isEnable",
            "data-buildertype": "checkbox",
            "label": "On / Off",
            "toggle": true,
            "style-marginBottom": ""
          },
          {
            "key": "receiver",
            "data-buildertype": "textarea",
            "label": "Receiver",
            "fluid": true,
            "rows": "10",
            "placeholder": "example@mail.com, example2@mail.com",
            "events": {},
            "other-required": true
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "button_1",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "saveSetting"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "",
                "buttonType": "submit",
                "other-readOnlyConition": ""
              },
              {
                "key": "button_2",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "cancelSetting"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-float": "left"
          }
        ],
        "style-source": "border-top: 1px solid black; padding-top: 20px;",
        "other-visibleConition": "data.structDivision !== undefined &&  data.structDivision  !== '''' ? true : false",
        "events": {}
      }
    ],
    "events": {},
    "other-visibleConition": ""
  }
]' WHERE [Id]='fe90af42-f588-41c2-a2e4-39aea75965dd';

