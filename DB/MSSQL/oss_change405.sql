-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu.json
-- sidemenu-settings.json
-- QNN_TRK_LIST_SAMPLE.json
-- QNN_TRK_LIST_SAMPLE-settings.json
-- swzListList.json
-- swzListList-settings.json
-- swzListList-code.js
-- swzsamplelist.json
-- swzsamplelist-settings.json
-- SwzTrkLists.json
-- SwzTrkLists-settings.json
-- QNN_TRK_LIST.json
-- QNN_TRK_LIST-settings.json
-- QNN_TRK_LIST-code.js
-- QNN_LIST.json
-- QNN_LIST-settings.json

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-25 15:42:58.663', 
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
            "target": "/surveydesigner?apanel=formlogic",
            "title": "Form Logic",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/surveydesigner?apanel=formstyle",
            "title": "Form Style",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzStyleList",
            "title": "CSS Style Library",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')",
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
            "title": "Deployments",
            "target": "/form/SwzDplyList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')"
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
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
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
            "title": "Response Status Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/RespondentParticipationReport",
            "title": "Respondent Participation Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/WordCloudReport",
            "title": "Word Cloud Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
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
            "title": "Tags",
            "target": "/form/SwzTags",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SampleAdmin'') || CloverApp.API.checkRole(''SurveyAdmin'')"
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
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''AuditAdmin'')"
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ShortLinkList",
            "title": "Short Links",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') || CloverApp.API.checkRole(''SampleAdmin'')"
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
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-25 15:42:58.807', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2023-05-25T15:42:58.7948705+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='343228f8-b8d1-4775-97f3-dd3278089bd7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.803', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-25 16:06:26.630', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List Sample",
        "size": "large"
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "TrkListId",
            "data-buildertype": "dictionary",
            "label": "Track List",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_TRK_LIST",
            "columns": "Name ASC",
            "paging": true,
            "pageSize": "20",
            "other-readOnlyConition": "true",
            "events": {}
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true
          },
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Email",
            "data-buildertype": "input",
            "label": "Email",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Remarks",
            "data-buildertype": "textarea",
            "label": "Remarks",
            "fluid": true,
            "reference": "Remarks"
          },
          {
            "key": "Status",
            "data-buildertype": "dictionary",
            "label": "Status",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_STATUS",
            "columns": "Title ASC"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
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
                        "value": "/form/SwzTrkLists"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ]
          }
        ]
      }
    ]
  }
]' WHERE [Id]='343228f8-b8d1-4775-97f3-dd3278089bd7';

