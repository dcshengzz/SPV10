-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_RESP_ADMIN-settings.json
-- QNN_RESP_ADMIN.json
-- QNN_HELP-settings.json
-- QNN_HELP.json
-- QNN_CATEGORY-settings.json
-- QNN_CATEGORY.json
-- QNN_SAMPLE-settings.json
-- QNN_SAMPLE.json
-- QNN_RULE-settings.json
-- QNN_RULE.json

UPDATE [dwMetadata] SET
[Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.397', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 17:08:02.330', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_RESP_ADMIN",
  "lastUpdate": "2021-07-06T17:08:02.3303886+08:00",
  "entityId": "cd522364-03bb-44c1-af31-575eab8ac087",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "7eca1a45-c409-c32e-acb9-251afa096832",
      "attributeId": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98277ccb-156d-afac-2a25-810f13e8ecb4",
      "attributeId": "d8512084-4732-4938-869d-0165bc220192",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5b887698-a623-eae4-a59f-a470b18bb314",
      "attributeId": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5e36525f-6583-2890-4e1a-b5b43f70b0d0",
      "attributeId": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
      "control": "respHtmlEditor",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0904f275-ff19-ad51-3862-c95d8ce0e28d",
      "attributeId": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
      "control": "EndDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14a5e4-f3c4-1a77-b66f-ab5ead0f9a9c",
      "attributeId": "46699848-4700-4d77-a193-ef4ecbd921ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16abd9a3-7f1f-7567-52f7-7eeca4e7ea42",
      "attributeId": "59530aed-1d91-40d2-8808-d1a286390b4f",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d8ab4c5-a6bc-45c0-769a-381960714fd3",
      "attributeId": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a5f37cdf-b2e2-0df8-f5db-b3ea2415a852",
      "attributeId": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
      "control": "StartDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b0088559-9d4a-b852-6699-6a6aa5878664",
      "attributeId": "617be8a6-bcdc-46db-86c9-2841eac54b68",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f27ec61-4e13-2d9e-7a39-60413c212ca9",
      "attributeId": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "44070596-2231-fd60-7e48-8a373db5ce80",
      "attributeId": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79d44998-f62a-a4c0-790a-f9920d1848a9",
      "attributeId": "5c84da90-3ecb-4c14-846f-8d1568091a77",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content"
}' WHERE [Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f';

