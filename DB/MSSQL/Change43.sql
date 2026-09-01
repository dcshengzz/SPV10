-- Feature: To have access control for IMPUTATION function
-- Implement guide:
-- run this script
-- restart site after execute sql


----------------------
INSERT INTO [dbo].[dwSecurityRole] ([Code], [Name], [Comment], [Id], [DomainGroup]) VALUES (N'Imputation', N'Imputation', NULL, 'B039A7E1-2686-A8AB-CF83-C7C4FC2E500F', NULL);
GO
----------------------
INSERT INTO [dbo].[dwSecurityPermissionGroup] ([Id], [Name], [Code]) VALUES ('9EA7A693-DC18-E324-67C9-C28A37F30D86', N'Imputation', N'Imputation');
GO
----------------------------
INSERT INTO [dbo].[dwSecurityPermission] ([Id], [Code], [Name], [GroupId]) VALUES ('8E4A5E96-142A-FA7A-84E5-20ABC8E4B4E7', N'View', N'View', '9EA7A693-DC18-E324-67C9-C28A37F30D86');
GO
INSERT INTO [dbo].[dwSecurityPermission] ([Id], [Code], [Name], [GroupId]) VALUES ('879C2EED-295F-F179-4E7F-56C71CBA40E4', N'Edit', N'Edit', '9EA7A693-DC18-E324-67C9-C28A37F30D86');
GO
----------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='FDA09D74-02B3-4085-9BC7-D4B7457E1AAD', [Folder]=N'metadata/forms', [Filename]=N'dplyImputation-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2020-01-07 13:10:31.320', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 13:22:17.313', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyImputation",
  "lastUpdate": "2020-02-19T13:22:17.3094612+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "0c5fe000-d5d0-5a64-104c-e7f1f12280ac",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29d8b956-8e2e-26ec-36a4-61cf663e6905",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "51778179-1119-e0ae-7f5c-a664c6e1611f",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f51f2d4b-9cf6-1258-8914-23dbee9b2fe0",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e6b13686-56ba-823f-7d4a-d2db4bb3cd9e",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19224cd3-7c22-ac6c-8bb8-fd61536d1233",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2dc05288-8957-2788-553e-c4b49022928c",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e2c99b3-aeca-7bbe-50e6-07f90af39af7",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b02a2117-747a-d512-ad06-b5cc9c5c8ef1",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1d68227d-1d05-079b-c826-7171bb015bcb",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e112652f-f104-44c6-0fdd-6193e2dd639b",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "81a69e67-7b1b-82fd-cd25-9e564cf1f2b0",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7b817447-7265-eaaa-cdff-c0fadb5dff56",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2b0a215-1328-6a3d-ad9d-cadd7524114b",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "81de3d2d-5855-ba97-f4a4-c7a69c5ce657",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb743015-363b-7187-9ee6-8abcd0cec3bf",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6c973712-a08a-123b-f74a-1c9611edc6d8",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a0b8586a-116b-666e-e0cf-c7ad2d7ba76c",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1b8d3fd5-4c90-8340-e430-594d4702f8cf",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fda33ab0-f60d-7a93-a573-b9df64ede83e",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e750482a-3322-907d-4e89-c286115dff43",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "861b3463-eff7-094d-5f84-89f810cf9bc2",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "def506ba-10f8-11aa-915a-2b865ad1148f",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b1eed774-a54a-cd8f-43d9-dc8bf6826ce2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bde9910-011f-02ef-13a8-0e521dce39c4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b7017236-9b84-049e-9d29-5ce3f73a2386",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d05c71f-fa09-d74b-d82f-5ca5341d7a7c",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4c13ac86-a8cf-9626-3dbc-0725de999539",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Imputation"
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='FDA09D74-02B3-4085-9BC7-D4B7457E1AAD');
GO
------------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='057F23A2-F709-4620-8A27-E95B43463BB3', [Folder]=N'metadata/forms', [Filename]=N'dplyImputation.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2020-01-07 13:10:30.993', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 13:22:16.113', [Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Data imputation",
    "size": "huge",
    "subheader": " {Name}"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "Deployment",
        "data-buildertype": "dictionary",
        "label": "Source Deployment",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentOnline",
        "columns": "Name ASC",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "removeAllFields"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": false,
        "filters": "[{\"column\":\"Id\", \"value\":\"{Id}\", \"term\":\"!=\"}]"
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {}
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "DeploymentQnnFields",
        "data-buildertype": "dictionary",
        "label": "Source Fields",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentQnnFields",
        "columns": "Name, NumberId asc",
        "events": {
          "onChange": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": true,
        "filters": "[{\"column\":\"DplyId\", \"value\":\"{Deployment}\", \"term\":\"=\"}]",
        "search": true
      },
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "addAllFields",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Add All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "addAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            },
            "style-marginRight": "10px"
          },
          {
            "key": "breadcrumb_1",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Remove All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "removeAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            }
          }
        ]
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Impute",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "impute"
            ],
            "targets": [
              "DeploymentQnnFields"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true,
        "inverted": true
      }
    ],
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  }
]', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='057F23A2-F709-4620-8A27-E95B43463BB3');
GO
---------------------------