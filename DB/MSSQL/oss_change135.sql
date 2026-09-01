-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu-settings.json
-- sidemenu.json
-- UserAccessMatrix-code.js
-- UserAccessMatrix-settings.json
-- UserAccessMatrix.json

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-02 18:26:35.460', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-08-02T18:26:35.4599439+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-02 18:26:35.437', 
[Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
        "children": [
          {
            "title": "Questionnaire",
            "target": "",
            "distype": "dropdownheader",
            "visibleCondition": ""
          },
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample List",
            "visibleCondition": "",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track List",
            "visibleCondition": "",
            "icon": ""
          }
        ],
        "distype": "dropdown",
        "icon": "list alternate outline"
      },
      {
        "target": "",
        "title": "",
        "children": [
          {
            "title": "Deployment",
            "target": "/form/SwzDplyList",
            "visibleCondition": ""
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor"
          }
        ],
        "distype": "dropdown"
      },
      {
        "distype": "dropdown",
        "icon": "database",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
          },
          {
            "target": "/form/ChoiceCount",
            "title": "Frequency Count Report",
            "visibleCondition": ""
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Status Response Dashboard",
            "visibleCondition": "",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": ""
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "target": "NEW /help",
            "title": "Help..."
          },
          {
            "title": "Category",
            "target": "/form/SwzCategoryList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "title": "Data Validation Rules",
            "target": "/form/SwzRuleList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/SwzRespAdminList",
            "title": "Respondent Content Management",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organizations",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'')"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "onItemClick"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": "",
    "icon": false,
    "compact": false,
    "style-width": ""
  }
]' WHERE [Id]='55636648-e5a4-4002-9f59-d597fd167c04';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-02 18:37:26.807', 
[Data]=N'{
    init: function(args){
        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        var url = ''/report/useraccessmatrix/options'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''get''
            })
            .then(response => {
                return response.json();
            })
            .then(response => {
                _loadingStop();
                var dropdownoptions = function (model) {
                    model[''label''] = ''User Access Aspect'';
                    model[''data-elements''] = response.options;
                };
                CloverApp.API.rewriteControlModel("Aspect", dropdownoptions);
                CloverApp.API.setDataField("Aspect", "");
                
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });
    },
    
    onChangeAspect: function(args){
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        var formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);
        var url = ''/report/useraccessmatrix'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => {
                return response.json();
            })
            .then(response => {
                _loadingStop();
                if (response.Success) {
                    var htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + response.Result + ''</div>''
                    CloverApp.API.setDataField("result", htmlOverall);
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });
    },
    
    onDownload: function(args){
        
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        var formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);    
        var url = ''/report/useraccessmatrix/download'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.blob())
            .then(blob => {
                _loadingStop();
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement(''a'');
                a.href = url;
                a.download = ''User '' + args.data.Aspect + '' Access Matrix.pdf'';
                document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
                a.click();    
                a.remove();  //afterwards we remove the element again  
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });

    }
}' WHERE [Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6';

UPDATE [dwMetadata] SET
[Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.310', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-02 18:02:33.080', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-08-02T18:02:33.0788958+08:00",
  "isTemplate": false,
  "securityGroup": ""
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

UPDATE [dwMetadata] SET
[Id]='8192e808-5af8-4759-acac-ccf130460ef0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.250', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-02 18:02:33.050', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "style-marginBottom": "20px",
    "textAlign": "left"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "Aspect",
            "data-buildertype": "dropdown",
            "label": "User Access Aspect",
            "fluid": false,
            "selection": true,
            "data-elements": [],
            "placeholder": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeAspect",
                  "apply"
                ],
                "targets": [
                  "Download"
                ],
                "parameters": []
              }
            },
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px",
            "defaultValue": "",
            "disabled": false
          },
          {
            "key": "Download",
            "data-buildertype": "button",
            "content": "Download",
            "primary": true,
            "floated": "",
            "other-visibleConition": "data.Aspect!== undefined && data.Aspect!= \"\" ? true : false",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "onDownload"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-hidden": false,
            "style-marginLeft": "",
            "style-marginTop": "",
            "fluid": false,
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px"
          }
        ],
        "style-width": "100%",
        "style-source": "",
        "style-marginBottom": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "result",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true,
            "isPre": true,
            "fetchData": true
          }
        ],
        "style-float": "",
        "style-marginTop": "40px"
      }
    ],
    "style-marginBottom": "10px"
  }
]' WHERE [Id]='8192e808-5af8-4759-acac-ccf130460ef0';

