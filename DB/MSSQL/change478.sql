-- Will UPDATE existing row(s) in dwMetadata for the following:
-- Organizations.json
-- Organizations-settings.json
-- ShortLinkList.json
-- ShortLinkList-settings.json
-- SwzDplyList.json
-- SwzDplyList-settings.json
-- SwzGlobalMailer.json
-- SwzGlobalMailer-settings.json
-- swzHelpList.json
-- swzHelpList-settings.json
-- SwzListList.json
-- SwzListList-settings.json
-- SwzQnnList.json
-- SwzQnnList-settings.json
-- SwzRuleList.json
-- SwzRuleList-settings.json
-- swzsamplelist.json
-- swzsamplelist-settings.json
-- SwzStyleList.json
-- SwzStyleList-settings.json
-- SwzTrkLists.json
-- SwzTrkLists-settings.json
-- SwzRespAdminList.json
-- SwzRespAdminList-settings.json

UPDATE [dwMetadata] SET
[Id]='a211ced0-595c-465a-bb8b-93b991246ec4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.013', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:33:09.783', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Organisation Structure",
    "size": "large",
    "textAlign": "left"
  },
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "Save",
    "primary": true,
    "inverted": false,
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "validate",
          "save",
          "refresh"
        ],
        "targets": [
          "collectioneditor_1"
        ],
        "parameters": []
      }
    },
    "compact": false,
    "floated": "right",
    "style-marginRight": "20px"
  },
  {
    "key": "collectioneditor_1",
    "data-buildertype": "collectioneditor",
    "idField": "Id",
    "parentIdField": "ParentId",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "width": "30%"
      }
    ],
    "hierarchical": true,
    "disableAdd": false,
    "disableDelete": false,
    "header": true,
    "draggable": false,
    "collapseAll": false,
    "other-visibleConition": "",
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "onChangeOrg"
        ],
        "targets": [],
        "parameters": []
      }
    }
  }
]' WHERE [Id]='a211ced0-595c-465a-bb8b-93b991246ec4';

UPDATE [dwMetadata] SET
[Id]='264a20b1-0b26-44c4-aa48-573103b8fc87', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.263', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:33:09.800', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "Organizations",
  "lastUpdate": "2024-05-24T11:33:09.7991943+08:00",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "NullifyOrganizationParentAsyncTrigger",
      "parameter": "{ParentId: \"@null\"}"
    },
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "InsertAnonymousSampleStructDivisionAsync"
    }
  ],
  "dataMap": [],
  "dataColl": [
    {
      "id": "795fa882-2c29-4a4f-1b1f-fdbc9b3e77fe",
      "entityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
      "filter": "ParentAsyncFilter",
      "parameter": "",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "00f387a3-77b7-72ce-ddfa-5799a92c5c16",
          "attributeId": "07e9391f-c1b3-4ae8-a228-6ea9228ac5be",
          "control": "",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4720db20-15a8-8cdf-d399-423b6dcac52b",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20aa074f-54eb-70c8-0bad-3899c0482a48",
          "attributeId": "e2f0469b-086d-4084-be71-2068e006a906",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_1_totalcount"
    }
  ],
  "securityGroup": "Organization"
}' WHERE [Id]='264a20b1-0b26-44c4-aa48-573103b8fc87';

UPDATE [dwMetadata] SET
[Id]='1c86fa2a-372d-4843-ac3f-d02fcc008549', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ShortLinkList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-20 17:27:41.197', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:42:13.817', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Short Links",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "buttonAdd",
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
              "gridShortLink"
            ],
            "parameters": []
          }
        },
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em"
      },
      {
        "key": "buttonDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "gridDelete",
              "gridRefresh"
            ],
            "targets": [
              "gridShortLink"
            ],
            "parameters": []
          }
        },
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em"
      }
    ],
    "style-float": "right",
    "events": {},
    "style-marginBottom": "",
    "style-width": "",
    "style-source": "",
    "style-marginRight": "20px"
  },
  {
    "key": "container_filters",
    "data-buildertype": "container",
    "style-float": "left",
    "style-source": "",
    "style-marginBottom": "",
    "children": [
      {
        "key": "FilterSearch",
        "data-buildertype": "input",
        "label": "",
        "fluid": false,
        "onChangeTimeout": "300",
        "placeholder": "Search...",
        "style-marginBottom": "0.25em",
        "style-marginLeft": "",
        "style-marginRight": "0.25em",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "300px"
      },
      {
        "key": "FilterLinkType",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": false,
        "selection": true,
        "data-elements": [
          {
            "value": "ALL",
            "text": "All Types"
          },
          {
            "value": "Anonymous",
            "text": "Anonymous Survey"
          },
          {
            "value": "Url",
            "text": " Links to URL"
          }
        ],
        "style-width": "200px",
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "defaultValue": "ALL",
        "placeholder": "Show All Types"
      },
      {
        "key": "FilterStatus",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": false,
        "selection": true,
        "data-elements": [
          {
            "value": "ALL",
            "text": "All Status"
          },
          {
            "value": "1",
            "text": "Active Only"
          },
          {
            "value": "0",
            "text": "Inactive Only"
          }
        ],
        "placeholder": "All Status",
        "defaultValue": "ALL",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "200px",
        "style-marginBottom": "0.25em",
        "style-marginLeft": "",
        "style-marginRight": "0.25em"
      }
    ],
    "style-marginRight": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
  },
  {
    "key": "gridShortLink",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 150
      },
      {
        "key": "DisplayDescription",
        "name": "Description",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "LinkType",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "DisplayTarget",
        "name": "Target",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 250
      },
      {
        "key": "IsEnhancedSecurity",
        "name": "Security",
        "type": "checkbox",
        "width": 80,
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Status",
        "name": "Active",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 80
      }
    ],
    "editForm": "ShortLink",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Name ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "64",
    "minHeight": "500",
    "style-source": "clear: both;"
  }
]' WHERE [Id]='1c86fa2a-372d-4843-ac3f-d02fcc008549';

