-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyValidation.json
-- dplyValidation-settings.json
-- dplyValidation-code.js

UPDATE dwMetadata SET
[Id]='7cb209ee-3094-4ef1-b530-74ca26baba6f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyValidation.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-12 13:45:29.520', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-09-29 13:37:20.030', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "ImportReportModal",
        "data-buildertype": "swzmodal",
        "content": "ImportReportModal",
        "style-display": "block",
        "children": [
          {
            "key": "header_5",
            "data-buildertype": "header",
            "content": "Dataset Import Complete",
            "size": "large",
            "textAlign": "left"
          },
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Datasets imported</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{ImportReportImportCount}</td></tr>\n<tr><td>Rows ignored</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{ImportReportIgnoredCount}</td></tr>\n<tr><td>Rows with duplicated UID</td><td style=\"color: black; padding-left: 32px; text-align: right; padding-right: 32px;\">{ImportReportDuplicateCount}</td></tr>\n<tr><td>Invalid rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{ImportReportInvalidCount}</td></tr>\n</table>",
            "isHtml": true,
            "style-font-size": "20px"
          },
          {
            "key": "container_6",
            "data-buildertype": "container",
            "children": [
              {
                "key": "button_4",
                "data-buildertype": "button",
                "content": "Close",
                "secondary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "cancelModal"
                    ],
                    "targets": [
                      "ImportReportModal"
                    ],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "text-align: right;",
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-hidden": true
  },
  {
    "key": "frm_Validation",
    "data-buildertype": "form",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Data-to-Data Validation Properties",
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
        "key": "IsDataToData",
        "data-buildertype": "checkbox",
        "label": "Enable Data-to-Data Validation",
        "toggle": true
      },
      {
        "key": "fg_DataToData",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "other-visibleConition": "data.IsDataToData",
        "children": [
          {
            "key": "fg_Datasets",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Validation to uploaded datasets",
                "size": "small"
              },
              {
                "key": "hide_the_file_input",
                "data-buildertype": "container",
                "style-hidden": true,
                "children": [
                  {
                    "key": "UploadDataset",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "file",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "onImport"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": true,
                        "actions": [
                          "test"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-hidden": true,
                    "customPostUrl": "",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_2",
                "data-buildertype": "container",
                "style-width": "100%",
                "children": [
                  {
                    "key": "button_3",
                    "data-buildertype": "button",
                    "content": "Upload CSV",
                    "primary": false,
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "onClickUpload"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "floated": "left",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "mdl_ClearDatasets",
                    "data-buildertype": "swzmodal",
                    "secondary": true,
                    "style-display": "none",
                    "style-source": "padding: 40px;",
                    "content": "Clear Datasets",
                    "style-marginRight": "20px",
                    "children": [
                      {
                        "key": "container_4",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "header_4",
                            "data-buildertype": "header",
                            "content": "Clear Datasets?",
                            "size": "medium",
                            "subheader": "This will delete the uploaded validation datasets for this deployment.",
                            "textAlign": "left"
                          },
                          {
                            "key": "container_3",
                            "data-buildertype": "container",
                            "style-width": "100%",
                            "children": [
                              {
                                "key": "btn_Clear",
                                "data-buildertype": "button",
                                "content": "Clear",
                                "secondary": false,
                                "floated": "",
                                "primary": true,
                                "style-marginRight": "20px",
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "clearDatasets"
                                    ],
                                    "targets": [
                                      "mdl_ClearDatasets"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "btn_Cancel",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "floated": "",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "cancelModal"
                                    ],
                                    "targets": [
                                      "mdl_ClearDatasets"
                                    ],
                                    "parameters": []
                                  }
                                },
                                "style-marginRight": "20px"
                              }
                            ],
                            "style-marginTop": "20px",
                            "style-marginBottom": "20px",
                            "style-source": "text-align: right;"
                          }
                        ],
                        "style-marginBottom": ""
                      }
                    ],
                    "style-width": "600px"
                  }
                ],
                "style-marginBottom": "10px",
                "style-marginTop": "20px"
              },
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "Uploading a CSV will remove existing uploaded data-to-data validation datasets and replace them with new datasets using the data from the CSV. The CSV must have a header row to provide value names and contain a UID column. The UID of samples for which a dataset has been uploaded for this deployment are listed below.",
                "style-width": "750px"
              },
              {
                "key": "gv_Datasets",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "key": "SampleId_UID",
                    "name": "UID",
                    "sortable": true,
                    "filterable": false,
                    "resizable": true
                  }
                ],
                "rowKey": "Id",
                "defaultSort": "SampleId_UID ASC",
                "pagerType": "server",
                "pageSize": "20",
                "style-marginTop": "20px"
              }
            ],
            "style-width": "800px"
          },
          {
            "key": "fg_ValidationDeployment",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Validation to previous responses",
                "size": "small"
              },
              {
                "key": "ValidationDplyId",
                "data-buildertype": "dictionary",
                "label": "Validate Against Deployment ",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_DPLY",
                "columns": "Name ASC",
                "clearable": true
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "The response by the sample to the specified deployment is used for data-to-data validation when no uploaded dataset is provided for that sample."
              }
            ],
            "style-marginTop": "20px",
            "style-width": "800px"
          }
        ],
        "orientation": "grouped",
        "style-source": "padding-bottom: 20px;",
        "style-marginTop": "20px"
      }
    ]
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "validate",
              "save",
              "init"
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
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='7cb209ee-3094-4ef1-b530-74ca26baba6f';

