-- Will UPDATE existing row(s) in dwMetadata for the following:
-- spheader.json
-- spheader-settings.json

UPDATE [dwMetadata] SET
[Id]='0b2e0224-b1e1-4ff5-bf19-18a2136d8333', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'spheader.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.723', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-23 11:08:17.843', 
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
                "title": "Change Password",
                "visibleCondition": "(false==window.IsCorppassLogin)"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-23 11:08:17.970', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "spheader",
  "lastUpdate": "2022-05-23T11:08:17.9400781+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": []
}' WHERE [Id]='6ba77bb4-320e-4f94-9273-95576cca4ffb';

