-- Will UPDATE existing row(s) in dwMetadata for the following:
-- corppassloginv2.json
-- corppassloginv2-settings.json
-- spheader.json
-- spheader-settings.json
-- resplogin.json
-- resplogin-settings.json

UPDATE [dwMetadata] SET
[Id]='390f9058-34ff-48c9-923e-80d28c0a8c6d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'corppassloginv2.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-01 11:17:36.037', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 00:48:50.293', 
[Data]=N'[
  {
    "key": "divLoginPage",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              }
            ],
            "style-width": "",
            "events": {},
            "style-marginLeft": "",
            "style-marginRight": "",
            "style-source": "",
            "style-marginTop": "",
            "style-customcss": "clover-resp-login-formb"
          }
        ],
        "style-source": "",
        "style-float": "",
        "style-width": "",
        "style-customcss": "clover-resp-login-container"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [],
        "style-float": "left",
        "style-width": ""
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formLogin",
            "data-buildertype": "form",
            "children": [
              {
                "key": "staticImage",
                "data-buildertype": "staticcontent",
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/Logo.png\" alt=\"imda logo\" class=\"ui image\" style=\"width: 360px; margin: auto;\">",
                "isHtml": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"spcpLogin\" href=\"#\" onclick=\"javascript: pergiKeCorppass(); return false; \">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
                "isHtml": true
              }
            ],
            "style-width": "",
            "events": {},
            "style-marginLeft": "",
            "style-marginRight": "",
            "style-source": "",
            "style-marginTop": "",
            "style-customcss": "clover-resp-login-form"
          }
        ],
        "style-source": "",
        "style-float": "",
        "style-width": "",
        "style-height": "",
        "style-customcss": "clover-resp-login-containerb"
      }
    ],
    "style-width": "100%",
    "style-marginLeft": "",
    "style-marginRight": "",
    "style-source": "",
    "style-height": "",
    "events": {},
    "style-float": "",
    "style-customcss": ""
  }
]' WHERE [Id]='390f9058-34ff-48c9-923e-80d28c0a8c6d';

UPDATE [dwMetadata] SET
[Id]='10f6da51-e8af-4e06-825c-0f3d3fc56b6e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'corppassloginv2-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-01 11:17:36.073', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 00:48:50.397', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-04-16T00:48:50.3969277+08:00",
  "isTemplate": false
}' WHERE [Id]='10f6da51-e8af-4e06-825c-0f3d3fc56b6e';

UPDATE [dwMetadata] SET
[Id]='0b2e0224-b1e1-4ff5-bf19-18a2136d8333', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'spheader.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.723', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 01:02:59.010', 
[Data]=N'[
  {
    "key": "clover-application-header",
    "data-buildertype": "container",
    "style-customcss": "clover-application-header",
    "children": [
      {
        "key": "clover-application-header-left",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "logo",
            "data-buildertype": "image",
            "src": "/Logo.png",
            "style-height": "",
            "style-width": "",
            "href": "/",
            "style-customcss": "clover-application-header-logo"
          }
        ],
        "style-marginLeft": "",
        "style-customcss": "clover-application-header-left"
      },
      {
        "key": "clover-application-header-right",
        "data-buildertype": "container",
        "children": [
          {
            "key": "currentUser",
            "data-buildertype": "dropdowntrigger",
            "defaultValue": "User",
            "items": [
              {
                "target": "/form/respdashboard",
                "title": "Home"
              },
              {
                "target": "/form/RespAccountChangePassword",
                "title": "Settings"
              },
              {
                "target": "/resp/logoff",
                "title": "Logout"
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "redirect"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "imageUrl": "/images/unknown.png"
          }
        ],
        "style-float": "right",
        "style-customcss": "clover-application-header-right"
      },
      {
        "key": "cnt_help",
        "data-buildertype": "container",
        "children": [
          {
            "key": "sc_HelpLink",
            "data-buildertype": "staticcontent",
            "content": "<a href=\"/help\" target=\"_blank\">Help</a>",
            "isHtml": true
          }
        ],
        "style-float": "",
        "style-customcss": "clover-application-header-right"
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_1",
            "data-buildertype": "staticcontent",
            "content": "{lastLogin}",
            "isHtml": false
          }
        ],
        "style-float": "right",
        "style-customcss": "",
        "style-source": "clear:right;",
        "style-marginRight": "30px"
      }
    ]
  }
]' WHERE [Id]='0b2e0224-b1e1-4ff5-bf19-18a2136d8333';

UPDATE [dwMetadata] SET
[Id]='6ba77bb4-320e-4f94-9273-95576cca4ffb', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'spheader-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.673', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 01:02:59.137', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "spheader",
  "lastUpdate": "2022-04-16T01:02:59.1354562+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": []
}' WHERE [Id]='6ba77bb4-320e-4f94-9273-95576cca4ffb';

UPDATE [dwMetadata] SET
[Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.993', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 01:09:20.777', 
[Data]=N'[
  {
    "key": "divLoginPage",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              }
            ],
            "style-width": "",
            "events": {},
            "style-marginLeft": "",
            "style-marginRight": "",
            "style-source": "margin: 0;\n  position: absolute;\n  top: 50%;\n  -ms-transform: translateY(-50%);\n  transform: translateY(-50%);",
            "style-marginTop": ""
          }
        ],
        "style-source": "position: relative;\npadding: 2em;\nmin-height: 500px;",
        "style-float": "left",
        "style-width": "60%"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [],
        "style-float": "left",
        "style-width": ""
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formLogin",
            "data-buildertype": "form",
            "children": [
              {
                "key": "image_1",
                "data-buildertype": "image",
                "src": "/Logo.png",
                "style-height": "",
                "style-marginLeft": "",
                "style-marginRight": "",
                "events": {},
                "style-hidden": false
              },
              {
                "key": "login",
                "data-buildertype": "input",
                "label": "Respondent Login",
                "fluid": true
              },
              {
                "key": "password",
                "data-buildertype": "input",
                "label": "Password",
                "fluid": true,
                "type": "password"
              },
              {
                "key": "breadcrumb_1",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Forgot Password",
                    "url": ""
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "forgotPassword"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-source": "",
                "style-hidden": true,
                "other-visibleConition": "data.Id"
              },
              {
                "key": "btnLogin",
                "data-buildertype": "button",
                "content": "Login",
                "fluid": true,
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "login"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-marginTop": "10px"
              }
            ],
            "style-width": "",
            "events": {},
            "style-marginLeft": "",
            "style-marginRight": "",
            "style-source": "margin: 0;\n  position: absolute;\n  top: 50%;\n  -ms-transform: translateY(-50%);\n  transform: translateY(-50%);\npadding: 2em;",
            "style-marginTop": ""
          }
        ],
        "style-source": "position: relative;\npadding: 2em;\nmin-height: 500px;",
        "style-float": "left",
        "style-width": "40%",
        "style-height": ""
      }
    ],
    "style-width": "100%",
    "style-marginLeft": "",
    "style-marginRight": "",
    "style-source": "",
    "style-height": "",
    "events": {},
    "style-float": ""
  }
]' WHERE [Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928';

UPDATE [dwMetadata] SET
[Id]='c6b165be-3eb2-4cb4-9ee5-2780c37d0909', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-16 01:09:20.903', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-04-16T01:09:20.9026996+08:00",
  "isTemplate": false
}' WHERE [Id]='c6b165be-3eb2-4cb4-9ee5-2780c37d0909';

