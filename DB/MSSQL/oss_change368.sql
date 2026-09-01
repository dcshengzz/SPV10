-- Will DELETE existing row(s) in dwMetadata for the following:
-- corppassloginv2.json
-- corppassloginv2-settings.json
-- corppassloginv2-code.js

-- Will INSERT row(s) into dwMetadata for the following:
-- respLoginSingpass.json
-- respLoginSingpass-settings.json
-- respLoginCorppass.json
-- respLoginCorppass-settings.json
-- respLoginSingpassCorppass.json
-- respLoginSingpassCorppass-settings.json

DELETE FROM [dwMetadata] WHERE [FileName]='corppassloginv2.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='corppassloginv2-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='corppassloginv2-code.js' AND [Folder]='metadata/forms';

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'172bd821-7bc0-4eca-b904-1b7815f8d7c3', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginSingpass.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:22:45.020', 
NULL, NULL, 
NULL, NULL, 
N'[
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/Logo.png\" alt=\"imda logo\" class=\"ui centered image\" style=\"width: 360px; margin: auto;\">",
                "isHtml": true,
                "events": {}
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"corppassLogin\" href=\"/resp/StartSingpassLogin\">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a><br/>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.singpass.gov.sg/''>here</a>.\n</div>",
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
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'061aa3e0-648d-4799-b34b-5ca2b43a3cec', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginSingpass-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:22:45.037', 
NULL, NULL, 
NULL, NULL, 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-11-28T14:22:45.0357492+08:00",
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
'e62c79bc-8a79-4973-86d8-741ddc1cdae1', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginCorppass.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:16:44.543', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:18:21.423', 
N'[
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/Logo.png\" alt=\"imda logo\" class=\"ui centered image\" style=\"width: 360px; margin: auto;\">",
                "isHtml": true,
                "events": {}
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"corppassLogin\" href=\"/resp/StartCorppassLogin\">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
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
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'dff4e95e-e334-47f6-9390-22efc3a2b182', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginCorppass-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:16:44.663', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:18:21.440', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-11-28T14:18:21.4387808+08:00",
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
'b9824964-4a8f-4524-8d4f-cd3feb9807e8', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginSingpassCorppass.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:18:59.443', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 15:39:15.427', 
N'[
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/Logo.png\" alt=\"imda logo\" class=\"ui centered image\" style=\"width: 360px; margin: auto;\">",
                "isHtml": true,
                "events": {}
              },
              {
                "key": "container_SPCP",
                "data-buildertype": "container",
                "style-source": "width: 100%;\nbox-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;",
                "style-customcss": "CorpPassParent",
                "children": [
                  {
                    "key": "container_4",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "staticcontent_3",
                        "data-buildertype": "staticcontent",
                        "content": "For Existing User,",
                        "isHtml": false
                      }
                    ]
                  },
                  {
                    "key": "container_spcpType",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "spcpType",
                        "data-buildertype": "radiogroup",
                        "label": "",
                        "data-elements": [
                          {
                            "value": "Singpass",
                            "text": "Login for Individual Response"
                          },
                          {
                            "value": "Corppass",
                            "text": "Login for Company / Entity Response"
                          }
                        ],
                        "direction": "v",
                        "defaultValue": "Corppass",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": true,
                            "actions": [
                              "setSPCPFlow"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-customcss": "swzLarge",
                        "style-source": "display: inline-content;",
                        "style-marginTop": "0.5em"
                      }
                    ],
                    "style-source": "text-align: left;\ndisplay: inline-content;\nmargin: 0 auto;\n",
                    "style-width": "60%",
                    "style-marginTop": ""
                  },
                  {
                    "key": "container_loginButton",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "staticcontent_spcpLogin",
                        "data-buildertype": "staticcontent",
                        "content": "<div style=\"padding-top: 0.5em; padding-bottom: 0.5em;\">\n  <span id=\"spcpLoginPrompt\" style=\"visibility: visible; color: red;\">\n    (Please select type of login from the options above)\n  </span>\n</div>\n\n<div style=\"padding-top: 0.5em; padding-bottom: 0.5em;;\">\n  <a id=\"spcpLogin\">\n    <img src=\"/images/logo-singpass.png\" alt=\"Login with Singpass\" style=\"max-width: 60%; height: auto;\">\n  </a>\n</div>\n\n<div style=\"padding-top: 0.5em; padding-bottom: 0.5em;\">\n  For new Individual User, register <a href=''https://www.singpass.gov.sg/''>here</a>.\n  <br/>\n  For new Company / Entity User, register <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
                        "isHtml": true,
                        "style-marginTop": ""
                      }
                    ],
                    "style-marginTop": "20px",
                    "style-source": ""
                  }
                ],
                "style-marginBottom": ""
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
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'2163d193-19cc-4a78-9ca5-685b5df2dd56', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginSingpassCorppass-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 14:18:59.470', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-11-28 15:39:15.523', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-11-28T15:39:15.5134871+08:00",
  "isTemplate": false
}');

