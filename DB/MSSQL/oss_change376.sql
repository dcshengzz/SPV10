-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzStyleList.json
-- SwzStyleList-settings.json
-- sidemenu.json
-- sidemenu-settings.json
-- QNN_STYLE.json
-- QNN_STYLE-settings.json
-- SwzRuleList-settings.json
-- QNN_RULE-settings.json

UPDATE [dwMetadata] SET
[Id]='cdc0b5fa-6b9a-405d-880f-2fe1bfbe23c7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzStyleList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 16:13:47.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 17:39:07.253', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "CSS Style Library",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonAdd",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridStyle"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "buttonDelete",
            "data-buildertype": "button",
            "content": "Delete",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete",
                  "gridRefresh",
                  "clearServerCache"
                ],
                "targets": [
                  "gridStyle"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deletionConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deletionConfirmText"
                  }
                ]
              }
            }
          }
        ],
        "style-float": "left",
        "events": {},
        "style-marginBottom": "20px",
        "style-marginRight": "20px"
      },
      {
        "key": "formgroup_1",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "FilterSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "placeholder": "Search...",
            "style-width": "300px",
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
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ],
        "style-source": "float: left;",
        "style-marginBottom": "20px",
        "style-marginRight": "20px"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "gridStyle",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Description",
        "name": "Description",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "editForm": "QNN_STYLE",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Name ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "1em",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "50",
    "minHeight": "500"
  }
]' WHERE [Id]='cdc0b5fa-6b9a-405d-880f-2fe1bfbe23c7';

UPDATE [dwMetadata] SET
[Id]='c1a5feba-f0ff-467a-9057-16ab89f8218d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzStyleList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 16:13:47.457', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 17:39:07.280', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzStyleList",
  "lastUpdate": "2023-01-17T17:39:07.2807899+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "4267fd22-eb4c-09cb-e2eb-11e74ea81710",
      "entityId": "218ec89e-4aa3-4985-bcf5-4e69c8824347",
      "filter": "StructAsyncFilter",
      "control": "gridStyle",
      "dataMap": [
        {
          "id": "518ad6e3-589c-6492-28bb-2fd73e22f6f4",
          "attributeId": "68d481c2-da6f-4186-b65f-ff583f740930",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bc8a825e-e455-b818-83bd-c16050d4b242",
          "attributeId": "ec886465-a2e5-4cc1-afd8-beb101ce86c6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99f1435c-578f-1ced-50ef-6b0282cc93d0",
          "attributeId": "00792a31-ed25-4d82-b673-5cfff21eb35e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7274c4a-d2f5-90de-3baf-37120a4945ab",
          "attributeId": "fc6da424-9227-47c5-a801-9217d29883f5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37b25361-bcbd-1c44-faf1-1ec797842d87",
          "attributeId": "85f06cd3-2033-4704-9a7e-cd1295179e37",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "af189325-c5d5-35ec-769e-1cd103fa6239",
          "attributeId": "12e325a8-ecca-4288-9e76-81d57ae03d7e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "227eed6a-c2d7-ff92-1d58-181f1f108173",
          "attributeId": "4ef2eaf5-6d7d-44e6-af6e-f0c230b9e368",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d010184-9a7e-da4d-645c-b71b7cacf37a",
          "attributeId": "ae020fe4-cb13-4994-894b-1152f2d88cf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f219f40b-1169-adc5-ba29-bd1c2e840974",
          "attributeId": "233251e4-788f-4443-8c71-a58e8b71abb2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "61eda6fb-5e97-52ed-ef2e-f3c521e60d72",
          "attributeId": "0ed9cb40-1a9b-49e4-a96e-b43978dd1e22",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "15e572d4-8c91-fec1-9a4d-74b72e2860c2",
          "attributeId": "d9d785b6-7573-43ef-b534-7e5b7ca2e542",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2b16d41a-be2c-d680-ba24-74bf85df514f",
          "attributeId": "9060a28f-eb9f-449d-b1bc-e211cc3ea7cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29452736-9e17-874e-9120-bf7e82c3a557",
          "attributeId": "40c7cb99-4fda-45dd-97b0-9f9f84957bf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d730404-0902-e1e0-46a3-43e96c7dc95c",
          "attributeId": "72ccc8e6-de8a-4814-b4d4-2772e23bfa8c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridStyle_totalcount"
    }
  ],
  "securityGroup": "Designer"
}' WHERE [Id]='c1a5feba-f0ff-467a-9057-16ab89f8218d';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 15:26:02.867', 
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
            "title": "<b>Forms</b>",
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
          },
          {
            "target": "/surveydesigner?apanel=formlogic",
            "title": "Form Logic",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/surveydesigner?apanel=formstyle",
            "title": "Form Style",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzStyleList",
            "title": "CSS Style Library",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
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
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
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
            "title": "Deployments",
            "target": "/form/SwzDplyList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')"
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
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Response Status Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/RespondentParticipationReport",
            "title": "Respondent Participation Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/WordCloudReport",
            "title": "Word Cloud Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "title": "<b>System</b>",
            "distype": "dropdownheader"
          },
          {
            "title": "Tags",
            "target": "/form/SwzTags",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
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
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organisations",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''AuditAdmin'')"
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ShortLinkList",
            "title": "Short Links",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') "
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
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 15:26:02.940', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2023-01-17T15:26:02.9409453+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='ffb8727c-7512-4358-a04c-a335cfe6d7ee', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_STYLE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 17:51:45.347', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 18:10:44.230', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Custom CSS Style",
            "size": "large"
          },
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Description",
            "data-buildertype": "input",
            "label": "Description",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "CssSelector",
            "data-buildertype": "input",
            "label": "CSS Selector",
            "fluid": true,
            "onChangeTimeout": 200,
            "placeholder": ".myclass"
          },
          {
            "key": "CssProperties",
            "data-buildertype": "textarea",
            "label": "CSS Properties",
            "fluid": true,
            "rows": "16",
            "placeholder": "border: 1px solid red;"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "save",
                      "clearServerCache"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": ""
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "redirect"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "name": "target",
                        "value": "/form/SwzStyleList"
                      }
                    ]
                  }
                },
                "primary": false,
                "secondary": true,
                "floated": ""
              }
            ],
            "style-float": "left"
          }
        ]
      }
    ]
  }
]' WHERE [Id]='ffb8727c-7512-4358-a04c-a335cfe6d7ee';