UPDATE [dwMetadata] SET
[Id]='8465a612-1d81-4743-9c5e-2ba92dfdae5e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ShortLinkList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-20 17:27:41.247', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:42:13.853', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "ShortLinkList",
  "lastUpdate": "2024-05-24T11:42:13.8506769+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "3098aa5a-4fd6-1084-3c30-b6bffa386357",
      "entityId": "9f2384b3-c50c-4a14-aada-cd75ff27c780",
      "filter": "StructAsyncFilter",
      "control": "gridShortLink",
      "dataMap": [
        {
          "id": "ec7cdc48-d0db-3e5c-40f4-f104df959c72",
          "attributeId": "a386cf67-dc72-454c-acc3-4a53da9a63b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5dced2c0-cf6a-8e25-f9b5-95bc8d931d10",
          "attributeId": "d279a7ce-1748-4a52-8f44-cd5ea6d9ca1c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b4ad7579-c2c4-c794-7bea-8ef69cb8d993",
          "attributeId": "ef36465f-85c4-4e7d-a24d-b161b1a076c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8abd19a6-a662-8b45-9128-9c21b6fcf8e2",
          "attributeId": "eb6f0fdf-f014-4615-ab5a-aa2ba9b3e0e2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63805863-9c31-7c72-dc80-f95141ad7c07",
          "attributeId": "5cff4fe9-0f43-41a6-a22e-994c44bf933e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4952be40-1d0c-cce7-99b7-55d1eab96d40",
          "attributeId": "cd5fc2da-fcf2-4e67-9b85-7294633c788f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f2f0e8d-9a97-04e6-71c6-9b34e6fdb10a",
          "attributeId": "904478aa-2ab1-4480-afd3-742ba9840c06",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1ce7f25b-8621-f96f-f253-0c5db33f45e8",
          "attributeId": "259e06f8-652b-4ef7-aace-cd5fd115e6de",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridShortLink_totalcount"
    }
  ],
  "securityGroup": "ShortLink"
}' WHERE [Id]='8465a612-1d81-4743-9c5e-2ba92dfdae5e';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 09:57:00.370', 
[Data]=N'[
  {
    "key": "container_4",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_2",
        "data-buildertype": "header",
        "content": "Deployments",
        "size": "huge",
        "style-source": "",
        "events": {}
      }
    ],
    "events": {},
    "style-source": "width: 100%;\nfloat:left;",
    "style-marginRight": "",
    "style-marginTop": "",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "buttonAdd",
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
        "style-marginBottom": "0.25em"
      },
      {
        "key": "buttonDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
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
        "circular": false,
        "style-marginBottom": "0.25em",
        "floated": ""
      }
    ],
    "style-float": "right",
    "style-marginBottom": "20px",
    "style-source": "",
    "style-width": "",
    "style-marginRight": "20px"
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
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "FilterSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": false,
                "onChangeTimeout": 200,
                "placeholder": "Search...",
                "style-width": "300px",
                "style-source": "",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "updateFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-marginBottom": "",
                "style-marginRight": ""
              }
            ],
            "style-source": "float: left;",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "FilterRecurrenceType",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllRecurrenceType",
                    "text": "(Recurring Survey: no filter)"
                  },
                  {
                    "value": "IR",
                    "text": "Recurring only"
                  },
                  {
                    "value": "I",
                    "text": "Recurring Initial only"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Recurring Recurrences only"
                  },
                  {
                    "key": 3,
                    "value": "N",
                    "text": "Not-recurring only"
                  }
                ],
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "updateFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "AllRecurrenceType",
                "style-source": "",
                "style-marginBottom": "",
                "style-marginRight": "",
                "placeholder": "",
                "style-width": "250px"
              },
              {
                "key": "FilterAnonymous",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllAnonymous",
                    "text": "(Anonymous Survey: no filter)"
                  },
                  {
                    "key": 2,
                    "value": "true",
                    "text": "Anonymous only"
                  },
                  {
                    "key": 3,
                    "value": "false",
                    "text": "Not-anonymous only"
                  }
                ],
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "updateFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "AllAnonymous",
                "style-source": "",
                "style-marginBottom": "",
                "style-marginRight": "",
                "placeholder": "",
                "style-width": "250px"
              },
              {
                "key": "FilterMultiple",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": false,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "AllMultiple",
                    "text": "(Multiple Response: no filter)"
                  },
                  {
                    "key": 2,
                    "value": "true",
                    "text": "Multiple only"
                  },
                  {
                    "key": 3,
                    "value": "false",
                    "text": "Not-multiple only"
                  }
                ],
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "updateFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "AllMultiple",
                "style-marginBottom": "",
                "style-marginRight": "",
                "style-width": "250px"
              }
            ],
            "style-source": "float: left;",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          }
        ],
        "style-width": "100%"
      }
    ]
  },
  {
    "key": "gridview_1",
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
        "key": "QnnTitle",
        "name": "Form Properties",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "ListName",
        "name": "Sample List",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "Tags",
        "name": "Tags",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": 250
      },
      {
        "key": "RecurrenceType",
        "name": "Recur",
        "type": "",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "IsAnonymous",
        "name": "Anon",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "IsMultipleResponse",
        "name": "Multi",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 64
      },
      {
        "key": "CreatedDate",
        "name": "Created",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 150
      },
      {
        "key": "RespCount",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": "Responses",
        "width": 128
      },
      {
        "key": "Action",
        "name": "Action",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 128
      }
    ],
    "editForm": "QNN_DPLY",
    "rowKey": "Id",
    "multiselect": true,
    "defaultSort": "Name ASC",
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
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [],
        "targets": [],
        "parameters": []
      }
    },
    "pagerType": "server",
    "autoHeight": false,
    "offSet": "100px",
    "style-marginTop": "10px",
    "rowHeight": "80",
    "minHeight": "500",
    "style-source": "clear: both;",
    "disableSort": false
  }
]' WHERE [Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38';

