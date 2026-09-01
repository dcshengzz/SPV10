------------------------------
--fix: when creating sample, pwd was encrypted twice
--added regex for password

UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='22CDF459-84E7-4174-A19B-79618F6F383B', [Folder]=N'metadata/forms', [Filename]=N'QNN_SAMPLE-settings.json', [IsDeleted]='0', [CreatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [CreatedDate]='2020-02-11 16:41:54.853', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-03-18 08:49:35.547', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2020-03-18T08:49:35.5457433+08:00",
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
  "dataColl": []
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='22CDF459-84E7-4174-A19B-79618F6F383B');
GO
--------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='6B16FA37-61D8-43A9-A851-558D889CA9C9', [Folder]=N'metadata/forms', [Filename]=N'QNN_SAMPLE.json', [IsDeleted]='0', [CreatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [CreatedDate]='2020-02-11 16:41:54.567', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-03-18 08:49:35.367', [Data]=N'[
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
            "other-customValidation": "/^(([^<>()[\\]\\\\.,;:\\s@\\\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\\\"]+)*)|(\\\".+\\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$/.test(value)?true:\"is not valid!\"",
            "reference": "Email Address"
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
            "other-customValidation": "((/^.*[A-Z][^A-Z\\s].*|.*[a-z][^a-z\\s].*|.*[\\d][^\\d\\s].*|.*[`~!@#$%^&*()_+\\-=:;\"'',.<>?{}\\[\\]\\/\\\\][^`~!@#$%^&*()_+\\-=:;\"'',.<>?{}\\[\\]\\/\\\\\\s].*$/.test(value)  && value.length>=8 )|| data.Id)?true:\"does not fit requirement!\""
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
                      "goBack"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
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
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='6B16FA37-61D8-43A9-A851-558D889CA9C9');

GO