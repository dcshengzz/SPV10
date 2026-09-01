-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMaintenance.json
-- dplyMaintenance-settings.json
-- dplyMaintenance-code.js
-- base.json

UPDATE [dwMetadata] SET
[Id]='967fd08d-4fee-4d24-ac0e-afe1dca6abbf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:03:40.110', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-26 13:22:21.820', 
[Data]=N'[
  {
    "key": "frm_Recurrence",
    "data-buildertype": "form",
    "children": [
      {
        "key": "formgroup_2",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "orientation": "grouped",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment Maintenance",
            "size": "medium"
          },
          {
            "key": "fg_Details",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "Name",
                "data-buildertype": "input",
                "label": "Deployment",
                "fluid": true,
                "onChangeTimeout": 200,
                "readOnly": true
              },
              {
                "key": "StructDivisionId",
                "data-buildertype": "dictionary",
                "label": "Organisation",
                "fluid": true,
                "selection": true,
                "columns": "Name ASC",
                "readOnly": true,
                "dataModel": "StructDivision"
              },
              {
                "key": "formgroup_3",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "formgroup_4",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "orientation": "inline",
                    "children": [
                      {
                        "key": "CreatedBy",
                        "data-buildertype": "dictionary",
                        "label": "Created By",
                        "fluid": true,
                        "selection": true,
                        "dataModel": "dwSecurityUser",
                        "columns": "Name ASC",
                        "readOnly": true,
                        "style-width": ""
                      },
                      {
                        "key": "CreatedDate",
                        "data-buildertype": "input",
                        "label": "Created Date",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "type": "datetime",
                        "readOnly": true
                      }
                    ],
                    "style-width": ""
                  },
                  {
                    "key": "formgroup_5",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "orientation": "inline",
                    "children": [
                      {
                        "key": "UpdatedBy",
                        "data-buildertype": "dictionary",
                        "label": "Updated By",
                        "fluid": true,
                        "selection": true,
                        "dataModel": "dwSecurityUser",
                        "columns": "Name ASC",
                        "readOnly": true,
                        "style-width": ""
                      },
                      {
                        "key": "UpdatedDate",
                        "data-buildertype": "input",
                        "label": "Updated Date",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "type": "datetime",
                        "readOnly": true
                      }
                    ],
                    "style-source": "",
                    "style-marginLeft": ""
                  }
                ],
                "orientation": "grouped",
                "style-width": ""
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;"
          },
          {
            "key": "fg_BackDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "Backdate Deployment",
                "content": "Use this function to forcibly modify deployment start and end dates without the usual validation checks. ",
                "info": true
              },
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "DateStart",
                    "data-buildertype": "input",
                    "label": "DateStart",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "300px",
                    "type": "datetime"
                  },
                  {
                    "key": "DateEnd",
                    "data-buildertype": "input",
                    "label": "DateEnd",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "300px",
                    "type": "datetime"
                  }
                ]
              },
              {
                "key": "btnApplyDates",
                "data-buildertype": "button",
                "content": "Apply Dates",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "confirm",
                      "applyDates"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "other-visibleConition": ""
          },
          {
            "key": "fg_ImportResponses",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_responseImport",
                "data-buildertype": "message",
                "header": "Response Import Upload",
                "content": "Select a csv file with the previously exported response data to transfer to the server. A background job will immediately (NO CONFIRMATION DIALOG!) be queued to process the data file on the server and you will be notified of the outcome by email.",
                "info": true
              },
              {
                "key": "ResponseUpload",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "file",
                "other-visibleConition": ""
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "other-visibleConition": "data.ResponseUpload == null || data.ResponseUpload == \"\""
          },
          {
            "key": "formgroup_6",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_2",
                "data-buildertype": "message",
                "header": "Purge Responses",
                "content": "Proceed with care. This function will reset all the responses to this deployment ({Name})",
                "info": true,
                "warning": false
              },
              {
                "key": "EnablePurgeResponsesButton",
                "data-buildertype": "checkbox",
                "label": "Enable button",
                "slider": false,
                "toggle": true,
                "fitted": false
              },
              {
                "key": "btnPurgeResp",
                "data-buildertype": "button",
                "content": "Delete all Responses",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "purgeResponses"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-readOnlyConition": "!Utils.isSelected(data.EnablePurgeResponsesButton)"
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "other-visibleConition": ""
          },
          {
            "key": "container_1",
            "data-buildertype": "container",
            "children": [
              {
                "key": "buttonCancel",
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
              }
            ],
            "style-width": "100%",
            "style-marginTop": "20px"
          }
        ],
        "other-visibleConition": ""
      }
    ],
    "style-width": "800px"
  }
]' WHERE [Id]='967fd08d-4fee-4d24-ac0e-afe1dca6abbf';