UPDATE [dwMetadata] SET
[Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.327', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 09:57:00.527', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzDplyList",
  "lastUpdate": "2024-05-24T09:57:00.5175069+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "058228ef-f056-b36f-c7ec-702668c9294a",
      "entityId": "f80dfd0d-8d02-4fa0-b96d-a8d0a4b158c3",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "19511b88-44e8-86e1-6d14-82bbe1011505",
          "attributeId": "f0a7d187-b968-4ad8-abec-e46b32bab0cf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c6b9cbf-4767-22e2-ca9e-9ff48eb9966d",
          "attributeId": "619d0245-2d3b-46bc-ad67-4d0d69b779a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7aff8724-8cd0-625d-d36b-ace2a505e040",
          "attributeId": "a2a0d06f-d6d9-4452-9910-df0e88be6104",
          "control": "ListName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9da9dd72-7068-08ac-d0a7-4923caf23aca",
          "attributeId": "abc42150-cc13-446b-9a8a-8277022e11d0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99fe6b46-ff27-ee98-7bc3-8132656515e2",
          "attributeId": "bef244ee-2ee4-496d-82aa-b3c212ed1d0b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a7a3938-317b-fb4b-0f19-49c9531e7035",
          "attributeId": "b1a5e363-bc28-40d6-864d-791bc353e150",
          "control": "QnnTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7b50251-f8e2-c9df-fe21-dfb83887e9d0",
          "attributeId": "d4044d06-1bd3-4e33-93ee-e0e7ef5384dc",
          "control": "QnnType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76e6c076-85d3-8ed9-07d2-1b267ceb476c",
          "attributeId": "932f78f2-eed2-43ad-a8ee-435d0fc7b3b8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b37898-b089-fbbb-6db6-d83280200104",
          "attributeId": "5a4cf42f-8ec4-446c-81cf-ae35f7318a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d083abec-c35f-6363-3a7d-862b0526ef58",
          "attributeId": "f29c04ff-05dc-4c47-9ba3-47c0b54a3a74",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a72c10e3-ad37-5968-ecc4-3d3a0a3fd32f",
          "attributeId": "04522c05-b4ee-4c68-ba7d-a94236d7f0b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0c7530a-11ac-6e69-4b3b-714e51056ab3",
          "attributeId": "623bdb8d-e43f-4157-8944-6c3cdb497a89",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12d09bf2-3761-090f-31de-7bad3d5f2db4",
          "attributeId": "27066598-1089-4846-b0fd-2019d299c43f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6fd2bfe6-4a4b-6b40-9a47-6bbe57ea6456",
          "attributeId": "205cadbe-08ab-43a8-9194-4ece2b83b0fb",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec';

UPDATE [dwMetadata] SET
[Id]='7920415b-36c7-4270-99de-fcd7abca91a7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:40:42.793', 
[Data]=N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_9",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "\nGlobal Mailer",
            "size": "huge",
            "subheader": "Send email to all all sample of active deployment with selected status"
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_10",
        "data-buildertype": "container",
        "children": [
          {
            "key": "swzmodal_2",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_11",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "organization",
                        "data-buildertype": "dictionary",
                        "label": "",
                        "fluid": true,
                        "selection": true,
                        "placeholder": "Organisation",
                        "dataModel": "vStructDivisionParentsAndThisName",
                        "columns": "Name, Id ASC",
                        "filters": "[{ column : \"ParentId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                        "paging": true,
                        "search": true,
                        "style-marginBottom": "10px"
                      },
                      {
                        "key": "target",
                        "data-buildertype": "radiogroup",
                        "label": "To",
                        "data-elements": [
                          {
                            "key": 1,
                            "value": "intranetUsers",
                            "text": "Backoffice Users (Intranet)"
                          },
                          {
                            "key": 2,
                            "value": "activeSamples",
                            "text": "Active Samples (Internet Respondents)"
                          }
                        ],
                        "style-marginTop": ""
                      },
                      {
                        "key": "dictionaryStatus",
                        "data-buildertype": "dictionary",
                        "label": "",
                        "fluid": true,
                        "selection": true,
                        "dataModel": "QNN_STATUS",
                        "columns": "Title, NumberId ASC",
                        "events": {
                          "onChange": {
                            "active": true,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-marginBottom": "20px",
                        "clearable": true,
                        "placeholder": "Select Status",
                        "multiple": true,
                        "other-visibleConition": "data.target == \"activeSamples\" ? true : false"
                      }
                    ]
                  },
                  {
                    "key": "container_13",
                    "data-buildertype": "container",
                    "style-customcss": "",
                    "children": [
                      {
                        "key": "emailFrom",
                        "data-buildertype": "input",
                        "label": "From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "",
                        "style-marginBottom": "20px",
                        "events": {}
                      },
                      {
                        "key": "subject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "other-visibleConition": "",
                        "style-marginBottom": "20px"
                      },
                      {
                        "key": "scheduledDate",
                        "data-buildertype": "input",
                        "label": "Start From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "reference": "Start From",
                        "other-visibleConition": "",
                        "type": "datetime",
                        "style-marginBottom": "20px"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "events": {
                      "onChange": {
                        "active": false,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      },
                      "onClick": {
                        "active": false,
                        "actions": [
                          "showModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": ""
                  },
                  {
                    "key": "container_15",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_SubmitEmail",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "createEmail"
                            ],
                            "targets": [
                              "grid"
                            ],
                            "parameters": []
                          }
                        },
                        "primary": true
                      },
                      {
                        "key": "btnCancel",
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
                              "swzmodal_2"
                            ],
                            "parameters": []
                          }
                        },
                        "style-marginLeft": "20px"
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Create Scheduled Email",
            "secondary": true,
            "inverted": false,
            "events": {
              "onClick": {
                "active": true,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "style-customcss": "",
            "style-source": "",
            "size": ""
          }
        ],
        "style-float": "right",
        "style-marginBottom": "",
        "events": {},
        "style-marginTop": "20px",
        "style-marginRight": "20px"
      }
    ],
    "style-source": "",
    "style-marginBottom": "",
    "events": {}
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-marginBottom": "50px",
    "style-source": "clear:both;"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "grid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime"
          },
          {
            "key": "ScheduledDate",
            "name": "Scheduled",
            "type": "datetime",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "EmailSubj",
            "name": "Subject",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SampleCount",
            "name": "Samples",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "EmailsSent",
            "name": "Sent",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "JobIsCanceled",
            "name": "Cancelled",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "IsTargetUsers",
            "name": "Intranet",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": true
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "defaultSort": "NumberId DESC",
        "multiselect": false,
        "rowHeight": "",
        "pageSize": "128",
        "minHeight": "",
        "editForm": "SwzGlobalMailerMessage",
        "events": {
          "onRowClick": {
            "active": true,
            "actions": [
              "gridEdit"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "autoHeight": false
      }
    ],
    "style-marginTop": ""
  }
]' WHERE [Id]='7920415b-36c7-4270-99de-fcd7abca91a7';

