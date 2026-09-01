-- Will UPDATE existing row(s) in dwMetadata for the following:
-- corppassloginv2-settings.json
-- corppassloginv2.json
-- resplogin-settings.json
-- resplogin.json
-- footer-settings.json
-- footer.json

UPDATE [dwMetadata] SET
[Id]='10f6da51-e8af-4e06-825c-0f3d3fc56b6e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'corppassloginv2-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-01 11:17:36.073', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 18:14:06.020', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-11-03T18:14:06.0189933+08:00",
  "isTemplate": false
}' WHERE [Id]='10f6da51-e8af-4e06-825c-0f3d3fc56b6e';

UPDATE [dwMetadata] SET
[Id]='390f9058-34ff-48c9-923e-80d28c0a8c6d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'corppassloginv2.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-01 11:17:36.037', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 18:14:05.983', 
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/images/surveyplus.png\" alt=\"imda logo\" class=\"ui image\" style=\"width: 360px; margin: auto;\">",
                "isHtml": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\n            \">\n    <span>\nFor Existing User,\n        </span><div style=\"margin-top: .5em;\">\n<a id=\"spcpLogin\" href=\"https://stg-id.singpass.gov.sg/auth?client_id=client_id&redirect_uri=https://www.sims.gov.sg/resp/corppassloginv2&response_type=code&scope=openid\"><img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\"></a>\n        </div>\n<span style=\"\n\">For New User, register</span>\n<a href=''https://www.corppass.gov.sg/''>here</a>.</div>",
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
[Id]='c6b165be-3eb2-4cb4-9ee5-2780c37d0909', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 17:12:58.277', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-11-03T17:12:58.2773227+08:00",
  "isTemplate": false
}' WHERE [Id]='c6b165be-3eb2-4cb4-9ee5-2780c37d0909';

UPDATE [dwMetadata] SET
[Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.993', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 17:12:58.227', 
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
                "src": "/images/surveyplus.png",
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
[Id]='995e8277-b8a2-4e22-a8cf-8bf987c2a917', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'footer-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.927', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 17:11:37.487', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-11-03T17:11:37.4873519+08:00",
  "isTemplate": false
}' WHERE [Id]='995e8277-b8a2-4e22-a8cf-8bf987c2a917';

UPDATE [dwMetadata] SET
[Id]='da53c0c7-b810-4464-94e9-918b51e2330f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'footer.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.970', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-03 17:11:37.433', 
[Data]=N'[
  {
    "key": "div",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<b>SurveyPlus</b>",
        "isHtml": true,
        "style-source": "paddingTop: 20px;",
        "style-marginTop": "",
        "style-width": "",
        "events": {}
      },
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>",
        "isHtml": true,
        "style-source": "paddingTop: 20px;",
        "style-marginTop": "",
        "style-width": "",
        "events": {},
        "other-visibleConition": "data != undefined",
        "style-hidden": true
      }
    ],
    "style-customcss": "clover-application-footer",
    "style-marginLeft": "",
    "style-marginRight": "",
    "style-width": "",
    "style-float": "",
    "style-source": "clear:both;\ntextAlign:center;",
    "style-marginTop": "",
    "style-marginBottom": ""
  }
]' WHERE [Id]='da53c0c7-b810-4464-94e9-918b51e2330f';

