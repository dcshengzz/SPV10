-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyRecurrence.json
-- dplyRecurrence-settings.json

UPDATE dwMetadata SET
[Id]='5e580c8a-8a4e-425c-8649-d13f9a83d932', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:31:17.030', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-10-29 14:19:43.160', 
[Data]=N'[
  {
    "key": "frm_Recurrence",
    "data-buildertype": "form",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Recurring Deployment Settings",
        "size": "medium"
      },
      {
        "key": "Name",
        "data-buildertype": "input",
        "label": "Deployment",
        "fluid": true,
        "onChangeTimeout": 200,
        "readOnly": true
      },
      {
        "key": "formgroup_2",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "orientation": "grouped",
        "children": [
          {
            "key": "message_1",
            "data-buildertype": "message",
            "header": "Recurrent Child Deployment",
            "content": "This deployment was created as a recurrence of a parent deployment and may not have its own recurrent settings. Please edit settings on the parent.",
            "other-visibleConition": "",
            "warning": false,
            "info": true
          },
          {
            "key": "container_1",
            "data-buildertype": "container",
            "children": [
              {
                "key": "buttonCancel2",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
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
                "style-marginRight": "20px"
              },
              {
                "key": "buttonOpenParent",
                "data-buildertype": "button",
                "content": "Open Parent Deployment",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "navigateParentDeployment"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "secondary": true
              }
            ],
            "style-width": "100%",
            "style-marginTop": "20px"
          }
        ],
        "other-visibleConition": "!(data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
      },
      {
        "key": "cnt_Content",
        "data-buildertype": "container",
        "children": [
          {
            "key": "RecurrenceEnabled",
            "data-buildertype": "checkbox",
            "label": "Enable Recurring Deployments",
            "toggle": true,
            "other-readOnlyConition": "!(data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
          },
          {
            "key": "fg_RecurrenceSettings",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "RecurrenceFrequency",
                "data-buildertype": "dropdown",
                "label": "Frequency",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "value": "MONTHLY",
                    "text": "Monthly"
                  },
                  {
                    "value": "QUARTERLY",
                    "text": "Quarterly"
                  },
                  {
                    "value": "HALF_YEARLY",
                    "text": "Half Yearly"
                  },
                  {
                    "value": "ANNUALLY",
                    "text": "Annually"
                  },
                  {
                    "value": "BIENNIALLY",
                    "text": "Biennially"
                  }
                ],
                "placeholder": "Select frequency of recurrence",
                "style-width": "300px",
                "other-customValidation": "!data.RecurrenceEnabled || (value!==undefined&&value!==null&&value!==\"\") ? true : \" is required\""
              },
              {
                "key": "RecurrenceEndDate",
                "data-buildertype": "input",
                "label": "Do not recur after",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "date",
                "placeholder": "Select end date",
                "other-customValidation": "!data.RecurrenceEnabled || (data.RecurrenceEnabled && value !== undefined && value !== null && value !== \"\") ? true : \" is required\"",
                "events": {}
              },
              {
                "key": "IsCreateInAdvance",
                "data-buildertype": "checkbox",
                "label": "Create deployment in advance of start date",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleDaysInAdvance"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "fg_CreateInAdvance",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "RecurrenceAdvanceDays",
                    "data-buildertype": "input",
                    "label": "Days in advance of deployment start",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "style-width": "200px",
                    "other-visibleConition": "",
                    "defaultValue": "",
                    "other-customValidation": "(!data.RecurrenceEnabled || (data.RecurrenceEnabled && ( !data.IsCreateInAdvance || (  (value > 0) )   )    ) ) ? true : \"Must be at least one day in advance\""
                  },
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "Note: When the recurrence is created in advance it is necessary to manually open the new deployment before its start date and make it visible to respondents (and to make any other adjustments as desired).",
                    "style-customcss": "ui info message"
                  }
                ],
                "orientation": "grouped",
                "other-visibleConition": "data.IsCreateInAdvance || (data.RecurrenceAdvanceDays > 0)"
              }
            ],
            "other-visibleConition": "data.RecurrenceEnabled && (data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null)"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "btn_Save",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "style-marginRight": "20px",
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "updateRecurrence"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btn_Cancel",
                "data-buildertype": "button",
                "content": "Cancel",
                "secondary": true,
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
                }
              }
            ],
            "style-width": "100%",
            "style-marginTop": "20px",
            "style-marginBottom": ""
          },
          {
            "key": "fg_NextDeployment",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "other-visibleConition": "data.RecurrenceEnabled && !(data.RecurrenceNextDate===undefined || data.RecurrenceNextDate===null)",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Next Deployment Recurrence",
                "size": "small",
                "textAlign": "left"
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Start Date",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "readOnly": true
              },
              {
                "key": "RecurrenceJobId",
                "data-buildertype": "input",
                "label": "Job Id",
                "fluid": true,
                "onChangeTimeout": 200,
                "readOnly": true,
                "style-width": "200px"
              }
            ],
            "orientation": "grouped",
            "style-customcss": "ui info message",
            "style-marginTop": "20px"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "other-visibleConition": "",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Previous Recurrences",
                "size": "small",
                "textAlign": "left"
              },
              {
                "key": "gv_Recurrences",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Deployment",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
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
                "rowKey": "Id",
                "defaultSort": "DateStart DESC",
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
            "orientation": "grouped",
            "style-customcss": "ui info message",
            "style-marginTop": "20px"
          }
        ],
        "other-visibleConition": "data.RecurrenceOfDplyId===undefined || data.RecurrenceOfDplyId===null"
      }
    ],
    "style-width": "800px"
  }
]' WHERE [Id]='5e580c8a-8a4e-425c-8649-d13f9a83d932';

