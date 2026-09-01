-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_SAMPLE.json
-- QNN_SAMPLE-settings.json

UPDATE [dwMetadata] SET
[Id]='6b16fa37-61d8-43a9-a851-558d889ca9c9', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.567', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-31 18:23:39.580', 
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
            "key": "LastLoginDate",
            "data-buildertype": "input",
            "label": "Last Login Date",
            "fluid": true,
            "onChangeTimeout": 200,
            "defaultValue": "0",
            "other-required": false,
            "reference": "Last Login Date",
            "type": "datetime",
            "other-visibleConition": "data.Id",
            "events": {},
            "readOnly": true
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
[Id]='22cdf459-84e7-4174-a19b-79618f6f383b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.853', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-31 18:23:39.840', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2021-07-31T18:23:39.8178706+08:00",
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
      "id": "68025520-09f5-8e87-de8a-d02b755a2e17",
      "attributeId": "e9ee47ca-3a33-42de-54e8-f98a5323d26d",
      "control": "LastLoginDate",
      "isEditable": true,
      "isLoadable": true
    },
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