UPDATE [dwMetadata] SET
[Id]='dc7cd7f5-8839-40fd-b16d-eace35fd3c59', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_STYLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 17:51:45.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 18:10:44.297', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_STYLE",
  "lastUpdate": "2023-01-17T18:10:44.2966933+08:00",
  "entityId": "218ec89e-4aa3-4985-bcf5-4e69c8824347",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "8c0c425f-5482-e9ed-d27c-da6e4d96011a",
      "attributeId": "68d481c2-da6f-4186-b65f-ff583f740930",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a2de45ed-f7ca-20a0-0ed4-648570905eeb",
      "attributeId": "ec886465-a2e5-4cc1-afd8-beb101ce86c6",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e1259b93-f850-b147-bbdf-ccccd70a15d1",
      "attributeId": "00792a31-ed25-4d82-b673-5cfff21eb35e",
      "control": "CssProperties",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "43992589-6b02-da3c-2226-c5c257e9dc3b",
      "attributeId": "fc6da424-9227-47c5-a801-9217d29883f5",
      "control": "CssSelector",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05cc1c14-4b4e-cf9e-80c0-b4fec756ca68",
      "attributeId": "85f06cd3-2033-4704-9a7e-cd1295179e37",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e1a55496-575b-cb87-45c6-4d05e21d99b0",
      "attributeId": "12e325a8-ecca-4288-9e76-81d57ae03d7e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16c7dde5-4b5a-384b-40ad-5230aebd44b9",
      "attributeId": "4ef2eaf5-6d7d-44e6-af6e-f0c230b9e368",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b42b7fa8-3f45-340f-80d4-35ee6bc9076d",
      "attributeId": "ae020fe4-cb13-4994-894b-1152f2d88cf5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8b9969c2-af2e-861d-e4fa-949c9516963c",
      "attributeId": "233251e4-788f-4443-8c71-a58e8b71abb2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "70035e38-990c-67a5-d134-1c727b9fc754",
      "attributeId": "0ed9cb40-1a9b-49e4-a96e-b43978dd1e22",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "439904c4-b2c8-4e90-afc1-3ca8c7f95f0b",
      "attributeId": "d9d785b6-7573-43ef-b534-7e5b7ca2e542",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25ab0fc0-25eb-a0f6-ed9e-323ff61d8e97",
      "attributeId": "9060a28f-eb9f-449d-b1bc-e211cc3ea7cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "484ccd18-70d1-2fd1-2337-2bfeace63c15",
      "attributeId": "40c7cb99-4fda-45dd-97b0-9f9f84957bf5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dd72ca8a-2193-c603-ee24-6ab711491151",
      "attributeId": "72ccc8e6-de8a-4814-b4d4-2772e23bfa8c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Designer"
}' WHERE [Id]='dc7cd7f5-8839-40fd-b16d-eace35fd3c59';

