-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_QNN.json
-- QNN_QNN-settings.json

UPDATE [dwMetadata] SET
[Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.690', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-23 14:01:00.080', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Form Properties",
    "size": "huge",
    "subheader": "(Questionnaire)"
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
            "key": "Warning_Type_P",
            "data-buildertype": "message",
            "header": "WARNING: Unsupported Form Properties Type",
            "content": "This Form Properties uses the deprecated ''P'' type for Offline PDF Surveys. \nSupport for this feature has been removed. ",
            "warning": false,
            "error": false,
            "other-visibleConition": "(data.Type===''P'')",
            "size": ""
          },
          {
            "key": "Type",
            "data-buildertype": "input",
            "label": "Type",
            "fluid": true,
            "onChangeTimeout": 200,
            "style-width": "50px",
            "readOnly": true,
            "other-visibleConition": "(data.Type !== ''O'')"
          },
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
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "congtainer_qnn_qnn_form",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Online Forms:",
                "size": "tiny"
              },
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
                "other-visibleConition": "",
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
                  ],
                  "NoLanguageMsg": [
                    {
                      "key": "NoLanguageMsg",
                      "data-buildertype": "message",
                      "header": "",
                      "content": "No link will be generated as there is no language specified",
                      "negative": false,
                      "warning": false,
                      "error": false,
                      "size": "mini",
                      "events": {},
                      "other-visibleConition": "data.Language ==null"
                    }
                  ]
                },
                "events": {}
              },
              {
                "key": "Warning_nolanguage_form",
                "data-buildertype": "message",
                "header": "WARNING: Language is not specified",
                "content": "No link will be generated for those not language specified in online form.",
                "other-visibleConition": "!data.collectioneditor_2.every(function(e) { return e.Language != \"\" }) || !data.collectioneditor_2.every(function(e) { return e.Language != null })",
                "events": {},
                "negative": true,
                "compact": true,
                "floating": false
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "other-visibleConition": "(data.Type==''O'')"
          },
          {
            "key": "Excel_Files_After_Save_Message",
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
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Downloadable Excel Files:",
                "size": "tiny",
                "subheader": "(Used in Excel-enabled Online Surveys)"
              },
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
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  },
                  "onAdd": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-visibleConition": ""
              },
              {
                "key": "Warning_nolanguage_file",
                "data-buildertype": "message",
                "header": "WARNING: Language is not specified",
                "content": "No link will be generated for those not language specified in excel file.",
                "other-visibleConition": "!data.collectioneditor_3.every(function(e) { return e.Language != \"\" }) || !data.collectioneditor_3.every(function(e) { return e.Language != null })",
                "info": false,
                "warning": false,
                "positive": false,
                "floating": false,
                "error": false,
                "compact": true,
                "negative": true,
                "success": false,
                "events": {},
                "other-customValidation-soft": false,
                "other-required": true
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
                      "createElement",
                      "showLangWarning"
                    ],
                    "targets": [
                      "collectioneditor_3"
                    ],
                    "parameters": []
                  }
                },
                "iconFiletypes": "*.xslx",
                "customPostUrl": ""
              }
            ],
            "other-visibleConition": "(data.Type==''O'' && data.Id)",
            "style-marginTop": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
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
                "primary": true,
                "other-visibleConition": "(data.Type !== ''P'')",
                "style-marginRight": "20px"
              },
              {
                "key": "btnConvertToOnlineForm",
                "data-buildertype": "button",
                "content": "Convert to Online Form",
                "events": {
                  "onClick": {
                    "actions": [
                      "convertToOnlineForm"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "inverted": false,
                "secondary": true,
                "primary": false,
                "other-visibleConition": "(data.Type === ''P'')",
                "style-marginRight": "20px"
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
      },
      {
        "key": "cntVisuallyDivideFormAndList",
        "data-buildertype": "container",
        "style-source": "clear: both;\ntext-align: center;",
        "style-marginBottom": "20px",
        "children": [
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<hr />",
            "isHtml": true
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_5",
            "data-buildertype": "header",
            "content": "Deployments using this Form Properties",
            "size": "small"
          },
          {
            "key": "gridDeployments",
            "data-buildertype": "gridview",
            "columns": [
              {
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "key": "Name",
                "name": "Deployment"
              },
              {
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "key": "SurveyName",
                "name": "Survey"
              },
              {
                "key": "CategoryName",
                "name": "Category",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "CreatedDate",
                "name": "Created",
                "resizable": true,
                "type": "datetime",
                "sortable": true,
                "filterable": false
              },
              {
                "key": "DateStart",
                "name": "Start",
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              },
              {
                "key": "DateEnd",
                "name": "End",
                "type": "datetime",
                "resizable": true,
                "sortable": true,
                "filterable": false
              }
            ],
            "rowKey": "Id",
            "pageSize": "50",
            "defaultSort": "Name ASC",
            "rowHeight": "80",
            "editFormShowType": "",
            "editForm": "QNN_DPLY",
            "events": {
              "onRowClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              },
              "onRowDblClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ],
        "style-source": "padding: 10px;\nclear: both;",
        "style-marginTop": "20px",
        "other-visibleConition": "(data.Id  && CloverApp.API.checkRole(''SurveyAdmin'') ) ? true : false",
        "style-customcss": "",
        "events": {}
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-23 14:01:00.220', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2021-12-23T14:01:00.1992044+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
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
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\", \"Type\": \"O\"}"
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
    },
    {
      "id": "70a597e0-2a98-67c3-58e7-c93905178502",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "gridDeployments",
      "dataMap": [
        {
          "id": "0fc26a7b-0c60-975d-04b1-69c3583119e6",
          "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "71e67030-9095-c850-2691-b010862e9067",
          "attributeId": "69d19937-002d-45b7-b86f-73f63e918fd8",
          "control": "CategoryName",
          "parentId": "0fc26a7b-0c60-975d-04b1-69c3583119e6",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "f94e1f28-9edd-3723-5420-3fad8d0757ff",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fa5bc6a4-d3ba-e4c5-cfeb-8eb498c6c89a",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "59c80845-b598-c4f1-e872-3217a14a4694",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1bddbab9-501c-cf15-f06d-ff2388220c85",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d8e3393-f577-1216-0663-8107dd32e933",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76938a99-3554-6185-83de-e0f3c2e9c456",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a07cefc8-e148-f2f6-ecc0-8a4e70633ef2",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a417dfbb-525c-e217-b478-897761e735af",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2537ffd2-371c-0ec3-090f-6936c1c1b720",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c6201e1e-f836-76f5-7197-50c911d301de",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ccc85c1b-e319-1af1-c225-992ee107a8e8",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "31c3fb47-3fb4-5994-e58a-6693b21b6d1d",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b77751e-0e66-8432-e1a4-2b99d3024bfe",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5d07b717-67ee-8a9a-bf2a-f90728fba4b7",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "9cae761d-d751-e2b0-6e86-2abf4eac8802",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "94de1ac0-ca93-95b0-52e9-42809d3bc279",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8f1727b5-ed2b-db71-31b2-8669d957c354",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3bae1a86-f38b-fff5-0c61-43183c25420e",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4aadcdf5-aeba-1a77-ecee-71aa28f0c895",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "31e61707-017b-e415-7011-68ac9376a5a4",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "872d8a3a-3719-2d0d-bcae-7fd3123e3a27",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d529500f-091f-7423-89b8-fa023dba022f",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4b85193f-0da8-0aee-dada-e77b4839f2ff",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e899d008-4184-a452-27f7-505f80d33e2b",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "715df851-974a-19af-6e97-65377fee7a0e",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a7070ce1-d4a7-2ca9-494e-f3df528f574e",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3200d237-795f-cc78-8a0b-1b1141a49a8f",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52a7e1bf-a22c-8988-359f-40cf5d7edc51",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8292c82d-bbec-8231-6075-6929a09aec4f",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "613b8244-8d92-c31a-1d55-c8a1c893f2ec",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d1e93282-d39b-f79d-b664-72ee4d6c333a",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fb4dd01f-6c7a-1cf8-b0a7-40091bd30db8",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "07d24d12-fe84-fbdb-828a-1c8a667b95b1",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "222a905f-60ab-d52d-b210-8bf2d8098611",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4f3383b1-c35b-e208-7b1c-4d853f808372",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "53791dff-cdb3-2a45-b02b-429e4d90cc43",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "53275c6e-f870-2daf-c1d3-ed123a03b6d4",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e645755b-29f5-d117-263d-087f8699a20f",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "887e611a-456e-ab03-76ee-74bf4b6828c4",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "bc4977c9-a175-a3fb-6431-f065b54b4f5b",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c8a31e73-7d79-5a8a-1d37-50fbddd8770b",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "61f79adc-c491-37c3-9eb8-6d2b1088c999",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "09524c23-4759-c60c-585f-41d2b032c618",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b6733898-921b-d8bc-c8fd-9afa42238f89",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4907d9c9-6aaa-f793-0f23-3ffbe9d71e86",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5d11bf80-11dc-5e82-8134-d4dd3e987fd5",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0fe79b84-1ed0-22e2-b4f3-2864821697db",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "479f4c36-752d-eede-de4e-ed8737e2d253",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c88fad57-ece2-e97c-4031-43a446ca7d05",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "202d264c-d444-7bbf-4f44-4da50653ef99",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d24e4f2c-3341-4761-1d56-0be5bcfaa0c1",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    }
  ],
  "securityGroup": "Questionnaire"
}' WHERE [Id]='27dbfadb-0e83-4acd-af28-35a760e3239b';

