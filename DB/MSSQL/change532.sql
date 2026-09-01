-- Will INSERT row(s) into dwMetadata for the following:
-- spheader-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- header.json
-- header-settings.json
-- header-code.js
-- resplogin.json
-- resplogin-settings.json
-- respLoginIAm.json
-- respLoginIAm-settings.json
-- respLoginIAmEntity.json
-- respLoginIAmEntity-settings.json
-- spheader.json
-- spheader-settings.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'ba5feefc-8802-41e7-a83f-8d451a3f1d1d', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'spheader-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-11-13 13:01:24.750', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-11-13 14:06:24.450', 
N'{
    init: function(args){
        spheaderUserActions.LoadBrandingImagePath(args);
    },
    
    LoadBrandingImagePath: function(args){
        Utils.getRequest("/ui/brandingImagePath").then(
            response => {
                if(response.success && response.item && Object.keys(response.item).length > 0){
                    let path = ''/'' + response.item.BrandingImagePath + ''/logo.png''
                    args.controlRef.refs.logo.props.src = path;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,''logo'',''src'',path);
                    args.component.refs["logo"].forceUpdate();
                }
            }, reason => {
                console.log(''Error load branding image'');
            }
        );
    }
}');

UPDATE [dwMetadata] SET
[Id]='3df5a99c-1591-4ecd-be23-259caf09e329', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.150', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-12 15:13:02.150', 
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
            "src": "/",
            "style-height": "",
            "style-width": "",
            "href": "/",
            "style-customcss": "clover-application-header-logo",
            "style-marginLeft": "",
            "events": {}
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
                "target": "/account/logoff",
                "title": "Logout"
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "onMenuItemClick"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "imageUrl": "/images/unknown.png",
            "style-source": ""
          }
        ],
        "style-float": "right",
        "style-customcss": "clover-application-header-right"
      },
      {
        "key": "cnt_help",
        "data-buildertype": "container",
        "style-customcss": "clover-application-header-right",
        "children": [
          {
            "key": "sc_HelpLink",
            "data-buildertype": "staticcontent",
            "content": "<a id=\"headerHelpLink\" href=\"/help\" target=\"_blank\">Help</a>",
            "isHtml": true,
            "other-visibleConition": ""
          }
        ]
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_1",
            "data-buildertype": "staticcontent",
            "content": "{lastLogin}",
            "fetchData": false,
            "style-source": ""
          }
        ],
        "style-float": "right",
        "style-customcss": "",
        "style-source": "clear:right;\nfloat:right;",
        "style-marginBottom": "",
        "style-marginRight": "30px"
      }
    ]
  }
]' WHERE [Id]='3df5a99c-1591-4ecd-be23-259caf09e329';

UPDATE [dwMetadata] SET
[Id]='65da7247-ec5a-4b52-ac4f-9ebfc759fa5e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.107', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-12 15:13:02.170', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2024-11-12T15:13:02.165221+08:00",
  "isTemplate": false
}' WHERE [Id]='65da7247-ec5a-4b52-ac4f-9ebfc759fa5e';

