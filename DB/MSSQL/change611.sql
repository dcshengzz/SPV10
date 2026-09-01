-- Will UPDATE existing row(s) in dwMetadata for the following:
-- resplogin.json
-- respLoginIAmIndividual.json
-- respLoginIAm.json
-- respLoginIAmEntity.json

UPDATE [dwMetadata] SET
[Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.993', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-08-31 17:18:04.227', 
[Data]=N'[
  {
    "key": "loginPageLayout",
    "data-buildertype": "container",
    "style-customcss": "clover-application-login",
    "style-width": "100%",
    "style-source": "",
    "children": [
      {
        "key": "logoPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-container",
        "style-source": "",
        "children": [
          {
            "key": "logoDesktop",
            "data-buildertype": "staticcontent",
            "content": "<img src=\"/Logo.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-desktop\" /><img src=\"/Logo_mobile.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-mobile\" />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "formPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-containerb",
        "style-source": "",
        "children": [
          {
            "key": "formContent",
            "data-buildertype": "container",
            "style-customcss": "clover-resp-login-form resp-login-form-section",
            "style-source": "",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              },
              {
                "key": "staticcontent_heading",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-heading\">Log In to Continue</div>",
                "isHtml": true
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
              },
              {
                "key": "browserNote",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-browser-note\">Please use Microsoft Edge or Google Chrome to access this portal. Best viewed on a desktop or tablet.</div>",
                "isHtml": true
              }
            ]
          }
        ]
      }
    ],
    "events": {}
  }
]' WHERE [Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928';

UPDATE [dwMetadata] SET
[Id]='1808a2af-ada5-46f4-beaf-965715aa5ca2', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAmIndividual.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:58:07.720', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-08-31 17:18:25.753', 
[Data]=N'[
  {
    "key": "loginPageLayout",
    "data-buildertype": "container",
    "style-customcss": "clover-application-login",
    "style-width": "100%",
    "style-source": "",
    "children": [
      {
        "key": "logoPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-container",
        "style-source": "",
        "children": [
          {
            "key": "logoDesktop",
            "data-buildertype": "staticcontent",
            "content": "<img src=\"/Logo.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-desktop\" /><img src=\"/Logo_mobile.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-mobile\" />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "formPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-containerb",
        "style-source": "",
        "children": [
          {
            "key": "formContent",
            "data-buildertype": "container",
            "style-customcss": "clover-resp-login-form",
            "style-source": "",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              },
              {
                "key": "staticcontent_heading",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-heading\">Log In to Continue</div>",
                "isHtml": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"margin-bottom:8px;\"><a href=\"/resp/StartIAmIndividualLogin\" class=\"resp-login-singpass-btn\">Log in with <span class=\"singpass-text\">Singpass</span></a></div><div class=\"resp-login-register\">Don''t have an account? <a href=\"https://www.singpass.gov.sg/\">Register</a></div>",
                "isHtml": true
              },
              {
                "key": "browserNote",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-browser-note\">Please use Microsoft Edge or Google Chrome to access this portal. Best viewed on a desktop or tablet.</div>",
                "isHtml": true
              }
            ]
          }
        ]
      }
    ],
    "events": {}
  }
]' WHERE [Id]='1808a2af-ada5-46f4-beaf-965715aa5ca2';

