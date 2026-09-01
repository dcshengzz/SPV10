-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AuditTrail-code.js
-- AuditTrail.json
-- AuditTrail-settings.json
-- AuditLog.json
-- AuditLog-settings.json

UPDATE [dwMetadata] SET
[Id]='17feec00-b037-4302-b630-328e430e7d1f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-06-30 17:35:20.063', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-29 15:11:21.063', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
        console.log("args",args);
    },
    
    
    purgeData: function (args){
        const gridView = args.controlRef;

        var formData = new FormData();

        if(args.data.dateArchive != null){
            formData.append(''dateArchive'', args.data.dateArchive);
        }

        formData.append(''isArchive'', args.data.checkboxArchive);
        formData.append(''dataCreatedBefore'', args.data.dataCreatedBefore);

        Utils.loadingStart();
        Utils.postFormRequest("/audit/purgeauditlog",formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
                console.log("purgeData error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    //disable dimmer click because the model will be close when user select date in modal.
    //this issue is due to old react modal version.
    closeDimmerClick: function(args) {
        args.component.refs.purgeModal.state.dimmerClick = false;
    },
    
    closeModal: function(args) {
        args.component.refs.purgeModal.close();
    },
  
}' WHERE [Id]='17feec00-b037-4302-b630-328e430e7d1f';

UPDATE [dwMetadata] SET
[Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.123', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-29 16:31:33.987', 
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
                      },
                      {
                        "name": "term",
                        "value": "="
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
            "key": "formgroup_6",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "inputEventBatch",
                "data-buildertype": "input",
                "label": "Event Batch",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Search by Event Batch...",
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
                        "value": "EventBatch"
                      }
                    ]
                  }
                },
                "reference": ""
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
      },
      {
        "key": "EventBatch",
        "name": "Event Batch",
        "type": "",
        "sortable": true,
        "filterable": false,
        "resizable": true
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
    "key": "purgeModal",
    "data-buildertype": "swzmodal",
    "secondary": true,
    "content": "Purge Data",
    "children": [
      {
        "key": "headerPurge",
        "data-buildertype": "header",
        "content": "Purge Audit Log",
        "size": "medium",
        "style-marginBottom": ""
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
                "key": "dataCreatedBefore",
                "data-buildertype": "input",
                "label": "Data Created Before",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "date",
                "events": {},
                "other-customValidation": "data.dataCreatedBefore== null ? \"is required!\" : true",
                "other-visibleConition": "",
                "style-marginBottom": "",
                "style-marginTop": "20px",
                "reference": "Data Created Before"
              },
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
                "key": "dateArchive",
                "data-buildertype": "input",
                "label": "Archive On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "events": {},
                "other-customValidation": "data.checkboxArchive == 1 && data.dateArchive == null ? \"is required if archive option is enabled!\" : true",
                "other-visibleConition": "data.checkboxArchive == 1",
                "style-marginBottom": "",
                "style-marginTop": "40px",
                "reference": "Archive On"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnAdminsGlobalPurge",
                    "data-buildertype": "button",
                    "content": "Purge",
                    "floated": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "validate",
                          "confirm",
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
                    "secondary": false,
                    "other-visibleConition": "checkRole(''AuditAdmin'')",
                    "primary": true,
                    "style-source": ""
                  },
                  {
                    "key": "btnCancel",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "floated": "",
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
                    "secondary": true,
                    "other-visibleConition": "checkRole(''AuditAdmin'')",
                    "style-source": ""
                  }
                ],
                "style-float": "right",
                "style-marginBottom": "10px",
                "events": {},
                "style-marginTop": "20px"
              }
            ],
            "events": {},
            "style-marginBottom": "",
            "style-hidden": false
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "style-marginTop": "30px",
        "style-float": "",
        "style-width": "100%",
        "other-visibleConition": "checkRole(''Admins'')"
      }
    ],
    "style-display": "none",
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "closeDimmerClick"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "size": "",
    "isOpen": "",
    "isDimmerClick": "false"
  }
]' WHERE [Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65';