UPDATE [dwMetadata] SET
[Id]='e6933014-c1d8-42a4-bdb1-5199b4d53677', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.903', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-05-25 16:06:26.680', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST_SAMPLE",
  "lastUpdate": "2023-05-25T16:06:26.6784691+08:00",
  "entityId": "245660f8-437f-4716-b14b-03a040a0f220",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "784b4f21-a409-e116-de1f-ff06612fabd3",
      "attributeId": "93d5e831-d471-4fdf-b562-60d70ed73b64",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8a7180f8-f9f9-f505-d986-5c21decc75ef",
      "attributeId": "a6337ff6-c08d-4998-b235-f0c4609d44e4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3cb61126-816a-5daf-9544-029c6d3f777a",
      "attributeId": "7d603136-3dbb-488f-81ef-482d2592184e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ebb8374-aa46-f57b-2dc2-0288ad9cfcff",
      "attributeId": "1c65984e-89ce-4030-8cbb-60d8eb2455d7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9deeb8ec-ac97-e5f9-20b5-4b3ddd830b92",
      "attributeId": "665424d0-9759-437b-b620-d5d5243287c8",
      "control": "Email",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9ffe2f4-669e-6ef6-20d8-ebee1236862e",
      "attributeId": "9ed7f898-6b13-4cd0-be8d-4ce5183f0da8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "35ba6fe2-9599-40ba-01ad-d9c43ef76a77",
      "attributeId": "8f29d669-5d1d-4e3d-90b4-97153c2bbdfb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "528c299a-5646-1359-80a7-a89fc01401dc",
      "attributeId": "ec0e063b-9864-49a5-9469-72c6e2f2546e",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "297fc5ba-be15-336a-f453-3a9df8e6c3da",
      "attributeId": "b84d9d22-dd5c-4077-a8f7-a45a55496c0a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4316c2e5-c884-3e9e-9937-a5c2e8f3ac46",
      "attributeId": "67bb8933-188d-46ff-a9ce-7152447c3e6a",
      "control": "Remarks",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42830c72-4bd5-eec2-e6fb-e32acff4746b",
      "attributeId": "97f7aa0f-e033-4b9f-80e9-1dd6730c65f9",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c3543e6-145e-59a2-5533-f53d0e9bb5e5",
      "attributeId": "aec40eba-82df-4090-8bda-87bc9ae2bdac",
      "control": "TrkListId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "689af3a3-6d26-0795-0833-95d10696fcbc",
      "attributeId": "5671f841-1602-4210-90f3-77b8c2a51aaf",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2aacbbe5-5a1f-1248-3289-731b02c05151",
      "attributeId": "4b041d0e-1bed-4dd0-87ea-1c8812ec54de",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "914fbc30-3ce8-b5a2-7e6d-2829f0e349be",
      "attributeId": "f042fa99-cffb-480c-af49-86b679f57c1e",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "List"
}' WHERE [Id]='e6933014-c1d8-42a4-bdb1-5199b4d53677';

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 13:44:53.730', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "modalDiv",
        "data-buildertype": "container",
        "children": [
          {
            "key": "copyModal",
            "data-buildertype": "swzmodal",
            "style-display": "block",
            "inverted": true,
            "secondary": true,
            "children": [
              {
                "key": "formImportList",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopySampleList",
                    "data-buildertype": "header",
                    "content": "Copy Sample List",
                    "size": "medium",
                    "subheader": "New Sample List Name*"
                  },
                  {
                    "key": "copySampleListId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "newSampleListName",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200
                  },
                  {
                    "key": "container_3",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "container_4",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "btnCopy",
                            "data-buildertype": "button",
                            "content": "Copy",
                            "primary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "copySampleList"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginRight": "20px",
                            "floated": ""
                          },
                          {
                            "key": "btnCancelCopy",
                            "data-buildertype": "button",
                            "content": "Cancel",
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "closeCopyModal"
                                ],
                                "targets": [
                                  "copyModal"
                                ],
                                "parameters": []
                              }
                            },
                            "floated": ""
                          }
                        ],
                        "style-float": "right"
                      }
                    ],
                    "style-float": "",
                    "style-width": "100%",
                    "events": {},
                    "style-marginBottom": "20px",
                    "other-visibleConition": ""
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      },
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_3",
            "data-buildertype": "header",
            "content": "Sample Lists",
            "size": "large"
          }
        ],
        "style-marginBottom": "20px"
      },
      {
        "key": "container_buttons",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Export",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridExport"
                ],
                "targets": [
                  "gridviewwithactions_1"
                ],
                "parameters": []
              }
            },
            "style-hidden": true,
            "secondary": true
          },
          {
            "key": "btnCreate",
            "data-buildertype": "button",
            "content": "Create",
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
                  "gridCreate"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
            "style-source": "float:left"
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Delete",
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
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": [
                  {
                    "value": "deleteSampleListConfirmTitle",
                    "name": "confirmTitle"
                  },
                  {
                    "value": "deleteSampleListConfirmText",
                    "name": "confirmText"
                  },
                  {
                    "value": "deleteSampleListConfirmOk",
                    "name": "confirmOk"
                  }
                ]
              }
            },
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "children": [
              {
                "key": "importModal",
                "data-buildertype": "swzmodal",
                "style-source": "",
                "secondary": true,
                "content": "Import",
                "style-display": "none",
                "children": [
                  {
                    "key": "formImportList",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "header_1",
                        "data-buildertype": "header",
                        "content": "Import List",
                        "size": "medium",
                        "events": {},
                        "other-visibleConition": ""
                      },
                      {
                        "key": "listName",
                        "data-buildertype": "input",
                        "label": "List Name",
                        "fluid": true,
                        "onChangeTimeout": 200
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
                            "other-visibleConition": "(data.sampleAdded == null || data.sampleAdded == undefined)",
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
                            "other-visibleConition": "(data.sampleAdded == null || data.sampleAdded == undefined)",
                            "style-source": "float: right;"
                          }
                        ],
                        "style-marginRight": "",
                        "style-width": "100%",
                        "style-marginBottom": "10px"
                      }
                    ]
                  },
                  {
                    "key": "sampleListImportHeader",
                    "data-buildertype": "header",
                    "content": "Sample List Import Complete",
                    "size": "large",
                    "events": {},
                    "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                    "style-hidden": true,
                    "textAlign": "left"
                  },
                  {
                    "key": "importSummaryStatic",
                    "data-buildertype": "staticcontent",
                    "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
                    "isHtml": true,
                    "style-font-size": "15px",
                    "style-hidden": true,
                    "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                    "events": {}
                  },
                  {
                    "key": "containerInvalidDetails",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "header_2",
                        "data-buildertype": "header",
                        "content": "Invalid Rows Detail",
                        "size": "medium",
                        "other-visibleConition": ""
                      },
                      {
                        "key": "form_2",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_1",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "orientation": "grouped",
                            "children": [
                              {
                                "key": "container_3",
                                "data-buildertype": "container",
                                "style-float": "",
                                "children": [
                                  {
                                    "key": "invalidRowsDetail",
                                    "data-buildertype": "collectioneditor",
                                    "idField": "Id",
                                    "parentIdField": "ParentId",
                                    "columns": [
                                      {
                                        "key": "RowNo",
                                        "name": "Row No",
                                        "control": "span",
                                        "width": ""
                                      },
                                      {
                                        "key": "ErrField",
                                        "name": "Field",
                                        "control": "span",
                                        "width": ""
                                      },
                                      {
                                        "key": "ErrMsg",
                                        "name": "Error Message",
                                        "control": "span",
                                        "width": ""
                                      }
                                    ],
                                    "disableAdd": false,
                                    "disableDelete": false,
                                    "other-visibleConition": "",
                                    "header": false,
                                    "headerTitle": "Pre-Populate Fields",
                                    "events": {},
                                    "readOnly": true
                                  }
                                ],
                                "style-width": "",
                                "style-marginBottom": "",
                                "events": {},
                                "other-visibleConition": "",
                                "style-customcss": "",
                                "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;",
                                "style-marginTop": ""
                              }
                            ],
                            "events": {}
                          }
                        ]
                      }
                    ],
                    "style-source": "",
                    "style-customcss": "ui negative message",
                    "style-float": "",
                    "style-width": "",
                    "other-visibleConition": "(data.invalidRowsDetail!= undefined || data.invalidRowsDetail!= null)",
                    "events": {},
                    "style-hidden": true
                  },
                  {
                    "key": "btnImportClose",
                    "data-buildertype": "button",
                    "content": "Close",
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
                    "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                    "style-source": "float: right;",
                    "style-hidden": true,
                    "style-marginBottom": "20px",
                    "secondary": true
                  }
                ],
                "size": "",
                "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
              }
            ],
            "style-float": "left"
          },
          {
            "key": "btnRefresh",
            "data-buildertype": "button",
            "content": "Refresh",
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
                  "gridRefresh"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "other-visibleConition": "",
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "inputSearch",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": "",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "grid"
                        ],
                        "parameters": [
                          {
                            "name": "column",
                            "value": "Name,Tags,SampleCount,UpdatedDate"
                          }
                        ]
                      }
                    },
                    "placeholder": "Search..."
                  }
                ],
                "style-float": "left",
                "style-width": "300px"
              }
            ],
            "style-float": "left"
          }
        ],
        "style-marginRight": "20px",
        "style-width": "100%",
        "other-readOnlyConition": ""
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "custom"
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "custom"
      },
      {
        "key": "SampleCount",
        "name": "No. Of Records",
        "type": "number",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "sortable": false,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "NumberId DESC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_LIST",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500"
  }
]' WHERE [Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa';

