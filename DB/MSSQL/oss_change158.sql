-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_QNN.json
-- QNN_QNN-code.js
-- QNN_QNN-settings.json

UPDATE [dwMetadata] SET
[Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.690', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-23 14:56:33.047', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Questionnaire",
    "size": "huge",
    "subheader": "(Form Properties)"
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
            "key": "Warning_Type_P",
            "data-buildertype": "message",
            "header": "WARNING: Unsupported Form Properties Type",
            "content": "This Form Properties uses the deprecated ''P'' type for Offline PDF Surveys. \nSupport for this feature has been removed. ",
            "warning": false,
            "error": false,
            "other-visibleConition": "(data.Type===''P'')",
            "size": ""
          },
          {
            "key": "Type",
            "data-buildertype": "input",
            "label": "Type",
            "fluid": true,
            "onChangeTimeout": 200,
            "style-width": "50px",
            "readOnly": true,
            "other-visibleConition": "(data.Type !== ''O'')"
          },
          {
            "key": "Title",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "other-customValidation": ""
          },
          {
            "key": "Alias",
            "data-buildertype": "input",
            "label": "Alias",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "CategoryId",
            "data-buildertype": "dictionary",
            "label": "Category",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_CATEGORY",
            "columns": "Name Asc",
            "filters": "[{\"column\":\"Type\", \"value\":\"Q\", \"term\":\"=\"}]"
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "congtainer_qnn_qnn_form",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_3",
                "data-buildertype": "header",
                "content": "Online Forms:",
                "size": "tiny"
              },
              {
                "key": "collectioneditor_2",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Form Name",
                    "control": "custom"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "header": true,
                "other-visibleConition": "",
                "placeholders": {
                  "Name": [
                    {
                      "key": "Name",
                      "data-buildertype": "dictionary",
                      "label": "",
                      "fluid": true,
                      "selection": true,
                      "columns": "Name",
                      "dataModel": "vSP_SurveyForm",
                      "paging": true,
                      "search": true,
                      "style-customcss": "dictionary-no-label"
                    }
                  ]
                }
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "other-visibleConition": "(data.Type==''O'')"
          },
          {
            "key": "Excel_Files_After_Save_Message",
            "data-buildertype": "container",
            "style-marginBottom": "",
            "style-marginTop": "20px",
            "other-visibleConition": "(data.Type==''O'' && (data.Id===undefined || data.Id===null || data.Id=='''')   )",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "(Excel survey files may be added after saving)"
              }
            ]
          },
          {
            "key": "container_qnn_qnn_file",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Downloadable Excel Files:",
                "size": "tiny",
                "subheader": "(Used in Excel-enabled Online Surveys)"
              },
              {
                "key": "collectioneditor_3",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "Name",
                    "name": "Excel File Name"
                  },
                  {
                    "key": "Token",
                    "name": "File",
                    "control": "file2"
                  },
                  {
                    "key": "Language",
                    "name": "Language"
                  },
                  {
                    "key": "Remarks",
                    "name": "Remarks"
                  }
                ],
                "disableAdd": true,
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [
                      "validate"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-visibleConition": ""
              },
              {
                "key": "dropzonecontrol_2",
                "data-buildertype": "dropzonecontrol",
                "showFiletypeIcon": true,
                "autoProcessQueue": true,
                "addRemoveLinks": true,
                "multile": true,
                "events": {
                  "success": {
                    "active": true,
                    "actions": [
                      "createElement"
                    ],
                    "targets": [
                      "collectioneditor_3"
                    ],
                    "parameters": []
                  }
                },
                "iconFiletypes": "*.xslx"
              }
            ],
            "other-visibleConition": "(data.Type==''O'' && data.Id)",
            "style-marginTop": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Deployment",
                "size": "small"
              },
              {
                "key": "gridview_1",
                "data-buildertype": "gridview",
                "columns": [
                  {
                    "sortable": true,
                    "filterable": false,
                    "resizable": true,
                    "key": "Name",
                    "name": "Name"
                  },
                  {
                    "sortable": true,
                    "filterable": false,
                    "resizable": true,
                    "key": "SurveyName",
                    "name": "Survey Name"
                  },
                  {
                    "key": "CategoryName",
                    "name": "Category",
                    "resizable": true,
                    "sortable": true,
                    "filterable": false
                  },
                  {
                    "key": "CreatedDate",
                    "name": "Date Created",
                    "resizable": true,
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false
                  }
                ],
                "rowKey": "Id",
                "pageSize": "50",
                "defaultSort": "Name ASC",
                "rowHeight": "80",
                "editFormShowType": "",
                "editForm": "QNN_DPLY",
                "events": {
                  "onRowClick": {
                    "active": true,
                    "actions": [
                      "gridEdit"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginTop": "20px",
            "other-visibleConition": "data.Id?true:false"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-float": "left",
            "events": {},
            "style-marginRight": "20px",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "customSave"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {
                        "value": "/form/SwzQnnList",
                        "name": "target"
                      }
                    ]
                  }
                },
                "inverted": false,
                "secondary": false,
                "primary": true,
                "other-visibleConition": "(data.Type !== ''P'')"
              },
              {
                "key": "btnConvertToOnlineForm",
                "data-buildertype": "button",
                "content": "Convert to Online Form",
                "events": {
                  "onClick": {
                    "actions": [
                      "convertToOnlineForm"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "inverted": false,
                "secondary": true,
                "primary": false,
                "other-visibleConition": "(data.Type === ''P'')"
              },
              {
                "key": "btnExit",
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
                        "value": "/form/SwzQnnList"
                      }
                    ]
                  }
                },
                "secondary": true,
                "inverted": false
              }
            ],
            "style-marginTop": "20px",
            "style-marginBottom": "20px"
          }
        ],
        "style-marginBottom": ""
      }
    ],
    "style-marginBottom": "",
    "events": {}
  },
  {
    "key": "divModal",
    "data-buildertype": "container",
    "children": [
      {
        "key": "errorModal",
        "data-buildertype": "swzmodal",
        "content": "errorModal",
        "size": "",
        "style-display": "block",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "System Message",
                "size": "medium",
                "style-source": "font-family: Lato,''Helvetica Neue'',Arial,Helvetica,sans-serif;\npadding-bottom: 1.5rem;\ncolor: rgba(0,0,0,.85);\nborder-bottom: 1px solid rgba(34,36,38,.15);"
              },
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "{ErrorText}",
                "isHtml": false,
                "style-source": "word-wrap: normal;\nleft-margin: auto; right-margin: auto;",
                "style-width": "80%",
                "style-customcss": "content"
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "style-source": "clear: both;\npadding: 20px;",
                "style-width": "100%",
                "children": [
                  {
                    "key": "btn_cancelErrorModal",
                    "data-buildertype": "button",
                    "content": "OK",
                    "secondary": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "cancelModal"
                        ],
                        "targets": [
                          "errorModal"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": true,
                    "floated": "right"
                  }
                ]
              }
            ],
            "style-source": "padding: 20px;"
          }
        ]
      }
    ],
    "style-hidden": true
  }
]' WHERE [Id]='61598194-d4d0-43cb-8fb8-a75ea0b2b374';

