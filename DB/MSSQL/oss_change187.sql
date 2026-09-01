-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyMessage-code.js
-- SwzGlobalMailerMessage.json
-- SwzGlobalMailerMessage-settings.json
-- SwzGlobalMailerMessage-code.js

UPDATE [dwMetadata] SET
[Id]='87ead053-54cb-4735-8cbc-e812f3344ab3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 12:29:26.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-22 22:45:31.053', 
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
        var statuslist = [];
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("dictionaryStatus",statuslist);
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
[Id]='516dfbb2-0dd2-4093-813a-3e2a2a6802bf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.460', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-23 12:18:12.010', 
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
[Id]='95150f4a-b078-48ac-a2a5-a12da83bf571', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:05:49.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-23 12:18:12.033', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "SwzGlobalMailerMessage",
  "lastUpdate": "2021-09-23T12:18:12.0329229+08:00",
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
[Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:13:14.040', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-23 15:07:44.560', 
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
        var status = args.data.dictionaryStatus ? target=="intranetUsers" ? "" :  args.data.dictionaryStatus : "";
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