UPDATE [dwMetadata] SET
[Id]='bd23d168-027b-4827-b17a-7617b4a12378', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:40:42.833', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailer",
  "lastUpdate": "2024-05-24T11:40:42.8341411+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "a6062e72-4830-7d94-dbc3-731a6adfffaf",
      "entityId": "26f92131-609c-40bc-8b38-9ec4fd66fca5",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "c467c287-9a90-9323-3cbd-bf8ae2727287",
          "attributeId": "be5cfc9e-69b1-4ccd-a92a-bdd062727c00",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ff86383-5e00-a969-8310-030675d955a7",
          "attributeId": "0c94a477-4399-4659-9d1d-5c24087d023c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a869f780-c1b7-67dc-de1c-75dac944c1aa",
          "attributeId": "dcee1721-2a49-4bbc-82b7-b8ea08f97c9a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a2fc8d9-8440-3ab1-12f9-7d2868616aae",
          "attributeId": "6e55e3d1-0f7b-4eb0-a20e-ca42f09ec4eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ede8577-6d92-a0cf-b9da-fdead3a0f7c5",
          "attributeId": "be72b7e3-bcc7-4d62-bb6d-3467d422512f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06100a2d-174b-4d39-ca2c-e2c14c76ce88",
          "attributeId": "705fe916-6b58-4b51-ac1d-cbbd565ab921",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62b8f9b9-83cf-9589-258f-e825421e57ee",
          "attributeId": "fb438787-70d2-4a34-97dc-1b214d1bdd92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da7f21e0-cf2a-2b81-d3d9-a2683ddf5a5d",
          "attributeId": "577ae8a2-3d0a-4b19-8a28-09c177fd19a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "afd269b5-bf93-5658-f107-87f896b8aa2f",
          "attributeId": "469e027c-f7dc-4227-a4c8-82152ba1dd91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0fcf4a9c-1172-8cad-41e7-367d045b51ec",
          "attributeId": "5d1fff92-b20c-4fb6-855d-f840171fa9bf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "880dbd97-5dc1-859e-f537-c0e8657306ac",
          "attributeId": "e5a4d062-2eb7-4009-920c-b00ec6f661da",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "de9764c9-5916-f36d-ddb4-e89d145f3408",
          "attributeId": "9001b9b9-0f4c-4cfe-b185-8fb97fe61a29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9cb669f7-74f6-7f5c-69c4-122532c93449",
          "attributeId": "b66ea0c8-5d41-4d09-9bc4-037a171d6913",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "66722324-156e-9ef1-b94c-23935deb1ab6",
          "attributeId": "465f2fc6-434a-457f-bd45-a1835abd7bcd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8cc2868-ce74-f236-2b54-da8a60dc4984",
          "attributeId": "ba1df5e9-1f0b-4f9e-8c32-7c02fd04fff4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a46b6591-b811-ca0e-e144-34303c20803f",
          "attributeId": "0f66dd50-0752-4c59-b219-8fed4d27ace0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "185090ea-8777-1d36-4752-68dd25ffdd6e",
          "attributeId": "aee289bb-555f-4890-b890-7b3b1a6dc719",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ffa4a564-7283-29a1-33f2-0225b86bb993",
          "attributeId": "1e447ccd-dd43-4cef-abb7-f3d7a688cc8c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d26f1d32-5173-94f8-8b1c-41985052b90d",
          "attributeId": "acce5637-059f-41f0-814b-a3269259045c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='bd23d168-027b-4827-b17a-7617b4a12378';

