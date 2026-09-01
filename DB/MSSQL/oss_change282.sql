-- Will UPDATE existing row(s) in dwMetadata for the following:
-- audittrail.json
-- audittrail-settings.json

UPDATE [dwMetadata] SET
[Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.123', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-11 12:10:41.667', 
[Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Audit Trail",
        "size": "medium",
        "subheader": ""
      },
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "Filters you can use: Event Date (between Start and End filter), Table Name, Event Type, User Name or Sample Name"
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "input_1",
                "data-buildertype": "input",
                "label": "Start",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "placeholder": "Select Event Start",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventDate"
                      },
                      {
                        "name": "term",
                        "value": ">="
                      }
                    ]
                  }
                },
                "readOnly": false,
                "disabled": false
              },
              {
                "key": "input_2",
                "data-buildertype": "input",
                "label": "End",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "placeholder": "Select Event End",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventDate"
                      },
                      {
                        "name": "term",
                        "value": "<="
                      }
                    ]
                  }
                }
              }
            ]
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "dictionary_1",
                "data-buildertype": "dictionary",
                "label": "Table Name",
                "fluid": true,
                "selection": true,
                "columns": "TableName ASc",
                "dataModel": "vSP_auditlog_TableName",
                "placeholder": "Select Table Name",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "TableName"
                      },
                      {
                        "name": "term",
                        "value": "="
                      }
                    ]
                  }
                },
                "clearable": true
              },
              {
                "key": "dictionary_2",
                "data-buildertype": "dictionary",
                "label": "Event Type",
                "fluid": true,
                "selection": true,
                "dataModel": "vSP_auditlog_EventType",
                "placeholder": "Select Event Type",
                "multiple": false,
                "columns": "EventType ASc",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "EventType"
                      }
                    ]
                  }
                },
                "clearable": true
              }
            ]
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "dictOrganization",
                "data-buildertype": "dictionary",
                "label": "Organization",
                "fluid": true,
                "selection": true,
                "dataModel": "vStructDivisionParentsAndThisName",
                "placeholder": "Select Organization",
                "paging": false,
                "search": false,
                "columns": "Name, Id ASC",
                "filters": "[{ column : \"ParentId\" , value : \"{UserStructId}\" , term : \"=\" }]",
                "style-marginBottom": "",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "StructDivisionId"
                      }
                    ]
                  }
                },
                "clearable": true
              }
            ]
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "input_3",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Search by Name...",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "UserName, SampleName"
                      }
                    ]
                  }
                },
                "reference": ""
              }
            ]
          },
          {
            "key": "formgroup_5",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "keywordInput",
                "data-buildertype": "input",
                "label": "Keyword",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Search by keyword... (Enter ''OR'' in between keywords for multiple keywords searching, eg : SurveyA OR SurveyB)",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridAuditLog"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "NewValue, OriginalValue"
                      },
                      {
                        "name": "term",
                        "value": "contains"
                      }
                    ]
                  }
                }
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [],
            "style-source": "clear:both;"
          }
        ],
        "style-customcss": "ui message"
      }
    ],
    "style-customcss": "",
    "style-width": ""
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [],
    "style-float": "",
    "style-marginTop": "20px",
    "style-width": "100%",
    "events": {}
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
          "gridRefresh"
        ],
        "targets": [
          "gridAuditLog"
        ],
        "parameters": []
      }
    },
    "floated": "left",
    "style-marginRight": "60px"
  },
  {
    "key": "gridAuditLog",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UserName",
        "name": "User Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "SampleName",
        "name": "Sample Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "TableName",
        "name": "Table Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "EventType",
        "name": "Event Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "",
        "width": ""
      },
      {
        "key": "EventDate",
        "name": "Event Date",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false
      }
    ],
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
    "rowKey": "Id",
    "pageSize": "64",
    "defaultSort": "EventDate DESC",
    "pagerType": "server",
    "editForm": "AuditLog",
    "style-marginTop": "",
    "style-source": "padding: 10px;\nclear: both;"
  },
  {
    "key": "cnt_adminsGlobalPurge",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_2",
        "data-buildertype": "form",
        "children": [
          {
            "key": "checkboxArchive",
            "data-buildertype": "checkbox",
            "label": "Require Archive",
            "toggle": true,
            "reference": "",
            "style-marginBottom": "",
            "events": {},
            "onChangeTimeout": "200"
          },
          {
            "key": "datePurge",
            "data-buildertype": "input",
            "label": "Purge Date",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "date",
            "events": {},
            "other-customValidation": "data.checkboxArchive == 1 && data.datePurge == null ? \"is required if require archive option is enabled!\" : true",
            "other-visibleConition": "data.checkboxArchive == 1",
            "style-marginBottom": "",
            "style-marginTop": "20px",
            "reference": "Purge Date"
          },
          {
            "key": "btnAdminsGlobalPurge",
            "data-buildertype": "button",
            "content": "Purge All Data!",
            "floated": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "validate",
                  "purgeData"
                ],
                "targets": [
                  "gridAuditLog"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "purgeAuditTrailTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "purgeAuditTrailText"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "checkRole(''AuditAdmin'')"
          }
        ],
        "events": {},
        "style-marginBottom": ""
      }
    ],
    "style-source": "",
    "style-customcss": "ui message",
    "style-marginTop": "30px",
    "style-float": "",
    "style-width": "100%",
    "other-visibleConition": "checkRole(''Admins'')"
  }
]' WHERE [Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65';

UPDATE [dwMetadata] SET
[Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.527', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-11 12:10:41.743', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2022-02-11T12:10:41.7273965+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "filter": "",
      "control": "gridAuditLog",
      "dataMap": [
        {
          "id": "eaa99175-fe0c-2b55-d9fb-e99ac183c740",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96b05054-f2e2-73f2-10cd-5d5beb80324e",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc91b26c-6dbb-6eb8-9218-7d6d83679de5",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac32e752-a32f-f980-bcc7-faec88bf814c",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52e11100-2bc2-9226-7ee5-85362d373cae",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12cd7b55-290c-ad1e-a9c2-0b8340fce6ae",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d060f249-db88-077b-1d9c-ae703ee503a6",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4d8bc32-8976-8eb6-9ee0-37eea7ce980f",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32464828-58e9-8012-af69-c4647c36ea9c",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd1d5507-525b-c4c0-dd2f-ca72ae54c1a3",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6206d655-e39c-07f3-ff1e-554f13447d4c",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21679a71-b29f-ae12-55a8-19853357daed",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81cc9561-54fd-d16d-cb4d-5002c6f892a9",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0cd0a723-ab1d-a598-81cf-0895c3fd9acb",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b239f88-0682-31b7-6d2c-ca7655c88de8",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2af7af6-9443-e547-a849-4a5f564ef036",
          "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__gridAuditLog_totalcount"
    }
  ],
  "securityGroup": "Audit"
}' WHERE [Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd';