UPDATE [dwMetadata] SET
[Id]='c85e93b8-8108-4ef3-818d-70539c440bd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAm.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:59:26.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-08-31 17:18:42.097', 
[Data]=N'[
  {
    "key": "loginPageLayout",
    "data-buildertype": "container",
    "style-customcss": "clover-application-login",
    "style-width": "100%",
    "style-source": "",
    "children": [
      {
        "key": "logoPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-container",
        "style-source": "",
        "children": [
          {
            "key": "logoDesktop",
            "data-buildertype": "staticcontent",
            "content": "<img src=\"/Logo.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-desktop\" /><img src=\"/Logo_mobile.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-mobile\" />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "formPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-containerb",
        "style-source": "",
        "children": [
          {
            "key": "formContent",
            "data-buildertype": "container",
            "style-customcss": "clover-resp-login-form",
            "style-source": "",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              },
              {
                "key": "staticcontent_heading",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-heading\">Log In to Continue</div>",
                "isHtml": true
              },
              {
                "key": "container_SPCP",
                "data-buildertype": "container",
                "style-source": "",
                "style-customcss": "resp-login-iam-section",
                "children": [
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
                        "style-source": "",
                        "style-marginTop": "0"
                      }
                    ],
                    "style-source": "text-align: left;",
                    "style-width": "",
                    "style-marginTop": ""
                  },
                  {
                    "key": "container_loginButton",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "staticcontent_spcpLogin",
                        "data-buildertype": "staticcontent",
                        "content": "<div style=\"margin-bottom:8px; margin-top:8px;\"><a id=\"spcpLogin\" href=\"/resp/StartIAmEntityLogin\" class=\"resp-login-singpass-btn\">Log in with <span class=\"singpass-text\">Singpass</span></a></div><div class=\"resp-login-register\" style=\"margin-top:20px;\">For new Individual User, register <a href=\"https://www.singpass.gov.sg/\">here</a>.<br/>For new Company / Entity User, register <a href=\"https://www.corppass.gov.sg/\">here</a>.</div>",
                        "isHtml": true,
                        "style-marginTop": ""
                      }
                    ],
                    "style-marginTop": "16px",
                    "style-source": ""
                  }
                ],
                "style-marginBottom": ""
              },
              {
                "key": "browserNote",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-browser-note\">Please use Microsoft Edge or Google Chrome to access this portal. Best viewed on a desktop or tablet.</div>",
                "isHtml": true
              }
            ]
          }
        ]
      }
    ],
    "events": {}
  }
]' WHERE [Id]='c85e93b8-8108-4ef3-818d-70539c440bd6';

UPDATE [dwMetadata] SET
[Id]='52cb0dd3-7ba9-428a-8632-9fdcf966949a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAmEntity.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:57:44.710', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-08-31 17:18:54.070', 
[Data]=N'[
  {
    "key": "loginPageLayout",
    "data-buildertype": "container",
    "style-customcss": "clover-application-login",
    "style-width": "100%",
    "style-source": "",
    "children": [
      {
        "key": "logoPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-container",
        "style-source": "",
        "children": [
          {
            "key": "logoDesktop",
            "data-buildertype": "staticcontent",
            "content": "<img src=\"/Logo.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-desktop\" /><img src=\"/Logo_mobile.png\" alt=\"Logo\" class=\"resp-login-logo resp-login-logo-mobile\" />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "formPanel",
        "data-buildertype": "container",
        "style-customcss": "clover-resp-login-containerb",
        "style-source": "",
        "children": [
          {
            "key": "formContent",
            "data-buildertype": "container",
            "style-customcss": "clover-resp-login-form",
            "style-source": "",
            "children": [
              {
                "key": "respLoginHtmlView",
                "data-buildertype": "swzhtmlview",
                "hideOutput": "block",
                "style-source": ""
              },
              {
                "key": "staticcontent_heading",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-heading\">Log In to Continue</div>",
                "isHtml": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<div style=\"margin-bottom:8px;\"><a id=\"corppassLogin\" href=\"/resp/StartIAmEntityLogin\" class=\"resp-login-singpass-btn\">Log in with <span class=\"singpass-text\">Singpass</span></a></div><div class=\"resp-login-corppass-label\">as Corppass user</div><div class=\"resp-login-register\">Don''t have an account? <a href=\"https://www.corppass.gov.sg/\">Register</a></div>",
                "isHtml": true
              },
              {
                "key": "browserNote",
                "data-buildertype": "staticcontent",
                "content": "<div class=\"resp-login-browser-note\">Please use Microsoft Edge or Google Chrome to access MISP. Best viewed on a desktop or tablet.</div>",
                "isHtml": true
              }
            ]
          }
        ]
      }
    ],
    "events": {}
  }
]' WHERE [Id]='52cb0dd3-7ba9-428a-8632-9fdcf966949a';

