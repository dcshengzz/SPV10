-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplySample.json
-- dplySample-settings.json
-- dplySample-code.js
-- respdashboard.json
-- respdashboard-settings.json

UPDATE [dwMetadata] SET
[Id]='ef5a5a02-0bc5-4c44-8abe-c8628521e9f6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplySample.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2024-06-13 13:18:52.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-04-13 12:05:36.387', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "{Name}",
    "size": "huge",
    "subheader": "Data Editor Assignment (by Sample)"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_1",
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
        "secondary": true
      },
      {
        "key": "btnAssignmentOfDataOwners",
        "data-buildertype": "button",
        "content": "Assignment by Data Editor",
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
                "value": "dplysampleowner"
              }
            ]
          }
        },
        "secondary": true
      }
    ]
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-float": "",
    "children": [
      {
        "key": "header_6",
        "data-buildertype": "header",
        "content": "Filter by Sample",
        "size": "medium"
      },
      {
        "key": "container_11",
        "data-buildertype": "container",
        "style-width": "100%",
        "children": [
          {
            "key": "DplySample",
            "data-buildertype": "dictionary",
            "label": "Sample",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_ListSampleInfo",
            "columns": "UIDName ASC",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeDplySample"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-customcss": "",
            "clearable": true,
            "multiple": true,
            "search": true,
            "style-marginBottom": "",
            "style-width": "400px",
            "filters": "[{column: \"DplyId\" ,value: \"{Id}\" ,term : \"=\"}]",
            "paging": false,
            "onChangeTimeout": "0"
          }
        ],
        "style-float": "",
        "style-marginBottom": "40px",
        "style-marginTop": ""
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "children": [
          {
            "key": "SampleTabs",
            "data-buildertype": "tab",
            "items": [],
            "children": [],
            "events": {
              "onItemClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "pointing": true,
            "secondary": true,
            "compact": false,
            "isDisplayCount": false,
            "fluid": false,
            "vertical": false,
            "tabular": false
          }
        ],
        "style-width": "100%",
        "style-marginTop": "",
        "style-customcss": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "mdlDataEditor",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "{Tabs_UID}",
                "size": "medium"
              },
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Data Editor",
                "size": "tiny",
                "style-source": "float:left;",
                "textAlign": "left",
                "style-marginTop": "10px"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "dictDataEditor",
                    "data-buildertype": "dropdown",
                    "label": "",
                    "fluid": true,
                    "selection": true,
                    "data-elements": [],
                    "search": true,
                    "multiple": true,
                    "style-width": "400px",
                    "events": {},
                    "style-marginLeft": ""
                  }
                ],
                "style-float": "left",
                "events": {},
                "style-marginLeft": "10px"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-marginTop": "10px",
                "style-marginBottom": "10px",
                "style-source": "clear:both;"
              },
              {
                "key": "btnAssignDataOwner",
                "data-buildertype": "button",
                "content": "Assign Data Owner",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "addDataEditor"
                    ],
                    "targets": [
                      "SampleTabs"
                    ],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btnModalClose",
                "data-buildertype": "button",
                "content": "Cancel",
                "primary": false,
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "closeAddDataOwnerModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "content": "DataEditorModal"
          }
        ],
        "style-hidden": true
      }
    ],
    "style-width": "100%",
    "style-marginBottom": "20px",
    "style-marginTop": "20px"
  }
]' WHERE [Id]='ef5a5a02-0bc5-4c44-8abe-c8628521e9f6';

UPDATE [dwMetadata] SET
[Id]='89e87aee-5756-4c59-bb15-3304534a03c6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplySample-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2024-06-13 13:18:52.550', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-04-13 12:05:36.420', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplysample",
  "lastUpdate": "2025-04-13T12:05:36.4210905+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "3e60dc4b-75cf-cc6e-fe1e-21d97fdf9276",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c722baa4-71ff-c5f7-0209-907d98d149ac",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "de06dd9e-4685-f60b-0064-015fa6f3c8d0",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ea01d558-2ba4-7958-8faa-378d3057cfae",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "23856733-a4c6-f947-d42a-2f4d7a22aa5c",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "026243ea-e806-1d3c-6578-cb6f7d84c978",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b7a95c56-e649-2e42-c877-6988501f3dec",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2cf301a5-5a58-e021-7d67-b78e159bca80",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ea45a6bd-3ea6-998c-83c9-dd303b667a1c",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "157ad2a0-3e2f-fdb3-8caf-5b55b0e49407",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f577b163-b50e-34fc-c29a-0415832e0553",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "93162fbd-2a6a-97bd-dcca-58781eb3445c",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "177bedf8-9c81-9865-6289-909fbb491b0d",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "180331f7-91cc-dcbe-82c1-baa59907dd12",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "18754b22-a7ce-451f-d053-db4e26e75b9a",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6ec467d7-f24e-683a-11e3-c34223712cb4",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "20996523-35e6-67b0-5a20-3b853d8197f7",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a947af4c-0166-f72e-53de-689587957b78",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e19ca9eb-7b4e-7f0c-5e7c-a06697993bea",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "39c665bd-9b10-3d54-38dc-2d824544eef5",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6e8bb163-a1cd-4587-78f2-440560d83c65",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8820e725-8cde-3050-eb6a-4b053c908330",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e7f653a-1b87-ee5a-7792-1b70092647f1",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a18a09c9-9086-f1c9-c336-93318cdc6e14",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a612e999-8c3f-bf24-952d-a00778ff030b",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "018ac76f-1f89-92d3-b21e-f1887c13146e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3593b742-0c52-36a1-e127-615f7b282401",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "664cc5dd-30d1-ea54-307d-925fa5778d8f",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "071870b1-a99c-087d-67a3-76431f59dbd8",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "28545e9d-71fa-024e-2b95-06ae34ba514b",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5b440add-1b03-654e-1d2e-871bb8c3570d",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3ff445b-ecce-509d-cac1-3187bbfabac5",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "febd68e3-a525-5f5d-2817-6c6ad68fb150",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f4209215-81b7-801f-8b0c-42116a14b892",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b134fde4-8c14-78e6-7dd6-bf8b40ac79ae",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f508976e-906c-5006-b450-4c667ed4f651",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f00d8400-1d17-43b5-9092-1849f0297e08",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5c5832a9-a210-d684-9bd5-b92f0b37559d",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a2d2061-b05e-ebb4-a151-c67cb1d8814e",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9a0856c2-c830-0dd7-bb9f-520ad7e59223",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b291a22f-21aa-4199-192d-940055adf0df",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c816bfb0-bccb-edb9-c600-22ec0f3d0a77",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf67bb96-51e6-9744-931f-ab953f524c0a",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ce23ac5-69f7-d97b-705d-bb5c133e8f28",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fa31006a-381e-ebad-d7f8-3645ac2a9c98",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f1246306-a24e-d866-285f-1d01fe7437e3",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4426e42-f0d8-ea37-82e9-8809580850b2",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2e9bf6b8-a862-d4ed-5530-5575838a2ff6",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "30009063-4fd8-c3ea-8f2b-36f1cd21909c",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "71383405-2be1-9a3e-22ea-fe5f08e688e2",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "69f05301-8067-f510-1042-1238cff8d66c",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "abd2f43e-0cae-faab-f579-269e682ee2bd",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b4ecc1dd-8c1b-f311-e4ce-69aac31a10c3",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "db4318c9-243e-657c-affb-cc45e3110bdd",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "723f4041-ad6f-303d-35ee-fab62a2aa864",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0315c491-e3da-1e12-4949-9c0e58b4fa04",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "213716d7-8398-e202-05ec-b3c724fb9597",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cdda5ed9-5100-d95b-12bb-e058a95a0f9a",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7dc8131c-3529-5a38-61b3-79223f526d36",
      "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bacc740-4a82-4d30-1022-0ef7154c111a",
      "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74ac17da-0ef0-984b-9365-00a22426edeb",
      "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48516d86-83d8-3f09-57f1-2e123fa83868",
      "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "603c5d6d-41ed-d9aa-d794-b32977ec9411",
      "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "41b9f6ce-426a-9a6d-ca17-82259a631d48",
      "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3a7b9531-eb0d-3bfd-fff3-6425d541fb23",
      "attributeId": "595da6d0-43c2-4faf-8b64-242a5e2a9c10",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}' WHERE [Id]='89e87aee-5756-4c59-bb15-3304534a03c6';