UPDATE [dwMetadata] SET
[Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.470', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 13:44:53.767', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2023-06-02T13:44:53.7674185+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "176196ed-079f-6a36-bc0c-331bfdb4c7d3",
      "entityId": "d779dd42-ad03-418f-9a00-7906cfb9e01f",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "24b1dfc8-98b5-2b3d-cc48-6e6a874659c6",
          "attributeId": "1f8c8043-fc0a-4bc3-a0d5-3933a136b8cb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9ccc51d-c139-eda6-0d48-9d1a1dc10f48",
          "attributeId": "33924fbd-7f4d-447e-9346-91fb73661914",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d7a2e45-1ca6-5be7-ae45-10db539e2ddb",
          "attributeId": "fe356bc9-fb35-418f-b289-6d3c3ba5bff9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c3d75d44-bc83-484d-66ce-5a80562732b0",
          "attributeId": "4da79cdf-bda1-4862-99b0-7762005b3fa8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e1e96a0-86b5-bf30-c83e-c74ca19142a9",
          "attributeId": "1439e7c0-9381-49ac-bb27-06177daba88e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dbc0e6f-294f-a7a1-7b84-3708819382cf",
          "attributeId": "a7caa665-5fcb-4cd8-b75e-4b6023baf6c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8fd30580-6db4-1048-6736-b3b42f516a3c",
          "attributeId": "e85aa4f7-4e99-4797-8979-783b4239720f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f21b7f4-e600-61a5-c8b0-3f0057ad0a4e",
          "attributeId": "b8f72a51-90d9-4416-8267-3ad35be75b43",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='3456238e-14eb-4c78-bdf0-1615fd33edd3';

UPDATE [dwMetadata] SET
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 13:26:04.717', 
[Data]=N'{
    init: function(args) {
        console.log("args to init", args);
        const innerArgs = args;
        const hasEditPermission = CloverApp.API.checkPermission("Edit");
        console.log("hasEditPermission", hasEditPermission);
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            if(hasEditPermission) {
                return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
            } else {
                return null;
            }
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Name.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    }, //end of int
    
    //called by Copy button in modal
    copySampleList: function(args) {
        const data = args.data;
        const id = data.copySampleListId;
        const title = (data.newSampleListName===undefined) ? "" : data.newSampleListName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sampleListId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating SampleList");
        Utils.postFormRequest("/list/duplicate", formData).then(
            result => {
                args.component.refs.grid.refresh();
                args.component.refs.copyModal.close();
                alertify.success("Created " + title);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of copySampleList
    
    viewArgs: function (args){
        console.log("View", args);
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var listName = args.data.listName;
        
        var errors = {};
        if (!listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                //message: ''List name or file cannot be empty'',
                formerrors: {main: errors}
            };
          
          return {};
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        Utils.postFormRequest("/list/importnew", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success(response.message,10000);
            }, reason => {
                CloverApp.API.setDataField("listFile", null);
                alertify.error(reason, 15000);
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeModal: function (args){
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''importSummaryStatic'',''sampleListImportHeader'',''btnImportClose'',''containerInvalidDetails'']
                  }
              }
            }
        }       
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='29d6757b-a248-477d-a1d5-e5a4f7550f07', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzsamplelist.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 09:33:31.797', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 14:33:45.000', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "pageHeader",
            "data-buildertype": "header",
            "content": "Samples",
            "size": "huge",
            "textAlign": "left",
            "style-marginTop": "",
            "style-source": "padding-top:20px;",
            "style-marginLeft": "",
            "style-width": "250px",
            "events": {}
          }
        ],
        "style-marginBottom": "10px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Export",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridExport"
                ],
                "targets": [
                  "gridviewwithactions_1"
                ],
                "parameters": []
              }
            },
            "style-hidden": true,
            "secondary": true
          },
          {
            "key": "btnCreate",
            "data-buildertype": "button",
            "content": "Create",
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
                  "gridCreate"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
            "style-source": "float:left"
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Delete",
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
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deleteSampleConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deleteSampleConfirmText"
                  }
                ]
              }
            },
            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")",
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "inputSearch",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": "350",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "grid"
                        ],
                        "parameters": [
                          {
                            "name": "column",
                            "value": "Name, UID"
                          }
                        ]
                      }
                    },
                    "placeholder": "Search by Name or UID"
                  }
                ],
                "style-float": "left",
                "style-width": "300px"
              }
            ],
            "style-float": "left"
          }
        ],
        "style-marginRight": "20px",
        "style-width": "100%"
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 150
      },
      {
        "key": "ToEmails",
        "name": "To Emails",
        "type": "",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 250
      },
      {
        "key": "CcEmails",
        "name": "CC Emails",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 250
      },
      {
        "key": "StructDivisionName",
        "name": "Organisation",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 150
      },
      {
        "key": "ActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 64
      },
      {
        "key": "LastLoginDate",
        "name": "Last Login Date",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "Name",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_SAMPLE",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500",
    "style-width": "100%"
  }
]' WHERE [Id]='29d6757b-a248-477d-a1d5-e5a4f7550f07';

UPDATE [dwMetadata] SET
[Id]='e3aa01f6-089e-477b-bc56-7bb0a62ca971', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzsamplelist-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 09:33:32.437', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 14:33:45.040', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzsamplelist",
  "lastUpdate": "2023-06-02T14:33:45.0388141+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "71b48e2c-7b9b-17d7-d790-99f8533733ac",
      "entityId": "96aba12c-a596-46b1-b1dd-74a5ba60f3d6",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "7802862b-264f-9665-0e2a-fc1c19c09c8b",
          "attributeId": "e6eacd17-2f27-ac18-7687-28d1a200b555",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d51ef056-f852-bb20-19da-129d6fbb6944",
          "attributeId": "7a48d23c-8d3f-476f-b443-0f2c15c32f51",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c987c0f5-3b5c-8cb3-2b52-9081c25257a9",
          "attributeId": "ed15f27b-d27a-4f96-a87e-35487ef74f6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "301e61f9-24d5-135a-117d-9b8c7ad8e400",
          "attributeId": "cd0aed58-ed57-47c3-a6a8-e1348aff5e37",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b3ac5c6-2c17-3d2f-404f-a4cfbcaac451",
          "attributeId": "7465d37b-32c2-4447-b563-71121c49aecb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aed556ab-ed20-c7df-c08a-3394712a8193",
          "attributeId": "18273149-6b04-49c7-9b0d-ba476ca9c2d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6876cd45-29c9-2300-1e82-ca0fa140438e",
          "attributeId": "ec38a02c-e930-41b3-bb5d-993aa510d212",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d67afb34-df34-55d6-c80f-7f6f19f7fed2",
          "attributeId": "37f0c1bc-9266-41e7-89f3-9db71c52d805",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99c53890-e2f7-2d6b-6dd8-f511ec32ccae",
          "attributeId": "bd7d0d39-4d14-4ab8-8da4-630351b0b2b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9034192-c642-b31b-97a4-0910c2013734",
          "attributeId": "67f5a605-d9d5-480d-9eaf-a6bb0244cfb9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='e3aa01f6-089e-477b-bc56-7bb0a62ca971';

UPDATE [dwMetadata] SET
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 15:26:04.747', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track Lists",
        "size": "large"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
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
              "gridview_1"
            ],
            "parameters": []
          }
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "gridDelete"
            ],
            "targets": [
              "gridview_1"
            ],
            "parameters": []
          }
        },
        "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "input_1",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
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
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Name, StructDivisionId_Name"
                  }
                ]
              }
            },
            "placeholder": "Filter by Name",
            "style-marginBottom": ""
          }
        ],
        "style-width": "48%",
        "style-float": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "right",
        "style-width": "48%",
        "children": [
          {
            "key": "dictionary_1",
            "data-buildertype": "dictionary",
            "label": "",
            "fluid": true,
            "selection": true,
            "placeholder": "Filter by Division",
            "dataModel": "vSP_StructDivision",
            "columns": "Name ASC",
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
                    "value": "StructDivisionId_Name"
                  }
                ]
              }
            },
            "style-marginBottom": "",
            "paging": true,
            "pageSize": "20",
            "clearable": true
          }
        ]
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "form_2",
    "data-buildertype": "form",
    "children": []
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
        "sortable": false,
        "filterable": false,
        "resizable": true,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "rowHeight": "50",
    "minHeight": "250",
    "pageSize": "10",
    "defaultSort": "Name ASC",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": true,
    "editForm": "QNN_TRK_LIST",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    }
  }
]' WHERE [Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64';

