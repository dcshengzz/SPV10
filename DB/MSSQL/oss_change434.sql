-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMaintenance.json
-- dplyMaintenance-settings.json
-- dplyMaintenance-code.js

UPDATE [dwMetadata] SET
[Id]='967fd08d-4fee-4d24-ac0e-afe1dca6abbf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:03:40.110', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-11-03 13:05:39.403', 
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
            "other-visibleConition": "data.ResponseUpload == null || data.ResponseUpload == \"\""
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-11-03 13:05:39.450', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMaintenance",
  "lastUpdate": "2023-11-03T13:05:39.4497219+08:00",
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
  "dataColl": []
}' WHERE [Id]='6a20fa57-ecb9-407a-801c-6e8b8e4f7c86';

UPDATE [dwMetadata] SET
[Id]='0c290d6f-5456-4ab4-913f-12cd3a456147', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:04:38.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-11-03 12:52:03.070', 
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
                        alertify.error("Upload Failed - " + xhr.statusText + " - " + xhr.responseText, 20000);
                    } else if(xhr.status===413) {
                        alertify.error("Upload Failed - the selected file is too large to be uploaded here", 20000);
                    } else {
                        alertify.error("Upload Failed - " + msg + " - " + err, 20000);
                    }
                } else {
                    console.error(xhr.message);
                    if("OK" == xhr.message) {
                        alertify.success("File transferred to server, you will be notified by email when processing is complete", 20000);
                    } else if("FAIL" == xhr.message) {
                        alertify.error("Failed to transfer the file to the server.", 20000);
                    } else {
                        alertify.error("This file is not valid. Please check that you have the correct file.", 20000);
                    }
                }
            }
        });  
    },
    
    applyDates: function(args) {
        //TODO - ensure correct format
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
                alertify.error(reason, 20000);
                Utils.loadingStop();
            }
        )
    },
    
    
}' WHERE [Id]='0c290d6f-5456-4ab4-913f-12cd3a456147';