UPDATE [dwMetadata] SET
[Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 11:42:38.733', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 17:38:27.963', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzRuleList",
  "lastUpdate": "2023-01-17T17:38:27.9631663+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "3b0c0712-15ac-a9eb-fdab-8bd186e2ce4a",
      "entityId": "ea08b91d-a603-41a2-8396-8430ccb3f1bb",
      "filter": "StructAsyncFilter",
      "control": "gridRule",
      "dataMap": [
        {
          "id": "c0a3a683-2fb5-ffce-386f-25fe6c0a1951",
          "attributeId": "250acf7c-d9fb-4738-88f9-8069b98a1ff5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57dad831-aceb-644a-4c89-c3b746ad4906",
          "attributeId": "2e95decc-de0f-47f7-9e2e-46ea22985ac0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52fe4b2c-f7db-8960-3e62-6d9305df8a8d",
          "attributeId": "3da67c4c-93fe-4ecc-b9a7-046dddad5de5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8f309f39-e1de-1c07-1cb7-ddd91a096632",
          "attributeId": "9a055a7f-4eb9-4441-8df5-b74c489e6e1a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a4e7aa62-624e-9f74-3118-9d50610cb85b",
          "attributeId": "430e1edc-de90-4af3-9f02-effe8089800a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b286a35-537f-b824-7587-e4a2a104a88b",
          "attributeId": "9fff33de-bcb2-4348-a7bf-559894ac6aec",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "367a1330-5f83-c552-2441-7f6a9e32cf4f",
          "attributeId": "4760359f-8a71-44ec-baf0-bef43ff238bf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06d1e3e5-23d1-7d35-ee93-174c82bfa123",
          "attributeId": "b12c7eb3-c550-4c9c-8999-4a663ee9f29d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69e71bb5-db6f-f9d1-80b7-51b442910b9b",
          "attributeId": "92044df4-e4bc-45f2-b023-9d50e722297e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60b8e0bb-cfcb-53e4-58ed-bf7a2a2f502c",
          "attributeId": "640e1fee-733e-41cb-9687-2bd9bd6bcb57",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01a0cff1-fb75-f47f-4113-40bea61ecd79",
          "attributeId": "89594fdd-5dde-42af-b69d-5d3722883bef",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "13e44ad7-6be5-e612-4f94-a8947049020f",
          "attributeId": "9192b784-b6ef-4d5e-b9bb-ebccadeed2dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d44703b7-f08e-273f-3609-c848c38bcfe4",
          "attributeId": "765eaf26-34e9-4154-a57b-ad54564a506f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridRule_totalcount"
    }
  ],
  "securityGroup": "Designer"
}' WHERE [Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f';

UPDATE [dwMetadata] SET
[Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-17 17:37:48.343', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_RULE",
  "lastUpdate": "2023-01-17T17:37:48.344255+08:00",
  "entityId": "ea08b91d-a603-41a2-8396-8430ccb3f1bb",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "452aa6b6-9b92-900a-3547-8a378e54aaf3",
      "attributeId": "c18b92cc-d3c6-56f9-419d-acb41056f78c",
      "control": "Comments",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "afad88af-db28-d247-7821-c43d39c6093d",
      "attributeId": "250acf7c-d9fb-4738-88f9-8069b98a1ff5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "772df5ed-04ff-c7e5-d9cc-737220693e93",
      "attributeId": "2e95decc-de0f-47f7-9e2e-46ea22985ac0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d8a9a88-f255-79fa-cad0-83be647fb54e",
      "attributeId": "3da67c4c-93fe-4ecc-b9a7-046dddad5de5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40b5a625-6c9a-5f6e-5952-088e7f0ed9a5",
      "attributeId": "9a055a7f-4eb9-4441-8df5-b74c489e6e1a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "10810acc-812c-a8cd-d35a-3e88f9ce0288",
      "attributeId": "430e1edc-de90-4af3-9f02-effe8089800a",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ccdc00d6-443a-c432-bb64-6a0fec5b512c",
      "attributeId": "9fff33de-bcb2-4348-a7bf-559894ac6aec",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8c0de3c7-52cc-9d0c-81fb-35c6542d320a",
      "attributeId": "4760359f-8a71-44ec-baf0-bef43ff238bf",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c6d5af00-6ac2-723b-7aee-9073bc9f8f79",
      "attributeId": "b12c7eb3-c550-4c9c-8999-4a663ee9f29d",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3bdd25f-a4a0-a1ef-9429-afa351eb50d7",
      "attributeId": "92044df4-e4bc-45f2-b023-9d50e722297e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f736b448-581b-6fc5-e852-c959d7163c20",
      "attributeId": "640e1fee-733e-41cb-9687-2bd9bd6bcb57",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c4dba87c-e810-fd32-bac5-e5164406f6d1",
      "attributeId": "89594fdd-5dde-42af-b69d-5d3722883bef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "622067d3-6fc2-69b5-ede8-2e587312afd8",
      "attributeId": "9192b784-b6ef-4d5e-b9bb-ebccadeed2dc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9306376e-090c-2b27-a0ba-64468aabfdb3",
      "attributeId": "765eaf26-34e9-4154-a57b-ad54564a506f",
      "control": "Validation",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Designer"
}' WHERE [Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4';