UPDATE [dwMetadata] SET
[Id]='52c60fe7-52bc-4191-9759-ced45ee3e7ea', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.947', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 15:26:04.803', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzTrklists",
  "lastUpdate": "2023-06-02T15:26:04.8037627+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "113be75a-51d8-db7b-9745-aa135fe7079e",
      "entityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "56fec25a-db74-f92d-b854-29ee2bb018e3",
          "attributeId": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0c70b31-7684-fbb1-23e1-ff96a00a9db1",
          "attributeId": "0c358898-d35c-4be3-89bd-368143effb39",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f08543d7-bfbd-6b13-4488-a679535eef1d",
          "attributeId": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3ac46703-2e77-13b5-9190-f907277c5c90",
          "attributeId": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f9bb2f3-70a5-b666-1874-6c4e991e2cfc",
          "attributeId": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb8a2a04-61a4-10e2-c06e-ea8ddb0a3e64",
          "attributeId": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5b82c5e0-3142-5dad-26c2-307f8f59a6c3",
          "attributeId": "f55004c7-067f-4b47-9815-1d91d177b8a2",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8566f52-293f-d6f8-27e2-0e850ef57c24",
          "attributeId": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b0973aa9-d8a7-8224-ad22-7dc8997bc1f3",
          "attributeId": "b3e75714-844d-4e64-b638-e9c60ffebf78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "482464a3-ebba-4393-97d5-2fd4a02af1e5",
          "attributeId": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
          "control": "UpdatedDate",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b789c7f-ab20-cfd7-8643-e702110c24c2",
          "attributeId": "863fb411-5f61-4962-ac06-cdf953abbbf0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "72e26579-e5f5-8b27-35b2-5ad4768e9ffb",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionId_Name",
          "parentId": "6b789c7f-ab20-cfd7-8643-e702110c24c2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d0459245-8976-318d-c8ab-4d5b13a9fa42",
          "attributeId": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='52c60fe7-52bc-4191-9759-ced45ee3e7ea';

UPDATE [dwMetadata] SET
[Id]='94df18e6-8c55-43f0-883c-8b905a2d882f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 15:27:28.373', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginBottom": "20px",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Track List",
        "size": "large"
      }
    ]
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
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "Description",
            "data-buildertype": "textarea",
            "label": "Description",
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
                        "value": "/form/swztrklists"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ],
            "style-marginBottom": "20px",
            "style-float": "right"
          }
        ]
      }
    ]
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newTrkListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelete",
                    "data-buildertype": "button",
                    "content": "Delete",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "gridDelete",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_7",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Track List Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "breadcrumb_1",
                            "data-buildertype": "breadcrumb",
                            "items": [
                              {
                                "text": "Download Template",
                                "url": "#"
                              }
                            ],
                            "events": {
                              "onItemClick": {
                                "active": true,
                                "actions": [
                                  "onDownloadTemplate"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "style-marginBottom": "20px"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": true,
                                    "actions": [
                                      "hideMessages"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "headerListSampleAdded",
                            "data-buildertype": "header",
                            "content": "Track List Sample Added: {listSampleAddedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleAddedCount!=null"
                          },
                          {
                            "key": "headerListSampleUpdated",
                            "data-buildertype": "header",
                            "content": "Track List Sample Updated: {listSampleUpdatedCount}",
                            "size": "small",
                            "events": {},
                            "style-hidden": false,
                            "other-visibleConition": "data.listSampleUpdatedCount!= null"
                          },
                          {
                            "key": "gridviewImportSummary",
                            "data-buildertype": "gridview",
                            "columns": [
                              {
                                "key": "RowNo",
                                "name": "RowNo",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "UID",
                                "name": "UID",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrField",
                                "name": "ErrField",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              },
                              {
                                "key": "ErrMsg",
                                "name": "ErrMsg",
                                "sortable": true,
                                "filterable": false,
                                "resizable": false
                              }
                            ],
                            "style-hidden": false,
                            "events": {},
                            "other-visibleConition": "data.gridviewImportSummary!= null && data.gridviewImportSummary!=undefined",
                            "rowKey": "RowNo",
                            "minHeight": "150"
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ]
              },
              {
                "key": "container_20",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "button_1",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "children": [],
                "style-float": "left"
              }
            ],
            "style-width": "",
            "style-float": "left",
            "style-marginRight": "",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "gridviewSample",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "UID",
                "name": "UID",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Name",
                "name": "Name",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              },
              {
                "key": "Email",
                "name": "Email",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "offSet": "",
            "multiselect": true,
            "rowKey": "Id",
            "defaultSort": "UID ASC",
            "events": {
              "onRowClick": {
                "active": true,
                "actions": [
                  "gridEdit"
                ],
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
            },
            "pagerType": "server",
            "editFormShowType": "",
            "minHeight": "",
            "style-marginTop": "",
            "editForm": "QNN_TRK_LIST_SAMPLE",
            "style-hidden": false,
            "pageSize": "80",
            "rowHeight": "80"
          }
        ],
        "other-visibleConition": "data.Id!=null"
      }
    ],
    "style-customcss": "hrm-block",
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  }
]' WHERE [Id]='94df18e6-8c55-43f0-883c-8b905a2d882f';