UPDATE [dwMetadata] SET
[Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.527', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-29 16:31:34.037', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2022-03-29T16:31:34.0306981+08:00",
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
          "id": "1da8afa6-eea4-1ee7-f17b-a01f0a456237",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "08acbef9-6831-48e2-2af2-52216b1456e4",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7df65018-3147-8215-75e0-d2f73d6079c8",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3fa460f6-f6a5-e62b-9971-cedd6ade008a",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5b06b555-b388-83ab-79ec-addf1b662752",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "495240a2-b931-1a37-3b5c-44afe9987d37",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0c7cb0c4-bf7a-64e6-ae10-52cad864b339",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "94ff067c-dcb4-c97c-c8c6-a6431ff1f214",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06ea8a9e-439d-d82c-2ea4-c8bd4190f179",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6d57e59-dc42-758c-f5b5-f53619e6ab8a",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6889c548-9be3-13f9-3f4a-ca87b61c1763",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "527b50fd-d8b7-d361-94a6-19975629b50f",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8775a7f2-5b60-c668-118a-bb31d7894113",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "65fb8f97-bfe6-91af-b955-cf1277b393c1",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "65cc4078-2355-1e72-504c-64eadf90b062",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "38377b17-22e6-c16f-32e6-22c6197b8331",
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

UPDATE [dwMetadata] SET
[Id]='f5168e8b-50fc-442b-ad6d-3e225324bd0e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-28 17:35:29.610', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-29 10:42:59.903', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Audit Log Item Details",
    "size": "medium"
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
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Back",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirect"
                ],
                "targets": [],
                "parameters": [
                  {
                    "value": "/form/audittrail",
                    "name": "target"
                  }
                ]
              }
            },
            "secondary": true,
            "toggle": true,
            "floated": "right"
          },
          {
            "key": "Id",
            "data-buildertype": "input",
            "label": "Id",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "Division",
            "data-buildertype": "input",
            "label": "Division",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "LoginId",
            "data-buildertype": "input",
            "label": "Login Id",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined",
            "events": {},
            "readOnly": true
          },
          {
            "key": "UserName",
            "data-buildertype": "input",
            "label": "User Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId!=null  && data.UserId!=undefined",
            "readOnly": true
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "Sample UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined",
            "readOnly": true
          },
          {
            "key": "SampleName",
            "data-buildertype": "input",
            "label": "Sample Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-visibleConition": "data.UserId==null || data.UserId==undefined",
            "readOnly": true
          },
          {
            "key": "EventType",
            "data-buildertype": "input",
            "label": "EventType",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "TableName",
            "data-buildertype": "input",
            "label": "TableName",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "RecordId",
            "data-buildertype": "input",
            "label": "RecordId",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "EventBatch",
            "data-buildertype": "input",
            "label": "EventBatch",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "ColumnName",
            "data-buildertype": "input",
            "label": "ColumnName",
            "fluid": true,
            "onChangeTimeout": 200,
            "readOnly": true
          },
          {
            "key": "EventDate",
            "data-buildertype": "input",
            "label": "EventDate",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "datetime",
            "readOnly": true
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "OriginalValue",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "{OriginalValue}",
                    "fetchData": false,
                    "events": {},
                    "style-customcss": "custom-label",
                    "isHtml": false,
                    "isPre": true
                  }
                ]
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "style-customcss": "field",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_3",
                    "data-buildertype": "staticcontent",
                    "content": "New Value",
                    "events": {},
                    "style-customcss": "custom-label"
                  }
                ],
                "style-customcss": "custom-label"
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "{NewValue}",
                "isHtml": false,
                "isPre": true
              }
            ]
          }
        ],
        "placeholders": {
          "customblock_1": []
        }
      }
    ]
  }
]' WHERE [Id]='f5168e8b-50fc-442b-ad6d-3e225324bd0e';

UPDATE [dwMetadata] SET
[Id]='65d69bcf-b52e-4a1a-bc13-6b7e790652b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditLog-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-28 17:35:29.720', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-29 10:42:59.933', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditLog",
  "lastUpdate": "2022-03-29T10:42:59.9321403+08:00",
  "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "21ca0018-6664-9ebf-5bdd-c3e300926676",
      "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2180ce1a-ca9e-10ac-b578-5ac709bc6893",
      "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "de405cfe-f8e9-6d3f-327a-d06d6e4d40cb",
      "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8d753f4c-73f9-0d0b-3e91-9ae3f085e969",
      "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "45a67e03-7e0f-a483-85c0-6092f813607f",
      "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bd33cf36-8a50-1b3c-d90d-19b33438517e",
      "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9725af5f-0b3a-4e76-3a38-beab3dab06c5",
      "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a4907796-043b-d8c5-3f65-a44b872b3b8e",
      "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "02bef758-0b83-4dbb-61aa-0af845f4fa15",
      "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79413a0f-594b-adde-fac4-b755f5f2f2b3",
      "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7bd01f9f-2fd3-2aa7-4883-6ddc39f04790",
      "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3d64c467-9a7a-7ba5-2bd4-a98c67eca42a",
      "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8a9b96e8-5b20-67f7-b67c-4adb9b7d136f",
      "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "70bf3886-8fa6-f096-4571-f5bfe692be68",
      "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e8b18e96-c333-eabf-bc79-843c1f7ead99",
      "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f6a525e9-f5bf-7ab1-b80d-56da15ec782a",
      "attributeId": "cd56fef8-e80f-4859-b2e7-49192ef4b0b5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a715c5b-2a64-2d94-7918-a1afe0670020",
      "attributeId": "dbd50faf-3f0f-4d91-9bf2-17bb574df291",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Audit"
}' WHERE [Id]='65d69bcf-b52e-4a1a-bc13-6b7e790652b0';

