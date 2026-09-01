-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMessage.json
-- dplyMessage-code.js
-- dplyMessage-settings.json
-- dplyMessages.json
-- dplyMessages-code.js
-- dplyMessages-settings.json
-- SwzGlobalMailerMessage.json
-- SwzGlobalMailerMessage-code.js
-- SwzGlobalMailerMessage-settings.json
-- SwzGlobalMailer.json
-- SwzGlobalMailer-code.js
-- SwzGlobalMailer-settings.json

UPDATE [dwMetadata] SET
[Id]='057eacaf-f332-4646-aa05-4e3d5656246a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:47.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 10:18:45.670', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Deployment Message",
    "size": "huge"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_2",
        "data-buildertype": "staticcontent",
        "content": "<h5 class=\"ui header\">Email Subject: </h5> {EmailSubj}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5> {MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5> {EmailFrom}<p/>\n\n",
        "isHtml": true
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
      }
    ],
    "style-marginBottom": "20px",
    "style-customcss": "ui message",
    "other-visibleConition": "",
    "style-width": "100%",
    "events": {},
    "other-required": false
  },
  {
    "key": "container_5",
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
                "key": "container_3",
                "data-buildertype": "container",
                "style-source": "clear: both;",
                "children": [
                  {
                    "key": "breadcrumb_1",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "url": ""
                      }
                    ],
                    "events": {
                      "onItemClick": {
                        "active": true,
                        "actions": [
                          "downloadEmailTemplate"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ],
                "style-marginBottom": "20px",
                "style-float": "left"
              },
              {
                "key": "container_14",
                "data-buildertype": "container",
                "style-source": "clear: both;",
                "children": [
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
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "20px",
                    "clearable": true,
                    "placeholder": "Select Status",
                    "multiple": true,
                    "other-visibleConition": "",
                    "other-required": true
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
                    "key": "button_2",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "editEmailToStatus"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btnCancel_1",
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
        "content": "Cancel Job",
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
        "content": "Back",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "goBack"
            ],
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "other-visibleConition": "",
        "inverted": false,
        "secondary": true
      }
    ],
    "style-marginBottom": "20px",
    "style-float": ""
  },
  {
    "key": "input_1",
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
          "gridview_1"
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
    "style-width": "300px"
  },
  {
    "key": "gridview_1",
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
    "pagerType": "server"
  }
]' WHERE [Id]='057eacaf-f332-4646-aa05-4e3d5656246a';

