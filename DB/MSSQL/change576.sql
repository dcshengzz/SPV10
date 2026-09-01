-- Will UPDATE existing row(s) in dwMetadata for the following:
-- MaintenanceTests.json
-- MaintenanceTests-settings.json
-- MaintenanceTests-code.js

UPDATE [dwMetadata] SET
[Id]='a6635595-4d80-40b2-8744-d2d85202a33d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'MaintenanceTests.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-12-10 12:50:58.680', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-21 13:52:17.853', 
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
                    "style-height": "64px"
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
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-21 13:52:17.877', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2025-11-21T13:52:17.876335+08:00",
  "isTemplate": false,
  "securityGroup": "Maintenance"
}' WHERE [Id]='1164183a-ef0d-4305-8b50-761541e8ccb1';

UPDATE [dwMetadata] SET
[Id]='9ec429b4-65c7-4b46-b828-6d17ac19ad1e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'MaintenanceTests-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-12-11 14:01:24.710', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2025-11-21 13:58:14.383', 
[Data]=N'{
    init: function(args) {
        Utils.loadingStart("Loading...");
        Utils.getRequest("/maintenance/license").then(
            response => {
                const details = response.item;
                console.log( "SurveyPlus License Details", response.item ); //don''t remove - console provides more detail than UI
                const descriptionHtml = ''<span style="font-style: italic;">'' + Utils.encodeHTML(details.description) + ''</span>'';
                CloverApp.API.setDataField("license_host", details.host);
                CloverApp.API.setDataField("license_expiry", details.expiry);
                CloverApp.API.setDataField("license_description", descriptionHtml);
            }, reason => {
                console.error("Failed to fetch SurveyPlus License Details", reason);
                const errorHtml = ''<span style="font-weight: bold; color: red;">Unable to get license details</span>'';
                CloverApp.API.setDataField("license_description", errorHtml);
            }
        ).finally(Utils.loadingStop);
    },
    
    performSmtpTest: function(args) {
        const behaviour = args.parameters.behaviour;
        const msgDuration = 30000; //Longer alert time on screen makes it easier to screenshot
        const url = "/maintenance/tests/smtp/" + encodeURIComponent(behaviour);
        const waitMessage = "Performing " + behaviour + " SMTP Test...";
        console.log(waitMessage);
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url).then(
            response => {
                console.log( response.message );
                alertify.success(Utils.encodeHTML(response.message), msgDuration);
            }, reason => {
                console.error(reason);
                alertify.error(Utils.encodeHTML(reason), msgDuration);
            }
        ).finally(Utils.loadingStop);
    },
}' WHERE [Id]='9ec429b4-65c7-4b46-b828-6d17ac19ad1e';