UPDATE [dwMetadata] SET
[Id]='3e37b27f-d66f-47c6-b6dc-c40d0a857db5', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzHelpList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 12:02:46.520', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:31:46.100', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Online Help Content",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "buttonAdd",
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
              "gridHelp"
            ],
            "parameters": []
          }
        },
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em"
      },
      {
        "key": "buttonDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "gridDelete",
              "gridRefresh"
            ],
            "targets": [
              "gridHelp"
            ],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "deletionConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "deletionConfirmText"
              }
            ]
          }
        },
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em"
      }
    ],
    "style-float": "right",
    "events": {},
    "style-marginBottom": "",
    "style-marginRight": "20px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "FilterSearch",
        "data-buildertype": "input",
        "label": "",
        "fluid": false,
        "onChangeTimeout": 200,
        "events": {
          "onClick": {
            "active": false,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          },
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "placeholder": "Search...",
        "style-marginBottom": "0.25em",
        "style-width": "300px",
        "style-source": "",
        "style-marginRight": "0.25em"
      },
      {
        "key": "FilterType",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": false,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "ALL",
            "text": "Show All"
          },
          {
            "key": 2,
            "value": "admin",
            "text": "Show Survey Admin"
          },
          {
            "key": 3,
            "value": "resp",
            "text": "Show Respondent Portal"
          }
        ],
        "defaultValue": "ALL",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "updateFilter"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-width": "200px",
        "style-marginBottom": "0.25em",
        "style-marginRight": "0.25em"
      }
    ]
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear:both",
    "style-marginBottom": "50px"
  },
  {
    "key": "gridHelp",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Topic",
        "name": "Topic",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Heading",
        "name": "Heading",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Type",
        "name": "Type",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 100
      },
      {
        "key": "Status",
        "resizable": false,
        "type": "checkbox",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "width": 50
      }
    ],
    "editForm": "QNN_HELP",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Heading ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "1em",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "50",
    "minHeight": "500"
  }
]' WHERE [Id]='3e37b27f-d66f-47c6-b6dc-c40d0a857db5';

UPDATE [dwMetadata] SET
[Id]='0def75a6-d5e4-4c2c-8547-962065127c70', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzHelpList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 12:02:46.540', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:31:46.137', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzHelpList",
  "lastUpdate": "2024-05-24T11:31:46.1368927+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "930b9887-d8f2-03c6-4eda-732f59246c50",
      "entityId": "bb075204-7deb-44cc-9251-b1d158e816d3",
      "filter": "",
      "control": "gridHelp",
      "dataMap": [
        {
          "id": "4385510a-144c-bcea-79ad-50ea87be6b22",
          "attributeId": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20800045-511c-530f-f6b0-23cce0512ca0",
          "attributeId": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "02b9587c-6a18-f9b5-b820-e07f7d6fff99",
          "attributeId": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d0bebb8-034c-b955-c82a-1187606ebe3f",
          "attributeId": "90a76b37-0d22-4e40-8524-f4f990a161d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e3eef2a-588b-8b33-0546-6e04e11705ee",
          "attributeId": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d3ece22-1217-f09e-cf4e-8461e00a6beb",
          "attributeId": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a7c47c62-b2c5-9c56-bf13-838265c47be2",
          "attributeId": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e74b2d19-beb4-0842-8d73-4087e3023b7a",
          "attributeId": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "34370749-0509-1466-b06e-db3d948e4d97",
          "attributeId": "94da5047-34a7-42a0-97ca-09e704f33af0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "014e64c5-6c25-97a5-fd64-8336e34b9e74",
          "attributeId": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d6e03af-cab0-0a1e-e70c-0a6e7b0d777a",
          "attributeId": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridHelp_totalcount"
    }
  ],
  "securityGroup": "Content"
}' WHERE [Id]='0def75a6-d5e4-4c2c-8547-962065127c70';