UPDATE [dwMetadata] SET
[Id]='87ead053-54cb-4735-8cbc-e812f3344ab3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 12:29:26.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 15:22:55.870', 
[Data]=N'{
    init: function(args){
        console.log(args);
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'');
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    $("p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
    },
    cancelJob: function(args){
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
       
       return ()=> {
            var url = ''/deployment/canceljob'' 
            var formData = new FormData();
            formData.append(''dplyMsgId'', args.data.Id);
            
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    $(''body'').loadingModal(''destroy'');
                    if (response.success) {
                        alertify.success(response.message);
                        const hideControls = [ "cancelJob", "swzmodal_2"];
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: hideControls
                                        }
                                    }
                                },
    

                            }
                        });    
    
                    } else {
                        alertify.error(response.message);
                    }
    
                })
                .catch(error => {
                    alertify.error(error.message);;
                });     
       }
    },
    editEmailToStatus: function(args){
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

        Pace.start();

        var dplyMsgId = args.data.Id;
        var dplyId = args.data.DplyId;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        var msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        var subject = args.data.emailSubj;
        var status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        let validated = true;
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
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

        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''dplyMsgId'', dplyMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        loadingStart();
        var url = ''/deployment/emailtostatus'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/dplyMessage/" + encodeURIComponent(dplyMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
            })
            .finally(()=>{
                Pace.stop();
            });   
        
    },
    downloadEmailTemplate: function(args){
         var text = '''';
        text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
        text += ''Purpose of the Survey:\n''
        text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
        text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
        text +=''Submission of the Questionnaire:\n''
        text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
        text +='' \n''
        text +=''The following are your login information:\n''
        text +=''Company name: {Name}\n''
        text +=''Username: {UID}\n''
        text +=''Password: {Password}\n''
        text +='' \n''
        
        text +=''Other tokens:\n''
        text +=''UID: {UID}\n''
        text +=''Password: {Password}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
        
        
         var hiddenElement = document.createElement(''a'');
            hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
            hiddenElement.target = ''_blank'';
            hiddenElement.download = ''EmailTemplate.txt'';
            hiddenElement.click();
    },
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    onEditClick: function (args) {
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    CloverApp.API.setDataField("dictionaryStatus",entry.ForStatus );
                });
        }
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        return { app:{} }
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
}' WHERE [Id]='87ead053-54cb-4735-8cbc-e812f3344ab3';

UPDATE [dwMetadata] SET
[Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:48.240', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 10:18:45.683', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMessage",
  "lastUpdate": "2021-08-27T10:18:45.6848053+08:00",
  "entityId": "d0fc550f-5f5b-48ef-9c22-bbb30528e6c2",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c9370afc-65af-ce1d-128b-ff72c191483e",
      "attributeId": "98ea38c9-6a0b-43c9-81e7-33c0fdf81664",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "745eb442-a214-4015-763d-c755eec82f9d",
      "attributeId": "53013ae2-ac53-49d9-8256-29517c8ce92d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2e313eff-505e-20bd-1d77-b769e682a84b",
      "attributeId": "05249853-6194-4045-b78a-b300b1261dbd",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "22c2ff97-d372-1635-b14c-5b85336111aa",
      "attributeId": "3827faa7-8f56-4657-b62f-3f0e2b741601",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "58d6ca3f-5562-1a2f-c667-264b808bc8e8",
      "attributeId": "59c5738d-c75c-48f3-a13d-89551dc8f265",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe10991b-03f6-819b-ea3d-d7c0d22e5a43",
      "attributeId": "617e73c0-cbc5-427c-8b5c-9b3eb9724eef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "93b2e866-3493-3a03-f1fc-3acd60609772",
      "attributeId": "b048ef0b-e83c-441b-8a37-bb9c186da00e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a486fa98-68dc-c3fc-3e8d-663cc132d38f",
      "attributeId": "e2f43f33-e402-4bf0-8240-406f330128ef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d4e4f928-bbf0-3903-7f5b-e31155052692",
      "attributeId": "980ba3ed-445e-4048-84e4-aa8a5a894d03",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "742c9f5f-2e42-54f7-4d33-04341f347da7",
      "attributeId": "723a024e-c6b7-4a6d-8840-700288df74fe",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6931df1a-f300-025f-3f2d-1bacd4666f5f",
      "attributeId": "5aa6f5c9-ff71-45dc-aac4-069c32bd2e46",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d705f381-e567-d49c-7c16-5c6f4ffdd799",
      "attributeId": "91b7860e-858d-4fb2-8c34-e08911284e78",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e29ebf-55bc-6cfe-af47-e9318c8cce94",
      "attributeId": "d8a72553-1d8e-4c67-8429-9055cb5c6679",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8d5ceaa9-dbf6-ce90-c5c6-364eee828eeb",
      "attributeId": "c43a9452-c591-440c-a1d4-e35201bfdd51",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d845079c-af30-193c-ffc1-a242f62aaa5b",
      "attributeId": "2081e372-56bf-4d2f-bf8f-0e41e9989215",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29783cdc-9668-53ac-4146-e3eadead99c0",
      "attributeId": "e5b3a81b-2dd8-4237-9792-99dde3d846fb",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "58ef1b63-8f95-4994-1e53-83b7eb89b4fe",
      "attributeId": "59aa8497-8343-4a3e-9e58-08d0474ea25d",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "7484baa3-a364-76d7-63e3-8a9daa3f5e23",
      "attributeId": "0d5d3634-db52-47d2-b648-06aff68ef376",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe701f01-ff07-824a-9ab2-b21a4667e146",
      "attributeId": "bc72319c-27cd-4331-8aa4-d4d7440d4558",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b1ea41a7-4d9e-42af-8798-5df1a1742e55",
      "attributeId": "248da247-714b-4c8e-aabe-ae51b1a298d7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9b3fc79-8855-cfd1-ef83-b5d7665c6baf",
      "attributeId": "3e45f699-36e4-4ec2-b6d4-d79f08aa90d1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f92263b7-3937-a7f0-09cf-742e1f32328a",
      "attributeId": "bb235505-d84c-41c6-ae87-06603fabb6b0",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "d66da26d-3666-017f-8186-c6b6d814ca15",
      "attributeId": "29bfaf0b-7047-4e34-b148-fa040deaf052",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "2085efba-b81b-b6e2-6ff6-e691b7832e3f",
      "attributeId": "0a6ac3a9-3884-4171-a423-0b7f032ebbef",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "b7078366-a6b7-4618-bc98-8ce0387c03af",
      "attributeId": "cd7763ec-414c-4abd-a1d2-0046377e916e",
      "isEditable": true,
      "isLoadable": false
    },
    {
      "id": "14f54703-0bbb-b496-3fc3-fa6cdfa6b86f",
      "attributeId": "be830ce8-ca8b-41a5-993c-bcedbbe889a9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a13627f0-a868-26de-de41-23191869a002",
      "attributeId": "687ad667-bbbf-4584-9a38-0b48d0b4b92a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ff060bce-473f-cb62-a009-4bc9b8112cbe",
      "attributeId": "b8365e45-58cf-4618-91a0-4bc1f9c97870",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0da158e6-e2dc-f265-de4c-06c107ec644d",
      "attributeId": "98282783-cd5c-4945-af3b-262377a1caeb",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "fbeaf2c0-69a1-6298-cb5e-abb7430a963b",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "ca44aea3-ad0c-52f8-7fe4-37e8588c2c77",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f536ba98-4c6f-8504-54dc-02fe35365124",
          "attributeId": "4cdbf6f2-c84a-4a11-82ce-7173d40eecd1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f7cc16b-bc81-3825-9a23-9a2a714d8d02",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62e684e4-e47c-0c38-f461-c687f995c9e4",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f984f169-9167-bd8d-5476-0a0021cb01a6",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d6f28fa9-1c85-a87a-7a71-5dfab0fcbc71",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "e22fb78e-4e0a-2bf8-2c31-9f742d39ab47",
      "entityId": "953e74a5-a493-4d79-a4d9-0ad32b7e1896",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "StatusCollection",
      "dataMap": [
        {
          "id": "c9faad19-728c-f67d-708c-352975f48c51",
          "attributeId": "f31f1bc0-3a16-4699-84d4-b12a3ce6c66f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8e6e385c-b484-5fc5-5668-add48805a469",
          "attributeId": "41ecf684-71cd-4d13-9535-1941227f974d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3be75909-d67f-c307-7bcd-e077038b6bd6",
          "attributeId": "b0c96375-5319-4ea4-aec8-90bb88ece7cb",
          "parentId": "8e6e385c-b484-5fc5-5668-add48805a469",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "ceafde69-7498-063a-812b-c12bb8b77486",
          "attributeId": "293a7a59-6c38-4db2-b230-2c206e777614",
          "isEditable": true,
          "isLoadable": false
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0';

UPDATE [dwMetadata] SET
[Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.593', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-10 15:54:29.970', 
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
            "content": "{Name}",
            "size": "huge",
            "subheader": "Manage message history of this deployment"
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
                    "key": "container_3",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "breadcrumb_1",
                        "data-buildertype": "breadcrumb",
                        "items": [
                          {
                            "text": "Download Template",
                            "url": ""
                          }
                        ],
                        "events": {
                          "onItemClick": {
                            "active": true,
                            "actions": [
                              "downloadEmailTemplate"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-width": "100%",
                        "style-source": "padding-top: 20px;"
                      }
                    ],
                    "style-marginBottom": "20px",
                    "style-float": "left"
                  },
                  {
                    "key": "container_14",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
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
                        "other-visibleConition": ""
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
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "emailToStatus"
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
                        "key": "btnCancel_1",
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
            "content": "Create Scheduled Email For Status",
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
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "swzmodal_1",
            "data-buildertype": "swzmodal",
            "style-display": "none",
            "children": [
              {
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "msgMailMerge",
                        "data-buildertype": "checkbox",
                        "label": "Mail Merge",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "msgEmail",
                        "data-buildertype": "checkbox",
                        "label": "Email",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "msgProfile",
                        "data-buildertype": "checkbox",
                        "label": "Generate Profile",
                        "slider": true,
                        "toggle": true,
                        "style-marginRight": "20px",
                        "events": {
                          "onClick": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          },
                          "onChange": {
                            "active": false,
                            "actions": [],
                            "targets": [],
                            "parameters": []
                          }
                        }
                      },
                      {
                        "key": "breadcrumb_2",
                        "data-buildertype": "breadcrumb",
                        "items": [
                          {
                            "text": "Download Template",
                            "url": ""
                          }
                        ],
                        "events": {
                          "onItemClick": {
                            "active": true,
                            "actions": [
                              "downloadEmailTemplate"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "style-width": "100%",
                        "style-source": "padding-top: 20px;"
                      }
                    ],
                    "style-marginBottom": "20px",
                    "style-float": "left"
                  },
                  {
                    "key": "container_8",
                    "data-buildertype": "container",
                    "style-source": "clear: both;",
                    "children": [
                      {
                        "key": "msgStatus",
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
                        "other-visibleConition": "data.msgMailMerge||data.msgEmail||data.msgProfile"
                      }
                    ]
                  },
                  {
                    "key": "container_12",
                    "data-buildertype": "container",
                    "style-customcss": "",
                    "children": [
                      {
                        "key": "msgEmailFrom",
                        "data-buildertype": "input",
                        "label": "From",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "style-marginBottom": "20px",
                        "events": {},
                        "other-visibleConition": "data.msgEmail"
                      },
                      {
                        "key": "msgSubject",
                        "data-buildertype": "input",
                        "label": "Subject",
                        "fluid": true,
                        "onChangeTimeout": 200,
                        "style-marginBottom": "20px",
                        "other-visibleConition": "data.msgEmail"
                      }
                    ],
                    "style-source": "",
                    "style-marginTop": "20px",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "msgContent",
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
                    "other-visibleConition": "data.msgMailMerge||data.msgEmail"
                  },
                  {
                    "key": "container_16",
                    "data-buildertype": "container",
                    "children": [
                      {
                        "key": "button_1",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "msgToStatus"
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
                        "key": "btnCancel_2",
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
                              "swzmodal_1"
                            ],
                            "parameters": []
                          }
                        }
                      }
                    ],
                    "style-marginTop": "20px"
                  }
                ],
                "style-customcss": "ui message"
              }
            ],
            "content": "Create Message For Status",
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
        "style-marginTop": "20px"
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
            "key": "DplyStep",
            "name": "Step",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "name": "Mail Merge?",
            "key": "NotifyMerge",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "NotifyEmail",
            "name": "Email?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "NotifyGenerate",
            "name": "Generate Profile?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "SampleCount",
            "name": "Number of Samples",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": false,
            "type": "datetime"
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
        "rowHeight": "80",
        "pageSize": "80",
        "minHeight": "",
        "editForm": "",
        "events": {
          "onRowClick": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
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
        "key": "btn_ManageListSamples",
        "data-buildertype": "button",
        "content": "Manage List Samples",
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
                "value": "dplyListSample"
              }
            ]
          }
        }
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
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
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a';

UPDATE [dwMetadata] SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 10:01:11.580', 
[Data]=N'{
        downloadEmailTemplate: function(args){
                 var text = '''';
                text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
                text += ''Purpose of the Survey:\n''
                text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
                text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
                text +=''Submission of the Questionnaire:\n''
                text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
                text +='' \n''
                text +=''The following are your login information:\n''
                text +=''Company name: {Name}\n''
                text +=''Username: {UID}\n''
                text +=''Password: {Password}\n''
                text +='' \n''
                
                text +=''Other tokens:\n''
                text +=''UID: {UID}\n''
                text +=''Password: {Password}\n''
                text +=''Questionnaire Name: {DplyQnn}\n''
                text +=''List Name: {DplyList}\n''
                text +=''Deployment Name: {DplyName}\n''
                text +=''Category Name: {DplyCategory}\n''
                text +=''UIDPeer: {UIDPeer}\n''
                text +=''Account Active Status: {ActiveYN}\n''
                text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
                
                
                 var hiddenElement = document.createElement(''a'');
                    hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                    hiddenElement.target = ''_blank'';
                    hiddenElement.download = ''EmailTemplate.txt'';
                    hiddenElement.click();
    },
    init: function(args) {        
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: ''link-style''}, ''Yes'');
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                
                  model.columns[3].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyGenerate){
                        var url = "/deployment/downloadProfile/" + p.row.GenerateProfileOutputToken;
                        if(p.row.GenerateProfileDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Generating");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };              
            }
            return model;
        };    

        
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    emailToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        var dplyId = args.data.Id;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContent = args.component.refs.htmlEditor.state.htmlData;
        var msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        var subject = args.data.subject;
        var status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        let validated = true;
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
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
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        console.log(''msgContentJson : '',msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        
        var url = ''/deployment/emailtostatus'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    console.log("args:",args);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },
    
    msgToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
        
        var dplyId = args.data.Id;
        var mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        var email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        var profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        var emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        var subject = args.data.msgSubject;
        var status = args.data.msgStatus ? args.data.msgStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(!mailMerge && !email && !profile){
            $(''body'').loadingModal(''destroy'');
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        var msgContent = "";
        var msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.msgContent.state.htmlData;
            msgContentJson = args.component.refs.msgContent.state.jsonData;
        }
        
        if(email && (emailFrom==undefined || emailFrom==null || emailFrom.length==0)){
            alertify.error("Email address from is required");
            validated = false;
        } else if(email && !emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if((email || mailMerge || profile) && (status==undefined || status==null || status.length==0)){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''email'', email);    
        formData.append(''profile'', profile);       
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''status'', status);          
        
        var url = ''/deployment/messagetostatus'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    }

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

UPDATE [dwMetadata] SET
[Id]='4a9265ad-e634-425d-964c-6ba7325313c8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.550', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-10 15:54:29.997', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyMessages",
  "lastUpdate": "2021-08-10T15:54:29.995778+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "4eea8bf2-bc7c-f6e8-7876-94e848626146",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "94a1a8a7-ec79-e083-6d12-8c5b487b2fa2",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "23483e91-d133-f59b-07d4-56e3736ad830",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e692525-ebf2-26ca-f9fa-24fd75594796",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f8529e8-4447-b3eb-8fc4-27ad6d752b35",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c990e95a-2f07-44be-ddd7-a75596c2874f",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80b90421-f882-97cc-79f2-2e513de597d3",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eb69ab88-e705-d472-45a6-144b317956ab",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "25ff2f3a-0739-ec93-88be-21ba02a18d14",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "566dfb86-bc25-1d4c-736d-ba72a8b25c6a",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a5f413d-54a3-e1af-7dfb-7b60f07a5246",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "86bc9c77-d96c-a3db-d3b6-16b61abdc3a9",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "38d3f594-c1c5-45b5-7da0-c40251c8f047",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b20a602-3395-05d7-a690-c28be7d7671f",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4d065225-77c1-6eb9-a037-32e4a4b24428",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c9f3b5f0-daa2-97b4-7a91-e72f7cffcff2",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0944778b-0ec1-c561-6872-f88e0dbb62f4",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ba4b3b6b-b282-738b-80d8-f63524e4b294",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "998cac2f-ddd2-61b1-4d6a-0cce55f790fb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5e339ef-8d58-44f3-e36f-2b4658079115",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fd691de8-ad3c-c601-c4f2-3ea528679f36",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0c382b47-6727-0456-4b40-0572c7dc5ba8",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab5d23f2-b4d7-e289-61f1-211a31b285ef",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f5ebf44-8b4f-73a4-3347-36396f10003e",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "64a8aadd-4f40-fd3d-c155-4923df865059",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d7b147af-017c-77ff-30da-c0024133097e",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6d244d89-0282-8d31-302b-b47cedc095aa",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fe53995a-9a5d-c653-91ae-88cecd0891a3",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bf9371ee-0b24-8dbd-16f1-882d609037a9",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f0e74be8-84f5-03d6-9c40-55aaa728a8ae",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f5cc0405-146e-4045-9677-2c7e80413018",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d94c4bd0-1bda-b112-a603-b715002d7fb0",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c087eea7-56b5-d6b4-c47b-3b55bd050008",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48f9defe-6f27-6ec1-f5f4-cb4b70313d9d",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b5e4a23d-61d1-e8cf-19c9-76e79376d7cd",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb4ebf5d-26bc-66e5-b7f6-ceae6874a9a2",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf904ce9-4510-112f-41fc-f6b25a0ac5c1",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9e5d2752-b33f-4738-56a1-fd0c753bacf9",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05d30da8-b070-962b-02d8-9e12b8626203",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7994af87-3fbe-cdd2-f61f-f9b960b6b08d",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a6c4fba3-a180-4a34-9f51-804c4481ff40",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "129f6d05-4d05-168c-ef1b-25bf47166088",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5436e34f-2a03-0cbf-4150-4dd479f142c6",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d192629-7319-8c4c-c28d-e24010aff510",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ddd4a7bd-1f01-8dbc-d6f0-194e2fee3a96",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e87f1b8-350a-e164-4be7-a5b5929e3aae",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77bf0020-8d39-b02d-7081-57b0f0c0efd9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "431f4999-2e39-1693-9125-dd212f2d610f",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "87b9d548-6502-1194-0102-eb5e70d0e7de",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e852ef59-2edb-6fb3-e90f-2a60e6bd64f7",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "7aa61911-5cad-4e47-1584-77a399729529",
      "entityId": "59aff502-0923-4c44-a333-fe09727419f2",
      "filter": "FilterByModelId",
      "parameter": "{DplyId: \"@Id\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "285a25a7-457d-9012-e148-812872f7f345",
          "attributeId": "75fe9558-ad13-4155-adfd-278726de0afe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d31f92a-155e-3263-c253-6b9deefae68e",
          "attributeId": "46d6816a-9736-4f40-808a-6bb0529b12c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b958e738-8730-746d-5670-dbd8f3a43c73",
          "attributeId": "e7df3305-b885-4b9f-bfd9-bc5800d2b3af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "00831898-d09a-51f0-68ef-539d2db6d01e",
          "attributeId": "d6e51f9b-36b7-4c4a-8713-94bafddffc4b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0e7e4be7-e73c-5838-4732-86444c38469b",
          "attributeId": "2c37782f-dcf0-4386-9c48-b1885c9ec96f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bbd53d9a-8b4a-ce4c-2c9e-f1401f9d8aaf",
          "attributeId": "188f0942-ea3d-4400-8ad2-8efe1fc68d8a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "88dac03c-75dc-f65c-f412-e2fca82378bf",
          "attributeId": "3b27eb5c-9959-4243-b9da-9155a90d8a85",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d653ede4-3206-d935-3940-74ca9b35d8d3",
          "attributeId": "82a1ea3e-7db2-4673-92cf-eca1c47db3c4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aa7affcf-8be7-be1a-2dea-b566f7ed2b13",
          "attributeId": "1b50815e-6bdb-4c8c-bbe1-b40e336409c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "becb0731-4e23-e255-4a4c-d40b3bec3769",
          "attributeId": "f17fa3f1-c23d-4a90-8685-be98234f9293",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a196eb5a-94df-5f9c-fac5-56c9c4cc7065",
          "attributeId": "93f82dd7-2705-42b3-bf1a-f9d62cc57663",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "18a2abe1-7b04-d3df-82e5-6aae2d98ff37",
          "attributeId": "4c89a233-907b-4a71-accc-995d9b9c8a76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "955b4502-cf1b-300b-06ef-57fa546c30ca",
          "attributeId": "491795d5-46e8-4247-975c-4c6419243b8f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "555a34a3-0ead-0a7c-1b70-a083fb003ab0",
          "attributeId": "1900ec19-9dac-4596-aa2a-ce82e9cfc493",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a191533f-269c-1b89-c2b2-3b7b90b6deeb",
          "attributeId": "a21d3068-cb0f-41ef-881c-25b6aca9b598",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36c74caf-0cf3-5392-d56b-0edd3d0ad91f",
          "attributeId": "534741ae-056b-4e92-97cf-5c97cf0e51c1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78e5a14a-bd95-a442-bf99-a8a118b8c69e",
          "attributeId": "18b42ed0-2227-4819-9b4f-38b1eca723be",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "48b97909-8a82-599c-35f5-6f19db39820f",
          "attributeId": "2cbedcd3-922c-4071-9f7a-c6baab5a6007",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6ac14fc5-7526-ccec-d21b-63b1c23a63b3",
          "attributeId": "df0b7d03-a12e-4c21-8148-cb0d6bfc163c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d75a6f43-73e1-7c3e-adab-3511fc06bf19",
          "attributeId": "475d3632-b629-4d78-8935-e19451cc5cd0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "41ac7538-f4ec-9965-9973-9e6f2750bed8",
          "attributeId": "b49c8574-e461-4400-8df5-68b08cf6cb3f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fd58cb00-a6ef-8621-0806-65c27c32379d",
          "attributeId": "568d1b2d-ba87-4cb1-b7f1-ad30dd23982e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f128f3a4-343e-9fb5-a0d0-c12d4a66440f",
          "attributeId": "019de426-2ba0-4e03-88af-6d32a6b16a40",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bb1f93ae-5190-83af-f71e-3a0e8c1deab2",
          "attributeId": "8014719b-0387-4367-9581-b3fbe54acb76",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4dccfa04-2541-88e9-f46e-0d4b81c5a9d0",
          "attributeId": "12da9e1a-c2f6-4e0e-bbba-dd98e38d72c2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "303c8966-b0b0-25fd-4166-04d4d4343c86",
          "attributeId": "ad82bb50-5d29-4c85-b93d-4ce2c219ddf5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "48d58510-dc34-3508-71b5-b703536a13fe",
          "attributeId": "ef45d376-b59e-464c-b997-c482a6edb593",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8077076c-19a6-be9b-bf57-e85cc79769a0",
          "attributeId": "bdd83ae4-2227-4f66-a1ed-4468407223ce",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b898fcfe-616f-ed9c-caeb-d17918c3c2cf",
          "attributeId": "11c9a997-e065-49b0-8b0b-3db8a55e36a5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8b33c0d-aaa7-bcb9-95c8-076ef6eca977",
          "attributeId": "0a863bd9-dd72-4a35-94aa-0aa81d0a3f32",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='4a9265ad-e634-425d-964c-6ba7325313c8';

UPDATE [dwMetadata] SET
[Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.460', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 11:06:43.397', 
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
        "content": "<h5 class=\"ui header\">Email Subject: </h5><p>{EmailSubj}</p>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5>{MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>{EmailFrom}<p/>\n\n",
        "isHtml": true
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
            "content": "<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">This scheduled job is cancel</h5><p/>",
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
                    "key": "button_2",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "editEmailToStatus"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btnCancel_1",
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
        "content": "Cancel Job",
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
        "content": "Cancel",
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
[Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:13:14.040', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 14:56:14.930', 
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
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
       
        return ()=> {
            var url = ''/globalmailer/canceljob'' 
            var formData = new FormData();
            formData.append(''globalMsgId'', args.data.Id);
            
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    $(''body'').loadingModal(''destroy'');
                    if (response.success) {
                        alertify.success(response.message);
                         const hideControls = [ "cancelJob", "swzmodal_2"];
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: hideControls
                                        }
                                    }
                                },
                            }
                        });    
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);
                });
       }
    },
    editEmailToStatus: function(args){
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

        Pace.start();

        var globalMsgId = args.data.Id;
        var organization = args.data.organization;
        var target = args.data.target;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        var msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        var subject = args.data.emailSubj;
        var status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
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
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
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

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''globalMsgId'', globalMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        loadingStart();
        var url = ''/globalmailer/editemailtostatus'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/SwzGlobalMailerMessage/" + encodeURIComponent(globalMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);
            })
            .finally(()=>{
                Pace.stop();
            });   
        
    },
    downloadEmailTemplate: function(args){
         var text = '''';
        text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
        text += ''Purpose of the Survey:\n''
        text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
        text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
        text +=''Submission of the Questionnaire:\n''
        text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
        text +='' \n''
        text +=''The following are your login information:\n''
        text +=''Company name: {Name}\n''
        text +=''Username: {UID}\n''
        text +=''Password: {Password}\n''
        text +='' \n''
        
        text +=''Other tokens:\n''
        text +=''UID: {UID}\n''
        text +=''Password: {Password}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
        
        
         var hiddenElement = document.createElement(''a'');
            hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
            hiddenElement.target = ''_blank'';
            hiddenElement.download = ''EmailTemplate.txt'';
            hiddenElement.click();
    },
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    onEditClick: function (args) {
        console.log("args :", args);
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    CloverApp.API.setDataField("dictionaryStatus",entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("organization",args.data.StructDivisionId);
        CloverApp.API.setDataField("target",args.data.IsTargetUsers ? "intranetUsers" : "activeSamples" );
        return { app:{} }
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

UPDATE [dwMetadata] SET
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 11:33:30.443', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2021-08-27T11:33:30.4220167+08:00",
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
      "readOnly": false
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
      "readOnly": false
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
      "readOnly": false
    }
  ]
}' WHERE [Id]='95150f4a-b078-48ac-a2a5-a12da83bf571';

UPDATE [dwMetadata] SET
[Id]='7920415b-36c7-4270-99de-fcd7abca91a7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 11:06:41.330', 
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
                        "key": "button_2",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "emailToStatus"
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
            "name": "Scheduled On",
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
            "name": "Number of Samples",
            "sortable": true,
            "filterable": false,
            "resizable": false
          },
          {
            "key": "JobIsCanceled",
            "name": "Cancel",
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
[Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:24:14.453', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 10:49:33.547', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    emailToStatus: function(args){
        console.log("resend args", args);
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});

        var organization = args.data.organization;
        var target = args.data.target;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContent = args.component.refs.htmlEditor.state.htmlData;
        var msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        var subject = args.data.subject;
        var status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
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
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
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
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''status'', status);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);
        var url = ''/globalmailer/emailtostatus'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                if (response.success) {
                    args.component.refs.swzmodal_2.close();
                    alertify.success(response.message);
                    args.controlRef.refresh();

                } else {
                    alertify.error(response.message);
                }

            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });   
        
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
}' WHERE [Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d';

UPDATE [dwMetadata] SET
[Id]='bd23d168-027b-4827-b17a-7617b4a12378', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:09:41.813', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-27 11:06:41.347', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailer",
  "lastUpdate": "2021-08-27T11:06:41.3449664+08:00",
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
      "readOnly": false
    }
  ]
}' WHERE [Id]='bd23d168-027b-4827-b17a-7617b4a12378';