UPDATE [dwMetadata] SET
[Id]='6a20fa57-ecb9-407a-801c-6e8b8e4f7c86', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:03:40.190', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-26 13:22:21.873', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMaintenance",
  "lastUpdate": "2024-07-26T13:22:21.8626679+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "30fff897-0852-9a41-af0a-a2a0e7744714",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4f8bf651-43bf-b341-9dff-b33e99f8fd3e",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "75882ba0-2e94-2e2b-47da-878266fda684",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "control": "CreatedBy",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83dc525c-8995-7239-f10f-1343c67df312",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "592127cf-a388-c628-ee78-11ddbb41231a",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b7d9c581-f387-b0b5-8fb6-26f524b79b7c",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9f5daec-88d1-e874-7239-b1dcac34aa92",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c617b481-5a9b-4b98-9583-81b7b1296b85",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9cfaece-d8d7-b454-565c-52141516bc23",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff2fdc68-da86-9d47-fb3b-35f6f7718e6f",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "21ecc0e8-0a9c-d0af-3632-3ba89b0d447b",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ad33d0df-bcaf-f2f3-8a31-a2b91f8a1efb",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1df8835b-13a7-0ea2-6157-4685655fdd79",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4275115c-30ca-b0e3-42cb-d834c5e4251f",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae0d204a-6ce1-c712-6dd6-c5ddf3a2b49b",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ce1e08f-c26f-548a-48c7-4e157989731d",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d791079c-90e3-e4a7-efb8-b3d47f763a29",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b74b7842-eff5-9ca1-84a5-28e334fd05f2",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a20969e3-ed82-e4ae-37d0-6b858192c9b3",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3396c2ab-daaa-4378-d243-368cab0ab27b",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b9fb2e1d-e618-e837-8b3a-6016b6c3b886",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "293af653-ab2e-fb57-e4e8-ef87c3b0ffa1",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "02f3c60b-ede2-162b-8ccf-536bfc53383e",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a063a561-1fc1-f276-7892-9ab7bb323553",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1584daa4-f89b-3da9-cdb3-b3fdd3e8f5d6",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8fd980d8-5217-7e1e-5c34-df805924be79",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "49c60ded-e1e8-905f-49ac-ed43abdd7465",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8adab067-5180-27f4-1047-67ae9b072034",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8e070916-a785-bfb5-1f7c-11bce8b9c881",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26b9b829-392c-f5f2-8431-c40edf2e4974",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "afde7541-673e-7784-00c7-3cd00d238fc5",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f614787a-96c3-39ee-310c-3d06120ad530",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ce0d43f-34b0-2c9f-200e-9fe65568d1ef",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25f64417-deea-ba62-e8bc-0d86b1df1af4",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5f8bb1b8-341a-d262-9d1e-e79c838eab20",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "18830bd9-0838-0460-e535-286806c5896e",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bae872e-38cd-1f59-8aca-a8cd9e1e6cc0",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a5caa201-8eb0-9c70-2e59-271eb1eadc13",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d4a2909-e3cc-e5bd-78e4-62602dfd8a79",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fc37bf41-08e1-a66a-1073-4c14502439af",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25c9e1b2-75e2-6377-86ee-0c424115ada7",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f6b07494-f19f-b535-ef9d-3f70c2056626",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "13689b41-499b-6dd6-28ce-df9805b583ea",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "96dc2e10-e9da-cb52-9d36-48658431b4f4",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a4b9e65e-ce78-be19-8ec0-1adab2df9df1",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f1fc83cd-40b2-0ee7-88ba-58908dfe8f69",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54f0e250-c2de-5339-d4cc-7d06f983b9fc",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb7f315d-621f-1335-7602-2ec70386eb9f",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f68765bd-dacb-1f98-7957-61c30ee95210",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bae9d2c5-2498-e839-355a-c8a393e0b47f",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e8752d-8d8a-0fcd-3e4f-d72dd8f00cff",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a0b472fd-dbd2-9ee8-409e-d6b9dd7337c8",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cc6bb0b7-f982-ccab-a1f0-32d306a8c916",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89757337-d4de-554a-e973-a157a644c319",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4b705b63-103f-dc09-ae17-6c7e7176f731",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dbf8c902-3e92-90d6-dc2c-32000ccd723d",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f9193f35-fcc2-4993-9145-21a4785338d9",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "821b39f0-066f-9e40-8c08-d703d45e5e48",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c17ccaa2-5e0f-7801-135b-e5f71b4efc69",
      "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "472250fa-1ffe-7cde-2d87-1be41091ec0e",
      "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7bb2aea-79ce-5632-3b75-45e64c6aa4c7",
      "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b80cee3a-8cb4-b72b-75ba-74a89e47c0c4",
      "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d98e554-ad5b-4913-5fc1-7ac95c2cfc34",
      "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5f1f82b-260c-4617-b457-0a2576638d40",
      "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f5e260f-f5e0-2d52-3352-e46c338f930b",
      "attributeId": "595da6d0-43c2-4faf-8b64-242a5e2a9c10",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Admins"
}' WHERE [Id]='6a20fa57-ecb9-407a-801c-6e8b8e4f7c86';