UPDATE [dwMetadata] SET
[Id]='9a0db841-f236-48da-91af-05dec27a92b4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.447', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 17:08:01.817', 
[Data]=N'[
  {
    "key": "header_2",
    "data-buildertype": "header",
    "content": "Respondent Content Management",
    "size": "large"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 2,
                "value": "RespLogin",
                "text": "Respondent Login"
              },
              {
                "key": 3,
                "value": "RespDashboard",
                "text": "Respondent Dashboard"
              }
            ],
            "style-width": "300px",
            "events": {},
            "defaultValue": "",
            "placeholder": ""
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "StartDate",
                "data-buildertype": "input",
                "label": "StartDate",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-required": true,
                "other-customValidation": "",
                "other-visibleConition": "",
                "labelPosition": "left"
              }
            ]
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "EndDate",
                "data-buildertype": "input",
                "label": "EndDate",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-required": true
              }
            ]
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Status",
            "toggle": true,
            "events": {}
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": []
          }
        ]
      }
    ]
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "respHtmlEditor",
        "data-buildertype": "swzhtml",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "onHtmlChange"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "",
        "other-customValidation": "",
        "defaultValue": "",
        "hideOutput": "none"
      }
    ]
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "save"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "primary": true
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Save Editor",
        "events": {
          "onClick": {
            "actions": [
              "submitHtmlData"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": true,
        "disabled": false,
        "fluid": false,
        "circular": true,
        "inverted": true,
        "compact": false,
        "secondary": true,
        "style-hidden": true
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Fetch Editor State",
        "events": {
          "onClick": {
            "actions": [
              "fetchEditorState"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": false,
        "disabled": false,
        "secondary": true,
        "style-hidden": true
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
                "value": "/form/SwzRespAdminList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='9a0db841-f236-48da-91af-05dec27a92b4';

UPDATE [dwMetadata] SET
[Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_HELP-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 11:03:46.440', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 17:02:08.810', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_HELP",
  "lastUpdate": "2021-07-06T17:02:08.8096146+08:00",
  "entityId": "bb075204-7deb-44cc-9251-b1d158e816d3",
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
      "id": "db188500-410c-b948-85ba-95072a3176f6",
      "attributeId": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
      "control": "HelpContent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a50392f-e54d-0e2f-73b1-6bdc4ad8f608",
      "attributeId": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8551abf1-fa37-ca9a-1180-18dd8498b685",
      "attributeId": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc1f01c5-751f-9cae-34f6-4cd6827badc6",
      "attributeId": "90a76b37-0d22-4e40-8524-f4f990a161d5",
      "control": "Heading",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9e78c85f-8330-54f6-141d-1dafdfff716f",
      "attributeId": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98b6ba10-12d1-0a43-ca6e-9a8575519ede",
      "attributeId": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90935ca2-0db8-1f6d-444c-310b7b83380d",
      "attributeId": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3d6810a-b9a7-3142-0479-2d97428c5660",
      "attributeId": "459a9286-34fe-4a23-9992-362731d39f49",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee59f60a-0487-dadc-5d95-123bcaf8eb79",
      "attributeId": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
      "control": "Topic",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "246dcd52-bdc7-3150-4bd3-bbd2c436dd0a",
      "attributeId": "94da5047-34a7-42a0-97ca-09e704f33af0",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b47d650-15e8-4233-a9fc-3191f50e2df2",
      "attributeId": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c8205e0c-7502-98f8-3555-38fe4a5ce0a6",
      "attributeId": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content"
}' WHERE [Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a';

UPDATE [dwMetadata] SET
[Id]='23b8f3ee-35cc-4d74-8299-ca39d80a4d18', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_HELP.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 11:03:46.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 17:02:08.743', 
[Data]=N'[
  {
    "key": "header_2",
    "data-buildertype": "header",
    "content": "Online Help Content Management",
    "size": "large"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Topic",
            "data-buildertype": "input",
            "label": "Topic",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 2,
                "value": "admin",
                "text": "Survey Admin"
              },
              {
                "key": 3,
                "value": "resp",
                "text": "Respondent Portal"
              }
            ],
            "style-width": "300px",
            "events": {},
            "defaultValue": "",
            "placeholder": "",
            "other-required": true
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Status",
            "toggle": true,
            "events": {}
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": []
          },
          {
            "key": "Heading",
            "data-buildertype": "input",
            "label": "Heading / FAQ Question",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          }
        ]
      }
    ]
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "HelpContent",
        "data-buildertype": "swzhtml",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "onHtmlChange"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "",
        "other-customValidation": "",
        "defaultValue": "",
        "hideOutput": "none",
        "other-required": true
      }
    ]
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "save"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "primary": true
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Save Editor",
        "events": {
          "onClick": {
            "actions": [
              "submitHtmlData"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": true,
        "disabled": false,
        "fluid": false,
        "circular": true,
        "inverted": true,
        "compact": false,
        "secondary": true,
        "style-hidden": true
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Fetch Editor State",
        "events": {
          "onClick": {
            "actions": [
              "fetchEditorState"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": false,
        "disabled": false,
        "secondary": true,
        "style-hidden": true
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
                "value": "/form/swzHelpList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='23b8f3ee-35cc-4d74-8299-ca39d80a4d18';

UPDATE [dwMetadata] SET
[Id]='e9cc3d0b-9488-4546-9d17-08addc93e437', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_CATEGORY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.017', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:35:58.817', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_CATEGORY",
  "lastUpdate": "2021-07-06T16:35:58.8156699+08:00",
  "entityId": "5684ce32-1bb3-4e92-9b2e-91f4e87905f2",
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
      "id": "dc71893e-978b-fafa-3765-a7b9f4d0aa56",
      "attributeId": "6536ef8f-b9a1-4a7a-819b-35691537fefd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f9215a7e-83fd-400e-55f7-51ad964c9742",
      "attributeId": "a6250e06-4a48-43dc-81f7-4bbc9a80a0ea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "711c45e0-68a2-695f-d9af-1c6cc6f3b93d",
      "attributeId": "f0370aec-4608-46ef-998b-b115c3fe4ca4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "85fc042c-b792-19ab-9a64-ba2c30f765d5",
      "attributeId": "fa137602-163a-4f3e-9b78-980f5820a3a0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b55387ee-00e2-951c-49a8-3b8d96f965ab",
      "attributeId": "83f78020-12c8-430e-a030-a659dce0df30",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e09224-5a9d-5bbb-8f0e-d8b367d7b351",
      "attributeId": "38bae30d-1d9f-4003-8850-b6c19fa2b565",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "52d68045-3cf6-2e56-a73b-f7088f7d1060",
      "attributeId": "2115d9aa-2765-4e15-bf55-9f67465f0270",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "84b17b71-c3b6-710b-eaa3-ace3cf41244c",
      "attributeId": "69d19937-002d-45b7-b86f-73f63e918fd8",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ceca8436-a67d-865c-2e6e-1a648e50f022",
      "attributeId": "0ba90a37-bdfa-447c-b463-70fabd946961",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae17eca4-b13e-0c66-53ea-63f29f8ec620",
      "attributeId": "7f67d0c6-4bab-49e9-8270-12cfcc0b2f8b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "21da636a-0291-c4ed-6461-658bfa0afa6c",
      "attributeId": "ee2a1214-2e10-46c1-82da-c63bbf0c2718",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0acf3b45-1dd8-1279-28cf-a5dda6cec2a2",
      "attributeId": "94217f4c-c998-4900-9ee1-a6f6826113c3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15384e53-8e33-cdf5-08a8-633fbd91dfb6",
      "attributeId": "d78ebe9c-b194-490a-859a-18ecaa37f967",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed65e1c6-dd49-7fe3-baf0-db65ed0964fe",
      "attributeId": "53fc33f5-3fab-487e-9569-170e34f28f09",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Category"
}' WHERE [Id]='e9cc3d0b-9488-4546-9d17-08addc93e437';

UPDATE [dwMetadata] SET
[Id]='11c92291-9d59-45b1-9322-a28318bb61c2', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'QNN_CATEGORY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.060', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:35:58.760', 
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
            "key": "dropdownType",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "L",
                "text": "List"
              },
              {
                "key": 2,
                "value": "Q",
                "text": "Questionnaire"
              },
              {
                "key": 3,
                "value": "D",
                "text": "Deployment"
              }
            ],
            "search": true,
            "placeholder": "Select type..."
          },
          {
            "key": "dictRoles",
            "data-buildertype": "dictionary",
            "label": "Roles",
            "fluid": true,
            "selection": true,
            "dataModel": "dwSecurityRole",
            "columns": "Name ASC",
            "placeholder": "Select one or more roles...",
            "multiple": true,
            "events": {},
            "filters": "[{\"column\": \"Code\", \"value\":\"Admins\", \"term\":\"!=\"}, {\"column\": \"Code\", \"value\":\"User\", \"term\":\"!=\"}]",
            "paging": false,
            "search": false
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
                  "btnSaveOnClick"
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
                  "redirect"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzCategoryList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          }
        ]
      }
    ]
  }
]' WHERE [Id]='11c92291-9d59-45b1-9322-a28318bb61c2';

