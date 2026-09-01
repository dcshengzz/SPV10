-- Will UPDATE existing row(s) in dwMetadata for the following:
-- corppassloginv2.json
-- resplogin.json

UPDATE [dwMetadata] SET
[Id]='390f9058-34ff-48c9-923e-80d28c0a8c6d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'corppassloginv2.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-01 11:17:36.037', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-08-18 15:56:43.737', 
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/Logo.png\" alt=\"imda logo\" class=\"ui centered image\" style=\"width: 100px; margin: auto;\">",
                "isHtml": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"spcpLogin\" href=\"/resp/StartCorppassLogin\">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
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
[Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.993', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-08-18 15:59:43.943', 
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
                "style-hidden": false,
                "style-source": "width:100px;"
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

