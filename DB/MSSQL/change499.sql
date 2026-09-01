-- Will INSERT row(s) into dwMetadata for the following:
-- dplySample.json
-- dplySample-settings.json
-- dplySample-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- base.json
-- dplysampleowner.json
-- dplysampleowner-settings.json
-- dplysampleowner-code.js

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'ef5a5a02-0bc5-4c44-8abe-c8628521e9f6', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'dplySample.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-06-13 13:18:52.420', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-07-18 11:25:34.103', 
N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "{Name}",
    "size": "huge",
    "subheader": "Assignment by Sample"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnAssignmentOfDataOwners",
        "data-buildertype": "button",
        "content": "Assignment of Data Owners",
        "primary": true,
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
        }
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
            "paging": false
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
                "active": true,
                "actions": [
                  "console"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "pointing": false,
            "secondary": false,
            "compact": false
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
                "key": "dictDataEditor",
                "data-buildertype": "dictionary",
                "label": "Data Editors",
                "fluid": true,
                "selection": true,
                "dataModel": "vSP_dataEditors",
                "columns": "Name ASC",
                "search": true,
                "clearable": true,
                "multiple": true,
                "events": {},
                "style-marginBottom": "",
                "style-width": "400px"
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-marginTop": "10px",
                "style-marginBottom": "10px"
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
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'89e87aee-5756-4c59-bb15-3304534a03c6', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'dplySample-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-06-13 13:18:52.550', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-07-18 11:25:34.133', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplysample",
  "lastUpdate": "2024-07-18T11:25:34.1337367+08:00",
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
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'7ef32ac9-b0ae-4d0f-bb91-70bcb1ff772f', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'dplySample-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-06-14 11:53:24.827', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-07-18 11:25:41.757', 
N'{
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
        var respDateStartVal = result.RespDateStart !== null ? dayjs(new Date(result.RespDateStart)).format(''DD MMM YYYY HH:mm'') : '''';
        content += "<tr><td " + tableStyle + ">Response Start</td><td>" + respDateStartVal + "</td></tr>";
        var respDateEndVal = result.RespDateEnd !== null ? dayjs(new Date(result.RespDateEnd)).format(''DD MMM YYYY HH:mm'') : '''';
        content += "<tr><td " + tableStyle + ">Response Complete</td><td>" + respDateEndVal + "</td></tr>";
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
        //const sampleOwnerIds = gridSelectedIndexes.map(i => gridItems[i].lsoId);
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
}');

