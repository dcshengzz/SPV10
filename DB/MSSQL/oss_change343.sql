-- Will UPDATE existing row(s) in dwMetadata for the following:
-- dplyListSample-code.js
-- dplyMessage.json
-- dplyMessage-settings.json
-- dplyMessage-code.js
-- dplyMessages.json
-- dplyMessages-settings.json
-- dplyMessages-code.js
-- QNN_DPLY.json
-- QNN_DPLY-settings.json
-- QNN_DPLY-code.js

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-14 12:56:46.850', 
[Data]=N'{
    addNewSample: function(args){
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        Utils.loadingStart("Updating deployment samples from list");
        Utils.postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of addNewSample
    
    closeModal: function(args) {
        args.controlRef.close(); //expects modal as event target    
    },
    
    onOpenManageDueDate: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalDueDate = args.component.refs.modalDueDate;
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    changeDueDate: function(args){
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='''') {
            alertify.error("Please select the due date");
            return {};
        }else if(Date.parse(dueDate) <= Date.parse(args.data.DateStart)){
            alertify.error("Due Date must be after Deployment Start Date (" + CloverApp.API.formatDatetime(args.data.DateStart, window.CloverLang.common.datetimeFormat) + ")");
            return {};
        }
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        Utils.loadingStart("Updating Due Dates");
        Utils.postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success(result.message);
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of changeDueDate

    onOpenSendMessage: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        if(noSamplesSelectedInGrid){
            modalSendMessage.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    //previously named sendMessage
    profileMailMergeToSamples: function(args){
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
 
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        var msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        }
        const subject = args.data.subject;

        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );

        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToSamples", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success(result.message);
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }
        
        const sampleIds = gridListSamples.state.selectedIndexes.map( gridIndex => gridListSamples.state.items[gridIndex].SampleId);
        const formData = new FormData();
        formData.append("sampleIds", sampleIds);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error(reason);
            }
        ).then(Utils.loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);

        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }        

        const sampleIds = gridListSamples.state.selectedIndexes
            .map( gridIndex => gridListSamples.state.items[gridIndex]) //extract selected grid items
            .map( item => { return { sampleId: item.SampleId, sampleInfoId: item.Id } } ); //extract objects with desired ids

        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

UPDATE [dwMetadata] SET
[Id]='057eacaf-f332-4646-aa05-4e3d5656246a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:47.203', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:30:05.260', 
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
        "content": "<h5 class=\"ui header\">Email Subject: </h5> {EmailSubj}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email Template: </h5> {MsgContent}<p/>\n<div class=\"ui divider\"></div>\n<h5 class=\"ui header\">Email From: </h5>\n\n",
        "isHtml": true
      },
      {
        "key": "staticcontent_EmailFrom",
        "data-buildertype": "staticcontent",
        "content": "{EmailFrom}",
        "isHtml": false,
        "other-visibleConition": "(data.EmailFrom != null && data.EmailFrom != \"\")"
      },
      {
        "key": "staticcontent_EmailFromDefault",
        "data-buildertype": "staticcontent",
        "content": "<i>(Default Sender)</i>",
        "isHtml": true,
        "other-visibleConition": "(data.EmailFrom == null || data.EmailFrom == \"\")"
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
          },
          {
            "key": "SampleCollection",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Id",
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
                "key": "container_6",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "staticcontent_4",
                    "data-buildertype": "staticcontent",
                    "content": "<i>(Changes to the email message text and schedule will also be applied to Mail Merge generation)</i>",
                    "isHtml": true
                  }
                ],
                "other-visibleConition": "(data.NotifyMerge!=null&&data.NotifyMerge==1)",
                "style-source": "clear: both;\nborder: 1px solid red;\npadding: 25px;",
                "style-marginBottom": "20px"
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
                    "other-visibleConition": "data.StatusCollection.length > 0",
                    "other-required": false
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
                    "key": "button_SubmitMessage",
                    "data-buildertype": "button",
                    "content": "Submit",
                    "secondary": false,
                    "inverted": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "updateProfileMailMerge"
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
[Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 06:48:48.240', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:30:05.290', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "dplyMessage",
  "lastUpdate": "2022-09-15T03:30:05.2881316+08:00",
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
      "isLoadable": true
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
        },
        {
          "id": "5203a0ea-f30f-4ad7-7d9e-15d441e63e6a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
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
      "readOnly": false,
      "totalCountPropertyName": "__StatusCollection_totalcount"
    },
    {
      "id": "c5794574-42a8-e0a7-7367-0b179084d7f9",
      "entityId": "4fe46821-6c3a-4ca1-ad29-b94cbb50d673",
      "filter": "FilterByModelId",
      "parameter": "{DplyMsgId: \"@Id\"}",
      "control": "SampleCollection",
      "dataMap": [
        {
          "id": "ddf9c8a0-b505-92ec-0c2d-efd55ce3e561",
          "attributeId": "43a91c1e-e62d-4db1-84d2-7cdaecb3e433",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "83753949-9ad2-caa5-8e25-273013642da6",
          "attributeId": "4cdbf6f2-c84a-4a11-82ce-7173d40eecd1",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b657c9f3-8076-bcb4-a501-0cac9db7cb14",
          "attributeId": "0f786ff4-518b-4e1f-a633-b0324a3b07c2",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "1a0df557-fb7f-a905-e0d5-65f9c7e62ae6",
          "attributeId": "feb2700a-4a5c-4665-9f30-da84e6936ea7",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "4bfd4143-4ef1-1b4a-b877-8056a8e90ab7",
          "attributeId": "205909c8-d7c3-4885-a04a-ffb5f7ba0fe8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "0936701e-4d83-bd91-ecf6-3212a4ddc11d",
          "attributeId": "a696f4e0-7052-4ee2-b2a1-db50544c077d",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "388a4722-ab91-3be5-5b24-3b9df981ae2a",
          "attributeId": "4b0da83f-860f-48c9-a837-bbd68b4b6f5f",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__SampleCollection_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='e3d5be20-1431-42b3-8eb7-9614d478c7f0';

UPDATE [dwMetadata] SET
[Id]='87ead053-54cb-4735-8cbc-e812f3344ab3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 12:29:26.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:45:28.467', 
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
        Utils.loadingStart();
        const formData = new FormData();
        formData.append(''dplyMsgId'', args.data.Id);
        Utils.postFormRequest("/deployment/canceljob",formData).then(
            response => {
                alertify.success(response.message);
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                console.log("Cancel jib failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
       return{};
    },
    
    //renamed from editEmailToStatus
    updateProfileMailMerge: function(args){
        const dplyMsgId = args.data.Id;
        const dplyId = args.data.DplyId;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const listSampleIds = args.data.targetSamples ? args.data.targetSamples : "";
        
        let validated = true;
        
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

        if(status.length==0 && listSampleIds.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        
        let url = "";
        if(status.length !== 0 && listSampleIds.length ==0){
            url = "/deployment/profileMailMergeToStatus";
            formData.append(''status'', status);
        } 
        if(listSampleIds.length !== 0 && status.length ==0){
            url = "/deployment/profileMailMergeToSamples";
            formData.append(''listSampleIds'',listSampleIds);
            formData.append(''mailMerge'', args.data.NotifyMerge);
            formData.append(''email'', args.data.NotifyEmail);
            formData.append(''profile'', args.data.NotifyGenerate);
        }

        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''dplyMsgId'', dplyMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);  
        
        if(validated){
            Utils.loadingStart();
            Utils.postFormRequest(url,formData).then(
                response => {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/dplyMessage/" + encodeURIComponent(dplyMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
                    alertify.success(response.message);
                }, reason => {
                    console.error(reason);
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        }

        return {};
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        var samplelist = [];
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
            CloverApp.API.setDataField("dictionaryStatus",statuslist);
        }
        if(args.data.SampleCollection.length > 0){
            args.data.SampleCollection.forEach(
                (entry) => {
                    samplelist.push(entry.ListSampleId);
                });
            CloverApp.API.setDataField("targetSamples",samplelist);
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
[Id]='fda03fad-1ea3-45a7-96c2-3c23fb76ad5a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.593', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:11:14.147', 
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
                        "key": "button_ProfileMailMergeToStatus_Scheduled",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "profileMailMergeToStatus"
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
                        "key": "button_ProfileMailMergeToStatus_Immediate",
                        "data-buildertype": "button",
                        "content": "Submit",
                        "secondary": false,
                        "inverted": false,
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "profileMailMergeToStatusImmediate"
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
      },
      {
        "key": "container_17",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnRefresh",
            "data-buildertype": "button",
            "content": "Refresh",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridRefresh"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "secondary": true
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
            "resizable": true
          },
          {
            "name": "Mail Merge?",
            "key": "NotifyMerge",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "NotifyEmail",
            "name": "Email?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "NotifyGenerate",
            "name": "Generate Profile?",
            "type": "custom",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "SampleCount",
            "name": "Samples",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "CreatedDate",
            "name": "Created On",
            "sortable": true,
            "filterable": false,
            "resizable": true,
            "type": "datetime"
          },
          {
            "key": "UserName",
            "name": "Created By",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "ScheduledDate",
            "name": "Scheduled For",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
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
[Id]='4a9265ad-e634-425d-964c-6ba7325313c8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.550', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:11:14.180', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplyMessages",
  "lastUpdate": "2022-09-15T03:11:14.1792753+08:00",
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
      "readOnly": false,
      "totalCountPropertyName": "__grid_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='4a9265ad-e634-425d-964c-6ba7325313c8';

UPDATE [dwMetadata] SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-15 03:12:00.240', 
[Data]=N'{
    init: function(args) {        
        const innerArgs = args;
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
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
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                };              
            }
            return model;
        }; //end of gridModelRewriter
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);   
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    //renamed from emailToStatus
    profileMailMergeToStatus: function(args){

        const dplyId = args.data.Id;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent = args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
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
            return {};
        }

        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);          
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatus",formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success(response.message);
                console.log("args:",args);
                args.controlRef.refresh();
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    //renamed from msgToStatus
    profileMailMergeToStatusImmediate: function(args){

        const dplyId = args.data.Id;
        const mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        const email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        const profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        const emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        const subject = args.data.msgSubject;
        const status = args.data.msgStatus ? args.data.msgStatus : "";
        
        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.msgContent.state.htmlData;
            msgContentJson = args.component.refs.msgContent.state.jsonData;
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
            return {};
        }
        
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''email'', email);    
        formData.append(''profile'', profile);       
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''status'', status);          
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatusImmediate", formData).then(
            response => {
                args.component.refs.swzmodal_1.close();
                alertify.success(response.message);
                args.controlRef.refresh();
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    }

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

UPDATE [dwMetadata] SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-13 09:00:30.460', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cntDeploymentTitle",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left",
            "subheader": ""
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_23",
        "data-buildertype": "container",
        "children": [
          {
            "key": "workflowbar_1",
            "data-buildertype": "workflowbar",
            "events": {
              "onCommandClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowExecuteCommand",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              },
              "onSetStateClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowSetState",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "blockSetState": true,
            "other-visibleConition": ""
          },
          {
            "key": "container_21",
            "data-buildertype": "container",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<strong>State:</strong> {StateName}",
                "isHtml": true
              }
            ]
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "Remarks",
                "data-buildertype": "textarea",
                "label": "",
                "fluid": true,
                "style-width": "",
                "reference": "Remarks",
                "events": {},
                "placeholder": "Please append your remarks",
                "style-customcss": "ui fluid input",
                "other-required": false
              }
            ]
          },
          {
            "key": "formgroup_9",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": []
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "other-visibleConition": "data.Id && data.EnableWorkflow"
      },
      {
        "key": "formgroup_10",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "container_22",
            "data-buildertype": "container",
            "style-float": "right",
            "children": [
              {
                "key": "cntImportModal",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "importModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "float: right;",
                    "secondary": true,
                    "content": "Import Response",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "importModalForm",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "header_3",
                            "data-buildertype": "header",
                            "content": "Import Response",
                            "size": "medium",
                            "events": {},
                            "other-visibleConition": ""
                          },
                          {
                            "key": "listFile",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "file",
                            "style-marginTop": "10px"
                          },
                          {
                            "key": "totalRows",
                            "data-buildertype": "header",
                            "content": "Total rows: {totalRows}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                          },
                          {
                            "key": "totalSampleResponseAdded",
                            "data-buildertype": "header",
                            "content": "Rows added: {totalSampleResponseAdded}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                          },
                          {
                            "key": "totalSampleNoResponse",
                            "data-buildertype": "header",
                            "content": "Rows not added (No response): {totalSampleNoResponse}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidUIDs",
                            "data-buildertype": "header",
                            "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidQnnColumns",
                            "data-buildertype": "header",
                            "content": "Total invalid columns: {totalInvalidQnnColumns}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                          },
                          {
                            "key": "moreModal",
                            "data-buildertype": "swzmodal",
                            "style-source": "",
                            "secondary": true,
                            "content": "More information",
                            "style-display": "none",
                            "children": [
                              {
                                "key": "invalidQnnColumnsForm",
                                "data-buildertype": "form",
                                "children": [
                                  {
                                    "key": "innerInvalidQnnColumnsForm",
                                    "data-buildertype": "form",
                                    "children": [
                                      {
                                        "key": "cntInvalidQnnColumns",
                                        "data-buildertype": "container",
                                        "style-float": "right",
                                        "children": [
                                          {
                                            "key": "invalidQnnColumns",
                                            "data-buildertype": "header",
                                            "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_1",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidColumns"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "invalidUIDs",
                                            "data-buildertype": "header",
                                            "content": "Invalid rows (UID): {totalInvalidRows}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_2",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidUIDs"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "totalInvalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                            "style-hidden": true
                                          },
                                          {
                                            "key": "invalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_3",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidDates"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "button_1",
                                            "data-buildertype": "button",
                                            "content": "Cancel",
                                            "style-customcss": "",
                                            "primary": false,
                                            "events-onClick": true,
                                            "events-onClick-actions": [
                                              "gridAdd"
                                            ],
                                            "events": {
                                              "onClick": {
                                                "active": true,
                                                "actions": [
                                                  "closeMoreModal"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "",
                                            "style-source": "float: right;",
                                            "inverted": false,
                                            "secondary": true
                                          }
                                        ],
                                        "style-marginRight": "",
                                        "style-width": "100%",
                                        "style-marginBottom": "",
                                        "style-source": ""
                                      }
                                    ],
                                    "style-source": "overflow-y: auto;\noverflow-x: auto;"
                                  }
                                ],
                                "style-source": "overflow-y: auto;\noverflow-x: auto;"
                              }
                            ],
                            "size": "",
                            "events": {
                              "onClick": {
                                "active": false,
                                "actions": [],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "other-customValidation": "",
                            "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                          },
                          {
                            "key": "container_17",
                            "data-buildertype": "container"
                          },
                          {
                            "key": "formgroup_7",
                            "data-buildertype": "formgroup",
                            "widths": "equal"
                          },
                          {
                            "key": "cntImportDialogButtons",
                            "data-buildertype": "container",
                            "style-float": "right",
                            "children": [
                              {
                                "key": "btnImportCancel",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "style-customcss": "",
                                "primary": false,
                                "events-onClick": true,
                                "events-onClick-actions": [
                                  "gridAdd"
                                ],
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
                                "other-visibleConition": "",
                                "style-source": "float: right;",
                                "inverted": false,
                                "secondary": true
                              },
                              {
                                "key": "btnImportSave",
                                "data-buildertype": "button",
                                "content": "Save",
                                "style-customcss": "",
                                "primary": true,
                                "events-onClick": true,
                                "events-onClick-actions": [
                                  "gridAdd"
                                ],
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;"
                              }
                            ],
                            "style-marginRight": "",
                            "style-width": "100%",
                            "style-marginBottom": "10px"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                    "style-marginLeft": ""
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "other-visibleConition": ""
              },
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageMessageHistory",
                    "data-buildertype": "button",
                    "content": "Manage Message History",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                            "value": "dplyMessages"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "buttonManageListSamples",
                    "data-buildertype": "button",
                    "content": "Manage List Samples",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                    },
                    "floated": "right",
                    "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)"
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "style-marginRight": "3.5px"
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageDataEditors",
                    "data-buildertype": "button",
                    "content": "Manage Data Editors",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplySampleOwner"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "floated": "right"
                  },
                  {
                    "key": "buttonManagePrePopulate",
                    "data-buildertype": "button",
                    "content": "Pre-Populate Response",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "QNN_DPLY_PRE_POPULATE"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'')",
                    "floated": "right"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Manage Validation Data",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                            "value": "dplyValidation"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "btnManageRecurringDeployments",
                    "data-buildertype": "button",
                    "content": "Manage Recurring Deployments",
                    "secondary": true,
                    "floated": "right",
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
                            "value": "dplyRecurrence"
                          }
                        ]
                      }
                    },
                    "other-visibleConition": "data.Id!=null"
                  }
                ],
                "style-float": "right",
                "style-width": "100%",
                "style-marginTop": "15px"
              }
            ]
          }
        ]
      }
    ],
    "style-width": "100%",
    "style-float": "right"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-width": "100%",
    "style-source": "clear: both;",
    "style-marginTop": "",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntMainContainer",
    "data-buildertype": "container",
    "children": [
      {
        "key": "MainForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "cntBasicProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerBasicProperties",
                "data-buildertype": "header",
                "content": "Basic Properties",
                "size": "medium"
              },
              {
                "key": "formgroup_BasicPropertiesMain",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "textName",
                    "data-buildertype": "input",
                    "label": "Deployment Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Deployment Name",
                    "other-visibleConition": ""
                  },
                  {
                    "key": "SurveyName",
                    "data-buildertype": "input",
                    "label": "Displayed Survey Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Survey Name"
                  },
                  {
                    "key": "Description",
                    "data-buildertype": "textarea",
                    "label": "Description",
                    "fluid": true
                  },
                  {
                    "key": "dictCategory",
                    "data-buildertype": "dictionary",
                    "label": "Category",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_CATEGORY",
                    "placeholder": "Select category...",
                    "columns": "Name ASC",
                    "search": true,
                    "other-required": false,
                    "other-readOnlyConition": "",
                    "clearable": true,
                    "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
                  },
                  {
                    "key": "dictQuestionnaire",
                    "data-buildertype": "dictionary",
                    "label": "Form Properties (Questionnaire) ~",
                    "fluid": true,
                    "selection": true,
                    "search": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "dropdownQuestionnaireOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "onChangeTimeout": "",
                    "dataModel": "QNN_QNN",
                    "columns": "Title ASC",
                    "placeholder": "Select a form properties...",
                    "other-required": true,
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "reference": "Form Properties"
                  },
                  {
                    "key": "dictList",
                    "data-buildertype": "dictionary",
                    "label": "Sample List ~",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_LIST",
                    "columns": "Name ASC",
                    "search": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "validateSampleList"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "placeholder": "Select a sample list...",
                    "other-required": true,
                    "style-source": "",
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "other-visibleConition": "",
                    "reference": "Sample List"
                  },
                  {
                    "key": "textApiIdentifier",
                    "data-buildertype": "input",
                    "label": "Api Identifier",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": false,
                    "events": {},
                    "reference": "Api Identifier",
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "events": {},
                "style-source": "clear:both;"
              }
            ],
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "cntResponseProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerResponseProperties",
                "data-buildertype": "header",
                "content": "Response Properties",
                "size": "medium"
              },
              {
                "key": "formGroupStartEndDate",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "DateStart",
                    "data-buildertype": "input",
                    "label": "Start On",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime",
                    "style-width": "100%",
                    "events": {},
                    "style-source": "z-index: 1000;",
                    "style-marginLeft": "32px",
                    "other-readOnlyConition": "",
                    "other-required": true
                  },
                  {
                    "key": "DateEnd",
                    "data-buildertype": "input",
                    "label": "End On",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime",
                    "other-readOnlyConition": "",
                    "other-required": true,
                    "style-source": "z-index: 1000;"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_5",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "VisibleToRespondent",
                    "data-buildertype": "checkbox",
                    "label": "Visible to Respondent",
                    "defaultValue": "True",
                    "toggle": false,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "slider": false,
                    "fitted": false
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "custom",
                "widthsCustom": "2",
                "children": [
                  {
                    "key": "MaxResponse",
                    "data-buildertype": "input",
                    "label": "Maximum Number of Respondents (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "events": {},
                    "defaultValue": "-1",
                    "style-width": "10em",
                    "reference": "Maximum Number of Respondents"
                  },
                  {
                    "key": "DaysUpdate",
                    "data-buildertype": "input",
                    "label": "Days for Update after Submission (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "defaultValue": "0",
                    "events": {},
                    "style-width": "10em",
                    "reference": "Days for Update",
                    "other-readOnlyConition": ""
                  }
                ],
                "orientation": "inline"
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "fg_RecurrenceInfo",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "This is a recurring deployment."
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Next Deployment Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": false,
                "readOnly": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3",
            "orientation": "grouped",
            "other-visibleConition": "data.RecurrenceEnabled"
          },
          {
            "key": "cntSurveyFeatures",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_6",
                "data-buildertype": "header",
                "content": "Survey Features",
                "size": "medium"
              },
              {
                "key": "formgroup_IsExcelEnabled",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsExcelEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Online Excel Support",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_RequireAccessCode",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "RequireAccessCode",
                    "data-buildertype": "checkbox",
                    "label": "Require Delegation Access Code",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_EnableWorkflow",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "EnableWorkflow",
                    "data-buildertype": "checkbox",
                    "label": "Use Workflow ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setDplyState",
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id",
                    "reference": "Enable Workflow"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_IsMultipleResponse",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsMultipleResponse",
                    "data-buildertype": "checkbox",
                    "label": "Allow Multiple Responses ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id || Utils.isSelected(data.IsAnonymous)"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "other-readOnlyConition": "Utils.isSelected(data.IsAnonymous)"
              },
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Anonymous Survey ~",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleAnonymousSurvey",
                      "updateFeatureInteraction",
                      "validateSampleList"
                    ],
                    "targets": [
                      "textCompleteURL"
                    ],
                    "parameters": []
                  }
                },
                "other-required": false,
                "style-width": "50%",
                "other-readOnlyConition": "data.Id"
              },
              {
                "key": "fgCompletionUrl",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "formgroup_IsAnonymous",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "events": {},
                    "children": [],
                    "style-width": "",
                    "widthsCustom": "3"
                  },
                  {
                    "key": "anonymousSurveyLink",
                    "data-buildertype": "staticcontent",
                    "content": "",
                    "isHtml": true,
                    "isPre": true,
                    "fetchData": true
                  },
                  {
                    "key": "textCompleteURL",
                    "data-buildertype": "input",
                    "label": "Completion URL (required for Anonymous surveys)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "placeholder": "http://",
                    "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                    "events": {},
                    "style-marginLeft": "",
                    "other-customValidation": "!(data.IsAnonymous== ''1''  && !value)? true : '' - Please provide completion URL for anonymous survey''",
                    "style-width": "",
                    "reference": "Completion URL"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "orientation": "grouped"
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "<i>(Above options marked with <strong>~</strong> may only be selected before creating the deployment and cannot be enabled later)</i>",
                "isHtml": true
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL-3",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "cntRestrictionProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Restriction Properties",
                "size": "medium",
                "style-marginTop": "",
                "style-marginBottom": ""
              },
              {
                "key": "RestrictIp",
                "data-buildertype": "checkbox",
                "label": "IP Restriction",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setIpRestriction"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "reference": "Ip Restriction",
                "style-marginBottom": "20px",
                "defaultValue": "0"
              },
              {
                "key": "RestrictIpInclusive",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Inclusive",
                    "value": "1"
                  },
                  {
                    "value": "0",
                    "text": "Exclusive"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "countryOrIpRange",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Countries",
                    "value": "1"
                  },
                  {
                    "text": "IP Ranges",
                    "value": "0"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "clearContent"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "IpCountry",
                "data-buildertype": "dropdown",
                "label": "IpCountry",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "SG",
                    "text": "Singapore"
                  },
                  {
                    "value": "MY",
                    "text": "Malaysia"
                  }
                ],
                "multiple": true,
                "reference": "Respondent Country",
                "placeholder": "Select countries",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
                "events": {}
              },
              {
                "key": "IpRange",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": true,
                "selection": true,
                "data-elements": [],
                "multiple": true,
                "search": true,
                "allowAddItems": true,
                "reference": "Ip Ranges",
                "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "cntInitialNotification",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<i>(Initial notification will be sent to all samples in the selected Sample List when the deployment is created)</i>",
                "isHtml": true
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
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
                "style-marginTop": "20px"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "",
                    "reference": "Email From",
                    "events": {}
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email Subject"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": ""
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "events": {}
          }
        ],
        "style-source": ""
      },
      {
        "key": "cntInfoBeforeCreating",
        "data-buildertype": "container",
        "style-marginBottom": "20p",
        "style-source": "",
        "style-customcss": "ui info message",
        "children": [
          {
            "key": "staticcontent_5",
            "data-buildertype": "staticcontent",
            "content": "<i>(After creating the deployment you can perform additional deployment management functions such as assigning data editors, configuring recurrence settings, setting snapshot report options, performing pre-population, etc)</i>",
            "isHtml": true,
            "fetchData": false
          }
        ],
        "other-visibleConition": "(data.Id?false:true)"
      }
    ],
    "style-float": "",
    "style-width": "100%",
    "style-source": "",
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntReportProperties",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "",
        "style-marginBottom": ""
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true,
            "search": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "",
    "style-marginBottom": "20px",
    "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnFirstSave",
        "data-buildertype": "button",
        "content": "Create Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "confirm",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "createDplyConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "createDplyConfirmText"
              }
            ]
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?false:true)",
        "other-customValidation": ""
      },
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Update Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?true:false)",
        "other-customValidation": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "redirect"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/SwzDplyList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]' WHERE [Id]='655275cf-8202-4438-b66b-874eab315889';

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-13 09:00:30.513', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2022-09-13T09:00:30.5127985+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnDplyTrigger"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "020f9a28-e54d-750b-cb60-045ce9ed0c05",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "control": "SurveyName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b17a499b-7d84-0cc9-96d2-58795c553378",
      "attributeId": "c1c6b94f-5e02-4c2a-8646-4fa79706828e",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bfa65cde-ed69-b522-cae6-f91eccaa1dad",
      "attributeId": "cd126359-fee9-4f36-9161-aefe0344e821",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b8cd14dc-2364-8ef6-2230-c18d9d9f2dc2",
      "attributeId": "a5d450bd-1cd0-453d-9ed4-f5695795256d",
      "control": "textApiIdentifier",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-09-14 13:47:00.183', 
[Data]=N'{
    init: function(args) {
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
        }
        
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch(error) {
                //ignore
            }
        }          

        var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
        if(args.data.IsAnonymous){
            qnn_dplyUserActions.getAnonymousSurveyLink(args);
        }
    
        // Only get category details
        // iff args.data.Id is not null
    
        var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
        var d1 = new Date();
        return ()=>{
            return fetch(url,
                {
                    credentials: ''same-origin'',
                    method: ''get''
                })
                .then(response => response.json())
                .then(response => {
                    Pace.stop();
                    qnn_dplyUserActions.showHideControls(args);  
                    console.log("Response is", response);
                    if (response.success) {
                        
                        var _hideControls = args.state.app.form.models.hideControls;
                        var items = response.items;
                        if (items != null)
                        {
                    
                        var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                        var valChkScheduler = obj[0].Id;
                        var EmailRecipients = obj[0].EmailRecipients;
                        var valEmailSuccess ;
                        var valEmailFailure ;
                        
                        if(obj[0].EmailSuccess == true)
                        {
                            valEmailSuccess = ''1'';
                        }
                        else
                        valEmailSuccess = ''0'';
                            
                        if(obj[0].EmailFailure == true)
                        {
                            valEmailFailure = ''1'';
                        }
                        else
                        {
                            valEmailFailure = ''0'';
                        }
                        
                        // var recipients = [];
                        
                        var recipients = [];
                        if(EmailRecipients == "No Recipient")
                        {
                            recipients = [];
                        }
                        else
                        {
                            var breakRecepient = EmailRecipients.split('','');
                            for (let r = 0 ; r < breakRecepient.length ; r++ )
                            {
                            recipients.push(breakRecepient[r]);
                        }
                        
                        }
                
                        /*// alert(items.length);
                        if(items !== undefined && items.length > 0){
                            _removeElement(_hideControls, dailySsForm);
                        }
                        // recipients.push(EmailRecipients);*/
                    
                        CloverApp.API.setDataField("chkScheduler", 1);
                        CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                        CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                        CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                        
                        _removeElement(_hideControls, ''dailySsForm'');  
                        _hideControls.concat(hideControls);
                        return Promise.resolve(
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models: {
                                                hideControls: _hideControls
                                            }
                                        }
                                    },
                                }
                            });  
                            
                        }
                        else
                        {
                            CloverApp.API.setDataField("chkScheduler", 0);
                            CloverApp.API.setDataField("ddlEmailReceipients", []);
                            CloverApp.API.setDataField("chkEmailSuccess", false);
                            CloverApp.API.setDataField("chkEmailFail", false);
                            return {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: args.state.app.form.models.hideControls
                                        }
                                    }
                                }
                            };                    
                        }
                    
                        //  _loadingStop();
                    
                    } // end if response.success        
                }) // end then => response
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
        }; //end return       
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append(''qnnId'', qnnId);
        loadingStart("Verifying survey field alias");
        postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.log(reason);
                alertify.alert(reason);
            }
        ).finally(loadingStop);
    }, //end of checkQnnFields
    
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    
    toggleCompletionUrl: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    
    toggleAnonymousSurvey: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);
        }else{
            CloverApp.API.setDataField("IsMultipleResponse", 0);
        }
    },
    
    downloadInvalidColumns(args) {
        //CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');
    }, // end of downloadInvalidColumns
    
    downloadInvalidDates(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');        
    }, //end of downloadInvalidDates
    
    downloadInvalidUIDs(args) {
          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');        
    }, //end of downloadInvalidUIDS
    
    viewArgs(args){
      console.log("View Args", args);  
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var dplyId = args.data.Id;
        var qnnId = args.data.dictQuestionnaire;
        var listId = args.data.dictList;

        var errors = {};
        if (qnnId == null || qnnId == undefined)
         alertify.error("Questionnaire not selected");
        if (listId == null || listId == undefined)    
         alertify.error("List not selected''");
        if (dplyId == null || dplyId == undefined)    
         alertify.error("There is no existing deployment");
         
         if (token == null || token == undefined){
             errors.token = ''Please select csv file'';
                
            if(errors.token){
              throw {
                  level: 1,
                  message: ''Check errors on the form!'',
                  formerrors: {main: errors}
              };
            }
            return {};
        }
        
        var url = ''/deployment/importresponse?token='' + token + ''&qnnId='' + qnnId + ''&listId='' + listId + ''&dplyId='' + dplyId;

        var d1 = new Date();
        Utils.loadingStart();
        return ()=>{
            return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Utils.loadingStop();
              
                if (response.success) {
                    var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
                    
                    alertify.success(''The changes have been applied!'');
                    console.log("Response is", response);
                    
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("totalSampleResponseAdded", response.statistics.totalSampleResponseAdded);
                    CloverApp.API.setDataField("totalSampleNoResponse", response.statistics.totalSampleNoResponse);
                    CloverApp.API.setDataField("totalSampleResponseAnsAdded", response.statistics.totalSampleResponseAnsAdded);                    
                    CloverApp.API.setDataField("totalInvalidQnnColumns", response.totalInvalidQnnColumns);
                    CloverApp.API.setDataField("totalInvalidUIDs", response.totalInvalidUIDs);
                    CloverApp.API.setDataField("totalInvalidDates_Updated", response.totalInvalidDates_Updated);
                    CloverApp.API.setDataField("totalInvalidScore_Updated", response.totalInvalidScore_Updated);
                   
                    if(response.statistics.totalSampleResponseAdded !== null && response.statistics.totalSampleResponseAdded != undefined){
                        CloverApp.API.setDataField("invalidQnnColumns", response.invalidQnnColumns);
                        CloverApp.API.setDataField("invalidUIDs", response.invalidUIDs);
                        CloverApp.API.setDataField("invalidDates_Updated", response.invalidDates_Updated);
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
                            }
                        });  
                    }
                } else {
                    alertify.error("Invalid");
                    console.log(response.message);
                }
            })
            .catch(error => {
                Utils.loadingStop();
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, // end of submitFile
    
    closeModal: function (args){
        console.log("Close modal", args);
        args.component.refs.importModal.close();
        if(args.component.refs.moreModal !== undefined)
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []
                }
              }
            }
        }       
    }, //end of closeModal
    
    closeMoreModal: function (args){
        console.log("Close open modal", args);
        args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []//[totalSampleResponseAdded, totalSampleResponseAnsAdded, totalInvalidQnnColumns, totalInvalidUIDs, totalInvalidDates_Updated, totalInvalidScore_Updated, invalidQnnColumns, invalidUIDs, invalidDates_Updated]
                  }
              }
            }
        }       
    }, //end of closeMoreModal
    
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            } 
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        

        return {hideControls: hideControls, showControls: showControls};
    },
    
    //TODO - refactoe
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    
    //TODO - refactor
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    }, //end of setIpRestriction
    
    onClickSave: function (args){
        const data = args.data.chkScheduler;
        const dplyId = args.data.Id;
        
        const emailSuccess = args.data.chkEmailSuccess;
        const emailFail = args.data.chkEmailFail;
        const userId = args.data.ddlEmailReceipients;
   
        const formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);       
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/updateSnapshotJob",formData).then(
            response => {
                console.log(data);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of onClickSave
    
    parseHtml: function(args) {
        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData,
                             msgContentJson: args.component.refs.htmlEditor.state.jsonData
                            }
                        }
                    }
                }
        };  
    },
    
    dropdownQuestionnaireOnChange: function(args) {
        var qnnId = args.sourceControlValue;
        var options = args.sourceControlRef.state.options;
        console.log("Args is", args);
        if(args.data.SurveyName=="" || args.data.SurveyName ==null){
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == qnnId){
                        CloverApp.API.setDataField("SurveyName", options[i]["text"]);
                        break;
                    }
                }
            }
        }   
    },
    
    radioCompletionActionOnChange: function(args) {
    },

    radioCompletionNavBackOnChange: function(args) {
    },

    radioCompletionNavCancelOnChange: function(args) {
    },

    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },

    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }
    }, //end of clearContent

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
    updateFeatureInteraction: function(args) {
        // const isSelected = function(toggleValue) {
        //     return Boolean(true===toggleValue || 1===toggleValue || "1"==toggleValue || "true"===String(toggleValue).toLowerCase());
        // }
        
        const isExcelEnabled = Utils.isSelected(args.data.IsExcelEnabled);
        const isDelegationEnabled = Utils.isSelected(args.data.RequireAccessCode);
        const isAnonymous = Utils.isSelected(args.data.IsAnonymous);
        const isMultipleResponse = Utils.isSelected(args.data.IsMultipleResponse);
        
        if(isAnonymous) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for anonymous surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDelegationEnabled) {
                alertify.error("Delegation Access Code is not supported for anonymous surveys");
                CloverApp.API.setDataField("RequireAccessCode", 0);
            }
        }
        
        if(isMultipleResponse) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for multiple response surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
        }
        
        
    },
    
    validateSampleList: function (args){
        const listId =  args.data.dictList;
        
        if(listId !== ''00000000-0000-0000-0000-000000000000''){
            Utils.loadingStart("Verifying list has samples...");
            Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
                response => {
                    if(!response.result) {
                        CloverApp.API.setDataField("dictList", "");
                        const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(listId)].text;
                        alertify.error("Sample List " + selectedList + " is empty.");
                    }else if(Utils.isSelected(args.data.IsAnonymous) && !response.isAnonymousSampleOnly){
                        CloverApp.API.setDataField("dictList", "");
                        alertify.error("Anonymous Survey is ONLY allow for Anonymous Sample.")
                    }
                }, reason => {
                    console.log(''validateSampleList'', reason);
                }
            ).finally(Utils.loadingStop);
        }
    },
    
    getAnonymousSurveyLink: function (args){
        const dplyId =  args.data.Id;
        const qnnId =  args.data.dictQuestionnaire;
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        const surveyLinkKey = ''anonymous-survey-'';
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/deployment/GenerateAnonymousSurveyURL/" + encodeURIComponent(dplyId) +"/"+ encodeURIComponent(qnnId)).then(
                response => {
                    if(response.success && response.result) {
                        htmlLink += ''<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Anonymous Survey URL:</i>'';
                        response.result.forEach(function(item, index){
                            //Does not show as hyperlink due to access anonymous survey will attempt to logout.
                            //let urlLink = ''<li><a href="'' + item.link +''" target="_blank">'' + item.link + ''&nbsp<i>(''+ item.lang +'')</i></a></li>'';
                            let iconBtn = ''<button id="btn-''+surveyLinkKey+index+''" name="btnCopy-anonymous-survey-link" title="Copy" data-link-id="''+surveyLinkKey+index+''" class="''+iconBtnClass+''"><i data-link-id="''+surveyLinkKey+index+''" class="''+iconClass+''" ariahidden="true"></i></button>'';
                            //this urlText is required for the copy action.
                            let urlText = ''<span id="link-''+surveyLinkKey+index+''" style="display:none;">''+item.url +''</span>'';
                            let headerDiv = ''<div style="margin:18px 18px 0px 18px; word-break: break-word;">''+iconBtn +'' '' +item.language + '' '' +urlText+''</div>'';
                            let qrCodeImg = ''<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,'' + item.qrCode +''"  alt="''+item.url+''"/>'';
                            let listItem = ''<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">''+ headerDiv + qrCodeImg + ''</div>'';
                            htmlLink += listItem;
                        });
                        
                        htmlLink += "</div>"
                        
                        CloverApp.API.setDataField("anonymousSurveyLink", htmlLink);
                        
                        //Due to security issue does not allow "unsafe inline", bind separately
                        document.getElementsByName("btnCopy-anonymous-survey-link").forEach(function(btn){
                           btn.addEventListener("click",function(e){
                               e.preventDefault();
                               const copyText = document.getElementById("link-" + e.target.getAttribute(''data-link-id'')).innerText
                               navigator.clipboard.writeText(copyText);
                               alertify.success(''Copied to clipboard!'');
                           })
                        });
                    }else{
                        CloverApp.API.setDataField("anonymousSurveyLink", "");
                    }
                }, reason => {
                    console.log(''getAnonymousSurveyLink'', reason);
                }
            ).finally(Utils.loadingStop);
            
    }
}






' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