UPDATE [dwMetadata] SET
[Id]='7ef32ac9-b0ae-4d0f-bb91-70bcb1ff772f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplySample-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2024-06-14 11:53:24.827', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-04-12 16:59:52.250', 
[Data]=N'{
    init:function(args){
        Utils.getRequest("/deployment/getDataEditor?dplyId=" + encodeURIComponent(args.data.Id))
        .then(response => {
                if(response.success && response.item !== null) {
                    var result = response.item;
                    const options = [];
                    for(var i=0; i<result.length; i++) {
                        options.push( {
                        value: result[i].id,
                        text: result[i].name,
                        } );
                    }
                    CloverApp.API.changeModelControl(args, "dictDataEditor","data-elements", options);
                }
            }, reason => {
                if(reason == ''NO_DATA_EDITORS''){
                    alertify.error(''No data editor found this organisation'');
                } else {
                    console.error("Error getDataEditor",reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            }
        ).finally(() => {
            args.component.refs.dictDataEditor.forceUpdate();
        });
    },
    
    onChangeDplySample: function(args){
        const dplyId = args.data.Id
        const dplySample = args.data.DplySample;
        const selectedSample = args.data.SelectedSample;
        const sampleArr = [];
        var sampleToRetrieve = null;
        const tabArray = args.sourceControlRef.state.options;
        
        for(var i = 0; i < dplySample.length; i++){
            sampleArr.push(dplySample[i]);
        };
        
        if(selectedSample !== undefined) {
            //Check is to add or remove
            let difference  = selectedSample.filter(x => !sampleArr.includes(x));
            let symDifference = selectedSample.filter(x => !sampleArr.includes(x))
                        .concat(sampleArr.filter(x => !selectedSample.includes(x)));
            if(difference.length > 0) {
                //To remove from Tab
                var indexToRemove;
                const sampleTabsModel = function (model) {
                    for (x=0;x<model.items.length;x++){
                        if(model.items[x].key == symDifference) {
                            indexToRemove = x;
                            break;
                        }
                    }
                    model.children.splice(indexToRemove, 1)
                    model.items.splice(indexToRemove, 1)
                    return model;
                };
                
                CloverApp.API.rewriteControlModel("SampleTabs", sampleTabsModel);
            } else {
                sampleToRetrieve = symDifference;
            }
        } else {
            sampleToRetrieve = sampleArr;
        }
        
        CloverApp.API.setDataField("SelectedSample", sampleArr);
        
        if(sampleToRetrieve !== null) {
            try{
                var tabTitle;
                var tabKey;
                for (x=0;x<tabArray.length;x++){
                    if(tabArray[x].key == sampleToRetrieve) {
                        tabTitle = tabArray[x].text;
                        tabKey = tabArray[x].key;
                    }
                }
                Utils.loadingStart();
                Utils.getRequest("/deployment/getDplySampleInfo?dplyId=" + encodeURIComponent(dplyId) + "&listSampleInfoId=" + encodeURIComponent(sampleToRetrieve))
                .then(response => {
                        if(response.success && response.item !== null) {
                            var result = response.item;
                            dplysampleUserActions.addSampleInfo(tabTitle,tabKey,result);
                        }
                    }, reason => {
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                }
                ).finally(Utils.loadingStop);
            }catch(e){
                console.log(e);
            }
        }
    },
    
    //Create tabs details for sample
    createSampleInfoTable: function (result) {
        var divArray = new Array();
        var id = result.UID;
        var isMultiResponse = result.multiResponse;
    
        divArray[''children''] = new Array();
        divArray[''data-buildertype''] = "container";
        divArray[''key''] = "container_" + id;
        divArray[''style-customcss''] = "ui message";
    
        var sampleInfo = new Array();
        var tableStyle = "style=''background-color:#e8e8e8;padding:5px;''";
        var content = "<table class=''ui info message''>";
        content += "<tr><td " + tableStyle + ">UID</td><td>" + result.UID + "</td></tr>";
        content += "<tr><td " + tableStyle + ">Name</td><td>" + result.Name + "</td></tr>";
        content += "<tr><td " + tableStyle + ">Status</td><td>" + result.StatusTitle + "</td></tr>";
        var segmentVal = result.Segment !== null ? result.Segment : '''';
        content += "<tr><td " + tableStyle + ">Segment</td><td>" + segmentVal + "</td></tr>";
        if(isMultiResponse == false){
            var respDateStartVal = result.RespDateStart !== null ? dayjs(new Date(result.RespDateStart)).format(''DD MMM YYYY HH:mm'') : '''';
            content += "<tr><td " + tableStyle + ">Response Start</td><td>" + respDateStartVal + "</td></tr>";
            var respDateEndVal = result.RespDateEnd !== null ? dayjs(new Date(result.RespDateEnd)).format(''DD MMM YYYY HH:mm'') : '''';
            content += "<tr><td " + tableStyle + ">Response Complete</td><td>" + respDateEndVal + "</td></tr>";
        }
        var dueDateVal = result.DueDate !== null ? dayjs(new Date(result.DueDate)).format(''DD MMM YYYY HH:mm'') : '''';
        content += "<tr><td " + tableStyle + ">Due Date</td><td>" + dueDateVal + "</td></tr>";
        content += "</table>";
    
        sampleInfo[''content''] = content;
        sampleInfo[''data-buildertype''] = "staticcontent";
        sampleInfo[''key''] = "staticContent_" + id;
        sampleInfo[''isHtml''] = true;
    
        divArray.children.push(sampleInfo);
    
        var divHr = new Array();
        divHr[''content''] = "<hr style=''margin-top:20px; margin-bottom:20px''>";
        divHr[''data-buildertype''] = "staticcontent";
        divHr[''key''] = "scHr_" + id;
        divHr[''isHtml''] = true;
    
        divArray.children.push(divHr);
    
        var gvSample = new Array();
        var gvSampleId = "gv_" + id
        gvSample[''key''] = gvSampleId;
        gvSample[''data-buildertype''] = "gridviewwithactions";
        gvSample[''columns''] = new Array();
        gvSample[''multiselect''] = true;
        gvSample[''rowKey''] = "lsoId";
        gvSample[''style-source''] = "margin-top:10px;max-height:200px;max-width:400px;overflow:hidden scroll;";
    
        var gvUsername = new Array();
        gvUsername[''key''] = "Username";
        gvUsername[''name''] = "Data Editor Name";
        gvUsername[''sortable''] = false;
        gvUsername[''filterable''] = false;
        gvUsername[''resizable''] = false;
        gvSample.columns.push(gvUsername);
        
        var eventAdd = [];
        eventAdd[''onClick''] = new Array();
        eventAdd.onClick[''active''] = true;
        eventAdd.onClick[''actions''] = new Array("openAddDataOwnerModal");
        eventAdd.onClick[''parameters''] = new Array();
        
        var param = new Array();
        param[''name''] = "UID";
        param[''value''] = id;
        eventAdd.onClick.parameters.push(param);
        
        var listSampleId = new Array();
        listSampleId[''name''] = "listSampleId";
        listSampleId[''value''] = result.ListSampleId;
        eventAdd.onClick.parameters.push(listSampleId);
        
        var gridName = new Array();
        gridName[''name''] = "gridName";
        gridName[''value''] = gvSampleId;
        eventAdd.onClick.parameters.push(gridName);
        
        var listSampleInfoId = new Array();
        listSampleInfoId[''name''] = "listSampleInfoId";
        listSampleInfoId[''value''] = result.Id;
        eventAdd.onClick.parameters.push(listSampleInfoId);
    
        var btnAdd = new Array();
        btnAdd[''content''] = "Add Assignment";
        btnAdd[''primary''] = true;
        btnAdd[''data-buildertype''] = "button";
        btnAdd[''key''] = "btnAdd_" + id;
        btnAdd[''events''] = eventAdd;
    
        var eventDelete = [];
        eventDelete[''onClick''] = new Array();
        eventDelete.onClick[''active''] = true;
        eventDelete.onClick[''actions''] = new Array("confirm","delDataOwner");
        eventDelete.onClick[''targets''] = new Array(gvSampleId);
        eventDelete.onClick[''parameters''] = new Array();
        
        var eventDeleteParamTitle = [];
        eventDeleteParamTitle[''name''] = "confirmTitle";
        eventDeleteParamTitle[''value''] = "deleteSampleAssignmentTitle";
        eventDelete.onClick.parameters.push(eventDeleteParamTitle);
        
        var eventDeleteParamText = [];
        eventDeleteParamText[''name''] = "confirmText";
        eventDeleteParamText[''value''] = "deleteSampleAssignmentText";
        eventDelete.onClick.parameters.push(eventDeleteParamText);
        
        var btnDel = new Array();
        btnDel[''content''] = "Remove Selected Assignment";
        btnDel[''secondary''] = true;
        btnDel[''data-buildertype''] = "button";
        btnDel[''key''] = "btnDel_" + id;
        btnDel[''events''] = eventDelete;
    
        divArray.children.push(btnAdd);
        divArray.children.push(btnDel);
        divArray.children.push(gvSample);
    
        var dataEditor = result.dataEditor;
        CloverApp.API.setDataField(gvSampleId, dataEditor);
    
        return divArray;
    },
    
    addSampleInfo:function(tabTitle,tabKey,result){
        const sampleTabsModel = function (model) {
            var sampleTable = dplysampleUserActions.createSampleInfoTable(result);
            model.children.push(sampleTable);
            model.items.push({ "title" : tabTitle , "key" : tabKey });
            return model;
        };
        CloverApp.API.rewriteControlModel("SampleTabs", sampleTabsModel);
        CloverApp.API.setDataField("SampleTabs", null);
    },
    
    delDataOwner:function(args){
        const dplyId = args.data.Id;
        const gridViewName = args.controlRef.props.name;
        const gridView = args.component.refs[gridViewName];
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        const filteredDataEditor = gridItems.filter((value, index) => !gridSelectedIndexes.includes(index));
        
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''sampleOwnerIds'', gridSelectedIndexes.map(i => gridItems[i].lsoId) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                CloverApp.API.setDataField(gridViewName, filteredDataEditor);
                gridView.refresh();
                alertify.success(Utils.encodeHTML(response.message));
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeAddDataOwnerModal: function(args){
        args.component.refs.mdlDataEditor.close();
    },
    
    openAddDataOwnerModal:function(args){
        args.component.refs.mdlDataEditor.openModal();
        CloverApp.API.setDataField("Tabs_UID", args.parameters.UID);
        CloverApp.API.setDataField("Tabs_UID_listSampleId", args.parameters.listSampleId);
        CloverApp.API.setDataField("Tabs_UID_gridName", args.parameters.gridName);
        CloverApp.API.setDataField("Tabs_UID_listSampleInfoId", args.parameters.listSampleInfoId);
    },
    
    addDataEditor:function(args){
        const dplyId = args.data.Id;
        const dataEditor = args.data.dictDataEditor;
        const listSampleId = args.data.Tabs_UID_listSampleId;
        
        if(dataEditor == null || dataEditor.length == 0) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        
        Utils.loadingStart("Adding assignments...");
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''userId'', dataEditor);
        formData.append(''listSampleIds'', listSampleId);
        Utils.postFormRequest("/deployment/setDataEditor", formData).then(
            response => {
                alertify.success(Utils.encodeHTML(response.message));
                dplysampleUserActions.refreshDataEditorGV(args)
            }, reason => {
                console.error("Failed to add assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(() => {
            Utils.loadingStop();
            CloverApp.API.setDataField("dictDataEditor", []);
        });
        
        args.component.refs.mdlDataEditor.close();
    },
    
    refreshDataEditorGV:function(args){
        const dplyId = args.data.Id;
        const gridName = args.data.Tabs_UID_gridName;
        const listSampleInfoId = args.data.Tabs_UID_listSampleInfoId;
        
        Utils.getRequest("/deployment/GetListSampleRespInfo?dplyId=" + encodeURIComponent(dplyId) + "&listSampleInfoId=" + encodeURIComponent(listSampleInfoId))
        .then(response => {
                if(response.success && response.item !== null) {
                    CloverApp.API.setDataField(gridName, response.item);
                }
            }, reason => {
                if(reason == ''NO_DATA_OWNER''){
                    //CloverApp.API.setDataField("dataEditorGv", []);
                } else {
                    console.error(reason);
                    alertify.error(Utils.encodeHTML(reason));
                }
            }
        );
    },
}' WHERE [Id]='7ef32ac9-b0ae-4d0f-bb91-70bcb1ff772f';

UPDATE [dwMetadata] SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-04-12 16:55:06.187', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Respondent Home",
        "size": "huge",
        "style-customcss": "",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "respDashboardHtmlView",
        "data-buildertype": "swzhtmlview",
        "hideOutput": "block",
        "events": {}
      }
    ],
    "style-source": "padding: 10px;"
  },
  {
    "key": "container_19",
    "data-buildertype": "container",
    "children": [
      {
        "key": "gridToggle",
        "data-buildertype": "checkbox",
        "label": "Grid View",
        "toggle": true,
        "style-customcss": "cbShowDropzones",
        "style-marginLeft": "",
        "events": {
          "onClick": {
            "active": false,
            "actions": [
              "onToggleGridClick"
            ],
            "targets": [],
            "parameters": []
          },
          "onChange": {
            "active": true,
            "actions": [
              "onToggleGridClick"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "defaultValue": "",
        "other-visibleConition": ""
      }
    ],
    "style-float": "right",
    "style-customcss": "",
    "style-marginBottom": "5px",
    "style-marginRight": "20px"
  },
  {
    "key": "container_15",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Current Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "currentSurveyGrid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "Form",
            "name": "Questionnaire",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom",
            "width": 190
          },
          {
            "key": "File",
            "name": "File",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom"
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateStart",
            "name": "Started On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateUpdate",
            "name": "Updated On",
            "type": "datetime",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Actions",
            "name": "Actions",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Delegate",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Print",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          }
        ],
        "rowKey": "Id",
        "defaultSort": "Hardcoded",
        "rowHeight": "128",
        "minHeight": "200px",
        "events": {}
      }
    ],
    "style-source": "margin: auto;\npadding: 10px;\nmargin-bottom: 1em;",
    "style-customcss": "hrm-block",
    "style-width": "100%",
    "events": {},
    "other-visibleConition": "data.gridToggle == 1 || (data.gridToggle == null && localStorage.getItem(''gridToggle'')) == 1 ? true : false"
  },
  {
    "key": "container_17",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_9",
        "data-buildertype": "header",
        "content": "Previous Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "previousSurveyGrid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "Form",
            "name": "Questionnaire",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom",
            "width": 190
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateStart",
            "name": "Started On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Print",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false,
            "name": "Print"
          }
        ],
        "rowKey": "Id",
        "defaultSort": "Hardcoded",
        "rowHeight": "128",
        "minHeight": "200px"
      }
    ],
    "style-source": "padding: 10px",
    "style-customcss": "hrm-block",
    "style-width": "100%",
    "other-visibleConition": "data.gridToggle == 1 || (data.gridToggle == null && localStorage.getItem(''gridToggle'')) == 1 ? true : false"
  },
  {
    "key": "container_18",
    "data-buildertype": "container",
    "children": [
      {
        "key": "currentAndPreviousTab",
        "data-buildertype": "tab",
        "items": [
          {
            "title": "Current"
          },
          {
            "title": "Previous"
          }
        ],
        "children": [
          {
            "key": "container_1",
            "data-buildertype": "container",
            "style-width": "100%",
            "style-customcss": "",
            "style-source": "margin: auto;\nmargin-bottom: 1em;\nbackground: #f2f5f9;\n",
            "children": [
              {
                "key": "currentSurveyCard",
                "data-buildertype": "cardgrid",
                "columns": [
                  {
                    "key": "QnnTitle",
                    "name": "Survey Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "",
                    "group": "header"
                  },
                  {
                    "key": "Form",
                    "name": "Questionnaire",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "body-left",
                    "icon": ""
                  },
                  {
                    "key": "RespDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Started On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "RespDateUpdate",
                    "name": "Updated On",
                    "type": "datetime",
                    "group": "body-right"
                  },
                  {
                    "key": "RespDateEnd",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Submitted On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "DplyDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Launched On",
                    "group": "body-bottom-left",
                    "icon": ""
                  },
                  {
                    "key": "DueDate",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Due On",
                    "group": "body-bottom-right",
                    "icon": ""
                  },
                  {
                    "key": "Print",
                    "name": "Print",
                    "type": "custom",
                    "group": "footer"
                  },
                  {
                    "key": "File",
                    "name": "File",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "footer",
                    "icon": ""
                  },
                  {
                    "key": "Actions",
                    "type": "custom",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Actions",
                    "group": "footer"
                  },
                  {
                    "key": "Delegate",
                    "type": "custom",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Delegate",
                    "group": "footer"
                  }
                ],
                "editFormShowType": "",
                "events": {},
                "style-hidden": false
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-width": "100%",
            "style-customcss": "",
            "style-source": "margin: auto;\nmargin-bottom: 1em;\nbackground: #f2f5f9;",
            "children": [
              {
                "key": "previousSurveyCard",
                "data-buildertype": "cardgrid",
                "columns": [
                  {
                    "key": "QnnTitle",
                    "name": "Survey Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "",
                    "group": "header"
                  },
                  {
                    "key": "Form",
                    "name": "Questionnaire",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "body-left",
                    "icon": ""
                  },
                  {
                    "key": "RespDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Started On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "RespDateUpdate",
                    "name": "Updated On",
                    "type": "datetime",
                    "group": "body-right"
                  },
                  {
                    "key": "RespDateEnd",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Submitted On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "DplyDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Launched On",
                    "group": "body-bottom",
                    "icon": ""
                  },
                  {
                    "key": "DueDate",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Due On",
                    "group": "body-bottom",
                    "icon": ""
                  },
                  {
                    "key": "Print",
                    "name": "Print",
                    "type": "custom",
                    "group": "footer"
                  }
                ],
                "editFormShowType": "",
                "events": {},
                "style-hidden": false
              }
            ]
          }
        ],
        "pointing": true,
        "secondary": true,
        "tabular": false,
        "vertical": false,
        "isDisplayCount": true
      }
    ],
    "style-hidden": false,
    "other-visibleConition": "data.gridToggle == 0 || (data.gridToggle == null && localStorage.getItem(''gridToggle'') == null) || (data.gridToggle == null && localStorage.getItem(''gridToggle'') == 0) ? true : false",
    "style-marginBottom": "-15px"
  },
  {
    "key": "modalsContainer",
    "data-buildertype": "container",
    "style-float": "",
    "style-hidden": true,
    "children": [
      {
        "key": "printModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "style-display": "block",
        "content": "printModal",
        "children": [
          {
            "key": "header_8",
            "data-buildertype": "header",
            "content": "PDF Export",
            "size": "medium",
            "subheader": ""
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "staticcontent_print",
                "data-buildertype": "staticcontent",
                "content": "<br/>\nPlease select the form to export (with responses).",
                "isHtml": true,
                "other-visibleConition": "data.formNameDropDownShow == 1 ? true : false",
                "events": {}
              },
              {
                "key": "formNameDropDown",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": 1,
                    "text": "Item 1"
                  },
                  {
                    "key": 2,
                    "value": 2,
                    "text": "Item 2"
                  },
                  {
                    "key": 3,
                    "value": 3,
                    "text": "Item 3"
                  }
                ],
                "placeholder": "",
                "other-visibleConition": "data.formNameDropDownShow == 1 ? true : false"
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "<br/>\nPlease enter the email address(es) to receive the exported PDF file (separated by comma):\n<br/>\n<i>eg: exampleA@example.com, exampleB@example.com)</i>",
                "isHtml": true,
                "events": {}
              },
              {
                "key": "inputEmails",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "example@gmail.com",
                "events": {},
                "style-marginTop": "10px"
              },
              {
                "key": "IsIncludeUnansweredSectionPDFExport",
                "data-buildertype": "checkbox",
                "label": "Include unanswered sections in exported file",
                "toggle": true,
                "events": {},
                "defaultValue": "",
                "style-marginTop": "20px",
                "other-visibleConition": "data.IsIncludeUnansweredSectionPDFExportShow == 1 ? true : false"
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "printButton",
                    "data-buildertype": "button",
                    "content": "Export",
                    "floated": "",
                    "secondary": false,
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "onPrintClick"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "printCancelButton",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closePrintModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "floated": "",
                    "secondary": true
                  }
                ],
                "style-marginTop": "20px",
                "events": {},
                "style-source": "text-align: right;"
              }
            ],
            "widthsCustom": "4",
            "orientation": "grouped",
            "style-marginTop": "",
            "events": {},
            "style-height": "270px",
            "other-visibleConition": ""
          }
        ]
      },
      {
        "key": "delegateModal",
        "data-buildertype": "swzmodal",
        "content": "delegateModal",
        "secondary": true,
        "style-display": "block",
        "children": [
          {
            "key": "header_6",
            "data-buildertype": "header",
            "content": "Delegate Survey",
            "size": "medium",
            "subheader": "Delegate access to answer the survey to another user in your organisation."
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "DelegateName",
                "data-buildertype": "input",
                "label": "Delegate''s name",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
              {
                "key": "DelegateEmail",
                "data-buildertype": "input",
                "label": "Delegate''s email address",
                "fluid": true,
                "onChangeTimeout": 200
              },
              {
                "key": "AccessCodeNote",
                "data-buildertype": "input",
                "label": "Survey access code for delegate to use",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px",
                "readOnly": true,
                "placeholder": "(Will be generated automatically by the system)"
              },
              {
                "key": "DelegateValidityStart",
                "data-buildertype": "input",
                "label": "Valid from",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "defaultValue": ""
              },
              {
                "key": "DelegateValidityEnd",
                "data-buildertype": "input",
                "label": "Valid until",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime"
              },
              {
                "key": "DelegateComments",
                "data-buildertype": "textarea",
                "label": "Comments  (optional)",
                "fluid": true,
                "rows": "3",
                "autoHeight": true,
                "style-width": "100%"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<hr/>",
                "isHtml": true
              },
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "Delegation Code Required",
                "content": "Please provide your delegation code to authorise the delegation or view the delegation history. Please note that this is the delegation code you were previously sent and NOT your CorpPass or SingPass password and NOT the access code the delegate will use to answer the survey.",
                "info": false,
                "positive": false,
                "negative": true
              },
              {
                "key": "DelegateFromName",
                "data-buildertype": "input",
                "label": "Your name",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
              {
                "key": "DelegateCode",
                "data-buildertype": "input",
                "label": "Your delegation code",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelegate",
                    "data-buildertype": "button",
                    "content": "Delegate",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "delegate"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnCancelDelegate",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDelegateModal"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnDelegationHistory",
                    "data-buildertype": "button",
                    "content": "Delegation History",
                    "floated": "right",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "openDelegateHistoryModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": false,
                    "secondary": true
                  }
                ],
                "style-marginTop": "20px"
              }
            ]
          }
        ],
        "primary": false
      },
      {
        "key": "accessCodeModal",
        "data-buildertype": "swzmodal",
        "style-display": "block",
        "content": "accessCodeModal",
        "secondary": true,
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Access Code Required",
                "size": "medium",
                "textAlign": "left"
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "This survey is protected. Please enter the survey specific access or delegation code to access this survey. ",
                "style-marginBottom": "20px"
              },
              {
                "key": "AccessCode",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px",
                "style-marginTop": "",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_9",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btn_SubmitAccessCode",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "submitAccessCode"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btn_CancelAccessCode",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeAccessCodeModal"
                        ],
                        "targets": [
                          "accessCodeModal"
                        ],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "",
                "style-marginBottom": ""
              }
            ]
          }
        ]
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "ExcelFileUpload",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "file",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "excelFileUploaded"
                ],
                "targets": [],
                "parameters": []
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "customPostUrl": ""
          }
        ],
        "style-hidden": true
      },
      {
        "key": "fileUploadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileUploadModal",
        "children": [
          {
            "key": "container_4",
            "data-buildertype": "container",
            "style-marginTop": "",
            "style-marginBottom": "",
            "style-source": "",
            "children": [
              {
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Upload survey response as an Excel file",
                "size": "medium",
                "subheader": "",
                "textAlign": "left"
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "After upload the survey will open for validation and editing. <br/>\n<br/>\nPlease select the form in which to open the survey:",
                    "isHtml": true
                  },
                  {
                    "key": "UploadFormChoice",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ]
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "style-marginBottom": "",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "Click \"Upload Excel Response\" below to select a file to upload. <br/>\nUpload will commence immediately and if successful the survey will open for you to finalise and submit.\n<br/>\n<br/>",
                    "isHtml": true
                  }
                ]
              },
              {
                "key": "container_7",
                "data-buildertype": "container",
                "style-marginTop": "20px",
                "style-source": "text-align: right;",
                "children": [
                  {
                    "key": "UploadExcelButton",
                    "data-buildertype": "button",
                    "content": "Upload Excel Response",
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "promptForExcelFile"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btn_CancelUpload",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileUploadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginBottom": ""
              }
            ]
          }
        ]
      },
      {
        "key": "fileDownloadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileDownloadModal",
        "children": [
          {
            "key": "container_13",
            "data-buildertype": "container",
            "style-marginTop": "",
            "style-marginBottom": "",
            "style-source": "",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Downloads",
                "size": "medium",
                "subheader": "",
                "textAlign": "left"
              },
              {
                "key": "container_14",
                "data-buildertype": "container",
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_6",
                    "data-buildertype": "staticcontent",
                    "content": "Please select a file to download:",
                    "isHtml": true
                  },
                  {
                    "key": "fileDropDown",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ]
              },
              {
                "key": "container_16",
                "data-buildertype": "container",
                "style-marginTop": "20px",
                "style-source": "text-align: right;",
                "children": [
                  {
                    "key": "btnDownload",
                    "data-buildertype": "button",
                    "content": "Download",
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "onDownloadClick"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "button_2",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileDownloadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginBottom": ""
              }
            ]
          }
        ],
        "events": {}
      },
      {
        "key": "delegateHistoryModal",
        "data-buildertype": "swzmodal",
        "content": "delegateHistoryModal",
        "style-display": "block",
        "events": {},
        "children": [
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_7",
                "data-buildertype": "header",
                "content": "Delegation History",
                "size": "medium",
                "textAlign": "left",
                "style-source": "float:left;"
              },
              {
                "key": "buttonCloseDelegateListModal",
                "data-buildertype": "button",
                "content": "Close",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "closeDelegateHistoryModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "style-marginLeft": "10px"
              },
              {
                "key": "RevokeAllDelegation",
                "data-buildertype": "button",
                "content": "Revoke All Delegation",
                "primary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "confirm",
                      "revokeAllDelegation"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "secondary": true,
                "style-hidden": false
              }
            ]
          },
          {
            "key": "gridDelegation",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "CreatedDate",
                "name": "Delegation Date",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "FromName",
                "name": "From",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "width": 100
              },
              {
                "key": "Name",
                "name": "Delegate To",
                "sortable": true,
                "filterable": false,
                "resizable": true
              },
              {
                "key": "ValidityStart",
                "name": "Validity Start",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "ValidityEnd",
                "name": "Validity End",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "Comments",
                "name": "Comments",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "type": "custom",
                "width": 100
              },
              {
                "key": "Status",
                "name": "Status",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": "",
                "type": ""
              },
              {
                "key": "Revoke",
                "name": "Revoke",
                "type": "custom",
                "sortable": false,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "events": {},
            "pagerType": "",
            "defaultSort": "CreatedDate DESC",
            "rowKey": "CreatedDate",
            "style-marginTop": "80px",
            "rowHeight": "80"
          }
        ],
        "compact": true,
        "secondary": true
      }
    ],
    "events": {}
  }
]' WHERE [Id]='d6e12e1d-3384-4352-bf68-8210aa75d406';

