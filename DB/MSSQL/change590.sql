-- Will UPDATE existing row(s) in dwMetadata for the following:
-- UserAccessMatrix.json
-- UserAccessMatrix-settings.json
-- UserAccessMatrix-code.js
-- AccessReportSchedule.json
-- AccessReportSchedule-settings.json
-- AccessReportSchedule-code.js
-- sidemenu.json
-- sidemenu-settings.json

UPDATE [dwMetadata] SET
[Id]='8192e808-5af8-4759-acac-ccf130460ef0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.250', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 18:47:28.823', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "style-marginBottom": "20px",
    "textAlign": "left"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "formgroup_1",
        "data-buildertype": "formgroup",
        "widths": true,
        "orientation": "inline",
        "children": [
          {
            "key": "Aspect",
            "data-buildertype": "radiogroup",
            "label": "",
            "data-elements": [],
            "style-marginRight": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeAspect",
                  "apply"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "onChangeTimeout": "250",
            "direction": "v"
          }
        ],
        "style-source": "float: left;",
        "style-marginRight": "20px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "btn_EmailSchedule",
                "data-buildertype": "button",
                "content": "Schedule PDF Emails",
                "floated": "left",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "redirectToForm"
                    ],
                    "targets": [],
                    "parameters": [
                      {
                        "name": "formName",
                        "value": "AccessReportSchedule"
                      }
                    ]
                  }
                },
                "style-marginRight": "20px",
                "style-marginBottom": "8px",
                "style-width": "200px"
              },
              {
                "key": "btn_ManageUsers",
                "data-buildertype": "button",
                "content": "Manage Users",
                "floated": "left",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "onClickManageUsers"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-marginRight": "20px",
                "style-marginBottom": "8px",
                "style-width": "200px"
              }
            ],
            "style-source": "float: left;\npadding: 0px;",
            "orientation": "grouped",
            "style-marginBottom": "20px",
            "other-visibleConition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "children": [
              {
                "key": "fg_downloads",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "style-source": "",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "container_3",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "staticcontent_1",
                        "data-buildertype": "staticcontent",
                        "content": "<i class=\"download icon\"></i><a href=\"/report/useraccessmatrix/download?aspect=RoleExt\">User Access Matrix by Role++ (PDF Format)</a><br />",
                        "isHtml": true,
                        "style-marginRight": "",
                        "style-marginBottom": ""
                      }
                    ],
                    "style-marginBottom": "8px"
                  },
                  {
                    "key": "container_5",
                    "data-buildertype": "container",
                    "style-marginBottom": "8px",
                    "children": [
                      {
                        "key": "sc_link_UserRoleAccessMatrix",
                        "data-buildertype": "staticcontent",
                        "content": "<i class=\"download icon\"></i><a href=\"/report/useraccessmatrix/download?aspect=Role\">User Access Matrix by Role (PDF Format)</a><br />",
                        "isHtml": true,
                        "style-marginRight": "",
                        "style-marginBottom": ""
                      }
                    ]
                  },
                  {
                    "key": "container_6",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "sc_link_userPermissionAccessMatrix",
                        "data-buildertype": "staticcontent",
                        "content": "<i class=\"download icon\"></i><a href=\"/report/useraccessmatrix/download?aspect=Permission\">User Access Matrix by Permission (PDF Format)</a><br />",
                        "isHtml": true,
                        "style-marginRight": "",
                        "style-marginBottom": "",
                        "other-visibleConition": ""
                      }
                    ],
                    "style-marginBottom": "8px",
                    "other-visibleConition": "CloverApp.API.checkRole(''Admins'')"
                  },
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "sc_link_userprofilelist",
                        "data-buildertype": "staticcontent",
                        "content": "<i class=\"download icon\"></i><a href=\"/report/userprofilelist\">User Profile List (CSV Format)</a>",
                        "isHtml": true,
                        "style-marginBottom": ""
                      }
                    ],
                    "style-marginBottom": "8px"
                  }
                ]
              }
            ],
            "style-width": "400px",
            "style-float": "left",
            "style-marginRight": "20px",
            "style-marginBottom": ""
          }
        ],
        "style-width": "",
        "style-source": "",
        "style-marginBottom": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "result",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true,
            "isPre": true,
            "fetchData": true
          }
        ],
        "style-float": "",
        "style-marginTop": "40px",
        "style-source": "overflow: auto;\nclear: both;\nborder-top: 1px solid black; padding-top: 20px;"
      }
    ],
    "style-marginBottom": "10px"
  }
]' WHERE [Id]='8192e808-5af8-4759-acac-ccf130460ef0';