UPDATE [dwMetadata] SET
[Id]='927fc400-e371-4fbb-b866-cb020fff46db', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-25 17:27:03.217', 
[Data]=N'{
    init: function(args){
      //console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]
        if(args.data.Id){
            CloverApp.API.setDataField("UpdatedDate", new Date());
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.Id);                  
            }
            catch(err) {
                ;
        	}
        } else {
            CloverApp.API.setDataField("Type","O");
        }
        CloverApp.API.setDataField("ErrorText", "");
    },  

    customSave: function(args) {
        //-----------------------
        const loadingStart = function(loadingMessage) {
        $(''body'').loadingModal({
            text: loadingMessage ? loadingMessage : ''Processing...'',
            animation: ''foldingCube'',
            backgroundColor: ''#1262E2''});
        };
        
        const loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        //---------------------
        
        //----------------------------------
        const changeData = function (data, name) {
            const url = "/data/change?name=" + encodeURIComponent(name);
            const formData = new FormData();
            formData.append( "data", JSON.stringify(args.data) );
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------
        
        args.data.UpdatedDate = new Date(); //trigger triggers
    
        const innerArgs = args;
        loadingStart("Saving...");
        changeData(args.data,"QNN_QNN").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_QNN/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                loadingStop();
            }
        );
    }, //end of customSave
    
    viewArgs: function(args){
        console.log(''View Args'', args);    
    },
    
  GenFormFields:function(args){
      console.dir(args);
      var qnnId = args.data.Id;
      var token = args.data.collectioneditor_1[0].Token;
          var url = ''/qnn/genfields?qnnId='' + args.data.Id + ''&token='' + token;
    $.post(url).done(function (data) {
        if(data.success)
            alertify.success(data.message);
        else
            alertify.error(data.message);
    }).fail(function (jqxhr, textStatus, error) {
       alertify.error(textStatus);
    }); 
    return {};
  },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        
        if(args.data.Title==undefined || args.data.Title==null || args.data.Title.trim() == ''''){
                errorMessages.push(''Please enter questionnaire title'');
                errors.main.Title = true;
                hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
                errorMessages.push(''<br />Please select questionnaire type!'');
                errors.main.Type = true;
                hasError= true;
        }        
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push(''<br />Please insert an online form!'');
                errors.main.collectioneditor_2 = true;
                hasError = true;
            }            
        }
        
        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    convertToOnlineForm: function(args) {
        //nb: it is assumed this is only called for an already saved entity
        CloverApp.API.setDataField("Type","O");
        alertify.success("Type changed to Online. Add an Online form and click Save to apply this change");
        const hideControls = [ "Warning_Type_P", "Type", "Excel_Files_After_Save_Message", "btnConvertToOnlineForm" ];
        return {
            app: {
                form: {
                    models: {
                        hideControls: hideControls,
                    },
                },
            },
        }; //end of state delta
    }, // end of convertToOnlineForm
}







' WHERE [Id]='927fc400-e371-4fbb-b866-cb020fff46db';

UPDATE [dwMetadata] SET
[Id]='27dbfadb-0e83-4acd-af28-35a760e3239b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-23 15:01:21.623', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_QNN",
  "lastUpdate": "2021-08-23T15:01:21.6148591+08:00",
  "entityId": "589862c4-0937-4c74-a1cc-e7605c16b43f",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateOnlineFormTrigger"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy:\"@CurrentUserId\", UpdatedDate:\"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "InsertQnnOnlineFormFieldsTrigger"
    },
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\", \"Type\": \"O\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnFilesTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "f5c72328-b907-7ee0-8b55-f4239c8da6e8",
      "attributeId": "c808a448-06a0-4c5f-869a-3eb2c0a6c903",
      "control": "Alias",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "721e7992-c058-fdec-99de-e4b2134e0071",
      "attributeId": "0d19ac69-83df-4a34-9dff-53382d296641",
      "control": "CategoryId",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "89b15150-fab8-f905-e931-1395a6cae270",
      "attributeId": "0f95423b-c5b2-4e7a-ae2b-e875ab4edf01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cfb7bec7-b589-607d-5129-a59dde6190ea",
      "attributeId": "bdb39dc9-cdb1-4963-bae8-9e6a2941fd6c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "581270f1-2e71-5a5c-a88d-f8da9064a71a",
      "attributeId": "3f57cdc6-e819-47fd-9d12-387211c01028",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "74a0dac6-9a11-ed4e-b5c6-96fae81edb84",
      "attributeId": "6ec427f4-d775-447e-bcd0-d7dc8055f95e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b137d32-d9f7-7c6d-dc7a-aa8d413b53df",
      "attributeId": "4dfd3c51-ff91-41f0-ac79-e8ef07ffc18e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa94aeed-0ff2-42b7-de9a-a6c8509a2c66",
      "attributeId": "8677a7da-33d6-48b4-8b2c-19988301076e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cd2ee951-429c-9622-3e69-141f0741a5e6",
      "attributeId": "4d3d387a-6b1b-4466-b1d5-cbf511236450",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d260ba0c-a6d5-b700-2354-c322a00c1814",
      "attributeId": "e9e32d8f-2bc3-4ae7-84df-f4e10da21e22",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e194959a-a340-9add-f232-c1617b48df7d",
      "attributeId": "c8c0e394-bd64-43ed-8b49-162a4bbc7625",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24dae954-e67e-a607-a3e4-f2bbbe492700",
      "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
      "control": "Title",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ac8dd062-9404-30ae-2a60-f64a0d2b5851",
      "attributeId": "234b84aa-654c-4aed-8a94-0c066ea34e1e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2497b2ba-fde1-921b-eb23-7bb1c90c9cbd",
      "attributeId": "a7afb96e-6a68-4bc0-8e00-71ecd545cbd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0f31090-e7d8-6df6-df4b-17911aafcbd6",
      "attributeId": "5c4a0ba5-aeb3-4a4e-a8e5-50b0973be692",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9c8c1d3f-e294-9402-162b-ae1fc8eaf98e",
      "attributeId": "5c876871-6dc2-4d6c-bcc5-54016c84a40b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a618b97-0e2c-8433-f49c-5ba34a9f6132",
      "attributeId": "3a038cc2-2d18-4898-95f9-b0e7cf3ba400",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "ce55df4c-3912-415b-d8f9-6858832481f8",
      "entityId": "727fe2b1-f979-49c5-b92d-c5e70c1a4110",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_2",
      "dataMap": [
        {
          "id": "b4f98c07-3eb7-4254-dc33-546a56ca63ac",
          "attributeId": "674343a1-e1a6-4d98-9e2d-a814ebf1742b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3048e0ad-79e1-3424-6c5b-31c8e7844626",
          "attributeId": "d7c53c38-8d62-431d-8ab7-73a25f6b58bb",
          "control": "Language",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86062545-a96f-5ff7-28d8-d342b8af08ce",
          "attributeId": "6a636ac4-263e-41a7-b6cd-23640c3f286e",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5774b7e-dfc2-5063-fafb-602fab6d71bb",
          "attributeId": "aafe438d-5468-4c99-a125-f23f8a0ea082",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1991fe4a-50db-50f1-3bcd-b2df702e17ae",
          "attributeId": "35a15d67-9f99-4d1a-9a73-7ab396344071",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9dfb9655-3bc3-f6e9-f0cd-640b5ccc3107",
          "attributeId": "8e81d88b-b5fe-4f3d-863f-8308bd3d9448",
          "control": "Remarks",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "b7ce1da8-ae40-e1fc-55d2-df280efd08a2",
      "entityId": "95a49c95-bd21-41ee-8a53-c1f96ca5d927",
      "filter": "FilterByModelId",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "collectioneditor_3",
      "dataMap": [
        {
          "id": "852590b9-843e-dab0-910e-ab0c75f435a7",
          "attributeId": "2e8d9106-1308-4399-a561-a34cd12de0c5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3287ffd8-7f38-a3da-c04d-232ca9c5da01",
          "attributeId": "b7275b5e-c4b4-4296-966d-91216131561f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d8d404cf-819c-e856-3cee-58a956982862",
          "attributeId": "e34c36c7-e5e7-4212-8feb-380d7feb5d48",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "592af51c-57f8-d328-4a0b-40eae472aff9",
          "attributeId": "6d833d65-ad3f-4d20-a64d-60e913572f0e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6182e72e-b921-ee6d-f4a4-b80bc7dfb5fa",
          "attributeId": "54a852ab-6ef1-4b5e-9780-c4cf2a8339af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ae5d7a7d-b38f-d9c8-6e81-88aa759f07d4",
          "attributeId": "a895859f-8c06-4515-9803-ce31821119a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1ae290f-bd5c-5387-cf44-70eec5ea51a0",
          "attributeId": "f65f5cda-7d7e-403f-b7c9-84837c48cd0a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6b139332-1d81-cc9f-a0bd-23d7d65277c8",
          "attributeId": "debe95cb-f26f-44f5-b9f0-268dd244468b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bfa16bb3-4e81-ff85-c4f6-fe864926638b",
          "attributeId": "fb81a1fb-fa8a-4264-ab16-3c30cd9c3927",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a3d05474-440a-188e-8d39-3142e5a4fba0",
          "attributeId": "3085136b-f4ce-4790-8dea-bb2fee94de7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eeb8673f-cff7-6087-38ba-35a47bd7c740",
          "attributeId": "7565471d-898d-4f6b-83b8-70fa86343d4f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "389ba6ae-a81e-155d-f797-bb8a5fb898eb",
          "attributeId": "b68d3ba2-f9c8-4697-8c0f-a71d8868f86a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2df7de33-37a9-6065-3592-00e830c7f31b",
          "attributeId": "9d07044c-e991-4f1a-816b-a5a2f879bf62",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "771d41fa-33b0-4745-8fc7-e9a9d60207b4",
          "attributeId": "48441dc8-4895-4df4-8f48-7358ad18cd97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a28f9da0-e40c-3531-e96d-8883e5ec8cd5",
          "attributeId": "fa07f472-dc63-4b47-b611-7bad7624387a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e46c4f1e-95d2-533e-8550-a77543efdef8",
          "attributeId": "51684962-8fa3-4964-bc2a-bc8fd2128baf",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "70a597e0-2a98-67c3-58e7-c93905178502",
      "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
      "filter": "FilterAsyncByModelIdAndStruct",
      "parameter": "{QnnId: \"@Id\"}",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "963a516e-298e-db71-07c7-cc3f5a7fa908",
          "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "600f057f-a776-5873-1fed-dedacff3f5d6",
          "attributeId": "69d19937-002d-45b7-b86f-73f63e918fd8",
          "control": "CategoryName",
          "parentId": "963a516e-298e-db71-07c7-cc3f5a7fa908",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "278a0d3c-907a-787f-bf50-c4bd81c5a8a6",
          "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76606976-9cea-ea76-98ba-3f80903adca8",
          "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7ab7dd93-ab7b-0819-9e12-17ed7db579b2",
          "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "17768ce1-a631-c03e-ff6c-c56c37d9ea5c",
          "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
          "control": "CreatedDate",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c04b37ca-8027-cf20-ee7b-a86570b3ef14",
          "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c4d9454d-2db2-4c38-1ba2-e9b5b3071e60",
          "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "77239f12-d86d-261e-b03e-e881da4d3aaa",
          "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "af201cfa-15a8-4a2a-494b-162592aeb3b9",
          "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a8fab9e-04fc-854e-ae83-830efcfd2589",
          "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a559f9f6-4d88-dd9d-2dcb-c80faba45548",
          "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06133d76-99c5-cf1a-ee57-86078ec82c80",
          "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f4c368ce-f660-f375-3317-87793d502473",
          "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "784cf36a-56f0-e880-acb9-1738979c0264",
          "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9662d793-86e5-213d-0e87-adb85edc52a5",
          "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d3e17a1c-05b9-1ccf-67c5-7a4115da135b",
          "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "532bc06a-39f2-c860-22c9-d0123db0bb0c",
          "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b782ee8-f822-0b62-3575-cb9aef90f612",
          "attributeId": "455e5598-3db3-484c-84a6-148758489688",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1eea9f1b-fc88-1eb8-e26a-07fbdae4f935",
          "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cdc87023-b7b2-4e7a-81bc-c2a9902f9bb8",
          "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6d801471-3c07-c86d-556c-e7671a5aeb3f",
          "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f3caba05-67ea-a509-f524-385c15470c6e",
          "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c29638da-b8b0-b879-c4cd-7ab9cf782b0c",
          "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cf786cfe-308e-248d-50d5-024992d56a3e",
          "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "279fe4ec-65d7-7369-a7c5-3b3d1dd7ffed",
          "attributeId": "8621d809-3ede-44eb-8695-1a26adb17420",
          "control": "QnnTitle",
          "parentId": "cf786cfe-308e-248d-50d5-024992d56a3e",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "3559450e-a68f-24af-b232-e61714d290b8",
          "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c60a27cd-0e22-9a3e-7496-6712a24d52eb",
          "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e24b227-f844-9bb6-a844-1e9520b2b602",
          "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f353c997-c191-0e44-7858-727547df2718",
          "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "341915c0-8dd0-2f66-ed36-718238211e6d",
          "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b5f8be5e-cb5f-b1e2-f479-c8924e26b1d3",
          "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1f0a3f19-13c0-46ab-afd1-aec1f84801cb",
          "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "839ed51f-e507-9635-2695-53c01da4a123",
          "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "16cc7c6f-9852-f494-b3ce-c80877c4d606",
          "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8c73373c-db84-b92e-eca8-e7c185b72925",
          "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89abb6da-f038-f884-e7e3-fbbb6273d5a3",
          "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c3d16f5f-b94a-9cc0-c94d-bc2e5af7cbe3",
          "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a3e426f3-d138-8b41-7bd2-4409307c8b3d",
          "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d490ef9a-4a2f-40f1-f840-7a57669526ea",
          "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3d860020-e8df-daa6-3001-dff3888f7472",
          "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "825cb4f7-b359-f5f2-8a99-a17274c29b21",
          "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c57553d-698c-5757-0f1d-7ae8ef750ae0",
          "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "78860605-dc94-7133-1352-df484be45f33",
          "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aaaa8b06-014b-6558-a4bb-ef41fcd2e15f",
          "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "da915c13-72d8-55f9-a747-1cdd87af36ac",
          "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2a384eac-7a49-cce3-37aa-fbafb42ee9eb",
          "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "130c5d9e-9d24-a89e-a04b-b249ecbeb668",
          "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "29e22da4-0853-2003-9b88-44297fc994aa",
          "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86865f79-128a-864c-e880-0aaae464ea77",
          "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "943409d7-5975-4918-b561-83f63731715f",
          "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b31ec96-3577-5d50-4377-7db1b1d34f1a",
          "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1ed289df-6c12-8784-a066-f8f790f9d514",
          "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7f5d0d9f-8d8f-3538-edd2-c1c5571da89c",
          "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
          "control": "SurveyName",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Questionnaire"
}' WHERE [Id]='27dbfadb-0e83-4acd-af28-35a760e3239b';