UPDATE [dwMetadata] SET
[Id]='27855988-ddc1-4d16-9272-69ebe7e64c13', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-01 10:18:05.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 15:27:28.427', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_TRK_LIST",
  "lastUpdate": "2023-06-02T15:27:28.4262736+08:00",
  "entityId": "3987392b-8965-4b2b-9142-9aeb72613ded",
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
      "id": "e3fdbacd-4375-80d2-740c-7640f45540a1",
      "attributeId": "4fc98cea-3187-4c06-a99f-4528a71e9a25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "189b34e9-b436-1620-293f-96b512e74eeb",
      "attributeId": "0c358898-d35c-4be3-89bd-368143effb39",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29536852-22ef-4321-6099-c79c4eed021b",
      "attributeId": "912f0f38-a974-4dde-bd19-4ea5d77fa980",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7f578f4f-db0d-f9d4-6def-3c5d9ba046ac",
      "attributeId": "3c44cb6f-f347-4ae5-8cd8-cf8a308ad483",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "827f2897-f7bb-10bf-6d86-b59c288e3bd2",
      "attributeId": "bd272d09-ca2c-4263-87f0-cbde2ad09dfe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1bafca91-1758-7795-8775-c66ceadd577a",
      "attributeId": "315fa785-1bbc-4078-9755-9e84e4d5ea8e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f69e648-723a-b662-fdd6-8fdf28016f17",
      "attributeId": "f55004c7-067f-4b47-9815-1d91d177b8a2",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54ed9637-3e8e-8e12-00e8-a24ad1c47f4c",
      "attributeId": "ca01aa62-5632-4a57-b5bc-9c371abfe8ca",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff10f833-945d-1258-ec3b-ce0af61fd36b",
      "attributeId": "b3e75714-844d-4e64-b638-e9c60ffebf78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9f27c2e-a9ec-dc10-868c-e57a039d72ad",
      "attributeId": "7ea30037-8af8-43c1-baef-6f36ba70fcc0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d23e0b5d-3658-a1a1-6202-1d30ec00565a",
      "attributeId": "863fb411-5f61-4962-ac06-cdf953abbbf0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b38af738-1a41-0f6e-1fd9-052438e971ce",
      "attributeId": "8920593a-ade0-4c0c-ab25-9e2e01e5afdc",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b2018773-2287-ab4a-5f60-6c614b841b76",
      "entityId": "245660f8-437f-4716-b14b-03a040a0f220",
      "filter": "FilterByModelId",
      "parameter": "{TrkListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "0cc2a40e-652a-3f5e-7502-cce03d7e26b9",
          "attributeId": "93d5e831-d471-4fdf-b562-60d70ed73b64",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d5b185b8-2318-5fc4-284a-4d6c3aca0540",
          "attributeId": "a6337ff6-c08d-4998-b235-f0c4609d44e4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "548fe073-4081-ca3b-e8cb-780a584cd2e3",
          "attributeId": "7d603136-3dbb-488f-81ef-482d2592184e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8cd98de-8a9a-b81d-58ba-925e47eb0b47",
          "attributeId": "1c65984e-89ce-4030-8cbb-60d8eb2455d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e66f31-0567-6973-6dbe-8ead55b735a5",
          "attributeId": "665424d0-9759-437b-b620-d5d5243287c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c1692c4-bc68-d880-6ae2-023173363cbb",
          "attributeId": "9ed7f898-6b13-4cd0-be8d-4ce5183f0da8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6a27f53d-c1e7-1242-2949-4ef829c0fee3",
          "attributeId": "8f29d669-5d1d-4e3d-90b4-97153c2bbdfb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c399f5c-2b24-7d4d-e23c-93400d7a1520",
          "attributeId": "ec0e063b-9864-49a5-9469-72c6e2f2546e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35b222dd-c9b1-84ed-5313-04c48f4bb267",
          "attributeId": "b84d9d22-dd5c-4077-a8f7-a45a55496c0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0297648c-0594-5ad0-8f16-0fab66e47816",
          "attributeId": "67bb8933-188d-46ff-a9ce-7152447c3e6a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "26a11c54-3f20-205d-986b-9ec0206a9f87",
          "attributeId": "97f7aa0f-e033-4b9f-80e9-1dd6730c65f9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9afe4bb-1f5a-5f9b-c8ef-32cf8a130d2c",
          "attributeId": "aec40eba-82df-4090-8bda-87bc9ae2bdac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a213b234-6c3e-9107-5700-fb7244c3d7c2",
          "attributeId": "5671f841-1602-4210-90f3-77b8c2a51aaf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa0e2e0-84ea-65b9-8e32-cac5d650b33c",
          "attributeId": "4b041d0e-1bed-4dd0-87ea-1c8812ec54de",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "498ba4b5-d60b-db99-acb1-09133f0a889b",
          "attributeId": "f042fa99-cffb-480c-af49-86b679f57c1e",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='27855988-ddc1-4d16-9272-69ebe7e64c13';

UPDATE [dwMetadata] SET
[Id]='ea958da5-0374-40dd-a53a-a00315a50a3a', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 15:06:37.850', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 17:30:16.727', 
[Data]=N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
    },
    
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){
        if(args.controlRef.state.rowsCount==0){
            alertify.error("Nothing to export");
            return;
        }
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
    submitFile(args)
    {
        const token = args.data.inputImportListSample;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        const formData = new FormData();
        formData.append("trkListId",args.data.Id);
        formData.append("token", token);

        Utils.loadingStart();
        Utils.postFormRequest("/trklist/importsamples", formData).then(
            response => {
                alertify.success(response.message);
                console.log("response", response);
                CloverApp.API.setDataField("inputImportListSample", null);
                args.component.refs.gridviewSample.refresh();
                CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                Utils.queueHideControl("headerListSampleAdded", false);
                Utils.queueHideControl("headerListSampleUpdated", false);
                if(response.items!=null && response.items!=undefined){
                    CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                    Utils.queueHideControl("gridViewImportSummary", false);
                }
                else{
                    Utils.queueHideControl("gridViewImportSummary", true);                     
                }
            }, reason => {
                console.error(reason);
                alertify.error(reason, 15000);
            }
        ).finally(Utils.loadingStop());
    }, 
  
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
    
}' WHERE [Id]='ea958da5-0374-40dd-a53a-a00315a50a3a';

