-- Will INSERT row(s) into dwMetadata for the following:
-- WordCloudReport.json
-- WordCloudReport-settings.json
-- WordCloudReport-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'f3be1b15-261c-4b23-9527-5c2f6f04a124', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'WordCloudReport.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-07 16:35:22.737', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-13 17:19:30.553', 
N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Word Cloud Report",
        "size": "huge",
        "textAlign": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "dictDeploymentId",
            "data-buildertype": "dictionary",
            "label": "Deployment",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_DPLY",
            "columns": "Name ASC",
            "paging": true,
            "clearable": true,
            "pageSize": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "init",
                  "getFields"
                ],
                "targets": [],
                "parameters": []
              }
            }
          },
          {
            "key": "dropDown_wordCloudFields",
            "data-buildertype": "dropdown",
            "label": "Question",
            "fluid": true,
            "selection": true,
            "data-elements": [],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "genWordCloud"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "other-visibleConition": ""
          },
          {
            "key": "WordCloudReport_1",
            "data-buildertype": "WordCloudReport",
            "events": {}
          }
        ]
      }
    ],
    "style-marginBottom": "10px"
  }
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'cb7445d4-be58-41e8-8618-99630fcda5f4', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'WordCloudReport-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-07 16:35:22.860', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-13 17:19:30.580', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-10-13T17:19:30.5811079+08:00",
  "isTemplate": false
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'811d2d21-9dcd-4182-8835-d11d471461b2', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'WordCloudReport-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-10 13:31:14.253', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-10-13 14:12:21.610', 
N'{
    getFields: function(args){
        
        CloverApp.API.setDataField("dplyId", null);
        CloverApp.API.setDataField("qnnField", null);
        CloverApp.API.setDataField("dropDown_wordCloudFields", null);
        Utils.loadingStart();
        Utils.getRequest("/report/wordcloudfields/" + encodeURIComponent(args.data.dictDeploymentId)).then(
            response => {
                if(response.success){
                    Utils.rewriteDropdown("dropDown_wordCloudFields", response.item, undefined);
                }
            }, reason => {
                Utils.rewriteDropdown("dropDown_wordCloudFields", null, undefined);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    genWordCloud: function(args){
        if(!args.data.dictDeploymentId || !args.data.dropDown_wordCloudFields){ 
            CloverApp.API.setDataField("dplyId", null);
            CloverApp.API.setDataField("qnnField", null);
            return;
        }
        CloverApp.API.setDataField("dplyId", args.data.dictDeploymentId);
        CloverApp.API.setDataField("qnnField", args.data.dropDown_wordCloudFields);

    }
}');

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-13 17:23:50.970', 
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
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')"
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
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
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
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
            "title": "Categories",
            "target": "/form/SwzCategoryList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
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
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') "
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

