-- Will INSERT row(s) into dwMetadata for the following:
-- corppassloginv2.json
-- corppassloginv2-settings.json
-- corppassloginv2-code.js

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'390f9058-34ff-48c9-923e-80d28c0a8c6d', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'corppassloginv2.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-09-01 11:17:36.037', 
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
                "content": "<img name=\"imageImda\" data-buildertype=\"image\" src=\"/images/imda.png\" alt=\"imda logo\" class=\"ui image\" style=\"width: 360px; margin: auto;\">",
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
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'10f6da51-e8af-4e06-825c-0f3d3fc56b6e', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'corppassloginv2-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-09-01 11:17:36.073', 
NULL, NULL, 
NULL, NULL, 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-09-01T11:17:36.0672999+08:00",
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
'8a84f1d4-af5a-4bf3-9f33-1ace66a1bf45', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'corppassloginv2-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-09-01 11:17:46.230', 
NULL, NULL, 
NULL, NULL, 
N'{
    init: function(args){
        function randomString(length) {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            for(var i = 0; i < length; i++) {
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            } 
            return text;
        }
        var data = ''https://stg-id.singpass.gov.sg/auth?client_id=client_id&redirect_uri=https://www.sims.gov.sg/resp/corppassloginv2&response_type=code&scope=openid'';
        $(''#spcpLogin'').attr(''href'', data + ''&state='' + randomString(8) + ''&nonce='' + randomString(16) )
    },
}');

