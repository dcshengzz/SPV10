-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_RESP_ADMIN-code.js
-- QNN_RESP_ADMIN-settings.json
-- QNN_RESP_ADMIN.json

UPDATE [dwMetadata] SET
[Id]='60935b9b-4184-421c-ba61-23c05e657b2c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.337', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-07 14:51:33.200', 
[Data]=N'{
    init: function(args){
    

    },
    
    onHtmlChange: function (args){

        var contentData =  JSON.stringify(args.component.refs.respHtmlEditor.state.jsonData);
     
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            respHtmlEditor: contentData  
                        }
                    }
                }
            }
        }
    },
    
    showArgs: function (args){
      //  console.log("show Args", args);
    },
    
    fetchEditorState: function (args){
    
      //  console.log("test button", args);
        var editorState = args.data.EditorState;
        
        if (editorState != null){
       // console.log("Editor State",editorState);
       // console.log(args.state.app.form.models);
              var modelArray = args.state.app.form.models.model; 
             var editor= args.state.app.form.models.model[1];
           var newModal= {''key'': editor[''key''], ''data-buildertype'': editor[''data-buildertype''], ''editorState'': editorState };
    
        modelArray.splice(1,1,newModal); //Replace item in whole model series
    
        return {
                app:{
                    form:{
                        models:{
                            model: modelArray
                        }
                    }
                }
            }
        }
    
    },
 
    customValidateInput: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
        var errors = {};
        if(new Date(data.StartDate).getTime() > new Date(data.EndDate).getTime()){
            throw {
              level: 1,
              message: ''End Date must be after Start Date'',
              formerrors: {main: errors}
          };
        }
        return {};
    },
    
    submitHtmlData: function(args){
    
        var contentData =  JSON.stringify(args.component.refs.swzhtml_1.state.jsonData);
       
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            EditorState: contentData  
                        }
                    }
                }
            }
        }
    },
    
    goBack: function(args) {
        args.state.router.history.goBack();
    }
}' WHERE [Id]='60935b9b-4184-421c-ba61-23c05e657b2c';

UPDATE [dwMetadata] SET
[Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.397', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-07 14:48:38.493', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_RESP_ADMIN",
  "lastUpdate": "2022-03-07T14:48:38.4929252+08:00",
  "entityId": "cd522364-03bb-44c1-af31-575eab8ac087",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "7eca1a45-c409-c32e-acb9-251afa096832",
      "attributeId": "9f428eaa-35c5-4cfd-8cc4-b32bf482561a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98277ccb-156d-afac-2a25-810f13e8ecb4",
      "attributeId": "d8512084-4732-4938-869d-0165bc220192",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5b887698-a623-eae4-a59f-a470b18bb314",
      "attributeId": "c59f90ad-9bec-4515-aa4f-381ddfbcd853",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5e36525f-6583-2890-4e1a-b5b43f70b0d0",
      "attributeId": "bfc94f30-64fc-4fad-89c9-b718eb8182b0",
      "control": "respHtmlEditor",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0904f275-ff19-ad51-3862-c95d8ce0e28d",
      "attributeId": "0eef8351-e1f8-4406-b13c-162a7222ba2e",
      "control": "EndDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "da14a5e4-f3c4-1a77-b66f-ab5ead0f9a9c",
      "attributeId": "46699848-4700-4d77-a193-ef4ecbd921ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16abd9a3-7f1f-7567-52f7-7eeca4e7ea42",
      "attributeId": "59530aed-1d91-40d2-8808-d1a286390b4f",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d8ab4c5-a6bc-45c0-769a-381960714fd3",
      "attributeId": "3c2fdcf5-bed4-4642-a2c9-d0ba9f97566e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a5f37cdf-b2e2-0df8-f5db-b3ea2415a852",
      "attributeId": "3955c616-c917-4a6c-a8b2-e90321a9f41d",
      "control": "StartDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b0088559-9d4a-b852-6699-6a6aa5878664",
      "attributeId": "617be8a6-bcdc-46db-86c9-2841eac54b68",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f27ec61-4e13-2d9e-7a39-60413c212ca9",
      "attributeId": "befe83a7-b642-4ee2-8308-2ea543b10ac2",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "44070596-2231-fd60-7e48-8a373db5ce80",
      "attributeId": "c421b5dd-dac8-4c5f-b548-0e4e8f611e17",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79d44998-f62a-a4c0-790a-f9920d1848a9",
      "attributeId": "5c84da90-3ecb-4c14-846f-8d1568091a77",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content"
}' WHERE [Id]='623fd743-bbf1-4dcd-8a1b-0dba02e9d98f';

UPDATE [dwMetadata] SET
[Id]='9a0db841-f236-48da-91af-05dec27a92b4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RESP_ADMIN.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.447', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-07 14:48:38.427', 
[Data]=N'[
  {
    "key": "header_2",
    "data-buildertype": "header",
    "content": "Respondent Content Management",
    "size": "large"
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
            "key": "Name",
            "data-buildertype": "input",
            "label": "Title",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "events": {},
            "other-customValidation": "",
            "reference": "Title"
          },
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 2,
                "value": "RespLogin",
                "text": "Respondent Login"
              },
              {
                "key": 3,
                "value": "RespDashboard",
                "text": "Respondent Dashboard"
              }
            ],
            "style-width": "300px",
            "events": {},
            "defaultValue": "",
            "placeholder": "",
            "other-required": true
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "StartDate",
                "data-buildertype": "input",
                "label": "Start Date",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-required": true,
                "other-customValidation": "",
                "other-visibleConition": "",
                "labelPosition": "left",
                "reference": "Start Date"
              },
              {
                "key": "EndDate",
                "data-buildertype": "input",
                "label": "End Date",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-required": true,
                "reference": "End Date"
              }
            ]
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Status",
            "toggle": true,
            "events": {}
          },
          {
            "key": "respHtmlEditor",
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
            "hideOutput": "none"
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "style-float": "left",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "events": {
                  "onClick": {
                    "actions": [
                      "validate",
                      "customValidateInput",
                      "save"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": true
              },
              {
                "key": "button_2",
                "data-buildertype": "button",
                "content": "Save Editor",
                "events": {
                  "onClick": {
                    "actions": [
                      "submitHtmlData"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {}
                    ]
                  }
                },
                "primary": true,
                "disabled": false,
                "fluid": false,
                "circular": true,
                "inverted": true,
                "compact": false,
                "secondary": true,
                "style-hidden": true
              },
              {
                "key": "button_1",
                "data-buildertype": "button",
                "content": "Fetch Editor State",
                "events": {
                  "onClick": {
                    "actions": [
                      "fetchEditorState"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": [
                      {}
                    ]
                  }
                },
                "primary": false,
                "disabled": false,
                "secondary": true,
                "style-hidden": true
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
                        "value": "/form/SwzRespAdminList"
                      }
                    ]
                  }
                },
                "secondary": true
              }
            ],
            "style-marginBottom": "20px",
            "style-marginTop": "20px"
          }
        ]
      }
    ]
  }
]' WHERE [Id]='9a0db841-f236-48da-91af-05dec27a92b4';

