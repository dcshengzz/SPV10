-- Feature: To include from email address field for deployment email sending
-- Implement guide:
-- run this script after Change41.sql (qnn_dply form being modified after change41.sql)
-- restart site after execute sql


------------------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.340', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 12:49:36.810', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2020-02-19T12:49:36.8063791+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c843062-e9a5-a4c5-8217-f183ce69c6e4",
      "attributeId": "2ed5084d-49c5-4111-9412-10b8930a9b2e",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}', [StructDivisionId]=NULL WHERE ([Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD');

GO
----------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='655275CF-8202-4438-B66B-874EAB315889', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.393', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 12:49:36.253', [Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left"
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float: right;",
            "secondary": true,
            "content": "Import Response",
            "style-display": "none",
            "children": [
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "header_3",
                    "data-buildertype": "header",
                    "content": "Import Response",
                    "size": "medium",
                    "events": {},
                    "other-visibleConition": ""
                  },
                  {
                    "key": "listFile",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "file",
                    "style-marginTop": "10px"
                  },
                  {
                    "key": "totalRows",
                    "data-buildertype": "header",
                    "content": "Total rows: {totalRows}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                  },
                  {
                    "key": "totalSampleResponseAdded",
                    "data-buildertype": "header",
                    "content": "Rows added: {totalSampleResponseAdded}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                  },
                  {
                    "key": "totalSampleNoResponse",
                    "data-buildertype": "header",
                    "content": "Rows not added (No response): {totalSampleNoResponse}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidUIDs",
                    "data-buildertype": "header",
                    "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidQnnColumns",
                    "data-buildertype": "header",
                    "content": "Total invalid columns: {totalInvalidQnnColumns}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                  },
                  {
                    "key": "moreModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "",
                    "secondary": true,
                    "content": "More information",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_2",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "container_13",
                                "data-buildertype": "container",
                                "style-float": "right",
                                "children": [
                                  {
                                    "key": "invalidQnnColumns",
                                    "data-buildertype": "header",
                                    "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_1",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidColumns"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "invalidUIDs",
                                    "data-buildertype": "header",
                                    "content": "Invalid rows (UID): {totalInvalidRows}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_2",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidUIDs"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "totalInvalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                    "style-hidden": true
                                  },
                                  {
                                    "key": "invalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_3",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidDates"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "button_1",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
                                    "style-customcss": "",
                                    "primary": false,
                                    "events-onClick": true,
                                    "events-onClick-actions": [
                                      "gridAdd"
                                    ],
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeMoreModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "",
                                    "style-source": "float: right;",
                                    "inverted": false,
                                    "secondary": true
                                  }
                                ],
                                "style-marginRight": "",
                                "style-width": "100%",
                                "style-marginBottom": "",
                                "style-source": ""
                              }
                            ],
                            "style-source": "overflow-y: auto;\noverflow-x: auto;"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": "",
                    "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                  },
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "right",
                    "children": [
                      {
                        "key": "btnImportCancel",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "style-customcss": "",
                        "primary": false,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;",
                        "inverted": false,
                        "secondary": true
                      },
                      {
                        "key": "btnImportSave",
                        "data-buildertype": "button",
                        "content": "Save",
                        "style-customcss": "",
                        "primary": true,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "submitFile"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;"
                      }
                    ],
                    "style-marginRight": "",
                    "style-width": "100%",
                    "style-marginBottom": "10px"
                  }
                ],
                "style-source": "overflow-y: auto;\noverflow-x: auto;"
              }
            ],
            "size": "",
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-visibleConition": "data.Id!=null",
            "style-marginLeft": ""
          }
        ],
        "style-float": "right",
        "style-marginLeft": ""
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageMessageHistory",
            "data-buildertype": "button",
            "content": "Manage Message History",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
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
                    "value": "dplyMessages"
                  }
                ]
              }
            },
            "floated": "right"
          },
          {
            "key": "buttonManageListSamples",
            "data-buildertype": "button",
            "content": "Manage List Samples",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
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
                    "value": "dplyListSample"
                  }
                ]
              }
            },
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-marginLeft": "",
        "style-marginRight": "3.5px"
      },
      {
        "key": "container_12",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageDataEditors",
            "data-buildertype": "button",
            "content": "Manage Data Editors",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplySampleOwner"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "floated": "right"
          },
          {
            "key": "buttonManageImputation",
            "data-buildertype": "button",
            "content": "Manage Imputation",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyImputation"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''Imputation'')",
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-width": "100%",
        "style-marginTop": "15px"
      }
    ],
    "style-width": "100%",
    "style-float": "right"
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
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {}
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "VisibleToRespondent",
                "data-buildertype": "checkbox",
                "label": "Visible to Respondent",
                "defaultValue": "True",
                "toggle": true
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": true
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": "",
                "other-required": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ]
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_14",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_16",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "30px",
    "style-marginBottom": "30px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
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
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='655275CF-8202-4438-B66B-874EAB315889');
Go
---------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.370', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 12:32:58.363', [Data]=N'{
    
    addNewSample: function(args){
        
        var dplyId = args.data.Id;
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''listId'', listId);        
        var url = ''/deployment/addnewsample'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    //console.log(''addNewSample args:'', args);
                    alertify.success(response.message);
                    args.controlRef.refresh();
                    

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });
            

    },
    manageDueDate: function(args){
        
        //console.log("manageDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
            
        }
        
    },
    changeDueDate: function(args){
        
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_1.close();
             alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_1.props.swzData.isOpen = true;
        }
        var dplyId = args.data.Id;
        var dueDate = args.data.dueDate;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''dueDate'', dueDate);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/changeDueDate'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_1.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });        
        
        
    },    
    goBack: function(args) {
        args.state.router.history.goBack();
    },
    manageResend: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
            args.component.refs.swzmodal_2.close();
            alertify.error("Please select at least one list sample");
            
        }
        else{
            args.component.refs.swzmodal_2.props.swzData.isOpen = true;
        }
        
    },
    reSend: function(args){
        //console.log("resend args", args);
        var dplyId = args.data.Id;
        var mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        var email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        var emailFrom = (email)? args.data.emailFrom : "";        
        var profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;        
        if(!mailMerge && !email && !profile){
            alertify.error("Check at least one");
            return {};
        }
        
        var msgContent = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
        }
        var subject = args.data.subject;
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Please input email subject");
            return {};            
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Please input messange content.");
            return {};            
        }
                
        
        
        //var formName = args.data.formName;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].ListSampleId;
            listSampleIds.push(listSampleId);
        }
        
        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        //formData.append(''formName'', formName);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);           
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/deployment/resend'';

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            });   
        
    },
    
    sampleResetPassword: function(args){
        
        if (args.controlRef.state.selectedIndexes.length < 1){
            alertify.error("Please select at least one list sample");
            return
        }
        console.log("Sample reset password!", args);
        var sampleIds = [];
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var sampleId = args.controlRef.state.items[gridIndex].SampleId;
            sampleIds.push(sampleId);
        }
        CloverApp.API.setDataField("loading", "");
        //CloverApp.API.setDataField("loading", "Loading...");
        var formData = new FormData();
        formData.append(''sampleIds'', sampleIds);        
        var url = ''/deployment/resetresppassword'';
        alertify.success("Loading...");
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success(response.message);
                    //CloverApp.API.setDataField("loading", response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
                //CloverApp.API.setDataField("loading", error.message);
            });   
        
    },
    showModal: function(args){
        args.component.refs.swzmodal_2.props.swzData.isOpen = true;
    }
        
    

}', [StructDivisionId]=NULL WHERE ([Id]='6122CF0B-786E-4824-9DB3-81870FEAD8A8');
Go
---------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='C1C3D084-F194-4719-B7AE-0B62F14F67E8', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.413', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 12:23:19.913', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyListSample",
  "lastUpdate": "2020-02-19T12:23:19.8997008+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "bc832ee5-3bd0-ebf6-3bf8-25ff0947ac8e",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a54be7e1-6121-4fe3-fabf-c0fd241bd88c",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8eece4fd-92b9-89cb-9ce5-b033fdb22e6e",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bd8efd2f-4fe7-e6ba-c68e-e09f951af003",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4efb6b7b-e2e7-cc3e-f3cf-24818308da18",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c5261b6c-0d65-53ec-13dd-e702ae734de2",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d31d80a-df37-5b85-bc80-70ce9188cb3a",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "848759d7-3c89-24e3-0376-87e075558973",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ae2fc8-d42b-68e0-e6fa-b5e75987ce3d",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a362a32-828a-0533-ec29-7c6ed2a15bc2",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c96969eb-0e90-27cf-ad4b-d81280319f35",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a292613-dd96-6200-8334-203d03b8dffd",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7e8e478-f1c2-f4f4-28ca-2aa868227e0e",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0afffdd2-98bc-b873-8fa7-1ac09711910e",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe20c92c-2272-cc47-b5c1-51bd07abe8cd",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b36376b8-bcd1-c703-feb9-93a2d1908859",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9ccf729f-2efd-8a11-9778-4042a4595b35",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e22b6e0f-7d71-53d5-7f38-3a338cd21939",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30122a30-2be2-34cc-62cf-edca9bc1f279",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7100e5fd-43b6-6f9b-08a4-9ec7a1c6fb1f",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a6b55cd-7b7f-1cef-f45b-7a65c6438e18",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7e882006-8c36-251c-c1f4-779501f5e200",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a7b7fed-328e-f039-94dd-3e55531421fe",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90a595c6-b385-22f0-e282-5335681d05a4",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3d9cd8bc-8f6b-6ae1-0011-938ef017356e",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "db0ad778-8c4e-102a-ee96-fd07b7962bec",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f2c73be5-9335-fdac-6c2d-3aefd3f5c330",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "9c4efb38-5907-162e-3fea-df643d5420cc",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "9978fddc-eec3-9093-b0c8-5e3aca535b6e",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cc4f8d6e-aa8f-5022-be5e-fd884eb06a60",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "373aecb8-8d7d-3c8e-456b-2a66209b141a",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5a5722a5-a1b5-158a-1ae1-5ae945291aa7",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "029fbf4c-87a1-7a87-08a5-91ddbe384c50",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "49497f8f-99f7-77b5-4b77-ace3a1ce3846",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "75a570bd-0915-5eb2-5b22-8ece6cf5f7bf",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd5640b8-4db0-3f65-cc38-5ad3b40539e3",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b91a407d-7e52-c2f1-e639-444cf18166c5",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d83e259f-c5f6-511a-22b5-f941b7170fd3",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d917943a-118c-c411-5c32-cde2e20ea902",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f0a041e9-c9b9-7264-d4b9-951950f6befa",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "886f408a-a7bd-e0f1-0404-2f7e94503365",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b771d4be-9aab-5b84-2c43-e4a95a3877c9",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f1e4821a-06a4-188f-05b5-6ecb9cdb7310",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41fe8bba-6b0e-882d-946b-6055a92a0ef6",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da8cde09-24c4-a61f-b4ba-f9eb40b7461a",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6db86a5-399d-f074-aa08-df497d17c6cf",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0d11670f-0e66-6a63-786f-97d9601c86db",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "720a8aab-26dc-4fb1-a690-3008617b7107",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac20f89c-b63e-32bc-2d3f-1a7deb58e78f",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fcd415ed-1da7-1e97-3094-ed1a5e28f9b3",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb0bf43-fd73-a672-14ce-fdfccaaaadf4",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "808b68c5-48c0-2e06-3e46-a2423bf3c6d5",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e34d7a9-61b5-418a-14f2-8e4c2ab6175b",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e05861e-51e7-54ef-6d95-0193fc383391",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb4fec13-5a4c-9687-5b3c-a58dfc28cc05",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72f8e5d7-8712-69eb-c424-a1b656464b15",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "264b48ef-2b6c-562f-a6e6-e3e5391d5975",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9ada3a1-679e-d102-dff3-ec944c9102d5",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e520499-6e1c-2fdd-666a-47ade51dedc5",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06f1fdb9-5c93-bb44-cb12-448ddc83975a",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b284dc1-a531-4c00-9a35-562eddc83e53",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76ff75aa-45e9-9584-7c32-da9189fdca51",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "768325b2-72f3-f307-e9a8-7045a7467674",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "50c4cfdb-6219-7209-572d-0a9194e49f34",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f11e3ca-4ae3-c4ff-83c1-13f249b82a1c",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "adb774b7-ea70-9bd6-9af2-204f70b8a73c",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d54b68b-2f0f-c53d-4986-dada95bdb84c",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d11621a0-a83c-7df6-5d13-c564361ed8ef",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f619c28-e828-a07e-93cf-d14e6a6868d6",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6ca07f9-a6c6-cc1b-bc18-b59fd267f1c9",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c34f9b3-3e27-6368-900e-3bef8753ae5c",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45d25e9d-3ccf-c473-1437-2b1fada7bbd4",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff134cf-9917-97bf-e7ad-f5a3b823576a",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8637245-6ed0-edd5-233d-c08df9e21e17",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f9e2961e-38d5-8db5-9b42-0625827b6f1c",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3414e56a-dab8-327f-3d91-db490d28b820",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d387ad1-9415-6968-ad98-5b9c0dc9da8f",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]=NULL WHERE ([Id]='C1C3D084-F194-4719-B7AE-0B62F14F67E8');

