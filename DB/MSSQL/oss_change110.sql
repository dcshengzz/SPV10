-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AuditTrail.json
-- AuditTrail-settings.json
-- AuditTrail-code.js

UPDATE [dwMetadata] SET
[Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.123', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-07 19:06:02.870', 
[Data]=N'[
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
    "key": "form_1",
    "data-buildertype": "form",
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
                  "gridview_1"
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
            }
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
                  "gridview_1"
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
                  "gridview_1"
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
                  "gridview_1"
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
        "key": "formgroup_3",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "input_3",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "placeholder": "Search by name...",
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
                    "value": "UserName, SampleName"
                  }
                ]
              }
            }
          }
        ]
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnPurge",
            "data-buildertype": "button",
            "content": "Purge Data",
            "floated": "right",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "purgeData"
                ],
                "targets": [
                  "gridview_1"
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
            "other-visibleConition": "checkRole(''Admins'')"
          }
        ],
        "style-source": ""
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [],
        "style-source": "clear:both;"
      }
    ],
    "style-customcss": "ui message",
    "style-width": ""
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UserName",
        "name": "User Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "SampleName",
        "name": "Sample Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 200
      },
      {
        "key": "TableName",
        "name": "Table Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 300
      },
      {
        "key": "EventType",
        "name": "Event Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 100
      },
      {
        "key": "EventDate",
        "name": "Event Date",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": 200
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
    "pageSize": "5",
    "defaultSort": "EventDate DESC",
    "pagerType": "server",
    "editForm": "AuditLog",
    "style-marginTop": "5em"
  }
]' WHERE [Id]='4bef2440-7b11-4d01-b795-09ee58ed0f65';

UPDATE [dwMetadata] SET
[Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.527', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-07 19:06:02.943', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2021-07-07T19:06:02.9172649+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "filter": "",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "f345c213-233a-3d14-83ca-88f9b03f5cd2",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "fb91b97d-6949-6b8d-6cf0-9d9ef344f609",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "c06712df-a6b6-c1c7-ab58-7b89a5de041d",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "05e3ee5e-7d2d-b852-82fd-7e3c650b66f8",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "control": "EventDate",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d9fbdbd-8e0a-c637-dafc-ed184a3c9e09",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "control": "EventType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "94f2382f-2a81-4a9b-db2f-044c3c2b2eb9",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d62a9084-0737-ee6e-885d-82a9b7251241",
          "attributeId": "daea24d9-f131-4870-a3bc-750a0b033c03",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a451f0ca-9d5a-5cdd-b1ec-c83348bd1e43",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4081026e-4090-c16d-addd-b49953e746c8",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "5a3cdbb3-406f-d699-2b7b-8eb5618df2b2",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8456ffb4-f2ad-f420-c8d3-7c8551a8ea59",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "59f37d1a-db46-15ad-0a2e-ae2221eaa404",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "control": "SampleName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2b451518-0f05-c7c2-79c2-3f1cd958b3e8",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bed24fc2-e383-12f1-218a-b0930bfccdbc",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "control": "TableName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eb6b3d4e-f6d3-c128-c89a-7458c050c1c5",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfa67c37-9ab4-d908-4fd3-f7091bfa7e34",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f7a1dcb4-683d-c395-ab2d-f08e2e5f3514",
          "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "control": "UserName",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Audit"
}' WHERE [Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd';

UPDATE [dwMetadata] SET
[Id]='17feec00-b037-4302-b630-328e430e7d1f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-06-30 17:35:20.063', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-07 19:08:00.900', 
[Data]=N'{
    
    purgeData: function (args){
        //-----------------------
        const loadingStart = function(loadingMessage) {
        $(''body'').loadingModal({
            text: loadingMessage ? loadingMessage : ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        };
        
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        console.log(args);
        
        const gridView = args.controlRef;
        loadingStart();
        $.post("/audit/purgeauditlog")
        .done(function (data) {
            gridView.refresh();
            if(data.success) 
                alertify.success(data.message);
            else
                alertify.error(data.message);
        }).fail(function (jqxhr, textStatus, error) {
            alertify.error("An error occured");
            console.log(textStatus, error);
        }).always( loadingStop );
    },
  
}' WHERE [Id]='17feec00-b037-4302-b630-328e430e7d1f';

