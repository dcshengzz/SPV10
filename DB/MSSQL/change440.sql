-- Will INSERT row(s) into dwMetadata for the following:
-- MaintenanceTests.json
-- MaintenanceTests-settings.json
-- MaintenanceTests-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- Home.json
-- Home-settings.json
-- Home-code.js
-- sidemenu.json
-- sidemenu-settings.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'a6635595-4d80-40b2-8744-d2d85202a33d', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'MaintenanceTests.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-10 12:50:58.680', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-13 13:42:58.587', 
N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Maintenance Tests",
        "size": "medium"
      },
      {
        "key": "fg_smtpTests",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "style-source": "border: 1px solid black;\npadding: 20px;",
        "orientation": "grouped",
        "children": [
          {
            "key": "message_smtp",
            "data-buildertype": "message",
            "header": "SMTP Test",
            "content": "The SMTP test will exercise the SMTP integration by sending a test message to users in your organisation and its child organisations who have the Maintenance role. The ''background'' behaviour will enqueue a job to immediately send the message in the background while the ''direct'' behaviour will immediately send it directly from the server. If the background test is not successful you can try the direct test. If that is successful yet the background test is not, then the problem lies with the scheduled job mechanism rather than the SMTP integration.",
            "info": true
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSmtpTestBackground",
                "data-buildertype": "button",
                "content": "Perform SMTP Test (Background)",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "performSmtpTest"
                    ],
                    "targets": [],
                    "parameters": [
                      {
                        "name": "behaviour",
                        "value": "async"
                      }
                    ]
                  }
                },
                "style-width": "200px",
                "style-height": "64px"
              },
              {
                "key": "btnSmtpTestDirect",
                "data-buildertype": "button",
                "content": "Perform SMTP Test (Direct)",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "performSmtpTest"
                    ],
                    "targets": [],
                    "parameters": [
                      {
                        "name": "behaviour",
                        "value": "direct"
                      }
                    ]
                  }
                },
                "style-marginLeft": "20px",
                "style-width": "200px",
                "style-height": "64px"
              }
            ]
          }
        ]
      }
    ],
    "style-width": "800px"
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
'1164183a-ef0d-4305-8b50-761541e8ccb1', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'MaintenanceTests-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-10 12:50:58.747', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-13 13:42:58.743', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-12-13T13:42:58.7305111+08:00",
  "isTemplate": false,
  "securityGroup": "Maintenance"
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'9ec429b4-65c7-4b46-b828-6d17ac19ad1e', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'MaintenanceTests-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-11 14:01:24.710', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-12-13 14:42:40.917', 
N'{
    performSmtpTest: function(args) {
        const behaviour = args.parameters.behaviour;
        const msgDuration = 30000; //Longer alert time on screen makes it easier to screenshot
        const url = "/maintenance/tests/smtp/" + encodeURIComponent(behaviour);
        const waitMessage = "Performing " + behaviour + " SMTP Test...";
        console.log(waitMessage);
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url).then(
            response => {
                alertify.success(response.message, msgDuration);
                console.log(response.message);
            }, reason => {
                alertify.error(reason, msgDuration);
                console.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
}');

UPDATE [dwMetadata] SET
[Id]='2bcf4c62-587e-4e14-8ac8-6fde2b40a72d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Home.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-12-02 14:00:32.923', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-12-10 12:49:56.013', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-source": "max-width: 1200px;\nmargin-left: auto;\nmargin-right: auto;",
    "children": [
      {
        "key": "btnDeployments",
        "data-buildertype": "button",
        "content": "Deployments",
        "style-source": "border-radius: 25px;\nbackground: #62a4f5;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/SwzDplyList"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"SurveyAdmin\") ? true : false"
      },
      {
        "key": "btnSampleList",
        "data-buildertype": "button",
        "content": "Sample Lists",
        "style-source": "border-radius: 25px;\nbackground: #99f2e9;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/SwzListList"
              }
            ]
          }
        },
        "other-visibleConition": "(CloverApp.API.checkRole(\"SampleAdmin\") || CloverApp.API.checkRole(\"SurveyAdmin\"))  ? true : false"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Samples",
        "style-source": "border-radius: 25px;\nbackground: #3dd4d4;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/swzsamplelist"
              }
            ]
          }
        },
        "other-visibleConition": "(CloverApp.API.checkRole(\"SampleAdmin\") || CloverApp.API.checkRole(\"SurveyAdmin\"))  ? true : false"
      },
      {
        "key": "btnDataEditor",
        "data-buildertype": "button",
        "content": "Data Editor",
        "style-source": "border-radius: 25px;\nbackground: #adf590;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/DataEditorDeploymentList"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"DataEditor\") ? true : false"
      },
      {
        "key": "btnFormDesigner",
        "data-buildertype": "button",
        "content": "Form Designer",
        "style-source": "border-radius: 25px;\nbackground: #fc876a;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/surveydesigner"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"SurveyDesigner\") ? true : false"
      },
      {
        "key": "btnSecurity",
        "data-buildertype": "button",
        "content": "Security",
        "style-source": "border-radius: 25px;\nbackground: #cfa1bc;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/useradmin"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"UserAdmin\") ? true : false"
      },
      {
        "key": "btnAuditTrail",
        "data-buildertype": "button",
        "content": "Audit Trail",
        "style-source": "border-radius: 25px;\nbackground: #a6a59c;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/audittrail"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"AuditAdmin\") ? true : false"
      },
      {
        "key": "btnUserAccessMatrix",
        "data-buildertype": "button",
        "content": "User Access Matrix",
        "style-source": "border-radius: 25px;\nbackground: #bfafc9;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/UserAccessMatrix"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"UserAdmin\") ? true : false"
      },
      {
        "key": "btnOnlineHelpContent",
        "data-buildertype": "button",
        "content": "Online Help Content",
        "style-source": "border-radius: 25px;\nbackground: #fabb28;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/swzHelpList"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"HelpEditor\") ? true : false"
      },
      {
        "key": "btnRespondentContentManagement",
        "data-buildertype": "button",
        "content": "Respondent Content Management",
        "style-source": "border-radius: 25px;\nbackground: #ff911c;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/SwzRespAdminList"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"HelpEditor\") ? true : false"
      },
      {
        "key": "btnMaintenanceTests",
        "data-buildertype": "button",
        "content": "Maintenance Tests",
        "style-source": "border-radius: 25px;\nbackground: #00911c;\npadding: 20px; \nfont-size: larger;",
        "style-width": "300px",
        "style-height": "200px",
        "floated": "left",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "style-marginLeft": "30px",
        "style-marginRight": "30px",
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
                "value": "/form/MaintenanceTests"
              }
            ]
          }
        },
        "other-visibleConition": "CloverApp.API.checkRole(\"Maintenance\") ? true : false"
      }
    ]
  }
]' WHERE [Id]='2bcf4c62-587e-4e14-8ac8-6fde2b40a72d';

