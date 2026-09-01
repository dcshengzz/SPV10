-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_QNN.json
-- QNN_QNN-settings.json

UPDATE [dwMetadata] SET
[Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.690', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-08-26 13:22:09.793', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Questionnaire",
    "size": "huge"
  },
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "View Args",
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "viewArgs"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "size": "",
    "primary": true,
    "style-hidden": true
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
            "key": "Title",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "other-customValidation": ""
          },
          {
            "key": "Alias",
            "data-buildertype": "input",
            "label": "Alias",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "CategoryId",
            "data-buildertype": "dictionary",
            "label": "Category",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_CATEGORY",
            "columns": "Name Asc",
            "filters": "[{\"column\":\"Type\", \"value\":\"Q\", \"term\":\"=\"}]"
          },
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "P",
                "text": "Offline"
              },
              {
                "key": 2,
                "value": "O",
                "text": "Online"
              }
            ]
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "children": [
              {
                "key": "collectioneditor_2",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Form Name",
                    "control": "custom"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "header": true,
                "other-visibleConition": "data.Type==''O''",
                "placeholders": {
                  "Name": [
                    {
                      "key": "Name",
                      "data-buildertype": "dictionary",
                      "label": "",
                      "fluid": true,
                      "selection": true,
                      "columns": "Name",
                      "dataModel": "vSP_SurveyForm",
                      "paging": true,
                      "search": true,
                      "style-customcss": "dictionary-no-label"
                    }
                  ]
                }
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "collectioneditor_1",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Name"
                  },
                  {
                    "key": "Token",
                    "name": "File",
                    "control": "file2"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "disableAdd": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "validate"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": true,
                "other-visibleConition": ""
              },
              {
                "key": "dropzonecontrol_1",
                "data-buildertype": "dropzonecontrol",
                "showFiletypeIcon": false,
                "autoProcessQueue": true,
                "addRemoveLinks": true,
                "multile": true,
                "events": {
                  "success": {
                    "active": true,
                    "actions": [
                      "createElement"
                    ],
                    "targets": [
                      "collectioneditor_1"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "other-visibleConition": "data.Type==''P''"
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-marginBottom": "",
            "style-marginTop": "20px",
            "other-visibleConition": "(data.Type==''O'' && (data.Id===undefined || data.Id===null || data.Id=='''')   )",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "(Excel survey files may be added after saving)"
              }
            ]
          },
          {
            "key": "container_qnn_qnn_file",
            "data-buildertype": "container",
            "children": [
              {
                "key": "collectioneditor_3",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Excel File Name"
                  },
                  {
                    "key": "Token",
                    "name": "File",
                    "control": "file2"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "disableAdd": true,
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [
                      "validate"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-visibleConition": ""
              },
              {
                "key": "dropzonecontrol_2",
                "data-buildertype": "dropzonecontrol",
                "showFiletypeIcon": true,
                "autoProcessQueue": true,
                "addRemoveLinks": true,
                "multile": true,
                "events": {
                  "success": {
                    "active": true,
                    "actions": [
                      "createElement"
                    ],
                    "targets": [
                      "collectioneditor_3"
                    ],
                    "parameters": []
                  }
                },
                "iconFiletypes": "*.xslx"
              }
            ],
            "other-visibleConition": "(data.Type==''O'' && data.Id)",
            "style-marginTop": "20px"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-float": "left",
            "events": {},
            "style-marginRight": "20px",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "customSave"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "value": "/form/SwzQnnList",
                        "name": "target"
                      }
                    ]
                  }
                },
                "inverted": false,
                "secondary": false,
                "primary": true
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
                        "value": "/form/SwzQnnList"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          }
        ],
        "style-marginBottom": ""
      }
    ],
    "style-marginBottom": "",
    "events": {}
  },
  {
    "key": "divModal",
    "data-buildertype": "container",
    "children": [
      {
        "key": "errorModal",
        "data-buildertype": "swzmodal",
        "content": "errorModal",
        "size": "",
        "style-display": "block",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "System Message",
                "size": "medium",
                "style-source": "font-family: Lato,''Helvetica Neue'',Arial,Helvetica,sans-serif;\npadding-bottom: 1.5rem;\ncolor: rgba(0,0,0,.85);\nborder-bottom: 1px solid rgba(34,36,38,.15);"
              },
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "{ErrorText}",
                "isHtml": false,
                "style-source": "word-wrap: normal;\nleft-margin: auto; right-margin: auto;",
                "style-width": "80%",
                "style-customcss": "content"
              },
             {
                "key": "container_6",
                "data-buildertype": "container",
                "style-source": "clear: both;\npadding: 20px;",
                "style-width": "100%",
                "children": [
                  {
                    "key": "btn_cancelErrorModal",
                    "data-buildertype": "button",
                    "content": "OK",
                    "secondary": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "cancelModal"
                        ],
                        "targets": [
                          "errorModal"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": true,
                    "floated": "right"
                  }
                ]
              }
            ],
            "style-source": "padding: 20px;"
          }
        ]
      }
    ],
    "style-hidden": true
  }
]' WHERE [Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374';

