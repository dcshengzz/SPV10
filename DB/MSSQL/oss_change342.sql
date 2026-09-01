-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzGlobalMailer.json
-- SwzGlobalMailer-settings.json
-- SwzGlobalMailer-code.js
-- SwzGlobalMailerMessage.json
-- SwzGlobalMailerMessage-settings.json
-- SwzGlobalMailerMessage-code.js

UPDATE [dwMetadata] SET
[Id]='7920415b-36c7-4270-99de-fcd7abca91a7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 11:30:27.113', 
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
        "style-float": "left",
        "style-marginBottom": "20px",
        "events": {},
        "style-marginTop": "20px",
        "style-marginRight": ""
      }
    ],
    "style-source": "clear: both;",
    "style-marginBottom": ""
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
            "resizable": false,
            "type": "datetime"
          },
          {
            "key": "ScheduledDate",
            "name": "Scheduled",
            "type": "datetime",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "EmailSubj",
            "name": "Subject",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "SampleCount",
            "name": "Sent",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "JobIsCanceled",
            "name": "Cancelled",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "IsTargetUsers",
            "name": "Intranet",
            "type": "checkbox",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": false
          }
        ],
        "rowKey": "Id",
        "pagerType": "server",
        "defaultSort": "NumberId DESC",
        "multiselect": false,
        "rowHeight": "",
        "pageSize": "80",
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
    ]
  }
]' WHERE [Id]='7920415b-36c7-4270-99de-fcd7abca91a7';

UPDATE [dwMetadata] SET
[Id]='bd23d168-027b-4827-b17a-7617b4a12378', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 11:30:27.147', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailer",
  "lastUpdate": "2022-09-12T11:30:27.1454899+08:00",
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
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='bd23d168-027b-4827-b17a-7617b4a12378';

UPDATE [dwMetadata] SET
[Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:24:14.453', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 11:30:02.787', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    createEmail: function(args){
        console.log("resend args", args);

        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent = args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        /*
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        */
        
        let validated = true;
        
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        /*if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }*/
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''status'', status);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ? emailFrom : "");
        formData.append(''scheduledDate'', scheduledDate);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    args.controlRef.refresh();
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally( Utils.loadingStop );
  
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
}' WHERE [Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d';

UPDATE [dwMetadata] SET
[Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.460', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 12:57:39.220', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Global Mail Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5><p>{EmailSubj}</p>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5>{MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>\n",
        "isHtml": true
      },
      {
        "key": "staticcontent_emailFrom",
        "data-buildertype": "staticcontent",
        "content": "{EmailFrom}",
        "isHtml": false,
        "other-visibleConition": "(data.EmailFrom != null && data.EmailFrom != \"\")"
      },
      {
        "key": "staticcontent_DefaultEmailFrom",
        "data-buildertype": "staticcontent",
        "content": "<i>(Default Sender)</i>",
        "isHtml": true,
        "other-visibleConition": "(data.EmailFrom==null || data.EmailFrom==\"\")"
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_3",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Scheduled time:</h5>{ScheduledDate}<p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_1",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">For Status:</h5><p name=\"status\"><p/>",
            "isHtml": true
          },
          {
            "key": "StatusCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "ForStatus_Title",
                "name": ""
              }
            ],
            "readOnly": true,
            "hierarchical": false,
            "disableAdd": true,
            "disableDelete": true,
            "header": false,
            "events": {},
            "collapseAll": false,
            "draggable": false,
            "style-hidden": true
          }
        ],
        "other-visibleConition": "data.StatusCollection.length !== 0"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "staticcontent_4",
            "data-buildertype": "staticcontent",
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">This scheduled job was cancelled</h5><p/>",
            "isHtml": true,
            "other-visibleConition": "data.ScheduledDate"
          }
        ],
        "other-visibleConition": "data.JobIsCanceled"
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%"
  },
  {
    "key": "container_6",
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
                    "placeholder": "Organization",
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
                        "text": "Intranet Users"
                      },
                      {
                        "key": 2,
                        "value": "activeSamples",
                        "text": "Active Samples"
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
                    "other-visibleConition": "data.target == null ? data.IsTargetUsers == true ? false : true : data.target == \"activeSamples\" ? true : false",
                    "other-customValidation-soft": false
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
                    "events": {},
                    "other-required": false
                  },
                  {
                    "key": "emailSubj",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-visibleConition": "",
                    "style-marginBottom": "20px",
                    "other-required": false
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
                    "style-marginBottom": "20px",
                    "other-required": true
                  },
                  {
                    "key": "msgContentEditor",
                    "data-buildertype": "swzhtml",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "onHtmlChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "",
                    "other-customValidation": "",
                    "defaultValue": "",
                    "hideOutput": "block",
                    "other-required": true
                  }
                ],
                "style-source": "",
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_15",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btn_SubmitEdit",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "editEmail"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btnCancelEdit",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "inverted": false,
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
                    "primary": false
                  }
                ],
                "style-marginTop": "20px"
              }
            ],
            "style-customcss": "ui message"
          }
        ],
        "content": "Edit",
        "secondary": false,
        "inverted": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "onEditClick"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "style-source": "",
        "size": "",
        "primary": true,
        "other-visibleConition": "!data.JobIsCanceled && data.MsgContentJson != null && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      }
    ],
    "style-float": "left"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cancelJob",
        "data-buildertype": "button",
        "content": "Cancel This Job",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "confirm",
              "cancelJob"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "!data.JobIsCanceled && data.ScheduledDate && new Date(data.ScheduledDate )>new Date()"
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Exit",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "value": "/form/SwzGlobalMailer",
                "name": "target"
              }
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  },
  {
    "key": "searchSample",
    "data-buildertype": "input",
    "label": "",
    "fluid": true,
    "onChangeTimeout": 200,
    "placeholder": "Filter by UID",
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "setFilter",
          "applyFilter"
        ],
        "targets": [
          "sampleGrid"
        ],
        "parameters": [
          {
            "name": "column",
            "value": "UID"
          }
        ]
      }
    },
    "style-marginBottom": "20px",
    "style-width": "300px",
    "other-visibleConition": "data.IsTargetUsers == 0 ? true : false"
  },
  {
    "key": "searchUser",
    "data-buildertype": "input",
    "label": "",
    "fluid": true,
    "onChangeTimeout": 200,
    "placeholder": "Filter by UID",
    "events": {
      "onChange": {
        "active": true,
        "actions": [
          "setFilter",
          "applyFilter"
        ],
        "targets": [
          "userGrid"
        ],
        "parameters": [
          {
            "name": "column",
            "value": "Name"
          }
        ]
      }
    },
    "style-marginBottom": "20px",
    "style-width": "300px",
    "other-visibleConition": "data.IsTargetUsers == 1 ? true : false"
  },
  {
    "key": "sampleGrid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "UID ASC",
    "pagerType": "server",
    "other-visibleConition": "data.IsTargetUsers == 0 ? true : false"
  },
  {
    "key": "userGrid",
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
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "EmailSentDate",
        "name": "Sent Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "Name ASC",
    "pagerType": "server",
    "other-visibleConition": "data.IsTargetUsers == 1 ? true : false"
  }
]' WHERE [Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf';