UPDATE [dwMetadata] SET
[Id]='0c290d6f-5456-4ab4-913f-12cd3a456147', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:04:38.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-26 12:51:39.907', 
[Data]=N'{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("ResponseUpload", model => {
            model.customPostUrl = "/deployment/import/responseupload/" + encodeURIComponent(dplyId);
            model.onUploadBegin = () => Utils.loadingStart("Transferring file...");
            model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                //console.log("ctrl", ctrl, "success", success, "xhr", xhr, "msg", msg, "err", err);
                Utils.loadingStop();
                if(!success) {
                    console.log("Upload failed", xhr, msg, err);
                    if(xhr.status=== 400) {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + xhr.statusText + " - " + xhr.responseText), 25000);
                    } else if(xhr.status===413) {
                        alertify.error("Upload Failed - the selected file is too large to be uploaded here", 25000);
                    } else {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + msg + " - " + err), 25000);
                    }
                } else {
                    console.error(xhr.message);
                    if("OK" == xhr.message) {
                        alertify.success("File transferred to server, you will be notified by email when processing is complete", 20000);
                    } else if("FAIL" == xhr.message) {
                        alertify.error("Failed to transfer the file to the server.", 25000);
                    } else {
                        alertify.error("This file is not valid. Please check that you have the correct file.", 25000);
                    }
                }
            }
        });  
    },
    
    applyDates: function(args) {
        const dplyId = args.data.Id;
        const dateStart = new Date(args.data.DateStart).toISOString();
        const dateEnd = new Date(args.data.DateEnd).toISOString();
        console.log("dateStart", dateStart, "dateEnd", dateEnd);
        const form = new FormData();
        form.append("dplyId", dplyId);
        form.append("dateStart", dateStart);
        form.append("dateEnd", dateEnd);
        Utils.loadingStart("Saving the date...");
        Utils.postFormRequest("/deployment/maintenance/applyDates", form).then(
            response => { 
                alertify.success("Dates updated",20000);
                window.setTimeout(()=>{window.location=window.location},1000);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 25000);
                Utils.loadingStop();
            }
        )
    },
    
    purgeResponses: function(args) {
        const isEnabled = args.data.EnablePurgeResponsesButton;
        if(!isEnabled) {
            alertify.error("Purge responses button is not enabled");
            return {};
        }
        const dplyId = args.data.Id;
        const message = { 
            parameters: { 
                confirmTitle: "purgeRespConfirmTitle", 
                confirmText: "purgeRespConfirmText", 
                confirmOk: "purgeRespConfirmOk"
        } };
        CloverApp.API.confirm(message).then(()=> {
            const form = new FormData();
            form.append("dplyId", dplyId);
            Utils.loadingStart("Purging responses...");
            Utils.postFormRequest("/deployment/maintenance/purgeresponses", form).then(
            response => { 
                    alertify.success(Utils.encodeHTML(response.message),20000);
                    CloverApp.API.setDataField("EnablePurgeResponsesButton", false);
                    //TODO - update readOnly for the button
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason), 25000);
                }
            ).finally(Utils.loadingStop);
        });
    },
    
}' WHERE [Id]='0c290d6f-5456-4ab4-913f-12cd3a456147';