UPDATE [dwMetadata] SET
[Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.310', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 18:47:28.850', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2025-12-06T18:47:28.8502163+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin",
  "isArchived": false
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 19:27:52.330', 
[Data]=N'{
    init: function(args){
        const initialAspect = "Role";
        const aspects = [
            {key: 1, text: "View by Role", value: "Role"},
        ];
        if(CloverApp.API.checkRole("Admins")) {
            aspects.push({key: 1, text: "View by Permission", value: "Permission"});
        }
        Utils.rewriteDropdown("Aspect", aspects, initialAspect);
        args.data.Aspect = initialAspect; //make available in onChangeAspect
        useraccessmatrixUserActions.onChangeAspect(args);
    },
    
    onChangeAspect: function(args){
        const aspect = args.data.Aspect;
        if(aspect === undefined || aspect === "")
            return;

        const params = new URLSearchParams({aspect:aspect});
        Utils.loadingStart("Generating report...");
        Utils.getRequest("/report/useraccessmatrix", params).then(
            response => {
                const htmlOverall = ''<div>'' + response.item + ''</div>''
                CloverApp.API.setDataField("result", htmlOverall);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    onClickManageUsers: function(args) {
        window.open("/useradmin", "_blank");
    },
}' WHERE [Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6';

UPDATE [dwMetadata] SET
[Id]='fe90af42-f588-41c2-a2e4-39aea75965dd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 15:47:52.047', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 18:43:13.887', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "textAlign": "left",
    "style-marginBottom": "20px",
    "subheader": "Schedule ''by Role++'' PDF Emails"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "structDivision",
            "data-buildertype": "dropdown",
            "label": "Organisation",
            "fluid": true,
            "selection": true,
            "data-elements": [],
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
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "other-visibleConition": "(data.structDivision !== undefined &&  data.structDivision  !== \"\")",
            "children": [
              {
                "key": "isEnable",
                "data-buildertype": "checkbox",
                "label": "On / Off",
                "toggle": true,
                "style-marginBottom": "20px",
                "events": {}
              },
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
                "style-marginBottom": "20px",
                "other-customValidation": "value !== null && value !== '''' ? true : ''Please select a schedule.''",
                "events": {},
                "other-required": true
              },
              {
                "key": "receiver",
                "data-buildertype": "input",
                "label": "Recipients (Comma delimited list of email addresses)",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "admin@example.com, admin2@example.com",
                "style-width": "640px",
                "style-marginBottom": "20px"
              }
            ],
            "style-source": "border-top: 1px solid black; padding-top: 20px;"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btn_Save",
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
                "other-readOnlyConition": "",
                "other-visibleConition": "(data.structDivision !== undefined &&  data.structDivision  !== \"\")",
                "style-marginRight": "20px"
              },
              {
                "key": "btn_Cancel",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "redirect"
                    ],
                    "targets": [],
                    "parameters": [
                      {
                        "name": "target",
                        "value": "UserAccessMatrix"
                      }
                    ]
                  }
                },
                "style-marginRight": "20px"
              }
            ],
            "style-float": "left"
          }
        ],
        "style-source": "",
        "other-visibleConition": "",
        "events": {}
      }
    ],
    "events": {},
    "other-visibleConition": ""
  }
]' WHERE [Id]='fe90af42-f588-41c2-a2e4-39aea75965dd';

UPDATE [dwMetadata] SET
[Id]='c326137e-9316-4c18-bf91-d4c4ebe245b1', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 15:47:52.077', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 18:43:13.910', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2025-12-06T18:43:13.909333+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin",
  "isArchived": false
}' WHERE [Id]='c326137e-9316-4c18-bf91-d4c4ebe245b1';

UPDATE [dwMetadata] SET
[Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 18:37:43.117', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 16:01:16.767', 
[Data]=N'{
    init: async function(args){
        const organizationList = await accessreportscheduleUserActions.getStruct();
        if(organizationList != null) {
            await CloverApp.API.changeModelControl(args, "structDivision",''data-elements'', organizationList);
            CloverApp.API.setDataField("structDivision", '''');
        }
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

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 16:44:51.920', 
[Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
        "children": [
          {
            "title": "<b>Forms</b>",
            "target": "",
            "distype": "dropdownheader",
            "visibleCondition": ""
          },
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/surveydesigner?apanel=formlogic",
            "title": "Form Logic",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/surveydesigner?apanel=formstyle",
            "title": "Form Style",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzStyleList",
            "title": "CSS Style Library",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          }
        ],
        "distype": "dropdown",
        "icon": "list alternate outline"
      },
      {
        "target": "",
        "title": "",
        "children": [
          {
            "title": "Deployments",
            "target": "/form/SwzDplyList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')"
          }
        ],
        "distype": "dropdown"
      },
      {
        "distype": "dropdown",
        "icon": "database",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')||CloverApp.API.checkRole(''UserAdmin'')",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/ChoiceCount",
            "title": "Frequency Count Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Response Status Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/RespondentParticipationReport",
            "title": "Respondent Participation Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/WordCloudReport",
            "title": "Word Cloud Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "title": "<b>System</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/MaintenanceTests",
            "title": "Maintenance",
            "visibleCondition": "CloverApp.API.checkRole(''Maintenance'')"
          },
          {
            "title": "Tags",
            "target": "/form/SwzTags",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzRespAdminList",
            "title": "Respondent Content Management",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organisations",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''AuditAdmin'')"
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ShortLinkList",
            "title": "Short Links",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') || CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''Maintenance'')"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "onItemClick"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": "",
    "icon": false,
    "compact": false,
    "style-width": ""
  }
]' WHERE [Id]='55636648-e5a4-4002-9f59-d597fd167c04';

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-12-06 16:44:51.967', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2025-12-06T16:44:51.9579351+08:00",
  "isTemplate": false,
  "isArchived": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