UPDATE [dwMetadata] SET
[Id]='93e2c53d-cf1e-4b4a-9226-0a33e6f06afa', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.543', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:35:37.810', 
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
                  }
                ],
                "style-source": "padding-bottom: 60px;"
              }
            ]
          }
        ],
        "style-hidden": true,
        "events": {}
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
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
    "key": "container_2",
    "data-buildertype": "container",
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
        "style-source": "",
        "floated": "left"
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
        "style-source": "",
        "inverted": false,
        "secondary": true,
        "compact": false,
        "floated": "left"
      },
      {
        "key": "div_float_modal",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float:left",
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
                        "children": [],
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
      }
    ],
    "style-float": "right",
    "style-marginRight": "20px"
  },
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
    "style-float": "",
    "style-width": "300px",
    "events": {},
    "style-marginBottom": "10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-source": "clear:both",
    "style-marginBottom": "50px",
    "children": [
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
        "style-source": "",
        "inverted": false,
        "secondary": true,
        "compact": false,
        "floated": "left"
      }
    ],
    "style-marginTop": ""
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 11:35:37.823', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzListList",
  "lastUpdate": "2024-05-24T11:35:37.8246499+08:00",
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
[Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.697', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:05:16.757', 
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
        "key": "div_main_button",
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
          }
        ],
        "style-float": "right",
        "style-marginRight": "20px"
      },
      {
        "key": "div_search",
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
                    "value": "Title,CreatedDate,Tags"
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
    "style-marginBottom": "1em",
    "style-width": "100%",
    "style-float": "left"
  },
  {
    "key": "div_clear",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginTop": "",
    "style-marginBottom": "30px"
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
        "key": "Tags",
        "name": "Tags",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": false
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
    "defaultSort": "Title ASC",
    "style-marginTop": "",
    "style-source": ""
  }
]' WHERE [Id]='5811df16-ed1a-4cf9-af2f-be001a7668ef';

UPDATE [dwMetadata] SET
[Id]='2868495b-b1d3-40a8-943b-0078927caa60', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.650', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:05:16.780', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzQnnList",
  "lastUpdate": "2024-05-24T10:05:16.7788385+08:00",
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
        },
        {
          "id": "16cc7389-055e-b28a-47fc-372ab83fb9a0",
          "attributeId": "e2018e3a-6e65-4b0d-aa62-c640c20288b0",
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

UPDATE [dwMetadata] SET
[Id]='4ec064cd-e6ea-454a-8216-893207b94b7b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 11:42:38.617', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:14:05.957', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Data Validation Rules",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonAdd",
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
                  "gridRule"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "buttonDelete",
            "data-buildertype": "button",
            "content": "Delete",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete",
                  "gridRefresh",
                  "clearServerCache"
                ],
                "targets": [
                  "gridRule"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deletionConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deletionConfirmText"
                  }
                ]
              }
            }
          }
        ],
        "style-float": "right",
        "events": {},
        "style-marginBottom": "",
        "style-marginRight": "20px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "FilterSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "placeholder": "Search...",
            "style-width": "300px",
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
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ]
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear: both",
    "style-marginBottom": "50px",
    "events": {}
  },
  {
    "key": "gridRule",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Description",
        "name": "Description",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "editForm": "QNN_RULE",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Name ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "1em",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "50",
    "minHeight": "500"
  }
]' WHERE [Id]='4ec064cd-e6ea-454a-8216-893207b94b7b';