UPDATE dwMetadata SET
[Id]='d95c76fc-a10b-4b34-aba6-6020b42217e0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:31:17.383', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-10-29 14:51:32.067', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyRecurrence",
  "lastUpdate": "2020-10-29T14:51:32.0249555+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "251086a6-9399-d8b4-63e7-ba1660361ce5",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19376db4-1b08-4983-e2ac-f2ea9d640f9a",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9813d5e6-7c04-e009-e4bb-c9b8f3b5d55b",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b4bb55f0-f82f-a93d-1109-219383c4f2d0",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7bcd2347-39ef-0f03-8c32-056da5b73032",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ced0b87-251b-7bc3-3f8a-51918c46cc6f",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b78e117b-2f62-87a1-5b0f-33801efd99df",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7d11d08-5bb9-dff9-3966-83af84286faf",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf119136-969d-1ca7-4650-b8d4917de1f5",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "396d1e83-5c27-6613-b419-5254bba6fdc4",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1bb0899f-2109-768d-ca5c-ce8afcb2060f",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fd4565b-3642-6b97-618e-6d716c89c1f8",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08542a1d-242c-35a8-dda8-740a08ad2092",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5df21c8c-d3de-eae6-051b-5c1db67e1da2",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a38dfee-a00a-7d63-7b9c-bbcb8c5b65bc",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f7880bc4-1c46-937d-7175-5e2efe3d997e",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78b08312-ac0b-8128-f8eb-aeff8cb77a48",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c6ce037-b742-ceb9-3ee5-9a4b3525b2ef",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c71bdf11-1624-1231-5366-3aa0f04dfd0f",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1eba387a-86ab-b769-93c2-19be0af741f2",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d813e036-b7d0-4382-d0ef-4bc92134fc6d",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "578fff01-828f-85a9-873c-6d69de559bec",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f02556a8-6e23-c4f8-ebee-96ffb82edbc3",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0d6c610e-2f7f-2ade-8143-0e9fb356909b",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80c71fa7-f762-a7af-9152-a73ecb9a62da",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "07f82828-f0b9-a585-cad6-16b5b82f6777",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "76f33d11-24ca-0d34-6470-9699d3c96d3f",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "92121ab3-8fb2-dae3-d494-34e196e18c95",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83f70cd0-970e-2165-2a39-6122b4bea908",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5139398a-ef15-65f8-f085-dd0f54f3df2c",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f2632b8-7449-ac57-12b3-06ea9a1e9abf",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a54494d6-7a6c-998b-f242-d6b9b7fb705f",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6b6dc71e-d173-6dc6-d8dc-71403d7baab2",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0bd3e4b8-542a-319f-1614-259e3e8df05c",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89e4b751-39ab-2d39-54bc-96e7091a236f",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4de30b35-9677-359f-b046-bdc28cf3d315",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "99cbb340-27e5-6d7a-b46c-5d04932c8435",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37d9dee-8f1d-6230-a206-35db9adbdc44",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce4a034-4933-414d-c9ac-da209056f06b",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7fc6413c-ed37-ea4a-61f5-336f53656ceb",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9fd860f7-c45f-9737-36a3-9761cba216dd",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f188cf30-c69a-ff10-1bb5-36d18d877607",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "control": "RecurrenceAdvanceDays",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40cabcc7-19e0-b86b-24d4-5dafeb5d15c9",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "control": "RecurrenceEndDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f2de1058-725a-21f3-35ed-4da89bd5cb0a",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "control": "RecurrenceFrequency",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78cc56ee-39fe-9c54-be43-f34b3d3f6aaf",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf1c5389-f718-9d16-3f8a-f07e73892cae",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "control": "RecurrenceEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08dda8b8-790d-48d0-4208-e67f63529dc4",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26f0788a-26d5-8188-10ed-96f51a3effba",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "5ea05b61-68da-691f-85de-92d435d5dc64",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterByModelId",
      "parameter": "{RecurrenceOfDplyId: \"@Id\"}",
      "control": "gv_Recurrences",
      "dataMap": [
        {
          "id": "dbd2ca31-e8c2-80f2-c7a2-f6730f524b52",
          "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e91d7ff4-ceb8-0208-49dd-79b2df16f66f",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5aca1c6-6fb7-41db-ac7e-ea2fc2aea4e2",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cbcabb25-3cfa-26f9-3db3-06d7cb632edd",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f14bdb5-5a89-06eb-e653-6c5e4dc75174",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11383080-2bff-f6f0-324a-4b12e8837ae2",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c766d920-5208-43b5-aac3-332f9893b213",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a8ef1c50-8e6c-3978-ee1f-5877c0ddd37c",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6351e09e-1fd6-d846-c41b-7f1ea965ae5b",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e79adbe7-4448-ccfc-18d5-86b4778ce111",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb8163d6-7c68-5419-9b21-ee2b340fb74b",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae812efb-32d6-a497-df76-5db272213a91",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "46fbbb0c-a6b6-5592-0b7a-4e9fa7192ffc",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14935a6a-b667-8145-58ce-cb2470d95e41",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dbfefdc3-c033-4d72-ae74-3cd0f141134c",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69c5491e-fd30-14cf-1055-4beb1aaa46cf",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ff15a20-ea53-707e-2def-b81681bd6bdb",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf7c684d-c238-6c19-d5a4-1a34ddc6a275",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d2143ebf-9642-60e4-e856-420f20261e2c",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "776e0c0d-0262-5407-f045-1924e5107852",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff4e4aba-6994-ac95-c55e-5055fe42d18b",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d7adab5-714b-ef27-8768-1292cc7e6c92",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60f24e99-75da-56ce-ed74-9dd4e862d1d2",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "016c131e-ec57-a7f4-22f5-90f50e065a34",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9ec6c2d5-aefc-0abd-5657-40f99730a23f",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4a0fb874-914e-4631-aba1-81006e5d216e",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab81cba1-59fb-30f5-323c-ab61f9bfd383",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6c3b3401-3606-c89d-c154-567ad76a46d6",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b6d44a9-7c08-3bd0-fe80-02f5249b8870",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b0805e99-8971-14b5-4f07-21a861e8bf46",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fb4e3217-411e-61c9-984c-43dfcc374e32",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4477254a-8846-4fce-8112-db21b87d47fd",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fb92a2af-fcba-baaf-ce09-797007fe4f3c",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c100932d-c98e-6a39-1de3-94e922e24b1c",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8f2e49dd-3806-103a-bf3e-17afea2f9d3f",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4b07b6d5-b0ea-b769-11e1-75ef32595aad",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "994fecdc-2a81-1790-3da3-24b50cf08b8b",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfcb88c1-3cdc-b2f3-9fd3-22bf1464e58f",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "18fe52dc-9c0a-797f-0688-cfec218dbd7e",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09f65613-284b-4bc8-45a4-910b2538f682",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d0e8347-ecc6-9ede-3b7b-16e1ae0960a9",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e2fa299c-229e-c3c9-e58c-33a8292f5374",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ae7ad15-0775-61d4-c42d-09d76e5b7f7c",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5874f7a1-4f95-8230-249c-691fd944dd55",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "667cb25b-81a3-55c9-6b70-d353743f6cc2",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a4a6499-c5dd-749f-e700-338ea1555b43",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "caef425b-9d21-0365-8e1f-95ad118e9f4c",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb460600-33cc-ab13-0e44-d46a46ce6fbe",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='d95c76fc-a10b-4b34-aba6-6020b42217e0';