UPDATE [dwMetadata] SET
[Id]='27dbfadb-0e83-4acd-af28-35a760e3239b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-08-26 13:22:09.837', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2021-07-14T17:38:21.5272155+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnFieldsTrigger"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "InsertQnnPdfFieldsTrigger",
      "parameter": ""
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateOnlineFormTrigger"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy:\"@CurrentUserId\", UpdatedDate:\"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "InsertQnnOnlineFormFieldsTrigger"
    },
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnFilesTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "f5c72328-b907-7ee0-8b55-f4239c8da6e8",
      "attributeId": "c808a448-06a0-4c5f-869a-3eb2c0a6c903",
      "control": "Alias",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "721e7992-c058-fdec-99de-e4b2134e0071",
      "attributeId": "0d19ac69-83df-4a34-9dff-53382d296641",
      "control": "CategoryId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89b15150-fab8-f905-e931-1395a6cae270",
      "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfb7bec7-b589-607d-5129-a59dde6190ea",
      "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "581270f1-2e71-5a5c-a88d-f8da9064a71a",
      "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74a0dac6-9a11-ed4e-b5c6-96fae81edb84",
      "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b137d32-d9f7-7c6d-dc7a-aa8d413b53df",
      "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa94aeed-0ff2-42b7-de9a-a6c8509a2c66",
      "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cd2ee951-429c-9622-3e69-141f0741a5e6",
      "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d260ba0c-a6d5-b700-2354-c322a00c1814",
      "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e194959a-a340-9add-f232-c1617b48df7d",
      "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24dae954-e67e-a607-a3e4-f2bbbe492700",
      "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
      "control": "Title",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ac8dd062-9404-30ae-2a60-f64a0d2b5851",
      "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2497b2ba-fde1-921b-eb23-7bb1c90c9cbd",
      "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0f31090-e7d8-6df6-df4b-17911aafcbd6",
      "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c8c1d3f-e294-9402-162b-ae1fc8eaf98e",
      "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a618b97-0e2c-8433-f49c-5ba34a9f6132",
      "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "a8f082fb-3708-b830-f8fc-c2d05863d63f",
      "entityId": "c20a37ac-e637-4eae-9ca5-274455d6b83d",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "be17b8b1-39ea-601c-0ae2-cd7a444c450b",
          "attributeId": "d41c0520-6ec8-4b9d-b5da-7d9f280353d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a23b7dbe-c559-b9de-9bdd-3fd2bab20a80",
          "attributeId": "632f1468-a0e6-4fcb-84a9-fa2c68b2b21f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19312a46-c3e9-34da-e26f-8b97d24f242b",
          "attributeId": "6b26300b-3db8-436f-a603-32f6f37c3cbc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf0498b1-893d-8a33-5103-4b51f8771ea2",
          "attributeId": "42f766b8-e59a-430d-aef0-e4d3f4e98d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "320d9b6b-4811-0e7a-11ab-2ec13580248d",
          "attributeId": "c548f205-edc0-4259-b840-c2035fad11cf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5344120d-e405-c4bb-48f0-e142c1b9eb2f",
          "attributeId": "c21bc428-4ab6-4155-9864-1523bdddb6b8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e8dc2fa-0fa2-2aed-ceca-92e58f8b583c",
          "attributeId": "11b29a33-078c-45a5-b0d4-73300202cde6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf6268bf-f749-89f2-4d12-f5eacac66643",
          "attributeId": "4d74d725-aa3f-4485-ba71-12bc00593f8e",
          "control": "Language",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8da170d-e0c7-15fc-ffda-4321e4405020",
          "attributeId": "705bedd0-90b0-4159-b2dc-2e5b167c85a1",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4a3d26a7-37b7-8355-6236-acb68ad46522",
          "attributeId": "1c0b2633-2d27-4a7a-800a-ddfd8d6530b9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "91408784-eb59-c367-eb88-2d3c63169edb",
          "attributeId": "bbba0639-2151-47d2-beb3-4af1bfc14681",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb39ebd7-e29d-0761-4e56-678a290bb752",
          "attributeId": "193f1d40-696d-489c-a981-38e1d235d5b2",
          "control": "Remarks",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14cab041-bda5-662e-630d-198f729b087b",
          "attributeId": "be25d4ad-96b4-4da2-b52f-9182b24cd0ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e3d18078-ae2f-4750-342a-773f10938b29",
          "attributeId": "4d673305-fe74-4b52-8886-5dead4f6f0a4",
          "control": "Token",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "61ba136c-2b89-0826-3af4-6bb8e204f8d4",
          "attributeId": "16445fab-034f-4f31-9571-e8d61363ae12",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "706d7b43-218b-f0a5-de19-4aa527bf13cc",
          "attributeId": "fcc4b9e5-b553-4d34-a673-3d174f6e7de9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "ce55df4c-3912-415b-d8f9-6858832481f8",
      "entityId": "727fe2b1-f979-49c5-b92d-c5e70c1a4110",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_2",
      "dataMap": [
        {
          "id": "b4f98c07-3eb7-4254-dc33-546a56ca63ac",
          "attributeId": "674343a1-e1a6-4d98-9e2d-a814ebf1742b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3048e0ad-79e1-3424-6c5b-31c8e7844626",
          "attributeId": "d7c53c38-8d62-431d-8ab7-73a25f6b58bb",
          "control": "Language",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86062545-a96f-5ff7-28d8-d342b8af08ce",
          "attributeId": "6a636ac4-263e-41a7-b6cd-23640c3f286e",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5774b7e-dfc2-5063-fafb-602fab6d71bb",
          "attributeId": "aafe438d-5468-4c99-a125-f23f8a0ea082",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1991fe4a-50db-50f1-3bcd-b2df702e17ae",
          "attributeId": "35a15d67-9f99-4d1a-9a73-7ab396344071",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9dfb9655-3bc3-f6e9-f0cd-640b5ccc3107",
          "attributeId": "8e81d88b-b5fe-4f3d-863f-8308bd3d9448",
          "control": "Remarks",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "b7ce1da8-ae40-e1fc-55d2-df280efd08a2",
      "entityId": "95a49c95-bd21-41ee-8a53-c1f96ca5d927",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_3",
      "dataMap": [
        {
          "id": "852590b9-843e-dab0-910e-ab0c75f435a7",
          "attributeId": "2e8d9106-1308-4399-a561-a34cd12de0c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3287ffd8-7f38-a3da-c04d-232ca9c5da01",
          "attributeId": "b7275b5e-c4b4-4296-966d-91216131561f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d8d404cf-819c-e856-3cee-58a956982862",
          "attributeId": "e34c36c7-e5e7-4212-8feb-380d7feb5d48",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "592af51c-57f8-d328-4a0b-40eae472aff9",
          "attributeId": "6d833d65-ad3f-4d20-a64d-60e913572f0e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6182e72e-b921-ee6d-f4a4-b80bc7dfb5fa",
          "attributeId": "54a852ab-6ef1-4b5e-9780-c4cf2a8339af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae5d7a7d-b38f-d9c8-6e81-88aa759f07d4",
          "attributeId": "a895859f-8c06-4515-9803-ce31821119a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1ae290f-bd5c-5387-cf44-70eec5ea51a0",
          "attributeId": "f65f5cda-7d7e-403f-b7c9-84837c48cd0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b139332-1d81-cc9f-a0bd-23d7d65277c8",
          "attributeId": "debe95cb-f26f-44f5-b9f0-268dd244468b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfa16bb3-4e81-ff85-c4f6-fe864926638b",
          "attributeId": "fb81a1fb-fa8a-4264-ab16-3c30cd9c3927",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a3d05474-440a-188e-8d39-3142e5a4fba0",
          "attributeId": "3085136b-f4ce-4790-8dea-bb2fee94de7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eeb8673f-cff7-6087-38ba-35a47bd7c740",
          "attributeId": "7565471d-898d-4f6b-83b8-70fa86343d4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "389ba6ae-a81e-155d-f797-bb8a5fb898eb",
          "attributeId": "b68d3ba2-f9c8-4697-8c0f-a71d8868f86a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2df7de33-37a9-6065-3592-00e830c7f31b",
          "attributeId": "9d07044c-e991-4f1a-816b-a5a2f879bf62",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "771d41fa-33b0-4745-8fc7-e9a9d60207b4",
          "attributeId": "48441dc8-4895-4df4-8f48-7358ad18cd97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a28f9da0-e40c-3531-e96d-8883e5ec8cd5",
          "attributeId": "fa07f472-dc63-4b47-b611-7bad7624387a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e46c4f1e-95d2-533e-8550-a77543efdef8",
          "attributeId": "51684962-8fa3-4964-bc2a-bc8fd2128baf",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Questionnaire"
}' WHERE [Id]='27dbfadb-0e83-4acd-af28-35a760e3239b';