UPDATE [dwMetadata] SET
[Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/localization', [FileName]=N'base.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:10.700', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-26 13:16:07.433', 
[Data]=N'{
  "common": {
    "dateFormat": "DD MMM YYYY",
    "timeFormat": "HH:mm",
    "datetimeFormat": "DD MMM YYYY HH:mm"
  },
  "msg": {
    "deleteAllSampleAssignmentTitle": "Remove ALL Sample Assignments",
    "deleteAllSampleAssignmentText": "This will delete ALL the DataEditor assignments for this deployment. Proceed?",
      
    "addSampleConfirmTitle": "Add List Samples",
    "addSampleConfirmText": "Are you sure you want to add new samples from the list to this deployment?",
    
    "submitSurveyConfirmTitle": "Survey Submission",
    "submitSurveyConfirmText": "Are you sure you want to submit survey?",
    
    "deleteListSamplesConfirmTitle": "Remove List Samples from Sample List",
    "deleteListSamplesConfirmText": "WARNING: Removing the samples from this list will also delete all their related data in deployments that use this list INCLUDING RESPONSE DATA. Are you absolutely sure you want to continue?", 
    
    "deleteSampleListConfirmTitle": "Delete Sample List & Associated Records",
    "deleteSampleListConfirmText": "WARNING: Deleting a Sample List will also immediately delete all deployments that use it INCLUDING RESPONSE DATA",
    "deleteSampleListConfirmOk": "Delete List",
    
    "deletionConfirmTitle": "Deletion Confirmation",
    "deletionConfirmText": "All the data related with selected records will be deleted. Are you sure you want to continue?",
    
    "deleteSampleConfirmTitle": "Delete Samples",
    "deleteSampleConfirmText": "WARNING: ALL the data related with selected samples will be deleted, INCLUDING RESPONSE DATA, sample list properties and etc. Are you absolutely sure you want to continue?",    
    
    "disableSamplesConfirmTitle": "Disable Samples",
    "disableSamplesConfirmText": "The selected sample''s status will be set to inactive in this list, making them inactive in deployments using this list (existing response data will NOT be deleted and you can re-enable them later). Continue?",  
    
    "createDplyConfirmTitle": "Create deployment?",
    "createDplyConfirmText": "Please confirm that you are ready to continue with the deployment record creation now. (Note: Certain deployment settings may only be specified before creating the deployment record and are not subsequently adjustable)",
    
    "resetResponseConfirmTitle": "Confirm Reset Response",
    "resetResponseConfirmText": "Click Reset to delete the answers for this response and set its status back to Pending",
    "resetResponseConfirmOk": "Reset",
    
    "setStatusConfirmTitle": "Confirm Change Status",
    "setStatusConfirmText": "This will change the response status. Continue?",
    
    "exemptConfirmTitle": "Set Exempted Status",
    "exemptConfirmText": "This will change the response status to Exempted. (The respondent will still be able to access the survey if it is visible to respondents)",
    "exemptConfirmOk": "Exempt",
    
    "deleteSampleAssignmentTitle": "Remove Selected Sample Assignments",
    "deleteSampleAssignmentText": "This will delete the DataEditor assignments for this deployment. Proceed?",
    
    "purgeRespConfirmTitle": "Purge Responses",
    "purgeRespConfirmText": "This will delete all responses for this deployment. Their response data (answers) will be deleted, their status set back to pending and editor remarks cleared. Proceed?",
    "purgeRespConfirmOk": "PURGE",
  },
  "forms": {
    "CategoryList": {
      "pageHeader_content": "List",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "searchField_label": ""
    },
    "DataEditorDeployment": {
      "Name_content": "{Name}",
      "remarks_label": "Remarks",
      "button_1_content": "Submit",
      "grid_UID": "UID (Name)",
      "grid_DateStart": "Date Start",
      "grid_DateComplete": "Date Complete",
      "grid_ActiveYN": "Active",
      "grid_CreatedDate": "",
      "grid_Remarks": "Remarks",
      "dropdownStatus_label": "Dropdown",
      "button_2_content": "Cancel",
      "grid_PeerUID": "Peer UID (Name)",
      "grid_StatusTitle": "Status",
      "grid_Actions": "Actions",
      "grid_Actions2": ""
    },
    "DataEditorDeploymentList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "dictionary_1_label": "Category",
      "input_1_label": "Filter",
      "grid_Name": "Name",
      "grid_StatusText": "Status",
      "grid_Title": "Questionnaire",
      "grid_Category": "Category",
      "grid_DateEnd": "Date End",
      "grid_Responses": "Responses",
      "grid_CategoryId": "",
      "refreshChart_content": "Refresh",
      "grid_QnnType": "Type"
    },
    "DEDplys": {
      "gridview_1_Id": "ID",
      "gridview_1_Name": "Name",
      "gridview_1_ListId_Name": "List"
    },
    "DocumentEdit": {
      "btnOpenWorkflowDesigner_content": "Open in Workflow Designer",
      "name_label": "Name",
      "managerId_label": "Manager",
      "number_label": "Number",
      "amount_label": "Money amount (Must be more 0!)",
      "author_label": "Author",
      "stateName_label": "State",
      "comment_label": "Comment",
      "header_1_content": "Document''s Transition History",
      "gridHistory_from": "From",
      "gridHistory_to": "To",
      "gridHistory_command": "Command",
      "gridHistory_executor": "Executor",
      "gridHistory_TransitionTime": "Date",
      "gridHistory_availiablefor": "Availiable for",
      "save_content": "Save",
      "saveexit_content": "Save & Exit"
    },
    "Documents": {
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "btnRefresh_content": "Refresh",
      "button_1_content": "Export",
      "inputSearch_label": "",
      "grid_number": "#",
      "grid_stateName": "State",
      "grid_name": "Name",
      "grid_comment": "Comment",
      "grid_author": "Author",
      "grid_manager": "Manager",
      "grid_amount": "Amount"
    },
    "footer": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "header": {
      "currentUser_/admin": "Admin panel",
      "currentUser_/form/settings": "Settings",
      "currentUser_/account/logoff": "Logout"
    },
    "qnns": {},
    "QNN_AUDIT_TRAIL": {
      "AuditAction_label": "AuditAction",
      "ChangeDate_label": "ChangeDate",
      "ModuleCode_label": "ModuleCode",
      "NumberId_label": "NumberId",
      "Ref_Id_label": "Ref_Id",
      "Ref_Name_label": "Ref_Name",
      "UserId_label": "UserId",
      "UserName_label": "UserName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY": {
      "header_1_content": "Deployments",
      "buttonManageListSamples_content": "Manage List Samples",
      "buttonManageDataEditors_content": "Manage Data Editors",
      "btnCancel_content": "Cancel",
      "btnSave_content": "Save",
      "headerBasicProperties_content": "Basic Properties",
      "textName_label": "Name",
      "dictCategory_label": "Category",
      "dictQuestionnaire_label": "Questionnaire",
      "dictList_label": "List",
      "DateStart_label": "Start On",
      "DateEnd_label": "End On",
      "headerCompletionProperties_content": "Completion  Properties",
      "textCompleteURL_label": "",
      "hedderNavigationProperties_content": "Navigation Properties",
      "textNavCancelUrl_label": "",
      "headerResponseProperties_content": "Response Properties",
      "MaxResponse_label": "Maximum Number of Responses",
      "DaysUpdate_label": "Days for Update",
      "button_1_content": "Manage List Samples",
      "button_2_content": "Manage Data Editors",
      "button_3_content": "Cancel",
      "button_4_content": "Save",
      "buttonManageMessageHistory_content": "Manage Message History",
      "header_2_content": "Initial Notification Type",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject"
    },
    "QNN_DPLY_MSG": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "DplyId_label": "DplyId",
      "DplyStep_label": "DplyStep",
      "EmailBCC_label": "EmailBCC",
      "EmailCC_label": "EmailCC",
      "EmailFrom_label": "EmailFrom",
      "EmailSubj_label": "EmailSubj",
      "GenerateDateTime_label": "GenerateDateTime",
      "GenerateQnnYN_label": "GenerateQnnYN",
      "IsDeleted_label": "IsDeleted",
      "MsgContent_label": "MsgContent",
      "NotifyEmail_label": "NotifyEmail",
      "NotifyGenerate_label": "NotifyGenerate",
      "NotifyMerge_label": "NotifyMerge",
      "NumberId_label": "NumberId",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_MSG_SAMPLE": {
      "CreatedDate_label": "CreatedDate",
      "DplyMsgId_label": "DplyMsgId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_DUEDATE": {
      "DplyId_label": "DplyId",
      "DueDate_label": "DueDate",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_INFO": {
      "DispatchInd_label": "DispatchInd",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "ProcessEditInd_label": "ProcessEditInd",
      "ProcessValidInd_label": "ProcessValidInd",
      "Remarks_label": "Remarks",
      "RemarksModifyBy_label": "RemarksModifyBy",
      "RemarksModifyOn_label": "RemarksModifyOn",
      "ReturnInd_label": "ReturnInd",
      "Status_label": "Status",
      "StatusModifyBy_label": "StatusModifyBy",
      "StatusModifyOn_label": "StatusModifyOn",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_OWNER": {
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_LIST": {
      "bcList_1": "List",
      "bcList_2": "Manage List",
      "headerName_content": "Manage {nameInput}",
      "headerName_subheader": "",
      "headerProperties_content": "Properties",
      "nameInput_label": "List Title",
      "headerDescription_label": "List Description",
      "dictionaryCategory_label": "Category Name",
      "toggleStatus_label": "Status",
      "headerUser_content": "Records User Control",
      "toggleEditName_label": "Edit Name",
      "toggleEditEmail_label": "Edit Email",
      "togglePassword_label": "Edit Password",
      "btnSaveR_content": "Save & Review",
      "btnSave_content": "Save",
      "btnCancel_content": "Cancel",
      "headerRecords_content": "Records ",
      "btnCreate2_content": "Create",
      "btnDelete_content": "Delete",
      "header_5_content": "Import Sample",
      "header_5_subheader": "CSV Format.. ",
      "button_7_content": "Create",
      "button_8_content": "Cancel",
      "button_1_content": "Export",
      "btnRefresh_content": "Refresh",
      "headerCount_content": "Total Count: {__collectioneditor_sample_totalcount}",
      "gridviewSample_Id": "ID",
      "gridviewSample_Name": "Title",
      "gridviewSample_Email": "Email",
      "collectioneditor_sample_UID": "UID",
      "collectioneditor_sample_Name": "Name",
      "collectioneditor_sample_Email": "Email",
      "collectioneditor_sample_NumRetry": "NumRetry",
      "collectioneditor_sample_Pwd": "Password",
      "collectioneditor_sample_ActiveYN": "Active",
      "collectioneditor_sample_PwdResetYN": "PwdResetYN",
      "collectioneditor_1_Alias": "Alias",
      "collectioneditor_1_ReqdYN": "Reqd",
      "collectioneditor_1_UsrEditYN": "UsrEdit",
      "collectioneditor_1_TxtRow": "TxtRow",
      "collectioneditor_1_TxtRegExp": "TxtRegExp",
      "collectioneditor_1_TxtRegExpErr": "TxtRegExpErr",
      "inputPassword_label": "Password",
      "inputImportListSample_label": "",
      "headerSampleAdded_content": "Sample Added: {sampleAddedCount}",
      "headerSampleUpdated_content": "Sample Updated: {sampleUpdatedCount}",
      "headerListSampleAdded_content": "List Sample Added: {listSampleAddedCount}",
      "headerListSampleUpdated_content": "List Sample Updated: {listSampleUpdatedCount}",
      "gridviewSample_UID": "UID",
      "gridviewSample_PeerUID": "Peer UID",
      "gridviewSample_PeerName": "Peer Name",
      "provideNameToDownload": "You may provide another preferred name, click OK to download",
      "provideName": "Please provide a name."
    },
    "QNN_LIST2": {
      "Name_label": "Name",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "qnn_lists": {
      "button_1_content": "Delete"
    },
    "QNN_LIST_REVIEW": {
      "dictionary_1_label": "List Name",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "button_1_content": "Cancel",
      "searchField2_label": ""
    },
    "QNN_LIST_SAMPLE": {
      "header_1_content": "Manage Sample",
      "DictionaryListName_label": "List Title",
      "Name_label": "Name",
      "Email_label": "Email",
      "UID_label": "Username",
      "UIDPeer_label": "UIDPeer",
      "Pwd_label": "Password",
      "ActiveYN_label": "Status",
      "PwdResetYN_label": "Password Reset",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "dictionarySample_label": "Sample",
      "dictionarySamplePeer_label": "Sample Peer"
    },
    "QNN_QNN": {
      "Alias_label": "Alias",
      "CategoryId_label": "CategoryId",
      "Status_label": "Status",
      "Title_label": "Title",
      "collectioneditor_1_Name": "Name",
      "collectioneditor_1_Token": "File",
      "collectioneditor_1_Language": "Language",
      "collectioneditor_1_Remarks": "Remarks",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "button_1_content": "Generate Qnn Fields",
      "header_1_content": "Questionnaire",
      "Type_label": "Type",
      "collectioneditor_2_Name": "Form Name",
      "collectioneditor_2_Language": "Language",
      "collectioneditor_2_Remarks": "Remarks"
    },
    "QNN_QNN_ENTITY": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "IsDeleted_label": "IsDeleted",
      "Language_label": "Language",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "Remarks_label": "Remarks",
      "Token_label": "Token",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_FIELD": {
      "Name_label": "Name",
      "QnnId_label": "QnnId",
      "ReadOnly_label": "ReadOnly",
      "Required_label": "Required",
      "Type_label": "Type",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW": {
      "QnnId_label": "QnnId",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW_FILES": {
      "Name_label": "Name",
      "NumberId_label": "NumberId",
      "ReviewId_label": "ReviewId",
      "Size_label": "Size",
      "token_label": "token",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP": {
      "DateComplete_label": "DateComplete",
      "DateStart_label": "DateStart",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "RespIp_label": "RespIp",
      "Score_label": "Score",
      "TimeTook_label": "TimeTook",
      "UpdatedDate_label": "UpdatedDate",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP_ADMIN": {
      "Name_label": "Title",
      "Type_label": "Type",
      "StartDate_label": "StartDate",
      "EndDate_label": "EndDate",
      "Status_label": "Status",
      "btnSave_content": "Save",
      "button_2_content": "Save Editor",
      "button_1_content": "Fetch Editor State",
      "btnExit_content": "Cancel",
      "header_2_content": "Respondent Content Management"
    },
    "QNN_RESP_ANS": {
      "AnsBin_label": "AnsBin",
      "AnsVal_label": "AnsVal",
      "NumberId_label": "NumberId",
      "QnnFieldId_label": "QnnFieldId",
      "RespId_label": "RespId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_STATUS": {
      "Active_label": "Active",
      "Code_label": "Code",
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "Description_label": "Description",
      "HasRespYN_label": "HasRespYN",
      "NumberId_label": "NumberId",
      "Title_label": "Title",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "respdashboard": {
      "gridview_1_DplyName": "Name",
      "gridview_1_QnnTitle": "Questionnaire",
      "gridview_1_DplyDateStart": "Survey Start",
      "gridview_1_DplyDateEnd": "Survey End",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "header_1_content": "Respondent Home",
      "header_2_content": "Current Surveys",
      "grid_QnnTitle": "Survey Name",
      "grid_Type": "Type",
      "grid_PeerName": "Peer",
      "grid_DplyDateStart": "Launched On",
      "grid_DueDate": "Due On",
      "grid_RespDateStart": "Responded On",
      "grid_RespDateEnd": "Submitted On",
      "grid_Password": "Password",
      "header_3_content": "Previous Surveys",
      "gridview_QnnTitle": "Survey Name",
      "gridview_Type": "Type",
      "gridview_PeerName": "Peer",
      "gridview_DplyDateStart": "Launched On",
      "gridview_DueDate": "Due On",
      "gridview_RespDateStart": "Responded On",
      "gridview_RespDateEnd": "Submitted On",
      "gridview_Password": "Password",
      "password_label": "",
      "btnClose_content": "OK"
    },
    "resplogin": {
      "login_label": "Respondent Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login",
      "breadcrumb_1_1": "Forgot Password"
    },
    "Settings": {
      "header_1_content": "Workflow",
      "button_1_content": "Manage workflow schemes",
      "header_3_content": "Roles",
      "btnRoles_content": "Manage roles",
      "header_2_content": "StructDivisions",
      "structdivision_name": "Name",
      "structdivision_roles": "Roles"
    },
    "sidemenu": {
      "sidemenu_/form/SwzQnnList": "Questionaires",
      "sidemenu_/form/SwzListList": "List",
      "sidemenu_/form/SwzDplyList": "Deployment",
      "sidemenu_/form/DataEditorDeploymentList": "Data Editor",
      "sidemenu_/form/SwzCategoryList": "Category",
      "sidemenu_/form/SwzQnnList/": "Questionaires",
      "sidemenu_/surveydesigner": "Survey Designer",
      "sidemenu_/form/SwzRespAdminList": "Respondent Content Management"
    },
    "spfooter": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "spheader": {
      "currentUser_/form/respsettings": "Settings",
      "currentUser_/resp/logoff": "Logout",
      "currentUser_/form/respdashboard": "Home",
      "currentUser_/form/RespAccountChangePassword": "Settings"
    },
    "sptop": {},
    "SwzCategoryList": {
      "header_1_content": "Categories",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridCategory_Name": "Name"
    },
    "SwzDataEditor": {
      "header_1_content": "Samples",
      "buttonCancel_content": "Cancel",
      "buttonSave_content": "Save",
      "gridviewListSamples_ReturnInd": "Return",
      "gridviewListSamples_ProcessValidInd": "Validation",
      "gridviewListSamples_ProcessEditInd": "Editing"
    },
    "SwzDataEditorList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "buttonDelete_content": "Delete",
      "buttonAddDataEditor_content": "Add",
      "gridviewDeployments_Name": "Name",
      "gridviewDeployments_Status": "Status",
      "gridviewDeployments_QnnId_Title": "Questionnaire",
      "gridviewDeployments_ListId_Name": "List",
      "gridviewDeployments_CategoryId_Name": "Category"
    },
    "SwzDplyList": {
      "header_2_content": "Deployments",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridview_1_Name": "Name",
      "gridview_1_Status": "Status",
      "gridview_1_QnnId_Title": "Questionnaire",
      "gridview_1_ListId_Name": "List",
      "gridview_1_CategoryId_Name": "Category",
      "gridview_1_QnnId_Type": "Type",
      "gridview_1_CreatedDate": "Date Created"
    },
    "SwzListList": {
      "pageHeader_content": "List",
      "button_3_content": "Export",
      "btnCreate_content": "Create",
      "header_1_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "inputSearch_label": "",
      "grid_Name": "Name",
      "grid_Category": "Category",
      "grid_SampleCount": "No. Of Records",
      "grid_UpdatedDate": "Date Modified",
      "grid_Status": "Status"
    },
    "SwzQnnList": {
      "header_1_content": "Questionnaire",
      "btnCreate2_content": "Create",
      "header_2_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "button_3_content": "Delete",
      "gridview_1_Title": "Name",
      "gridview_1_Type": "Type",
      "gridview_1_Status": "Status"
    },
    "SwzRespAdminList": {
      "header_1_content": "Respondent Content Management",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete"
    },
    "SwzReviewList": {
      "pageHeader_content": "Reviews",
      "List_content": "List Name: {Listname}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "Save_content": "Save",
      "cancelbu_content": "Cancel",
      "button_1_content": "Export",
      "header_1_content": "Total Count: {__review_gridview_totalcount}"
    },
    "SwzReviewQnn": {
      "header_1_content": "Reviews",
      "Questionnaire_content": "Questionnaire: {Title}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "button_2_content": "Save",
      "button_3_content": "Cancel",
      "button_1_content": "Export",
      "header_2_content": "Total Count: {__swzgridview_1_totalcount}"
    },
    "test": {
      "button_1_content": "Button"
    },
    "top": {},
    "login": {
      "login_label": "Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login"
    },
    "Job": {
      "Arguments_label": "Arguments",
      "CreatedAt_label": "CreatedAt",
      "ExpireAt_label": "ExpireAt",
      "InvocationData_label": "InvocationData",
      "StateId_label": "StateId",
      "StateName_label": "StateName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyListSample": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage list of samples specific to this deployment",
      "txtFilter_label": "",
      "input_1_label": "Filter Due Date  >=",
      "input_5_label": "Filter Due Date  <=",
      "dueDate_label": "Due Date",
      "button_5_content": "Submit",
      "input_2_label": "Filter Generated Date  >=",
      "input_3_label": "Filter Generated Date  <=",
      "btnResetPassword_content": "Reset Password",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject",
      "button_2_content": "Submit",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_DueDate": "Due Date",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Respponse End",
      "gridview_1_CreatedDate": "Generated On",
      "button_1_content": "Add New List Sample",
      "button_4_content": "Manage Message History",
      "button_3_content": "Back"
    },
    "TestControllsForSurveyForm": {
      "header_1_content": "Name: {input_1}",
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "input_4_label": "Input",
      "input_6_label": "Input",
      "button_1_content": "Button"
    },
    "TestControllsForSurveyForm_table": {
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "button_1_content": "Button"
    },
    "Server": {
      "Data_label": "Data",
      "LastHeartbeat_label": "LastHeartbeat",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "test123": {},
    "RespAccountChangePassword": {
      "header_1_content": "Please enter your new password",
      "oldPassword_label": "Old Password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "tableForm": {},
    "AggregatedCounter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testCustom2": {
      "input_112_label": "Input",
      "button_1_content": "Button"
    },
    "RespResetPasswordSuccess": {
      "header_1_content": "Check email for reset password link.",
      "btnSubmit_content": "Resend",
      "button_1_content": "Cancel"
    },
    "testForm": {
      "input_1_label": "Input"
    },
    "Hash": {
      "ExpireAt_label": "ExpireAt",
      "Field_label": "Field",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testrequired": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "testCustom": {},
    "RespResetPassword": {
      "resetPwdHeader_content": "Enter login to receive reset password link in email",
      "resetPwdHeader_subheader": "",
      "UID_label": "Respondent Login",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "sysdiagrams": {
      "definition_label": "definition",
      "name_label": "name",
      "principal_id_label": "principal_id",
      "version_label": "version",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyMessages": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage message history of this deployment",
      "grid_DplyStep": "Step",
      "grid_NotifyMerge": "Mail Merge?",
      "grid_NotifyEmail": "Email?",
      "grid_NotifyGenerate": "Generate Profile?",
      "grid_SampleCount": "Number of Samples",
      "grid_CreatedDate": "Created On",
      "grid_UserName": "Created By",
      "button_3_content": "Back"
    },
    "testText": {
      "input_1_label": "Input"
    },
    "State": {
      "CreatedAt_label": "CreatedAt",
      "Data_label": "Data",
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Reason_label": "Reason",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "JobQueue": {
      "FetchedAt_label": "FetchedAt",
      "JobId_label": "JobId",
      "Queue_label": "Queue",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "MP2015_Questionnaire": {
      "header_1_content": "Header",
      "input_1_label": "Input"
    },
    "JobParameter": {
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "vSP_ListSampleCount": {
      "ListId_label": "ListId",
      "SampleCount_label": "SampleCount",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Schema": {
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Counter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplysampleowner": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Assign Data Editors for Deployment Samplers",
      "DataEditor_label": "Data Editor",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "gridview_1_DueDate": "Due Date",
      "button_1_content": "Save",
      "button_2_content": "Cancel",
      "provideNameToDownload": "You may provide another preferred name, click OK to download",
      "provideName": "Please provide a name."
    },
    "RespChangePassword": {
      "header_1_content": "Please enter your new password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "deletethis": {
      "header_4_content": "Attemp to hide container",
      "button_1_content": "Show Args",
      "toggle_label": "Toggle",
      "input_2_label": "Show = true",
      "input_3_label": "Show = false",
      "header_1_content": "Container A",
      "input_1_label": "1st"
    },
    "RespChangePasswordSuccess": {
      "header_1_content": "Change password successful",
      "btnSubmit_content": "Home"
    },
    "ResendTemplateOne": {
      "subject_content": "SP7: Resend",
      "body_content": "Dear {Name}!<br/><br/>\n\n<br />DplyName:  {DplyName}, <br />\n<br />DplyQnn: {DplyQnn}, <br /> \n<br />DplyList: {DplyList}, <br />\n<br />DplyCategory: {DplyCategory}, <br />\n<br />Name: {Name}, <br /> \n<br />Email: {Email}, <br /> \n<br />UID: {UID}, <br /> \n<br />UIDPeer: {UIDPeer}, <br /> \n<br />ActiveYN: {ActiveYN}, <br />\n<br />Password: {Password}, <br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<p>&nbsp;</p>\n"
    },
    "TestWorkflow": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "LitterCount": {
      "Name_label": "Name",
      "Observer _label": "I am an Observer ",
      "dropdown_1_label": "Location"
    },
    "testreg": {
      "input_1_label": "Input"
    },
    "ThankYou": {
      "header_1_content": "Completion of Survey"
    },
    "List": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Set": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Score_label": "Score",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    }
  }
}' WHERE [Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a';

