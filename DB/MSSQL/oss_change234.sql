-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu.json
-- DataEditorDeployment-settings.json
-- QNN_LIST-settings.json
-- QNN_DPLY_PRE_POPULATE-settings.json
-- UserAccessMatrix-settings.json
-- SwzGlobalMailer-settings.json
-- SwzGlobalMailerMessage-settings.json

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 16:24:11.520', 
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
            "target": "/surveydesigner?apanel=filestorage",
            "title": "File Storage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "Validation Rules",
            "target": "/form/SwzRuleList",
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
            "visibleCondition": "",
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
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') "
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
[Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 12:00:21.670', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeployment",
  "lastUpdate": "2021-11-04T12:00:21.6455013+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "dd2b1de1-8906-5440-a0b1-02b52ae0b7bb",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "af0b83d4-7938-1792-7467-8cda8561fe59",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a586de72-847a-a985-3629-7e51539d4a84",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "734db879-1d82-c264-1027-f30a57b9b67a",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "34836eb8-15f1-34ec-ab1c-e0e535f12a9d",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dae432fc-ec82-a8f2-03d7-7b3b4495fdb5",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e51fde7-57db-97cb-44b5-43b57a7b2c7a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "799e556b-61ce-1fc4-4d1a-7dfecd1a571c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ec6ab480-72d9-4e70-8ae5-e9fa27776491",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1e4706d9-3dda-13d2-cbae-ba3192c4c478",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1af8c09f-a1a6-e6d2-68ca-5a2aff87db30",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8b3d96dc-a807-1e6b-281a-e9fd87c0c595",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a681a21-7ea6-fbdc-76c4-57adf19cd9be",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "45cc1a58-9465-85b9-733b-e35726bbe246",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14d66d-44b0-635d-b9cd-0586f86baca2",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "11709f94-f671-f1ef-9d2c-80c5a1411442",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2186040a-20a9-baa7-7aa7-dac44246641e",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29f312d4-dc1a-a3e3-f4b0-5b28f3125567",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039caea8-8b26-54a3-c82b-9d71aa0a285c",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "039280c8-f268-964d-101a-4fc229a524d1",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "88d5edc3-9d2d-958d-fcd3-0dc260e95f00",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "348b6b76-a181-c3d8-10c3-64dccfcfb5c8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6b22e96c-497f-5dd8-f4d5-5451e39e1ed7",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c937d26-b286-4818-87c2-64ca646c0b09",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dd5554b7-3553-c9fc-c472-47b7ae764ae9",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1df3b42b-b6a3-bda3-e867-cf6e5ff6c146",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb3c783b-89c2-6c2a-cc11-b1a2bb3eb729",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "35ccbaae-388e-7f28-ea7c-7304541afae9",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1d40544a-b501-7c0d-5f87-3daabb92ba95",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "840aaca3-e459-2b81-39fc-4658c3f3c263",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bf099076-5ad5-ede5-f80e-25042482b18b",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f172169e-666e-4df9-964b-c8f43babf927",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "573af6e6-6b28-9f43-25b6-5deaeb8eeb2f",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c6b1203-7c06-14d6-632d-bd9f75cf392f",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "af1fb791-053c-d155-7038-d5d2f43a5ad4",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "14ee1d12-282d-7e2a-227d-a04682b9f06e",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "563d44e5-b373-7ce4-9396-393b8048548c",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2c10aa9-a84e-8652-e0d1-09f8b58346f8",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "898de757-596a-b36e-14db-facf115e67fa",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "02164652-3fae-a756-6ad7-3c5ff10f6860",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "99f9f3db-5e93-3bbd-8170-f3d6def5b716",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4879333f-cddb-05fb-d28a-001589f23de5",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8a15e500-d6c6-cee3-f2a1-031d74a8650b",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "43f40941-ce5e-2326-827b-69b2ee2ae6b6",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9ea64c57-9ec8-4755-cb19-de2c63a9547b",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfbd4e1a-23b1-e22b-26c6-42f4459f72e3",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9832d71-bdd9-fa77-3cd2-eb70e6d815a9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9bd2dd1-4892-b55e-62f1-565755bbfab6",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7e0286d2-b996-269d-ea4a-70a88b7a8251",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e8bdcd70-6784-8c12-4a12-da128039ddeb",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a56b8b4-4501-60a4-0e36-1e42c4fb491b",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bb8cd888-a68c-3962-3232-6cded5eefaee",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "aa7f5eac-b5d0-45b2-a883-37af1e8c90b0",
      "entityId": "fe42f73b-dd23-468f-abce-7603be873b15",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{UserId: \"@UserId\", DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "ca856a82-8cf7-94e5-6a63-be0112a9de69",
          "attributeId": "5068b642-c419-4e66-9cb6-4c499f8fbf98",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac9a5899-a4ab-a832-2458-bbbe9297800e",
          "attributeId": "9839c5ec-1da6-4480-b4a4-dfcd0d8c7ee3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ec5edf34-3b0b-5c28-4a65-def784054037",
          "attributeId": "bc9ea8c1-8e42-46c1-a307-20bd1f16425c",
          "control": "DateComplete",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1cc6738a-1af6-a23b-389f-398c8fd7358f",
          "attributeId": "29955168-38dc-4bc4-9d09-51936f0c47a3",
          "control": "DateStart",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db11567c-09c6-2bea-b6d5-5d66ed18ea9a",
          "attributeId": "5092b667-2bd3-4e5c-901d-af0c08ab963f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "07b46b6f-2327-8fa4-ad8b-1b372074f71f",
          "attributeId": "eae438a7-c933-4cf4-901f-9afe4676b5d2",
          "control": "FormNames",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29992aa5-ff10-8f3f-3496-af3af7c8c049",
          "attributeId": "3f32683a-0b73-4487-8f9f-bcf67f4cd3de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0af2ce3e-6c33-6c1a-02fb-adacf28ccf1e",
          "attributeId": "12b9130f-5b30-4de6-b1b3-9c87eb24b51b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9e3e3241-0ed5-991c-ceed-8a7e7dfa36e9",
          "attributeId": "8de04fab-6501-4963-9be1-d94e4e17bdad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99668211-09a4-a2ff-025b-712f80a76e84",
          "attributeId": "194b29f5-61d7-4e19-9bff-61b7d63a59bc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df75d4b6-1b24-8491-608f-65eb8e83b7a6",
          "attributeId": "bdd2c1e8-5fcc-425e-961a-902bb6a04b1b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20fb1a1a-4568-05f7-191a-5f7fe80c5e11",
          "attributeId": "6334a04c-beac-457e-a52c-6321f8eee654",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0333e9e4-2539-eea0-3fe5-469f369b162e",
          "attributeId": "5d21fa68-625e-47f7-8b04-7e2407cb6833",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbfc2be2-151c-fa31-134e-29e1565630d0",
          "attributeId": "ea09352e-57ba-4d9b-a1dc-c46e0f9d35a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d27dcbe-d8c3-9339-9c82-22c664862417",
          "attributeId": "a3a11c9c-b29d-409b-8bec-45da88c5d7cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9497d95-641b-128d-fb42-8ab57b7037e3",
          "attributeId": "cb1b05c3-930a-4336-82a3-8fcf1d5d03be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ecb61b0-5e91-a2c7-f3d2-9fafb61d274a",
          "attributeId": "e119a97f-3f94-4359-bf02-550c2523f58e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ba5e855-c142-3291-a47c-3e5f269c0371",
          "attributeId": "2f9a77cf-0afc-413a-abe5-8268e56c8f3b",
          "control": "StatusTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bf4af0d-2c41-be37-d27f-6564ff0ed821",
          "attributeId": "2416c808-79fd-45b8-b9ea-09ff66b261dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47c01363-0e02-128d-6836-b43901d62d8c",
          "attributeId": "e62abbfa-5e05-45f0-a59d-d25f0a90e47a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa72e2c4-3908-eca1-c269-5ca4628df44b",
          "attributeId": "93d1e6f3-e3da-46c6-8da2-f145da19c67e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "606e2796-04bc-7cec-16ab-d329785946b8",
          "attributeId": "c77c6136-5ac5-49e8-bf25-7e6bda01302c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dbf63b7-2082-676b-627d-422e1ec8c924",
          "attributeId": "0eef5a8c-cfa7-4c9e-ab34-d3d7b45593bc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6711b4a5-90ee-9960-7ada-d28884061dbc",
          "attributeId": "16421e73-0595-4b09-bee5-15d70ea719d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2429f66b-3e7f-b3df-a83f-eb1f76d6d6ec",
          "attributeId": "60a898b6-786f-45e3-a57e-8f7739ac70b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "492a6432-5665-e28f-bfd8-31a6f8cd0b1d",
          "attributeId": "8bd473e5-f566-4b1e-acb6-334ebd1c42f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db2fc40a-7bc0-1820-c5d7-304f368e2411",
          "attributeId": "b4fd6baf-2091-46f5-9479-1cb9755293e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6eb9df3d-925b-61cb-a4d5-bbb642712db8",
          "attributeId": "12e75b20-1246-448e-a824-b8e7320a0bdd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "317feb1c-51ba-f67e-c9ac-02ec111c2f91",
          "attributeId": "235e46d5-89f1-42db-a225-0e788022075c",
          "control": "UIDName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5077e7e6-8186-ee94-45ae-e6586b381adb",
          "attributeId": "81d40b12-963d-40a8-bc18-c310f0f82a5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5de0cae3-364e-20c5-4196-0120370d24c8",
          "attributeId": "ead782a3-2bf2-4ffd-aa71-970315d9a3ac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4c741369-1e2b-16c4-7d81-56803e6be9db",
          "attributeId": "0380c4cb-0e1b-4232-ba8b-8e4cb26cf0eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "30962f6d-1fce-bd3e-9fb3-f92ac87aed3d",
          "attributeId": "d76d0092-3f3a-4006-a7ec-326621b58e70",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c989e4b2-ff2e-3958-9698-de4453caaa4d",
          "attributeId": "a1cb339f-8561-41a3-9f05-62a327f7e30b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f679353-160f-141d-120e-8db0d48a859c",
          "attributeId": "dec06220-d310-43c9-ace8-cdf8bcfa233b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "568bc539-279c-0035-dc94-2a17964374ea",
          "attributeId": "73e6b5cc-fedb-4d93-8be2-91f9992e4b1e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cfbfa2f6-6a8a-2c0c-ec37-63439a176986",
          "attributeId": "4a348d30-9f13-415e-8c6d-bf6944ce7272",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf076c60-4e13-63f8-f248-fd83fd368787",
          "attributeId": "a5fae11f-6956-4f3e-8a98-b4c87eff7829",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "DataEditor"
}' WHERE [Id]='65e99b1a-44c8-47cf-94f3-e96a73e3f9fd';

UPDATE [dwMetadata] SET
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 12:28:27.353', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2021-11-04T12:28:27.3520238+08:00",
  "entityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
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
      "id": "6bb9025a-7861-e177-eded-333d69e577d4",
      "attributeId": "17bf4b77-798d-4cba-83d4-16ea2a7696b7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b63f953d-7550-606b-742b-a593cba856a2",
      "attributeId": "c25bbd26-a246-4904-9400-a34ee23930a3",
      "control": "dictionaryCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79853784-fc1e-c680-ffe9-cb8aaeff5c39",
      "attributeId": "ebcf3683-c851-499c-a4b9-e2daec3948c2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e158c090-63ad-c843-de20-e2fd018a051e",
      "attributeId": "9eef3bf1-726a-4bcc-81db-eb27a0a16b04",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ea041ec-525a-89ac-0908-fab13baf146b",
      "attributeId": "76f762fb-7aa1-47fd-9ecf-b0c17bca4b43",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1ccd0d11-07a4-5fa0-41d7-b5979cbfdfd1",
      "attributeId": "852fb683-2f47-412a-9e40-11de48808b16",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e8b13f8-da52-e713-1b09-efb0d94a0148",
      "attributeId": "98399b10-9bc8-442e-88ce-2ff314a8c7ba",
      "control": "headerDescription",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ce4fa93-6667-133a-8f7a-7604cf99939b",
      "attributeId": "83bee845-79e5-4929-b4fb-fe5cff7748a8",
      "control": "toggleEditEmail",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab9545bf-afde-3b8a-be20-7fd4fb38ff33",
      "attributeId": "27f10ba1-fbdf-4878-958c-8400ea40490f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f07bb99-136e-4e3c-2401-c27a6d38e5c6",
      "attributeId": "a11f6ad2-bda5-4a4f-bafd-230fa27ccb36",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9cf7eb23-7a27-f882-e683-4d1cd4e17c97",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "control": "nameInput",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bd5ce67-64b2-f488-1327-13b0fa4725bb",
      "attributeId": "483d548e-4239-40a9-82cd-c47981e25945",
      "control": "toggleEditName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed6d936f-04af-04c3-2ff0-a1c23fa25c83",
      "attributeId": "0d50217d-3b94-4aa3-bccb-7dbdbb222749",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "292801af-0143-79be-0402-be3fc30eec41",
      "attributeId": "3f17e524-114a-4c9a-a71f-99154710f20e",
      "control": "togglePassword",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4af24cb-542d-3804-ef56-7cb98f1ba120",
      "attributeId": "6899bb22-b9f9-48da-adef-29209c0b0595",
      "control": "toggleStatus",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "456dd0ff-56dd-614a-89a5-4c6983bdf189",
      "attributeId": "064f6b2f-14dc-48dd-8e6d-b4e175be873f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6daa775d-0f9a-63a3-a83f-3ee20de05d28",
      "attributeId": "82b9d680-7b4e-4d25-8b72-555bbb17fe8a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f06fd16-7354-7c35-0406-313e3dca70d2",
      "attributeId": "bb19edbc-181e-4f9d-9e8b-3f64a38dd911",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ca7559f5-2bb1-9ca3-df65-72516fecebce",
      "attributeId": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5194d452-7552-b246-c734-b81f51c9921e",
      "attributeId": "eba31ce9-8aea-467e-a463-4ed7ba17131b",
      "control": "TrkListIds",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "49f4229e-2ed5-6cbf-bc35-84f3bdffa14f",
          "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
          "control": "ActiveYN",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ca89d71-5128-9a6a-c46f-83c9b59d14f0",
          "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62f8faa6-b7d9-e5ae-2b1d-88968f5ad0d9",
          "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "dbf9842b-37d4-0fb0-ada0-d035f5821578",
          "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b98176e2-3a0a-1342-d8b6-ecc361035af1",
          "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "955eebb3-28e6-5927-75b7-f7cdebf0bb25",
          "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d339890-30b0-5099-e5fa-c29f931d88f7",
          "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a6ab3152-ef5c-3e46-47b5-87c6ea7b39a6",
          "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1a17e60-f698-b26d-8cf7-53dd3eed081f",
          "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e53a0cd0-bbb9-568d-434b-81ba82c172ef",
          "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ce869cca-457e-8e84-7f2d-aedebaaa4f83",
          "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e949966f-95ee-78bd-208b-afb9f7465364",
          "attributeId": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
          "control": "Email",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d0cdf7e6-3aea-1d21-65f6-b93e864be0e2",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "Name",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6e0819a-a46c-6f4d-4ee2-2dddee8062a1",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "UID",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93a8b5de-28af-a8b7-313a-c6429a2ce66e",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "PeerName",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d28cd4d5-202d-3a60-99d3-55ab0fd8a62e",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "PeerUID",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "dbf01fb4-db82-d562-bddb-a718f924ef35",
      "entityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "8442fb3b-134a-c355-7d90-f3e49c30af2c",
          "attributeId": "9c84a07d-bde2-414d-8628-9665e6df1c4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9990f3ba-6ea2-01f2-2522-5df2b216d08e",
          "attributeId": "304670fb-e871-443c-9c62-75b544da93a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e980519-bb41-ee3b-b0f9-724fad5fe32e",
          "attributeId": "495a9b97-319e-4139-aade-8103d4bc2e41",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0df8f806-b655-09c3-7a45-f6edf7604746",
          "attributeId": "27a0ea17-2da1-4ebb-ba54-0f783e3d2907",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b49e1ae4-2ad3-3cd2-4a86-66ce0cda30c2",
          "attributeId": "fc40cac5-1da7-46d7-90c3-f8e90cf935cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8657b639-deed-2116-f436-1982cee0669d",
          "attributeId": "cde17e04-b25f-476e-b722-97c11da29326",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5abd8c3-1e7f-166b-91d7-6725f32c6ded",
          "attributeId": "cbe9a1b9-bea3-49e1-9e1e-ac8391624939",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df2b19f4-19fa-9d44-b12e-1590811b0e55",
          "attributeId": "f5682ad5-b493-43a5-864e-3d554ac37ddf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "970989ac-c2e1-737a-1d0c-fd77022f0cfe",
          "attributeId": "70c763b0-6a8e-4a59-959e-fd6859fdfc17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb1ae13-7ce8-8524-217c-23de6712a577",
          "attributeId": "b2761fa3-a119-48a0-84e8-5112873d10d3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1e49ed9-982d-bfdc-cc71-a21fd33e3522",
          "attributeId": "6eaf8118-3a45-4e6d-88bd-f0fd37671cd3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b6adfdac-f4c3-b5bd-5158-25befb267921",
          "attributeId": "b430f4f3-2d95-4d88-a2c7-b8d12d33b144",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e128c585-70ab-a73c-ad73-1fd43d8f738e",
          "attributeId": "641d5acb-3586-4c86-a28b-22c339609610",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

UPDATE [dwMetadata] SET
[Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.283', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 12:33:23.840', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_DPLY_PRE_POPULATE",
  "lastUpdate": "2021-11-04T12:33:23.8397001+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c786f28a-7c1d-18a1-4e82-b9f14e49d539",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0967f63c-7b85-ccb8-9303-3e9b7cf2fe33",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5023f9da-3f2e-dda2-0f73-5a6311cce0c7",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83bce928-58fa-df11-8c38-8023ae24ffd3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "deca8cf6-dcd5-16dd-b0c0-394a30bc5bb4",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1b987af7-cddd-db61-fcd8-22c3f4c53430",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "374a9edc-ec27-f0f3-e318-ae95b1d65d56",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6368b51c-2ae4-cb3a-5ef7-1b413c202b5c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26703d56-1156-31f0-171d-e8d87610d564",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3b4f621f-b303-8322-460f-b72a0b58edec",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8579bacc-ad88-1655-66bf-fc4c0bc0e799",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a20baeb1-4027-5887-98ef-be1c2688cb8b",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c032b3d1-5303-f950-b1e0-23b6f059fa21",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8713a7b4-640f-8759-797b-8a6bfed64ca5",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7c124c4a-951e-b2cb-a968-d8c5273788e1",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dfd118fb-c4ae-28e5-0842-3651bbcc6547",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05468910-5730-4606-ca8a-2e51c41a049b",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4805992-33ac-ccb9-86e7-8dc8676e91d8",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0d2eaa09-3b24-f802-60f0-866ee281d2bb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08388972-fcf2-f431-14ee-2760c49ac885",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32f0783b-3ac4-05ef-afcb-513c0cf8a96a",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "22f01e4c-f4f5-b0a8-9ace-fff152c8861f",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2f395ae-8032-fb82-68ff-21491768e624",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8c9d150c-a4f8-bb87-e6d9-a1bc85955e43",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4cba037-57a7-977b-5611-779850d41495",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16fdf4f0-9710-d9c5-dfd9-919d2566a221",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9460cdee-c086-e3af-0ccd-b73915f33012",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5bf9eaaa-01b8-944f-0718-aa190ae0afa8",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42882ed3-0f8e-6d54-2a52-3499a8ed8dc7",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "14a0cd73-68bc-b02e-36eb-c474113482f2",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a3934ed-0ab2-ddfe-94b6-5dcefe8dfc01",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b217f1e9-4d95-46af-6850-93438bbaa77b",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bda4a316-cb9c-9c63-031a-d5f5c962de8c",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40074d33-2215-8f83-a2c6-103e301b60d2",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0f7f7c29-6856-d67d-7a28-52c37db4898a",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a8f1c8a9-ccb9-8119-3302-300fef905b8e",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "53a8bb29-ee35-bbbe-5e21-53706eb76527",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29d92318-26b2-a87c-2a62-36fc4e014814",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb1eb284-f895-ba94-87d0-22c7a6553d6a",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "624201ff-d565-fd15-2cb0-b007910456ac",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fad4c089-b443-251a-f24e-708131b711ea",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2eba97d8-5a12-25d7-e37a-a52fea864488",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a106511-5ee8-8d68-456d-122801b83c44",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e8ca787-2034-33c4-5966-190cfc0d1d78",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8dbefaa4-9886-95c2-ed6b-fcda217425d8",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "56b98d6c-ecf2-cf2c-dba7-29a2ea1a4cf3",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "722646b8-e0fa-5664-a7d1-9e3fa23bd1e9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "739c6a49-f04a-f95b-2e67-863ae59a2db2",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4c505d0d-4bd1-3673-b360-3af13fe1c638",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fb7b109-f7b4-1e28-0944-1371fb8059de",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "85ea249a-e020-aa37-6bf2-b1e891cd656e",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30a8203b-b474-503c-676c-545cf45771e9",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4209fb5b-8423-27f6-b5c1-d303126fcc18",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c3cd8263-34d2-221a-6255-fc2c0ca0367f",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "PrePopulate"
}' WHERE [Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f';

UPDATE [dwMetadata] SET
[Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.310', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 15:28:14.820', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-11-04T15:28:14.8192027+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin"
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

UPDATE [dwMetadata] SET
[Id]='bd23d168-027b-4827-b17a-7617b4a12378', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 15:41:13.973', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailer",
  "lastUpdate": "2021-11-04T15:41:13.9718411+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "a6062e72-4830-7d94-dbc3-731a6adfffaf",
      "entityId": "26f92131-609c-40bc-8b38-9ec4fd66fca5",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "c467c287-9a90-9323-3cbd-bf8ae2727287",
          "attributeId": "be5cfc9e-69b1-4ccd-a92a-bdd062727c00",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff86383-5e00-a969-8310-030675d955a7",
          "attributeId": "0c94a477-4399-4659-9d1d-5c24087d023c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a869f780-c1b7-67dc-de1c-75dac944c1aa",
          "attributeId": "dcee1721-2a49-4bbc-82b7-b8ea08f97c9a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a2fc8d9-8440-3ab1-12f9-7d2868616aae",
          "attributeId": "6e55e3d1-0f7b-4eb0-a20e-ca42f09ec4eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ede8577-6d92-a0cf-b9da-fdead3a0f7c5",
          "attributeId": "be72b7e3-bcc7-4d62-bb6d-3467d422512f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06100a2d-174b-4d39-ca2c-e2c14c76ce88",
          "attributeId": "705fe916-6b58-4b51-ac1d-cbbd565ab921",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62b8f9b9-83cf-9589-258f-e825421e57ee",
          "attributeId": "fb438787-70d2-4a34-97dc-1b214d1bdd92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da7f21e0-cf2a-2b81-d3d9-a2683ddf5a5d",
          "attributeId": "577ae8a2-3d0a-4b19-8a28-09c177fd19a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "afd269b5-bf93-5658-f107-87f896b8aa2f",
          "attributeId": "469e027c-f7dc-4227-a4c8-82152ba1dd91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0fcf4a9c-1172-8cad-41e7-367d045b51ec",
          "attributeId": "5d1fff92-b20c-4fb6-855d-f840171fa9bf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "880dbd97-5dc1-859e-f537-c0e8657306ac",
          "attributeId": "e5a4d062-2eb7-4009-920c-b00ec6f661da",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "de9764c9-5916-f36d-ddb4-e89d145f3408",
          "attributeId": "9001b9b9-0f4c-4cfe-b185-8fb97fe61a29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9cb669f7-74f6-7f5c-69c4-122532c93449",
          "attributeId": "b66ea0c8-5d41-4d09-9bc4-037a171d6913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "66722324-156e-9ef1-b94c-23935deb1ab6",
          "attributeId": "465f2fc6-434a-457f-bd45-a1835abd7bcd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8cc2868-ce74-f236-2b54-da8a60dc4984",
          "attributeId": "ba1df5e9-1f0b-4f9e-8c32-7c02fd04fff4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a46b6591-b811-ca0e-e144-34303c20803f",
          "attributeId": "0f66dd50-0752-4c59-b219-8fed4d27ace0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "185090ea-8777-1d36-4752-68dd25ffdd6e",
          "attributeId": "aee289bb-555f-4890-b890-7b3b1a6dc719",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa4a564-7283-29a1-33f2-0225b86bb993",
          "attributeId": "1e447ccd-dd43-4cef-abb7-f3d7a688cc8c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='bd23d168-027b-4827-b17a-7617b4a12378';

UPDATE [dwMetadata] SET
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 15:44:04.400', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2021-11-04T15:44:04.3991144+08:00",
  "entityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "2233d8bb-2753-7adc-140a-f3713ed2bd19",
      "attributeId": "51458d0d-a57e-415d-af77-0506b62b2deb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e737ab32-149c-f374-034e-dbe21901d118",
      "attributeId": "178e7c32-3be5-46ae-8ab1-94a6504f1a2b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78945706-2fd2-e046-bfdb-bc96647a242b",
      "attributeId": "7c6620ef-f482-49bd-86bd-86ec78fa23ee",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "80e9b5b6-e9d0-d6c6-7820-fda90a42cdca",
      "attributeId": "04e1e5d0-d802-4a29-92ab-221ff60efb6c",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "cc3532d7-a661-48ec-434f-ecbf5d6f4c37",
      "attributeId": "868d7019-916a-41a2-ad9c-80e83c3e7146",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37108dd-6858-a497-a9bb-a8a61d9d4a62",
      "attributeId": "cf5185ac-386f-4c17-9b43-d81346e47627",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "00f5b7a6-98e0-e43d-bdfb-7130427ac87b",
      "attributeId": "7f4eb9fe-d50d-4b90-be34-5f81b48a005f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbc3f2c9-8468-1e35-8b28-186bd9130f4c",
      "attributeId": "25163e9e-6d07-4423-bef6-5203af0926cf",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "4c82c383-7898-02c4-46e8-c5048e9d98e1",
      "attributeId": "a59d6ab1-d8f1-4092-a7b2-5302d788b52a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d7efc1d-18a9-1188-aaab-64a342757ed9",
      "attributeId": "e24601f7-a005-4dc1-b76b-2e4ced2c9f47",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9ee0391-52e3-87a4-554f-0b077751cef3",
      "attributeId": "ffc06abf-996d-41b7-8aee-f8ee9b573217",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e3246e2e-23df-9c09-498d-019c4037fbaf",
      "attributeId": "b34d67a4-bfc5-4ee0-9112-d7ddffbfd570",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c40f8b2-4c30-f7bc-e027-d37ee84d4bfd",
      "attributeId": "603cb5e3-af1f-4288-8659-9d041999c4d4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19190086-6d45-9e40-be40-9531abc43cd7",
      "attributeId": "98daf50e-4248-4701-8fdd-17dacdd94355",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfe6fd82-2f3c-1d8e-ca6f-761aab03d8ef",
      "attributeId": "bb0f1b64-9144-4b35-916b-3a6292a0e774",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "61abc650-e453-e08e-8278-b4f1239170d1",
      "attributeId": "f1658572-a0e2-4084-8cf9-17b3a4f2998a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d475ab76-4cf6-9e57-4d3b-bc47bac2dedf",
      "attributeId": "1a057eec-3f17-49fa-b876-261f21e6695a",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b0292df5-4b89-70ba-7594-fd5ba4e1f8bc",
      "entityId": "65091649-b0af-4091-86f9-7109aeb9fbf7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "attributeId": "8c53aed3-bbc5-420f-84f0-e6b8820052cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10d586e4-f3bf-dd0a-fdc5-8e00c0c5b388",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "e9dd17e6-7fdd-78ea-f15d-73b1202f750b",
          "attributeId": "1287529e-1bc7-465a-a53b-98cb619f253b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ce34148-ea28-4a48-8417-e7f8a16a222c",
          "attributeId": "1ffeb14b-0ab9-4ca5-ade4-2971477fe68b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "4ba1a0b1-27ae-1ffb-2156-315fff887e73",
      "entityId": "1aa13d9f-30a1-482e-9733-ee01420755f7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "sampleGrid",
      "dataMap": [
        {
          "id": "fc90a4a8-8cf1-61a1-609c-fd1ec101de5f",
          "attributeId": "e958ec47-15ba-4f2a-9f06-b82631dc6a6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f4699a1-ab9d-1454-a2c7-647b982701af",
          "attributeId": "0e2eac76-0927-4eb7-8fdf-c5955a3d227a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf4d04ce-5cb5-202a-a744-9bee51e82991",
          "attributeId": "8b4aaa31-a559-4912-9397-09de90ac4e16",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a504a99-7cd1-4452-6ffc-7612b2961e92",
          "attributeId": "4853e87b-032f-48ce-b964-790b92b9e918",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d4e96d7-3e92-7958-6d7e-687c26985e75",
          "attributeId": "686137e7-c77f-43bd-9dd2-e6b79b4465aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96a42599-adad-d96f-c7e2-4ac67180323e",
          "attributeId": "907dfbd8-9670-4099-8dae-91b18986837c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "10a9584a-1aff-bc30-6e96-512acd7ac710",
      "entityId": "a7267c48-2060-46d2-8923-cd1dcbd01006",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "userGrid",
      "dataMap": [
        {
          "id": "4f17a43d-7519-f6d4-b4ca-c396cb3bc46e",
          "attributeId": "b3bc9f47-0598-4079-9114-f21bf45fc83e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5272c995-ab67-e316-a4de-fc2bbe043cd8",
          "attributeId": "4077a2c7-b11c-42e3-9fdc-e9382299c204",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63d33da7-0f3c-5557-34a2-b50f4da8ebb1",
          "attributeId": "08edc3df-13f7-480f-9fbe-9a8d1f638a70",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9427ff3-b519-ab75-0167-db1c85bb1450",
          "attributeId": "0a99aad0-9fcf-412f-8f29-f51ec14de57e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "619b3f3f-8600-98d5-ebe3-865d75e7ecbc",
          "attributeId": "cef5e01e-8dcb-4767-bcb9-6b1dc397ea25",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='95150f4a-b078-48ac-a2a5-a12da83bf571';