UPDATE [dwMetadata] SET
[Id]='745d15ea-5f67-484d-9076-e31a9fb48b54', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Home-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-12-02 14:00:33.057', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-12-10 12:49:56.050', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-12-10T12:49:56.0490796+08:00",
  "isTemplate": false
}' WHERE [Id]='745d15ea-5f67-484d-9076-e31a9fb48b54';

UPDATE [dwMetadata] SET
[Id]='ff8bf5f7-b286-4539-8b29-ff2f52957df2', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Home-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-12-02 14:06:03.117', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-12-11 15:28:46.443', 
[Data]=N'{
    init: function(args) {
        //Redirect to alternative landing page based on role
        let form = null;
        let text = null;
        if(CloverApp.API.checkRole("DataEditor")) {
            form = "DataEditorDeploymentList";
            text = "Data Editor Module";
        }
        else if(CloverApp.API.checkRole("SurveyAdmin")) {
            form = "SwzDplyList";
            text = "Deployment Module";
        }
        else if(CloverApp.API.checkRole("Maintenance")) {
            form = "MaintenanceTests";
            text = "Maintenance Module";
        }
        
        if(form) { 
            Utils.loadingStart("Redirecting to " + text);
            Utils.queueTask( () => {
                const delta = CloverApp.API.redirectToForm(form);
                Utils.dispatchUpdate(delta);
            } );
        }
        return {};  
        
        //Other roles would remain on Home
    },

    
}




' WHERE [Id]='ff8bf5f7-b286-4539-8b29-ff2f52957df2';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-12-11 20:17:48.863', 
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
            "target": "/form/MaintenanceTests",
            "title": "Maintenance",
            "visibleCondition": "CloverApp.API.checkRole(''Maintenance'')"
          },
          {
            "title": "Tags",
            "target": "/form/SwzTags",
            "visibleCondition": "CloverApp.API.checkRole(''Maintenance'')",
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-12-11 20:17:48.907', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2023-12-11T20:17:48.9069135+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