UPDATE [dwMetadata] SET
[Id]='22cdf459-84e7-4174-a19b-79618f6f383b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.853', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:33:20.400', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2021-07-06T16:33:20.4008503+08:00",
  "entityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{NumRetry: 0, CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"0\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"1\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "DecryptPasswordAsyncTrigger"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertSampleStructDivisionAsync"
    }
  ],
  "dataMap": [
    {
      "id": "edc7e5b8-3583-18b9-c627-cf5e7cb86f24",
      "attributeId": "011a70db-a5ae-4019-a9ac-4c167d60bbb0",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a49787b-ba63-68a2-17b3-36da7da2cf2a",
      "attributeId": "63a7a61b-6248-4197-8d08-3fc85ff686ba",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbdffc8e-e317-f0d7-53b4-04aa30f76d98",
      "attributeId": "be7d893d-9d5d-4c1e-a3e7-b04e13a5c303",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ff7b685-f4d8-fb31-e481-f56b2789e4c3",
      "attributeId": "3cb554ec-8497-4513-93c5-58769fe5231c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3f1f58c5-4e1c-2f43-7ff3-5f26b5cc9a98",
      "attributeId": "8778e5f8-94eb-438f-bfd5-36ede705a05b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "744728cd-b932-3c71-4ad5-cd42d92935d3",
      "attributeId": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
      "control": "Email",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3c3d5589-a4b2-5a16-3334-24c619fbcdcc",
      "attributeId": "96143a54-6881-4bfe-947e-39e6ab7fd935",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a6cb92af-19df-2766-c04e-b94f1f078fe0",
      "attributeId": "b22a30c4-696c-4ced-aa4a-22620b16a884",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e8cc4b-66f9-f92f-4eb3-55a05b13914b",
      "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5cf2cb99-c2d4-d091-a37f-d857b1273fa6",
      "attributeId": "1b3705b9-e1de-401c-996e-c7c9ac10366a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7435cf97-3c62-30f1-4a23-4d823c702644",
      "attributeId": "ac3c5076-a671-43d0-bab9-d50d339598a9",
      "control": "NumRetry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ab14d4-d93e-6287-ffff-59e47491846d",
      "attributeId": "a02ab42a-6f9c-4a9d-8112-3cc7eae2a5fc",
      "control": "Pwd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eae93866-4ae7-aec2-c89b-b10233e2beb9",
      "attributeId": "700091f4-476a-440a-bc17-ab5351fa461b",
      "control": "PwdResetYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f467544-177f-9368-48bd-501792ae1096",
      "attributeId": "a7440614-efc1-454a-8ff7-cc29764ad271",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4ad5c54-eea6-5a18-b8d2-878a742ef438",
      "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37738de-03a7-9b0e-cce8-db6ac0994dd1",
      "attributeId": "96609d0c-c7fc-4fcb-816b-cde87a1e5de3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "acf1b3ba-ad4d-ed4a-62a8-145645ae5a31",
      "attributeId": "791dc4a1-5ee5-4550-88d4-56ff82d0d867",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8376408e-eb50-67e7-5260-eb9d677237eb",
      "attributeId": "c50309ed-78cf-4601-b861-a0e8c43f8ba3",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "List"
}' WHERE [Id]='22cdf459-84e7-4174-a19b-79618f6f383b';

UPDATE [dwMetadata] SET
[Id]='6b16fa37-61d8-43a9-a851-558d889ca9c9', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.567', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:33:20.337', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "{entityState} Sample",
        "size": "huge",
        "subheader": ""
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "events": {}
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-readOnlyConition": "data.Id",
            "other-required": true
          },
          {
            "key": "Email",
            "data-buildertype": "input",
            "label": "Email",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-customValidation": "!value || (/^(([^<>()[\\]\\\\.,;:\\s@\\\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\\\"]+)*)|(\\\".+\\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$/).test(value)?true:\"is not valid!\"",
            "reference": "Email Address",
            "other-required-soft": false
          },
          {
            "key": "Pwd",
            "data-buildertype": "input",
            "label": "Password",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-visibleConition": "CloverApp.API.checkRole(''Admins'')==true || !data.Id",
            "reference": "Password",
            "type": "password",
            "other-customValidation": "(/^[a-zA-Z0-9]{12,100}$/.test(value)  || (CloverApp.API.checkRole(''Admins'')==false && data.Id))?true:\"must contain alphanumeric characters only; password must be between 12 and 100 characters!\""
          },
          {
            "key": "NumRetry",
            "data-buildertype": "input",
            "label": "NumRetry",
            "fluid": true,
            "onChangeTimeout": 200,
            "defaultValue": "0",
            "other-required": true,
            "reference": "NumRetry",
            "type": "number",
            "other-visibleConition": "data.Id",
            "events": {}
          },
          {
            "key": "ActiveYN",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "PwdResetYN",
            "data-buildertype": "checkbox",
            "label": "Change Password at First Login"
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
                      "save"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btnResetPassword",
                "data-buildertype": "button",
                "content": "Reset Password",
                "primary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "resetPassword"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "secondary": true,
                "other-visibleConition": "data.Id"
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
                        "value": "/form/swzsamplelist"
                      }
                    ]
                  }
                },
                "primary": false,
                "secondary": true
              }
            ],
            "style-float": "left"
          }
        ]
      }
    ]
  }
]' WHERE [Id]='6b16fa37-61d8-43a9-a851-558d889ca9c9';

UPDATE [dwMetadata] SET
[Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:29:45.653', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_RULE",
  "lastUpdate": "2021-07-06T16:29:45.6334534+08:00",
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
}' WHERE [Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4';

UPDATE [dwMetadata] SET
[Id]='ce0c6c21-9d50-421c-b7d2-bedfc889a3f4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-06 16:29:45.123', 
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
            "secondary": true
          }
        ]
      }
    ]
  }
]' WHERE [Id]='ce0c6c21-9d50-421c-b7d2-bedfc889a3f4';

