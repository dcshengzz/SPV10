-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_RULE-code.js
-- SwzRuleList-code.js
-- QNN_RULE-settings.json
-- QNN_RULE.json
-- SwzRuleList-settings.json
-- SwzRuleList.json

UPDATE [dwMetadata] SET
[Id]='fe8d9cb6-abcd-4cab-b341-1e6696056661', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:49:28.520', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 11:49:30.757', 
[Data]=N'{
    init: function(args){
        var urlSearchParams = new URLSearchParams(window.location.search);
        var params = Object.fromEntries(urlSearchParams.entries());
        if(params.datavalidation !== undefined){
            CloverApp.API.setDataField("Validation", params.datavalidation);
        }
    },
    goback: function (args){
        const back = args.state.router.history.goBack;
        return back;
    },
    
    clearServerCache: function(args){
        const url = ''/datavalidationrule/clearCache'';
        return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post''
            })
        return;
    }
    
}



' WHERE [Id]='fe8d9cb6-abcd-4cab-b341-1e6696056661';

UPDATE [dwMetadata] SET
[Id]='725db87e-a183-4fda-9ba0-f0c672feb425', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:47:11.843', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 11:49:21.047', 
[Data]=N'{
    
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, Description",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridRule: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    },
    
    clearServerCache: function(args){
        const url = ''/datavalidationrule/clearCache'';
        return fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post''
            })
        return;
    }
    
}' WHERE [Id]='725db87e-a183-4fda-9ba0-f0c672feb425';

UPDATE [dwMetadata] SET
[Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 11:41:30.467', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_RULE",
  "lastUpdate": "2021-08-20T11:41:30.4583061+08:00",
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
  "securityGroup": "Questionnaire"
}' WHERE [Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4';

UPDATE [dwMetadata] SET
[Id]='ce0c6c21-9d50-421c-b7d2-bedfc889a3f4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 11:41:30.423', 
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
            "content": "Data Validation Rules",
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
            "key": "Comments",
            "data-buildertype": "textarea",
            "label": "Comments",
            "fluid": true
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
                        "value": "/form/SwzRuleList"
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
]' WHERE [Id]='ce0c6c21-9d50-421c-b7d2-bedfc889a3f4';

UPDATE [dwMetadata] SET
[Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 11:42:38.733', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 10:34:31.170', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzRuleList",
  "lastUpdate": "2021-08-20T10:34:31.170007+08:00",
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
}' WHERE [Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f';

UPDATE [dwMetadata] SET
[Id]='4ec064cd-e6ea-454a-8216-893207b94b7b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 11:42:38.617', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-20 10:34:31.140', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Data Validation Rules",
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
                  "gridRefresh",
                  "clearServerCache"
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
]' WHERE [Id]='4ec064cd-e6ea-454a-8216-893207b94b7b';

