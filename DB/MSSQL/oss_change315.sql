-- Will UPDATE existing row(s) in dwMetadata for the following:
-- header.json
-- header-settings.json

UPDATE [dwMetadata] SET
[Id]='3df5a99c-1591-4ecd-be23-259caf09e329', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.150', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-25 21:33:23.377', 
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
            "src": "/images/surveyplus.png",
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-25 21:33:23.450', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-05-25T21:33:23.4477735+08:00",
  "isTemplate": false
}' WHERE [Id]='65da7247-ec5a-4b52-ac4f-9ebfc759fa5e';

