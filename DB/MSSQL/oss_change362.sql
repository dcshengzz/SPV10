-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu-settings.json
-- sidemenu.json

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-11-08 17:13:22.477', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-11-08T17:13:22.4748825+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-11-08 17:13:22.410', 
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