UPDATE dwMetadata SET
[Id]='1368be1e-8bfc-4117-a850-e85f5c71f9b6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyValidation-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-12 13:45:30.087', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-09-29 13:37:20.080', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyValidation",
  "lastUpdate": "2020-09-29T13:37:20.0783514+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "21072243-9575-46d2-6888-388a70b6c735",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "898aac3a-fd8a-36aa-5d30-c869a5407671",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "10922179-95a7-8b48-5504-a967ada545d1",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "59b9ce0c-16cc-8255-dd64-2e3264842007",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "45475302-8333-8d17-7b81-c5717ba0fc0c",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bb4132e0-56eb-5cbc-d9fb-dea2cf846669",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19d9f11e-66e3-270f-a001-343b1617b045",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83990ee1-976d-204f-0cf8-93686c154de3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0ed134bc-3a71-642b-79ee-5d7bb30e8cae",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d3fb29a-7215-f112-2541-6b22c8db7f84",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "704600a5-635e-b2c1-225d-d3bc73590481",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da433f33-bb64-aa78-0766-5f8e28800b53",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "81e1ad08-8886-5967-880e-b6bd2ca9442b",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bd5d47-02a3-a3ea-9f93-19e7032b13a5",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfd0a382-6752-fe89-4459-c14c3eff1255",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "51457741-3231-226a-b41a-8bd05a17acda",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "484a277d-38dd-ad52-0cf3-611a7847f639",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f73d550c-fdbc-938b-4155-dcaa58992c59",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91aa2fab-1ddc-7234-d097-e6d9792a70a7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e7eb61c6-4242-d1b3-2d2f-f5eaf8ec13a9",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "571fa76d-953d-6aac-c4a7-6b3fe049352b",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "021173cd-3481-d15d-7676-53364c20be16",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fc7c72dc-97c8-4bf2-da42-d09a5704bd98",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "57fdd69b-fce8-3713-c0c1-b0616a3ec6bd",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff1e2607-713e-80aa-0265-437107ecbdac",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0da05df-8c88-dc15-3109-efc98815dcb8",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "51febc08-7964-87c0-da91-24d5ebaf68ac",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3af5a8a1-9cb3-0d4b-1c65-51b9899673fa",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0ede742-f460-8d28-baaa-8279483d238b",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cc002cf1-e1d0-361d-d60b-ad6b57e11106",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b7d7a29f-31d7-b41d-5f77-f7f6f33917a3",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "35b3e652-bdc2-e329-ac28-a4c675bcc903",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "888d91df-751c-1e00-8904-775ddf4adaf1",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e8ba5de2-1cf2-f096-6447-9b91ce644794",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f3f398a-71d1-73fd-9030-3838948d407b",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d5a3b670-ce9f-290e-fc57-3852c8fe2af6",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05572f15-76e0-4e14-9061-b650bbc955c0",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8616b7fd-872f-7c65-0764-5e3809ada569",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ae7450d8-ccc8-9f75-2ff1-1491bea0ed64",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ce75e6e-2bce-7034-1596-79a545916c8a",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "control": "ValidationDplyId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b4c5c43f-e144-f72a-42c6-0ff4b4383064",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "control": "IsDataToData",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "38f01d79-240c-374a-9225-7f7bb85b50a4",
      "entityId": "b0c74e5f-ee68-4c55-9139-6cd123a50e89",
      "control": "gv_Datasets",
      "dataMap": [
        {
          "id": "a7a4992e-671c-6e94-ed73-6034aa76e217",
          "attributeId": "4be80f7d-38b7-48cc-a245-c5d859824d6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4bbbb02b-16e3-cc18-4c8c-bf6e3c0386be",
          "attributeId": "b01b0858-6948-4ef8-8b7c-b151beaced16",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c90555e6-d669-5216-bbe2-51cafcb0cd13",
          "attributeId": "540da639-899f-4030-9a32-e4a527594a28",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eb5bc5a6-795b-8284-b6ef-896e9e0315f2",
          "attributeId": "5686c29e-9ba8-4755-937c-b2e320ea4221",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d6a9884-7cdc-1d6a-075d-58538abf7ebb",
          "attributeId": "32445ec9-fe0e-420e-a081-73ec8f037b0e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f9b4f503-0663-f048-6ce7-f374e01afff6",
          "attributeId": "b1dbfad1-b3fb-49fb-b247-97e634e64a10",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0952dd2-fe4f-ce2c-9c10-5d3787a7d291",
          "attributeId": "5e6e6007-8860-4d1e-aa11-cf7d66bf73b3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ed0dbca5-3d0a-265e-ca0b-e25e328083d9",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "SampleId_UID",
          "parentId": "c0952dd2-fe4f-ce2c-9c10-5d3787a7d291",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": true
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='1368be1e-8bfc-4117-a850-e85f5c71f9b6';

UPDATE dwMetadata SET
[Id]='ec448626-827e-4932-bd3a-bba8de7146dd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyValidation-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-12 13:54:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-09-29 13:56:16.457', 
[Data]=N'{
    init: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------------------
        
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("UploadDataset", model => {
            model.customPostUrl = "/deployment/dataset/" + dplyId;
            model.onUploadBegin = () => loadingStart("Uploading data to server");
            model.onUploadEnd = (cmp, ok, data) => { 
                loadingStop();
                if(ok) {
                    if(data.item) {
                        const importReport = data.item;
                        CloverApp.API.setDataField("ImportReportImportCount", importReport.importCount);
                        CloverApp.API.setDataField("ImportReportInvalidCount", importReport.invalidCount);
                        CloverApp.API.setDataField("ImportReportIgnoredCount", importReport.ignoredCount);
                        CloverApp.API.setDataField("ImportReportDuplicateCount", importReport.duplicateCount);
                    }
                } else {
                    CloverApp.API.setDataField("UploadDataset",null);
                    alertify.error("File upload failed");
                }
            };
        });
    },
    
    onClickUpload: function(args) {
        const file = $("input[name=''UploadDataset'']");
        file.trigger(''click'');
    },
    
    onImport: function(args) {
        const gridview = args.component.refs.gv_Datasets;
        const result = args.sourceControlValue;
        
        //Need to clear the file field so it can be used again
        CloverApp.API.setDataField("UploadDataset",null);
        
        if("FAIL"==result) {
            alertify.error("Data import failed.");
        } else if("NO UID COLUMN"==result) {
            alertify.error("Invalid file. A UID column is required to identify samples.");
        } else if("INCORRECT FILE TYPE"==result) {
            alertify.error("Incorrect file type. Please upload a CSV file.");
        } else if("OK"==result) {
            gridview.refresh();
            args.component.refs.ImportReportModal.openModal();
        } else {
            console.error("CSV import error", result);
            alertify.error("An error occured.");
        }
        
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
    },
    
    clearDatasets: function(args) {
        
        //---------------------------------
        const loadingStart = function(loadingMessage) {
            $(''body'').loadingModal({
                text: loadingMessage ? loadingMessage : ''Please wait...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''});
        };
    
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        const deleteJsonRequest = function (url, body) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((body === undefined) || (body === null)) {
                body = "";
            } else if(!(typeof body == "string")){
                body = JSON.stringify(body);
            };
            const promise = fetch(url, {
                headers: {
                  ''Content-Type'': ''application/json'',
                },
                credentials: ''same-origin'',
                method: ''delete'',
                body: body,
            }).then( response => {
                   return response.ok ? response.json() : Promise.reject("Failed to send delete request: " + response.status);
                }, reason => {
                    Promise.reject(reason);
                } 
            ).then( responseData => {
                    return responseData.success ? responseData.data : Promise.reject(responseData.message);
                }, reason => {
                    if(reason.message && reason.message.includes("Unexpected token") && !url.startsWith("/") && !url.startsWith("http")) {
                        console.warn(url + " appears to have returned a non JSON response. Is url correct? Should it start with a ''/'' ?");
                    }
                    return Promise.reject(reason);
                } 
            );
            return promise;
        }
        //---------------------------------
        
        args.controlRef.close();
        const gridview = args.component.refs.gv_Datasets;
        loadingStart("Removing uploaded datasets");
        deleteJsonRequest("/deployment/dataset/"+args.data.Id).then(
            () => {
                alertify.success("Datasets removed");
                gridview.refresh();
            },
            reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
    },

}








' WHERE [Id]='ec448626-827e-4932-bd3a-bba8de7146dd';