UPDATE [dwMetadata] SET
[Id]='715ce353-26d4-4c0f-8b65-57db2da22232', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 18:30:28.440', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "bcList",
        "data-buildertype": "breadcrumb",
        "items": [
          {
            "divider": "right angle",
            "text": "List",
            "url": "/form/SwzListList"
          },
          {
            "text": "Manage List",
            "active": true
          }
        ],
        "events": {
          "onItemClick": {
            "active": true,
            "actions": [
              "redirect"
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "headerPage",
        "data-buildertype": "container",
        "style-float": "left",
        "style-marginTop": "",
        "style-marginBottom": "",
        "style-marginLeft": "",
        "children": [
          {
            "key": "form_5",
            "data-buildertype": "form",
            "children": [
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "headerName",
                    "data-buildertype": "header",
                    "content": "Manage {nameInput}",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  },
                  {
                    "key": "header_1",
                    "data-buildertype": "header",
                    "content": "",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  }
                ]
              }
            ],
            "style-marginLeft": "7px",
            "style-customcss": ""
          }
        ],
        "style-source": "",
        "style-marginRight": "20px"
      }
    ],
    "style-source": "",
    "style-marginTop": "10px",
    "style-marginBottom": "",
    "style-marginLeft": "",
    "style-float": "left",
    "style-width": "",
    "style-customcss": ""
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-source": "",
    "style-height": "",
    "children": []
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
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "style-float": "left",
                "style-width": "100%",
                "children": [
                  {
                    "key": "form_3",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "headerProperties",
                        "data-buildertype": "header",
                        "content": "Properties",
                        "size": "medium"
                      },
                      {
                        "key": "formgroup_5",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "nameInput",
                            "data-buildertype": "input",
                            "label": "List Name",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "text",
                            "readOnly": false,
                            "events": {},
                            "labelPosition": "",
                            "style-width": "",
                            "other-required": true,
                            "reference": "List Name"
                          }
                        ]
                      },
                      {
                        "key": "formgroup_7",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "headerDescription",
                            "data-buildertype": "textarea",
                            "label": "List Description",
                            "fluid": true,
                            "other-required": false,
                            "events": {}
                          }
                        ]
                      },
                      {
                        "key": "staticcontent_3",
                        "data-buildertype": "staticcontent",
                        "content": "Tags",
                        "isHtml": true,
                        "style-marginBottom": "4px",
                        "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                      },
                      {
                        "key": "divActiveTags",
                        "data-buildertype": "container",
                        "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;",
                        "events": {},
                        "children": [
                          {
                            "key": "mdlTag",
                            "data-buildertype": "swzmodal",
                            "content": "Add/Remove Tags",
                            "compact": true,
                            "secondary": true,
                            "events": {
                              "onClick": {
                                "active": true,
                                "actions": [
                                  "openTagsModal"
                                ],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "children": [
                              {
                                "key": "header_4",
                                "data-buildertype": "header",
                                "content": "Add/Remove Tags",
                                "size": "medium"
                              },
                              {
                                "key": "message_1",
                                "data-buildertype": "message",
                                "header": "",
                                "content": "Add a custom tag by typing in the Tags",
                                "info": true
                              },
                              {
                                "key": "staticcontent_5",
                                "data-buildertype": "staticcontent",
                                "content": "Tags",
                                "isHtml": true,
                                "style-marginBottom": "4px",
                                "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                              },
                              {
                                "key": "ddTags",
                                "data-buildertype": "dropdown",
                                "label": "",
                                "fluid": true,
                                "selection": true,
                                "data-elements": [],
                                "placeholder": "Type and add tag here",
                                "search": true,
                                "multiple": true,
                                "allowAddItems": true,
                                "style-marginBottom": "20px",
                                "events": {}
                              },
                              {
                                "key": "divTagsSearchResult",
                                "data-buildertype": "container",
                                "style-source": "clear:both;\nborder:1px solid rgba(34,36,38,.15);\nborder-radius: 5px;\npadding:9.5px 14px;\nmin-height:45px;",
                                "style-marginBottom": "10px",
                                "events": {},
                                "children": [
                                  {
                                    "key": "formgroup_10",
                                    "data-buildertype": "formgroup",
                                    "widths": "equal",
                                    "orientation": "grouped",
                                    "children": [
                                      {
                                        "key": "staticcontent_6",
                                        "data-buildertype": "staticcontent",
                                        "content": "Search For Tags",
                                        "isHtml": true,
                                        "style-marginBottom": "4px",
                                        "style-source": "color:#97A3B4;\nfont-size:12px;\nfont-weight:400;\nline-height:16px;"
                                      },
                                      {
                                        "key": "TagsSearch",
                                        "data-buildertype": "input",
                                        "label": "",
                                        "fluid": false,
                                        "onChangeTimeout": 200,
                                        "placeholder": "Search Tags...",
                                        "events": {
                                          "onChange": {
                                            "active": true,
                                            "actions": [
                                              "searchTagsInDB"
                                            ],
                                            "targets": [],
                                            "parameters": []
                                          }
                                        }
                                      }
                                    ]
                                  },
                                  {
                                    "key": "staticcontent_7",
                                    "data-buildertype": "staticcontent",
                                    "content": "<hr>",
                                    "isHtml": true,
                                    "style-marginBottom": "10px",
                                    "style-source": "",
                                    "style-marginTop": "10px"
                                  }
                                ]
                              },
                              {
                                "key": "container_24",
                                "data-buildertype": "container",
                                "style-float": "left",
                                "style-marginTop": "30px",
                                "style-marginBottom": "20px",
                                "children": [
                                  {
                                    "key": "btnTagsSave",
                                    "data-buildertype": "button",
                                    "content": "Save",
                                    "primary": true,
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "saveActiveTags"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    }
                                  },
                                  {
                                    "key": "button_2",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeTagsModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "secondary": true
                                  }
                                ]
                              }
                            ],
                            "size": "tiny",
                            "style-display": "none",
                            "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                          },
                          {
                            "key": "staticcontent_4",
                            "data-buildertype": "staticcontent",
                            "content": "<hr>",
                            "isHtml": true,
                            "style-marginBottom": "10px",
                            "style-source": "",
                            "style-marginTop": "10px"
                          }
                        ],
                        "style-marginTop": "",
                        "style-marginBottom": "15px"
                      },
                      {
                        "key": "formgroup_4",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "TrkListIds",
                            "data-buildertype": "dictionary",
                            "label": "Track List",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_TRK_LIST",
                            "columns": "Name ASC",
                            "events": {},
                            "multiple": true,
                            "clearable": true,
                            "style-hidden": false
                          }
                        ],
                        "style-marginTop": "15px"
                      },
                      {
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "toggleStatus",
                            "data-buildertype": "checkbox",
                            "label": "Status",
                            "toggle": true,
                            "events": {},
                            "style-width": "300px"
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-customcss": ""
              }
            ],
            "style-width": "100%",
            "style-float": "left"
          },
          {
            "key": "container_13",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_2",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "",
                    "style-width": "100%",
                    "children": [
                      {
                        "key": "form_4",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "headerUser",
                            "data-buildertype": "header",
                            "content": "Records User Control",
                            "size": "medium"
                          },
                          {
                            "key": "formgroup_8",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditName",
                                "data-buildertype": "checkbox",
                                "label": "Edit Name",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_3",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditEmail",
                                "data-buildertype": "checkbox",
                                "label": "Edit Email",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_9",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "togglePassword",
                                "data-buildertype": "checkbox",
                                "label": "Edit Password",
                                "toggle": true
                              }
                            ]
                          }
                        ],
                        "style-source": "float:left"
                      }
                    ],
                    "other-visibleConition": "",
                    "style-hidden": true
                  },
                  {
                    "key": "container_11",
                    "data-buildertype": "container",
                    "children": [],
                    "style-float": "",
                    "style-source": "clear:both",
                    "style-customcss": "",
                    "style-width": ""
                  }
                ],
                "style-source": "",
                "style-width": "100%",
                "style-marginTop": "10px"
              }
            ],
            "style-width": "100%"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "List Sample Properties",
            "size": "medium"
          },
          {
            "key": "collectioneditor_1",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Alias",
                "name": "Alias",
                "width": "",
                "control": "input"
              },
              {
                "key": "ReqdYN",
                "name": "Reqd",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "UsrEditYN",
                "name": "UsrEdit",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "TxtRow",
                "name": "TxtRow",
                "control": "number",
                "width": "10%"
              },
              {
                "key": "TxtRegExp",
                "name": "TxtRegExp",
                "width": "25%",
                "control": "input"
              },
              {
                "key": "TxtRegExpErr",
                "name": "TxtRegExpErr",
                "width": "20%",
                "control": "input"
              }
            ],
            "header": false,
            "headerTitle": "List Sample Properties",
            "hierarchical": false,
            "placeholders": {
              "Type": [
                {
                  "key": "Type",
                  "data-buildertype": "input",
                  "label": "",
                  "fluid": true,
                  "onChangeTimeout": 200,
                  "readOnly": true,
                  "defaultValue": "1",
                  "style-hidden": false
                }
              ]
            },
            "events": {},
            "style-width": "100%",
            "style-customcss": "hmr-block",
            "style-marginBottom": "20px"
          }
        ],
        "style-customcss": "",
        "style-width": "100%",
        "style-source": "padding: 10px;\nborder: 1px solid rgba(34,36,38,.15);",
        "style-hidden": false,
        "other-visibleConition": "",
        "style-float": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnSave",
            "data-buildertype": "button",
            "content": "Save",
            "events": {
              "onClick": {
                "actions": [
                  "processTrkList",
                  "validate",
                  "save",
                  "goRecords"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzListList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          },
          {
            "key": "btnCancel",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "exit",
                  "redirect"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/swzlistlist"
                  }
                ]
              }
            },
            "secondary": true
          }
        ],
        "style-float": "right",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": ""
  },
  {
    "key": "cnt_visuallyDivideMasterAndDetail",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium",
                "subheader": "Samples in this list"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDisable",
                    "data-buildertype": "button",
                    "content": "Disable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "toggleListSamplesActive",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "disableSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "disableSamplesConfirmText"
                          },
                          {
                            "name": "action",
                            "value": "disable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  },
                  {
                    "key": "btnEnable",
                    "data-buildertype": "button",
                    "content": "Enable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "toggleListSamplesActive",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "action",
                            "value": "enable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_22",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDeleteSample",
                    "data-buildertype": "button",
                    "content": "Delete Samples & Data",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "deleteListSample",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "deleteListSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteListSamplesConfirmText"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "formImportList",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "inputPassword",
                            "data-buildertype": "input",
                            "label": "Password",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "password"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": false,
                                    "actions": [],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ]
                          },
                          {
                            "key": "container_14",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      },
                      {
                        "key": "sampleListImportHeader",
                        "data-buildertype": "header",
                        "content": "Sample List Import Complete",
                        "size": "large",
                        "events": {},
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-hidden": true,
                        "textAlign": "left"
                      },
                      {
                        "key": "importSummaryStatic",
                        "data-buildertype": "staticcontent",
                        "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Updated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleUpdated}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
                        "isHtml": true,
                        "style-font-size": "15px",
                        "style-hidden": true,
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "events": {}
                      },
                      {
                        "key": "containerInvalidDetails",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Invalid Rows Detail",
                            "size": "medium",
                            "other-visibleConition": ""
                          },
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "formgroup_1",
                                "data-buildertype": "formgroup",
                                "widths": "equal",
                                "orientation": "grouped",
                                "children": [
                                  {
                                    "key": "container_3",
                                    "data-buildertype": "container",
                                    "style-float": "",
                                    "children": [
                                      {
                                        "key": "invalidRowsDetail",
                                        "data-buildertype": "collectioneditor",
                                        "idField": "Id",
                                        "parentIdField": "ParentId",
                                        "columns": [
                                          {
                                            "key": "RowNo",
                                            "name": "Row No",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrField",
                                            "name": "Field",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrMsg",
                                            "name": "Error Message",
                                            "control": "span",
                                            "width": ""
                                          }
                                        ],
                                        "disableAdd": false,
                                        "disableDelete": false,
                                        "other-visibleConition": "",
                                        "header": false,
                                        "headerTitle": "Pre-Populate Fields",
                                        "events": {},
                                        "readOnly": true
                                      }
                                    ],
                                    "style-width": "",
                                    "style-marginBottom": "",
                                    "events": {},
                                    "other-visibleConition": "",
                                    "style-customcss": "",
                                    "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;",
                                    "style-marginTop": ""
                                  }
                                ],
                                "events": {}
                              }
                            ]
                          }
                        ],
                        "style-source": "",
                        "style-customcss": "ui negative message",
                        "style-float": "",
                        "style-width": "",
                        "other-visibleConition": "(data.invalidRowsDetail!= undefined || data.invalidRowsDetail!= null)",
                        "events": {},
                        "style-hidden": true
                      },
                      {
                        "key": "btnImportClose",
                        "data-buildertype": "button",
                        "content": "Close",
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
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-source": "float: right;",
                        "style-hidden": true,
                        "style-marginBottom": "20px",
                        "secondary": true
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": "CloverApp.API.checkPermission(\"Edit\")"
                  }
                ],
                "style-marginRight": ""
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "btnExportSamples",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_25",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnRefresh",
                    "data-buildertype": "button",
                    "content": "Refresh",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": "",
                    "secondary": true
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "inputSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "300px",
                "size": "",
                "labelPosition": "",
                "style-source": "float: left;",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridviewSample"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "Name, UID"
                      }
                    ]
                  }
                },
                "placeholder": "Search by Name or UID"
              }
            ],
            "style-width": "100%",
            "style-float": "",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      }
    ],
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "gridviewSample",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "ListSampleActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "ToEmails",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "CcEmails",
        "name": "CC Emails",
        "sortable": true,
        "filterable": false,
        "resizable": true
      }
    ],
    "autoHeight": false,
    "offSet": "",
    "multiselect": true,
    "rowKey": "Id",
    "defaultSort": "UID ASC",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
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
    },
    "pagerType": "server",
    "editFormShowType": "",
    "minHeight": "",
    "style-marginTop": "",
    "editForm": "QNN_LIST_SAMPLE",
    "style-hidden": false,
    "rowHeight": "80",
    "pageSize": "80",
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "container_20",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null",
    "style-marginTop": "20px"
  },
  {
    "key": "container_23",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Deployments using this Sample List",
        "size": "small",
        "textAlign": "left"
      },
      {
        "key": "gridDeployments",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "Name",
            "name": "Deployment",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SurveyName",
            "name": "Survey",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CategoryName",
            "name": "Category",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CreatedDate",
            "name": "Created",
            "type": "datetime",
            "resizable": true,
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
        "editForm": "QNN_DPLY",
        "rowKey": "Id",
        "pageSize": "50",
        "defaultSort": "Name ASC",
        "rowHeight": "80",
        "events": {
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
    "other-visibleConition": "(data.Id  && CloverApp.API.checkRole(''SurveyAdmin'') ) ? true : false"
  }
]' WHERE [Id]='715ce353-26d4-4c0f-8b65-57db2da22232';

