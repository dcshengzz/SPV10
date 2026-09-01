--Insert and update rows in dwMetadata in relation to changes in recent commits e8f996f and 4f8ae6f 

--Inserts the following in dwMetaInfo for the new swzRuleList and QNN_RULE forms:
--	swzRuleList.json
--	swzRuleList-code.js
--	swzRuleList-settings.json
--	QNN_RULE.json
--	QNN_RULE-code.js
--	QNN_RULE-settings.json

--Updates the menu to link the rules list:
--	sidemenu.json
--	sidemenu-settings.json

INSERT INTO dbo.dwMetadata (Id,Folder,Filename,IsDeleted,CreatedBy,CreatedDate,DeletedBy,DeletedDate,UpdatedBy,UpdatedDate,Data,StructDivisionId) 
VALUES
  ('CE0C6C21-9D50-421C-B7D2-BEDFC889A3F4',N'metadata/forms',N'QNN_RULE.json',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 12:33:23.377', 120),NULL,NULL,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-07-06 13:29:51.283', 120),N'[
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
            "content": "Data Validation Rule",
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
            "key": "Validation",
            "data-buildertype": "input",
            "label": "Data Validation",
            "fluid": true,
            "onChangeTimeout": 200
          },
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
                  "save"
                ],
                "targets": [],
                "parameters": []
              }
            }
          },
          {
            "key": "btnExit",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "goback"
                ],
                "active": true,
                "targets": [],
                "parameters": []
              }
            },
            "primary": false,
            "secondary": true
          }
        ]
      }
    ]
  }
]','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045'),
  ('FE8D9CB6-ABCD-4CAB-B341-1E6696056661',N'metadata/forms',N'QNN_RULE-code.js',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 12:49:28.520', 120),NULL,NULL,NULL,NULL,N'{
    goback: function (args){
        const back = args.state.router.history.goBack;
        return back;
    },
}



','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045'),
  ('6CCABC70-6921-4DC1-BBFD-3B1138BBBCC4',N'metadata/forms',N'QNN_RULE-settings.json',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 12:33:23.423', 120),NULL,NULL,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-07-06 13:29:51.300', 120),N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_RULE",
  "lastUpdate": "2020-07-06T13:29:51.3000396+08:00",
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
  "securityGroup": "Questionnaire"
}','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045'),
  ('4EC064CD-E6EA-454A-8216-893207B94B7B',N'metadata/forms',N'SwzRuleList.json',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 11:42:38.617', 120),NULL,NULL,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-07-06 13:29:28.760', 120),N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Rules",
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
                  "gridRule"
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
                  "gridRefresh"
                ],
                "targets": [
                  "gridRule"
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
        "style-float": "",
        "events": {},
        "style-marginBottom": "1em"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "gridRule",
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
    "editForm": "QNN_RULE",
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
]','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045'),
  ('725DB87E-A183-4FDA-9BA0-F0C672FEB425',N'metadata/forms',N'SwzRuleList-code.js',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 12:47:11.843', 120),NULL,NULL,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 12:49:18.127', 120),N'','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045'),
  ('2F5DDDC0-0414-4F9F-B615-A93D9F875C7F',N'metadata/forms',N'SwzRuleList-settings.json',0,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-06-29 11:42:38.733', 120),NULL,NULL,'B9D69BA9-282B-D3D2-8F23-EFC2596A082C',convert(datetime, '2020-07-06 13:29:28.893', 120),N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzRuleList",
  "lastUpdate": "2020-07-06T13:29:28.8765204+08:00",
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
      "readOnly": false
    }
  ],
  "securityGroup": "Questionnaire"
}','F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');

UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'sidemenu.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:25.787', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-06-29 11:37:18.617', 120), Data = N'[
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
            "title": "Rules",
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
            "title": "Respondent Content Management",
            "target": "/form/SwzRespAdminList",
            "children": [],
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/organizations",
            "title": "Organizations",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": "",
            "children": []
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
          "redirect"
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
]', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '55636648-E5A4-4002-9F59-D597FD167C04';
UPDATE dbo.dwMetadata SET Folder = N'metadata/forms', Filename = N'sidemenu-settings.json', IsDeleted = 0, CreatedBy = '540E514C-911F-4A03-AC90-C450C28838C5', CreatedDate = convert(datetime, '2019-03-28 21:49:24.490', 120), DeletedBy = NULL, DeletedDate = NULL, UpdatedBy = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', UpdatedDate = convert(datetime, '2020-06-29 11:37:18.810', 120), Data = N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2020-06-29T11:37:18.7990928+08:00",
  "isTemplate": false
}', StructDivisionId = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE Id = '82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A';
