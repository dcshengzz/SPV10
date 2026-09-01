-- Will UPDATE existing row(s) in dwMetadata for the following:
-- UserAccessMatrix.json
-- UserAccessMatrix-settings.json
-- UserAccessMatrix-code.js

UPDATE [dwMetadata] SET
[Id]='8192e808-5af8-4759-acac-ccf130460ef0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.250', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-03-02 20:57:43.250', 
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
              },
              {
                "key": "btnRefresh",
                "data-buildertype": "button",
                "content": "Refresh",
                "floated": "left",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "generateReport"
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
                "style-source": "padding-top: 8px;",
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-03-02 20:57:43.277', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2026-03-02T20:57:43.2753222+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin",
  "isArchived": false
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-03-02 20:36:03.987', 
[Data]=N'{
    init: function(args){
        useraccessmatrixUserActions.generateReport(args);
    },
    
    generateReport: function(args){
        const params = new URLSearchParams({aspect:"Role"});
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