UPDATE [dwMetadata] SET
[Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/localization', [FileName]=N'base.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:10.700', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-17 13:11:06.060', 
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

UPDATE [dwMetadata] SET
[Id]='b2c5fd29-64a3-4d9a-8cc2-5a3c9c739089', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.740', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-18 11:24:33.987', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "{Name}",
    "size": "huge",
    "subheader": "Assignment of Data Owners"
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-float": "",
    "children": [
      {
        "key": "btnAssignmentBySample",
        "data-buildertype": "button",
        "content": "Assignment by Sample",
        "secondary": false,
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
                "value": "dplySample"
              }
            ]
          }
        },
        "floated": "",
        "style-marginLeft": "",
        "other-visibleConition": "",
        "primary": true,
        "inverted": false
      }
    ],
    "style-marginBottom": "20px",
    "style-marginTop": "",
    "style-width": "100%"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "style-float": "",
        "children": [
          {
            "key": "header_4",
            "data-buildertype": "header",
            "content": "Bulk Assignments and Unassignments",
            "size": "medium"
          },
          {
            "key": "container_14",
            "data-buildertype": "container",
            "children": [
              {
                "key": "mdlBulkUploadAssignments",
                "data-buildertype": "swzmodal",
                "style-display": "none",
                "children": [
                  {
                    "key": "header_3",
                    "data-buildertype": "header",
                    "content": "Upload Assignment CSV",
                    "size": "medium"
                  },
                  {
                    "key": "message_1",
                    "data-buildertype": "message",
                    "header": "",
                    "content": "CSV file must contains UID and UserName in header.\nUID is the sample UID and UserName is the name of the data editor.",
                    "info": true,
                    "compact": false,
                    "success": false
                  },
                  {
                    "key": "form_1",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "container_15",
                        "data-buildertype": "container",
                        "style-width": "",
                        "children": [
                          {
                            "key": "assignmentUploadFile",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "file"
                          }
                        ],
                        "style-float": "",
                        "style-marginBottom": "",
                        "style-marginRight": ""
                      }
                    ]
                  },
                  {
                    "key": "container_16",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "btnUploadAssignment",
                        "data-buildertype": "button",
                        "content": "Upload Assignment",
                        "secondary": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "UploadAssignmentCSV"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "floated": "",
                        "primary": true
                      },
                      {
                        "key": "uploadAssignmentClose",
                        "data-buildertype": "button",
                        "content": "Cancel",
                        "secondary": true,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "closeAssignmentUploadModal"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "floated": ""
                      }
                    ],
                    "style-marginTop": "20px",
                    "style-float": "right",
                    "style-marginBottom": "20px"
                  }
                ],
                "primary": true,
                "style-hidden": false,
                "disabled": false,
                "style-source": "",
                "content": "Upload Assignments",
                "events": {
                  "onClick": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-marginBottom": ""
              }
            ],
            "style-hidden": false,
            "style-float": "left",
            "style-marginBottom": ""
          },
          {
            "key": "btnBulkDownloadAssignments",
            "data-buildertype": "button",
            "content": "Download All Assignments",
            "secondary": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "getSampleOwnerCSV"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "floated": "",
            "style-marginLeft": "",
            "other-visibleConition": "",
            "primary": true
          },
          {
            "key": "deleteAllBtn",
            "data-buildertype": "button",
            "content": "Delete ALL Assignments",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "deleteAllAssignment"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deleteAllSampleAssignmentTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deleteAllSampleAssignmentText"
                  }
                ]
              }
            },
            "floated": "",
            "style-marginLeft": "",
            "other-visibleConition": ""
          }
        ],
        "style-marginBottom": "20px",
        "style-marginTop": "",
        "style-width": "100%"
      },
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<hr>",
        "isHtml": true
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "header_5",
            "data-buildertype": "header",
            "content": "Selective Assignments and Unassignments",
            "size": "medium"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-width": "",
            "children": [
              {
                "key": "DataEditor",
                "data-buildertype": "dictionary",
                "label": "Data Editors",
                "fluid": true,
                "selection": true,
                "dataModel": "vSP_dataEditors",
                "columns": "Name ASC",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "onChangeDataEditor"
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
                "style-source": ""
              }
            ],
            "style-float": "left",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "btnDownloadAssignments",
                "data-buildertype": "button",
                "content": "Download Data Editor Assignments",
                "secondary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "getSelectedSampleOwnerCSV"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "left",
                "primary": true
              },
              {
                "key": "btnAssignAllSamples",
                "data-buildertype": "button",
                "content": "Assign All Samples",
                "secondary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "AssignAllSamples"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "",
                "style-marginLeft": "",
                "other-visibleConition": "",
                "primary": true
              }
            ],
            "style-marginBottom": "20px",
            "style-marginTop": "",
            "style-width": "",
            "other-visibleConition": "!(data.DataEditor == null || data.DataEditor == '''') ? true : false",
            "style-marginLeft": ""
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-source": "clear:both;"
          },
          {
            "key": "container_8",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_11",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "modalTsfSampleOwner",
                        "data-buildertype": "swzmodal",
                        "style-display": "none",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Transfer Assignment to Data Owner",
                            "size": "medium"
                          },
                          {
                            "key": "container_10",
                            "data-buildertype": "container",
                            "style-width": "",
                            "children": [
                              {
                                "key": "dictTsfDataEditor",
                                "data-buildertype": "dictionary",
                                "label": "Data Editors",
                                "fluid": true,
                                "selection": true,
                                "dataModel": "vSP_dataEditors",
                                "columns": "Name ASC",
                                "events": {
                                  "onChange": {
                                    "active": false,
                                    "actions": [
                                      "onChangeDataEditor"
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
                                "style-source": ""
                              },
                              {
                                "key": "container_12",
                                "data-buildertype": "container",
                                "children": [
                                  {
                                    "key": "button_1",
                                    "data-buildertype": "button",
                                    "content": "Save",
                                    "secondary": false,
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "tsfDplySampleOwner"
                                        ],
                                        "targets": [
                                          "dataEditorGv"
                                        ],
                                        "parameters": []
                                      }
                                    },
                                    "floated": "",
                                    "primary": true
                                  },
                                  {
                                    "key": "btnTsfModalClose",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
                                    "secondary": true,
                                    "events": {
                                      "onClick": {
                                        "active": true,
                                        "actions": [
                                          "closeTsfDataOwnerModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "floated": ""
                                  }
                                ],
                                "style-marginTop": "20px"
                              }
                            ],
                            "style-float": "",
                            "style-marginBottom": "",
                            "style-marginRight": ""
                          }
                        ],
                        "primary": true,
                        "style-hidden": true,
                        "disabled": false,
                        "style-source": "",
                        "content": "Transfer Selected Assignments",
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "openTsfModal"
                            ],
                            "targets": [
                              "dataEditorGv"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-hidden": false,
                    "style-float": "left",
                    "style-marginBottom": ""
                  },
                  {
                    "key": "deleteBtn",
                    "data-buildertype": "button",
                    "content": "Delete Selected Assignments",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "deleteDplySampleOwner"
                        ],
                        "targets": [
                          "dataEditorGv"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "deleteSampleAssignmentTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteSampleAssignmentText"
                          }
                        ]
                      }
                    },
                    "floated": "left"
                  }
                ],
                "style-marginTop": "",
                "style-marginBottom": ""
              },
              {
                "key": "container_13",
                "data-buildertype": "container",
                "events": {},
                "style-source": "clear:both"
              },
              {
                "key": "dataEditorGv",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "username",
                    "name": "User",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false
                  },
                  {
                    "key": "uid",
                    "name": "UID",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false
                  },
                  {
                    "key": "name",
                    "name": "Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false
                  },
                  {
                    "key": "statusTitle",
                    "name": "Status",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false
                  },
                  {
                    "key": "segment",
                    "name": "Segment",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false
                  },
                  {
                    "key": "respDateStart",
                    "name": "Response Start",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "datetime"
                  },
                  {
                    "key": "respDateEnd",
                    "name": "Response Complete",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "datetime"
                  },
                  {
                    "key": "dueDate",
                    "name": "Due Date",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "datetime"
                  }
                ],
                "defaultSort": "Username ASC, UID ASC",
                "rowKey": "PK",
                "multiselect": true,
                "events": {
                  "onSelectionChanged": {
                    "active": false,
                    "actions": [
                      "onChangeSegment"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "minHeight": "300px",
                "pagerType": "",
                "pageSize": "500",
                "rowHeight": "80",
                "style-marginTop": "10px",
                "other-visibleConition": ""
              }
            ],
            "style-width": "",
            "style-marginTop": "20px",
            "other-visibleConition": "!(data.DataEditor == null || data.DataEditor == '''') ? true : false",
            "style-customcss": "ui message"
          }
        ],
        "style-width": "100%",
        "style-marginBottom": "20px",
        "style-marginTop": "20px"
      }
    ]
  }
]' WHERE [Id]='b2c5fd29-64a3-4d9a-8cc2-5a3c9c739089';

