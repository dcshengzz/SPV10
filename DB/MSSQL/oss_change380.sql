-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzQnnList.json
-- SwzQnnList-settings.json

UPDATE [dwMetadata] SET
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-02-16 12:56:30.553', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Form Properties",
        "size": "huge",
        "textAlign": "left",
        "style-width": "",
        "style-marginLeft": "",
        "events": {},
        "style-source": ""
      },
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
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "hdrCopyQnn",
                    "data-buildertype": "header",
                    "content": "Copy Form Properties",
                    "size": "medium",
                    "subheader": "New Form Properties Name*"
                  },
                  {
                    "key": "CopyQnnId",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "readOnly": true,
                    "style-hidden": true
                  },
                  {
                    "key": "NewQnnName",
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
                                  "copyQnn"
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
                                  "closeModal"
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
                    "style-marginBottom": "20px"
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
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnCreate2",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "style-source": "float:left",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Delete",
            "primary": false,
            "style-source": "float:left",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "gridQnn"
                ],
                "parameters": []
              }
            },
            "secondary": true,
            "inverted": false
          },
          {
            "key": "123",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1123",
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
                          "gridQnn"
                        ],
                        "parameters": [
                          {
                            "name": "column",
                            "value": "Title,CreatedDate"
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
        "style-float": "left",
        "style-marginRight": "20px"
      }
    ],
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "gridQnn",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Title",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom"
      },
      {
        "key": "Status",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "checkbox"
      },
      {
        "key": "UpdatedDate",
        "name": "Date Modified",
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
        "sortable": false,
        "filterable": false
      }
    ],
    "editForm": "QNN_QNN",
    "multiselect": true,
    "pagerType": "server",
    "pageSize": "50",
    "rowKey": "Id",
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
    "minHeight": "500",
    "defaultSort": "Title ASC"
  }
]' WHERE [Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef';

UPDATE [dwMetadata] SET
[Id]='2868495b-b1d3-40a8-943b-0078927caa60', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.650', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-02-16 12:56:30.620', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzQnnList",
  "lastUpdate": "2023-02-16T12:56:30.6197954+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "f7cb6ad3-78ac-8040-0838-09058d73161a",
      "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
      "filter": "StructAsyncFilter",
      "control": "gridQnn",
      "dataMap": [
        {
          "id": "0ead9748-ecef-a6a1-10d8-95911c4b7de3",
          "attributeId": "c808a448-06a0-4c5f-869a-3eb2c0a6c903",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e0490605-602b-8bde-ca88-4f309919c83f",
          "attributeId": "0d19ac69-83df-4a34-9dff-53382d296641",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2745cc89-c54f-d253-bbc5-67765af500a5",
          "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9eefbfb-c05d-277e-61f1-2463208aa58d",
          "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b843f723-2acd-c38a-1381-ae6883cfea39",
          "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36e795f2-b899-f6d0-81b4-4ba60c81359d",
          "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93015bf0-2009-41d5-81cf-4aa6e9fd063c",
          "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "228d3101-b4bc-0eea-a96c-db7cfb4ce9e1",
          "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ff5f3abc-abe7-5c06-ad70-3a2c1894e925",
          "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "70de2c9d-6607-0cd5-f8c2-f6aed26cf048",
          "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "27c1cfef-6d4c-12de-add1-839bc5dd08e5",
          "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f6e08bf3-0b0e-536b-1485-8e662b1aa6c2",
          "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "05f9bb5e-a5bc-60ca-5d22-b9a5d35b06e9",
          "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "672d3d2a-a7f7-21ca-9bca-0a7f7044e906",
          "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8787ec91-9b6b-fbd4-e407-aaca9ca20a5f",
          "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "607a923f-7a35-368b-ca05-464f7dc9ff1f",
          "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6f340d62-9ff5-60a5-253a-b591891dffc7",
          "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__gridQnn_totalcount"
    }
  ],
  "securityGroup": "Questionnaire"
}' WHERE [Id]='2868495b-b1d3-40a8-943b-0078927caa60';