UPDATE [dwMetadata] SET
[Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-11-29 15:29:54.600', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-13 14:43:02.617', 
[Data]=N'{
    init: function(args){
        headerUserActions.SetupAlternativeAcc(args);
        headerUserActions.LoadBrandingImagePath(args);
    },
    
    SetupAlternativeAcc: function(args){
        Utils.loadingStart();
        Utils.getRequest("/account/getalternativeacc/").then(
            response => {
                if(response.success && response.item && response.item.length > 0){
                    let options = [];
                    let logoutItem = {target: ''/account/logoff'', title: ''Logout''};
                    for(let i in response.item){
                        let item = {target: ''/account/switchacc/'' + response.item[i].id, title: response.item[i].name};
                        options.push(item);
                    }
                    options.push(logoutItem);
                    args.controlRef.refs.currentUser.props.items = options;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,''currentUser'',''items'',options);
                    args.component.refs["currentUser"].forceUpdate();
                }
            }, reason => {
                console.log(''SetupAlternativeAcc'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onMenuItemClick: function(args){
        console.log(''onMenuItemClick'',args);
        if(args.parameters.target === ''/account/logoff''){
            CloverApp.API.redirect(''account'',''logoff'',undefined);
        }else{
            Utils.loadingStart(''Switching Account...'');
            Utils.postFormRequest(args.parameters.target).then(
                response => {
                    if(response.success){
                        document.location.href = window.location.origin;
                    }else{
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
                }, reason => {
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }
    },
    
    LoadBrandingImagePath: function(args){
        Utils.getRequest("/ui/brandingImagePath").then(
            response => {
                if(response.success && response.item && Object.keys(response.item).length > 0){
                    let path = ''/'' + response.item.BrandingImagePath + ''/logo.png''
                    args.controlRef.refs.logo.props.src = path;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,''logo'',''src'',path);
                    args.component.refs["logo"].forceUpdate();
                }
            }, reason => {
                console.log(''Error load branding image'');
            }
        );
    }
}' WHERE [Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b';

UPDATE [dwMetadata] SET
[Id]='3aff3e04-37f4-4c84-9aa9-7da112f95928', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'resplogin.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.993', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:20:51.197', 
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
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "brandingImage",
                    "data-buildertype": "swzhtmlview",
                    "hideOutput": "block"
                  }
                ],
                "style-customcss": "ui centered image",
                "style-width": ""
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:20:51.213', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2024-11-19T14:20:51.2116869+08:00",
  "isTemplate": false
}' WHERE [Id]='c6b165be-3eb2-4cb4-9ee5-2780c37d0909';

UPDATE [dwMetadata] SET
[Id]='c85e93b8-8108-4ef3-818d-70539c440bd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAm.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:59:26.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:15:08.417', 
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
                "key": "container_5",
                "data-buildertype": "container",
                "style-customcss": "ui centered image",
                "style-width": "360px",
                "children": [
                  {
                    "key": "brandingImage",
                    "data-buildertype": "swzhtmlview",
                    "hideOutput": "block"
                  }
                ]
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
]' WHERE [Id]='c85e93b8-8108-4ef3-818d-70539c440bd6';

UPDATE [dwMetadata] SET
[Id]='5bf821b9-7e08-412e-88ba-56af5ae2715e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAm-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:59:26.840', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:15:08.440', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2024-11-19T14:15:08.439982+08:00",
  "isTemplate": false
}' WHERE [Id]='5bf821b9-7e08-412e-88ba-56af5ae2715e';

UPDATE [dwMetadata] SET
[Id]='52cb0dd3-7ba9-428a-8632-9fdcf966949a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAmEntity.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:57:44.710', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:12:59.843', 
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
                "key": "container_4",
                "data-buildertype": "container",
                "style-customcss": "ui centered image",
                "style-width": "360px",
                "children": [
                  {
                    "key": "brandingImage",
                    "data-buildertype": "swzhtmlview",
                    "hideOutput": "block",
                    "style-source": "",
                    "style-width": "",
                    "viewState": "",
                    "style-customcss": ""
                  }
                ]
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
]' WHERE [Id]='52cb0dd3-7ba9-428a-8632-9fdcf966949a';

UPDATE [dwMetadata] SET
[Id]='056b92f4-446b-4f8c-be79-c91e99689462', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respLoginIAmEntity-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-21 10:57:44.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-19 14:12:59.870', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2024-11-19T14:12:59.8703463+08:00",
  "isTemplate": false
}' WHERE [Id]='056b92f4-446b-4f8c-be79-c91e99689462';

UPDATE [dwMetadata] SET
[Id]='0b2e0224-b1e1-4ff5-bf19-18a2136d8333', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'spheader.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.723', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-13 13:01:57.467', 
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
            "src": "/",
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
                "title": "Change Password",
                "visibleCondition": "(false==window.IsSPCPLogin)"
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
                  "redirect",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "imageUrl": "/images/unknown.png",
            "style-marginRight": "30px"
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
            "content": "<a id=\"spHeaderHelpLink\" href=\"/help\" target=\"_blank\">Help</a>",
            "isHtml": true,
            "other-visibleConition": ""
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
            "isHtml": false,
            "style-marginRight": "30px"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-11-13 13:01:57.523', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "spheader",
  "lastUpdate": "2024-11-13T13:01:57.5153286+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": []
}' WHERE [Id]='6ba77bb4-320e-4f94-9273-95576cca4ffb';

