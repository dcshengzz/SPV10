-- Will DELETE existing row(s) in dwMetadata for the following:
-- respLoginSingpassCorppass.json
-- RespLoginSingpassCorppass-settings.json
-- respLoginCorppass.json
-- respLoginCorppass-settings.json
-- respLoginSingpass.json
-- respLoginSingpass-settings.json

-- Will INSERT row(s) into dwMetadata for the following:
-- respLoginIAm.json
-- respLoginIAm-settings.json
-- respLoginIAmEntity.json
-- respLoginIAmEntity-settings.json
-- respLoginIAmIndividual.json
-- respLoginIAmIndividual-settings.json

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginSingpassCorppass.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginSingpassCorppass-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginCorppass.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginCorppass-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginSingpass.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='respLoginSingpass-settings.json' AND [Folder]='metadata/forms';

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'c85e93b8-8108-4ef3-818d-70539c440bd6', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAm.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:59:26.813', 
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
'5bf821b9-7e08-412e-88ba-56af5ae2715e', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAm-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:59:26.840', 
NULL, NULL, 
NULL, NULL, 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-11-21T10:59:26.8404526+08:00",
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
'52cb0dd3-7ba9-428a-8632-9fdcf966949a', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAmEntity.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:57:44.710', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 12:37:31.837', 
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
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"corppassLogin\" href=\"/resp/StartIAmEntityLogin\">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
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
'056b92f4-446b-4f8c-be79-c91e99689462', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAmEntity-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:57:44.787', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 12:37:31.983', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-11-21T12:37:31.9704815+08:00",
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
'1808a2af-ada5-46f4-beaf-965715aa5ca2', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAmIndividual.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:58:07.720', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 12:38:23.140', 
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
                "content": "<div style=\"\n    width: 100%;\n    box-shadow: 0 0 5px 2.5px lightgrey;\n    border-radius: 10px;\n    text-align: center;\n    padding: 1.5em;\n    margin-top: .5em;\n\" class=\"CorpPassParent\">\n    <span>\n        For Existing User,\n    </span>\n    <div style=\"margin-top: .5em;\">\n    <a id=\"corppassLogin\" href=\"/resp/StartIAmIndividualLogin\">\n        <img src=\"/images/logo-singpass.png\" alt=\"Login with \" style=\"max-width: 60%; height: auto;\">\n    </a>\n    </div>\n    <span style=\"\">\n        For New User, register\n    </span>\n    <a href=''https://www.corppass.gov.sg/''>here</a>.\n</div>",
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
'b5c74d52-4c01-492c-8f0b-37ca8193563b', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'respLoginIAmIndividual-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 10:58:07.747', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2023-11-21 12:38:23.190', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-11-21T12:38:23.1899794+08:00",
  "isTemplate": false
}');

