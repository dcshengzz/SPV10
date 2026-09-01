CREATE TABLE [dbo].[AuditLog] (
[Id] uniqueidentifier NOT NULL ,
[UserId] uniqueidentifier NULL ,
[SampleId] uniqueidentifier NULL ,
[EventBatch] uniqueidentifier NOT NULL ,
[EventDate] datetime NOT NULL ,
[EventType] nvarchar(20) COLLATE Latin1_General_CI_AS NOT NULL ,
[TableName] nvarchar(100) COLLATE Latin1_General_CI_AS NULL ,
[RecordId] uniqueidentifier NULL ,
[ColumnName] nvarchar(100) COLLATE Latin1_General_CI_AS NULL ,
[OriginalValue] nvarchar(MAX) COLLATE Latin1_General_CI_AS NULL ,
[NewValue] nvarchar(MAX) COLLATE Latin1_General_CI_AS NULL ,
[StructDivisionId] uniqueidentifier NULL ,
CONSTRAINT [PK_AuditLog] PRIMARY KEY NONCLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_TableName] ON [dbo].[AuditLog]
([TableName] ASC) 
ON [PRIMARY]
GO

CREATE INDEX [IDX_EventType] ON [dbo].[AuditLog]
([EventType] ASC) 
ON [PRIMARY]
GO

CREATE INDEX [IDX_UserId] ON [dbo].[AuditLog]
([UserId] ASC) 
ON [PRIMARY]
GO

CREATE INDEX [IDX_StructDivisionId] ON [dbo].[AuditLog]
([StructDivisionId] ASC) 
ON [PRIMARY]
GO
------------------------------------

CREATE VIEW [dbo].[vSP_auditlog] AS 
select al.*, qs.UID, qs.Name as [SampleName], su.Name as [UserName], sc.Login as [LoginId], sd.Name as [Division] from AuditLog al
left join dwSecurityUser su on al.UserId = su.Id
left join dwSecurityCredential sc on sc.SecurityUserId = su.Id
left join QNN_SAMPLE qs on qs.Id = al.SampleId
left join StructDivision sd on al.StructDivisionId = sd.Id
GO
--------------
CREATE VIEW [dbo].[vSP_auditlog_EventType] AS 
select DISTINCT EventType as Id, EventType from AuditLog
GO
-------------------
CREATE VIEW [dbo].[vSP_auditlog_TableName] AS 
select DISTINCT TableName as Id, TableName from AuditLog where TableName is not null
GO
-------------------------
INSERT INTO [dbo].[dwAppSettings] ([Name], [Value], [GroupName], [ParamName], [Order], [EditorType], [IsHidden]) VALUES (N'AuditOn', N'True', N'Application settings', N'Enable Audit', '3', N'0', '0');
GO
--------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A', [Folder]=N'metadata/forms', [Filename]=N'sidemenu-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.490', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-29 12:27:26.143', [Data]=N'{
  "isSurvey": false,
  "lastUpdate": "2019-08-29T12:27:26.1431749+08:00",
  "isTemplate": false
}', [StructDivisionId]=NULL WHERE ([Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A');
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='55636648-E5A4-4002-9F59-D597FD167C04', [Folder]=N'metadata/forms', [Filename]=N'sidemenu.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.540', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-08-29 12:27:26.007', [Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "/form/SwzQnnList",
        "title": "Questionaires",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true",
        "children": [
          {
            "title": "Survey Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')==true"
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
          }
        ]
      },
      {
        "target": "/form/SwzListList",
        "title": "List",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/SwzDplyList",
        "title": "Deployment",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "title": "Data Editor",
        "target": "/form/DataEditorDeploymentList",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')==true"
      },
      {
        "title": "Category",
        "target": "/form/SwzCategoryList",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/organizations",
        "title": "Organizations",
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "title": "Respondent Content Management",
        "target": "/form/SwzRespAdminList",
        "children": [],
        "visibleCondition": "CloverApp.API.checkRole(''Admins'')==true"
      },
      {
        "target": "/useradmin",
        "title": "Security",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')==true"
      },
      {
        "target": "/form/audittrailer",
        "title": "Audit Trailer",
        "visibleCondition": "\t CloverApp.API.checkRole(''Admins'')==true"
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
    "other-visibleConition": ""
  }
]', [StructDivisionId]=NULL WHERE ([Id]='55636648-E5A4-4002-9F59-D597FD167C04');

