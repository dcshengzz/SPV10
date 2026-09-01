-- Will UPDATE existing row(s) in dwMetadata for the following:
-- UserAccessMatrix.json

UPDATE [dwMetadata] SET
[Id]='8192e808-5af8-4759-acac-ccf130460ef0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.250', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-11-04 15:28:14.720', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "style-marginBottom": "20px",
    "textAlign": "left"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "Aspect",
            "data-buildertype": "dropdown",
            "label": "User Access Aspect",
            "fluid": false,
            "selection": true,
            "data-elements": [],
            "placeholder": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeAspect",
                  "apply"
                ],
                "targets": [
                  "Download"
                ],
                "parameters": []
              }
            },
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px",
            "defaultValue": "",
            "disabled": false
          },
          {
            "key": "Download",
            "data-buildertype": "button",
            "content": "Download",
            "primary": true,
            "floated": "",
            "other-visibleConition": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "onDownload"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-hidden": false,
            "style-marginLeft": "",
            "style-marginTop": "",
            "fluid": false,
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px"
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Access Report Scheduler",
            "floated": "right",
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
                    "value": "AccessReportSchedule"
                  }
                ]
              }
            }
          }
        ],
        "style-width": "100%",
        "style-source": "",
        "style-marginBottom": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "result",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true,
            "isPre": true,
            "fetchData": true
          }
        ],
        "style-float": "",
        "style-marginTop": "40px",
        "style-source": "overflow: auto;"
      }
    ],
    "style-marginBottom": "10px"
  }
]' WHERE [Id]='8192e808-5af8-4759-acac-ccf130460ef0';

