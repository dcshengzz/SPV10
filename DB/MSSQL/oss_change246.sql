-- Will INSERT row(s) into dwMetadata for the following:
-- header-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- header-settings.json
-- header.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'd2b77f0a-b241-4941-8472-cd5071b95f0b', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'header-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-11-29 15:29:54.600', 
NULL, NULL, 
'6168b6e0-89d3-7e3b-5961-35a4cccd7ab0', '2021-12-01 09:43:56.280', 
N'{
    init: function(args){
        headerUserActions.SetupAlternativeAcc(args);
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
                        location.reload(true);
                    }else{
                        alertify.error(response.message);
                    }
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }
    }
}');

UPDATE [dwMetadata] SET
[Id]='65da7247-ec5a-4b52-ac4f-9ebfc759fa5e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.107', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='6168b6e0-89d3-7e3b-5961-35a4cccd7ab0', [UpdatedDate]='2021-11-29 21:38:37.940', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-11-29T21:38:37.9321354+08:00",
  "isTemplate": false
}' WHERE [Id]='65da7247-ec5a-4b52-ac4f-9ebfc759fa5e';

UPDATE [dwMetadata] SET
[Id]='3df5a99c-1591-4ecd-be23-259caf09e329', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:20.150', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='6168b6e0-89d3-7e3b-5961-35a4cccd7ab0', [UpdatedDate]='2021-11-29 21:38:37.803', 
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
            "content": "<a href=\"/help\" target=\"_blank\">Help</a>",
            "isHtml": true
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