UPDATE [dwMetadata] SET
[Id]='62be1681-cb69-4112-ba0b-9cfb32724b58', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-18 11:24:34.143', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplysampleowner",
  "lastUpdate": "2024-07-18T11:24:34.1369921+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "80c4025d-a1b5-5d93-5825-279725028d24",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "901c16d0-fc25-1b61-376d-23fb0270d404",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f68a406e-8da0-3479-796a-8034e07ab61d",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee1f9e69-af87-3801-92f7-984865afd1f2",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ec31d1c7-abab-ee75-1ea1-d5a4346af1dc",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "494fd8af-a728-ec33-85f6-0af37d245a95",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5f351be5-0f67-0a8b-6371-2b6c853a14c9",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8611ba8b-fbe4-d5de-9f6c-0f2da88957e0",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "582e7cf7-a157-58ea-0a32-d4cdf3d6e93e",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2eb47227-6587-2c5e-5ba0-8eba482acbbf",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e15f706b-222a-69d6-74d9-87f010610132",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2a936e4-8700-3413-e949-d295f795d7c3",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4bbacc00-08b7-1a35-0816-8a811350d70e",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "529dd847-2c5f-e16f-314e-2a9656ad132a",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "305bf785-7173-fcaa-20ae-5df19a961475",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "327346e6-06cc-4bd5-afd1-b254444eca88",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "616c46b2-cd55-c8c1-2123-e074381efaaa",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8e08ced6-654c-10b7-e3b9-25ff194e095d",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6cea3e31-785d-665a-031f-d4a8503decd6",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ec1adc3-17cd-5f4d-99ce-ab681ea403b6",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b273e574-cf6a-fa2e-58ff-3abaf5673ffd",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a2a96cb8-ab98-3c5e-30b6-af24cac00789",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32d4e95b-0618-3fbc-7442-25198e6ef924",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7da9872-3d06-d7b8-e9c4-82e7236aa0e8",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a12c806-22e9-0f25-bdc3-3c857901e249",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8928f0c8-f551-a819-8d91-5d2a91ef0866",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b6b6da2e-3c1b-1dde-97cb-933734f8df6c",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2bb247d9-656f-67af-0b35-43adf04bfdeb",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "506dc64a-746b-87c8-e5fe-371de29ef82e",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ad33eaa-9824-b038-915c-a4df2b4d830d",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "13150b13-0d45-bd6d-5dd4-d879689d3d79",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54e9d9d4-b1a8-5f3f-bd39-a96d7be510e3",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e96d833-4957-cd10-f586-f75aa8ffb37a",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4040f278-5916-ed95-b802-c811002bbbbd",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f38f9500-2322-2115-1841-736523cf5af9",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fdaf4c32-aca9-d483-a117-6c2b8ea2261c",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e0bdca9d-5e7b-73c6-8e26-f03dde3a1217",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e06c910-cc36-c093-f646-2320378a3dc2",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "38be3a79-f383-c763-2935-7f6a313294cb",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ef758958-77a4-025b-2dd8-916e1361618d",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e65662c-3fb6-0f60-64a2-779ec1323a80",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24a77797-abf2-d920-5b82-de61d9c99498",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "88109494-aae6-b1bb-9d3a-97042849ba53",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2ed5b9f7-2bde-51c0-18dc-4ad5a90c5cc2",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aac70eda-94a7-5f99-e02e-3000669c6390",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "67119abd-97a2-adaf-c2a9-28fb3359ec6e",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ce8a0908-29b2-5b13-487b-8e6563000310",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ea175f7a-7e3d-57c2-4c24-1c42bf7bd774",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "69935918-6f30-b098-6cb4-9859e5448f31",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5cc2a93-560e-0658-580b-de5321f96ec5",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "111923d6-c888-2568-6f10-ec57c5a05add",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "145cdb0a-19e1-2ae3-a497-478b95ce61fc",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f397cfc2-ab18-b73f-471a-7b562fd0d42d",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "22c63a21-900f-879a-2339-4f03a593ed15",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "381901da-eb41-2a6a-bad4-e8eeed96de59",
      "attributeId": "50dc8926-bba9-4c03-9a59-267aab2f1999",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9021a153-c0a8-e175-ec03-058d1cccc327",
      "attributeId": "31d51bc5-36d1-4d4a-9ba3-800e5245f1d8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cc8a6185-77b6-840d-e965-93a105cfbab6",
      "attributeId": "d71d57fd-f787-4130-ac9e-28276b1988ed",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d738ec71-1688-b543-99f7-88a7852d21a4",
      "attributeId": "f05b253e-d4b3-4cda-bd78-0175b0b18e07",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3c2e175e-f2b1-2452-289b-983d11cfb878",
      "attributeId": "7cdb2342-264a-4c24-91ac-1dfac739a199",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee4a258d-b83a-aeac-3489-2a0a44b20d5d",
      "attributeId": "565a7e02-6340-4b9d-ac07-2c2ecf89a069",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "850b74c2-ba1f-9209-3289-bbd502012bd3",
      "attributeId": "e2c19db6-dc23-414e-ba88-f51f92ff580f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa23be27-e481-fcba-92b2-610f9b1b0110",
      "attributeId": "b1f366b5-eccd-4ae3-9442-b4379c68ab65",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "abd4002d-3c09-1be5-f13a-a89b7a7c1b25",
      "attributeId": "73d3d704-8028-41ec-92ef-43fdbadc124f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f642010d-326f-e0ed-0fbe-b6a6bdf9575b",
      "attributeId": "fcf9895c-7f3e-4e6e-afe2-0eb2d9462afd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2ba3e12f-cd12-f2aa-ca16-6d285172ba9e",
      "attributeId": "595da6d0-43c2-4faf-8b64-242a5e2a9c10",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "SetDataEditor"
}' WHERE [Id]='62be1681-cb69-4112-ba0b-9cfb32724b58';

