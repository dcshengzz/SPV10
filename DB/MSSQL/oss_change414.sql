-- Will UPDATE existing row(s) in dwMetadata for the following:
-- RespondentParticipationReport.json
-- SwzDplyList.json

UPDATE [dwMetadata] SET
[Id]='ce0356a5-09ff-4fc3-b838-b09ef6c81b8a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 12:37:25.427', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-07-20 11:54:26.043', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Respondent Participation Report",
    "size": "huge"
  },
  {
    "key": "form_2",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "UID",
                "data-buildertype": "input",
                "label": "UID",
                "fluid": true,
                "onChangeTimeout": 200,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "RespName",
                "data-buildertype": "input",
                "label": "Respondent Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "reference": "Respondent Name",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ]
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "Status",
                "data-buildertype": "dictionary",
                "label": "Status",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_STATUS",
                "columns": "Title, NumberId ASC",
                "placeholder": "Select Status",
                "multiple": true,
                "clearable": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "DeploymentName",
                "data-buildertype": "dictionary",
                "label": "Deployment Name",
                "fluid": true,
                "selection": true,
                "reference": "Deployment Name",
                "dataModel": "QNN_DPLY",
                "filters": "[{ column : \"StructDivisionId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                "placeholder": "Select Deployment Name",
                "columns": "Name ASC, Id",
                "multiple": true,
                "clearable": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "gridFilter"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-width": "100%"
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "actionAddAllStatus",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Add All Status",
                    "url": "/"
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "actionAddAllFields"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-source": "margin:5px;"
              },
              {
                "key": "actionRemoveAllStatus",
                "data-buildertype": "breadcrumb",
                "items": [
                  {
                    "text": "Remove All Status",
                    "url": "/"
                  }
                ],
                "events": {
                  "onItemClick": {
                    "active": true,
                    "actions": [
                      "actionRemoveAllFields"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "style-source": "margin:5px"
              }
            ],
            "style-marginTop": "-15px",
            "style-marginBottom": "10px"
          }
        ]
      }
    ]
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnExport",
        "data-buildertype": "button",
        "content": "Export",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "onExport"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-marginRight": "15px"
      },
      {
        "key": "btnRefresh",
        "data-buildertype": "button",
        "content": "Refresh",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridFilter"
            ],
            "targets": [],
            "parameters": []
          }
        }
      }
    ]
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "uid",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "respondentName",
        "name": "Respondent Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "name",
        "name": "Deployment Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "status",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "statusDate",
        "name": "Status Date",
        "type": "datetime",
        "sortable": true,
        "filterable": false,
        "resizable": true
      }
    ],
    "defaultSort": "Name ASC",
    "pagerType": "",
    "pageSize": "10",
    "editFormShowType": ""
  }
]' WHERE [Id]='ce0356a5-09ff-4fc3-b838-b09ef6c81b8a';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-07-20 11:38:42.157', 
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
        "style-marginBottom": "0.25em"
      }
    ],
    "style-float": "left",
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