UPDATE [dwMetadata] SET
[Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRuleList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 11:42:38.733', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:14:05.970', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzRuleList",
  "lastUpdate": "2024-05-24T10:14:05.9705613+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "3b0c0712-15ac-a9eb-fdab-8bd186e2ce4a",
      "entityId": "ea08b91d-a603-41a2-8396-8430ccb3f1bb",
      "filter": "StructAsyncFilter",
      "control": "gridRule",
      "dataMap": [
        {
          "id": "c0a3a683-2fb5-ffce-386f-25fe6c0a1951",
          "attributeId": "250acf7c-d9fb-4738-88f9-8069b98a1ff5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57dad831-aceb-644a-4c89-c3b746ad4906",
          "attributeId": "2e95decc-de0f-47f7-9e2e-46ea22985ac0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52fe4b2c-f7db-8960-3e62-6d9305df8a8d",
          "attributeId": "3da67c4c-93fe-4ecc-b9a7-046dddad5de5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8f309f39-e1de-1c07-1cb7-ddd91a096632",
          "attributeId": "9a055a7f-4eb9-4441-8df5-b74c489e6e1a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a4e7aa62-624e-9f74-3118-9d50610cb85b",
          "attributeId": "430e1edc-de90-4af3-9f02-effe8089800a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b286a35-537f-b824-7587-e4a2a104a88b",
          "attributeId": "9fff33de-bcb2-4348-a7bf-559894ac6aec",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "367a1330-5f83-c552-2441-7f6a9e32cf4f",
          "attributeId": "4760359f-8a71-44ec-baf0-bef43ff238bf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06d1e3e5-23d1-7d35-ee93-174c82bfa123",
          "attributeId": "b12c7eb3-c550-4c9c-8999-4a663ee9f29d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69e71bb5-db6f-f9d1-80b7-51b442910b9b",
          "attributeId": "92044df4-e4bc-45f2-b023-9d50e722297e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60b8e0bb-cfcb-53e4-58ed-bf7a2a2f502c",
          "attributeId": "640e1fee-733e-41cb-9687-2bd9bd6bcb57",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01a0cff1-fb75-f47f-4113-40bea61ecd79",
          "attributeId": "89594fdd-5dde-42af-b69d-5d3722883bef",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "13e44ad7-6be5-e612-4f94-a8947049020f",
          "attributeId": "9192b784-b6ef-4d5e-b9bb-ebccadeed2dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d44703b7-f08e-273f-3609-c848c38bcfe4",
          "attributeId": "765eaf26-34e9-4154-a57b-ad54564a506f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridRule_totalcount"
    }
  ],
  "securityGroup": "Designer"
}' WHERE [Id]='2f5dddc0-0414-4f9f-b615-a93d9f875c7f';

UPDATE [dwMetadata] SET
[Id]='29d6757b-a248-477d-a1d5-e5a4f7550f07', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzsamplelist.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 09:33:31.797', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:43:18.733', 
[Data]=N'[
  {
    "key": "container_5",
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
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "right",
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
      }
    ],
    "style-marginRight": "20px",
    "style-width": ""
  },
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
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:43:18.753', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzsamplelist",
  "lastUpdate": "2024-05-24T10:43:18.753253+08:00",
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
[Id]='cdc0b5fa-6b9a-405d-880f-2fe1bfbe23c7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzStyleList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 16:13:47.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:15:18.713', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "CSS Style Library",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonAdd",
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
                  "gridStyle"
                ],
                "parameters": []
              }
            }
          },
          {
            "key": "buttonDelete",
            "data-buildertype": "button",
            "content": "Delete",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete",
                  "gridRefresh",
                  "clearServerCache"
                ],
                "targets": [
                  "gridStyle"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deletionConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deletionConfirmText"
                  }
                ]
              }
            }
          }
        ],
        "style-float": "right",
        "events": {},
        "style-marginBottom": "",
        "style-marginRight": "20px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "FilterSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "placeholder": "Search...",
            "style-width": "300px",
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
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            }
          }
        ],
        "style-float": "left"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
  },
  {
    "key": "gridStyle",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Description",
        "name": "Description",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "editForm": "QNN_STYLE",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Name ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "1em",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "50",
    "minHeight": "500"
  }
]' WHERE [Id]='cdc0b5fa-6b9a-405d-880f-2fe1bfbe23c7';

UPDATE [dwMetadata] SET
[Id]='c1a5feba-f0ff-467a-9057-16ab89f8218d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzStyleList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-09 16:13:47.457', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:15:18.733', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzStyleList",
  "lastUpdate": "2024-05-24T10:15:18.7344674+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "4267fd22-eb4c-09cb-e2eb-11e74ea81710",
      "entityId": "218ec89e-4aa3-4985-bcf5-4e69c8824347",
      "filter": "StructAsyncFilter",
      "control": "gridStyle",
      "dataMap": [
        {
          "id": "518ad6e3-589c-6492-28bb-2fd73e22f6f4",
          "attributeId": "68d481c2-da6f-4186-b65f-ff583f740930",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bc8a825e-e455-b818-83bd-c16050d4b242",
          "attributeId": "ec886465-a2e5-4cc1-afd8-beb101ce86c6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99f1435c-578f-1ced-50ef-6b0282cc93d0",
          "attributeId": "00792a31-ed25-4d82-b673-5cfff21eb35e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7274c4a-d2f5-90de-3baf-37120a4945ab",
          "attributeId": "fc6da424-9227-47c5-a801-9217d29883f5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "37b25361-bcbd-1c44-faf1-1ec797842d87",
          "attributeId": "85f06cd3-2033-4704-9a7e-cd1295179e37",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "af189325-c5d5-35ec-769e-1cd103fa6239",
          "attributeId": "12e325a8-ecca-4288-9e76-81d57ae03d7e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "227eed6a-c2d7-ff92-1d58-181f1f108173",
          "attributeId": "4ef2eaf5-6d7d-44e6-af6e-f0c230b9e368",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d010184-9a7e-da4d-645c-b71b7cacf37a",
          "attributeId": "ae020fe4-cb13-4994-894b-1152f2d88cf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f219f40b-1169-adc5-ba29-bd1c2e840974",
          "attributeId": "233251e4-788f-4443-8c71-a58e8b71abb2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "61eda6fb-5e97-52ed-ef2e-f3c521e60d72",
          "attributeId": "0ed9cb40-1a9b-49e4-a96e-b43978dd1e22",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "15e572d4-8c91-fec1-9a4d-74b72e2860c2",
          "attributeId": "d9d785b6-7573-43ef-b534-7e5b7ca2e542",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2b16d41a-be2c-d680-ba24-74bf85df514f",
          "attributeId": "9060a28f-eb9f-449d-b1bc-e211cc3ea7cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29452736-9e17-874e-9120-bf7e82c3a557",
          "attributeId": "40c7cb99-4fda-45dd-97b0-9f9f84957bf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d730404-0902-e1e0-46a3-43e96c7dc95c",
          "attributeId": "72ccc8e6-de8a-4814-b4d4-2772e23bfa8c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridStyle_totalcount"
    }
  ],
  "securityGroup": "Designer"
}' WHERE [Id]='c1a5feba-f0ff-467a-9057-16ab89f8218d';