UPDATE [dwMetadata] SET
[Id]='a6712791-65c1-463b-bd07-3a2bdac69c68', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.640', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-18 11:24:50.843', 
[Data]=N'{   
    deleteAllAssignment: function(args){
        const dplyId = args.data.Id;
        const dataEditorGv = args.component.refs.dataEditorGv;
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        Utils.postFormRequest("/deployment/deleteAllDataEditors", formData).then(
            response => {
                dplysampleownerUserActions.onChangeDataEditor(args);
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    AssignAllSamples: function(args){
        if(!args.data.DataEditor) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        const dplyId = args.data.Id;
        Utils.loadingStart("Adding assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        formData.append("userId", args.data.DataEditor);
        Utils.postFormRequest("/deployment/addAllSamplesToDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
            }, reason => {
                console.error("Failed to add all assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    tsfDplySampleOwner: function(args){
        const dataEditorIds = args.data.dictTsfDataEditor;
        const dplyId = args.data.Id;
        const sampleOwnerIds = args.data.tsfSampleOwnerIds;
        
        Utils.loadingStart("Transfering Assignments...");
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''dataEditorIds'', dataEditorIds);
        formData.append(''sampleOwnerIds'', sampleOwnerIds);  
        Utils.postFormRequest("/deployment/TsfSamplesToDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
                CloverApp.API.setDataField("dictTsfDataEditor", null);
            }, reason => {
                console.error("Failed to transfer assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        dplysampleownerUserActions.closeTsfDataOwnerModal(args);
    },
    
    openTsfModal: function(args){
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        const sampleOwnerIds = gridSelectedIndexes.map( i => gridItems[i].lsoId );
        if(gridSelectedIndexes.length===0){
            dplysampleownerUserActions.closeTsfDataOwnerModal(args);
            alertify.error("No assignments selected"); 
            return {};
        }
        CloverApp.API.setDataField("tsfSampleOwnerIds", sampleOwnerIds);
    },
    
    closeTsfDataOwnerModal: function(args){
         args.component.refs.modalTsfSampleOwner.close();
    },
    
    deleteDplySampleOwner: function(args){
        const dataEditorGv = args.component.refs.dataEditorGv;
        const dplyId = args.data.Id;
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''sampleOwnerIds'', gridSelectedIndexes.map( i => gridItems[i].lsoId ) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                dplysampleownerUserActions.onChangeDataEditor(args);
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    onChangeDataEditor: function(args){
        var data = args.data;
        var selectedDataEditors = data.DataEditor;
        var filterArr = [];
        var dplyId = args.data.Id
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            return CloverApp.API.setDataField("dataEditorGv", []);
            args.component.refs.dataEditorGv.forceUpdate();
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        Utils.loadingStart();
        Utils.getRequest("/deployment/getDplySampleOwner?dplyId=" + encodeURIComponent(dplyId) + "&strUserIds=" + encodeURIComponent(filterArr))
        .then(response => {
                if(response.success && response.item !== null) {
                    var result = response.item;
                    CloverApp.API.setDataField("dataEditorGv", result);
                }
            }, reason => {
                if(reason == ''NO_ASSIGNMENT''){
                    CloverApp.API.setDataField("dataEditorGv", []);
                } else {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            }
        ).finally(() => {
            Utils.loadingStop();
            args.component.refs.dataEditorGv.forceUpdate();
        });
    },
    
    getSampleOwnerCSV: function(args, strUserIds) {
        var userIds = null
        var dplyId = args.data.Id;
        
        if(strUserIds != undefined)
            userIds = strUserIds;
        let defaultFormName = args.data.Name + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.dplysampleowner.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.dplysampleowner.provideName);
          }
        }
        var url = ''/deployment/getSampleOwnerCSV?dplyId='' + encodeURIComponent(dplyId) + ''&fileName='' +  encodeURIComponent(inputName)  + ''&strUserIds='' +  encodeURIComponent(userIds);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    getSelectedSampleOwnerCSV:function(args) {
        dplysampleownerUserActions.getSampleOwnerCSV(args, args.data.DataEditor);
    },
    
    closeAssignmentUploadModal: function(args){
         args.component.refs.mdlBulkUploadAssignments.close();
    },
    
    UploadAssignmentCSV:function(args) {
        var dplyId = args.data.Id;
        var token = args.data.assignmentUploadFile;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please", 15000);
            return {};
        };
        const formData = new FormData();
        formData.append("token", token);
        formData.append("dplyId", dplyId);
        Utils.loadingStart();
        Utils.postFormRequest(''/deployment/setSampleOwnerCSV'', formData).then(
            response => {
                if(response.success && response.item !== null) {
                    alertify.success( Utils.encodeHTML(response.message), 10000);
                    CloverApp.API.setDataField("assignmentUploadFile", null);
                    dplysampleownerUserActions.onChangeDataEditor(args);
                    args.component.refs.mdlBulkUploadAssignments.close();
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally( Utils.loadingStop );
    },
    
}' WHERE [Id]='a6712791-65c1-463b-bd07-3a2bdac69c68';