GO
---------------------------------------------
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('F5168E8B-50FC-442B-AD6D-3E225324BD0E', N'metadata/forms', N'AuditLog.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-28 17:35:29.610', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-29 11:50:31.763', N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Log Item Details",
    "size": "medium"
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
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Back",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirect"
                ],
                "targets": [],
                "parameters": [
                  {
                    "value": "/form/audittrailer",
                    "name": "target"
                  }
                ]
              }
            },
            "secondary": true,
            "toggle": true,
            "floated": "right"
          },
          {
            "key": "Id",
            "data-buildertype": "input",
            "label": "Id",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Division",
            "data-buildertype": "input",
            "label": "Division",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "LoginId",
            "data-buildertype": "input",
            "label": "Login Id",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined",
            "events": {}
          },
          {
            "key": "UserName",
            "data-buildertype": "input",
            "label": "User Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined"
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "Sample UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined"
          },
          {
            "key": "SampleName",
            "data-buildertype": "input",
            "label": "Sample Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined"
          },
          {
            "key": "EventType",
            "data-buildertype": "input",
            "label": "EventType",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "TableName",
            "data-buildertype": "input",
            "label": "TableName",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "RecordId",
            "data-buildertype": "input",
            "label": "RecordId",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "ColumnName",
            "data-buildertype": "input",
            "label": "ColumnName",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "EventDate",
            "data-buildertype": "input",
            "label": "EventDate",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "OriginalValue",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "{OriginalValue}",
                    "fetchData": false,
                    "events": {},
                    "style-customcss": "custom-label",
                    "isHtml": false,
                    "isPre": true
                  }
                ]
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_3",
                    "data-buildertype": "staticcontent",
                    "content": "New Value",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "{NewValue}",
                "isHtml": false,
                "isPre": true
              }
            ]
          }
        ],
        "placeholders": {
          "customblock_1": []
        }
      }
    ]
  }
]', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('1787CCCB-BC84-4E3A-9731-C60A9664E377', N'metadata/forms', N'AuditLog-code.js', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-29 05:08:52.053', NULL, NULL, NULL, NULL, N'{
    init: function(args){
        return {
            app:{
                form: {
                    models: {
                        readOnly: true
                    }
                }
            }
        };    
    },
    
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('65D69BCF-B52E-4A1A-BC13-6B7E790652B0', N'metadata/forms', N'AuditLog-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-28 17:35:29.720', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-29 11:50:31.903', N'{
  "isSurvey": false,
  "name": "AuditLog",
  "lastUpdate": "2019-08-29T11:50:31.9019506+08:00",
  "entityId": "6607ad29-8548-42e8-a4b6-a4fb6acadb83",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "b90aff40-227a-cd9e-98df-62f76515f2f5",
      "attributeId": "37fdbd9c-a576-4a75-9a1e-1d17a3ea144d",
      "control": "ColumnName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "44699b72-5367-f219-a74e-e7a1e3b3faf6",
      "attributeId": "b19e8792-ec58-4dca-8cbd-db80a4aa28bc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f9de4f52-8bec-ed91-c7d1-533863090bbb",
      "attributeId": "c2e47810-dc84-41c1-be4e-0a72811ec4a1",
      "control": "EventDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4214217d-ab99-cda3-6f7e-2695a502506f",
      "attributeId": "c466b24c-b698-422e-afb1-acce464e3333",
      "control": "EventType",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6d6b83ea-1413-68f3-7583-b61e30a8d83f",
      "attributeId": "465508cc-71b4-46a5-a12b-616b12988122",
      "control": "Id",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e700e95-95d7-3d2e-89c2-65a96ecdc216",
      "attributeId": "99def6c9-0868-4477-affe-980d9dbfa05b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "67cbd6cd-c630-231f-1e0e-b0e116f9e761",
      "attributeId": "e9b4e29d-6780-4afc-9824-3237b24221ef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "806fe8e8-3872-b174-6d18-1fed636f49c6",
      "attributeId": "9f408c59-77ee-4bc3-b7f3-e9a0f64d54bb",
      "control": "RecordId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a24a4a6e-5f5b-753a-075a-691c5dbe27f3",
      "attributeId": "4b3af9b5-ff96-4c88-89dc-013d723988c8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4cfc2fe-0ffb-90dc-bc6c-93c3051d924d",
      "attributeId": "87852fbd-78fa-4cee-855f-8e57e8a3c52c",
      "control": "SampleName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e0a6d56-3752-f67d-4972-717f79894ee4",
      "attributeId": "ea84794d-0210-4455-80e4-fa22592e3a05",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3fce4430-f069-98fb-80e4-bb9dd822d356",
      "attributeId": "9e80ab7f-fd4d-44f5-9f00-5d769b21e703",
      "control": "TableName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d6bf335e-f40b-7815-4411-95f09f7bb96f",
      "attributeId": "df3ddea7-68b8-42d4-bc57-77d0ec125e9d",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4156d49f-0679-b9d0-b729-ee7b5327a635",
      "attributeId": "a3f11159-074e-407c-b74d-3efa2ef8861c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f9abe51-6571-5762-f120-1f708a3cff7d",
      "attributeId": "cbbbad29-c71e-49c5-a94e-3d6721fd5525",
      "control": "UserName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "95373c9d-07f3-96f1-c0f9-69ea2df411bd",
      "attributeId": "ad4872cc-3a53-4c02-9469-ae9fba7e383c",
      "control": "Division",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bc40786-e5a2-7b8b-81e1-f88401a54bfa",
      "attributeId": "5db248ab-b068-4a1e-bbc8-224c02299656",
      "control": "LoginId",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('4BEF2440-7B11-4D01-B795-09EE58ED0F65', N'metadata/forms', N'AuditTrailer.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-22 17:06:51.123', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-29 14:29:47.190', N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Trailer",
    "size": "medium",
    "subheader": ""
  },
  {
    "key": "staticcontent_1",
    "data-buildertype": "staticcontent",
    "content": "Filters you can use: Event Date (between Start and End filter), Table Name, Event Type, User Name or Sample Name"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
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
                  "gridview_1"
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
            }
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
                  "gridview_1"
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
                  "gridview_1"
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
                  "gridview_1"
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
        "key": "formgroup_3",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "input_3",
            "data-buildertype": "input",
            "label": "",
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
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "UserName, SampleName"
                  }
                ]
              }
            }
          }
        ]
      }
    ],
    "style-customcss": "ui message"
  },
  {
    "key": "gridview_1",
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
    "pageSize": "5",
    "defaultSort": "EventDate DESC",
    "pagerType": "server",
    "editForm": "AuditLog"
  }
]', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
INSERT INTO [dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('821D5319-793C-4B0E-AA09-6AF302B3A6FD', N'metadata/forms', N'AuditTrailer-settings.json', '0', '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-22 17:06:51.527', NULL, NULL, '540E514C-911F-4A03-AC90-C450C28838C5', '2019-08-29 14:32:02.720', N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrailer",
  "lastUpdate": "2019-08-29T14:32:02.691633+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "1897ec65-fe7e-402c-9974-72cb9342dc93",
      "filter": "StructDivisionFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "f526573f-a62b-95bf-346d-a06b92c76e12",
          "attributeId": "2e21e8b9-1e90-40d2-938d-fa726da87038",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a4b657e-689b-3949-6603-0e8f7ca9d932",
          "attributeId": "5869778c-89cd-45e3-a8c9-1747167f61ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dbb0c63c-0add-af05-d51c-6f1954b43e88",
          "attributeId": "6fdec3d4-8a48-43fb-9807-0d64a49aaa5a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c24d08c2-9e1d-c3a3-d382-3b500d7315db",
          "attributeId": "93c7731d-b893-4f18-937d-8673d9a3d9d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99f2df97-0581-8476-9500-196bac947e9f",
          "attributeId": "1b453bce-5bbd-4b45-b8f1-4c9afdb576a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "854e614d-e2d2-f068-0451-ca6d082526f4",
          "attributeId": "b33e2ad5-9c76-431c-b50a-e453b5d8aaa2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "de952a18-0e0f-d80f-79b2-1fbf553e9440",
          "attributeId": "4b11d200-6a61-49e1-858b-2982112da95b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd375f77-d340-3f74-9536-d0aacfe6723c",
          "attributeId": "da3da2f2-bd77-4e9a-8fba-c6d4483a9584",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "902168a9-f82f-101f-693c-404998ef8dc7",
          "attributeId": "af9dde32-9a6b-492c-92f3-60c83fb265a9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8d37cede-a164-5b87-aa5f-da6a6af47662",
          "attributeId": "8dad216f-5cc9-4016-ab61-3fe57901d512",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "806238de-71c0-4559-b966-2c3961a6c40a",
          "attributeId": "a9de8a50-ab77-4dec-91c4-de47a7830a36",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "194b747f-eeb2-5057-9d53-22b18c2d0926",
          "attributeId": "fbd8712c-47f7-4afb-8b12-c797387526fa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "caec513c-67e8-7961-fbbd-cae28b5edfd9",
          "attributeId": "bccbce8c-3484-4adf-a64f-f75d51d2bb4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a6f4e69e-1ace-66d5-d950-0978267890ab",
          "attributeId": "ecc77617-4bb7-4b61-9068-ce1b37f9613f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9f58858c-024e-e39b-38c2-2d5de0b26d34",
          "attributeId": "02ef86df-c080-48bf-b367-52a01206593f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "434e038b-7ae1-2cca-cd28-4e8f8998c155",
          "attributeId": "4ffa7632-4275-4f08-ac6b-8d8d19a8f481",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21d3c8e7-0014-f592-d1c0-7cf6e0718339",
          "attributeId": "056a5a07-7305-4c7b-ad84-6e83a5961e0d",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');


GO
---------------------------------------------------------------------------


   
	ALTER PROCEDURE [dbo].[spSP_AddDplySampleInfoByListId]
		@DplyId uniqueidentifier,
		@ListId uniqueidentifier,
		@userpass varchar(256),
		@Status uniqueidentifier = 'A3D01086-40FC-4A7A-BF0C-DE17BDD205FA',
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime

	AS
	BEGIN
		Create TABLE #Temp (Id uniqueidentifier)
		if(Exists(select top 1 1 from QNN_LIST_SAMPLE ls
		 WHERE ListId = @ListId 
		and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)
	))
			BEGIN		

				INSERT INTO QNN_DPLY_SAMPLE_INFO 
					(Id, DplyId, ListSampleId, Status, PdfPassword, CreatedDate)
				OUTPUT INSERTED.ID INTO #Temp(Id)
				SELECT NEWID(), @DplyId, Id, @Status, Upper(right(@DplyId, 12))+Lower(left(Id, 8)), GETDATE()
					FROM QNN_LIST_SAMPLE ls
				 WHERE ListId = @ListId 
				and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)

				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Insert', 'QNN_DPLY_SAMPLE_INFO', null, null, null, 
						(select * from QNN_DPLY_SAMPLE_INFO where Id IN( SELECT Id FROM #Temp) FOR JSON AUTO), @StructDivisionId;



			END


	END

GO
----------------------------------------------------

	ALTER PROCEDURE [dbo].[spSP_DeleteByTableNameAndIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime
	AS
	BEGIN
		DECLARE @query_all  AS NVARCHAR(MAX),
		 @dplyIds  AS NVARCHAR(MAX)
		SET NOCOUNT ON;

		if(UPPER(@TableName)='QNN_DPLY')
			BEGIN

				if(Exists(select top 1 1 from QNN_RESP where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))

					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
						where r.DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
						
						delete from qnn_resp where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
					END

 
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

				delete from QNN_DPLY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 
			END
		ELSE IF(UPPER(@TableName)='QNN_LIST')
		 BEGIN

				if(Exists(select top 1 1 from QNN_RESP r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						INSERT INTO AuditLog 
								(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
							SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r 
							inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id left join QNN_RESP_ANS ra on ra.RespId = r.Id 
							where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
		

						delete r from qnn_resp r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN

						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId
								
						delete from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END

				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST', null, null,(select * from QNN_LIST 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;



				delete from QNN_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

		 END
		ELSE IF(UPPER(@TableName)='QNN_QNN')
		 BEGIN
				if(Exists(select top 1 1 from QNN_RESP  where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN

						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
						where r.QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
						
						delete from qnn_resp where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
	
					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
		
						delete from QNN_DPLY where QnnId IN (select Item FROM dbo.splitIds(@Ids, ',')); 
					END

				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_QNN', null, null,(select * from QNN_QNN 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;


				delete from QNN_QNN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_CATEGORY')
		 BEGIN
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_CATEGORY', null, null,(select * from QNN_CATEGORY 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

				delete from QNN_CATEGORY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_RESP_ADMIN')
		 BEGIN
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP_ADMIN', null, null,(select * from QNN_RESP_ADMIN 
				where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

				delete from QNN_RESP_ADMIN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

	END
	
	GO
--------------------------------
	ALTER PROCEDURE [dbo].[spSP_DeleteSampleProp]
		@ListId uniqueidentifier,
		@ListSampleIds NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime

	AS
	BEGIN
		SET NOCOUNT ON;

		if(Exists(select top 1 1 from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ','))))

			BEGIN
				INSERT INTO AuditLog 
					(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
				SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST_SAMPLE_PROP', null, null,(select * from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')) FOR JSON AUTO), null, @StructDivisionId;
				
				delete from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')); 
			END

	END
	
	GO
------------------------------------