----------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='4CCDC858-527D-4321-8BEE-942751FEB26E', [Folder]=N'metadata/forms', [Filename]=N'dplyListSample.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:19.457', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-19 12:23:19.077', [Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage list of samples specific to this deployment"
          }
        ],
        "style-float": "left"
      },
      {
        "key": "container_10",
        "data-buildertype": "container",
        "children": [],
        "style-float": "right"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "txtFilter",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
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
                    "value": "StatusTitle, UIDName"
                  },
                  {
                    "name": "fieldName",
                    "value": "txtResend"
                  }
                ]
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-readOnlyConition": "",
            "placeholder": "Filter UID and Status",
            "labelPosition": "",
            "style-marginBottom": ""
          },
          {
            "key": "container_6",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_1",
                "data-buildertype": "input",
                "label": "Filter Due Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              },
              {
                "key": "input_5",
                "data-buildertype": "input",
                "label": "Filter Due Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "DueDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          },
          {
            "key": "swzmodal_1",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "dueDate",
                    "data-buildertype": "input",
                    "label": "Due Date",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": true,
                    "inverted": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "changeDueDate"
                        ],
                        "targets": [
                          "gridview_1"
                        ],
                        "parameters": []
                      }
                    },
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Manage Due Date",
            "secondary": true,
            "inverted": true,
            "style-customcss": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageDueDate"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            }
          }
        ],
        "events": {},
        "style-marginTop": "20px",
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-customcss": "ui message"
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "txtFilter",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter",
                  "clearField"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "StatusTitle, UIDName"
                  },
                  {
                    "value": "txtDueDate",
                    "name": "fieldName"
                  }
                ]
              },
              "onClick": {
                "active": false,
                "actions": [
                  "clearField"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "fieldName",
                    "value": "txtDueDate"
                  }
                ]
              }
            },
            "placeholder": "Filter UID and Status",
            "other-readOnlyConition": ""
          },
          {
            "key": "container_7",
            "data-buildertype": "container",
            "children": [
              {
                "key": "input_2",
                "data-buildertype": "input",
                "label": "Filter Generated Date  >=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              },
              {
                "key": "input_3",
                "data-buildertype": "input",
                "label": "Filter Generated Date  <=",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
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
                        "value": "CreatedDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                },
                "placeholder": "",
                "style-marginBottom": "20px",
                "style-marginTop": "20px"
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          },
          {
            "key": "btnResetPassword",
            "data-buildertype": "button",
            "content": "Reset Password",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "sampleResetPassword"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "primary": true,
            "style-marginTop": "",
            "style-source": "float:left;\n",
            "style-marginBottom": "",
            "style-marginLeft": "",
            "style-marginRight": "10px",
            "floated": "left"
          },
          {
            "key": "swzmodal_2",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_11",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "style-float": "left",
                    "children": [
                      {
                        "key": "cbMailMerge",
                        "data-buildertype": "checkbox",
                        "label": "Mail Merge",
                        "toggle": true,
                        "slider": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbEmail",
                        "data-buildertype": "checkbox",
                        "label": "Email",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginRight": "20px"
                      },
                      {
                        "key": "cbProfile",
                        "data-buildertype": "checkbox",
                        "label": "Generate Profile",
                        "slider": true,
                        "toggle": true,
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [
                              "showModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-customcss": "",
                    "style-source": ""
                  },
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;"
                  },
                  {
                    "key": "container_13",
                    "data-buildertype": "container",
                    "style-customcss": "",
                    "children": [
                      {
                        "key": "emailFrom",
                        "data-buildertype": "input",
                        "label": "From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "subject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "data.cbEmail",
                        "style-marginBottom": "20px"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": false,
                        "actions": [
                          "showModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail"
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": true,
                        "inverted": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "reSend"
                            ],
                            "targets": [
                              "gridview_1"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Send Message",
            "secondary": true,
            "inverted": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "manageResend"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "style-customcss": "",
            "style-source": ""
          }
        ],
        "style-marginBottom": "20px",
        "style-float": "left",
        "style-marginTop": "20px",
        "style-marginLeft": "20px",
        "style-customcss": "ui message"
      }
    ],
    "style-source": "clear: both;"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UIDName",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "PeerName",
        "name": "Peer UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response End",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "CreatedDate",
        "name": "Generated On",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pagerType": "server",
    "defaultSort": "UIDName ASC",
    "multiselect": true,
    "rowHeight": "80",
    "pageSize": "80"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Add New List Sample",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "addNewSample",
              "gridRefresh"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "addSampleConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "addSampleConfirmText"
              }
            ]
          }
        },
        "primary": true
      },
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Manage Message History",
        "secondary": true,
        "inverted": false,
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
                "value": "dplyMessages"
              }
            ]
          }
        },
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Back",
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
        "secondary": true
      }
    ]
  }
]', [StructDivisionId]=NULL WHERE ([Id]='4CCDC858-527D-4321-8BEE-942751FEB26E');
GO