UPDATE [dwMetadata] SET
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 12:57:39.267', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2022-09-12T12:57:39.2672257+08:00",
  "entityId": "702ee0f9-58fb-4592-8e50-40ff050e49f2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "2233d8bb-2753-7adc-140a-f3713ed2bd19",
      "attributeId": "51458d0d-a57e-415d-af77-0506b62b2deb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e737ab32-149c-f374-034e-dbe21901d118",
      "attributeId": "178e7c32-3be5-46ae-8ab1-94a6504f1a2b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "78945706-2fd2-e046-bfdb-bc96647a242b",
      "attributeId": "7c6620ef-f482-49bd-86bd-86ec78fa23ee",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "80e9b5b6-e9d0-d6c6-7820-fda90a42cdca",
      "attributeId": "04e1e5d0-d802-4a29-92ab-221ff60efb6c",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "cc3532d7-a661-48ec-434f-ecbf5d6f4c37",
      "attributeId": "868d7019-916a-41a2-ad9c-80e83c3e7146",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37108dd-6858-a497-a9bb-a8a61d9d4a62",
      "attributeId": "cf5185ac-386f-4c17-9b43-d81346e47627",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "00f5b7a6-98e0-e43d-bdfb-7130427ac87b",
      "attributeId": "7f4eb9fe-d50d-4b90-be34-5f81b48a005f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbc3f2c9-8468-1e35-8b28-186bd9130f4c",
      "attributeId": "25163e9e-6d07-4423-bef6-5203af0926cf",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "4c82c383-7898-02c4-46e8-c5048e9d98e1",
      "attributeId": "a59d6ab1-d8f1-4092-a7b2-5302d788b52a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d7efc1d-18a9-1188-aaab-64a342757ed9",
      "attributeId": "e24601f7-a005-4dc1-b76b-2e4ced2c9f47",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a9ee0391-52e3-87a4-554f-0b077751cef3",
      "attributeId": "ffc06abf-996d-41b7-8aee-f8ee9b573217",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e3246e2e-23df-9c09-498d-019c4037fbaf",
      "attributeId": "b34d67a4-bfc5-4ee0-9112-d7ddffbfd570",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1c40f8b2-4c30-f7bc-e027-d37ee84d4bfd",
      "attributeId": "603cb5e3-af1f-4288-8659-9d041999c4d4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "19190086-6d45-9e40-be40-9531abc43cd7",
      "attributeId": "98daf50e-4248-4701-8fdd-17dacdd94355",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfe6fd82-2f3c-1d8e-ca6f-761aab03d8ef",
      "attributeId": "bb0f1b64-9144-4b35-916b-3a6292a0e774",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "61abc650-e453-e08e-8278-b4f1239170d1",
      "attributeId": "f1658572-a0e2-4084-8cf9-17b3a4f2998a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d475ab76-4cf6-9e57-4d3b-bc47bac2dedf",
      "attributeId": "1a057eec-3f17-49fa-b876-261f21e6695a",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "b0292df5-4b89-70ba-7594-fd5ba4e1f8bc",
      "entityId": "65091649-b0af-4091-86f9-7109aeb9fbf7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "attributeId": "8c53aed3-bbc5-420f-84f0-e6b8820052cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10d586e4-f3bf-dd0a-fdc5-8e00c0c5b388",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "3ef7bb8c-fa79-1943-a5d6-2c394beeaec1",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "e9dd17e6-7fdd-78ea-f15d-73b1202f750b",
          "attributeId": "1287529e-1bc7-465a-a53b-98cb619f253b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4ce34148-ea28-4a48-8417-e7f8a16a222c",
          "attributeId": "1ffeb14b-0ab9-4ca5-ade4-2971477fe68b",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__StatusCollection_totalcount"
    },
    {
      "id": "4ba1a0b1-27ae-1ffb-2156-315fff887e73",
      "entityId": "1aa13d9f-30a1-482e-9733-ee01420755f7",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "sampleGrid",
      "dataMap": [
        {
          "id": "fc90a4a8-8cf1-61a1-609c-fd1ec101de5f",
          "attributeId": "e958ec47-15ba-4f2a-9f06-b82631dc6a6f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3f4699a1-ab9d-1454-a2c7-647b982701af",
          "attributeId": "0e2eac76-0927-4eb7-8fdf-c5955a3d227a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bf4d04ce-5cb5-202a-a744-9bee51e82991",
          "attributeId": "8b4aaa31-a559-4912-9397-09de90ac4e16",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9a504a99-7cd1-4452-6ffc-7612b2961e92",
          "attributeId": "4853e87b-032f-48ce-b964-790b92b9e918",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d4e96d7-3e92-7958-6d7e-687c26985e75",
          "attributeId": "686137e7-c77f-43bd-9dd2-e6b79b4465aa",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96a42599-adad-d96f-c7e2-4ac67180323e",
          "attributeId": "907dfbd8-9670-4099-8dae-91b18986837c",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__sampleGrid_totalcount"
    },
    {
      "id": "10a9584a-1aff-bc30-6e96-512acd7ac710",
      "entityId": "a7267c48-2060-46d2-8923-cd1dcbd01006",
      "filter": "FilterByModelId",
      "parameter": "{GlobalMsgId: \"@Id\"}",
      "control": "userGrid",
      "dataMap": [
        {
          "id": "4f17a43d-7519-f6d4-b4ca-c396cb3bc46e",
          "attributeId": "b3bc9f47-0598-4079-9114-f21bf45fc83e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5272c995-ab67-e316-a4de-fc2bbe043cd8",
          "attributeId": "4077a2c7-b11c-42e3-9fdc-e9382299c204",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63d33da7-0f3c-5557-34a2-b50f4da8ebb1",
          "attributeId": "08edc3df-13f7-480f-9fbe-9a8d1f638a70",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a9427ff3-b519-ab75-0167-db1c85bb1450",
          "attributeId": "0a99aad0-9fcf-412f-8f29-f51ec14de57e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "619b3f3f-8600-98d5-ebe3-865d75e7ecbc",
          "attributeId": "cef5e01e-8dcb-4767-bcb9-6b1dc397ea25",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__userGrid_totalcount"
    }
  ],
  "securityGroup": "GlobalMailer"
}' WHERE [Id]='95150f4a-b078-48ac-a2a5-a12da83bf571';

UPDATE [dwMetadata] SET
[Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:13:14.040', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-12 13:30:26.453', 
[Data]=N'{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'')
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    //var element = CloverApp.API.createElement("a", {className: "ui label"}, entry.ForStatus_Title);
                    $("p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
        
        console.log(args);
    },
    
    cancelJob: function(args){
        const formData = new FormData();
        formData.append(''globalMsgId'', args.data.Id);
        Utils.loadingStart("Cancelling mail job");
        Utils.postFormRequest("/globalmailer/canceljob", formData).then(
            response => {
                alertify.success(response.message);
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swz_modal_2");
            }, reason => {
                alertify.error(reason);
                console.log("cancelJob error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    editEmail: function(args){
        
        const globalMsgId = args.data.Id;
        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? target=="intranetUsers" ? "" :  args.data.dictionaryStatus : "";
        
        let validated = true;
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null || msgContentJson==undefined || msgContentJson==null){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        const formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''globalMsgId'', globalMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success("Message updated");
                const reloadUrl = "/form/SwzGlobalMailerMessage/" + encodeURIComponent(globalMsgId);
                window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of editEmail
    

    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        if(args.data.StatusCollection.length > 0){
            CloverApp.API.setDataField("target","activeSamples");
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("dictionaryStatus",statuslist);
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("organization",args.data.StructDivisionId);
        CloverApp.API.setDataField("target",args.data.IsTargetUsers ? "intranetUsers" : "activeSamples" );
        return { 
            app:{}
        }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
}' WHERE [Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c';