UPDATE [dwMetadata] SET
[Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-04-12 16:55:06.237', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2025-04-12T16:55:06.2339146+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "c1b2ca73-2ded-e096-39ef-7cfc0f62ac2c",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "currentSurveyCard",
      "dataMap": [
        {
          "id": "de499ef5-d48e-8751-1435-5fdf4bad03d6",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0cedcc5a-0faf-7ddf-8f8b-6cc422bb03d9",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6c5ca042-8eab-4e96-82fa-93b821df7ebe",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1820827-1a12-e7bb-da37-e83381fd2bbe",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df8d2528-af6c-439c-3afb-851fb89168f2",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5c7b4a6b-ec0f-c1f5-16ad-ba49d6f95a32",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e4eb684-13e8-e3e1-13a6-bbc8dde3daef",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a5b2d8f3-10ca-4ba0-cbb1-c93f70293eb7",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9bbe4900-f1f7-240c-f411-116be94924e6",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b949bd3c-3c62-94e9-71bf-ba52c35c800b",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8fc229a2-eccc-9699-b1d9-f6bf52e8ab12",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "505ff2d8-3d3c-a6a7-42ce-c841f072eca5",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d65f67c-5158-6691-2c88-21114a5662bc",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "64e9f997-7ec5-4d4e-a2da-20b07d8cdd00",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d21cc6f-fcf7-64d5-2a8a-e149f21a03d3",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fff17f24-df36-838a-7216-c34095660f4c",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6bbaf148-a75d-bb84-55bf-0fd066ac771f",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b62eb0f-24c8-0a31-b6c6-c1fc0090468c",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd4955a9-8ec9-27fe-98da-a3b7a80a7ccc",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f2a5d70-7bf8-3dfc-5e9f-618eeaa0ec84",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "240d3b14-0943-b274-86f9-a3ae29cd2adb",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0556426a-9928-5c29-a6c0-3e73efba988f",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7153a0c3-c498-b3c6-3dce-9d4be61cd837",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0d163571-97b7-7300-3089-0e8246b35249",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69dfe58b-8234-6112-f6d3-03a624172dd4",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f863de45-42fa-2732-6225-a5d19f76ec46",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e28e4f2-083d-09be-e749-6f5d16092b27",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37355549-1fa6-9cec-d655-ff60666395a0",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c83c444-09a8-e64e-4c70-e6ce04cfd9db",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1deb5d25-cd89-74bf-94e6-c3af55575a04",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a69c8ec2-9962-adf7-3799-cf986ca59d82",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "199f9105-91c1-a668-4dc6-bd3414d85a76",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4fe3545e-aa1c-dec1-8600-7e5e61b1c076",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5d931ba6-69a5-4231-1071-bd376d0aeef5",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39ac1fb6-a16f-1b0a-eff7-595d651f7103",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d1d7e6ef-3a56-3885-b471-a4e70e768e2d",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a2a59d0b-c7e3-76da-24bb-b5a535ac7507",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b45dcee-818e-4a69-7f7a-8f1e6a321b8a",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c5ac3829-e130-f7fd-feb0-a011ba53cb1c",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fa236c82-2137-17b5-f39f-5aa3e75a1280",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4bebef43-c7f1-6f17-eea7-2fba6adb6193",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a25f1f9b-8175-150e-0701-5b74081cb3db",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "92d5901a-8386-be34-2ae6-ddbc2e288423",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fbc39bd1-d4ff-5428-9d57-cc642899c43e",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3a4df715-d398-a3ab-983a-ed544b679395",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6e0e0f5-7a87-f697-577d-d8ef7e49c25a",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f91ceb7-5c8f-0d53-7884-22d4c8959a52",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27c8e4b3-354f-5d79-ab84-42f578421ffe",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89c9fbc6-c1d4-d7a0-7a20-50cc1546f87e",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3b37c584-1910-c912-5bfc-96d60c0fce30",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c81de3ce-8085-80d2-d05f-8e0515b65b4c",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cd212774-3a08-8716-04d8-0d9e26c5b342",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "871de62a-fe83-5c97-0879-0d3f333461dc",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4fe212f3-5915-a186-54cc-4cd8dc68ea19",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "53bdacee-661f-2572-4fc2-29ec111efb9f",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8dfe18d-1366-752c-b12f-9d01f08488f0",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fe94fc07-14fb-d694-a712-844c39041294",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "817eca63-b79b-15e5-deed-cd9138322642",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96f7048b-f0cf-7b46-aa7e-78b1a7dc5ebb",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e3123f6d-949e-95c2-3f7d-7a80d4844347",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52c61f53-b3e4-99a0-404f-1aecad768511",
          "attributeId": "f384f444-143d-43e7-8727-09b545ed8819",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f437392-f8a2-0c11-df39-efbdb4f2019e",
          "attributeId": "704cea13-77e0-4087-9136-561b7c7743b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "80f82b08-e0fe-2a3c-19ff-ab840601191f",
          "attributeId": "96f391bb-a0b5-4c38-a382-d8b963a88524",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da7c07d0-1c86-0a30-e4f6-bcd1b098d34b",
          "attributeId": "e40d9199-bbba-4267-b632-7c1fd80f2021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f01b15d-3a7a-2c74-706f-d5911774eb51",
          "attributeId": "0b1faa54-a4d7-4f86-9010-c00bc1d6592a",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__currentSurveyCard_totalcount"
    },
    {
      "id": "9c373d2d-38e1-5859-ce23-ffda481c0f3b",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "previousSurveyCard",
      "dataMap": [
        {
          "id": "de26eda1-3ceb-2de8-2e5b-23ce507c2315",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d2855ae8-90dc-94d3-88e5-29fd37821c47",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5874602-d9ab-db1f-e455-cf3c945c2c3f",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4864319-48d1-e1ee-45fc-d7c4fd40fca1",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5d88d814-c63b-a26c-7867-a814b1801637",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7a49cf79-b561-b2fc-f8d6-8b809239b173",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bce2bd0e-fbd3-9941-ecd7-56c6288a6618",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4383584b-09e8-0c6f-238c-6f8b3816b499",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eaba1792-784d-764a-c000-2c50204514ff",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b2aea760-4bb0-0b99-3951-5219df91545d",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "42862819-c6c3-bbee-34b1-10cade51c774",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a85fef4-5483-8c90-d50a-620df48cdc79",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f62cba3f-4b7e-147f-cd02-ee8f0952eac4",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05eb28a1-07ae-04ab-3478-651b1ecb1690",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "934ce7f1-2858-1201-b327-002e3f4fe7c1",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "280fbffc-6788-4c6f-fcb0-a4cfe15ef93d",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8d1a2a01-45b9-2bbf-ee8b-c287f62b4fd9",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b964e2-3ff8-0f16-c8f3-3bc6cabb9745",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27084ce4-8c72-5389-e4b5-5e7d91cc2875",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9e7cdb36-5777-c77c-8f48-bf733ae63a3f",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "710e1c47-9c56-4762-5fd9-ab5dc85394d2",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b838c250-3f9c-3d4b-1a00-c0d318be223e",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96bd86de-36b0-cbd5-125b-89777b670a55",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2649f238-490c-9950-1952-713ba8e9ca35",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1b0856-9227-975b-2661-737e7c422aa7",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd431db6-ba4a-1a7f-155d-5700816d823b",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "239863c7-a98a-a4e6-a0db-9d74aaa2fd5a",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2209cc6d-05d2-4071-6842-8546ccc51ee5",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60c8149a-e637-aff7-7b7d-edf2cc3b54ae",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84d8107e-d824-18ba-162a-441c8b88cf4c",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "345af599-3f75-b6c0-4836-c9dfaa853245",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e7396913-5419-df30-492a-e17f04fd59d8",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1ee9b6c-99ea-78b8-9d91-e533881403bb",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab3f1823-2d38-546e-426e-75fd8df02527",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3ccbe982-2efa-b66b-bfe0-0a9725166234",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2258546f-1c27-19a4-7c01-bac01e49ae9b",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a0e36b3-5a95-286f-3fcf-3a6f75e3aa11",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1daa6e-231d-9108-5056-4adebf6abb6f",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4a1707a-0f21-7d9b-2771-49072f0d4739",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ca2b07fe-c472-6cb5-d8b5-b4f5bcbef72e",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "345fab4b-e472-eec0-b034-ba6edb1547d3",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6bbfff9f-47d8-868a-5ea8-4494d88fc106",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "94ee384b-53e3-85aa-92d1-b9782513ab10",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e00eb46-9516-c514-0831-8c5217e5c97e",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ce6f9b27-40a4-12f8-6e2b-54ec688ea639",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05139731-3d7c-5378-788c-487d3487821d",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "70345d2b-1a3d-6f1e-ce3c-3e84621c1d3d",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "acfa30de-d4d4-8e52-5fc1-dce2b10b1658",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "be786b98-e78f-576c-97ed-72ada5a97ec5",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "683d482a-4bc3-7f1c-8839-cf11eb362d86",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f867911a-c9ed-2773-e170-8edd83e6f5a8",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "461218ed-83a9-a5a6-a76c-6f8b9b304827",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e835892-a26f-6aff-fd39-64605e0fd901",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d157d03-31c9-102f-c5b1-5520b100fa34",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f43d7de-7c58-c0c2-7e92-713e5de9bb06",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4870960-a194-ded0-87ee-14dcd353fed5",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05e18520-d5b9-09b7-eb93-b002037e4188",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e34f8321-c469-9537-7a12-75d7df1f5a97",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "681ff069-e261-361e-83b8-41c6eb06e2f9",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf2a4466-0d0b-e713-2feb-a03b109e110f",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1091a3df-a65b-d403-1e77-1c04ed88df69",
          "attributeId": "f384f444-143d-43e7-8727-09b545ed8819",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ce94534-33c6-e2b8-0876-bb1b1df9c968",
          "attributeId": "704cea13-77e0-4087-9136-561b7c7743b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "710e2b43-f7e0-6212-860d-ce2b81c1b8a9",
          "attributeId": "96f391bb-a0b5-4c38-a382-d8b963a88524",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0a91d59d-89b6-f990-f8f5-f13e46156e7a",
          "attributeId": "e40d9199-bbba-4267-b632-7c1fd80f2021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad277186-481e-bbc8-1c86-5a57b23d0572",
          "attributeId": "0b1faa54-a4d7-4f86-9010-c00bc1d6592a",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__previousSurveyCard_totalcount"
    },
    {
      "id": "3f2e73d6-0cf0-3307-19b8-9d09585825d1",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "currentSurveyGrid",
      "dataMap": [
        {
          "id": "1d6965dc-fa6e-6034-ed1d-277be2965a2c",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "576b598e-7954-8254-3a58-9bd6c2f087ff",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "28c1f34b-6522-cd89-adad-61fee9f7a3d8",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad96c1d9-d615-8a11-5bc4-413a87f43a92",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "daa92a4a-8edd-7e76-a383-435fff12b5f2",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "818f5aaa-46e3-b965-a121-742ce9da5033",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ebc0b763-5182-b56a-f6e6-c279c56c7df3",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cdd8a270-e3cf-972c-3fb2-f04136aa2f2e",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3df443ef-253d-b9b0-9fbd-285a55aacf2c",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b96abff-3bac-a864-f16c-83947f5515c3",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "42a4ac50-8b5a-0464-e4c4-b48a3242e89e",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9ad27adf-0b03-ef3c-296a-f136dc97bb54",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "623d1b17-e078-550e-a950-762df011e251",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "755ac48d-abf6-fc1b-936a-0a1cd57aedff",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ab96b38-f523-be22-8bcd-3cf56ead7275",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2078a82c-6114-c493-78d2-59f25eebcab7",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e7db3353-26ce-c0ce-849a-0bd7f5c61bb9",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1ed84365-f9ad-d2b6-1c9c-221432d735a0",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c2b3faae-5a6d-c26b-02df-35dbad803724",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0898e6f3-6a2b-e50c-226f-9399ecf699c4",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e42d569d-ccf3-dee4-f978-e9accafa38c1",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b444875b-eaa1-00c7-5002-c8c2713f360c",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9ed5909a-2acd-cfcd-2f90-044db07af4a9",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aaa011c2-d0ec-4965-82ff-51b7845fe67c",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b967f7c-d88c-e5df-22fb-4b29ca67fbaa",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4bd7c97d-5d0a-c847-0e00-4b46153f7ab1",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "574ce0fb-03c2-e12c-e424-c1d630ef67c5",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df36a431-1e6c-3c49-7437-5284fe51f4f8",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7b79c5f3-57c6-6d0e-ea54-41bf0e28f4d2",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "857a6b81-1bd5-2ea2-3197-4be3be912d5b",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5c5c0c39-c380-2cb3-cb50-520ebcc09405",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff4dfa07-8e3c-dbb3-a1e9-cce5d31caa14",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f39a1d4-9beb-84c4-a3bc-6d80045dc241",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4843e9fa-fe70-4fd5-22a4-348e71f84d71",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d23fda3a-8406-bc58-7481-708c5b6d71f9",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "199211f6-893b-4c1f-5fdf-cc652b56c3f8",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57169652-ffe4-de60-76e1-1b6ae944127a",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df4c2523-6edb-305e-30d1-4814daaa990d",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11d38933-ad1a-f321-95fc-62c019dd807b",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f3b61b98-ec26-3351-46a3-a6fded595fa3",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11f6b106-af11-57a1-4b81-5831eb4ada12",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c9f818fc-9b35-2658-47f8-3a8d6aa865bd",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f56bf117-2c10-bb82-de72-33c67ff91973",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "301beba0-d056-e483-18a9-c47d73f5eaff",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4268e857-6ed3-053b-52c7-24792481f70e",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d3cae0f-e4d9-79cb-ec24-92ba45e374ee",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ec6beee7-d8cb-4627-4787-54adfa672fd3",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "82c68b91-267f-2c79-79d8-03a8d9dc893b",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1b7836a5-8ed4-e24d-2af6-b9cda77cf2a7",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "48d3ebd4-0c8b-4bac-9936-679dcdda86d2",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ba292798-7722-d06a-bd2f-0dbd4d145878",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "393bae36-e19d-ab04-7616-65367906e115",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b4f42f3c-67ec-3597-37ed-99bdbfb5b446",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cbdec15c-9ef3-df88-fb61-9845077573c0",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c104e5d4-dae9-4fbf-41cf-045d63c3ce30",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f6b59eb-a5d8-b82c-59fa-869b7f2a5d7f",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "be59f6ea-5819-849e-ca8b-ddf4cdb738ff",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "97fb47a6-63df-ae91-e224-4ae28fcb22fa",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4383ada2-9283-b13c-ce6e-245eda2b2edd",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5d90a4f3-5c19-bfc6-484d-53adc43846fa",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09ff060f-8ec8-752e-3a3f-783e9e12190c",
          "attributeId": "f384f444-143d-43e7-8727-09b545ed8819",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3c197553-841d-7204-e64e-3b138844c116",
          "attributeId": "704cea13-77e0-4087-9136-561b7c7743b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a8d7f08-459c-95c0-25d4-866eb64bd199",
          "attributeId": "96f391bb-a0b5-4c38-a382-d8b963a88524",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c1f39503-206d-a992-fe0d-2179f5b2c2f7",
          "attributeId": "e40d9199-bbba-4267-b632-7c1fd80f2021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c5f70ee0-1b7c-7b71-aac2-b3a98e9edc80",
          "attributeId": "0b1faa54-a4d7-4f86-9010-c00bc1d6592a",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__currentSurveyGrid_totalcount"
    },
    {
      "id": "5ba9d735-5df0-4e0d-7414-6efcfcffbd86",
      "entityId": "cb3d079f-a052-45a1-a143-75a5c0ca1d23",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{ Comment: \"This collection and filter serve only as a placeholder under u@app.\" }",
      "control": "previousSurveyGrid",
      "dataMap": [
        {
          "id": "26762b17-40df-b1a5-6be7-2930a7e50c47",
          "attributeId": "cae9de15-e878-4755-8dc8-b036e25105dd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bd947759-d1b5-c886-ae2c-1cccf87be6fa",
          "attributeId": "92fc64bc-7dac-4784-b28f-9925c3fbfcf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c18faea0-3021-89af-3c83-4c8499c09077",
          "attributeId": "e0150db6-09d7-493a-85bb-c64edc0fdef5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "597c23c5-2f17-5626-b164-f10d0029740d",
          "attributeId": "a27fc32b-7767-41a8-bb98-c4e4aa67e8e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "146d715e-3407-8bff-d065-ce0e61babaa5",
          "attributeId": "cacf4955-97f6-4929-a5a6-9b4e8d318961",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2677e022-b280-679f-1580-44f3927feb41",
          "attributeId": "dc0a72e0-86d7-41ae-ac29-b40e9b3d86b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a04a2049-e5a7-fc4a-56e6-6493ace02738",
          "attributeId": "3f8a5fbf-78cd-45cd-a1ec-a37eb15fa904",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89e224e7-8679-d433-3085-77f2cef93f54",
          "attributeId": "1d56eb13-1460-4fd9-86dd-18b19e80bda1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fcbab297-ae3f-b501-db21-ab2a5ff806b4",
          "attributeId": "2dd4b24f-6824-4bc3-9b7f-d673469ec51a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "68bfc8bd-faab-37d2-e748-28918790fc50",
          "attributeId": "eb4d4b03-a5d0-4c29-871a-5c0118a70ed7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "34a8281a-de77-2628-d148-afb9dad81f80",
          "attributeId": "16185f31-6818-41e0-8d67-d2ad33108559",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "540af14b-a87b-423a-7835-626fd681096f",
          "attributeId": "479306ee-bd4a-4447-aff7-e535ae3cc458",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0c501a3d-6a4e-34e5-48c4-13b3d319b202",
          "attributeId": "54dc98a9-8012-4b39-87a1-0f9869b815e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76d00fbb-40ed-7615-a3ce-4e61ef818f34",
          "attributeId": "979c3398-38e0-4d66-b349-85d17d150b27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0da50bba-03eb-a1b4-6af3-6798067657d0",
          "attributeId": "255c908a-2261-40c4-b363-2e3300ddfd55",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "49f6edc2-1286-cde5-abfd-ff863fb6b67d",
          "attributeId": "8205f5fe-9ed9-419e-b954-e6547741a34e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd6d03dd-b7dd-d77c-53c6-526511957436",
          "attributeId": "1e97d0c3-cc4a-4799-815e-9623343ebd2f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fe41e113-3f7a-a13d-d44c-f120401804f8",
          "attributeId": "4901a17f-3666-4b6a-a40c-eccd9482df3b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "40aa5ea8-ab8b-32e6-684e-2e5cda96f6aa",
          "attributeId": "61bf4dac-d7cf-4843-a231-1c5e80382e35",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "17599c1e-9fb1-be59-decf-1074d254fb30",
          "attributeId": "8c9d78b3-a1d0-4961-9976-3fd4d22957f1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e0017f5-8ccb-db72-e3d7-60e91dd7eeff",
          "attributeId": "8671635c-b1ca-4ca3-8312-30c548a7b579",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e2906190-2fb1-dcd0-fb2c-cdfa13d13cc7",
          "attributeId": "532327eb-fce5-46d4-ad4c-772823325636",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "82e347d4-0f20-aeb2-654c-57c9b4bdb04f",
          "attributeId": "18734c70-0971-491b-b0ed-8480b5869727",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0871bbe0-f8c1-6e71-4707-12306cee6b83",
          "attributeId": "ef07f541-642e-4b19-8987-74f595fc66e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e92232f4-5e48-9258-ddf1-553ac0d344d1",
          "attributeId": "7c1e9bf9-2a55-4409-bffc-d0af9d81f00a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3c131db1-9bd6-d467-95a3-783f202ee82b",
          "attributeId": "c4ade896-633d-4e34-9c58-f7c7cd0ff67b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e8f5afe-bf1c-d2bd-6bb0-5e30c2ce9efc",
          "attributeId": "6e9d3238-478e-4da6-b76c-68c5e83bd266",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "55780bd9-8529-28a7-36a1-e3545f8f483c",
          "attributeId": "03ee3b57-2f4b-4c6a-bd38-a78e23e0dc7a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4f21e7a-d0c4-7236-2f1e-b7c0f5256882",
          "attributeId": "14a6b8b8-d044-41cf-a2e3-dca89357a8b5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cb57c9c6-abde-3c9f-37d2-16ecdf799d58",
          "attributeId": "46d48649-a63a-4a70-b1a8-8e8c26072b5f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "75a2d486-ebee-ed64-ecd1-bcc248105d44",
          "attributeId": "72cae622-a283-4bde-bdb1-5150f2c2e392",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d535eb3-cdab-95e8-c372-e4500cc52889",
          "attributeId": "432c5a56-5a53-43f8-8d4d-0157d3d9585b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b10dec8c-f61f-4bb2-80e1-9cf89ec03c9b",
          "attributeId": "27642cea-16cd-4e39-824f-a4811f3bc399",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45431ab6-7003-0e16-f43b-616bf04f4b1b",
          "attributeId": "ec2a50df-9d88-4bcd-835e-658480662e93",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "03c62d73-e409-1025-0cb3-cabf6e9e613e",
          "attributeId": "abeadf3f-228c-4173-844d-4b3da7ee39d8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "38e841b9-9245-797b-d617-ed01eb75d232",
          "attributeId": "fabd0251-b03f-4485-af61-7e5419b99995",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "50170606-42f5-ff45-b683-cffcc9dbe783",
          "attributeId": "1353884d-9490-4c26-bd4f-215fc6c6a6b7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2248a29d-1c53-959c-0215-9d1905075764",
          "attributeId": "1346458a-026a-4e38-a3d4-4fb7cd7fe659",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "429336ea-b659-75e5-4f3d-5865f6d25bf8",
          "attributeId": "a077938a-1661-465d-a937-8b0d080e95c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b53e5451-e938-0918-3a0b-f69948be55a3",
          "attributeId": "397fc49f-bd27-4669-ab8c-d3956d11c281",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "55201659-2d9c-3dea-1f16-838bd9c6a841",
          "attributeId": "d8571666-2346-42d5-bbed-b0ecd5e71913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "82e4d2cc-779b-c3ee-cb2b-f38c27389425",
          "attributeId": "4cd76fef-b480-4499-a1f6-108a298b1bf3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "28567a74-eb01-329c-7326-fe468ab54f54",
          "attributeId": "16e4df41-d909-4a3b-9bbf-097d1b1278b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c5986a54-7f76-1640-884a-341bb7926d96",
          "attributeId": "fb7daa2c-d041-4ce6-8cd7-f09515d5d22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "71de305e-6919-8a67-35de-121067e07447",
          "attributeId": "016dbcbd-802b-439b-95f6-d0d531f7cc18",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19836fc4-30f5-6275-41c8-af8466eb1823",
          "attributeId": "2fa5d5af-f73e-445e-828c-f1cecf73b4e7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e351849-68f5-c4a1-4ea2-fa3e7670b929",
          "attributeId": "d272ccc1-e982-4c94-809b-599fcb8fd248",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7f10ad5f-d925-0c51-4527-1a5f5b94c262",
          "attributeId": "fccc2163-ff7a-4f82-884c-5324848049b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d1f518ba-7ccf-3110-2e25-2d0d712b3866",
          "attributeId": "da231bf3-32ba-499c-8234-0ab51434bc34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6206da19-411d-1db4-3045-1306f2ce83d1",
          "attributeId": "0fd9aca5-afda-4cb2-9ed2-c9012150501e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c544897b-3513-1f63-3052-dd099836ce29",
          "attributeId": "fefb04a4-9410-4def-a31e-055ab6bbbb33",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9592fce-eb79-7b48-cc16-17d8097c4121",
          "attributeId": "5f01ec1a-9752-4062-b954-4b251862e473",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d51b2ccc-2954-2cea-855c-319bbd2bb616",
          "attributeId": "3ccdd014-c18d-41e6-b32a-8d4fec750978",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84d9260e-0ebf-aede-426b-74d7bc3bdb99",
          "attributeId": "21ddf70c-0c58-4cc3-8818-10cec65b4472",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ee1eaee4-3bb6-29b6-2b1b-2c11698f9097",
          "attributeId": "88faf742-166e-4acb-bf00-9870fb94f619",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "64dc768e-91f7-c1aa-5553-efe7a5a88470",
          "attributeId": "7b8329e8-b08a-4163-a260-088c6e7fc98f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "109b725a-a748-e50d-e8c7-fec52adfc7f5",
          "attributeId": "e3222688-50e3-464c-b6f3-ae3e6cf9443c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4a2fdcc8-f2e3-2bbb-8279-287eac6f1d01",
          "attributeId": "f4cbe5ea-7299-4497-93b4-4306fee93f34",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae80ecd7-0c1b-48cd-5188-d90f0c2205a9",
          "attributeId": "7ef8776b-3386-41b2-86cb-2a1fa5dbd455",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e3ede2d-7c87-23c6-38e9-d25759c230f0",
          "attributeId": "09c0782d-4bde-41eb-9f20-724456aa6ad3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7125a7d2-b67c-7952-52e5-a204a75988cb",
          "attributeId": "f384f444-143d-43e7-8727-09b545ed8819",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "47991fc6-2381-2dde-40e6-c14d02441a7d",
          "attributeId": "704cea13-77e0-4087-9136-561b7c7743b2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "819cb610-7527-13fd-feec-9e9066f1f215",
          "attributeId": "96f391bb-a0b5-4c38-a382-d8b963a88524",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5441b791-b7c8-bd06-bda8-6a94c9fafb9a",
          "attributeId": "e40d9199-bbba-4267-b632-7c1fd80f2021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ce294a08-09ea-25f6-5294-5bb95bc0c5de",
          "attributeId": "0b1faa54-a4d7-4f86-9010-c00bc1d6592a",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__previousSurveyGrid_totalcount"
    }
  ]
}' WHERE [Id]='50a76e5a-98f3-44bf-a161-003ed4fb2f3b';