UPDATE [dwMetadata] SET
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-06-02 18:30:28.527', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2023-06-02T18:30:28.5075742+08:00",
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
    },
    {
      "id": "6a6cf905-666e-ea96-3dc7-ea414625f144",
      "attributeId": "727c6358-fea5-49ed-9099-2762644973fe",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "6cf82f70-64e4-4494-b02b-82806ea7c26e",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "81789810-9928-2fd3-bad0-fa54dfae9227",
          "attributeId": "8cccf6c3-0226-48a3-a998-da0e36c4daf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19b7bc15-60ca-0552-7ffb-f99ca0f979a2",
          "attributeId": "8483bf15-ff56-49e2-96e1-c9bc94be1938",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc0643f8-c16f-9c44-5a89-1b03699e8d54",
          "attributeId": "04ae0ae7-aa15-4fe4-9a9e-3da6b1011130",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "055e840f-5d2c-de43-f5ee-1aec3231946d",
          "attributeId": "0303ebaa-f136-4957-853e-52fb9dce9865",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1ccc22e-44f4-079b-e05f-33112d8a94c8",
          "attributeId": "f9357a1b-c839-42c1-a624-ee242454fcfc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27629011-2b07-85fb-2ac7-ea8fed5b3de2",
          "attributeId": "361ff056-f5e5-42e3-af19-804c08085e6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9b8b9fe-9ec1-7f75-8458-6d0b876a606f",
          "attributeId": "cf043f7d-e0bf-4cdf-a5f2-22e2cb362f82",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5b6d9ce-d349-4130-006a-ae105bb6e21b",
          "attributeId": "32553188-2535-4522-95b8-957279ba3ed1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6886368-d110-d7d8-bd6d-eb63bc7fd5ce",
          "attributeId": "8325f35d-ec44-4846-b129-0011d8b15cc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41d8d692-cfc7-1490-f59c-8a7d6ad738d4",
          "attributeId": "b5602ad5-e7a9-4659-a2d8-ee1b7b7a2bbf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "595a1068-fbb6-bc68-f3ab-ec868b11793e",
          "attributeId": "75e179e7-7731-46f4-9e62-eb27d6fe95aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1e9b043-7a8f-67e2-e1e3-fa6bbd773f49",
          "attributeId": "f25864f8-5967-4508-8fa8-3fbdbdeeff9b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "623faa61-93d5-e2a0-82ed-a90b0877bcb5",
          "attributeId": "38bfcb12-f658-4ce2-ab33-99e5c236435a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84770df3-3b00-da09-a7ce-6e8b51c01fb6",
          "attributeId": "f9743ce4-bd21-4aec-ae86-0bb6d7440190",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
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
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_1_totalcount"
    },
    {
      "id": "8161ebf5-8ee8-cfe0-f4e9-935018d59779",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridDeployments",
      "dataMap": [
        {
          "id": "7eb438a5-8378-c552-f483-616b4c93c22e",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "80ff6f67-e35c-616d-d105-fce77104b780",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f691ddf4-f53b-f6fc-c2b0-e71dea6f5a36",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b30ab47f-c182-941e-b0af-eced94413c75",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "874d2516-9167-54f8-0b10-ffb989851c2a",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b3c1aea5-7b04-5545-d228-0be1c415c664",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d171d52-707f-e394-f76e-9289a1ce2c6c",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "686f8437-cefd-20bd-c123-01990b71b0c7",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "df652069-f61c-6a16-4d7c-5117f50276df",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76751db7-b053-cda9-fe7c-caa2f473b806",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b58afbda-846a-45d2-9f41-fd8b781d4d2c",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "539bd40b-09f3-d46e-aee2-e1647d96c47a",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "58c09ddf-88d3-41db-4c40-255b51d76bcd",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "324607f9-64a7-a4a2-867e-21a16bd48a30",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a61f3f0-17f8-5560-8aa1-226f00b0bfc0",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "6ab9dd5a-70f4-b3d7-33fd-0d74b6fed431",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "8ccce086-674d-d299-83aa-b9e0a31dca2c",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "07173d24-9a62-d3da-95a1-151bddcf650d",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "534bf5ba-27bf-ddd8-6bdd-5b3ec0a0c030",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17e8f3bf-d9b3-d76a-8bf9-8f5bccd5edb8",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98ba8faa-f5d7-5f66-fc28-123bfb82f447",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "17eb14fc-b708-37ff-4d0c-4fbdb112a8a2",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e86db019-f90c-9e27-3b29-146c8e393b49",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3bb8be8f-61e1-840f-4e0c-6e2b0329c971",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "27a77db0-a3d0-ffb6-9258-c1c2074c9be7",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e80c78df-a127-2d8d-60bc-8fb646b952ac",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "38b7ccea-48b0-7c18-2c49-ff5a17580aa5",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e09c75b1-86fa-b386-86fb-4e14c7386e1c",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e63666a4-d893-e406-1ef0-b42decba3846",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f252bd0f-3337-42c8-0cef-a259957135c8",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "d83b1629-fa64-5d96-a049-0ab2549d43aa",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62fdacb4-f875-b857-023c-3a8d48a39723",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "160429b3-b94d-3e59-7e4b-5dbb9468aabc",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "2218a6b9-000b-acca-e751-274e2d688d8f",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "3ca153e7-01d6-248c-3ba2-d7bec064177e",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b9ee09ac-8c87-2ed5-8c7b-e445fe3813e3",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "bd8ed4c3-1f81-67fc-1f70-9a6a83c517cc",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1c6a67fc-8d25-df17-58d8-4ab23ca9d466",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a1a16e9-7349-24b2-6932-7a3ae3378498",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1075e0b4-8efc-fbff-d5e1-044f438cd1e5",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "98228910-e68e-8b0c-ee11-809f3c8aa8d2",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e0201016-9f47-a707-765a-eae1b5e50471",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b46ac118-589a-de57-460a-e97b892b5d13",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a32c472-41aa-93d8-7209-750dd241db1a",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f2ac5885-3565-8174-86b2-e3b25ce3a03d",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f98e53fd-fbad-e205-9605-e1a1688df15a",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "961307f9-927e-47a6-c493-26e901f3b26a",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "eb6a51e2-c389-247f-61a5-9506bf94b2bd",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "417028e7-9314-bab9-d94a-2eeac101941b",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "f0c8e82a-23c5-fa7f-3b46-f4ac728ab9e3",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "e558c8e2-3ae0-2ee4-7716-874b83bb14a4",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "95689c4e-507b-d3ac-173f-a39fec264a6f",
          "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b137e4b-b2a1-ee47-2ae7-47b36e4c2dd9",
          "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1969361-f986-69b9-6382-3cb3bb2d4bb4",
          "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e565af0-2681-4106-90be-aa91f09842b9",
          "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "625db4ca-d2cb-e4ac-db61-0bf5e306b00a",
          "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b52aea0-1929-4c1d-57d3-ce5bffef8755",
          "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47a7f132-b61e-7b8d-fd39-0df8dbec78c7",
          "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridDeployments_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

