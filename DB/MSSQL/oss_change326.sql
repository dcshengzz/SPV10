-- Will UPDATE existing row(s) in dwMetadata for the following:
-- Home.json
-- Home-settings.json

UPDATE [dwMetadata] SET
[Id]='2bcf4c62-587e-4e14-8ac8-6fde2b40a72d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Home.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-12-02 14:00:32.923', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-11 12:42:10.047', 
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
        "other-visibleConition": "CloverApp.API.checkRole(\"SurveyAdmin\") ? true : false"
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
      }
    ]
  }
]' WHERE [Id]='2bcf4c62-587e-4e14-8ac8-6fde2b40a72d';

UPDATE [dwMetadata] SET
[Id]='745d15ea-5f67-484d-9076-e31a9fb48b54', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Home-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-12-02 14:00:33.057', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-11 12:42:10.303', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-06-11T12:42:10.2844353+08:00",
  "isTemplate": false
}' WHERE [Id]='745d15ea-5f67-484d-9076-e31a9fb48b54';

