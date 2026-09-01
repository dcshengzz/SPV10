-- Will UPDATE existing row(s) in dwMetadata for the following:
-- MaintenanceTests.json
-- MaintenanceTests-settings.json

UPDATE [dwMetadata] SET
[Id]='a6635595-4d80-40b2-8744-d2d85202a33d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'MaintenanceTests.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-12-10 12:50:58.680', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-21 20:31:02.493', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Maintenance",
        "size": "medium"
      },
      {
        "key": "container_smtpTests",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "fg_smtpTests",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_smtp",
                "data-buildertype": "message",
                "header": "SMTP Test",
                "content": "The SMTP test will exercise the SMTP integration by sending a test message to users in your organisation and its child organisations who have the Maintenance role. The ''background'' behaviour will enqueue a job to immediately send the message in the background while the ''direct'' behaviour will immediately send it directly from the server. If the background test is not successful you can try the direct test. If that is successful yet the background test is not, then the problem lies with the scheduled job mechanism rather than the SMTP integration.",
                "info": true
              },
              {
                "key": "container_2",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnSmtpTestBackground",
                    "data-buildertype": "button",
                    "content": "Perform SMTP Test (Background)",
                    "primary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "performSmtpTest"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "behaviour",
                            "value": "async"
                          }
                        ]
                      }
                    },
                    "style-width": "200px",
                    "style-height": "64px",
                    "style-customcss": "download icon",
                    "size": ""
                  },
                  {
                    "key": "btnSmtpTestDirect",
                    "data-buildertype": "button",
                    "content": "Perform SMTP Test (Direct)",
                    "primary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "performSmtpTest"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "behaviour",
                            "value": "direct"
                          }
                        ]
                      }
                    },
                    "style-marginLeft": "20px",
                    "style-width": "200px",
                    "style-height": "64px"
                  }
                ]
              }
            ],
            "style-marginBottom": ""
          }
        ],
        "style-width": "640px",
        "style-marginRight": "20px",
        "style-marginBottom": "20px"
      },
      {
        "key": "container_license",
        "data-buildertype": "container",
        "children": [
          {
            "key": "fg_license",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_license",
                "data-buildertype": "message",
                "header": "SurveyPlus License",
                "content": "Each backoffice server has its own license. In a multiple server environment the information shown here will only provide the details for the particular server that handled this request.",
                "info": true
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "license_description",
                    "data-buildertype": "staticcontent",
                    "content": "(License Description)",
                    "fetchData": true,
                    "style-font-size": "",
                    "isHtml": true,
                    "isPre": true,
                    "style-marginTop": "",
                    "style-source": "\n"
                  }
                ],
                "style-marginTop": "",
                "style-source": "padding: 10px;\nborder: 1px solid rgba(44, 51, 56, 0.165);\n",
                "style-customcss": "",
                "style-marginBottom": "20px"
              },
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "formgroup_1",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "children": [
                      {
                        "key": "license_expiry",
                        "data-buildertype": "input",
                        "label": "Expiring",
                        "fluid": false,
                        "onChangeTimeout": 200,
                        "type": "datetime",
                        "readOnly": true,
                        "style-width": "200px"
                      },
                      {
                        "key": "license_host",
                        "data-buildertype": "input",
                        "label": "Licensed Host",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "readOnly": true,
                        "style-width": "400px"
                      }
                    ],
                    "orientation": "inline",
                    "style-width": "100%"
                  }
                ],
                "style-marginBottom": "20px"
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "style-marginBottom": ""
          }
        ],
        "style-float": "left",
        "style-width": "640px",
        "style-marginBottom": "20px",
        "style-marginRight": "20px"
      },
      {
        "key": "container_database",
        "data-buildertype": "container",
        "children": [
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "Database Tools & Reports",
                "content": "",
                "info": true
              },
              {
                "key": "sc_link_objectpageusage",
                "data-buildertype": "staticcontent",
                "content": "<i class=\"download icon\"></i><a href=\"/maintenance/database/objectpageusage\">Object Page Usage (CSV Format)</a>",
                "isHtml": true
              }
            ],
            "style-source": "border: 1px solid black;\npadding: 20px;",
            "style-marginBottom": ""
          }
        ],
        "style-float": "left",
        "style-width": "640px",
        "style-marginBottom": "20px",
        "style-marginRight": "20px"
      }
    ],
    "style-width": ""
  }
]' WHERE [Id]='a6635595-4d80-40b2-8744-d2d85202a33d';

UPDATE [dwMetadata] SET
[Id]='1164183a-ef0d-4305-8b50-761541e8ccb1', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'MaintenanceTests-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-12-10 12:50:58.747', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-21 20:31:02.517', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2025-11-21T20:31:02.5151413+08:00",
  "isTemplate": false,
  "securityGroup": "Maintenance"
}' WHERE [Id]='1164183a-ef0d-4305-8b50-761541e8ccb1';