UPDATE [dwMetadata] SET
[Id]='b6dfab92-c666-4494-b09e-8e9e5db00b64', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTrklists.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 09:24:36.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:36:13.903', 
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
    "style-marginBottom": "",
    "style-float": "right",
    "style-marginRight": "20px"
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
        "style-width": "300px",
        "style-float": "left"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-float": "left",
        "style-width": "300px",
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
        ],
        "style-marginLeft": "10px"
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "container_6",
    "data-buildertype": "container",
    "style-source": "clear:both;",
    "style-marginBottom": "50px"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:36:13.920', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzTrklists",
  "lastUpdate": "2024-05-24T10:36:13.9189962+08:00",
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
[Id]='02e8136c-05cd-4541-8df3-ad727992c6f6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRespAdminList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-09 09:14:33.160', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:45:07.413', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Respondent Content Management",
        "size": "huge",
        "textAlign": "left",
        "events": {}
      }
    ],
    "style-source": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "right",
    "style-marginRight": "20px",
    "children": [
      {
        "key": "btnCreate",
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
              "grid_respadmin"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "btnDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridDelete"
            ],
            "targets": [
              "grid_respadmin"
            ],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": ""
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-marginTop": "",
    "style-marginBottom": "50px",
    "style-source": "clear:both;"
  },
  {
    "key": "grid_respadmin",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Type",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StartDate",
        "name": "Start Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "EndDate",
        "name": "End Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "defaultSort": "NumberId ASC",
    "pagerType": "server",
    "editForm": "QNN_RESP_ADMIN",
    "autoHeight": false,
    "offSet": "285px",
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
        "parameters": [],
        "active": false,
        "actions": [],
        "targets": []
      }
    },
    "editFormShowType": "",
    "multiselect": true,
    "style-marginTop": "10px",
    "minHeight": "250",
    "rowHeight": "80"
  }
]' WHERE [Id]='02e8136c-05cd-4541-8df3-ad727992c6f6';

UPDATE [dwMetadata] SET
[Id]='815eaaa7-0ce0-487b-bdd3-8282471fcff2', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzRespAdminList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-09 09:14:33.273', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-05-24 10:45:07.430', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzRespAdminList",
  "lastUpdate": "2024-05-24T10:45:07.4297654+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8545a415-8f5e-24cb-3cb0-835d4723add1",
      "entityId": "cd522364-03bb-44c1-af31-575eab8ac087",
      "control": "grid_respadmin",
      "dataMap": [
        {
          "id": "953748b6-a60d-80ba-4e3e-55359aa05c21",
          "attributeId": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4625a56-4633-155c-1b05-fc8187f3bbaa",
          "attributeId": "d8512084-4732-4938-869d-0165bc220192",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc40b2fa-3238-424c-31d7-d51eea9a01d2",
          "attributeId": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4e482d2a-814b-2378-26f7-e6924a4abed1",
          "attributeId": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9cd2aa18-95ae-39d3-f518-2874d836c125",
          "attributeId": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d16f4476-8ce6-626b-3748-648a9762d8b3",
          "attributeId": "46699848-4700-4d77-a193-ef4ecbd921ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06400da2-63e9-7480-cdc2-f9086cdddaa6",
          "attributeId": "59530aed-1d91-40d2-8808-d1a286390b4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f4d776c0-5f48-4852-a110-3ee3b91ca770",
          "attributeId": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93bf876e-d25f-0248-96a7-3cd9a45670f4",
          "attributeId": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12da3aef-a0ed-07cb-de97-a2c22ba2f05a",
          "attributeId": "617be8a6-bcdc-46db-86c9-2841eac54b68",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1c8847db-0a76-9214-90f0-195b099934be",
          "attributeId": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "076b8f57-6bb9-20eb-3ff2-2d47da719b1f",
          "attributeId": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4e7ca3a-06d2-a081-2f21-d8fdd1d3a390",
          "attributeId": "5c84da90-3ecb-4c14-846f-8d1568091a77",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_respadmin_totalcount"
    }
  ],
  "securityGroup": "Content"
}' WHERE [Id]='815eaaa7-0ce0-487b-bdd3-8282471fcff2';

