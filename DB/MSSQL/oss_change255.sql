-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu.json
-- sidemenu-settings.json
-- audittrail.json
-- audittrail-settings.json

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-07 12:53:31.590', 
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
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')"
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
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track List",
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
            "title": "Deployment",
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
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')"
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
            "title": "Status Response Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
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
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-07 12:53:31.703', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-12-07T12:53:31.7033624+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.123', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-07 13:09:02.843', 
[Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Audit Trail",
        "size": "medium",
        "subheader": ""
      },
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "Filters you can use: Event Date (between Start and End filter), Table Name, Event Type, User Name or Sample Name"
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "input_1",
                "data-buildertype": "input",
                "label": "Start",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "placeholder": "Select Event Start",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "readOnly": false,
                "disabled": false
              },
              {
                "key": "input_2",
                "data-buildertype": "input",
                "label": "End",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "placeholder": "Select Event End",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                }
              }
            ]
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "dictionary_1",
                "data-buildertype": "dictionary",
                "label": "Table Name",
                "fluid": true,
                "selection": true,
                "columns": "TableName ASc",
                "dataModel": "vSP_auditlog_TableName",
                "placeholder": "Select Table Name",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "TableName"
                      },
                      {
                        "name": "term",
                        "value": "="
                      }
                    ]
                  }
                },
                "clearable": true
              },
              {
                "key": "dictionary_2",
                "data-buildertype": "dictionary",
                "label": "Event Type",
                "fluid": true,
                "selection": true,
                "dataModel": "vSP_auditlog_EventType",
                "placeholder": "Select Event Type",
                "multiple": false,
                "columns": "EventType ASc",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventType"
                      }
                    ]
                  }
                },
                "clearable": true
              }
            ]
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "dictOrganization",
                "data-buildertype": "dictionary",
                "label": "Organization",
                "fluid": true,
                "selection": true,
                "dataModel": "vStructDivisionParentsAndThisName",
                "placeholder": "Select Organization",
                "paging": false,
                "search": false,
                "columns": "Name, Id ASC",
                "filters": "[{ column : \"ParentId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                "style-marginBottom": "",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "StructDivisionId"
                      }
                    ]
                  }
                },
                "clearable": true
              }
            ]
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "input_3",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Search by name...",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "UserName, SampleName"
                      }
                    ]
                  }
                },
                "reference": ""
              }
            ]
          },
          {
            "key": "formgroup_5",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "keywordInput",
                "data-buildertype": "input",
                "label": "Keyword",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Search by keyword... (Enter ''OR'' in between keywords for multiple keywords searching, eg : SurveyA OR SurveyB)",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "NewValue, OriginalValue"
                      },
                      {
                        "name": "term",
                        "value": "contains"
                      }
                    ]
                  }
                }
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [],
            "style-source": "clear:both;"
          }
        ],
        "style-customcss": "ui message"
      }
    ],
    "style-customcss": "",
    "style-width": ""
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnRefresh",
        "data-buildertype": "button",
        "content": "Refresh",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridRefresh"
            ],
            "targets": [
              "gridAuditLog"
            ],
            "parameters": []
          }
        },
        "floated": "left"
      }
    ],
    "style-float": "",
    "style-marginTop": "20px",
    "style-width": "100%"
  },
  {
    "key": "gridAuditLog",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UserName",
        "name": "User Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "SampleName",
        "name": "Sample Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "TableName",
        "name": "Table Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 300
      },
      {
        "key": "EventType",
        "name": "Event Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "EventDate",
        "name": "Event Date",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": 200
      }
    ],
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
    "rowKey": "Id",
    "pageSize": "64",
    "defaultSort": "EventDate DESC",
    "pagerType": "server",
    "editForm": "AuditLog",
    "style-marginTop": "20px"
  },
  {
    "key": "cnt_adminsGlobalPurge",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnAdminsGlobalPurge",
        "data-buildertype": "button",
        "content": "Purge All Data!",
        "floated": "",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "purgeData"
            ],
            "targets": [
              "gridAuditLog"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "purgeAuditTrailTitle"
              },
              {
                "name": "confirmText",
                "value": "purgeAuditTrailText"
              }
            ]
          }
        },
        "secondary": true,
        "other-visibleConition": "checkRole(''Admins'')"
      }
    ],
    "style-source": "",
    "style-customcss": "ui message",
    "style-marginTop": "30px",
    "style-float": "",
    "style-width": "100%",
    "other-visibleConition": "checkRole(''Admins'')"
  }
]' WHERE [Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65';

UPDATE [dwMetadata] SET
[Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.527', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-07 13:16:43.270', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2021-12-07T13:16:43.2599549+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "filter": "StructAsyncFilter",
      "control": "gridAuditLog",
      "dataMap": [
        {
          "id": "eaa99175-fe0c-2b55-d9fb-e99ac183c740",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96b05054-f2e2-73f2-10cd-5d5beb80324e",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc91b26c-6dbb-6eb8-9218-7d6d83679de5",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac32e752-a32f-f980-bcc7-faec88bf814c",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52e11100-2bc2-9226-7ee5-85362d373cae",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12cd7b55-290c-ad1e-a9c2-0b8340fce6ae",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d060f249-db88-077b-1d9c-ae703ee503a6",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4d8bc32-8976-8eb6-9ee0-37eea7ce980f",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32464828-58e9-8012-af69-c4647c36ea9c",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd1d5507-525b-c4c0-dd2f-ca72ae54c1a3",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6206d655-e39c-07f3-ff1e-554f13447d4c",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21679a71-b29f-ae12-55a8-19853357daed",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81cc9561-54fd-d16d-cb4d-5002c6f892a9",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0cd0a723-ab1d-a598-81cf-0895c3fd9acb",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b239f88-0682-31b7-6d2c-ca7655c88de8",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2af7af6-9443-e547-a849-4a5f564ef036",
          "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    }
  ],
  "securityGroup": "Audit"
}' WHERE [Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd';

